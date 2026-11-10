#!/bin/bash
# =============================================================================
# BioWatch scout — scheduled run, with catch-up
#
# Default cadence: every 14 days. If the machine was off (vacation, outage),
# this catches up in proper 14-day windows — one report per missed cycle,
# each with correct period_from/period_to — rather than one oversized report
# spanning the whole gap.
#
# Override for an explicit one-off window (bypasses catch-up entirely):
#
#   BIOWATCH_FROM=2026-11-24 BIOWATCH_TO=2026-12-08 bash bin/run_biowatch.sh
#
# Reads the prompt from AGENT_INSTRUCTIONS.md so the prompt has one source of
# truth — editing that file changes what the next run does, nothing to keep in sync.
# =============================================================================
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUTPUT_DIR="$REPO_DIR/automated_findings"
CHECKLIST="$REPO_DIR/REVIEW_CHECKLIST.md"
INSTRUCTIONS="$REPO_DIR/AGENT_INSTRUCTIONS.md"
VOCABULARY="$REPO_DIR/TAG_VOCABULARY.md"
LAST_RUN_FILE="$HOME/.local/share/biowatch_last_run"
LOG_DIR="$HOME/logs/biowatch"
CLAUDE="$HOME/.local/bin/claude"
CADENCE_DAYS="${BIOWATCH_CADENCE_DAYS:-14}"
MIN_DAYS="${BIOWATCH_MIN_DAYS:-13}"

mkdir -p "$LOG_DIR" "$OUTPUT_DIR"
LOG="$LOG_DIR/$(date '+%Y%m%d_%H%M%S').log"
ts() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG"; }

# Runs one cycle for the given window. Returns non-zero only on hard failure.
run_one_cycle() {
    local period_from="$1" period_to="$2"
    local filename output_file prompt claude_exit

    filename="$(echo "$period_to" | tr -d '-').md"
    output_file="$OUTPUT_DIR/$filename"

    if [[ -f "$output_file" ]]; then
        ts "Output file already exists: $output_file — skipping"
        return 0
    fi

    ts "Period: $period_from -> $period_to"
    ts "Output: $output_file"

    prompt="$(cat "$INSTRUCTIONS")

$(cat "$VOCABULARY")

## This run
- run_type: automated
- period_from: $period_from
- period_to: $period_to
- output_file: $output_file

The tag vocabulary above is pasted in full — pick entry tags from it directly,
there is no separate file to go read for this.

Search thoroughly, then write the file to the exact output_file path above."

    ts "Launching claude scout..."
    "$CLAUDE" --allowedTools "WebSearch,WebFetch,Write,Read,Glob,mcp__plugin_bio-research_biorxiv__search_preprints,mcp__plugin_bio-research_biorxiv__get_preprint,mcp__plugin_bio-research_biorxiv__search_published_preprints,mcp__plugin_bio-research_pubmed__search_articles,mcp__plugin_bio-research_pubmed__get_article_metadata,mcp__plugin_bio-research_pubmed__find_related_articles,mcp__plugin_bio-research_pubmed__lookup_article_by_citation,mcp__plugin_bio-research_consensus__search" -p "$prompt" 2>&1 | tee -a "$LOG"
    claude_exit=${PIPESTATUS[0]}

    if [[ $claude_exit -ne 0 ]]; then
        ts "ERROR: claude exited with code $claude_exit"
        return 1
    fi
    if [[ ! -f "$output_file" ]]; then
        ts "ERROR: output file not created: $output_file"
        return 1
    fi

    ts "Scout complete: $output_file"

    # AGENT_INSTRUCTIONS.md tells the agent to append its own checklist row — this
    # is only a fallback in case it didn't, so a run is never silently dropped.
    if ! grep -qF "[[${filename%.md}]]" "$CHECKLIST"; then
        printf -- '- [ ] [[%s]] — %s -> %s\n' "${filename%.md}" "$period_from" "$period_to" >> "$CHECKLIST"
        ts "Agent didn't add a checklist row — added one (fallback)"
    else
        ts "Checklist row already present for $filename"
    fi

    commit_and_push "$filename" || return 1
}

# Commits the new report + checklist row and pushes to both remotes, so the
# vault stays current without anyone running git by hand (issue #2). The
# commit happens even if a later push fails, so nothing generated is lost —
# a failed push just gets retried (ordinary `git push`) on the next run.
commit_and_push() {
    local filename="$1"
    cd "$REPO_DIR"

    git add "$OUTPUT_DIR/$filename" "$CHECKLIST"
    if git diff --cached --quiet; then
        ts "Nothing to commit for $filename"
        return 0
    fi

    if ! git commit -m "docs(findings): add automated report ending ${filename%.md}

Co-Authored-By: Claude Sonnet 5 <noreply@anthropic.com>" >> "$LOG" 2>&1; then
        ts "ERROR: git commit failed for $filename"
        return 1
    fi
    ts "Committed $filename"

    if ! git push origin main >> "$LOG" 2>&1; then
        ts "ERROR: push to origin failed"
        return 1
    fi
    if ! git push upstream main >> "$LOG" 2>&1; then
        ts "ERROR: push to upstream failed"
        return 1
    fi
    ts "Pushed to origin and upstream"
}

ts "=== BioWatch scout starting ==="

if [[ -n "${BIOWATCH_FROM:-}" && -n "${BIOWATCH_TO:-}" ]]; then
    ts "Explicit window — single run, no catch-up"
    run_one_cycle "$BIOWATCH_FROM" "$BIOWATCH_TO"
    exit $?
fi

if [[ -f "$LAST_RUN_FILE" ]]; then
    CURSOR=$(cat "$LAST_RUN_FILE")
else
    CURSOR=$(date -d "$CADENCE_DAYS days ago" '+%Y-%m-%d')
    ts "No previous run found. Defaulting start to $CURSOR"
fi

TODAY=$(date '+%Y-%m-%d')
RAN_ANY=0

while true; do
    DAYS_SINCE_CURSOR=$(( ($(date -d "$TODAY" +%s) - $(date -d "$CURSOR" +%s)) / 86400 ))
    if (( DAYS_SINCE_CURSOR < MIN_DAYS )); then
        if (( RAN_ANY == 0 )); then
            ts "Skipping: last run was $DAYS_SINCE_CURSOR days ago ($CURSOR). Need $MIN_DAYS+."
        else
            ts "Caught up to $CURSOR — next cycle not due yet."
        fi
        break
    fi

    PERIOD_FROM="$CURSOR"
    PERIOD_TO=$(date -d "$CURSOR + $CADENCE_DAYS days" '+%Y-%m-%d')
    # Don't create a window reaching into the future.
    if [[ "$(date -d "$PERIOD_TO" +%s)" -gt "$(date -d "$TODAY" +%s)" ]]; then
        PERIOD_TO="$TODAY"
    fi

    run_one_cycle "$PERIOD_FROM" "$PERIOD_TO"
    RAN_ANY=1

    CURSOR="$PERIOD_TO"
    echo "$CURSOR" > "$LAST_RUN_FILE"
    ts "Updated last-run to $CURSOR"
done

ts "=== Done ==="

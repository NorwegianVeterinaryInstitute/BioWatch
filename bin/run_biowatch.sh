#!/bin/bash
# =============================================================================
# BioWatch scout — scheduled run
#
# Default cadence: every 14 days (skips if run too soon). Override the window
# explicitly for a backfill or a one-off:
#
#   BIOWATCH_FROM=2026-11-24 BIOWATCH_TO=2026-12-08 bash bin/run_biowatch.sh
#
# Reads the prompt from AGENT_INSTRUCTIONS.md so the prompt has one source of
# truth — editing that file changes what the next run does, nothing to keep in sync.
# =============================================================================
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUTPUT_DIR="$REPO_DIR/standard_queries"
CHECKLIST="$REPO_DIR/REVIEW_CHECKLIST.md"
INSTRUCTIONS="$REPO_DIR/AGENT_INSTRUCTIONS.md"
LAST_RUN_FILE="$HOME/.local/share/biowatch_last_run"
LOG_DIR="$HOME/logs/biowatch"
CLAUDE="$HOME/.local/bin/claude"
MIN_DAYS="${BIOWATCH_MIN_DAYS:-13}"

mkdir -p "$LOG_DIR" "$OUTPUT_DIR"

TODAY=$(date '+%Y-%m-%d')
LOG="$LOG_DIR/$(date '+%Y%m%d_%H%M%S').log"
ts() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG"; }

ts "=== BioWatch scout starting ==="

if [[ -n "${BIOWATCH_FROM:-}" && -n "${BIOWATCH_TO:-}" ]]; then
    PERIOD_FROM="$BIOWATCH_FROM"
    PERIOD_TO="$BIOWATCH_TO"
    ts "Explicit window: $PERIOD_FROM -> $PERIOD_TO"
else
    if [[ -f "$LAST_RUN_FILE" ]]; then
        LAST=$(cat "$LAST_RUN_FILE")
        LAST_EPOCH=$(date -d "$LAST" +%s 2>/dev/null) || { ts "ERROR: bad date in $LAST_RUN_FILE"; exit 1; }
        DAYS_AGO=$(( ($(date +%s) - LAST_EPOCH) / 86400 ))
        if (( DAYS_AGO < MIN_DAYS )); then
            ts "Skipping: last run was $DAYS_AGO days ago ($LAST). Need $MIN_DAYS+."
            exit 0
        fi
        PERIOD_FROM="$LAST"
    else
        PERIOD_FROM=$(date -d "14 days ago" '+%Y-%m-%d')
        ts "No previous run found. Defaulting period_from to $PERIOD_FROM"
    fi
    PERIOD_TO="$TODAY"
fi

FILENAME="$(echo "$PERIOD_TO" | tr -d '-').md"
OUTPUT_FILE="$OUTPUT_DIR/$FILENAME"

if [[ -f "$OUTPUT_FILE" ]]; then
    ts "Output file already exists: $OUTPUT_FILE — skipping"
    exit 0
fi

ts "Period: $PERIOD_FROM -> $PERIOD_TO"
ts "Output: $OUTPUT_FILE"

PROMPT="$(cat "$INSTRUCTIONS")

## This run
- period_from: $PERIOD_FROM
- period_to: $PERIOD_TO
- output_file: $OUTPUT_FILE

Search thoroughly, then write the file to the exact output_file path above."

ts "Launching claude scout..."
"$CLAUDE" --allowedTools "WebSearch,Write,Read" -p "$PROMPT" 2>&1 | tee -a "$LOG"
CLAUDE_EXIT=${PIPESTATUS[0]}

if [[ $CLAUDE_EXIT -ne 0 ]]; then
    ts "ERROR: claude exited with code $CLAUDE_EXIT"
    exit 1
fi

if [[ ! -f "$OUTPUT_FILE" ]]; then
    ts "ERROR: output file not created: $OUTPUT_FILE"
    exit 1
fi

ts "Scout complete: $OUTPUT_FILE"

# Append an unchecked row to the review checklist
printf -- '- [ ] [[%s]] — %s -> %s\n' "${FILENAME%.md}" "$PERIOD_FROM" "$PERIOD_TO" >> "$CHECKLIST"
ts "Appended checklist row for $FILENAME"

if [[ -z "${BIOWATCH_FROM:-}" ]]; then
    echo "$PERIOD_TO" > "$LAST_RUN_FILE"
    ts "Updated last-run to $PERIOD_TO"
fi

ts "=== Done ==="

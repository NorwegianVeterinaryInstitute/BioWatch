#!/bin/bash
# =============================================================================
# BioWatch — backfill historical automated reports
#
# Walks forward, oldest-first, in 14-day windows from (earliest existing
# report's start - N days) up to that existing report's start, so each new
# cycle's duplicate check (see AGENT_INSTRUCTIONS.md) is comparing against
# real, already-generated history rather than guessing. Reuses
# run_biowatch.sh per window, so prompt, tools, tagging and checklist
# handling are identical to a normal scheduled run.
#
# Usage: bash bin/backfill.sh [days_back]   (default 365)
#
# Safe to interrupt and re-run: existing output files are skipped (same
# idempotency as run_biowatch.sh), so it resumes where it left off.
# =============================================================================
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUTPUT_DIR="$REPO_DIR/automated_findings"
DAYS_BACK="${1:-365}"
CADENCE_DAYS=14

EARLIEST_FILE=$(ls "$OUTPUT_DIR"/*.md 2>/dev/null | sort | head -1 || true)
if [[ -z "$EARLIEST_FILE" ]]; then
    echo "No existing reports found in $OUTPUT_DIR — nothing to backfill up to." >&2
    exit 1
fi

BOUNDARY=$(grep '^period_from:' "$EARLIEST_FILE" | head -1 | sed 's/period_from: *//')
if [[ -z "$BOUNDARY" ]]; then
    echo "Could not read period_from from $EARLIEST_FILE" >&2
    exit 1
fi

START=$(date -d "$BOUNDARY - $DAYS_BACK days" '+%Y-%m-%d')

echo "Backfilling from $START up to $BOUNDARY (existing earliest report: $EARLIEST_FILE)"
echo "Cadence: $CADENCE_DAYS days per cycle"
echo ""

CURSOR="$START"
N=0
FAILED=0

while [[ "$(date -d "$CURSOR" +%s)" -lt "$(date -d "$BOUNDARY" +%s)" ]]; do
    NEXT=$(date -d "$CURSOR + $CADENCE_DAYS days" '+%Y-%m-%d')
    if [[ "$(date -d "$NEXT" +%s)" -gt "$(date -d "$BOUNDARY" +%s)" ]]; then
        NEXT="$BOUNDARY"
    fi

    N=$((N + 1))
    echo "=== Backfill cycle $N: $CURSOR -> $NEXT ==="
    if BIOWATCH_FROM="$CURSOR" BIOWATCH_TO="$NEXT" bash "$REPO_DIR/bin/run_biowatch.sh"; then
        echo "=== Cycle $N OK ==="
    else
        echo "=== Cycle $N FAILED — continuing with next window ===" >&2
        FAILED=$((FAILED + 1))
    fi
    echo ""

    CURSOR="$NEXT"
done

echo "Backfill done: $N cycles attempted ($FAILED failed), covering $START to $BOUNDARY."

#!/bin/bash
# advance-drift-baseline.sh — record current code repo HEAD as the drift baseline.
#
# Run this after clearing tech-doc drift (e.g. after /w-sync-docs confirms all
# flagged docs are up to date). The SessionStart hook diffs from this SHA
# instead of HEAD~5, so only code changes since the last clear are reported.
#
# Usage: bash .claude/scripts/advance-drift-baseline.sh

DOCS_REPO="$(cd "$(dirname "$0")/../.." && pwd)"
CODE_REPO="$DOCS_REPO/../Peerloop"
BASELINE_FILE="$DOCS_REPO/.claude/.drift-baseline-sha"

SHA=$(git -C "$CODE_REPO" rev-parse HEAD 2>/dev/null)
if [[ -z "$SHA" ]]; then
  echo "Error: could not read HEAD from $CODE_REPO"
  exit 1
fi

echo "$SHA" > "$BASELINE_FILE"
echo "✅ Drift baseline advanced to $SHA"
echo "   Next SessionStart will diff from this commit."

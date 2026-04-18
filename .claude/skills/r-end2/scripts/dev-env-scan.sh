#!/bin/bash
# dev-env-scan.sh — Scan session files for machine-specific mentions
#
# Checks if any session files from the current month reference
# specific development machines, indicating potential devcomputers.md updates.

DOCS_REPO="$(cd "$(dirname "$0")/../../../.." && pwd)"
MONTH=$(date '+%Y-%m')
SESSION_DIR="$DOCS_REPO/docs/sessions/$MONTH"

echo "### Development Environment"

if [[ ! -d "$SESSION_DIR" ]]; then
  echo "No session directory for $MONTH. Skipping."
  exit 0
fi

matches=$(grep -l -E "(MacMiniM4-Pro|MacMiniM4)" "$SESSION_DIR"/*.md 2>/dev/null || true)

if [[ -z "$matches" ]]; then
  echo "No machine-specific mentions in $MONTH session files."
else
  count=$(echo "$matches" | wc -l | tr -d ' ')
  echo "**$count session files mention machine names** — review for devcomputers.md updates:"
  echo "$matches" | while IFS= read -r f; do
    basename_f=$(basename "$f")
    # Show the matching lines for context
    context=$(grep -E "(MacMiniM4-Pro|MacMiniM4)" "$f" | head -2 | sed 's/^/    /')
    echo "- \`$basename_f\`"
    echo "$context"
  done
fi

#!/bin/bash
# SessionStart hook: Track session number and start time in SESSION-INDEX.md

SESSION_FILE="$CLAUDE_PROJECT_DIR/SESSION-INDEX.md"

# Check if SESSION-INDEX.md exists
if [ ! -f "$SESSION_FILE" ]; then
  echo "SESSION-INDEX.md not found - creating initial file"
  echo "# Session Index" > "$SESSION_FILE"
  echo "" >> "$SESSION_FILE"
  LAST_SESSION=0
else
  # Get the last session number (find highest "## Session N" line)
  LAST_SESSION=$(grep -E "^## Session [0-9]+" "$SESSION_FILE" | tail -1 | sed 's/## Session //')
  if [ -z "$LAST_SESSION" ]; then
    LAST_SESSION=0
  fi
fi

# Increment session number
NEW_SESSION=$((LAST_SESSION + 1))

# Get current timestamp
TIMESTAMP=$(date '+%b %d, %Y %H:%M')

# Append new session entry
echo "" >> "$SESSION_FILE"
echo "## Session $NEW_SESSION" >> "$SESSION_FILE"
echo "- Time Start: $TIMESTAMP" >> "$SESSION_FILE"

echo "=== SESSION TRACKING ==="
echo ""
echo "Session #$NEW_SESSION started at $TIMESTAMP"
echo ""
echo "=== END SESSION TRACKING ==="

exit 0

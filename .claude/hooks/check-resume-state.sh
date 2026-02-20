#!/bin/bash
# SessionStart hook: Detect and display RESUME-STATE.md at session start
# This runs automatically when Claude Code starts a new session

RESUME_FILE="${CLAUDE_PROJECT_DIR:-$(pwd)}/RESUME-STATE.md"

if [ -f "$RESUME_FILE" ]; then
  # Extract key fields for display
  SAVED_AT=$(grep "Saved At" "$RESUME_FILE" | head -1 | sed 's/.*: //')
  PHASE=$(grep "Phase" "$RESUME_FILE" | head -1 | sed 's/.*: //')
  SUBTASK=$(grep "Subtask" "$RESUME_FILE" | head -1 | sed 's/.*: //')
  NEXT_ACTION=$(grep -A1 "## Next Action" "$RESUME_FILE" | tail -1)

  echo "=== RESUME STATE DETECTED ==="
  echo ""
  echo "Found saved resume state from: $SAVED_AT"
  echo "----------------------------------------"
  echo "Phase: $PHASE"
  echo "Task: $SUBTASK"
  echo "Next: $NEXT_ACTION"
  echo ""
  echo "Options:"
  echo "1. Resume this work (/q-resume)"
  echo "2. View full state file (read RESUME-STATE.md)"
  echo "3. Ignore and delete state file"
  echo "4. Ignore but keep state file"
  echo ""
  echo "=== END RESUME STATE ==="
fi

exit 0

#!/bin/bash
# SessionStart hook: Detect and display RESUME-STATE.md at session start
# Works with any RESUME-STATE.md format — shows content directly

RESUME_FILE="${CLAUDE_PROJECT_DIR:-$(pwd)}/RESUME-STATE.md"

if [ -f "$RESUME_FILE" ]; then
  CONTENT=$(cat "$RESUME_FILE")

  echo "╔══════════════════════════════════════════════════╗"
  echo "║  RESUME STATE DETECTED — ACTION REQUIRED        ║"
  echo "║                                                  ║"
  echo "║  You MUST present this to the user immediately.  ║"
  echo "║  Do NOT start other work. Do NOT ignore this.    ║"
  echo "╚══════════════════════════════════════════════════╝"
  echo ""
  echo "$CONTENT"
  echo ""
  echo "──────────────────────────────────────────────────"
  echo "Present these options to the user:"
  echo "  1. Resume this work"
  echo "  2. Ignore and delete state file"
  echo "  3. Ignore but keep state file"
  echo "──────────────────────────────────────────────────"
fi

exit 0

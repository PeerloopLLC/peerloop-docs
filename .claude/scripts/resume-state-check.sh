#!/bin/bash
# Check if RESUME-STATE.md exists and show its saved date
DOCS_ROOT="${CLAUDE_PROJECT_DIR:-$(pwd)}"
if [ -f "$DOCS_ROOT/RESUME-STATE.md" ]; then
  echo "EXISTS — saved on:"
  head -5 "$DOCS_ROOT/RESUME-STATE.md" | grep 'Saved:'
else
  echo "No existing RESUME-STATE.md"
fi

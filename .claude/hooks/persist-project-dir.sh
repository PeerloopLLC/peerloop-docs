#!/bin/bash
# Persist $CLAUDE_PROJECT_DIR (available in hooks) to $CLAUDE_ENV_FILE
# so it's available in skill !` backtick expressions for the rest of the session.
if [ -n "$CLAUDE_ENV_FILE" ] && [ -n "$CLAUDE_PROJECT_DIR" ]; then
  echo "export CLAUDE_PROJECT_DIR=$CLAUDE_PROJECT_DIR" >> "$CLAUDE_ENV_FILE"
fi
exit 0

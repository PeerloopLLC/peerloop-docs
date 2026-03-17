#!/bin/bash
# Read .conv-current (ephemeral file) and display value
# Used by ! backtick pre-computation in r-commit and r-end
DOCS_ROOT="${CLAUDE_PROJECT_DIR:-$(pwd)}"
if [ -f "$DOCS_ROOT/.conv-current" ]; then
    cat "$DOCS_ROOT/.conv-current"
else
    echo "MISSING — no active conv (run /r-start first)"
fi

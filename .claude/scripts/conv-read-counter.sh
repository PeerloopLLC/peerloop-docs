#!/bin/bash
# Read CONV-COUNTER and display current value
# Used by ! backtick pre-computation in r-start
DOCS_ROOT="${CLAUDE_PROJECT_DIR:-$(pwd)}"
if [ -f "$DOCS_ROOT/CONV-COUNTER" ]; then
    cat "$DOCS_ROOT/CONV-COUNTER"
else
    echo "MISSING — CONV-COUNTER file not found"
fi

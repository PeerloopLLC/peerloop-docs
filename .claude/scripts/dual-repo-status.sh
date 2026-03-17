#!/bin/bash
# Check both repos for uncommitted changes — used by r-start to verify clean state
DOCS_ROOT="${CLAUDE_PROJECT_DIR:-$(pwd)}"
CODE_ROOT="$DOCS_ROOT/../Peerloop"

echo "=== Docs repo (peerloop-docs) ==="
DOCS_STATUS=$(git -C "$DOCS_ROOT" status --short 2>/dev/null)
if [ -z "$DOCS_STATUS" ]; then
    echo "CLEAN"
else
    echo "DIRTY"
    echo "$DOCS_STATUS"
fi

echo ""
echo "=== Code repo (Peerloop) ==="
if [ -d "$CODE_ROOT" ]; then
    CODE_STATUS=$(git -C "$CODE_ROOT" status --short 2>/dev/null)
    if [ -z "$CODE_STATUS" ]; then
        echo "CLEAN"
    else
        echo "DIRTY"
        echo "$CODE_STATUS"
    fi
else
    echo "NOT FOUND at $CODE_ROOT"
fi

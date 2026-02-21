#!/bin/bash
# SessionStart hook: Display dual-repo architecture info

DOCS_REPO="$CLAUDE_PROJECT_DIR"
CODE_REPO="$CLAUDE_PROJECT_DIR/../Peerloop"

echo "=== DUAL-REPO MODE ==="
echo ""
echo "  Docs repo:  $(basename "$DOCS_REPO")  ($(git -C "$DOCS_REPO" branch --show-current 2>/dev/null || echo 'no branch'))"
echo "  Code repo:  $(basename "$CODE_REPO")  ($(git -C "$CODE_REPO" branch --show-current 2>/dev/null || echo 'not found'))"
echo ""
echo "=== END DUAL-REPO ==="

exit 0

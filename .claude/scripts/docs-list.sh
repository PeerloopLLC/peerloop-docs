#!/bin/bash
# List all markdown files in docs/
DOCS_ROOT="${CLAUDE_PROJECT_DIR:-$(pwd)}"
find "$DOCS_ROOT/docs" -name '*.md' 2>/dev/null | sort | sed "s|$DOCS_ROOT/||" | sed 's|^|- |' || echo "- (no docs found)"

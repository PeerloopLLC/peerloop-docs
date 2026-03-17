#!/bin/bash
# List recent Dev session files for the current month
DOCS_ROOT="${CLAUDE_PROJECT_DIR:-$(pwd)}"
MONTH=$(date '+%Y-%m')
find "$DOCS_ROOT/docs/sessions/$MONTH" -name '*Dev.md' 2>/dev/null | sort | tail -5 | sed 's|^|- |' || echo "- (none yet this month)"

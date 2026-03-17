#!/bin/bash
# Find WIP markers and checkboxes in PLAN.md
DOCS_ROOT="${CLAUDE_PROJECT_DIR:-$(pwd)}"
grep -n 'IN PROGRESS\|WIP\|\[x\]\|\[ \]' "$DOCS_ROOT/PLAN.md" 2>/dev/null | head -30 || echo "(no WIP markers found)"

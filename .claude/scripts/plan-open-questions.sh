#!/bin/bash
# Extract the Open Questions section from PLAN.md
DOCS_ROOT="${CLAUDE_PROJECT_DIR:-$(pwd)}"
sed -n '/^## Open Questions/,/^## /p' "$DOCS_ROOT/PLAN.md" 2>/dev/null | head -20 || echo "(none found)"

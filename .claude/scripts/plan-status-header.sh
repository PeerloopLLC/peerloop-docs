#!/bin/bash
# Extract everything from start of PLAN.md up to first "## In Progress" or "## Deferred" heading
DOCS_ROOT="${CLAUDE_PROJECT_DIR:-$(pwd)}"
sed -n '1,/^## \(In Progress\|Deferred\)/p' "$DOCS_ROOT/PLAN.md" 2>/dev/null | head -30 || echo "(not found)"

#!/bin/bash
# SessionStart hook: surface tech-doc drift at conv start.
#
# Wraps .claude/scripts/tech-doc-sweep.sh in a compact presentation.
# Silent on clean state (no drift) so it doesn't become noise — only speaks
# up when something is flagged. This is Option D of DOC-SYNC-STRATEGY Phase 3.

SWEEP_SCRIPT="$CLAUDE_PROJECT_DIR/.claude/scripts/tech-doc-sweep.sh"

if [[ ! -x "$SWEEP_SCRIPT" ]]; then
  exit 0
fi

output=$(bash "$SWEEP_SCRIPT" 2>/dev/null)

# Silent on clean state — no output, no "=== ... ===" block.
if echo "$output" | grep -qE "No (reference/as-designed docs flagged|recent code changes)"; then
  exit 0
fi

flagged_count=$(echo "$output" | grep -m1 -oE "\*\*[0-9]+ docs flagged" | grep -oE "[0-9]+")

echo "=== TECH-DOC DRIFT ==="
echo ""
echo "🔴 ${flagged_count:-some} doc(s) may be out of sync with recent code (code repo HEAD~5)."
echo ""
# Print only the bulleted list, stopping before the "For each flagged doc" footer.
echo "$output" | awk '
  /^For each flagged doc/ { exit }
  /^- `/ { in_list = 1 }
  in_list { print }
'
echo ""
echo "Resolve: run /w-sync-docs or address during /r-end2."
echo "Silent next session if drift is cleared."
echo ""
echo "=== END TECH-DOC DRIFT ==="

exit 0

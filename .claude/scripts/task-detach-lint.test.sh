#!/usr/bin/env bash
# task-detach-lint.test.sh — assert the Task-subsystem detach (Conv 406) stays intact.
#
# Structural invariants that must hold after the write-through cutover. Fails if a
# future edit re-introduces a Task tool into a skill, reverts a CURRENT-TASKS.md
# anchor, or drops the write-through wording. Read-only.
#
# Run:  .claude/scripts/task-detach-lint.test.sh

set -uo pipefail
ROOT="$HOME/projects/peerloop-docs"
pass=0 fail=0

ok()   { echo "  ✅ $1"; pass=$((pass+1)); }
bad()  { echo "  ❌ $1"; fail=$((fail+1)); }
check(){ if [ "$2" -eq 0 ]; then ok "$1"; else bad "$1${3:+ — $3}"; fi }

echo "task-detach lint:"

# 1. No skill frontmatter declares a Task subsystem tool in allowed-tools.
hits=$(grep -rn '^allowed-tools:' "$ROOT/.claude/skills" 2>/dev/null \
        | grep -E 'TaskCreate|TaskList|TaskUpdate|TaskGet|TodoWrite' || true)
check "no Task* in any skill allowed-tools" "$([ -z "$hits" ] && echo 0 || echo 1)" "${hits:0:120}"

# 2. No stale CURRENT-TASKS.md anchors anywhere in .claude/ or CLAUDE.md (excl. memory mirror + these tests).
stale=$(grep -rnE '🔥 Ordered|Unordered backlog|Completed this conv|## ⏸️ PARKED' \
         "$ROOT/.claude" "$ROOT/CLAUDE.md" 2>/dev/null \
         | grep -v 'memory-sync' | grep -v '\.test\.sh' || true)
check "no stale old-format anchors" "$([ -z "$stale" ] && echo 0 || echo 1)" "${stale:0:120}"

# 3. The output-reminder hook no longer says TodoWrite.
check "hook drops TodoWrite wording" \
  "$(grep -q 'TodoWrite' "$ROOT/.claude/hooks/check-output-reminder.sh" && echo 1 || echo 0)"

# 4. CLAUDE.md §Task Persistence carries the write-through model.
check "CLAUDE.md states write-through model" \
  "$(grep -qi 'write-through' "$ROOT/CLAUDE.md" && echo 0 || echo 1)"

# 5. The four load-bearing anchors exist in the live board, in order.
BOARD="$ROOT/CURRENT-TASKS.md"
if [ -f "$BOARD" ]; then
  order=$(grep -nE '^## (🎯 Now|⏸️ Parked|Tasks|✅ Done this conv)' "$BOARD" | sed 's/:.*//' | tr '\n' ' ')
  four=$(grep -cE '^## (🎯 Now|⏸️ Parked|Tasks|✅ Done this conv)' "$BOARD")
  sorted=$(echo "$order" | tr ' ' '\n' | sed '/^$/d' | sort -n | tr '\n' ' ')
  check "live board has all 4 anchors"      "$([ "$four" -eq 4 ] && echo 0 || echo 1)" "found $four"
  check "anchors are in canonical order"    "$([ "$order" = "$sorted" ] && echo 0 || echo 1)"
else
  bad "live board CURRENT-TASKS.md missing"
fi

# 6. The validator script exists and is executable.
check "current-tasks-check.sh executable" "$([ -x "$ROOT/.claude/scripts/current-tasks-check.sh" ] && echo 0 || echo 1)"

echo "-------------------------------------------"
echo "task-detach lint: $pass passed, $fail failed"
[ "$fail" -eq 0 ]

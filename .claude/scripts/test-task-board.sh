#!/usr/bin/env bash
# test-task-board.sh — one command to test the write-through task board + Task-tool
# detach (Conv 406). Runs the live-board validation and all three test suites.
#
#   1. current-tasks-check.sh          — validate the live CURRENT-TASKS.md
#   2. current-tasks-check.test.sh     — self-test: does the validator catch each break?
#   3. task-board-lifecycle.test.sh    — add/start/park/complete + Done-reset are green
#   4. task-detach-lint.test.sh        — no Task tool / stale anchor crept back in
#
# Run:  .claude/scripts/test-task-board.sh
# Exit: 0 if everything passes, 1 otherwise.

set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
rc=0

echo "════════════════════════════════════════════"
echo " Task board — full test run"
echo "════════════════════════════════════════════"

echo; echo "▶ live board validation:"
out="$("$HERE/current-tasks-check.sh")"
echo "  $out"
[[ "$out" == OK:* ]] || rc=1

for t in current-tasks-check.test.sh task-board-lifecycle.test.sh task-detach-lint.test.sh; do
  echo; echo "▶ $t:"
  if "$HERE/$t"; then :; else rc=1; fi
done

echo; echo "════════════════════════════════════════════"
if [ "$rc" -eq 0 ]; then echo " ✅ ALL TASK-BOARD TESTS PASSED"; else echo " ❌ TASK-BOARD TESTS FAILED"; fi
echo "════════════════════════════════════════════"
exit "$rc"

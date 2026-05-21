#!/bin/bash
# cross-machine-verify.sh — HOME-simulation harness for path-derivation patterns.
#
# Why: The dual-repo project runs on two dev machines with different usernames
# (M4 = "livingroom", M4Pro = "jamesfraser"). Skills, hooks, and scripts must
# work identically on both. Patterns established by the Conv 162 sweep
# (tilde-literal everywhere, slug derivation via $(echo ~/... | tr / -), etc.)
# can silently break if authored against one HOME and never verified against
# the other. This harness runs each canonical pattern under both HOMEs and
# asserts the structural property holds.
#
# Usage:
#   ~/projects/peerloop-docs/.claude/scripts/cross-machine-verify.sh
#     → run all built-in test cases, output side-by-side + pass/fail summary
#
#   ~/projects/peerloop-docs/.claude/scripts/cross-machine-verify.sh --scan <file>
#     → scan a skill SKILL.md or shell script for tilde / $HOME references and
#       resolve each under both HOMEs (advisory, no pass/fail)
#
# Use before committing changes to: any skill SKILL.md, any .claude/scripts/*,
# any hook in ~/.claude/hooks/, or any code that derives a path from $HOME.

set -u

M4_HOME=/Users/livingroom
M4PRO_HOME=/Users/jamesfraser

# ─── Test case framework ─────────────────────────────────────────────
# Each case is named; expression runs in a subshell under each HOME.
# Assertion is a glob pattern that BOTH outputs must match structurally.

pass=0
fail=0
results=()

run_case() {
  local name=$1
  local expr=$2
  local assert_glob=$3
  local description=$4

  local out_m4
  local out_m4pro
  out_m4=$(HOME=$M4_HOME bash -c "$expr" 2>&1)
  out_m4pro=$(HOME=$M4PRO_HOME bash -c "$expr" 2>&1)

  local status
  if [[ $out_m4 == $assert_glob && $out_m4pro == $assert_glob ]]; then
    status=PASS
    ((pass++))
  else
    status=FAIL
    ((fail++))
  fi

  results+=("$status  $name")
  results+=("       $description")
  results+=("       expr:    $expr")
  results+=("       assert:  $assert_glob")
  results+=("       M4:      $out_m4")
  results+=("       M4Pro:   $out_m4pro")
  results+=("")
}

# ─── Scan mode ──────────────────────────────────────────────────────
if [[ ${1:-} == --scan ]]; then
  file=${2:-}
  if [[ -z $file || ! -f $file ]]; then
    echo "Usage: $0 --scan <file>" >&2
    exit 2
  fi
  echo "Scanning $file for tilde / \$HOME / \$CLAUDE_PROJECT_DIR references..."
  echo ""
  # Pull every line containing one of these markers. Strip surrounding markdown.
  grep -nE '(~/|\$HOME\b|\$CLAUDE_PROJECT_DIR\b)' "$file" 2>/dev/null | while IFS= read -r line; do
    echo "  $line"
  done
  exit 0
fi

# ─── Built-in test cases ────────────────────────────────────────────

# 1. Tilde outside quotes expands to $HOME
run_case "tilde-unquoted-docs" \
  'echo ~/projects/peerloop-docs' \
  '/Users/*/projects/peerloop-docs' \
  "Tilde outside quotes expands to absolute path on both machines"

run_case "tilde-unquoted-code" \
  'echo ~/projects/Peerloop' \
  '/Users/*/projects/Peerloop' \
  "Code-repo tilde path resolves correctly"

# 2. Tilde INSIDE quotes does NOT expand (bug-trap)
run_case "tilde-quoted-stays-literal" \
  'echo "~/projects/peerloop-docs"' \
  '~/projects/peerloop-docs' \
  "Tilde inside double quotes is a literal; warns the user this pattern was broken"

# 3. SLUG derivation pattern (Conv 162)
run_case "slug-derivation" \
  'echo ~/projects/peerloop-docs | tr / -' \
  '-Users-*-projects-peerloop-docs' \
  "SLUG derived via tr-based subshell produces dash-separated path"

# 4. Memory dir path derivation
run_case "memory-dir-derivation" \
  'SLUG=$(echo ~/projects/peerloop-docs | tr / -); echo ~/.claude/projects/$SLUG/memory' \
  '/Users/*/.claude/projects/-Users-*-projects-peerloop-docs/memory' \
  "Memory dir composed from \$HOME-derived slug; both segments expand on both machines"

# 5. Mirror dir path derivation
run_case "mirror-dir-derivation" \
  'echo ~/projects/peerloop-docs/.claude/memory-sync/memories' \
  '/Users/*/projects/peerloop-docs/.claude/memory-sync/memories' \
  "Mirror dir under docs repo (in-tree, doesn't depend on machine slug)"

# 6. $HOME outside quotes expands like tilde
run_case "home-unquoted-equivalence" \
  'echo $HOME/projects/peerloop-docs' \
  '/Users/*/projects/peerloop-docs' \
  "Bare \$HOME outside quotes resolves the same as tilde (would prompt in Claude Code Bash gate)"

# 7. Slug ends with expected suffix (structural property — last 14 chars are stable)
run_case "slug-suffix-stable" \
  'echo ~/projects/peerloop-docs | tr / - | grep -oE "peerloop-docs$"' \
  'peerloop-docs' \
  "Slug always ends with 'peerloop-docs' regardless of HOME (last path segment is HOME-independent)"

# 8. Conv counter file path
run_case "conv-counter-path" \
  'echo ~/projects/peerloop-docs/CONV-COUNTER' \
  '/Users/*/projects/peerloop-docs/CONV-COUNTER' \
  "CONV-COUNTER absolute path resolves correctly on both"

# ─── Report ─────────────────────────────────────────────────────────

echo "Cross-Machine Path-Derivation Verification"
echo "=========================================="
echo "Simulated HOMEs:"
echo "  M4    = $M4_HOME"
echo "  M4Pro = $M4PRO_HOME"
echo ""

for line in "${results[@]}"; do
  echo "$line"
done

echo "──────────────────────────────────────────"
echo "Total: $((pass + fail)) cases — $pass pass, $fail fail"

if (( fail > 0 )); then
  exit 1
fi
exit 0

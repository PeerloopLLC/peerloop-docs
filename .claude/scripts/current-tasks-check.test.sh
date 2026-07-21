#!/usr/bin/env bash
# current-tasks-check.test.sh — self-test for current-tasks-check.sh.
#
# Builds a good CURRENT-TASKS.md fixture and one deliberately-broken variant per
# failure class, and asserts the checker (a) passes the good one and (b) flags each
# break with the right label. Exit 0 = all pass, 1 = a regression in the checker.
#
# Run:  .claude/scripts/current-tasks-check.test.sh
# CI:   wire into the boundary skills / a hook if a hard gate is ever wanted.

set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CHECK="$HERE/current-tasks-check.sh"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

pass=0 fail=0

# A minimal, valid board.
good() {
  cat <<'EOF'
# Current Tasks

## 🎯 Now

1. [AAA](#aaa) — thing one
2. [BBB](#bbb) — thing two

## ⏸️ Parked

- [CCC](#ccc) — gate: something

## Tasks

### [AAA]

- **State:** 🔄 active

### [BBB]

- **State:** 📋 queued

### [CCC]

- **State:** ⏸️ parked · gate: something

## ✅ Done this conv

_(none)_
EOF
}

# assert <name> <fixture-file> <expected-substring>  ("OK:" means expect a clean pass)
assert() {
  local name="$1" file="$2" want="$3" out
  out="$($CHECK "$file")"
  if echo "$out" | grep -qF "$want"; then
    echo "  ✅ $name"; pass=$((pass+1))
  else
    echo "  ❌ $name — expected \"$want\", got: $out"; fail=$((fail+1))
  fi
}

echo "current-tasks-check self-test:"

# 1. GOOD — must pass clean.
good > "$TMP/good.md"
assert "good board passes"        "$TMP/good.md" "OK:"

# 2. DANGLING — TOC line with no body.
{ good; } > "$TMP/dangling.md"
# insert a Now entry for a code that has no body (after line 1 of the Now list)
awk '1; /^1\. \[AAA\]/{print "2. [ZZZ](#zzz) — no body here"}' "$TMP/good.md" > "$TMP/dangling.md"
assert "dangling TOC link caught" "$TMP/dangling.md" "DANGLING"

# 3. ORPHAN — body with no TOC line.
awk '1; /^### \[CCC\]/{hit=1} hit && /^- \*\*State:\*\* ⏸️/ && !done{print ""; print "### [ORP]"; print ""; print "- **State:** 📋 queued"; done=1}' "$TMP/good.md" > "$TMP/orphan.md"
assert "orphan body caught"       "$TMP/orphan.md" "ORPHAN"

# 4. DUPLICATE — same code heads two bodies.
awk '1; /^### \[AAA\]/ && !d{print ""; print "### [AAA]"; print ""; print "- **State:** 🔄 active"; d=1}' "$TMP/good.md" > "$TMP/dup.md"
assert "duplicate body caught"    "$TMP/dup.md" "DUPLICATE"

# 5. IN-BOTH — code in Now and Parked.
awk '1; /^- \[CCC\]/{print "- [AAA](#aaa) — gate: bogus"}' "$TMP/good.md" > "$TMP/both.md"
assert "in-both-TOCs caught"      "$TMP/both.md" "IN BOTH"

# 6. BAD-SLUG — TOC link slug != code.
sed 's/\[AAA\](#aaa)/[AAA](#wrongslug)/' "$TMP/good.md" > "$TMP/badslug.md"
assert "bad slug caught"          "$TMP/badslug.md" "BAD-SLUG"

# 7. STATE-MISMATCH — parked State but listed in Now.
awk '{ if ($0=="- **State:** 🔄 active" && !d){print "- **State:** ⏸️ parked"; d=1} else print }' "$TMP/good.md" > "$TMP/mismatch.md"
assert "state/section mismatch caught" "$TMP/mismatch.md" "STATE-MISMATCH"

echo "-------------------------------------------"
echo "current-tasks-check self-test: $pass passed, $fail failed"
[ "$fail" -eq 0 ]

#!/usr/bin/env bash
# extract-prune.test.sh — self-test / calibration for extract-prune.mjs.
#
# Calibrated per [CMH] against the canonical case: Conv 429, where the Step-4b prune
# honoured a 140-line manifest of lines the learn-decide agent had merely READ, and
# stripped §Prompts & Actions narrative, cut §Completed 8 items → 1, and emptied
# §Open Questions and §New Patterns.
#
# HONEST LIMIT ON THE CALIBRATION: the literal replay the [PRUNESAFE] task specifies
# — Conv 429's real manifest against Conv 429's pre-prune Extract — is NOT possible.
# The manifest is rm'd by Step 4b itself, and the Extract was only ever committed
# post-prune (19dc595), so neither artefact survives. Fixture 1 below therefore
# RECONSTRUCTS that case: the section layout is copied from the real committed
# Extract's headings (Meta / Prompts & Actions / Learnings / Decisions / Progress
# {Completed, New Subtasks, Blockers, Open Questions} / Changes {Code, Docs, New
# Patterns}), and the manifest carries the same failure signature — line numbers
# spread across sections the prune must not be able to reach. That reproduces the
# defect exactly; it is not the original bytes.
#
# Run:  .claude/scripts/extract-prune.test.sh
# Exit: 0 = all pass, 1 = a regression in the pruner.

set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PRUNE="$HERE/extract-prune.mjs"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

PASS=0; FAIL=0
ok()   { echo "  ✅ $1"; PASS=$((PASS+1)); }
bad()  { echo "  ❌ $1"; FAIL=$((FAIL+1)); }
check(){ if [ "$2" = "$3" ]; then ok "$1"; else bad "$1 (want '$3', got '$2')"; fi; }

# ── Fixture 1: the Conv-429 shape ────────────────────────────────────────────
make_extract() {
cat > "$1" <<'EOF'
# Conv 429 Extract

## Meta
- Conv: 429
- Machine: MacMiniM4Pro

## Prompts & Actions

### /r-start
Counter incremented, memory synced.

### Dev-tooling batch
Traced three brick variants, all root-caused.
Never port-kill — lsof returns Chrome.

## Learnings
The astro-7 dev server daemonizes and returns exit 0.
Green gates conceal drift as effectively as red ones.

## Decisions
Fix the retired-status defect on both surfaces, then decide the card.
Keep the --icon-N family as-is.

## Progress

### Completed
- [DEVSRV-KILL] closed
- [DEVSRV-STALE] closed
- [CRS-CREATED-CARD] closed
- [PROV-DANGLE] closed
- retired-badge defect fixed
- port-kill swept from 4 places
- hook rule added
- 2 regression guards added

### Open Questions
- Does WS-DATA-MODEL block anything else?

## Changes

### Code repo
- 50baeff2 retired badge
- 5ded9f68 prov dangle

### New Patterns
- Ask what dead code KNOWS, not who calls it.
EOF
}

EX="$TMP/20260729_0649 Extract.md"
MAN="$TMP/manifest.txt"

echo "extract-prune.test.sh"
echo
echo "Fixture 1 — Conv-429 signature: manifest spans the whole file"

make_extract "$EX"
TOTAL_BEFORE=$(wc -l < "$EX" | tr -d ' ')

# §Learnings body is lines 17-18, §Decisions body 21-22 (1-indexed, per the fixture).
# The manifest lists those AND lines from every other section — the Conv-429 failure.
printf '%s\n' 9 12 13 17 18 21 22 27 28 29 34 41 45 > "$MAN"

OUT="$("$PRUNE" "$EX" "$MAN" 2>&1)"
RC=$?
check "exit 0" "$RC" "0"

IGNORED=$(echo "$OUT" | grep -oE 'IGNORED \(out-of-span\): [0-9]+' | grep -oE '[0-9]+$')
DELETED=$(echo "$OUT" | grep -oE 'deleted +: [0-9]+' | grep -oE '[0-9]+$')
check "deletes only the 4 in-span lines" "$DELETED" "4"
check "ignores the 9 out-of-span lines"  "$IGNORED" "9"

# The whole point: every other section survives byte-for-byte.
grep -q "Traced three brick variants" "$EX" && ok "§Prompts & Actions intact" || bad "§Prompts & Actions damaged"
# Count list items between "### Completed" and the next "###" — the Conv-429 damage
# was 8 → 1 here, so this is the assertion that matters most.
COMPLETED_ITEMS=$(awk '/^### Completed/{f=1;next} f&&/^### /{exit} f&&/^- /{n++} END{print n+0}' "$EX")
check "§Completed still has all 8 items" "$COMPLETED_ITEMS" "8"
grep -q "Does WS-DATA-MODEL block" "$EX" && ok "§Open Questions intact"   || bad "§Open Questions emptied"
grep -q "Ask what dead code KNOWS" "$EX" && ok "§New Patterns intact"     || bad "§New Patterns emptied"
grep -q "50baeff2 retired badge"   "$EX" && ok "§Changes intact"          || bad "§Changes damaged"

# And the sections it IS allowed to touch were collapsed to pointers.
grep -q '→ See `20260729_0649 Learnings.md`' "$EX" && ok "Learnings pointer inserted" || bad "no Learnings pointer"
grep -q '→ See `20260729_0649 Decisions.md`' "$EX" && ok "Decisions pointer inserted" || bad "no Decisions pointer"
grep -q "astro-7 dev server daemonizes" "$EX" && bad "Learnings body not pruned" || ok "Learnings body pruned"

echo
echo "Fixture 2 — the OLD behaviour must genuinely have been destructive"
# Calibration in the other direction: if the span filter is what saves us, then
# applying the same manifest WITHOUT it must wreck the file. Simulated by deleting
# every manifest line directly (what Step 4b's prose said to do).
make_extract "$EX"
python3 - "$EX" "$MAN" <<'PY'
import sys
ex, man = sys.argv[1], sys.argv[2]
lines = open(ex).read().split('\n')
doomed = {int(l)-1 for l in open(man) if l.strip().isdigit()}
open(ex,'w').write('\n'.join(l for i,l in enumerate(lines) if i not in doomed))
PY
grep -q "Traced three brick variants" "$EX" && bad "unfiltered prune left §Prompts intact — fixture is not exercising the bug" \
  || ok "unfiltered prune destroys §Prompts & Actions (the bug is real)"

echo
echo "Fixture 3 — edge cases"
make_extract "$EX"; printf '' > "$MAN"
"$PRUNE" "$EX" "$MAN" >/dev/null 2>&1
check "empty manifest → exit 0" "$?" "0"
check "empty manifest → file unchanged" "$(wc -l < "$EX" | tr -d ' ')" "$TOTAL_BEFORE"

make_extract "$EX"
"$PRUNE" "$EX" "$TMP/nope.txt" >/dev/null 2>&1
check "missing manifest → exit 0" "$?" "0"

make_extract "$EX"
seq 1 "$TOTAL_BEFORE" > "$MAN"
"$PRUNE" "$EX" "$MAN" >/dev/null 2>&1
check "manifest of every line → still exit 0 (span-bounded)" "$?" "0"
grep -q "Traced three brick variants" "$EX" && ok "even an all-lines manifest cannot reach §Prompts" \
  || bad "all-lines manifest escaped the span filter"

make_extract "$EX"; printf '%s\n' 17 18 > "$MAN"
"$PRUNE" "$EX" "$MAN" --dry-run >/dev/null 2>&1
check "--dry-run → file unchanged" "$(wc -l < "$EX" | tr -d ' ')" "$TOTAL_BEFORE"

printf 'no headings here\n' > "$TMP/bare.md"; printf '1\n' > "$MAN"
"$PRUNE" "$TMP/bare.md" "$MAN" >/dev/null 2>&1
check "no prunable sections → exit 2" "$?" "2"

echo
echo "──────────────────────────────"
echo "  passed: $PASS   failed: $FAIL"
[ "$FAIL" -eq 0 ] || exit 1

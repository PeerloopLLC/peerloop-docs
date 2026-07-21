#!/usr/bin/env bash
# task-board-lifecycle.test.sh — exercise the write-through task-board WORKFLOW.
#
# Proves the operations the lifecycle skills describe actually produce checker-green
# states, on both a controlled fixture and a copy of the REAL board. Also tests the
# r-start Step 7.5 Done-reset awk. All work happens on sandbox copies — the real
# CURRENT-TASKS.md is never modified.
#
# Ops covered: add → start → park → complete, plus the ✅ Done reset.
# Run:  .claude/scripts/task-board-lifecycle.test.sh

set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CHECK="$HERE/current-tasks-check.sh"
LIVE="$HOME/projects/peerloop-docs/CURRENT-TASKS.md"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
pass=0 fail=0

green() { # <name> <file>
  local out; out="$($CHECK "$2")"
  if [[ "$out" == OK:* ]]; then echo "  ✅ $1"; pass=$((pass+1))
  else echo "  ❌ $1 — $out"; fail=$((fail+1)); fi
}
want() { # <name> <expr result 0=ok>
  if [ "$2" -eq 0 ]; then echo "  ✅ $1"; pass=$((pass+1)); else echo "  ❌ $1"; fail=$((fail+1)); fi
}
nowcount() { $CHECK "$1" | sed -n 's/^OK: \([0-9]*\) Now.*/\1/p'; }

fixture() {
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

echo "task-board lifecycle test:"

# ── Op sequence on a controlled fixture ──────────────────────────────
F="$TMP/board.md"
fixture > "$F"
green "baseline"                 "$F"
base_now=$(nowcount "$F")

# ADD: new queued task → body under ## Tasks + line in 🎯 Now.
awk '
  /^## ⏸️ Parked/ && !n { print "3. [NEW](#new) — a new task"; print "" }
  /^## ✅ Done this conv/ && !b { print "### [NEW]"; print ""; print "- **State:** 📋 queued"; print ""; b=1 }
  { print }
  /^3\. \[NEW\]/ { n=1 }
' "$F" > "$F.1" && mv "$F.1" "$F"
green "after ADD (queued)"       "$F"
want  "ADD raised Now count"     "$([ "$(nowcount "$F")" -eq $((base_now+1)) ] && echo 0 || echo 1)"

# START: flip [NEW] State queued → active (body doesn't move).
sed 's/- \*\*State:\*\* 📋 queued$/- **State:** 🔄 active/;t' "$F" | \
  awk 'BEGIN{d=0} /^- \*\*State:\*\* 🔄 active$/{if(d){print;next}} {print}' > "$F.1" && mv "$F.1" "$F"
# (BBB was 📋 queued too; ensure NEW specifically is active — simplest: set both queued→active is fine for validity)
green "after START (active)"     "$F"

# PARK: move [NEW] from 🎯 Now to ⏸️ Parked + State → parked. Body stays put.
awk '
  /^3\. \[NEW\]/ { next }                                   # drop the Now line
  /^- \[CCC\]/ { print; print "- [NEW](#new) — gate: waiting"; next }  # add a Parked line
  { print }
' "$F" > "$F.1" && mv "$F.1" "$F"
# set NEW body State → parked (it is the body whose heading is ### [NEW])
awk '
  /^### \[NEW\]/ { innew=1 }
  /^### / && !/^### \[NEW\]/ { innew=0 }
  innew && /^- \*\*State:\*\*/ { print "- **State:** ⏸️ parked · gate: waiting"; next }
  { print }
' "$F" > "$F.1" && mv "$F.1" "$F"
green "after PARK"               "$F"
want  "PARK returned Now count"  "$([ "$(nowcount "$F")" -eq "$base_now" ] && echo 0 || echo 1)"
want  "NEW now in Parked TOC"    "$(grep -qE '^- \[NEW\]\(#new\)' "$F" && echo 0 || echo 1)"

# COMPLETE: delete body + Parked line, add one-liner to ✅ Done.
awk '
  /^- \[NEW\]\(#new\)/ { next }                             # drop Parked line
  /^### \[NEW\]/ { skip=1; next }                           # start skipping body
  skip && /^### / { skip=0 }                                # next body ends the skip
  skip && /^## / { skip=0 }                                 # or next section
  skip { next }
  /^_\(none\)_$/ { print "- [NEW] — shipped in sandbox"; next }
  { print }
' "$F" > "$F.1" && mv "$F.1" "$F"
green "after COMPLETE"           "$F"
want  "NEW body removed"         "$(grep -qE '^### \[NEW\]' "$F" && echo 1 || echo 0)"
want  "NEW in ✅ Done"            "$(grep -qF '[NEW] — shipped' "$F" && echo 0 || echo 1)"

# ── r-start Step 7.5 Done-reset awk (mirrors the skill) ──────────────
R="$TMP/reset.md"
fixture | sed 's/_(none)_/- [OLD] — from last conv/' > "$R"
awk '
  /^## ✅ Done this conv/ { print; print ""; print "_(none yet — cleared at each /r-start)_"; exit }
  { print }
' "$R" > "$R.1" && mv "$R.1" "$R"
want "Done-reset cleared last conv" "$(grep -qF 'from last conv' "$R" && echo 1 || echo 0)"
want "Done-reset wrote placeholder" "$(grep -qF 'cleared at each /r-start' "$R" && echo 0 || echo 1)"

# ── Real-file round-trip: add a temp task to a copy of the LIVE board ─
if [ -f "$LIVE" ]; then
  S="$TMP/live.md"; cp "$LIVE" "$S"
  green "real board (copy) baseline" "$S"
  real_now=$(nowcount "$S")
  awk '
    /^## 🎯 Now/ && !h { print; print ""; print "99. [ZZTEST](#zztest) — sandbox probe"; h=1; next }
    /^## ✅ Done this conv/ && !b { print "### [ZZTEST]"; print ""; print "- **State:** 📋 queued"; print ""; b=1 }
    { print }
  ' "$S" > "$S.1" && mv "$S.1" "$S"
  green "real board + ZZTEST added"  "$S"
  want  "real add raised Now count"  "$([ "$(nowcount "$S")" -eq $((real_now+1)) ] && echo 0 || echo 1)"
else
  echo "  ⏭️  real board not found — skipped real-file round-trip"
fi

echo "-------------------------------------------"
echo "task-board lifecycle test: $pass passed, $fail failed"
[ "$fail" -eq 0 ]

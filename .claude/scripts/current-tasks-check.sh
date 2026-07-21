#!/usr/bin/env bash
# current-tasks-check.sh — validate CURRENT-TASKS.md (the write-through task board).
#
# Checks TOC ↔ body consistency for the four-anchor format (Conv 406 Task-tool detach):
#   ## 🎯 Now      — numbered TOC:  `N. [CODE](#slug) — title`
#   ## ⏸️ Parked   — bulleted TOC:  `- [CODE](#slug) — gate: …`
#   ## Tasks       — bodies:        `### [CODE]`
#   ## ✅ Done this conv
#
# Reports: dangling TOC links (code in a TOC, no body), orphan bodies (body in no TOC),
# duplicate bodies, and section counts. Exit 0 always (advisory); prints a one-line
# summary the r-update-tasks / r-commit / r-end skills surface. Pure read-only.

set -euo pipefail
FILE="${1:-$HOME/projects/peerloop-docs/CURRENT-TASKS.md}"

if [ ! -f "$FILE" ]; then
  echo "MISSING: $FILE"
  exit 0
fi

# Extract bracketed [CODE] from a line (first occurrence).
codes_now=$(awk '
  /^## 🎯 Now/      {s=1; next}
  /^## /            {s=0}
  s && /^[0-9]+\. \[/ { if (match($0, /\[[A-Z0-9][A-Z0-9-]*\]/)) print substr($0, RSTART+1, RLENGTH-2) }
' "$FILE" | sort -u)

codes_parked=$(awk '
  /^## ⏸️ Parked/   {s=1; next}
  /^## /            {s=0}
  s && /^- \[/      { if (match($0, /\[[A-Z0-9][A-Z0-9-]*\]/)) print substr($0, RSTART+1, RLENGTH-2) }
' "$FILE" | sort -u)

codes_body=$(awk '
  /^## Tasks/       {s=1; next}
  /^## /            {s=0}
  s && /^### \[/    { if (match($0, /\[[A-Z0-9][A-Z0-9-]*\]/)) print substr($0, RSTART+1, RLENGTH-2) }
' "$FILE" | sort)

codes_body_uniq=$(echo "$codes_body" | sort -u)
codes_toc=$(printf '%s\n%s\n' "$codes_now" "$codes_parked" | sort -u | sed '/^$/d')

# Dangling: in a TOC but no body.
dangling=$(comm -23 <(echo "$codes_toc") <(echo "$codes_body_uniq") | sed '/^$/d')
# Orphan: has a body but in no TOC.
orphan=$(comm -13 <(echo "$codes_toc") <(echo "$codes_body_uniq") | sed '/^$/d')
# Duplicate bodies.
dup=$(echo "$codes_body" | uniq -d | sed '/^$/d')
# In both TOCs.
both=$(comm -12 <(echo "$codes_now" | sed '/^$/d') <(echo "$codes_parked" | sed '/^$/d') | sed '/^$/d')

n_now=$(echo "$codes_now" | sed '/^$/d' | grep -c . || true)
n_parked=$(echo "$codes_parked" | sed '/^$/d' | grep -c . || true)
n_body=$(echo "$codes_body_uniq" | sed '/^$/d' | grep -c . || true)

problems=0
[ -n "$dangling" ] && problems=$((problems+1))
[ -n "$orphan" ]   && problems=$((problems+1))
[ -n "$dup" ]      && problems=$((problems+1))
[ -n "$both" ]     && problems=$((problems+1))

if [ "$problems" -eq 0 ]; then
  echo "OK: ${n_now} Now, ${n_parked} Parked, ${n_body} bodies — all TOC↔body consistent"
else
  echo "ISSUES: ${n_now} Now, ${n_parked} Parked, ${n_body} bodies"
  [ -n "$dangling" ] && echo "  DANGLING (TOC line, no body): $(echo "$dangling" | tr '\n' ' ')"
  [ -n "$orphan" ]   && echo "  ORPHAN (body, no TOC line):   $(echo "$orphan" | tr '\n' ' ')"
  [ -n "$dup" ]      && echo "  DUPLICATE body:               $(echo "$dup" | tr '\n' ' ')"
  [ -n "$both" ]     && echo "  IN BOTH Now+Parked:           $(echo "$both" | tr '\n' ' ')"
fi
exit 0

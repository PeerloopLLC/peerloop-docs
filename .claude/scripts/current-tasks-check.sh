#!/usr/bin/env bash
# current-tasks-check.sh — validate CURRENT-TASKS.md (the write-through task board).
#
# Format (Conv 406 Task-tool detach):
#   ## 🎯 Now      — numbered TOC:  `N. [CODE](#slug) — title`
#   ## ⏸️ Parked   — bulleted TOC:  `- [CODE](#slug) — gate: …`
#   ## Tasks       — bodies:        `### [CODE]` then a `- **State:** …` bullet
#   ## ✅ Done this conv
#
# Checks (all deterministic, read-only, exit 0 always — advisory summary on stdout):
#   1. DANGLING       — a TOC line whose [CODE] has no ### body
#   2. ORPHAN         — a ### body whose [CODE] is in no TOC (invisible to the resume display)
#   3. DUPLICATE      — the same [CODE] heads two bodies
#   4. IN-BOTH        — a [CODE] listed in both 🎯 Now and ⏸️ Parked
#   5. BAD-SLUG       — a TOC link's #slug != the heading's computed slug (lowercased code) → dead link
#   6. STATE-MISMATCH — a body's State says parked but it's in 🎯 Now, or says active/queued/watch but in ⏸️ Parked
#
# Usage: current-tasks-check.sh [path]   (default: ~/projects/peerloop-docs/CURRENT-TASKS.md)

set -euo pipefail
FILE="${1:-$HOME/projects/peerloop-docs/CURRENT-TASKS.md}"

if [ ! -f "$FILE" ]; then
  echo "MISSING: $FILE"
  exit 0
fi

# One awk pass emits a normalized record stream:
#   NOW  <code> <slug>
#   PARK <code> <slug>
#   BODY <code>
#   STATE <code> <now|parked>
REC=$(awk '
  function code_of(line,   m) { if (match(line, /\[[A-Za-z0-9][A-Za-z0-9-]*\]/)) return substr(line, RSTART+1, RLENGTH-2); return "" }
  function slug_of(line,   s) { if (match(line, /\(#[a-z0-9-]+\)/)) return substr(line, RSTART+2, RLENGTH-3); return "" }
  /^## 🎯 Now/     { sec="now";  next }
  /^## ⏸️ Parked/  { sec="park"; next }
  /^## Tasks/      { sec="body"; next }
  /^## /           { sec="other" }
  sec=="now"  && /^[0-9]+\. \[/ { c=code_of($0); s=slug_of($0); if (c!="") print "NOW " c " " s }
  sec=="park" && /^- \[/        { c=code_of($0); s=slug_of($0); if (c!="") print "PARK " c " " s }
  sec=="body" && /^### \[/      { cur=code_of($0); if (cur!="") print "BODY " cur; statedone=0 }
  sec=="body" && cur!="" && statedone==0 && /\*\*State:\*\*/ {
    cls = (index($0,"parked")>0) ? "parked" : "now"
    print "STATE " cur " " cls; statedone=1
  }
' "$FILE")

now_codes=$(echo "$REC"  | awk '$1=="NOW"  {print $2}' | sort -u)
park_codes=$(echo "$REC" | awk '$1=="PARK" {print $2}' | sort -u)
body_codes=$(echo "$REC" | awk '$1=="BODY" {print $2}')
body_uniq=$(echo "$body_codes" | sort -u | sed '/^$/d')
toc_codes=$(printf '%s\n%s\n' "$now_codes" "$park_codes" | sort -u | sed '/^$/d')

dangling=$(comm -23 <(echo "$toc_codes") <(echo "$body_uniq") | sed '/^$/d')
orphan=$(comm -13 <(echo "$toc_codes") <(echo "$body_uniq") | sed '/^$/d')
dup=$(echo "$body_codes" | sort | uniq -d | sed '/^$/d')
both=$(comm -12 <(echo "$now_codes" | sed '/^$/d') <(echo "$park_codes" | sed '/^$/d') | sed '/^$/d')

# BAD-SLUG: for every TOC record, expected slug = code lowercased (codes are already [A-Z0-9-]).
badslug=$(echo "$REC" | awk '$1=="NOW"||$1=="PARK" {
  code=$2; slug=$3; want=tolower(code);
  if (slug=="" || slug!=want) printf "%s(#%s want #%s) ", code, slug, want
}')

# STATE-MISMATCH: body State class must agree with which TOC holds the code.
mismatch=$(
  echo "$REC" | awk '$1=="STATE"{st[$2]=$3} $1=="NOW"{now[$2]=1} $1=="PARK"{park[$2]=1}
    END{
      for (c in st) {
        if (st[c]=="parked" && now[c]) printf "%s(parked-but-in-Now) ", c
        if (st[c]=="now"    && park[c]) printf "%s(active-but-in-Parked) ", c
      }
    }'
)

n_now=$(echo "$now_codes"  | sed '/^$/d' | grep -c . || true)
n_park=$(echo "$park_codes"| sed '/^$/d' | grep -c . || true)
n_body=$(echo "$body_uniq" | sed '/^$/d' | grep -c . || true)

problems=0
for v in "$dangling" "$orphan" "$dup" "$both" "$badslug" "$mismatch"; do
  [ -n "${v// }" ] && problems=$((problems+1)) || true
done

if [ "$problems" -eq 0 ]; then
  echo "OK: ${n_now} Now, ${n_park} Parked, ${n_body} bodies — TOC↔body, slugs, and State all consistent"
else
  echo "ISSUES: ${n_now} Now, ${n_park} Parked, ${n_body} bodies"
  [ -n "$dangling" ]      && echo "  DANGLING (TOC line, no body): $(echo "$dangling" | tr '\n' ' ')"
  [ -n "$orphan" ]        && echo "  ORPHAN (body, no TOC line):   $(echo "$orphan" | tr '\n' ' ')"
  [ -n "$dup" ]           && echo "  DUPLICATE body:               $(echo "$dup" | tr '\n' ' ')"
  [ -n "$both" ]          && echo "  IN BOTH Now+Parked:           $(echo "$both" | tr '\n' ' ')"
  [ -n "${badslug// }" ]  && echo "  BAD-SLUG (dead TOC link):     ${badslug}"
  [ -n "${mismatch// }" ] && echo "  STATE-MISMATCH (State↔section): ${mismatch}"
fi
exit 0

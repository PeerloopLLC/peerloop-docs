#!/bin/bash
# chat-replay.sh — render ONLY the human-facing conversation from a Claude Code
# session transcript: what you said and what Claude said, nothing else.
#
# Built Conv 395 [CHATSEP]. Read-only — never writes, never touches CC state.
#
# WHY: a CC transcript is ~92% tool traffic by bytes (Conv 395 measurement:
# 7% signal / 44% skill `!` backtick context / 27% tool results / 19% tool calls).
# `verbose: false` collapses tool output live; this gives the same conversation
# back as a clean scrollable document, after the fact.
#
# USAGE (run from a SEPARATE terminal — running it inside the session just adds
# output to the thing you're trying to keep quiet):
#
#   chat-replay.sh                 # whole conversation, this project's newest session
#   chat-replay.sh -n 10           # last 10 exchanges only
#   chat-replay.sh -f              # follow live (tail -f)
#   chat-replay.sh -s <session-id> # a specific session
#   chat-replay.sh -l              # list recent sessions and exit
#   chat-replay.sh | less -R       # scroll it (-R keeps the colours)
#
# WHAT IT KEEPS            WHAT IT DROPS
#   your typed messages      tool_use / tool_result   (the 46% you never read)
#   Claude's prose to you    isMeta records           (skill `!` precomputed ctx)
#                            thinking blocks          (internal)
#                            isSidechain records      (subagent chatter)
#
# The filter is STRUCTURAL — it selects on CC's own record flags, not on text
# heuristics. See SCHEMA GUARD below: the transcript JSONL is an INTERNAL,
# UNDOCUMENTED format, so a CC upgrade can change it. This script fails LOUDLY
# rather than silently printing nothing.

set -uo pipefail

PROJ_DIR="$HOME/.claude/projects/-Users-jamesfraser-projects-peerloop-docs"
SESSION=""; FOLLOW=0; LAST=0; LIST=0

usage() { sed -n '2,30p' "$0" | sed 's/^# \{0,1\}//'; exit 0; }

while [ $# -gt 0 ]; do
  case "$1" in
    -f|--follow)  FOLLOW=1; shift ;;
    -n|--last)    LAST="${2:-10}"; shift 2 ;;
    -s|--session) SESSION="${2:-}"; shift 2 ;;
    -l|--list)    LIST=1; shift ;;
    -h|--help)    usage ;;
    *) echo "unknown option: $1  (try --help)" >&2; exit 2 ;;
  esac
done

[ -d "$PROJ_DIR" ] || { echo "No project transcript dir: $PROJ_DIR" >&2; exit 1; }

if [ "$LIST" = "1" ]; then
  echo "Recent sessions for peerloop-docs (newest first):"
  find "$PROJ_DIR" -maxdepth 1 -name '*.jsonl' -exec stat -f '%m|%Sm|%z|%N' -t '%Y-%m-%d %H:%M' {} \; 2>/dev/null \
    | sort -rn | head -12 \
    | while IFS='|' read -r _ when size path; do
        printf "  %s  %6sKB  %s\n" "$when" "$((size/1024))" "$(basename "$path" .jsonl)"
      done
  exit 0
fi

if [ -n "$SESSION" ]; then
  T="$PROJ_DIR/${SESSION%.jsonl}.jsonl"
  [ -f "$T" ] || { echo "No such session: $T" >&2; exit 1; }
else
  T=$(find "$PROJ_DIR" -maxdepth 1 -name '*.jsonl' -exec stat -f '%m %N' {} \; 2>/dev/null \
        | sort -rn | head -1 | cut -d' ' -f2-)
  [ -n "${T:-}" ] && [ -f "$T" ] || { echo "No session transcript found in $PROJ_DIR" >&2; exit 1; }
fi

# ── the filter ────────────────────────────────────────────────────────────────
# Structural selection on CC's own flags. Two record shapes matter:
#   user   typed message : .type=="user",      .isMeta!=true, .message.content is a STRING
#   claude prose         : .type=="assistant", .isSidechain!=true,
#                          .message.content[] | select(.type=="text") | .text
FILTER='
  def esc: "[";
  def dim:  esc + "2m";   def rst: esc + "0m";
  def cyan: esc + "1;36m"; def green: esc + "1;32m";
  def rule: dim + "──────────────────────────────────────────────────────────" + rst;

  if (.type=="user" and (.isMeta != true) and ((.message.content|type)=="string")) then
    (.message.content
      | if startswith("<command-message>")
        then "/" + ((capture("<command-name>/?(?<c>[^<]*)</command-name>").c) // "slash-command")
        else . end)
      | select((. | gsub("\\s";"") | length) > 0)
      | "\n" + cyan + "▸ YOU" + rst + "\n" + . + "\n" + rule
  elif (.type=="assistant" and (.isSidechain != true)) then
    ([.message.content[]? | select(.type=="text") | .text] | join("\n"))
      | select((. | gsub("\\s";"") | length) > 0)
      | "\n" + green + "▸ CLAUDE" + rst + "\n" + . + "\n" + rule
  else empty end
'

# ── SCHEMA GUARD ──────────────────────────────────────────────────────────────
# The JSONL layout is internal to CC and undocumented; a version bump can silently
# reshape it. If a non-empty transcript yields zero conversation records, that is
# almost certainly schema drift, not an empty chat. Say so instead of printing
# nothing and looking "fine".
if [ "$FOLLOW" != "1" ]; then
  HITS=$(jq -r "$FILTER" "$T" 2>/dev/null | grep -c '▸' || true)
  if [ "${HITS:-0}" -eq 0 ] && [ -s "$T" ]; then
    cat >&2 <<EOF
⚠️  chat-replay: transcript is non-empty ($(wc -c < "$T" | tr -d ' ') bytes) but matched
    ZERO conversation records. The CC transcript JSONL format is internal and
    undocumented — this usually means a CC upgrade changed it.

    Session : $T
    CC ver  : $(claude --version 2>/dev/null || echo unknown)

    Diagnose with:
      jq -r '.type' "$T" | sort | uniq -c
      jq -r 'select(.type=="assistant") | .message.content[]?.type' "$T" | sort | uniq -c
    Then repair the FILTER in this script (see Conv 395 [CHATSEP] / task notes).
EOF
    exit 3
  fi
fi

printf '\033[2m── %s · %s ──\033[0m\n' "$(basename "$T" .jsonl)" "$(basename "$PROJ_DIR")" >&2

if [ "$FOLLOW" = "1" ]; then
  # Show recent context FIRST, then follow live — opening to a blank pane and
  # waiting for the next message is useless. -n controls the backfill depth.
  BACKFILL="${LAST:-0}"; [ "$BACKFILL" = "0" ] && BACKFILL=6
  jq -r "$FILTER" "$T" 2>/dev/null | awk -v n="$BACKFILL" '
    { buf[NR]=$0; if ($0 ~ /^\033\[1;3[26]m▸ (YOU|CLAUDE)\033\[0m$/) marks[++m]=NR }
    END { start = (m > n) ? marks[m-n+1] : 1; for (i=start; i<=NR; i++) print buf[i] }'
  printf '\033[2m── following live · Ctrl-C to stop ──\033[0m\n'
  tail -n 0 -f "$T" | jq -r --unbuffered "$FILTER" 2>/dev/null
elif [ "$LAST" != "0" ]; then
  # Keep the last N exchanges. Anchor on the REAL header line — a line that starts
  # with the colour escape + marker — not a bare '▸'. Prose that merely mentions
  # "▸ YOU" / "▸ CLAUDE" (e.g. this script's own docs) must not count as a header.
  jq -r "$FILTER" "$T" 2>/dev/null | awk -v n="$LAST" '
    { buf[NR]=$0; if ($0 ~ /^\033\[1;3[26]m▸ (YOU|CLAUDE)\033\[0m$/) marks[++m]=NR }
    END { start = (m > n) ? marks[m-n+1] : 1; for (i=start; i<=NR; i++) print buf[i] }'
else
  jq -r "$FILTER" "$T" 2>/dev/null
fi

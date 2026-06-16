#!/usr/bin/env bash
# Concurrent-session lock for /r-start (Peerloop Conv 293).
#
# Prevents a second terminal's r-start from trampling an already-active
# session (the failure that cost ~30 min to untangle: two concurrent
# sessions both incrementing CONV-COUNTER, pushing, and memory-syncing).
#
# The lock is MACHINE-LOCAL (lives under ~/.claude/projects/<slug>/, NOT in
# the git repo) because PIDs are only meaningful on one machine, the two
# Minis are intentionally isolated, and a committed lock would create git
# noise/conflicts.
#
# Ownership/liveness model — r-start blocks ONLY when the lock's PID is a
# DIFFERENT, still-alive `claude` process from this session's own. That makes
# it self-healing:
#   - second terminal, first still open     -> different live claude  -> ACTIVE (block)
#   - same terminal, r-end -> /clear -> r-start -> same sid/pid        -> CLEAR (own)
#   - prior session crashed without r-end   -> pid dead / not claude   -> STALE (reclaimable)
#
# Subcommands:
#   check            read-only verdict for the !`...` pre-computed context.
#                    Prints exactly one of:
#                      CLEAR[|reason] | ACTIVE|sid=..|pid=..|conv=..|machine=..|started=..
#                                     | STALE|sid=..|pid=..|conv=..|machine=..|started=..
#                    Never writes.
#   acquire [conv]   write/refresh this session's lock. Prints ACQUIRED|...
#   release          remove the lock IFF it belongs to this session. Prints
#                    RELEASED | SKIPPED|not-owner | NOLOCK
set -u

SLUG=$(echo "$HOME/projects/peerloop-docs" | tr / -)
LOCK="$HOME/.claude/projects/$SLUG/active-session.lock"

# Walk up the process tree from this script until a `claude` process is found.
my_claude_pid() {
  local p="${PPID:-}" comm
  while [ -n "$p" ] && [ "$p" -gt 1 ] 2>/dev/null; do
    comm=$(ps -o comm= -p "$p" 2>/dev/null)
    case "$comm" in
      *claude*) echo "$p"; return 0 ;;
    esac
    p=$(ps -o ppid= -p "$p" 2>/dev/null | tr -d ' ')
  done
  return 1
}

field() { sed -n "s/^$1=//p" "$LOCK" 2>/dev/null | head -1; }

cmd_check() {
  [ -f "$LOCK" ] || { echo "CLEAR"; return 0; }
  local lsid lpid lconv lmachine lstarted mine lcomm
  lsid=$(field session_id); lpid=$(field pid); lconv=$(field conv)
  lmachine=$(field machine); lstarted=$(field started)
  # Our own session?
  if [ -n "${CLAUDE_CODE_SESSION_ID:-}" ] && [ "$lsid" = "${CLAUDE_CODE_SESSION_ID:-}" ]; then
    echo "CLEAR|own-session"; return 0
  fi
  # Our own claude process (e.g. new session id after /clear, same terminal)?
  mine=$(my_claude_pid || true)
  if [ -n "$mine" ] && [ "$lpid" = "$mine" ]; then
    echo "CLEAR|own-process"; return 0
  fi
  # A different session — is its pid still a live claude process?
  if [ -n "$lpid" ] && kill -0 "$lpid" 2>/dev/null; then
    lcomm=$(ps -o comm= -p "$lpid" 2>/dev/null)
    case "$lcomm" in
      *claude*) echo "ACTIVE|sid=$lsid|pid=$lpid|conv=$lconv|machine=$lmachine|started=$lstarted"; return 0 ;;
    esac
  fi
  echo "STALE|sid=$lsid|pid=$lpid|conv=$lconv|machine=$lmachine|started=$lstarted"
}

cmd_acquire() {
  local conv="${1:-unknown}" machine pid started dir
  machine=$(cat "$HOME/.claude/.machine-name" 2>/dev/null || echo unknown)
  pid=$(my_claude_pid || echo "")
  started=$(date +%Y-%m-%dT%H:%M:%S%z)
  dir=$(dirname "$LOCK"); mkdir -p "$dir"
  cat > "$LOCK" <<EOF
session_id=${CLAUDE_CODE_SESSION_ID:-unknown}
pid=$pid
conv=$conv
machine=$machine
started=$started
EOF
  echo "ACQUIRED|sid=${CLAUDE_CODE_SESSION_ID:-unknown}|pid=$pid|conv=$conv|machine=$machine|started=$started"
}

cmd_release() {
  [ -f "$LOCK" ] || { echo "NOLOCK"; return 0; }
  local lsid lpid mine
  lsid=$(field session_id); lpid=$(field pid); mine=$(my_claude_pid || true)
  if { [ -n "${CLAUDE_CODE_SESSION_ID:-}" ] && [ "$lsid" = "${CLAUDE_CODE_SESSION_ID:-}" ]; } \
     || { [ -n "$mine" ] && [ "$lpid" = "$mine" ]; }; then
    rm -f "$LOCK"; echo "RELEASED"
  else
    echo "SKIPPED|not-owner"
  fi
}

case "${1:-}" in
  check)   cmd_check ;;
  acquire) shift; cmd_acquire "${1:-unknown}" ;;
  release) cmd_release ;;
  *) echo "usage: conv-session-lock.sh <check|acquire|release> [conv]" >&2; exit 2 ;;
esac

#!/bin/bash
# conv-branch-guard.sh — [CBG], Conv 395. COMMIT-TIME code-branch drift guard.
# Consumed by /r-commit and /r-end (pre-computed `!` backtick context).
#
# ── Why this exists, and why it is NOT conv-branch-check.sh ───────────────────
# `conv-branch-check.sh` ([RSTART-DIFFGATE], Conv 297) guards /r-START: it compares
# the code branch against the branch recorded in the PREVIOUS conv's RESUME-STATE.md.
# It cannot be reused at commit time: it answers the WRONG QUESTION. RESUME-STATE
# describes the PREVIOUS conv — and since Conv 457 it PERSISTS mid-conv (no longer
# deleted at /r-start Step 7.6), so wiring conv-branch-check.sh into /r-commit would
# silently compare the live branch against LAST conv's recorded branch, not this
# one's. The Conv 371 failure was a branch swapped MID-CONV by an external checkout
# (client's `brian-July-7`), committed to before anyone noticed; no comparison
# against last conv's branch can catch that.
# (Pre-Conv-457 there was a second reason — RESUME-STATE didn't exist mid-conv, so
# the script just returned NO-RESUME-STATE — now obsolete since the file persists.)
#
# This guard instead compares live HEAD against `.conv-branch` — the branch /r-start
# Step 5.6 ALREADY VALIDATED this conv and now records (ephemeral, gitignored,
# conv-scoped sibling of `.conv-current`; written at /r-start, removed at /r-end
# Step 8). That is the branch the conv's work belongs on.
#
# Bug class being killed: PRINTED-BUT-NOT-VERIFIED. /r-end already *prints* the code
# branch and never checks it; that is how Conv 371 slipped by. Hence the verdicts
# below are consumed by a HALT, not a log line.
#
# ── Verdicts (exactly one line on stdout) ────────────────────────────────────
#   MATCH (<branch>)                        — live == recorded. Proceed.
#   NO-CONV-BRANCH (live: <branch>)         — no .conv-branch (pre-[CBG] conv, or
#                                             /r-start predates this). Advisory only.
#   DETACHED (want=<recorded>)              — detached HEAD.
#   MISMATCH live=<L> want=<W> ahead=<A> behind=<B> dirty=<yes|no>
#                                           — HALT and ask. <A>/<B> are live vs want.
#
# Exit codes: 0 = MATCH / NO-CONV-BRANCH (nothing to decide) · 1 = MISMATCH or
# DETACHED (caller must HALT). Skills branch on the verdict text; the exit code is
# for non-skill callers (hooks/CI).
#
# Test overrides (NEVER set in normal use):
#   CONV_BRANCH_GUARD_LIVE   — pretend the code repo is on this branch
#   CONV_BRANCH_GUARD_FILE   — path to a .conv-branch fixture
#   CONV_BRANCH_GUARD_CODE   — path to the code repo

DOCS="${CLAUDE_PROJECT_DIR:-$HOME/projects/peerloop-docs}"
CODE="${CONV_BRANCH_GUARD_CODE:-$DOCS/../Peerloop}"
BRANCH_FILE="${CONV_BRANCH_GUARD_FILE:-$DOCS/.conv-branch}"
# NOTE the `-` (not `:-`): an explicitly-set EMPTY override must be honoured, since
# empty is exactly how git reports a detached HEAD. With `:-`, an empty override
# would fall through to real git and the DETACHED path would be untestable.
LIVE="${CONV_BRANCH_GUARD_LIVE-$(git -C "$CODE" branch --show-current 2>/dev/null)}"

# No recorded branch → pre-[CBG] conv, or /r-start ran before this existed.
# Advisory only: never block a commit over missing bookkeeping.
if [ ! -f "$BRANCH_FILE" ]; then
  echo "NO-CONV-BRANCH (live: ${LIVE:-unknown})"
  exit 0
fi

WANT=$(tr -d '[:space:]' < "$BRANCH_FILE" 2>/dev/null)
if [ -z "$WANT" ]; then
  echo "NO-CONV-BRANCH (live: ${LIVE:-unknown})"
  exit 0
fi

if [ -z "$LIVE" ]; then
  echo "DETACHED (want=$WANT)"
  exit 1
fi

if [ "$LIVE" = "$WANT" ]; then
  echo "MATCH ($LIVE)"
  exit 0
fi

# Mismatch — quantify the gap so the user can decide with real numbers rather
# than a bare "branches differ". ahead/behind are live relative to want; "?" when
# want is unresolvable (branch deleted/renamed since /r-start).
if git -C "$CODE" rev-parse --verify --quiet "refs/heads/$WANT" >/dev/null 2>&1; then
  AHEAD=$(git -C "$CODE" rev-list --count "$WANT".."$LIVE" 2>/dev/null || echo "?")
  BEHIND=$(git -C "$CODE" rev-list --count "$LIVE".."$WANT" 2>/dev/null || echo "?")
else
  AHEAD="?"; BEHIND="?"
fi
[ -n "$(git -C "$CODE" status --short 2>/dev/null | head -1)" ] && DIRTY=yes || DIRTY=no

echo "MISMATCH live=$LIVE want=$WANT ahead=$AHEAD behind=$BEHIND dirty=$DIRTY"
exit 1

#!/bin/bash
# conv-branch-check.sh — used by /r-start (Step 5.6, the [RSTART-DIFFGATE] gate).
#
# Verifies the code repo's checked-out branch matches the branch RESUME-STATE.md
# recorded as the working branch of the previous conv. Catches the cross-machine
# stale-checkout hazard: Conv 297 found MacMiniM4 sitting on `jfg-dev-13-matt`
# (Conv 291 tip) while all of Conv 292/295/296's work — including the PALETTE-FDN
# colour foundation that unblocked RG-COURSES — lived on `jfg-dev-14`. The branch
# name was printed by the SessionStart hook but nothing cross-checked it against
# RESUME-STATE, so the mismatch was invisible until a token lookup failed.
#
# Emits ONE deterministic verdict line (consumed by the skill step):
#   MATCH (<branch>)
#   DETACHED (live HEAD is detached; want=<W>)
#   NO-RESUME-STATE (live: <branch>)
#   NO-BRANCH-LINE (live: <branch>)
#   MISMATCH-NOREF live=<L> want=<W>     # expected branch absent locally AND on origin
#   MISMATCH live=<L> want=<W> ref=<R> ahead=<A> behind=<B> SAFE
#   MISMATCH live=<L> want=<W> ref=<R> ahead=<A> behind=<B> UNSAFE-DIRTY
#   MISMATCH live=<L> want=<W> ref=<R> ahead=<A> behind=<B> UNSAFE-AHEAD(<A>)
#
# SAFE  = clean tree AND live is 0 commits ahead of the target (every local commit
#         is already contained in the target) → `git checkout <want>` loses nothing.
# UNSAFE-DIRTY / UNSAFE-AHEAD = a checkout could lose uncommitted work or orphan
#         commits unique to the current branch → warn only, let the user resolve.
#
# Calibration/test overrides (NEVER set in normal use):
#   CONV_BRANCH_CHECK_RS    — path to a RESUME-STATE fixture
#   CONV_BRANCH_CHECK_LIVE  — pretend the code repo is on this branch
#   CONV_BRANCH_CHECK_CODE  — path to the code repo

DOCS="${CLAUDE_PROJECT_DIR:-$HOME/projects/peerloop-docs}"
CODE="${CONV_BRANCH_CHECK_CODE:-$DOCS/../Peerloop}"
RS="${CONV_BRANCH_CHECK_RS:-$DOCS/RESUME-STATE.md}"
LIVE="${CONV_BRANCH_CHECK_LIVE:-$(git -C "$CODE" branch --show-current 2>/dev/null)}"

# No prior state → nothing to compare against.
if [ ! -f "$RS" ]; then
  echo "NO-RESUME-STATE (live: ${LIVE:-unknown})"
  exit 0
fi

# Extract the recorded code branch from a "**Branch:** code: `X`, docs: `Y`" line
# (tolerates missing backticks: "code: X").
BRANCH_LINE=$(grep -iE 'branch:' "$RS" | head -1)
WANT=$(printf '%s\n' "$BRANCH_LINE" | sed -nE 's/.*code:[[:space:]]*`?([A-Za-z0-9._/-]+)`?.*/\1/p')
if [ -z "$WANT" ]; then
  echo "NO-BRANCH-LINE (live: ${LIVE:-unknown})"
  exit 0
fi

# Detached HEAD → no branch name to match.
if [ -z "$LIVE" ]; then
  echo "DETACHED (live HEAD is detached; want=$WANT)"
  exit 0
fi

if [ "$LIVE" = "$WANT" ]; then
  echo "MATCH ($LIVE)"
  exit 0
fi

# Mismatch — resolve the target to a concrete ref (prefer a local branch, else origin).
if git -C "$CODE" rev-parse --verify --quiet "refs/heads/$WANT" >/dev/null 2>&1; then
  WREF="$WANT"
elif git -C "$CODE" rev-parse --verify --quiet "refs/remotes/origin/$WANT" >/dev/null 2>&1; then
  WREF="origin/$WANT"
else
  echo "MISMATCH-NOREF live=$LIVE want=$WANT"
  exit 0
fi

# Classify checkout safety.
DIRTY=$(git -C "$CODE" status --short 2>/dev/null | head -1)
AHEAD=$(git -C "$CODE" rev-list --count "$WREF".."$LIVE" 2>/dev/null || echo "?")
BEHIND=$(git -C "$CODE" rev-list --count "$LIVE".."$WREF" 2>/dev/null || echo "?")

if [ -n "$DIRTY" ]; then
  SAFE="UNSAFE-DIRTY"
elif [ "$AHEAD" = "0" ]; then
  SAFE="SAFE"
else
  SAFE="UNSAFE-AHEAD($AHEAD)"
fi

echo "MISMATCH live=$LIVE want=$WANT ref=$WREF ahead=$AHEAD behind=$BEHIND $SAFE"

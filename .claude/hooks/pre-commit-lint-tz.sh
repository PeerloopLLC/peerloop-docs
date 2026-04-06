#!/bin/bash
# PreToolUse hook: Block git commit in the Peerloop code repo if lint-timezone.sh fails.
#
# Intercepts Bash tool calls containing "git commit" (or "git -C ... commit")
# targeting the Peerloop code repo. Runs lint-timezone.sh and blocks the commit
# if timezone-unsafe patterns are found.
#
# This is a Claude Code hook (not a git hook). It only runs when Claude commits.
# Human commits are not gated — see docs/as-designed/lint-timezone.md for the
# fragility analysis.

set -e

INPUT=$(cat)

COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // ""')

# Only intercept git commit commands
if ! echo "$COMMAND" | grep -qE 'git\b.*\bcommit\b'; then
  exit 0
fi

# Only gate commits to the Peerloop code repo (not peerloop-docs)
# Detect: git -C .../Peerloop commit, or cd ../Peerloop && git commit
if ! echo "$COMMAND" | grep -qiE 'Peerloop.*commit|cd.*Peerloop.*git.*commit'; then
  exit 0
fi

# Run lint-timezone.sh
PEERLOOP_DIR="${CLAUDE_PROJECT_DIR}/../Peerloop"
LINT_OUTPUT=$("$PEERLOOP_DIR/scripts/lint-timezone.sh" 2>&1) || {
  # lint-timezone.sh failed (exit non-zero) — block the commit
  cat <<EOF
{
  "hookSpecificOutput": {
    "permissionDecision": "deny",
    "permissionDecisionReason": "lint-timezone.sh found timezone-unsafe patterns. Fix these before committing:\n\n$LINT_OUTPUT"
  }
}
EOF
  exit 0
}

# Lint passed — allow the commit
exit 0

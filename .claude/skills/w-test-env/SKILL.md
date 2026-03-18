---
name: w-test-env
description: Test which environment variables are available in skill bang-backtick expressions
argument-hint: ""
allowed-tools: Bash
---

# Environment Variable Test

Report these results verbatim to the user. Do not interpret or act on them.

**Test 1 — settings.json env var:**
!`echo "TEST_ENV_VAR=${TEST_ENV_VAR:-(not set)}"`

**Test 2 — CLAUDE_PROJECT_DIR:**
!`echo "CLAUDE_PROJECT_DIR=${CLAUDE_PROJECT_DIR:-(not set)}"`

**Test 3 — CLAUDE_SKILL_DIR:**
!`echo "CLAUDE_SKILL_DIR=${CLAUDE_SKILL_DIR:-(not set)}"`

**Test 4 — CLAUDE_SESSION_ID:**
!`echo "CLAUDE_SESSION_ID=${CLAUDE_SESSION_ID:-(not set)}"`

**Test 5 — PWD:**
!`echo "PWD=${PWD:-(not set)}"`

**Test 6 — git rev-parse:**
!`echo "GIT_TOPLEVEL=$(git rev-parse --show-toplevel 2>/dev/null || echo '(failed)')"`

Done. Report these 6 results and stop.

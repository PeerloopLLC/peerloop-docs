#!/bin/bash
# PostToolUse hook: Remind to TodoWrite any issues from Bash commands
#
# Two layers:
# 1. SPECIFIC: Check commands (test, lint, tsc, astro, tailwind) get detailed
#    output parsing to extract error/warning/hint counts
# 2. GENERAL: Any other Bash command with non-zero exit code gets a generic
#    failure reminder
#
# Reads tool_input.command and tool_response from stdin JSON.

set -e

INPUT=$(cat)

COMMAND=$(echo "$INPUT" | jq -r '.tool_input.command // ""')
EXIT_CODE=$(echo "$INPUT" | jq -r '.tool_response.exit_code // 0')

# ─── Layer 1: Specific check commands (detailed parsing) ────────────────

CHECK_TYPE=""
case "$COMMAND" in
  *"npm test"*|*"npm run test"*|*"npx vitest"*) CHECK_TYPE="test" ;;
  *"npm run lint"*|*"npx eslint"*) CHECK_TYPE="lint" ;;
  *"npm run typecheck"*|*"tsc --noEmit"*|*"npx tsc"*) CHECK_TYPE="typecheck" ;;
  *"astro check"*) CHECK_TYPE="astro" ;;
  *"check:tailwind"*) CHECK_TYPE="tailwind" ;;
esac

if [ -n "$CHECK_TYPE" ]; then
  STDOUT=$(echo "$INPUT" | jq -r '.tool_response.stdout // ""')
  HAS_ISSUES=false
  ISSUE_SUMMARY=""

  case "$CHECK_TYPE" in
    test)
      FAIL_COUNT=$(echo "$STDOUT" | grep -oE '[0-9]+ failed' | head -1 || true)
      if [ -n "$FAIL_COUNT" ] || [ "$EXIT_CODE" != "0" ]; then
        HAS_ISSUES=true
        ISSUE_SUMMARY="Test failures detected${FAIL_COUNT:+ ($FAIL_COUNT)}"
      fi
      ;;
    lint)
      if echo "$STDOUT" | grep -qE '[0-9]+ error|[0-9]+ warning' 2>/dev/null || [ "$EXIT_CODE" != "0" ]; then
        HAS_ISSUES=true
        ERROR_COUNT=$(echo "$STDOUT" | grep -oE '[0-9]+ error' | head -1 || true)
        WARN_COUNT=$(echo "$STDOUT" | grep -oE '[0-9]+ warning' | head -1 || true)
        ISSUE_SUMMARY="ESLint issues: ${ERROR_COUNT:-0 errors} ${WARN_COUNT:-0 warnings}"
      fi
      ;;
    typecheck)
      if [ "$EXIT_CODE" != "0" ]; then
        HAS_ISSUES=true
        TS_ERRORS=$(echo "$STDOUT" | grep -c "error TS" 2>/dev/null || echo "0")
        ISSUE_SUMMARY="TypeScript errors ($TS_ERRORS)"
      fi
      ;;
    astro)
      ERRORS=$(echo "$STDOUT" | grep -oE '[0-9]+ errors?' | head -1 || true)
      WARNINGS=$(echo "$STDOUT" | grep -oE '[0-9]+ warnings?' | head -1 || true)
      HINTS=$(echo "$STDOUT" | grep -oE '[0-9]+ hints?' | head -1 || true)
      if echo "$ERRORS" | grep -qE '[1-9]' 2>/dev/null; then
        HAS_ISSUES=true
        ISSUE_SUMMARY="Astro: $ERRORS"
      fi
      if echo "$WARNINGS" | grep -qE '[1-9]' 2>/dev/null; then
        HAS_ISSUES=true
        ISSUE_SUMMARY="${ISSUE_SUMMARY:+$ISSUE_SUMMARY, }Astro: $WARNINGS"
      fi
      if echo "$HINTS" | grep -qE '[1-9]' 2>/dev/null; then
        HAS_ISSUES=true
        ISSUE_SUMMARY="${ISSUE_SUMMARY:+$ISSUE_SUMMARY, }Astro: $HINTS"
      fi
      ;;
    tailwind)
      if [ "$EXIT_CODE" != "0" ]; then
        HAS_ISSUES=true
        ISSUE_SUMMARY="Tailwind v4 compatibility issues found"
      fi
      ;;
  esac

  if [ "$HAS_ISSUES" = true ]; then
    echo "⚠️ CHECK OUTPUT HAS ISSUES: $ISSUE_SUMMARY — TodoWrite these NOW before continuing. Do not dismiss as pre-existing."
  fi
  exit 0
fi

# ─── Layer 2: General failure catch-all ──────────────────────────────────

if [ "$EXIT_CODE" != "0" ]; then
  # Extract just the command name for a concise message (first token or up to first pipe)
  CMD_SHORT=$(echo "$COMMAND" | sed 's/ |.*//; s/ 2>&1.*//' | head -c 80)
  echo "⚠️ COMMAND FAILED (exit $EXIT_CODE): $CMD_SHORT — Diagnose the failure. If it reveals an issue, TodoWrite it."
fi

exit 0

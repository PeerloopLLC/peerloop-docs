---
name: Skill portability verified
description: Skills using $CLAUDE_PROJECT_DIR work on both dev machines — tested Conv 005 on MacMiniM4
type: project
---

Skill bang-backtick expressions using `$CLAUDE_PROJECT_DIR` resolve correctly at runtime on MacMiniM4 (verified 2026-03-17, Conv 005 via `/w-test-env`).

**Why:** Skills previously used hardcoded paths which would break across machines. The Conv alignment work (Conv 004) switched to `$CLAUDE_PROJECT_DIR` for portability.

**How to apply:** All `r-*` and `w-*` skills should use `$CLAUDE_PROJECT_DIR` (not hardcoded paths) for cross-machine compatibility. The two unavailable env vars (`CLAUDE_SKILL_DIR`, `CLAUDE_SESSION_ID`) are not used by any current skills — no impact.

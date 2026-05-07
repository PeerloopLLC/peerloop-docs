---
name: Always TodoWrite codecheck findings
description: Never dismiss codecheck issues as "pre-existing" — always create TodoWrite tasks for any failures/warnings/hints found
type: feedback
---

When running `/w-codecheck`, `npx tsc --noEmit`, `npm run lint`, `npx astro check`, or a full test suite and issues are found, ALWAYS create TodoWrite tasks for them — even if they appear pre-existing or unrelated to the current session's work.

**Why:** Dismissing issues as "pre-existing" or "not related to our changes" means they never get tracked and accumulate. The user had to manually prompt fixing 3 Astro hints that were labeled "pre-existing deprecation notices" when they should have been TodoWrite'd immediately. The whole point of running checks is to surface issues for action.

**How to apply:**
- Any TypeScript error, ESLint warning, Astro hint, or test failure → TodoWrite immediately
- Never use language like "pre-existing", "not related to our changes", or "not from this session" to justify skipping a TodoWrite
- If in fix mode, fix them; if in default mode, TodoWrite them
- This applies to full test suite runs too — if tests fail, TodoWrite them even if they were already failing

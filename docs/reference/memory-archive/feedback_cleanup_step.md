---
name: Always include a cleanup step
description: Every PLAN block and multi-step task should end with an explicit cleanup phase
type: feedback
---

Every PLAN block and multi-step endeavour should include a **Cleanup** phase as the final step — run after the work is verified (tests pass, codecheck clean).

**Why:** Cleanup is easiest immediately after the work while context is fresh. Deferred cleanup creates ambiguity in future convs (e.g., unchecked RFC items, stale CURRENT-BLOCK-PLAN.md, leftover TODO markers).

**How to apply:**
- Add a Cleanup section to every PLAN block (after Tests/Docs)
- Include: check off RFC items, reset CURRENT-BLOCK-PLAN.md, remove any temporary scaffolding, verify no stale references
- Run cleanup right after verification passes, not as a separate future task

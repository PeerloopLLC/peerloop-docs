---
name: Exploration pacing after pattern establishment
description: After Phase 1 establishes codebase patterns, write code immediately in subsequent phases — don't re-explore
type: feedback
---

After the first phase of a multi-phase implementation establishes codebase patterns (file structure, API patterns, test patterns, component patterns), subsequent phases should write code immediately rather than re-exploring the same patterns.

**Why:** User flagged Conv 057 Phase 2 — spent over an hour exploring before writing AdminCourseTab, when all patterns were already understood from Phase 1. After the nudge, Phases 2-4 completed much faster.

**How to apply:** When starting Phase N+1 of a multi-phase block, check if Phase N already explored the relevant patterns. If yes, jump straight to writing code. Only explore new patterns (e.g., a new file type or component not seen in Phase 1).

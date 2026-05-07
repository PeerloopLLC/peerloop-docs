---
name: feedback_post_rend_fixes
description: Post /r-end fixes use /r-start (no /clear) to open a new conv with full context — no special skills needed
type: feedback
---

When the user spots something to fix after /r-end completes, the pattern is: `/r-start` (without `/clear` first) → fix the issue → `/r-end`. No gates, no topup skills, no changes to /r-end.

**Why:** Each fix gets its own conv number with proper session docs. Full conversation context is preserved (no /clear). No backfilling, no awkward mid-skill pauses. The "cost" of an extra conv number is actually better for traceability.

**How to apply:** Never propose adding commit gates or topup skills to /r-end. If the user needs to fix something post-/r-end, they already know the pattern. Don't suggest /clear between convs unless the user asks for it.

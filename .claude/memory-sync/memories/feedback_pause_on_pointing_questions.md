---
name: Pause fully after 👉👉👉 questions
description: When asking the user a 👉👉👉 question, stop and wait — do not continue with other independent work in the same turn
type: feedback
originSessionId: bdeac370-2c10-402b-8c7d-e8016cfa5eb5
---
When asking the user a 👉👉👉 question, **the question must be the last visible content in the turn**. No prose below it. However, clearly independent work (work whose outcome is not affected by any reasonable answer to the question) may be completed first — complete it, then ask the question last.

**Why:** The pointing-emoji convention prevents questions from getting buried in long output. Work done *after* a question creates awkward state if the user's answer is "skip" or "no." Work done *before* a question is fine — it's already committed and doesn't depend on the answer.

**How to apply:**
- Sequence: do independent work → ask question last → stop.
- Do NOT do work that depends on the answer after posting a 👉👉👉 question.
- If multiple questions exist, batch them into one block and stop — don't stream across multiple turns interleaved with work.
- The rule from Conv 125 `/r-start`: Steps 7-8 of /r-start (TodoWrite transfer + resume context) were independent of the npm-install question but came after it — the fix is to do those steps first, then ask.
- If uncertain whether work is truly independent, treat it as dependent and stop.

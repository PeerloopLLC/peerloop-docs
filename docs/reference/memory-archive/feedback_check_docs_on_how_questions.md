---
name: Check docs on "how does X work" questions
description: When user asks how a part of the system works, check likely doc files alongside code; offer to update docs if the answer required significant searching
type: feedback
originSessionId: 1ce77693-dd06-43b6-a431-e32c4018db19
---
When the user asks how a part of the system works, check likely doc files for the answer as well as the normal code-search process. If the answer required a lot of searching, ask whether we should update the appropriate docs with the answer.

**Why:** A "how does X work" question signals the user is unclear about an aspect of the system — which makes it a prime candidate for a doc gap. If Claude had to dig hard to answer, a future reader (or future Claude) will too.

**How to apply:** On any "how does X work / where is X / what happens when X" question:
1. Search likely doc locations (`docs/reference/`, `docs/as-designed/`, `docs/POLICIES.md`, `CLAUDE.md`, RFCs) in addition to code.
2. Answer the question.
3. If the answer required substantial searching (multiple files, cross-referencing, code-tracing), ask the user whether to update the appropriate doc(s) with the answer.

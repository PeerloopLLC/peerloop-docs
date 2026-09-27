---
name: /r-end must complete ALL steps after /r-eos — RECURRING FAILURE
description: After /r-eos completes within /r-end, IMMEDIATELY continue with Steps 3-8 (save state, commit, push, cleanup, summary) — NEVER stop after /r-eos
type: feedback
originSessionId: ff0c04a6-29c3-4424-abbe-fac8b0bddf83
---
**RECURRING FAILURE (Conv 006, 019, 026, 027 — at least four times).** When `/r-end` invokes `/r-eos`, the /r-eos sub-skill displays its own "End-of-Conv Complete" 4-checkbox summary. This summary LOOKS like a natural endpoint but it is NOT — /r-eos is only Step 2 of /r-end's 8-step workflow. **The /r-eos summary output is NOT a conversation turn boundary.**

After `/r-eos` returns, IMMEDIATELY proceed — in the same response — through:
3. Check TaskList → save state if needed
4. Invoke `/r-commit`
5. (step 5 was removed)
6. Push both repos
7. Delete `.conv-current`
8. Display closing summary with "Safe to exit."

**Why:** Four times now, Claude has stopped after /r-eos's summary as if the work was done. The user had to explicitly tell Claude to continue. This breaks the "single command to close" contract.

**How to apply:** The /r-eos summary is a SUB-SKILL reporting completion, not /r-end's final output. The real stopping point is Step 8's "Safe to exit." — nothing else. Treat /r-eos completion the same way you'd treat any intermediate tool result: consume it and keep going.

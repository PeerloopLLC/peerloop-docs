---
name: Option-question format (A) B) C) labels) — pointer to CLAUDE.md
description: "NEVER ask 'X or Y?' as the primary question; ALWAYS A) B) labels above the 👉. Recurring failure (at least once per conv per user, through Conv 208). Primary rule lives in CLAUDE.md §User-Facing Questions; this file preserves incident archaeology + the visceral anti-pattern as a memory-grep anchor."
type: feedback
originSessionId: 08988022-6234-4a56-949f-dba1be6eec54
---

## The rule (anti-pattern verbatim)

**NEVER** write the primary user-facing question as a compound `"X, or Y?"` sentence — readers parse that shape as yes/no and answer `"yes"` meaning the first option.

**ALWAYS** put labeled options above the 👉:

```
A) Run /w-codecheck now
B) Batch with later work

👉👉👉 **A or B?**
```

The `**A or B?**` inside the bold-pointing line is fine — what's banned is `"Run /w-codecheck now, or batch with later work?"` as the question itself. The trigger is *does my question, read on its own, look like yes/no?* — if yes, refactor to labeled blocks.

Applies to: any non-yes/no choice, including binary A/B picks. Including codecheck-vs-batch. Including approach picks. Including "now vs later." Every time.

## Why this keeps recurring

The rule is in CLAUDE.md §User-Facing Questions (always loaded) AND indexed in MEMORY.md (also always loaded). It still happens at least once per conv. Conv 208 example: "Run /w-codecheck now to validate the profile retrofit, or batch with later work?" — exact anti-pattern shape. The miss is in-the-moment, not directive-knowledge. Treat this file as a self-check trigger when drafting any non-yes/no question.

## Motivating incidents (preserved for archaeology)

- **Conv 132** — Original incident. Asked *"Want to review the strategy doc before I proceed to Phase 2, or would you rather handle the retirement decisions first?"* User replied "yes" — ambiguous. User correction: *"These long sentences with 'or' far inside look like Yes/no."*
- **Conv 147** — Recurrence; prescription strengthened. Asked *"Continue with [LE-TRIAGE], save for its own conv, or stop here?"* User replied "yes" meaning option 1. User correction: *"You keep asking me compound OR-type questions whose first option I want and so I say yes. In the future, when you are asking a question which cannot be answered with Yes or No, use the A) B) C) format so at a glance I can see you have an non Yes/No question."*
- **Conv 208** — Recurrence + user-mandated weight boost. Asked *"Run /w-codecheck now to validate the profile retrofit, or batch with later work?"* User: *"I really, really wish your MEMORY.md and/or CLAUDE.md would give this more importance. It happens at least once a COnv."* → led to this file's rewrite + a new CLAUDE.md §Recurring Failures section at the top.

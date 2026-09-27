---
name: decisions-go-through-askuserquestion-replaced-inline-a-b-rule-qlint
description: "Route every user-facing decision — option picks AND yes/no — through the AskUserQuestion tool: reasoning in prose above, picker below; the user SELECTS, not types. Conv 273 replaced the inline A)/B)/C)-label rule AND retired the QLINT Stop-hook with this structural approach. This file keeps the incident archaeology + rationale."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: d04cb083-7564-4b2c-87e6-9bc511e4e9eb
---

## The rule (current — Conv 273)

**Route every user-facing decision through the `AskUserQuestion` tool** — both option picks (≥2 discrete choices) and yes/no. Put the reasoning, tradeoffs, and recommendation in **prose above** the tool call; the tool renders the choices as a selectable picker (labels 1–5 words; terse required descriptions). The user **selects rather than types**.

**Why:** the malformed-question failures that recurred ~once per conv for ~10 convs — compound `"X, or Y?"` read as yes/no, untypeable symbol labels (`α/β`, `①②③`), misspelled yes/no — are all *typing* failures. Move the answer from typing to selecting and they cannot occur (structural prevention, not a reminder).

**How to apply:** decision needed → write the full case in prose, then call `AskUserQuestion` with the choices as bare labels. Mark a recommended option in its label/description. Open-ended free-text questions (not a discrete pick) still use the inline `👉👉👉` + bold convention. Rule lives in CLAUDE.md §User-Facing Questions + §Recurring Failures #1. See [[feedback_pause_on_pointing_questions]] for the "ask last, then stop" sequencing.

## History — why we got here

The original rule: NEVER write the primary question as a compound `"X, or Y?"` (reads as yes/no); ALWAYS put labeled `A)`/`B)` options above the 👉, with typeable Latin labels (never symbols). It was in always-loaded CLAUDE.md AND MEMORY.md, yet still failed ~once per conv — a **salience** failure (the rule wasn't retrieved at the authoring moment), not a knowledge gap.

- **Conv 272** built **[QLINT]**, a deterministic Stop-hook enforcing the inline-label rule (typeability check; `.claude/hooks/qlint-question-format.sh`).
- **Conv 273** reframed it: prose (proactive, decays) and a Stop-hook (post-hoc, partial detector) are both the wrong *layer* for a salience failure. The right lever is changing the **channel** — route decisions through AskUserQuestion so the bad shape can't be expressed. After a same-conv trial, the user chose to **drop QLINT entirely** (removed the hook + its `settings.json` registration + the calibration harness) and **prune the inline-format prose**, relying purely on the tool. The one residual risk — *remembering* to invoke the tool — is the same salience dependency, accepted as the tradeoff.

## Motivating incidents (preserved)

- **Conv 132** — *"Want to review the strategy doc before I proceed to Phase 2, or would you rather handle the retirement decisions first?"* → user replied "yes" (ambiguous). *"These long sentences with 'or' far inside look like Yes/no."*
- **Conv 147** — *"Continue with [LE-TRIAGE], save for its own conv, or stop here?"* → "yes" meaning option 1. User mandated the A)/B)/C) format.
- **Conv 208** — *"Run /w-codecheck now…, or batch with later work?"* → *"I really, really wish your MEMORY.md and/or CLAUDE.md would give this more importance. It happens at least once a Conv."*
- **Conv 263** — used `①②③`/`α/β` as labels; user couldn't type them back: *"a memory about not using symbols as choices because I cannot easily type them."* (Label-glyph failure, distinct from the compound-OR shape.)

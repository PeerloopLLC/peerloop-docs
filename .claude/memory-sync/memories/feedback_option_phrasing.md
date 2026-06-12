---
name: Option-question format (A) B) C) labels) — pointer to CLAUDE.md
description: "NEVER ask 'X or Y?' as the primary question; ALWAYS A) B) labels above the 👉. Labels must be TYPEABLE Latin (A/B/C, A1/A2) — never symbols (α/β, ①②③, emoji) the user can't type back. Recurring failure (at least once per conv per user, through Conv 263). Primary rule lives in CLAUDE.md §User-Facing Questions + §Recurring Failures; this file preserves incident archaeology + the visceral anti-pattern as a memory-grep anchor."
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

## Labels must be TYPEABLE (Latin only — never symbols)

The label is what the user **types back** to answer, so it MUST be a plain keyboard character: `A) B) C)`, or `A1`/`A2` when namespacing nested/sequential sub-questions. **NEVER** use symbols as labels — no Greek letters (`α`/`β`/`γ`), no circled numbers (`①`/`②`/`③`), no emoji, no math glyphs. They force the user to enter a character they can't easily type.

The trap is *namespacing*: when an inner sub-question would collide with the outer `A) B) C)`, the wrong fix is to reach for a different symbol set (α/β, ①②③) to disambiguate. The right fix is Latin compounds — `A1/A2`, `B1/B2` — or just re-use `A/B/C` per question (each question's letters are local). Symbols are never the disambiguator.

- **Conv 263** — used `①②③` for the three Stream-write models and `α/β` for the C1 and A2 sub-options across a long design conversation; the user had to type "α" to answer and flagged it: *"a memory about not using symbols as choices because I cannot easily type them."* Distinct from the compound-OR failure below — this is about the label *glyph*, not the question *shape*.

## Why this keeps recurring

The rule is in CLAUDE.md §User-Facing Questions (always loaded) AND indexed in MEMORY.md (also always loaded). It still happens at least once per conv. Conv 208 example: "Run /w-codecheck now to validate the profile retrofit, or batch with later work?" — exact anti-pattern shape. The miss is in-the-moment, not directive-knowledge. Treat this file as a self-check trigger when drafting any non-yes/no question.

## Deterministic backstop — the [QLINT] Stop hook (Conv 272)

The rule is now ALSO enforced by a Stop hook: `.claude/hooks/qlint-question-format.sh`, registered under `hooks.Stop` in `.claude/settings.json`. It blocks turn-end (feeds a correction back) when the final message is **soliciting** (has 👉, or its last non-empty line ends with `?`) AND offers an **unlabeled choice** (a space-bounded " or " that isn't "yes or no", OR a parenthetical with ≥2 slashes like `(a/b/c)`) AND has **no A)/B) labels**. Only labels exempt — a bare 👉 does NOT (Conv-272 refinement: the rule is a *typeability* check, not a surface-"or" check; you answer by typing, so any choice richer than yes/no needs single-letter labels). Code fences + double-quoted spans are stripped so quoting the rule doesn't self-trip; `stop_hook_active` guards against loops; fails open. Calibration harness: `.scratch/qlint-calibration.sh` (19/19, incl. all 3 canonical incidents below). To extend, edit the script + add a fixture to the harness and keep it green (per `feedback_heuristic_calibration.md`).

## Motivating incidents (preserved for archaeology)

- **Conv 132** — Original incident. Asked *"Want to review the strategy doc before I proceed to Phase 2, or would you rather handle the retirement decisions first?"* User replied "yes" — ambiguous. User correction: *"These long sentences with 'or' far inside look like Yes/no."*
- **Conv 147** — Recurrence; prescription strengthened. Asked *"Continue with [LE-TRIAGE], save for its own conv, or stop here?"* User replied "yes" meaning option 1. User correction: *"You keep asking me compound OR-type questions whose first option I want and so I say yes. In the future, when you are asking a question which cannot be answered with Yes or No, use the A) B) C) format so at a glance I can see you have an non Yes/No question."*
- **Conv 208** — Recurrence + user-mandated weight boost. Asked *"Run /w-codecheck now to validate the profile retrofit, or batch with later work?"* User: *"I really, really wish your MEMORY.md and/or CLAUDE.md would give this more importance. It happens at least once a COnv."* → led to this file's rewrite + a new CLAUDE.md §Recurring Failures section at the top.

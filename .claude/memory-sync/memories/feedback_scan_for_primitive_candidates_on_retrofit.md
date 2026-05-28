---
name: feedback-scan-for-primitive-candidates-on-retrofit
description: "When retrofitting a @stand-in or legacy page to Matt-inspired, scan it FIRST for repeating/composable UI elements that should become new primitives — don't write inline JSX."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: f1ae7235-3dca-4f6c-905e-f0e2be5a5dc2
---

When retrofitting a `@stand-in` or legacy page to `@matt-inspired`, **scan the page first for UI elements that are good primitive candidates** — before writing any inline JSX. Especially when Matt hasn't designed primitives for that surface (forms, onboarding wizards, settings panels, etc.).

**Why:** Without this step, the retrofit just reproduces the legacy UI inside Matt-style chrome — losing the chance to grow the shared design-system surface. Login retrofit (Conv 207) surfaced 3 reusable form primitives (`Input` / `FormField` / `PasswordInput`); signup then composed them with zero new primitives. The principle generalises: each retrofit is also a primitive-extraction opportunity.

**How to apply:** Before editing the page/component:

1. Read the legacy component end-to-end.
2. List elements that repeat (multiple inputs, multiple cards, multiple option chips) OR are atomic enough to be reused on other surfaces (a single password field, an empty state, a topic-tag chip).
3. Check if a Matt-designed primitive exists for it (probe Figma via MCP, check `docs/reference/matt-frames-ready-for-dev.md`). If yes → use it. If no → these are extrapolation candidates.
4. Surface the candidates to the user **before** writing the page, with a brief proposal (name, what it wraps, why it's a primitive vs inline). Wait for go-ahead.
5. Build agreed primitives under `src/components/{form,ui,...}/`; register in `scripts/prov-candidates.ts` `PHASE6_EXTRAPOLATION_CANDIDATES`; apply `@matt-inspired` to the page itself per Conv 207 convention.

**Anti-pattern:** Translating the legacy page line-by-line into Matt tokens. That ports the look without extending the design system; the next retrofit starts from scratch.

**Related:** [[feedback_reuse_existing_components]] (use existing primitives, never inline duplicates); [[feedback_tokenize_only_matt_variables]] (token-ify what Matt tokenized).

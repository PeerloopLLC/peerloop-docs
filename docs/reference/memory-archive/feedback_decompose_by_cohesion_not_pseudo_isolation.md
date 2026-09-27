---
name: feedback_decompose_by_cohesion_not_pseudo_isolation
description: "Split work into cohesive vertical slices, never pseudo-isolated fragments where one task needs a piece of another"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 033fc760-dec5-4b5f-accc-d593fff79687
---

When breaking a body of work into tasks, decompose by **cohesion (vertical slices)**, NOT by surface
feature labels that produce pseudo-isolated, seemingly-serializable fragments. If a fragment needs a
*piece* of a sibling (not the whole sibling), the split is wrong — it adds coordination cost and buys
no real independence.

**Why:** Conv 271 — the feed/promotion/discovery group had ~14 fragments that repeatedly "missed
something fundamental." Root cause (user-named) was the decomposition itself: "build CommunityAnchor"
was never separable from the pipeline-metadata feeding it and the renderer consuming it; three "seed"
tasks all rewrote the same file; entity-promo needed the anchors. User: *"I see no value in the task
isolation if this happens."* First re-plan attempt only re-sequenced + added a "foundations" phase —
still kept the broken split (one foundation task "unblocked five"). User rejected it; the fix was to
**reassemble** the fragments into 3 cohesive units (Seed / Discovery-Rendering / Promotion-System).

**How to apply:** A unit is correctly isolated only if — (1) it owns every layer it touches (data
pipeline, schema, component, render, seed, tests) so it builds AND verifies end-to-end without
reaching into an unfinished sibling; (2) its dependencies are *whole prior units*, not pieces of a
peer; (3) deps are unidirectional (no mutual halves); (4) **it has a standalone done-test** — a
runnable/observable thing proving the slice works. Rule 4 is the tell: a fragment with no
self-contained done-test was cut through the middle of a cohesive thing → merge it back. Genuinely
independent one-offs that share no surface (e.g. a 6-line GET-gate, a doc regen) SHOULD stay separate
— that's correct isolation, not the pseudo kind. Pair this with a premise-check before building each
unit (trace the real code path; missing data/schema it needs IS part of this unit's scope). Related:
[[feedback_infra_vs_deliverable]], [[feedback_no_simplest_fix]].

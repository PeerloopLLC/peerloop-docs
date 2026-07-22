---
name: feedback-assess-ask-before-acting
description: "Conv 407 (first Fable 5 conv) — surface scope/target choices as questions before executing; a changed doc premise requires a full rewrite, not grep patches"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: f63c7684-16ac-4bf6-826f-f35721b58ef9
  modified: 2026-07-22T16:25:22.876Z
---

**What happened (Conv 407, MERGE-BRIAN):** three user-flagged misses in one conv, one root — executing ahead of confirming intent. (a) The user named `brian-July-7` as the review target; CC silently promoted the newer `brian-July-20` to "the target" inside a larger update (justified by an old board note + a strict-descendant measurement) instead of stopping at that decision point and asking. (b) When the user corrected the scope, CC grep-patched the plan README's mentions instead of re-reading and re-grounding the whole document — the Focus line (line 3 of the file) survived one "sweep" and the §1 header survived the next; the user caught both. (c) Pattern named by the user: "You are not assessing my ask before making changes… your changes to the README have been shallow… I am wondering whether we shouldn't start again on this whole investigation." Resolution: fresh-docs restart (README rewritten from the pivot premise, analysis re-run) while keeping verified infra.

**Why:** A scope-defining interpretation (which branch, which snapshot, which doc premise) is the user's call even when a measurement makes one option look strictly better — containment facts don't override an agreed human pivot point. And grep-patching a document whose founding premise changed leaves premise-echoes wherever the grep didn't reach; only a full re-read catches them.

**How to apply:** Before executing an ask, restate any scope-affecting interpretation and surface target/scope choices as explicit `AskUserQuestion` decisions — *especially* when data suggests deviating from what the user literally named. When a document's founding premise changes, re-read it in full and rewrite from the new premise; never repair by search-hit. Related: [[feedback_explicit_approval_not_inferred]] (consent bar is HIGHER right after a miss), [[feedback_audit_surface_findings_first]].

**The user's working model (their words, Conv 407):** reasoning is the **decision gate**, not context — *"I use your reasoning to see if I should entertain your options at all. I may challenge your reasoning. Or agree with it and pick one of your options."* Options without reasoning are unusable to them. Focus mode was constant across all prior convs — the variable was the MODEL: Fable 5 over-applied outcome-first compression to the reasoning itself. When a decision is being offered, the reasoning IS the deliverable, never the "supporting detail" to drop.

**Second dimension (same conv, user re-flagged):** *"You assess in the background and offer choices without pre-explaining why the choices are offered."* Under focus mode the user sees ONLY the final message of a turn — every probe, measurement, and inference in between is invisible. So every `AskUserQuestion` must be preceded **in the same message** by: what was found → how it was interpreted → why each option exists → the recommendation and its reason. A picker arriving without its reasoning above it is a regression against CLAUDE.md §User-Facing Questions ("reasoning/tradeoffs/recommendation in prose above"), not a style choice. Conv 407 instances: branch retarget (no question at all), D1-reseed picker (mechanics explained only after the user asked why); the restart-options picker (tainted-vs-sound assessment attached) was the compliant counter-example.

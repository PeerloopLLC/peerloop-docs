---
name: feedback_route_sweep_pause_protocol
description: "ROUTE SWEEP (RTMIG-4) — per-route process: exhaustive Tier-1 + Tier-2 assessment, PAUSE before code, browser-verify, user out-of-scope review, mark Swept. Canonical 8-step process in plan/route-migration/README.md"
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 859736c4-8307-4fa1-9306-8cbbfbb65b4f
---

**The ROUTE SWEEP (RTMIG-4, reframed Conv 291).** A **full visual-presentation sweep** of every route, organized into 14 route-group tasks (`RG-*`). The unit is a route's `.astro` page, but scope = the **whole rendered page + every subcomponent**. Every route is swept, **including already-ported ones**. Porting is just one kind of per-route work. **Exhaustive assessment is valued VERY highly — do NOT hurry; we want complete coverage of both tiers.**

**Canonical 8-step per-route process** (full text + resumption pointers in `plan/route-migration/README.md` § "Working protocol"; a new conv resumes from there + the route checklist + the [[tier2 ledger]] + `.scratch/prim-candidates-*.md`):

1. **Assess Tier-1** (visual/token) — walk the ENTIRE component tree; flag Matt-shell/layout gaps + every legacy-token survivor (`primary-*`/`secondary-*`/`rounded-lg`/`text-sm`/`dark:`) + SubNav + 404-honesty + existing-primitive reuse.
2. **Assess Tier-2** (primitives) — run `/w-prim-candidates`; **log EVERY STRONG candidate** (incl. one-offs) in `plan/route-migration/tier2-primitive-ledger.md` (route · site · count · status · impact). Complete pass — nothing skipped, only deferred-with-a-record.
3. **Surface** the full Tier-1 + Tier-2 assessment + recommended dispositions.
4. **PAUSE for refinements — STOP, wait. NO code before this clears.**
5. **Do the work** — Tier-1 fixes + *ripe* Tier-2 extractions (register in matt-inspired-registry + `data-prov` stamp; update ledger to 🟢).
6. **Browser-verify** — gate (tsc/astro/lint/prov:sweep) + view in-browser (member + visitor + conditional states); DOM-verify where precision matters (gates miss CSS — `bg-primary` was transparent; brand-blue bg token = `bg-text-primary`).
7. **User out-of-scope review (user-driven, final)** — user inspects the page; anything they want fixed that's OUTSIDE Tier-1/Tier-2 → create a dedicated per-route task `[<ROUTE>-FIXES]`. **CAPTURE, do NOT solution/fix/discuss-to-resolution** — when the user asks for a task, MAKE the task, don't try to solve the items. Store CC research/comments inline per item (root-cause, affected components, options — user welcomes them). It's a **living list**: grows + consulted across routes (Conv 291 lesson — CC over-engaged trying to fix panel/filters instead of just capturing).
8. **Mark Swept** — tick the route row ☑. **Swept = Tier-1 done + Tier-2 fully assessed (ripe extracted, rest logged) + browser-verified + out-of-scope review done.** Un-ripe ledger candidates do NOT block Swept.

**Why:** the route is the lens for assessing visual presentation; the user adds/reframes scope before any edit, and owns the final out-of-scope call. **How to apply:** SoT = `plan/route-migration/README.md` (process + per-group route checklists with ☐/☑) + `tier2-primitive-ledger.md` (cross-route candidate accumulation). Cross-cutting primitives extract at the route that completes Rule-of-Three. Relates to [[feedback_dom_truth_over_screenshots]], [[feedback_port_functionality_and_styling]], [[project_matt_phaseout_inspired_default]], [[project_old_pages_no_delete_until_vetted]].

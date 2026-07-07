# Current Tasks — between convs

> Last refreshed 2026-07-07 (Conv 370). Per-conv history lives in `docs/sessions/` + git; this file is forward-looking task state only.
>
> **Persistent home for Peerloop task state.** Tracked in git so both machines see the
> same state via `/r-commit` push/pull. Edit by hand to reorder; the refresh (`/r-update-tasks`,
> plus `/r-commit` + `/r-end`) preserves your edits and overlays statuses from TodoWrite for
> code-matched rows.
>
> **Format:** Tasks are keyed by `[CODE]` (the sole stable identifier — no numeric IDs). Every task is
> an H3 (`### [CODE] · status · [model]`; the status segment appears in Ordered only) with a lead line
> then sub-bullets (Ordered uses Status / Next / Why / Refs; backlog is a lead line + adaptive
> sub-bullets). **Lanes** fold related micro-tasks into one H3's sub-bullets. **Parked** items sit under
> the blockquoted `> ## ⏸️ PARKED` divider near the end of the backlog. Only the three real `## ` H2
> anchors (🔥 Ordered / 📋 Unordered backlog / ✅ Completed this conv) are load-bearing.

---

## 🔥 Ordered (next-conv execution sequence)

_(none — the [MEM-CAP-ARCH] block completed Conv 358 via full-collapse; promote a backlog item here to set the next sequence.)_

---

## 📋 Unordered backlog

### [TZ-AUDIT] · standalone · [Opus]

Full timezone-correctness audit. Recurring `new Date()` issues have survived multiple sweeps; user has low confidence TZ handling is right — dedicated deep pass.

### [HOME-FIXES] · standalone (deferred per-route bucket)

Deferred bucket of per-route fixes captured while sweeping the Home (`/`) route — small issues set aside to batch later.

### [COURSES-FIXES] · standalone (deferred per-route bucket)

Same as [HOME-FIXES] but for the Courses route(s).

### [PLAN-XTRACT] · standalone

Extract bloated inline PLAN.md blocks out to `plan/<slug>/README.md`. PLAN.md is ~62K tokens — over the Read-tool limit (forced a Python-splice workaround Conv 350). Low priority.

### [BRAND-DOCS] · standalone

Docs-wide "PeerLoop" → "Peerloop" casing sweep — **pre-existing** inconsistency (NOT Conv-369-caused), surfaced by the Conv-369 r-end docs agent: ~30 docs still carry the old casing as generic prose, mostly manual/vendor (`resend.md`, `stripe.md`, `cloudflare.md`, `matt-design-system/*`) + a few driftCheck (`url-routing.md`, `messaging.md`, `ratings-feedback.md`). BRAND-CASE (Conv 369) was scoped "UI copy only." Verify each isn't an intentional reference before bulk-replace. Low priority.

> ## ⏸️ PARKED (blocked behind a clear gate — out of active rotation)
>
> Each revisits when its gate clears.

### [RG-PUBLIC] · ⏸️ Parked — gate: marketing redesign

Public/marketing route group sweep (the only un-swept RG-* group; RTMIG-4 closed Conv 340 with it deferred). The 14 marketing pages live only in `/old/*`; root paths 404 by design. Revisit if/when the marketing redesign is scheduled. **Refs:** `plan/route-migration/README.md § RG-PUBLIC disposition`.

### [PREFLIP-WT] · ⏸️ Parked — gate: user say-so

Tear down the preflip reference worktree (`~/projects/Peerloop-preflip` on :4331, `peerloop-ref` alias). Consequential + machine-local; the PLATO port-audit reason for keeping it has cleared. **Refs:** memory `project_preflip_worktree_reference`.

### [BROWSER-SMOKE-2B] · ⏸️ Parked — gate: post-launch · [Opus]

Evaluate an LLM-driven headless PLATO browser-mode smoke-walk executor. Do NOT resurrect Playwright E2E. **Refs:** `docs/decisions/06-testing-ci.md`.

### [MINWIDTH-320] · ⏸️ Parked — gate: user say-so (on hold Conv 369)

Lower the supported minimum screen width 375px → 320px (iPhone-SE class). 3 scoped overflow sites: `MembersFilters.tsx` + `CoursesFilters.tsx` filter rows (let search shrink via `min-w-0`, or wrap the cluster) + Home's legacy feed-card action button (`min-w-0`/`flex-wrap`); re-verify at 320px via the iframe harness. Optional — **put on hold Conv 369** pending user say-so. **Refs:** `docs/decisions/05-ui-ux-components.md` [MINWIDTH], `memory/reference_responsive_iframe_harness`.

### [ICON-LIC] · ⏸️ Parked — gate: MVP-GOLIVE (pre-launch legal/compliance)

Icon commercial-use compliance, surfaced Conv 370 during [ICN-NS]. **Two items:** (1) **Attribution NOTICE** — no `LICENSE`/`NOTICE`/`THIRD-PARTY-NOTICES` file exists, but `icons.tsx` = **Heroicons (MIT, Tailwind Labs)** and ~20 `MattIcon` SVGs = **Material Symbols (Apache 2.0, Google)** both require the notice retained → add a third-party-notices file (low effort). (2) **Brand-logo trademark review** — `brand-icons.tsx` (Google/Stripe/GitHub/X/LinkedIn/YouTube/Instagram) are trademarks, not licensed assets: check each against brand guidelines before launch — esp. **Google Sign-In** button rules, **Stripe** badge rules, and the `fill="currentColor"` monochrome recoloring (some brands mandate specific colors). The 39 `matt-catalogue` MattIcons are commissioned/owned — verify the designer agreement assigns IP. **NOT legal advice — needs counsel sign-off at launch.** **Refs:** `docs/as-designed/icon-system.md`, `src/components/icons/icon-provenance.ts`.

---

## ✅ Completed this conv

- **[ICN-NS] — Icon-system reconciliation, all phases + §3.3 decided (Conv 370).** Option A (MattIcon-canonical) ratified, then executed end-to-end. **Phase 1:** retired the legacy Astro path registry (`icon-paths.ts` + `Icon.astro` deleted; 4 call sites migrated — Breadcrumbs `chevron-right`→MattIcon, Footer 3 brand logos→`brand-icons.tsx` [Twitter bird→X]); systems 4→3, §3.1+§3.2 gone. **Phase 2:** ratified the naming convention (MattIcon kebab name canonical; icons.tsx renames to match) + full `icons.tsx`↔MattIcon reconciliation map (`icon-system.md` §7); found & documented 10 literal `icons.tsx` aliases. **Phase 3:** consolidated all 10 aliases + **all 15** name-mismatch renames (~80 files; `icons.tsx` 108→98 exports; incl. `UsersIcon`→`GroupIcon` after a glyph check kept `TeamIcon`=3-person distinct; `RatingIcon`→`ratings` moot). **§3.3 decided:** accept the `icons.tsx` (Heroicons) / `MattIcon` (Material) two-system split as an intentional documented steady state — implementation-unification declined (RTMIG-4 route sweep closed Conv 340 without scoping it; no migration will absorb it). All 5 gates green at each step (final: tsc/lint/astro 0-0-0/6761 tests/build). Docs: `icon-system.md` (rewritten §3.3/§6/§7 + header), `_INDEX.md`, decision-log + 01-architecture + INDEX, memory `reference_icon_system`. **ICN-NS closed.**

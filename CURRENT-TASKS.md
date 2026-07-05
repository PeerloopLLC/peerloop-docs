# Current Tasks — between convs

> Last refreshed 2026-07-05 (Conv 366). Per-conv history lives in `docs/sessions/` + git; this file is forward-looking task state only.
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

### [ICN-NS] · standalone

Icon-namespace cleanup across the two icon systems (Astro path registry `icon-paths.ts` + React `icons.tsx`/`brand-icons.tsx`) and the Matt `MattIcon` registry — reconcile naming so the three don't collide/duplicate.

### [TZ-AUDIT] · standalone · [Opus]

Full timezone-correctness audit. Recurring `new Date()` issues have survived multiple sweeps; user has low confidence TZ handling is right — dedicated deep pass.

### [DOCGEN-SPEC] · standalone

Document the generated-docs regen binding + the `/r-end` Step 5c regen gate in `doc-sync-strategy.md` (the auto-regen contract is encoded in skill scripts but not written down).

### [BRAND-CASE] · standalone

App-wide "PeerLoop" → "Peerloop" casing cleanup: 45 camelCase instances in `src/` UI copy vs the canonical 168. Verify each isn't intentional stylization before bulk-replace; skip the wordmark SVG filename.

### [HOME-FIXES] · standalone (deferred per-route bucket)

Deferred bucket of per-route fixes captured while sweeping the Home (`/`) route — small issues set aside to batch later.

### [COURSES-FIXES] · standalone (deferred per-route bucket)

Same as [HOME-FIXES] but for the Courses route(s).

### [PLAN-XTRACT] · standalone

Extract bloated inline PLAN.md blocks out to `plan/<slug>/README.md`. PLAN.md is ~62K tokens — over the Read-tool limit (forced a Python-splice workaround Conv 350). Low priority.

### [E2E-DOCS] · standalone

Reconcile E2E test counts across `docs/reference/TEST-COVERAGE.md` + `docs/reference/TEST-E2E.md` (both driftCheck). Pre-existing drift surfaced by the Conv-363 r-end docs agent (NOT caused by Conv 363): TEST-COVERAGE lists E2E = 30; TEST-E2E says "25 files / 105 tests" (last touched Session 390); disk has 28 `e2e/*.spec.ts`. Re-verify per-file counts and fix both docs + the "All Test Files" grand total (carries a stale +2). Low priority.

### [SPACING-OFFGRID] · standalone

Audit off-grid spacing 4× bugs. The `@theme` bridge (`tokens-tailwind-bridge.css`) only remaps Matt's 4px-grid values `{4,8,12,16,20,24,32,40,48,64}` to literal px; off-grid values (`6,10,14,2,…`) silently fall back to standard Tailwind = **4× bigger**. Surfaced Conv 366 [SESS-UI]: `CourseSessionsActions` pills rendered 66px instead of ~28px (`px-14 py-6 gap-6` → 56/24/24px). **119 files** use off-grid `6/10/14` — MOST are harmless (e.g. stepper `gap-6`=24px looked fine), so this needs a **targeted audit of clearly-compact components**, NOT a blind sweep. Snap true-bug sites to nearest grid value (ties round up, per `memory/project_spacing_snap_over_matt_exception`). Low priority.

> ## ⏸️ PARKED (blocked behind a clear gate — out of active rotation)
>
> Each revisits when its gate clears.

### [RG-PUBLIC] · ⏸️ Parked — gate: marketing redesign

Public/marketing route group sweep (the only un-swept RG-* group; RTMIG-4 closed Conv 340 with it deferred). The 14 marketing pages live only in `/old/*`; root paths 404 by design. Revisit if/when the marketing redesign is scheduled. **Refs:** `plan/route-migration/README.md § RG-PUBLIC disposition`.

### [V217-WATCH] · ⏸️ Parked — gate: new CC release

Watch the upstream Claude Code `[TERM-GARBLE]` bug (blank/partial tool output + confabulated failure under Opus 4.8 + parallel batches; unfixed as of CC 2.1.159). Re-check on new CC releases. **Refs:** memory `reference_term_garble_upstream_bug`.

### [PREFLIP-WT] · ⏸️ Parked — gate: user say-so

Tear down the preflip reference worktree (`~/projects/Peerloop-preflip` on :4331, `peerloop-ref` alias). Consequential + machine-local; the PLATO port-audit reason for keeping it has cleared. **Refs:** memory `project_preflip_worktree_reference`.

### [BROWSER-SMOKE-2B] · ⏸️ Parked — gate: post-launch · [Opus]

Evaluate an LLM-driven headless PLATO browser-mode smoke-walk executor. Do NOT resurrect Playwright E2E. **Refs:** `docs/decisions/06-testing-ci.md`.

---

## ✅ Completed this conv

- **[STEP-BG] — Course Stepper green background tint (Conv 366).** `CourseJourneyStepper` all 4 variant roots `bg-white`→`bg-course-background` (#E8F4DF, Matt's course Entity-Background). Reads as a distinct unit vs the surrounding white; inner step-circles kept white to pop. DOM-verified computed bg + astro check.
- **[PROG-OUTLINE] — ProgressBar track ghost outline (Conv 366).** Added tone-matched `border border-{tone}-primary/40` to the track so the 100% extent stays legible on any surface (the neutral track dissolved into the new green stepper band). Affects both call sites (stepper meter + CourseProgressCard).
- **[TAB-PAD] — Mobile tab row padding reduction (Conv 366).** `SubNavItem` compact/top-strip rows `p-12`→`p-8 md:p-12` — mobile 2-col tab grid rows 48→40px; desktop/rail keep p-12.
- **[SESS-UI] — Sessions action card mobile fixes (Conv 366).** `CourseSessionsActions` top variant: snapped off-grid spacing (card py-10→py-8, pills px-14 py-6 gap-6 → px-12 py-8 gap-8; 66px→34px pills, card 230→92px on mobile), dropped the current-page pill per-route (`actions.filter(!isActive)`), kept the SESSIONS caption (stepper scrolls off → it's the orientation anchor). Root-caused the 4× oversize → filed [SPACING-OFFGRID].
- **[STEP-POS] — Moved stepper below the tabs (Conv 366).** `CourseJourneyStepper` out of AppLayout `entity-header` slot → content-top (below the sticky tab strip) on 3 pages (`[...tab]`/`book`/`success`); tabs pin sooner, stepper introduces content. Stays in content column so rail layout unaffected; not sticky (Conv 359 honored).
- **[STEP-SHRINK] — Compacted the mobile stepper (Conv 366).** Snapped `gap-6`→`gap-4` (fixes 24px off-grid bug, global), circles `size-[24px] md:size-[32px]`, band `py-12 md:py-16`, connector `mt-[11px] md:mt-[15px]`. Kept labels + progress meter. Mobile band 154px→98px (verified at 375px viewport).

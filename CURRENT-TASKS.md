# Current Tasks — between convs

> Last refreshed 2026-07-05 (Conv 364). Per-conv history lives in `docs/sessions/` + git; this file is forward-looking task state only.
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

### [VITE-DEDUP] · standalone

Durable `resolve.dedupe ['react','react-dom']` / ssr fix for the Vite SSR multiple-React cold-start crash. Retires the manual `rm -rf node_modules/.vite` workaround.

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

- **[LAYOUT-SG] — Course hero styling decided: keep inset (Conv 364, no code change).** The open call was inset-vs-full-bleed for the `/course/[slug]` hero. `CourseHeader` (`@matt-source 517:8935`, set 517:8934) renders in AppLayout's `entity-header` slot inside `<main>` — on desktop that's Matt's floating white card (`lg:p-24 lg:bg-white lg:rounded-[20px]`), and the hero itself is a rounded-16 dark card with its own padding, i.e. already a fully-inset card-within-a-card. **Decision: keep inset** — matches the Matt source frame and the floating-card desktop language; full-bleed would depart from `@matt-source` and (for true viewport-edge bleed) require restructuring the slot out of `<main>`. No edits; item closed as decided.
- **[LAYOUT-TOGGLE-AFF] — /profile layout control confirmed: keep the segmented toggle (Conv 364, no code change).** Conv-357's "check a box" phrasing raised whether the `nav_layout` control should be a checkbox instead of `LayoutToggle.tsx`'s segmented "Top bar / Side rail" radiogroup. **Decision: keep the segmented toggle** — both options named + symmetric with no implied default; the checkbox alternative was considered (unchecked=top default / checked=rail) but the explicit two-option control is clearer. No edits; item closed as confirmed.

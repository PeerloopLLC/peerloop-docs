# Current Tasks — between convs

> Last refreshed 2026-07-06 (Conv 368). Per-conv history lives in `docs/sessions/` + git; this file is forward-looking task state only.
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

### [MINWIDTH-320] · standalone

Lower the supported minimum screen width from 375px → 320px (iPhone-SE class). Per the Conv 367 **[MINWIDTH]** decision (`docs/decisions/05-ui-ux-components.md`), only 3 sites overflow below ~357px: the listing filter rows in `MembersFilters.tsx` + `CoursesFilters.tsx` (the `flex shrink-0 … gap-8` cluster + `min-w-[150px]` search can't compress → let search shrink via `min-w-0`, or wrap the cluster) and Home's legacy feed-card `ml-auto … px-3 py-1.5` action button in a no-wrap flex row (→ `min-w-0` / `flex-wrap`). Re-verify at 320px via the iframe harness (`memory/reference_responsive_iframe_harness`). Optional — only if iPhone-SE-class support is wanted.

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

### [STG-DEPLOY] · 🔄 Active

Deploy Conv 368's frontend fixes (TW-V4-OUTLINE + SIDEBAR-COLLIDE) to staging via `npm run deploy:staging`. Re-seed check → **not needed** (frontend-only; staging D1 already healthy at 11 users / 6 courses, current schema). Awaiting deploy confirmation.

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

- **[TW-V4-OUTLINE] — Tailwind v4 outline rename + src/ sweep (Conv 368).** `NavDrawer.tsx:77` `outline-none` → `outline-hidden` (the v4 behavior-preserving equivalent: keeps the forced-colors focus-outline affordance the v3 code intended on the programmatically-focused dialog panel). It was the **only** site — `check:tailwind` now clean and an independent grep found no `flex-grow`/`flex-shrink` or other v3→v4 renames. Gates green (tsc/lint/astro 0-0-0/build); no test surface.
- **[SIDEBAR-COLLIDE] — collision-precise merge trigger via JS observer (Conv 368).** Replaced the fixed `@media (max-height:500px)` merge proxy with a `ResizeObserver` on the `<aside>` that sets `data-merged` on **real overflow** (scrollHeight > clientHeight), so the merge presentation (12px seam + WORKSPACES divider/label hide) keys off the actual per-role collision at any viewport height; compaction (py/gap tightening) stays on the `@media` proxy per the oscillation caveat. **Hysteresis** releases only when clientHeight clears the recorded unmerged-content height + 96px — an in-browser sweep caught a first-cut bug (scrollHeight clamps to clientHeight, so the original `slack`-based release was structurally impossible → stuck-merged), fixed by driving release off un-clamped clientHeight. Verified via the exact-height iframe harness: admin (9 rows) merges at ~700px vs student (8 rows) at ~650px (per-role precision a fixed threshold can't give), clean release with no oscillation, design-neutral when tall. VT-safe (attribute on the persisted node). 3 files (Sidebar.tsx/global.css + the outline fix in NavDrawer); gates green + Sidebar tests 9/9.

# Current Tasks — between convs

> Last refreshed 2026-07-06 (Conv 367). Per-conv history lives in `docs/sessions/` + git; this file is forward-looking task state only.
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

- **[SPACING-OFFGRID] — Off-grid spacing 4× audit (Conv 367).** Targeted audit of the 329 off-grid `value-6` sites + tails. Key finding: the 4× bug only bites **compact, Matt-convention** elements — legacy components (`text-sm`/`rounded-lg`) are accidentally-correct (off-grid = standard Tailwind = intended), and most Matt off-grid values are wanted-24px container spacing. Fixed **3 real sites**: `MembersFilters`/`CoursesFilters` Filters pill (`px-14 gap-6`→`px-16 gap-8`, 56→16px) + `SegmentedPills` `tabs` variant (`py-6`→`py-8`, now matches sibling `pills`). DOM-verified via ephemeral dev server (Filters pill computed 16/12px + gap-8, box 107×44). `Button` was a false positive (doc-comment). Broad `value-6` bucket deliberately **not** blind-swept. Gates green (tsc/lint/astro/build); no test surface. 🟠 pre-existing NavDrawer `outline-none` v4-remnant left untouched.
- **[MINWIDTH] — Minimum supported screen width investigation → 375px (Conv 367).** Empirically swept **12 layout-stressing pages** at a true 320px viewport (exact-width same-origin **iframe harness** — `resize_window` is laggy and the MCP sees the real viewport, not DevTools device mode). Current clean floor **~357px**; only `/members` (357), Home (353), `/courses` (340) overflow below it (filter-row `shrink-0`+`min-w-[150px]` search; Home legacy `ml-auto` feed button). Decided **375px** as the official minimum (works today, zero changes) — recorded in `docs/decisions/05-ui-ux-components.md` + decision-log + INDEX (MINWIDTH). Filed **[MINWIDTH-320]** backlog task for the 3 fixes to reach 320px. New memory `reference_responsive_iframe_harness`. Ephemeral dev server used + torn down cleanly.
- **[SIDEBAR-MOBILE] — Sidebar short/landscape overlap + drawer-scroll fix (Conv 367).** Root cause: `flex flex-col justify-between` (top cluster + bottom cluster) → clusters collide under negative free space (Safari overlap; Chrome stacks) and the desktop variant had no scroll escape (Admin/Profile stranded ~184px off-screen). Fix: `mt-auto` on all 3 bottom elements (replaces justify-between — deterministic, no overlap) + `lg:overflow-y-auto` on desktop. Landscape-gated compaction (`@media (max-height:500px)`, scoped via `[data-prov-name=Sidebar]`, VT-safe): rows py-8→4, sidebar padding 24/32→12, and ALL gaps unified to 12px via a `--sb-item-gap` CSS var (MainNav/Workspaces/bottom + seam `row-gap`) so the merged list has uniform spacing incl. the previously-0 seam; merged state also hides the WORKSPACES divider+label (`data-sidebar-group-label`). DOM-verified both states (merged = uniform 12px + no label + scrolls; tall = Matt spacing + label + mt-auto pin, design-neutral). 3 files (Sidebar/MainNav/global.css); gates green + Sidebar tests 9/9. Trigger is a height proxy (≤500px, tunable; JS collision-detect offered).

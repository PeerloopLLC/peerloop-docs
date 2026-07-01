# State — Conv 354 (2026-06-30 ~20:25)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Single-thread UI conv: shipped **[SNAV-TOP] Phase 1** — moved the page-section SubNav from the desktop left rail to a horizontal top tab bar (with a mobile equal-width 2-col grid fill), lifted the persistent entity headers (community Card + `CourseHeader`) into AppLayout's `entity-header` slot so tabs sit above per-tab content, and fixed a pre-existing sub-466px horizontal overflow on both headers. The flat pages (community/learning/creating/teaching/courses) flip to top; the **zoned course enrollment journey stays a left rail on purpose** — Phase 2 redesigns it as a horizontal stepper. Both repos committed; `/r-end` pushed.

## Key Context

- **Global toggle:** `src/lib/subnav-layout.ts` → `SUBNAV_LAYOUT` (default `'top'`). Flip to `'left'` to restore the desktop rail everywhere in one line. Read by `AppLayout.astro` (wrapper direction + `subNavLayout` prop) and `SubNav.astro` (top-strip vs rail; forces rail when items are `zoned`).
- **Course pages pin the rail:** `/course/[slug]/[...tab]`, `success`, `book`, `/session/[id]` pass `subNavLayout="left"`. Phase 2 removes these pins once the journey is a horizontal stepper.
- **Entity-header pattern:** persistent entity headers belong in AppLayout's `entity-header` slot (a *direct child* of the component — Astro won't hoist a `slot=` attr from inside `<article>`). Per-tab title headers stay in the content slot.
- **Responsive reflow:** community header uses `min-w-0` + a 96px mobile image (`w-[96px] min-[480px]:w-56`) + wrap rows; `CourseHeader` stacks its two-column row + cuts padding on mobile (`px-24 py-32 sm:px-64 sm:py-40`, content row `flex-col ... sm:flex-row`).
- **Verification gotcha:** the Chrome bridge would not hold a sub-558px viewport on this machine (reported successful resizes that didn't apply; docked DevTools stole viewport width). Responsive fixes were verified via the **forced-mobile-state** method (force the mobile classes via inline style, then measure fit) — not a real narrow viewport. See Learnings.md.
- **Adjacent:** [LAYOUT-SG] — the entity-header move completed its "full-bleed top" residual; the inset-vs-full-bleed *styling* decision remains (context noted in CURRENT-TASKS).
- Baseline: 5 gates run green repeatedly this conv (tsc, astro check 0/0/0, lint, build ~6.4s); no test regressions (no SubNav/AppLayout tests, layout-only).
- For the task backlog, see `CURRENT-TASKS.md` — [SNAV-TOP] is Ordered #1 with **Phase 2** (horizontal journey stepper + un-pin course pages) as the next step. Do not re-list here.

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context.

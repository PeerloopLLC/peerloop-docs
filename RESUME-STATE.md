# State — Conv 360 (2026-07-02 ~15:55)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Completed **STICKY-P2** (sticky detail-page action bars, Phase 2) plus a follow-up header-CTA placement fix (**CHCTA**). The detail-page primary CTA now rides the sticky `SubNav` tab strip in top-bar layout — merge-into-strip via a new opt-in `action` prop, top-bar-only (side-rail already self-pins), hidden at rest and revealed once the bar sticks. The community non-member Join gap is fixed (Join now in the header, top-right). Two conv commits landed pre-`/r-end` (STICKY-P2 code `de4c9755`, docs `7d5efba`); the CHCTA fix + end-of-conv bookkeeping land in the Step-6 commit.

## Key Context

- **`SubNav` `action` prop** (`src/components/SubNav.astro`, + exported `SubNavAction` type) is the new primitive: top-bar-only, **reveal-on-stuck** (scoped `[data-reveal]/[data-stuck]` style + an inline scroll script; graceful no-JS fallback = always-visible). Forwarded by `CourseRail.astro` (top mode only). Course computes Enroll/Continue/Go-to-Session (mirrors the `CourseHeader` hero states); community computes creator→Manage.
- **Community non-member Join** lives in the **header** (not the strip) — single wired instance, `POST /api/communities/[slug]/join`, closes the `FeedActivityCard` dead-end. The header identity column got `flex-1` ([CHCTA]) so the CTA stays top-right beside the title.
- **Verification:** all 5 gates green (run 3× this conv); DOM-truth on the `:4321` dev server in BOTH layouts (course hides-at-rest → reveals pinned on scroll; community member→Leave, non-member→header Join with correct POST wiring; side-rail → action suppressed).
- **Open deferral:** the persistent enrollment-context/progress strip was NOT built (no room in the strip row) — recorded on PLAN row 29. `[LAYOUT-DOC]` still carries the addendum to document the new sticky behavior in the (manual) layout doc.
- **Backlog:** see `CURRENT-TASKS.md` — no Ordered sequence set; both this conv's tasks (STICKY-P2, CHCTA) are in Completed.

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context.

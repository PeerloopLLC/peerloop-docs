# State — Conv 368 (2026-07-06 ~18:42)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Cleared three UI-polish backlog items + a staging deploy, all user-verified. **[TW-V4-OUTLINE]** — the last Tailwind v3→v4 remnant (`NavDrawer` `outline-none`→`outline-hidden`; only site, sweep clean). **[SIDEBAR-COLLIDE]** — replaced Conv 367's fixed 500px merge proxy with a `ResizeObserver` that sets `data-merged` on real overflow (per-role precise) + hysteresis; a real-browser iframe sweep caught and fixed a `scrollHeight`-clamping "stuck-merged" bug the gates/jsdom couldn't see. **[STG-DEPLOY]** — deployed to staging (Version `89c7f5b1`, verified live), re-seed determined unnecessary. Both fixes confirmed by the user on desktop + mobile.

## Key Context

- **Backlog:** see `CURRENT-TASKS.md`. No `🔥 Ordered` sequence set; all backlog items low-priority (MINWIDTH-320, ICN-NS, TZ-AUDIT, DOCGEN-SPEC, BRAND-CASE, HOME/COURSES-FIXES, PLAN-XTRACT, E2E-DOCS + Parked). No new backlog items added this conv.
- **SIDEBAR-COLLIDE mechanism (Sidebar.tsx):** `ResizeObserver` on the `<aside>` → `data-merged` attribute. **Enter** on `scrollHeight > clientHeight`; **release** only when un-clamped `clientHeight` > recorded unmerged-content-height + `MERGE_HYSTERESIS` (96px). Critical gotcha (memory'd): `scrollHeight` clamps to `≥ clientHeight`, so a `clientHeight − scrollHeight` slack maxes at 0 and can't drive release — must use un-clamped clientHeight. global.css split: compaction stays on `@media (max-height:500px)`, merge presentation (seam + WORKSPACES-hide) on `[data-merged]`.
- **Testing lesson (memory `reference_responsive_iframe_harness`):** the exact-size iframe harness now also covers min-HEIGHT/landscape; HMR/Fast-Refresh contaminates it mid-sweep (recreate the iframe fresh after edits settle).
- **Deploy:** `npm run deploy:staging` = build + `wrangler deploy` (Worker only, no D1). Staging D1 was healthy (11 users / 6 courses). Prod remains gated (MVP-GOLIVE).
- **Commits (pushed at this r-end):** code `f12dd941` (the 3 frontend files) + docs `3dc4df9` (mid-conv task refresh) + this end-of-conv bookkeeping commit. Gates green each thread (tsc/lint/astro/build; Sidebar tests 9/9).
- **Decision routed:** SIDEBAR-COLLIDE approach → `docs/decisions/05-ui-ux-components.md` + decision-log + INDEX + TIMELINE.

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context.

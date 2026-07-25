# State — Conv 414 (2026-07-25 ~09:12)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Built **[TAB-THEME]** — a user-facing Matt/Brian tab colour-theme toggle (MERGE-BRIAN §1 follow-up, revisiting M7's dropped client-branch colours). Added 3 style-guide tokens + a `--Tab-*` CSS-var switch (`SubNavItem` reads it, staying prov-clean), a cross-device `tab_theme` user column + `PATCH /api/me/profile` validation, `AppLayout` SSR root-attr (site-wide), and `TabThemeToggle` on /profile Preferences (mapping **A · Solid selected**; instant flip + background save). 5 gates green (suite 6552), Playwright + screenshot verified. Committed (code `de090a18`, docs `62b179d`) + pushed mid-conv; this /r-end adds the session/PLAN/decision bookkeeping.

## Key Context

- **MERGE-BRIAN §1 is now fully closed** (9/9 ADAPT built + `[HERO]` Conv 413 + `[TAB-THEME]` Conv 414). Next MERGE-BRIAN work = **§2 `/courses` catalog disposition walk** (review-order table in `plan/merge-brian/README.md`).
- **New reusable pattern:** user-preference runtime theme via a root `data-tab-theme` attribute + CSS vars — default theme = the *current* values (byte-identical no-op), SSR-set from a DB column (FOUC-free), instant client flip + background persist. First real one (ThemeToggle dark is parked; LayoutToggle reloads).
- **Optional `[TAB-THEME]` follow-ups (not started, documented in `plan/merge-brian` §1 follow-up build log):** extend `data-tab-theme` to `AdminLayout` + `LandingLayout` (their tabs stay Matt); `#2a93d5` is in the style guide but unused by mapping A.
- **`[DEVSRV-STALE]` parked (watch):** the user hit an old `/matt`+`/discover` site on 4321 this conv — stale astro-dev daemon / preflip-worktree server / Brave cache; verify current-ness via `curl … /matt` → 404.
- For the task backlog, see `CURRENT-TASKS.md` — do not re-list here.

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context.

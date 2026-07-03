# State — Conv 361 (2026-07-03 ~12:46)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Three standalone items, all committed + pushed: **[LAYOUT-DOC]** (drift-fixed `08-layout-and-margins.md` §8.2/§8.5 + new §8.6/§8.6.4), **[AFK-CFG]** (disabled CC's AskUserQuestion 60s auto-proceed nudge via `CLAUDE_AFK_TIMEOUT_MS`=maxint in both settings scopes), and **[MOBNAV]** — a new mobile/tablet hamburger→full-Sidebar drawer (Arrangement A), designed from an interactive 4-option mockup, built, gate-green, DOM-verified.

## Key Context

- **[MOBNAV]** shipped in code `d0b527a7` (jfg-dev-14): new `NavDrawer.tsx` (body-level slide-out hosting the **reused** `Sidebar variant="drawer"` — single source of truth) + `NavMenuButton.tsx` (hamburger → global `nav:open` event); `ControlBar` = 4 bare MattIcons (Home/Courses/Communities/Messages, `gap-20`); `HeaderBar` flanks shown at tablet; `AppLayout` wiring. All 5 gates green (6743 tests). **True-mobile viewport visibility unverified in-browser** (Chrome clamped the window ≥1482px) — user to eyeball on a real narrow width / phone.
- **Two [MOBNAV] follow-ups** are `⬜` subtasks under LAYOUT-SG in PLAN.md: Communities↔Members bare-icon swap; notifications-vs-avatar in header-right.
- **[AFK-CFG]** effective next launch; `CLAUDE_AFK_TIMEOUT_MS=2147483647` in `~/.claude/settings.json` + project `.claude/settings.json`. New memory `feedback_afk_nudge_disabled`.
- **Backlog:** see `CURRENT-TASKS.md` — no Ordered sequence set; the 3 this-conv items are in Completed.

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context.

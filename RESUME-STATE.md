# State — Conv 367 (2026-07-06 ~14:47)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Three UI fix/investigation threads plus a dev-workflow reversal, all committed + pushed mid-conv. **[SPACING-OFFGRID]** — targeted audit of the off-grid Tailwind spacing 4× bug; found it only bites Matt-convention components (legacy are accidentally-correct), fixed 3 real sites (Filters pill ×2, SegmentedPills tabs). **[MINWIDTH]** — empirical 12-page iframe sweep → recorded **375px** as the official minimum supported width (decision + log + index); filed [MINWIDTH-320] for the future 320px work. **[SIDEBAR-MOBILE]** — fixed the top/bottom cluster overlap on short/landscape viewports (`mt-auto` replaces `justify-between`; `lg:overflow-y-auto` on desktop) + landscape-gated compaction with uniform 12px gaps and a hidden WORKSPACES label when merged. Also reversed the persistent-dev-server convention → ephemeral/situational.

## Key Context

- **Backlog:** see `CURRENT-TASKS.md`. New this conv: **[MINWIDTH-320]** (3 fixes to lower the floor to 320px), **[SIDEBAR-COLLIDE]** (make the ≤500px trigger collision-precise via JS — user offered + deferred), **[TW-V4-OUTLINE]** (pre-existing NavDrawer `outline-none` v4 remnant). All low priority. No `🔥 Ordered` sequence set.
- **New workflow (in effect):** no long-running dev server — CC spins up an **ephemeral** `npm run dev` on-demand for browser verification and tears it down (memory `feedback_persistent_dev_server_4321.md`). Exercised 3× this conv, each clean. Root cause it fixes: a CC-launched dev server is a child of the long-lived `claude` CLI process, survives `/clear`, and warns on `/quit`.
- **New technique (memory):** `reference_responsive_iframe_harness` — faithful responsive/min-width testing via an exact-width same-origin iframe (media queries key off iframe width). `resize_window` is laggy; the MCP sees the real page viewport, NOT a DevTools device panel; container-forcing lies.
- **Off-grid spacing bug (still latent, mostly benign):** `tokens-tailwind-bridge.css` `@theme` remaps only the 4px-grid set; off-grid values = N×4px. Only Matt-convention compact components are affected. [MINWIDTH-320]'s filter-row fixes are unrelated (min-w-0/wrap).
- **Sidebar fix mechanism:** gaps routed through a `--sb-item-gap` CSS var (VT-safe) so a `@media (max-height:500px)` block in `global.css` can unify them to 12px; WORKSPACES divider+label carry `data-sidebar-group-label` for the merged-state hide. Design-neutral above 500px.
- **Commits (all pushed):** code `2d593cf2` (SPACING), `afa88576` (SIDEBAR); docs `066a713` (SPACING+dev-server), `5197775` (MINWIDTH), `35e4513` (SIDEBAR task) + this r-end bookkeeping commit. Gates green each thread (tsc/lint/astro/build; Sidebar tests 9/9).

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context.

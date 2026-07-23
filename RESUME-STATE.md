# State — Conv 408 (2026-07-23 ~19:15)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Completed the **MERGE-BRIAN §1 `/course/[slug]` disposition walk** — all 12 mechanisms decided from live side-by-side comparison (ours `:4321` vs pivot `8a1e677f` `:4341`): **8 ADAPT, 3 DROP (2 soft/revisitable), 0 straight ADOPT**. No building this conv — deferred to next conv by user instruction. Along the way, fixed **9 dead account/settings links** across 6 files (the `/settings/*` → `/profile/*` flattening residue; code `6b4bbb2f`) and root-caused a reported `/profile`→`/@handle` redirect as a **browser-cached 301** (stale Brave state, not a code defect — no fix needed).

## Key Context

- **BUILD is the next step** (user: "now we will start building next conv"). Read `plan/merge-brian/README.md §1` first — it holds all 12 dispositions with per-mechanism rationale and build notes. Order the build cosmetic-first; note the coupling: mechanism 1's band is now **standalone** (mechanisms 8/9 dropped, so no `back-header` slot / `--pin-top` scaffolding to reach for).
- **The 12 dispositions:** 1 HDR-ABOVE-TABS ADAPT (compress hero, keep cover/price/CTA) · 2 SESS-TAB ADAPT **curriculum-first** (Modules≠Sessions per schema — public curriculum tab with session overlay, keep Prepare/Join + Homework + Diploma) · 3 SESS-FILES ADAPT (strips + `display_order`, defer `in_room`) · 4 TCH-SEARCH ADAPT (relabel + count-gated search) · 5 BAND-ACTION ADAPT (compact row, Payment→receipt, Diploma actionable) · 6 TAB-SCROLL ADAPT opt-in · 7 TAB-FLOAT/COMPACT ADAPT compact-only (tokenised, no gradient) · 8 BACK-X + 9 FEED-WIDTH **DROP soft** (breadcrumb aesthetic declined, revisitable by Brian) · 10 COMM-BAND ADAPT logo+affiliation only (drop accent) · 11 Teacher-switching **DROP** (keep one-teacher 403) · 12 MattCourseFeed ADAPT (tokenise).
- **New tasks this conv:** `[TSLASH]` (trailing-slash route normalization) and `[RECEIPT]` (no payment-receipt page — mechanism 5's Payment link depends on one; `transactions` table has the data). Both `[Opus]`-tagged.
- **Open asks of Brian** (in `plan/merge-brian/README.md`): the git-absent "Conv 376 approved" rationale for teacher-switching; whether he argues for the soft-dropped breadcrumb/shell changes.
- **Side-by-side gotchas:** dev seeds diverge ~52 lines across the fork (diff seeds before attributing a state difference to code); `:4321` and `:4341` **share one localhost auth cookie** (re-assert identity per side before reading); `:4341` login modal never renders (use the dev-login DevTools snippet).
- **Environment:** `:4321` is the Astro-7 daemon (may persist; `astro dev status`/`stop`); `:4341` is the pivot worktree (`~/projects/Peerloop-brian` at `8a1e677f`, ephemeral `npm run dev -- --port 4341`). Model is now **Opus 4.8 (1M)**; focus mode OFF.
- For the task backlog, see `CURRENT-TASKS.md` — do not re-list here.

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context.

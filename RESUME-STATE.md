# State — Conv 364 (2026-07-05 ~11:45)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Short decision-only conv — no code changes. Cleared the "LAYOUT-SG / toggle" backlog bundle by making the two open design calls: **[LAYOUT-SG]** the `/course/[slug]` hero stays **inset** (rounded dark card inside the desktop floating white content card — matches Matt source `517:8935`; full-bleed would depart from the source frame and, for true viewport-edge bleed, require restructuring the entity-header slot out of `<main>`); **[LAYOUT-TOGGLE-AFF]** the `/profile` `nav_layout` control stays the **segmented "Top bar / Side rail" toggle** (`LayoutToggle.tsx`) rather than a checkbox. Both items removed from the backlog and logged in `CURRENT-TASKS.md` ✅ Completed.

## Key Context

- **Backlog:** see `CURRENT-TASKS.md` — now 9 active standalone items (VITE-DEDUP, ICN-NS, TZ-AUDIT[Opus], DOCGEN-SPEC, BRAND-CASE, HOME-FIXES, COURSES-FIXES, PLAN-XTRACT, E2E-DOCS) + 4 Parked. No 🔥 Ordered sequence set.
- **PLAN.md:** there is a *real* ACTIVE inline block coded `LAYOUT-SG` ("Unified margins/layout style guide", FOUNDATION LOCKED Conv 289) — distinct from the CURRENT-TASKS backlog item of the same code. The update-plan agent resolved that block's "inset-vs-full-bleed design call" residual note in place (→ keep inset, Conv 364); the block stays ACTIVE (other residuals remain: §8.5.4 rhythm tokens, §8.5.5 hero-slot abstraction, md pill icon-spacing).
- **Inline fix:** `plan/route-migration/README.md` line 433 stale "still tracked under [LAYOUT-SG]" phrase updated to record the Conv-364 resolution.
- **No baseline re-verify needed** — zero code changes this conv (code repo was CLEAN throughout).

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context.

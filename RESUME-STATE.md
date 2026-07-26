# State — Conv 416 (2026-07-25 ~20:39)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Two threads, both committed. **[MF-SKEW]** (the Conv-415 #1 directive) fixed the wrangler↔astro-dev miniflare version skew: exact-pin `wrangler@4.112.0` so its bundled miniflare (4.20260714.0) dedupes with the dev server's into ONE shared copy, plus `@cloudflare/workers-types` v4→v5 (measured tsc-clean — the feared fallout was unfounded), global nvm wrangler bumped to match, dead `r2:list:*` scripts removed; live-verified `wrangler --local` + `db:seed:r2:local` now run while the dev server is up (code `3de05f0f`). Then **MERGE-BRIAN §1 course-page follow-ups**: Feed "Post" button restyled to the module-button look; "Ask a Question" (Creator + Peer Teachers) wired to `/messages?to=`; a gated `CourseReviewComposer` modal with API-aligned display criteria; and two shared-messages `?to=` deep-link bugs fixed (by-id preselect + endless-reopen loop) — all verified e2e (code `d450ae2c`). All 5 gates green (suite 6552) at both commits.

## Key Context

- **MF-SKEW is RESOLVED.** The `wrangler` exact-pin `4.112.0` (no caret) is **load-bearing** — a caret lets a fresh install float wrangler to a different miniflare pin → two copies → the `_cf_ALARM` crash returns. Rationale captured in memory `project_wrangler_exact_pin_miniflare_dedupe`. If `@astrojs/cloudflare` is ever upgraded, re-check its vite-plugin's bundled miniflare and re-align wrangler's pin.
- **Restart the dev server after any dependency change** — an `npm install` bricks a *running* `astro dev`'s in-memory miniflare module runner (500s on page loads, though CLI wrangler ops still work). Left running on `:4321` this conv (PID 22511); it's ephemeral — kill when done.
- **New reusable pattern — API-aligned gating:** compute a UI affordance's visibility from the *exact* predicate the backing endpoint enforces (the review button gates on real `enrollment.status='completed'`, not the journey proxy), so the button never appears when the POST would 400.
- **Messages `?to=` deep-link now works for new conversations** (preselect resolves the user by id via `/api/users/search?id=`; the modal no longer reopens on poll). Fixes notifications/profile "message" links too.
- **MERGE-BRIAN remaining:** §1 is complete; next block work is the §2 `/courses` catalog disposition walk, then §3–6 (communities / shell / sessions-files / misc) per `plan/merge-brian/README.md`.
- For the task backlog, see `CURRENT-TASKS.md` — do not re-list here.

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context.

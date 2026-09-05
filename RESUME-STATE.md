# State — Conv 447 (2026-09-05 ~12:12)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-15`, docs: `main`

## Summary

Conv 447 was one client-driven UI change plus a staging deploy. Added a drop-shadow + 1px hover-lift to the tab pills on every tabbed page (`/profile` `/learning` `/creating` `/teaching` `/community/{slug}` `/course/{slug}`) via a single `compact`-scoped edit in the shared `SubNavItem.astro`, reusing the Conv-434 `shadow-brian-pill` tokens (0 raw colour). Then deployed to staging (`deploy:staging`, v`2e8303ae`) and did a full `:feeds`-tier reseed — shipping this change plus the previously-undeployed Conv 445/446 course-page work, and syncing staging to the Conv 441–443 seed data.

## Key Context

- **Branch handoff (post-close, this conv):** after `/r-end`, closed out `jfg-dev-14` and created **`jfg-dev-15`** as the new working branch; also created **`brian-sep-05`** for the client. The Branch line above reads `jfg-dev-15` because that is where the next conv should work — the code repo was moved there after the end-of-conv commit landed on `jfg-dev-14`. `jfg-dev-14`, `jfg-dev-15`, and `brian-sep-05` all point at the same tip (`c173c7b3` — the Conv-447 end-of-conv code commit; the tab change itself is `6b7f01aa`).
- **`/moderating` is not a tabbed page** — `mod.astro` is a plain queue; six of the seven listed routes share the one primitive.
- **Deployed & verified:** staging returns 200 across homepage/course/communities; deployed `global.De6bmzKU.css` contains `shadow-brian-pill(-hover)`. `npm run verify` was green this conv (6406 tests, build clean).
- **`[STREAM-ENV]` caveat live on staging:** the `:feeds` reseed means community/course feeds carry duplicate Stream activities (staging shares the dev Stream app). Known, cosmetic; fix is the tracked `[STREAM-ENV]` Stream-side clean.
- **Probe-error note:** mid-verify I raised a false 🔴 "shadow not rendering" alarm (truncated computed box-shadow + wrong element); self-corrected, captured in Learnings.md + a feedback draft.
- **Task backlog:** see `CURRENT-TASKS.md`.

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context. Note the code repo is on `jfg-dev-15`.

# State — Conv 341 (2026-06-27 ~13:38)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Two threads. **(1) ROUTEGEN-NAV #14 — DONE:** repointed both route-doc generators (`scripts/route-matrix.mjs`, `scripts/route-api-map.mjs`) from the deleted `[AppNavbar]`/`[DiscoverSlidePanel]`/`[UserAccountDropdown]` nav model to the real `[Sidebar]` model (BFS re-rooted at `[Sidebar]`), regenerated all 6 artifacts across both repos; full baseline suite GREEN this conv (6697/6697 + build). One honest new orphan: `/creating/apply`. **(2) PLATO assessed live + scoped:** stepped back to check if PLATO still works after ~100+ dormant convs. Found it's **two layers** — API mode (green in `npm test`, 10/10) vs browser mode (manual, nav-stale). A live `member-directory` browser-run proved **refresh-not-rebuild**: every capability flowed once the dead entry-nav was corrected. Scoped the revival as **PLAN.md § PLATO-REVIVE** (DEFERRED #28) + task #15; narrowed #8 to E2E-Playwright-gate-only. All work committed + pushed.

## Completed

- [x] [ROUTEGEN-NAV] #14 — generators → Sidebar nav model; 6 artifacts regenerated both repos; all 5 baseline gates GREEN (tsc/lint/tailwind/astro 0-0-0 / test 6697/6697 / build); committed (code 5924999c, docs f671075)
- [x] PLATO live assessment — member-directory browser-run (as Amanda Lee); two-layer model surfaced; refresh-not-rebuild verdict
- [x] [PLATO-REVIVE] scoped — PLAN.md DEFERRED #28 (detail + summary row) + task #15; #8 narrowed to E2E-only; PLATO-REGISTRY.md cross-ref; committed (code a5e3bfe5, docs c5b6d1f)

## Remaining

- [ ] [RG-PUBLIC] #1 — public/marketing route group, parked until the marketing redesign (the `/old` keep-set: 14 LandingLayout pages, 404 at root by design)
- [ ] [LAYOUT-SG] #2 — `/course/[slug]` hero inset-vs-full-bleed design call
- [ ] [MEM-CAP-ARCH] #3 [Opus] — MEMORY.md at ~85% of the 25 KB SessionStart cap; architectural fix; do NOT re-run /r-prune-memory
- [ ] [VITE-DEDUP] #4 — durable `resolve.dedupe ['react','react-dom']` / ssr fix for the Vite SSR multiple-React cold-start crash (workaround `rm -rf node_modules/.vite`)
- [ ] [HOME-FIXES] #5 · [COURSES-FIXES] #6 — deferred per-route fix buckets
- [ ] [E2E-MIG] #7 — migrate E2E (Playwright) tests post-flip
- [ ] [E2E-GATE] #8 — restore the E2E (Playwright) gate. **NARROWED Conv 341:** the PLATO nav-model portion moved to #15 [PLATO-REVIVE]; E2E (Playwright) is a SEPARATE layer from PLATO
- [ ] [ICN-NS] #9 — icon-namespace cleanup across the two icon systems + MattIcon registry
- [ ] [TZ-AUDIT] #10 [Opus] — timezone-correctness audit
- [ ] [DOCGEN-SPEC] #11 — document the regen binding + r-end Step 5c gate in doc-sync-strategy.md
- [ ] [V217-WATCH] #12 — watch the [TERM-GARBLE] upstream CC bug
- [ ] [PREFLIP-WT] #13 — teardown the preflip worktree (consequential + machine-local; do on user say-so)
- [ ] [PLATO-REVIVE] #15 — **NEW Conv 341.** Revive PLATO browser mode (PLAN.md § PLATO-REVIVE). 3 buckets: (1) 17 nav waypoints [mechanical, inventoried], (2) per-instance `expect`/`pageAction` prose refresh, (3) **OPEN data-strategy decision** (re-pin to dev seed / seed genesis personas into migrations-dev / per-instance snapshots) — gates buckets 1-2. Plus refresh stale PLATO-REGISTRY.md (Conv 112)

## TodoWrite Items

- [ ] #1 [RG-PUBLIC] · #2 [LAYOUT-SG] · #3 [MEM-CAP-ARCH] [Opus] · #4 [VITE-DEDUP] · #5 [HOME-FIXES] · #6 [COURSES-FIXES] · #7 [E2E-MIG] · #8 [E2E-GATE] · #9 [ICN-NS] · #10 [TZ-AUDIT] [Opus] · #11 [DOCGEN-SPEC] · #12 [V217-WATCH] · #13 [PREFLIP-WT] · #15 [PLATO-REVIVE]

## Key Context

- **Baseline GREEN this conv** — full suite 6697/6697 (400 files), tsc/eslint/tailwind/astro-check 0-0-0 (1346 files), build clean; all run after ROUTEGEN-NAV. The generator change touched only `scripts/*.mjs` + generated artifacts (tsc-validated; no unit-test/app-build path consumes the generated TS).
- **PLATO is two layers** (key re-orientation): **API mode** = `scenarios` (chains of `steps`) run by `tests/plato/api/plato-scenarios.api.test.ts`, part of `npm test`, GREEN — proves data/personas/endpoints/verify-queries hold. **Browser mode** = `instances/*.instance.ts` `walkthrough[]` BrowserIntents, walked manually via Chrome bridge — the only drifted part (= PLATO-REVIVE #15). E2E (Playwright) is a THIRD, separate layer (#7/#8), NOT PLATO.
- **PLATO-REVIVE #15 corrected nav mappings** (verified live, for when picked up): `/discover/courses`→`/courses` (browse-all catalog, absorbed it); `/discover/members`→`/members` (absorbed Conv 223); sign-out → `/profile` account tab (`#logout-btn`→`POST /api/auth/logout`); onboarding-data → `/profile/interests` (InterestsSettings); `/dashboard`→`/learning` (StudentDashboard) for course-progress views OR `/`→Home SmartFeed for the interest-feed case. 17 waypoints across flywheel/activities/ecosystem/member-directory/new-user-pair. Full detail in PLAN.md § PLATO-REVIVE.
- **PLATO data mismatch (bucket 3):** dev D1 seed has Guy/Gabriel Rymberg, Sarah Miller, Amanda Lee, Jennifer Kim — NOT the genesis personas (Mara Chen, Alex Rivera) the instances assume. member-directory has no snapshot. dev-login emails are `<firstname>.<last>@example.com` style (e.g. `amanda.lee@example.com`); admin@peerloop.com / brian@peerloop.com also present.
- **`/members` page-behavior drift** (live-confirmed): defaults to the **Creator** role filter (not show-all); role chips are **additive multi-select** (OR); empty-state copy "No members found matching your criteria". This is bucket-2 `expect` drift.
- **Chrome bridge quirk:** `javascript_tool` rejects top-level `await` — use Promise `.then()` chains.
- Commits land in Step 6 (this is a pre-commit snapshot). All Conv-341 work was already committed + pushed mid-conv; the end-of-conv commit carries only session bookkeeping (Extract/Learnings/Decisions/RESUME-STATE/TIMELINE).

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.

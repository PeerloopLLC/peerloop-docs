# State — Conv 241 (2026-06-04 ~16:34)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Light conv: ran `/r-start` (counter 240→241, transferred 43 carried tasks, MEMORY.md flagged at 83% byte cap), then deployed the current `jfg-dev-13-matt` working tree to staging at the user's request. `npm run deploy:staging` — build passed, Worker shipped to `peerloop-staging` (Version `eea0ebe0-be32-495b-bc5f-f3bd76f80efa`) with correct staging bindings; smoke tests on /, /login, /courses, /api/debug/db-env all HTTP 200. No code/source changes committed (deploy = gitignored build artifacts only).

## Completed

- [x] [STG-DEPLOY] Deployed current `jfg-dev-13-matt` to staging — Version `eea0ebe0`, smoke tests HTTP 200, correct staging bindings (D1 peerloop-db-staging, R2 peerloop-storage-staging, Stripe pk_test)

## Remaining

Carried-forward backlog (unchanged this conv) + one new optional task ([STG-SEED]):
- [ ] [COMM-TAG-FILTER] Build real Commons tag filtering [Opus] · [CT-RESTYLE] · [COMM-LEAVE] · [MOD-TOGGLE]
- [ ] [MATT-EXEC-PG2] Phase 5 remaining pages (~5 routes; /book → CALENDAR2) · [MATT-EXEC-EXT] · [MMP-PH5] · [MATT-EXEC-GRD] · [CH-VARIANTS] · [SUCCESS-COMMUNITY] · [MFRD-LOOKUP] · [PRECHECKOUT-MATT-CONFIRM] · [ENROLL-NAV-MATT-CONFIRM]
- [ ] [RTMIG-TIER] Decide Tier-1/Tier-2 route-migration strategy [Opus] · [RTMIG-4] port ~89 /old/* pages
- [ ] [PRIM-MATCH-INDEX] · [PRIM-DOC] · [PRIM-ORPHAN-ACK] · [TXTBTN] · [PROFILE-PRIM-SWEEP] (PAUSED) · [PRIM-COURSES-DISMISS]
- [ ] [ICN-NS] Icon namespace convergence [Opus] · [HOWTOREG-ICN] · [ASSET-SWEEP-GATE]
- [ ] [E2E-MIG] · [E2E-GATE]
- [ ] [SHOWMORE] · [SELECT-AUDIT]
- [ ] [ADMIN-REDIRECT-BLANK] [Opus] · [SETTINGS-WATCHER] · [BAK-ARTIFACT]
- [ ] [PREFLIP-WT] · [REND-DEDUP-GUARD] · [MEM-CAP] (run /r-prune-memory) · [GARBLE-WATCH]
- [ ] [API-USERS-DRIFT] · [DOCS-ROUTES-STALE] · [PREPLAN-CHECKOUT-NOTE]
- [ ] [HOME-FEEDSHUB-VIS] · [DOM-FIRST]
- [ ] [PROV-SWEEP-DEBT] · [DASH-COURSES-LINK]
- [ ] [CALENDAR2] Matt restyle of booking wizard SessionBooking.tsx (/book stays @stand-in) [Opus]
- [ ] [STG-SEED] Optionally reseed staging D1 with latest seed (reset→migrate→seed:staging) — optional, not blocking

## TodoWrite Items

- [ ] #1: [COMM-TAG-FILTER] [Opus] · #2: [CT-RESTYLE] · #3: [COMM-LEAVE] · #4: [MOD-TOGGLE]
- [ ] #5: [MATT-EXEC-PG2] · #6: [MATT-EXEC-EXT] · #7: [MMP-PH5] · #8: [MATT-EXEC-GRD] · #9: [CH-VARIANTS] · #10: [SUCCESS-COMMUNITY] · #11: [MFRD-LOOKUP] · #12: [PRECHECKOUT-MATT-CONFIRM] · #13: [ENROLL-NAV-MATT-CONFIRM]
- [ ] #14: [RTMIG-TIER] [Opus] · #15: [RTMIG-4]
- [ ] #16: [PRIM-MATCH-INDEX] · #17: [PRIM-DOC] · #18: [PRIM-ORPHAN-ACK] · #19: [TXTBTN] · #20: [PROFILE-PRIM-SWEEP] · #21: [PRIM-COURSES-DISMISS]
- [ ] #22: [ICN-NS] [Opus] · #23: [HOWTOREG-ICN] · #24: [ASSET-SWEEP-GATE]
- [ ] #25: [E2E-MIG] · #26: [E2E-GATE]
- [ ] #27: [SHOWMORE] · #28: [SELECT-AUDIT]
- [ ] #29: [ADMIN-REDIRECT-BLANK] [Opus] · #30: [SETTINGS-WATCHER] · #31: [BAK-ARTIFACT]
- [ ] #32: [PREFLIP-WT] · #33: [REND-DEDUP-GUARD] · #34: [MEM-CAP] · #35: [GARBLE-WATCH]
- [ ] #36: [API-USERS-DRIFT] · #37: [DOCS-ROUTES-STALE] · #38: [PREPLAN-CHECKOUT-NOTE]
- [ ] #39: [HOME-FEEDSHUB-VIS] · #40: [DOM-FIRST]
- [ ] #41: [PROV-SWEEP-DEBT] · #42: [DASH-COURSES-LINK]
- [ ] #43: [CALENDAR2] [Opus]
- [ ] #45: [STG-SEED] Optionally reseed staging D1

## Key Context

- **Staging is live on the Conv-241 build:** `peerloop-staging.brian-1dc.workers.dev`, Version `eea0ebe0-be32-495b-bc5f-f3bd76f80efa`, = current `jfg-dev-13-matt` working tree (includes Conv 240's two-tier Journey). Deployed via `npm run deploy:staging` (builds staging env into `dist/server/wrangler.json`; does NOT pass `--env staging` to wrangler).
- **Staging D1 was NOT reseeded** — deploy ran against existing staging data. [STG-SEED] #45 covers an optional fresh reset→migrate→seed:staging if wanted.
- **Baseline gates not re-run this conv** — deploy relied on the build (`&&` gate) as the deploy-blocking check. 5 gates were green at Conv 240 close (suite 6459). prov:sweep still RED at 6 errors ([PROV-SWEEP-DEBT] #41).
- **MEMORY.md at 83% of the 25KB auto-load byte cap** (120/200 lines, 21201/25600 bytes) — [MEM-CAP] #34, run /r-prune-memory before it truncates.
- **No code commits this conv** — code repo stays at Conv 240's HEAD (`25e6a4f5` / `54e2823` docs). Only docs change is RESUME-STATE bookkeeping.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.

# State — Conv 258 (2026-06-10 ~08:31)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Closed ROLE-STUDIOS Phase 4: browser-verified the progression nudges ([NUDGE-TC] done — S→T positive for amanda-lee, teacher+creator negative for guy-rymberg, via dev-login + DOM-truth settle-then-read), found+filed the stale-cache wrong-role flash ([NUDGE-CACHE-FLASH]), wrote the bridge memory ([BRIDGE-MEM]), deferred the v2 progression-gap ([NUDGE-TC-V2]). Marked ROLE-STUDIOS ⛔ BLOCKED BY CLIENT (deletion path gated on the old-vs-new dashboard comparison). Then a long design session on the **feeds redesign**: built a pre-meeting baseline (`plan/home-feed-merge/README.md`), then reconciled a pivotal-but-**speculative** client model (`client-meeting-2026-06-10-feeds.md`) across all 4 threads, captured the Matt post-shell spec (`post-format-matt.md`), and anchored everything to [HOME-FEED-MERGE] #30 with 5 reserved build tasks held until client adoption. Only code change: `/feed` removed from the Sidebar (route kept).

## Completed

- [x] [NUDGE-TC] ROLE-STUDIOS Phase-4 render-checks — S→T positive (amanda-lee: Home ③ banner + ① course card, persist after settle; per-course gate confirmed) + teacher+creator negative (guy-rymberg: 0 across all 4 surfaces). DOM-truth via dev-login + settle-then-read.
- [x] [BRIDGE-MEM] memory `reference_chrome_bridge_island_stale_cache` + MEMORY.md pointer
- [x] `/feed` removed from Sidebar NAV + COLLAPSED_NAV (route + page kept; mirrors Conv-250 /feeds)
- [x] ROLE-STUDIOS marked ⛔ BLOCKED BY CLIENT across PLAN.md + phase-4-nudges.md + task #1 + conv-tasks.md
- [x] Feeds redesign fully designed + reconciled → `plan/home-feed-merge/` (README baseline + client-meeting reconciliation + post-format-matt spec)
- [x] [HOME-FEED-MERGE] #30 set as the anchor task (points to 3 docs + 5 reserved codes + adoption gate)

## Remaining

- [ ] [ROLE-STUDIOS] #1 — ⛔ BLOCKED BY CLIENT. Deletion path (retire UnifiedDashboard, AppNavbar.tsx:97, AdminDashboardCard drop, Phase-5 orphan tree) gated on old-vs-new dashboard comparison sign-off. Available-but-parked: island restyles #20-23, [NUDGE-TC-V2], admin model-A deep-links, Home rework. SoT PLAN.md § ROLE-STUDIOS.
- [ ] [HOME-FEED-MERGE] #30 [Opus] — **anchor for the feeds redesign.** Design COMPLETE + reconciled (SPECULATIVE). SoT `plan/home-feed-merge/` (README + client-meeting-2026-06-10-feeds.md + post-format-matt.md). ADOPTION GATE (client): (1) retire-participatory-townhall sign-off; (2) promotion pricing/policy. On adoption: batch-create the 5 reserved tasks ([DISCOVERY-RAILS], [PROMOTE-PIPELINE], [ADMIN-FEED-UI], [RECO-UNIFY], [POST-MATT]) + fold README phases into the new model. Build post shell first.
- [ ] [NUDGE-TC-V2] #29 [Opus] — T→C v2 progression-gap (deferred; needs semantics decision A/B/C + data signal to client). SoT plan/role-studios/phase-4-nudges.md.
- [ ] [NUDGE-CACHE-FLASH] #28 — fix transient wrong-role nudge flash (stale `peerloop_user_cache` first-paint); gate nudges on a "classification fresh" signal. Memory: reference_chrome_bridge_island_stale_cache.
- [ ] [VISITOR-GATING] #31 [Opus] — audit visitor browse-vs-act gating clarity site-wide; builds the intent-preserving signup that HOME-FEED-MERGE sample-post CTAs depend on. Investigative → surface findings first.
- [ ] [RTMIG-4] #2 [Opus] · [ENTITY-ANCHOR] #3 · [SSR-LOADER-DEAD] #4
- [ ] [COMM-TAG-FILTER] #5 · [CT-RESTYLE] #6 (Tier-2 community)
- [ ] [PRIM-MATCH-INDEX] #7 · [TXTBTN] #8 (watch) · [PROFILE-PRIM-SWEEP] #9 (PAUSED)
- [ ] [ICN-NS] #10 · [E2E-MIG] #11 · [E2E-GATE] #12 · [SHOWMORE] #13 (ties to [POST-MATT])
- [ ] [PREFLIP-WT] #14 (KEEP until client-vet) · [TZ-AUDIT] #15 [Opus] · [SUCCESS-COMMUNITY-VERIFY] #16
- [ ] [MEM-CAP] #17 (MEMORY.md ~83% byte cap → /r-prune-memory) · [DOCGEN-SPEC] #18 · [OLD-PORTED-CLEANUP] #19
- [ ] [LEARN-ISLAND-RESTYLE] #20 · [CREATE-ISLAND-RESTYLE] #21 · [TEACH-ISLAND-RESTYLE] #22 · [TRIAGE-RESTYLE] #23
- [ ] [V217-WATCH] #24 · [COURSEDETAIL-DEAD] #27

## TodoWrite Items

- [ ] #1 [ROLE-STUDIOS] (BLOCKED) · #2 [RTMIG-4] [Opus] · #3 [ENTITY-ANCHOR] · #4 [SSR-LOADER-DEAD]
- [ ] #5 [COMM-TAG-FILTER] · #6 [CT-RESTYLE] · #7 [PRIM-MATCH-INDEX] · #8 [TXTBTN] · #9 [PROFILE-PRIM-SWEEP]
- [ ] #10 [ICN-NS] · #11 [E2E-MIG] · #12 [E2E-GATE] · #13 [SHOWMORE] · #14 [PREFLIP-WT]
- [ ] #15 [TZ-AUDIT] [Opus] · #16 [SUCCESS-COMMUNITY-VERIFY] · #17 [MEM-CAP] · #18 [DOCGEN-SPEC] · #19 [OLD-PORTED-CLEANUP]
- [ ] #20 [LEARN-ISLAND-RESTYLE] · #21 [CREATE-ISLAND-RESTYLE] · #22 [TEACH-ISLAND-RESTYLE] · #23 [TRIAGE-RESTYLE]
- [ ] #24 [V217-WATCH] · #27 [COURSEDETAIL-DEAD] · #28 [NUDGE-CACHE-FLASH] · #29 [NUDGE-TC-V2] [Opus] · #30 [HOME-FEED-MERGE] [Opus] · #31 [VISITOR-GATING] [Opus]

## Key Context

- **Feeds redesign SoT:** `plan/home-feed-merge/` — 3 docs. README = pre-meeting baseline (still valid, intact). client-meeting-2026-06-10-feeds.md = the speculative client model + full reconciliation (rail taxonomy: **Peerloop Picks**/editorial · **Promoted**/paid · Trending/New/Popular · For You; **Discovery Rails** daily/global/KV/localStorage service; Commons→**System community** admin-only + feeds un-named + feed_type townhall→system; promotion in feed MVP free escalation, payment deferred; cursor Option A holds). post-format-matt.md = post shell spec (Matt frames 477:8285 + 477:8203).
- **Not adopted** — do NOT start building the feeds redesign until the client signs off on (1) retiring the participatory townhall and (2) promotion pricing. The 5 reserved task codes live only in the docs until then.
- **Smart Feed is DB-tunable** — `scoring.ts` ScoringParams (7 weights + 6 dials) via `platform_stats smart_feed_%`; extend that pattern for new dials, don't reinvent.
- **Verification method for client-gated islands:** dev-login (`POST /api/auth/dev-login {email}`) + hard navigate + **settle-then-read** (~1.5s) on the `data-*` marker; the /chrome bridge live DOM races the `peerloop_user_cache` first-paint.
- **Dev server + /chrome bridge** were running this conv (localhost:4321, browser "Peerloop2") — will not persist after /clear.
- Code committed in Step 6 (pre-commit HEAD; only `src/components/Sidebar.tsx`).

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.

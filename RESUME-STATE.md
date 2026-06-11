# State — Conv 266 (2026-06-11 ~13:38)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Built **HOME-FEED-MERGE Phases 1–2** (the backend-first runs-first piece of the Feeds-redesign arc). **Phase 1 — `getMarketingCandidates`:** new `src/lib/smart-feed/marketing.ts` returns a two-pool `{ samplePosts, cards }` — sample posts via a net-new global-chronological `feed_activities` query (top-level only, recency-windowed, public-feeds-only, flag/viewer excluded, per-feed cap, `(created_at,id)` cursor), cards mapped from the injected Conv-261 Discovery Rails blob (good-card bar, dedupe, lens). **Phase 2 — orchestrator rework:** `getSmartFeed` now produces a unified 3-kind stream (`member-post`/`sample-post`/`suggestion-card`), mode-selected backbone, opaque Option-A `(created_at,id)` cursor (oldest-backbone floor — fixes a latent skip/dupe bug), generalized interleave + mode-aware diversity cap; replaced `getDiscoveryCandidates`, preserved `smart_feed_dismissals`. Endpoint stays 401-gated (un-gate is Phase 3), passes `railsBlob: null`, filters cards. Full baseline **6606/6606** + tsc/astro(0-0-0)/lint/build all green this conv. Tier-5 "Commons anchor" retired as a dead premise (SYS-RENAME Conv 259). Phases 3–7 remain.

## Completed

- [x] [HOME-FEED-MERGE] Phase 1 — `getMarketingCandidates` builder (`src/lib/smart-feed/marketing.ts`) + 19 tests (17 + 2 dismissal).
- [x] [HOME-FEED-MERGE] Phase 2 — orchestrator rework (`index.ts`): unified 3-kind stream, Option-A cursor, mode backbone, interleave/cascade, dismissals preserved; `getMemberCandidates` `beforeId` tiebreaker; `EnrichedCandidate` +kind/activityId/createdAt; endpoint gated + card-filtered. + 6 orchestrator tests.
- [x] Fixed latent smart-feed pagination skip/dupe bug (cursor = oldest backbone `(created_at,id)`).
- [x] Baseline verified THIS conv — 6606/6606, tsc + astro check (0/0/0) + lint + build green.
- [x] Docs: `feeds.md` + `API-COMMUNITY.md` + `TEST-COVERAGE.md` updated (docs agent); plan SoT § Phase 1 + § Phase 2.

## Remaining

- [ ] [HOME-FEED-MERGE] #28 [Opus] **[NEXT]** — **Phase 3:** un-gate `/api/feeds/smart` (auth-aware; visitor gets a real feed), wire the real rails blob into `getSmartFeed` (KV-read with compute fallback), visitor-branch caching, stop passing `railsBlob: null`. Then **Phase 4** (SmartFeed.tsx 3 render variants — member-post · sample-post w/ quiet intent CTA · suggestion/announcement card + "caught up → discover" boundary card; stop filtering cards at the endpoint), **Phase 5** (Home recompose: strip to nudges, mount feed, auth-conditional chrome, sticky sign-up bar, `/feed` redirect-visitor→`/`), **Phase 6** (intent-preserving signup, shared w/ VISITOR-GATING), **Phase 7** (browser-verify authed/visitor/cold-start). SoT `plan/home-feed-merge/README.md`.
- [ ] [PROMOTE-PIPELINE] #29 [Opus] — Steps 3–7 (3 Promote button + 4 templates+CommunityAnchor+composer both gated on #28 phase-4 · 5 PROMO-LIFECYCLE · 6 ADMIN-FEED-UI · 7 PromoteNudge LAST).
- [ ] [ADMIN-FEED-UI] #30 [Opus] · [RECO-UNIFY] #31 [Opus] (subsumes `getDiscoveryCandidates`, now orphaned-but-retained) · [PROMO-LIFECYCLE] #35 [Opus] — downstream PROMOTE-PIPELINE chain.
- [ ] [API-DISC-DOC] #33 — document `GET /api/discovery/rails` in a driftCheck API doc + add a `/api/discovery/*` entry to `.claude/scripts/route-mapping.txt` (both absent; pre-existing Conv-261, re-flagged Convs 265+266).
- [ ] [SYS-NAMING] #32 · [DISC-SEED] #34 · [SYS-GET-GATE] #36 (townhall comments GET still auth-only, low risk).
- [ ] [ROLE-STUDIOS] #1 — ⛔ BLOCKED BY CLIENT (old-vs-new dashboard comparison sign-off).
- [ ] [RTMIG-4] #2 [Opus] · [ENTITY-ANCHOR] #3 [Opus] · [SSR-LOADER-DEAD] #4
- [ ] [COMM-TAG-FILTER] #5 · [CT-RESTYLE] #6 · [PRIM-MATCH-INDEX] #7 · [TXTBTN] #8 (watch) · [PROFILE-PRIM-SWEEP] #9 (PAUSED)
- [ ] [ICN-NS] #10 · [E2E-MIG] #11 · [E2E-GATE] #12 · [SHOWMORE] #13 · [PREFLIP-WT] #14 (KEEP until client-vet)
- [ ] [TZ-AUDIT] #15 [Opus] · [SUCCESS-COMMUNITY-VERIFY] #16 · [MEM-CAP] #17 (MEMORY.md ~87% byte cap → /r-prune-memory) · [DOCGEN-SPEC] #18 · [OLD-PORTED-CLEANUP] #19
- [ ] [LEARN-ISLAND-RESTYLE] #20 · [CREATE-ISLAND-RESTYLE] #21 · [TEACH-ISLAND-RESTYLE] #22 · [TRIAGE-RESTYLE] #23
- [ ] [V217-WATCH] #24 · [COURSEDETAIL-DEAD] #25 · [NUDGE-CACHE-FLASH] #26 · [NUDGE-TC-V2] #27

## TodoWrite Items

- [ ] #1 [ROLE-STUDIOS] (BLOCKED) · #2 [RTMIG-4] [Opus] · #3 [ENTITY-ANCHOR] [Opus] · #4 [SSR-LOADER-DEAD]
- [ ] #5 [COMM-TAG-FILTER] · #6 [CT-RESTYLE] · #7 [PRIM-MATCH-INDEX] · #8 [TXTBTN] · #9 [PROFILE-PRIM-SWEEP]
- [ ] #10 [ICN-NS] · #11 [E2E-MIG] · #12 [E2E-GATE] · #13 [SHOWMORE] · #14 [PREFLIP-WT]
- [ ] #15 [TZ-AUDIT] [Opus] · #16 [SUCCESS-COMMUNITY-VERIFY] · #17 [MEM-CAP] · #18 [DOCGEN-SPEC] · #19 [OLD-PORTED-CLEANUP]
- [ ] #20 [LEARN-ISLAND-RESTYLE] · #21 [CREATE-ISLAND-RESTYLE] · #22 [TEACH-ISLAND-RESTYLE] · #23 [TRIAGE-RESTYLE]
- [ ] #24 [V217-WATCH] · #25 [COURSEDETAIL-DEAD] · #26 [NUDGE-CACHE-FLASH] · #27 [NUDGE-TC-V2]
- [ ] #28 [HOME-FEED-MERGE] [Opus] [NEXT] (Phase 3+) · #29 [PROMOTE-PIPELINE] [Opus] (Steps 3–7)
- [ ] #30 [ADMIN-FEED-UI] [Opus] · #31 [RECO-UNIFY] [Opus] · #32 [SYS-NAMING] · #33 [API-DISC-DOC] · #34 [DISC-SEED] · #35 [PROMO-LIFECYCLE] [Opus] · #36 [SYS-GET-GATE]

## Key Context

- **HOME-FEED-MERGE unified stream (phase 2).** `getSmartFeed(db, client, userId: string | null, { limit, before?, railsBlob? })` → `{ activities: FeedItem[], nextCursor, pageSize }`. `FeedItem` = `EnrichedCandidate` (`kind: 'member-post' | 'sample-post'`, keeps `isDiscovery` for client back-compat, +`activityId`/`createdAt`) ∪ `SuggestionCardItem` (`kind: 'suggestion-card'`, no Stream activity). Cursor = opaque `${createdAt}~${id}` = the OLDEST backbone post in the page (true floor); cards never in the cursor.
- **Mode backbone:** member posts if the viewer has feeds, else marketing sample posts (visitor/cold-start). `getMarketingCandidates` `perFeedCap = hasMemberFeeds ? 1 (injected) : diversityCap (visitor backbone)`. Dismissals (`smart_feed_dismissals`) wired into both marketing pools.
- **Phase 3 entry (NEXT):** the blob source — `getSmartFeed` accepts `railsBlob` (currently null at the gated endpoint). Phase 3 supplies it via KV-read with `computeDiscoveryRails(db)` fallback (mirror the existing `/api/discovery/rails` endpoint's two-tier pattern), drops the 401, and adds visitor-branch caching. The endpoint currently FILTERS `suggestion-card` items — Phase 4 stops that + adds the client render variants (the client `SmartFeed.tsx` still understands only 2 kinds).
- **`getDiscoveryCandidates` is now orphaned** (no longer called by the orchestrator) but retained + exported + tested; its removal is `[RECO-UNIFY]` #31.
- **Baseline:** verified THIS conv — 6606/6606 tests, tsc + astro check (0/0/0) + lint + build all green.
- Code + docs commits land at this /r-end.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.

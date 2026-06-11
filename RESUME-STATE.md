# State — Conv 267 (2026-06-11 ~14:44)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Built **HOME-FEED-MERGE Phases 3, 4, 5, and 7** — the backend-to-Home arc of the Feeds-redesign. **Phase 3:** un-gated `/api/feeds/smart` (now auth-aware, not 401 — a visitor gets the marketing backbone), wired the real Discovery Rails blob via a NEW shared two-tier reader `src/lib/discovery-rails/serve.ts` (`loadDiscoveryRailsBlob` + `getDiscoveryRailsKV`, also adopted by `/api/discovery/rails`), and added auth-varying caching (visitor `public,max-age=60`+`Vary:Cookie` / authed `private,no-store`). **Phase 4:** taught the client to render all 3 stream kinds via a `kind`-discriminated union + NEW `src/components/feed/SuggestionCard.tsx` entity card + a "caught up → discover" boundary card, and stopped filtering cards at the endpoint. **Phase 5:** recomposed Home (`/`) into the feed-leads marketing surface (removed hero/cards/FeedsHub/Recent-Activity/TriageStrip, kept nudges, mounted SmartFeed, auth-conditional chrome) + NEW `src/components/marketing/StickySignupBar.astro` (visitor-only) + `/feed` visitor→`/` redirect (middleware + page). **Phase 7:** browser-verified authed (member backbone + boundary card) and visitor (orienting line + sticky bar + marketing-only feed) against a local dev server; cold-start by unit test. Committed code `00bd8992` + docs `d03d4d0` mid-conv (this /r-end adds the doc-sync commit). Full baseline 6610/6610 + tsc/astro(0/0/0)/lint/build green at every phase. **Only Phase 6 (intent-preserving signup, shared with VISITOR-GATING) remains** on the block.

## Completed

- [x] [HOME-FEED-MERGE] Phase 3 — un-gate `/api/feeds/smart` (auth-aware) + shared rails reader `serve.ts` + visitor/authed caching + `tests/api/feeds/smart/index.test.ts` (4).
- [x] [HOME-FEED-MERGE] Phase 4 — `SmartFeed.tsx` kind-discriminated union + new `SuggestionCard.tsx` + boundary card; endpoint stops filtering cards.
- [x] [HOME-FEED-MERGE] Phase 5 — Home (`index.astro`) feed-leads recompose + new `StickySignupBar.astro` + `/feed` visitor→`/` (middleware + `feed.astro`) + `tests/middleware.test.ts` (88).
- [x] [HOME-FEED-MERGE] Phase 7 — browser-verified authed + visitor (cold-start by unit test); dev-server stale-cache (`jsxDEV`) restart was incidental, not a code defect.
- [x] Committed code `00bd8992` + docs `d03d4d0`; baseline 6610/6610 + all 5 gates green each phase.
- [x] Docs synced (this /r-end): `feeds.md`, `API-COMMUNITY.md`, `url-routing.md`, `TEST-COVERAGE.md`; architecture decision routed.

## Remaining

- [ ] [HOME-FEED-MERGE] #28 [Opus] **[NEXT]** — **Phase 6:** intent-preserving signup (signup accepts a post-signup destination/action — "sign up, then join X / take Y"); shared with `[VISITOR-GATING]` signup machinery; the home feed's sample-post CTAs are its first consumer. Then the deferred cosmetic polish: Matt `FeedPost` teaser restyle of sample-posts (still `DiscoveryCard`), visitor-aware SmartFeed copy/filter-tabs (member-oriented "From Teachers/Trending/Unseen" tabs show empty for a visitor), mobile sticky-bar refinement. SoT `plan/home-feed-merge/README.md`.
- [ ] [FEEDSHUB-ORPHAN] #37 — resolve orphaned `src/components/feed/FeedsHubPanel.tsx` (no consumer after the Phase-5 "Your Feeds" removal): delete or repurpose. Low priority; not deleted (directive removed it from Home, not the codebase).
- [ ] [PROMOTE-PIPELINE] #29 [Opus] — Steps 3–7 (3 Promote button + 4 templates+CommunityAnchor+composer gated on #28 Phase-4 ✅ now unblocked · 5 PROMO-LIFECYCLE · 6 ADMIN-FEED-UI · 7 PromoteNudge LAST).
- [ ] [ADMIN-FEED-UI] #30 [Opus] · [RECO-UNIFY] #31 [Opus] (removes orphaned `getDiscoveryCandidates`) · [PROMO-LIFECYCLE] #35 [Opus] — downstream PROMOTE-PIPELINE chain.
- [ ] [API-DISC-DOC] #33 — document `GET /api/discovery/rails` in a driftCheck API doc + `/api/discovery/*` entry in `.claude/scripts/route-mapping.txt`.
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
- [ ] #28 [HOME-FEED-MERGE] [Opus] [NEXT] (Phase 6) · #29 [PROMOTE-PIPELINE] [Opus] (Steps 3–7)
- [ ] #30 [ADMIN-FEED-UI] [Opus] · #31 [RECO-UNIFY] [Opus] · #32 [SYS-NAMING] · #33 [API-DISC-DOC] · #34 [DISC-SEED] · #35 [PROMO-LIFECYCLE] [Opus] · #36 [SYS-GET-GATE] · #37 [FEEDSHUB-ORPHAN]

## Key Context

- **Smart feed is now public/auth-aware.** `getSmartFeed(db, client, userId: string | null, { limit, before?, railsBlob? })` returns `{ activities: FeedItem[], nextCursor, pageSize }`. `FeedItem` = post (`kind: 'member-post' | 'sample-post'`, keeps `activity`/`isDiscovery`/`discoveryContext` for back-compat) ∪ `SuggestionCardItem` (`kind: 'suggestion-card'`). The endpoint `src/pages/api/feeds/smart/index.ts` is un-gated (visitor → marketing backbone), serves all 3 kinds, cache varies on session.
- **Shared rails reader:** `src/lib/discovery-rails/serve.ts` — `loadDiscoveryRailsBlob(db, kv?)` (two-tier KV-then-compute, kv as param for testability) + `getDiscoveryRailsKV()` (binding lookup). Both `/api/feeds/smart` and `/api/discovery/rails` consume it; a rails failure in the smart feed degrades to no-cards, never fails the feed.
- **Client render (`SmartFeed.tsx`):** `kind`-discriminated union + `isPostItem` guard; card branch checked FIRST (else a card crashes the post path). member-post → `FeedActivityCard` (interactive), sample-post → `DiscoveryCard`, suggestion-card → new `SuggestionCard`. Boundary card "caught up → discover" (→ `/feeds`) shows only when the stream has a `member-post`.
- **Phase 6 entry (NEXT):** intent-preserving signup — signup must accept a post-signup destination/action; the home feed sample-post CTAs (DiscoveryCard's Join/View) are the first consumer; shares `[VISITOR-GATING]` machinery (server-side done Conv 264). Matt `FeedPost` is display-only (can't be the member renderer — would regress reactions/comments); its teaser restyle of sample-posts is deferred cosmetic.
- **Browser-test note:** session cookie is HttpOnly — clear via `POST /api/auth/logout` (not `document.cookie`); restore via `POST /api/auth/dev-login {email}`. A stale Astro dev server throws `jsxDEV is not a function` on every page render (cure: restart + `rm -rf node_modules/.vite`); API routes stay unaffected, so diagnose by checking an unrelated page.
- **Baseline:** verified THIS conv — 6610/6610, tsc + astro check (0/0/0) + lint + build all green.
- Code committed `00bd8992`; docs `d03d4d0` + this /r-end's doc-sync commit.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.

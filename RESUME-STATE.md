# State — Conv 268 (2026-06-11 ~17:31)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Built **HOME-FEED-MERGE Phase 6 — intent-preserving signup**, completing all build phases (1–7) of the block. The home feed's discovery CTAs (sample-post + suggestion-card) now route a **visitor** through `/signup?redirect=<entity>` and return them to that exact course/community after signup; an **authed** viewer keeps the direct entity link. The branch lives **server-side** (in the freshly-built `ctaUrl`) via a NEW shared `src/lib/smart-feed/cta.ts` `buildDiscoveryCtaUrl` helper used by both ctaUrl sites — so the client cards stay dumb (no auth prop, no localStorage cache read, no [NUDGE-CACHE-FLASH] class). Key finding: the signup `?redirect=` round-trip machinery already existed (`signup.astro` → `AutoOpenAuthModal` → `handleAuthSuccess`; `EnrollButton` already used it), so Phase 6 was just making the feed CTAs consume the proven pattern. Scope = destination-level ("return them to X"), NOT action-level auto-perform (Stripe-enroll auto-redirect would be hostile). Browser-verified both auth states (DOM-truth) + the signup round-trip target. Suite 6618/6618, all 5 gates green. Committed code `5b299ecb` + docs `ff1fd20` (this /r-end adds the doc-sync commit).

## Completed

- [x] [HOME-FEED-MERGE] Phase 6 — intent-preserving signup: home-feed discovery CTAs route visitors through `/signup?redirect=<entity>`; authed unchanged. NEW `src/lib/smart-feed/cta.ts` shared helper; threaded `viewerAuthenticated = Boolean(userId)` into `cardToItem` (index.ts) + `enrichCandidates`/`toEnrichedCandidate` (enrichment.ts).
- [x] Tests: NEW `tests/lib/smart-feed-cta.test.ts` (6) + 2 orchestrator tests; existing card-injection visitor assertion updated. Suite **6618/6618** (+8); tsc + astro (0/0/0) + lint + build all green THIS conv.
- [x] Browser-verified (DOM-truth, local `:4321`): visitor → all 13 CTAs are signup links, modal carries the exact-entity redirect; authed → direct entity links, no signup links.
- [x] Committed code `5b299ecb` + docs `ff1fd20`; docs synced (this /r-end): `feeds.md`, `API-COMMUNITY.md`, `TEST-COVERAGE.md`; architecture decision routed to `docs/decisions/01-architecture.md`.

## Remaining

- [ ] [HOME-FEED-MERGE] #28 — block build-complete; only **NON-core** remnants left: (a) deferred **cosmetic polish** — Matt `FeedPost` teaser restyle of sample-posts (still `DiscoveryCard`), visitor-aware SmartFeed copy + filter-tabs (member-oriented "From Teachers/Trending/Unseen" tabs render empty for a visitor), mobile sticky-bar refinement; (b) the distinct **[VISITOR-GATING] authed "Join to participate" 403-CTA** — needs an architecture call now that Phase 4 kept `FeedActivityCard` (not display-only `FeedPost`) as the interactive member renderer. SoT `plan/home-feed-merge/README.md`.
- [ ] [TW-V4] #38 — review 2 pre-existing Tailwind v3→v4 candidates (`StickySignupBar.astro:26` `backdrop-blur-sm`, `SuggestionCard.tsx:111` `flex-shrink-0`; Conv 267 Phase 4/5). May be false positives.
- [ ] [PROMOTE-PIPELINE] #29 [Opus] — Steps 3–7 NOW UNBLOCKED by Phase 6/Phase-4: Step 3 Promote button + Step 4 templates+CommunityAnchor+composer · 5 PROMO-LIFECYCLE · 6 ADMIN-FEED-UI · 7 PromoteNudge LAST.
- [ ] [ADMIN-FEED-UI] #30 [Opus] · [RECO-UNIFY] #31 [Opus] (removes orphaned `getDiscoveryCandidates`) · [PROMO-LIFECYCLE] #35 [Opus] — downstream PROMOTE-PIPELINE chain.
- [ ] [API-DISC-DOC] #33 — document `GET /api/discovery/rails` in a driftCheck API doc + `/api/discovery/*` entry in `.claude/scripts/route-mapping.txt`. (Re-surfaced by Conv-268 docs agent; pre-existing Conv-261 gap.)
- [ ] [SYS-NAMING] #32 · [DISC-SEED] #34 · [SYS-GET-GATE] #36 (townhall comments GET still auth-only, low risk) · [FEEDSHUB-ORPHAN] #37 (orphaned `FeedsHubPanel.tsx`).
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
- [ ] #28 [HOME-FEED-MERGE] [Opus] (Phase 6 CORE done; polish + VG-CTA remain) · #29 [PROMOTE-PIPELINE] [Opus] (Steps 3–7, unblocked)
- [ ] #30 [ADMIN-FEED-UI] [Opus] · #31 [RECO-UNIFY] [Opus] · #32 [SYS-NAMING] · #33 [API-DISC-DOC] · #34 [DISC-SEED] · #35 [PROMO-LIFECYCLE] [Opus] · #36 [SYS-GET-GATE] · #37 [FEEDSHUB-ORPHAN] · #38 [TW-V4]

## Key Context

- **Intent-preserving CTA = server-side branch.** `src/lib/smart-feed/cta.ts` `buildDiscoveryCtaUrl(feedType, feedId, via, viewerAuthenticated)`: authed → `/course/:slug?via=…` | `/community/:slug?via=…`; visitor → `/signup?redirect=<encodeURIComponent(entityPath)>` (the `?via=` tracking lives INSIDE the redirect target). Used by BOTH ctaUrl sites — `cardToItem` (index.ts, `via=home-discovery`) + the `discoveryContext` builder (enrichment.ts, `via=smart-feed-discovery`) — so they can't drift.
- **`enrichCandidates` signature changed:** now `(client, scored, params, db?, viewerAuthenticated = false)`; `toEnrichedCandidate` gained `viewerAuthenticated` after `params`. Default `false` = visitor (fail-safe). Single production caller is `getSmartFeed` (index.ts), which passes `Boolean(userId)`.
- **CTA label unchanged for visitors** ("Join Community"/"View Course") — the label carries intent, honesty comes from the "from X · not joined" framing. No client component edit was needed (DiscoveryCard/SuggestionCard render `ctaUrl` verbatim).
- **Caching unaffected:** the visitor ctaUrl is identical for all logged-out viewers → the Phase-3 `public, max-age=60` + `Vary: Cookie` visitor branch stays cacheable; the authed direct-entity ctaUrl only rides `private, no-store`.
- **Action-level intent deliberately NOT built** (deferred): auto-join/auto-enroll after signup is asymmetric (course enroll → Stripe checkout; auto-redirecting a fresh signup to payment is hostile). The authed "one-click join/enroll from discovery" (design line 85) is its own future enhancement.
- **The two block remnants are NON-core:** cosmetic polish (rote) + the VISITOR-GATING authed "Join to participate" 403-CTA (an architecture call — where it lives is open now that Phase 4 kept `FeedActivityCard`, not `FeedPost`, as the interactive member renderer; `FeedPost` is display-only).
- **Baseline:** verified THIS conv — 6618/6618, tsc + astro check (0/0/0) + lint + build all green.
- Code committed `5b299ecb`; docs `ff1fd20` + this /r-end's doc-sync commit (will be committed in Step 6).

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.

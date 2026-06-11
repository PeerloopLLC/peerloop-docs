# State — Conv 269 (2026-06-11 ~19:31)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Built **PROMOTE-PIPELINE Step 3 — the Promote button** (escalate-existing-post entry point), the next unblocked piece of the HOME-FEED-MERGE epic. Decided (user) the promote endpoint **resolves posts by Stream activity id** (`{ streamActivityId, password }`, `WHERE stream_activity_id = ?`) rather than the FK `feed_activities.id` — matching the system-wide client identity model and scaling free to future promote surfaces; made promotion **idempotent** (2 UNIQUE schema indexes + an early-return). Browser verification caught that the live **course feed mounts `MattCourseFeed`→Matt `SocialPost`, not the legacy `CourseFeed`/`FeedActivityCard`** I first edited — so extracted a shared `PromoteButton` and wired it onto BOTH live renderers (community via FeedActivityCard, course via a new `SocialPost.actions` slot). Verified end-to-end on both feeds (post→Promote→password→"Promoted", one D1 row each). All 5 gates green (6626/6626). Steps 4–7 remain.

## Completed

- [x] [PROMOTE-PIPELINE] #29 **Step 3 (Promote button)** — endpoint Stream-id contract (A) + idempotent early-return; `migrations/0001_schema.sql` +2 UNIQUE indexes (`idx_feed_activities_stream`, `idx_post_promotions_unique`); shared `src/components/feed/PromoteButton.tsx`; `FormModal` password field; `SocialPost.actions` slot; wired on `FeedActivityCard` (community) + `MattCourseFeed` (course); NEW `tests/api/feeds/promote.test.ts` (8); browser-verified both feeds; 5 gates green (6626/6626). Docs synced (API-COMMUNITY, TEST-COVERAGE, feeds.md).

## Remaining

- [ ] [PROMOTE-PIPELINE] #29 [Opus] — **Steps 4–7** (Step 3 done): 4 templates (entity-promo content-type + `CommunityAnchor` + render + seed + composer, *needs #28*) · 5 PROMO-LIFECYCLE · 6 ADMIN-FEED-UI · 7 PromoteNudge LAST. SoT `plan/home-feed-merge/README.md` § Build sequence.
- [ ] [PROMO-LIFECYCLE] #35 [Opus] — active 14d + D1 retention 60d, cron purge (`workers/cron/`) + platform_stats dials + admin UI (the next PROMOTE unit **independent of #28**).
- [ ] [HOME-FEED-MERGE] #28 [Opus] — non-core remnants: cosmetic polish (FeedPost teaser restyle · visitor-aware copy/tabs · mobile sticky-bar) + the `[VISITOR-GATING]` authed "Join to participate" 403-CTA (architecture call; gates PROMOTE Step 4 composer).
- [ ] [ADMIN-FEED-UI] #30 [Opus] — Announcement model + fan-out + promotion-password admin UI + duration dials + System-promotion takedown view.
- [ ] [RECO-UNIFY] #31 [Opus] — unify reco bands onto Discovery Rails + Promoted lane (removes orphaned `getDiscoveryCandidates`).
- [ ] [ROLE-STUDIOS] #1 — ⛔ BLOCKED BY CLIENT (old-vs-new dashboard comparison sign-off).
- [ ] [RTMIG-4] #2 [Opus] · [ENTITY-ANCHOR] #3 [Opus] · [SSR-LOADER-DEAD] #4
- [ ] [COMM-TAG-FILTER] #5 · [CT-RESTYLE] #6 · [PRIM-MATCH-INDEX] #7 · [TXTBTN] #8 (watch) · [PROFILE-PRIM-SWEEP] #9 (PAUSED)
- [ ] [ICN-NS] #10 · [E2E-MIG] #11 · [E2E-GATE] #12 · [SHOWMORE] #13 · [PREFLIP-WT] #14 (KEEP until client-vet)
- [ ] [TZ-AUDIT] #15 [Opus] · [SUCCESS-COMMUNITY-VERIFY] #16 · [MEM-CAP] #17 (MEMORY.md ~87% byte cap → /r-prune-memory) · [DOCGEN-SPEC] #18 · [OLD-PORTED-CLEANUP] #19
- [ ] [LEARN-ISLAND-RESTYLE] #20 · [CREATE-ISLAND-RESTYLE] #21 · [TEACH-ISLAND-RESTYLE] #22 · [TRIAGE-RESTYLE] #23
- [ ] [V217-WATCH] #24 · [COURSEDETAIL-DEAD] #25 · [NUDGE-CACHE-FLASH] #26 · [NUDGE-TC-V2] #27
- [ ] [SYS-NAMING] #32 · [API-DISC-DOC] #33 (also covers the `/api/discovery/rails` doc gap re-flagged this conv) · [DISC-SEED] #34 · [SYS-GET-GATE] #36 · [FEEDSHUB-ORPHAN] #37 · [TW-V4] #38

## TodoWrite Items

- [ ] #1 [ROLE-STUDIOS] (BLOCKED) · #2 [RTMIG-4] [Opus] · #3 [ENTITY-ANCHOR] [Opus] · #4 [SSR-LOADER-DEAD]
- [ ] #5 [COMM-TAG-FILTER] · #6 [CT-RESTYLE] · #7 [PRIM-MATCH-INDEX] · #8 [TXTBTN] · #9 [PROFILE-PRIM-SWEEP]
- [ ] #10 [ICN-NS] · #11 [E2E-MIG] · #12 [E2E-GATE] · #13 [SHOWMORE] · #14 [PREFLIP-WT]
- [ ] #15 [TZ-AUDIT] [Opus] · #16 [SUCCESS-COMMUNITY-VERIFY] · #17 [MEM-CAP] · #18 [DOCGEN-SPEC] · #19 [OLD-PORTED-CLEANUP]
- [ ] #20 [LEARN-ISLAND-RESTYLE] · #21 [CREATE-ISLAND-RESTYLE] · #22 [TEACH-ISLAND-RESTYLE] · #23 [TRIAGE-RESTYLE]
- [ ] #24 [V217-WATCH] · #25 [COURSEDETAIL-DEAD] · #26 [NUDGE-CACHE-FLASH] · #27 [NUDGE-TC-V2]
- [ ] #28 [HOME-FEED-MERGE] [Opus] · #29 [PROMOTE-PIPELINE] [Opus] (Step 3 DONE; Steps 4–7 remain)
- [ ] #30 [ADMIN-FEED-UI] [Opus] · #31 [RECO-UNIFY] [Opus] · #32 [SYS-NAMING] · #33 [API-DISC-DOC] · #34 [DISC-SEED] · #35 [PROMO-LIFECYCLE] [Opus] · #36 [SYS-GET-GATE] · #37 [FEEDSHUB-ORPHAN] · #38 [TW-V4]

## Key Context

- **PROMOTE-PIPELINE Step 3 DONE + verified.** The Promote button is live on both feed surfaces. Endpoint `POST /api/feeds/promote` now takes `{ streamActivityId, password }` (resolves the row via `stream_activity_id`, UNIQUE-indexed) and is **idempotent** (`{ alreadyPromoted: true }` on re-promote; UNIQUE `(source_activity_id,to_feed_type,to_feed_id)` backstop). Internal FK / `recordPromotion` / lane unchanged (still `feed_activities.id`).
- **Two live feed renderers — remember this for Steps 4/7:** community feed = `CommunityFeed`→`FeedActivityCard` (legacy island); course feed = `MattCourseFeed`→Matt `SocialPost` (the @matt-source redesign). The legacy `CourseFeed.tsx` is NO LONGER the live course renderer (edited for consistency only). Shared `src/components/feed/PromoteButton.tsx` is the single home for the password modal + POST.
- **🟠 Seed-data caveat:** dev seed `feed_activities.stream_activity_id` are placeholders (`stream-fa-NNN`) that never match the real Stream ids the live feed returns → the Promote button 404s on **seed** posts. Posts created through the app promote correctly (verified). A seed-fidelity fix (real-shaped stream ids) would unblock seeded-post promotion — could fold into [DISC-SEED] #34 or a new seed task.
- **Next PROMOTE unit independent of #28 = Step 5 / [PROMO-LIFECYCLE] #35** (cron + dials). Step 4 (templates/composer) needs [HOME-FEED-MERGE] #28's phase-4 composer.
- **Promotion gate password is set in LOCAL D1 only** (`promote123`, for this conv's verification) — ephemeral, reset by `db:setup:local:dev`. Not in staging/prod.
- **Baseline verified THIS conv:** tsc 0 · astro 0/0/0 · lint clean · suite **6626/6626** (387 files) · build ✓.
- Code + docs commit lands at this /r-end (Step 6). Counter started at Conv 268 (M4Pro ran 264–268; HOME-FEED-MERGE Phases 1–7 shipped there).

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.

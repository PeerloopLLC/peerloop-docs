# State — Conv 015 (2026-03-19 ~15:05)

**Conv:** 015
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-8`, docs: `main`

## Summary

Conv 015 completed CURRENTUSER-OPTIMIZE Phase 5, FEEDS-HUB PAGE+NAVIGATION, and FEED-INTEL Phase 1 (D1 activity index for badge counts). Six follow-up items remain — mostly verification, cleanup, and test coverage gaps.

## Completed

- CURRENTUSER-OPTIMIZE Phase 5: MyFeeds card, FeedSlidePanel refactor (2 API calls → 0), placed on 3 dashboards
- FEEDS-HUB PAGE: `/feeds` page with FeedsHub component (The Commons, communities, courses, search)
- FEEDS-HUB NAVIGATION: Navbar "My Feeds" → `/feeds` link, MyFeeds "See All" → `/feeds`, community hub cross-link
- FEED-INTEL Phase 1: `feed_visits` + `feed_activities` D1 tables, dual-write in 3 post endpoints, visit recording on feed GET, `GET /api/me/feed-badges` endpoint, badge UI on FeedsHub + MyFeeds
- 11 integration tests (feed-activity.test.ts), 10 E2E tests (feeds-hub + my-feeds-card)
- CURRENTUSER-OPTIMIZE moved to COMPLETED_PLAN.md (#43)
- FEED-INTEL block created in PLAN.md with full CQRS design

## Remaining

### Critical — Verify Before Shipping
- [ ] Verify `VALUES` SQL syntax in `getFeedBadgeCounts()` works with D1's SQLite version — `(fa.feed_type, fa.feed_id) IN (VALUES (?, ?), ...)` requires SQLite 3.38+. Unit tests pass on better-sqlite3 but D1 may differ. File: `src/lib/feed-activity.ts:87`

### Follow-up — FEED-INTEL Gaps
- [ ] Add comment/reply dual-write to `feed_activities` — comment endpoints (`community/[slug]/comments.ts`, `townhall/comments.ts`) lack feed slug context. Only top-level posts generate badges currently.
- [ ] Write API integration test for `GET /api/me/feed-badges` — unit tests cover D1 functions but no HTTP-level test with auth
- [ ] E2E test for badge count display — requires posting to feed via API, then verifying badge appears on `/feeds` page

### Cleanup
- [ ] Delete or archive orphaned `FeedSlidePanel.tsx` — nothing imports it since navbar changed to `/feeds` link. File: `src/components/layout/FeedSlidePanel.tsx`
- [ ] Configure 90-day pruning cron for `feed_activities` — `wrangler.toml` cron trigger + `DELETE FROM feed_activities WHERE created_at < datetime('now', '-90 days')`

## TodoWrite Items

- [ ] Verify VALUES SQL syntax works with D1's SQLite version — CRITICAL: getFeedBadgeCounts() uses `IN (VALUES ...)` syntax
- [ ] Add comment/reply dual-write to feed_activities — comment endpoints lack feed slug context
- [ ] Write API integration test for /api/me/feed-badges — no HTTP-level test exists
- [ ] Delete or archive orphaned FeedSlidePanel.tsx — nothing imports it
- [ ] Configure 90-day pruning cron for feed_activities — wrangler.toml + cron handler
- [ ] E2E test for badge count display on /feeds page — requires posting + verifying badge

## Key Context

- **CQRS architecture:** Stream.io stores content (posts, reactions, comments). D1 `feed_activities` stores metadata index (~150 bytes/row). `feed_visits` tracks last-visited timestamps. Badge counts via single D1 LEFT JOIN query — zero Stream API calls.
- **Dual-write is fire-and-forget:** `indexFeedActivity()` catches errors silently — a failed INSERT means a badge count is off by one, not a broken feature. The D1 index is rebuildable from Stream.
- **Visit recording only on offset=0:** Feed GET endpoints record visits only on first page load (not pagination scroll). This prevents every scroll-triggered fetch from resetting the badge.
- **FeedSlidePanel orphaned intentionally:** File retained in case a future decision brings back the slideout (e.g., keyboard shortcut). Can be safely deleted.
- **Stream.io limitation:** Flat feeds have NO unread/unseen tracking. Only notification feeds support it. This was the key discovery that drove the CQRS approach.

## Resume Command

To continue: run `/r-resume`, which will consolidate state and present a unified view.

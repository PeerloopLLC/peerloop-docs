---
name: CURRENTUSER-OPTIMIZE block context
description: Version polling, redundancy elimination, community memberships + feed index — ALL 5 PHASES COMPLETE (Conv 013-015)
type: project
---

CURRENTUSER-OPTIMIZE block — version polling for CurrentUser freshness, eliminate redundant dashboard API calls, add community memberships + feed index. **ALL 5 PHASES COMPLETE.**

**Why:** Dashboard components re-fetched 60-95% of data CurrentUser already had. But eliminating those calls required solving staleness first — dashboards were acting as the freshness mechanism.

**Phase 1 DONE (Conv 013):** Version polling infrastructure — `data_version` column, `bumpUserDataVersion()`, 31 mutation bumps, client 30s polling, 7 integration + 14 E2E tests.

**Phase 2 DONE (Conv 014):** Enriched `UserEnrollment` with `hasReview`, `courseDuration`, `courseSessionCount`. Refactored `StudentDashboard` to use `useCurrentUser()` instead of `fetch('/api/me/enrollments')`. 4 new API tests + 27 component tests rewritten.

**Phase 3 DONE (Conv 014):** Added `community_count` to `/api/me/creator-dashboard` stats. Removed separate `fetch('/api/me/communities')` from `CreatorDashboard`. 1 new API assertion.

**Phase 4 DONE (Conv 014):** Added `UserCommunityMembership` type, `fetchCommunityMemberships` query in `/api/me/full`, `getCommunityMemberships()`, `isMemberOf()`, `getTownhall()` methods. Added `discussionFeedEnabled` to `CourseMetadata` (all 3 course relationship types + queries). Built `UserFeedLink` type + `getFeeds()` method (townhall → communities → course feeds with dedup). 6 API integration + 14 unit tests. E2E updated for 5 seed users.

**Phase 5 DONE (Conv 015):** `MyFeeds` dashboard card component using `getFeeds()` — townhall pinned, communities/courses grouped, MAX_VISIBLE=3 with "+N more". Placed on Student/Teacher/Creator dashboards. FeedSlidePanel refactored from 2 API calls (`/api/communities` + `/api/me/enrollments`) to `useCurrentUser().getFeeds()` — zero fetches, instant open. 4 E2E tests. All 5930 Vitest + 18 E2E tests passing.

**FEEDS-HUB block (READY — unblocked by Phase 5 completion):** Client expects feeds = 50% of learning. Composite `/feeds` page needed as a primary destination. See PLAN.md and `project_feeds_hub.md`.

**Test counts:** Conv 015 ended with 5930 Vitest tests passing, 0 failures.

**Key files added/modified in Conv 015:**
- `src/components/dashboard/MyFeeds.tsx` — NEW (MyFeeds card)
- `src/components/layout/FeedSlidePanel.tsx` — refactored (eliminated 2 API calls)
- `src/components/dashboard/StudentDashboard.tsx` — added MyFeeds
- `src/components/dashboard/TeacherDashboard.tsx` — added MyFeeds
- `src/components/dashboard/CreatorDashboard.tsx` — added MyFeeds
- `tests/pages/dashboard/StudentDashboard.test.tsx` — added getFeeds to mock
- `e2e/my-feeds-card.spec.ts` — NEW (4 E2E tests)

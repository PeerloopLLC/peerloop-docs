# Test Coverage

Index of all test files organized by category. For testing commands, see [CLI-TESTING.md](CLI-TESTING.md).

**Last Updated:** 2026-03-31 (Conv 064 — PLATO Phase 3 atomic runs + Phase 4 seed scenario)

---

## Quick Reference

| Document | Location | Description |
|----------|----------|-------------|
| [TEST-COMPONENTS.md](TEST-COMPONENTS.md) | `tests/components/` | React component tests |
| [TEST-PAGES.md](TEST-PAGES.md) | `tests/pages/` | Page-level tests |
| [TEST-UNIT.md](TEST-UNIT.md) | `tests/lib/`, `tests/unit/`, `tests/integration/`, `tests/ssr/` | Lib, unit, integration, SSR tests |
| [TEST-E2E.md](TEST-E2E.md) | `e2e/` | Playwright E2E tests (flows, setup, patterns) |

---

## Test Runners

| Runner | Command | Purpose |
|--------|---------|---------|
| Vitest | `npm run test` | Unit, component, API, integration tests |
| Playwright | `npm run test:e2e` | End-to-end tests |

---

## Summary

| Category | Files | Test Cases | Location |
|----------|:-----:|:----------:|----------|
| API Endpoints | 226 | — | `tests/api/` |
| Components | 87 | — | `tests/components/` |
| Pages | 14 | — | `tests/pages/` |
| Lib | 11 | — | `tests/lib/` |
| Integration | 9 | — | `tests/integration/` |
| SSR | 3 | — | `tests/ssr/` |
| Unit | 12 | — | `tests/unit/` |
| Middleware | 1 | — | `tests/` (root) |
| PLATO | 1 | — | `tests/plato/` |
| E2E (Playwright) | 30 | — | `e2e/` |
| **Vitest Total** | **363** | — | |
| **All Test Files** | **393** | — | |

---

## Test Infrastructure

| File | Purpose |
|------|---------|
| `tests/helpers/index.ts` | Test utilities (describeWithTestDB, describeWithBBB, getTestDB, seedCoreTestDB) |
| `tests/helpers/bbb.ts` | BBB credential loader + test client (canUseBBB, getBBBTestClient) |
| `tests/helpers/dates.ts` | UTC-safe date helpers (utcDate, futureUTC, pastUTC, nextDayOfWeekUTC, toDateStringUTC) |
| `tests/helpers/mock-astro-middleware.ts` | Mock for `astro:middleware` (aliased in vitest.config.ts) |
| `tests/helpers/mock-astro-navigate.ts` | Mock for `astro:transitions/client` (aliased in vitest.config.ts) |
| `tests/api/helpers/index.ts` | API context helpers (createAPIContext, createMockRequest) |
| `vitest.config.ts` | Vitest configuration with path aliases |
| `vitest.global-setup.ts` | Global test setup (database initialization) |
| `vitest.setup.ts` | Per-file test setup |
| `playwright.config.ts` | Playwright configuration |
| `e2e/helpers.ts` | E2E shared helpers (login, mockFeedApi) |
| `e2e/fixtures/mock-feed-data.ts` | Mock Stream.io feed responses for Playwright route interception |

### Path Aliases

Test files use path aliases instead of deep relative imports:

| Alias | Resolves To |
|-------|-------------|
| `@/` | `src/` |
| `@api-helpers` | `tests/api/helpers` |
| `@test-helpers` | `tests/helpers` |

---

## API Tests — `tests/api/` (220 files)

Tests mirror the API route structure with 1:1 file mapping:

```
tests/api/
├── resource/
│   ├── index.test.ts        # GET/POST collection
│   └── [id]/
│       ├── index.test.ts    # GET/PATCH/DELETE item
│       └── action.test.ts   # POST action endpoints
```

### Admin — `tests/api/admin/` (65 files)

| Area | File | Tests |
|------|------|:-----:|
| Dashboard | `tests/api/admin/dashboard.test.ts` | 30 |
| **Analytics** | | |
| | `tests/api/admin/analytics/index.test.ts` | 12 |
| | `tests/api/admin/analytics/courses.test.ts` | 5 |
| | `tests/api/admin/analytics/engagement.test.ts` | 5 |
| | `tests/api/admin/analytics/revenue.test.ts` | 5 |
| | `tests/api/admin/analytics/teachers.test.ts` | 5 |
| | `tests/api/admin/analytics/users.test.ts` | 5 |
| **Topics** (admin) | | |
| | `tests/api/admin/topics/index.test.ts` | 15 |
| | `tests/api/admin/topics/[id]/index.test.ts` | 10 |
| | `tests/api/admin/topics/reorder.test.ts` | 7 |
| **Certificates** | | |
| | `tests/api/admin/certificates/index.test.ts` | 24 |
| | `tests/api/admin/certificates/[id]/index.test.ts` | 5 |
| | `tests/api/admin/certificates/[id]/approve.test.ts` | 6 |
| | `tests/api/admin/certificates/[id]/reject.test.ts` | 6 |
| | `tests/api/admin/certificates/[id]/revoke.test.ts` | 7 |
| **Courses** | | |
| | `tests/api/admin/courses/index.test.ts` | 43 |
| | `tests/api/admin/courses/[id]/index.test.ts` | 19 |
| | `tests/api/admin/courses/[id]/badge.test.ts` | 12 |
| | `tests/api/admin/courses/[id]/feature.test.ts` | 5 |
| | `tests/api/admin/courses/[id]/suspend.test.ts` | 8 |
| | `tests/api/admin/courses/[id]/unsuspend.test.ts` | 8 |
| **Creator Applications** | | |
| | `tests/api/admin/creator-applications/index.test.ts` | 15 |
| | `tests/api/admin/creator-applications/[id].test.ts` | 5 |
| | `tests/api/admin/creator-applications/[id]/approve.test.ts` | 9 |
| | `tests/api/admin/creator-applications/[id]/deny.test.ts` | 8 |
| **Enrollments** | | |
| | `tests/api/admin/enrollments/index.test.ts` | 46 |
| | `tests/api/admin/enrollments/[id]/index.test.ts` | 29 |
| | `tests/api/admin/enrollments/[id]/cancel.test.ts` | 9 |
| | `tests/api/admin/enrollments/[id]/force-complete.test.ts` | 10 |
| | `tests/api/admin/enrollments/[id]/reassign-teacher.test.ts` | 10 |
| | `tests/api/admin/enrollments/[id]/refund.test.ts` | 14 |
| **Moderation** | | |
| | `tests/api/admin/moderation/index.test.ts` | 19 |
| | `tests/api/admin/moderation/[id]/index.test.ts` | 9 |
| | `tests/api/admin/moderation/[id]/dismiss.test.ts` | 10 |
| | `tests/api/admin/moderation/[id]/remove.test.ts` | 10 |
| | `tests/api/admin/moderation/[id]/suspend.test.ts` | 12 |
| | `tests/api/admin/moderation/[id]/warn.test.ts` | 9 |
| **Moderators** | | |
| | `tests/api/admin/moderators/index.test.ts` | 15 |
| | `tests/api/admin/moderators/invite.test.ts` | 17 |
| | `tests/api/admin/moderators/[id]/remove.test.ts` | 8 |
| | `tests/api/admin/moderators/[id]/resend.test.ts` | 12 |
| | `tests/api/admin/moderators/[id]/revoke.test.ts` | 9 |
| **Payouts** | | |
| | `tests/api/admin/payouts/index.test.ts` | 35 |
| | `tests/api/admin/payouts/batch.test.ts` | 10 |
| | `tests/api/admin/payouts/pending.test.ts` | 11 |
| | `tests/api/admin/payouts/[id]/index.test.ts` | 10 |
| | `tests/api/admin/payouts/[id]/process.test.ts` | 14 |
| | `tests/api/admin/payouts/[id]/retry.test.ts` | 10 |
| **Sessions** | | |
| | `tests/api/admin/sessions/index.test.ts` | 23 |
| | `tests/api/admin/sessions/[id]/index.test.ts` | 21 |
| | `tests/api/admin/sessions/[id]/recording.test.ts` | 15 |
| | `tests/api/admin/sessions/[id]/resolve.test.ts` | 13 |
| | `tests/api/admin/sessions/cleanup.test.ts` | 11 |
| **Teachers** | | |
| | `tests/api/admin/teachers/index.test.ts` | 35 |
| | `tests/api/admin/teachers/[id]/index.test.ts` | 30 |
| | `tests/api/admin/teachers/[id]/activate.test.ts` | 8 |
| | `tests/api/admin/teachers/[id]/deactivate.test.ts` | 9 |
| **Users** | | |
| | `tests/api/admin/users/index.test.ts` | 53 |
| | `tests/api/admin/users/[id]/index.test.ts` | 29 |
| | `tests/api/admin/users/[id]/suspend.test.ts` | 10 |
| | `tests/api/admin/users/[id]/unsuspend.test.ts` | 9 |
| **Intel** | | |
| | `tests/api/admin/intel/course/[id].test.ts` | — |
| | `tests/api/admin/intel/community/[id].test.ts` | — |
| | `tests/api/admin/intel/user/[id].test.ts` | — |
| | `tests/api/admin/intel/communities-batch.test.ts` | 6 |
| | `tests/api/admin/intel/courses-batch.test.ts` | 6 |
| | `tests/api/admin/intel/dashboard-intel.test.ts` | 3 |

### Auth — `tests/api/auth/` (9 files)

| File | Tests |
|------|:-----:|
| `tests/api/auth/login.test.ts` | 14 |
| `tests/api/auth/logout.test.ts` | 4 |
| `tests/api/auth/register.test.ts` | 28 |
| `tests/api/auth/reset-password.test.ts` | 8 |
| `tests/api/auth/session.test.ts` | 10 |
| `tests/api/auth/github/index.test.ts` | 12 |
| `tests/api/auth/github/callback.test.ts` | 10 |
| `tests/api/auth/google/index.test.ts` | 17 |
| `tests/api/auth/google/callback.test.ts` | 12 |

### Checkout — `tests/api/checkout/` (1 file)

| File | Tests |
|------|:-----:|
| `tests/api/checkout/create-session.test.ts` | 13 |

### Communities — `tests/api/communities/` (6 files)

| File | Tests |
|------|:-----:|
| `tests/api/communities/index.test.ts` | 11 |
| `tests/api/communities/[slug]/index.test.ts` | 14 |
| `tests/api/communities/[slug]/join.test.ts` | 15 |
| `tests/api/communities/[slug]/progressions.test.ts` | 11 |
| `tests/api/communities/[slug]/moderators/index.test.ts` | 16 |
| `tests/api/communities/[slug]/moderators/[userId].test.ts` | 7 |

### Conversations — `tests/api/conversations/` (4 files)

| File | Tests |
|------|:-----:|
| `tests/api/conversations/index.test.ts` | 14 |
| `tests/api/conversations/[id]/index.test.ts` | 11 |
| `tests/api/conversations/[id]/messages.test.ts` | 11 |
| `tests/api/conversations/[id]/read.test.ts` | 7 |

### Courses — `tests/api/courses/` (8 files)

| File | Tests |
|------|:-----:|
| `tests/api/courses/index.test.ts` | 22 |
| `tests/api/courses/[slug].test.ts` | 15 |
| `tests/api/courses/[slug]/discussion-feed.test.ts` | 19 |
| `tests/api/courses/[id]/curriculum.test.ts` | 9 |
| `tests/api/courses/[id]/homework.test.ts` | 12 |
| `tests/api/courses/[id]/resources.test.ts` | 11 |
| `tests/api/courses/[id]/reviews.test.ts` | 11 |
| `tests/api/courses/[id]/sessions.test.ts` | 12 |

### Creators — `tests/api/creators/` (4 files)

| File | Tests |
|------|:-----:|
| `tests/api/creators/index.test.ts` | 15 |
| `tests/api/creators/apply.test.ts` | 20 |
| `tests/api/creators/[handle].test.ts` | 10 |
| `tests/api/creators/[id]/courses.test.ts` | 13 |

### Enrollments — `tests/api/enrollments/` (5 files)

| File | Tests |
|------|:-----:|
| `tests/api/enrollments/index.test.ts` | 13 |
| `tests/api/enrollments/[id]/course-review.test.ts` | 24 |
| `tests/api/enrollments/[id]/expectations.test.ts` | 35 |
| `tests/api/enrollments/[id]/progress.test.ts` | 18 |
| `tests/api/enrollments/[id]/review.test.ts` | 20 |

### Feeds — `tests/api/feeds/` (10 files)

| File | Tests |
|------|:-----:|
| `tests/api/feeds/timeline.test.ts` | 8 |
| `tests/api/feeds/townhall.test.ts` | 13 |
| `tests/api/feeds/townhall/comments.test.ts` | 20 |
| `tests/api/feeds/townhall/reactions.test.ts` | 15 |
| `tests/api/feeds/course/[slug].test.ts` | 23 |
| `tests/api/feeds/community/[slug]/index.test.ts` | 14 |
| `tests/api/feeds/community/[slug]/comments.test.ts` | 15 |
| `tests/api/feeds/smart/dismiss.test.ts` | 7 |
| `tests/api/feeds/community/[slug]/reactions.test.ts` | 12 |
| `tests/api/feeds/discover.test.ts` | 7 |

### Health — `tests/api/health/` (3 files)

| File | Tests |
|------|:-----:|
| `tests/api/health/db.test.ts` | 5 |
| `tests/api/health/kv.test.ts` | 5 |
| `tests/api/health/r2.test.ts` | 7 |

### Homework — `tests/api/homework/` (5 files)

| File | Tests |
|------|:-----:|
| `tests/api/homework/[id]/index.test.ts` | 8 |
| `tests/api/homework/[id]/submit.test.ts` | 11 |
| `tests/api/homework/[id]/submissions/index.test.ts` | 9 |
| `tests/api/homework/[id]/submissions/me.test.ts` | 9 |
| `tests/api/homework/[id]/submissions/[subId].test.ts` | 13 |

### Me — `tests/api/me/` (60 files)

| Area | File | Tests |
|------|------|:-----:|
| **Profile/Account** | | |
| | `tests/api/me/account.test.ts` | 12 |
| | `tests/api/me/full.test.ts` | 25 |
| | `tests/api/me/version.test.ts` | 7 |
| | `tests/api/me/feed-badges.test.ts` | 7 |
| | `tests/api/me/onboarding-profile.test.ts` | 11 |
| | `tests/api/me/profile.test.ts` | 30 |
| | `tests/api/me/settings.test.ts` | 21 |
| **Enrollments/Certificates** | | |
| | `tests/api/me/certificates.test.ts` | 7 |
| | `tests/api/me/certificates/recommend.test.ts` | 13 |
| | `tests/api/me/enrollments.test.ts` | 18 |
| **Teacher** | | |
| | `tests/api/me/availability.test.ts` | 22 |
| | `tests/api/me/availability/overrides.test.ts` | 16 |
| | `tests/api/me/availability/overrides/[id].test.ts` | 6 |
| | `tests/api/me/teacher-dashboard.test.ts` | 12 |
| | `tests/api/me/teacher-earnings.test.ts` | 14 |
| | `tests/api/me/teacher-sessions.test.ts` | 15 |
| | `tests/api/me/teacher-students.test.ts` | 16 |
| | `tests/api/me/teacher/[courseId]/toggle.test.ts` | 9 |
| | `tests/api/me/teacher-analytics/index.test.ts` | 2 |
| | `tests/api/me/teacher-analytics/earnings.test.ts` | 4 |
| | `tests/api/me/teacher-analytics/sessions.test.ts` | 4 |
| | `tests/api/me/teacher-analytics/students.test.ts` | 4 |
| **Creator** | | |
| | `tests/api/me/creator-dashboard.test.ts` | 13 |
| | `tests/api/me/creator-earnings.test.ts` | 12 |
| | `tests/api/me/creator-analytics.test.ts` | 5 |
| | `tests/api/me/creator-analytics/index.test.ts` | 9 |
| | `tests/api/me/creator-analytics/courses.test.ts` | 10 |
| | `tests/api/me/creator-analytics/enrollments.test.ts` | 7 |
| | `tests/api/me/creator-analytics/funnel.test.ts` | 7 |
| | `tests/api/me/creator-analytics/materials-feedback.test.ts` | 11 |
| | `tests/api/me/creator-analytics/progress.test.ts` | 7 |
| | `tests/api/me/creator-analytics/sessions.test.ts` | 7 |
| | `tests/api/me/creator-analytics/teacher-performance.test.ts` | 7 |
| **Communities** | | |
| | `tests/api/me/communities/index.test.ts` | 16 |
| | `tests/api/me/communities/[slug]/index.test.ts` | 15 |
| | `tests/api/me/communities/[slug]/members.test.ts` | 11 |
| | `tests/api/me/communities/[slug]/progressions.test.ts` | 23 |
| **Courses (Creator)** | | |
| | `tests/api/me/courses/index.test.ts` | 18 |
| | `tests/api/me/courses/[id]/index.test.ts` | 16 |
| | `tests/api/me/courses/[id]/publish.test.ts` | 8 |
| | `tests/api/me/courses/[id]/unpublish.test.ts` | 5 |
| | `tests/api/me/courses/[id]/thumbnail.test.ts` | 4 |
| | `tests/api/me/courses/[id]/teachers.test.ts` | 9 |
| | `tests/api/me/courses/[id]/teachers/[teacherId].test.ts` | 5 |
| | `tests/api/me/courses/[id]/curriculum/index.test.ts` | 7 |
| | `tests/api/me/courses/[id]/curriculum/[moduleId].test.ts` | 7 |
| | `tests/api/me/courses/[id]/curriculum/reorder.test.ts` | 4 |
| | `tests/api/me/courses/[id]/homework/index.test.ts` | 5 |
| | `tests/api/me/courses/[id]/homework/[assignmentId].test.ts` | 5 |
| | `tests/api/me/courses/[id]/resources/index.test.ts` | 5 |
| | `tests/api/me/courses/[id]/resources/[resourceId].test.ts` | 4 |
| **Messages** | | |
| | `tests/api/me/can-message/[userId].test.ts` | 7 |
| | `tests/api/me/full-unread-messages.test.ts` | 7 |
| | `tests/api/me/messages/count.test.ts` | 8 |
| | `tests/api/me/messages/read-all.test.ts` | 7 |
| **Notifications** | | |
| | `tests/api/me/notifications/index.test.ts` | 13 |
| | `tests/api/me/notifications/count.test.ts` | 6 |
| | `tests/api/me/notifications/edge-cases.test.ts` | 11 |
| | `tests/api/me/notifications/read-all.test.ts` | 5 |
| | `tests/api/me/notifications/[id]/index.test.ts` | 6 |
| | `tests/api/me/notifications/[id]/read.test.ts` | 6 |
| **Payouts** | | |
| | `tests/api/me/payouts/request.test.ts` | 12 |

### Moderator Invites — `tests/api/moderator-invites/` (3 files)

| File | Tests |
|------|:-----:|
| `tests/api/moderator-invites/[token]/index.test.ts` | 9 |
| `tests/api/moderator-invites/[token]/accept.test.ts` | 9 |
| `tests/api/moderator-invites/[token]/decline.test.ts` | 8 |

### Sessions — `tests/api/sessions/` (6 files)

| File | Tests |
|------|:-----:|
| `tests/api/sessions/index.test.ts` | 22 |
| `tests/api/sessions/[id]/index.test.ts` | 45 |
| `tests/api/sessions/[id]/join.test.ts` | 14 |
| `tests/api/sessions/[id]/attendance.test.ts` | 10 |
| `tests/api/sessions/[id]/rating.test.ts` | 23 |
| `tests/api/sessions/[id]/recording.test.ts` | 10 |

### Teachers — `tests/api/teachers/` (3 files)

| File | Tests |
|------|:-----:|
| `tests/api/teachers/index.test.ts` | 12 |
| `tests/api/teachers/[id]/availability.test.ts` | 15 |
| `tests/api/teachers/[id]/reviews.test.ts` | 13 |

### Users — `tests/api/users/` (4 files)

| File | Tests |
|------|:-----:|
| `tests/api/users/index.test.ts` | 26 |
| `tests/api/users/[handle].test.ts` | 17 |
| `tests/api/users/check-handle.test.ts` | 13 |
| `tests/api/users/search.test.ts` | 20 |

### Webhooks — `tests/api/webhooks/` (2 files)

| File | Tests |
|------|:-----:|
| `tests/api/webhooks/bbb.test.ts` | 20 |
| `tests/api/webhooks/bbb-analytics.test.ts` | 8 | BBB Learning Analytics callback (JWT, storage, upsert) |
| `tests/api/webhooks/stripe.test.ts` | 14 |

### Other API — `tests/api/` top-level (23 files)

| File | Tests |
|------|:-----:|
| `tests/api/topics/index.test.ts` | — |
| `tests/api/certificates/[id]/verify.test.ts` | 11 |
| `tests/api/contact.test.ts` | 13 |
| `tests/api/db-test.test.ts` | 5 |
| `tests/api/debug/db-env.test.ts` | 7 |
| `tests/api/faq.test.ts` | 13 |
| `tests/api/flags.test.ts` | 20 |
| `tests/api/leaderboard.test.ts` | 17 |
| `tests/api/recommendations/communities.test.ts` | 11 |
| `tests/api/recommendations/courses.test.ts` | 13 |
| `tests/api/resources/[id]/download.test.ts` | 10 |
| `tests/api/reviews/[type]/[id]/response.test.ts` | 19 |
| `tests/api/stats.test.ts` | 6 |
| `tests/api/stories/index.test.ts` | 14 |
| `tests/api/stories/[id].test.ts` | 8 |
| `tests/api/stream/token.test.ts` | 6 |
| `tests/api/stripe/connect.test.ts` | 12 |
| `tests/api/stripe/connect-link.test.ts` | 10 |
| `tests/api/stripe/connect-status.test.ts` | 8 |
| `tests/api/stripe/verify-checkout.test.ts` | 9 |
| `tests/api/submissions/[id]/index.test.ts` | 11 |
| `tests/api/team.test.ts` | 8 |
| `tests/api/testimonials.test.ts` | 18 |
| `tests/api/topics/index.test.ts` | 7 |

---

## Lib Tests — `tests/lib/` (7 files)

| File | Tests | Coverage |
|------|:-----:|----------|
| `tests/lib/auth-modal.test.ts` | 26 | Auth modal state management |
| `tests/lib/booking.test.ts` | 25 | Booking: positional assignment, reflow, eligibility, backfill, enrollment completion, post-session actions |
| `tests/lib/current-user-cache.test.ts` | 17 | Cache structural guard, stale-while-revalidate, lifecycle |
| `tests/lib/current-user-community-feeds.test.ts` | 14 | Community memberships (getCommunityMemberships, isMemberOf, getTownhall), feed index (getFeeds) |
| `tests/lib/current-user-listeners.test.ts` | 14 | Change listeners (subscribe/unsubscribe/notify), useCurrentUser hook, unread counts |
| `tests/lib/feed-activity.test.ts` | 11 | Feed activity D1 index: indexFeedActivity, recordFeedVisit, getFeedBadgeCounts (FEED-INTEL Phase 1) |
| `tests/lib/smart-feed-scoring.test.ts` | 11 | Smart feed scoring: weight application, signal combination, member/discovery profiles, reason determination, recency decay |
| `tests/lib/smart-feed-candidates.test.ts` | 9 | Smart feed candidates: getUserFeedList, getDismissedFeeds, getMemberCandidates (cursor, unseen, own-post exclusion) |
| `tests/lib/messaging.test.ts` | 20 | canMessage policy rules, getMessageableFlags, SQL search |
| `tests/lib/notifications.test.ts` | 39 | Notification processing and display |
| `tests/lib/video/bbb.test.ts` | 48 | BBB video provider integration |

---

## Integration Tests — `tests/integration/` (7 files)

| File | Tests | Coverage |
|------|:-----:|----------|
| `tests/integration/bbb-connectivity.test.ts` | 4 | BBB server connectivity |
| `tests/integration/database.test.ts` | 0 | Database connectivity (empty) |
| `tests/integration/message-lifecycle.test.ts` | 13 | Send → count → read → multi-conversation |
| `tests/integration/notification-lifecycle.test.ts` | 21 | Full notification lifecycle |
| `tests/integration/session-invite.test.ts` | 15 | Session invite create, accept, decline, reschedule, expiry, version bump, accepted invite listing |
| `tests/integration/session-invite-notifications.test.ts` | 3 | Unmocked notification verification for invites |
| `tests/integration/enrollment-guards.test.ts` | 11 | Creator/teacher self-enrollment, duplicate, re-enrollment, no-teachers, partial unique index |
| `tests/integration/session-lifecycle.test.ts` | 15 | Session booking → completion lifecycle |

---

## SSR Tests — `tests/ssr/` (3 files)

| File | Tests | Coverage |
|------|:-----:|----------|
| `tests/ssr/about.test.ts` | 7 | About page SSR rendering |
| `tests/ssr/courses.test.ts` | 19 | Course pages SSR |
| `tests/ssr/static.test.ts` | 14 | Static page generation |

---

## Unit Tests — `tests/unit/` (11 files)

| File | Tests | Coverage |
|------|:-----:|----------|
| `tests/unit/admin-intel/admin-badge.test.tsx` | 12 | AdminBadge counts, 99+, sizes, colors, tooltips, aria |
| `tests/unit/admin-intel/admin-community-tab.test.tsx` | 6 | AdminCommunityTab full/compact rendering, flags, member count |
| `tests/unit/admin-intel/admin-course-tab.test.tsx` | 6 | AdminCourseTab full/compact rendering, flags, stat cards |
| `tests/unit/admin-intel/admin-dashboard-card.test.tsx` | 7 | AdminDashboardCard pending items, links, all-clear state, loading/error |
| `tests/unit/admin-intel/admin-links.test.ts` | 10 | All admin-links URL mappings |
| `tests/unit/admin-intel/admin-member-summary.test.tsx` | 5 | AdminMemberSummary full/compact rendering, status, roles |
| `tests/unit/admin-intel/bidirectional-links.test.tsx` | 9 | Bidirectional links hrefs and admin red styling in detail components |
| `tests/unit/availability-utils.test.ts` | 26 | Calendar merge algorithm, overrides, recurring |
| `tests/unit/example.test.ts` | 8 | Example/template test |
| `tests/unit/ratings.test.ts` | 13 | Rating calculations |

---

## Middleware Tests — `tests/` root (1 file)

| File | Tests | Coverage |
|------|:-----:|----------|
| `tests/middleware.test.ts` | 86 | Auth guard middleware — public routes, public-browsable, protected prefixes, protected exact-match, redirect with return URL |

---

## Page Tests — `tests/pages/` (14 files)

See [TEST-PAGES.md](TEST-PAGES.md) for details.

| Area | File | Tests |
|------|------|:-----:|
| **Auth** | | |
| | `tests/pages/auth/LoginForm.test.tsx` | 20 |
| | `tests/pages/auth/PasswordResetForm.test.tsx` | 27 |
| | `tests/pages/auth/SignupForm.test.tsx` | 25 |
| **Courses** | | |
| | `tests/pages/courses/CourseBrowse.test.tsx` | 30 |
| | `tests/pages/courses/CourseDetail.test.tsx` | 56 |
| **Creators** | | |
| | `tests/pages/creators/CreatorBrowse.test.tsx` | 33 |
| | `tests/pages/creators/CreatorProfile.test.tsx` | 40 |
| **Dashboard** | | |
| | `tests/pages/dashboard/CreatorDashboard.test.tsx` | 48 |
| | `tests/pages/dashboard/StudentDashboard.test.tsx` | 29 |
| | `tests/pages/dashboard/TeacherDashboard.test.tsx` | 62 |
| **Onboarding** | | |
| | `tests/pages/onboarding/onboarding.test.ts` | 7 |
| **Profile** | | |
| | `tests/pages/profile/UserProfile.test.tsx` | 36 |
| **Teachers** | | |
| | `tests/pages/teachers/TeacherDirectory.test.tsx` | 35 |
| | `tests/pages/teachers/TeacherProfile.test.tsx` | 58 |

---

## PLATO Tests — `tests/plato/` (1 file)

PLATO is an API-level user journey testing framework using Model B (sequential DB-accumulation). Each "run" models a page visit with button presses that trigger API calls. Runs compose into scenarios — independent, goal-driven chains with their own persona sets and DB verifications. See `docs/as-designed/plato.md` for design rationale and `docs/reference/PLATO-GUIDE.md` for the practical guide.

| File | Scenarios | Coverage |
|------|:---------:|----------|
| `tests/plato/api/plato-scenarios.api.test.ts` | 4 | Flywheel (11 runs) + Ecosystem (18 steps) + Activities (7 runs) + Seed-dev (53 steps) |

### PLATO Scenarios

| File | Purpose |
|------|---------|
| `tests/plato/scenarios/flywheel.scenario.ts` | Genesis flywheel — 11 runs, single course, learn-teach-earn cycle |
| `tests/plato/scenarios/ecosystem.scenario.ts` | Multi-course/multi-student — 2 courses, 3 students, 7 DB verifications |
| `tests/plato/scenarios/activities.scenario.ts` | Phase 3 atomic runs — tests all 7 new runs (session, message, follow, homework, availability) |
| `tests/plato/scenarios/seed-dev.scenario.ts` | Seed scenario — 53 chain steps, 14 verifications, 10 actors, 6 courses (used by `db:seed:plato`) |
| `tests/plato/scenarios/seed-dev-topup.ts` | 36 SqlTopUp enrichment steps — reviews, transactions, certificates, moderation, notifications, expertise, etc. |
| `tests/plato/scenarios/index.ts` | Scenario registry and loader |

### PLATO Runs

| File | Purpose |
|------|---------|
| `tests/plato/runs/register-creator.run.ts` | Register creator account via auth API |
| `tests/plato/runs/grant-creator-role.run.ts` | Admin grants creator role |
| `tests/plato/runs/create-community.run.ts` | Creator creates a community |
| `tests/plato/runs/create-course.run.ts` | Creator creates a course in the community |
| `tests/plato/runs/add-modules.run.ts` | Creator adds modules/lessons to course |
| `tests/plato/runs/publish-course.run.ts` | Creator publishes the course |
| `tests/plato/runs/register-student.run.ts` | Register student account via auth API |
| `tests/plato/runs/self-certify-creator.run.ts` | Stripe Connect + creator self-certifies as teacher |
| `tests/plato/runs/add-teacher-cert.run.ts` | Per-course teacher certification (no Stripe Connect) |
| `tests/plato/runs/enroll-student.run.ts` | Course discovery, checkout, Stripe webhook enrollment (supports `findBy` for multi-course) |
| `tests/plato/runs/complete-course.run.ts` | 3x (book session + BBB webhook) → enrollment auto-complete |
| `tests/plato/runs/certify-teacher.run.ts` | Creator certifies student → flywheel closes (uses `$actor.student.userId` directly) |
| `tests/plato/runs/book-complete-session.run.ts` | Atomic book + complete session (single session cycle) |
| `tests/plato/runs/cancel-session.run.ts` | Atomic book + cancel session |
| `tests/plato/runs/send-message.run.ts` | Create conversation + send messages |
| `tests/plato/runs/follow-user.run.ts` | Follow creator via handle discovery |
| `tests/plato/runs/create-homework.run.ts` | Creator creates homework assignment |
| `tests/plato/runs/submit-homework.run.ts` | Student submits homework |
| `tests/plato/runs/set-availability.run.ts` | Teacher sets weekly availability |
| `tests/plato/runs/_chain.ts` | Fixed ordered list of runs (legacy, used by flywheel scenario) |
| `tests/plato/runs/index.ts` | Run loader (19 runs registered) |

### PLATO Infrastructure

| File | Purpose |
|------|---------|
| `tests/plato/lib/types.ts` | Type definitions (PlatoRun, PlatoScenario, RunRef, PageVisit, PageAction, etc.) |
| `tests/plato/lib/api-runner.ts` | PlatoRunner class — `executeScenario()`, `applyActorBindings()`, `flattenCourseData()`, `findBy` in extractPath, `$runtime.courseTitle` auto-propagation |
| `tests/plato/lib/reporter.ts` | Console progress reporter with scenario and page-visit output |
| `tests/plato/lib/mock-registry.ts` | Service mock factories (Stripe, Stream, R2, email, video) — unique Stripe account IDs per call |
| `tests/plato/personas/genesis.ts` | Flywheel persona set (Mara Chen creator, Alex Rivera student, admin) |
| `tests/plato/personas/ecosystem.ts` | Ecosystem persona set (Mara 2 courses, Sarah/Marcus/Jennifer students, admin) |
| `tests/plato/personas/seed-full.ts` | Seed persona set (10 actors, 6 courses — full dev environment) |
| `tests/plato/personas/index.ts` | Persona set loader |

---

## E2E Tests — `e2e/` (25 files)

See [TEST-E2E.md](TEST-E2E.md) for details.

| File | Tests | Coverage |
|------|:-----:|----------|
| `e2e/admin-crud.spec.ts` | 6 | Admin CRUD operations |
| `e2e/admin-overview.spec.ts` | 5 | Admin dashboard overview |
| `e2e/admin-webhookstate.spec.ts` | 5 | Webhook state management |
| `e2e/auth-dashboard.spec.ts` | 4 | Auth → dashboard flow |
| `e2e/browse-enroll.spec.ts` | 5 | Browse → enrollment flow |
| `e2e/community-feed.spec.ts` | 3 | Community feed interactions |
| `e2e/community-pages.spec.ts` | 3 | Community page rendering |
| `e2e/course-detail.spec.ts` | 5 | Course detail page |
| `e2e/course-feed.spec.ts` | 3 | Course feed interactions |
| `e2e/course-learning.spec.ts` | 4 | Learning flow |
| `e2e/creator-application.spec.ts` | 3 | Creator application flow |
| `e2e/creator-dashboard.spec.ts` | 5 | Creator dashboard |
| `e2e/discovery.spec.ts` | 4 | Discovery/browse pages |
| `e2e/earnings.spec.ts` | 5 | Earnings display |
| `e2e/feed-badges.spec.ts` | 2 | Feed badge counts: display after posting, clearing after visit |
| `e2e/feeds-hub.spec.ts` | 6 | Feeds hub page (/feeds) rendering, search, navigation links |
| `e2e/home-feed.spec.ts` | 3 | Home feed (chronological timeline, deprecated) |
| `e2e/smart-feed.spec.ts` | 6 | Smart feed: seeded activities, discovery cards, filter tabs, CTA navigation, dismiss persistence |
| `e2e/homepage.spec.ts` | 5 | Homepage rendering |
| `e2e/my-feeds-card.spec.ts` | 4 | MyFeeds dashboard card on Student/Teacher/Creator dashboards |
| `e2e/notifications.spec.ts` | 9 | Notification system |
| `e2e/profiles.spec.ts` | 5 | User profiles |
| `e2e/seed-data-verification.spec.ts` | 14 | Seed data → CurrentUser pipeline verification (5 users × 3 dashboards) |
| `e2e/session-booking-flow.spec.ts` | 1 | Full booking flow |
| `e2e/session-booking.spec.ts` | 3 | Session booking UI |
| `e2e/session-completed.spec.ts` | 4 | Session completion |
| `e2e/session-completion-flow.spec.ts` | 1 | Full completion flow |
| `e2e/settings.spec.ts` | 5 | Settings pages |
| `e2e/signup-flow.spec.ts` | 4 | Signup flow |
| `e2e/teaching-dashboard.spec.ts` | 5 | Teaching dashboard |

---

## Component Tests — `tests/components/` (87 files)

See [TEST-COMPONENTS.md](TEST-COMPONENTS.md) for the full breakdown by category.

---

## Related Documentation

- [CLI-TESTING.md](CLI-TESTING.md) - Testing commands in detail
- [CLI-QUICKREF.md](CLI-QUICKREF.md) - Quick command reference

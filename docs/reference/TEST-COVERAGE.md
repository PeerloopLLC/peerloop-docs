# Test Coverage

Index of all test files organized by category. For testing commands, see [CLI-TESTING.md](CLI-TESTING.md).

**Last Updated:** 2026-03-12 (Session 383 — full rebuild)

---

## Quick Reference

| Document | Location | Description |
|----------|----------|-------------|
| [TEST-COMPONENTS.md](TEST-COMPONENTS.md) | `tests/components/` | React component tests |
| [TEST-PAGES.md](TEST-PAGES.md) | `tests/pages/` | Page-level tests |
| [TEST-UNIT.md](TEST-UNIT.md) | `tests/unit/`, `tests/integration/`, `tests/ssr/` | Unit, integration, SSR tests |
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
| API Endpoints | 274 | ~3,547 | `tests/api/` |
| Components | 72 | ~2,036 | `tests/components/` |
| Pages | 16 | ~504 | `tests/pages/` |
| Lib | 6 | ~162 | `tests/lib/` |
| Integration | 5 | ~53 | `tests/integration/` |
| SSR | 3 | ~40 | `tests/ssr/` |
| Unit | 3 | ~47 | `tests/unit/` |
| E2E (Playwright) | 25 | ~113 | `e2e/` |
| **Vitest Total** | **379** | **~6,389** | |
| **All Test Files** | **404** | **~6,502** | |

---

## Test Infrastructure

| File | Purpose |
|------|---------|
| `tests/helpers/index.ts` | Test utilities (describeWithTestDB, describeWithBBB, getTestDB) |
| `tests/helpers/bbb.ts` | BBB credential loader + test client (canUseBBB, getBBBTestClient) |
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

## API Tests — `tests/api/` (274 files)

Tests mirror the API route structure with 1:1 file mapping:

```
tests/api/
├── resource/
│   ├── index.test.ts        # GET/POST collection
│   └── [id]/
│       ├── index.test.ts    # GET/PATCH/DELETE item
│       └── action.test.ts   # POST action endpoints
```

### Admin — `tests/api/admin/` (66 files)

| Area | File | Tests |
|------|------|:-----:|
| Dashboard | `admin/dashboard.test.ts` | 30 |
| **Analytics** | | |
| | `admin/analytics/index.test.ts` | 12 |
| | `admin/analytics/courses.test.ts` | 5 |
| | `admin/analytics/engagement.test.ts` | 5 |
| | `admin/analytics/revenue.test.ts` | 5 |
| | `admin/analytics/teachers.test.ts` | 5 |
| | `admin/analytics/users.test.ts` | 5 |
| **Categories** | | |
| | `admin/categories/index.test.ts` | 15 |
| | `admin/categories/[id]/index.test.ts` | 10 |
| | `admin/categories/reorder.test.ts` | 7 |
| **Certificates** | | |
| | `admin/certificates/index.test.ts` | 24 |
| | `admin/certificates/[id]/index.test.ts` | 5 |
| | `admin/certificates/[id]/approve.test.ts` | 6 |
| | `admin/certificates/[id]/reject.test.ts` | 6 |
| | `admin/certificates/[id]/revoke.test.ts` | 7 |
| **Courses** | | |
| | `admin/courses/index.test.ts` | 43 |
| | `admin/courses/[id]/index.test.ts` | 19 |
| | `admin/courses/[id]/badge.test.ts` | 12 |
| | `admin/courses/[id]/feature.test.ts` | 5 |
| | `admin/courses/[id]/suspend.test.ts` | 8 |
| | `admin/courses/[id]/unsuspend.test.ts` | 8 |
| **Creator Applications** | | |
| | `admin/creator-applications/index.test.ts` | 15 |
| | `admin/creator-applications/[id].test.ts` | 5 |
| | `admin/creator-applications/[id]/approve.test.ts` | 9 |
| | `admin/creator-applications/[id]/deny.test.ts` | 8 |
| **Enrollments** | | |
| | `admin/enrollments/index.test.ts` | 46 |
| | `admin/enrollments/[id]/index.test.ts` | 29 |
| | `admin/enrollments/[id]/cancel.test.ts` | 9 |
| | `admin/enrollments/[id]/force-complete.test.ts` | 10 |
| | `admin/enrollments/[id]/reassign-teacher.test.ts` | 10 |
| | `admin/enrollments/[id]/refund.test.ts` | 14 |
| **Moderation** | | |
| | `admin/moderation/index.test.ts` | 19 |
| | `admin/moderation/[id]/index.test.ts` | 9 |
| | `admin/moderation/[id]/dismiss.test.ts` | 10 |
| | `admin/moderation/[id]/remove.test.ts` | 10 |
| | `admin/moderation/[id]/suspend.test.ts` | 12 |
| | `admin/moderation/[id]/warn.test.ts` | 9 |
| **Moderators** | | |
| | `admin/moderators/index.test.ts` | 15 |
| | `admin/moderators/invite.test.ts` | 17 |
| | `admin/moderators/[id]/remove.test.ts` | 8 |
| | `admin/moderators/[id]/resend.test.ts` | 12 |
| | `admin/moderators/[id]/revoke.test.ts` | 9 |
| **Payouts** | | |
| | `admin/payouts/index.test.ts` | 35 |
| | `admin/payouts/batch.test.ts` | 10 |
| | `admin/payouts/pending.test.ts` | 11 |
| | `admin/payouts/[id]/index.test.ts` | 10 |
| | `admin/payouts/[id]/process.test.ts` | 14 |
| | `admin/payouts/[id]/retry.test.ts` | 10 |
| **Sessions** | | |
| | `admin/sessions/index.test.ts` | 23 |
| | `admin/sessions/[id]/index.test.ts` | 21 |
| | `admin/sessions/[id]/recording.test.ts` | 15 |
| | `admin/sessions/[id]/resolve.test.ts` | 13 |
| **Teachers** | | |
| | `admin/teachers/index.test.ts` | 35 |
| | `admin/teachers/[id]/index.test.ts` | 30 |
| | `admin/teachers/[id]/activate.test.ts` | 8 |
| | `admin/teachers/[id]/deactivate.test.ts` | 9 |
| **Users** | | |
| | `admin/users/index.test.ts` | 53 |
| | `admin/users/[id]/index.test.ts` | 29 |
| | `admin/users/[id]/suspend.test.ts` | 10 |
| | `admin/users/[id]/unsuspend.test.ts` | 9 |

### Auth — `tests/api/auth/` (9 files)

| File | Tests |
|------|:-----:|
| `auth/login.test.ts` | 14 |
| `auth/logout.test.ts` | 4 |
| `auth/register.test.ts` | 28 |
| `auth/reset-password.test.ts` | 8 |
| `auth/session.test.ts` | 10 |
| `auth/github/index.test.ts` | 12 |
| `auth/github/callback.test.ts` | 10 |
| `auth/google/index.test.ts` | 17 |
| `auth/google/callback.test.ts` | 12 |

### Checkout — `tests/api/checkout/` (1 file)

| File | Tests |
|------|:-----:|
| `checkout/create-session.test.ts` | 13 |

### Communities — `tests/api/communities/` (6 files)

| File | Tests |
|------|:-----:|
| `communities/index.test.ts` | 11 |
| `communities/[slug]/index.test.ts` | 14 |
| `communities/[slug]/join.test.ts` | 15 |
| `communities/[slug]/progressions.test.ts` | 11 |
| `communities/[slug]/moderators/index.test.ts` | 16 |
| `communities/[slug]/moderators/[userId].test.ts` | 7 |

### Conversations — `tests/api/conversations/` (4 files)

| File | Tests |
|------|:-----:|
| `conversations/index.test.ts` | 14 |
| `conversations/[id]/index.test.ts` | 11 |
| `conversations/[id]/messages.test.ts` | 11 |
| `conversations/[id]/read.test.ts` | 7 |

### Courses — `tests/api/courses/` (8 files)

| File | Tests |
|------|:-----:|
| `courses/index.test.ts` | 22 |
| `courses/[slug].test.ts` | 15 |
| `courses/[slug]/discussion-feed.test.ts` | 19 |
| `courses/[id]/curriculum.test.ts` | 9 |
| `courses/[id]/homework.test.ts` | 12 |
| `courses/[id]/resources.test.ts` | 11 |
| `courses/[id]/reviews.test.ts` | 11 |
| `courses/[id]/sessions.test.ts` | 12 |

### Creators — `tests/api/creators/` (4 files)

| File | Tests |
|------|:-----:|
| `creators/index.test.ts` | 15 |
| `creators/apply.test.ts` | 20 |
| `creators/[handle].test.ts` | 10 |
| `creators/[id]/courses.test.ts` | 13 |

### Enrollments — `tests/api/enrollments/` (5 files)

| File | Tests |
|------|:-----:|
| `enrollments/index.test.ts` | 13 |
| `enrollments/[id]/course-review.test.ts` | 24 |
| `enrollments/[id]/expectations.test.ts` | 35 |
| `enrollments/[id]/progress.test.ts` | 18 |
| `enrollments/[id]/review.test.ts` | 20 |

### Feeds — `tests/api/feeds/` (8 files)

| File | Tests |
|------|:-----:|
| `feeds/timeline.test.ts` | 8 |
| `feeds/townhall.test.ts` | 13 |
| `feeds/townhall/comments.test.ts` | 20 |
| `feeds/townhall/reactions.test.ts` | 15 |
| `feeds/course/[slug].test.ts` | 23 |
| `feeds/community/[slug]/index.test.ts` | 14 |
| `feeds/community/[slug]/comments.test.ts` | 15 |
| `feeds/community/[slug]/reactions.test.ts` | 12 |

### Health — `tests/api/health/` (3 files)

| File | Tests |
|------|:-----:|
| `health/db.test.ts` | 5 |
| `health/kv.test.ts` | 5 |
| `health/r2.test.ts` | 7 |

### Homework — `tests/api/homework/` (5 files)

| File | Tests |
|------|:-----:|
| `homework/[id]/index.test.ts` | 8 |
| `homework/[id]/submit.test.ts` | 11 |
| `homework/[id]/submissions/index.test.ts` | 9 |
| `homework/[id]/submissions/me.test.ts` | 9 |
| `homework/[id]/submissions/[subId].test.ts` | 13 |

### Me — `tests/api/me/` (59 files)

| Area | File | Tests |
|------|------|:-----:|
| **Profile/Account** | | |
| | `me/account.test.ts` | 12 |
| | `me/full.test.ts` | 15 |
| | `me/onboarding-profile.test.ts` | 11 |
| | `me/profile.test.ts` | 30 |
| | `me/settings.test.ts` | 21 |
| **Enrollments/Certificates** | | |
| | `me/certificates.test.ts` | 7 |
| | `me/certificates/recommend.test.ts` | 13 |
| | `me/enrollments.test.ts` | 18 |
| **Teacher** | | |
| | `me/availability.test.ts` | 22 |
| | `me/availability/overrides.test.ts` | 16 |
| | `me/availability/overrides/[id].test.ts` | 6 |
| | `me/teacher-dashboard.test.ts` | 12 |
| | `me/teacher-earnings.test.ts` | 14 |
| | `me/teacher-sessions.test.ts` | 15 |
| | `me/teacher-students.test.ts` | 16 |
| | `me/teacher/[courseId]/toggle.test.ts` | 9 |
| | `me/teacher-analytics/index.test.ts` | 2 |
| | `me/teacher-analytics/earnings.test.ts` | 4 |
| | `me/teacher-analytics/sessions.test.ts` | 4 |
| | `me/teacher-analytics/students.test.ts` | 4 |
| **Creator** | | |
| | `me/creator-dashboard.test.ts` | 13 |
| | `me/creator-earnings.test.ts` | 12 |
| | `me/creator-analytics.test.ts` | 5 |
| | `me/creator-analytics/index.test.ts` | 9 |
| | `me/creator-analytics/courses.test.ts` | 10 |
| | `me/creator-analytics/enrollments.test.ts` | 7 |
| | `me/creator-analytics/funnel.test.ts` | 7 |
| | `me/creator-analytics/materials-feedback.test.ts` | 11 |
| | `me/creator-analytics/progress.test.ts` | 7 |
| | `me/creator-analytics/sessions.test.ts` | 7 |
| | `me/creator-analytics/teacher-performance.test.ts` | 7 |
| **Communities** | | |
| | `me/communities/index.test.ts` | 16 |
| | `me/communities/[slug]/index.test.ts` | 15 |
| | `me/communities/[slug]/members.test.ts` | 11 |
| | `me/communities/[slug]/progressions.test.ts` | 23 |
| **Courses (Creator)** | | |
| | `me/courses/index.test.ts` | 18 |
| | `me/courses/[id]/index.test.ts` | 16 |
| | `me/courses/[id]/publish.test.ts` | 8 |
| | `me/courses/[id]/unpublish.test.ts` | 5 |
| | `me/courses/[id]/thumbnail.test.ts` | 4 |
| | `me/courses/[id]/teachers.test.ts` | 9 |
| | `me/courses/[id]/teachers/[teacherId].test.ts` | 5 |
| | `me/courses/[id]/curriculum/index.test.ts` | 7 |
| | `me/courses/[id]/curriculum/[moduleId].test.ts` | 7 |
| | `me/courses/[id]/curriculum/reorder.test.ts` | 4 |
| | `me/courses/[id]/homework/index.test.ts` | 5 |
| | `me/courses/[id]/homework/[assignmentId].test.ts` | 5 |
| | `me/courses/[id]/resources/index.test.ts` | 5 |
| | `me/courses/[id]/resources/[resourceId].test.ts` | 4 |
| **Messages** | | |
| | `me/can-message/[userId].test.ts` | 7 |
| | `me/messages/count.test.ts` | 8 |
| | `me/messages/read-all.test.ts` | 7 |
| **Notifications** | | |
| | `me/notifications/index.test.ts` | 13 |
| | `me/notifications/count.test.ts` | 6 |
| | `me/notifications/edge-cases.test.ts` | 11 |
| | `me/notifications/read-all.test.ts` | 5 |
| | `me/notifications/[id]/index.test.ts` | 6 |
| | `me/notifications/[id]/read.test.ts` | 6 |
| **Payouts** | | |
| | `me/payouts/request.test.ts` | 12 |

### Moderator Invites — `tests/api/moderator-invites/` (3 files)

| File | Tests |
|------|:-----:|
| `moderator-invites/[token]/index.test.ts` | 9 |
| `moderator-invites/[token]/accept.test.ts` | 9 |
| `moderator-invites/[token]/decline.test.ts` | 8 |

### Sessions — `tests/api/sessions/` (6 files)

| File | Tests |
|------|:-----:|
| `sessions/index.test.ts` | 22 |
| `sessions/[id]/index.test.ts` | 42 |
| `sessions/[id]/join.test.ts` | 14 |
| `sessions/[id]/attendance.test.ts` | 10 |
| `sessions/[id]/rating.test.ts` | 23 |
| `sessions/[id]/recording.test.ts` | 10 |

### Teachers — `tests/api/teachers/` (3 files)

| File | Tests |
|------|:-----:|
| `teachers/index.test.ts` | 12 |
| `teachers/[id]/availability.test.ts` | 15 |
| `teachers/[id]/reviews.test.ts` | 13 |

### Users — `tests/api/users/` (4 files)

| File | Tests |
|------|:-----:|
| `users/index.test.ts` | 26 |
| `users/[handle].test.ts` | 17 |
| `users/check-handle.test.ts` | 13 |
| `users/search.test.ts` | 20 |

### Webhooks — `tests/api/webhooks/` (2 files)

| File | Tests |
|------|:-----:|
| `webhooks/bbb.test.ts` | 14 |
| `webhooks/stripe.test.ts` | 14 |

### Other API — `tests/api/` top-level (24 files)

| File | Tests |
|------|:-----:|
| `categories.test.ts` | 4 |
| `certificates/[id]/verify.test.ts` | 11 |
| `contact.test.ts` | 13 |
| `db-test.test.ts` | 5 |
| `debug/db-env.test.ts` | 7 |
| `faq.test.ts` | 13 |
| `flags.test.ts` | 20 |
| `leaderboard.test.ts` | 17 |
| `recommendations/communities.test.ts` | 11 |
| `recommendations/courses.test.ts` | 13 |
| `resources/[id]/download.test.ts` | 10 |
| `reviews/[type]/[id]/response.test.ts` | 19 |
| `stats.test.ts` | 6 |
| `stories/index.test.ts` | 14 |
| `stories/[id].test.ts` | 8 |
| `stream/token.test.ts` | 6 |
| `stripe/connect.test.ts` | 12 |
| `stripe/connect-link.test.ts` | 10 |
| `stripe/connect-status.test.ts` | 8 |
| `stripe/verify-checkout.test.ts` | 9 |
| `submissions/[id]/index.test.ts` | 11 |
| `team.test.ts` | 8 |
| `testimonials.test.ts` | 18 |
| `topics/index.test.ts` | 7 |

---

## Lib Tests — `tests/lib/` (6 files)

| File | Tests | Coverage |
|------|:-----:|----------|
| `lib/auth-modal.test.ts` | 26 | Auth modal state management |
| `lib/booking.test.ts` | 13 | Booking utilities and validation |
| `lib/current-user-cache.test.ts` | 17 | Cache structural guard, stale-while-revalidate, lifecycle |
| `lib/current-user-listeners.test.ts` | 14 | Change listeners (subscribe/unsubscribe/notify), useCurrentUser hook, unread counts |
| `lib/messaging.test.ts` | 20 | canMessage policy rules, getMessageableFlags, SQL search |
| `lib/notifications.test.ts` | 38 | Notification processing and display |
| `lib/video/bbb.test.ts` | 48 | BBB video provider integration |

---

## Integration Tests — `tests/integration/` (5 files)

| File | Tests | Coverage |
|------|:-----:|----------|
| `integration/bbb-connectivity.test.ts` | 4 | BBB server connectivity |
| `integration/database.test.ts` | 0 | Database connectivity (empty) |
| `integration/message-lifecycle.test.ts` | 13 | Send → count → read → multi-conversation |
| `integration/notification-lifecycle.test.ts` | 21 | Full notification lifecycle |
| `integration/session-lifecycle.test.ts` | 15 | Session booking → completion lifecycle |

---

## SSR Tests — `tests/ssr/` (3 files)

| File | Tests | Coverage |
|------|:-----:|----------|
| `ssr/about.test.ts` | 7 | About page SSR rendering |
| `ssr/courses.test.ts` | 19 | Course pages SSR |
| `ssr/static.test.ts` | 14 | Static page generation |

---

## Unit Tests — `tests/unit/` (3 files)

| File | Tests | Coverage |
|------|:-----:|----------|
| `unit/availability-utils.test.ts` | 26 | Calendar merge algorithm, overrides, recurring |
| `unit/example.test.ts` | 8 | Example/template test |
| `unit/ratings.test.ts` | 13 | Rating calculations |

---

## Page Tests — `tests/pages/` (16 files)

See [TEST-PAGES.md](TEST-PAGES.md) for details.

| Area | File | Tests |
|------|------|:-----:|
| **Auth** | | |
| | `pages/auth/LoginForm.test.tsx` | 20 |
| | `pages/auth/PasswordResetForm.test.tsx` | 27 |
| | `pages/auth/SignupForm.test.tsx` | 25 |
| **Courses** | | |
| | `pages/courses/CourseBrowse.test.tsx` | 30 |
| | `pages/courses/CourseDetail.test.tsx` | 56 |
| **Creators** | | |
| | `pages/creators/CreatorBrowse.test.tsx` | 33 |
| | `pages/creators/CreatorProfile.test.tsx` | 40 |
| **Dashboard** | | |
| | `pages/dashboard/CreatorDashboard.test.tsx` | 45 |
| | `pages/dashboard/StudentDashboard.test.tsx` | 29 |
| | `pages/dashboard/TeacherDashboard.test.tsx` | 46 |
| **Onboarding** | | |
| | `pages/onboarding/onboarding.test.ts` | 7 |
| **Profile** | | |
| | `pages/profile/UserProfile.test.tsx` | 36 |
| **Teachers** | | |
| | `pages/teachers/TeacherDirectory.test.tsx` | 35 |
| | `pages/teachers/TeacherProfile.test.tsx` | 58 |

---

## E2E Tests — `e2e/` (25 files)

See [TEST-E2E.md](TEST-E2E.md) for details.

| File | Tests | Coverage |
|------|:-----:|----------|
| `admin-crud.spec.ts` | 6 | Admin CRUD operations |
| `admin-overview.spec.ts` | 5 | Admin dashboard overview |
| `admin-webhookstate.spec.ts` | 5 | Webhook state management |
| `auth-dashboard.spec.ts` | 4 | Auth → dashboard flow |
| `browse-enroll.spec.ts` | 5 | Browse → enrollment flow |
| `community-feed.spec.ts` | 3 | Community feed interactions |
| `community-pages.spec.ts` | 3 | Community page rendering |
| `course-detail.spec.ts` | 5 | Course detail page |
| `course-feed.spec.ts` | 3 | Course feed interactions |
| `course-learning.spec.ts` | 4 | Learning flow |
| `creator-application.spec.ts` | 3 | Creator application flow |
| `creator-dashboard.spec.ts` | 5 | Creator dashboard |
| `discovery.spec.ts` | 4 | Discovery/browse pages |
| `earnings.spec.ts` | 5 | Earnings display |
| `home-feed.spec.ts` | 3 | Home feed |
| `homepage.spec.ts` | 5 | Homepage rendering |
| `notifications.spec.ts` | 9 | Notification system |
| `profiles.spec.ts` | 5 | User profiles |
| `session-booking-flow.spec.ts` | 1 | Full booking flow |
| `session-booking.spec.ts` | 3 | Session booking UI |
| `session-completed.spec.ts` | 4 | Session completion |
| `session-completion-flow.spec.ts` | 1 | Full completion flow |
| `settings.spec.ts` | 5 | Settings pages |
| `signup-flow.spec.ts` | 4 | Signup flow |
| `teaching-dashboard.spec.ts` | 5 | Teaching dashboard |

---

## Component Tests — `tests/components/` (72 files)

See [TEST-COMPONENTS.md](TEST-COMPONENTS.md) for the full breakdown by category.

---

## Related Documentation

- [CLI-TESTING.md](CLI-TESTING.md) - Testing commands in detail
- [CLI-QUICKREF.md](CLI-QUICKREF.md) - Quick command reference

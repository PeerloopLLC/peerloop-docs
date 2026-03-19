# Unit, Lib, Integration & SSR Tests

Unit tests, library function tests, database integration tests, and SSR loader tests.

**Last Updated:** 2026-03-17 (Conv 002 — added timezone.test.ts, session-timezone.test.ts)

**Total:** 22 test files (excludes E2E — see [TEST-E2E.md](TEST-E2E.md))

---

## Unit Tests (Vitest)

Unit tests for pure functions, utilities, and isolated components.

| Module | Test File | Tests | Coverage |
|--------|-----------|------:|----------|
| Auth Modal | `tests/lib/auth-modal.test.ts` | 28 | State machine, modal switching, events |
| BBB Adapter | `tests/lib/video/bbb.test.ts` | 48 | Query string encoding, URL normalization, checksum, room CRUD, webhook parsing, factory |
| Booking Module | `tests/lib/booking.test.ts` | 13 | Positional module assignment, reflow on cancel, eligibility, single-module edge case |
| CurrentUser Cache | `tests/lib/current-user-cache.test.ts` | 17 | localStorage caching, stale-while-revalidate, structural guard |
| CurrentUser Listeners | `tests/lib/current-user-listeners.test.ts` | 14 | Pub/sub subscribeToUserChange, hook integration |
| Messaging | `tests/lib/messaging.test.ts` | 20 | canMessage, getMessageableFlags, contact SQL |
| Notifications | `tests/lib/notifications.test.ts` | 38 | CRUD (create, batch, count, markRead, delete, clear), 10 type-specific helpers, currency formatting, batch to admins |
| Example | `src/__tests__/example.test.ts` | 4 | Basic assertions |
| Example Unit | `tests/unit/example.test.ts` | 8 | Basic assertions |
| Availability Utils | `tests/unit/availability-utils.test.ts` | 26 | Availability calendar utilities |
| Rating Display | `tests/unit/ratings.test.ts` | 13 | 3-review threshold, getRatingDisplay(), badge labels |
| Timezone | `tests/unit/timezone.test.ts` | 15 | localToUTC (EDT/EST/UTC/Tokyo/DST), formatLocalTime |
| Feed Activity | `tests/lib/feed-activity.test.ts` | 11 | indexFeedActivity, recordFeedVisit, getFeedBadgeCounts |
| Smart Feed Scoring | `tests/lib/smart-feed-scoring.test.ts` | 11 | Weight application, signal combination, member/discovery profiles, reason determination, recency decay |
| Smart Feed Candidates | `tests/lib/smart-feed-candidates.test.ts` | 9 | getUserFeedList, getDismissedFeeds, getMemberCandidates (cursor, unseen, own-post exclusion) |
| Button | `src/__tests__/Button.test.tsx` | 5 | Component tests |

**Subtotal:** 15 files, 265 tests

---

## Integration Tests (Vitest)

Database and service integration tests.

| Module | Test File | Tests | Coverage |
|--------|-----------|------:|----------|
| BBB Connectivity | `tests/integration/bbb-connectivity.test.ts` | 4 | BBB server connectivity and API health |
| Database | `tests/integration/database.test.ts` | 7 | better-sqlite3 operations |
| Session Lifecycle | `tests/integration/session-lifecycle.test.ts` | 15 | Full flow: book → join → complete → rate, cancel, attendance, conflicts |
| Session Timezone | `tests/integration/session-timezone.test.ts` | 8 | Full timezone chain: availability → UTC slots → booking → DB → join window → display |
| Notification Lifecycle | `tests/integration/notification-lifecycle.test.ts` | 21 | Full flow: create → list → count → mark read → mark all → clear, batch to admins, cross-user isolation, badge count (AppNavbar) |
| Message Lifecycle | `tests/integration/message-lifecycle.test.ts` | 14 | Full flow: send → count → mark read → multi-conversation sums → mark all → cross-user isolation |

**Subtotal:** 5 files, 61 tests

### Database Test Details

The database integration test validates:
- Schema migration application
- CRUD operations (insert, select, update, delete)
- Foreign key constraints
- Transaction handling
- Concurrent access

Uses `better-sqlite3` which works on all development machines.

---

## SSR Loader Tests (Vitest)

Server-side rendering data loader tests. These test the pure functions that fetch data for SSR pages.

| Module | Test File | Tests | Coverage |
|--------|-----------|------:|----------|
| About Page | `tests/ssr/about.test.ts` | 4 | fetchAboutData |
| Course Pages | `tests/ssr/courses.test.ts` | ~15 | fetchCoursesData, fetchCourseDetail, fetchCourseDiscussion, fetchCourseSuccess |
| Static Pages | `tests/ssr/static.test.ts` | ~20 | fetchFaqData, fetchStoriesData, fetchTestimonialsData |

**Subtotal:** 3 files, ~40 tests

### SSR Test Pattern

SSR loader tests validate pure functions that:
1. Take `D1Database` as input
2. Return typed data structures
3. Throw `SSRDataError` on failures

```typescript
import { fetchAboutData, SSRDataError } from '@lib/ssr';
import { describeWithTestDB, getTestDB } from '@test-helpers';

describeWithTestDB('SSR: fetchAboutData', () => {
  it('returns team and stats arrays', async () => {
    const db = getTestDB();
    const result = await fetchAboutData(db);
    expect(result).toHaveProperty('team');
    expect(result).toHaveProperty('stats');
  });
});
```

### Running SSR Tests

```bash
# All SSR tests
npm test -- --run "tests/ssr/"

# Specific loader (for page test scripts)
npm test -- --run "tests/ssr/static.test.ts" -t "fetchFaqData"
```

---

## Summary

| Category | Files | Tests | Runner |
|----------|------:|------:|--------|
| Unit (lib + unit + src/__tests__) | 12 | 234 | Vitest |
| Integration | 5 | 61 | Vitest |
| SSR Loaders | 3 | ~40 | Vitest |
| **Total** | **20** | **~335** | |

---

## Running Tests

```bash
# All unit tests
npm run test:unit

# Integration tests only
npm run test:integration

# All tests
npm run test:all
```

---

## Related Documentation

- [TEST-COVERAGE.md](TEST-COVERAGE.md) - Test coverage index
- [TEST-E2E.md](TEST-E2E.md) - E2E tests (Playwright)
- [CLI-TESTING.md](CLI-TESTING.md) - Testing commands in detail

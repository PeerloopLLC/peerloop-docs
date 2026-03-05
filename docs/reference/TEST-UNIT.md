# Unit, Integration, SSR & E2E Tests

Low-level unit tests, database integration tests, SSR loader tests, and end-to-end tests.

**Last Updated:** 2026-03-05 (Session 337)

**Total:** 18 test files

---

## Unit Tests (Vitest)

Unit tests for pure functions, utilities, and isolated components.

| Module | Test File | Tests | Coverage |
|--------|-----------|------:|----------|
| Auth Modal | `tests/lib/auth-modal.test.ts` | 28 | State machine, modal switching, events |
| BBB Adapter | `tests/lib/video/bbb.test.ts` | 48 | Query string encoding, URL normalization, checksum, room CRUD, webhook parsing, factory |
| Booking Module | `tests/lib/booking.test.ts` | 13 | Positional module assignment, reflow on cancel, eligibility, single-module edge case |
| Notifications | `tests/lib/notifications.test.ts` | 38 | CRUD (create, batch, count, markRead, delete, clear), 10 type-specific helpers, currency formatting, batch to admins |
| Example | `src/__tests__/example.test.ts` | 4 | Basic assertions |
| Example Unit | `tests/unit/example.test.ts` | 8 | Basic assertions |
| Availability Utils | `tests/unit/availability-utils.test.ts` | — | Availability calendar utilities |
| Rating Display | `tests/unit/ratings.test.ts` | 13 | 3-review threshold, getRatingDisplay(), badge labels |
| Button | `src/__tests__/Button.test.tsx` | 5 | Component tests |

**Subtotal:** 9 files, 157+ tests

---

## Integration Tests (Vitest)

Database and service integration tests.

| Module | Test File | Tests | Coverage |
|--------|-----------|------:|----------|
| Database | `tests/integration/database.test.ts` | 7 | better-sqlite3 operations |
| Session Lifecycle | `tests/integration/session-lifecycle.test.ts` | 15 | Full flow: book → join → complete → rate, cancel, attendance, conflicts |
| Notification Lifecycle | `tests/integration/notification-lifecycle.test.ts` | 21 | Full flow: create → list → count → mark read → mark all → clear, batch to admins, cross-user isolation, badge count (AppNavbar) |

**Subtotal:** 3 files, 43 tests

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

## E2E Tests (Playwright)

**4 files, 19 tests** — See [TEST-E2E.md](TEST-E2E.md) for full documentation (setup, test users, selector patterns, gotchas).

| Flow | Test File | Tests |
|------|-----------|------:|
| Homepage | `e2e/homepage.spec.ts` | 5 |
| Browse → Enroll | `e2e/browse-enroll.spec.ts` | 5 |
| Auth → Dashboard | `e2e/auth-dashboard.spec.ts` | 4 |
| Admin Overview | `e2e/admin-overview.spec.ts` | 5 |

---

## Summary

| Category | Files | Tests | Runner |
|----------|------:|------:|--------|
| Unit | 6 | 106 | Vitest |
| Integration | 2 | 22 | Vitest |
| SSR Loaders | 3 | ~40 | Vitest |
| E2E | 4 | 19 | Playwright |
| **Total** | **15** | **~187** | |

---

## Running Tests

```bash
# All unit tests
npm run test:unit

# Integration tests only
npm run test:integration

# E2E tests (requires dev server)
npm run test:e2e

# All tests
npm run test:all
```

---

## Related Documentation

- [TEST-COVERAGE.md](TEST-COVERAGE.md) - Test coverage index
- [CLI-TESTING.md](CLI-TESTING.md) - Testing commands in detail

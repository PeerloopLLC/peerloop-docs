# Unit, Integration, SSR & E2E Tests

Low-level unit tests, database integration tests, SSR loader tests, and end-to-end tests.

**Last Updated:** 2026-02-19 (Session 227)

**Total:** 10 test files

---

## Unit Tests (Vitest)

Unit tests for pure functions, utilities, and isolated components.

| Module | Test File | Tests | Coverage |
|--------|-----------|------:|----------|
| Auth Modal | `tests/lib/auth-modal.test.ts` | 28 | State machine, modal switching, events |
| Example | `src/__tests__/example.test.ts` | 4 | Basic assertions |
| Example Unit | `tests/unit/example.test.ts` | 8 | Basic assertions |
| Button | `src/__tests__/Button.test.tsx` | 5 | Component tests |

**Subtotal:** 4 files, 45 tests

---

## Integration Tests (Vitest)

Database and service integration tests.

| Module | Test File | Tests | Coverage |
|--------|-----------|------:|----------|
| Database | `tests/integration/database.test.ts` | 7 | better-sqlite3 operations |

**Subtotal:** 1 file, 7 tests

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

End-to-end tests running against the full application.

| Flow | Test File | Tests | Coverage |
|------|-----------|------:|----------|
| Homepage | `e2e/homepage.spec.ts` | 5 | Page load, navigation |

**Subtotal:** 1 file, 5 tests

### Homepage E2E Details

Tests validate:
- Page loads successfully
- Peerloop logo/brand visible in navigation
- Navigation links present (Courses, Sign In)
- Navigate to courses page
- Navigate to login page

**Notes:**
- All selectors scoped to `getByRole('navigation')` to avoid footer/page ambiguity
- Sign In link has 10s timeout (waits for React hydration + auth state check)

---

## Summary

| Category | Files | Tests | Runner |
|----------|------:|------:|--------|
| Unit | 4 | 45 | Vitest |
| Integration | 1 | 7 | Vitest |
| SSR Loaders | 3 | ~40 | Vitest |
| E2E | 1 | 5 | Playwright |
| **Total** | **9** | **~97** | |

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

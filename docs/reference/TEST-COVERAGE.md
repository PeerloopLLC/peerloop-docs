# Test Coverage

Index of all test files organized by category. For testing commands, see [CLI-TESTING.md](CLI-TESTING.md).

**Last Updated:** 2026-03-05 (Session 339)

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

| Category | Codebase | Tests | Coverage | Location |
|----------|:--------:|:-----:|:--------:|----------|
| API Endpoints | 214 | 213 | 100% | `tests/api/` |
| SSR Loaders | — | 3 | — | `tests/ssr/` |
| Astro Pages | 45 | 14 | 31% | `tests/pages/` |
| Components | — | 69 | — | `tests/components/` |
| Lib | — | 5 | — | `tests/lib/` |
| Integration | — | 5 | — | `tests/integration/` |
| Unit Tests | — | 2 | — | `src/__tests__/` |
| Unit Tests | — | 3 | — | `tests/unit/` |
| E2E (Playwright) | — | 25 | — | `e2e/` |
| **Vitest Total** | | **313** | |
| **All Test Files** | | **338** | |

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

## API Test Structure

Tests mirror the API route structure with 1:1 file mapping:

```
tests/api/
├── resource/
│   ├── index.test.ts        # GET/POST collection
│   └── [id]/
│       ├── index.test.ts    # GET/PATCH/DELETE item
│       └── action.test.ts   # POST action endpoints
```

To find tests for a specific API area, browse `tests/api/` which mirrors the route structure.

---

## Coverage Gaps

### API Endpoints (100% covered)

All 214 API endpoints have corresponding test files.

Coverage gaps closed in Session 214: communities (4), feeds (4), enrollments/review (1), me/creator-earnings (1), me/full (1).
New in Session 325: student-teachers/[id]/reviews — 1 test file, 13 tests for public ST reviews listing.
New in Session 329: Closed all remaining API test gaps (7 endpoints, 65 tests):
  - `health/kv` — 5 tests (KV write/read/delete cycle, missing binding, errors)
  - `courses/[id]/sessions` — 8 tests (auth, enrollment check, status filtering, duration calc)
  - `sessions/[id]/attendance` — 12 tests (auth, participant/admin access, role derivation)
  - `me/availability/overrides` — 17 tests (teacher auth, GET filtering, POST validation, create available/blocked)
  - `me/availability/overrides/[id]` — 6 tests (auth, ownership, deletion)
  - `me/creator-analytics/materials-feedback` — 12 tests (auth, sub-ratings, responses, pagination, course filter)
  - `stripe/verify-checkout` — 8 tests (auth, Stripe session validation, payment status, idempotent enrollment)
Also renamed 4 test files from flattened to path-mirroring convention (Session 329).
New in Session 333: 7 tests added across 2 existing files:
  - `sessions/index` — +2 tests (rebooking guard: completed enrollment 403, cancelled enrollment 403)
  - `sessions/[id]/index` — +5 tests (late cancel requires reason, late cancel with reason saves flag, cancelled_at saved, reschedule increments count, reschedule limit 422)
New in Session 339: 2 new API test files + 1 integration test (29 tests total):
  - `me/messages/count` — 8 tests (auth, count accuracy across conversations, self-message exclusion, last_read_at handling)
  - `me/messages/read-all` — 7 tests (auth, marks all, count drops to 0, cross-user isolation)
  - `tests/integration/message-lifecycle.test.ts` — 14 tests (full lifecycle: send → count → mark read → multi-conversation sums → cross-user isolation)
New in Session 341: 1 new lib test file (20 tests):
  - `tests/lib/messaging.test.ts` — 20 tests (canMessage: all 11 POLICIES.md §4 relationship rules including student→ST, student→creator, ST→creator, admin→anyone, student→student blocked, unrelated blocked; getMessageableFlags batch checks; messageableContactsSQL search filter)
New in Session 344: 1 new API test file (7 tests):
  - `tests/api/me/can-message/[userId].test.ts` — 7 tests (auth check, self-message blocked, student→teacher allowed, student→creator allowed, unrelated blocked, admin→anyone allowed, anyone→admin allowed)

### Auth/Hook Tests

New in Session 320: `tests/components/auth/useCreatorGate.test.ts` — 11 tests for creator access gate hook (instant cache check, stale refresh, hasCourses flag, loading/visitor states). Pattern C API gate tests added to 4 API test files (creator-dashboard, courses, creator-earnings, communities).

### Unit Tests

New in Session 289: `tests/unit/availability-utils.test.ts` — 26 tests for calendar merge algorithm (override merge, recurring duration, series-end, multi-day recurring, edge cases).

### Page Tests (32 untested of 45)

| Page Group | Pages | Tests | Gap |
|------------|:-----:|:-----:|:---:|
| Auth (login, signup, reset-password) | 3 | 3 | 0 ✓ |
| Courses (course/[slug]/*) | 7 | 2 | 5 |
| Creators (creator/[handle]) | 1 | 2 | 0 ✓ |
| Dashboard (creating/*, learning) | 5 | 3 | 2 |
| Teachers (teacher/[handle]) | 1 | 2 | 0 ✓ |
| Teaching (teaching/*) | 6 | 0 | 6 |
| Profile (@[handle], profile) | 2 | 1 | 1 |
| Discover (discover/*) | 7 | 0 | 7 |
| Community (community/[slug]/*) | 5 | 0 | 5 |
| Settings (settings/*) | 5 | 0 | 5 |
| Other (feed, index, messages, notifications, courses) | 5 | 0 | 5 |

### Other Gaps

| Area | Priority | Notes |
|------|----------|-------|
| OAuth callbacks | Medium | GitHub/Google callback flow tests |
| Webhook handlers | Medium | Stripe: 14 tests covering 7 events + signature + errors (Session 224: added dispute.created, dispute.closed, fixed transfer.created). BBB: 14 tests covering all event types + module_id completion (Session 332: +4 module assignment tests). E2E: Session 335 added BBB webhook completion flow test (synthetic meeting-ended → session completed). |
| R2 operations | Low | File upload/download tests |

---

## Related Documentation

- [CLI-TESTING.md](CLI-TESTING.md) - Testing commands in detail
- [CLI-QUICKREF.md](CLI-QUICKREF.md) - Quick command reference

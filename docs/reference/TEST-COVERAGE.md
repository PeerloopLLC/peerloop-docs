# Test Coverage

Index of all test files organized by category. For testing commands, see [CLI-TESTING.md](CLI-TESTING.md).

**Last Updated:** 2026-02-23 (Session 268)

---

## Quick Reference

| Document | Location | Description |
|----------|----------|-------------|
| [TEST-API.md](TEST-API.md) | `tests/api/` | API endpoint integration tests |
| [TEST-COMPONENTS.md](TEST-COMPONENTS.md) | `tests/components/` | React component tests |
| [TEST-PAGES.md](TEST-PAGES.md) | `tests/pages/` | Page-level tests |
| [TEST-UNIT.md](TEST-UNIT.md) | `tests/unit/`, `tests/integration/`, `tests/ssr/`, `e2e/` | Unit, integration, SSR, E2E tests |

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
| API Endpoints | 193 | 193 | 100% | `tests/api/` |
| SSR Loaders | — | 3 | — | `tests/ssr/` |
| Astro Pages | 45 | 14 | 31% | `tests/pages/` |
| Components | — | 68 | — | `tests/components/` |
| Lib (auth-modal) | — | 1 | — | `tests/lib/` |
| Integration | — | 1 | — | `tests/integration/` |
| Unit Tests | — | 2 | — | `src/__tests__/` |
| Unit Tests | — | 1 | — | `tests/unit/` |
| E2E (Playwright) | — | 1 | — | `e2e/` |
| **Vitest Total** | | **283** | |
| **All Test Files** | | **284** | |

---

## Test Infrastructure

| File | Purpose |
|------|---------|
| `tests/helpers/index.ts` | Test database utilities (describeWithTestDB, getTestDB) |
| `tests/helpers/mock-astro-navigate.ts` | Mock for `astro:transitions/client` (aliased in vitest.config.ts) |
| `tests/api/helpers/index.ts` | API context helpers (createAPIContext, createMockRequest) |
| `vitest.config.ts` | Vitest configuration with path aliases |
| `vitest.global-setup.ts` | Global test setup (database initialization) |
| `vitest.setup.ts` | Per-file test setup |
| `playwright.config.ts` | Playwright configuration |

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

See [TEST-API.md](TEST-API.md) for complete details.

---

## Coverage Gaps

### API Endpoints (1 untested of 193)

193 test files for 193 endpoints. The extra test (`me/creator-analytics/index.test.ts`) covers subdirectory naming. One gap: `health/kv` endpoint has no test file.

Coverage gaps closed in Session 214: communities (4), feeds (4), enrollments/review (1), me/creator-earnings (1), me/full (1).

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
| Webhook handlers | Medium | Stripe: 14 tests covering 7 events + signature + errors (Session 224: added dispute.created, dispute.closed, fixed transfer.created). BBB webhook untested. |
| R2 operations | Low | File upload/download tests |

---

## Related Documentation

- [CLI-TESTING.md](CLI-TESTING.md) - Testing commands in detail
- [CLI-QUICKREF.md](CLI-QUICKREF.md) - Quick command reference

# API Tests

Integration tests for API endpoints using test database (better-sqlite3).

**Last Updated:** 2026-02-24 (Session 278)

---

## Coverage Summary

| Metric | Count |
|--------|------:|
| API Endpoints | 196 |
| Test Files | 194 |
| **Coverage** | **99%** |

*2 untested: `courses/[id]/sessions`, `sessions/[id]/attendance` (added Session 278).*

---

## Test Structure

Tests are organized to **mirror the API route structure**:

```
tests/api/
├── admin/
│   ├── categories/
│   │   ├── index.test.ts          # GET/POST /api/admin/categories
│   │   ├── reorder.test.ts        # POST /api/admin/categories/reorder
│   │   └── [id]/
│   │       └── index.test.ts      # GET/PATCH/DELETE /api/admin/categories/:id
│   ├── users/
│   │   ├── index.test.ts          # GET/POST /api/admin/users
│   │   └── [id]/
│   │       ├── index.test.ts      # GET/PATCH/DELETE /api/admin/users/:id
│   │       ├── suspend.test.ts    # POST /api/admin/users/:id/suspend
│   │       └── unsuspend.test.ts  # POST /api/admin/users/:id/unsuspend
│   └── ...
├── courses/
│   ├── index.test.ts              # GET /api/courses
│   ├── [slug].test.ts             # GET /api/courses/:slug
│   └── [id]/...
└── ...
```

### Naming Convention

| Pattern | Purpose |
|---------|---------|
| `index.test.ts` | Collection endpoints (list, create) or item endpoints (get, update, delete) |
| `[id]/index.test.ts` | Item detail endpoints within ID subdirectory |
| `[id]/action.test.ts` | Action endpoints (e.g., suspend, approve, refund) |
| `[slug].test.ts` | Slug-based lookup endpoints |

---

## Path Aliases

Test files use path aliases instead of deep relative imports:

```typescript
import { POST } from '@/pages/api/admin/users/[id]/suspend';
import { createAPIContext } from '@api-helpers';
import { describeWithTestDB, getTestDB } from '@test-helpers';
```

| Alias | Resolves To |
|-------|-------------|
| `@/` | `src/` |
| `@api-helpers` | `tests/api/helpers` |
| `@test-helpers` | `tests/helpers` |

---

## Test Counts by Area

| Area | Endpoints | Test Files |
|------|----------:|-----------:|
| Admin Analytics | 6 | 6 |
| Admin Categories | 3 | 3 |
| Admin Certificates | 5 | 5 |
| Admin Creator Applications | 4 | 4 |
| Admin Courses | 6 | 6 |
| Admin Dashboard | 1 | 1 |
| Admin Enrollments | 6 | 6 |
| Admin Moderation | 6 | 6 |
| Admin Moderators | 5 | 5 |
| Admin Payouts | 6 | 6 |
| Admin Sessions | 4 | 4 |
| Admin Student-Teachers | 4 | 4 |
| Admin Users | 4 | 4 |
| Auth | 9 | 9 |
| Categories | 1 | 1 |
| Certificates | 1 | 1 |
| Checkout | 1 | 1 |
| Communities | 6 | 6 |
| Contact | 1 | 1 |
| Conversations | 4 | 4 |
| Courses | 8 | 7 |
| Creators | 4 | 4 |
| DB Test | 1 | 1 |
| Debug | 1 | 1 |
| Enrollments | 3 | 3 |
| FAQ | 1 | 1 |
| Feeds | 8 | 8 |
| Flags | 1 | 1 |
| Health | 3 | 2 |
| Homework | 5 | 5 |
| Leaderboard | 1 | 1 |
| Me (Current User) | 46 | 47 |
| Moderator Invites | 3 | 3 |
| Recommendations | 2 | 2 |
| Resources | 1 | 1 |
| Sessions | 6 | 5 |
| Stats | 1 | 1 |
| Stories | 2 | 2 |
| Stream | 1 | 1 |
| Stripe | 3 | 3 |
| Student-Teachers | 2 | 2 |
| Submissions | 1 | 1 |
| Team | 1 | 1 |
| Testimonials | 1 | 1 |
| Topics | 1 | 1 |
| Users | 4 | 4 |
| Webhooks | 2 | 2 |
| **Total** | **196** | **194** |

---

## Test Infrastructure

| File | Purpose |
|------|---------|
| `tests/helpers/index.ts` | Test database utilities (describeWithTestDB, getTestDB, etc.) |
| `tests/api/helpers/index.ts` | API context helpers (createAPIContext, createMockRequest) |
| `vitest.config.ts` | Vitest configuration with path aliases |
| `vitest.global-setup.ts` | Global test setup (database initialization) |
| `vitest.setup.ts` | Per-file test setup |

---

## Running Tests

```bash
# Run all API tests
npm test -- --run tests/api/

# Run tests for a specific area
npm test -- --run tests/api/admin/users/

# Run a specific test file (note: [id] directories work via parent pattern)
npm test -- --run tests/api/auth/login.test.ts
```

---

## Related Documentation

- [TEST-COVERAGE.md](TEST-COVERAGE.md) - Test coverage index
- [API-REFERENCE.md](API-REFERENCE.md) - API endpoint documentation
- [CLI-TESTING.md](CLI-TESTING.md) - Testing commands

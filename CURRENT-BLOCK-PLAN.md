# CURRENT-BLOCK-PLAN.md

## Block: CREATOR-GATE — useCreatorGate Hook + Client-Side Access Cleanup

**Session:** 319 (started), completed Session 320
**Status:** ✅ COMPLETE

---

### Context

Session 319 discovered inconsistent creator access gates across the codebase. Two concepts exist:

- **Permission** (`can_create_courses` flag) — admin-granted capability
- **State** (has existing courses) — derived from data

**Policy established (see POLICIES.md):**
- **Create** new resources → Permission only (`can_create_courses = 1`)
- **View/manage** existing resources → Permission OR State (Pattern C)

### Completed (Session 319)

- [x] Fixed email `from` address → `noreply@send.peerloop.com` (3 files)
- [x] Updated tech doc `docs/tech/tech-004-resend.md` with verified domain + caveat
- [x] Fixed creator access gates to Pattern C (4 API endpoints):
  - `GET /api/me/creator-dashboard`
  - `GET /api/me/courses`
  - `GET /api/me/creator-earnings`
  - `GET /api/me/communities`
- [x] Added analytics empty state in `CreatorAnalytics.tsx` (course count pre-check)
- [x] Created `POLICIES.md` with creator access control policies
- [x] Updated `PLAN.md` — RESEND-DOMAIN complete, COURSE-LIMIT deferred (#16)

### Completed (Session 320)

- [x] Created `useCreatorGate` hook (`src/components/auth/useCreatorGate.ts`)
  - Returns `{ status: 'loading' | 'creator' | 'not-creator', hasCourses: boolean }`
  - Reads `CurrentUser` global state (instant from cache)
  - Handles stale cache via `refreshCurrentUser()` fallback
- [x] Updated 5 components to use the hook:
  - `CreatorDashboard.tsx` — gate before API fetch
  - `CreatorStudio.tsx` — replaced inline 401/403 handling
  - `CreatorAnalytics.tsx` — replaced `/api/me/courses` pre-fetch with `hasCourses`
  - `CreatorCommunities.tsx` — replaced inline 401/403 handling
  - `CreatorEarningsDetail.tsx` — added gate (had no 403 handling before)
- [x] Removed redundant `/api/me/courses` fetch from CreatorAnalytics (eliminated extra round-trip)
- [x] Updated POLICIES.md with `useCreatorGate` client-side gate policy
- [x] Updated 4 test files with `vi.mock` for useCreatorGate
- [x] Fixed pre-existing test assertion bug in CreatorStudio (edit course URL)
- [x] All 296 test files pass (5,423 tests)

### Files Changed in Session 320

**Code repo (`../Peerloop/`):**
- `src/components/auth/useCreatorGate.ts` — NEW: reusable creator access gate hook
- `src/components/dashboard/CreatorDashboard.tsx` — added useCreatorGate
- `src/components/creators/studio/CreatorStudio.tsx` — replaced 401/403 handling with useCreatorGate
- `src/components/analytics/CreatorAnalytics.tsx` — replaced courses pre-fetch with useCreatorGate
- `src/components/creators/communities/CreatorCommunities.tsx` — replaced 401/403 handling with useCreatorGate
- `src/components/creators/workspace/CreatorEarningsDetail.tsx` — added useCreatorGate
- `tests/pages/dashboard/CreatorDashboard.test.tsx` — added useCreatorGate mock
- `tests/components/creator/CreatorStudio.test.tsx` — added mock, updated 403/401 tests, fixed edit URL assertion
- `tests/components/analytics/CreatorAnalytics.test.tsx` — added useCreatorGate mock
- `tests/components/dashboard/CreatorDashboard.test.tsx` — added useCreatorGate mock

**Docs repo (`peerloop-docs/`):**
- `POLICIES.md` — added useCreatorGate policy + updated analytics empty state policy
- `CURRENT-BLOCK-PLAN.md` — marked complete

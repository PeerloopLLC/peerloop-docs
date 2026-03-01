# CURRENT-BLOCK-PLAN.md

## Block: CREATOR-GATE — useCreatorGate Hook + Client-Side Access Cleanup

**Session:** 319 (started), continuing post-compact
**Status:** 🔄 IN PROGRESS

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

### Remaining: useCreatorGate Hook

**Goal:** Replace scattered 403-handling and redundant API pre-fetches with a single reusable hook that checks `CurrentUser` global state.

#### 1. Create `useCreatorGate` hook

**File:** `src/components/auth/useCreatorGate.ts` (alongside existing `useRequireAuth.ts`)

**Returns:** `{ status: 'loading' | 'creator' | 'not-creator', hasCourses: boolean }`

**Logic:**
```
Mount → getCurrentUser() (instant, from cache)
  ├── canCreateCourses || hasCreatedCourses() → status='creator'
  └── neither → refreshCurrentUser() → recheck
        ├── now passes → status='creator' (stale cache was the issue)
        └── still fails → status='not-creator'

hasCourses = getCurrentUser().hasCreatedCourses()
```

**Staleness handling:** If cached `CurrentUser` says "not creator" but user is on `/creating/*`, the hook calls `refreshCurrentUser()` before showing a gate. Handles the scenario where admin just approved a creator application.

#### 2. Update 4-5 components to use the hook

| Component | Currently Does | Change To |
|-----------|---------------|-----------|
| `CreatorDashboard.tsx` | Calls API, handles 403 | `useCreatorGate()` → show empty/redirect if not-creator |
| `CreatorStudio.tsx` | Calls `/api/me/courses`, handles 403 | Same pattern |
| `CreatorAnalytics.tsx` | Fetches `/api/me/courses` just for course count | `useCreatorGate()` → use `hasCourses` for empty state |
| `CreatorCommunities.tsx` | Calls `/api/me/communities`, handles 403 | Same pattern |
| Creator earnings component | TBD — check if component exists | Same pattern |

#### 3. Remove redundant pre-fetch from CreatorAnalytics

The `/api/me/courses` fetch added in Session 319 for the course count gate can be replaced by `useCreatorGate().hasCourses`. This eliminates the extra network round-trip.

#### 4. Add to POLICIES.md

Add policy: "Creator pages use `useCreatorGate` hook for client-side access checks. Server-side API gates remain for security."

### What Stays Unchanged

- All server-side API gates (Pattern A, B, C) — security enforcement
- Pattern D (course ownership checks) — fine as-is
- The 8 analytics API endpoints stay Pattern B — gated client-side by `hasCourses`

### Files Changed in Session 319 (for reference)

**Code repo (`../Peerloop/`):**
- `src/lib/email.ts` — configurable from address
- `src/pages/api/admin/moderators/invite.ts` — from address
- `src/pages/api/admin/moderators/[id]/resend.ts` — from address
- `src/pages/api/me/creator-dashboard.ts` — Pattern C gate
- `src/pages/api/me/courses/index.ts` — Pattern C gate
- `src/pages/api/me/creator-earnings.ts` — Pattern C gate
- `src/pages/api/me/communities/index.ts` — Pattern C gate (GET only)
- `src/components/analytics/CreatorAnalytics.tsx` — course count pre-check + empty state
- `.dev.vars.example` — RESEND_FROM docs

**Docs repo (`peerloop-docs/`):**
- `POLICIES.md` — new file
- `PLAN.md` — RESEND-DOMAIN complete, COURSE-LIMIT added
- `CLAUDE.md` — POLICIES.md references added
- `docs/tech/tech-004-resend.md` — verified domain + caveat

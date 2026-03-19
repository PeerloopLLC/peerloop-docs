# State Management Architecture

**Created:** 2026-01-29 (Session 146)
**Status:** Active

## Architectural Principle: Read-Only Cache

**CurrentUser is a client-side convenience cache, not a source of truth.**

| Layer | Role | Authority |
|-------|------|-----------|
| JWT session cookie | Identity authority | Server uses this to determine *who* is making a request |
| Database (D1) | Data authority | API endpoints query this for current values and permissions |
| CurrentUser global | UI convenience cache | Components read this for show/hide decisions, never for authorization |

**Rules:**
- Components may read `getCurrentUser()` for UI rendering decisions (show buttons, badges, prompts)
- API endpoints must **never** trust client-sent CurrentUser data — they derive identity from the session and query the DB
- CurrentUser data may be stale — this is a UX concern, not a security concern
- All updates go through `refreshCurrentUser()` which fetches fresh data from `/api/me/full`
- The `CurrentUser` class is fully immutable (`readonly` properties); `setCurrentUser()` is private to the library

**External service keys** (e.g., `stripeAccountId`) are cached in CurrentUser for convenience — components can check `hasStripeConnected()` instantly without an API call. The server remains the authority for all Stripe operations.

## Overview

Peerloop uses a hybrid state management approach designed for Astro's islands architecture. This document explains how user authentication state and network status are managed across page navigations and within single pages.

### The Problem

1. **Cross-page state:** User logs in on page A, navigates to page B - how does B know they're logged in?
2. **Same-page state:** Multiple React islands on one page need to share auth status - how do they communicate?
3. **Network errors:** API calls fail - how do we show appropriate UI (retry vs re-login)?

### The Solution

Three layers working together:

| Layer | Scope | Persistence | Purpose |
|-------|-------|-------------|---------|
| Session cookie | Cross-page | Browser manages | Server knows you're authenticated |
| localStorage | Cross-page | Survives page loads | Cached user data, login flag |
| Window globals | Same-page | Resets on navigation | React islands share state |

## Two Globals Architecture

Two separate globals on `window.__peerloop`:

```typescript
window.__peerloop = {
  currentUser: CurrentUser | null,  // Pure user data
  networkState: {                   // Network/auth status
    authStatus: 'loading' | 'authenticated' | 'visitor' | 'session_expired' | 'error',
    authError?: string,
    lastAuthAttempt?: string,
  }
}
```

### Why Two Globals?

**Separation of concerns:**
- `currentUser` answers: "Who is this user? What can they do?"
- `networkState` answers: "Did the API call succeed? What went wrong?"

**Clean mental model:**
- User data doesn't get polluted with network error strings
- Network status is extensible (could add `apiHealth`, `isOnline` later)

### Accessors

```typescript
import { getCurrentUser, getNetworkState } from '@lib/current-user';

// Get user data (null if not authenticated)
const user = getCurrentUser();
if (user?.isTeacherFor(courseId)) { ... }

// Get network/auth status
const { authStatus, authError } = getNetworkState();
if (authStatus === 'session_expired') { ... }
```

## Persistence Layer

### Session Cookie

- **Set by:** `/api/auth/login` endpoint
- **HTTP-only:** JavaScript can't read it (security)
- **Sent with:** Every request to `/api/*`
- **Survives:** Page navigations, browser restarts (until expiry)

The cookie is the **source of truth** for "is this user authenticated?" on the server side.

### localStorage Keys

| Key | Purpose | Set When | Cleared When |
|-----|---------|----------|--------------|
| `peerloop_user_cache` | Cached `MeFullResponse` data | Successful `/api/me/full` | Logout, or 401 response |
| `peerloop_was_logged_in` | Flag: user was previously logged in | Successful auth | Explicit logout only |

### Why `was_logged_in` Flag?

Distinguishes between:
- **True visitor:** Never logged in → show "Sign up" CTA
- **Session expired:** Was logged in, session now invalid → show "Session expired, log in again"

```typescript
// On 401 response:
if (wasLoggedIn()) {
  setNetworkState({ authStatus: 'session_expired' });
} else {
  setNetworkState({ authStatus: 'visitor' });
}
```

## Astro Islands Pattern

### The Challenge

Astro pages are server-rendered HTML with "islands" of interactivity (React components). Each island is isolated - they don't share React context.

```astro
<!-- page.astro -->
<AppNavbar client:load />      <!-- React island 1 -->
<CourseList client:load />       <!-- React island 2 -->
<UserProfile client:load />      <!-- React island 3 -->
```

### The Solution: Window Globals

All islands on the same page share `window`. One island initializes the globals, others read from them.

```
Page Load
    ↓
AppNavbar mounts first (client:load)
    ↓
Calls initializeCurrentUser()
    ↓
Sets window.__peerloop.currentUser
Sets window.__peerloop.networkState
    ↓
Other islands read via getCurrentUser() / getNetworkState()
```

### Important: Initialization Order

The "main" navbar component (AppNavbar, AdminNavbar) should:
1. Mount early (`client:load`)
2. Call `initializeCurrentUser()` in `useEffect`
3. Other components can then read from globals

If a component reads before initialization completes, it gets:
- `currentUser`: `null` (or cached value from localStorage)
- `networkState`: `{ authStatus: 'loading' }`

## Page Load Flow

### Full Page Navigation (Astro Default)

```
User clicks link to /dash/courses
         ↓
Browser: Full page load
         ↓
window.__peerloop = undefined (reset)
         ↓
Server renders new page HTML
         ↓
AppNavbar island mounts
         ↓
initializeCurrentUser():
  1. Read localStorage cache → instant user data
  2. Set currentUser + networkState (optimistic)
  3. Fetch /api/me/full (cookie sent automatically)
  4. Update globals with fresh data
         ↓
Other islands read from globals
```

### Same-Page Interaction

```
User clicks "My Feeds" button
         ↓
FeedSlidePanel opens (same page, same window)
         ↓
Reads getNetworkState().authStatus
         ↓
Shows appropriate UI based on auth status
```

## Cross-Page vs Same-Page State

| Aspect | Cross-Page | Same-Page |
|--------|------------|-----------|
| State survives? | Via cookie + localStorage | Via window globals |
| Mechanism | Stale-while-revalidate | Shared globals |
| User data | Cached, re-verified on load | Live in memory |
| Network status | Reset, fresh per page | Shared across islands |

### Stale-While-Revalidate Pattern

1. **Stale:** Show cached user data instantly (from localStorage)
2. **Revalidate:** Fetch fresh data in background
3. **Update:** If data changed, update UI

This gives instant perceived load while ensuring fresh data.

```typescript
// In initializeCurrentUser():

// 1. Instant from cache
const cached = loadFromCache();
if (cached) {
  setCurrentUser(new CurrentUser(cached));
  setNetworkState({ authStatus: 'authenticated' });
}

// 2. Fetch fresh (background)
const response = await fetch('/api/me/full');
const data = await response.json();

// 3. Update with fresh
setCurrentUser(new CurrentUser(data));
saveToCache(data);
```

## Data Freshness & External Changes

### The Problem

`CurrentUser` instances are **immutable** - all properties are `readonly`. Once created, the instance cannot be modified. This raises the question: what happens when data changes externally?

**Examples of external changes:**
- Admin grants `canTeachCourses` to a user
- Creator certifies user as Teacher for a course
- User's enrollment status changes (completed, cancelled)
- Admin revokes capabilities

### Staleness Contract

CurrentUser data may be briefly stale on page load (cached from localStorage). Components using `useCurrentUser()` re-render automatically when fresh data arrives via background refresh.

**Staleness windows:**
- **Own mutations:** ~100-300ms (immediate `refreshCurrentUser()` call after mutation)
- **External changes:** ≤30 seconds (version polling interval)
- **Tab switch:** Immediate (window focus refresh)

**Security note:** The server always validates permissions on API calls. Stale client state may show incorrect UI temporarily, but cannot bypass security.

### Refresh Mechanisms

```typescript
import { refreshCurrentUser } from '@lib/current-user';

// Force refresh from API (ignores cache)
await refreshCurrentUser();
```

### Version Polling (CURRENTUSER-OPTIMIZE, Conv 013)

Each user has a monotonic `data_version` counter in the `users` table. Mutation endpoints call `bumpUserDataVersion()` after changing data that CurrentUser carries. The client polls `GET /api/me/version` every 30 seconds.

```
Server side:
  POST /api/enrollments/complete  →  bumps data_version for student
  POST /api/admin/teachers/activate  →  bumps data_version for teacher
  POST /api/webhooks/stripe (checkout)  →  bumps data_version for student

Client side:
  Every 30s: GET /api/me/version  →  { version: 47 }
  CurrentUser was built from version 46
  Version mismatch → refreshCurrentUser()
```

**What bumps `data_version`:** Profile updates, capability changes, enrollment CRUD, teacher certification changes, course creation/activation, community moderation, Stripe status updates, notification/message creation (unread counts).

**What does NOT bump `data_version`:** Course content (modules, pricing), session schedules, earnings/payouts, feed activity (Stream.io), other users' data. These are fetched by page-level dashboard APIs, not carried by CurrentUser.

**Key files:**
- `src/lib/user-data-version.ts` — `bumpUserDataVersion()` and `getUserDataVersion()` helpers
- `src/pages/api/me/version.ts` — Ultra-lightweight polling endpoint (~20 byte response)
- `src/lib/current-user.ts` — `startVersionPolling()`, `stopVersionPolling()` (managed by `initializeCurrentUser` / `clearCurrentUser`)

### Principle: Consume What's Loaded

**If CurrentUser already loads the data (for any reason), consume it from CurrentUser rather than re-fetching.** Dashboard endpoints remain for operational/transactional data (earnings, session schedules, pending action counts) that CurrentUser doesn't carry.

This supersedes the earlier "summary vs. detail" rule which was: *"If data answers a yes/no question across multiple pages, cache it in CurrentUser. If it's only needed on one page, fetch it there."* That rule created a blind spot where dashboards re-fetched data that CurrentUser already had loaded for permission checking.

### All Refresh Triggers

| Trigger | Implemented | Location |
|---------|-------------|----------|
| Page navigation | Yes | `initializeCurrentUser()` in navbar |
| Window focus | Yes | `AppNavbar.tsx` |
| Version polling (30s) | Yes | `startVersionPolling()` in `current-user.ts` |
| After own mutations | Yes | `bumpUserDataVersion()` server-side + client calls `refreshCurrentUser()` |
| Push (WebSocket/SSE) | No | Version polling is compatible — upgrade transport without changing `data_version` column |
| Broadcast Channel | No | Would sync across browser tabs (same origin) |

### Design Rationale

Version polling was chosen over push mechanisms because:

1. **Simplicity** — One column, one endpoint, one `setInterval`. No Durable Objects or SSE infrastructure.
2. **Cheap** — `SELECT data_version FROM users WHERE id = ?` is ~1ms on D1. Response is ~20 bytes.
3. **Upgrade path** — The `data_version` column stays if we later add SSE or WebSockets; only the transport changes.
4. **Sufficient for scale** — 30-second interval is fast enough for external changes. Own mutations trigger immediate refresh.

## Page Areas

Different areas of the app have different initialization patterns:

| Area | Navbar Component | Initializes Globals? |
|------|------------------|---------------------|
| APP (`/`, `/learning`, `/teaching`, `/creating`, `/discover/*`, etc.) | AppNavbar | Yes |
| ADMIN (`/admin/*`) | AdminNavbar | Yes (Session 261) |
| PUBLIC (`/login`, `/signup`, `/reset-password`) | AppNavbar (via AppLayout) | Yes |

### APP Pages

All use AppLayout → AppNavbar → `initializeCurrentUser()`. AppNavbar persists across View Transitions (`transition:persist="app-navbar"`), refreshes on window focus, and handles session expiry detection.

### ADMIN Pages

All use AdminLayout → AdminNavbar → `initializeCurrentUser()`. AdminNavbar initializes CurrentUser on mount, displays admin identity (name/email/avatar), and redirects to `/login` on session expiry.

### PUBLIC Pages

Login, signup, and reset-password all use AppLayout, so they already have CurrentUser via AppNavbar. No standalone public pages exist yet outside AppLayout.

## Code Examples

### Reading User Data

```typescript
import { getCurrentUser } from '@lib/current-user';

function CourseActions({ courseId }: { courseId: string }) {
  const user = getCurrentUser();

  if (!user) return <LoginPrompt />;

  if (user.isCreatorFor(courseId)) {
    return <CreatorControls />;
  }

  if (user.isTeacherFor(courseId)) {
    return <TeacherControls />;
  }

  return <StudentControls />;
}
```

### Reading Network Status

```typescript
import { getNetworkState } from '@lib/current-user';

function AuthStatusBanner() {
  const { authStatus, authError } = getNetworkState();

  switch (authStatus) {
    case 'loading':
      return <LoadingSpinner />;
    case 'authenticated':
      return null;
    case 'visitor':
      return <SignUpCTA />;
    case 'session_expired':
      return <SessionExpiredBanner onReLogin={handleReLogin} />;
    case 'error':
      return <ErrorBanner message={authError} onRetry={handleRetry} />;
  }
}
```

### Logout Flow

```typescript
import { clearCurrentUser } from '@lib/current-user';

async function handleLogout() {
  // 1. Clear client-side state
  clearCurrentUser(true);  // true = explicit logout, clears was_logged_in flag

  // 2. Clear server-side session
  await fetch('/api/auth/logout', { method: 'POST' });

  // 3. Redirect
  window.location.href = '/';
}
```

## Cache Structural Guard

**Added:** Session 362

**Problem:** After a deploy, the cached `MeFullResponse` may have a different shape than the code expects. The navbar renders garbage from the stale cache for a split second before the API refresh corrects it.

**Solution:** `isValidCachedData()` — a type guard in `loadFromCache()` that checks critical fields before the cache is used.

### What It Checks

| Field | Why Required |
|-------|-------------|
| `user.id` | Used as key for all user-specific operations |
| `user.name` | Rendered in AppNavbar, UserAccountDropdown |
| `user.handle` | Used in profile links, @ mentions |
| `enrollments` | `CurrentUser` constructor `.map()`s over it — non-array throws |
| `teacherCertifications` | Same — `.map()` in constructor |
| `createdCourses` | Same — `.map()` in constructor |

### What It Does NOT Check

- Optional fields (`stats`, `expertise`, `communityModerations`) — the constructor uses `?? []` fallbacks
- Array element shapes — semantic issues are corrected by the API refresh
- Data freshness — semantic staleness is handled by the background API refresh

### When Guard Fails

1. Removes the stale cache from localStorage
2. Returns `null`
3. The UI shows a brief loading skeleton (~200ms) instead of broken content
4. The API refresh hydrates fresh data normally

This is **self-healing** — no manual intervention, no version bumps, no build system changes needed.

### Design Decisions

**Why not a build version key?** Would force a loading flash for every user on every deploy, even when the API shape didn't change. Requires build infrastructure. Doesn't help with semantic staleness (which the API refresh already handles).

**Why not full schema validation?** Creates maintenance burden — every new `MeFullResponse` field would need a guard update. Rejects valid data unnecessarily. The guard checks only the minimum fields that would cause a crash or broken render.

**Why no TTL (Time-To-Live)?** The API refresh runs on every page load — the cache is never the final source of truth. A TTL would cause unnecessary loading flashes for frequent visitors.

### Maintenance Notes

- **Adding required fields to `MeFullResponse`:** If a new field is required by the `CurrentUser` constructor (not optional/defaulted), add a check in `isValidCachedData()`.
- **Removing fields:** If a guarded field is removed from the API response, remove it from the guard.
- **The guard is intentionally minimal.** The API refresh corrects everything within milliseconds.

## Related Files

| File | Purpose |
|------|---------|
| `src/lib/current-user.ts` | CurrentUser class, globals, accessors, cache structural guard |
| `src/pages/api/me/full.ts` | API endpoint for full user state |
| `src/components/layout/AppNavbar.tsx` | APP navbar, initializes globals |
| `src/components/layout/AdminNavbar.tsx` | Admin navbar, initializes globals (Session 261) |
| `tests/lib/current-user-cache.test.ts` | Cache behavior tests (17 tests) |

## References

- [Astro Islands](https://docs.astro.build/en/concepts/islands/)
- [Stale-While-Revalidate](https://web.dev/stale-while-revalidate/)
- PLAN.md → CURRENTUSER block

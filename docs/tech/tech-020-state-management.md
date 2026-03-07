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

### Current Behavior

The user's `CurrentUser` instance will **not** automatically update. Fresh data is only fetched:

1. **On page load** - `initializeCurrentUser()` fetches from API
2. **Explicit refresh** - Code calls `refreshCurrentUser()`

There is no push mechanism (WebSocket, SSE, polling) to notify the client of changes.

### Refresh Mechanisms

```typescript
import { refreshCurrentUser } from '@lib/current-user';

// Force refresh from API (ignores cache)
await refreshCurrentUser();
```

### Implemented Patterns

**1. Refresh on window focus** (user returns to tab) - **IMPLEMENTED in AppNavbar**
```typescript
// In AppNavbar.tsx
useEffect(() => {
  const handleFocus = async () => {
    await refreshCurrentUser();
    setUser(getCurrentUser());
    forceUpdate((n) => n + 1);
  };
  window.addEventListener('focus', handleFocus);
  return () => window.removeEventListener('focus', handleFocus);
}, []);
```

This catches the scenario where a user is on the platform, an admin/creator makes changes, and the user switches tabs or returns to the browser.

### Additional Patterns (Not Yet Implemented)

Depending on how critical real-time updates are, consider these approaches:

**2. Refresh after sensitive actions**
```typescript
// After admin grants capability
await grantCapability(userId, 'canTeachCourses');
// If current user is the affected user, refresh
if (getCurrentUser()?.id === userId) {
  await refreshCurrentUser();
}
```

**3. Periodic refresh** (polling)
```typescript
// Refresh every 5 minutes
useEffect(() => {
  const interval = setInterval(() => refreshCurrentUser(), 5 * 60 * 1000);
  return () => clearInterval(interval);
}, []);
```

**4. Refresh on specific routes**
```typescript
// Force fresh data on capability-sensitive pages
useEffect(() => {
  refreshCurrentUser();
}, []);
```

### What's NOT Implemented

| Mechanism | Status | Notes |
|-----------|--------|-------|
| WebSocket push | Not implemented | Would require server infrastructure |
| Server-Sent Events | Not implemented | Simpler than WebSocket, still needs server support |
| Polling | Not implemented by default | Can be added per-component as needed |
| Broadcast Channel | Not implemented | Would sync across browser tabs |

### Design Rationale

The current pull-based approach was chosen because:

1. **Simplicity** - No WebSocket infrastructure needed
2. **Sufficient for MVP** - Capability changes are rare admin actions
3. **Page loads are frequent** - Users naturally get fresh data on navigation
4. **Window focus refresh** - Catches changes made while user was away
5. **Stale data is usually harmless** - UI might show/hide a button incorrectly, but API calls still validate permissions server-side

**Important:** The server always validates permissions on API calls. Stale client state may show incorrect UI, but cannot bypass security.

### Current Implementation Summary

| Trigger | Implemented | Location |
|---------|-------------|----------|
| Page navigation | Yes | `initializeCurrentUser()` in navbar |
| Window focus | Yes | `AppNavbar.tsx` |
| After admin/creator actions | Caller's responsibility | Call `refreshCurrentUser()` after mutations |
| Polling | No | Add if needed |
| Push (WebSocket/SSE) | No | Add if needed |

### Future Considerations

If real-time updates become critical:

1. **Broadcast Channel API** - Sync state across browser tabs (same origin)
2. **SSE endpoint** - Push capability changes to connected clients
3. **Polling with exponential backoff** - Simple, works everywhere

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

## Related Files

| File | Purpose |
|------|---------|
| `src/lib/current-user.ts` | CurrentUser class, globals, accessors |
| `src/pages/api/me/full.ts` | API endpoint for full user state |
| `src/components/layout/AppNavbar.tsx` | APP navbar, initializes globals |
| `src/components/layout/AdminNavbar.tsx` | Admin navbar, initializes globals (Session 261) |

## References

- [Astro Islands](https://docs.astro.build/en/concepts/islands/)
- [Stale-While-Revalidate](https://web.dev/stale-while-revalidate/)
- PLAN.md → CURRENTUSER block

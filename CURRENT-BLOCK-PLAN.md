# CURRENT-BLOCK-PLAN: MESSAGING

**Block:** MESSAGING — Messaging & Notifications UX
**Status:** 🔄 IN PROGRESS (Session 339)
**Goal:** Bring Messages UX to parity with Notifications UX, add missing badges, filtering, and bulk read actions.

---

## Summary

| Step | Description | Status |
|------|-------------|--------|
| 1 | `/api/me/messages/count` endpoint | COMPLETE |
| 2 | `/api/me/messages/read-all` endpoint | COMPLETE |
| 3 | Messages badge in AppNavbar | COMPLETE |
| 4 | All/Unread filter tabs in ConversationList | COMPLETE |
| 5 | "Mark all read" button in ConversationList | COMPLETE |
| 6 | Tests for new API endpoints | COMPLETE |
| 7 | Integration tests for badge count lifecycle | COMPLETE |
| 8 | Notifications UI parity review | COMPLETE |

---

## Step 1: `/api/me/messages/count` Endpoint — COMPLETE

**File:** `src/pages/api/me/messages/count.ts`

**What it does:** Returns total unread message count across all conversations for the authenticated user. Mirrors the notification count endpoint pattern.

**SQL approach:** Uses a correlated subquery that sums unread messages per conversation — messages from other users created after the user's `last_read_at`, or all messages from others if `last_read_at` is NULL.

**Response:** `{ count: number }`

---

## Step 2: `/api/me/messages/read-all` Endpoint — COMPLETE

**File:** `src/pages/api/me/messages/read-all.ts`

**What it does:** PATCH endpoint that sets `last_read_at = now()` on all `conversation_participants` rows for the current user. This marks every conversation as fully read.

**Response:** `{ success: true, marked_count: number }`

---

## Step 3: Messages Badge in AppNavbar — COMPLETE

**File:** `src/components/layout/AppNavbar.tsx`

**Changes:**
- Added `unreadMessageCount` state (line 81)
- Added `useEffect` with `/api/me/messages/count` fetch + 60s polling (mirrors notification polling)
- Added badge rendering for `item.id === 'messages'` — red pill, 99+ cap

**Pattern:** Identical to the notification badge added in Session 338. Both use the same visual style, polling interval, and overflow handling.

---

## Step 4: All/Unread Filter Tabs in ConversationList — COMPLETE

**File:** `src/components/messages/ConversationList.tsx`

**Changes:**
- Added `filter` state (`'all' | 'unread'`)
- Filter tabs matching NotificationsList visual pattern (rounded pill buttons in gray bg)
- `filteredConversations` derived from filter state
- Empty state for "All caught up!" when filtering by unread with no results
- Unread count badge on the "Unread" tab

---

## Step 5: "Mark All Read" Button — COMPLETE

**File:** `src/components/messages/ConversationList.tsx`

**Changes:**
- "Mark all read" button in header (visible only when `unreadTotal > 0`)
- Calls `PATCH /api/me/messages/read-all`
- Dispatches `messages:mark-all-read` custom event
- Parent `Messages.tsx` listens for event and refetches conversations

---

## Step 6: Tests for New API Endpoints — COMPLETE

### `/api/me/messages/count` Tests — 8 tests

**File:** `tests/api/me/messages/count.test.ts`

- [x] Returns 401 for unauthenticated requests
- [x] Returns `{ count: 0 }` when user has no messages
- [x] Counts unread messages from other users in one conversation
- [x] Sums unread across multiple conversations
- [x] Does not count messages sent by the user themselves
- [x] Returns 0 after all conversations marked read
- [x] Counts only messages after last_read_at
- [x] Returns 503 when database is unavailable

### `/api/me/messages/read-all` Tests — 7 tests

**File:** `tests/api/me/messages/read-all.test.ts`

- [x] Returns 401 for unauthenticated requests
- [x] Marks all conversations as read
- [x] Sets last_read_at on all participant rows
- [x] Count returns 0 after mark-all-read
- [x] Does not affect other users' read state
- [x] Other user still sees their unread count
- [x] Returns 503 when database is unavailable

---

## Step 7: Integration Tests for Badge Count Lifecycle — COMPLETE

**File:** `tests/integration/message-lifecycle.test.ts` — 14 tests

Single conversation lifecycle:
- [x] Alice creates conversation with Bob
- [x] Count is 0 (no messages from Bob)
- [x] Bob sends message → Alice count is 1
- [x] Bob sends another → Alice count is 2
- [x] Alice marks read → count drops to 0
- [x] New message after read → count goes back up
- [x] Conversation list unread_count matches count endpoint

Multi-conversation counts:
- [x] Alice has conversations with both Bob and Carol
- [x] Messages from both sum up (NULL last_read_at counts all)
- [x] Reading one conversation only reduces that conversation's count
- [x] Mark all read clears everything

Cross-user isolation:
- [x] Sender's own messages don't count toward their unread
- [x] Alice's mark-all-read doesn't affect Bob's unread

**Key pattern:** Tests use NULL `last_read_at` for reliable counting — avoids SQLite/JS timestamp precision issues where `datetime('now')` (SQLite format) vs `new Date().toISOString()` (ISO format) differ in string comparison.

---

## Step 8: Notifications UI Parity Review — COMPLETE

**Verified:** Notifications UI already has all features. No changes needed.

- [x] Badge in AppNavbar (Session 338)
- [x] All/Unread filter tabs
- [x] Mark all as read button
- [x] Individual mark-as-read on click
- [x] Blue unread dot indicator
- [x] Bold title for unread
- [x] Delete individual
- [x] Clear read (bulk delete)
- [x] Pagination with "Load more"

---

## Design Decisions

### Badge Styling
Both Messages and Notifications badges use the same visual: red pill (`bg-red-500`), white text, 11px font, `min-w-5` for consistent sizing, caps at "99+". This follows the AppHeader's existing badge pattern but with a higher cap (99+ vs 9+) since the sidebar has more space.

### Filter Tabs
Messages filter tabs use the same visual pattern as Notifications: pill-shaped buttons in a `bg-secondary-100` container, with the active tab having a white background and shadow. The Messages version is slightly more compact (`text-xs`, `py-1.5`) since it shares space with the conversation list header.

### Mark All Read Communication
ConversationList dispatches a `messages:mark-all-read` custom event after calling the API. The parent Messages component listens for this event and triggers an immediate `fetchConversations()` call, avoiding prop-drilling a callback through multiple levels.

### Polling Strategy
Both badges poll every 60 seconds. The Messages component itself polls every 10 seconds for thread updates, but the AppNavbar badge uses the slower 60s interval since it's a background indicator, not the active view.

---

## Files Changed

| File | Change |
|------|--------|
| `src/pages/api/me/messages/count.ts` | NEW — unread message count endpoint |
| `src/pages/api/me/messages/read-all.ts` | NEW — mark all conversations read endpoint |
| `src/components/layout/AppNavbar.tsx` | Messages badge + unreadMessageCount state + polling |
| `src/components/messages/ConversationList.tsx` | Filter tabs + mark-all-read button + unread total |
| `src/components/messages/Messages.tsx` | Listen for mark-all-read event |

## Test Files Created

| File | Tests | Purpose |
|------|------:|---------|
| `tests/api/me/messages/count.test.ts` | 8 | Count endpoint tests |
| `tests/api/me/messages/read-all.test.ts` | 7 | Mark-all-read endpoint tests |
| `tests/integration/message-lifecycle.test.ts` | 14 | Full lifecycle integration tests |
| **Total** | **29** | |

# API Reference: Messages

Direct messaging endpoints for conversations between users. Part of [API Reference](API-REFERENCE.md).

---

## Overview

The messaging system supports 1:1 conversations between users (students, teachers, creators). Each conversation tracks participants and their read status.

---

## Conversation Endpoints

### GET /api/conversations

List all conversations for the current user.

**Auth:** Required

**Response (200):**
```json
{
  "conversations": [
    {
      "id": "conv-123",
      "created_at": "2026-01-22T10:00:00Z",
      "updated_at": "2026-01-22T15:30:00Z",
      "participants": [
        {
          "id": "usr-456",
          "name": "John Doe",
          "handle": "johndoe",
          "avatar_url": "/avatars/johndoe.jpg"
        }
      ],
      "last_message": {
        "id": "msg-789",
        "sender_id": "usr-456",
        "content": "Thanks for the help!",
        "created_at": "2026-01-22T15:30:00Z"
      },
      "unread_count": 2
    }
  ]
}
```

---

### POST /api/conversations

Create a new conversation or find existing one with a user.

**Auth:** Required

**Request Body:**
```json
{
  "recipient_id": "usr-456",
  "message": "Hi, I have a question about..." // optional initial message
}
```

**Response (200 if existing, 201 if created):**
```json
{
  "conversation_id": "conv-123"
}
```

**Errors:**
- `400` - recipient_id required or cannot message yourself
- `403` - No messaging relationship with this user (POLICIES.md §4)
- `404` - Recipient not found

**Access Control (Session 341):** Validates messaging relationship via `canMessage()` from `src/lib/messaging.ts`. Only users with a platform relationship (enrollment, Teacher certification, or admin status) can create conversations. See POLICIES.md section 4 for the full relationship matrix.

---

### GET /api/conversations/[id]

Get conversation details with messages.

**Auth:** Required (must be participant)

**Query Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `page` | number | 1 | Page number |
| `limit` | number | 50 | Messages per page (max 100) |

**Response (200):**
```json
{
  "conversation": {
    "id": "conv-123",
    "created_at": "2026-01-22T10:00:00Z",
    "updated_at": "2026-01-22T15:30:00Z",
    "participants": [
      {
        "id": "usr-current",
        "name": "Current User",
        "handle": "currentuser",
        "avatar_url": null
      },
      {
        "id": "usr-456",
        "name": "John Doe",
        "handle": "johndoe",
        "avatar_url": "/avatars/johndoe.jpg"
      }
    ]
  },
  "messages": {
    "items": [
      {
        "id": "msg-001",
        "sender_id": "usr-current",
        "content": "Hello!",
        "created_at": "2026-01-22T10:00:00Z",
        "sender": {
          "name": "Current User",
          "handle": "currentuser",
          "avatar_url": null
        }
      }
    ],
    "total": 25,
    "page": 1,
    "limit": 50,
    "totalPages": 1,
    "hasMore": false
  }
}
```

**Errors:**
- `404` - Conversation not found or not a participant

---

### POST /api/conversations/[id]/messages

Send a message in a conversation.

**Auth:** Required (must be participant)

**Request Body:**
```json
{
  "content": "Message text here"
}
```

**Response (201):**
```json
{
  "message": {
    "id": "msg-new",
    "sender_id": "usr-current",
    "content": "Message text here",
    "created_at": "2026-01-22T15:35:00Z",
    "sender": {
      "name": "Current User",
      "handle": "currentuser",
      "avatar_url": null
    }
  }
}
```

**Errors:**
- `400` - Content required or message too long (max 5000 chars)
- `403` - Messaging relationship no longer active (POLICIES.md §4)
- `404` - Conversation not found or not a participant

**Access Control (Session 341):** Validates that the sender still has an active messaging relationship with all other participants. If a relationship ends (enrollment cancelled, Teacher deactivated), existing conversations remain readable but new messages return 403.

---

### PUT /api/conversations/[id]/read

Mark conversation as read for current user.

**Auth:** Required (must be participant)

**Response (200):**
```json
{
  "success": true,
  "last_read_at": "2026-01-22T15:40:00Z"
}
```

**Errors:**
- `404` - Conversation not found or not a participant

---

## Message Dashboard Endpoints

### GET /api/me/messages/count

Get total unread message count across all conversations. (Endpoint live; its former global-badge consumer, the legacy `AppNavbar`, was retired with the `/old` shell in Conv 339 — no Matt-shell consumer is currently wired.)

**Auth:** Required

**Response (200):**
```json
{
  "count": 5
}
```

**Notes:**
- Sums unread messages across all conversations the user participates in
- Unread = messages from other users created after the user's `last_read_at`
- If `last_read_at` is NULL (never read), counts all messages from others
- Previously polled every 60 seconds by the legacy `AppNavbar` badge (retired Conv 339); not currently polled by the Matt shell

---

### PATCH /api/me/messages/read-all

Mark all conversations as read for the current user. Sets `last_read_at` to now on all conversation_participants rows.

**Auth:** Required

**Response (200):**
```json
{
  "success": true,
  "marked_count": 3
}
```

**Notes:**
- Only affects the current user's read state — other participants are unaffected
- After calling, `/api/me/messages/count` will return `{ count: 0 }`

---

## Messaging Permission — no endpoint

`GET /api/me/can-message/[userId]` was **deleted in Conv 419** (`[MSG-CLEANUP]`, M6). It had had no
caller since Conv 418 (`[CANMSG]`) made the client check local, so it was a live, tested surface
that nothing exercised — and `[KNIP]` would have had to carry it as a permanent exception. It is
recoverable from git history if a future non-web client needs it.

Nothing about permission enforcement changed. The two places that matter:

- **Authoritative gate (server).** `canMessage()` in `src/lib/messaging.ts`, called by
  `POST /api/conversations` and `POST /api/conversations/[id]/messages`. This is, and always was,
  what actually decides whether a message can be sent. Rules: never yourself; admins and global
  moderators may message anyone; anyone may message an admin (support channel); an active
  enrollment relationship (student ↔ teacher, student ↔ creator); a teacher ↔ creator relationship
  via `teacher_certifications`. Under open messaging (Conv 110) any authenticated member may
  message any non-deleted member, so in practice the gate is broad.
- **Advisory affordance (client).** `useCanMessage` (`src/lib/useCanMessage.ts`) decides only
  whether to *render* a message control: signed in, a recipient exists, and it isn't you. Pure
  derivation over `useAuthStatus` + `useCurrentUser` — **no fetch in any state**, pinned by
  `tests/lib/useCanMessage.test.ts`.

The one input the client cannot derive is whether the recipient is soft-deleted, so Conv 418 added
`deleted_at IS NULL` to the SSR loaders feeding these surfaces (`communities.ts` member directory,
`teachers.ts` / `creators.ts` profile lookups; `users.ts` already filtered, and
`GET /api/me/communities/[slug]/members` followed in `[CMDEL]`). Those filters are load-bearing for
the client derivation and are pinned by `tests/ssr/soft-deleted-users.test.ts`.

**See:** `src/lib/messaging.ts` (`canMessage`), POLICIES.md section 4

---

## User Search Endpoint

### GET /api/users/search

Search for users to message.

**Auth:** Required

**Query Parameters:**

| Parameter | Type | Default | Description |
|-----------|------|---------|-------------|
| `q` | string | required | Search query (min 2 chars) |
| `limit` | number | 10 | Max results (max 20) |

**Response (200):**
```json
{
  "users": [
    {
      "id": "usr-456",
      "name": "John Doe",
      "handle": "johndoe",
      "avatar_url": "/avatars/johndoe.jpg",
      "title": "Teacher"
    }
  ]
}
```

**Notes:**
- Searches name and handle (case-insensitive)
- Excludes current user
- Excludes suspended/deleted users
- Prioritizes handle matches over name matches
- **Filtered to messageable contacts only** (Session 341) — uses `messageableContactsSQL()` from `src/lib/messaging.ts`. Only users with a platform relationship (enrollment, Teacher certification, or admin status) appear in results. Admins see all users.

**Errors:**
- `400` - Query must be at least 2 characters

---

## Database Schema

```sql
-- conversations table
CREATE TABLE conversations (
  id TEXT PRIMARY KEY,
  created_at TEXT NOT NULL DEFAULT (datetime('now')),
  updated_at TEXT NOT NULL DEFAULT (datetime('now'))
);

-- conversation_participants table
CREATE TABLE conversation_participants (
  id TEXT PRIMARY KEY,
  conversation_id TEXT NOT NULL REFERENCES conversations(id),
  user_id TEXT NOT NULL REFERENCES users(id),
  joined_at TEXT NOT NULL DEFAULT (datetime('now')),
  last_read_at TEXT,
  UNIQUE(conversation_id, user_id)
);

-- messages table
CREATE TABLE messages (
  id TEXT PRIMARY KEY,
  conversation_id TEXT NOT NULL REFERENCES conversations(id),
  sender_id TEXT NOT NULL REFERENCES users(id),
  content TEXT NOT NULL,
  created_at TEXT NOT NULL DEFAULT (datetime('now'))
);
```

---

## Client Integration

**Starting a conversation from profile pages:**

```typescript
// Link format
<a href={`/messages?to=${user.id}`}>Message</a>

// The Messages component handles the ?to parameter:
// - If conversation exists → selects it
// - If not → opens new conversation modal with user pre-selected
```

**Polling for updates:**

The Messages component polls every 10 seconds. WebSocket support is not included in MVP.

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
- `404` - Recipient not found

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
- `404` - Conversation not found or not a participant

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
      "title": "Student-Teacher"
    }
  ]
}
```

**Notes:**
- Searches name and handle (case-insensitive)
- Excludes current user
- Excludes suspended/deleted users
- Prioritizes handle matches over name matches

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

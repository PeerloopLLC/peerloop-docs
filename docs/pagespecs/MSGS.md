# Page: Messages

**Code:** MSGS
**URL:** `/messages` or `/messages/:conversation_id`
**Access:** Authenticated
**Priority:** P0
**Status:** In Scope

---

## Purpose

Private direct messaging between users, enabling student-teacher communication, inquiries, and relationship building.

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| Nav | "Messages" link | Global navigation ✅ |
| STPR | "Message" button | Message an ST ✅ |
| CPRO | "Message" button | Message a creator ✅ |
| SDSH | "Message Teacher" | Contact assigned ST ✅ |
| CMST | "Message" action | ST messages a student ✅ |
| NOTF | New message notification | Direct to conversation ✅ |

### Outgoing (users navigate to)

| Target | Trigger | Notes |
|--------|---------|-------|
| PROF | Avatar/name click in conversation | View user's profile |
| STPR | Avatar/name click (if ST) | View ST profile |
| SBOK | "Book Session" in chat | Schedule with ST |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| conversations | id, updated_at | Conversation list |
| conversation_participants | conversation_id, user_id, last_read_at | Participants |
| messages | id, conversation_id, sender_id, content, created_at | Message content |
| users | id, name, avatar, handle | Participant display |

---

## Sections

### Conversation List (Left Panel / Main on Mobile)
- List of conversations sorted by most recent
- Each shows:
  - Participant avatar(s)
  - Participant name(s)
  - Last message preview (truncated)
  - Timestamp
  - Unread indicator (dot or bold)
- Search conversations
- "New Message" button → start new conversation

### Message Thread (Right Panel / Separate View on Mobile)
- **Header:**
  - Participant avatar + name
  - "View Profile" link → PROF/STPR
  - More options (mute, block, etc.)
- **Message List:**
  - Messages in chronological order
  - Own messages on right (blue)
  - Others' messages on left (gray)
  - Timestamps (grouped by day)
  - Read receipts (optional)
- **Composer:**
  - Text input
  - Attachment button (future)
  - Send button
  - Emoji picker (future)

### New Conversation Modal/View
- Search for user by name or handle
- Select from recent/suggested users
- Start typing message

### Empty States
- No conversations: "No messages yet. Start a conversation!"
- No messages in thread: "Start the conversation"

---

## User Stories Fulfilled

- US-P004: Private messaging system
- US-S016: Send private messages to STs
- US-S017: Receive messages from teachers
- US-S018: Access message history
- US-S019: Get notifications for new messages

---

## States & Variations

| State | Description |
|-------|-------------|
| Empty | No conversations, show CTA |
| List View | Browsing conversations |
| Thread View | Reading/writing in conversation |
| New Message | Starting new conversation |
| Unread | Conversations with unread messages highlighted |

---

## Mobile Considerations

- List and thread are separate screens
- Back button to return to list
- Keyboard-aware composer (stays above keyboard)
- Swipe to archive/delete (future)

---

## Error Handling

| Error | Display |
|-------|---------|
| Load fails | "Unable to load messages. [Retry]" |
| Send fails | "Message not sent. [Retry]" with failed indicator |
| User not found | "User not found" in search |

---

## Analytics Events

| Event | Trigger | Data |
|-------|---------|------|
| `page_view` | Page load | conversations_count |
| `conversation_opened` | Thread opened | conversation_id |
| `message_sent` | Message sent | conversation_id, is_new_conversation |
| `new_conversation` | Started new conversation | recipient_id |

---

## API Calls

| Endpoint | When | Purpose |
|----------|------|---------|
| `GET /api/conversations` | Page load | List all conversations |
| `GET /api/conversations/:id` | Thread opened | Conversation with messages |
| `POST /api/conversations` | New conversation | Start new thread |
| `POST /api/conversations/:id/messages` | Send message | Post new message |
| `PUT /api/conversations/:id/read` | Thread opened | Mark as read |
| `GET /api/users/search?q=...` | New conversation | Find users to message |

**Conversations List Response:**
```typescript
GET /api/conversations
{
  conversations: [{
    id, updated_at,
    participants: [{ id, name, avatar }],
    last_message: { content, created_at, sender_id },
    unread_count: number
  }]
}
```

**Single Conversation Response:**
```typescript
GET /api/conversations/:id
{
  id, created_at,
  participants: [{ id, name, avatar, handle }],
  messages: [{
    id, sender_id, content, created_at
  }]
}
```

**Send Message:**
```typescript
POST /api/conversations/:id/messages
{
  content: string
}
// Returns created message with id, created_at
```

**Start Conversation:**
```typescript
POST /api/conversations
{
  participant_ids: string[],
  initial_message: string
}
// Returns new conversation with id
```

---

## Notes

- Using custom WebSocket for real-time message delivery
- Push notifications for new messages
- Message encryption considerations (future)
- Rate limiting to prevent spam
- Block/report functionality needed

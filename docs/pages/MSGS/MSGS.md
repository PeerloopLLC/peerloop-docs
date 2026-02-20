# MSGS - Messages

| Field | Value |
|-------|-------|
| Route | `/messages` or `/messages/:conversation_id` |
| Access | Authenticated |
| Priority | P0 |
| Status | 📋 Spec Only |
| Block | 5 |
| JSON Spec | `src/data/pages/messages.json` |
| Astro Page | `src/pages/messages.astro` |

---

## Purpose

Private direct messaging between users, enabling student-teacher communication, inquiries, and relationship building.

---

## User Stories

| ID | Story | Priority | Status |
|----|-------|----------|--------|
| US-P004 | As a Platform, I need a private messaging system so that users can communicate | P0 | 📋 |
| US-S016 | As a Student, I need to send private messages to STs so that I can ask questions | P0 | 📋 |
| US-S017 | As a Student, I need to receive messages from teachers so that I get answers | P0 | 📋 |
| US-S018 | As a Student, I need to access message history so that I can reference past conversations | P0 | 📋 |
| US-S019 | As a Student, I need to get notifications for new messages so that I don't miss replies | P0 | 📋 |

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| Nav | "Messages" link | Global navigation |
| STPR | "Message" button | Message an ST |
| CPRO | "Message" button | Message a creator |
| PROF | "Message" button | Message any user |
| SDSH | "Message Teacher" | Contact assigned ST |
| TDSH | "Message Student" | Contact a student |
| NOTF | New message notification | Direct to conversation |

### Outgoing (users navigate to)

| Target | Trigger | Notes | Status |
|--------|---------|-------|--------|
| PROF | Avatar/name click in conversation | View user's profile | 📋 |
| STPR | Avatar/name click (if ST) | View ST profile | 📋 |
| SBOK | "Book Session" in chat | Schedule with ST | 📋 |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| conversations | id, updated_at | Conversation list |
| conversation_participants | conversation_id, user_id, last_read_at | Participants |
| messages | id, conversation_id, sender_id, content, created_at | Message content |
| users | id, name, avatar, handle | Participant display |

---

## Features

### Conversation List
- [ ] List of conversations sorted by most recent `[US-S018]`
- [ ] Participant avatar(s) `[US-S018]`
- [ ] Participant name(s) `[US-S018]`
- [ ] Last message preview (truncated) `[US-S018]`
- [ ] Timestamp `[US-S018]`
- [ ] Unread indicator (dot or bold) `[US-S019]`
- [ ] Search conversations `[US-S018]`
- [ ] "New Message" button `[US-S016]`

### Message Thread
- [ ] Header with participant avatar + name `[US-S018]`
- [ ] "View Profile" link → PROF/STPR `[US-S018]`
- [ ] Messages in chronological order `[US-S018]`
- [ ] Own messages on right (blue) `[US-S018]`
- [ ] Others' messages on left (gray) `[US-S018]`
- [ ] Timestamps grouped by day `[US-S018]`
- [ ] Read receipts (optional) `[US-S018]`

### Message Composer
- [ ] Text input `[US-S016]`
- [ ] Send button `[US-S016]`
- [ ] Attachment button (future) `[US-S016]`

### New Conversation
- [ ] Search for user by name or handle `[US-S016]`
- [ ] Select from recent/suggested users `[US-S016]`
- [ ] Start typing message `[US-S016]`

---

## Sections (from Plan)

### Conversation List (Left Panel / Main on Mobile)
- Sorted by most recent
- Participant info + preview
- Unread indicators
- Search and "New Message"

### Message Thread (Right Panel / Separate View on Mobile)
**Header:**
- Participant avatar + name
- "View Profile" link
- More options (mute, block)

**Message List:**
- Chronological messages
- Own vs others styling
- Day dividers
- Read receipts

**Composer:**
- Text input
- Send button

---

## API Endpoints

| Endpoint | Method | Purpose | Status |
|----------|--------|---------|--------|
| `/api/conversations` | GET | List all conversations | 📋 |
| `/api/conversations/:id` | GET | Conversation with messages | 📋 |
| `/api/conversations` | POST | Start new thread | 📋 |
| `/api/conversations/:id/messages` | POST | Post new message | 📋 |
| `/api/conversations/:id/read` | PUT | Mark as read | 📋 |
| `/api/users/search` | GET | Find users to message | 📋 |

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

## States & Variations

| State | Description |
|-------|-------------|
| Empty | No conversations, show CTA |
| List View | Browsing conversations |
| Thread View | Reading/writing in conversation |
| New Message | Starting new conversation |
| Unread | Conversations with unread messages highlighted |

---

## Error Handling

| Error | Display |
|-------|---------|
| Load fails | "Unable to load messages. [Retry]" |
| Send fails | "Message not sent. [Retry]" with failed indicator |
| User not found | "User not found" in search |

---

## Mobile Considerations

- List and thread are separate screens
- Back button to return to list
- Keyboard-aware composer (stays above keyboard)
- Swipe to archive/delete (future)

---

## Implementation Notes

- Using custom WebSocket for real-time message delivery
- Push notifications for new messages
- Message encryption considerations (future)
- Rate limiting to prevent spam
- Block/report functionality needed
- Cloudflare Durable Objects for WebSocket state

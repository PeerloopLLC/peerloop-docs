# Page: Course Chat

**Code:** CHAT
**URL:** `/courses/:id/chat`
**Access:** Authenticated (enrolled students and certified STs)
**Priority:** P2 (Block 2+)
**Status:** In Scope (Goodwill Points Feature)

---

## Purpose

Course-specific community chat room where enrolled students can ask questions, get help from STs, and award goodwill points for helpful answers.

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| CCNT | "Course Chat" link | From course content |
| CDET | "Join Discussion" | From course detail |
| NOTF | Chat notification | New message/mention |
| SDSH | Course chat icon | Quick access |

### Outgoing (users navigate to)

| Target | Trigger | Notes |
|--------|---------|-------|
| CCNT | "Back to Course" | Return to content |
| STPR | ST name click | View helper's profile |
| PROF | User name click | View user's profile |
| HELP | "Need 1-on-1 Help?" | Escalate to Summon |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| posts | id, author_id, course_id, content, created_at | Chat messages |
| users | id, name, avatar, is_student_teacher | Participant info |
| student_teachers | course_id, user_id | ST badge display |
| user_goodwill | balance | Points available to award |
| goodwill_transactions | from_user_id, to_user_id, points, reason | Awards |
| courses | id, title | Course context |

---

## Sections

### Header
- Course title + "Chat"
- Participants count: "X online"
- "Back to Course" → CCNT
- Room settings (mute, etc.)

### Chat Messages (Main Area)
- Real-time message stream
- Each message shows:
  - Author avatar + name
  - ST badge (if certified for this course)
  - Timestamp
  - Message content
  - **Action buttons:**
    - "Mark as Question" (on own messages)
    - "This Helped!" (on others' answers)
- Question messages highlighted differently
- Answers to questions indented/grouped

### Help Queue Panel (Sidebar or Tab)
- **Pending Questions:**
  - Questions awaiting answers
  - Ordered by time asked
  - Quick link to question in chat
- **Available Helpers:**
  - STs currently online
  - "Available to Help" status
  - Avatar + name

### Message Composer
- Text input
- "Ask Question" toggle (marks as question)
- Send button
- Character limit indicator

### "This Helped!" Interaction
- On clicking "This Helped!":
  - Opens slider: 5 points (default)
  - Note: "Award points for helpful answer"
  - Confirm button
  - Points deducted from giver's balance
  - Points added to helper's total

### Goodwill Points Indicator
- User's available balance shown
- "X points to give"
- Link to earn more

---

## User Stories Fulfilled

- US-S065: Participate in course chat
- US-S066: Ask questions in chat
- US-T028: ST answers questions in chat
- US-S069: Award points for helpful answers (from CD-023)

---

## States & Variations

| State | Description |
|-------|-------------|
| Active | Messages flowing, users online |
| Quiet | No recent messages, "Start the conversation" prompt |
| Question Pending | User's question awaiting answer |
| Helping | ST actively answering questions |
| Low Balance | User has few points to award, subtle prompt to help others |

---

## Mobile Considerations

- Full-screen chat
- Help queue accessed via tab or swipe
- Composer sticky at bottom
- Quick point award via long-press

---

## Error Handling

| Error | Display |
|-------|---------|
| Not authorized | "You must be enrolled to access this chat." |
| Send fails | "Message not sent. [Retry]" |
| Award fails | "Unable to award points. Try again." |
| Connection lost | "Reconnecting..." with retry |

---

## Analytics Events

| Event | Trigger | Data |
|-------|---------|------|
| `page_view` | Page load | course_id, user_role |
| `message_sent` | Message sent | course_id, is_question |
| `question_asked` | Question marked | course_id |
| `points_awarded` | "This Helped" completed | points, recipient_id |
| `helper_online` | ST came online | st_id, course_id |

---

## Server Integration

### Feature Flag
```typescript
// Requires: canAccess('course_chat')
// Also check: user enrolled in course OR user is certified ST for course
```

### API Endpoints Called

| Endpoint | When | Purpose |
|----------|------|---------|
| `GET /api/courses/:id/chat/room` | Page load | Get/create chat room |
| `GET /api/courses/:id/chat/messages` | Page load | Load message history |
| `POST /api/courses/:id/chat/messages` | Send message | Create message |
| `WS /api/chat/connect` | Page load | WebSocket connection |
| `POST /api/goodwill/award` | "This Helped!" | Award points |
| `GET /api/courses/:id/chat/helpers` | Page load | Online STs |

### WebSocket Architecture (Custom)

```
Connection:
  1. GET /api/courses/:id/chat/room → { room_id, user_token }
  2. Connect: WS /api/chat/connect?room={room_id}&token={user_token}
  3. Server validates token, joins user to room

Implementation: Cloudflare Durable Objects
  - Each course has a Durable Object instance
  - Handles message broadcast
  - Tracks online users
  - Manages presence

Message Flow:
  Client → WebSocket → Durable Object → Broadcast to room
                    → Store in D1 (chat_messages table)
```

### WebSocket Events

```typescript
// Client → Server
{ type: 'message', content: string, is_question: boolean }
{ type: 'typing' }
{ type: 'mark_helpful', message_id: string }

// Server → Client
{ type: 'message', data: ChatMessage }
{ type: 'user_joined', user: User }
{ type: 'user_left', user_id: string }
{ type: 'presence', users: User[] }
{ type: 'typing', user_id: string }
```

### Goodwill Points Award

```typescript
// POST /api/goodwill/award
{
  recipient_id: string,
  points: number,        // 5 default for chat help
  reason: 'chat_help',
  reference_id: message_id
}

// Backend:
1. Validate sender has sufficient balance
2. Deduct from sender: UPDATE user_goodwill SET balance = balance - points
3. Add to recipient: UPDATE user_goodwill SET balance = balance + points
4. Record transaction in goodwill_transactions
5. Broadcast point award to chat room
```

### Message Storage

```typescript
// POST /api/courses/:id/chat/messages (also via WebSocket)
{
  content: string,
  is_question: boolean,
  reply_to_id?: string
}

// Stored in chat_messages table
// Also broadcast via Durable Object
```

### Data Flow Diagram

```
┌─────────────┐      ┌─────────────┐      ┌─────────────┐
│   CHAT      │      │  Cloudflare │      │   D1 / KV   │
│   (Client)  │      │  Durable Obj│      │  (Storage)  │
└──────┬──────┘      └──────┬──────┘      └──────┬──────┘
       │                    │                    │
       │ WS connect         │                    │
       │───────────────────>│                    │
       │                    │ Load history       │
       │                    │───────────────────>│
       │ { messages }       │                    │
       │<───────────────────│                    │
       │                    │                    │
       │ Send message       │                    │
       │───────────────────>│                    │
       │                    │ Store message      │
       │                    │───────────────────>│
       │                    │                    │
       │                    │ Broadcast to room  │
       │<───────────────────│                    │
       │                    │──────> (other clients)
```

---

## Notes

- **Feature Flag:** `course_chat` - check with `canAccess('course_chat')`
- **Block 2+ feature:** Part of Goodwill Points system (CD-023)
- Custom WebSocket via Cloudflare Durable Objects (not Stream Chat)
- Consider anti-spam: rate limits (1 msg/sec), moderation
- ST incentive: Earning points for helping
- Integration with MODQ for flagged content
- Message history persisted in chat_messages table

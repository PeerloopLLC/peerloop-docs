# tech-018: Messaging & Communication Architecture

**Type:** Architecture Decision
**Status:** ✅ DECIDED (MVP) / ⏸️ ON-HOLD (CHAT, SUBCOM)
**Created:** 2026-01-19
**Updated:** 2026-01-23
**Related:** `tech-002-stream.md`, `tech-011-cloudflare.md`

---

## Current State (2026-01-23)

### Implemented Communication Systems

| System | Type | Scope | Implementation | Status |
|--------|------|-------|----------------|--------|
| **MSGS** | Private DMs | Any user ↔ Any user | Custom D1 + polling | ✅ Complete |
| **FEED** | Broadcast | Platform-wide (Townhall) | Stream.io Feeds | ✅ Complete |
| **IFED** | Broadcast | Creator's followers | Stream.io Feeds | ✅ Complete |
| **CDIS** | Forum (async) | Course enrollees | Custom D1 | ✅ Complete |

### On-Hold Pages (Awaiting Client Decision)

| Page | Type | Scope | Proposed Tech | Status |
|------|------|-------|---------------|--------|
| **CHAT** | Chatroom (real-time) | Course enrollees | WebSockets + Durable Objects | ⏸️ On-Hold |
| **SUBCOM** | Topic feed | User-created groups | Stream.io Feeds | ⏸️ On-Hold |

---

## Key Discussion Points (2026-01-23 Session)

### 1. MSGS Already Supports Open DMs

The current MSGS implementation allows messaging **any user**, not just STs/Creators:

```sql
-- From /api/users/search.ts
SELECT id, name, handle, avatar_url, title
FROM users
WHERE id != ?
  AND deleted_at IS NULL
  AND suspended_at IS NULL
  AND (name LIKE ? OR handle LIKE ?)
```

**Implication:** Students can already message other students. No restrictions by role.

### 2. CHAT vs CDIS: Real-time vs Async

| Aspect | CDIS (Implemented) | CHAT (Proposed) |
|--------|-------------------|-----------------|
| **Timing** | Async | Real-time |
| **Structure** | Threads + nested replies | Flat message stream |
| **Presence** | No | "5 users online" |
| **Typing indicator** | No | "Sarah is typing..." |
| **Goodwill Points** | No | "This Helped!" awards |
| **Use case** | "I have a question about Module 3" | "Can someone help me right now?" |

**Question for Client:** Is real-time chat necessary, or could CDIS absorb CHAT's features (e.g., add Goodwill Points to CDIS)?

### 3. SUBCOM vs MSGS Group DMs

SUBCOM was envisioned for user-created interest groups (like subreddits). However:
- MSGS already supports group DMs
- For study groups, users could create a group DM in MSGS today

**SUBCOM's unique value:** Public/discoverable topic-based feeds (not just private groups).

### 4. Simplification Options

| Option | Description | Effort |
|--------|-------------|--------|
| **Skip CHAT** | CDIS already serves course Q&A. Add Goodwill Points to CDIS instead. | Low |
| **Lightweight CHAT** | Skip WebSockets, use polling (like MSGS). Add presence via "last seen". | Medium |
| **Skip SUBCOM** | Use MSGS group DMs for study groups. Defer public interest groups. | Zero |
| **Lightweight SUBCOM** | Just a filtered FEED with membership table. No full invite system. | Medium |

---

## Decision

**Original decision (2026-01-21):** Stream Chat for private messaging.

**Actual implementation (2026-01-22):** Custom D1 + polling for MSGS (simpler, works).

**Pending decision (2026-01-23):** Client to decide on CHAT and SUBCOM.

**Rationale for current state:**
- MSGS with D1 + polling is working well for MVP
- 10-second polling is sufficient for 1:1 messaging
- WebSockets deferred until proven necessary
- Stream Chat integration not needed for current functionality

---

## Overview

PeerLoop requires real-time messaging for:
- **Student ↔ S-T** - Core tutoring communication
- **Student ↔ Creator** - Course questions
- **Admin ↔ Anyone** - Support
- **Session context** - Pre/post video session messages

This document compares two approaches: **Stream Chat** vs **Custom (Cloudflare Workers + D1 + Durable Objects)**.

---

## Decision Status

| Option | Recommendation | Client Decision |
|--------|----------------|-----------------|
| Stream Chat | Faster MVP, better integration | ✅ **Chosen** (2026-01-21) |
| Custom Workers/D1 | Lower long-term cost, full control | ❌ Not selected |

**Original assumption** (from `stream-usage.md`):
> "Build custom (Cloudflare D1 + Workers) - Simpler, lower cost, more control"

**Outcome:** Re-evaluation led to Stream Chat selection for MVP speed and integration benefits.

---

## Comparison Summary

| Dimension | Stream Chat | Custom | Winner |
|-----------|-------------|--------|--------|
| Implementation effort | 8-12 hours | 30-40 hours | Stream |
| Stability/reliability | 99.999% SLA, SDK handles reconnection | Must build resilience | Stream |
| Feed integration | Native (same vendor) | Manual bridging | Stream |
| Cost (Genesis) | Free (<100 MAU) | Free | Tie |
| Cost (Scale) | ~$499+/mo at 10K MAU | ~$20-50/mo | Custom |
| Data ownership | Stream servers | Your D1 | Custom |
| Moderation | Built-in AI moderation | Must build | Stream |
| Feature completeness | Full (threads, presence, typing) | Build each feature | Stream |
| Vendor lock-in | High | None | Custom |

---

## Detailed Analysis

### 1. Implementation Complexity

#### Stream Chat

```typescript
// SDK install
npm install stream-chat stream-chat-react

// Connect user (client-side)
import { StreamChat } from 'stream-chat';
const client = StreamChat.getInstance(apiKey);
await client.connectUser({ id: userId }, userToken);

// Pre-built React components
import { Chat, Channel, MessageList, MessageInput } from 'stream-chat-react';
<Chat client={client}>
  <Channel>
    <MessageList />
    <MessageInput />
  </Channel>
</Chat>
```

**Included out-of-box:**
- Real-time WebSocket management
- Typing indicators
- Read receipts
- User presence (online/offline)
- File/image uploads
- Message reactions
- Threads/replies
- Moderation tools

**Estimated effort:** 8-12 hours

#### Custom (Workers + D1 + Durable Objects)

```typescript
// Must build:
// 1. Database schema
CREATE TABLE conversations (
  id TEXT PRIMARY KEY,
  participant_1 TEXT NOT NULL,
  participant_2 TEXT NOT NULL,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE messages (
  id TEXT PRIMARY KEY,
  conversation_id TEXT NOT NULL,
  sender_id TEXT NOT NULL,
  content TEXT NOT NULL,
  created_at TEXT DEFAULT CURRENT_TIMESTAMP,
  read_at TEXT,
  FOREIGN KEY (conversation_id) REFERENCES conversations(id)
);

// 2. API endpoints
POST /api/conversations
GET  /api/conversations
GET  /api/conversations/:id/messages
POST /api/conversations/:id/messages
PATCH /api/messages/:id/read

// 3. Real-time via Durable Objects
export class ChatRoom extends DurableObject {
  async fetch(request: Request) {
    // WebSocket upgrade
    // Connection management
    // Message broadcasting
    // Reconnection handling
  }
}

// 4. Client-side WebSocket management
// 5. Offline queuing
// 6. Optimistic UI updates
// 7. Typing indicators
// 8. Read receipts
// 9. Presence tracking
```

**Estimated effort:** 30-40 hours

---

### 2. Stability & Fallbacks

#### Stream Chat

| Aspect | Capability |
|--------|------------|
| Uptime SLA | 99.999% |
| API latency | ~9ms global |
| Reconnection | SDK handles automatically |
| Offline handling | SDK queues messages |
| Optimistic UI | Built into components |

**Risk:** External dependency - Stream outage = our outage

#### Custom

| Aspect | Requirement |
|--------|-------------|
| Uptime | Cloudflare's ~99.99% |
| Reconnection | Must implement retry logic |
| Offline handling | Must build message queue |
| Optimistic UI | Must implement |

**Implementation pattern for reconnection:**
```typescript
class WebSocketManager {
  private ws: WebSocket | null = null;
  private reconnectAttempts = 0;
  private messageQueue: Message[] = [];

  connect() {
    this.ws = new WebSocket(url);
    this.ws.onclose = () => this.scheduleReconnect();
    this.ws.onopen = () => this.flushQueue();
  }

  private scheduleReconnect() {
    const delay = Math.min(1000 * 2 ** this.reconnectAttempts, 30000);
    setTimeout(() => this.connect(), delay);
    this.reconnectAttempts++;
  }

  send(message: Message) {
    if (this.ws?.readyState === WebSocket.OPEN) {
      this.ws.send(JSON.stringify(message));
    } else {
      this.messageQueue.push(message); // Queue for later
    }
  }
}
```

---

### 3. Integration with Stream Feeds

Since PeerLoop uses Stream for Activity Feeds, messaging integration matters.

#### Stream Chat (Same Vendor)

```typescript
// Single token generation endpoint
const streamToken = client.generateUserToken({ user_id: userId });
// Works for both Chat and Feeds

// Cross-linking example: Chat message → Feed notification
await feedClient.feed('notification', recipientId).addActivity({
  type: 'new_message',
  actor: senderId,
  verb: 'sent',
  object: `message:${messageId}`,
  foreign_id: `chat:${conversationId}`,
});
```

**Benefits:**
- Single SDK, single auth
- Native user management
- Unified notification feed
- Cross-product features

#### Custom (Separate Systems)

```typescript
// Separate auth flows
const peerloopToken = await generateJWT(user);
const streamToken = await getStreamToken(user); // For feeds only

// Manual cross-linking
async function sendMessage(conversationId, content) {
  // 1. Save to D1
  const message = await db.messages.create({ ... });

  // 2. Broadcast via Durable Object
  await chatRoom.broadcast(message);

  // 3. Manually push to Stream notification feed
  await streamClient.feed('notification', recipientId).addActivity({
    type: 'new_message',
    // ... manually construct activity
  });
}
```

**Challenges:**
- Two data sources for "activity"
- Manual sync required
- Different auth contexts

---

### 4. Cost Analysis

#### Stream Pricing

| Product | Maker (Free) | Startup |
|---------|--------------|---------|
| Activity Feeds | Up to 100 MAU | ~$499/mo |
| Chat | Up to 100 MAU | ~$499/mo |
| **Combined** | **Free** | **~$998/mo** |

#### Custom Pricing (Cloudflare)

| Service | Free Tier | Paid |
|---------|-----------|------|
| Workers | 100K req/day | $5/10M req |
| D1 | 5GB storage | $0.75/GB |
| Durable Objects | 1M req/mo | $0.15/M req |
| **Estimated** | **Free** | **~$20-50/mo** |

#### PeerLoop Projection

| Phase | MAU | Stream (Feeds+Chat) | Custom |
|-------|-----|---------------------|--------|
| Genesis | ~150 | Free | Free |
| Growth (1K) | 1,000 | ~$998/mo | ~$30/mo |
| Scale (10K) | 10,000 | ~$998/mo | ~$100/mo |

**Break-even:** Custom becomes significantly cheaper past free tier.

---

### 5. Moderation (Critical for US-S017)

User story US-S017 concerns student-to-student messaging safety.

#### Stream Chat

| Feature | Availability |
|---------|--------------|
| AI auto-moderation | Built-in |
| Profanity filter | Built-in |
| Image moderation | Built-in |
| Flagging system | Built-in |
| Ban/mute users | Built-in |
| Admin dashboard | Stream Dashboard |

#### Custom

| Feature | Requirement |
|---------|-------------|
| Content filtering | Integrate third-party (Perspective API, etc.) |
| Flagging | Build flagging table + UI |
| Ban/mute | Build into user management |
| Admin review | Build in ADMIN dashboard |

**Estimated additional effort for moderation:** 12-16 hours

---

### 6. Feature Comparison

| Feature | Stream Chat | Custom | Priority |
|---------|-------------|--------|----------|
| 1:1 messaging | ✅ | Build | P0 |
| Real-time delivery | ✅ | Durable Objects | P0 |
| Message persistence | ✅ | D1 | P0 |
| Read receipts | ✅ | Build | P1 |
| Typing indicators | ✅ | Build | P2 |
| File uploads | ✅ | R2 integration | P1 |
| Threads/replies | ✅ | Build | P2 |
| User presence | ✅ | Build | P2 |
| Message search | ✅ | D1 FTS | P2 |
| Reactions | ✅ | Build | P2 |
| Group chat | ✅ | Build if needed | P3 |
| Push notifications | ✅ | Separate integration | P2 |

---

## Recommendation Matrix

| If Priority Is... | Choose | Rationale |
|-------------------|--------|-----------|
| **Fastest MVP** | Stream Chat | Pre-built everything, 8-12h vs 30-40h |
| **Best feed integration** | Stream Chat | Native cross-product, single SDK |
| **Safety/moderation** | Stream Chat | Built-in AI moderation for US-S017 |
| **Lowest long-term cost** | Custom | Avoid $500+/mo at scale |
| **Maximum control** | Custom | Own data model, no vendor lock-in |
| **Simplest data model** | Custom | PeerLoop only needs 1:1 messaging |

---

## Questions for Client (Resolved)

*Client decision received 2026-01-21: Use Stream Chat.*

~~1. **Timeline priority:** Is faster MVP (Stream) worth potential migration later?~~

~~2. **Cost tolerance:** At Startup tier (~$998/mo combined), is Stream acceptable?~~

~~3. **Moderation priority:** How critical is built-in AI moderation for Genesis?~~

~~4. **Long-term vision:** Will messaging evolve beyond 1:1 (group chat, channels)?~~

~~5. **Data ownership:** Any concerns with messages on Stream's servers?~~

---

## Implementation Path

### If Stream Chat

1. Add `stream-chat` and `stream-chat-react` packages
2. Update `/api/stream/token` to include Chat permissions
3. Create `ChatWrapper` React component
4. Integrate into MSGS page
5. Configure moderation in Stream Dashboard
6. Cross-link with notification feed

### If Custom

1. Add D1 tables: `conversations`, `messages`
2. Create Durable Object for WebSocket coordination
3. Build API endpoints for CRUD
4. Create React components for message UI
5. Implement reconnection/offline handling
6. Build moderation queue in ADMIN
7. Manual integration with Stream notification feed

---

## Full Communication Landscape

```
┌─────────────────────────────────────────────────────────────────┐
│                    PeerLoop Communication                        │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  PRIVATE (1:1 or Group)                                         │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │ MSGS - Direct Messages                         ✅ Done   │    │
│  │   • Any user can message any user                        │    │
│  │   • Group DMs supported                                  │    │
│  │   • Custom D1 + 10s polling                              │    │
│  └─────────────────────────────────────────────────────────┘    │
│                                                                  │
│  BROADCAST (Public Feeds)                                       │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │ FEED - Townhall                                ✅ Done   │    │
│  │   • Platform-wide posts                                  │    │
│  │   • Stream.io Activity Feeds                             │    │
│  ├─────────────────────────────────────────────────────────┤    │
│  │ IFED - Instructor Feed                         ✅ Done   │    │
│  │   • Creator's followers see posts                        │    │
│  │   • Stream.io Activity Feeds                             │    │
│  └─────────────────────────────────────────────────────────┘    │
│                                                                  │
│  COURSE-SCOPED                                                  │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │ CDIS - Course Discussion (Forum)               ✅ Done   │    │
│  │   • Async Q&A threads                                    │    │
│  │   • Custom D1                                            │    │
│  ├─────────────────────────────────────────────────────────┤    │
│  │ CHAT - Course Chatroom                         ⏸️ Hold   │    │
│  │   • Real-time chat                                       │    │
│  │   • WebSockets + Durable Objects                         │    │
│  │   • Goodwill Points ("This Helped!")                     │    │
│  │   • Question: Merge into CDIS?                           │    │
│  └─────────────────────────────────────────────────────────┘    │
│                                                                  │
│  USER-CREATED GROUPS                                            │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │ SUBCOM - Sub-Communities                       ⏸️ Hold   │    │
│  │   • Interest-based topic feeds                           │    │
│  │   • Stream.io Feeds (new group)                          │    │
│  │   • Join/invite system                                   │    │
│  │   • Alternative: Use MSGS group DMs                      │    │
│  └─────────────────────────────────────────────────────────┘    │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### Summary for Client

**What's working now (MVP complete):**
- Private messaging to anyone (MSGS)
- Public broadcasts (FEED, IFED)
- Course Q&A forums (CDIS)

**What's on hold:**
- CHAT (real-time course chatroom) - Could add Goodwill Points to CDIS instead
- SUBCOM (user-created groups) - Could use MSGS group DMs for study groups

**Questions for Brian:**
1. Is real-time chat necessary, or is async CDIS sufficient?
2. If CHAT is needed, should Goodwill Points be its own feature or added to CDIS?
3. Are public interest groups (SUBCOM) needed, or do private group DMs suffice?

---

## References

- `tech-002-stream.md` - Stream platform overview
- `tech-011-cloudflare.md` - Cloudflare D1/Workers/Durable Objects
- `research/run-001/assets/stream-usage.md` - RUN-001 Stream decisions
- [Stream Chat Docs](https://getstream.io/chat/docs/)
- [Cloudflare Durable Objects](https://developers.cloudflare.com/durable-objects/)
- [Stream Chat React SDK](https://getstream.io/chat/docs/react/)

# Page: Summon Help

**Code:** HELP
**URL:** Modal overlay (on CCNT)
**Access:** Authenticated (enrolled students)
**Priority:** P2 (Block 2+)
**Status:** In Scope (Goodwill Points Feature)

---

## Purpose

Real-time help request system allowing students to summon available Student-Teachers for immediate 1-on-1 assistance, with goodwill point incentives.

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| CCNT | "Summon Help" button | From course content |
| CHAT | "Need 1-on-1 Help?" | Escalate from chat |

### Outgoing (users navigate to)

| Target | Trigger | Notes |
|--------|---------|-------|
| CCNT | Close modal / Complete | Return to course content |
| STPR | Helper name click | View helper profile |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| help_summons | id, student_id, course_id, module_id, status, responder_id | Summon tracking |
| user_availability | user_id, is_available | Available helpers |
| users (STs) | id, name, avatar | Helper display |
| student_teachers | user_id, course_id | Certified for this course |
| user_goodwill | balance | Points to award |
| course_curriculum | id, title | Module context |

---

## Sections

### Modal Container
- Overlay on course content
- Closable (X button, click outside)
- Responsive sizing

### State: Initiating
- **Header:** "Get Help Now"
- **Available Helpers:**
  - Count: "3 helpers online"
  - Avatar stack of available STs
- **Context:**
  - "Module: [Current Module Title]"
  - Optional: Add question/description
- **Actions:**
  - "Summon Helper" button
  - "Cancel" link

### State: Waiting
- **Header:** "Finding a Helper..."
- **Animation:** Searching/pulsing indicator
- **Status:** "Looking for an available helper"
- **Timer:** Time elapsed waiting
- **Available Helpers:** Count display
- **Actions:**
  - "Cancel" button

### State: Connected
- **Header:** "You're Connected!"
- **Helper Info:**
  - Avatar, name
  - "Student-Teacher for [Course]"
- **Communication:**
  - Text chat interface
  - OR video call link (if escalated)
- **Session Timer:**
  - Time elapsed
  - "5 min minimum for points" reminder
- **Actions:**
  - "End Session" button
  - "Start Video Call" (optional escalation)

### State: Complete
- **Header:** "Session Complete"
- **Summary:**
  - Helper name
  - Duration: X minutes
- **Award Points:**
  - Slider: 10-25 points (default 15)
  - Point guideline:
    - 10 = Helpful
    - 15 = Very helpful (default)
    - 20 = Extremely helpful
    - 25 = Exceptional
  - Current balance reminder
- **Actions:**
  - "Award [X] Points" button
  - "Skip" (not recommended, with confirmation)

### State: Cancelled/No Response
- **Header:** "No Helpers Available"
- **Message:** "All helpers are currently busy."
- **Alternatives:**
  - "Try again in a few minutes"
  - "Ask in Course Chat" → CHAT
  - "Schedule a Session" → SBOK
- **Actions:**
  - "Close" button

---

## User Stories Fulfilled

- US-S062: Access Summon Help feature
- US-S063: See available helpers
- US-S064: Get connected with helper
- US-T025: ST receives summon notification
- US-T026: ST responds to summon request

---

## States & Variations

| State | Description |
|-------|-------------|
| Initiating | Ready to summon, showing available helpers |
| Waiting | Looking for helper |
| Connected | Active help session |
| Complete | Session ended, awarding points |
| No Helpers | No one available |
| Cancelled | User cancelled |
| Timed Out | No response within time limit |

---

## Mobile Considerations

- Modal becomes full-screen sheet
- Chat interface optimized for mobile
- Large touch targets for point slider
- Easy access to cancel/close

---

## Error Handling

| Error | Display |
|-------|---------|
| No helpers online | "No helpers available right now. Try Course Chat instead." |
| Connection failed | "Unable to connect. Please try again." |
| Helper disconnected | "Helper disconnected. Would you like to try again?" |
| Points award failed | "Unable to award points. [Retry]" |

---

## Analytics Events

| Event | Trigger | Data |
|-------|---------|------|
| `summon_initiated` | Summon started | course_id, module_id, helpers_available |
| `summon_waiting` | Entered waiting state | - |
| `summon_connected` | Helper connected | helper_id, wait_time |
| `summon_completed` | Session ended | helper_id, duration |
| `points_awarded` | Points given | points, helper_id |
| `summon_cancelled` | User cancelled | wait_time |
| `summon_timeout` | No response | wait_time |

---

## Server Integration

### Feature Flag
```typescript
// Requires: canAccess('summon_help')
// Depends on: course_chat, goodwill_points
// Also check: user enrolled in course
```

### API Endpoints Called

| Endpoint | When | Purpose |
|----------|------|---------|
| `GET /api/courses/:id/helpers/available` | Modal open | Get online helpers |
| `POST /api/help/request` | "Summon Helper" | Create help request |
| `WS /api/help/connect` | Request created | Real-time help session |
| `POST /api/help/:id/complete` | "End Session" | Mark session complete |
| `POST /api/goodwill/award` | Award points | Transfer goodwill points |

### Help Request Flow

```
Initiate Request:
  1. POST /api/help/request {
       course_id: string,
       module_id?: string,
       message?: string
     }
  2. Backend:
     - Create help_request (status: 'pending')
     - Broadcast to available STs via WebSocket
     - Start timeout timer (2 minutes)
  3. Response: { request_id, available_helpers: count }

ST Receives Notification:
  - Push notification: "Student needs help in [Course]"
  - WebSocket event to ST dashboard
  - First to accept wins

ST Accepts:
  1. POST /api/help/:id/accept
  2. Backend:
     - Update status: 'accepted'
     - Set helper_id
     - Notify student
  3. Both parties join WebSocket room
```

### WebSocket Help Session

```typescript
// Connection:
WS /api/help/connect?request_id={id}&token={user_token}

// Events:
// Server → Client
{ type: 'matched', helper: User }
{ type: 'message', data: ChatMessage }
{ type: 'helper_typing' }
{ type: 'session_ended', duration: number }

// Client → Server
{ type: 'message', content: string }
{ type: 'typing' }
{ type: 'end_session' }
```

### Session Completion

```typescript
// POST /api/help/:id/complete
{
  ended_by: 'student' | 'helper',
  duration_seconds: number
}

// Backend:
1. Update help_request status: 'completed'
2. Record duration
3. Calculate points eligibility (min 5 min)
4. Return { eligible_for_points: boolean, suggested_points: 15 }
```

### Points Award

```typescript
// POST /api/goodwill/award
{
  recipient_id: helper_user_id,
  points: 10-25,
  reason: 'summon_help',
  reference_id: help_request_id
}

// Same flow as CHAT goodwill award
```

### Data Flow Diagram

```
┌─────────────┐      ┌─────────────┐      ┌─────────────┐
│   Student   │      │  PeerLoop   │      │     ST      │
│   (HELP)    │      │  (Server)   │      │   (TDSH)    │
└──────┬──────┘      └──────┬──────┘      └──────┬──────┘
       │                    │                    │
       │ POST /help/request │                    │
       │───────────────────>│                    │
       │                    │ Create request     │
       │                    │ Broadcast to STs   │
       │                    │───────────────────>│
       │ { pending }        │                    │
       │<───────────────────│                    │
       │                    │                    │
       │ Waiting...         │ POST /help/:id/    │
       │                    │ accept             │
       │                    │<───────────────────│
       │                    │                    │
       │ WS: matched        │ WS: student joined │
       │<───────────────────│───────────────────>│
       │                    │                    │
       │ [Chat session via WebSocket]            │
       │<──────────────────────────────────────>│
       │                    │                    │
       │ POST /help/:id/    │                    │
       │ complete           │                    │
       │───────────────────>│                    │
       │                    │ Session ended      │
       │ { award prompt }   │───────────────────>│
       │<───────────────────│                    │
       │                    │                    │
       │ POST /goodwill/    │                    │
       │ award              │                    │
       │───────────────────>│                    │
       │                    │ Transfer points    │
```

### Availability System

```typescript
// STs set availability:
POST /api/users/me/availability/status
{ available_for_help: true }

// Stored in KV for fast lookup:
KV: help_available:{course_id} → [user_id, user_id, ...]

// When ST goes offline or busy:
- Remove from KV set
- Broadcast updated count to HELP modals
```

---

## Notes

- **Feature Flag:** `summon_help` - check with `canAccess('summon_help')`
- **Dependencies:** Requires `course_chat` and `goodwill_points` features
- **Block 2+ feature:** Part of Goodwill Points system (CD-023)
- Minimum 5-minute session for points eligibility
- Anti-gaming: Cooldown between summons to same person (15 min)
- ST notification: Push + WebSocket when summoned
- Consider escalation to video (links to SBOK for scheduled session)
- Points range: 10-25 per CD-023
- Timeout: 2 minutes waiting, then "No helpers available"

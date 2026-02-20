# HELP - Summon Help

| Field | Value |
|-------|-------|
| Route | Modal overlay (on CCNT) |
| Access | Authenticated (enrolled students) |
| Priority | P2 (Block 2+) |
| Status | 📋 Spec Only (Goodwill Points Feature) |
| Block | 5 |
| JSON Spec | `src/data/pages/help.json` |
| Astro Page | Modal component (not separate page) |

---

## Purpose

Real-time help request system allowing students to summon available Student-Teachers for immediate 1-on-1 assistance, with goodwill point incentives.

---

## User Stories

| ID | Story | Priority | Status |
|----|-------|----------|--------|
| US-S062 | As a Student, I need to access the Summon Help feature so that I can get immediate assistance | P2 | 📋 |
| US-S063 | As a Student, I need to see available helpers so that I know help is coming | P2 | 📋 |
| US-S064 | As a Student, I need to get connected with a helper so that I can ask questions | P2 | 📋 |
| US-T025 | As a S-T, I need to receive summon notifications so that I can help students | P2 | 📋 |
| US-T026 | As a S-T, I need to respond to summon requests so that I can earn points | P2 | 📋 |

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| CCNT | "Summon Help" button | From course content |
| CHAT | "Need 1-on-1 Help?" | Escalate from chat |

### Outgoing (users navigate to)

| Target | Trigger | Notes | Status |
|--------|---------|-------|--------|
| CCNT | Close modal / Complete | Return to course content | 📋 |
| STPR | Helper name click | View helper profile | 📋 |

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

## Features

### State: Initiating
- [ ] "Get Help Now" header `[US-S062]`
- [ ] Available helpers count + avatar stack `[US-S063]`
- [ ] Current module context `[US-S062]`
- [ ] Optional question/description input `[US-S062]`
- [ ] "Summon Helper" button `[US-S062]`
- [ ] Cancel link `[US-S062]`

### State: Waiting
- [ ] "Finding a Helper..." header `[US-S062]`
- [ ] Searching/pulsing animation `[US-S062]`
- [ ] Time elapsed timer `[US-S062]`
- [ ] Available helpers count `[US-S063]`
- [ ] Cancel button `[US-S062]`

### State: Connected
- [ ] "You're Connected!" header `[US-S064]`
- [ ] Helper avatar + name `[US-S064]`
- [ ] Text chat interface `[US-S064]`
- [ ] Session timer `[US-S064]`
- [ ] "5 min minimum for points" reminder `[US-S064]`
- [ ] "End Session" button `[US-S064]`
- [ ] "Start Video Call" option `[US-S064]`

### State: Complete
- [ ] "Session Complete" header `[US-S064]`
- [ ] Helper name + duration summary `[US-S064]`
- [ ] Points slider (10-25 points) `[US-S064]`
- [ ] Point guidelines display `[US-S064]`
- [ ] "Award [X] Points" button `[US-S064]`
- [ ] Skip option with confirmation `[US-S064]`

### State: No Helpers
- [ ] "No Helpers Available" message `[US-S063]`
- [ ] Alternative suggestions `[US-S062]`
- [ ] "Try again" option `[US-S062]`
- [ ] "Ask in Course Chat" link → CHAT `[US-S062]`
- [ ] "Schedule a Session" link → SBOK `[US-S062]`

---

## Sections (from Plan)

### Modal Container
- Overlay on course content
- Closable (X, click outside)
- Responsive sizing

### Initiating State
- Header: "Get Help Now"
- Available helpers display
- Module context
- Summon button

### Waiting State
- Animation indicator
- Timer
- Cancel option

### Connected State
- Helper info
- Chat interface
- Session timer
- End session button

### Complete State
- Summary
- Points slider
- Award button

---

## API Endpoints

| Endpoint | Method | Purpose | Status |
|----------|--------|---------|--------|
| `/api/courses/:id/helpers/available` | GET | Get online helpers | 📋 |
| `/api/help/request` | POST | Create help request | 📋 |
| `/api/help/connect` | WS | Real-time help session | 📋 |
| `/api/help/:id/complete` | POST | Mark session complete | 📋 |
| `/api/goodwill/award` | POST | Transfer goodwill points | 📋 |

**Help Request Flow:**
```
1. POST /api/help/request {
     course_id, module_id?, message?
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
2. Both parties join WebSocket room
```

**WebSocket Session:**
```typescript
// Events:
// Server → Client
{ type: 'matched', helper: User }
{ type: 'message', data: ChatMessage }
{ type: 'session_ended', duration: number }

// Client → Server
{ type: 'message', content: string }
{ type: 'end_session' }
```

**Points Award:**
```typescript
POST /api/goodwill/award
{
  recipient_id: helper_user_id,
  points: 10-25,
  reason: 'summon_help',
  reference_id: help_request_id
}
```

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

## Error Handling

| Error | Display |
|-------|---------|
| No helpers online | "No helpers available right now. Try Course Chat instead." |
| Connection failed | "Unable to connect. Please try again." |
| Helper disconnected | "Helper disconnected. Would you like to try again?" |
| Points award failed | "Unable to award points. [Retry]" |

---

## Mobile Considerations

- Modal becomes full-screen sheet
- Chat interface optimized for mobile
- Large touch targets for point slider
- Easy access to cancel/close

---

## Implementation Notes

- **Feature Flag:** `summon_help` - check with `canAccess('summon_help')`
- **Dependencies:** Requires `course_chat` and `goodwill_points` features
- **Block 2+ feature:** Part of Goodwill Points system (CD-023)
- Minimum 5-minute session for points eligibility
- Anti-gaming: 15 min cooldown between summons to same person
- ST notification: Push + WebSocket when summoned
- Points range: 10-25 per CD-023
- Timeout: 2 minutes waiting, then "No helpers available"
- Availability stored in KV for fast lookup

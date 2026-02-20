# Page: Session Room

**Code:** SROM
**URL:** `/session/:id`
**Access:** Authenticated (session participants only)
**Priority:** P0
**Status:** In Scope

---

## Purpose

Video conferencing interface for 1-on-1 tutoring sessions between students and Student-Teachers, powered by VideoProvider (BBB or PlugNmeet).

---

## Connections

### Incoming (users arrive from)

| Source | Trigger | Notes |
|--------|---------|-------|
| SDSH | "Join Session" button | Student joining |
| TDSH | "Join Session" button | ST joining |
| NOTF | Session reminder notification | Direct join |
| (Email) | Email reminder link | Direct join |

### Outgoing (users navigate to)

| Target | Trigger | Notes |
|--------|---------|-------|
| SDSH | "Back to Dashboard" / session ends (Student) | Return to dashboard |
| TDSH | "Back to Dashboard" / session ends (ST) | Return to dashboard |
| CCNT | "Back to Course" | Return to course content |
| (Feedback) | Session ends | Post-session feedback modal |

---

## Data Requirements

| Entity | Fields Used | Purpose |
|--------|-------------|---------|
| sessions | id, scheduled_start, scheduled_end, bbb_meeting_url, status | Session info |
| users (student) | name, avatar | Participant display |
| users (teacher) | name, avatar | Participant display |
| courses | title | Context display |
| enrollments | course_id | Course context |
| session_resources | id, name, type, r2_key, duration_seconds | Session resources |

---

## Sections

### Pre-Join Screen (Before Video Starts)
- **Session Info:**
  - Course title
  - Participant: [Other person's name + avatar]
  - Scheduled time
  - Duration
- **Device Check:**
  - Camera preview
  - Microphone indicator
  - Speaker test
- **Ready Actions:**
  - "Join Session" button → enters video room
  - "Test Audio/Video" link
- **Tips:**
  - "Ensure good lighting"
  - "Use headphones for best audio"

### Video Room (Main Session)
*Implemented via VideoProvider iframe/SDK*

- **Video Area:**
  - Main video feed (active speaker)
  - Self-view (small, corner)
  - Participant video
- **Controls Bar:**
  - Mute/unmute microphone
  - Enable/disable camera
  - Screen share
  - Chat toggle
  - Settings (audio/video devices)
  - Leave session button
- **Side Panel (Optional):**
  - Text chat
  - Session notes
  - Resource links
- **Session Timer:**
  - Time elapsed
  - Scheduled end time

### Session Header
- Course title
- Participant name
- Session status indicator

### Post-Session Screen
- "Session Ended"
- **Quick Feedback:**
  - Rating: 1-5 stars
  - Optional comment
  - Submit button
- **Actions:**
  - "Back to Dashboard" → SDSH/TDSH
  - "Book Next Session" → SBOK
  - "View Course Content" → CCNT
- **Session Resources:**
  - Recording (when available):
    - "Recording processing..." initially
    - "Watch Recording" when ready
    - Duration display
  - Files shared during session (if any)
  - "Download" button for each resource
  - ST can upload additional resources post-session
- **Upload Resources (ST only):**
  - "Upload Session Materials" button
  - Share slides, notes, or follow-up materials
  - Files stored in R2, linked to session
  - Source: Brian Review 2025-12-26

---

## User Stories Fulfilled

- US-S042: Join scheduled session
- US-S043: Participate in video session
- US-V001: Access video conferencing
- US-V005: Access session recordings (if enabled)
- US-V006: Rate session after completion
- US-T007: ST conducts teaching session

---

## States & Variations

| State | Description |
|-------|-------------|
| Early | Session not yet joinable (>15 min before) |
| Joinable | Within join window, pre-join screen |
| In Progress | Active video session |
| Waiting | One participant waiting for other |
| Ended | Post-session feedback screen |
| No Show | Other participant didn't join |
| Technical Issues | Connection problems, retry options |

---

## Mobile Considerations

- Full-screen video by default
- Controls at bottom, auto-hide
- Portrait: stacked videos
- Landscape: side-by-side
- Minimize to picture-in-picture

---

## Error Handling

| Error | Display |
|-------|---------|
| Session not found | "Session not found. Check your dashboard." |
| Not authorized | "You're not part of this session." |
| Session expired | "This session has ended." |
| Connection failed | "Unable to connect. [Retry]" |
| Camera/mic denied | "Please allow camera/microphone access." |
| Video provider error | "Video service unavailable. Try again." |

---

## Analytics Events

| Event | Trigger | Data |
|-------|---------|------|
| `page_view` | Page load | session_id, user_role |
| `session_joined` | Entered video room | session_id, time_before_start |
| `session_started` | Both participants present | session_id |
| `session_ended` | Session concluded | session_id, duration |
| `feedback_submitted` | Rating submitted | session_id, rating |
| `tech_issue` | Connection problem | error_type |

---

## Server Integration

### API Endpoints Called

| Endpoint | When | Purpose |
|----------|------|---------|
| `GET /api/sessions/:id` | Page load | Verify session exists, user authorized, get status |
| `POST /api/video/token` | "Join Session" clicked | Get PlugNmeet join token |
| `POST /api/sessions/:id/feedback` | Feedback submitted | Record rating and comments |
| `GET /api/sessions/:id/resources` | Post-session screen | Get session resources |
| `POST /api/sessions/:id/resources` | Upload resources (ST) | Upload session materials |
| `GET /api/resources/:id` | Download clicked | Get download URL |

### PlugNmeet Integration Flow

```
Page Load:
  1. GET /api/sessions/:id → session details, participants
  2. Check session.status (scheduled, active, ended)
  3. Check current time vs scheduled_start (join window)

Join Flow:
  1. User clicks "Join Session"
  2. POST /api/video/token { session_id, role: "participant"|"host" }
  3. Backend:
     - Verifies user is session participant
     - Calls PlugNmeet API: createRoom (if not exists)
     - Calls PlugNmeet API: getJoinToken
     - Returns { join_url, token }
  4. Client redirects to PlugNmeet room (iframe or new tab)

During Session:
  - PlugNmeet handles all video/audio
  - Our client polls /api/sessions/:id for status updates (optional)
  - Webhooks update our DB asynchronously
```

### Webhooks Received (Background)

| Webhook | Impact | DB Update |
|---------|--------|-----------|
| `participant_joined` | Track attendance start | `session_attendance.joined_at` |
| `participant_left` | Track attendance end | `session_attendance.left_at`, calculate `duration_seconds` |
| `room_finished` | Session complete | `sessions.status = 'completed'`, `sessions.ended_at` |
| `recording_proceeded` | Recording ready | `sessions.recording_url` (replicated to R2) |

### Token Generation Details

```typescript
// POST /api/video/token
{
  session_id: string,
  user_id: string (from auth)
}

// Response
{
  join_url: "https://plugnmeet.peerloop.com/...",
  token: "jwt-token-here",
  room_id: "peerloop-session-{session_id}"
}
```

### Data Flow Diagram

```
┌─────────────┐      ┌─────────────┐      ┌─────────────┐
│   SROM      │      │  PeerLoop   │      │  PlugNmeet  │
│   (Client)  │      │  (Server)   │      │  (Service)  │
└──────┬──────┘      └──────┬──────┘      └──────┬──────┘
       │                    │                    │
       │ GET /sessions/:id  │                    │
       │───────────────────>│                    │
       │ session data       │                    │
       │<───────────────────│                    │
       │                    │                    │
       │ POST /video/token  │                    │
       │───────────────────>│                    │
       │                    │ createRoom()       │
       │                    │───────────────────>│
       │                    │ room_id            │
       │                    │<───────────────────│
       │                    │                    │
       │                    │ getJoinToken()     │
       │                    │───────────────────>│
       │                    │ token              │
       │                    │<───────────────────│
       │ { join_url, token }│                    │
       │<───────────────────│                    │
       │                    │                    │
       │ redirect to PlugNmeet                   │
       │─────────────────────────────────────────>
       │                    │                    │
       │           [Webhooks: participant_joined, room_finished, etc.]
       │                    │<───────────────────│
       │                    │ Update DB          │
```

### Recording Storage

1. PlugNmeet stores recording temporarily
2. Webhook `recording_proceeded` triggers:
   - Download from PlugNmeet
   - Upload to R2: `recordings/sessions/{session_id}/{timestamp}.webm`
   - Update `sessions.recording_url`
3. Client shows "Recording Available" with R2 URL

---

## Notes

- **VideoProvider:** PlugNmeet (selected per `assets/video-platform-decisions.md`)
- CD-007: 1-on-1 optimized, P2P when possible
- Recording storage: PlugNmeet → R2 replication
- Session reminders: 24h, 1h, 15min before (via Resend)
- Consider "reschedule" option from pre-join if issues
- Accessibility: Keyboard navigation, screen reader support for controls

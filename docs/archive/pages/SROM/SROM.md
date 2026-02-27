# SROM - Session Room

| Field | Value |
|-------|-------|
| Route | `/session/:id` |
| Access | Authenticated (session participants only) |
| Priority | P0 |
| Status | 📋 Spec Only |
| Block | 4 |
| JSON Spec | `src/data/pages/session/[id].json` |
| Astro Page | `src/pages/session/[id].astro` |

---

## Purpose

Video conferencing interface for 1-on-1 tutoring sessions between students and Student-Teachers, powered by VideoProvider (PlugNmeet).

---

## User Stories

| ID | Story | Priority | Status |
|----|-------|----------|--------|
| US-S042 | As a Student, I need to join scheduled sessions so that I can receive tutoring | P0 | 📋 |
| US-S043 | As a Student, I need to participate in video sessions so that I can learn | P0 | 📋 |
| US-V001 | As a User, I need access to video conferencing so that sessions can happen | P0 | 📋 |
| US-V005 | As a User, I need access to session recordings so that I can review later | P1 | 📋 |
| US-V006 | As a User, I need to rate sessions after completion so that quality is tracked | P0 | 📋 |
| US-T007 | As a S-T, I need to conduct teaching sessions so that I can help students | P0 | 📋 |

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

| Target | Trigger | Notes | Status |
|--------|---------|-------|--------|
| SDSH | Session ends (Student) | Return to dashboard | 📋 |
| TDSH | Session ends (ST) | Return to dashboard | 📋 |
| CCNT | "Back to Course" | Return to course content | 📋 |

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
| session_assessments | rating, comment | Feedback data |

---

## Features

### Pre-Join Screen
- [ ] Session info (course, participant, time, duration) `[US-S042]`
- [ ] Camera preview `[US-S042]`
- [ ] Microphone indicator `[US-S042]`
- [ ] Speaker test `[US-S042]`
- [ ] "Join Session" button `[US-S042]`
- [ ] "Test Audio/Video" link `[US-S042]`
- [ ] Tips (lighting, headphones) `[US-S042]`

### Video Room
- [ ] Main video feed (active speaker) `[US-S043]`
- [ ] Self-view (small, corner) `[US-S043]`
- [ ] Participant video `[US-S043]`
- [ ] Mute/unmute microphone `[US-S043]`
- [ ] Enable/disable camera `[US-S043]`
- [ ] Screen share `[US-S043]`
- [ ] Chat toggle `[US-S043]`
- [ ] Settings (audio/video devices) `[US-S043]`
- [ ] Leave session button `[US-S043]`
- [ ] Session timer `[US-S043]`

### Session Header
- [ ] Course title `[US-S042]`
- [ ] Participant name `[US-S042]`
- [ ] Session status indicator `[US-S042]`

### Post-Session Screen
- [ ] "Session Ended" message `[US-V006]`
- [ ] Rating: 1-5 stars `[US-V006]`
- [ ] Optional comment `[US-V006]`
- [ ] Submit feedback button `[US-V006]`
- [ ] "Back to Dashboard" link `[US-V006]`
- [ ] "Book Next Session" link `[US-V006]`
- [ ] Session resources section `[US-V005]`
- [ ] Recording (when available) `[US-V005]`
- [ ] Upload resources (ST only) `[US-T007]`

---

## Sections (from Plan)

### Pre-Join Screen
- Session info card
- Device preview/check
- Join button
- Tips

### Video Room (PlugNmeet)
- Video area (main + self)
- Controls bar
- Side panel (chat, notes)
- Session timer

### Session Header
- Course title
- Participant name
- Status indicator

### Post-Session Screen
- Feedback form
- Navigation options
- Resources section

---

## API Endpoints

| Endpoint | Method | Purpose | Status |
|----------|--------|---------|--------|
| `/api/sessions/:id` | GET | Verify session, get status | 📋 |
| `/api/video/token` | POST | Get PlugNmeet join token | 📋 |
| `/api/sessions/:id/feedback` | POST | Record rating and comments | 📋 |
| `/api/sessions/:id/resources` | GET | Get session resources | 📋 |
| `/api/sessions/:id/resources` | POST | Upload materials (ST) | 📋 |
| `/api/resources/:id` | GET | Get download URL | 📋 |

**PlugNmeet Integration Flow:**
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
```

**Token Response:**
```typescript
POST /api/video/token
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

**Webhooks Received:**
| Webhook | Impact | DB Update |
|---------|--------|-----------|
| `participant_joined` | Track attendance start | `session_attendance.joined_at` |
| `participant_left` | Track attendance end | `session_attendance.left_at` |
| `room_finished` | Session complete | `sessions.status = 'completed'` |
| `recording_proceeded` | Recording ready | `sessions.recording_url` |

**Recording Storage:**
1. PlugNmeet stores recording temporarily
2. Webhook triggers download from PlugNmeet
3. Upload to R2: `recordings/sessions/{session_id}/{timestamp}.webm`
4. Update `sessions.recording_url`

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

## Mobile Considerations

- Full-screen video by default
- Controls at bottom, auto-hide
- Portrait: stacked videos
- Landscape: side-by-side
- Minimize to picture-in-picture

---

## Implementation Notes

- **VideoProvider:** PlugNmeet (selected per `assets/video-platform-decisions.md`)
- CD-007: 1-on-1 optimized, P2P when possible
- Recording storage: PlugNmeet → R2 replication
- Session reminders: 24h, 1h, 15min before (via Resend)
- Consider "reschedule" option from pre-join if issues
- Accessibility: Keyboard navigation, screen reader support
- Join window: 15 minutes before scheduled_start
- WebRTC required for video

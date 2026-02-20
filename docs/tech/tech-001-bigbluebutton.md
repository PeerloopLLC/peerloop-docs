# tech-001: BigBlueButton

**Type:** Video Conferencing Platform
**Status:** ✅ SELECTED (2026-01-20)
**Research Date:** 2025-11-30
**Source:** https://docs.bigbluebutton.org/

> **Implementation (2026-01-20):** VideoProvider interface implemented with BBB adapter.
> See `src/lib/video/` for the implementation.
> Client (Brian) confirmed BBB as the video platform choice.

---

## Overview

BigBlueButton (BBB) is an open-source web conferencing system designed specifically for online learning. It provides real-time sharing of audio, video, slides, chat, and screen.

## Key Capabilities

### Core Features
| Feature | Description | Relevant User Stories |
|---------|-------------|----------------------|
| Video Conferencing | WebRTC-based multi-party video calls | US-V001, US-A014, US-T007 |
| Screen Sharing | Share desktop or application windows | US-A017, US-T007 |
| Recording | Record sessions for later playback | US-V005, US-A014 |
| Shared Notes | Collaborative note-taking via Etherpad | US-V003 |
| Chat | Real-time text messaging during sessions | US-V003 |
| Breakout Rooms | Split meetings into smaller groups | P2 future |
| Presentations | Upload and display slides/documents | US-V003 |
| Whiteboard | Interactive drawing during presentations | P2 future |
| Polls | Real-time audience polling | P2 future |

### API Capabilities
- **Meeting Management:** create, join, end meetings
- **Recording Management:** getRecordings, publishRecordings, deleteRecordings
- **Webhooks:** Callbacks for meeting end, recording ready events
- **Monitoring:** isMeetingRunning, getMeetings, getMeetingInfo
- **Session Tracking:** Track session duration, participants

### User Roles
- **MODERATOR:** Full control (start/stop recording, manage participants)
- **VIEWER:** Standard participant with configurable permissions

## Technical Requirements

### Hosting Model
**Self-hosted only** - BigBlueButton requires dedicated server infrastructure

| Requirement | Specification |
|-------------|---------------|
| OS | Ubuntu 22.04 64-bit |
| RAM | 16GB minimum (recommended 32GB+) |
| CPU | 8 cores minimum |
| Storage | SSD recommended |
| Network | Public IP, ports 80/443, UDP 16384-32768 |

### Integration Architecture
```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│   Alpha Peer    │────▶│   BBB Server    │◀────│   BBB Client    │
│   Backend       │ API │   (Self-hosted) │     │   (Browser)     │
└─────────────────┘     └─────────────────┘     └─────────────────┘
```

**IMPORTANT:** API calls must originate from server-side only. Never embed BBB API secrets in browser JavaScript.

### Security Model
- Checksum-based API authentication
- Server-to-server HTTPS communication
- JWT-encoded webhook payloads
- Password or role-based meeting access

## Pricing

| Item | Cost |
|------|------|
| Software | FREE (open-source, LGPL) |
| Hosting | Infrastructure costs only |

**Estimated hosting costs:**
- Cloud VM (16GB, 8 cores): $80-150/month
- Larger deployments: Consider Scalelite load balancer

### Managed Hosting Alternatives
- BigBlueButton hosting providers exist but add monthly fees
- Consider providers like Blindside Networks for managed service

## User Story Coverage

### Directly Addresses (P0)
| Story ID | Story | Coverage |
|----------|-------|----------|
| US-V001 | Handle video chat experience | Full |
| US-A013 | Facilitate tutor sessions | Full |
| US-A014 | Video calls with recording | Full |
| US-A017 | Screen sharing in sessions | Full |
| US-V004 | Monitor time for billing | Partial (via API) |
| US-T007 | Video sessions with screen sharing | Full |

### Partially Addresses
| Story ID | Story | Gap |
|----------|-------|-----|
| US-A016 | Monitored session time | API provides duration; billing integration needed |
| US-A018 | Store tutor sessions | Recording storage; metadata integration needed |
| US-V006 | Post-session assessment | External feature needed |

### Does NOT Address
| Story ID | Story | Alternative Needed |
|----------|-------|-------------------|
| US-A015 | AI-powered summaries/transcripts | Requires additional AI service |
| US-V007 | AI-powered summaries/transcripts | Requires additional AI service |
| US-V002 | Limit participants | Configurable in API, but defaults may need tuning |

## Integration Considerations

### Pros
- Purpose-built for education/tutoring
- Full-featured video conferencing
- Recording included
- No per-minute or per-user fees
- Open source, customizable

### Cons
- Self-hosting complexity
- Server maintenance burden
- No built-in AI transcription
- Scaling requires Scalelite infrastructure
- Development environment setup is complex

### React/Astro Integration
1. Backend (Node.js) handles BBB API calls
2. Generate signed join URLs server-side
3. Redirect users to BBB interface OR embed via iframe
4. Webhook endpoints receive meeting/recording events

```javascript
// Example: Server-side meeting creation
const crypto = require('crypto');
const BBB_URL = process.env.BBB_URL;
const BBB_SECRET = process.env.BBB_SECRET;

function createMeeting(meetingId, name) {
  const params = `meetingID=${meetingId}&name=${encodeURIComponent(name)}&record=true`;
  const checksum = crypto
    .createHash('sha1')
    .update(`create${params}${BBB_SECRET}`)
    .digest('hex');
  return `${BBB_URL}/api/create?${params}&checksum=${checksum}`;
}
```

## Recommendations

1. **Accept BBB as video solution** - It's required and capable
2. **Plan for hosting infrastructure** - Budget for dedicated VM or managed service
3. **Build webhook integration early** - Critical for session tracking
4. **Plan AI transcription separately** - Consider Whisper API or similar for US-A015, US-V007
5. **Consider Cloudflare Workers** - For API proxy layer between Alpha Peer and BBB

## Open Questions

- [ ] Will Alpha Peer self-host BBB or use managed provider?
- [ ] What recording retention policy is needed?
- [ ] How will recordings be stored long-term (BBB server vs cloud storage)?
- [ ] Need to evaluate Scalelite for multi-server scaling

---

## PeerLoop Integration

*Added 2026-01-20*

### VideoProvider Interface

PeerLoop implements a `VideoProvider` abstraction to allow swapping video platforms if needed.

**Location:** `src/lib/video/`

```typescript
interface VideoProvider {
  createRoom(options: CreateRoomOptions): Promise<Room>;
  endRoom(roomId: string): Promise<void>;
  getJoinUrl(roomId: string, participant: Participant, options?: CreateRoomOptions): Promise<JoinInfo>;
  getRoomInfo(roomId: string): Promise<RoomInfo>;
  isRoomActive(roomId: string): Promise<boolean>;
  getRecordings(roomId: string): Promise<Recording[]>;
  deleteRecording(recordingId: string): Promise<void>;
  parseWebhook(payload: unknown): WebhookEvent | null;
}
```

### BBB Adapter

The `BBBProvider` class implements this interface using BBB's checksum-based API authentication.

**Environment Variables Required:**
- `BBB_URL` - BBB server URL (e.g., `https://bbb.example.com/bigbluebutton`)
- `BBB_SECRET` - BBB shared secret for API authentication

### Database Schema

Sessions table tracks BBB room info:
- `bbb_meeting_id` - Our session ID (used as BBB meetingID)
- `bbb_internal_meeting_id` - BBB's internal ID
- `bbb_attendee_pw` - Attendee password for join URLs
- `bbb_moderator_pw` - Moderator password for join URLs

### API Endpoints

| Endpoint | Purpose |
|----------|---------|
| `POST /api/sessions` | Create session booking |
| `GET /api/sessions/:id` | Get session details |
| `DELETE /api/sessions/:id` | Cancel session |
| `POST /api/sessions/:id/join` | Get BBB join URL (creates room if needed) |
| `POST /api/sessions/:id/rating` | Rate session after completion |
| `POST /api/webhooks/bbb` | Handle BBB webhook events |

### Webhook Events Handled

| BBB Event | Action |
|-----------|--------|
| `meeting-started` | Mark session as `in_progress` |
| `meeting-ended` | Mark session as `completed` |
| `user-joined` | Create attendance record |
| `user-left` | Update attendance duration |
| `rap-publish-ended` | Store recording URL |

---

## References

- [BigBlueButton API Documentation](https://docs.bigbluebutton.org/development/api/)
- [BigBlueButton Development Guide](https://docs.bigbluebutton.org/development/guide/)
- [Scalelite Load Balancer](https://github.com/blindsidenetworks/scalelite)

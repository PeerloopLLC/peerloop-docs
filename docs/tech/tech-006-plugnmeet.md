# tech-006-plugnmeet.md

**Service:** PlugNmeet
**Type:** Video Conferencing / Virtual Classroom
**Website:** https://www.plugnmeet.org/
**Source:** CD-028 (Brian LeBlanc Slack message, Dec 24, 2025)
**Status:** ❌ NOT SELECTED (2026-01-20 - Client chose BigBlueButton instead)

> **Decision Change (2026-01-20):** Brian decided to use BigBlueButton instead of PlugNmeet.
> The VideoProvider interface allows easy swapping between providers if this decision changes.
> See `tech-001-bigbluebutton.md` for the selected implementation.

---

## Overview

PlugNmeet positions itself as a **"modern BigBlueButton replacement"** - open-source like BBB but built with newer technology (WebRTC/LiveKit). Brian discovered this after concerns were raised that BBB's software is "quite old and dated."

**Key Value Proposition:**
- Modern, Zoom-like interface (vs BBB's clunky UI)
- Same classroom features as BBB
- Better scalability due to microservices architecture
- Pay-per-session or flat server cost model

---

## Pricing

| Model | Cost | Notes |
|-------|------|-------|
| **Self-Hosted** | Free (VPS cost only) | $5-10/month for VPS, flat rate regardless of user count |
| **Cloud (Flex Plan)** | Flat monthly fee | Based on concurrent usage/capacity, NOT registered users |

**vs BBB/Blindside Networks:** BBB typically charges per-session fees. PlugNmeet's flat rate model could be more cost-effective for high-volume usage.

---

## Interface & UX

- **Modern, responsive, customizable**
- Looks more like **Zoom or Google Meet** than traditional LMS/BBB interfaces
- Drops the "clunky interface" of BBB while keeping classroom features

---

## Features

### Core Video Features
- HD video
- Screen sharing
- Waiting rooms
- Breakout rooms

### Classroom/Education Tools
| Feature | Description |
|---------|-------------|
| **Whiteboard** | Upload PDFs or Office documents and draw on them |
| **Breakout Rooms** | Essential for group work |
| **Polls & Voting** | Instant student feedback |
| **Shared Notepad** | Collaborative note-taking during lecture |
| **Moderator Controls** | Lock students' mics, webcams, or chat permissions (critical for maintaining order) |

### Accessibility
- **AI-powered "Meeting Agent"**
- Live speech-to-text
- Translations
- Significant plus for accessibility compliance

### LMS Integration
- Ready-made plugins for **Moodle, WordPress, Joomla**
- Students can join directly from course pages without separate login
- Retains the deep Moodle/LMS integration that makes BBB popular

---

## Scalability

**Verdict: Highly scalable - more so than BBB**

### BBB Limitations (Why PlugNmeet is Better)
- BBB is **"monolithic"** - heavy and difficult to split across servers
- Scaling BBB requires load balancer redirecting to completely separate servers (adds cost and complexity)

### PlugNmeet Architecture
- Built on **Go and LiveKit** (modern WebRTC infrastructure)
- Uses **microservices approach**

### Scaling Tiers

| Scale | Capability |
|-------|------------|
| **Small** | Single robust server handles hundreds of concurrent users (lightweight software) |
| **Large** | Separate "heavy lifting" components (e.g., Recording engine on cheap separate server so live video isn't slowed) |
| **Massive** | Cluster media servers - distribute video streams across multiple servers while keeping them in same "session" logic. Can handle 1,000+ students |

---

## Fit for PeerLoop

### Alignment with Requirements

| Requirement | PlugNmeet Support |
|-------------|-------------------|
| 1:1 tutoring sessions | ✅ Lightweight, cost-effective for small sessions |
| Group sessions | ✅ Breakout rooms, scales to many concurrent users |
| Recording | ✅ Can run recording on separate server |
| LMS/Course integration | ✅ Plugin ecosystem (though we'd need custom integration) |
| Modern UX | ✅ Zoom-like interface vs BBB's dated look |
| Pay-per-session model | ✅ Self-hosted = flat cost regardless of sessions |
| Education-specific features | ✅ Whiteboard, polls, shared notepad, moderator controls |
| Accessibility | ✅ AI transcription and translation |

### Potential Concerns
- **Newer/less established** than BBB (need to verify production stability)
- **Custom integration needed** - not using Moodle/WordPress plugins directly
- **Self-hosted complexity** - need to manage infrastructure (vs Blindside Networks managed BBB)

---

## Comparison: PlugNmeet vs BBB

| Aspect | BigBlueButton | PlugNmeet |
|--------|---------------|-----------|
| Architecture | Monolithic | Microservices (Go + LiveKit) |
| Interface | Traditional LMS look | Modern Zoom-like |
| Scalability | Difficult (load balancer) | Easy (component separation) |
| Self-hosted cost | Complex setup | $5-10/month VPS |
| Managed hosting | Blindside Networks (per-session) | Cloud Flex Plan (capacity-based) |
| Education features | ✅ Full | ✅ Full (equivalent) |
| LMS plugins | Moodle, WordPress, etc. | Moodle, WordPress, Joomla |
| AI features | Limited | Meeting Agent (transcription, translation) |
| Maturity | Established (10+ years) | Newer (needs verification) |

---

## Decision Summary (2025-12-26)

**PlugNmeet selected as video platform for PeerLoop.**

### Why PlugNmeet over BBB:
1. Modern Zoom-like interface (better UX for students)
2. Better scalability architecture (microservices vs monolithic)
3. Lower cost (~$10/mo VPS vs $80-150/mo for BBB)
4. AI accessibility features built-in (transcription, translation)
5. Same classroom features (whiteboard, breakout rooms, polls)
6. Full API coverage for our VideoProvider interface

---

## Questions Resolved ✅

| Question | Resolution |
|----------|------------|
| Stability | Brian approved after evaluation (2025-12-26) |
| API | Full API documented below - covers all our needs |
| Recording storage | PlugNmeet server + replicate to R2 |
| Hosted option | Self-hosted for cost efficiency |
| Migration | N/A - starting with PlugNmeet |

---

## API Reference

**Base URL:** `https://{your-server}/auth`
**Method:** All endpoints use POST with JSON body
**Auth Headers Required:**
- `API-KEY`: Your server API key
- `HASH-SIGNATURE`: HMAC-SHA256 of request body (hex format) using API Secret
- `Content-Type`: application/json

### Room Management

#### Create Room
**Endpoint:** `POST /room/create`

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `room_id` | string | Yes | Unique room identifier (reusable after session ends) |
| `max_participants` | number | No | Maximum allowed participants |
| `empty_timeout` | number | No | Seconds room stays active if no one joins |
| `metadata` | object | Yes | Room configuration (see below) |

**Metadata Object:**
| Field | Type | Required |
|-------|------|----------|
| `room_title` | string | Yes |
| `welcome_message` | string | No |
| `webhook_url` | string | No |
| `logout_url` | string | No |
| `room_features` | object | Yes |
| `default_lock_settings` | object | No |

**Room Features (key fields for PeerLoop):**
| Field | Type | Purpose |
|-------|------|---------|
| `allow_webcams` | boolean | Enable video |
| `mute_on_start` | boolean | Mute participants on join |
| `allow_screen_share` | boolean | Screen sharing |
| `room_duration` | number | Max duration (0 = unlimited) |
| `recording_features.is_allow` | boolean | Enable recording |
| `recording_features.enable_auto_cloud_recording` | boolean | Auto-start recording |
| `chat_features.is_allow` | boolean | Enable chat |
| `whiteboard_features.is_allow` | boolean | Enable whiteboard |
| `waiting_room_features.is_active` | boolean | Waiting room |
| `breakout_room_features.is_allow` | boolean | Breakout rooms |

**Response:**
```json
{
  "status": true,
  "msg": "success",
  "room_info": { ... }
}
```

#### Join Room (Get Token)
**Endpoint:** `POST /room/getJoinToken`

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `room_id` | string | Yes | Room to join |
| `user_info.name` | string | Yes | Display name |
| `user_info.user_id` | string | Yes | Unique user ID |
| `user_info.is_admin` | boolean | Yes | Moderator access |
| `user_info.is_hidden` | boolean | No | Join as spectator |
| `user_info.user_metadata.profile_pic` | string | No | Avatar URL |
| `user_info.user_metadata.record_webcam` | boolean | No | Include in recording |

**Response:**
```json
{
  "status": true,
  "msg": "success",
  "token": "eyJhbGciOiJIUzI1NiIs..."
}
```

**Usage:** Redirect user to `https://{server}/?access_token={token}`

#### Check Room Status
**Endpoint:** `POST /room/isRoomActive`

| Parameter | Type | Required |
|-----------|------|----------|
| `room_id` | string | Yes |

**Response:**
```json
{
  "status": true,
  "is_active": true,
  "msg": "success"
}
```

#### End Room
**Endpoint:** `POST /room/endRoom`

| Parameter | Type | Required |
|-----------|------|----------|
| `room_id` | string | Yes |

**Response:**
```json
{
  "status": true,
  "msg": "room ended"
}
```

### Recording Management

#### Fetch Recordings
**Endpoint:** `POST /recording/fetch`

| Parameter | Type | Required | Default |
|-----------|------|----------|---------|
| `room_ids` | array | Yes | - |
| `from` | number | No | 0 |
| `limit` | number | No | 20 |
| `order_by` | string | No | DESC |

**Response includes:** `record_id`, `room_id`, `file_path`, `file_size`, `creation_time`

#### Get Recording Info
**Endpoint:** `POST /recording/recording-info`

#### Download Recording
**Endpoint:** `POST /recording/download`

Returns download token for secure file access.

#### Delete Recording
**Endpoint:** `POST /recording/delete`

#### Update Recording Metadata
**Endpoint:** `POST /recording/update-metadata`

### Webhooks

Configure `webhook_url` in room creation to receive events.

| Event | Trigger |
|-------|---------|
| `room_created` | Room initialized |
| `room_started` | First participant joins |
| `room_finished` | Room ends |
| `participant_joined` | User enters room |
| `participant_left` | User leaves room |
| `track_published` | Audio/video stream starts |
| `track_unpublished` | Audio/video stream stops |
| `start_recording` | Recording begins |
| `end_recording` | Recording stops |
| `recording_proceeded` | Recording file ready |
| `rtmp_started` | RTMP broadcast begins |
| `rtmp_ended` | RTMP broadcast ends |
| `speech_to_text_session_started` | Transcription begins |
| `speech_to_text_session_ended` | Transcription ends |

**Webhook Payload Structure:**
```typescript
interface WebhookEvent {
  event: string;
  room: { sid: string; identity: string; name: string };
  participant?: { sid: string; identity: string; name: string };
  recording_info?: { ... };
}
```

### SDKs Available

| Language | Package |
|----------|---------|
| PHP | `composer require mynaparrot/plugnmeet-sdk` |
| JavaScript | `npm install @anthropic-ai/plugnmeet-sdk-js` |

---

## Mapping to PeerLoop VideoProvider Interface

| VideoProvider Method | PlugNmeet Endpoint | Notes |
|---------------------|-------------------|-------|
| `createRoom()` | `POST /room/create` | ✅ Full support |
| `deleteRoom()` | `POST /room/endRoom` | ✅ Ends active session |
| `getJoinUrl()` | `POST /room/getJoinToken` | ✅ Returns token for URL |
| `startRecording()` | Room feature or webhook | Use `enable_auto_cloud_recording` |
| `stopRecording()` | Via room end or API | Recording stops with room |
| `getRecording()` | `POST /recording/fetch` | ✅ Full support |
| `getRoomStatus()` | `POST /room/isRoomActive` | ✅ Full support |

**Webhook Integration:**
- `room_finished` → Update session status in DB
- `recording_proceeded` → Trigger R2 replication
- `participant_joined/left` → Track attendance

---

## Data Persistence & Session History

### What PlugNmeet Stores (Queryable via API)

| API | Data Available | Limitation |
|-----|----------------|------------|
| `/room/fetchPastRooms` | Room title, room_id, room_sid, participant count, created/ended timestamps | Aggregated - no individual user data |
| `/analytics/fetch` | File metadata, room-level stats | Deprecated; no per-user breakdown |
| `/recording/fetch` | Recording files by room_id | Files only, not user data |

**Key limitation:** PlugNmeet uses its own `user_id` namespace. When you call `getJoinToken`, you pass your user ID, but PlugNmeet doesn't maintain a queryable database linking "PeerLoop user X attended sessions Y and Z."

### What Must Be Captured via Webhooks

| Webhook Event | Data to Store in PeerLoop DB |
|---------------|------------------------------|
| `participant_joined` | user_id, room_id, timestamp → attendance start |
| `participant_left` | user_id, room_id, timestamp → attendance end |
| `room_finished` | room_id, timestamp → session completion |
| `recording_proceeded` | room_id, file info → link recording to session |

### PeerLoop Database Design for Session Tracking

```
sessions table
├── session_id (PeerLoop ID)
├── plugnmeet_room_id
├── plugnmeet_room_sid
├── status, started_at, ended_at
└── recording_url

session_attendance table
├── session_id
├── user_id (PeerLoop user)
├── joined_at, left_at
└── duration_seconds
```

### Webhook Handler Pattern

```typescript
// POST /api/webhooks/plugnmeet
switch (event.event) {
  case 'participant_joined':
    await db.sessionAttendance.create({
      sessionId: lookupByRoomId(event.room.identity),
      userId: event.participant.identity, // PeerLoop user_id passed at join
      joinedAt: new Date()
    });
    break;
  case 'participant_left':
    await db.sessionAttendance.update({
      leftAt: new Date(),
      durationSeconds: calculateDuration()
    });
    break;
  case 'room_finished':
    await db.sessions.update({
      status: 'completed',
      endedAt: new Date()
    });
    break;
  case 'recording_proceeded':
    await replicateToR2(event.recording_info);
    await db.sessions.update({
      recordingUrl: r2Url
    });
    break;
}
```

**Bottom line:** Webhooks are required for user-level session data. PlugNmeet's API provides room-level history, but attendance tracking per user must be built by listening to `participant_joined/left` events.

---

## User Stories Covered

Same as BBB (tech-001):
- US-V001-V007 (Video/Session stories)
- US-A013-A018 (Admin video management)
- US-T007 (Teacher sessions)

---

## Source Document

**CD-028:** Brian LeBlanc Slack messages (Dec 24, 2025)
- Context: Fraser's son (former TopHat coder) noted BBB is "quite old and dated"
- Brian researched modern alternatives
- Found PlugNmeet as "Best Modern BBB Replacement"
- Still needs deeper investigation before final decision

---

## References

### Official Documentation
- [PlugNmeet Website](https://www.plugnmeet.org/)
- [API Reference Introduction](https://www.plugnmeet.org/docs/api/intro)
- [Create Room API](https://www.plugnmeet.org/docs/api/room/create)
- [Join Room API](https://www.plugnmeet.org/docs/api/room/join)
- [Room Is Active API](https://www.plugnmeet.org/docs/api/room/is-active)
- [End Room API](https://www.plugnmeet.org/docs/api/room/end)
- [Fetch Past Rooms API](https://www.plugnmeet.org/docs/api/room/fetch-past)
- [Recording Fetch API](https://www.plugnmeet.org/docs/api/recording/fetch)
- [Webhooks Documentation](https://www.plugnmeet.org/docs/others/webhooks/)
- [Scalable Setup Guide](https://www.plugnmeet.org/docs/developer-guide/scalable-setup)

### SDKs
- [JavaScript/Node.js SDK](https://github.com/mynaparrot/plugNmeet-sdk-js)
- [PHP SDK](https://github.com/mynaparrot/plugNmeet-sdk-php)
- [Server Source Code](https://github.com/mynaparrot/plugNmeet-server)

### npm
- [plugnmeet-sdk-js on npm](https://www.npmjs.com/package/plugnmeet-sdk-js)

---

## PeerLoop Integration

*Migrated from `research/run-001/assets/video-platform-decisions.md` (2026-01-19)*

### VideoProvider Interface Contract

PeerLoop implements a VideoProvider abstraction to allow swapping video platforms if needed.

```typescript
interface VideoProvider {
  createRoom(options: CreateRoomOptions): Promise<Room>;
  deleteRoom(roomId: string): Promise<void>;
  getJoinUrl(roomId: string, participant: Participant): Promise<string>;
  startRecording(roomId: string): Promise<RecordingId>;
  stopRecording(recordingId: string): Promise<RecordingUrl>;
  getRecording(recordingId: string): Promise<RecordingUrl>;
  getRoomStatus(roomId: string): Promise<RoomStatus>;
}

interface CreateRoomOptions {
  title: string;
  maxParticipants?: number;
  duration?: number;
  enableRecording?: boolean;
  enableWaitingRoom?: boolean;
  webhookUrl?: string;
}

interface Participant {
  id: string;
  name: string;
  isAdmin: boolean;
  avatarUrl?: string;
}

interface Room {
  id: string;
  title: string;
  joinUrl: string;
  status: 'active' | 'ended';
}

interface RoomStatus {
  isActive: boolean;
  participantCount: number;
  startedAt?: Date;
}
```

### Implementation Approach

1. **Build to interface** - All code targets `VideoProvider` interface
2. **PlugNmeet adapter** - Implements interface using PlugNmeet API
3. **Keep abstraction** - Allows future swap to BBB if needed

### Cost Comparison

| Platform | Model | Est. Monthly Cost | Notes |
|----------|-------|-------------------|-------|
| BBB (self-hosted) | VM | $80-150 | Need ops capacity |
| BBB (Blindside) | Per-session | Variable | Depends on volume |
| **PlugNmeet (self-hosted)** | VPS | **$5-10** | ✅ Selected |
| PlugNmeet (Cloud Flex) | Capacity | TBD | Fallback if self-host difficult |

**Budget:** ~$10/mo for video infrastructure.

### Recording Storage Strategy

1. **Primary:** PlugNmeet server stores recordings
2. **Replication:** Copy to Cloudflare R2 for redundancy
3. **Trigger:** `recording_proceeded` webhook → R2 upload job

```typescript
// On recording_proceeded webhook
async function replicateToR2(recordingInfo: RecordingInfo) {
  const downloadUrl = await plugnmeet.getRecordingDownloadUrl(recordingInfo.record_id);
  const fileStream = await fetch(downloadUrl);

  await r2.put(
    `sessions/${recordingInfo.room_id}/recording.webm`,
    fileStream.body,
    { httpMetadata: { contentType: 'video/webm' } }
  );

  return `${R2_PUBLIC_URL}/sessions/${recordingInfo.room_id}/recording.webm`;
}
```

### Source Documents

- CD-028 - Brian's PlugNmeet discovery
- API.md - VideoProvider interface definition

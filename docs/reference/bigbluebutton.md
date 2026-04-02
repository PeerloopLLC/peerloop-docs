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

PeerLoop uses **Blindside Networks managed BBB SaaS** — no self-hosted infrastructure required.

| Field | Value |
|-------|-------|
| Provider | Blindside Networks (managed BBB hosting) |
| API URL | `https://peerloop.api.rna1.blindsidenetworks.com/bigbluebutton/api/` |
| Secret | 88-char shared secret (in `.dev.vars` and CF Dashboard secrets) |
| Contact (Sales) | Binoy Wilson (`binoy.wilson@blindsidenetworks.com`, 613-695-0264) |
| Contact (Technical) | Fred Dixon (CEO, Blindside Networks) — responded to technical questions (2026-03-26, CD-038; 2026-03-29, ticket #21121) |
| Support | `support@blindsidenetworks.com` — for implementation help |

**Self-hosted alternative** (not used — documented for reference):

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

### Managed Hosting (Blindside Networks)
- **Selected provider:** Blindside Networks managed BBB SaaS
- Pricing TBD — contact Binoy Wilson for current rates
- No infrastructure to provision or maintain

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

- [x] ~~Will Alpha Peer self-host BBB or use managed provider?~~ → Blindside Networks managed SaaS (confirmed Session 276)
- [ ] What recording retention policy is needed?
- [ ] How will recordings be stored long-term (Blindside servers vs R2 replication)? → Download mechanism confirmed (Conv 037, CD-038): cookie-based `.m4v` fetch
- [ ] ~~Need to evaluate Scalelite for multi-server scaling~~ (N/A with managed hosting)
- [x] ~~Decide webcam storage policy: all webcams vs instructor-only~~ → **Instructor-only** enabled by Blindside Networks (2026-03-29, ticket #21121). Student webcams excluded from recordings.
- [ ] Provide production analytics callback URL to Blindside Networks (CD-038)
- [x] ~~Confirm JWT shared secret for analytics callbacks (same as BBB_SECRET?)~~ → **Yes, same shared secret** confirmed by Fred Dixon (2026-03-29, ticket #21121)

---

## Blindside Networks Integration Gotchas

*Added 2026-02-24 (Session 276)*

1. **No iframe embedding.** Blindside's BBB deployment blocks iframe. Must open BBB in a new browser tab via `window.open()`. Our `SessionRoom.tsx` uses `window.location.href` to redirect.

2. **`!` encoding in query strings.** `encodeURIComponent` does NOT encode `!` per RFC 3986, but BBB's checksum verification expects `!` → `%21`. Our `buildQueryString` must post-process to replace `!` with `%21`.

3. **URL normalization.** Blindside's API URL already ends with `/api/` (`https://peerloop.api.rna1.blindsidenetworks.com/bigbluebutton/api/`). Our `buildApiUrl` appends `/api/` again → double `/api/api/`. Must strip trailing `/api` or `/api/` from `serverUrl` before appending.

4. **Duplicate meeting creation is OK.** Calling `create` on an existing meeting returns `duplicateWarning` but `returncode=SUCCESS`. Treat as success — no special handling needed.

5. **Multi-tenant redirects are normal.** Join URLs redirect to a different host (e.g., `myda412331.rna1.blindsidenetworks.com`). This is expected behavior in Blindside's multi-tenant infrastructure.

6. **Webhook URL format.** The `meta_endCallbackUrl` parameter must be URL-encoded in the create call. BBB calls this URL when the meeting ends. As of Conv 075, the URL includes an HMAC token for authentication (see Webhook Authentication section).

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
- `BBB_URL` - BBB API base URL: `https://peerloop.api.rna1.blindsidenetworks.com/bigbluebutton/api/`
- `BBB_SECRET` - BBB shared secret (88 chars, from Blindside Networks)

**Where configured:**
- Local dev: `../Peerloop/.dev.vars` (both vars)
- CF Preview/Production: `BBB_URL` is non-secret → `wrangler.toml [vars]`; `BBB_SECRET` is secret → CF Dashboard only

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
| `POST /api/webhooks/bbb` | Handle BBB webhook events (HMAC-authenticated via URL token) |
| `POST /api/webhooks/bbb-analytics` | Handle BBB analytics callback (JWT-authenticated) |
| `POST /api/sessions/:id/complete` | Manual session completion (webhook healing) |

### Webhook Events Handled

| BBB Event | Action |
|-----------|--------|
| `meeting-started` | Mark session as `in_progress` |
| `meeting-ended` | Mark session as `completed` |
| `user-joined` | Create attendance record |
| `user-left` | Update attendance duration |
| `rap-publish-ended` | Store recording URL |
| Analytics callback | Per-attendee engagement data (separate endpoint: `bbb-analytics.ts`) |

### Webhook Authentication (Conv 075)

BBB's two webhook endpoints use different auth mechanisms:

| Endpoint | Auth Method | Secret |
|----------|-------------|--------|
| `POST /api/webhooks/bbb` | URL-embedded HMAC-SHA256 token | `BBB_SECRET` |
| `POST /api/webhooks/bbb-analytics` | JWT in request body (HS512) | `BBB_SECRET` |

**End-callback (`bbb.ts`):** BBB's `meta_endCallbackUrl` has no built-in authentication mechanism (confirmed via CD-038 / Blindside Networks). Authentication is achieved by appending an HMAC token to the callback URL at room creation time:

1. `join.ts` generates `HMAC-SHA256(sessionId, BBB_SECRET)` via `src/lib/webhook-auth.ts`
2. Token is appended as `?token=<hex>` to the `meta_endCallbackUrl`
3. `bbb.ts` extracts the token from the request URL and verifies it against the `roomId` from the parsed webhook event
4. Constant-time comparison prevents timing attacks

**Utility:** `src/lib/webhook-auth.ts` — `generateWebhookToken(roomId, secret)` / `verifyWebhookToken(token, roomId, secret)`. Uses Web Crypto API (HMAC-SHA256). Reusable for any webhook endpoint without built-in auth.

### Connectivity Test (Session 336)

`tests/integration/bbb-connectivity.test.ts` verifies BBB API connectivity by creating a temporary meeting, querying it, and cleaning up. Runs as part of `npm test` when real Blindside Networks credentials are in `.dev.vars`; skips automatically otherwise (`describeWithBBB` helper). The test client (`tests/helpers/bbb.ts`) is independent of `src/lib/video/` — it tests the external service, not our adapter.

### Webhook Failure Healing (Session 334)

If the `meeting-ended` webhook fails to fire, sessions can be manually completed by the teacher or course creator via `POST /api/sessions/:id/complete`. All completion paths (webhook, manual, admin) use the shared `completeSession()` function in `src/lib/booking.ts`, ensuring consistent module_id freezing and sequential completion enforcement.

---

## Recording Downloads (CD-038, Conv 037)

*Source: Fred Dixon (Blindside Networks), 2026-03-26*

Blindside Networks stores session recordings in `.m4v` (MPEG-4 Video) format. Recordings are accessible via the `getRecordings` API.

### Download Mechanism

Recording download requires a **two-step cookie-based authentication**:

1. **Fetch the capture page** to obtain a session cookie:
   ```
   GET https://recordings.rna1.blindsidenetworks.com/bn/{record_id}/capture/
   ```
   → Extract `Set-Cookie` header from response

2. **Use the cookie to download the `.m4v` file:**
   ```
   GET https://recordings.rna1.blindsidenetworks.com/bn/{record_id}/capture/capture-0.m4v
   Cookie: <cookie from step 1>
   ```

**Important:** Direct download of the `.m4v` URL without the cookie will fail. The capture page URL sets an authentication cookie that gates access to the actual video file.

### URL Pattern

The `record_id` in the URL corresponds to BBB's `internal_meeting_id` (which is the same as the record ID for recorded meetings). This maps to our `bbb_internal_meeting_id` column in the `sessions` table.

### R2 Replication

Our `replicateRecordingToR2()` function in `src/lib/r2.ts` needs to implement this two-step cookie fetch to download `.m4v` files from Blindside's servers and store them in Cloudflare R2 for long-term retention. See RECORDING-PERSIST block in PLAN.md.

### Webcam Storage Options

Blindside Networks configures per-account whether **viewer (student) webcams** are stored in recordings:

| Option | Behavior | Use Case |
|--------|----------|----------|
| All webcams (default) | Both instructor and student webcams stored | Full session replay |
| **Instructor-only** ✅ | **Only the moderator's webcam stored** | **Student privacy** |

**Decision (2026-03-29):** Instructor-only webcam storage enabled on our account by Blindside Networks (ticket #21121). Student webcams are excluded from recordings for privacy. This is an account-level setting, not an API parameter.

---

## Analytics Callbacks (CD-038, Conv 037)

*Source: Blindside Networks "Hosting Analytics Callback" document (confidential, 2025-06-13) + Fred Dixon email (2026-03-26)*

### Overview

After a meeting ends, Blindside Networks can POST a JSON analytics payload to a callback URL. This provides per-attendee engagement metrics without polling.

### Activation

Pass `meta_analytics-callback-url` as a meta parameter on the BBB `create` API call:

```
meta_analytics-callback-url=https://peerloop.com/api/webhooks/bbb-analytics
```

The callback URL must:
- Resolve to a public IP (no private ranges, localhost)
- Use port 80, 443, or >= 1024
- Preferably HTTPS (payload contains personal data)

### Authentication

The callback request includes a JWT Bearer token:

```
Content-Type: application/json
Authorization: Bearer <JWT token>
```

JWT validation:
- Algorithm: `HS512` (HMAC-SHA512)
- Secret: The BBB shared secret (`BBB_SECRET`) — **confirmed same secret** used for API checksum authentication (Fred Dixon, 2026-03-29, ticket #21121)
- Must check `exp` (expiry) claim — reject if in the past
- The JSON analytics body is NOT included in the JWT payload — it's the HTTP request body

### Analytics JSON Structure

```json
{
  "version": "1.0",
  "meeting_id": "<meeting_id from create API>",
  "internal_meeting_id": "<BBB internal ID / record_id>",
  "custom": { /* any custom meta data passed on create */ },
  "data": {
    "metadata": { "meeting_name": "...", "analytics_callback_url": "..." },
    "duration": 3196,
    "start": "2019-03-15 08:49:04 +0000",
    "finish": "2019-03-15 09:42:20 +0000",
    "attendees": [{
      "ext_user_id": "45",
      "name": "Sylvia Kelley",
      "moderator": true,
      "joins": ["2019-03-15 08:49:29 +0000"],
      "leaves": ["2019-03-15 09:42:20 +0000"],
      "duration": 3171.0,
      "recent_talking_time": "2019-03-15 09:42:01 +0000",
      "engagement": {
        "chats": 3,
        "talks": 318,
        "raisehand": 0,
        "emojis": 0,
        "poll_votes": 0,
        "talk_time": 1746
      }
    }],
    "files": ["default.pdf"],
    "polls": [{ "id": "...", "published": true, "options": ["Yes", "No"], "votes": {...}, "start": "..." }]
  }
}
```

### Per-Attendee Fields

| Field | Type | Description |
|-------|------|-------------|
| `ext_user_id` | string | External user ID (our user ID, passed via join URL) |
| `name` | string | Full name (from join URL) |
| `moderator` | boolean | Whether user was a moderator (Teacher = true) |
| `joins` | string[] | Array of join timestamps (supports reconnections) |
| `leaves` | string[] | Array of leave timestamps |
| `duration` | number | Total time in session (seconds) |
| `recent_talking_time` | string | Last time user spoke |
| `engagement.chats` | number | Number of chat messages sent |
| `engagement.talks` | number | Number of times microphone was active |
| `engagement.raisehand` | number | Hand-raise count |
| `engagement.emojis` | number | Emoji reaction count |
| `engagement.poll_votes` | number | Number of polls answered |
| `engagement.talk_time` | number | Total talk time (seconds) |

### Response Requirements

| Status | Meaning |
|--------|---------|
| `200 OK` or `202 Accepted` | Callback processed successfully |
| `410 Gone` | Meeting deleted from our system — stop retrying |
| `3XX` | Treated as error (redirects not followed) |
| Other | Error — BBB will retry several times |

Response body should be empty. On error, may return short text (`Content-Type: text/plain`) for Blindside logging.

### PeerLoop Implementation

Our endpoint: `POST /api/webhooks/bbb-analytics` (`src/pages/api/webhooks/bbb-analytics.ts`)

- JWT verification: Implemented (HS512 with `BBB_SECRET`)
- Payload storage: `session_analytics` table (upsert by `session_id`)
- Status: **Fully wired, awaiting end-to-end verification.** `meta_analytics-callback-url` is passed on room creation (`join.ts:135` → `bbb.ts:306`). JWT secret confirmed same as `BBB_SECRET` (2026-03-29). Testing deferred to DEV-WEBHOOKS block.

### Setup Steps (from Blindside docs)

1. Deploy analytics endpoint to production
2. ~~Provide callback URL to Blindside Networks~~ — **Not needed:** URL is self-configuring via `meta_analytics-callback-url` on each `create` call (see Webhook Environment Strategy below)
3. ~~They configure a test account with the endpoint and provide shared secret confirmation~~ — **Done:** JWT uses same `BBB_SECRET` (confirmed 2026-03-29)
4. Test: run a session on staging → verify callback arrives with analytics JSON (Fred: "Let us know if you're getting callbacks at that URL after your BigBlueButton sessions end")

### Webhook Environment Strategy (Conv 037)

BBB webhooks are **self-configuring** — callback URLs are set per-meeting via meta parameters in the `create` API call, built dynamically from `request.url.origin` in `join.ts`. This means:

- **Production** (`peerloop.pages.dev`): webhooks auto-point to production
- **Staging** (`staging.peerloop.pages.dev`): webhooks auto-point to staging
- **Local dev** (`localhost:4321`): BBB cannot call back to localhost (private IP — blocked by Blindside). Use integration tests instead.

No vendor-side webhook URL configuration is needed per-environment (unlike Stripe, which requires separate Dashboard entries).

---

## References

- [BigBlueButton API Documentation](https://docs.bigbluebutton.org/development/api/)
- [BigBlueButton Development Guide](https://docs.bigbluebutton.org/development/guide/)
- [Scalelite Load Balancer](https://github.com/blindsidenetworks/scalelite)

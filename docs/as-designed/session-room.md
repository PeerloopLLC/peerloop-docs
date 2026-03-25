# Session Room — Join, Conduct, Complete

**Created:** Conv 003
**Status:** Implemented
**Companion:** `docs/as-designed/session-booking.md` (covers everything up to "session is scheduled")

## Overview

This document covers the session lifecycle from the participant's perspective — from a scheduled session through joining the BBB video room, conducting the session, and the post-session experience. It answers: how do student and teacher arrive at the session, what must each do to start, what restrictions are in place, and what happens if someone is late or absent.

---

## Session Room Page (SROM)

**File:** `src/pages/session/[id].astro`
**URL:** `/session/:id`
**Access:** Authenticated; must be the session's student or teacher

The page loads full session context (enrollment, course, both participants) and renders the `SessionRoom` React component.

---

## State Machine

The SessionRoom component (`src/components/booking/SessionRoom.tsx`) implements a 6-state finite state machine that governs the entire participant experience:

```
                    15+ min before start
                    ┌─────────┐
                    │  early  │  Countdown timer visible
                    └────┬────┘
                         │  Within 15 min of start
                         v
                    ┌──────────┐
                    │ joinable │  "Join Session" button enabled
                    └────┬─────┘
                         │  Click "Join Session"
                         v
                    ┌──────────┐
                    │ joining  │  Calling POST /api/sessions/:id/join
                    └────┬─────┘
                         │  BBB URL returned
                         v
                    ┌────────────┐
                    │ in_session │  BBB open in new tab; polling every 15s
                    └────┬───────┘
                         │  Session status = 'completed'
                         v
                    ┌───────────┐
                    │ completed │  Rating form + goals update
                    └───────────┘

                    ┌───────────┐
                    │ cancelled │  Terminal (separate entry)
                    └───────────┘
```

**State persistence rule:** Once in `joining`, `in_session`, or the rating phase, the timer/polling cannot reset the state backward. This prevents race conditions between the countdown timer and API responses.

---

## Participant Experience by Phase

### Phase 1: Waiting (state: `early`)

**What they see:** A countdown timer showing time until the join window opens.

**When:** More than 15 minutes before `scheduled_start`.

Both student and teacher see the same waiting screen with session details (course name, other participant's name, scheduled time).

### Phase 2: Pre-Join (state: `joinable`)

**What they see:** A "Join Session" button becomes active.

**When:** From 15 minutes before `scheduled_start` until `scheduled_end`.

The join window is identical for both participants — neither has priority. Either can join first.

### Phase 3: Joining (state: `joining`)

**What happens:** The client calls `POST /api/sessions/:id/join`. This is where the BBB room is created (if not already) and a join URL is generated.

**Join endpoint logic** (`src/pages/api/sessions/[id]/join.ts`):

1. **Verify participant** — must be the session's student or teacher
2. **Check session status** — rejects if `completed` or `cancelled`
3. **Enforce join window:**
   - Too early (>15 min before start) → 403 with `joinable_at` timestamp
   - Too late (after `scheduled_end`) → 403 "Session time has passed"
4. **Create BBB room on first join** (idempotent — skips if room exists):
   - `maxParticipants: 2`
   - `enableWaitingRoom: false` (no lobby for 1-on-1 tutoring)
   - `enableRecording: true`
   - `muteOnStart: false`
   - `allowModsToUnmuteUsers: true`
   - Welcome message: "Welcome to your tutoring session!"
5. **Determine participant role:**
   - **Teacher → moderator** (can end meeting, manage recording)
   - **Student → attendee** (standard participant)
6. **Transition session to `in_progress`** (if still `scheduled`):
   ```sql
   UPDATE sessions
   SET bbb_meeting_id = ?,
       status = CASE WHEN status = 'scheduled' THEN 'in_progress' ELSE status END,
       started_at = CASE WHEN started_at IS NULL THEN datetime('now') ELSE started_at END
   WHERE id = ?
   ```
7. **Return join URL** — BBB URL with meeting ID, user name, avatar, and role-appropriate password

**Response:**
```json
{
  "join_url": "https://bbb.example.com/bigbluebutton/api/join?...",
  "room_created": true,
  "session": { ... },
  "participant": { "name": "Jane Doe", "role": "teacher", "is_moderator": true }
}
```

The client opens the BBB URL in a new browser tab.

### Phase 4: In Session (state: `in_session`)

**What they see:** The SROM page shows an "in progress" state while BBB runs in the other tab. The page polls `GET /api/sessions/:id` every 15 seconds to detect when the session ends.

**BBB room behavior:**
- Teacher has moderator controls (end meeting, manage recording)
- Student has standard attendee controls
- Max 2 participants enforced by BBB
- Recording enabled by default

**Webhook events during session** (received at `POST /api/webhooks/bbb`):

| BBB Event | Our Handler | Effect |
|-----------|-------------|--------|
| `meeting-created` / `meeting-started` | `room_started` | Sets `status = 'in_progress'`, `started_at` |
| `user-joined` | `participant_joined` | Creates `session_attendance` record with `joined_at` |
| `user-left` | `participant_left` | Updates attendance: `left_at`, `duration_seconds` |
| `meeting-ended` | `room_ended` | Calls `completeSession()` → sets `completed`, freezes module |
| `rap-publish-ended` | `recording_ready` | Stores `recording_url` on session; attempts R2 replication if `downloadUrl` available (see Recording R2 Replication below) |

**Analytics callback** (received at `POST /api/webhooks/bbb-analytics`, separate from event webhooks):
BBB POSTs learning analytics JSON (per-attendee talk time, chat count, attendance duration, polls) after meeting ends. JWT-authenticated. See BBB Learning Analytics section below.

### Phase 5: Completed (state: `completed`)

**What they see** (`src/components/booking/SessionCompletedView.tsx`):

**Both participants:**
- 5-star overall rating (required)
- Text comment (optional)
- Recording link (if available)
- Contextual navigation (Conv 026):
  - "View Course Sessions" → `/course/{slug}/sessions` — primary CTA after rating submitted, secondary before
  - "Go to Dashboard" — secondary button (role-appropriate dashboard)
  - "Continue Course" — secondary button

**Student only (additional):**
- Sub-ratings: Teaching Quality, Interaction, Materials (each 1-5)
- Learning goals update (optional, 20-char minimum)

**Rating endpoint:** `POST /api/sessions/:id/rating`
- Session must be `completed`
- User must be a participant
- Cannot rate twice (idempotent)
- Updates `user_stats` (average_rating, total_reviews) as a non-blocking side effect

---

## Restrictions & Guards

| Restriction | Where Enforced | Detail |
|-------------|---------------|--------|
| Must be participant | Page + API | 403 if user is not the session's student or teacher |
| 15-min join window | `POST .../join` | Cannot join earlier than 15 min before `scheduled_start` |
| No join after end time | `POST .../join` | Cannot join after `scheduled_end` |
| No join if completed/cancelled | `POST .../join` | Status must be `scheduled` or `in_progress` |
| Teacher = moderator | `POST .../join` | Only teacher gets BBB moderator role |
| Max 2 participants | BBB room config | Enforced at room creation |
| No waiting room | BBB room config | 1-on-1 sessions skip lobby |
| Rate only once | `POST .../rating` | Duplicate check per assessor |
| Rate only completed sessions | `POST .../rating` | Status must be `completed` |
| Manual complete after end only | `POST .../complete` | Cannot complete before `scheduled_end` |
| Manual complete by teacher/creator | `POST .../complete` | Students cannot manually complete |
| Max 2 reschedules | `PATCH .../sessions/:id` | `reschedule_count >= 2` → 422 |
| Late cancel needs reason | `DELETE .../sessions/:id` | Within 24h of start and no reason → 400 |

---

## Lateness & No-Shows

### Late Arrival

The join window extends from **15 minutes before** `scheduled_start` all the way to `scheduled_end`. A late participant can join at any point within this window.

**Scenario: Teacher joins on time, student is 10 minutes late**
1. Teacher clicks "Join" → room created, `status = in_progress`, `started_at` recorded
2. Teacher is alone in BBB room (waiting)
3. Student arrives late, clicks "Join" → gets join URL for the existing room
4. Both are now in the room; session proceeds with reduced time
5. BBB `user-joined` webhook fires for each, creating separate attendance records with accurate `joined_at` timestamps

**Scenario: Both join late**
- Same flow — whoever joins first triggers room creation and `in_progress` transition
- Attendance records capture actual join times for both

**After `scheduled_end`:** The join endpoint returns 403 "Session time has passed." Neither participant can join. The session remains `scheduled` (or `in_progress` if someone was briefly in and left).

### No-Show Detection (Implemented — Conv 025)

`detectNoShows()` in `src/lib/booking.ts` finds sessions where:
1. `status = 'scheduled'` (not already transitioned)
2. `scheduled_end < now` (window has closed)
3. No `session_attendance` records exist (nobody joined)

**On detection:** Sets `status = 'no_show'` and `ended_at = scheduled_end`. Sends `session_no_show` notification to both student and teacher ("Missed Session").

**Trigger:** `POST /api/admin/sessions/cleanup` (admin-only, no cron on Workers). Runs `detectNoShows()` as part of a batch cleanup that also handles stale in-progress sessions. Returns a summary: `{ no_shows: N, auto_completed: M, errors: [] }`.

**Why no attendance = no-show (not just "nobody joined first"):** BBB rooms are created on-demand when a participant clicks "Join". If nobody joined, no room was ever created and no webhooks fired. The session never left `scheduled` status.

**Idempotent:** Once a session is marked `no_show`, it no longer matches the `status = 'scheduled'` filter. Running cleanup twice produces zero results on the second pass.

---

## Session Completion Paths

Five paths lead to `status = 'completed'`, all calling the shared `completeSession()` function in `src/lib/booking.ts`:

| Path | Trigger | When |
|------|---------|------|
| **Automatic** | BBB `meeting-ended` webhook | Real-time when teacher ends meeting |
| **Empty room** | BBB `user-left` webhook + empty-room detection | Real-time when last participant leaves (Conv 025) |
| **Stale cleanup** | `POST /api/admin/sessions/cleanup` → `detectStaleInProgress()` | Admin-triggered batch, 1h+ after scheduled_end (Conv 025) |
| **Manual** | `POST /api/sessions/:id/complete` | Teacher or course creator, after `scheduled_end` |
| **Admin** | `PATCH /api/admin/sessions/:id` | Admin override, any time |

### Empty Room Detection (Conv 025)

When a `user-left` webhook fires, `detectEmptyRoomAndComplete()` checks three conditions:

1. Session is `in_progress`
2. At least 2 distinct users have attendance records (both participants joined at some point)
3. No attendance records with `left_at IS NULL` (nobody still in the room)

If all conditions are met, `completeSession()` is called immediately. This handles the "both Leave, nobody Ends" scenario where the BBB `meeting-ended` webhook never fires.

**Why require 2 distinct users?** If only the teacher joined and then left (student no-show), we don't auto-complete — the session should be handled by the no-show detection system instead.

**UX guidance:** `SessionRoom.tsx` shows a role-specific amber banner during `in_session` state:
- **Teacher:** "Click the three-dot menu (⋯) → End meeting to complete the session for both participants."
- **Student:** "Close the video tab or click Leave when finished. The session completes automatically once both participants have left."

`completeSession()` is idempotent — calling it on an already-completed session returns `already_completed: true` with no state change.

### Stale In-Progress Auto-Complete (Conv 025)

`detectStaleInProgress()` in `src/lib/booking.ts` finds sessions where:
1. `status = 'in_progress'`
2. `scheduled_end + 1 hour < now` (grace period allows meetings to run slightly over)

This is the safety net for when both the `meeting-ended` webhook and the empty-room detection fail (e.g., BBB service outage, webhook delivery failure). Called from `POST /api/admin/sessions/cleanup` alongside no-show detection.

**On detection:** Calls `completeSession()` for each session, which handles module freezing and idempotency. Uses `scheduled_end` as `ended_at` (best available timestamp). Sends notifications to both participants.

### Client-Side Manual Completion (Conv 025)

If a participant is still on the SessionRoom page after `scheduled_end` passes and the session hasn't auto-completed, a role-specific "stuck session" panel appears:

- **Teacher:** Red "Complete Session Now" button → calls `POST /api/sessions/:id/complete`
- **Student:** Pre-populated message form → sends a message to the teacher (via `POST /api/conversations`) asking them to complete the session. The message includes the session path so the teacher can navigate directly.

**Design decision:** Students cannot complete sessions directly. Completion triggers module_id freezing, which a student could abuse to skip a no-show and get module credit. Only teachers and course creators can complete. The student's path is to notify the teacher, who has authority.

**When it shows:** Only in `in_session` view state (triggered by `session.status === 'in_progress'` in `getInitialState()`), after `scheduledEnd` has passed. The polling effect (every 15s) updates the `isPastEnd` flag.

**Note:** `getInitialState()` routes `in_progress` sessions directly to `in_session` view (regardless of time). The countdown timer effect guards against overriding `completed` state once polling detects the DB transition.

**Defense-in-depth summary:** Automatic (BBB webhook) → Empty room (attendance webhook) → Client-side (teacher action or student report) → Admin cleanup (batch) → Future: Cron trigger (CRON-CLEANUP block).

On completion:
- `status → 'completed'`
- `ended_at` set to webhook timestamp or current time
- `module_id` frozen (positional assignment) — unless earlier sessions are still `scheduled`, in which case `module_id` stays NULL to preserve ordering
- Module backfill: later completed sessions with NULL `module_id` get resolved (Conv 026)
- Enrollment check: if all modules now have completed sessions → enrollment auto-completed (Conv 026)
- Post-session actions (async, non-blocking): completion notifications, `sessions_completed` stats, enrollment notifications + stats if applicable (Conv 026)

---

## BBB Room Cleanup on Cancellation

**Implemented:** Conv 026.

When an `in_progress` session is cancelled via `DELETE /api/sessions/:id`, the BBB room may still be running with participants connected. The endpoint now calls `bbb.endRoom(sessionId)` to terminate the room before returning.

**Behavior:**
- Only triggered when `sessionData.status === 'in_progress'` at the time of cancellation (not for `scheduled` sessions — no BBB room exists yet)
- Requires `BBB_URL` and `BBB_SECRET` in the runtime environment; silently skips if not configured
- **Non-blocking:** wrapped in try/catch — if `endRoom()` fails (BBB unreachable, room already ended), the cancellation still succeeds. The error is logged but does not affect the response.
- BBB's `end` API kicks all connected participants and triggers recording processing

**Why non-blocking:** The session is already marked `cancelled` in D1 before the BBB call. If BBB cleanup fails, the room will eventually time out on its own. The DB state is the source of truth — a stale BBB room is cosmetic, not a data integrity issue.

---

## BBB Integration Details

**Provider:** `src/lib/video/bbb.ts` (implements `VideoProvider` interface from `src/lib/video/types.ts`)

**Authentication:** SHA1 checksum — `SHA1(apiName + queryString + secret)`

**Key operations:**

| Operation | BBB API Call | Used When |
|-----------|-------------|-----------|
| Create room | `create` | First participant joins |
| Generate join URL | `join` | Each participant joins |
| End room | `end` | Cancelling an in-progress session (Conv 026) |
| Check room status | `isMeetingRunning` | Debugging / admin |
| Get meeting info | `getMeetingInfo` | Check if room exists before creating |
| Get recordings | `getRecordings` | After `rap-publish-ended` webhook |

**Join URL includes:** meeting ID, participant name, user ID, avatar URL, role-appropriate password (moderator or attendee), redirect=true.

### Recording R2 Replication (Conv 027)

**Goal:** Long-term recording storage in Cloudflare R2, independent of BBB server retention.

**Current state:** Partially implemented — code is wired but blocked on BBB video format availability.

**How it works (when enabled):**
1. `recording_ready` webhook fires with `playbackUrl` (always) and `downloadUrl` (only if BBB video format is enabled)
2. `playbackUrl` is stored in `sessions.recording_url` (HTML player — always available)
3. If `downloadUrl` exists AND R2 binding is available, `replicateRecordingToR2()` fires (non-blocking):
   - Fetches video binary from BBB download URL
   - Streams to R2 at `sessions/{sessionId}/recording.{ext}`
   - Updates `sessions.recording_r2_key` on success
4. If replication fails, BBB playback URL remains as fallback — failure is logged, not propagated

**Schema:** `recording_r2_key TEXT` on `sessions` table (nullable — only populated when R2 replication succeeds)

**BBB format parsing:** `getRecordings()` now handles multiple playback formats (BBB can return presentation, video, podcast). The video format URL is extracted as `downloadUrl` on the `Recording` type. Presentation format URL is `playbackUrl`.

**Blocker:** BBB's default recording format is "presentation" (HTML playback page). The "video" format that produces a downloadable file must be enabled on the BBB server. Blindside Networks managed service status is unknown — requires vendor inquiry (tracked as action item).

**Key files:**
- `src/lib/r2.ts` — `replicateRecordingToR2()` helper
- `src/pages/api/webhooks/bbb.ts` — `handleRecordingReady()` wires R2 replication
- `src/lib/video/bbb.ts` — Multi-format `getRecordings()` parser
- `src/lib/video/types.ts` — `RecordingReadyData.downloadUrl`, `Recording.downloadUrl`

### BBB Learning Analytics (Conv 028)

**Goal:** Capture per-attendee engagement metrics (talk time, chat count, attendance duration, poll results) after each session.

**Mechanism:** BBB's `meta_analytics-callback-url` parameter — set on room creation alongside `meta_endCallbackUrl`. After a meeting ends, BBB POSTs a JSON payload containing the same data that powers the Learning Analytics Dashboard, signed with a JWT (HS512, using `BBB_SECRET`).

**How it works:**
1. `join.ts` passes `analyticsCallbackUrl` in `CreateRoomOptions` → BBB receives `meta_analytics-callback-url`
2. Meeting ends → BBB POSTs analytics JSON to `POST /api/webhooks/bbb-analytics`
3. Endpoint verifies JWT Bearer token (HS512 signed with `BBB_SECRET`)
4. Payload stored in `session_analytics` table (full JSON + summary columns)
5. `GET /api/sessions/:id` includes analytics for completed sessions

**Analytics payload includes per-attendee:**
- `duration` — seconds in meeting
- `engagement.talk_time` — seconds speaking
- `engagement.chats` — messages sent
- `engagement.raisehand` — hand raises
- `engagement.emojis` — emoji reactions
- `engagement.poll_votes` — polls participated in
- Join/leave timestamps

**Schema:** `session_analytics` table — `session_id` (UNIQUE FK), `analytics_json` (TEXT), `duration_seconds`, `attendee_count`, `created_at`. Upserts on retry (BBB may resend).

**Key files:**
- `src/pages/api/webhooks/bbb-analytics.ts` — Analytics callback endpoint (JWT verification + storage)
- `src/pages/api/sessions/[id]/join.ts` — Sets `analyticsCallbackUrl` on room creation
- `src/lib/video/bbb.ts` — Passes `meta_analytics-callback-url` in `createRoom`
- `src/lib/video/types.ts` — `CreateRoomOptions.analyticsCallbackUrl`
- `migrations/0001_schema.sql` — `session_analytics` table
- `tests/api/webhooks/bbb-analytics.test.ts` — 8 tests (JWT, storage, upsert, lookup, errors)

### BBB Webhook Reconciliation (Conv 028)

**Goal:** Self-healing for missed BBB webhooks — catches `meeting-ended` and `recording_ready` events that didn't arrive.

**Mechanism:** `reconcileBBBSessions()` in `src/lib/booking.ts`, wired into `POST /api/admin/sessions/cleanup`. Polls BBB's API for authoritative state:

1. **Missed `meeting-ended`:** Finds `in_progress` sessions past `scheduled_end` with a `bbb_meeting_id`. Calls `getRoomInfo()` — if room is no longer active, calls `completeSession()`.
2. **Missed `recording_ready`:** Finds `completed` sessions with no `recording_url`. Calls `getRecordings()` — if a published recording exists, backfills `recording_url`.

**Not recoverable:** Analytics callbacks (`meta_analytics-callback-url`). BBB deletes the underlying data shortly after meeting end. Analytics are best-effort.

**Automated scheduling:** Deferred to CRON-CLEANUP block (Cloudflare Cron Trigger, pre-launch). Currently runs as part of manual admin cleanup.

---

## File Map

```
src/
├── pages/
│   ├── session/[id].astro                    # SROM page (auth + data loading)
│   └── api/
│       ├── sessions/[id]/
│       │   ├── join.ts                       # POST — join window, room creation, BBB URL
│       │   ├── complete.ts                   # POST — manual completion (teacher/creator)
│       │   ├── rating.ts                     # POST — post-session rating
│       │   └── index.ts                      # GET detail, PATCH reschedule, DELETE cancel
│       └── webhooks/
│           ├── bbb.ts                        # BBB webhook handler (all events)
│           └── bbb-analytics.ts              # BBB Learning Analytics callback (JWT-verified)
├── components/booking/
│   ├── SessionRoom.tsx                       # State machine, countdown, join flow, polling
│   └── SessionCompletedView.tsx              # Post-session rating + goals UI
├── lib/
│   ├── booking.ts                            # completeSession(), resolveModuleAssignments()
│   └── video/
│       ├── bbb.ts                            # BBB API client (VideoProvider impl)
│       └── types.ts                          # VideoProvider interface
```

---

## Session Invites ("Book Now")

Teachers can send instant session invites to students via the notification system. This enables starting a session immediately rather than booking a future time slot.

### Flow

1. **Teacher initiates:** Clicks "Offer Session Now" (bolt icon) in My Students → `POST /api/session-invites`
2. **Student notified:** Receives notification with "Accept & Join" action button
3. **Student accepts:** Clicks notification → booking page with `?invite=` param → one-click accept → `POST /api/session-invites/:id/accept`
4. **Session created:** At `now + 5 minutes`, 1 hour duration
5. **Both redirect:** To `/session/:id` (session room) — join window is already open (15-min early window means `now - 10min`)

### Two Modes

- **New booking:** Student has unbooled modules → invite creates a new session
- **Reschedule:** All modules booked → invite auto-cancels the next upcoming scheduled session and creates a new one at `now + 5min`

### Walkthrough: Instant Session (Teacher → Student)

**Scenario:** Sarah Miller (teacher) wants to start a session right now with Alex Chen (student) for "AI Tools Overview". Alex is enrolled with 0% progress.

#### Sarah's Steps (Teacher)

1. **Navigate to My Students** — `/teaching/students`
   - Sees all active students grouped by course
   - Alex appears under "AI Tools Overview" with status `enrolled`

2. **Click the ⚡ bolt icon next to Alex's name**
   - Fires `POST /api/session-invites` with Alex's enrollment ID
   - Backend validates: Sarah is the assigned teacher, enrollment is active, no pending invite exists
   - Creates `session_invites` row with `status: 'pending'`, expires in 30 minutes

3. **See inline invite status on Alex's row**
   - Bolt icon changes to a clock icon (amber) while invite is pending
   - Banner appears below the row: "Invite sent to Alex Chen — waiting for response (expires in 29m 45s)"
   - Live countdown updates every second
   - Component polls `GET /api/session-invites?enrollment_id=` every 10 seconds

4. **Alex accepts → row updates automatically**
   - Poll detects `status: 'accepted'` with `accepted_session_id`
   - Banner changes to green: "Alex Chen accepted! Session starting soon." with **Join Session →** button
   - Teacher's `data_version` is bumped on acceptance → notification badge updates within 30s
   - Notification arrives: "Alex Chen accepted — session starting now" with "Join Session" action

5. **Join the session room**
   - Click "Join Session →" in the row banner (or follow the notification link)
   - Navigates to `/session/:id` — join window is already open
   - Enters BBB room as **moderator**

#### Alex's Steps (Student)

1. **Receive notification**
   - Appears in notification center (top-right)
   - Message: "Sarah Miller is offering an instant session for AI Tools Overview"
   - "Accept & Join" action button, expires in 30 minutes

2. **Click "Accept & Join"**
   - Redirects to `/course/ai-tools-overview/book?invite={inviteId}`
   - Booking wizard loads in simplified mode — skips teacher/date/time steps
   - Shows single confirmation: "Accept Session"

3. **Click "Accept Session"**
   - `POST /api/session-invites/:id/accept` fires
   - Session created: `scheduled_start = now + 5 minutes`, 1 hour duration
   - Invite status → `accepted`, Sarah notified

4. **Join the session room**
   - Redirected to `/session/:id`
   - Join window already open (15-min early window covers `now + 5min`)
   - Click "Join Session" → enters BBB room as **attendee**

#### Timing Summary

| Event | Time |
|-------|------|
| Sarah sends invite | T+0 |
| Invite expires (if ignored) | T+30 min |
| Alex accepts | T+N (within 30 min) |
| Session scheduled start | Accept + 5 min |
| Join window opens | Immediately (15-min early window) |
| Session ends | Up to 1 hour after start |

#### After the Session

1. **Sarah ends meeting** in BBB (moderator control) → `meeting-ended` webhook fires → `completeSession()` runs
2. **Module frozen** — session assigned to 1st module positionally (Alex's first session)
3. **Both rate each other** — 5-star + optional comment; Alex also rates teaching quality, interaction, materials
4. **Enrollment progresses** — status moves from `enrolled` → `in_progress`
5. **Teacher navigation** — after rating, teacher can return to the course-specific view at `/teaching/courses/{courseId}` (tabbed overview of students, sessions, reviews for that course) or the main dashboard at `/teaching`

### Constraints

- Only the enrollment's assigned teacher or course creator can send invites
- One pending invite per enrollment at a time
- Invites expire after 30 minutes (lazy expiry — checked on access, no background job)
- Teacher + student conflict checks run at accept time
- Session count invariant holds — non-cancelled sessions never exceed module count

### Data Model

`session_invites` table: `id`, `teacher_id`, `enrollment_id`, `status` (pending/accepted/expired/declined), `expires_at`, `accepted_session_id`, `notification_id`

### Key Files

- API: `src/pages/api/session-invites/` (index.ts, [id]/accept.ts, [id]/decline.ts)
- Notifications: `notifySessionInvite()`, `notifySessionInviteAccepted()` in `src/lib/notifications.ts`
- Teacher UI: Inline invite status + polling in `src/components/teachers/workspace/MyStudents.tsx` (InviteButton, InviteStatusBanner, ExpiryCountdown components)
- Student UI: `invite-confirm` step in `src/components/booking/SessionBooking.tsx`
- Version propagation: `bumpUserDataVersion()` called in accept.ts → teacher's notification badge refreshes within 30s
- Notification icons: `NotificationsList.tsx` TYPE_ICONS covers `session_invite`, `session_completed`, `enrollment_completed`, `session_cancelled`, `session_no_show`, `creator_application`, `course_no_teachers`
- RFC: `docs/requirements/rfc/CD-037/`

---

## References

- `docs/as-designed/session-booking.md` — Booking wizard, session creation, module assignment
- `docs/as-designed/availability-calendar.md` — Teacher availability rules
- `docs/as-designed/run-001/_FLOWS.md` §2 — Session Join Flow diagram (references PlugNmeet; BBB replaced it)
- `docs/as-designed/run-001/_features-block-4.md` — SBOK + SROM feature specs
- `docs/DECISIONS.md` — Sessions 331-334 (module assignment, completion healing)
- `docs/requirements/rfc/CD-037/` — Session Invite design document and checklist

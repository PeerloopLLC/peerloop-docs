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
| `rap-publish-ended` | `recording_ready` | Stores `recording_url` on the session |

### Phase 5: Completed (state: `completed`)

**What they see** (`src/components/booking/SessionCompletedView.tsx`):

**Both participants:**
- 5-star overall rating (required)
- Text comment (optional)
- Recording link (if available)
- Navigation: "Go to Dashboard" or "Continue Course"

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

### No-Shows

The `no_show` status exists in the schema but **is not currently automated**. There is no cron job or timer that converts a `scheduled` session to `no_show` after the window closes.

**Current behavior when nobody joins:**
- Session stays `scheduled` forever (no automatic state change)
- No BBB room is ever created (room creation is on-demand at join time)
- No notification is sent

**Manual completion as workaround:** A teacher or course creator can call `POST /api/sessions/:id/complete` after `scheduled_end` has passed, which marks the session `completed`. This is the healing path — but it doesn't distinguish between "session happened" and "nobody showed up."

**Future:** The `no_show` status is ready in the schema for a scheduled job or admin action to detect and mark sessions where no participant joined after the window closed.

---

## Session Completion Paths

Three paths lead to `status = 'completed'`, all calling the shared `completeSession()` function in `src/lib/booking.ts`:

| Path | Trigger | When |
|------|---------|------|
| **Automatic** | BBB `meeting-ended` webhook | Real-time when teacher ends meeting |
| **Manual** | `POST /api/sessions/:id/complete` | Teacher or course creator, after `scheduled_end` |
| **Admin** | `PATCH /api/admin/sessions/:id` | Admin override, any time |

`completeSession()` is idempotent — calling it on an already-completed session returns `already_completed: true` with no state change.

On completion:
- `status → 'completed'`
- `ended_at` set to webhook timestamp or current time
- `module_id` frozen (positional assignment) — unless earlier sessions are still `scheduled`, in which case `module_id` stays NULL to preserve ordering

---

## BBB Integration Details

**Provider:** `src/lib/video/bbb.ts` (implements `VideoProvider` interface from `src/lib/video/types.ts`)

**Authentication:** SHA1 checksum — `SHA1(apiName + queryString + secret)`

**Key operations:**

| Operation | BBB API Call | Used When |
|-----------|-------------|-----------|
| Create room | `create` | First participant joins |
| Generate join URL | `join` | Each participant joins |
| Check room status | `isMeetingRunning` | Debugging / admin |
| Get meeting info | `getMeetingInfo` | Check if room exists before creating |
| Get recordings | `getRecordings` | After `rap-publish-ended` webhook |

**Join URL includes:** meeting ID, participant name, user ID, avatar URL, role-appropriate password (moderator or attendee), redirect=true.

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
│           └── bbb.ts                        # BBB webhook handler (all events)
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
- Teacher UI: BoltIcon button in `src/components/teachers/workspace/MyStudents.tsx`
- Student UI: `invite-confirm` step in `src/components/booking/SessionBooking.tsx`
- RFC: `docs/requirements/rfc/CD-037/`

---

## References

- `docs/as-designed/session-booking.md` — Booking wizard, session creation, module assignment
- `docs/as-designed/availability-calendar.md` — Teacher availability rules
- `docs/as-designed/run-001/_FLOWS.md` §2 — Session Join Flow diagram (references PlugNmeet; BBB replaced it)
- `docs/as-designed/run-001/_features-block-4.md` — SBOK + SROM feature specs
- `docs/DECISIONS.md` — Sessions 331-334 (module assignment, completion healing)
- `docs/requirements/rfc/CD-037/` — Session Invite design document and checklist

# RFC: CD-037 — Instant Session Booking ("Book Now")

**Source:** [CD-037](./CD-037.md)
**Status:** Closed (Conv 004, 2026-03-17)
**Created:** 2026-03-17

---

## Schema

- [x] Add `session_invites` table to `migrations/0001_schema.sql` (id, teacher_id, enrollment_id, status, created_at, expires_at, accepted_session_id, notification_id)
- [x] Add `'session_invite'` to notification type CHECK constraint in `migrations/0001_schema.sql`
- [x] Add indexes: `idx_session_invites_teacher`, `idx_session_invites_enrollment`, `idx_session_invites_status`

## API Endpoints

- [x] `POST /api/session-invites` — Teacher creates an invite (validates enrollment eligibility, creates invite + notification)
- [x] `POST /api/session-invites/[id]/accept` — Student accepts an invite (validates invite, books or reschedules session, updates invite status)
- [x] `POST /api/session-invites/[id]/decline` — Student declines an invite (updates status, optional)
- [x] `GET /api/session-invites?enrollment_id=X` — Check for active invites on an enrollment (used by booking page)

## Notification Integration

- [x] Add `notifySessionInvite()` helper to `src/lib/notifications.ts` (teacher→student: "ready for session now")
- [x] Add `notifySessionInviteAccepted()` helper (student→teacher: "accepted, session starting")
- [x] Add `session_invite` icon + color mapping in `NotificationsList.tsx` TYPE_ICONS
- [x] Add `email_session_invite` preference to notification settings (optional — may share `email_session_booked`)

## Teacher UI — "Offer Session Now" Button

- [x] Teaching dashboard: add "Offer Session Now" action next to student rows
- [x] Message thread: add "Offer Session Now" action in composer or thread header (if feasible)
- [x] Button disabled/hidden when enrollment has no bookable modules AND no future scheduled sessions
- [x] Confirmation before sending: "Offer an instant session for [Module Title] to [Student Name]?"
- [x] Success feedback: "Invite sent! You'll be notified when [Student] accepts."

## Student UI — Booking Page Changes

- [x] `SessionBooking.tsx`: detect `?invite=[id]` query param, fetch and validate invite
- [x] If valid invite with `bookable_count > 0`: show "Start Session Now" confirmation (skip date/time steps)
- [x] If valid invite with `bookable_count === 0`: show reschedule confirmation with auto-selected next session
- [x] If invite expired: show expiry message with guidance
- [x] On accept: redirect to `/session/[id]` instead of success page

## Student UI — Notification & Dashboard Visibility

- [x] Notification renders with action button: "Accept & Join →"
- [x] Learning dashboard: show banner/card when active (non-expired) invite exists for any enrollment
- [x] Consider: course detail page banner if invite exists for that course

## Accept Logic (Core)

- [x] Validate invite: status='pending', not expired, enrollment belongs to student
- [x] If `bookable_count > 0`: create session at `now+5min` / `now+65min` via existing `POST /api/sessions` logic
- [x] If `bookable_count === 0`: find next upcoming scheduled session for enrollment, cancel it, then create new session at `now+5min`
- [x] Update invite: `status='accepted'`, `accepted_session_id` set
- [x] Send acceptance notification + email to teacher
- [x] Handle race conditions: invite accepted twice, session booked between invite and accept

## Seed Data

- [x] Add session invite test records to `migrations-dev/0001_seed_dev.sql` (pending, expired, accepted examples)

## Tests

- [x] Unit tests: `session-invites` API (create, accept, decline, expiry, validation)
- [x] Unit tests: `notifySessionInvite` + `notifySessionInviteAccepted` helpers
- [x] Integration tests: full flow — teacher creates invite → student accepts → session created → module assigned correctly
- [x] Integration tests: reschedule flow — all modules booked → accept invite → next session rescheduled
- [x] Integration tests: overbooking guard — concurrent accept attempts
- [x] Integration tests: expiry — accept after 30min fails gracefully

## Documentation

- [x] Update `docs/architecture/session-room.md` with session invite flow
- [x] Update `research/DB-API.md` with new endpoints
- [x] Update `research/DB-GUIDE.md` with `session_invites` table rationale
- [x] Update `docs/reference/API-REFERENCE.md`

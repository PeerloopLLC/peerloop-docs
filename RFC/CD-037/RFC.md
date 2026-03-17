# RFC: CD-037 — Instant Session Booking ("Book Now")

**Source:** [CD-037](./CD-037.md)
**Status:** Closed (Conv 004, 2026-03-17)
**Created:** 2026-03-17

---

## Schema

- [ ] Add `session_invites` table to `migrations/0001_schema.sql` (id, teacher_id, enrollment_id, status, created_at, expires_at, accepted_session_id, notification_id)
- [ ] Add `'session_invite'` to notification type CHECK constraint in `migrations/0001_schema.sql`
- [ ] Add indexes: `idx_session_invites_teacher`, `idx_session_invites_enrollment`, `idx_session_invites_status`

## API Endpoints

- [ ] `POST /api/session-invites` — Teacher creates an invite (validates enrollment eligibility, creates invite + notification)
- [ ] `POST /api/session-invites/[id]/accept` — Student accepts an invite (validates invite, books or reschedules session, updates invite status)
- [ ] `POST /api/session-invites/[id]/decline` — Student declines an invite (updates status, optional)
- [ ] `GET /api/session-invites?enrollment_id=X` — Check for active invites on an enrollment (used by booking page)

## Notification Integration

- [ ] Add `notifySessionInvite()` helper to `src/lib/notifications.ts` (teacher→student: "ready for session now")
- [ ] Add `notifySessionInviteAccepted()` helper (student→teacher: "accepted, session starting")
- [ ] Add `session_invite` icon + color mapping in `NotificationsList.tsx` TYPE_ICONS
- [ ] Add `email_session_invite` preference to notification settings (optional — may share `email_session_booked`)

## Teacher UI — "Offer Session Now" Button

- [ ] Teaching dashboard: add "Offer Session Now" action next to student rows
- [ ] Message thread: add "Offer Session Now" action in composer or thread header (if feasible)
- [ ] Button disabled/hidden when enrollment has no bookable modules AND no future scheduled sessions
- [ ] Confirmation before sending: "Offer an instant session for [Module Title] to [Student Name]?"
- [ ] Success feedback: "Invite sent! You'll be notified when [Student] accepts."

## Student UI — Booking Page Changes

- [ ] `SessionBooking.tsx`: detect `?invite=[id]` query param, fetch and validate invite
- [ ] If valid invite with `bookable_count > 0`: show "Start Session Now" confirmation (skip date/time steps)
- [ ] If valid invite with `bookable_count === 0`: show reschedule confirmation with auto-selected next session
- [ ] If invite expired: show expiry message with guidance
- [ ] On accept: redirect to `/session/[id]` instead of success page

## Student UI — Notification & Dashboard Visibility

- [ ] Notification renders with action button: "Accept & Join →"
- [ ] Learning dashboard: show banner/card when active (non-expired) invite exists for any enrollment
- [ ] Consider: course detail page banner if invite exists for that course

## Accept Logic (Core)

- [ ] Validate invite: status='pending', not expired, enrollment belongs to student
- [ ] If `bookable_count > 0`: create session at `now+5min` / `now+65min` via existing `POST /api/sessions` logic
- [ ] If `bookable_count === 0`: find next upcoming scheduled session for enrollment, cancel it, then create new session at `now+5min`
- [ ] Update invite: `status='accepted'`, `accepted_session_id` set
- [ ] Send acceptance notification + email to teacher
- [ ] Handle race conditions: invite accepted twice, session booked between invite and accept

## Seed Data

- [ ] Add session invite test records to `migrations-dev/0001_seed_dev.sql` (pending, expired, accepted examples)

## Tests

- [ ] Unit tests: `session-invites` API (create, accept, decline, expiry, validation)
- [ ] Unit tests: `notifySessionInvite` + `notifySessionInviteAccepted` helpers
- [ ] Integration tests: full flow — teacher creates invite → student accepts → session created → module assigned correctly
- [ ] Integration tests: reschedule flow — all modules booked → accept invite → next session rescheduled
- [ ] Integration tests: overbooking guard — concurrent accept attempts
- [ ] Integration tests: expiry — accept after 30min fails gracefully

## Documentation

- [ ] Update `docs/architecture/session-room.md` with session invite flow
- [ ] Update `research/DB-API.md` with new endpoints
- [ ] Update `research/DB-GUIDE.md` with `session_invites` table rationale
- [ ] Update `docs/reference/API-REFERENCE.md`

# CURRENT-BLOCK-PLAN.md — SESSION-INVITE

**Block:** SESSION-INVITE
**Created:** 2026-03-17 Conv 004
**Last Updated:** 2026-03-17 Conv 004
**Status:** IN PROGRESS

> Delete this file when the full block is complete and update PLAN.md status.

---

## Progress

| Phase | Sub-block | Done | Remaining |
|-------|-----------|------|-----------|
| 1 | Schema + Types | ✅ | |
| 2 | Notification Helpers | ✅ | |
| 3 | API Endpoints | ✅ | |
| 4 | Teacher UI | ✅ | |
| 5 | Student UI | ✅ | |
| 6 | Tests | ✅ | 11/11 passing, 5822 total no regressions |
| 7 | Docs | ✅ | DB-API, DB-GUIDE, API-REFERENCE, session-room all updated |

---

## Design Summary

Teacher sends a short-lived Session Invite (30-min expiry) scoped to an enrollment. Student accepts via notification → session created at now+5min → both redirect to session room. If all modules booked, auto-reschedules next upcoming session.

**RFC:** CD-037 (`RFC/CD-037/`)
**Full plan:** `.claude/plans/calm-fluttering-lecun.md`

## Key Files

| Purpose | File |
|---------|------|
| Schema | `../Peerloop/migrations/0001_schema.sql` |
| Types | `../Peerloop/src/lib/db/types.ts` |
| Notifications lib | `../Peerloop/src/lib/notifications.ts` |
| Notifications UI | `../Peerloop/src/components/notifications/NotificationsList.tsx` |
| Booking eligibility | `../Peerloop/src/lib/booking.ts` |
| Session creation pattern | `../Peerloop/src/pages/api/sessions/index.ts` |
| Teacher UI | `../Peerloop/src/components/teachers/workspace/MyStudents.tsx` |
| Booking page | `../Peerloop/src/pages/course/[slug]/book.astro` |
| Booking component | `../Peerloop/src/components/booking/SessionBooking.tsx` |

## New Files

| Purpose | File |
|---------|------|
| Create/list invites | `../Peerloop/src/pages/api/session-invites/index.ts` |
| Accept invite | `../Peerloop/src/pages/api/session-invites/[id]/accept.ts` |
| Decline invite | `../Peerloop/src/pages/api/session-invites/[id]/decline.ts` |
| Integration tests | `../Peerloop/tests/integration/session-invite.test.ts` |

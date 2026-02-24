# CURRENT-BLOCK-PLAN.md — BBB Block

**Block:** BBB (Video Sessions — Post-Enrollment Flow)
**Created:** 2026-02-24 Session 276
**Status:** 🔄 IN PROGRESS

> Delete this file when the full BBB block is complete and update PLAN.md status.

### Session 278 Progress

| Sub-block | Done | Remaining |
|-----------|------|-----------|
| PREREQUISITES | 5/5 | — |
| BBB.ROUTING | 5/5 | — |
| BBB.RECORDINGS | 4/4 | — |
| BBB.ATTENDANCE | 4/4 | — |
| BBB.RESCHEDULING | 4/4 | — |
| BBB.TESTING | 3/5 | Integration test, manual testing checklist |

**Session 278 new files:**
- `../Peerloop/src/pages/api/courses/[id]/sessions.ts` — Course past sessions endpoint (enrolled only)
- `../Peerloop/src/pages/api/sessions/[id]/attendance.ts` — Session attendance endpoint
- `../Peerloop/src/emails/SessionCancelledEmail.tsx` — Cancellation email template
- `../Peerloop/src/emails/SessionRescheduledEmail.tsx` — Reschedule email template

**Session 278 changes:**
- `CourseTabs.tsx` — Added "Book Your First Session" CTA (enrolled + teachers available), added past sessions section in Resources tab with recording links
- `SessionHistory.tsx` — Added attendance display in expanded session details (fetches on expand)
- `st-sessions.ts` — Added no-show auto-detection (marks stale scheduled sessions as no_show)
- `sessions/[id]/index.ts` — Wired cancel + reschedule email notifications via Resend

**Session 277 new files:**
- `../Peerloop/tests/lib/video/bbb.test.ts` — BBB adapter unit tests (48 tests)
- `../Peerloop/tests/api/sessions/[id]/recording.test.ts` — Recording endpoint tests (10 tests)

**Full test suite:** 289 files, 5252 tests, all passing.

**Next session:** Integration test (enrollment → booking → join → complete → rating), manual testing checklist with Blindside BBB.

---

## PREREQUISITES

- [x] Update `docs/tech/tech-001-bigbluebutton.md` with Blindside Networks info (managed hosting, API URL, contact, gotchas) — Session 276
- [x] Fix `!` encoding bug in `buildQueryString` (`../Peerloop/src/lib/video/bbb.ts` line ~127) — Session 276
- [x] Fix URL normalization in `buildApiUrl` (`../Peerloop/src/lib/video/bbb.ts` line ~257) — Session 276
- [x] Add `BBB_URL` and `BBB_SECRET` to `../Peerloop/.dev.vars` — Session 276 (placeholder secret)
- [x] Verify `wrangler.toml` has BBB env var bindings for preview/production — Session 276 (BBB_URL in all [vars])

---

## BBB.ROUTING (Critical Blocker)

*Session page and post-enrollment entry points*

- [x] Create `/session/[id].astro` page — Session 276. Also updated SessionRoom to use `window.open()` for Blindside BBB, added `in_session` state with polling
- [x] Add "Book Your First Session" CTA to enrollment confirmation / course detail page — Session 278. CTA in About tab when enrolled with teachers available, links to /course/:slug/book
- [x] Add "Upcoming Sessions" section to student dashboard (`/learning`) — Session 276. Fetches from `/api/sessions?upcoming=true&role=student`, shows join/view buttons with time-aware styling
- [x] Add "My Sessions" section to S-T dashboard (`/teaching/sessions`) — Already exists: `SessionHistory` component at `/teaching/sessions` fetches from `/api/me/st-sessions`
- [x] Ensure `/course/[slug]/book` connects to SessionBooking with correct S-T — Already exists: `book.astro` renders `SessionBooking` with pre-selected S-T support, navigates to `/session/:id` on success

### Key Files

| File | Role |
|------|------|
| `../Peerloop/src/pages/session/[id].astro` | **NEW** — Session room page |
| `../Peerloop/src/pages/course/[slug]/index.astro` | Pattern reference |
| `../Peerloop/src/pages/learning.astro` | Student dashboard (add sessions section) |
| `../Peerloop/src/pages/teaching/sessions.astro` | S-T sessions page |
| `../Peerloop/src/components/booking/SessionRoom.tsx` | Session room UI (5 states) |
| `../Peerloop/src/components/booking/SessionBooking.tsx` | Booking wizard |
| `../Peerloop/src/components/dashboard/StudentDashboard.tsx` | Student dashboard component |

---

## BBB.RECORDINGS

*Session recording access after completion*

- [x] Wire BBB `recording_ready` webhook to store recording URL in `sessions.recording_url` — Already implemented in `webhooks/bbb.ts` `handleRecordingReady()`
- [x] Create `GET /api/sessions/[id]/recording` endpoint with enrollment auth check — Session 276
- [x] Add recording playback link to completed session view — Already implemented: `SessionCompletedView` renders recording link when `recordingUrl` is set
- [x] Add "Past Sessions" with recordings to course resources tab — Session 278. New `/api/courses/:id/sessions` endpoint + past sessions section in Resources tab with Watch/No recording links

### Key Files

| File | Role |
|------|------|
| `../Peerloop/src/pages/api/webhooks/bbb.ts` | Webhook handler (already has recording_ready case) |
| `../Peerloop/src/pages/api/sessions/[id]/recording.ts` | **NEW** — Recording endpoint |
| `../Peerloop/src/components/booking/SessionCompletedView.tsx` | Already has `recordingUrl` prop |

---

## BBB.ATTENDANCE

*Track participation from BBB webhooks*

- [x] Wire `participant_joined`/`participant_left` webhooks to `session_attendance` table — Already implemented: `handleParticipantJoined()` creates record, `handleParticipantLeft()` sets `left_at` and `duration_seconds`
- [x] Calculate `duration_seconds` from join/leave times — Already implemented: BBB webhook provides `duration` in `participant_left` event, stored directly
- [x] Display attendance data in S-T session history — Session 278. Attendance section in expanded SessionRow, fetches from `/api/sessions/:id/attendance` on expand
- [x] Flag no-shows (scheduled but never joined) — Session 278. Auto-detection in st-sessions API: marks scheduled sessions past end time with no attendance as `no_show`

### Key Files

| File | Role |
|------|------|
| `../Peerloop/src/pages/api/webhooks/bbb.ts` | Webhook handler (already has participant cases) |
| `../Peerloop/migrations/0001_schema.sql` | `session_attendance` table (lines ~692-699) |

---

## BBB.RESCHEDULING

*Handle session changes after booking*

- [x] `PATCH /api/sessions/[id]` — Session 276. Reschedule with conflict detection for both teacher and student
- [x] Cancellation email notifications — Session 278. Created SessionCancelledEmail + SessionRescheduledEmail templates, wired into PATCH/DELETE via Resend with `session_booked` preference
- [x] "Reschedule" button on upcoming session view — Session 277. Added to SessionJoinableView and early screen in SessionRoom. Navigates to `/course/:slug/book?reschedule=:id`
- [x] Conflict detection for new time slot — Included in PATCH endpoint (checks teacher + student conflicts excluding current session)

### Key Files

| File | Role |
|------|------|
| `../Peerloop/src/pages/api/sessions/[id]/index.ts` | Add PATCH handler here |
| `../Peerloop/src/components/booking/SessionJoinableView.tsx` | Add reschedule button |

---

## BBB.TESTING

*Verify session flow end-to-end*

- [x] Unit tests for BBB adapter (`!` encoding, URL normalization, checksum, room create/join) — Session 277. `tests/lib/video/bbb.test.ts` (48 tests)
- [x] API tests for session CRUD (create, join, cancel, reschedule, recording) — Session 277. Added 17 PATCH reschedule tests to `[id]/index.test.ts`, created `[id]/recording.test.ts` (10 tests). Also fixed SessionRoom component test for `window.open()` change.
- [ ] Integration test: enrollment → booking → join → complete → rating
- [x] Webhook handler tests (recording_ready, participant events) — Already exist: `tests/api/webhooks/bbb.test.ts` (11 tests covering all event types)
- [ ] Manual testing checklist with real Blindside BBB server

---

## Blindside Networks Details

| Field | Value |
|-------|-------|
| Provider | Blindside Networks (managed BBB SaaS) |
| API URL | `https://peerloop.api.rna1.blindsidenetworks.com/bigbluebutton/api/` |
| Secret | 88 chars, in `.dev.vars` only |
| Contact | Binoy Wilson (`binoy.wilson@blindsidenetworks.com`, 613-695-0264) |
| No iframe | Must open BBB in new tab via `window.open()` |
| Duplicate meetings | `create` on existing meeting returns `duplicateWarning` — treat as success |
| Multi-tenant redirects | Join URL redirects to different host (normal) |

---

## Verification Checklist

After each sub-block:
- `cd ../Peerloop && npx tsc --noEmit` — no type errors
- `cd ../Peerloop && npm run dev` — starts cleanly
- Route check: `/session/test-id` → 404 page (not routing error)
- After TESTING sub-block: `cd ../Peerloop && npm test` — all pass

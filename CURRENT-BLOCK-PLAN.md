# CURRENT-BLOCK-PLAN.md — BBB Block

**Block:** BBB (Video Sessions — Post-Enrollment Flow)
**Created:** 2026-02-24 Session 276
**Status:** 🔄 IN PROGRESS

> Delete this file when the full BBB block is complete and update PLAN.md status.

### Session 276 Progress

**Completed:** All PREREQUISITES, most of ROUTING/RECORDINGS/ATTENDANCE/RESCHEDULING
**Remaining:** 7 unchecked items across sub-blocks + all of TESTING

| Sub-block | Done | Remaining |
|-----------|------|-----------|
| PREREQUISITES | 5/5 | — |
| BBB.ROUTING | 4/5 | "Book First Session" CTA |
| BBB.RECORDINGS | 3/4 | Past Sessions in course resources tab |
| BBB.ATTENDANCE | 2/4 | ST history display, no-show flagging |
| BBB.RESCHEDULING | 2/4 | Email notifications, reschedule button UI |
| BBB.TESTING | 0/5 | All (webhook tests already exist but adapter unit tests needed) |

**Key new files created:**
- `../Peerloop/src/pages/session/[id].astro` — Session room page
- `../Peerloop/src/pages/api/sessions/[id]/recording.ts` — Recording endpoint

**Key changes:**
- `bbb.ts` — Fixed `!` encoding and `/api/api/` URL normalization bugs
- `SessionRoom.tsx` — Changed to `window.open()` for Blindside BBB, added `in_session` state with 15s polling
- `StudentDashboard.tsx` — Added "Upcoming Sessions" section
- `[id]/index.ts` — Added `PATCH` reschedule endpoint with conflict detection
- `wrangler.toml` — Added `BBB_URL` to all env vars sections
- `.dev.vars` — Added `BBB_URL` and `BBB_SECRET` (placeholder)
- `tech-001-bigbluebutton.md` — Added Blindside Networks section and integration gotchas

**Next session:** Pick up BBB.TESTING (adapter unit tests first), then remaining UI items.

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
- [ ] Add "Book Your First Session" CTA to enrollment confirmation / course detail page
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
- [ ] Add "Past Sessions" with recordings to course resources tab

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
- [ ] Display attendance data in S-T session history
- [ ] Flag no-shows (scheduled but never joined)

### Key Files

| File | Role |
|------|------|
| `../Peerloop/src/pages/api/webhooks/bbb.ts` | Webhook handler (already has participant cases) |
| `../Peerloop/migrations/0001_schema.sql` | `session_attendance` table (lines ~692-699) |

---

## BBB.RESCHEDULING

*Handle session changes after booking*

- [x] `PATCH /api/sessions/[id]` — Session 276. Reschedule with conflict detection for both teacher and student
- [ ] Cancellation email notifications (TODO in current code)
- [ ] "Reschedule" button on upcoming session view
- [x] Conflict detection for new time slot — Included in PATCH endpoint (checks teacher + student conflicts excluding current session)

### Key Files

| File | Role |
|------|------|
| `../Peerloop/src/pages/api/sessions/[id]/index.ts` | Add PATCH handler here |
| `../Peerloop/src/components/booking/SessionJoinableView.tsx` | Add reschedule button |

---

## BBB.TESTING

*Verify session flow end-to-end*

- [ ] Unit tests for BBB adapter (`!` encoding, URL normalization, checksum, room create/join) — **START HERE next session**
- [ ] API tests for session CRUD (create, join, cancel, reschedule) — session list/create tests, join tests, recording endpoint, PATCH reschedule
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

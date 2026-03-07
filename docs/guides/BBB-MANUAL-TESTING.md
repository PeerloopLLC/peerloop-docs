# BBB Manual Testing Checklist

Manual testing steps for the BigBlueButton session flow against the real Blindside Networks server.

**Prerequisites:**
- `BBB_URL` and `BBB_SECRET` set in `../Peerloop/.dev.vars`
- Dev server running: `cd ../Peerloop && npm run dev`
- At least one course with an active Teacher in the dev database
- Two browser profiles (or one regular + one incognito) for student/teacher

---

## Environment Verification

- [ ] `BBB_URL` resolves: open `https://peerloop.api.rna1.blindsidenetworks.com/bigbluebutton/api/` in browser — should return XML (no auth needed for base URL)
- [ ] Dev server starts without BBB errors in console
- [ ] `.dev.vars` has both `BBB_URL` and `BBB_SECRET` (88-char secret)

---

## 1. Session Booking

| # | Step | Expected | Pass |
|---|------|----------|------|
| 1.1 | Log in as student | Dashboard loads | [ ] |
| 1.2 | Navigate to an enrolled course | Course detail page loads with "Book Your First Session" CTA (About tab) | [ ] |
| 1.3 | Click CTA or navigate to `/course/:slug/book` | SessionBooking wizard loads with teacher(s) listed | [ ] |
| 1.4 | Select teacher, pick a future time slot, confirm | 201 response, redirects to `/session/:id` | [ ] |
| 1.5 | Check student dashboard (`/learning`) | "Upcoming Sessions" section shows the new session | [ ] |

---

## 2. Session Join (Teacher)

| # | Step | Expected | Pass |
|---|------|----------|------|
| 2.1 | Log in as teacher in second browser | Teacher dashboard loads | [ ] |
| 2.2 | Navigate to `/session/:id` (from step 1.4) | SessionRoom shows "Waiting" or "Joinable" state | [ ] |
| 2.3 | Click "Join Session" button | `window.open()` opens BBB in new tab | [ ] |
| 2.4 | BBB room loads | Teacher sees BBB interface with moderator controls | [ ] |
| 2.5 | Check DB: `sessions` row | `status = 'in_progress'`, `bbb_meeting_id` set, `started_at` populated | [ ] |

**BBB-specific checks:**
- [ ] Multi-tenant redirect is normal (URL changes from `peerloop.api.rna1...` to `mydaNNNNNN.rna1...`)
- [ ] Teacher has moderator controls (mute all, recording, etc.)
- [ ] Welcome message shows course title

---

## 3. Session Join (Student)

| # | Step | Expected | Pass |
|---|------|----------|------|
| 3.1 | Student clicks "Join Session" on `/session/:id` | `window.open()` opens BBB in new tab | [ ] |
| 3.2 | BBB room loads | Student sees BBB interface as attendee | [ ] |
| 3.3 | Audio/video connection | Both parties can hear/see each other | [ ] |

**BBB-specific checks:**
- [ ] Student does NOT have moderator controls
- [ ] Session Room page shows "In Session" state with polling

---

## 4. Session Completion

| # | Step | Expected | Pass |
|---|------|----------|------|
| 4.1 | Teacher ends meeting in BBB (click End Meeting) | BBB tab closes or shows "meeting ended" | [ ] |
| 4.2 | Check webhook delivery | Server logs show `meeting_ended` event received | [ ] |
| 4.3 | Check DB: session status | `status = 'completed'`, `ended_at` set | [ ] |
| 4.4 | Session Room page | Shows "Session Completed" view with rating form | [ ] |

---

## 5. Attendance Tracking

| # | Step | Expected | Pass |
|---|------|----------|------|
| 5.1 | Check webhook logs | `participant_joined` and `participant_left` events received | [ ] |
| 5.2 | Check DB: `session_attendance` | Records for both teacher and student with `joined_at`, `left_at`, `duration_seconds` | [ ] |
| 5.3 | Teacher views session in teaching history (`/teaching/sessions`) | Expand session → attendance section shows both participants | [ ] |

---

## 6. Recording

| # | Step | Expected | Pass |
|---|------|----------|------|
| 6.1 | Wait for recording processing (may take 5-30 min) | `recording_ready` webhook fires | [ ] |
| 6.2 | Check DB: `sessions.recording_url` | URL populated (e.g., `https://...blindsidenetworks.com/playback/...`) | [ ] |
| 6.3 | Student views completed session | "View Recording" link appears | [ ] |
| 6.4 | Click recording link | BBB playback page loads | [ ] |
| 6.5 | Course Resources tab | "Past Sessions" section shows the session with Watch link | [ ] |

---

## 7. Session Rating

| # | Step | Expected | Pass |
|---|------|----------|------|
| 7.1 | Student rates teacher (1-5 stars + comment) | 200 response, rating saved | [ ] |
| 7.2 | Teacher rates student (1-5 stars + comment) | 200 response, rating saved | [ ] |
| 7.3 | Check DB: `session_assessments` | 2 records with correct assessor/assessee | [ ] |
| 7.4 | Check DB: `user_stats` | Teacher's `average_rating` and `total_reviews` updated | [ ] |
| 7.5 | Attempt duplicate rating | 409 Conflict response | [ ] |

---

## 8. Cancellation & Rescheduling

| # | Step | Expected | Pass |
|---|------|----------|------|
| 8.1 | Book a new session | 201, session created | [ ] |
| 8.2 | Student clicks "Reschedule" on session page | Navigates to booking wizard with `?reschedule=:id` | [ ] |
| 8.3 | Pick new time, confirm | PATCH 200, times updated | [ ] |
| 8.4 | Check email (if Resend configured) | Both parties receive reschedule notification | [ ] |
| 8.5 | Student cancels the session | DELETE 200, status → cancelled | [ ] |
| 8.6 | Check email (if Resend configured) | Both parties receive cancellation notification | [ ] |

---

## 9. Edge Cases

| # | Step | Expected | Pass |
|---|------|----------|------|
| 9.1 | Try to join before join window (>15 min early) | 400 "Session not yet joinable" with `joinable_at` | [ ] |
| 9.2 | Try to join after session end time | 400 "Session time has passed" | [ ] |
| 9.3 | Non-participant tries to join | 403 "Not authorized" | [ ] |
| 9.4 | Rate a non-completed session | 400 "Can only rate completed sessions" | [ ] |
| 9.5 | Book overlapping time with existing session | 409 conflict | [ ] |
| 9.6 | `create` on existing BBB meeting | `duplicateWarning` returned — treated as success (join URL still works) | [ ] |

---

## Webhook Configuration

For webhooks to work in local dev, BBB needs to reach your machine. Options:

1. **Cloudflare Tunnel** (recommended): `cloudflared tunnel --url http://localhost:4321`
2. **ngrok**: `ngrok http 4321`
3. **Skip webhooks**: Test everything except recording_ready and attendance — verify those via Cloudflare staging deployment

The webhook URL is set per-room in the join endpoint: `{origin}/api/webhooks/bbb`

---

## Blindside Networks Notes

- **No iframe embedding** — BBB must open in a new tab (`window.open()`)
- **Multi-tenant redirects** — Join URL redirects to a different hostname (e.g., `myda412331.rna1.blindsidenetworks.com`) — this is normal
- **Duplicate meeting create** — Calling `create` on an existing meeting returns `duplicateWarning` (not an error)
- **Recording processing** — Takes 5-30 minutes after meeting ends
- **Contact**: Binoy Wilson (`binoy.wilson@blindsidenetworks.com`, 613-695-0264)

# Timezone — Manual Verification Checklist (pre-GO-LIVE)

**Why this is (still partly) manual.** Timezone display bugs pass every automated test that
runs in a single zone. Two automated layers now guard against that: unit tests pin the
library + server date-math (`tests/unit/timezone.test.ts`, `period-dates.test.ts`,
`expiry-helpers.test.ts`, `is-valid-timezone.test.ts`, the `cleanup` UTC-day-boundary test,
and `session-reminders.test.ts`), and **a jsdom component-render suite asserts each display
island renders session times in the viewer's zone** (the `[TZ-BROWSER-AUTO]` render tests,
flip-verified under the `Pacific/Kiritimati` CI leg — Conv 377; see the automated-coverage
list below). What remains **browser-only, and therefore manual**, is the **SSR `.astro` path**
(server-rendered times reading `Astro.locals.userTimezone`, e.g. `MySessionsTab.astro`) and
**hydration flicker** — jsdom cannot run Astro SSR. Run this checklist by hand (or via the
`/chrome` PLATO browser bridge) before launch to cover that residual.

The per-user timezone model ([TZ-MODEL], Convs 371–375): each user's IANA zone is stored
in `users.timezone` (browser-detected at signup, editable in Settings). A `null` zone
falls back to UTC with an explicit `" UTC"` label. Every session time/date is rendered in
the **viewer's** zone (in-app) or the **recipient's** zone (emails).

## Setup — two accounts in DIFFERENT zones (the whole point)

The single most important condition: the two users in a session must be in zones on
**opposite sides of UTC** so a bug is visible. The genesis PLATO persona already does this
(creator **Mara Chen → America/Los_Angeles**, student **Alex Rivera → Asia/Tokyo**), or set
it manually:

1. Log in as user A → **Settings → Profile → Timezone** → set `America/Los_Angeles` (UTC−7/−8).
2. Log in as user B (second browser / incognito) → set `Asia/Tokyo` (UTC+9).
3. Have a booked session between them (e.g. run the genesis flywheel, or book one).

Pick a session whose start instant lands on a **different calendar day** in the two zones
(easy at ~UTC midnight ± a few hours) — that exposes both the time-of-day and the
day-boundary bug at once.

## Checklist

For the SAME booked session instant, confirm each surface renders correctly per viewer:

- [ ] **Session detail** (`/session/{id}`) — user A sees the PT time; user B sees the JST
      time; both refer to the same instant. If the instant is near UTC midnight, the two
      may show **different calendar days** — both correct.
- [ ] **Sessions list** — student (`StudentSessionsList`) and teacher (`TeacherSessionsList`)
      each show the session in their own zone.
- [ ] **Dashboard "upcoming sessions"** (`TeacherUpcomingSessions`, `StudentDashboard`) — same.
- [ ] **SSR sessions tab** (`MySessionsTab.astro`, reads `Astro.locals.userTimezone`) — the
      server-rendered path; confirm no hydration flicker between server and client time.
- [ ] **Booking flow** (`SessionBooking`) — available slots render in the booker's zone;
      the slot you pick is the slot that gets booked (verify the stored/confirmed time).
- [ ] **Calendar / availability** — teacher availability renders in the viewer's zone.
- [ ] **Reminder emails** (24h + 1h, [SESSION-REMIND]) — each recipient's email shows the
      session in **their** zone with an explicit zone label (e.g. "9:00 AM JST"). Check the
      booking/cancel/reschedule emails too (`formatRecipientSession`).
- [ ] **Notification center** — the in-app `session_reminder` / `session_booked`
      notifications match the viewer's zone.
- [ ] **Admin session views** (`SessionsAdmin`, `SessionDetailContent`) — render in the
      admin's zone.

## Fallback + edge cases

- [ ] **Null-tz user** — a user who never set a zone (or a fresh account before capture)
      sees times labelled `" UTC"` (never an unlabelled wrong local time). Verify one
      surface with such an account.
- [ ] **Change-of-zone** — change a user's zone in Settings, reload; displayed session
      times shift accordingly.
- [ ] **DST** — if testing near a US DST transition (Mar 8 / Nov 1, 2026), confirm a session
      booked across the boundary still shows the correct wall-clock time to each party.

## What automated coverage already exists (so you don't re-verify it by hand)

- Library conversion/formatting incl. DST + UTC-day boundaries: `tests/unit/timezone.test.ts`.
- Earnings period boundaries (money): `tests/unit/period-dates.test.ts`.
- Moderation expiry offsets across DST: `tests/unit/expiry-helpers.test.ts`.
- Timezone validation gate: `tests/unit/is-valid-timezone.test.ts`.
- Signup→register capture: `tests/api/auth/register.test.ts` (Timezone Capture).
- No-show notification date is UTC-stable across a day boundary: `tests/api/admin/sessions/cleanup.test.ts`.
- Reminder email per-recipient zone (NY vs Tokyo): `tests/lib/session-reminders.test.ts`.
- **Component-level viewer-tz display** (session times render in the viewer's zone; `" UTC"` on a
  null zone): the `[TZ-BROWSER-AUTO]` jsdom render suite across 7 islands — `SessionRoom` (Conv 376)
  plus the 6 added Conv 377: `TeacherUpcomingSessions`, admin `SessionDetailContent` (attendance
  times), `StudentSessionsList`, `StudentDashboard` (upcoming), `TeacherSessionsList`, and
  `SessionBooking` (confirm step). Each asserts the viewer-zone wall-clock + the `" UTC"` fallback and
  is flip-verified under the `Pacific/Kiritimati` CI leg. Does NOT cover the SSR/hydration residual above.
- Server date-math regression (getUTC*/setUTC*) is caught statically by `npm run lint:tz`.

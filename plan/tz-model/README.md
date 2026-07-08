# TZ-MODEL — Per-user timezone model rollout

**Focus:** Adopt a coherent per-user timezone model so session times/dates render consistently in each viewer's own zone (app AND email). Resolves the recurring "TZ handling feels wrong" class ([TZ-AUDIT], Conv 371).
**Status:** 🔧 IN PROGRESS — audit + Bucket 1 (Conv 371); Phase 0 DONE (Conv 372); **Phase 1 Foundation + Student slice DONE (Conv 372)**; Phase 1 Teacher/Booking/Admin/Messages slices next.
**Model decision (Conv 371):** **Option A — store `users.timezone` (IANA)** and render everything in the viewer's stored tz. Chosen over B (browser-local, no email localization) and C (UTC-everywhere labelled) because a scheduling product must show each user *their* local time, including in the booking-confirmation email; pre-launch is the cheapest time to add the column.

**Root cause (the META-finding):** `users` has **no `timezone` column**, so three surfaces render in three zones that disagree across a UTC-day boundary — session **times** = browser-local, session **dates** = teacher-local/UTC (`formatDateUTC`), **emails** = UTC. The code already flags this: `TeacherUpcomingSessions.tsx:23-26` carries a `⚠️ TZ-AUDIT (#10)` marker deferring exactly this global decision. Prior sweeps patched individual `toLocale` sites without fixing the model — hence the recurrence.

**Contract (`docs/decisions/02-database.md` DATE-FORMAT):** storage = UTC ISO-8601 `Z`; display via `src/lib/timezone.ts` helpers (`formatDateUTC`, `formatDateTimeUTC`, `formatLocalTime(iso, tz)`); `getNow()` (`src/lib/clock.ts`) for time-sensitive decisions. Good existing patterns: explicit `{timeZone:'UTC'}` (SessionRoom.tsx:326, TeacherProfile.tsx:76), the `data-session-time` client-upgrade (CourseHeader.tsx:212-220), ISO string-slicing (profile astro:165).

---

## Bucket 1 — model-independent bugs (DONE, Conv 371)

- **B1 · P0 · `localToUTC` DST bug** — FIXED. `src/lib/timezone.ts` sampled the tz offset at the wrong instant → stored `scheduled_start` ±1h off within the offset-window of any DST transition (empirically reproduced NY/Sydney, both directions). Fixed via fixpoint refinement (`tzOffsetMsAt` + re-apply). +5 regression tests in `tests/unit/timezone.test.ts`.
- **B2 · P1 → latent · overnight slot-gen** — RECLASSIFIED, no code change. `teachers/[id]/availability.ts` inline `generateSlots` drops midnight-spanning windows, but overnight windows are **unreachable** (both `me/availability.ts:210` and `AvailabilityCalendar.tsx:216` reject `end ≤ start`). Left as-is deliberately (switching to `windowToUtc` would only affect the unreachable case and risk offer-then-reject vs `isSlotWithinAvailability`).
- **B3 · P1 · booking email UTC label** — FIXED. `sessions/index.ts` both `SessionBookingEmail` call sites now pass `sessionTime: \`${sessionTime} UTC\``, matching the in-app notification + cancel/reschedule emails. (Phase 2 replaces the UTC label with recipient-local.)

All 5 gates green Conv 371: full suite 6766✓, build✓, astro 0/0/0, tsc/lint clean.

---

## Phases

### Phase 0 · Foundation (schema + capture + backfill) — ✅ DONE (Conv 372)

**Two novel sub-decisions resolved (user-approved, Conv 372):**
- **NULL semantics / backfill:** column is **nullable**, `NULL` = "unknown" → display/email fall back to **UTC (labelled)**; browser tz **captured opportunistically on next login** (progressive fill). Chosen over a `NOT NULL DEFAULT` (which is indistinguishable from a genuine user choice and blocks a later "fill the unknowns" pass). Note: prod is undeployed → "existing users" = seed/test only, so this mainly governs the fallback the Phase-1/2 code uses.
- **Capture UX / picker:** signup stores the **raw detected IANA** zone (accurate worldwide); Settings **reuses the 12-entry `COMMON_TIMEZONES`** dropdown but **injects any out-of-list detected zone** as its own option so an exotic zone is never silently clobbered.

**Shipped:**
- `users.timezone TEXT` (nullable) added to `migrations/0001_schema.sql`.
- `isValidTimezone()` IANA validator added to `src/lib/timezone.ts` (ICU-backed, reused by signup + Settings).
- **Signup capture:** `SignupForm.tsx` detects `Intl…timeZone` → `POST /api/auth/register` validates + stores (invalid/absent → NULL).
- **Settings edit:** `timezone` threaded through `me/profile.ts` (whitelist + GET + PATCH validation, `nav_layout` precedent); `ProfileSettings.tsx` renders a `TimezoneSelect` in Contact & Location.
- **Exposed on `/api/me/full`** → `UserIdentity` + `CurrentUser` singleton (`current-user.ts`) carry `timezone`.
- **Login-capture:** `captureTimezoneIfMissing()` in `current-user.ts` backfills NULL-tz accounts (incl. OAuth signups) after a successful `/api/me/full` load — fire-and-forget, once per session.
- **Seed:** post-INSERT `UPDATE` in both `migrations/0002_seed_core.sql` (admin → ET) and `migrations-dev/0001_seed_dev.sql` (all → ET, **Guy Rymberg → `Asia/Jerusalem`** as a deliberate non-ET cross-boundary test fixture).
- **Gates (Conv 372):** tsc clean · lint 0 · astro 0/0/0 · full suite **6766✓** (1 SignupForm assertion updated for the new body field) · build clean · local D1 re-seed verified (tz values landed).

**Not done deliberately:** the actual display/email localization — that's Phase 1/2. Until then, NULL-tz users still see the pre-existing (internally-consistent-per-surface) behavior; the model is now *capturable*, not yet *threaded*.

### Phase 1 · Display threading (Bucket 2 — ~40 sites)
Replace raw `toLocale*` (no `timeZone`) with the viewer's stored tz; thread `userTz` into the client islands. **Site inventory (from the Conv-371 audit):**

**🔧 IN PROGRESS — Foundation + Student slice DONE (Conv 372).**

**Canonical pattern (established + DOM-verified Conv 372):**
- **Foundation (built once):** middleware `resolveUserContext` resolves `Astro.locals.userTimezone` from `users.timezone` (mirrors the `nav_layout` precedent, same query row); `App.Locals.userTimezone` type (`env.d.ts`); shared helpers `formatSessionTime(iso, tz)` / `formatSessionDate(iso, tz)` in `src/lib/timezone.ts` (tz `null` → **UTC + " UTC" label** on times, unlabelled UTC on dates); `useUserTimezone()` hook in `current-user.ts` (composes the hydration-safe `useCurrentUser`, so SSR/first-render = UTC → upgrades to stored tz after mount). +8 helper unit tests.
- **Per site:** `.astro` SSR → `Astro.locals.userTimezone` (flash-free, Model-A stored tz); `.tsx` islands → `useUserTimezone()`. Both call the shared helpers. **Rejected** the `data-session-time` browser-local upgrade for SSR — it's Model B and would disagree with Phase-2 emails.
- **Verified end-to-end (Conv 372, DOM + raw SSR HTML):** set a seed user's stored tz to `Asia/Tokyo` (via the Phase-0 PATCH) while the browser was `America/Toronto`; `10:00Z` session rendered **7:00 PM** on `MySessionsTab` (SSR HTML), `StudentSessionsList` (island `7:00 PM – 8:30 PM`), and `StudentDashboard` (`7:00 PM`) — i.e. stored tz, not browser-local (6 AM) or UTC (10 AM).

**Student slice — DONE (Conv 372):** `MySessionsTab.astro` (SSR) · `StudentSessionsList.tsx` · `StudentDashboard.tsx` · `MyCourses.tsx` (EnrollmentRow) · `ModuleAccordion.tsx` (session + completion stamp) · `SessionsTabContent.tsx` (5 buckets, discover-preview via `ExploreCourseTabs`→`CourseTabs`). All formats preserved; 5 gates green (6773✓).

**Remaining slices (later convs):** Teacher (`TeacherUpcomingSessions`, `TeacherSessionsList`, `TeacherSessionsTabContent`, `ExploreTeachingTab`, …) · Booking (`SessionBooking` mixed-zone pairs + calendar day-cell) · **Admin/mod** (`SessionsAdmin`, `SessionDetailContent`, `AllSessionsTabContent` [creator/admin/mod tabs], `ModerationAdmin`, `RecordingsAdmin`, …) · Messages (`messages/types.ts` day-bucketing) · misc date-only stamps. The `getNow()` client-determinism items (7×P1) stay a **separate** gated question (not tz-display).

**Session TIME-OF-DAY (raw `toLocaleTimeString`, no tz — hydration mismatch + wrong meeting time):**
MySessionsTab.astro:55 · StudentSessionsList.tsx:42 · TeacherSessionsList.tsx:103,115 · TeacherUpcomingSessions.tsx:38 · StudentDashboard.tsx:143 · MyCourses.tsx:461 · ModuleAccordion.tsx:109 · SessionsTabContent.tsx:145,208 · AllSessionsTabContent.tsx:194 · TeacherSessionsTabContent.tsx:206 · discover/detail-tabs/TeacherTabContent.tsx:246

**Session/stamp DATE-ONLY (raw `toLocaleDateString`, ±1-day):**
MySessionsTab.astro:53 · TeacherUpcomingSessions.tsx:29 · TeacherSessionsList.tsx:95 · StudentDashboard.tsx:142 · MyCourses.tsx:460 · ModuleAccordion.tsx:105,108 · SessionsTabContent.tsx:144,207,263,312,347 · AllSessionsTabContent.tsx:191 · TeacherSessionsTabContent.tsx:203 · ExploreTeachingTab.tsx:179,187 · TeacherTabContent.tsx:303 · CourseTeacherList.tsx:55 · CourseTeachingCard.tsx:20,67 · TeachersTabContent.tsx:115 · EarningsDetail.tsx:94

**Admin/mod surfaces (internal, ±1-day / wrong-time):**
SessionsAdmin.tsx:396,398 · SessionDetailContent.tsx:238,239 · ModerationAdmin.tsx:469 · RecordingsAdmin.tsx:118,148 · AnnouncementsAdmin.tsx:251,253 · AdminMemberSummary.tsx:88,112 · AdminCourseTab.tsx:104 · AdminCommunityTab.tsx:103 · discover/MemberCard.tsx:140 · members/MemberCard.tsx:129

**Messages:** messages/types.ts:66 (`formatMessageTime` no tz); types.ts:75,78,98 (`toDateString` day-bucketing per viewer-local — anchor to chosen tz)

**Booking UI mixed-zone pair (date UTC + time browser-local disagree):** SessionBooking.tsx:652,670,721,799 (times) vs :627,715,798 (dates); calendar day-cell off-by-one :594-597 vs :503

**Client join-window using raw `new Date()`/`Date.now()` instead of `getNow()` (7×P1) — decide if client time should be test-deterministic:**
TeacherSessionsList.tsx:165 · StudentSessionsList.tsx:81 · StudentDashboard.tsx:118 · SessionsTabContent.tsx:182 · TeacherSessionsTabContent.tsx:158 · MyCourses.tsx:358 · SessionRoom.tsx:86 (+ P2: SessionRoom.tsx:105,133,167 · TeacherUpcomingSessions.tsx:47 · PriorityHeader.tsx:26 · ModeratorsAdmin.tsx:348 · ModeratorDetailContent.tsx:81 · SessionBooking.tsx:111,128 · TeacherSessionsList.tsx:437). NB the real join gate is server-side (`api/sessions/[id]/join.ts`, uses getNow) — these are UI-determinism, not security. No client component imports getNow today.

### Phase 2 · Email senders
Render booking/cancel/reschedule (+ reminder if built) times in the **recipient's stored tz**; drop the interim "UTC" labels (incl. B3's). Templates already take pre-formatted strings — change the callers (`sessions/index.ts`, `sessions/[id]/index.ts`).

### Phase 3 · Cleanup & fragility
- Remove leftover UTC labels now localized.
- **Bucket 3 P2 (UTC-Worker-dependent, harden with `Date.UTC`/`getUTC*`):** earnings `getPeriodDates` — creator-earnings.ts:82,83,87,95 · teacher-earnings.ts:79,80,84,92; analytics bucketing — admin/analytics/{revenue:107,courses:120,engagement:112,teachers:119,users:120}.ts · me/creator-analytics/enrollments.ts:198 · me/teacher-analytics/earnings.ts:105; expiry — admin/moderation/[id]/suspend.ts:39,42,45 · moderators/invite.ts:49 · moderators/[id]/resend.ts:31; cleanup notification labels — `lib/cleanup.ts:59,85,108` (add `{timeZone:'UTC'}`).
- **STRUCTURAL GAP — dead session-reminder scaffolding:** `SessionReminderEmail.tsx` + `FeedbackReminderEmail.tsx` + `email_session_reminder` pref column + `'session_reminder'` notification type exist but have **no sender and no reminder cron** (only cron is `workers/cron` cleanup). DECIDE: build the reminder job (24h/1h before `scheduled_start`, window via `getNow()` + strftime ISO-Z) OR delete the dead pref/templates.

---

## Verified clean (Conv 371 — don't re-audit)
0 `datetime()` in SQL comparisons; all writes UTC-Z; every time-sensitive *server* decision uses `getNow()`; `localToUTC` correct off-DST-boundaries (now correct on them too).

**Audit method + full agent findings:** 6 read-only agents (display/getNow/local-field/availability-deep/write+SQL/cron+email), Conv 371. Working copy `.scratch/tz-audit-findings.md` (gitignored — this README is the durable record).

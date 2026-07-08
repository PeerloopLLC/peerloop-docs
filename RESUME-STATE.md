# State — Conv 373 (2026-07-08 ~12:52)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Drove **[TZ-MODEL]** through the rest of **Phase 1** (Booking → Admin/mod → Messages → misc-date-only-stamps display slices) and all of **Phase 2** (email + in-app notification senders → recipient-local times). **Phases 0, 1, and 2 are now complete** — every in-app session time/datetime renders in the viewer's stored tz, pure calendar-date stamps are UTC-stable, and session emails/notifications render in each recipient's own zone. Committed as 5 per-slice/phase code checkpoints (`1e748981` · `784dc909` · `014a4099` · `18d93181` · `13a7fb72`) + matching docs commits. **Only Phase 3 (cleanup) remains** to close the whole block.

## Key Context

- **Backlog:** see `CURRENT-TASKS.md`. **[TZ-MODEL]** is 🔥 Ordered — **Phase 3 is next and the LAST phase**: (a) leftover interim "UTC" label sweep; (b) **Bucket-3 hardening** — make UTC-Worker-dependent date math explicit (`Date.UTC`/`getUTC*`) in earnings `getPeriodDates` (creator/teacher-earnings), analytics bucketing (admin/analytics/*, creator/teacher-analytics), expiry (moderation suspend/invite/resend), `lib/cleanup.ts` labels; (c) **DECIDE the dead session-reminder scaffolding** — `SessionReminderEmail.tsx`/`FeedbackReminderEmail.tsx` + `email_session_reminder` pref + `'session_reminder'` type exist with NO sender/cron: build the 24h/1h reminder job OR delete the dead pieces. Full inventory: `plan/tz-model/README.md § Phase 3`.
- **TZ-MODEL toolkit (all in `src/lib/timezone.ts`):** `formatSessionTime` / `formatSessionDate` (viewer-tz, null→UTC-labelled time / unlabelled date) · `formatSessionDateTime` (viewer-tz combined datetime, admin surfaces) · `dateKeyInTz(utcIso, tz)` (viewer-tz `YYYY-MM-DD` grouping key — `formatToParts`, locale-independent) · `formatRecipientSession(iso, tz)` (email/notification recipient-tz + explicit short zone label via `timeZoneName:'short'`). Client islands use `useUserTimezone()`; SSR `.astro` uses `Astro.locals.userTimezone`.
- **Policy (decided this conv):** session **times/datetimes** → viewer-tz (bare local in-app, explicit zone label in email); pure **calendar-date stamps** (cert/review/member-since/last-active/flag/earnings) → **UTC-stable `formatDateUTC`** (localizing a midnight-stored date introduces a ±1-day off-by-one for behind-UTC viewers). For a UTC-stable date with a custom format, `formatSessionDate(iso, null, opts)`.
- **Unpushed → pushed:** this r-end pushes all Conv-373 commits (7 checkpoints + the r-end bookkeeping commit) to `origin/jfg-dev-14`.
- `getNow()` client-determinism (7×P1) stays a **separate** gated question — not tz-display, out of TZ-MODEL Phase scope.

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context.

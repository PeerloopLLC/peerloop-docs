# State — Conv 387 (2026-07-11 ~17:30)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Shipped two standalone features. **[HW-SUBMIT-UI]:** re-homed the orphaned student homework-submission UI as an enrolled-only "Homework" course tab (`/course/[slug]/homework`) and restyled `HomeworkTab` off the legacy palette onto Matt tokens. **[CAF]:** added a `/courses` "Available soon" filter (exact-lazy — a new `POST /api/courses/availability-batch` computes per-course teacher availability on demand) plus an admin-configurable window (reused `platform_stats.availability_window_days`, default 30→14) with a new `/admin/availability-settings` page. Both live-verified in the browser; all 5 gates green (suite 6876); committed + pushed mid-conv. Also trimmed the PLATO-SEQ CURRENT-TASKS entry to its one post-launch item.

## Key Context

- **Task backlog is in `CURRENT-TASKS.md`** — do not re-list here. All three of this conv's items ([HW-SUBMIT-UI], [PLATO-SEQ] trim, [CAF]) are in its Completed section.
- **[CAF] window is admin-configurable** via `/admin/availability-settings` (`GET/POST /api/admin/availability-config`). The single source of the default (14) is `src/lib/availability-config.ts`; the same key drives both the browse filter and the course-detail availability preview. **Existing-DB note:** the 30→14 seed change only affects fresh DBs — staging keeps 30 until an admin sets it via the new UI (no SQL needed).
- **[CAF] compute is exact-lazy** (user chose "won't mind waiting"): the batch endpoint runs `countAvailableSlots` per course only when the filter is toggled; no KV cache in v1 (add later if slow). It returns a boolean map so it composes with the client-side level/topic/search filters.
- **Availability gotchas** (for future availability work): the booking wizard hardcodes a 28-day / `weeks=4` lookahead and does NOT read `availability_window_days` (only the detail preview + browse filter do) — corrected in `availability-calendar.md` + `session-booking.md` this conv. **[AVAIL-BUFFER]** (buffer_minutes not persisted + availability-rule-tz vs `users.timezone` seam) is still open in the backlog and is the natural next availability task.
- **Baseline (this conv):** all 5 gates green — tsc 0 / astro-check 0 / lint / test **6876** / build ✓.

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context.

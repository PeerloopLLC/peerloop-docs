# State — Conv 372 (2026-07-08 ~10:30)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Executed **[TZ-MODEL] Phase 0** (per-user timezone foundation — `users.timezone` schema + signup/Settings capture + seed backfill + opportunistic login-capture) and **Phase 1 Foundation + Student + Teacher slices** (threaded the viewer's stored tz through 10 session-display surfaces). Established the canonical display-threading pattern, DOM-verified it end-to-end, and committed each slice as its own checkpoint. Phase 1 continues next conv (Booking → Admin/mod → Messages → misc stamps).

## Key Context

- **Backlog:** see `CURRENT-TASKS.md`. **[TZ-MODEL]** is 🔥 Ordered — **Phase 1 Booking slice next** (`SessionBooking` mixed-zone date/time pairs + calendar day-cell off-by-one — the trickiest remaining surface, worth its own focused pass), then **Admin/mod** → **Messages** → **misc date-only stamps** (cert/created/review dates incl. `TeacherTabContent:303`). Then **Phase 2** (email senders) + **Phase 3** (cleanup + dead session-reminder decision). Full remaining inventory + the pattern: `plan/tz-model/README.md`.
- **Canonical Phase-1 pattern (replicate for remaining slices):** SSR `.astro` → `Astro.locals.userTimezone` (resolved in middleware `resolveUserContext` alongside `nav_layout`, one query row); client islands → `useUserTimezone()` hook; both format via `formatSessionTime(iso, tz)` / `formatSessionDate(iso, tz)` in `src/lib/timezone.ts` (tz `null` → UTC-labelled on times, unlabelled UTC on dates). **The hook goes in the SUB-component that renders** (tsc catches scope slips). Rejected the `data-session-time` browser-local upgrade (Model B — would disagree with Phase-2 emails).
- **DOM-verify technique:** set a seed user's stored tz to an exotic zone (`Asia/Tokyo`) via `PATCH /api/me/profile`, `localStorage.removeItem('peerloop_user_cache')`, hard-nav, read DOM — pick a zone whose offset differs from BOTH the browser and UTC (the dev browser is `America/Toronto` = ET offset, so ET renders don't discriminate). Always restore the mutated seed value.
- **`getNow()` client-determinism** (7×P1) is a **separate** gated question (test-determinism, not tz-display) — deliberately out of Phase 1.
- **Branch:** code work on `jfg-dev-14`; all conv commits pushed at this r-end. Phase-0/1 code landed across commits `da83e7d9` · `2f662f1d` · `b1a17045`.

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context.

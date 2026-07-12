# State — Conv 388 (2026-07-12 ~10:13)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Built **[AVAIL-BUFFER]** end-to-end (persist + apply teacher availability `buffer_minutes`), then did a **full staging deploy** and **activated session reminders on staging** — including proving cron-driven reminder email delivery to a real inbox. All work committed + pushed; staging is live and verified.

## Key Context

- **Task backlog is in `CURRENT-TASKS.md`** — do not re-list here. All three items this conv ([AVAIL-BUFFER], [AVAIL-BUFFER-DEPLOY], [SESSION-REMIND-DEPLOY] staging) are in its Completed section; [SESSION-REMIND-DEPLOY] is re-parked for the **prod repeat only** (gated behind MVP-GOLIVE).
- **[AVAIL-BUFFER]:** `buffer_minutes` now persists (new `availability` column, `DEFAULT 15`, denormalized per-row like `timezone`) AND is applied as a symmetric gap in all 3 per-teacher conflict checks (`POST /api/sessions`, `teachers/[id]/availability.ts` slot-gen, `lib/availability.ts countAvailableSlots`). Single source of the default is the schema column. Baseline this conv: 5 gates green, suite **6883**.
- **Staging is on the CLIENT's Cloudflare account** (`brian-1dc`) — destructive staging ops (the reset+reseed done this conv) are outward-facing; always confirm the wipe. Current staging: app `170a0b1a`, cron `d95ddb91`, DB reset+reseeded to `feeds` level with current `0001`.
- **[SESSION-REMIND-DEPLOY] staging is DONE + verified:** `RESEND_API_KEY` secret set on `peerloop-cron-staging`, cron deployed (`*/15`), reminder columns present. Verified: the cron stamps `reminder_24h_sent_at` on due sessions + delivers reminder emails (confirmed to a real inbox). **Gotcha:** the staging `RESEND_API_KEY` is a **send-only** key — no delivery-status readback via the API (401), so future delivery checks need an inbox / the Resend dashboard.
- **Tooling gotchas** (see Learnings): wrangler writes results to **stderr** (capture `2>&1`); D1 caps compound SELECT <70; macOS has no `timeout` (use bg+`kill`); a deployed cron has no on-demand trigger (wait for the `*/15` tick).

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context.

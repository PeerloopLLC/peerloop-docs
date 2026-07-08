# State — Conv 374 (2026-07-08 ~14:51)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Conv 374 completed **TZ-MODEL Phase 3** and **closed the block** — the per-user
timezone model is fully delivered (Convs 371–374). (a) The leftover-UTC-label
sweep found nothing to remove: the surviving `${…} UTC` strings are the designed
null-tz fallbacks inside `src/lib/timezone.ts`'s own helpers. (b) Hardened
host-tz-dependent server date math to explicit UTC across 13 files (earnings
period boundaries, 7 analytics bucketing loops, 3 moderation expiry helpers,
cleanup notification stamps) and added two `[TZLINT]` patterns to
`scripts/lint-timezone.sh` enforcing the standard. (c) Decided to **build** the
dead session-reminder scaffolding, spun out as the new block **[SESSION-REMIND]**
(its own conv). This conv's `/r-end` was interrupted by a **power failure** after
the 3 agents ran but before commit/push; this state records the completed close.

## Key Context

- **TZ-MODEL is CLOSED** — do not reopen. Any remaining tz work is the
  SESSION-REMIND feature (a separate block), not this one.
- **★ Next = [SESSION-REMIND]** (`CURRENT-TASKS.md` § 🔥 Ordered): build the
  session-reminder cron job. ~70% scaffolding already exists
  (`SessionReminderEmail.tsx`, `email_session_reminder` pref live in Settings,
  `session_reminder` notif type). To build: per-session dedup columns
  (`reminder_24h_sent_at` / `reminder_1h_sent_at`, schema `0001`), a
  `sendSessionReminders(db)` lib fn (mirror `runSessionCleanup`), per-recipient
  timezone formatting, cron wiring, and tests. Also decide FeedbackReminderEmail
  (build or delete). Full scope in `CURRENT-TASKS.md`.
- **Key learning:** the vitest host runs in `America/Toronto` (UTC−4), NOT UTC,
  and the setup does not force `TZ=UTC` — so server code using the bare `Date`
  constructor or local `get/setDate/Month/FullYear` diverges between the test env
  and the UTC Cloudflare Worker. Standard is now explicit `getUTC*` / `Date.UTC` /
  `setUTC*` for any stored/compared date arithmetic — enforced by
  `scripts/lint-timezone.sh` `[TZLINT]`; decision routed to
  `docs/decisions/06-testing-ci.md`.
- **Baseline (verified in Conv 374):** 5 gates green — tsc · lint · astro 0/0/0 ·
  full suite **6784✓** · build. The `lint-timezone.sh` `[TZLINT]` addition
  committed at this r-end is a lint-script-only change (no src runtime surface),
  so the baseline is unchanged from that verification.
- **Commits:** code `5db13be6` (Phase 3b UTC date math) + this r-end's code commit
  (lint-timezone.sh `[TZLINT]`); docs `30e5f1a` + `51e3d21` + this r-end's
  end-of-conv bookkeeping commit.

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence
and this narrative for context.

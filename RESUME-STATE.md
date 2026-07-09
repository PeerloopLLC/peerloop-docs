# State — Conv 375 (2026-07-08 ~20:13)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Three efforts: **(1) [SESSION-REMIND]** — built + closed the session-reminder cron
job (24h + 1h, partition-band windows, per-recipient-tz email + always-on in-app
notification, dedup-stamped, no `datetime()`); deleted the dead `FeedbackReminderEmail`.
**(2) [TZ-TESTS]** — a plan-mode pre-GO-LIVE review of the TZ-MODEL work found the
implementation sound but the verification empty; added **+20 flip-verified tests**
(revert-fix → red) over earnings periods, expiry helpers, the validation gate, the
signup→register capture path, and cleanup's UTC-day boundary, plus cross-boundary
PLATO actors and a manual checklist. **(3) [TZ-LINT-CI]** — wired `lint:tz` into CI
and added a hostile-TZ test matrix so a UTC CI host can actually catch host-local
date regressions. All committed + pushed; 5 gates green (6810✓) throughout.

## Key Context

- **Task backlog lives in `CURRENT-TASKS.md`** — do not re-list here. Ordered is
  empty (no queued CC-execution item); the standalone backlog holds
  [SESSION-REMIND-DEPLOY], [FEEDBACK-NUDGE]·[Opus], [TZ-BROWSER-AUTO],
  [TZ-LINT-SCAN2]·[Opus], [TZ-HOOK-CHECK], plus the pre-existing items.
- **Deploy to activate SESSION-REMIND** ([SESSION-REMIND-DEPLOY], user-owned):
  `wrangler secret put RESEND_API_KEY` on the cron Worker + apply the 2 new
  `sessions` columns to the existing staging D1 (editing `0001_schema.sql` only
  affects fresh setups). Until then the cron logs `session-reminders skipped`.
- **⚠️ Factual correction made at r-end:** a mid-conv claim that "no
  `pre-commit-lint-tz.sh` hook exists" was a **repo-scoping error** — the CC
  PreToolUse hook DOES exist in the **docs** repo (`$CLAUDE_PROJECT_DIR/.claude/`),
  gating CC-initiated code-repo commits. Corrected across `docs/decisions/06-testing-ci.md`,
  `decision-log.md`, this conv's Learnings/Decisions, and the Extract. In a dual-repo
  project, ALL `.claude/` config lives in **peerloop-docs** — scope hook/settings
  checks there, not the code repo.
- **[TZ-HOOK-CHECK]** (#8): that hook exists but did NOT block a red-`lint:tz`
  baseline commit this conv — it may be silently non-functional; other PreToolUse
  guards could be too. CI now backstops `lint:tz`, so not urgent.
- **TZ verification patterns established:** the *flip check* (revert the UTC fix →
  confirm the test goes red) is the acceptance test for any tz-hardening test; on a
  UTC CI host boundary tests give zero protection, so a hostile-TZ matrix leg is the
  linchpin. Analytics bucketers are lint-protected (not runtime-tested) by design.
- **Baseline (verified this conv):** 5 gates green — tsc · lint · astro 0/0 · full
  suite **6810✓** (also passes under `TZ=Pacific/Kiritimati`) · build; `lint:tz` green.
- **Commits (pushed):** code `877380fb`, `549907b7`, `94c550d5`; docs `39915f6`,
  `34be7dd`, `e242dd0` + this r-end's bookkeeping commit.

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and
this narrative for context.

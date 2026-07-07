# State — Conv 371 (2026-07-07 ~15:16)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Ran `/w-codecheck` (all green), resolved Logo.tsx Tailwind-IntelliSense false-positive warnings (editor-config + memory), then completed **[TZ-AUDIT]** — a full timezone-correctness audit via 6 read-only agents. Fixed **Bucket 1** (localToUTC DST P0 + regression tests; booking-email "UTC" label; overnight slot-gen reclassified as unreachable), chose **Model A** (store `users.timezone`), and scoped the multi-conv rollout as **[TZ-MODEL]**.

## Key Context

- **Backlog:** see `CURRENT-TASKS.md`. **[TZ-MODEL]** is 🔥 Ordered (next-conv). Phase 0 = add `users.timezone` schema + signup auto-detect (`Intl…resolvedOptions().timeZone`) + Settings field + backfill existing users; two novel sub-decisions to resolve at Phase 0 start (backfill default, capture UX). Durable plan + full Bucket 2/3 display-site inventory: `plan/tz-model/README.md`. New backlog item **[CBG]** (commit-time branch guard). Working audit copy: `.scratch/tz-audit-findings.md`.
- **Branches:** our code work is on `jfg-dev-14` (pushed at this r-end, was 1 ahead pre-push). **`brian-July-7` is the CLIENT's (Brian) experimental UI branch — do NOT commit our work there.** It was reset back to origin base `c50afd82` this conv after a mid-conv external checkout landed a commit on it (moved to jfg-dev-14).
- **localToUTC fix:** fixpoint offset correction in `src/lib/timezone.ts` (new `tzOffsetMsAt`) — DST-transition wall-times now round-trip correctly (was ±1h off, corrupting `scheduled_start`). Model A's email localization (Phase 2) will replace the interim "UTC" label added to `SessionBookingEmail`.
- **Editor:** `Peerloop/.vscode/settings.json` (gitignored, machine-local) silences Tailwind IntelliSense `suggestCanonicalClasses` false positives on `@matt-source` arbitrary `[Npx]` — **replicate on MacMiniM4**. Memory: `reference_tailwind_intellisense_canonical_suggestions`.

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context.

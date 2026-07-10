# State — Conv 382 (2026-07-10 ~19:45)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Landed the **PLATO-SEQ Phase 3 durable foundation** and started (then checkpointed) the first browser re-walk. All 4 non-flywheel journeys are now formalized with the typed `restoreFrom`/`capturesTo` fields — `session-invite` + `member-directory` as **restore-only**, `activities` + `ecosystem` as **restore-from-waypoint** — with cut-points annotated from authoritative step-file reads. Authored + validated 2 lineage-exact producers (`activities-pre-11`, `ecosystem-pre-12`). Then restored `activities-pre-11`, drove the **real booking UI** as Alex, and DB-verified a scheduled session — proving the restore-from-waypoint walk works end-to-end. Foundation committed (code `e6f6f697`, docs `86dae0e`); the remaining browser re-walks are the multi-conv tail.

## Key Context

- **Task backlog is in `CURRENT-TASKS.md`** — do not re-list here. `[PLATO-SEQ]` stays the active Ordered item ([Opus]). **Next = finish the activities walk, then the ecosystem walk** (both browser re-walks).
- **Why lineage-exact producers (not snapshot reuse):** row-identity validation (the chosen bar) requires the restore base to be a prefix of the journey's OWN scenario — a different scenario reaching an equivalent state would differ on setup tables. So `activities` restores `activities-pre-11` (not `flywheel-pre-12`), `ecosystem` restores `ecosystem-pre-12`. Both are registered like `flywheel-pre-N` (dynamic runner, no static test block) and validated as correct prefixes.
- **⚠️ OPEN BLOCKER for the walks — CUT-3 completion bridge on a live server.** The BBB `room_ended` completion is checksum-verified; decide how to fire it against `npm run dev` (valid-checksum POST to `/api/webhooks/bbb`, a dev/test completion endpoint, or a faithful SQL replica of `completeSession()`'s effects: status=completed + freeze `module_id` + `module_progress` row). **Conv 381 applied the flywheel's CUT-3 completions as API bridges between segments — check how (its session doc / `.scratch/`) and reuse.**
- **Bridge-tool gotcha:** the Chrome `computer` click tool uses SCREENSHOT pixels (1242w), not CSS pixels (1177w, ~1.055× device-scale) → **click by `ref`** (from `find`), not raw coordinates. Restore-from-waypoint walks that register no users inherit correct persona tzs (no reconciliation needed, unlike Conv-381 B1). Genesis creds: Alex `alex.rivera@example.com`, Mara `mara.chen@example.com`; actor-switch via `POST /api/auth/dev-login {email}` + `localStorage.clear();sessionStorage.clear()` + hard nav.
- **Resume the activities walk:** re-restore `activities-pre-11` (`npm run plato:snapshot:restore -- activities-pre-11`, dev server DOWN + port 4321 free first), start `npm run dev`, then walk: book+complete session 1 (complete = CUT-3 bridge), book+cancel session 2, create homework (Mara), submit homework (Alex), follow, message; apply `topup-make-profiles-public` SQL bridge; browse members; then `plato:capture -- <name>` (**NOT** `activities` — don't clobber the API producer) + per-table `COUNT(*)` diff vs `activities.sqlite`. Then repeat the pattern for `ecosystem` (multi-actor, interleaved bridges).
- **Baseline (this conv):** no `src/` product code changed — only PLATO test infrastructure + docs. Gates run: tsc clean, eslint clean, PLATO API 13/13. Full `npm test`/build NOT run (not warranted for test-infra + docs).

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context.

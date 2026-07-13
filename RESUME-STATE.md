# State — Conv 392 (2026-07-12 ~20:27)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Conv 392 started as a live browser-walk of the Conv-391 certificate→diploma surfaces and turned into a substantial dead-code cleanup. The walk found **4 of 9 "user-visible" surfaces were on orphaned components rendered by no route** (Conv-391's grep sweep had edited dead code), and that the **Diploma appeared nowhere in the admin**. From there: rebuilt the missing completion moment on the live page, gave admins Diploma visibility, built an orphaned-page-component detector, and used it to purge the whole dead-legacy tail — **~84 dead components/tests deleted** across two passes (the course-detail family + Category-A). Also fixed [CERT-ROWSHAPE-FOLLOWUP] (PUT returns full enriched CourseDetail) at the top of the conv. All 5 gates green throughout (final suite 409 files / 6643 tests).

## Key Context

- **Task backlog lives in `CURRENT-TASKS.md`** — do not re-list here. The live thread is **`[ORPHAN-BACKLOG]`** (Ordered): Category-A (62 dead-legacy orphans) DONE this conv; **remaining = Category-B marketing (52, parked behind RG-PUBLIC) + Category-C (4 needs-a-look: `error/ErrorPage`, `leaderboard/Leaderboard`, `invite/ModeratorInvite`, `context-actions/ContextActionsPanel` — possibly built-but-never-wired, review per-item before deleting) + detector→/w-codecheck wiring + a stray dead-`.ts`-util sweep**.
- **The orphaned-component detector** is `.claude/scripts/codecheck-orphan-components.mjs` (BFS from `src/pages/**` routes → flags `src/components/**` unreachable components). It currently reports **57** orphans (52 B + 4 C + `CreatorCard`, a marketing dep) and exits 1 — a **manual tool**, NOT yet a hard `/w-codecheck` gate. Wire it (with the residuals baselined into `KNOWN_ORPHANS`) only after B+C resolve. Lesson memory: `[[feedback_orphaned_components_survive_migration]]`.
- **Detector methodology (validated):** an orphan set is a closed set disconnected from routes, so no *live* file imports any orphan — deletion can only dangle tests, dead barrels, or other orphans. **tsc is the precise arbiter** for danglers; grep import pre-checks false-positive on same-basename files and comments.
- **Admin Diploma:** now on the **Enrollments** admin (not a separate view — a Diploma has no table, it's derived from the enrollment). List + detail APIs return `diploma_awarded_at`; completed rows get a "View Diploma" action → `/diploma/[enrollmentId]`; detail panel shows a Diploma field.
- **Dashboard memory corrected:** the `[[project_role_studios_deconstruct_nudges]]` "keep UnifiedDashboard/`/old/dashboard` for comparison" was already revoked (Conv 339 deleted the route); this conv retired the last dead unified bits (`TriageStrip`/`NeedsAttention`/`PriorityHeader`, unmounted since Conv 258) and fixed the stale memory + `index.astro` comment.
- **`enr-david-n8n`** was force-completed via the admin during the walk to generate live notifications — it's now a completed-with-diploma dev fixture.

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context.

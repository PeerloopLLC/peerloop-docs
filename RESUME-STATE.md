# State — Conv 451 (2026-09-24 ~13:24)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-16`, docs: `main`

## Summary

Conv 451 finalized the Brian client-import (deployed `jfg-dev-16` to staging app-only, `60b375de`) and then built + shipped a new teacher-availability feature, `[CRTEACH]` (Brian's ask): a course with no active teacher is now hidden from the catalog + discovery rails, the course-detail hero shows a "No teachers currently available" badge, the creator is auto-certified as the first teacher at course creation, and the creator can step down via a guarded "Stop teaching" control. Committed (code `fbcf3571`, docs `ff14c7d`) and deployed to staging with a full destructive reseed (app `d3b8c594`); baseline green (6523 tests). Along the way, recovered an emptied local `.dev.vars` (JWT_SECRET) that had 500'd the Smart Feed, and caught a masked `npm run verify` "exit 0" that was hiding 10 real fixture failures.

## Key Context

- **Staging is CURRENT at Conv 451** — two deploys this conv: app-only Brian-import (`60b375de`), then the full-reseed `[CRTEACH]` deploy (`d3b8c594`). Both logged in `plan/deployment/README.md`.
- **`[CRTEACH]` is DONE** (moved to `## ✅ Done this conv`). The enrollability invariant is enforced at read time: catalog (`api/courses/index.ts`) + rails (`discovery-rails/compute.ts COURSE_BASE`) require `EXISTS(teacher_certifications is_active=1)`. `DISCOVERY_RAILS_VERSION` bumped 1→2.
- **Auto-cert:** `POST /api/me/courses` inserts an active `teacher_certifications` row for the creator + enables `can_teach_courses`. The explicit self-cert POST is now a re-activation/409 path — PLATO steps were changed to *discover* the auto-created cert.
- **`[TBK]` recurrence:** a backgrounded `npm run verify > log; echo EXIT=$?` reported a false "exit 0" (the echo's exit) while 10 tests failed. Always capture the real exit INTO the log and read the `Test Files … passed` line.
- **`.dev.vars` (local) was emptied on Sep 23** — cause unexplained (local-only; staging unaffected). Open question on the board only informally; user's call to investigate.
- Prod-KV-rebuild note (rails blob) self-heals via the version bump; captured in the deploy log, not a standing task.
- Dev server left running on `jfg-dev-16` (localhost:4321, pid ~82981); `npx astro dev stop` from `~/projects/Peerloop` to kill. Chrome bridge tab is dev-logged-in as Gabriel Rymberg.

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context. Note the code repo is on `jfg-dev-16`.

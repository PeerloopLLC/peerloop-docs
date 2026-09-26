# State — Conv 454 (2026-09-25 ~20:24)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-16`, docs: `main`

## Summary

Client feature conv (client = **Brian**). Shipped `[DISC-DEFAULT]`: the per-course "Discussion" toggle now **defaults ON** at creation, and the feed emits dated announcement posts on effective-live transitions — publish → "Discussion feed started/started again on …", unpublish/toggle-off → "turned off", toggle-on(published) → "started again", toggle on a draft → silent. Added a CI-safe render E2E (`[DISC-E2E]`, run green live) and **deployed to staging** (version 918ddb38). Also added a CLAUDE.md note that the client is Brian (not in-app test users like "Guy Rymberg").

## Key Context

- **Design model (decision A″):** feed "live" = `is_active = 1 AND discussion_feed_enabled = 1`. Announcements fire on transitions of that AND. Publish **force-enables** the toggle. Schema default stays `discussion_feed_enabled DEFAULT 0` (safety net); the create endpoint overrides to 1. New shared helper `src/lib/course-discussion-feed.ts` (`activate`/`deactivate`). Stream failures non-fatal; a failed first-provision rolls the toggle back to OFF so the public feed can't 500.
- **Scope:** creator self-serve flow only (`/api/me/courses`, publish, unpublish, `courses/[slug]/discussion-feed`) — matches `[CRTEACH]`. Admin bare-create endpoint untouched. No schema migration (column already existed).
- **Staging:** live at `peerloop-staging.brian-1dc.workers.dev` (v918ddb38). Applies to newly created/published courses; existing courses aren't retroactively flipped (republishing a draft force-enables it).
- **Tests:** unit/integration cover the transition logic; `e2e/course-discussion-feed.spec.ts` covers the render (mocked feed, CI-safe). 3 matrix gaps deliberately left open by the user: re-publish→"started again" via publish.ts, publish Stream-failure rollback, disable-when-not-live.
- **Baseline:** `npm run verify` green this conv (6528 tests, build, tsc, codecheck) — pre-E2E-file additions; E2E files don't affect verify.
- **Commits this conv (code jfg-dev-16):** `b275cc0f` (feature), `60e52509` (E2E). Docs: `9befa9f`, `c5c43dc`, plus the end-of-conv bookkeeping commit (Step 6). Not pushed until Step 7.
- **Follow-up:** `[DISC-E2E-REAL]` (optional, queued) — opt-in local-only real-Stream round-trip E2E. `[GSN-SPIN]` remains the next-up bug on the board.
- **MEMORY.md** at ~82% of the SessionStart byte cap — `[MEM-CAP]`/`[MEM-PRUNE]` watch; run `/r-prune-memory` when convenient.

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context.

# State — Conv 122 (2026-04-15 ~11:40)

**Conv:** ended
**Machine:** MacMiniM4-Pro
**Branch:** code: `jfg-dev-12`, docs: `main` (uncommitted changes will be committed in Step 6 of /r-end)

## Summary

Conv 122 tackled Option 2 from Conv 121's carried-over menu: two medium tasks sequentially. Closed **#12 [RS]** with a durable restructure of `scripts/reset-d1.js` (index pre-drop, post-sweep, final verification — eliminates the orphan-index failure class). Investigated **#13 [DS]** and root-caused `dev:staging` React-SSR hook errors to two-React-copies in `@astrojs/cloudflare` 13's `remoteBindings` branch. Tried two config-level fixes (#20 [DS-FIX]) — both failed — and the issue was **deferred indefinitely** as `DEV-STAGING-SSR` in PLAN.md §ON-HOLD after confirming zero prod/build/deploy/test impact. Spawned **#19 [CLM-RS]** to later update CLAUDE.md §Known issue about reset-d1 automation, and docs-agent spawned **#22 [SGA]** for a sync-gaps.sh false-positive on `.astro/*.d.ts`.

## Completed

- [x] #12 [RS] reset-d1.js orphan-table drop — durable implementation landed
- [x] #13 [DS] dev:staging adapter 13 regression — root-caused + deferred
- [x] #20 [DS-FIX] dev:staging React-dup fix — attempted, reverted, documented

## Remaining

### Deferred-but-documented (do NOT pull unless deliberately re-opening)
- DEV-STAGING-SSR (in PLAN.md §ON-HOLD) — React-dup in @astrojs/cloudflare 13 remoteBindings branch. Only affects `dev:staging`. Next step if/when reopened: read adapter source at `node_modules/@astrojs/cloudflare/dist/` for the `remoteBindings` branch; check 13.x changelog for upstream reports; try stripping `USE_STAGING_DB` and importing staging data into local D1 instead.

### Substantial blocks (need prioritization, not drain)
- [ ] #1 [P8] COMMUNITY-RESOURCES Phase 8 — PLATO flywheel step
- [ ] #2 [RA] ROLE-AUDIT — sweep non-CurrentUser role checks across codebase
- [ ] #3 [EM] Email notification for session invites
- [ ] #4 [DGH] DEPLOYMENT.GHACTIONS
- [ ] #5 [DP] DEPLOYMENT.PROD
- [ ] #6 [DSD] DEPLOYMENT.STAGING-DOMAIN (optional)
- [ ] #7 [PFC] PLATO-FLYWHEEL-CREATOR-GAP — creator-lifecycle audit
- [ ] #8 [CCS] CODECHECK-SQL — schema-aware SQL column-name lint
- [ ] #9 [ACR] API-COMM-REVIEW — API-COMMUNITY.md review for Conv 118 changes
- [ ] #10 [DSA] DBAPI-SUBCOM-AUDIT — full §Communities + §Authentication endpoint audit

### Medium
- [ ] #11 [MPT] Multipart file-upload happy-path tests (R2 mocking required)
- [ ] #14 [BKN] BKC-NEXT — SessionBooking next-month upper bound (design call)
- [ ] #15 [BKF] BKC-FETCH — SessionBooking 4-week fetch horizon (design call)
- [ ] #16 [CRE] COURSE-RES-AUTH-EDGE — disputed + soft-deleted enrollment gate (pending product call)

### Small / housekeeping
- [ ] #19 [CLM-RS] CLAUDE.md §Known issue update — note reset-d1 automation; keep manual recovery as last-resort fallback
- [ ] #22 [SGA] sync-gaps.sh — exclude `**/.astro/**` to stop false-positive flagging of generated `.d.ts` files

### Blocked / deferred
- [ ] #17 [IN] Install gh CLI on MacMiniM4-Pro (machine-blocked — run on -Pro only; this conv ran on -Pro but user didn't direct install)
- [ ] #18 [CSS] /discover/members bottom-row clipping (root-caused earlier; fix needs browser verification)

## TodoWrite Items

All 17 pending tasks above will be transferred to TodoWrite by /r-start in Conv 123.

## Key Context

### Conv 122 artifacts (fresh, load-bearing)

- **`scripts/reset-d1.js`** — durable restructure. New helpers: `queryWrangler(sql, base)` (JSON output with graceful degradation), `listUserObjects(base, typeFilter)` (sqlite_master enumeration filtering `sqlite_%`/`d1_%`/`_cf_%`). `resetRemote()` now runs as 6 explicit steps: (1) drop user indexes first, (2) drop tables in FK dependency order, (3) post-sweep leftover user objects, (4) clear `d1_migrations`, (5) final verification with printed leftovers, (6) return false on verification failure. Local path untouched. No tests depend on it.

- **`PLAN.md` §ON-HOLD → DEV-STAGING-SSR** — full diagnostic row: root cause (two React copies in SSR graph via @astrojs/cloudflare 13 remoteBindings branch), attempted fixes (ssr.noExternal, resolve.dedupe — both failed, verified via `deps_ssr/react-dom_server.js` persistence after `.vite` cache clear), blast radius (dev:staging only; zero impact on prod/build/deploy/test/preview/CI), workarounds (stage-deploy, wrangler d1 execute, local D1 with staging import).

### Patterns named this conv

- **Differential repro before source reading** for env-flag-gated regressions (confirmed on #13).
- **Adapter-override assumption:** `ssr.noExternal` and `resolve.dedupe` are not always honored when an adapter has its own SSR externalization branch. Verify via `deps_ssr/` filesystem inspection after cache clear, not just error absence.
- **Idempotent DB reset pattern:** drop indexes first → drop tables in FK order → post-sweep → verify. Applied to reset-d1.js this conv.
- **`node -c` absolute path rule:** relative paths in dual-repo work silently resolve against wrong repo. Use `node -c /abs/path/to/file.js`.

### Commits this conv (pre-/r-end)

- Docs: `635bf81` (Conv 122 start) — PLAN.md + RESUME-STATE.md deletion + /r-end commit pending this step.
- Code: no commits yet — `scripts/reset-d1.js` + `package-lock.json` will be committed in /r-end Step 6.

### npm install ran this conv

`cd ../Peerloop && npm install` — 121 packages added, lockfile sync only, no intentional dependency changes.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.

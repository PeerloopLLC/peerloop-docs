# State — Conv 126 (2026-04-18 ~09:30)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-12`, docs: `main`

## Summary

Conv 126 was a tooling session across multiple sub-sessions: synced r-end/r-start/r-commit/r-timecard-day skills from spt-docs via `/w-sync-skills`, then built and iterated on `timecard-day.js` (the deterministic timecard script) through three rounds of classification fixes — DB Changes H4, docNameWhitelist for ALL-CAPS stems, API Changes detection, and db:*/npm/npx infraPrefixWords routing. Regenerated `.timecard.md` for Apr 15, 2026 with all fixes applied.

## Completed

- [x] /w-sync-skills: r-end, r-start, r-commit, r-timecard-day from spt-docs
- [x] Round 2 timecard fixes: PLAN.md/DOC-DECISIONS.md routing, DB Changes H4, dbSqlRe
- [x] Round 3 timecard fixes: docNameWhitelist, API Changes detection, infraPrefixWords
- [x] Regenerated .timecard.md for Apr 15, 2026 with all fixes

## Remaining

### Substantial blocks (need prioritization)
- [ ] #1 [EM] Email notification for session invites
- [ ] #2 [DGH] DEPLOYMENT.GHACTIONS
- [ ] #3 [DP] DEPLOYMENT.PROD
- [ ] #4 [DSD] DEPLOYMENT.STAGING-DOMAIN (optional)
- [ ] #5 [PFC] PLATO-FLYWHEEL-CREATOR-GAP — creator-lifecycle audit
- [ ] #6 [CCS] CODECHECK-SQL — schema-aware SQL column-name lint
- [ ] #7 [ACR] API-COMM-REVIEW — API-COMMUNITY.md review for Conv 118 changes
- [ ] #8 [DSA] DBAPI-SUBCOM-AUDIT — §Communities + §Authentication audit
- [ ] #9 [RA-SSR] Collapse course/[slug]/*.astro SSR queries into fetchCourseDetailData loader (~3-4 hr)

### Medium
- [ ] #10 [MPT] Multipart file-upload happy-path tests — R2 mocking required
- [ ] #11 [BKN] BKC-NEXT — SessionBooking next-month upper bound (design call)
- [ ] #12 [BKF] BKC-FETCH — SessionBooking 4-week fetch horizon (design call)
- [ ] #13 [CRE] COURSE-RES-AUTH-EDGE — disputed + soft-deleted enrollment gate (product call)

### Small / housekeeping
- [ ] #14 [CLM-RS] CLAUDE.md §Known issue update for reset-d1 automation
- [ ] #15 [IN] Install gh CLI on MacMiniM4-Pro
- [ ] #16 [CSS] /discover/members bottom-row clipping fix — 2-line fix root-caused at AppNavbar.tsx:593; needs browser verification
- [ ] #17 [ASTRO-CT] Note astro-check includes generated content.d.ts files in dev guide
- [ ] #18 [HMP] Canonicalize hook-mock test pattern in DEVELOPMENT-GUIDE.md
- [ ] #19 [RA-SSR-LOADER] (Conv 125) — `src/lib/ssr/loaders/communities.ts:471-476` has raw `SELECT is_admin`; migrate to `isUserAdmin(db, userId)`; ~5 min
- [ ] #20 [TC-STRIP] Add "Extract/Learnings/Decisions for Conv" to routineStrip.phrases in config.json — 1-line config change

## TodoWrite Items

All 20 pending tasks above will be transferred to TodoWrite by `/r-start` in Conv 127.

## Key Context

### Timecard tooling (timecard-day.js) — fresh this conv

- **classifyItem() tier ordering**: T2.5 (DB tag/path/keyword) → T3a (infraPrefixWords: db:*/npm/npx) → T3b (API method+path, workEffort only) → T3c (infraPathSubstring) → T3g (codePrefixRe). Order is load-bearing — changing it causes cross-signal contamination.
- **T3b guard**: `item.src === 'workEffort' && !isTestRelated({ text }, rt)` — mandatory on any path-substring heuristic to prevent tests/api/* paths from routing to API Changes.
- **docNameWhitelist**: 22-entry stem list in `config.json → rTimecardDay`. When a new reference doc is added, add its ALL-CAPS stem here so bullets referencing it without `.md` are recognized.
- **docRootExclude vs validDocs**: Files in `docRootExclude` are excluded from `validDocs`. If a file should appear in Doc Changes when mentioned in bullets, it must NOT be in `docRootExclude`. PLAN.md and DOC-DECISIONS.md were removed from `docRootExclude` this conv.

### Known remaining timecard rough edges (not fixed this conv)

- "admins"/"no" H5 groups in User-facing — commit format issue (bullets lack em-dash pattern); not a script bug
- "Extract/Learnings/Decisions for Conv NNN" in Work Effort — tracked as #20 [TC-STRIP]: add phrase to routineStrip.phrases

### Continuing code state

- Code repo `jfg-dev-12` is clean — [CTR] changes were committed in Conv 125.
- Docs repo: Conv 126 had 3 commits (start, CLAUDE.md/r-optimize, timecard tooling/skill sync).

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.

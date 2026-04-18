# State — Conv 127 (2026-04-18 ~14:20)

**Conv:** ended
**Machine:** MacMiniM4-Pro
**Branch:** code: `jfg-dev-12`, docs: `main`

## Summary

Conv 127 was a tooling/skills refactor: converted `/r-timecard-day2` from a first-match-wins tier-cascade classifier into a parameter-driven engine where each H4 section owns an independent `include` predicate and a bullet can render in every H4 whose predicate matches. Created `/r-commit2` + `/r-end2` as pure-additive v2-format forks of the originals (`### SECTION` H3 headers + `Format: v2` trailer); wrote the canonical `docs/reference/COMMIT-MESSAGE-FORMAT.md` spec; moved all project-specific literals out of `timecard-day.js` into `.claude/config.json → rTimecardDay`; named H5/H6 strategies in config with implementations in a script lookup table. Also reset staging D1 + all seeds at the start of the conv. This is the first `/r-end2` invocation — commit uses v2 format.

## Completed

- [x] `/r-start` — Conv 126→127; 20 tasks transferred; npm install resolved dep drift
- [x] Staging D1 reset + all seeds (`db:setup:staging:feeds`) — 148 indexes + 67 tables dropped clean, 4 migrations, dev/stripe/booking/feeds seeds applied
- [x] `[TC2-SPEC]` `docs/reference/COMMIT-MESSAGE-FORMAT.md` — v2 canonical spec
- [x] `[TC2-CFG]` `config.json → rTimecardDay` — h4Sections + skipFilter + dayWindow + convMeta + commitTagPrefixes + legacy + render
- [x] `[TC2-SCRIPT]` `timecard-day.js` — loadCfg, predicate engine (evalPredicate + computeH4Buckets + predicateHasFallthrough), extractV2Bullets, H5/H6 strategy lookup tables
- [x] `[TC2-SKILLS]` `/r-commit2` + `/r-end2` forked with v2 commit template
- [x] `[TC2-DOC]` `/r-timecard-day2` SKILL.md updated — h4Sections / predicate DSL / named strategies
- [x] `[TC2-VERIFY]` verification battery — multi-H4 real-data confirmed (4 appearances from one bullet); fallthrough fix applied

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
- [ ] #9 [RA-SSR] Collapse `course/[slug]/*.astro` SSR queries into `fetchCourseDetailData` loader (~3-4 hr)
- [ ] #10 [MPT] Multipart file-upload happy-path tests — R2 mocking required

### Medium
- [ ] #11 [BKN] BKC-NEXT — SessionBooking next-month upper bound (design call)
- [ ] #12 [BKF] BKC-FETCH — SessionBooking 4-week fetch horizon (design call)
- [ ] #13 [CRE] COURSE-RES-AUTH-EDGE — disputed + soft-deleted enrollment gate (product call)

### Small / housekeeping
- [ ] #14 [CLM-RS] CLAUDE.md §Known issue update for reset-d1 automation
- [ ] #15 [IN] Install gh CLI on MacMiniM4-Pro
- [ ] #16 [CSS] `/discover/members` bottom-row clipping fix at `AppNavbar.tsx:593` — needs browser verification
- [ ] #17 [ASTRO-CT] Note astro-check includes generated content.d.ts files in dev guide
- [ ] #18 [HMP] Canonicalize hook-mock test pattern in DEVELOPMENT-GUIDE.md
- [ ] #19 [RA-SSR-LOADER] `src/lib/ssr/loaders/communities.ts:471-476` raw `SELECT is_admin` → `isUserAdmin(db, userId)` — ~5 min
- [ ] #20 [TC-STRIP] Add "Extract/Learnings/Decisions for Conv" to `routineStrip.phrases` — 1-line config change
- [ ] #21 [TDS-AUTH] (new Conv 127) — audit 4 stale auth docs (API-AUTH.md, auth-libraries.md, google-oauth.md, auth-sessions.md) vs current `src/lib/auth/*`
- [ ] #22 [DEVCOMP-REVIEW] (new Conv 127) — periodic review of 59 session files for machine-specific notes missing from `devcomputers.md`

## TodoWrite Items

All 22 pending tasks above will be transferred to TodoWrite by `/r-start` in Conv 128.

## Key Context

### Timecard v2 tooling architecture (core of this conv)

- **Predicate engine.** `.claude/scripts/timecard-day.js` now routes bullets via per-H4 `include` predicates in config (not a tier cascade). Each H4 in `config.rTimecardDay.h4Sections[]` evaluates independently against every bullet — a bullet can appear in multiple H4s. Predicate DSL is closed set: `src`, `matchesRegex`, `textContainsAny`, `startsWithAny`, `docsMentionGt`/`Eq`/`Gte`, `testRelated`, `notTestRelated`, `isRoutine`, `commitFileMatchesPrefix`, `allCommitFilesUnder`, `flag`, `fallthrough`, plus `anyOf`/`allOf` combinators. String refs like `"reroute.apiMethodRe"` resolve to config fields at eval time.

- **Fallthrough is a combinator, 2-pass.** Work Effort uses `{anyOf: [{src: "workEffort"}, {fallthrough: true}]}`. Pass 1: all predicates run (fallthrough returns false); workEffort-src bullets match via the first arm. Pass 2: bullets that matched nothing get dumped into whichever H4 has nested `fallthrough: true` (detected recursively by `predicateHasFallthrough`). Key bug fixed in verification: initial Work Effort was fallthrough-only, which excluded workEffort-src bullets that ALSO matched other H4s.

- **H5/H6 are named strategies.** Strategy names in `h4Sections[].h5Strategy` (and optional `h6.strategy`); implementations in `H5_STRATEGIES` / `H6_STRATEGIES` lookup tables in the script. 8 H5 strategies + 1 H6 strategy cover all current H4s. `docFilename` is the only strategy that legitimately produces multiple H5 entries from a single bullet (one per mentioned doc).

- **v2 detection via `Format: v2` trailer.** Not a date cutoff. `/r-commit2` + `/r-end2` emit this trailer. When present, `parseMetadata` calls `extractV2Bullets(body, h4Sections)` which reads `### SECTION` H3 headers and assigns each bullet an `src` via title→id lookup. v1 commits lack the trailer; predicates work identically on both, but v2 has richer `src` metadata from explicit H3 placement.

- **`h4Sections[].title` is the literal string in both places.** A v2 commit emits `### DB Changes` (the title); the timecard emits `#### DB Changes`. Rename is one config edit. Title→id lookup in the v2 body parser handles arbitrary renames.

### Coexistence, not replacement

- `/r-end`, `/r-commit`, `/r-timecard-day` untouched — full backward compat.
- `/r-end2`, `/r-commit2` are pure-additive forks; `/r-timecard-day2` handles both v1 and v2 via the same predicate engine.
- Recommendation: adopt v2 on your own timeline; retire v1 skills after a few weeks of v2 use.

### Staging DB reset (first action of the conv)

- Full `db:setup:staging:feeds` chain ran clean — no orphaned-indexes issue (the known Session 359 pitfall did NOT reproduce on this machine/run).
- Final state: DB UUID `605f1ab8-62cc-4934-a2fd-d828e188f50e`, 1.38 MB, `platform_stats.environment='staging'`, full seed data (2022 dev rows + 9 Stripe + 46 booking + 14 Stream activities + 17 reactions).

### Known remaining rough edges (not fixed this conv)

- #20 [TC-STRIP]: "Extract/Learnings/Decisions for Conv NNN" phrases are still appearing in Work Effort rollups — 1-line add to `routineStrip.phrases` in config.json.
- #21 [TDS-AUTH] + #22 [DEVCOMP-REVIEW]: tech-doc-sweep / dev-env-scan carry-over items flagged by docs agent this conv.
- V2 format has not yet been tested against a real v2-formatted historical commit (this conv's /r-end2 commit will be the first).

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.

# State — Conv 125 (2026-04-15 ~20:05)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-12`, docs: `main` (uncommitted Conv-125 changes will be committed in Step 6 of /r-end)

## Summary

Conv 125 drained 3 of 4 RA-* TodoWrite tasks from the Conv 123 ROLE-AUDIT block. [ADR] closed as false-positive triage (4 tech-doc-sweep flags, all pre-updated or orthogonal — documented in DOC-DECISIONS.md §5 with dismissal table + fixed a stale `r-docs/` path reference in the existing decision). [CTR]/[RA-RES-ROLE] executed as a field-deletion refactor that cascaded into a `LEFT JOIN community_members` removal from the community-resources SSR query (8 files, 13 lines, 1 JOIN eliminated). [RA-JWT] recorded as Decision A in docs/DECISIONS.md §4 after discovering the audit's "15-min staleness" framing was wrong — the refresh-token-as-auth fallback widens it to 7 days, making embedding incompatible with instant admin revocation for security-sensitive gates. All baselines green; only `[RA-SSR]` (substantial 3-4 hr refactor) remains in the mechanical RA-* family, plus the newly-spawned [RA-SSR-LOADER] 5-min fix.

## Completed

- [x] [ADR] Auth-doc review for Conv 123 ROLE-AUDIT propagation — all 4 flags false-positive; documented as expected noise
- [x] [CTR] / [RA-RES-ROLE] — Dropped unused `CommunityTabs.Resource.uploadedBy.role` field (8 files, 13 lines, 1 LEFT JOIN eliminated as bonus)
- [x] [RA-JWT] — Decided against JWT `isAdmin` embedding; docs/DECISIONS.md §4 has full rationale with 4 options and revisit triggers

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
- [ ] #9 [RA-SSR] Collapse course/[slug]/*.astro SSR queries into fetchCourseDetailData loader (~3-4 hr) — only remaining mechanical RA-* task

### Medium
- [ ] #12 [MPT] Multipart file-upload happy-path tests — R2 mocking required
- [ ] #13 [BKN] BKC-NEXT — SessionBooking next-month upper bound (design call)
- [ ] #14 [BKF] BKC-FETCH — SessionBooking 4-week fetch horizon (design call)
- [ ] #15 [CRE] COURSE-RES-AUTH-EDGE — disputed + soft-deleted enrollment gate (product call)

### Small / housekeeping
- [ ] #16 [CLM-RS] CLAUDE.md §Known issue update for reset-d1 automation
- [ ] #17 [IN] Install gh CLI on MacMiniM4-Pro
- [ ] #18 [CSS] /discover/members bottom-row clipping fix — 2-line fix root-caused at AppNavbar.tsx:593; needs browser verification
- [ ] #20 [ASTRO-CT] Note astro-check includes generated content.d.ts files in dev guide
- [ ] #21 [HMP] Canonicalize hook-mock test pattern in DEVELOPMENT-GUIDE.md
- [ ] #22 [RA-SSR-LOADER] (NEW Conv 125) — `src/lib/ssr/loaders/communities.ts:471-476` has raw `SELECT is_admin` that Conv 123 [RA-ADM] missed; migrate to `isUserAdmin(db, userId)`; ~5 min

## TodoWrite Items

All 19 pending tasks above will be transferred to TodoWrite by `/r-start` in Conv 126.

## Key Context

### Conv 125 artifacts (fresh, load-bearing)

- **`docs/DECISIONS.md` §4 "Do NOT embed isAdmin in JWT"** — authoritative record of the [RA-JWT] decision. Key passage: the refresh-token-as-auth fallback at `src/lib/auth/session.ts:88-94` makes any claim embedded in the refresh token trusted for 7 days (not 15 min). This reframes every future discussion of JWT claims vs. DB-lookup tradeoffs. Includes revisit triggers (P95 latency regression + embedding design that preserves instant revocation).
- **`DOC-DECISIONS.md` §5 "Tech Doc Sweep: Auth-Doc False Positives Are Expected"** — dismissal table for `API-AUTH.md`, `auth-libraries.md`, `google-oauth.md`, `auth-sessions.md`. Only review them if the code change falls into the narrow categories listed (new HTTP endpoint / JWT library pattern / OAuth setup / session-lifecycle).
- **`src/lib/ssr/loaders/communities.ts`** — SQL query for community resources now runs without the `LEFT JOIN community_members` that Conv 123 had in place. Output `Resource` type no longer has `uploadedBy.role`. Downstream consumers in 6 Astro pages + `CommunityTabs.tsx` updated.

### Discoveries that should not need re-finding

- **`tech-doc-sweep.sh` is stateless** — no hash state or baseline mechanism. The `[TS]` "Re-baseline" task referenced in older session extracts was a ghost task (feature never shipped). The `[TD]` "Tighten to src/**" task is already committed (line 59: `grep '^src/'`).
- **`src/lib/ssr/loaders/communities.ts:471-476` has raw `SELECT is_admin`** — Conv 123 [RA-ADM] migrated 9 API-handler sites but missed this SSR loader. Tracked as `[RA-SSR-LOADER]` #22.
- **Astro's `[slug]` dirname collides with glob character-class syntax** — `Glob` tool returns nothing for `src/pages/course/[slug]/**/*.astro`. Use `Bash ls` with path quoted, or escape the brackets.

### Patterns named this conv

- **Pointing-emoji question = turn ends** — `feedback_pause_on_pointing_questions.md` in memory. 👉👉👉 questions must not be followed by more tool calls or prose; they terminate the turn. This was a real slip in this conv's /r-start that the user caught.
- **Audit reachability sweeps need `src/lib/` inclusion** — `src/pages/api/**`-only scoping misses SSR loaders. When designing pattern-migration audits, explicitly enumerate directory scope and spot-check hits in unexpected dirs at close-out.
- **Field-deletion refactors should trace to the SQL layer** — an "unused type field" downstream may be load-bearing for an otherwise-invisible JOIN. [CTR] discovered this by walking the data pipeline from UI → type → loader transformation → SQL query → JOIN.

### Commits this conv (pre-/r-end)

- Docs: `77510c1` (Conv 125 start). Uncommitted (to be committed in /r-end Step 6): `DOC-DECISIONS.md`, `PLAN.md`, `docs/DECISIONS.md`, RESUME-STATE.md delete, Conv-125 session files.
- Code: (none yet this conv). Uncommitted: 8 files from [CTR] + `package-lock.json` hash regen from /r-start dependency sync (will be committed in /r-end Step 6).

### Notable non-issues (verified this conv)

- Full baseline green after [CTR]: tsc exit 0, astro check 0/0/0. Lint 1 pre-existing error in `MemberDirectory.tsx` (react-hooks/exhaustive-deps config issue, carried forward from Conv 124).
- `/api/me/profile`, `/api/me/full`, `/api/auth/session`, `/api/auth/login` all legitimately SELECT `is_admin` as part of wider user-row queries — NOT candidates for the `isUserAdmin` helper migration. Don't flag them as misses.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.

# PACKAGE-UPDATES — npm dependency upgrade sweep

**Focus:** Upgrade all npm dependencies to latest versions, on a dedicated branch
**Status:** 🔥 IN PROGRESS (Convs 104-113) — Phases 1-6 complete; PR #26 created (jfg-dev-11 → staging) for client review (Conv 113); CF Pages build failure discovered + temp postbuild patch deployed to staging; Phase 2b deferred (ecosystem gap). **Branch:** `jfg-dev-11` (promoted from `jfg-dev-10up`). Merge target: staging (PR #26). **Five-gate baseline** clean (tsc 0, astro 0, lint 4 pre-existing, tests 6391/6391, build; Conv 111).

**Completed:**
- Phase 1 minor/patch bumps; Stripe apiVersion → `2026-02-25.clover`; `getStripe()` helper — Conv 100
- Phase 2-prep: Centralized Cloudflare env access (`getEnv`/`requireEnv`/`getR2`), ~95 files migrated — Conv 100
- Phase 2a: Astro 5.18 → 6.1.5, `@astrojs/cloudflare` 12.6 → 13.1.8, `@astrojs/react` 4.4 → 5.0.3, Vite 6 → 7, `cloudflare:workers` env import + vitest alias, `src/env.d.ts` rewrite — Conv 101
- Phase 3 baseline-clearing: 18 pre-existing tsc errors eliminated via `json<T>` codemod (1,587 sites / 198 files, ts-morph), 5 time-fragile session test failures fixed with `futureAt(daysFromNow, utcHour)` helper — Conv 102
- Phase 3 proper: `zod ^3.25.76 → ^4.3.6` (dedupes with Astro's vendored copy; ZERO first-party imports — investigated in [ZU]: added 2026-01-08 for PageSpec, orphaned by Session 307's 40k-line delete) — Conv 104
- Phase 4: `stripe ^20.1.0 → ^22.0.1`; `apiVersion '2026-02-25.clover' → '2026-03-25.dahlia'` (single tsc error, one-line fix); [SD] changelog audit completed same-conv (checkout UI mode + Capabilities risk requirements both unaffected; documented in `docs/reference/stripe.md` as template for future bumps) — Conv 104
- Phase 5: `better-sqlite3 ^11.10.0 → ^12.8.0`, `eslint ^9.39.4 → ^10.2.0`, `jsdom ^27.4.0 → ^29.0.2`, `@cloudflare/workers-types` nightly — Conv 104
- [LD] ESLint drift cleanup: 45 → 0 problems (13 unused imports, 17 unused args, 1 stale `eslint-disable`, 5 redundant-any casts fixed; 2 half-wired `setActionLoading` + 7 `CourseEditor` state vars prefixed `_` and flagged as [HW]); `eslint.config.js` extended with `varsIgnorePattern`/`destructuredArrayIgnorePattern` on `^_` — Conv 104
- **Astro check gap closed** — `npm run check` added to CI (`lint-and-typecheck` job), `CLAUDE.md` Development Commands, `/w-codecheck` SKILL.md, `docs/reference/BEST-PRACTICES.md` (3 baseline blocks), and memory (`feedback_baseline_includes_astro_check.md`). New baseline = five gates. Conv 102's "clean baselines" claim retroactively incomplete — Conv 104
- [AC] 10 astro check errors fixed: `CourseTag` consolidation (renamed junction → `CourseTagRow`, canonicalized display shape in `lib/db/types.ts`, deleted duplicates in `mock-data.ts` + `course-tabs/types.ts`; zero `.astro` edits needed); `creator/[handle]/index.astro` `primary_topic_id` added; `discover/course/[slug]/[...tab].astro` TabId narrowing; `CourseTabs.initialTab` widened to `TabId | (string & {})` to match runtime — Conv 104
- [AH] 27 astro check hints cleaned: 14 test files (unused imports/vars), `booking.ts` dead `enrollmentId` param, 2 unused `via` params in `.astro`, `FormModal` `FormEvent → SyntheticEvent` (React 19), deleted orphaned `tests/plato/steps/_chain.ts`, `feed-activity.test.ts` half-wired upsert test completed with missing assertion — Conv 104
- [HW] Half-wired features cleanup: discovered both features were superseded legacy state (not missing UI). Deleted 3 unused `_error`/`_successMessage` state pairs + `actionLoading` dead state in ModerationAdmin/ModeratorQueue/CourseEditor (3 files, 11+/46-); FormModal + backdrop already provides action lockout; showToast already provides feedback. 4 pre-existing silent-failure `setError(err...)` sites in TeachersTab + PeerLoopFeaturesTab replaced with `showToast(..., 'error', 5000)` (net UX improvement). Five-gate baseline still green — Conv 105
- [P6] Five-gate baseline re-verified on `jfg-dev-10up` HEAD (3e15f8a): tsc 0 / astro 0 / eslint 0/0 / tests 6399/6399 / build 6.03s — Conv 106
- [P6] Broader docs sweep for stale version mentions: 3 live "Astro 5.x" references refreshed to "Astro 6.x" with current Node ranges (`docs/DECISIONS.md` Stay-on-Node-22 decision — preserved 2026-02-16 date, added 2026-04-11 update note; `docs/as-designed/devcomputers.md`; `docs/reference/cloudflare.md`). Sessions archive confirmed frozen — Conv 106
- TodoWrite backlog clearance (33/34 items): doc fixes ([DR] DOC-DECISIONS, [RT] DB-GUIDE, [FL] BEST-PRACTICES, [CK] cloudflare-kv, [AS] auth docs), bug fixes ([AM] midnight-spanning availability, [CC] Astro content config, [DH] dead test helpers, [DL] locals param verified active), skill fixes ([RS] /r-end timing note, [RD] /r-start dedup guard, [CP] /r-timecard-day paths, [SG] sync-gaps.sh, [TD] tech-doc-sweep.sh, [PM] extract-manifest path), codecheck ([SF]+[LE] 2 new rules), sweeps ([VS] `npm run verify`, [TT] futureUTC test helper, [HD] helpers.md inventory). 5 items assessed and closed as low-value ([HD2], [OD], [SD2], [SV], [PG]) — Conv 107
- [S1] Schema: `primary_topic_id` restored to `courses` table + seed data + types — Conv 108
- [S2] Schema: `homework_submissions.student_user_id` → `student_id` renamed across schema, seed, types, tests — Conv 108
- [S3] Code: `teacher-dashboard.ts` `assigned_teacher_id` → `teacher_id` fix — Conv 108
- E2E suite: all 6 pre-existing failures fixed (login race, browse-enroll redirect, admin-overview selectors, session-completion-flow rewrite, smart-feed simplification, session-booking fallback) — 137/137 passing Conv 108
- PLATO flywheel snapshot pipeline: `snapshot: true` at file level + `metadata.sqlite` filter in restore script — Conv 108
- PLATO flywheel browser walkthrough: all 14 intents verified (Mara Chen creator side + Alex Rivera student→teacher side) — Conv 108
- [FE] LoginForm inner try-catch for non-JSON error responses — Conv 108
- [LS] `login.astro` + `signup.astro` server-side `getSession()` redirect for authenticated users — Conv 108
- [CM] `member_count` fixed in seed SQL: `UPDATE communities SET member_count=N` after `community_members` inserts (core: 1, dev: 11) — Conv 108
- Late cancellation test timing fix: `futureUTC(0, 14)` → `Date.now() + 4h` — Conv 108
- `/w-codecheck` `error-captured-never-rendered` grep: added `error ||` variant — Conv 108
- `jfg-dev-11` branch created from `jfg-dev-10up` — Conv 108
- Session invite fire-and-forget bug fix: `await` added to `notifySessionInvite()` and `notifySessionInviteAccepted()` in both endpoints (Workers can kill unawaited promises) — Conv 109
- Session invite two-user integration tests: 9 tests covering notification isolation, badge counts, acceptance flow — Conv 109
- PLATO session-invite: steps (send + accept), scenario (12-step chain), instance (6 browser intents), browser walkthrough verified — Conv 109
- Session expiry UX: expired identity localStorage, "Welcome back [Name]" with email pre-fill, "Not [Name]?" escape hatch — Conv 109
- Dev-mode login endpoint (`/api/auth/dev-login`): passwordless login gated on `import.meta.env.DEV` for PLATO testing — Conv 109
- 26 tests for session expiry UX (current-user-cache 10, auth-modal 6, dev-login 10) — Conv 109
- Removed 3× `setTimeout` hacks from existing `session-invite-notifications.test.ts` — Conv 109
- Five-gate baseline: tsc 0 / lint 0 / tests 6410/6410 / build — Conv 109
- Dev environment fix: npm install (Cloudflare adapter 12→13) + vite cache clear — Conv 110
- AppNavbar simplification: commented out 5 menu items (feeds, courses, communities, teaching, creating) — client-approved — Conv 110
- index.astro: My Courses card commented out, Messages card auth-only (hidden for visitors) — Conv 110
- Open messaging: `getMessageableFlags()` simplified (3 relationship queries → 1 existence check), `messageableContactsSQL()` simplified (6 EXISTS → `u.deleted_at IS NULL`), 125 lines removed — Conv 110
- Updated messaging tests (5 expectations in messaging.test.ts, 1 in can-message API test) — Conv 110
- Updated POLICIES.md section 4 + messaging.md for open messaging model — Conv 110
- Five-gate baseline: tsc 0 / lint 0 / tests 6435/6435 / build — Conv 110
- Unified member directory: consolidated /discover/teachers, /discover/creators, /discover/students into single /discover/members page with server-side search, multi-role OR filter, 5 sort options, Load More UX — Conv 111
- GET /api/members endpoint with optional auth (admin extras inline), expertise batch-fetch — Conv 111
- MemberRole types, MEMBER_ROLE_COLORS, MemberRoleBadge/MemberRoleBadgeRow components with dimmed variant — Conv 111
- MemberCard + MemberDirectory React components — Conv 111
- /discover/members opened to all users (admin gate removed); DiscoverSlidePanel consolidated (3 links → 1); discover hub updated — Conv 111
- 301 redirects: /discover/teachers → /discover/members?roles=teacher, /discover/creators → ?roles=creator, /discover/students → ?roles=student — Conv 111
- Deleted 4 old components (TeacherDirectory, CreatorBrowse, StudentDirectory, DiscoverMembers) + 2 old test files (~2350 lines removed) — Conv 111
- 24 API tests for /api/members (role derivation, filtering, search, sorting, pagination, admin privileges) — Conv 111
- Five-gate baseline: tsc 0 / astro 0 / lint 4 pre-existing / tests 6391/6391 / build — Conv 111
- PLATO browse-members step (read-only, 4 query variations) + member-directory scenario + instance (8 BrowserIntents); SQL top-up for privacy_public. 10/10 PLATO tests — Conv 112
- Browser smoke test of /discover/members: initial load, All Members, Creator filter, multi-role, search — all verified — Conv 112
- Fixed MemberDirectory.tsx hydration race: AbortController + rolesKey serialization (Creator filter empty on initial load) — Conv 112
- Fixed `users.last_login` never written: `recordLogin()` helper added to `session.ts`, called from all 4 auth endpoints — Conv 112
- Fixed stale `DISCOVER_LINKS` in `route-api-map.mjs` for Conv 111 consolidation — Conv 112
- Documented Chrome MCP image dimension limits + PLATO snapshot strategy in BROWSER-TESTING.md — Conv 112
- Created PR #26 (jfg-dev-11 → staging) for client review — Conv 113
- Installed `gh` CLI on MacMiniM4 (v2.89.0) — Conv 113
- Diagnosed CF Pages build failure: Astro 6 + `@astrojs/cloudflare@13` targets Workers, not Pages — Conv 113
- Deployed temporary `postbuild` script (`scripts/fix-pages-wrangler.mjs`) to staging — patches adapter-generated wrangler.json to pass Pages validation — Conv 113
- Documented Astro 6 + Pages incompatibility in `docs/reference/cloudflare.md` — Conv 113

## Phase 2a Follow-ups

- [ ] Drop `_locals` parameter from `getEnv`/`getDB`/`getR2` helpers in a dedicated sweep commit (Fork 2 = X deferral from Conv 101; ~130 call sites) — task [DL] *(Conv 107: investigated, `locals` param is actively used for `__testEnv` injection — not dead code. The `_locals` unused-parameter version does not exist. Task reframed: the sweep would remove the parameter from production call sites where `__testEnv` is never passed, but this is low-value.)*
- [ ] End-to-end validate `npm run dev:staging` with `CLOUDFLARE_ENV=preview` against remote staging D1/R2 — task [DV] *(folded into PLATO testing phase)*

## Phase 2b — TypeScript 5→6 (deferred, ecosystem gap) — task [T6]

*Blocked by peer deps — Astro 6 vendors `tsconfck` pinned to TS ^5.0.0; `@astrojs/check` and `@typescript-eslint/*` not yet TS 6 compatible. TS 6.0.2 is a "bridge release" toward the TS 7 native rewrite.*

- [ ] Criteria to revisit: `npm ls typescript` shows no "invalid peer" markers for `@astrojs/check`, `@typescript-eslint/*`, and Astro-vendored `tsconfck`
- [ ] typescript 5.9.3 → 6.x
- [ ] Fix type errors surfaced by TS 6
- [ ] Run full five-gate baseline

## Phase 6 — Cleanup + PR merge — task [P6]

- [x] Verify five-gate baseline on final commit (tsc / astro check / lint / test / build) — Conv 106
- [x] Update any remaining docs referencing old versions — Conv 106 (3 "Astro 5.x" → "Astro 6.x" refreshes)
- [x] ~~Add ESLint rule or `/w-codecheck` grep check enforcing: no direct `locals.runtime?.env?.*` access outside helper files~~ — implemented as `/w-codecheck` grep rule (Conv 107), not ESLint
- [x] ~~`gh pr create jfg-dev-10up → jfg-dev-9`~~ — **Superseded (Conv 108):** `jfg-dev-10up` promoted to latest working branch; no merge back to `jfg-dev-9`
- [x] Fix all remaining E2E failures (4 pre-existing: login race, browse-enroll redirect, admin-overview, session-completion-flow rewrite) — Conv 108 (137/137 passing)
- [x] PLATO manual testing — flywheel all 14 intents verified (Conv 108); Stripe checkout required manual user intervention (known limitation — Chrome MCP can't interact with external Stripe pages)
- [x] Post-PLATO: five-gate baseline + E2E full pass — Conv 108 (tsc 0 / lint 0 / tests 6399/6399 / build / E2E 18 passed)
- [x] Browser smoke test of /discover/members — Creator filter, multi-role, search, All Members all verified — Conv 112
- [x] Staging smoke test: `npm run dev:staging` end-to-end validate against remote staging D1/R2 — before final staging merge — ✅ verified Conv 146 (seed-feeds are always fresh on each invocation; Smart feeds consistent with decay parameters)

## Codecheck Rule Follow-ups (discovered Conv 105 during [HW])

- [x] **[SF]** /w-codecheck rule: detect "error-captured-never-rendered" — grep-based check for `setError` without render. Implemented Conv 107. ([HD2] AST detector assessed as disproportionate — grep sufficient.)

## Test Hardening Follow-ups (discovered Conv 102)

*Surfaced during the `json<T>` sweep and pre-existing failure root-cause. Picked up opportunistically.*

- [x] **[AM]** Fixed `isSlotWithinAvailability` midnight-spanning bug — added `windowToUtc()` helper that advances end date by 1 day when `endTime <= startTime`. All 85 availability + 606 session tests pass — Conv 107
- [x] **[TT]** Swept `Date.now()+Nh` fragility in 5 high-risk test files — migrated to shared `futureUTC(days, utcHour)` helper in `tests/helpers/dates.ts`. 606/606 session tests pass — Conv 107
- [x] **[DH]** Dead helper audit — deleted 5 unused functions (`getResponseJSON`, `expectSuccess`, `expectError`, `expectJSONResponse`, `expectRedirect`) + `APIErrorResponse` interface from `api-test-helper.ts`, updated re-export index — Conv 107
- [x] **[VS]** Created `npm run verify` composite script chaining all five gates (`typecheck && check && lint && test && build`) — Conv 107

## ESLint v10 Post-Upgrade Gotcha (surfaced Conv 143)

**Breaking change:** ESLint v10 treats unknown rules in `// eslint-disable[-next-line]` directives as **hard errors** (in v9 they were silently ignored). This means any disable comment referencing a rule whose plugin isn't registered in `eslint.config.js` will fail the lint gate with `"Definition for rule 'X/Y' was not found"`.

**How it surfaced:** Phase 5 (Conv 104) bumped `eslint ^9.39.4 → ^10.2.0`; the same conv's `[LD]` drift cleanup removed 1 stale `eslint-disable` directive as part of the transition. Conv 143 later registered `eslint-plugin-react-hooks@^7.1.1` as part of `[LE]` and discovered pre-existing `react-hooks/exhaustive-deps` disable comments that v10 had been failing hard on (`"Definition for rule 'react-hooks/exhaustive-deps' was not found"`). Registering the plugin made Conv 143 dual-purpose: it activated the intended `rules-of-hooks: error` / `exhaustive-deps: warn` *and* cleared the lint errors v10 had been rejecting.

**Pattern for the next ESLint major-version bump:**
1. List disable directives referencing non-core rules:
   ```bash
   cd ../Peerloop && grep -rn "eslint-disable" src/ | grep -v "no-unused\|@typescript"
   ```
2. Cross-check each referenced rule/plugin against the registered plugins in `eslint.config.js`.
3. For each mismatch, either register the missing plugin or delete the now-dead disable comment.
4. Run `npm run lint` — clean exit is the only acceptable post-bump state; unknown-rule errors are hard gates, not warnings.

**Cross-reference:** `docs/reference/DEVELOPMENT-GUIDE.md §"ESLint Configuration (Conv 143)"` — plugin registry + effective-config check (`npm run lint -- --print-config <file>`).

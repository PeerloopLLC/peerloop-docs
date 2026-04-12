# Timeline

Significant milestones, choices, and inflection points. For full decision rationale, see `docs/DECISIONS.md` and `DOC-DECISIONS.md`. For session detail, see `docs/sessions/`.

Ref column: `S###` = Session (pre-Conv era), `###` = Conv, `—` = predates session tracking.

---

## 2025-Dec

| Date | Ref | Event | Rationale | Concerns |
|------|-----|-------|-----------|----------|
| 16 | — | Vitest (CLI-only) + Playwright chosen for testing | Vitest GUI unreliable; Playwright has good Astro support | |
| 26 | — | Tech stack locked: Astro + React islands + TailwindCSS + Cloudflare (Pages/D1/R2) | SSG/SSR with selective hydration; edge-native | |
| 26 | — | Custom JWT auth chosen over Clerk | Clerk has Astro+Cloudflare Pages compatibility issues | |
| 26 | — | Three-nav architecture + role switching via dropdown | Core navigation pattern for all roles | |
| 28 | — | Three-layout system (Landing, App, Admin) | Clean separation of public, authenticated, and admin UX | |
| 28 | — | 4-layer data fetching architecture (SSR cached → CSR overlay → SSR auth → hybrid admin) | SEO + performance + personalization | |
| 29 | — | D1 as canonical data source; soft delete; INSERT OR IGNORE for idempotent migrations | Foundation data layer decisions | |
| 29 | — | Stripe Connect chosen for payments (85/15 split) | Marketplace payout model fits learn-teach-earn flywheel | |

## 2026-Jan

| Date | Ref | Event | Rationale | Concerns |
|------|-----|-------|-----------|----------|
| 19 | S001 | Stream.io feed operations: server-side proxy pattern | API secret never exposed to client; business logic enforcement | |
| 20 | S009 | BigBlueButton chosen for video; Stream.io for feeds | Two major external dependencies locked in | BBB managed hosting; Stream flat-feed limits discovered later |
| 23 | S069 | Blocks VIDEO through NAVIGATION complete (8 blocks in 2 weeks) | All core features functional end-to-end | Pre-onboarding, pre-polish |
| 28 | S135 | SSR testing: extract to `src/lib/ssr/` testable functions | 17 pages had untestable D1 queries in Astro frontmatter | |
| 28 | S135 | Test DB excludes seed data — tests control own data | Seed data caused count mismatches and flaky assertions | |
| 29 | S145 | Dashboard-as-homepage; CurrentUser global state architecture | Unified landing for all roles; cross-island communication | Significantly expanded Conv 013-024 |

## 2026-Feb

| Date | Ref | Event | Rationale | Concerns |
|------|-----|-------|-----------|----------|
| 02 | S161 | User role system: capabilities (can_*) + course relationships; Permission vs State distinction | Separates admin-controlled flags from derived roles | ~926 column renames planned |
| 04 | S181 | Community/Feed 1:1 mapping; Progressions chain (Community → Progression → Course) | Defines content hierarchy and discovery model | |
| 05 | S190 | Migration architecture: production-safe split seeds (migrations/ vs migrations-dev/) | Production never gets test data; blocked commands for safety | |
| 16 | S220 | Cloudflare Pages + D1 deployment strategy locked in | Edge-native hosting | |
| 20 | S229 | Docs-primary Claude Code architecture (dual-repo established) | Separation of code from docs/planning; CC home in docs repo | Two repos to keep in sync |
| 22 | S252 | ONBOARDING complete — personalized recommendations (80/20 category-to-tag scoring) | First ML-adjacent feature; explicit onboarding intent signal | |
| 27 | S298 | E2E test suite expanded: 4→24 files, 19→94 Playwright tests | First comprehensive browser-level coverage | |

## 2026-Mar (Sessions)

| Date | Ref | Event | Rationale | Concerns |
|------|-----|-------|-----------|----------|
| 01 | S317 | BROKENLINKS: 42 stale routes fixed, 20 new pages created | First systematic route audit | |
| 01 | S319 | Resend domain `send.peerloop.com` verified | Production email capability unlocked | |
| 05 | S325 | Session booking flow target design established | Defines core learn-teach-earn UX | Complex multi-step flow |
| 05 | S346 | GLOSSARY.md as terminology source of truth; ~960 files, ~5000 replacements | Largest rename in project history; identity hierarchy formalized | |

## 2026-Mar (Convs)

| Date | Ref | Event | Rationale | Concerns |
|------|-----|-------|-----------|----------|
| 10 | 001 | Conv numbering replaces Sessions; Skills 2 migration (11 skills converted) | New workflow infrastructure | |
| 17 | 002 | UTC timezone normalization — `timezone.ts` library created | Fixed fundamental time representation bug | Per-user tz deferred (EMAIL-TZ) |
| 17 | 004 | Session Invite feature (teacher-initiated "Book Now"); CD-037 closed | First RFC fully closed | |
| 18 | 010 | DATE-FORMAT decision — canonical UTC ISO 8601 everywhere (130+ files) | Eliminates timezone ambiguity | Breaking during 5-phase migration |
| 19 | 015 | FEED-INTEL Phase 1: CQRS pattern (Stream writes, D1 reads) | Stream can't do cross-feed queries or unread counts | New data layer alongside Stream |
| 19 | 017 | SMART-FEED: ranked personalized feed with discovery pipeline | Hybrid D1 → scoring → Stream → diversity | 13 tunable params; needs usage data |
| 24 | 027 | SQLite `datetime()` vs ISO comparison bug discovered and fixed | Silent: space < T in ASCII made time-window queries return all rows | Added CLAUDE.md rule + codecheck lint |
| 28 | 048 | TAG-TAXONOMY: categories → topics, topics → tags, multi-tag courses | Rebuilt 3-table taxonomy across ~180 files | App non-functional during 6-phase migration |
| 29 | 055 | ADMIN-INTEL: contextual admin intelligence on member-facing pages | Admins see actionable data in-context vs switching to /admin | 85 tests, 6 phases |
| 31 | 062 | PLATO: learn-teach-earn flywheel validated end-to-end (11 API runs) | Core business model proven in code | Browser tests deferred |
| 31 | 066 | PLATO-SCENARIOS: API-driven seed data replaces SQL seeds | 10 actors, 6 courses via API chains + SqlTopUp enrichment | SQL and API seeds coexist |

## 2026-Apr

| Date | Ref | Event | Rationale | Concerns |
|------|-----|-------|-----------|----------|
| 06 | 086 | TIMELINE.md created for milestone tracking | Automated via /r-end learn-decide agent | Backfilled from project history |
| 06 | 087 | STUMBLE-AUDIT: 4 systemic error-handling patterns fixed across ~60 endpoints; `parseBody<T>()` utility | Malformed JSON → 500 eliminated; dashboard logging; OAuth null guards; batch transactions | |
| 06 | 088 | STUMBLE-AUDIT complete (Conv 067-088); remnants deferred to STUMBLE-REMNANTS block | 22-conv audit block closed cleanly; 10 remaining items tracked with cross-references | |
| 06 | 089 | getNow() sweep: 22 server files migrated + lint-timezone.sh enforcement | Clock abstraction existed since Conv 003 but only 4 files used it; lint rule prevents future drift | ~20 legitimate uses need `// getNow-exempt` comments |
| 06 | 091 | lint-timezone.sh promoted to CC PreToolUse hook; DEV-WEBHOOKS.SCRIPTS + DATA-ALIGNMENT | Hook gates Claude commits; webhook trigger/orchestrator scripts for dev testing | Human commits remain ungated |
| 06 | 092 | BBB-VERIFY expanded to STAGING-VERIFY: unified staging integration tests for Stream, Resend, Stripe, BBB | All external services share same testing pattern; plus-addressed email capture for Resend | New PLAN block needed |
| 07 | 094 | First Chrome MCP browser walkthrough; `BROWSER-TESTING.md` reference doc created | New testing capability: exploratory browser testing via MCP complements Playwright CI tests | Non-deterministic; token-expensive |
| 07 | 095 | KV bindings removed from codebase; feature flags noted Post-MVP #19 | KV provisioned Session 215 but never used; adapter tolerates missing binding | Re-add post-launch if feature flags need KV |
| 07 | 095 | PLAN.md major restructure: 7 amalgamations, 44→19 deferred entries (46% line reduction) | Periodic consolidation essential; related blocks scattered across months of discovery | All detail preserved in git history |
| 07 | 095 | ESCROW moved to Post-MVP; SESSION-CREDITS to Post-MVP | Zero implementation; current immediate-transfer flow works | Client must re-vest post-launch |
| 07 | 096 | PACKAGE-UPDATES block: 6-phase upgrade plan for 24 outdated packages (Astro 6, TS 6, Zod 4, Stripe 22) | Phased approach isolates regressions; Astro+TS+adapters grouped by coupling | Cloudflare adapter v13 may affect D1/R2 bindings |
| 10 | 098 | `Doc:` and `Infra:` commit tags cleanly separated across r-commit, r-end, r-timecard-day | Clean split easier to follow than fuzzy boundary; r-end commits now primary source of Doc: lines | Generation vs extraction must stay in sync |
| 10 | 099 | Skill-sync sweep: w-sync-skills DIRECTION block, w-sync-docs +Schema/+Cross-Doc audits, r-timecard `Doc:` extraction closing Conv 098 reader gap | Writer/reader tag contract now symmetric; sync-skills self-validated in-session | PLAN status-drift detector still missing |
| 10 | 099 | PLAN.md PACKAGE-UPDATES status corrected: "🔥 IN PROGRESS (Conv 096)" → "📋 PLANNED" | Block was never actually started despite 3 convs of misleading marker | Next conv begins PU with clean expectations |
| 10 | 100 | Durability principle codified: favour durable decisions over faster options (project-wide guiding directive) | Anchored verbatim from user to Stripe apiVersion bump decision; default framing for all future trade-offs | |
| 10 | 100 | PACKAGE-UPDATES Phase 1 landed on `jfg-dev-10up`; Stripe apiVersion `2025-12-15.clover` → `2026-02-25.clover` + 3 call sites consolidated to `getStripe()` | Within-semver bumps clean; pinning old Stripe API is debt not stability | |
| 10 | 100 | Phase 2 split: Astro 6 + `@astrojs/cloudflare@13` + `@astrojs/react@5` proceed (2a); TypeScript 5 → 6 deferred (2b) | Astro vendors `tsconfck` pinned to TS ^5; TS 6 ecosystem hasn't caught up | Revisit TS 6 when `npm ls typescript` shows no invalid peer lines |
| 10 | 100 | Centralize Cloudflare env access refactor committed (`5284708`, 106 files); `locals.runtime?.env` access removed from application code | Preparatory refactor decouples pattern change from adapter v13 bump; independently valuable | |
| 10 | 101 | PACKAGE-UPDATES Phase 2a landed: Astro 5→6, `@astrojs/cloudflare` 12→13, `@astrojs/react` 4→5, Vite 6→7 | 6399/6399 tests passing, clean build, React 19 `server.edge` workaround removed as fixed upstream | `dev:staging` not yet exercised against remote D1/R2 |
| 10 | 101 | `cloudflare:workers` virtual module adopted as canonical env source; `__testEnv` introduced as test-injection slot on `App.Locals` | Adapter 13 removes `locals.runtime.env`; Conv 100 centralization reduced blast radius to 5 files | |
| 10 | 102 | ts-morph added as devDep; `.json() as any` codemod migrated 1,587 sites across 198 test files to `json<T>(response)` | Uniform mechanical pattern (100%) handled faster + more consistently than parallel subagents; single bisectable commit | Codemod template at `scripts/codemods/migrate-test-json-as-any.ts` |
| 10 | 102 | Test/tsc/build baselines all green on `jfg-dev-10up` for the first time (6399/6399, 0 tsc errors, 6.98s build) | 5 pre-existing session-creation failures root-caused (time-fragile `Date.now()+Nh` crossing UTC midnight) and fixed via `futureAt()` helper | Broader `Date.now()+Nh` fragility sweep tracked as [TT]; midnight-spanning app bug tracked as [AM] |
| 10 | 102 | Baseline-verification rule codified: RESUME-STATE test/tsc/build numbers must come from commands run in the current conv | Conv 101 → 102 evidence: 5 failing tests lurked silently because baselines were copy-forwarded without re-verification | |
| 11 | 103 | Reporting timecards become branch-aware: `/r-timecard-day` detect-and-prompt + `/r-timecard conv=` silent `--branches` union; new Branch column in Git History tables | Apr-10 run silently dropped 4 of 10 code commits because all lived on long-lived `jfg-dev-10up` while HEAD was `jfg-dev-9` — billing-accuracy bug | `/r-timecard cNdN` count mode left HEAD-only by design; latent footgun on wrong branch |
| 11 | 104 | Baseline check set expanded 3 → 5 gates: `tsc + astro check + lint + test + build`; `npm run check` added to CI, /w-codecheck, CLAUDE.md, BEST-PRACTICES.md, memory | `tsc --noEmit` never scans `.astro`; 10 hidden errors surfaced on first /w-codecheck this conv; Conv 100–103 "clean baselines" retroactively incomplete | Older session-doc baseline claims should not be cited as authoritative |
| 11 | 104 | PACKAGE-UPDATES Phases 3–5 landed: Zod 3→4, Stripe SDK 20→22 (apiVersion `.clover`→`.dahlia` + same-conv changelog audit), better-sqlite3 11→12, eslint 9→10, jsdom 27→29 | Phased bumps isolated each regression; Stripe audit documented in `docs/reference/stripe.md` as template | TS 5→6 still deferred as [T6] |
| 11 | 104 | First fully clean five-gate baseline on `jfg-dev-10up`: tsc 0, astro 0, lint 0/0, tests 6399/6399, build 6.70s | [AC]/[AH] fixed 10 astro errors + 27 hints; `CourseTag` consolidated (junction → `CourseTagRow`, display shape canonicalized); `initialTab` widened to `TabId \| (string & {})` | Half-wired `setActionLoading` + CourseEditor error/success UI flagged [HW] |
| 12 | 108 | PLATO browser-mode flywheel walkthrough: all 14 learn-teach-earn intents verified via Chrome MCP | First browser-mode end-to-end proof of flywheel; confirms Mara (creator) → Alex (student→teacher) path works in real UI | Stripe checkout requires manual intervention; Chrome MCP can't interact with external Stripe pages |
| 12 | 108 | E2E suite fully passing: 137/137 tests after schema fixes and spec rewrites | Three schema mismatches (primary_topic_id, student_id rename, teacher_id fix) corrected; 18 files changed | |
| 12 | 108 | `jfg-dev-10up` promoted as latest working branch; `jfg-dev-11` created from it | 32-file divergence (schema changes, E2E rewrites) made merge to jfg-dev-9 impractical; staging is eventual target | |

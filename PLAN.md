# PLAN.md

This document tracks **current and pending work**. Completed blocks are in [plan/COMPLETED.md](plan/COMPLETED.md).

The `plan/` subdirectory holds per-block plan files for large blocks. Currently migrated:
- **MATT family** — `plan/matt/` (README + per-phase files + cutover + standin-matt). Phases 1–4.5 ✅; Phase 5 🔥; Phase 6 → ongoing; Phase 7 pending. Cutover ✅ shipped Conv 197.

Other named blocks still live inline below; per-block extraction happens incrementally as each block needs attention.

---

## Block Sequence

### ACTIVE

| Block | Name | Status |
|-------|------|--------|
| MATT-DESIGN-PUSH | Matt Design System — tokens, shell, primitives, page conversion, doc graduation | 🔥 IN PROGRESS — **Phase 5** (course-tab family ✅ Convs 188-190; Enroll + Session families + 5 other routes pending). Phases 1–4.5 ✅ (13/13 Matt-named primitives + per-icon viewBox + Course In Feed re-render Conv 187). Phase 6 → ongoing per-page; Phase 7 pending. → [plan/matt/README.md](plan/matt/README.md) |
| NAV-RETROFIT | Legacy→Matt incremental migration — retrofit legacy shell onto Matt's design | 🔥 IN PROGRESS (Conv 191, demo-driven). **Root cause found ([DEMO-HOME]):** Conv 174 added `@import tokens-tailwind-bridge.css` to `global.css`; the bridge's `@theme` `--spacing-*` block aliases Tailwind's numeric scale to Matt's literal-px scale (`--spacing-64: var(--space-64)` = 64px), silently shrinking EVERY legacy spacing utility in the set {4,8,12,16,20,24,32,40,48,64} ~4× app-wide since Conv 174 (`w-64`→64px, `h-4`→4px). Tests never caught it (CSS not unit-tested); `/matt` unaffected (uses arbitrary `[Npx]` + bare numerics that EXPECT Matt's scale). **Strategy (user decision):** `/matt` is the final design destination — do NOT revert the override (would break `/matt`); instead migrate legacy components ONTO Matt's design incrementally. **Approach B chosen** (restyle legacy in place, preserve behavior; approach A = swap to Matt components, possibly later). **Conv 191 DONE — AppNavbar step 1 + bidirectional demo bridge:** `<aside>` `w-64`→`w-[220px]` + `AppLayout` main `lg:ml-64`→`lg:ml-[220px]`; rows restyled to Matt (`text-body-medium-bold` label + 12px `text-body-small` desc via `line-clamp-2`, `gap-[12px]`, brand-blue flat "Selected" active — white pill deferred until grey shell); chevrons `h-4 w-4`→`size-[16px]` (Discover + user item + dropdown close); both slideouts (`DiscoverSlidePanel`, `UserAccountDropdown`) `left-64`→`left-[220px]`. Bidirectional nav: AppNavbar "New Design"→`/matt/` (top item, SparklesIcon); Matt `Sidebar.tsx` NAV+COLLAPSED_NAV "Classic App"→`/` (arrow-left, marked **TEMP demo bridge** for easy removal). Round-trip verified in Chrome bridge; all 5 gates green (tsc/check 1264 0/0/0/lint/test 6453/build 6.43s). **Conv 191 follow-up — 3 View-Transition regressions found+fixed via the / → New-Design → Classic-App round-trip** (all DOM-verified, NOT screenshot — see `feedback_dom_truth_over_screenshots.md`): (1) navbar items bunched (island-unique `py-[10px]` dropped when /matt CSS swapped in → standard `gap-3/px-2/py-2.5/p-3`); (2) Messages quick-action card vanished (inline reveal `<script>` doesn't re-run on VT → bound to `astro:page-load`); (3) Discover/User slideouts behind navbar (island-unique `left-[220px]` dropped + a **duplicate-`style` JSX bug** that silently dropped the first fix → merged into single inline `style`, DOM-confirmed left:220 flush + on-top). Sweep: only `index.astro` had a VT-fragile inline script; AdminNavbar shares the bug class (admin-only, [NAV-SIBLINGS]). **Conv 192 — home-page spacing fixes + [LEGACY-SPACING-AUDIT] resolved (do-nothing-broad):** Fixed the home footer (`Footer.astro` full + compact variants — 7 hijacked-step utilities → arbitrary px `py-[48px]`/`px-[16px]`/`lg:px-[32px]`/`gap-[32px]`/`pt-[32px]`/`gap-[16px]`/`mt-[16px]`) and the dashboard main panel (`index.astro` — icon containers + clock `h-12 w-12`→`h-[48px] w-[48px]` were clipping 24px glyphs to 12px boxes; `mb-8`→`mb-[32px]`, `gap-4`→`gap-[16px]`, `mb-4`→`mb-[16px]`, `py-8`→`py-[32px]`), both DOM-verified in Chrome bridge. **[LEGACY-SPACING-AUDIT] quantified + decided:** override hijacks **3,894** utilities across **354 legacy files** vs only **11 `matt/` files** that depend on the new meaning — asymmetry would justify reverting, BUT user chose **do-nothing-broad / fix per-component as legacy→Matt conversion reaches each** (the mechanical sweep would be thrown away by the migration; reaffirms Conv 191 "don't revert"). Remediation recipe per component: convert hijacked-step utilities to arbitrary `[Npx]`. **Conv 193 — AdminNavbar retrofit + both-nav icon swap; group #4–#8 resolved.** **[NAV-SIBLINGS] narrowed to AdminNavbar-only + DONE** (Decision: AppHeader excluded — speculative, never client-reviewed, public-facing visitor→member surface most likely to be redesigned; MoreSlidePanel deferred → new [MSP-COUPLING]): AdminNavbar un-broke 9 hijacked-step spacing utils (avatars `h-8`→`size-[32px]`, header `h-16`→`h-[64px]`, paddings `p-4`→`p-[16px]`, etc.) + rail `w-64`→`w-[220px]` + coupled `AdminLayout` `lg:ml-64`→`lg:ml-[220px]` + content padding + stale docstring; dark theme kept. **[NAV-ICON-SWAP] DONE** (user directive: match from Matt43 ∪ Material Design icons, dashed-border any unmatched): probed both navs' icon inventories + Matt's 43-set — Matt's set is product-oriented (no nav-chrome/admin-tooling glyphs), so ~half the nav icons had no Matt equivalent; harvested 10 Material-outlined icons (menu, search, admin-panel-settings, chevron-right, group, label, assignment, videocam, warning, person-add) via curl from the marella mirror into the MattIcon registry (**43→53**, fills normalized to `currentColor` — MattIcon wrapper is `fill="none"` so harvested paths MUST carry explicit fill); swapped BOTH AppNavbar + AdminNavbar to MattIcon; removed legacy `@components/ui/icons` imports from both; zero dashed-border cases (Material covered every gap); all 21 referenced names validated to resolve to real files; provenance documented in MEMORY.md. **[LEGACY-SPACING-AUDIT] recipe applied** to AdminNavbar (the per-component remediation form, as decided Conv 192). **[NAV-APP-A] deferred — continue approach B** (approach-A component swap would moot #4/#5 work; matches standing Conv 191 decision). **[VTPRD] DROPPED** (no recoverable scope — deleting beat guessing). VT-drop learning: arbitrary utilities are safe within a route family (AdminNavbar persists only admin→admin, every admin route generates its classes) — only cross-family island-unique arbitrary utilities (Conv 191 slideout offsets) need inlining. Baselines: tsc 0; astro check 1271 0/0/0; lint; build. **NOT visually verified** — both navs auth-gated; mechanism proven (harvested `menu` icon renders in real SSR output, zero placeholders) but logged-in look unconfirmed. AppHeader intentionally NOT retrofitted (speculative public surface). **Conv 194 — both Conv 193 PENDING items closed + 1 latent bug fixed + 1 new bug found.** **[MSP-COUPLING] RESOLVED by deletion** — live-DOM check showed `MoreSlidePanel.tsx` is dead code (superseded by `UserAccountDropdown`, zero consumers); every feature has a home (dark-mode + Help + Settings in UserAccountDropdown; Privacy in Footer); deleted file + barrel export + stale `AppLayout.astro` comment (incl. 256px→220px rail drift). **[LH-VERIFY] DONE** — both navbars visually verified in Chrome bridge: AppNavbar (Guy session, 220px rail @left:0, 0 dashed icons, slideouts at left:220) + AdminNavbar (Brian session, 220px rail, main margin-left:220px, 15 MattIcons, 0 dashed, 14 links; flat-list by design, no slide-out). **[MPB] FIXED** — AppNavbar slide-out panels (`DiscoverSlidePanel` + `UserAccountDropdown`) bled ~220px over content below `lg` (closed `-translate-x-full` from left:220 was only occluded by the rail, not truly off-viewport; rail goes off-canvas below lg, exposing them); fixed with self-sufficient inline closed-transform `translateX(calc(-100% - 220px))` (viewport-independent, survives VT swaps) in both panels. **NEW BUG [ADMIN-REDIRECT-BLANK]** — authenticated non-admin hitting `/admin/*` gets a blank 15-byte 200 instead of redirect to `/`; clean dev restart falsified the optimize-deps hypothesis; mechanism unexplained (why `AdminLayout` line 37 `Astro.redirect('/')` yields blank 200 while line 34 `/login` redirect yields clean 302) → deferred to DEFERRED #27. Also confirmed [CRS-MOBILE] + course-page entity-vis audit (no issues; see those subtasks). Branch `jfg-dev-13-matt`. |
| MATT-CUTOVER | Make Matt the primary app — provenance attribution + route flip | 🟢 SUBSTANTIALLY COMPLETE — Conv 197 [PROV] + [ROUTE-FLIP] both done (43 legacy pages → `/old/`, 9 Matt → root, namespace dissolved); Conv 198 post-flip doc reconciliation; Conv 199 [PROV-SWEEP] + [PROV-MATCH]. Remaining: [PROV-MATCH-AUTO] (Figma-matching automation). → [plan/matt/cutover.md](plan/matt/cutover.md) |
| ROUTE-MIGRATION | Forward-migrate legacy `/old/*` flows onto the new root routes (post-ROUTE-FLIP) | 🔥 IN PROGRESS (Conv 201). **Context:** Conv 197 [ROUTE-FLIP] moved legacy flows to `/old/*` and promoted Matt pages to root, but per user decision there is **no redirect layer** — unbuilt root routes 404. The legacy infra (middleware prefixes, `/login` redirect target, ~30 component hrefs) still pointed at the old root paths, breaking auth app-wide. User strategy (manual-programmer sequence): **(1)** wire the minimum to make the app usable (login/logout/home); **(2)** stub every main-nav menu item at root; **(3)** verify the minimal app works; **(4)** convert `/old/*` pages → new routes one at a time, retiring `/old` incrementally. **Phases 1–3 DONE + browser-verified (Conv 201):** [RTMIG-1] `/login`+`/signup` promoted to root (reuse `AutoOpenAuthModal`, new `AppLayout`, redirect authed→`/`); `AuthModalRenderer` re-homed into `AppLayout` (was mounted only in legacy AppNavbar → modal dead app-wide after flip); post-login default `/dashboard`→`/` in `auth-modal.ts`; root `/` confirmed canonical Home (former `/matt/index`, stale "stub" comment corrected). [RTMIG-2] honest stubs for the two missing nav routes `/earnings` + `/profile` (AppLayout+SubNav+empty-state pattern from Conv 193); `/earnings` added to middleware `PROTECTED_EXACT`. [RTMIG-LOGOUT] logout button wired into `/profile` (deferred here from Phase 1 per decision A). [RTMIG-3] full nav status sweep = zero 404s (public 200 / protected 302→login); live-verified login→home→logout + protected-route redirect with `returnUrl` round-trip. [RTMIG-SIGNUP] `/onboarding` promoted to root (thin port reusing `OnboardingProfile`; post-signup landing was 404ing same dead-route class); full signup→account→`/onboarding` happy-path browser-verified (real topic-picker renders). All bugs fixed were string-valued route refs invisible to `tsc` — only the browser caught them. Gates: astro check + tsc 0 errors. **Conv 202 — pre-flip reference env stood up + deep-link fix RETIRED + [RTMIG-4] gap analysis → RESCOPE NEEDED.** The live branch can't browse legacy `/old/*` look+behavior (deep nav links lack the `/old/` prefix → 404 by design, since there is no redirect layer). Considered three in-branch patches (client-side href rewrite / `basePath` prop threading / middleware 404→`/old` fallback) and **rejected all** — the middleware fallback in particular would silently mask the very 404s that are RTMIG's verification signal. Chosen durable solution: **a pre-flip git worktree as a zero-debt reference environment** ([PREFLIP-WT]). `git worktree add ~/projects/Peerloop-preflip 846bab9f^` (detached HEAD `608346a2`, the parent of the Conv 197 ROUTE-FLIP commit — `/matt` present, `/old` absent = genuine pre-flip app); copied `.dev.vars`, recreated `.env` symlink, `npm install`, `npm run db:setup:local:dev`, `npm run dev -- --port 4331`. /chrome bridge confirmed port/URL-based (directory-agnostic) → :4321 live + :4331 reference coexist and are both fully browsable; toured the legacy app logged-in as admin (Dashboard/Discover/Course/Messages/Learning/Admin). User declared the worktree **satisfies all requirements of the proposed `/old` deep-link fix → retired that need entirely**. Reproduction tooling: `peerloop-ref` shell alias (machine-local), committed idempotent bootstrap `scripts/setup-preflip-ref.sh` (worktree add + .dev.vars copy + install + seed + append alias) for M4Pro, named folder `Peerloop-preflip (:4331 ref)` added to `peerloop.code-workspace` (travels via git), memory `project_preflip_worktree_reference.md`. **[RTMIG-4] gap analysis (RESCOPE NEEDED next conv):** ~90 `/old` pages have NO root equivalent; Matt designed only **9** pages and they're **already at root** (moved by ROUTE-FLIP). So RTMIG-4 is fundamentally a *routing migration of legacy pages*, NOT a build-to-Matt-design (can't be, without blocking on 90 nonexistent designs; Matt redesign is the separate later MATT-EXEC-*/MMP-* track). The open methodology fork is which *shell* legacy bodies land in at root: **(A)** port legacy body into Matt shell `@layouts/AppLayout.astro` [CC recommended, follows Conv 201 root pattern], **(B)** port legacy as-is with the legacy shell, **(C)** migrate only the Matt-designed pages. 90 pages × an unresolved A/B/C fork is too coarse for one task → user stopped before any code; decompose + resolve the fork at the start of the next conv. **Conv 203 — RTMIG-4 fork RESOLVED = A + Home recreated as the pilot + route-honesty hardening + Home-slice primitives.** **Methodology fork resolved = approach A** (port legacy body into Matt shell): consistent nav everywhere, follows the Conv 201 root pattern; Home was never a real Matt design (only a shell preview) so it's A-by-nature. **Home port complete (RTMIG-4 pilot):** `src/pages/index.astro` rebuilt from the `/old` dashboard inside the Matt shell (header + OnboardingNudgeBanner + 2 ActionCards + Recent-Activity EmptyState + auth-reveal script); browser-verified. Per-page loop established: build in Matt shell → middleware PROTECTED_PREFIXES + hrefs → repoint e2e → browser-verify vs :4331 → retire `/old` copy. **Route-honesty hardening (Decision: links to unconverted pages must 404 — no resolving placeholder stubs):** deleted 6 placeholder routes (`/saved` `/todo` `/teachers` `/earnings` `/notifications` `/messages`) so links 404 honestly; removed Peer Teachers + Earnings from Sidebar NAV/COLLAPSED_NAV; kept `/teachers/[handle]` as StudentTeacherAnchor target; functional real-data `/courses` retained; memory `project_route_404_honesty_standin.md`. **Primitives showcase archived** `/` → `/dev/primitives` (+ `/dev/saved` + `/dev/todo` dev mirrors, dev subnav trimmed to Overview/Saved/To-Do); Decision: page owns its own SubNav (slot-based opt-in — structural, not new). **New `@stand-in` transient provenance marker** on 7 pages (login, signup, onboarding, profile, courses, course/[slug]/[...tab], teachers/[handle]) — "not ours, not Matt, stand-ins to redesign"; greppable, NOT formalized in prov-sweep (self-erasing at retrofit; `grep -rl '@stand-in' src/pages` = remaining-retrofit counter). **Home-slice MATT-EXEC-EXT primitives built** (#7 EXT slice done): new `EmptyState.astro` (+retrofit `/dev/saved`) + `ActionCard.astro` (both registered in prov-candidates `PHASE6_EXTRAPOLATION_CANDIDATES`, unmarked=ours), harvested Material `clock.svg` (icon-provenance entry), restyled `OnboardingNudgeBanner` to Matt (MattIcon + tokens + Button). **Fixed a latent prov-sweep bug** (4c untracked-note check read only COMPONENT_CANDIDATES, not PHASE6 → false UNTRACKED on the new primitives; fixed by unioning both arrays). Gates green (tsc/astro check/prov-sweep/route-map); route map regenerated (109 routes). **Remaining:** [RTMIG-4] **(approach A locked; Home pilot DONE — ~89 legacy pages remain)** per-page `/old`→root conversion via the Matt-shell loop; also fix middleware PROTECTED_PREFIXES still listing root paths whose pages are under `/old`, and `/profile`→`/@me` once `/@handle` routes migrate), [STANDIN-MATT] (#25 — approach A applied to the 7 `@stand-in` pages; same workstream as RTMIG-4, treat as one), [PREFLIP-M4PRO] (#24 — retrofit M4Pro worktree + `peerloop-ref` alias), [PREFLIP-WT] (remove the pre-flip reference worktree when RTMIG-4 inspection is done), [E2E-MIG] (re-point e2e to new routes incrementally), [E2E-GATE] (structural-change tier + goto-target resolver check — the five-gate baseline runs vitest only; playwright e2e is outside `/w-codecheck` + `/r-end` by construction, which is why the relocation's dead routes went undetected; diagnostic prototype at `.scratch/e2e-route-map.mjs`). **Next-conv ordering directive:** [PREFLIP-M4PRO] (#24) FIRST, [STANDIN-MATT] (#25) SECOND. Branch `jfg-dev-13-matt`. |
| BBB-RECORDING | BBB Recording Investigation — diagnose empty recordings, fix `autoStartRecording`, build account-wide diagnostic endpoint | 🔥 IN PROGRESS (Convs 159-164: [REC-LABEL] complete Conv 163; [BR-NAVBAR-HYDRATE] complete Conv 164; only [BR-STATUS] + [BR-ZERO-REPRO] deferred. [CRT] promoted to own block.) |
| CALENDAR | Platform Calendar — custom multi-view calendar component for all roles | 📋 PENDING |
| ADMIN-REVIEW | Admin System Review — testing gaps, UI consistency, cross-links, menu restructure | 📋 PENDING (promoted Conv 095) |
| PACKAGE-UPDATES | Package Version Upgrades — all dependencies current, new branch | ✅ COMPLETE (Convs 104-114, PR #26 merged into `staging`). CF Pages→Workers migration spawned as separate CF-WORKERS block and also complete. |

### ON-HOLD

| Block | Name | Notes |
|-------|------|-------|
| DEPLOYMENT | Deployment automation + prod cutover — spawned from CF-WORKERS | PAGES-DISCONNECT done (Conv 116). Staging green. Remaining: GHACTIONS, PROD, STAGING-DOMAIN. Deferred Conv 129 — no sub-block urgent. |
| INTRO-SESSIONS | Intro Sessions — free 15-minute pre-enrollment calls | Schema exists (`intro_sessions`); feature not built. Discovered in TERMINOLOGY review Session 348. |
| ~~DEV-STAGING-SSR~~ | ✅ **RESOLVED Conv 177** via `[DSSR-SCOPE]` fix | The Conv 122 root-cause hypothesis (two React copies via `@astrojs/cloudflare` 13) was wrong. Real cause: Vite cold-start dep-discovery race (industry-wide, see DEVELOPMENT-GUIDE.md § Vite SSR Cold-Start Dep Discovery). Fix: `astro.config.mjs` `vite.optimizeDeps.entries` + `include: ['astro/virtual-modules/transitions.js']`. Cold-start /matt/ now succeeds first try; production build clean (7.27s); preview /matt/ renders fully with `Sidebar.tsx` useState intact. Conv 176 stateless-primitives discipline retired. |

### DEFERRED

*Reorganized Conv 095. Previous numbering in git history.*

| # | Block | Name | Notes |
|---|-------|------|-------|
| 1 | SEEDDATA | Database Seeding & Empty State | 🟡 Nearly Complete (EMPTY_STATE deferred to POLISH) |
| 2 | POLISH | Production Readiness | Validation, roles, tech debt, security, deferred features |
| 3 | MVP-GOLIVE | Production Go-Live | Absorbs OAUTH, STAGING-VERIFY, CRON-CLEANUP, RECORDING-PERSIST |
| 4 | TESTING | Multi-User Testing | Merged: E2E-GAPS + E2E-LIFECYCLE + WORKFLOW-TESTS |
| 5 | IMAGES | Image Pipeline — uploads, management, optimization | Merged: FILE-UPLOADS + IMAGE-MGMT + IMAGE-OPTIMIZE |
| 6 | FEEDS-NEXT | Feed Enhancements — ranking, mobile, privacy, level matching, promotion | Merged: FEEDS + FEED-PROMOTION + FEED-PRIVACY + LEVEL-MATCH |
| 7 | OBSERVABILITY | Error Tracking, Analytics, Audit Logging | Merged: SENTRY + POSTHOG + AUDIT-LOG |
| 8 | CERT-APPROVAL | Certificate Lifecycle — student page, creator approval, PDF, public view | 7 admin/API endpoints built, 0 UI pages |
| 9 | PUBLIC-PAGES | Public Page Coherence — header unify, legacy cleanup, footer, personalization | |
| 10 | PAGES-DEFERRED | Deferred Pages (7) | Includes story IDs |
| 11 | RATINGS-EXT | Ratings Extensions — expectations, materials rating, display | |
| 12 | EXTRA-SESSIONS | Extra Session Purchases | Beyond course plan |
| 13 | COURSE-LIMIT | Creator Course Limit | Default 3, admin-adjustable |
| 14 | AVAIL-OVERRIDES | Availability Overrides | Schema exists; feature not built |
| 15 | EMAIL-TZ | Per-User Timezone in Emails | Requires `timezone` column on users |
| 16 | MSG-TEACHER | Message Teacher from Course Page | Messaging now open (Conv 110); needs UI button on course page |
| 17 | RESPONSIVE | Responsive & Mobile Review | Site-wide audit needed |
| 18 | ROUTE-AUDIT | Route & Sitemap Audit | Routes vs `url-routing.md`, public/auth boundaries |
| 19 | STUMBLE-REMNANTS | STUMBLE-AUDIT Remaining Items | JWT test, 2 client decisions (member_count fixed Conv 108) |
| 20 | STRIPE-E2E-DEV | Dev-Level Stripe Integration Stress Test — real browser, real Test-mode cards, real webhook tunnel | Prerequisite for go-live confidence. Conv 145 scoped. Tiered (A/B/C/D). Complements Conv 144 staging live-verification with higher-fidelity Dev-side coverage. |
| 21 | DISC-DROP | Drop `/discover`; fold its content into `/courses` in stages | Conv 204 (supersedes ~~DISC-UNIFY~~) — decided to drop `/discover` entirely and fold its sections into `/courses` rather than unify the two on one loader. **Stage 1 DONE Conv 204:** scaffold slots (onboarding-nudge / recommended / explore{tabs,filters,catalog}); `CoursesRoleTabs` (role tabs via ExploreTabBar) + `CoursesCatalog` (filters by role lens) wired via custom `courses:tabchange` event; `CoursesFilters` (level pills + topic dropdown + text search + Clear button) via `courses:filterchange`; fixed shell-wide current-user init (new `CurrentUserInit` island in `AppLayout`) + loader bug (`fetchCourseBrowseData` hardcoded `primary_topic_id:null` → authoritative `c.primary_topic_id` column). **Stage 2 + full Matt restyle DONE Conv 205 — `/courses` page is DONE:** mounted Stage 2 slots (`OnboardingNudgeBanner` + `RecommendedCourses`); removed all DEV scaffold from `courses.astro`; Matt-restyled `CoursesRoleTabs` inline (dropped shared legacy `ExploreTabBar`, kept role-color dots) + `RecommendedCourses` (MattIcon header/dismiss; legacy `CourseCard` left untouched — 5 other users). **New Matt browse card `CourseCatalogCard.tsx` composed from primitives** (no Matt catalog card exists — all Matt course cards are feed-embed ROWS; user chose "B. Matt has no card grid yet."): two variants — `stacked` (16:9 thumbnail top, grid sm:2/xl:3) + `overlay` (image backdrop + dark-scrim, RecommendedCourses band); image source = `course.thumbnail_url` (reuses Matt's `CourseHeader` 517:8934 backdrop+scrim pattern, `#1f2937` fallback); leading course icon dropped (redundant in a course list); **per-card CTA dropped → whole card is a stretched-link** (one title `<a>` + `after:inset-0`, hover lift-shadow/white-ring; verified exactly 1 anchor per card). Onboarding nudge confirmed-rendering via temporary FORCE_SHOW bypass (reverted). Browser-verified throughout; all 5 gates green this conv ([FULLBASE-204] closed: tsc/check 0/0/0/lint/build + **6452/6452 tests, 371 files**). **Remaining: Stages 3-4 BLOCKED** — the 7 other discover destinations (communities, members, leaderboard, feeds, creators, students, teachers) exist only at `/old/discover/*` with no Matt pages, and the Matt sidebar links only Home + Courses; per the 404-honesty rule sidebar links can't point at `/old/*` or nonexistent routes. User authorized breaking 404-honesty to build them. **Ownership Conv 207:** DISC-DROP owns this scope (was briefly folded into STANDIN-MATT Conv 205, reverted Conv 207). NOTE: of those 7, creators/students/teachers are already 301 redirect shims to `/discover/members?roles=X` (Conv 111 [DISC-M]) → only 4 unique pages to build (communities, members, leaderboard, feeds). Spawns [DISC-RTB-RECONCILE] (discover role-tabs vs Matt role-tab-bar slot) + [AICODING-SEED] (AI Coding topic count 3-vs-2 seed question, #29). **Cleanup debts:** (a) `RecommendedCourses` loading skeleton still light-styled while overlay cards are dark — load-state polish; (b) shared role/ratingLabel helper across `CoursesRoleTabs` / `CoursesCatalog` / `RecommendedCourses`. |
| 22 | ADMIN-REDIRECT-BLANK | Non-admin hitting `/admin/*` gets blank page instead of redirect | Conv 194 — authenticated non-admin (Guy, `is_admin=0` confirmed in D1) gets a blank 15-byte 200 on all `/admin/*` instead of a redirect to `/`. Unauthenticated `/admin` → clean 302 → `/login` (no-session branch works); authenticated non-admin → `AdminLayout` line 37 `Astro.redirect('/')` yields blank 200, NOT 302. Clean dev restart falsified the Vite optimize-deps hypothesis. **Mechanism unexplained** — why does line 37's redirect differ from line 34's (`/login`, no-session) clean 302? Needs focused investigation. |
| 23 | PREFLIP-M4PRO | Retrofit MacMiniM4Pro pre-flip reference worktree + `peerloop-ref` alias | Conv 203 — **DO FIRST next conv.** Run the committed idempotent bootstrap `scripts/setup-preflip-ref.sh` on M4Pro to stand up the `~/projects/Peerloop-preflip` (:4331) reference worktree (worktree add `846bab9f^`/`608346a2` + `.dev.vars` copy + install + `db:setup:local:dev` + append `peerloop-ref` alias). Machine-local; the reference env currently exists only on M4. |
| 24 | STANDIN-MATT | Retrofit `@stand-in` pages to Matt-style (approach A) | 🔥 IN PROGRESS — login/signup/onboarding/404 retrofitted Convs 207-208 (11 new form/UI primitives); /profile still pending (Conv 208 attempted then reverted as premature). → [plan/matt/standin-matt.md](plan/matt/standin-matt.md) |

---

## Conv 150-157 Deferred Tasks

Infrastructure, memory-sync, skill-authoring, and timecard enhancement work surfaced deferred architectural items:

- [x] **[MND]** Conv 168 — Fixed `detect-machine.sh` hostname match for M4Pro (added `*M4Pro*` + `*M4-Pro*` case patterns; emits `MacMiniM4Pro`). Also migrated canonical name across 11 files (`MachineName` TS type narrowed to `'MacMiniM4Pro' | 'MacMiniM4' | 'CI' | 'unknown'`, `vitest.global-setup.ts`, `tests/README.md` × 5, `dev-env-scan.sh` grep widened to accept `MacMiniM4Pro|MacMiniM4-Pro|MacMiniM4` for forward + historical compat, plus 8 docs: CLAUDE.md, devcomputers.md, env-vars-secrets.md, dev-setup.md, skills-system.md, COMMIT-MESSAGE-FORMAT.md, DEVELOPMENT-GUIDE.md, cloudflare.md). See DECISIONS.md decision 1 — code-truth conflict resolved by migrating code TO PLAN form (no-hyphen). tsc clean.

- [ ] **[AAP]** Astro dev-only absolute-filesystem path leak in `ClientRouter` `<script src>` — Astro 6.3.6 emits `<script type="module" src="/Users/jamesfraser/projects/Peerloop/node_modules/astro/components/ClientRouter.astro?astro&type=script&index=0&lang.ts">` (absolute filesystem path leaks into URL). Root cause: `node_modules/astro/dist/vite-plugin-astro/compile.js:50` — `import "${compileProps.filename}?astro&type=script..."` where `compileProps.filename` is absolute. Verified by `npm pack astro@6.3.6` + diff (latest stable has identical buggy line). Naïve relative-path fix doesn't work (Vite resolves relative imports against importer = same .astro file = absolute). Functionally a no-op (Vite serves 200 either way) but cross-machine portability hazard. **WAITING on upstream Astro fix post-6.3.7.** Conv 177: re-tested against Astro 6.3.7 — still broken upstream (absolute path still leaks in ClientRouter src). Verification probe after each Astro upgrade: `curl http://localhost:4321/ | grep -oE 'src="[^"]*ClientRouter[^"]*"'` — non-absolute path = fixed. (Conv 163, retested 177)

- [x] **[CAP-DEFEND]** Conv 167 — Widened `CourseAvailabilityPreview.tsx:76` early-return guard from `!data || data.teacherCount === 0` to `!data || !Array.isArray(data.teachers) || data.teachers.length === 0`. Defensive against any "data shaped but teachers absent" case (e.g., `{}` mock fallback that crashed `data.teachers.map(...)`). CourseTabs test 19/19 passes with 0 unhandled errors (was "1 unhandled error" in Conv 166).

- [x] **[PROD-PW]** Conv 168 — Decisions captured in `docs/DECISIONS.md` §4 "Prod admin seed password: rotate to 'Peerloop2', apply deferred". Decision: password = `Peerloop2` (matches dev); apply deferred to bundle seed edit + `wrangler d1 execute` UPDATE in one synchronous step. Counter-option (strong random + 1Password) explicitly preserved for "revisit if/when team grows." Un-defer procedure documented (3 numbered steps including bcryptjs hash location + `wrangler d1 execute` command shape). Apply tracked separately as [PROD-PW-APPLY] (see Conv 168 section). (Conv 167 surfaced, Conv 168 decided)

- [x] **[CCK-DA]** Conv 168 — Redesigned `/w-codecheck` Check 8 as alias-aware schema-aware lint. New v2 algorithm parses FROM/JOIN/INTO/UPDATE → alias-to-table map; for each `<token>.deleted_at` resolves via map and flags only if owning table lacks column; for each unqualified `deleted_at` flags only when NONE of the FROM/JOIN tables has the column. Calibrated against actual Conv 117 motivating case (verified via `git show 7df6c02`): pre-fix SQL was `SELECT ... FROM communities WHERE slug = ? AND deleted_at IS NULL` — **unqualified** filter, not qualified as session-doc summary claimed. v2 fires on this case with correct reasoning. Test harness `.scratch/cck-da-v2-test.mjs` with `--fixture` (Conv 117 reproduction) + `--counter` (5 hand-built cases, 3 silent / 2 fire — 5/5 pass). Production script at `.claude/scripts/codecheck-deleted-at.mjs` (~95 lines, replaces inline `node -e` in SKILL.md). Live codebase: 0 violations (vs v1's 90 across 18 tables). `w-codecheck/SKILL.md` Check 8 section rewritten with v2 binding-aware approach + calibration history. (Conv 167 surfaced, Conv 168 fixed)

- [ ] **[PD]** Prod cron Worker deploy — block date 2026-04-28 has passed; verify whether prerequisites still hold when next picked up. (Conv 150 inception)

- [ ] **[RSC]** Conditional: pair `-c` with `-v` if MSI rsync ever gains `-v` for diagnostics — watch-task, fires only on a specific edit to one of the three production rsync sites (`r-start/SKILL.md` Step 5.7 Phase 1, `r-commit/SKILL.md` Step 1.5, or `r-end/SKILL.md` Step 5b). Evaluated Conv 157: production rsync invocations don't use `-v`, so the cleaner-audit-logs benefit is invisible. Adding `-c` speculatively is over-engineering. Rewritten as precondition-bound rule to avoid bit-rot — task stays indefinitely until the trigger condition (adding `-v` for diagnostics) is met. (Conv 157)

- [x] **[BIV]** Bilateral verification reminder — retired Conv 155. The /r-start Step 5.7 forensics block (Conv 155) uses `diff -rq` directly, encoding the bidirectional check in code. No remaining manual file-list walks in tree-comparison logic. Reminder superseded by structural fix. (Conv 150 inception; scope tightened Conv 153; retired Conv 155)

- [x] **[MPP]** Memory path portability rewrite — convert hardcoded usernames to portable placeholders. Edited 3 files (`MEMORY.md`, `feedback_git_dash_c_enforcement.md`, `feedback_check_memory_before_directive_save.md`) replacing `/Users/jamesfraser/...` and `/Users/livingroom/...` with `~/projects/...` syntax (tilde expansion works on both machines). Verified end-to-end with `git -C ~/projects/...` runtime tests. (Conv 152)

- [x] **[MPS]** M4Pro memory sync — apply Conv 152 [MPP] + frontmatter fix to converge M4Pro with M4 state. Executed Conv 153: located tarball, backed up M4Pro dir, extracted and spot-checked 4 content differences, applied via rsync, ran full L1-L4 verification ladder (frontmatter clean, path-portability expected 1 hit, byte-equivalent match, tilde-expansion runtime verified). M4Pro now matches M4 byte-for-byte; bidirectional sync ban lifted. (Conv 153)

- [x] **[MSI]** Memory-sync skill integration — skill-based cross-machine memory sync via mirror in-repo, rsync-backed, self-bootstrapping. /r-start syncs mirror→live (mirror frozen at start of conv, live is working copy), /r-commit and /r-end sync live→mirror, git transports state to other machine. No separate manifest or checksum index — git history IS the ledger. Approved design Conv 154; implementation completed: 3 skill files edited (r-start/r-commit/r-end), Step 5.7/1.5/5b added respectively, path derivation via `$HOME` + `${CLAUDE_PROJECT_DIR//\//-}`, mirror dir bootstrapped and committed by Conv 154's /r-end. Conv 155: first cross-machine sync verified (M4Pro /r-start pulled M4's mirror, 51 files byte-identical); presync forensics + data-loss halt added to Step 5.7 (auto-backup on `Only in $LIVE` detection). Conv 156: Step 5.7 redesigned to always-pause on non-empty diff (not just data-loss); two-phase split; three question shapes (empty=silent, normal=yes/no, data-loss=A/B/C+auto-backup). (Conv 154-156)

  - [x] **[MSI-RE]** /r-end Step 5b added (live → mirror rsync before COMMIT). (Conv 154)
  - [x] **[MSI-RC]** /r-commit Step 1.5 added (live → mirror rsync before staging). (Conv 154)
  - [x] **[MSI-RS]** /r-start Step 5.7 added (mirror → live rsync, followed by explicit Read MEMORY.md). (Conv 154)
  - [x] **[MSI-VERIFY]** First end-to-end verification across machines — after M4's /r-end seeds mirror and pushes, M4Pro's next /r-start applies it; validate live dirs match byte-for-byte. (Conv 155 ✓ — 51 files, byte-identical)
  - [x] **[SDD]** /r-start Step 5.7: display incoming-diff inline, not just log — superseded and absorbed by Conv 156 larger redesign (always-pause on non-empty diff).
  - [x] **[MSI-RENAME]** Renamed `feedback_msi_first_sync_data_loss_window.md` → `feedback_msi_sync_user_checkpoint.md` (Conv 157) — filename now matches broadened content. Live updated; /r-commit Step 1.5 propagated to mirror. MEMORY.md link target updated. Historical references in DOC-DECISIONS.md / TIMELINE.md / session extracts left intact (accurate as past state).

*Conv N Items below are the chronological per-conv record of non-MATT work. **MATT-related Conv N Items (Convs 170–188, 190, 192, 207–208) have been migrated to [plan/matt/](plan/matt/README.md) — see the per-phase files + standin-matt.md + cutover.md + the README Conv timeline.** This will be true of other blocks too as each one migrates.*

## Conv 168 Items

**Completed Conv 168 (cross-block follow-up batch — no single PLAN block advanced):**

- [x] **[CCK-DA]** Conv 168 — `/w-codecheck` Check 8 v2 alias-aware heuristic eliminates 90 v1 false positives across 18 tables; calibrated against actual Conv 117 motivating case via `git show 7df6c02`. See Conv 150-157 Deferred Tasks section above for detail.

- [x] **[MND]** Conv 168 — `detect-machine.sh` hostname match for M4Pro + canonical name migration `MacMiniM4-Pro` → `MacMiniM4Pro` across 11 files. See Conv 150-157 Deferred Tasks section above + DECISIONS.md §4 decision 1.

- [x] **[RAM-NO-NAV]** Conv 168 — `parseNoNav(content)` helper added to `scripts/route-api-map.mjs:90-99`; emit branched (`ℹ️ no-nav by design` vs `⚠️ no discovered path`); applied to `/course/[slug]/[tab].astro` as first instance. Establishes declarative per-route opt-out pattern (vs central whitelist). New `export const noNav = true;` convention; remaining 19 legitimate no-nav routes tracked as `[RAM-NONAV-SWEEP]` below.

- [x] **[PROD-PW]** Conv 168 — Decisions captured in DECISIONS.md §4. Apply tracked as `[PROD-PW-APPLY]` below. See Conv 150-157 Deferred Tasks section above for detail.

- [x] **[XMV]** Conv 168 — Cross-machine path-derivation verification harness built at `.claude/scripts/cross-machine-verify.sh`. Runs 9 canonical path-derivation cases under `HOME=/Users/livingroom` (M4) and `HOME=/Users/jamesfraser` (M4Pro) via `bash -c` subshells, asserts each output matches a structural glob (e.g., `/Users/*/projects/peerloop-docs`), prints side-by-side comparisons, exits non-zero on any case failure. 9/9 pass. Plus `--scan <file>` advisory mode lists every tilde / `$HOME` / `$CLAUDE_PROJECT_DIR` reference in a target file (no pass/fail). Documented under "Cross-Machine Path Verification" subsection in `docs/as-designed/devcomputers.md § Machine Inventory`. Encodes the Conv 162 tilde-everywhere sweep's invariants as a runnable regression test. Retires the recurring "front-load cross-machine verification before locking sweep rules" meta-task that had been in RESUME-STATE for 4 convs.

**New deferred subtasks spawned Conv 168:**

- [x] **[RAM-NONAV-SWEEP]** Conv 169 — Applied `export const noNav = true;` to all 19 remaining legitimate no-nav routes: footer pages (`/about`, `/become-a-teacher`, `/blog`, `/careers`, `/contact`, `/cookies`, `/faq`, `/for-creators`, `/how-it-works`, `/pricing`, `/privacy`, `/stories`, `/terms`, `/testimonials`), `/404`, admin-only `/admin/recordings`, and 301-redirect shims (`/discover/creators`, `/discover/students`, `/discover/teachers`). Scanner now reports `ℹ️ no-nav by design` for all 20 annotated routes (including Conv 168's `/course/[slug]/[tab]`); zero `⚠️ no discovered nav` warnings remain. Verified `tsc --noEmit` clean + `npm run check` clean (0 errors / 0 warnings / 0 hints across 1215 files).

- [→] **[PROD-PW-APPLY]** Conv 169 — Redirected into `DEPLOYMENT.DB-SYNC` (see Active: DEPLOYMENT block above). Discovery: prod D1 has wider drift (missing migrations 0003 + 0004, plus stale `0002_seed.sql` tracker name) that warrants bundling with the password rotation rather than applying in isolation. Bundle when the DEPLOYMENT block is actively worked.

## Conv 169 Items

**Completed Conv 169 (cross-block follow-up batch — no single PLAN block advanced):**

- [x] **[RAM-NONAV-SWEEP]** Conv 169 — see Conv 150-157 Deferred Tasks section above for detail (19 `.astro` files annotated with `export const noNav = true;` + reason comment; scanner now reports `ℹ️ no-nav by design` for all 20 annotated routes; tsc + astro check clean).

- [x] **[PROD-PW-APPLY-REDIRECT]** Conv 169 — Discovered prod D1 has 3-migration drift (0002 tracker name stale, 0003 + 0004 not applied; `feed_visits` / `feed_activities` missing). Reverted in-flight seed edit. Added new `DEPLOYMENT.DB-SYNC` sub-block bundling password rotation with schema convergence + tracker cleanup (see Active: DEPLOYMENT). Decision recorded in this conv's session doc and extract Decisions §1.

*MATT design intake ([MATT-INTAKE], [MATT-MCP-RETRY], [MATT-INVENTORY-CLEANUP], [MATT-PRE-PLAN]) moved to [plan/matt/README.md § Pre-execution intake](plan/matt/README.md).*

## Conv 179 Items

- [ ] **[ASF]** Investigate `Astro.slots.has` + `&&` short-circuit interaction surfaced Conv 175 [MSH-VIZ] empty-pill bug. Conditional Fragment forwarding `<Fragment slot="x"><slot name="y" /></Fragment>` suppressed child's `<slot name="x">FALLBACK</slot>` even when slot `y` was empty; `Astro.slots.has` + `&&` short-circuit did not restore the fallback. Production workaround in place: defaults at the layout consumer via ternary inside unconditional Fragments. Root-cause investigation deferred — file an Astro issue or build a minimal repro if it bites again. Captured in memory as `reference_astro_slot_forwarding.md`.

- [ ] **[TDS-DRIFT]** `tech-doc-sweep` hook returned no recent changes despite the substantial `matt/*` additions across Convs 173-178 (new tokens, new layout shells, new primitives, new pages). Investigate: drift baseline SHA at `.claude/.drift-baseline-sha` may be stale, or sweep matchers in `.claude/scripts/tech-doc-sweep.sh` may not detect `src/components/matt/*` / `src/styles/tokens-*.css` / `src/pages/matt/*` paths. Reproduce: `cat .claude/.drift-baseline-sha`, then `git -C ../Peerloop diff $(cat .claude/.drift-baseline-sha)..HEAD --stat -- 'src/components/matt/*' 'src/styles/tokens-*' 'src/pages/matt/*'` to see whether files-changed are visible to the matchers.

- [ ] **[MEM-CAP]** Schedule a `/r-prune-claude` pass when MEMORY.md auto-load utilization climbs above 80% (Conv 179 baseline: 59% lines / 57% bytes — not urgent, watch-task only). Auto-load cap is 200 lines / 25 KB at every SessionStart (per `code.claude.com/docs/en/memory.md`); /r-start Step 5.7 Phase 2 emits a 🔴🔴🔴 alert at ≥80% on either axis. Adding the `## External Source-of-Truth` section in Conv 179 grew MEMORY.md by 1 section + 1 line; subsequent net-growth convs without prune will close the gap.

- [ ] **[INV-PATH-FIX]** Sweep `.scratch/matt-figma/` references in code/docs → `.scratch/matt-main/`. `matt-figma` was the initial 229-file Figma export (Conv 169); `matt-main` is the curated 83-file build set (Conv 170 [MATT-ISOLATE]). Active references in Matt design docs (matt-design-system.md, matt-pre-plan.md) or `src/` may still point at the read-only inventory dir instead of the canonical build set. Find with: `grep -rn 'matt-figma' docs/ && git -C ~/projects/Peerloop grep 'matt-figma' -- src/`. Replace path-by-path; verify each isn't an intentional historical reference.

## Conv 200 Items

**Completed Conv 200 (DTUNE — doc-sync-system cost-reduction; infra/tooling, no block advancement):** Re-tuned the existing `docsRegistry` (Convs 132–137) so per-conv doc-maintenance obligation shrinks to an explicit opt-in set. **Key reframe:** the wall-time lever is the *maintenance contract* (SessionStart drift hook + /r-end docs agent + CLAUDE.md "update the doc" mandate), not the doc count — removing docs from those machines' *category scope* reclaims the time even with zero files deleted. Design = **default-to-manual / driftCheck is opt-in**: added a `doc-category <relpath>` matcher to `docs-registry.mjs` (glob/brace; unmatched → `manual`), gated `tech-doc-sweep.sh` on `category==driftCheck`, flipped vendor-docs → `manual` (rules retained as a code→vendor knowledge map), re-scoped /r-end Agent 3 to driftCheck-only ("no docs" valid, no gap-spiral), rewrote CLAUDE.md "When Working with a Technology" + added a Maintenance-Tiers table, recorded §8 in `doc-sync-strategy.md`. C-batch: archived 4 frozen docs → `docs/archive/` (🗄️ banners + ref/registry repoint), refreshed the one actively-misleading vendor doc (`reactjs.md` Alpha Peer→Peerloop) + added 📌 snapshot banners to 17 vendor docs (did NOT mass-trim accurate ones — low value once unmaintained, risks losing gotchas; git preserves all). 3 commits pushed to origin/main (`63f8dc2`, `e2a1e99`, `47159e4`). NULL-byte hazard caught + fixed in the matcher edit (a `**`→`.*` placeholder landed as a literal `\x00`; tests passed but git saw the file binary — visible `@@GS@@` token now). Test suite 18/18 (3 vendor positive-controls flipped to negatives + 3 doc-category unit assertions). No baseline gate run claimed (docs/machinery-only conv, no code-repo changes).

- [x] **[DTUNE-V]** Conv 200 — vendor-docs reclassified `driftCheck`→`manual` in `.claude/config.json` (+ `_categoryNote`); `doc-category` matcher added to `docs-registry.mjs`; `tech-doc-sweep.sh` gated on `category==driftCheck` so vendor docs never flag. Keyword rules retained as a knowledge map (policy now lives solely in the registry category field, inherited by every consumer). (A3/B1, commit `63f8dc2`)

- [x] **[DTUNE-R]** Conv 200 — /r-end docs Agent 3 (`SKILL.md` + `refs/fmt-docs.md`) re-scoped to driftCheck-only: "no docs to update" is a valid outcome, gap-detection runs for driftCheck docs only, vendor/editorial rows marked editorial-only in fmt-docs. Reduces the per-conv doc-task volume. (B2, commit `63f8dc2`)

- [x] **[DTUNE-P]** Conv 200 — CLAUDE.md "When Working with a Technology" rewritten (read-if-cheaper-than-re-derive cleaving test, update-on-contract-violation, default-manual) + Maintenance-Tiers table added (the 4 registry categories = maintenance tiers; driftCheck auto-maintained, all else editorial/leave-alone). (A2/B3, commit `63f8dc2`)

- [x] **[DTUNE-D]** Conv 200 — `doc-sync-strategy.md` §8 records the re-tuning (which docs moved tiers + the default-to-manual inversion). (A1, commit `63f8dc2`)

- [x] **[DTUNE-C2]** Conv 200 — archived 4 frozen docs (admin-intel-plan, plato-implementation-plan, comp-cloudflare-vs-vercel, STORY-GAP-ANALYSIS) → `docs/archive/` via `git mv` with 🗄️ ARCHIVED provenance banners; live refs repointed (plato.md, _hosting-decisions.md, doc-sync-strategy inventory); `archive` group (archival, `docs/archive/**`) added to config; `orig-pages-map.md` left in place (6 active incoming refs, already archival). (commit `e2a1e99`)

- [x] **[DTUNE-C1]** Conv 200 — `reactjs.md` de-staled (Alpha Peer→Peerloop, future→present tense, removed pre-build P0/P1 + User-Story-Coverage tables, KEPT the Cloudflare React-19 SSR caveat); uniform 📌 "Snapshot — official source canonical" banner added to 17 vendor docs via script. Accurate vendor docs deliberately NOT trimmed. (commit `47159e4`)

- [ ] **[DTUNE-WATCH]** Conv 200 — Validate over the next few convs that the re-scoped /r-end docs agent actually produces fewer doc tasks. The change is **prompt-based, not a hard gate** — if vendor/prose doc tasks still appear, tighten the Agent 3 prompt. (open follow-up)

## Conv 206 Items

**Completed Conv 206 (CC-workflow / memory + skill infrastructure — no PLAN feature block advanced):** MEMORY.md byte-cap pressure relieved via full audit, CLAUDE.md pruned via `/r-prune-claude` (after fixing its `!`-backtick path bugs), new `/r-coherence-check` skill built by subsuming `/r-optimize` (legacy skill deleted), and a new always-loaded behavioral rule `§Investigative Framings — Surface Findings Before Acting` added to CLAUDE.md. No code-repo work besides `package-lock.json` no-op sync.

- [x] **[MEM-CAP-WATCH]** Conv 206 — MEMORY.md full audit pass (option C). 8 heaviest entries stub-pointered (preserving distinctive markers per `feedback_memory_index_load_bearing.md`); 3 inline rule blocks consolidated into stub-pointer rows; 4 stale index entries retired (project_course_page_merge / project_currentuser_optimize / project_skill_portability / rename-lessons). **21,950 → 17,336 bytes (86% → 68% of 25 KB auto-load cap); 132 → 104 lines; +8,264 byte headroom.** Closes the carry-forward [MEM-CAP-WATCH] task from RESUME-STATE.

- [x] **[INV-FRAMINGS]** Conv 206 — New top-level `## Investigative Framings — Surface Findings Before Acting` section added to CLAUDE.md (between §Critical Rule and §Skills) plus supporting `memory/feedback_audit_surface_findings_first.md` + MEMORY.md index line. Codifies the verb test (audit / review / investigate / examine / classify / analyze → surface dispositions first; build / make / fix → proceed). Triggered by Conv 206 [MEM-AUDIT] — user picked option C in MEMORY.md audit and CC executed end-to-end without surfacing per-item dispositions; user noted structural asymmetry ("I cannot know what you will find" preemptively).

- [x] **[RPC-BUGS]** Conv 206 — Fixed 4 `!`-backtick relative-path bugs in `.claude/skills/r-prune-claude/SKILL.md` (lines 16/19/22/25 → tilde-literal `~/projects/peerloop-docs/CLAUDE.md` etc., matching the Conv 162 sweep convention from `feedback_git_dash_c_enforcement.md`). Skill had been returning `CLAUDE.md line count: 12` (its own SKILL.md, not project CLAUDE.md). Added Step 4 (scoped post-execute [BROKEN-REF] validation) + Step 5 pointer to `/r-coherence-check`.

- [x] **[CLAUDE-PRUNE]** Conv 206 — Ran `/r-prune-claude` on CLAUDE.md (533 lines, 30 KB — >2× the skill's `high` threshold of 250). 8 reference sections moved to NEW `docs/reference/CLAUDE-OFFLOAD.md` (316 lines / 15 KB, 8 H2 sections): Dual-Repo Architecture, Startup Hooks, Conversation Lifecycle, Test Suite Workflow, Schema Discrepancy Discipline, Development Commands, Database Migrations, Tech & Arch Documentation. 14 sections KEPT (all behavioral rules + identity context). **CLAUDE.md 533 → 286 lines (46% reduction); 30 KB → 20 KB. 22 H2 headers preserved + 9 offload pointer links inserted.**

- [x] **[COHERENCE-SKILL]** Conv 206 — Built new `/r-coherence-check` skill (296 lines) as composite of structural lint + semantic deep review. **Subsumed and deleted `/r-optimize`** (substantially-overlapping charter discovered after initial build; user had used it once and forgotten it existed) — 10 categories (4 structural BROKEN-REF/STUB-DRIFT/OVERLAP/ORPHAN + 6 semantic AMBIGUITY/FRICTION/STALE/REDUNDANCY/GAP/SCOPE-CREEP + DEFERRED CONTRADICTION) + severity ladder + apply-fixes protocol; all path bugs fixed with tilde-literal. Applied all 5 P1-P5 improvements: tiered invocation (`--deep`/`--semantic`/`--all` flags), `.claude/coherence-ack.md` acknowledgments file, configurable `coherenceCheck.markers` in `config.json`, diff preview for SEMANTIC fixes, frontmatter description cleanup. `memory/feedback_conversational_brevity.md` updated (one `/r-optimize` → `/r-coherence-check` reference).

- [x] **[COHERENCE-ARGS-BUG]** Conv 206 — Fixed `$ARGUMENTS` not populating in `!`-backticks: `--deep` invocation fell through to structural-mode default. Dropped conditional `$ARGUMENTS` checks from `!`-backticks (always load full CLAUDE.md + memory files now); Step 0 detects Mode from the `ARGUMENTS:` line appended to the prompt body by the harness. Re-invoked `--deep` worked: full content loaded (~161 KB persisted), Mode=DEEP detected, all 10 categories ran. **Pattern recorded:** for arg-driven skill behavior, parse `ARGUMENTS:` in skill body, NOT `!`-backticks.

- [x] **[COHERENCE-DEEP-RUN]** Conv 206 — First `/r-coherence-check --deep` run surfaced 4 active findings: #1 HIGH [STALE] `project_skill_portability.md` body claimed `$CLAUDE_PROJECT_DIR` is the convention (superseded by Conv 162 tilde-literal); #2 MEDIUM [GAP] multi-conv-scope counter-case only in `feedback_default_durable_no_ask.md` body not CLAUDE.md; #3+#4 LOW [AMBIGUITY] §Critical Rule "multiple features" + §Schema Discrepancy "unambiguously self-evident" judgment-heavy phrasing. User chose: fix STALE + GAP, defer LOW AMBIGUITY. Fix #1: deleted `project_skill_portability.md` live (mirror self-resolves at Step 5b sync). Fix #2: added `**Multi-conv scope carve-out.**` paragraph to CLAUDE.md §Solution Quality referencing `feedback_default_durable_no_ask.md`. Followup: updated `feedback_default_durable_no_ask.md` to mark multi-conv-scope as promoted to CLAUDE.md while retaining Conv 131 [TDS-AUTH] precedent.

**New deferred subtasks spawned Conv 206:**

- [ ] **[COHERENCE-AMBIG-LOW]** Conv 206 — Two LOW [AMBIGUITY] findings deferred for future calibration: §Critical Rule "multiple features" (unquantified threshold) and §Schema Discrepancy exception "unambiguously self-evident" (judgment-heavy). Accepted as natural judgment thresholds — revisit only if a concrete miscalibration appears.

- [ ] **[SKILL-DISCOVERY-WATCH]** Conv 206 — User had used `/r-optimize` once and forgotten it existed. Periodic audit of low-usage skills could surface other under-discovered skills before they accumulate stale code (r-optimize had 2 path bugs that would have broken on M4Pro). No fixed cadence; revisit after 5-10 more convs of skill churn.

## Conv 157 Timecard Enhancement Items

- [x] **[TC-OPT-OBSIDIAN]** Obsidian vault integration for `/r-timecard-day` output (Conv 157 ✅). Moved vault-write from `.timecard.md` in repo to timed files in Obsidian vault. Config: `rTimecardDay.vaultPath = "~/Obsidian Vaults/main2025/_projects/Peerloop/timecards"` (tilde-portable for M4/M4Pro via `$HOME` runtime expansion). Filename format: `Peerloop Timecard • Coding • <H3-title> • <startTimeNoColon>.md` (e.g., `Peerloop Timecard • Coding • May 6, 2026 • 0910.md`). Vault file replaces `.timecard.md` write. Obsidian Sync auto-propagates to both machines. Script: `placeholderNames[]` field added to JSON output; SKILL.md Step 4 rewritten to drive from array via literal substitution (eliminates regex-scanning bug). Step 5 three-branch flow: dir-missing → STOP, file-exists → halt-and-ask, else → write+open. Verified cross-machine portability (M4Pro `$HOME=/Users/jamesfraser` → correct path derivation).

## BBB-RECORDING (Convs 159-161)

🔥 **ACTIVE** — Triggered by recording-gap in Conv 158 BBB testing. Conv 159: diagnosis confirmed `autoStartRecording` missing. Conv 161: **Blindside reply** — `getRecordings` requires `limit≤100` parameter (fixed both diagnostic surfaces); paginated `/admin/recordings` built with 2-call total derivation; all 7 user-facing recording-display surfaces verified on staging (1 of 8 orphaned recordings visible correctly). Conv 162: discovered 8th surface (TeacherTabContent My Sessions tab) and fixed it — verbatim mirror of student `SessionsTabContent` "Recording" affordance. Conv 163: [REC-LABEL] completed — shared `<RecordingLink>` component extracted, all 10 surfaces (8 + 2 admin added mid-conv) unified on Option B bordered-text "Recording" button; local dev seed now ships Sarah/Guy/Intro-to-n8n session with real Blindside `recording_url` (exact parity with staging); [DLE] investigation root-caused user-reported "loading errors" to existing [BR-NAVBAR-HYDRATE] (scope widened — not admin-only). Conv 164: [RV] 10-surface verification sweep confirmed all recording-button updates landed (Sarah/Guy/Brian role rotation, all 10 surfaces ✓). [BR-NAVBAR-HYDRATE] root-caused + fixed at AdminNavbar.tsx:90 via the established `isHydrated` flag pattern (single bug, single file — Conv 163 [DLE] "scope widened" was a misdiagnosis: the non-admin reproduction came from `data-astro-transition-persist` carrying the errored navbar across View Transitions, not a separate bug). [CRT] promoted to its own block. **Completed:** account-wide diagnostics, autoStartRecording fix deployed, paginated admin UI with 20-per-page paging, empirical UI verification on all surfaces, TeacherCourseView + TeacherTabContent recording-link bug fixes deployed to staging, 10-surface recording-link unification via `<RecordingLink>`, local dev seed parity with staging for recording flow, AdminNavbar hydration mismatch fixed.

**Subtasks:**

- [x] **[BR-DIAG]** Conv 159: Account-wide `getRecordings` check (finding: 0 recordings, eliminated webhook/config hypotheses).

- [x] **[BR-AUTO]** Conv 159: Added `autoStartRecording: true` to 3-layer fallback in types + `bbb.ts` + `join.ts`.

- [x] **[BR-ADMIN]** Conv 159: Built `/api/admin/bbb/recordings` endpoint + `/admin/recordings` page + RecordingsAdmin component + menu entry.

- [x] **[BR-ADMIN-SCRIPT]** Conv 159: Promoted diagnostic script to `Peerloop/scripts/bbb-list-recordings.mjs`.

- [x] **[BR-REPLY]** Conv 159: Drafted Blindside reply with diagnostic findings and questions.

- [x] **[BR-MENU]** Conv 161: Verified Recordings menu entry exists in AdminNavbar.

- [x] **[BR-OFFSET-PROBE]** Conv 161: Confirmed Blindside supports `offset` parameter (Blindside-specific, not standard BBB).

- [x] **[BR-PAGE]** Conv 161: Rewrote `/admin/recordings` with 20-per-page pagination (2-call total derivation for BBB), shared AdminPagination component, page/limit state management, prev/next navigation.

- [x] **[BR-TRACE]** Conv 161: Mapped all 7 user-facing recording-display surfaces; traced all 8 BBB recordings across staging/prod D1 (1 visible, 5 orphaned, 2 Greenlight-only). Cross-verified API returns correct `recording_url` on all surfaces.

- [x] **[TCV-REC]** Conv 161: Fixed TeacherCourseView SessionRow missing recording-link bug (JSX was reading type but not rendering field); added PlayCircleIcon conditional block; deployed to staging; verified live.

- [x] **[MST-REC]** Conv 162: Fixed TeacherTabContent My Sessions tab missing recording link — added `recording_url: string | null` to `SessionRow` interface and mirrored student `SessionsTabContent`'s bordered text "Recording" button verbatim in `SessionRowView`. API endpoint `/api/teaching/courses/[courseId].ts` already returned `recording_url` (client-side gap only — same root-cause shape as Conv 161 [TCV-REC]). Deployed to staging (Version `36c761e7-...`), verified live by user. Discovery: this is the 8th user-facing recording surface, not 7 as [BR-TRACE] mapped in Conv 161 — [REC-LABEL] inventory updated below.

- [x] **[BR-NAVBAR-HYDRATE]** Conv 161 → Conv 164 (Conv 163 [DLE] "scope widened to non-admin pages" was a misdiagnosis — one bug, one file). Root cause: `AdminNavbar.tsx:90` `useState<CurrentUser|null>(getCurrentUser())` read localStorage/window in the initializer, so SSR returned `null` while CSR returned a hydrated user — flipping the `{admin && (<div>...)}` block at lines 181-198. Fix: mirrored AppNavbar's established `isHydrated` flag pattern — `useState(null)` + `setIsHydrated(true)` in the existing useEffect + render guard `{isHydrated && admin && (...)}`. Repo-wide grep `useState[<(].*getCurrentUser\(\)` returned exactly one hit, confirming the bug was isolated. Conv 163 [DLE] reproduction on non-admin pages came from `data-astro-transition-persist="admin-navbar"` carrying the persisted (already-errored) AdminNavbar across View Transitions — not a separate bug surface. All 5 baseline gates green (tsc / astro 0/0/0 across 1211 files / lint 0 errors 4 pre-existing warnings / 6415 tests / build 6.43s). 2 edits to `src/components/layout/AdminNavbar.tsx` (8 lines net).

- [x] **[CRT]** Promoted to its own ACTIVE block (designed Conv 164); completed Conv 165-166. See COMPLETED_PLAN.md.

- [x] **[REC-LABEL]** Conv 161 (extended Conv 162, completed Conv 163). Created `<RecordingLink>` component (`src/components/ui/RecordingLink.tsx`): bordered text "Recording" button with dark-mode classes, `target="_blank" rel="noopener noreferrer"`, single variant. Applied to all 10 user-facing surfaces (the original 8 plus admin/recordings list and admin/sessions Recording column, added Conv 163 per user request). API endpoint `/api/admin/sessions/index.ts` now returns `recording_url` in list payload (was queried but dropped before). Detail panels (#1 SessionCompletedView, #7 admin SessionDetailContent) standardized on `bg-secondary-50` + "Session Recording" heading + `<RecordingLink>`. Old icon-only+tooltip and "Watch" affordances retired. `docs/reference/bigbluebutton.md` UI Surfaces table updated 8 → 10. All 5 baseline gates green (tsc / astro 0/0/0 / lint 4 pre-existing / 6415 tests / build).

- [ ] **[BR-STATUS]** Add `sessions.recording_status` column with enum `none | requested | capturing | processing | published | failed` for richer post-session UI. Defer pending Blindside follow-up on server-level recording configuration + outcome of orphaned-recording investigation.

- [ ] **[BR-ZERO-REPRO]** Reproduce the 0-min empty-but-published recording state — external-blocked (needs fresh BBB test session). Prereq for [BR-STATUS] enum design (we need to know which post-session states are reachable in practice before fixing the column shape).

- [ ] **[VITE-DEPS-WATCH]** Watch for recurring Vite missing-chunk warnings during `npm run dev` / `npm run dev:staging` — watch-only; act if the warning recurs (i.e., trips dev server hot-reload or build). Carried from Conv 168 RESUME-STATE.

## Conv 158 Timecard Model & Sub-Agent Testing — ABANDONED (Conv 160)

Multi-model exploration for `/r-timecard-day` dropped. Sub-agent dispatch was cost-prohibitive (Sonnet sub-agent 60-300s vs Opus baseline 15s) and Haiku exhibited hallucinated permission asks. Items [TC-SONNET-FG], [TC-HAIKU-FG], [TC-PARAM-OUTPATH], [TC-GLIDE-DOC] all retired. Skill runs on whatever model the caller invokes it under; no further investment planned.

---


## Follow-ups: COMMUNITY-RESOURCES (Conv 124, block closed)

COMMUNITY-RESOURCES block closed Conv 124 — Phase 8 PLATO step `upload-community-resources` added to flywheel scenario (JSON-link path, 2 resources via `repeat`, discovery GET on `/api/me/communities` for cross-step slug). All 9 phases complete. Remaining follow-ups:

- [x] **[MPT]** Conv 130 — Multipart file-upload happy-path tests for POST community resources: 11 tests (8 happy-path + 3 validation), manual Uint8Array multipart body construction to bypass jsdom FormData serialization bug; session-invite mock updated. 6404/6404 tests passing.
- [x] **[COURSE-RES-AUTH-EDGE]** Conv 129 — `download.ts` enrollment gate: added `AND deleted_at IS NULL`; disputed enrollments retain access (product decision). tsc clean.
- [x] **[BKC-NEXT]** Conv 129 — SessionBooking next-month nav capped at today+28 days (`maxBookingDate`/`isAtMaxMonth` computed values; next-month button disabled at horizon).
- [x] **[BKC-FETCH]** Conv 129 — `availability-summary.ts` default `availabilityWindowDays` corrected from `'30'` to `'28'`; both surfaces now aligned on 28 days.
- [x] **[CODECHECK-SQL]** Conv 129 — `/w-codecheck` Check #8 added: schema-aware SQL lint parses `deleted_at` table list dynamically, scans template-literal SQL blocks, flags co-occurrence with non-`deleted_at` tables.
- [x] **[CSS]** Conv 128 — `/discover/members` bottom-row clipping fixed. Removed `<div className="h-14 lg:hidden" />` spacer from AppNavbar; added `pt-14 lg:pt-6` to AppLayout content div. Verified in browser (desktop + mobile viewport).
- [x] **[DBAPI-SUBCOM-AUDIT]** Conv 131 — structural audit complete. §Authentication rewritten (6 fictional → 10 real endpoints with `peerloop_access`/`peerloop_refresh` cookies + `recordLogin()` side-effects + Stream.io/Google/GitHub OAuth externals). §Communities rewritten (7 → 18 endpoints: 15 active + 3 explicitly-proposed in a separated subsection; removed Conv 121 audit banner). DB-API.md +218 net lines (net-new documentation, not drift).

---

## Follow-ups: ROLE-AUDIT (Conv 123, block closed)

ROLE-AUDIT block closed Conv 123 — audit report produced (`docs/reference/role-audit-2026-04-15.md`), codebase materially cleaner than framing suggested (zero stale role constructs, zero SSR duplication bugs). Closed in-conv: [RA-RO] (`transformRole` extract + 6-file Astro narrowing + `CommunityTabs`/SSR loader types narrowed to `'creator' | 'member'` + `RoleBadge` collapse), [RA-ADM] (3 narrow helpers in `src/lib/auth/session.ts`: `isUserAdmin`, `getUserPermissionFlags`, `getAllAdminUserIds`; 9 sites migrated; 3 moderator sites intentionally inline by superset-query rule).

Remaining spawned follow-ups:

- [x] **[RA-CLI]** Conv 124 — `MyCourses.tsx` migrated to `useCurrentUser()` + `useAuthStatus()` (derived enrollments via `user.getEnrollments()`, heal path calls `refreshCurrentUser`). `UserProfile.tsx` discovered to be dead code (zero src/.astro callers) and deleted along with its 36-test file. Spawned + closed **[RA-API]** same conv.
- [x] **[RA-API]** Conv 124 — Deleted dead `/api/me/enrollments` endpoint + 18-test file + stale negative-assertion test in `StudentDashboard.test.tsx`; regenerated `tests/plato/route-map.generated.ts` + `docs/as-designed/route-api-map.md`. Discovered `/api/me/stats` endpoint never existed (phantom URL masked by `.catch(() => null)` in the now-deleted `UserProfile.tsx`).
- [x] **[RA-SSR]** Conv 130 — Collapsed all 6 `course/[slug]/*.astro` SSR frontmatter queries into `fetchCourseTabData` loader (11-query `Promise.all`, `CourseTabData` interface, enrollment check + `canPost` derivation). Each page reduced ~180 → ~85 lines. Named `fetchCourseTabData` (not `fetchCourseDetailData`) to avoid collision with existing function of different shape. **Tail Conv 131:** Deleted the now-orphaned legacy `fetchCourseDetailData` loader (200 lines) + `CourseDetailData` interface + 2 dead `mock-data` imports + `src/lib/ssr/index.ts` re-exports + 8-test CDET describe block in `tests/ssr/courses.test.ts`. Header docstring updated (CDET → CTAB). tsc clean; 21 → 13 tests passing.
- [x] **[RA-SSR-LOADER]** Conv 128 — `src/lib/ssr/loaders/communities.ts:471-476` raw `SELECT is_admin` replaced with `isUserAdmin(db, userId)` helper. tsc clean.
- [x] **[RA-JWT]** Conv 125 — Decision recorded in `docs/DECISIONS.md` §4: **keep status quo, do NOT embed `isAdmin` in JWT.** Load-bearing reason: refresh-token-as-auth fallback (`session.ts:88-94`) widens staleness to 7 days (not 15 min as the audit framed), which is incompatible with instant admin-revocation for security-sensitive gates. Revisit only if admin-gate P95 latency measurably regresses. Spawned `[RA-SSR-LOADER]` for missed site in `ssr/loaders/communities.ts:471-476`.
- [x] **[RA-RES-ROLE]** Conv 125 — Dropped unused `CommunityTabs.Resource.uploadedBy.role` field. Removed `role` from 8 files (6 Astro pages + CommunityTabs.tsx type + SSR loader type, ResourceRow interface, SQL SELECT, and `LEFT JOIN community_members` that existed *only* to supply this field). 13 lines deleted; query now 1 JOIN lighter.

### Conv 123 drain pass (infra)

- [x] **[SGA]** — `sync-gaps.sh` `find` excludes `.astro/` generated-content dirs in API + tests sections (fixes `src/pages/api/**/.astro/content.d.ts` false positives; 241 API routes documented clean).

---

## Deferred: TESTING

**Focus:** Multi-user testing — E2E Playwright flows, branching workflow integration tests, admin test gaps
**Status:** 📋 PENDING
**Merged Conv 095:** E2E-GAPS + E2E-LIFECYCLE + WORKFLOW-TESTS + ADMIN-REVIEW.TESTING

### TESTING.E2E — Playwright Multi-User Flows

*Two-browser Playwright tests for flows not coverable by integration tests*

- [ ] Session invite: Teacher sends → Student accepts → Session created → Both in room
- [ ] Session invite variants: reschedule, expired, decline
- [ ] Booking wizard: teacher select → date → time → confirm → session room
- [ ] Booking reschedule: cancel old → pick new time
- [ ] Session lifecycle: join → video room → completion → rating (two-browser)
- [ ] Notifications: User A action → User B notification badge + page update
- [ ] Messages: User A sends → User B conversation + badge update

### TESTING.WORKFLOW — Branching Integration Tests

*Multi-step flows with decision-point variants. Shared setup → branch at decision point → verify different downstream state.*

| Workflow | Branches | Value |
|----------|----------|-------|
| **Booking→Session→Completion** | book, join/no-show, complete (single/final), cancel (on-time/late), reschedule (under/at limit) | Highest — most user-facing |
| **Completion→Cert→Teacher** | rate/skip, recommend/decline, certify/reject, first booking as Teacher (full flywheel) | High — core product thesis |
| **Payment** | checkout success/abandon, refund, dispute open/close (won/lost), payout fail | Medium — webhook chains |
| **Messaging** | start convo (allowed/403), send after relationship ends, admin bypass | Low — relationship gates removed (Conv 110 open messaging); admin rules still testable |

Existing partial coverage: `tests/api/sessions/`, `tests/api/webhooks/stripe.ts`, `tests/lib/messaging.test.ts`, `tests/integration/message-lifecycle.test.ts`, `tests/integration/notification-lifecycle.test.ts`

### TESTING.ADMIN — Admin Test Gaps

*From Conv 080 audit. 81 of 96 admin components/APIs tested (~1900 tests).*

**Category 1 — Decision Data (12 untested GET `[id].ts` endpoints):**
admin/enrollments, teachers, certificates, courses, sessions, users, payouts, topics, moderation, intel/courses, intel/dashboard, intel/communities. Highly templatable — same auth→404→200+shape pattern.

**Category 2 — Action Execution (2 components):**
ModeratorsAdmin (invite/revoke/remove), TopicsAdmin (reorder/CRUD). API tests exist but component→API wiring untested.

**Category 3 — Shared Infrastructure (5 primitives):**
AdminDataTable, AdminDetailPanel, AdminFilterBar, AdminPagination, AdminActionMenu. Tested indirectly. Recommended: test DataTable + DetailPanel directly (highest cascade risk), skip others.

---

## Completed: CF-WORKERS (Conv 114)

**Focus:** Migrate Cloudflare Pages → Workers with Static Assets (Astro 6 + adapter 13 requires Workers)
**Status:** ✅ COMPLETE (Conv 114, branch `jfg-dev-12`)
**Tech Doc:** `docs/reference/cloudflare.md` (§Cloudflare Workers Deployment)

**Summary:** Staging deployed at `peerloop-staging.brian-1dc.workers.dev`. Smoke test green: SSR routes, D1/R2/KV/ASSETS bindings all working, `ENVIRONMENT` baked into bundle as `STG`. The Conv 113 postbuild patch was removed.

### CF-WORKERS.MIGRATE — Pages → Workers Migration

- [x] Create Workers project in Cloudflare Dashboard (`peerloop-staging` created by user)
- [x] Update `wrangler.toml` for Workers with Static Assets format
- [x] Migrate D1, R2, KV bindings to Workers config (same account-level IDs)
- [ ] Configure custom domain / DNS routing for Workers (**deferred** — using `.workers.dev` default for staging)
- [x] Verify `[env.staging]` bindings work (renamed from `[env.preview]`)
- [x] Test deployment end-to-end (build → deploy → verify all routes)
- [x] Remove temporary `scripts/fix-pages-wrangler.mjs` and `postbuild` npm script
- [x] Update `docs/reference/cloudflare.md` to reflect Workers setup
- [x] Update CI/CD if any Pages-specific configuration exists (removed `CF_PAGES` env var usage)

**Follow-ups tracked in DEPLOYMENT block below.**

---

## Active: DEPLOYMENT

**Focus:** Complete the CF Workers rollout — production cutover and automation.
**Status:** 📋 PENDING (spawned from CF-WORKERS Conv 114)
**Tech Doc:** `docs/reference/cloudflare.md` (§Cloudflare Workers Deployment)

### DEPLOYMENT.GHACTIONS — GitHub Actions auto-deploy workflow

- [ ] `.github/workflows/deploy.yml` — auto-deploy on push to staging/main
- [ ] Configure GitHub repo secrets: `CLOUDFLARE_API_TOKEN` (deploy), `DOCS_REPO_PAT` (doc-drift workflow cross-repo checkout of peerloop-docs — PAT needs `repo` read scope)
- [ ] Build + run tests + deploy (staging env)
- [ ] Main branch deploys to production (once prod cutover done)

### DEPLOYMENT.PAGES-DISCONNECT — Disable old Pages auto-deploy ✅ COMPLETE (Conv 116)

**Resolved:** Client uninstalled the Cloudflare Pages GitHub App from `PeerloopLLC`. Pushes to `staging`/`main` no longer trigger broken CF Pages builds.

- [x] **GitHub-side:** Cloudflare Pages GitHub App uninstalled from `PeerloopLLC` org.

**Do NOT delete the Pages project itself** — production still serves from it until DEPLOYMENT.PROD completes.

### DEPLOYMENT.DB-SYNC — Prod D1 schema/data convergence (Conv 169 discovery)

**Status:** 📋 PENDING — pre-cutover prerequisite. Discovered Conv 169 while preparing [PROD-PW-APPLY]: prod D1 has drifted vs local + staging. Bundling all prod D1 mutations (schema-sync + password rotation + tracker-cleanup) into one synchronous sweep.

**Drift state (live, captured Conv 169):**

| Migration | Local | Staging | Production |
|---|:---:|:---:|:---:|
| 0001_schema.sql | ✅ | ✅ | ✅ |
| 0002_seed_core.sql | ✅ | ✅ | ⚠️ recorded under old name `0002_seed.sql` |
| 0003_fix_session_times.sql | ✅ | ✅ | ❌ **NOT APPLIED** (would be no-op — `sessions_missing_z = 0`) |
| 0004_feed_activity_index.sql | ✅ | ✅ | ❌ **NOT APPLIED** — `feed_visits` / `feed_activities` tables missing on prod |

**Live prod row counts (Conv 169):** 9 users (including `usr-admin`), 6 sessions, 0 sessions missing `Z` suffix.

**Tasks (run as one bundle when ready to apply):**

- [ ] **[DB-SYNC-04]** Apply `migrations/0004_feed_activity_index.sql` to prod via `wrangler d1 execute peerloop-db --remote --file migrations/0004_feed_activity_index.sql`. Creates `feed_visits` + `feed_activities` tables + 2 indexes. Real schema gap — any feed-intel code path that reads/writes these tables will fail on prod until applied. Then insert tracker row: `wrangler d1 execute peerloop-db --remote --command="INSERT INTO d1_migrations (name, applied_at) VALUES ('0004_feed_activity_index.sql', strftime('%Y-%m-%dT%H:%M:%fZ', 'now'))"`.

- [ ] **[DB-SYNC-03]** Insert tracker row for `0003_fix_session_times.sql` without running the SQL (already-converged data — prod has zero bare-string sessions): `wrangler d1 execute peerloop-db --remote --command="INSERT INTO d1_migrations (name, applied_at) VALUES ('0003_fix_session_times.sql', strftime('%Y-%m-%dT%H:%M:%fZ', 'now'))"`. Tracker-only — keeps `wrangler d1 migrations list` clean.

- [ ] **[DB-SYNC-02-RENAME]** Rename the stale tracker entry `0002_seed.sql` → `0002_seed_core.sql` to match the current filename: `wrangler d1 execute peerloop-db --remote --command="UPDATE d1_migrations SET name = '0002_seed_core.sql' WHERE name = '0002_seed.sql'"`. Cosmetic — but `wrangler d1 migrations list` will then return clean "No migrations to apply" instead of falsely listing 0002_seed_core.sql as pending.

- [ ] **[PROD-PW-APPLY]** Execute the deferred `Peerloop2` rotation against prod admin (was Conv 168 deferred, redirected here Conv 169). **Three sub-steps, all in this same DB-SYNC bundle:**
  1. Edit `migrations/0002_seed_core.sql:172` — replace the `Password1` hash (`$2b$10$Mc4KOG9BDrsrhzJZznRipeGBmQbYHxxxa..IIemgOSUIpMq0wxJk6`) with the `Peerloop2` hash (`$2b$10$tQMUTTuSbJiuqpITHrCN7.PMrqqkJTZROlbhZkPfvLKYEtcAsflXi`) — same hash used in `migrations-dev/0001_seed_dev.sql` and `src/lib/mock-data.ts:1485`. Update the file comment at line 168 too.
  2. `wrangler d1 execute peerloop-db --remote --command="UPDATE users SET password_hash = '<hash>' WHERE id = 'usr-admin'"` against prod.
  3. Verify by logging into prod as `admin@peerloop.com` / `Peerloop2`.

- [ ] **[DB-SYNC-VERIFY]** Final convergence check — `wrangler d1 migrations list peerloop-db --remote` should report "No migrations to apply"; spot-check `SELECT name FROM sqlite_master WHERE name IN ('feed_visits','feed_activities')` returns both; spot-check `SELECT substr(password_hash,1,12) FROM users WHERE id='usr-admin'` returns `$2b$10$tQMU...` (Peerloop2) not `$2b$10$Mc4K...` (Password1).

**Rationale for bundling:** Each individual task is small and could be done separately, but the DECISIONS.md §4 principle ("bundle so live prod and seed never disagree") generalizes — applying these one-by-one over multiple convs leaves prod in successively-different intermediate states, none of which match any reference (local/staging/seed-file). Batching makes the diff a single atomic step.

**Why not run now (Conv 169):** User direction — route into the existing pre-production block rather than mutate prod mid-conv. Apply when the DEPLOYMENT block is actively being worked.

### DEPLOYMENT.PROD — Production cutover

**Prerequisites (before first prod deploy):**
- [ ] Create the `peerloop` Worker in the Cloudflare Dashboard (Workers & Pages → Create → Worker → "Hello World" template → rename to `peerloop`). First `wrangler deploy` will overwrite the stub. *Note: the accidental `peerloop` Worker from Conv 114 was deleted; it no longer exists.*
- [ ] Confirm the prod KV `SESSION` namespace ID in `wrangler.toml` (`7605e3a3...`) is correct for the production account — verify in CF Dashboard that this namespace exists and is not a staging leftover. If wrong, create a new prod KV namespace and update the top-level `[[kv_namespaces]]` in `wrangler.toml`.
- [ ] Confirm prod D1 `peerloop-db` and R2 `peerloop-storage` resources exist and contain the intended production data (not test seed). **Tracked separately: DEPLOYMENT.DB-SYNC above covers prod D1 migration convergence.**
- [ ] Upload production secrets to the `peerloop` Worker via `wrangler secret bulk` — JWT_SECRET, BBB_SECRET, RESEND_API_KEY, STRIPE_SECRET_KEY (live `sk_live_...`, not test), STRIPE_WEBHOOK_SECRET (separate prod webhook in Stripe Dashboard), STREAM_API_SECRET (prod Stream.io key). See `docs/reference/cloudflare.md` §Secrets for the bulk-upload recipe. **Do NOT reuse staging secrets for production.**

**Cutover:**
- [ ] Deploy `peerloop` Worker via `npm run deploy:prod` (tests `confirm-prod.js`)
- [ ] Smoke test the `.workers.dev` URL before any DNS change
- [ ] Configure custom domain routing in CF dashboard (`peerloop.com` → Worker)
- [ ] Verify production DNS resolves to Worker, not old Pages project
- [ ] Delete the old CF Pages project (after prod cutover verified stable)

### DEPLOYMENT.STAGING-DOMAIN — Staging custom domain (optional)

- [ ] If desired: `staging.peerloop.com` → Worker Routes (replaces `.workers.dev`)

### DEPLOYMENT.STAGING-FOLLOWUPS — Discovered during Conv 116 staging verification

- [x] **[VS]** Staging seed scripts unblocked — fixed 3 stale `--env preview` references in `scripts/reset-d1.js` (2) + `scripts/plato-seed-staging.js` (1); live reset → migrate → seed:staging → seed:booking:staging → seed-feeds.mjs all green (Conv 116)
- [x] **[SF]** SSR self-fetch 404 regression on Workers — refactored 8 community/discover `.astro` pages + 3 `/api/communities/*` handlers to use new `src/lib/ssr/loaders/communities.ts`; extended `SSRDataError` with UNAUTHORIZED/FORBIDDEN; ~750 LOC net deletion; all 4 community slugs + 3 API endpoints return 200 on staging; 6392/6392 tests pass (Conv 116)
- [x] **[CF-TOKEN]** Rotated `CLOUDFLARE_API_TOKEN` to User API Token `peerloop-wrangler-full` with D1/Workers/KV/R2/Observability/Routes + User:Memberships:Read + User:User Details:Read; set `CLOUDFLARE_ACCOUNT_ID` in `.dev.vars` to disambiguate multi-account token (Conv 116)
- [ ] **[RS]** `scripts/reset-d1.js` doesn't drop orphan tables outside current schema — Conv 116 staging reset left legacy `users`, `user_interests`, `user_topic_interests`, `categories` tables (not in `0001_schema.sql`) that FK-blocked the drop-in-dependency-order pass. Required manual DROP. Fix: query `sqlite_master` for ALL non-system tables, not just ones in current schema.
- [ ] **[DS]** `npm run dev:staging` doesn't actually use remote bindings — `remoteBindings: true` in adapter 13 config appears to be a no-op. Dev server reads empty local miniflare D1 sandbox instead of remote staging D1. Suspect adapter 13 / vite-plugin 1.31.2 regression. Blocks the "post-adapter-migration smoke test" workflow that would have caught [SF] earlier.
- [ ] **[PE]** `platform_stats.environment` marker row not seeded by `migrations/0002_seed_core.sql` — `/api/debug/db-env` returns 'unknown' for remote D1s even when data is correctly populated.

**Learning (folded into tech docs by r-end):** CF Workers + Static Assets route SSR self-fetches to the Assets layer which 404s plain-text; `[assets].run_worker_first` has ZERO effect on Worker-internal subrequests (only external-edge routing). Fix was Path B — refactor to direct loader imports — per CLAUDE.md §Solution Quality.

---

## Active: CALENDAR

**Focus:** Custom multi-view calendar component system serving all platform roles
**Status:** 📋 PENDING
**Session:** 342

**Vision:** A single, versatile custom calendar component that powers every time-based view on the platform — student schedules, S-T availability and sessions, admin oversight, and activity history. Supports year, month, week, and day views with role-specific data layers, filtering, and clickable items. Built custom (not wrapping a library) to fully control rendering, interaction, and data integration.

### Current State

The platform has three separate calendar-like UIs, each built independently:

| Component | Views | Limitation |
|---|---|---|
| `AvailabilityCalendar` | Month only | No week/day; cell interaction is availability-specific |
| `SessionBooking` (step 2) | Month only | Date picker only; no time-axis view |
| `AvailabilityQuickView` | Static week dots | Not interactive; summary only |

All other schedule UIs (TeacherUpcomingSessions, SessionHistory, StudentDashboard) are lists or tables with no calendar visualization. `react-big-calendar` is installed but unused.

### CALENDAR.CORE — Base Component Architecture

*The shared calendar engine that all role-specific views build on*

- [ ] `PeerloopCalendar` base component with view modes: Year, Month, Week, Day
- [ ] View switcher UI (toolbar with Year | Month | Week | Day toggle)
- [ ] Navigation controls (prev/next, today button, date range display)
- [ ] Timezone-aware date handling (all views respect user timezone)
- [ ] Slot rendering system — calendar "items" rendered as colored blocks/badges:
  - Items have: title, time range, color/category, click handler, optional icon
  - Week/Day views: time-axis layout (vertical hours, items as positioned blocks)
  - Month view: items as compact badges within day cells
  - Year view: heat-map style (activity density per day)
- [ ] Filter bar — toggle data layers on/off (checkboxes or pills)
- [ ] Click-through — items are clickable, navigate to detail page or open detail modal
- [ ] Responsive: week/day views scroll horizontally on mobile; month/year stack vertically
- [ ] Empty state handling per view mode

**Design principle:** The calendar component knows how to render items in time. It does NOT know what the items are. Each integration passes typed item arrays with colors, labels, and click targets.

### CALENDAR.STUDENT — Student Schedule View

*Replace the flat list on StudentDashboard with a real calendar*

- [ ] Week view (default) showing upcoming sessions across all enrolled courses
- [ ] Day view for detailed single-day schedule
- [ ] Month view for planning ahead
- [ ] Data layers:
  - Booked sessions (color-coded by course)
  - Available booking slots (if enrollment has remaining sessions)
- [ ] Click session → navigate to `/session/:id`
- [ ] Click available slot → navigate to booking flow
- [ ] Integration point: StudentDashboard and/or dedicated `/schedule` page

### CALENDAR.TEACHER — Teacher Schedule View

*Unified Teacher calendar replacing AvailabilityQuickView + TeacherUpcomingSessions*

- [ ] Week view (default) showing sessions + availability on the same time axis
- [ ] Day view for detailed daily schedule
- [ ] Month view (replaces or augments existing AvailabilityCalendar)
- [ ] Data layers (toggleable):
  - Booked sessions (color-coded by course or student)
  - Availability windows (recurring slots as background shading)
  - Availability overrides (blocked time, adjusted hours)
  - Buffer time between sessions (visual gap)
- [ ] Click session → navigate to `/session/:id`
- [ ] Click availability block → edit availability
- [ ] Integration point: TeacherDashboard and/or `/teaching/schedule`

**Note:** The existing AvailabilityCalendar with its multi-select-days-and-set-times interaction may remain as a separate editing UI. The CALENDAR.TEACHER view is for *viewing* the schedule, not editing availability.

### CALENDAR.ADMIN — Admin Oversight Calendar

*Platform-wide activity calendar with extensive filtering*

- [ ] All four views: Year, Month, Week, Day
- [ ] Data layers (toggleable, expect this list to grow):
  - **Sessions:** All platform sessions (booked, completed, cancelled, no-show)
  - **Enrollments:** Enrollment events (new, completed, dropped, refunded)
  - **Community activity:** Townhall feed posts, community feed posts
  - **Course activity:** New courses published, materials updated
  - **User events:** Signups, S-T certifications, creator applications
  - **Payments:** Checkout completions, refunds, disputes, payouts
  - **Notifications:** System notifications sent
- [ ] Filters:
  - By role: Student, S-T, Creator, Admin
  - By course: specific course or all
  - By user: specific user or all
  - By event type: sessions, enrollments, community, payments, etc.
  - By status: active, completed, cancelled, etc.
  - Date range quick-picks: Today, This Week, This Month, This Quarter
- [ ] Click any item → navigate to its detail page (session detail, enrollment detail, user profile, etc.)
- [ ] Year view as activity heat map (GitHub-contribution-style) for spotting trends
- [ ] Export/print view (stretch goal)
- [ ] Integration point: Admin dashboard, possibly `/admin/calendar`

### CALENDAR.MIGRATE — Migrate Existing Calendar UIs

*After core is built, migrate existing custom grids to the new system*

- [ ] Evaluate whether `AvailabilityCalendar` editing interaction can use the new month grid or needs to stay separate
- [ ] Migrate `SessionBooking` date picker step to use new month view
- [ ] Replace `AvailabilityQuickView` with a compact week view from the new system
- [ ] Remove `react-big-calendar` from `package.json` (never used, dead dependency)

### CALENDAR.ICS
*.ics calendar file attachments for session booking emails*

**Current state:** `SessionBookingEmail.tsx` sends booking confirmation with BBB link. No `.ics` (iCalendar) file attached. (Capabilities review Session 359)

- [ ] Generate `.ics` file content for booked sessions (VEVENT with start/end, BBB join URL, attendees)
- [ ] Attach `.ics` to `SessionBookingEmail` and `SessionRescheduledEmail`

### Design Notes

**Data fetching pattern:** Each data layer is an independent API call. The calendar component accepts `items: CalendarItem[]` and the parent page fetches and combines layers based on active filters. This keeps the calendar component pure and testable.

```typescript
// Shared item type all data layers produce
interface CalendarItem {
  id: string;
  title: string;
  start: Date;
  end: Date;
  category: string;       // 'session' | 'enrollment' | 'availability' | 'feed' | ...
  color: string;           // Tailwind color class or hex
  icon?: string;           // Optional icon identifier
  href?: string;           // Click-through URL
  onClick?: () => void;    // Or custom click handler
  metadata?: Record<string, unknown>; // Role-specific extra data
}
```

**Phased delivery:** CORE → STUDENT → TEACHER → ADMIN → MIGRATE. Each phase delivers value independently. The admin calendar (most complex) comes last because it has the most data layers and benefits from patterns established in the simpler views.

**Why custom, not react-big-calendar:** The platform needs cell-level control that libraries don't provide — availability multi-select, heat-map year views, togglable data layers with role-specific filtering, and consistent styling with the existing Tailwind design system. A library would fight us on every customization. Building custom means the calendar grows with the platform.

**Week/Day vs Month are architecturally different:** Month view is a grid of day cells with badges. Week/Day views have a vertical time axis (e.g., 6am-10pm) where items are absolutely positioned blocks based on start/end time. The core component must handle both layout modes.

---


## Planned: PACKAGE-UPDATES

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

### Phase 2a Follow-ups

- [ ] Drop `_locals` parameter from `getEnv`/`getDB`/`getR2` helpers in a dedicated sweep commit (Fork 2 = X deferral from Conv 101; ~130 call sites) — task [DL] *(Conv 107: investigated, `locals` param is actively used for `__testEnv` injection — not dead code. The `_locals` unused-parameter version does not exist. Task reframed: the sweep would remove the parameter from production call sites where `__testEnv` is never passed, but this is low-value.)*
- [ ] End-to-end validate `npm run dev:staging` with `CLOUDFLARE_ENV=preview` against remote staging D1/R2 — task [DV] *(folded into PLATO testing phase)*

### Phase 2b — TypeScript 5→6 (deferred, ecosystem gap) — task [T6]

*Blocked by peer deps — Astro 6 vendors `tsconfck` pinned to TS ^5.0.0; `@astrojs/check` and `@typescript-eslint/*` not yet TS 6 compatible. TS 6.0.2 is a "bridge release" toward the TS 7 native rewrite.*

- [ ] Criteria to revisit: `npm ls typescript` shows no "invalid peer" markers for `@astrojs/check`, `@typescript-eslint/*`, and Astro-vendored `tsconfck`
- [ ] typescript 5.9.3 → 6.x
- [ ] Fix type errors surfaced by TS 6
- [ ] Run full five-gate baseline

### Phase 6 — Cleanup + PR merge — task [P6]

- [x] Verify five-gate baseline on final commit (tsc / astro check / lint / test / build) — Conv 106
- [x] Update any remaining docs referencing old versions — Conv 106 (3 "Astro 5.x" → "Astro 6.x" refreshes)
- [x] ~~Add ESLint rule or `/w-codecheck` grep check enforcing: no direct `locals.runtime?.env?.*` access outside helper files~~ — implemented as `/w-codecheck` grep rule (Conv 107), not ESLint
- [x] ~~`gh pr create jfg-dev-10up → jfg-dev-9`~~ — **Superseded (Conv 108):** `jfg-dev-10up` promoted to latest working branch; no merge back to `jfg-dev-9`
- [x] Fix all remaining E2E failures (4 pre-existing: login race, browse-enroll redirect, admin-overview, session-completion-flow rewrite) — Conv 108 (137/137 passing)
- [x] PLATO manual testing — flywheel all 14 intents verified (Conv 108); Stripe checkout required manual user intervention (known limitation — Chrome MCP can't interact with external Stripe pages)
- [x] Post-PLATO: five-gate baseline + E2E full pass — Conv 108 (tsc 0 / lint 0 / tests 6399/6399 / build / E2E 18 passed)
- [x] Browser smoke test of /discover/members — Creator filter, multi-role, search, All Members all verified — Conv 112
- [x] Staging smoke test: `npm run dev:staging` end-to-end validate against remote staging D1/R2 — before final staging merge — ✅ verified Conv 146 (seed-feeds are always fresh on each invocation; Smart feeds consistent with decay parameters)

### Codecheck Rule Follow-ups (discovered Conv 105 during [HW])

- [x] **[SF]** /w-codecheck rule: detect "error-captured-never-rendered" — grep-based check for `setError` without render. Implemented Conv 107. ([HD2] AST detector assessed as disproportionate — grep sufficient.)

### Test Hardening Follow-ups (discovered Conv 102)

*Surfaced during the `json<T>` sweep and pre-existing failure root-cause. Picked up opportunistically.*

- [x] **[AM]** Fixed `isSlotWithinAvailability` midnight-spanning bug — added `windowToUtc()` helper that advances end date by 1 day when `endTime <= startTime`. All 85 availability + 606 session tests pass — Conv 107
- [x] **[TT]** Swept `Date.now()+Nh` fragility in 5 high-risk test files — migrated to shared `futureUTC(days, utcHour)` helper in `tests/helpers/dates.ts`. 606/606 session tests pass — Conv 107
- [x] **[DH]** Dead helper audit — deleted 5 unused functions (`getResponseJSON`, `expectSuccess`, `expectError`, `expectJSONResponse`, `expectRedirect`) + `APIErrorResponse` interface from `api-test-helper.ts`, updated re-export index — Conv 107
- [x] **[VS]** Created `npm run verify` composite script chaining all five gates (`typecheck && check && lint && test && build`) — Conv 107

### ESLint v10 Post-Upgrade Gotcha (surfaced Conv 143)

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

---

## Nearly Complete: SEEDDATA

Database seeding strategy and empty state handling.
**Status:** 🟡 NEARLY COMPLETE (only EMPTY_STATE remaining, deferred to POLISH)

**Completed:** Full seed data overhaul (Session 285). All 59 tables seeded. Conv 083 password standardization (all `Password1`). PLATO seed path activated. Two parallel seed paths: SQL (`db:setup:*`) and PLATO (`plato:seed*`).

### SEEDDATA.EMPTY_STATE (Deferred → POLISH)
- [ ] Test each page with zero records
- [ ] Verify empty state messages display correctly
- [ ] Test first-user / first-course / first-enrollment flows

---

## Deferred: POLISH

Production readiness items.

### POLISH.VALIDATION
- [ ] API request body validation (Zod)
- [ ] Webhook payload validation (Stripe, BBB)
- [ ] Form validation schemas
- [ ] Environment variable validation

### POLISH.ROLES
- [ ] Course-scoped vs global role semantics
- [ ] Multi-role user navigation
- [ ] Admin impersonation model
- [ ] Admin user creation UI (from ROLES.CREATE_UI)

### POLISH.TECHNICAL_DEBT
- [ ] Status field inconsistency (boolean vs enum) + type-safe helpers
- [x] Full getNow() sweep (Conv 090)
- [ ] MergedPeople.tsx broken `/@[uuid]` URLs (Conv 047)
- [x] Replace all `prompt()` calls with FormModal (Conv 080)
- [x] `users.last_login` column is dead — never written to by any code, always NULL; admin analytics `/api/admin/analytics` queries it for "active in last 30/60 days" returning 0 for all users (Conv 111) — **Fixed Conv 112:** `recordLogin()` helper added to `session.ts`, called from all 4 auth endpoints
- [ ] Consolidate `detect-changes.sh` + `dev-env-scan.sh` from `r-end/scripts/` to `.claude/scripts/` — same pattern as Conv 133's consolidation (deferred from DOC-SYNC-STRATEGY Phase 2)
- [ ] Full resync of `docs/reference/resend.md` template table — phantom entries (`BookingConfirmationEmail`, `SessionCompletedEmail`) + ~9 real templates missing (SessionBooking, SessionCancelled, SessionRescheduled, FeedbackReminder, ModeratorInvite, EnrollmentConfirmation, CertificateIssued, 3× CreatorApplication); Conv 133 only fixed the 3 SessionInvite rows (deferred from DOC-SYNC-STRATEGY Phase 2)
- [x] **[LE-TRIAGE]** — Completed: see COMPLETED_PLAN.md §POLISH.LINT_EXHAUSTIVE_DEPS (Conv 147-149)


### POLISH.SECURITY_HARDENING
- [ ] Audit logging for admin actions (see OBSERVABILITY.AUDIT-LOG)
- [ ] Rate limiting on sensitive endpoints
- [ ] Explicit role checks where derived permissions are used
- [ ] Proper token refresh flow — refresh token currently used as direct auth credential in `getSession()` fallback, granting 7-day privileged API access after 15-min access token expires. Needs: refresh endpoint + client auto-refresh + getSession fix (Conv 112)

### POLISH.DEFERRED_FEATURES
- [ ] Session reminders (Cloudflare cron)
- [ ] Compatible member matching (Jaccard similarity)
- [ ] User → Member rename (platform-wide)
- [ ] Community filtering by topic on `/discover/communities`
- [ ] Remove MyXXX pages — pending client agreement (Conv 054)
- [ ] Smart Feed algorithm UX simplification (Conv 059)
- [ ] Student profile — "Following Courses" section using `GET /api/me/course-follows` (deferred from COURSE-FOLLOWS block, Conv 138)
- [x] Email notification fallback for session invites — Conv 130: 3 email templates (SessionInviteEmail, SessionInviteAcceptedEmail, SessionInviteDeclinedEmail); fire-and-forget on create/accept/decline paths; also fixed gap in decline.ts (missing in-app notification to teacher added). All use `session_booked` preference type.

---

## Deferred: MVP-GOLIVE

**Focus:** Production readiness for all external service providers
**Status:** ⏸️ DEFERRED (until launch decision)
**Last Audited:** Session 223 (2026-02-18)

All code is implemented and tested in dev/preview environments. Go-live requires adding production secrets to Cloudflare, registering endpoints in provider dashboards, and verifying DNS/domain configuration. No code changes expected — this is all infrastructure and configuration.

### Production Readiness Scorecard

| Provider | Code | Dev/Preview | Prod Secrets | Prod Config | Ready? |
|----------|:----:|:-----------:|:------------:|:-----------:|:------:|
| **Stripe** | ✅ | ✅ Staging webhook active | ❌ Deferred | ❌ Prod webhook not registered | 🟡 |
| **Stream.io** | ✅ | ✅ | ❌ Not set | ⚠️ Verify feed groups in prod app | 🟡 |
| **Resend** | ✅ | ✅ | ❌ Not set | ❌ Domain not verified, DNS not set | 🔴 |
| **BigBlueButton** | ✅ | ✅ Blindside Networks | ❌ Not set | ❌ Prod webhook not registered | 🟡 |
| **Google OAuth** | ✅ | ❌ No credentials | ❌ Not set | ❌ Not registered in Google Console | 🔴 |
| **GitHub OAuth** | ✅ | ❌ No credentials | ❌ Not set | ❌ Not registered in GitHub | 🔴 |
| **Cloudflare** | ✅ | ✅ | ❌ Not set | ✅ Bindings configured | 🟡 |

### MVP-GOLIVE.AUTH
*Re-evaluate auth approach before launch*

- [ ] Re-evaluate JWT auth vs Astro Sessions — assess whether any workarounds during development would be better served by session-based auth (see `docs/as-designed/auth-sessions.md`)

### MVP-GOLIVE.STRIPE
*Payment processing and marketplace payouts*
**Tech Doc:** `docs/reference/stripe.md` (comprehensive webhook docs added Session 223)

**What's done:** Complete Stripe Connect integration — checkout, transfers (with idempotency keys), refunds, 7 webhook handlers (including dispute handling with transfer reversal), self-healing status sync, Express onboarding flow tested end-to-end. Staging webhook active at `staging.peerloop.pages.dev` (Session 224). Enrollment self-healing fallback for missed webhooks — success page SSR + /courses localStorage bridge (Session 324). Fixed `enrollments.student_teacher_id` FK mismatch (was inserting st-xxx instead of usr-xxx, Session 324). Fixed teacher profile session count JOINs and ST booking URL pre-selection (Session 324).

**Go-live steps:**
- [ ] Add `STRIPE_SECRET_KEY` (`sk_live_...`) to CF Dashboard Production secrets
- [ ] Register webhook endpoint in Stripe Dashboard (live mode):
  - URL: `https://<production-domain>/api/webhooks/stripe`
  - Events: `checkout.session.completed`, `charge.refunded`, `account.updated`, `transfer.created`, `charge.dispute.created`, `charge.dispute.closed`
- [ ] Copy generated `whsec_...` to CF Dashboard as `STRIPE_WEBHOOK_SECRET`
- [ ] Update `STRIPE_PUBLISHABLE_KEY` in `wrangler.toml` top-level `[vars]` to `pk_live_...`
- [ ] Test with real $1 charge → verify webhook arrives → refund immediately
- [ ] Configure Stripe branding (Dashboard → Settings → Branding):
  - [ ] Update account display name from "Alpha Peer LLC" to "Peerloop"
  - [ ] Upload Peerloop logo/icon (appears on Connect onboarding left panel)
  - [ ] Set brand color and accent color to match Peerloop palette

**Caveat:** Live-mode keys were intentionally deferred (Session 207, tech-026) to prevent accidental real charges during development.

**Pre-launch hardening:**
- [ ] Stripe Event Polling via Cron Trigger — catch-up for missed webhooks (enrollment self-healing done in Session 324; still needed for transfers, disputes, payout failures)
- [ ] Extended self-healing — reconcile transfer/dispute status on relevant page loads (enrollment self-healing done in Session 324; extend pattern to other entities)
- [ ] Dynamic admin lookup for dispute notifications (currently hardcoded to `'usr-admin'`; should query for admin role)
- [ ] Dispute evidence submission tooling (currently admin responds via Stripe Dashboard directly)
- [ ] `payout.failed` webhook endpoint (requires separate Connected accounts webhook in Stripe Dashboard)
- [ ] `checkout.session.expired` handler (clean up pending enrollments from abandoned checkouts)
- [ ] `transfer.reversed` handler (safety net for confirming transfer reversals)
- [ ] `/api/dev/simulate-checkout` endpoint (dev-only, skips Stripe Checkout redirect for faster manual testing)

### MVP-GOLIVE.STREAM
*Activity feeds (GetStream.io)*
**Tech Doc:** `docs/reference/stream.md`

**What's done:** REST API client (edge-compatible, no Node SDK), feed groups configured in dev app, enrollment-triggered follow relationships, course discussion feeds.

**Current config:**
- Dev/Preview app: `1457190` (configured in `wrangler.toml [env.preview.vars]`)
- Production app: `1456912` (configured in `wrangler.toml` top-level `[vars]`)

**Go-live steps:**
- [ ] Add `STREAM_API_SECRET` (prod app secret) to CF Dashboard Production secrets
- [ ] Verify Stream Dashboard (prod app `1456912`) has all feed groups:
  - `townhall` (flat), `course` (flat), `community` (flat)
  - `notification` (notification), `timeline` / `timeline_aggregated` (aggregated)
- [ ] Test feed creation and activity posting against prod app
- [ ] Verify token generation works with prod app credentials

**Note:** `STREAM_API_KEY` and `STREAM_APP_ID` are non-secrets already in `wrangler.toml`.

### MVP-GOLIVE.RESEND
*Transactional email*
**Tech Doc:** `docs/reference/resend.md`

**What's done:** SDK integrated, React Email templates framework, Cloudflare Workers compatible.

**API key status:** Verified working (Session 252, 2026-02-22). Dev key can send emails successfully. Without a verified domain, Resend restricts recipients to the account owner's email only.

**Go-live steps (CRITICAL — has lead time):**
- [ ] **Domain verification** — see **RESEND-DOMAIN** section above (moved out of go-live; do ASAP to unblock testing)
- [ ] Add `RESEND_API_KEY` (prod key `re_ZpBp...`) to CF Dashboard Production secrets
- [ ] Complete email templates: welcome, verification, password reset, session booking, payment receipt
- [ ] Test email delivery to real inboxes (check spam scoring)
- [ ] Implement email verification flow (depends on domain verification)
- [ ] Test moderator invite flow end-to-end (email delivery requires domain verification)
- [ ] (Optional) Configure Resend webhooks for bounce/complaint handling

**Caveat:** Without domain verification, emails send from `onboarding@resend.dev` which looks unprofessional and may be spam-filtered. Start DNS setup early.

### MVP-GOLIVE.BBB
*Video sessions (BigBlueButton via Blindside Networks)*
**Tech Doc:** `docs/reference/bigbluebutton.md`

**What's done:** VideoProvider interface, BBB adapter (with `!` encoding and URL normalization fixes), session CRUD + join + reschedule APIs, webhook handler, `/session/[id]` page, SessionRoom with `window.open()` + polling, recording endpoint, StudentDashboard upcoming sessions. Blindside Networks selected as managed BBB provider (no self-hosting needed).

**Go-live steps:**
- [ ] Get production BBB_SECRET from Blindside Networks (Binoy Wilson, `binoy.wilson@blindsidenetworks.com`)
- [ ] Add `BBB_SECRET` to CF Dashboard Production secrets
- [ ] `BBB_URL` already in `wrangler.toml` for all environments
- [ ] Configure BBB webhooks to call `https://<production-domain>/api/webhooks/bbb`
- [ ] Test meeting creation, join URLs, and recording with Blindside server

**Note:** No server provisioning needed — Blindside Networks provides managed BBB SaaS.

### MVP-GOLIVE.OAUTH
*Social login (Google + GitHub)*
**Tech Doc:** `docs/reference/google-oauth.md`

See OAUTH block for full checklist.

**Key lead-time item:** Google OAuth consent screen verification takes **1-2 weeks** for apps with >100 users. Start early.

### MVP-GOLIVE.CLOUDFLARE
*Infrastructure: D1, R2, KV, Pages*

**What's done:** All bindings configured in `wrangler.toml`. D1 databases exist (`peerloop-db` for prod, `peerloop-db-staging` for preview). R2 bucket `peerloop-storage` configured for both environments. KV namespace `SESSION` removed Conv 095 (unused — re-add for feature flags post-MVP).

**Go-live steps:**
- [ ] Add all secrets to CF Dashboard Production tab:
  - `JWT_SECRET` (generate fresh with `openssl rand -base64 32`)
  - All provider secrets listed above (Stripe, Stream, Resend, BBB, OAuth)
- [ ] Run `npm run db:migrate:prod` to apply schema to production D1
- [ ] Run `npm run db:setup:local:clean` to test fresh-install flow (no dev seed data)
- [ ] Verify R2 bucket permissions for production reads/writes
- [ ] Re-add KV `SESSION` namespace if feature flags needed (removed Conv 095)
- [ ] Configure custom domain in CF Pages (e.g., `peerloop.com`)
- [ ] Set up DNS records pointing domain to CF Pages

### MVP-GOLIVE.DOMAIN
*Production domain setup (prerequisite for most providers)*

**Why this matters:** Most provider registrations (Stripe webhook URL, OAuth callback URLs, Resend domain verification) require knowing the **exact production domain**. This should be decided first.

- [ ] Decide production domain (e.g., `peerloop.com`, `app.peerloop.com`)
- [ ] Configure domain in Cloudflare DNS
- [ ] Point domain to CF Pages deployment
- [ ] Verify HTTPS is working
- [ ] Update all provider configurations with final domain

### MVP-GOLIVE.EXECUTION_ORDER

Recommended order based on dependencies and lead times:

| Step | Provider | Why This Order | Lead Time |
|------|----------|---------------|-----------|
| 1 | **Domain** | All other providers need the production URL | Hours |
| 2 | **Cloudflare** | Secrets + DB migration; foundation for everything | Hours |
| 3 | **Resend** | DNS verification has variable wait time | Hours-24h |
| 4 | **Google OAuth** | Consent screen verification takes 1-2 weeks | **1-2 weeks** |
| 5 | **GitHub OAuth** | Quick registration, no verification needed | Minutes |
| 6 | **Stream.io** | Just add secret + verify feed groups | Minutes |
| 7 | **Stripe** | Register webhook + add secrets; test last | Hours |
| 8 | **BBB** | Heaviest infra; can defer if needed | Days-weeks |

### MVP-GOLIVE.OAUTH (absorbed Conv 095)

Code implemented and tested for both Google and GitHub OAuth. Missing: app registrations in provider consoles.

- [ ] Google: Create project, consent screen, OAuth Client ID, redirect URIs, add secrets to CF
- [ ] GitHub: Create OAuth App, callback URL, add secrets to CF
- [ ] Google consent screen verification: **1-2 weeks** for >100 users — start early
- [ ] See `docs/reference/google-oauth.md` for full walkthrough

### MVP-GOLIVE.CRON-CLEANUP (absorbed Conv 095; extended Conv 141 / Phase B)

**Status:** Phase A (infra) ✅ COMPLETE | Phase B (BBB-FIX) ✅ COMPLETE (Conv 142) | Awaiting 1-week staging health gate before Prod deploy

Currently `detectNoShows()` + `detectStaleInProgress()` + `reconcileBBBSessions()` run manually via admin. For production, add automated scheduled runs.

**Architectural decision (Conv 141):** `@astrojs/cloudflare 13` does not expose `workerEntryPoint` — the Astro Worker cannot cleanly add a `scheduled()` export. Decision: deploy cron as a **separate standalone Worker** (`peerloop-cron` / `peerloop-cron-staging`) sharing D1/R2 bindings via binding IDs. Cleaner separation, reusable for future Stripe polling cron.

**Phase A (Infra) — COMPLETE:**

- [x] Investigate Astro + CF adapter dual exports (`fetch` + `scheduled`) — resolved: adapter doesn't support; use separate Worker
- [x] Refactor `src/pages/api/admin/sessions/cleanup.ts` — extracted shared logic into `src/lib/cleanup.ts` (called by both the admin endpoint and the cron Worker)
- [x] Create `../Peerloop/workers/cron/` standalone Worker — `wrangler.toml`, `src/index.ts` with `scheduled()` export, shared D1/R2 bindings
- [x] Add `[triggers.crons]` to cron Worker's wrangler.toml (`*/15 * * * *` staging, `*/30 * * * *` prod)
- [x] Add npm scripts `deploy:cron:staging` / `deploy:cron:prod`
- [x] Deploy to staging; verified `wrangler tail` shows scheduled runs ✅ **First run 2026-04-21T09:30:35Z recovered 1 real missed BBB recording_ready webhook**

**Phase B scope (driven by `docs/as-designed/webhook-miss-resilience.md`):**

- [x] BBB-FIX: one-sided-crash timeout — `detectOrphanedParticipants()` function wired before `detectStaleInProgress` (Conv 142)
- [x] BBB-FIX: `INSERT OR IGNORE` guard on `participant_joined` attendance insert with partial unique index (Conv 142)
- [x] BBB-FIX: `duration_minutes` fallback — `completeSession()` backfill via `COALESCE(started_at, ?)` (Conv 142)
- [ ] Prod cron deploy — `deploy:cron:prod` + set prod BBB_SECRET (awaiting 1-week staging health gate, ~2026-04-28)
- [ ] Notification batching (daily digest vs individual alerts) — deferred; low priority until volume grows

### MVP-GOLIVE.STAGING-VERIFY (absorbed Conv 095)

Unified staging integration tests for all external services. Replaces BBB-VERIFY remaining items.

**Webhook miss-resilience (BBB + Stripe — Conv 141/143/144):** ✅ Phase A complete for both providers. BBB scenarios live-verified Conv 141/142. Stripe: direct-sign harness Conv 143, all 7 scenarios live-verified on staging Conv 144. Phase A uncovered a **production-blocker Stripe bug** (`constructEvent` → `constructEventAsync` — SubtleCryptoProvider sync-context failure on CF Workers since the Conv 114 migration; every Stripe webhook silently HTTP 400'd in staging). Fix deployed Conv 144. Three Phase B Stripe follow-ups added: [VD] `(student, course)` UNIQUE race, [VW] `webhook_log` `ctx.waitUntil()`, [VA] STRIPE_SECRET_KEY mode audit.

- [x] BBB: Harness extended + live-verified on staging; Phase B BBB-FIX block scoped; see CRON-CLEANUP
- [x] [VH] Stripe direct-sign POST helper — 7 events (`stripe-*-direct`) + `stripe-direct-raw` (Conv 143)
- [x] [VS] Stripe staging end-to-end verification — Conv 144: all 7 scenarios LIVE (S1–S7). See `docs/as-designed/webhook-miss-resilience.md §Stripe live-verified scenarios (Conv 144)`. Also hardened harness with `STUDENT_ID`/`COURSE_ID`/`SESSION_ID`/`TEACHER_ID`/`CREATOR_ID`/`TEACHER_CERT_ID` env-var overrides (was only `PENDING_ENR`/`CHECKOUT_ID`/`PI_ID`/`AMOUNT`). Also landed Stripe Mode Discipline decision (local=Test, staging=Sandbox, prod=Live) in `docs/DECISIONS.md §8` + `docs/reference/stripe.md`
- [x] **[Stripe constructEventAsync fix]** Prod-blocker bugfix (Conv 144) — `src/lib/stripe.ts` + `src/pages/api/webhooks/stripe.ts:64` switched to `await constructEventAsync()`. Deployed to staging 2026-04-21 version `254fa8e9`. Unit tests (17/17) pass
- [ ] Stream: verify feed creation + activity posting against staging app
- [ ] Resend: plus-addressed email capture (`fgorrie+{handle}@bio-software.com`), verify delivery
- [x] **[VD]** `handleCheckoutCompleted` early-return on `(student, course)` dedup (Phase B Stripe — Conv 145). Added partial-index-predicate-matching SELECT in `src/lib/enrollment.ts` after existing `pending_enrollment_id` idempotency check; matches `status IN ('enrolled', 'in_progress')` predicate exactly; on collision logs `ADMIN_ALERT duplicate_enrollment_attempt` warning and returns existing enrollment ID idempotently. Test added: `blocks duplicate-purchase when (student, course) already active`. Avoids SQLITE_CONSTRAINT_UNIQUE → HTTP 500 → Stripe retry storm when a fresh `pending_enrollment_id` collides with an existing enrollment for same student + course.
- [x] **[VW]** `webhook_log` INSERT wrapped in `ctx.waitUntil()` for Stripe + BBB (Phase B Stripe — Conv 145). Wrapped fire-and-forget `db.prepare(...).run().catch(...)` in `locals.cfContext.waitUntil(...)` at `src/pages/api/webhooks/stripe.ts:75-85` and `src/pages/api/webhooks/bbb.ts:80-90`; updated test helper `cfContext` stub from `{}` to real shape with `waitUntil` + `passThroughOnException` no-ops. Fixes default-case (short-path) events losing their log entry due to fire-and-forget race with Worker context termination.
- [x] **[VA]** Audit staging Worker `STRIPE_SECRET_KEY` is a Sandbox `sk_test_` (not Test-mode) (Phase B Stripe — Conv 145). Built admin-gated `/api/admin/stripe-mode` endpoint (`src/pages/api/admin/stripe-mode.ts` + 4 tests) using `stripe.accounts.retrieveCurrent()`; deployed to staging Version `e5f00fb0`; verified staging account_id `acct_1SkSfYRu7i9fxxy0` = Sandbox workbench (not Test-mode `acct_1SkSfMRyHGcVUhoO`); mode aligned with webhook secret. Mode-split risk averted: `stripe.transfers.list()` will work correctly (no mode mismatch → reversals run as designed).
- [x] **[VL]** Rotate leaked `sk_test_...PP6iSq` Test-mode key (Phase B Stripe — Conv 145). Safe-grep audit: 5 occurrences in docs-repo Extracts (all redacted stubs, no full value leaked); `.dev.vars` clean; code repo clean. Stripe CLI cache refreshed via `stripe login` (Test-mode Standard key now current); final verification `grep -c "PP6iSq" ~/.config/stripe/config.toml` → 0. Hygiene complete; Test-mode only — does NOT affect Sandbox/staging or Live.
- [ ] **[STRIPE-UI-UPDATE]** Update `docs/reference/stripe.md` §Stripe Mode Discipline + §Per-Environment Webhook Configuration with note about Stripe Dashboard UI merging Test-mode into the Sandboxes listing page (screenshot: banner "Test mode is now part of sandboxes, so you can manage all of your test environments in one place.") — account-level isolation unchanged (`acct_1SkSfMRyHGcVUhoO` Test vs `acct_1SkSfYRu7i9fxxy0` Sandbox), but navigation has shifted from separate toggle to unified Sandboxes page. Discovered Conv 145 [VA] verification step.

### MVP-GOLIVE.RECORDING-PERSIST (absorbed Conv 095)

Cookie-based `.m4v` download implemented (Conv 037). Remaining:

- [ ] Verify `recording_url` populated by webhook on live BBB session
- [ ] Verify cookie-based download produces valid `.m4v`
- [ ] Confirm BBB shared secret matches `BBB_SECRET`
- [ ] Recording playback/download UI on session detail page
- [ ] Admin: expose `recording_size_bytes`, query recording status across sessions

---

## Deferred: PAGES-DEFERRED

**Focus:** 7 pages deferred per client directive — not yet designed for the Twitter-style left-side menu layout
**Status:** ⏸️ DEFERRED (post-MVP, pending client direction)
**Unimplemented stories:** 6 (US-S065, US-M004, US-C026, US-S081, US-P097, US-P099)

**Open question:** Current app pages use a Twitter-like left-side menu navigation. These more traditional/standard pages need layout decisions — do they use the same left-side menu pattern, or a different layout?

| Code | Page | Route | Stories | Notes |
|------|------|-------|---------|-------|
| HELP | Summon Help | `/help` | *(see GOODWILL block)* | Blocked on goodwill system |
| BLOG | Blog | `/blog` | — | Content not ready |
| CARE | Careers | `/careers` | — | Content not ready |
| CHAT | Course Chat | `/courses/:slug/chat` | US-S065, US-M004 | Superseded by community feeds |
| CNEW | Creator Newsletters | `/creating/newsletters` | US-C026 | Post-MVP |
| SUBCOM | Sub-Community | `/groups/:id` | US-S081, US-P097 | Post-MVP |
| CLOG | Changelog | `/changelog` | US-P099 | Gap story — no route exists yet |

---

## Deferred: RATINGS-EXT

**Focus:** Extended ratings features beyond core session/completion reviews
**Status:** 📋 PLANNING
**Tech Doc:** `docs/as-designed/ratings-feedback.md`

**Context:** Core rating system is complete (session assessments + completion reviews). These extensions add richer feedback dimensions and display.

### RATINGS-EXT.EXPECTATIONS

*Capture student goals/expectations at enrollment time*

- [ ] `enrollment_expectations` table (schema in tech-022)
- [ ] POST endpoint to capture expectations post-purchase
- [ ] Optional update after each session
- [ ] Display in completion review context ("did course meet expectations?")

### RATINGS-EXT.MATERIALS

*Separate course content quality rating from teaching quality*

- [ ] `course_reviews` table with optional sub-ratings (clarity, relevance, depth)
- [ ] Add `rating` and `rating_count` columns to `courses` table
- [ ] Two-part completion review modal (teaching + materials)
- [ ] Course page displays materials rating separately from Teacher rating
- [ ] Creator analytics: materials feedback breakdown

### RATINGS-EXT.DISPLAY

*Surface ratings in more places*

- [ ] Show completion reviews on Teacher public profile page
- [ ] Rating trend charts in Teacher/Creator analytics dashboards

---

## Deferred: EMAIL-TZ

**Focus:** Format notification/email times in recipient's local timezone
**Status:** 📋 PENDING
**Conv:** 002

**Context:** Conv 002 completed UTC-TIMES (session timezone normalization). Emails currently show times in UTC with "UTC" label. For polish, format in recipient's timezone — requires adding `timezone` column to users table and querying it during notification formatting.

- [ ] Add `timezone TEXT` column to users table (IANA timezone string, e.g., `America/New_York`)
- [ ] Populate during onboarding or profile settings (detect from browser `Intl.DateTimeFormat().resolvedOptions().timeZone`)
- [ ] Use `formatLocalTime(utcIso, userTimezone)` in session creation, reschedule, and cancellation email formatting
- [ ] Use `formatLocalTime()` in in-app notification text

---

## Deferred: PUBLIC-PAGES

**Focus:** Unified header/footer/nav/currentUser strategy for public-facing pages
**Status:** 📋 PENDING
**Session:** 385

**Context:** Session 385 audit found three layout/header components serving different page types, each with independent auth patterns:

| Layout | Header Component | Auth Pattern | Pages |
|--------|-----------------|--------------|-------|
| `AppLayout` | `AppNavbar.tsx` | `initializeCurrentUser()` (full `/api/me/full`) | ~54 authenticated pages |
| `AdminLayout` | `AdminNavbar.tsx` | `initializeCurrentUser()` (full `/api/me/full`) | 14 admin pages |
| `LandingLayout` | `Header.tsx` | `fetch('/api/auth/session')` (lightweight) | ~26 public pages |
| `LegacyAppLayout` | `AppHeader.tsx` | `fetch('/api/auth/session')` + notification count | Deprecated, still mounted |

**Problems to solve:**

1. **Header.tsx uses stale role booleans** — `/api/auth/session` returns `is_student`, `is_teacher`, `is_creator` as flat DB flags, not derived from actual course relationships. A user with `can_create_courses=true` but zero created courses shows "Creator Dashboard" link incorrectly.

2. **Header.tsx `getDashboardLink()` duplicates AppNavbar logic** — role-priority routing (admin → creator → teacher → student) is implemented independently in both components with different field names (`is_admin` vs `isAdmin`).

3. **No shared footer** — public and app pages have no consistent footer component. Marketing pages need footer nav (About, Privacy, Terms, etc.), app pages may need a slimmer version.

4. **AppHeader.tsx (legacy) is a dead-end** — has its own mobile sidebar with hardcoded routes that don't match AppNavbar. Should be removed once all pages use AppLayout.

5. **Public pages can't personalize for returning users** — e.g., `/courses` could show "Continue Learning" for enrolled courses, but Header.tsx doesn't initialize currentUser and there's no `getCurrentUserIfCached()` helper.

### PUBLIC-PAGES.HEADER-UNIFY

*Unify Header.tsx auth with currentUser cache*

- [ ] Add `getCurrentUserIfCached()` to `current-user.ts` — reads localStorage only, no fetch, returns `CurrentUser | null`
- [ ] Refactor `Header.tsx` to use `getCurrentUserIfCached()` instead of `/api/auth/session`
- [ ] Fall back to lightweight session fetch only if no cache exists (first-time visitor who never visited an AppLayout page)
- [ ] Replace stale `is_teacher`/`is_creator` booleans with currentUser's `isActiveTeacher()`/`hasCreatedCourses()` for accurate dashboard routing
- [ ] Extract shared `getDashboardLink(user)` utility used by both Header and AppNavbar

### PUBLIC-PAGES.LEGACY-CLEANUP

*Remove AppHeader.tsx and LegacyAppLayout*

- [ ] Audit which pages (if any) still use `LegacyAppLayout.astro`
- [ ] Migrate remaining pages to `AppLayout.astro`
- [ ] Delete `AppHeader.tsx` and `LegacyAppLayout.astro`
- [ ] Remove `AppHeader` from any component exports/barrels

### PUBLIC-PAGES.FOOTER

*Shared footer component for public and app pages*

- [ ] Design footer structure (links, social, copyright)
- [ ] Create `Footer.astro` component (zero JS, build-time)
- [ ] Add to `LandingLayout.astro`
- [ ] Decide whether app pages need a footer variant (likely no — sidebar layout doesn't need one)

### PUBLIC-PAGES.PERSONALIZATION

*Returning-user awareness on public pages (stretch)*

- [ ] `/courses` — show "Continue Learning" badge on enrolled courses via `getCurrentUserIfCached()`
- [ ] `/` (landing) — show "Go to Dashboard" instead of "Get Started" for cached users
- [ ] `EnrollButton` on public course pages — instant "Go to Course" for enrolled users (no fetch needed)

---

## Deferred: CERT-APPROVAL

**Focus:** Full certificate lifecycle — creator approval UI, student certificate page, PDF generation & R2 storage, dead link fixes
**Status:** 📋 PENDING
**Origin:** Session 359 (capabilities review), Conv 007 (seed data review), Session 390 (LearnTab blocker), Conv 042 (CompletedTabContent dead link)

### What Exists

| Piece | Status | Location |
|-------|--------|----------|
| `certificates` table | ✅ Full schema | `migrations/0001_schema.sql:650` — id, user_id, course_id, type (completion/mastery/teaching), status (pending/issued/revoked), certificate_url (always NULL), recommended_by, issued_by |
| Admin list/create | ✅ Built | `GET/POST /api/admin/certificates` — paginated listing with status/type filters + stats |
| Admin approve | ✅ Built | `POST /api/admin/certificates/[id]/approve` — pending→issued, syncs `teacher_certifications` for teaching certs, sends email via Resend (`CertificateIssuedEmail`) + notification |
| Admin reject | ✅ Built | `POST /api/admin/certificates/[id]/reject` — hard-deletes pending cert |
| Admin revoke | ✅ Built | `POST /api/admin/certificates/[id]/revoke` — issued→revoked, deactivates teaching cert if applicable |
| Teacher recommend | ✅ Built | `POST /api/me/certificates/recommend` — teacher recommends enrolled student, creates `pending` cert (validates: active teacher, certified for course, student enrolled, student completed for teaching certs) |
| My certificates | ✅ Built | `GET /api/me/certificates` — user's own certs with course/issuer joins |
| Public verify | ✅ Built | `GET /api/certificates/[id]/verify` — no-auth verification endpoint |
| CompletedTabContent | ⚠️ Dead link | `src/components/discover/detail-tabs/CompletedTabContent.tsx:40` — links to `/course/[slug]/certificate` (doesn't exist), has "coming soon" disclaimer |
| LearnTab | ⚠️ TODO | `src/components/courses/LearnTab.tsx:382` — commented TODO for certificate link |

### What's Missing

**The certificate lifecycle has 5 gaps:**

1. **Creator has no approval UI** — Only admin can approve/reject. The flywheel requires creators to certify their own students. Creator dashboard has no pending-certificates view.
2. **Creator not notified** — When a teacher recommends a student, no notification goes to the course creator. Only admin would see it.
3. **No student certificate page** — `/course/[slug]/certificate` doesn't exist. Two UI elements link to it (CompletedTabContent, LearnTab TODO).
4. **No PDF generation** — No library installed, no template designed, `certificate_url` is always NULL. R2 helpers exist (`src/lib/r2.ts`) but no cert-specific upload code.
5. **No public certificate view** — The verify endpoint returns JSON; there's no shareable HTML page for a certificate.

### CERT-APPROVAL.PHASE-1 — Dead Link Fix + Student Certificate Page

*Minimum viable: show certificate status to students who earned one, fix dead links*

- [ ] Create `/course/[slug]/certificate` page (Astro SSR)
  - Fetch user's certificate for this course via `GET /api/me/certificates` (filter by course)
  - States: not-authenticated → login redirect, no-certificate → "not earned", pending → "awaiting approval", issued → certificate display, revoked → revoked message
  - Issued state: show course name, student name, issue date, certificate ID, issuer name, type badge
  - If `certificate_url` exists: "Download PDF" button (for Phase 3)
  - If `certificate_url` is NULL: "PDF coming soon" note (graceful degradation)
  - Public share link: `/certificates/[id]/verify` (already exists as API, needs HTML page — see Phase 4)
- [ ] Fix CompletedTabContent dead link (`src/components/discover/detail-tabs/CompletedTabContent.tsx:40`)
  - Link should go to `/course/${courseSlug}/certificate` — URL is correct, just needs the page to exist
  - Remove "coming soon" disclaimer once page is live
- [ ] Fix LearnTab TODO (`src/components/courses/LearnTab.tsx:382`)
  - Add "View Certificate" link in completion celebration card
- [ ] Tests: certificate page rendering (all 5 states), auth redirect, data display

### CERT-APPROVAL.PHASE-2 — Creator Approval Flow

*Creator-facing certification management — the flywheel step where creators certify graduates*

- [ ] `GET /api/me/courses/[id]/pending-certificates` — list pending certs for a creator's course
- [ ] `POST /api/me/courses/[id]/certificates/[certId]/approve` — creator approves (reuse approve logic from admin endpoint, verify creator owns course)
- [ ] `POST /api/me/courses/[id]/certificates/[certId]/reject` — creator rejects with reason
- [ ] Creator notification: when teacher recommends a student, notify the course creator (new notification type: `cert.recommendation_received`)
- [ ] Creator dashboard UI: "Pending Certifications" section or tab showing students awaiting approval
  - Student name, course, recommending teacher, recommendation date
  - Approve / Reject buttons with confirmation
- [ ] Student notification on approval/rejection (approval notification already exists via admin flow — verify it fires for creator approval too)
- [ ] Tests: creator approval/rejection, authorization (only course creator can approve), notification delivery
- [ ] Build "Recommend for Certification" UI button on teacher-facing student views (Conv 082: `POST /api/me/certificates/recommend` has zero UI consumers)
- [ ] Fix dashboard attention item "Certification recommendation" → link to actionable destination (currently `/teaching/students` has no recommend action)
- [ ] Unified admin visibility for both certification paths (creator direct writes to `teacher_certifications` only; recommend/approve writes to `certificates` then syncs — admin Certificate Management page only shows `certificates` table)

### CERT-APPROVAL.PHASE-3 — PDF Generation & R2 Storage

*Generate certificate PDFs on approval and store to R2*

- [ ] Choose PDF library — candidates: `pdf-lib` (lightweight, no native deps, CF Workers compatible), `@react-pdf/renderer` (React-based templates), or server-side HTML→PDF
  - **Constraint:** Must work in Cloudflare Workers environment (no Puppeteer/Chrome)
- [ ] Design certificate template: course name, student name, date, certificate ID, type badge, creator signature area, verification QR code
- [ ] `generateCertificatePDF(cert)` function in `src/lib/certificates.ts`
- [ ] Hook into approve endpoint: generate PDF → upload to R2 at `certificates/{cert_id}/certificate.pdf` → store URL in `certificates.certificate_url`
- [ ] Update student certificate page: when `certificate_url` exists, show "Download PDF" button
- [ ] Seed data: add sample certificate URLs once generation works
- [ ] Tests: PDF generation, R2 upload, URL storage

### CERT-APPROVAL.PHASE-4 — Public Certificate Page (Optional)

*Shareable HTML certificate view — currently verify endpoint is JSON-only*

- [ ] Create `/certificates/[id]` public page (no auth required)
  - Shows: recipient, course, issuer, date, type, validity status
  - Revoked certs: show revoked status with date
  - QR code linking back to this page for physical certificate verification
- [ ] Update student certificate page: "Share" button with copyable public URL
- [ ] Consider: Open Graph meta tags for social sharing preview

---

## Post-MVP Phases

*After PMF confirmation:*

| Phase | Purpose | Notes |
|-------|---------|-------|
| 11 | Goodwill Points System | 25 stories (23 P2, 2 P3). Points engine, summon help, tiers, anti-gaming. Detail in git history (removed Conv 095). Source: CD-010, CD-011, CD-023. |
| 12 | Gamification (leaderboards, badges) | Partially covered by GOODWILL |
| 13 | Database Backups & Disaster Recovery | |
| 14 | Full Legal/Compliance Review | |
| 15 | Scalability Optimization | |
| 16 | Mobile/PWA + R2 Video Streaming | |
| 17 | User Documentation/Help Center | |
| 18 | Localization/i18n | |
| 19 | Feature Flags | Re-add KV bindings + KV-backed flags. See `docs/reference/cloudflare-kv.md`. KV removed Conv 095. |
| 20 | Payment Escrow | Not implemented — immediate transfer + clawback. Client decides (US-P074/75/76). |
| 21 | Session Credits | Schema exists, dispute path works. Redemption depends on GOODWILL. |

*Additional deferred features:*
- Certificate PDF generation (→ CERT-APPROVAL.PHASE-3)
- "Schedule Later" video booking (from VIDEO block)
- Feed promotion (→ FEEDS-NEXT.PROMOTION, 3 stories)
- PLATO: supporting runs, browser tests, harvest, docs, persona tags, runner design flaw, next-gen (design in `plato.md`)

---

## Unimplemented Story Summary

**32 stories** remain unimplemented out of 402 total (92% complete). All are P2 or P3 — **zero P0/P1 gaps**.

| Block | Stories | Priority | Notes |
|-------|---------|----------|-------|
| GOODWILL | 25 | P2 (23), P3 (2) | Largest cluster — full subsystem |
| FEEDS-NEXT.PROMOTION | 3 | P2 (1), P3 (2) | Depends on GOODWILL + FEEDS-NEXT.RANKING |
| PAGES-DEFERRED (CHAT) | 2 | P2 | Superseded by community feeds |
| PAGES-DEFERRED (SUBCOM) | 2 | P3 | User-created study groups |
| PAGES-DEFERRED (CNEW) | 1 | P3 | Creator newsletters |
| PAGES-DEFERRED (CLOG) | 1 | P2 | Changelog — gap story, no route |
| **Total** | **34** | | |

*Source: [ROUTE-STORIES.md](docs/as-designed/route-stories.md) §10 (On-Hold) and §11 (Gap)*

*Note: Count is 34 including US-P053 and US-P082 which have routes (`/discover/leaderboard`) but are blocked on the goodwill points data they need to display.*

---

## Active: ADMIN-REVIEW

**Focus:** Admin system review — testing gaps, UI consistency, cross-links, menu restructure, settings UI
**Status:** 📋 PENDING (promoted to active Conv 095)
**Absorbs:** ROLES (create UI, audit), ADMIN-SETTINGS-UI
**Conv:** 080 (audit only)

**Risk model:** 2 max users, high trust. Admins develop usage patterns and don't exercise breadth/edge cases. Regressions in decision-data (what the admin sees) or action-execution (what the admin does) are silently catastrophic — wrong data leads to wrong decisions, broken actions fail without the admin realizing.

**Audit baseline (Conv 080):**

| Layer | Source | Tested | Tests | File Coverage |
|-------|--------|--------|-------|---------------|
| Admin components | 28 | 19 | ~876 | 68% |
| Admin APIs | 67 | 55 | ~916 | 82% |
| Admin intel | — | 6 | ~50 | separate |
| Moderator component | 1 | 1 | 59 | 100% |
| **Total** | **96** | **81** | **~1900** | |

**Also completed Conv 080:** Replaced all 23 `prompt()` calls with `FormModal` across 6 admin/moderation files. Created `src/components/ui/FormModal.tsx`. Updated 2 test files.

### ADMIN-REVIEW.TESTING

**Gate question (ask at block start):** Full test implementation for all gaps, or risk-profile-prioritized subset?

#### Category 1: Decision Data — must be correct

These show admins the data they use to make decisions. Wrong/missing fields → wrong decisions.

| Gap | What It Shows | Decision It Feeds |
|-----|--------------|-------------------|
| `CreatorApplicationDetailContent` | Application for creator role | Approve/deny creator |
| `ModeratorDetailContent` | Moderator info + activity | Remove moderator |
| `UserEditModal` | Role editing form | Role assignment (escalation risk) |
| 12 × `[id].ts` API endpoints | Single-record fetch for detail panels | All detail views — a regressed field is invisible to the admin |

The 12 missing API endpoints (all GET single-record):
- `admin/enrollments/[id].ts`
- `admin/teachers/[id].ts`
- `admin/certificates/[id].ts`
- `admin/courses/[id].ts`
- `admin/sessions/[id].ts`
- `admin/users/[id].ts`
- `admin/payouts/[id].ts`
- `admin/topics/[id].ts`
- `admin/moderation/[id].ts`
- `admin/intel/courses.ts`
- `admin/intel/dashboard.ts`
- `admin/intel/communities.ts`

These are highly templatable — same pattern (auth, 404, 200 + shape validation) repeated 12 times.

#### Category 2: Action Execution — must be bulletproof

Components that trigger irreversible or hard-to-reverse operations. API tests exist but component→API wiring is untested.

| Gap | Actions | Risk |
|-----|---------|------|
| `ModeratorsAdmin` | Invite (FormModal), revoke, remove | Permission escalation/revocation |
| `TopicsAdmin` | Reorder, CRUD topics/tags | Affects course categorization site-wide |

#### Category 3: Shared Infrastructure — cascade risk

Building blocks used by every admin view. Currently tested only indirectly through parent components. A regression breaks N tests simultaneously, making root-cause diagnosis harder.

| Gap | Used By | Role |
|-----|---------|------|
| `AdminDataTable` | Every admin list view | Sorting, row selection, rendering |
| `AdminDetailPanel` | Every admin detail view | Panel open/close, sections, fields |
| `AdminFilterBar` | Every admin list view | Search, filter dropdowns |
| `AdminPagination` | Every admin list view | Page navigation, items-per-page |
| `AdminActionMenu` | Every row action | Action buttons, variants, disabled |

#### Approach options

| Option | Strategy | Sequence | Trade-off |
|--------|----------|----------|-----------|
| A | Bottom-up | Primitives → Actions → Data → APIs | Clean isolation, more upfront work |
| B | Risk-first | Actions → Data → Primitives → APIs | Highest-risk first, harder diagnosis |
| C | Hybrid | `AdminDataTable` + `AdminDetailPanel` → `ModeratorsAdmin` + `TopicsAdmin` → Detail contents → APIs. Skip `AdminFilterBar`/`Pagination`/`ActionMenu` (well-exercised indirectly). | Best risk/effort ratio |

**Recommendation:** Option C (hybrid) — gets infrastructure diagnostic value for the two highest-cascade primitives, then closes the action-execution and decision-data gaps. The 12 API endpoints batch separately regardless of option.

#### Quality notes from Conv 080 audit

- API tests use real `better-sqlite3` via `describeWithTestDB` — not mocks. Strong pattern.
- Component tests use `@testing-library/react` + `userEvent` — real interaction, not implementation-detail testing.
- `beforeEach` resets DB state — no cross-test contamination.
- No admin E2E tests — component fetch URLs aren't verified against actual API routes. A URL typo passes both layers independently.
- Test counts per file range from 15 (CreatorApplicationsAdmin) to 70 (ModerationDetailContent) — indicating depth varies.

### ADMIN-REVIEW.MENU

**Gate question (ask at block start):** Confirm current menu structure is still accurate before making changes.

#### Current Menu Structure (12 items in 3 groups)

```
OVERVIEW
└─ Dashboard (/admin)

MANAGEMENT (9 items)
├─ Users          ├─ Courses        ├─ Topics
├─ Enrollments    ├─ Teachers       ├─ Sessions
├─ Payouts        ├─ Certificates   └─ Creator Apps

MODERATION (2 items)
├─ Moderation Queue
└─ Moderators

HIDDEN (no menu entry)
└─ Analytics (/admin/analytics) — accessible by URL only
```

#### Assessment

**A. Missing from menu:**
- `/admin/analytics` exists as a full page but has no sidebar entry. Admin must know the URL.

**B. Grouping doesn't match workflow:**

The flat MANAGEMENT list has 9 items in alphabetical-ish order. But admins think in workflows, not entity types. Related items aren't adjacent:

| Workflow | Current Items (scattered) |
|----------|--------------------------|
| User lifecycle | Users → Creator Apps → Teachers → Certificates |
| Course lifecycle | Courses → Topics → Enrollments → Sessions |
| Money | Payouts (alone) |

**Recommendation:** Regroup by workflow proximity:

```
OVERVIEW
└─ Dashboard
└─ Analytics                          ← promote from hidden

PEOPLE
├─ Users
├─ Creator Apps                       ← adjacent to Users (user applies → admin reviews)
├─ Teachers                           ← certified users
└─ Moderators                         ← moved from MODERATION group

COURSES & LEARNING
├─ Courses
├─ Topics                             ← course metadata
├─ Enrollments                        ← students in courses
├─ Sessions                           ← scheduled learning
└─ Certificates                       ← completion artifacts

OPERATIONS
├─ Payouts                            ← money
└─ Moderation Queue                   ← content review
```

This groups 12+1 items into 4 semantic clusters. The admin's eye can scan to the right section by intent ("I need to deal with a person" vs "I need to check a course-related thing").

**C. Cross-linking between admin views:**

The `admin-links.ts` module provides `?highlight=` navigation between admin list views. Currently supported:

| From Detail Panel | Can Navigate To |
|-------------------|-----------------|
| User → | Profile page (member-facing) |
| Course → | Course page, Creator profile |
| Enrollment → | Course page (but NOT student profile) |
| Session → | Course page (but NOT student/teacher profiles, NOT enrollment) |
| Certificate → | Profile page, Course page |
| Payout → | Recipient profile (but NOT individual splits/transactions) |
| Moderation → | Target user profile (but NOT flagger profile) |

**Missing cross-links (high value for admin workflow):**

| Gap | Why It Matters |
|-----|---------------|
| Session → Student/Teacher profiles | Admin resolving session dispute needs to see participant history |
| Session → Enrollment | Admin needs enrollment context (payment, progress) for session issues |
| Enrollment → Student profile | Admin reviewing enrollment can't quickly check student status |
| Payout → Source enrollments/courses | Admin verifying payout can't trace to originating transactions |
| Moderation → Flagger profile | Admin assessing credibility of flag can't see who flagged it |

**D. Dual-link pattern: admin-to-admin + admin-to-member (both required):**

**Design principle:** The admin↔member boundary is intentionally bidirectional. Existing `memberUrlFor` links (`/@handle`, `/discover/course/slug`) let admins cross into the member side to see what members experience and use the ADMIN-INTEL overlays available there. This is by design — it keeps admins "in touch" with the member experience and puts decision-making apparatus on the member side.

**What's missing** is the other direction: admin-to-admin links that stay within the admin system. From SessionDetail, clicking a student name should offer BOTH `/@handle` (see them as a member) AND `/admin/users?highlight={userId}` (see them in admin context among like users). The `admin-links.ts` infrastructure already supports this via `adminUrlFor`.

**Implementation pattern:** For each entity reference in a detail panel, show two links:
- 🔗 `adminUrlFor(type, id)` — opens in admin context (primary, labeled e.g. "Admin →")
- 👤 `memberUrlFor(type, slug)` — opens in member context (secondary, labeled e.g. "Member →")

**CRITICAL: Never remove existing `memberUrlFor` links.** They are the admin's window into the member experience. Admin-to-admin links are additive.

### ADMIN-REVIEW.UI

**Gate question (ask at block start):** Confirm the functional/convenient priority still holds — not a visual polish pass.

**Design principles for this subblock:**
- Not pretty, but functional and convenient. Related items easily reachable from inside pages. Sidebar as secondary navigation.
- **Bidirectional boundary crossing:** Admin↔Member boundary is intentionally porous. Admin-to-member links (`memberUrlFor`) let admins experience the app as members see it + use ADMIN-INTEL overlays. Admin-to-admin links (`adminUrlFor`) let admins see entities in admin context among like entities. Both directions must coexist — never remove one to add the other.

#### Assessment: What works well

1. **Shared component architecture is strong.** All list views use `AdminFilterBar → AdminDataTable → AdminPagination → AdminDetailPanel` consistently. Pattern is learned once, works everywhere.
2. **Detail panels are rich.** `PanelSection` / `PanelField` / `StatusBadge` / `RoleBadge` give uniform information density.
3. **Action patterns are consistent.** ConfirmModal (now + FormModal) → toast → list refresh. Predictable feedback loop.
4. **Dashboard provides genuine operational value.** Alerts, quick actions, session cleanup, recent activity — not just vanity metrics.

#### Assessment: Friction points

**F1. Inconsistent status filtering patterns**

| View | Status Selection | Pattern |
|------|-----------------|---------|
| Users, Courses, Enrollments, Teachers, Sessions | Dropdown filter | Standard |
| Certificates | Tab bar (`all \| pending \| issued \| revoked`) | Outlier |
| Payouts | Hybrid: pending tab + dropdown for others | Outlier |

Admin learns dropdown pattern, hits tabs in Certificates, hits hybrid in Payouts. Recommendation: standardize on dropdowns for all, OR standardize on tabs for views where status is the primary workflow axis (Certificates, Payouts, Moderation). Pick one and apply consistently.

**F2. Dead feature: EnrollmentsAdmin stats**

API returns `stats: {total, active, completed, cancelled}` — component fetches but never renders them. Either display as summary cards above the table (like Dashboard metrics) or stop fetching.

**F3. PayoutsAdmin pending mode is a different UI entirely**

Pending tab shows grouped-by-recipient expandable view. All other tabs show standard table. This is the only view with two fundamentally different layouts. Recommendation: either make the grouped view the standard (with status column to distinguish), or split into two pages (`/admin/payouts` for history, `/admin/payouts/pending` for processing).

**F4. Missing admin-to-admin cross-links in detail panels (additive — keep member links)**

Detail panels link to member-facing pages (`/@handle`, `/discover/course/slug`) — this is intentional and must be preserved. These links let admins cross into the member experience to see what members see and use ADMIN-INTEL overlays for in-context decision-making.

What's missing is the **complementary** admin-to-admin direction. An admin investigating a session dispute who wants to see the student's admin record has to:
1. Open session detail
2. Note the student name
3. Close panel
4. Navigate to Users
5. Search for the student
6. Open their detail

Should be: click student name in session detail → `/admin/users?highlight={userId}` (admin view) alongside the existing `/@handle` (member view).

The `admin-links.ts` infrastructure exists for this (`adminUrlFor('user', id)` → `/admin/users?highlight={id}`). It's just not wired into most detail content components.

**Implementation:** Dual-link pattern per entity reference — admin link (primary) + member link (secondary, existing). See .MENU §D for pattern details.

**Priority detail panels for admin-to-admin wiring:**
- `SessionDetailContent` — student, teacher, enrollment links
- `EnrollmentDetailContent` — student link
- `PayoutDetailContent` — source course/enrollment links
- `ModerationDetailContent` — flagger link

**F5. No filter persistence across navigation**

Navigating away from a filtered list and returning clears all filters. Admin must re-enter search criteria. Low-cost fix: store filter state in URL query params (already partially supported via `?highlight=`).

**F6. TopicsAdmin has no detail panel**

Only admin view without a detail panel. Cannot view topic metadata, associated course count, or tag usage. Actions are limited to reorder and delete. Recommendation: add a lightweight detail panel showing course count, creation date, and usage stats.

**F7. Admin page-level auth guard gap (Conv 082)** ✅ Fixed Conv 083

~~Non-admin users can navigate to `/admin/*` pages and see the full admin sidebar layout before the API rejects the data request.~~ Auth guard added to `AdminLayout.astro` — checks JWT, verifies session, confirms admin role. Unauthenticated → `/login`, non-admin → `/`.

**F8. ModeratorsAdmin has no detail panel content**

`ModeratorDetailContent.tsx` exists as a file but its completeness should be verified at block start. If the panel shows basic info only, it should display moderation activity stats (flags reviewed, actions taken).

#### Recommended execution order

1. **Menu restructure** (ADMIN-REVIEW.MENU) — regroup sidebar, promote Analytics, add admin-to-admin links in detail panels
2. **Filter consistency** (F1) — pick tabs vs dropdowns and standardize
3. **Cross-link wiring** (F4) — wire `adminUrlFor` into detail content components (SessionDetail, EnrollmentDetail, PayoutDetail, ModerationDetail)
4. **Dead feature cleanup** (F2, F3) — render EnrollmentsAdmin stats or remove; decide on PayoutsAdmin pending layout
5. **Filter persistence** (F5) — URL query param state for filters
6. **TopicsAdmin detail panel** (F6) — lightweight panel with course count
7. **ModeratorsAdmin detail panel** (F8) — verify and enhance if needed

Items 1-4 are functional improvements (convenience, workflow). Items 5-7 are polish (nice-to-have for 2-user system).

### ADMIN-REVIEW.ROLES (absorbed from ROLES block)

*Role management additions. EDIT_UI complete (Session 280).*

- [ ] Admin user creation UI (UserCreateModal → `POST /api/admin/users`)
- [ ] Role change audit trail (subsumed by OBSERVABILITY.AUDIT-LOG)

### ADMIN-REVIEW.SETTINGS (absorbed from ADMIN-SETTINGS-UI)

*Admin UI for editing `platform_stats` values*

- [ ] Settings page: edit `availability_window_days`, 13 `smart_feed_*` parameters
- [ ] Validate ranges, show current values, save confirmation

---

## Deferred: IMAGES

**Focus:** Image pipeline — upload endpoints, management UI, delivery optimization
**Status:** 📋 PENDING
**Merged Conv 095:** FILE-UPLOADS + IMAGE-MGMT + IMAGE-OPTIMIZE

**Current state:** R2 helpers exist (`src/lib/r2.ts`). Image display complete (Conv 023: unified fallback, community covers, FeedsHub images). Schema columns exist. No POST upload endpoints. Dev seed uses static placeholder avatar.

### IMAGES.UPLOADS — Upload Endpoints

- [ ] `POST /api/me/avatar` — accept image, validate size/type, resize to 200x200, upload to R2 `avatars/{user_id}/`
- [ ] `POST /api/courses/[slug]/materials` — file type validation, upload to R2 `courses/{course_id}/materials/`
- [ ] `POST /api/courses/[slug]/thumbnail` — course thumbnail upload (creator)
- [ ] `POST /api/communities/[slug]/cover` — community cover upload (creator)
- [ ] Profile settings UI: upload button, preview, remove option

### IMAGES.OPTIMIZE — Delivery Optimization (post-MVP)

- [ ] Choose service: CF Image Resizing (stay in ecosystem) vs Cloudinary (richer transforms)
- [ ] URL helper for transform URLs, responsive `srcset`, `loading="lazy"`, WebP/AVIF auto-format
- [ ] Trigger: image count >100, mobile perf bottleneck, or video thumbnails needed

---

## Deferred: FEEDS-NEXT

**Focus:** Feed enhancements — ranking, mobile performance, privacy, level matching, promotion
**Status:** 📋 PENDING
**Merged Conv 095:** FEEDS + FEED-PROMOTION + FEED-PRIVACY + LEVEL-MATCH
**Tech Doc:** `docs/reference/stream.md`

### FEEDS-NEXT.RANKING — Algorithmic Feed Ordering

*Requires paid Stream tier — awaiting client input*

- [ ] Confirm client wants ranked feeds (paid tier cost)
- [ ] Configure ranking formula: `decay_gauss(time) * pinned * priority * content_type_weights`
- [ ] User preference weights in D1 (announcements, courses, community)
- [ ] Pin posts: creator/admin pin/unpin action + `is_pinned` field in Stream activities

### FEEDS-NEXT.MOBILE — Feed Performance

- [ ] Verify pagination with `limit` + `offset`/`id_lt` in all queries
- [ ] Feed caching (React Query or similar)
- [ ] Loading skeletons for pagination
- [ ] 3G simulation testing

### FEEDS-NEXT.PRIVACY — Feed Visibility Toggle

*Schema: `communities.is_public` exists. Courses need `feed_public` column.*

- [ ] Privacy toggle UI + API for communities and course feeds
- [ ] SMART-FEED discovery already respects flags (Conv 017)

### FEEDS-NEXT.LEVEL-MATCH — Proficiency-Based Recommendations

*Schema ready: `user_tags.level` column (Conv 071)*

- [ ] Compare `user_tags.level` with `courses.level` in `scoreCandidates()`
- [ ] Boost/penalize course recommendations by alignment

### FEEDS-NEXT.PROMOTION — Paid/Points-Based Promotion (Post-MVP)

*Depends on GOODWILL (points) + RANKING (weighted display). 3 stories (US-S071, US-P085, US-C047).*

- [ ] Student: spend goodwill points to promote posts
- [ ] Creator: pay (Stripe) for promoted course placement

---

## Deferred: OBSERVABILITY

**Focus:** Error tracking, product analytics, user activity audit logging
**Status:** 📋 PENDING
**Merged Conv 095:** SENTRY + POSTHOG + AUDIT-LOG

### OBSERVABILITY.ERROR-TRACKING — Sentry

**Problem:** 176 API files use bare `console.error` (~292 call sites) — ephemeral on CF Workers.
**Tech Doc:** `docs/reference/sentry.md`

- [ ] Install `@sentry/astro` + `@sentry/cloudflare`, add DSN to envs
- [ ] Create `src/lib/sentry.ts` shared capture utilities
- [ ] Migrate routes in priority order: payment/webhook → auth → user-facing → admin → feed
- [ ] React Error Boundary on key components
- [ ] Wire user identification into CurrentUser
- [ ] Alert rules + Slack integration
- [ ] Source map upload in deploy pipeline

### OBSERVABILITY.ANALYTICS — PostHog

**Tech Doc:** `docs/reference/posthog.md`. Free tier covers Genesis (1M events/mo).

- [ ] Install `posthog-js`, add Astro/React integration
- [ ] Key events: `course_viewed`, `enrollment_started/completed`, `session_booked/completed`, `certificate_earned`, `became_student_teacher`
- [ ] Session replays
- [ ] Feature flags for A/B experiments

### OBSERVABILITY.AUDIT-LOG — User Activity Log

**Design:** Custom D1-backed. Schema and action codes designed (detail in git history, Conv 095). Recommendation: Option A (custom D1) for MVP, CF Workers Logs as complement.

- [ ] `audit_log` table in schema + `src/lib/audit.ts` with fire-and-forget `logAction()`
- [ ] Instrument: auth, enrollment, session, payment, certificate, admin, profile, course endpoints
- [ ] Admin UI: `/admin/audit-log` with date/user/action filters, single-user timeline, CSV export
- [ ] Retention: 90-day default, R2 archival for expired logs
- [ ] Subsumes ROLES.AUDIT (role changes logged here)

---

## Deferred: STUMBLE-REMNANTS

**Focus:** Deferred findings from STUMBLE-AUDIT walkthroughs (Conv 067-088)
**Status:** 📋 PENDING

### Cross-referenced (tracked in other blocks)

These items are already detailed in their respective blocks — listed here for traceability back to the walkthrough that found them.

**→ CERT-APPROVAL:**
- Broken route: `/course/[slug]/certificate` — page doesn't exist, linked from discover pages (Conv 068)
- No "Recommend for Certification" UI button (teacher side) — `POST /api/me/certificates/recommend` has zero UI consumers (Conv 082)
- Dashboard "Certification recommendation" attention item links to `/teaching/students` which has no recommend action — dead-end (Conv 082)
- Two parallel certification paths (creator direct vs recommend/approve) with no unified admin visibility (Conv 082)

**→ PLATO (Post-MVP):**
- Create `post-enrollment` instance and `multi-student` scenario (design in `plato.md`)

### Standalone items

- [x] The Commons `member_count` denormalized counter out of sync — fixed in seed SQL via `UPDATE communities SET member_count=N` after inserts (Conv 108).
- [ ] Expired/invalid JWT session tokens — no test coverage (requires infra-level test changes to mock token expiry)

### Client decisions required

- [ ] Remove MyXXX pages (`/courses`, `/feeds`, `/communities`) — redundant with unified dashboard? Needs client confirmation.
- [ ] Home page differentiation for new members — currently shows same Twitter-like feed for everyone (Conv 067)

---

## Deferred: STRIPE-E2E-DEV

**Focus:** End-to-end Stripe integration stress test run at the Dev level — real browser, real Test-mode cards, real `stripe listen` webhook tunnel — as a rehearsal before Staging and Prod rollouts
**Status:** 📋 DEFERRED — scoped Conv 145, ready for Plan Mode
**Priority:** High — prerequisite for go-live confidence
**Origin:** Conv 145 [VD/VW/VA/VL] drain pass exposed that our existing confidence in Stripe rests on three disjoint surfaces (unit tests, harness-driven direct-sign webhook replay, one-time staging live-verification). None of them covers the "real user in a real browser with real card input routing to a real tunnel" path. That's the gap this block closes.

### Why this block exists

Conv 144 proved that integration-level Stripe bugs are real, non-theoretical, and can hide for months:
- `constructEvent` → `constructEventAsync` on CF Workers — every staging webhook had been HTTP 400'd for ~8 weeks before live-verification caught it
- `(student, course)` UNIQUE collision on duplicate-purchase — would have been a retry storm in production
- `webhook_log` INSERT racing Worker termination on short-path handlers — forensics-critical data loss

Each of those surfaced only when a real webhook hit a real handler in a real environment. Unit tests with mocks couldn't see them. The harness direct-sign tool is good for scenario-matrix coverage but can't catch runtime-specific bugs. The staging live-verification is high-value but expensive (needs deploy + Sandbox Dashboard setup + secret rotation discipline) and therefore rare — once per block, roughly.

Dev-level E2E fills the rapid-iteration slot: fix a bug, rerun the scenario in under 2 minutes, no deploy, no shared state, no coordination. That's what turns "probably works" into "demonstrably works" at the velocity of normal development.

### Current confidence surface (as of Conv 145)

| Surface | Coverage | Misses |
|---|---|---|
| Vitest unit tests (`tests/api/webhooks/stripe.test.ts`, 18 tests) | Handler logic with mocked Stripe SDK | Runtime bugs (async/sync crypto), frontend integration, real Stripe event shapes, DB sequence effects |
| Harness direct-sign replay (`scripts/trigger-webhook.sh`) | Signature verification + handler dispatch for 7 event types locally and on staging | Real card-entry UI, real Checkout session state, connected-account onboarding, dispute lifecycle |
| Staging live-verification (Conv 144, 7 scenarios S1–S7) | Real Worker runtime + real Sandbox Stripe + real webhook tunnel | One-shot, not CI-gated; requires deploy cycle; rare to re-run; no browser-driven UI step |
| `/api/admin/stripe-mode` diagnostic (Conv 145 [VA]) | Mode alignment at any time, for any env with the endpoint deployed | Doesn't exercise the payment flow itself |

**What nothing on this list covers**: a student clicks Enroll on the course page → arrives at Stripe Checkout → types `4242 4242 4242 4242` → returns to `/success` → the success page SSR self-heals → enrollment appears in the app navigation → an email gets sent. That full-stack path is the actual production user flow, and today it has zero automated coverage.

### What Dev E2E testing buys us — and why it matters for Staging and Live

The value chain is three-layered:

**Dev layer (this block):** high-fidelity, low-cost, fast iteration
- Catches handler-integration bugs that unit tests can't see (wrong redirect URL, missing DB field, silent failure in error path, race conditions between webhook handler and success-page SSR)
- Exercises the *browser-to-Stripe-to-handler-to-DB-to-UI* loop in its entirety
- Makes edge cases cheap to probe: declined cards, dispute cards, 3DS-required cards, expired cards, zero-decimal currencies
- Anyone on the team can reproduce a reported bug locally in minutes
- Shared vocabulary: "run scenario S4" becomes a thing people say, not a thing they reinvent

**Staging layer (already established by Conv 144):** Worker runtime + real Stripe infrastructure
- Catches bugs that only appear in the Cloudflare Worker runtime (SubtleCryptoProvider, execution time limits, `waitUntil` lifecycle)
- Validates secret-slot discipline (STRIPE_SECRET_KEY ↔ STRIPE_WEBHOOK_SECRET alignment within the Sandbox workbench)
- Exercises the direct-to-Stripe webhook delivery path without a local tunnel in between
- Expensive per run — deploy cycle, Sandbox Dashboard setup, secret rotation discipline — so typically one full pass per significant Stripe change

**Live layer (future go-live):** real money, real customers, one-shot
- The $1 real-charge smoke test during go-live is the final verification
- No acceptable failure rate for integration bugs — customer trust is set by their first interaction
- Anything caught here is a reputation-damaging incident, not a bug report

**The compounding effect:** each layer catches a different class of issue. Dev layer catches *functional* issues cheaply; Staging layer catches *runtime / infrastructure* issues at moderate cost; Live layer is the final confirmation. Skipping the Dev layer means functional bugs get caught at Staging cost or (worse) Live cost. The Conv 144 bugs that hid for 8 weeks are a preview of how much you pay for a missing Dev-layer tier.

**What this block does NOT replace:**
- The 18 unit tests (different abstraction, sub-second feedback)
- The staging live-verification pass (different infrastructure, Worker-specific)
- The eventual Live $1 smoke test during go-live cutover

### Scope tiers (pick one as MVP, layer others later)

**Tier A — Paper walkthrough** (~60 min, docs only)
- New `docs/guides/stripe-dev-e2e.md` with prerequisite checklist, 11 numbered scenarios (see table below), expected DB state + verification query for each, screenshot checkpoints, troubleshooting table
- Test-card appendix (the 6 standard Stripe magic numbers: success `4242…`, decline `4000…0002`, insufficient funds `4000…9995`, 3DS-required `4000…3155`, dispute `4000…9979`, expired `4000…0069`)
- `stripe trigger` recipe appendix for CLI-synthesized events (dispute flow specifically)

**Tier B — Scripted orchestrator** (adds ~90 min on top of A, one new script)
- `scripts/dev-stripe-smoke.sh` automates the deterministic scenarios (direct-signed `checkout.session.completed` → verify DB → direct-signed `charge.refunded` → verify DB → etc.), leveraging existing `scripts/trigger-webhook.sh`. Manual UI-driven steps (real card payment, real onboarding) stay manual.

**Tier C — Playwright E2E suite** (~half-day, new test files)
- `tests/e2e/stripe-smoke.spec.ts` drives a real browser against `npm run dev:webhooks`. Stripe Checkout iframe interaction is the tricky part. Flagged as `describe.skip` in CI by default (requires live Stripe CLI auth) but runnable locally via `npm run test:e2e:stripe`.

**Tier D — Claude-MCP-driven interactive verification** (new idea surfaced Conv 145)
- Claude drives Chrome via the claude-in-chrome MCP bridge, starts `stripe listen` as a background process, walks through scenarios, produces a pass/fail report with screenshots. Not CI-grade; session-grade. Lets a human ask "verify scenario S6 still works" and get a report in ~5 minutes without writing or running test code themselves. Feasibility hinges on whether the MCP bridge handles Stripe's cross-origin iframes cleanly — unknown until tried.

### Scenarios to cover (minimum set, 11 rows)

| # | Scenario | Driver | Webhook(s) | DB effect to verify | Notes |
|---|---|---|---|---|---|
| 1 | Creator onboarding happy path | Browser + Stripe Express form | `account.updated` | `users.stripe_account_status='active'`, `stripe_payouts_enabled=1` | Requires completing Stripe Connect Express UI in Test mode |
| 2 | Enrollment, valid card | Browser + card `4242…` | `checkout.session.completed` → `transfer.created` (platform) | New rows in `enrollments`, `transactions`, `payment_splits` (2-3 per enrollment); course `student_count++` | Happy path — most common real flow |
| 3 | Enrollment, declined card | Browser + card `4000…0002` | None (Stripe declines before session completes) | No DB change | User sees error in Checkout UI |
| 4 | Enrollment, 3DS-required | Browser + card `4000…3155` | `checkout.session.completed` (after 3DS challenge) | Same as #2 | Exercises the 3DS flow real European traffic will use |
| 5 | Full refund | Admin UI | `charge.refunded` | `enrollments.status='cancelled'`, `transactions.status='refunded'`, `payment_splits.status='reversed'`; Stream unfollow | Admin-initiated from `/admin/payments` |
| 6 | Partial refund | Admin UI | `charge.refunded` | `transactions.status='partially_refunded'`, enrollment stays active | Admin 50% refund |
| 7 | Dispute created | Card `4000…9979` or `stripe trigger` | `charge.dispute.created` | `enrollments.status='disputed'`, `transactions.status='disputed'`, admin notification created | Duplicate-purchase [VD] guard also applies here — student stays disputed if they try to re-enroll |
| 8 | Dispute won | `stripe trigger charge.dispute.closed` | `charge.dispute.closed` (status=won) | Enrollment restored to `'enrolled'`, transaction `'completed'` | Requires CLI-synthesized event |
| 9 | Dispute lost | `stripe trigger` + Dashboard update | `charge.dispute.closed` (status=lost) | Enrollment cancelled, transfers reversed, admin notification | Exercises the full transfer-reversal path |
| 10 | Account status change → restricted | Sandbox Dashboard action | `account.updated` | `users.stripe_account_status='restricted'` | Disable payouts in Sandbox test-account settings |
| 11 | Self-healing path (webhook miss) | Browser + simulated webhook drop | — (no event) | `/api/stripe/verify-checkout` + success.astro SSR heal create the enrollment on success-page load | Verifies the Session 324 self-heal fallback still works; simulate by stopping `stripe listen` right before completing checkout, then restarting + visiting `/success` |

### Pre-requisites / preconditions this block needs

- [ ] Local D1 seeded with `db:setup:local:stripe` — produces at least one Creator with Test-mode `stripe_account_id`, at least one Teacher with a certification, at least one priced course (`price_cents > 0`)
- [ ] Stripe CLI authenticated to Test mode — `stripe login` into the default workbench, not Sandbox. CLI config currently in state verified Conv 145 [VL]
- [ ] `.dev.vars` holds Test-mode `sk_test_` / `pk_test_` + current `whsec_` from `stripe listen` (stable per-machine — changes only on re-auth)
- [ ] No second `stripe listen` process running (two tunnels compete for the same account's events)
- [ ] `/api/admin/stripe-mode` endpoint (Conv 145 [VA]) is available on Dev — trivially so, since it's in `src/pages/api/admin/` — for parallel diagnostic use during testing

### Open questions for Plan Mode

1. **Which tier is the right MVP?** Default recommendation: Tier A (paper walkthrough) — highest leverage per hour, foundation for the others, surfaces ambiguities a script would otherwise have to resolve. B and C and D can layer on.
2. **Does the Chrome MCP bridge handle Stripe Checkout iframes?** Answer is unknown until we try. If yes, Tier D becomes very attractive (Claude-driven rehearsals on demand). If no, fallback is `stripe trigger` for the webhook step with browser only for pre-checkout and post-success.
3. **Do we repeat the full matrix on Sandbox (staging) after Dev passes?** Conv 144 did scenarios S1–S7 on Sandbox; this block would add 4 more (onboarding, 3DS, partial refund, self-heal). Staging matrix should grow to match, but schedule (before each Stripe-touching PR? monthly? pre-go-live only?) is a Plan Mode question.
4. **Do we need a Dev counterpart to `/api/admin/stripe-mode` for webhook-secret verification?** An endpoint that returns the currently-loaded `STRIPE_WEBHOOK_SECRET` *hash* (not value) would let us verify `stripe listen`'s whsec matches `.dev.vars` without a diff on the filesystem. Marginal value; flag for discussion.
5. **Does Stripe Dashboard's Test-mode-into-Sandboxes-listing UI change (noted Conv 145 [VA] screenshot) require any doc updates before we write the walkthrough?** Probably a one-paragraph note in the Tier A prerequisites section, but worth verifying current state against the doc before writing.
6. **Is there value in adding `charge.succeeded` and `payment_intent.succeeded` to the coverage matrix?** Current handler doesn't subscribe to them (handler uses `checkout.session.completed` as the creation trigger), but Stripe fires them too. Plan Mode should decide: ignore, observe-only, or wire them up.
7. **Seed-data sensitivity:** the existing `stripe` seed (`migrations-dev/0002_seed_stripe.sql`) pre-fills `stripe_account_id` values for seed Creators. Are these real Test-mode `acct_...` that work against the current Test-mode workbench, or fake strings? If fake, #1 onboarding is the actual first step for every fresh Dev setup — which reshapes the walkthrough.

### Risks / unknowns flagged for Plan Mode

- 🟠 **Stripe Checkout iframe automation** untested with claude-in-chrome MCP — may force Tier D into a hybrid browser/CLI shape
- 🟠 **`stripe trigger`'s payloads are generic**, not tied to real charges — scenarios #8 and #9 may require Sandbox-side dispute-state manipulation to produce realistic test state
- 🟠 **Connected-account webhook testing** (e.g., `payout.failed`) needs `stripe listen --forward-connect-to` separately — either second tunnel or different URL routing. Currently deferred in `stripe.md` as "requires separate Connected-accounts webhook endpoint"
- 🟠 **Dispute-card `4000…9979` timing** — Stripe normally takes minutes to fire `charge.dispute.created` after a dispute card is used; the walkthrough should note the expected latency so scenarios don't look "stuck"
- 🟢 **Cost:** Test-mode charges are free — no real-money risk at any point

### Exit criteria

**Minimum (Tier A):**
- `docs/guides/stripe-dev-e2e.md` exists, covers all 11 scenarios, has been run end-to-end by at least one team member with pass notes attached
- Every scenario has a documented expected DB state + verification query + at least one screenshot

**Stretch (Tier B/C/D):**
- Tier B scripted orchestrator produces green for 5 consecutive runs across 2 days
- Tier C Playwright suite runs clean locally, `describe.skip` gate in CI documented
- Tier D: a Claude-driven interactive session successfully walks through ≥ 6 of 11 scenarios with screenshot trail

**Confidence signal:** after this block, the answer to "would we be comfortable doing the go-live $1 smoke test today?" shifts from "mostly, but we'd double-check things" to "yes — we have a rehearsal we've run end-to-end".

### References

- `docs/DECISIONS.md §8 Stripe Mode Discipline` — the env × mode mapping
- `docs/reference/stripe.md §Stripe Mode Discipline (CRITICAL)`, `§Per-Environment Webhook Configuration`, `§Connected Accounts Are Per-Mode AND Per-Environment`
- `docs/as-designed/webhook-miss-resilience.md` — Stripe events + Conv 144 live-verified S1–S7 scenarios (starting point for our 11-scenario matrix)
- `scripts/dev-webhooks.sh` + `scripts/trigger-webhook.sh` — existing Dev harness
- `scripts/check-env.sh` — Dev prerequisite validator (called by `dev-webhooks.sh`)
- `tests/api/webhooks/stripe.test.ts` — 18 unit tests; don't duplicate this coverage
- `src/pages/api/webhooks/stripe.ts` + `src/lib/enrollment.ts` — current handler entry points (post-Conv 145 [VD]/[VW])
- `src/pages/api/admin/stripe-mode.ts` (Conv 145 [VA]) — the mode-diagnostic endpoint to call during/before each scenario
- Conv 144 Extract + Conv 145 Extract — the integration-bug history this block is designed to prevent repeating

---

*Last Updated: 2026-05-28 Conv 208 — **STANDIN-MATT closing arc: all 3 Conv 207 deferred items closed (STANDIN-404 + PROV-CODIFY + PROV-SWEEP-MI); /profile retrofit attempted then REVERTED as premature.** [STANDIN-404] retrofit `@stand-in` → `@matt-inspired` (Matt tokens + Button primitive; LandingLayout retained). [PROV-CODIFY] 3-marker page-provenance convention codified — full §11 in `docs/as-designed/matt-provenance.md` (rationale, marker table, detection extension, examples through Conv 208, relationship to component-level provenance) + concise section in CLAUDE.md with table + pointer. [PROV-SWEEP-MI] `scripts/prov-sweep.ts` extended with page-level classifier (`classifyPage`, walks `src/pages/`, skips `old|dev|api/`); 3 new line-anchored regexes (`PAGE_SRC_RE` / `PAGE_INSPIRED_RE` / `PAGE_STANDIN_RE`) re-derived from scratch after the first run misclassified 404 (the §9 grep-pollution gotcha generalized — its own header cited `Button (@matt-source 40:482)` in prose); verified against all 8 canonical pages before commit per `feedback_heuristic_calibration.md`. **Memory-sync reword:** `r-start/SKILL.md` Step 5.7 A/B/C reframed around "whose intent wins" (A=save this machine's file first, B=let other machine win incl. deletion, C=inspect). **§Recurring Failures section** added at top of CLAUDE.md as a pre-send checklist (option-phrasing + 👉-pause) — triggered by user *"I really, really wish your MEMORY.md and/or CLAUDE.md would give this more importance. It happens at least once a Conv."*; pattern = when a directive keeps being violated despite always-loaded context, reformulate statement → vivid trigger (anti-pattern verbatim + self-check) AND position so the rule fires before the failing turn ships. `feedback_option_phrasing.md` rewritten to lead with anti-pattern verbatim; MEMORY.md line updated. **/profile retrofit REVERTED** — wrote marker flip @stand-in → @matt-inspired + EmptyState + Button primitive swap; user *"we have not done /profile yet and it should be marked @stand-in"* — task tagged "complex, deferred from Conv 205" expected substantive account-page design work, not markup tidying on a placeholder stub. `git restore` cleanly reverted; STANDIN-MATT stays open with /profile pending. **Codecheck discussion:** user audited "did you run /w-codecheck?" after STANDIN-404 + PROV-CODIFY; concession: the 404 retrofit DID add Tailwind utility classes that only `npm run build` catches, but build will catch them after upcoming changes; no CLAUDE.md / MEMORY.md changes needed (`feedback_codecheck_moment_includes_tests_and_build.md` correctly delegates the decision). 1 new deferred: [PROF-SUBNAV-DEAD] (Profile SubNav has 3 dead links — fix during [RTMIG-4] when real profile content lands). Branch `jfg-dev-13-matt`. **Next-conv leads:** /profile genuine retrofit, DISC-DROP Stages 3-4, [RTMIG-4] per-page conversion, [MATT-EXEC-PG2] Enroll/Session families. PREVIOUS (Conv 207): **STANDIN-MATT retrofit pass: 3 of 4 remaining `@stand-in` pages converted + 11 NEW form/UI primitives + new 3-marker page-provenance convention.** Scope-trim: Conv 205 "7 discover destinations" addendum removed from STANDIN-MATT — DISC-DROP (#21) reclaimed ownership. Deletions: `/teachers/[handle].astro` (zero live callers — Conv 193 pre-emptive infra, StudentTeacherAnchor default href now 404s honestly). Marker corrections: `course/[slug]/[...tab].astro` `@stand-in`→8 `@matt-source` markers (Feed/About/Modules/Reviews/Resources/Teachers/Creator + Hero). **3 retrofits to `@matt-inspired`:** login/signup/onboarding, composed from 11 NEW primitives in `src/components/form/` + `src/components/ui/`: Input/FormField/PasswordInput (login) + Select/SelectableCard/FormBanner/FormSection/SkeletonCard/ErrorState (onboarding) + SearchInput/SegmentedPills (`/courses` CoursesFilters bonus retrofit). **NEW 3-marker page-provenance convention adopted:** every non-legacy page carries exactly ONE of `@stand-in` (transient placeholder) / `@matt-source <nodeId>` (1:1 Figma frame) / `@matt-inspired` (Matt tokens/primitives, no source frame); unmarked = legacy; dev/* opt-out. Page-provenance audit ratified — index/courses → `@matt-inspired`, 404 → `@stand-in`. **FormField asterisk-outside-label fix** resolved 35 form-test failures at the primitive level (not by patching tests): label textContent = exact label text, `getByLabelText` queries resolve cleanly; canonical "required" a11y signal stays on the input's `required` attribute. **`/w-codecheck` unchanged** (3 fold-in edits made then reverted); new memory `feedback_codecheck_moment_includes_tests_and_build.md` codifies decision-point framing — when CC decides to run `/w-codecheck`, decide per-change whether prov-sweep/tests/build belong in this pass (none auto-bundled, none off-menu). New memory `feedback_scan_for_primitive_candidates_on_retrofit.md` — scan retrofit candidates BEFORE writing inline JSX. All 5 baseline gates green (tsc/check 1290 0/0/0/lint/build/test 6452/6452 across 371 files); route-doc regen + prov-sweep clean. CourseCatalogCard retroactively registered in PHASE6_EXTRAPOLATION_CANDIDATES (Conv 205 backfill). 3 new deferred items: [PROV-CODIFY] (codify 3-marker convention in CLAUDE.md + matt-design-system docs), [PROV-SWEEP-MI] (teach prov-sweep.ts about `@matt-inspired`), [STANDIN-404] (actual 404.astro retrofit deferred). **Remaining `@stand-in` pages: `/profile` only** (deferred — complex, per Conv 205 directive). `grep -rl '@stand-in' src/pages` = remaining-work counter. No blocks completed; STANDIN-MATT (#24) + DISC-DROP (#21) stay open. Branch `jfg-dev-13-matt`. **Next-conv leads:** `/profile` retrofit (last `@stand-in` page) / DISC-DROP Stages 3-4 (4 unique destinations communities/members/leaderboard/feeds; creators/students/teachers are 301 redirect shims) / RTMIG-4 per-page conversion / [PROV-CODIFY]. PREVIOUS (Conv 206): **CC-workflow / memory + skill infrastructure (no PLAN feature block advanced).** Triggered by MEMORY.md at 86% of 25KB auto-load cap (carry-forward [MEM-CAP-WATCH]). **[MEM-CAP-WATCH] DONE** — full audit (option C): 8 heaviest entries stub-pointered, 3 inline rule blocks consolidated, 4 stale index entries retired (project_course_page_merge / project_currentuser_optimize / project_skill_portability / rename-lessons). **21,950→17,336 bytes (86%→68%); 132→104 lines; +8,264 byte headroom.** **[INV-FRAMINGS] DONE** — new top-level `## Investigative Framings — Surface Findings Before Acting` section added to CLAUDE.md between §Critical Rule and §Skills, plus `memory/feedback_audit_surface_findings_first.md` + MEMORY.md index line; codifies the verb test (audit/review/investigate → surface dispositions first; build/make/fix → proceed). Triggered by [MEM-AUDIT] — user picked option C in MEMORY.md audit and CC executed end-to-end without surfacing per-item dispositions; structural asymmetry user noted ("I cannot know what you will find" preemptively). **[RPC-BUGS] DONE** — fixed 4 relative-path `!`-backticks in `r-prune-claude/SKILL.md` to tilde-literal (per Conv 162 sweep); added Step 4 (post-execute reference validation) + Step 5 pointer to `/r-coherence-check`. **[CLAUDE-PRUNE] DONE** — `/r-prune-claude` moved 8 reference sections (Dual-Repo Architecture / Startup Hooks / Conv Lifecycle / Test Suite Workflow / Schema Discrepancy / Development Commands / Database Migrations / Tech & Arch Doc) to NEW `docs/reference/CLAUDE-OFFLOAD.md` (316 lines/15 KB); **CLAUDE.md 533→286 lines (46% reduction); 30 KB→20 KB**; 14 sections kept (all behavioral rules + identity); 22 H2 headers preserved + 9 offload pointer links. **[COHERENCE-SKILL] DONE + [/r-optimize] DELETED** — built composite `/r-coherence-check` (296 lines): 4 structural lint categories (BROKEN-REF/STUB-DRIFT/OVERLAP/ORPHAN) + 6 semantic categories subsumed from /r-optimize (AMBIGUITY/FRICTION/STALE/REDUNDANCY/GAP/SCOPE-CREEP; CONTRADICTION deferred) + severity ladder HIGH/MEDIUM/LOW + apply-fixes protocol; all 5 P1-P5 improvements applied (tiered `--deep`/`--semantic`/`--all` flags, `.claude/coherence-ack.md` ack file, configurable `coherenceCheck.markers` in config.json, diff-preview for SEMANTIC fixes, description cleanup). /r-optimize had 2 path bugs (relative `cat CLAUDE.md` + hardcoded `livingroom` username) that would have broken on M4Pro — user had used it once and forgotten it existed. **[COHERENCE-ARGS-BUG] DONE** — first `--deep` invocation surfaced `$ARGUMENTS` not populated in `!`-backticks; refactored to always-load full content + parse `ARGUMENTS:` from prompt body in Step 0. **[COHERENCE-DEEP-RUN] DONE** — 4 findings surfaced (1 HIGH STALE, 1 MED GAP, 2 LOW AMBIGUITY); user chose fix STALE+GAP, leave LOW. Fix #1 STALE: deleted `memory/project_skill_portability.md` (claim that `$CLAUDE_PROJECT_DIR` is the convention superseded by Conv 162). Fix #2 GAP: added `**Multi-conv scope carve-out.**` paragraph to CLAUDE.md §Solution Quality + followup-edited `feedback_default_durable_no_ask.md` line 9 to mark the carve-out as promoted to CLAUDE.md (retaining Conv 131 [TDS-AUTH] precedent). **Pattern recorded:** for arg-driven skill behavior, parse `ARGUMENTS:` in skill body, NOT `!`-backticks. **Pattern reinforced:** when promoting a memory-only rule to CLAUDE.md, do the followup edit to the memory file noting the promotion. No code-repo work besides `package-lock.json` no-op sync. No feature blocks completed. 2 new deferred items: [COHERENCE-AMBIG-LOW] (defer §Critical Rule "multiple features" + §Schema Discrepancy "unambiguously self-evident" judgment-heavy phrasing until concrete miscalibration) + [SKILL-DISCOVERY-WATCH] (periodic low-usage-skill audit). Branch `jfg-dev-13-matt`. **Next-conv leads:** [PREFLIP-M4PRO] FIRST → [STANDIN-MATT] (build the 7 discover-dest Matt pages — same workstream as [RTMIG-4], unblocks DISC-DROP Stages 3-4). PREVIOUS (Conv 205): **DISC-DROP: `/courses` page DONE (Stage 2 + full Matt restyle + image cards + card-click); Stages 3-4 BLOCKED.** Ran `npm install` (drift sync). Mounted DISC-DROP Stage 2 slots (`OnboardingNudgeBanner` + `RecommendedCourses`) into `/courses`; removed all DEV scaffold from `courses.astro`. **Full Matt restyle:** `CoursesRoleTabs` Matt-restyled inline (dropped shared legacy `ExploreTabBar`, kept role-color dots); `RecommendedCourses` restyled (MattIcon header/dismiss; legacy `CourseCard` left untouched — 5 other users). **New Matt browse card `CourseCatalogCard.tsx` composed from primitives** — Matt has NO catalog/browse card (all his course cards are feed-embed ROWS); user chose "B. Matt has no card grid yet." Two variants: `stacked` (16:9 thumbnail top, grid sm:2/xl:3) + `overlay` (image backdrop + dark-scrim, RecommendedCourses band). Image source = `course.thumbnail_url` (reuses Matt's `CourseHeader` 517:8934 backdrop+scrim, `#1f2937` fallback); leading course icon dropped (redundant in a course list); **per-card CTA dropped → whole card is a stretched-link** (one title `<a>` + `after:inset-0`, hover lift-shadow/white-ring; verified exactly 1 anchor/card via elementFromPoint). Onboarding nudge confirmed-rendering via temporary FORCE_SHOW bypass (reverted). Browser-verified throughout. **[FULLBASE-204] CLOSED — all 5 gates green this conv:** tsc/astro check 0/0/0/lint/build + **6452/6452 tests, 371 files.** **Remaining: Stages 3-4 BLOCKED** — the 7 other discover destinations (communities/members/leaderboard/feeds/creators/students/teachers) exist only at `/old/discover/*` with no Matt pages; Matt sidebar links only Home + Courses; 404-honesty rule bars sidebar links to `/old/*`/nonexistent routes. User authorized breaking 404-honesty to build them → folds into STANDIN-MATT (#24). Latter half of the conv ran inside r-quiet-mode (images + card-click iteration). 2 cleanup debts: (a) RecommendedCourses light skeleton vs dark overlay cards; (b) shared role/ratingLabel helper. 3 new decisions (compose catalog card from primitives / stretched-link card / drop course icon) + 3 learnings (Matt has no browse card / thumbnail_url+CourseHeader backdrop / stretched-link a11y). No blocks completed (DISC-DROP stays open — `/courses` done but Stages 3-4 blocked). Branch `jfg-dev-13-matt`. **Next-conv leads:** DISC-DROP Stages 3-4 / STANDIN-MATT remaining pages (build the 7 discover-dest Matt pages), RTMIG-4 per-page conversion. PREVIOUS (Conv 204): **STANDIN-MATT advanced (`/courses` retrofit) + DISC-DROP block opened (Stage 1) + r-quiet-mode skill infra + CUI-VERIFY.** **[PREFLIP-M4PRO] verified** on MacMiniM4Pro (worktree `~/projects/Peerloop-preflip` @608346a, .dev.vars, .env symlink, node_modules, local D1 seeded, `peerloop-ref` alias, :4331 → HTTP 200). **[STANDIN-MATT] `/courses` DONE:** found it was already a Matt-primitive build (Conv 192), over-marked `@stand-in`; removed the stand-in marker + a stale top-level SubNav (dead /saved /teachers /todo tabs, misused page-section component); **made `/courses` PUBLIC** in middleware (removed from `PROTECTED_EXACT` — user-confirmed public browse gateway; `middleware.test.ts` updated, 85/85). Remaining `@stand-in` pages: login, signup, onboarding, teachers/[handle], course/[slug]/[...tab] (last via PG2 tab tasks); **`/profile` deferred** (complex; return after simpler pages). **[DISC-DROP] block opened (supersedes [DISC-UNIFY], #21) — Stage 1 DONE:** decided to drop `/discover` and fold its content into `/courses` in stages rather than unify on one loader. Built scaffold slots (onboarding-nudge / recommended / explore{tabs,filters,catalog}); `CoursesRoleTabs` (role tabs via ExploreTabBar) + `CoursesCatalog` (filters by role lens) wired via custom `courses:tabchange` event (replaceState fires no hashchange → explicit island↔island event); `CoursesFilters` (level pills + topic dropdown + text search + Clear button) via `courses:filterchange`. Fixed **shell-wide current-user init** (new headless `CurrentUserInit` island in `AppLayout` — `initializeCurrentUser` previously ran only in legacy navbars, so Matt pages never populated the singleton) + a **loader bug** (`fetchCourseBrowseData` hardcoded `primary_topic_id:null` → now uses authoritative `c.primary_topic_id` column). Remaining: Stages 2-4 + Stage-1 cleanup. 2 new deferred items: [DISC-RTB-RECONCILE], [AICODING-SEED] (AI Coding topic count 3-vs-2, #29). **New skill `/r-quiet-mode <on|off>`:** the log file IS the state (single fixed `.scratch/quiet-mode-log.md`; ON iff it exists, OFF deletes it); r-end Step 0 guard blocks while it exists; r-start Step 5.8 surfaces a leftover; OFF augmented to a mandatory issue-raising checkpoint that pauses. Round-trip + guard tested (r-end blocked twice while ON). DISC-DROP Stage 1 was built inside quiet mode. **[CUI-VERIFY] DONE** (closes a CURRENTUSER-OPTIMIZE residual): added an in-flight guard to `initializeCurrentUser` (dedupe concurrent callers); Home now reads the singleton instead of a redundant raw `/api/me/full` fetch (1 call, was 2 — browser-confirmed). **Baseline NOT fully verified** — full `npm test` + `npm run build` were NOT run this conv; targeted tests (courses loader + browse + middleware = 135) + tsc + astro check + lint were green (treat full baseline as unverified per CLAUDE.md). No blocks completed (STANDIN-MATT + DISC-DROP both remain open). Branch `jfg-dev-13-matt`. **Next-conv leads:** STANDIN-MATT remaining 5 pages, DISC-DROP Stages 2-4, or RTMIG-4 per-page conversion. PREVIOUS (Conv 203): **ROUTE-MIGRATION: [RTMIG-4] methodology fork RESOLVED = A + Home recreated from `/old` as the pilot + route-honesty hardening + Home-slice MATT-EXEC-EXT primitives.** The A/B/C fork (which shell legacy bodies land in at root) resolved = **approach A** (port legacy body into Matt shell `@layouts/AppLayout.astro`) — consistent nav everywhere, follows the Conv 201 root pattern, and Home was never a real Matt design (only a shell preview) so it's A-by-nature. **Home port (RTMIG-4 pilot):** `src/pages/index.astro` rebuilt from the `/old` dashboard in the Matt shell (header + OnboardingNudgeBanner + 2 ActionCards + Recent-Activity EmptyState + auth-reveal script); browser-verified. Per-page loop established: build in Matt shell → middleware PROTECTED_PREFIXES + hrefs → repoint e2e → browser-verify vs :4331 → retire `/old`. **Route-honesty hardening (Decision: links to unconverted pages must 404 — no resolving placeholder stubs):** deleted 6 placeholder routes (`/saved` `/todo` `/teachers` `/earnings` `/notifications` `/messages`), removed Peer Teachers + Earnings from Sidebar, kept `/teachers/[handle]` as StudentTeacherAnchor target, retained real-data `/courses`; memory `project_route_404_honesty_standin.md`. **Primitives showcase archived** `/`→`/dev/primitives` (+ `/dev/saved` + `/dev/todo` mirrors, dev subnav trimmed to 3); Decision: page owns its SubNav (slot-based opt-in, structural). **New `@stand-in` transient provenance marker** on 7 pages (login/signup/onboarding/profile/courses/course[...tab]/teachers[handle]) — greppable, NOT formalized in prov-sweep (self-erasing at retrofit; `grep -rl '@stand-in' src/pages` = remaining-work counter). **Home-slice MATT-EXEC-EXT primitives built** (Phase-6 slice): `EmptyState.astro` (+retrofit /dev/saved) + `ActionCard.astro` (both registered in prov-candidates `PHASE6_EXTRAPOLATION_CANDIDATES`, unmarked=ours), harvested Material `clock.svg`, restyled `OnboardingNudgeBanner` to Matt. **Fixed a latent prov-sweep 4c bug** (untracked-note check read only COMPONENT_CANDIDATES, not PHASE6 → false UNTRACKED on the new primitives). Gates green (tsc/astro check/prov-sweep); route map regenerated (109 routes). 2 new tasks: [PREFLIP-M4PRO] (retrofit M4Pro worktree + `peerloop-ref` alias) + [STANDIN-MATT] (approach A applied to the 7 `@stand-in` pages — same workstream as RTMIG-4); **next-conv ordering directive: PREFLIP-M4PRO FIRST, STANDIN-MATT SECOND.** No blocks completed (ROUTE-MIGRATION stays IN PROGRESS). Branch `jfg-dev-13-matt`. PREVIOUS (Conv 202): **ROUTE-MIGRATION: pre-flip git-worktree reference env stood up + `/old` deep-link fix RETIRED + [RTMIG-4] gap analysis → RESCOPE NEEDED.** The live branch can't browse legacy `/old/*` behavior (deep nav links lack the `/old/` prefix → 404 by design; no redirect layer). Rejected three in-branch patches (client-side href rewrite / `basePath` prop / middleware 404→`/old` fallback — the fallback would mask the very 404s that are RTMIG's verification signal). Durable choice: a **pre-flip git worktree as a zero-debt reference environment** ([PREFLIP-WT]) — `git worktree add ~/projects/Peerloop-preflip 846bab9f^` (detached `608346a2`, parent of the Conv 197 ROUTE-FLIP commit: `/matt` present, `/old` absent = genuine pre-flip app), `.dev.vars` copy + `.env` symlink + `npm install` + `db:setup:local:dev` + `npm run dev -- --port 4331`. /chrome confirmed port/URL-based (directory-agnostic) → :4321 live + :4331 reference coexist; toured the legacy app logged-in as admin. User declared the worktree satisfies all requirements of the proposed `/old` deep-link fix → **retired that need**. Reproduction: `peerloop-ref` alias + committed idempotent bootstrap `scripts/setup-preflip-ref.sh` (M4Pro) + named folder added to `peerloop.code-workspace` + memory `project_preflip_worktree_reference.md`. **[RTMIG-4] gap analysis (RESCOPE NEEDED next conv):** ~90 `/old` pages have NO root equivalent; Matt designed only **9** pages, all already at root (moved by ROUTE-FLIP) → RTMIG-4 is a routing migration of legacy pages, NOT build-to-Matt-design (can't be without blocking on 90 nonexistent designs; redesign is the separate MATT-EXEC-*/MMP-* track). Open methodology fork (which *shell* legacy bodies land in at root): (A) port body into Matt shell `@layouts/AppLayout.astro` [CC recommended, follows Conv 201 pattern], (B) port as-is with legacy shell, (C) migrate only Matt-designed. 90 pages × unresolved A/B/C is too coarse for one task → user stopped before any code; decompose + resolve the fork at the start of the next conv. RESUME-STATE.md cleared at /r-start. 1 code-repo file (`scripts/setup-preflip-ref.sh` new); docs `peerloop.code-workspace` + memory. No blocks completed (ROUTE-MIGRATION stays IN PROGRESS). Next major step (lead): RTMIG-4 rescope (decompose + resolve A/B/C). PREVIOUS (Conv 201): **ROUTE-MIGRATION block spawned + Phases 1–3 + SIGNUP DONE (post-ROUTE-FLIP forward-migration).** User asked whether the `/old/*` flows were E2E-verified after the Conv 197 flip; investigation found the e2e suite (30 specs) `goto()`s pre-flip root paths now living under `/old/*`, and — more importantly — that the legacy infra (middleware prefixes, `/login`/`/dashboard`/`/onboarding` redirect targets, ~30 hrefs) still pointed at old root paths, breaking auth app-wide with no redirect layer. **Systemic finding:** the five-gate baseline's gate #4 is `npm test` = vitest only (not `test:all`); `/w-codecheck` + `/r-end` never invoke playwright, so "baseline green" is *defined* to exclude real-URL navigation — the only signal that catches a moved route (vitest integration tests are in-process `/api/*` tests, never navigate). **Strategy (user, manual-programmer sequence):** treat `/old` as a *conversion source* not a maintained target — do NOT repoint tests/redirects to `/old`; instead (1) wire minimum to make app usable, (2) stub nav items, (3) verify, (4) convert `/old` pages → root one at a time. **Built + browser-verified via /chrome bridge:** [RTMIG-1] `/login`+`/signup` promoted to root (reuse `AutoOpenAuthModal`, authed→`/`), `AuthModalRenderer` re-homed into `AppLayout` (was mounted only in legacy AppNavbar → modal dead app-wide post-flip), post-login `/dashboard`→`/` in `auth-modal.ts`, root `/` confirmed canonical Home (stale "stub" comment corrected); [RTMIG-2] honest stubs `/earnings`+`/profile` (Conv-193 pattern), `/earnings` added to middleware `PROTECTED_EXACT`; [RTMIG-LOGOUT] logout button on `/profile`; [RTMIG-3] full nav sweep zero 404s + login→home→logout + protected-route `returnUrl` round-trip verified; [RTMIG-SIGNUP] `/onboarding` promoted to root (post-signup was 404ing), full signup→account→onboarding happy-path verified (real topic-picker). **All 4 bugs fixed were string-valued route refs invisible to `tsc`+`astro check` — only the browser caught them.** 2 code commits (`6ae1085d`, `912b75ab`) + 2 docs commits; gates astro check + tsc 0 errors. **Remaining in block:** [RTMIG-4] (per-page `/old`→root conversion, the big ongoing work + middleware PROTECTED_PREFIXES cleanup + `/profile`→`/@me`), [E2E-MIG] (re-point e2e to new routes incrementally), [E2E-GATE] (structural-change tier + goto-target resolver check; prototype `.scratch/e2e-route-map.mjs`). Branch `jfg-dev-13-matt`. PREVIOUS (Conv 200): **DTUNE: doc-sync-system cost-reduction (infra/tooling, no block advancement).** Re-tuned the existing `docsRegistry` so per-conv doc-maintenance shrinks to an explicit opt-in set. **Reframe:** the wall-time lever is the maintenance *contract* (drift hook + /r-end docs agent + CLAUDE.md "update the doc" mandate), not doc count. Design = **default-to-manual / driftCheck opt-in**: `doc-category` matcher added to `docs-registry.mjs` (unmatched→`manual`), `tech-doc-sweep.sh` gated on `category==driftCheck`, vendor-docs flipped to `manual` (rules kept as a code→vendor knowledge map), /r-end Agent 3 re-scoped driftCheck-only ("no docs" valid, no gap-spiral), CLAUDE.md tech-doc section rewritten + Maintenance-Tiers table, `doc-sync-strategy.md` §8. C-batch: 4 frozen docs archived → `docs/archive/` (🗄️ banners), `reactjs.md` de-staled (Alpha Peer→Peerloop), 📌 snapshot banners on 17 vendor docs (accurate ones NOT trimmed). 3 commits pushed (`63f8dc2`/`e2a1e99`/`47159e4`). NULL-byte hazard caught+fixed in the matcher edit (`**`→`.*` placeholder landed as `\x00`; tests passed but git saw binary; now `@@GS@@`). Tests 18/18. **Open follow-up [DTUNE-WATCH]:** validate over the next few convs that the re-scoped /r-end docs agent produces fewer doc tasks — the change is prompt-based, not a hard gate; tighten Agent 3 if vendor/prose tasks persist. **Side finding:** spt-docs has a live event-capture system (`PostToolUse:TaskUpdate`+`UserPromptSubmit`→`.conv-events.jsonl`, Conv 213) that Peerloop does NOT — Peerloop's Extract is built by scanning the conversation at /r-end (recorder vs task-creator distinction; `feedback`/`reference_spt_dual_repo` divergence extends to the whole capture layer). No code-repo changes; no blocks completed. Next major step (lead): MATT-DESIGN-PUSH Enroll/Session families ([MATT-EXEC-PG2] #2/#4), [MMP-PH5] roll-forward, [DISC-UNIFY], or [ADMIN-REDIRECT-BLANK]. PREVIOUS (Conv 199): **MATT-CUTOVER: [PROV-SWEEP] + [PROV-MATCH] DONE (provenance detection workstream) + [NAV-APP-A] confirmed mooted & closed.** Decision: build only the part of §6 that is both recurring AND deterministic today — the route flip dissolved the `matt/` domain delimiter, so collision candidates can't auto-derive from folder structure and must be hand-declared. New `scripts/prov-sweep.ts` (tsx validator: derives marked set by grep, reads `scripts/prov-candidates.ts` + `icon-provenance.ts`, runs 4 drift checks, emits collision-candidate manifest) + `scripts/prov-candidates.ts` (hand-maintained unmarked component+token candidate registry) + `prov:sweep` npm script + `matt-provenance.md §6a`; both drift branches calibrated via git-reverted test mutations; marker accept-rule tightened to require a node-shaped ref `\d+:\d+` (fixed false-positive on prose `@matt-source` mentions in `icon-provenance.ts`). [PROV-MATCH] (the Figma half) DONE same conv: live `get_metadata`(Components 1:269) + name-matching → **no confirmed collisions** (RoleTabBar not Matt-drawn; SectionTitle/SubNav name-matches are non-collisions by node-type) + `get_variable_defs`(40:482) confirmed no Alert/Carmine tokens; `matt-provenance.md §10`. [PLAY-CIRCLE-ICN] harvested play_circle (319:10972) → `svg/play-circle.svg` (matt-embedded 2→3) wired into VideoClipAnchor. [NAV-APP-A] CLOSED — AppNavbar renders only at `old/AppLayout.astro:38` (`/old/*`); root uses Matt Sidebar; NAV-RETROFIT + Conv-193 NAV-ICON-SWAP superseded. [ICN-NS] re-scoped to a 204-file legacy→MattIcon migration (kept open). [RA-STALE] role-audit doc fixed; [MCFRAME] folded into `feedback_conversational_brevity.md`. **Remaining in MATT-CUTOVER:** [PROV-MATCH-AUTO] (filter section-type nodes; gated on harvest infra #16/#17). **Learnings:** post-flip namespace dissolution removes the domain delimiter (derive-what's-marked, declare-what-isn't); tighten the accept-condition rather than chase reject-conditions; name-match needs node-type filter; triage terse task codes before grab-bag closeout. Code: `package.json` + `VideoClipAnchor.tsx` + `icon-provenance.ts` + `_INDEX.md` + 2 new scripts + 1 SVG; tsc clean. Branch `jfg-dev-13-matt`. MATT-CUTOVER stays IN PROGRESS for [PROV-MATCH-AUTO]. Next major step (lead): MATT-DESIGN-PUSH Enroll/Session families ([MATT-EXEC-PG2] #4), [MMP-PH5] roll-forward, [DISC-UNIFY], or [ADMIN-REDIRECT-BLANK]. PREVIOUS (Conv 198): **MATT-CUTOVER: post-flip doc-reconciliation batch #25–28 DONE** (docs-only conv). Framing decision Option B (design-canonical + status banner, NOT literal `/old` rewrite). [URLDOC-RECONCILE] (#25) url-routing.md §§1–7 kept canonical + status banner at § Route Categories + file-tree rewrite + Implementation-Status split + §8 softened; [DEVGUIDE-MATT-RECONCILE] (#26) DEVELOPMENT-GUIDE.md ~20 matt path/route/import refs → root, `matchHref`/component locations grep-verified; [MDS-MATT-RECONCILE] (#27) matt-design-system/ INDEX banner + concrete-ref fixes across 6 files (03 Conv-190 supersession pointer resolving a 03↔DEVGUIDE contradiction; 05 cross-ref repointed to renamed heading); [MFRD-MATT-PATHS] (#28) matt-frames-ready-for-dev.md bulk `replace_all` promotion + Status note. **Remaining in MATT-CUTOVER:** only [PROV-SWEEP] (deferred detection workstream). NAV-RETROFIT + [NAV-APP-A] still appear mooted by the flip (pending user close-out). **New pattern:** doc-reconciliation treatment is a function of doc TYPE (timeless-design / living-guide / historical-spec / machine-lookup), not the stale string. RESUME-STATE.md cleared at /r-start (28 items → TodoWrite). No code changes; no blocks completed (MATT-CUTOVER stays IN PROGRESS for [PROV-SWEEP]). PREVIOUS (Conv 197): **MATT-CUTOVER: [PROV] + [ROUTE-FLIP] both DONE** (demo succeeded → triggered the flip). [PROV]: 35 components + token blocks (primitives/typography/semantic, all Figma-node-cited) + 53-icon registry marked `@matt-source`; 9 unmarked = ours; new `matt-embedded` curation class (Material glyphs Matt curated into his Figma = his, cite his frame; ones we picked = ours); `icon-provenance.ts` (canonical typed map, per-glyph node granularity via Figma re-probe) + `_INDEX.md` human view; semantic-token provenance recovered via consuming-node re-probe (`40:484`/`40:482`); `matt-provenance.md` §7 SETTLED + §9 record. [ROUTE-FLIP]: pure file-move+link-rewrite (no redirect/middleware) — 43 legacy pages → `/old/*` (excl. api/ + 404), 9 Matt pages → root, layout collision resolved (legacy AppLayout→`/old`, Matt's→canonical root), `src/components/matt/*` namespace dissolved into components root (83 imports rewritten, 0 residual), 139 `/matt` URL literals rewritten + ControlBar/MainNav home-active special-case (the `startsWith('/')` trap), 2 demo bridges removed, route map regenerated, docs updated (provenance §8, url-routing §8 + banners); all 5 gates green / 6453 tests (full suite caught + fixed `onboarding.test.ts` hardcoded-path break). **Remaining in block:** [PROV-SWEEP] (deferred detection workstream) + [URLDOC-RECONCILE] (#27, url-routing §§1–7 + file-tree rewrite for post-flip layout). **NAV-RETROFIT + [NAV-APP-A] (#5) now appear mooted** by the shipped flip (root uses Matt's Sidebar; AppNavbar serves only `/old/*`) — flagged, awaiting user close-out. [ICN-NS] namespace-dissolve half mechanically done by the flip. **Key learnings:** path aliases (`@components/`/`@layouts/`, 0 relative page imports) de-risk move-heavy refactors to pure `git mv` + target-rewrite; blind `/matt/`→`/` replace breaks `startsWith` route-matching (home needs exact-match); word-boundary hazard (`/matt\b` would corrupt `/matt-provenance`); full test suite is the only gate catching hardcoded fs-path references. Branch `jfg-dev-13-matt`. (Earlier Conv 195/194 entries trimmed — see git history / docs/sessions.)*

*Previously: 2026-05-25 Conv 192 — NAV-RETROFIT home-page spacing fixes + MATT-DESIGN-PUSH doc-infra split + /matt/courses index. **NAV-RETROFIT:** fixed the home footer (`Footer.astro` both variants) and dashboard main-panel icons (`index.astro` `h-12 w-12`→`h-[48px]`, was clipping 24px glyphs) by converting hijacked spacing-bridge utilities to arbitrary px in place; DOM-verified in Chrome bridge. **[LEGACY-SPACING-AUDIT] resolved (do-nothing-broad):** override hijacks 3,894 utilities / 354 legacy files vs only 11 matt files — user chose to leave the bridge and fix per-component as the legacy→Matt migration reaches each (mechanical sweep would be thrown away); reaffirms Conv 191 "don't revert". **MATT-DESIGN-PUSH [MDS-SPLIT]:** matt-design-system.md (1,717 lines) split into `docs/as-designed/matt-design-system/` folder (INDEX + 01–07; §5 split at Button into color-tokens + component-primitives); old path → stub with §N→file mapping; byte-for-byte lossless verified; `docs/INDEX.md` repointed; convention recorded in `DOC-DECISIONS.md` §2. [CH-DOCSYNC] confirmed already done (Conv 187). **[MATT-COURSES-INDEX]:** new `src/pages/matt/courses.astro` (approach B — thin Matt-native index reusing `fetchCourseBrowseData` + `CourseEmbedCard` grid; CTA already targets `/matt/course/[slug]`); fills the SubNav 404; DOM-verified 6 cards/6 CTAs. **1 new deferred:** [DISC-UNIFY] (migrate `/discover/courses` onto `fetchCourseBrowseData`; needs `primary_topic_id` added to loader). No baseline gate run claimed this conv (doc-split + thin page + spacing-utility swaps — gates carried unverified from Conv 191). Branch `jfg-dev-13-matt`. Both NAV-RETROFIT and MATT-DESIGN-PUSH stay IN PROGRESS. Next major step (lead): [NAV-ICON-SWAP] / [NAV-SIBLINGS], MATT-DESIGN-PUSH Enroll/Session families, or [DISC-UNIFY].*

*Previously: 2026-05-25 Conv 191 — NAV-RETROFIT block opened (demo-driven legacy→Matt incremental migration). **Conv 191 deliverables:** root cause of an app-wide spacing regression found ([DEMO-HOME]) — Conv 174's `tokens-tailwind-bridge.css` `@theme` `--spacing-*` block silently shrank every legacy spacing utility in {4,8,12,16,20,24,32,40,48,64} ~4× since Conv 174 (`w-64`→64px); strategy (user) = do NOT revert (would break `/matt`), migrate legacy ONTO Matt incrementally (approach B). AppNavbar step 1 restyled to Matt (220px width, `text-body-medium-bold`/12px `text-body-small`, brand-blue flat active, `size-[16px]` chevrons, both slideouts `left-[220px]`); bidirectional demo bridge (AppNavbar "New Design"→`/matt/`; Matt Sidebar "Classic App"→`/`, TEMP). 3 View-Transition regressions found+fixed via the / → New-Design → Classic-App round-trip, all DOM-verified not screenshot (island-unique arbitrary-utility drop; inline-`<script>` not re-running on VT → `astro:page-load`; duplicate-`style` JSX silently dropped). [MDET] global machine-detection fixed (detect-machine.sh → canonical MacMiniM4Pro, committed global `98cc4c4`); 5 small carry-forwards closed ([MEM-ICON-COUNT] 43 icons, [MDS-SHELL] doc sync, [VIDEO-COMMENT-ICN] chat→video-comment swap, [MATT-PROFILE-VERIFY] user-verified). New memory `feedback_dom_truth_over_screenshots.md`. **3 new deferred (under NAV-RETROFIT):** [NAV-ICON-SWAP] / [NAV-SIBLINGS] (AdminNavbar/AppHeader `w-64` + MoreSlidePanel `left-64`) / [LEGACY-SPACING-AUDIT]. **Blocker:** [MMP-PH5] promotion half is machine-pinned to MacMiniM4 (source `.scratch/` files never synced). All 5 gates green (test 6453 / build 6.43s); commits code `c5ad1b6`+`be462d5`, docs `377ac5c`+`ac3e2cb`. Branch `jfg-dev-13-matt` retained. NAV-RETROFIT stays IN PROGRESS. Next major step (lead): [NAV-ICON-SWAP] / [NAV-SIBLINGS] / [LEGACY-SPACING-AUDIT] sweep, or possible approach-A component swap; MATT-DESIGN-PUSH Enroll/Session families still open.*

*Previously: 2026-05-25 Conv 190 — MATT-DESIGN-PUSH active — MATT-EXEC-PG2 course-tab polish + Sidebar/shell rewrite to Matt's Layout Desktop. **Conv 190 deliverables (8 subtasks completed + 1 new deferred):** [COURSE-TAGS-LOADER] fixed (`course_tags` JOIN tags for real names) + [REVIEW-COUNT] fixed (header count → `reviews.length`); [SNV-ICONS] DONE — Matt-sourced course SubNav leading icons (About=`info` extrapolation); [RTCONS] route consolidation (Decision 1 — `index.astro` deleted, About folded into `[...tab].astro` empty-segment `'about'` view, shared `_course-tabs.ts` single SubNav-config source; surfaced by a browser-found duplicated `courseTabs` array); [MNV-STYLE] DONE — Sidebar emoji → MattIcon; [SBAR-STICKY] sidebar viewport-pinned; [MATT-COURSE-POLISH] SubNav sticky + design-system-wide letter-spacing token fix (Figma `-2.2` = `-0.022em`, was `-2.2px` ~6× too tight across 4 "Body larger sizes" tokens); [SBAR-REWRITE] (Decision 2, scope B) — shell `#f8fafc` grey page + floating white rounded content card + transparent sidebar, always-white active pill, `«` double-chevron collapse (`chevrons-left.svg` = 43rd icon), role-aware bottom Profile cluster via new `src/lib/roles.ts` `describeRoles` (hierarchy Admin>Creator>Teacher>Moderator>Student, Visitor fallback, Decision 3), Logo Small + MainNav gap-24. **4 decisions:** (1) consolidate the two course routes into one catch-all; (2) scope B rewrite Sidebar AND shell (grey page enables the active pill contrast); (3) `roles.ts` multi-role `describeRoles` + Visitor; (4) About SubNav icon = `info` (Peerloop extrapolation). **Key learning:** browser verification catches duplicated-source bugs static checks can't (the iconless About page exposed a second `courseTabs` copy). **Code:** `courses.ts` (tag JOIN), `[...tab].astro` (REVIEW-COUNT + About `'about'` segment + `buildCourseTabs`), NEW `_course-tabs.ts` / `src/lib/roles.ts` / `icons/svg/chevrons-left.svg`, `Sidebar.tsx` rewrite, `AppLayout.astro` shell, `MainNav.tsx`, `SubNav.astro`, `UserIcon.tsx`, `tokens-typography.css`, `route-map.generated.ts` (-index.astro). All 5 gates green (test 6453 pass / 371 files). **1 new deferred:** [PROF-ROW-VERIFY] (logged-in Profile row not yet visually verified — only Visitor confirmed). Branch `jfg-dev-13-matt` retained; dev server left running on 4321. Next major step (lead): Enroll family / Session family under [MATT-EXEC-PG2], or [MMP-PH5] graduation.*

*Previously: 2026-05-24 Conv 189 — MATT-DESIGN-PUSH active — MATT-EXEC-PG2 course-tab family COMPLETE (all 6 course sub-tabs built). **Conv 189 deliverables (4 subtasks completed + 3 new deferred):** [CRTTAB] CreatorTab built — identity/bio/3 stat chips from real loader data; the 4 no-schema sections (Expertise / Teaching Philosophy / Qualifications / Why-Learn) render Matt's verbatim copy as static grey via a `staticContent` prop, NO schema change per user directive (`CREATOR_STATIC` constants in route); cosmetic fixes (`leading-normal` line-height workaround → [LH-VERIFY] now has visible evidence, light-blue quote bg restored). [RVWTAB] ReviewsTab built reading the existing `course_reviews` table via a new loader query (rating/body/author/timestamp real; reaction pills static). [MODTAB] ModulesTab built 1 card per `course_curriculum` row (1:1 per [MOD-SCHEMA]; sub-count + posts pill omitted per user "omit both"). [FEEDTAB] Course Feed tab built `MattCourseFeed.tsx` client island on the existing `GET /api/feeds/course/[slug]` (same Stream-backed API as legacy `CourseFeed.tsx` — real posts, corrected an earlier "needs Stream integration" conclusion). Extracted `CourseEmbedCard.tsx` (shared embedded-course card; Reviews refactored to reuse). All six course sub-tabs now render in `[...tab].astro` (feed/modules/creator/teachers/reviews/resources). **3 decisions:** (1) CreatorTab unbacked sections = static grey, no schema; (2) Reviews+Feed use real data via existing tables/APIs; (3) Modules = 1 card per curriculum row, omit unbacked counts. **Key learning:** per-tab data strategy is only knowable after probing the actual schema/seed/API (4 tabs, 4 different verdicts; a one-size default would have been wrong 3 of 4 times). **Code:** `src/lib/ssr/loaders/courses.ts` (+`reviews` query), `[...tab].astro` (4 branches + `CREATOR_STATIC` + shared `courseEmbed` + viewer query); NEW `CreatorTab.astro` / `ReviewsTab.astro` / `ModulesTab.astro` / `MattCourseFeed.tsx` / `CourseEmbedCard.tsx`. **No doc authorship** (session bookkeeping only). **3 new deferred:** [CRS-MOBILE] (no mobile breakpoint on course SubNav+tab layout), [FEED-COMPOSER-USER] (logged-out composer "?" avatar), [COURSE-TAGS-LOADER] (latent `course_tags` SELECT * typing mismatch). All 5 gates green (test 6453 pass). Branch `jfg-dev-13-matt` retained. Next major step (lead): Enroll family / Session family under [MATT-EXEC-PG2], or [MMP-PH5] graduation.*

*Previously: 2026-05-24 Conv 188 — MATT-DESIGN-PUSH active — MMP-PH4.5 SubNav routing COMPLETE + course-tab family decomposed + [MOD-SCHEMA] + [ENTITY-CASCADE-BUG] resolved. **Conv 188 deliverables (5 subtasks completed + 4 new deferred):** [MATT-SUBNAV-ROUTING] COMPLETE — `/matt/course/[slug]/[...tab].astro` catch-all route (`VALID_TABS` = feed/modules/creator/teachers/reviews/resources, invalid → 302, shell + per-tab switch) + a latent `SubNav.astro` active-state bug fixed (startsWith-prefix → most-specific-match-wins; About no longer stays Selected on child tabs); routing demonstrated live in Chrome bridge across all 7 tabs, `matt-subnav-routing.gif` → `.scratch/screenshots/`. **[MATT-EXEC-PG2] course-tab family decomposed** (Decision Option A — per-tab `.astro` body components + `tab ===` switch, index.astro/About untouched, shell duplicated across the 2 route files): [RESTAB] ResourcesTab built (Matt's empty state; `folder.svg` harvested = 42nd Matt icon); [TCHTAB] TeachersTab built (bio-card composite reading live D1 via SSR loader; role-based entity palette `.entity-creator` purple / `.entity-student-teacher` blue; stat chips mapped to real loader data not Matt's demo); [CRTTAB] / [RVWTAB] / [MODTAB] remain pending; Enroll + Session families still under PG2 parent. Conv 188 triage corrected Ready-for-Dev lookup rows 3-8 (tabs are NEW card composites, not anchor-list shells; Matt frames are happy-path instance snapshots). **[MOD-SCHEMA] RESOLVED** — Session↔Module is 1:1; Matt's/creators' nested "Modules" = Sub-Modules (term misuse); no session→many-modules data model; saved to memory `project_module_submodule_model.md`. **[ENTITY-CASCADE-BUG] FIXED** — cascade-driven `--color-entity-primary/background` moved from plain `@theme` to `@theme inline` (plain `@theme` flattened `var(--Entity-*)` against `:root`, silently breaking EntityPill / EntityLink / UserIcon role colors app-wide); surfaced via opt-in `roleDot` prop on `UserIcon.tsx`. **3 decisions:** (1) PG2 course tabs = per-tab components, shell duplicated; (2) Modules model Session↔Module 1:1, Matt "Module"=Sub-Module; (3) role-color cue = opt-in corner role dot. **3 learnings:** Tailwind 4 `@theme` flattens cascade-driven tokens (use `@theme inline`); most-specific-match-wins for section-index nav active-state; Ready-for-Dev "expected primitives" are inferences, always probe the frame. **Code:** `SubNav.astro` (active-state fix), `UserIcon.tsx` (roleDot), `tokens-tailwind-bridge.css` (@theme inline), NEW `ResourcesTab.astro` / `TeachersTab.astro` / `[...tab].astro` / `icons/svg/folder.svg`. **Docs/scratch:** `matt-frames-ready-for-dev.md` rows 3-8 corrected; new `memory/project_module_submodule_model.md` + MEMORY.md pointer; `matt-subnav-routing.gif`. **4 new deferred:** [SHOWMORE] (Teachers+Reviews show-more), [SNV-ICONS] (course SubNav leading icons), [MNV-STYLE] (Sidebar emoji icons + type mismatch vs Matt Layouts), [MEM-ICON-COUNT] (MEMORY.md icon count stale → 42). Full baseline: build 6.30s clean; test 6453 passed / 371 files. Branch `jfg-dev-13-matt` retained. Next major step (lead): continue [MATT-EXEC-PG2] — wire remaining course tabs ([CRTTAB] / [RVWTAB] / [MODTAB]) and/or [MMP-PH5] graduation.*

*Previously: 2026-05-24 Conv 187 — MATT-DESIGN-PUSH active — MMP-PH4 re-render test COMPLETE + per-icon viewBox registry + CourseHeader re-validated to Matt's Default frame + addressability-first routing resolution. **Conv 187 deliverables (8 PLAN subtasks completed + 2 new deferred + 6 code/asset files touched across 2 commits):** [MMP-PH4] Course In Feed (`519:9096`) re-rendered as `CourseInFeed.tsx` (props-driven dark-hero card composing EntityPill + 4 on-dark IconLabelChips + course Button + MattIcon) — live-verified in Chrome bridge at 245px (matches Matt's instance exactly); the re-render gate surfaced the two assumptions it was designed to catch. [CMP-ICN-REGISTRY] RESOLVED = per-icon intrinsic viewBox in `MattIcon.tsx` (default 24×24) over rescale-via-transform — icons stored at native size, MattIcon now size-agnostic so future Material harvests at any grid "just work". [STARS2-ICN] + [ACCESSIBILITY-ICN] harvested from Figma asset URLs at native 20×20 (fills normalized to `currentColor`, mask rect `#D9D9D9`). [DARK-HERO-VARS] COMPLETE — `tone="default"|"on-dark"` prop on IconLabelChip applied to both heroes; **Button dark variant confirmed unneeded** (both heroes use light-bg pill CTAs). [MATT-IDX-AUDIT] 6 placeholder `<article>` cards → `<Card>`. [MATT-EXEC-FLAGS] RESOLVED on the addressability axis (user reframe): addressable = Course tabs, Enroll Success (Stripe success_url), Choose Teacher, Session (ONE state-driven `/session/[id]`), Home/Feed; non-addressable = Enroll pre-checkout, Session Scheduled, Home/Course Completed; file-count deferred to build. [GVD-SELFREE-VERIFY] + [MCP-SEL-MISFIRE] closed — `get_variable_defs` confirmed selection-free with explicit nodeId; "selection-required" tool class retired. **CourseHeader re-validated to Matt's Default frame `517:8935` (reverses Conv 184/185 creator trio):** `CourseHeader.astro` → `CourseHeader.tsx`; Matt shows all metadata as white on-dark IconLabelChips, NOT the UserIcon+EntityPill+EntityLink trio (which now belongs in the future Meet-the-Creator tab); user confirmed ("B" — keep the reversal). **3 decisions:** (1) icon registry absorbs non-24dp icons via per-icon viewBox; (2) CourseHeader re-validated to Matt's frame; (3) Matt-flow routes decided by addressability not page-count (saved as `feedback_routing_addressability_first.md`). **4 learnings:** all Figma read tools are selection-free with an explicit nodeId; master/instance is the recurring shape for Matt's hero frames (probe `get_metadata` on the section to enumerate variants first); addressability not page-count is the load-bearing routing decision; re-render-and-verify catches drift that building-from-spec misses. **Code commits:** `ead81ada` (CourseInFeed + per-icon viewBox + 2 SVGs + IconLabelChip on-dark + showcase), `cea3def0` (CourseHeader re-validation + 6 article→Card). **Docs commit:** `06d33a0` (`reference_figma_mcp_behavior.md` selection-required class retired; new `feedback_routing_addressability_first.md`; MEMORY.md index). **Scratch:** `.scratch/matt-frames-ready-for-dev.md` rows 31/32 resolved + Route Addressability section. **2 new deferred items:** [CH-DOCSYNC] (matt-design-system.md doc-sync — replace CourseHeader creator-trio docs with the IconLabelChip chip; routed to docs agent + TaskCreate), [CH-VARIANTS] (CourseHeader Enrolled `597:6504` + Scheduled `685:13240` variants — only Default built; sequence at MMP-PH5 enrolled-state pages). All 5 baseline gates green (tsc 0; astro check 0/0/0; build clean). Branch `jfg-dev-13-matt` retained. Next major step (lead): **[MMP-PH5]** Phase 5 graduation — promote scratch lookups to `docs/`, then roll forward to remaining `/matt/*` routes via MCP (now addressability-resolved as thin-shell assembly).*

*Previously: 2026-05-24 Conv 186 — MATT-DESIGN-PUSH active — Matt frames Ready-for-Dev drift lookup landed (32 rows across Components ✅ + Happy Path ✅ + Layout ✅) + Course SubNav routing pattern resolved + 3 redundant tasks deleted + 9 new deferred subtasks spawned. **Conv 186 deliverables (6 PLAN subtasks completed + 9 new deferred + 3 tasks deleted + 1 sub-assumption of [MATT-EXEC-FLAGS] resolved):** [SP-AUDIT] SocialPost subtree audit clean per `feedback_reuse_existing_components.md`; [ASSET-SWEEP] verified zero embedded Figma URLs in `src/`; [MFRD-DESIGN] drift-detection workflow designed (cheap status-banner probes for "Last Touched" comparison + deep probe on date mismatch + side-effect Material-icon harvest); [MFRD-SEED] `.scratch/matt-frames-ready-for-dev.md` populated with 32 rows + 3 completeness markers; [SUBNAV-PATTERN] resolved Course SubNav route shape — mirror `/discover/course/[slug]/[...tab].astro` (Astro rest-spread + VALID_TABS + path-based bookmarkable); [TASK-CLEANUP] deleted 3 redundant tasks ([CMP-EXT-ICN] / [MATT-CREATOR-TAB] / [MDR]). **4 strategic decisions:** (1) Matt Course SubNav routing = path-based `[...tab].astro` mirroring `/discover/course`; (2) Drift-detection lookup at `.scratch/matt-frames-ready-for-dev.md` (graduates to `docs/reference/` at MMP-PH5 or sooner); (3) Side-effect Material-icon discovery via drift-check workflow (replaces umbrella [CMP-EXT-ICN] with automatic mechanism); (4) `Parent Page` column added to lookup schema. **8 patterns/learnings established:** (1) Spatial banner-to-section derivation reliable on Matt's Figma (y=785 alignment); (2) Matt's "Last Touched" is the single drift signal (3 text nodes per banner, single `get_design_context` call); (3) `Home /` vs `Page /` prefix convention (variants vs standalone pages); (4) The lookup-driven discovery loop exposes architecture as side-effect of cataloging design state; (5) Matt's review passes are batched, not incremental (treat bulk-update patterns as one response unit); (6) Figma MCP `get_design_context` works without selection on remote MCP when explicit node-IDs supplied (contradicts Conv 180 memory entry — selection only required when probing the *currently-selected* node); (7) Name-collision drift catches: section-name vs banner-title (banner wins); (8) `ControlBar.tsx` purpose discovered retroactively via lookup row 14 (Session During). **Code changes:** None — purely doc/scratch work. **Docs changes:** None (RESUME-STATE.md deleted by /r-start). **Scratch changes:** NEW file `.scratch/matt-frames-ready-for-dev.md` (32-row lookup with schema, drift-check workflow, completeness markers, drift-check history). **Tasks created Conv 186 (9 new deferred):** [TXTBTN], [MATT-IDX-AUDIT], [STARS2-ICN], [ACCESSIBILITY-ICN], [HOWTOREG-ICN], [ASSET-SWEEP-GATE], [FIGMA-MCP-DOC-HARVEST], [MFRD-LOOKUP], [MATT-SUBNAV-ROUTING]. **Tasks deleted Conv 186 (3 redundant):** [CMP-EXT-ICN] (#10, superseded by 5 specific harvest tasks + drift-check side-effect rule); [MATT-CREATOR-TAB] (#16, replaced by [MATT-SUBNAV-ROUTING] — Creator is now one of 6 tabs in `VALID_TABS`); [MDR] (#19, placeholder completed by [MFRD-LOOKUP]). **[MATT-EXEC-FLAGS] sub-assumption (e) RESOLVED** (Matt Course SubNav = mirror `/discover/course/[slug]/[...tab].astro`); 6 of 7 sub-assumptions remain (expanded from 4 to 7: added (f) Enroll funnel route family, (g) Session lifecycle routes, (h) Home variant route shape). Branch `jfg-dev-13-matt` retained (no code changes this conv). Open question: Is `Hero Course in Feed` (502:12911) identical to `Course In Feed` (519:9096) or do they have subtle differences? Verify at MMP-PH4 kickoff. Next major step (lead): **[MMP-PH4]** Re-render Course In Feed (519:9096) + translate + visual diff — empirically buildable with full primitive vocabulary (and now with drift lookup as canonical reference for what's Ready-for-Dev).*

*Previously: 2026-05-24 Conv 185 — MATT-DESIGN-PUSH MMP-PH3 audit-driven follow-throughs — all 5 Q1/Q2 carry-forward items from Conv 184 audit COMPLETE in one conv. **Conv 185 deliverables (5 carry-forward items closed + 3 new deferred + 11 new code components + 6 SVG assets + 2 new subdirs + 1 memory file update):** User redirected from auto-recommended MMP-PH4 to the Conv 184 audit table; CC sequenced BRN → CHAT → C178-REVAL → CMP-ANCH-REST (build all Q1 NEW primitives FIRST so re-probes see full vocabulary, then audit, then largest batch last). **[MATT-EXEC-CMP-BRN] Brand primitive** — Logo (3 variants Large/Medium/Small) + LogoMark (3 variants Default/Medium/Small) from Matt's `40:481`/`1:270`/`35:144`. 4 SVGs downloaded via `curl` to discover Figma MCP asset URLs return SVG for vector sources (not raster PNG) — new MCP empirical finding captured in `reference_figma_mcp_behavior.md` + MEMORY.md. Fills normalized `var(--fill-0, #hex)` → `currentColor` via perl-pi. Refactored `Sidebar.tsx:85-91` from placeholder `∞ PeerLoop` text to Logo Medium (expanded) / LogoMark Default (collapsed). Playwright screenshot verified all 6 variants. **[CMP-CHAT] Chat Bubble primitive** — 2 variants Default/Us from `646:7540` (159×35; Matt drew pre-mirrored shapes rather than CSS transforms). `ChatBubble.tsx` with `property1: 'Default' | 'Us'` strict-B enum, currentColor tail with matching `text-*` class per variant. **Strict-B drift documented:** `inline-flex max-w-[280px]` content-sized default instead of Matt's 159px Figma placeholder (159px is drawing scaffold, not UX rule). **[C178-REVAL] re-validation** found significant Conv 178 drift in all 3 newly-probed: **Module** rewritten with 2 variants Default/Current matching Matt's `property1` enum (dropped over-engineered 4-color `entity` prop — Matt's "active" uses single hardcoded `--Primary-Light`), 220px width, Medium font weight, single title+duration line; **ToDoItem** rewritten with 20×20 rounded-[5px] checkbox (was 24×24 rounded-6), Medium font weights, 289px width, dropped `entity` prop, kept idiomatic `checked: boolean` API; **SectionTitle NAME COLLISION discovered** — Matt's "Section Title" is a Figma-internal dev-status banner (WIP orange/Dev Ready green/Archived red, 1280×96px, TT Norms Pro Mono font) — NOT a product component; our `SectionTitle.astro` is a generic content heading (Inter) — different purposes; documented but unchanged; **SocialPost** re-probe skipped (already validated Conv 184). Verified Module + ToDoItem are only used in `/matt/index.astro` showcase before refactoring (safe). **[REFACTOR-COURSEHEADER]** Creator section refactored to UserIcon + EntityPill + EntityLink trio in `.entity-creator` cascade; extended `CreatorRef` interface with optional `slug`/`initials`/`avatarUrl`; updated caller `/matt/course/[slug]/index.astro` to pass `data.creator.handle` + `data.creator.avatar_url`. **Caveat:** Rating/level/CTA stay inline because dark-hero contrast is incompatible with light-bg-optimized primitives (IconLabelChip uses `text-text-tertiary` gray; Button is light-bg-optimized). Spawned [DARK-HERO-VARS] for follow-up. **[CMP-ANCH-REST]** All 8 remaining anchor row components built in single batch: CreatorAnchor (entity-creator, "Learn More" CTA); CertificationAnchor (no pill, no CTA); ModuleAnchor (no pill, no CTA); ResourceAnchor (default Button "View"); ReviewAnchor (default Button "Read"); StudentTeacherAnchor (entity-student-teacher, pill "Suggested" — NOT "Student-Teacher" per Matt's text; "View Teacher" CTA); VideoClipAnchor (123×69 thumbnail with inline-SVG play-circle overlay; chat icon as substitute for `video_comment` pending [VIDEO-COMMENT-ICN]; "Watch" CTA); MilestoneAnchor (no pill, default Button "View"). Locks in Option C: 9 distinct anchor row components, no shared base. **All 13 of Matt's named Components-page primitives now built** — MMP-PH3 substantially complete; remaining gaps are Phase 6 extrapolation work. **4 strategic decisions:** (1) Sequence BRN → CHAT → C178-REVAL → CMP-ANCH-REST (composite ordering over smallest-first / audit-first / anchors-first); (2) ChatBubble drifts from Matt's 159px canvas placeholder (`inline-flex max-w-[280px]` default with optional className override); (3) Drop `entity` prop from Module + ToDoItem (strict-B match to Matt's 2 variants); (4) CourseHeader CTA + rating/level stay inline pending [DARK-HERO-VARS]. **5 patterns established:** (1) Figma MCP asset URLs preserve source format (vector → SVG with `fill="var(--fill-0, #hex)"`, raster → PNG); (2) pre-mirrored asset SVGs vs CSS-transform mirroring (Matt may draw each variant as separate pre-mirrored SVG); (3) Conv 178 reconnaissance over-engineered with `entity` prop on non-entity primitives (strict-B mirror is safer default); (4) Playwright fallback when Chrome MCP bridge is flaky; (5) design-system meta elements aren't always product primitives (Matt's SectionTitle = Figma-internal dev-status banner). **Code changes:** 11 new component files (Logo.tsx + LogoMark.tsx + ChatBubble.tsx + 8 anchor .tsx) + 6 SVG assets + 2 new subdirs `matt/brand/` + `matt/chat/`; Module.tsx + ToDoItem.tsx rewritten (113 → 113 lines and 84 → 84 lines respectively, dropping `entity` prop); Sidebar.tsx Brand integration (11 line delta); CourseHeader.astro creator-section refactor (36 line delta); `/matt/index.astro` showcase extended with 175 line delta (Brand 2 Cards + Chat 1 Card + 8 Anchor Cards + updated Module/ToDoItem callers). **Docs changes:** none (memory + extract only). **Memory changes:** `reference_figma_mcp_behavior.md` augmented with SVG-asset-format finding; MEMORY.md index line updated with Conv 185 reference + perl-normalize command. **3 new deferred items:** [DARK-HERO-VARS] (build dark-hero variants of IconLabelChip + Button so CourseHeader rating/level/CTA can be refactored); [VIDEO-COMMENT-ICN] (harvest Material icon — VideoClipAnchor uses `chat` as substitute); [PLAY-CIRCLE-ICN] (harvest Material icon — VideoClipAnchor uses inline-SVG placeholder). **Package changes:** Installed Playwright chromium browser (~250MB one-time via `npx playwright install chromium`) for programmatic screenshot verification — Chrome MCP extension disconnected mid-conv; `osascript` + `screencapture -x` kept grabbing desktop wallpaper. Persists in `~/Library/Caches/ms-playwright/`. Branch `jfg-dev-13-matt` retained. RESUME-STATE.md cleared at /r-start. Next major step (lead): **[MMP-PH4]** Re-render Course In Feed (519:9096) + translate + visual diff — now empirically buildable with full primitive vocabulary.*

*Previously: 2026-05-24 Conv 184 — MATT-DESIGN-PUSH MMP-PH3 continued — SubNav + Entity collection decomposition (Option C) + SocialPost full closure + new reuse standing rule. **Conv 184 deliverables (12 PLAN subtasks completed + 3 new deferred + 8 new code components + 1 new memory file + 6 .astro→.tsx conversions + 1 new entity-class alias):** [MATT-EXEC-CMP-SNV] COMPLETE — `SubNav.astro` rewritten with `currentPath`-derived active state (fixing latent Conv 175 silent bug); new `SubNavItem.astro` 3 Property 1 variants (Default/Hover/Selected) + Selected-with-subnav expanded conditional render. Resolved Conv 183 "Need 3+ Levels" open question via Figma probes (`502:12864` base + `622:18616` expanded) — NOT multi-level, it's base + Selected-expanded. User reframed Entities + Post Anchors as collections; Option C architecture locked in: **9 distinct anchor row components, no shared `AnchorRow` base** — Matt's component-naming convention is the load-bearing signal per `feedback_tokenize_only_matt_variables.md`, and heterogeneous data per anchor type resists clean abstraction. [CMP-UICN] / [CMP-EPILL] / [CMP-ELINK] / [CMP-CHIP] — 4 leaf primitives extracted from Entities decomposition; IconLabelChip is the deliberate strict-B deviation (Matt didn't name it; user "make these reusable" directive justifies; honest-orphan annotation in file header). [CMP-ANCH-COURSE] CourseAnchor first anchor row (composes UserIcon + EntityPill + IconLabelChip + Button + MattIcon). [CMP-ANALYTIC] AnalyticCount primitive extracted from SocialPost inline `ActionPill()` helper (2 variants Default/1+ auto-flip). [CMP-UICN-IMG] UserIcon extended with `avatarUrl?` strict-B extrapolation for production avatars; honest-orphan annotation in file header. [REFACTOR-SOCIALPOST] SocialPost.tsx + _SocialPostDemo.tsx fully refactored — removed inline Avatar / ActionPill / LikeIcon / CommentIcon constants; imports UserIcon + IconLabelChip + AnalyticCount + CourseAnchor (embed); flattened header to Matt's strict-B layout; replaced footer with 3 `<AnalyticCount>` instances + added `loves?` prop; removed avatar-preview commenters strip (Conv 175 extrapolation not in Matt's design). Breaking API: `roleIcon: ReactNode` → `roleIconName?: string`; removed `commenters` prop. **Astro/React boundary cascade forced full standardization on React (.tsx)** — SocialPost.tsx (React) needed to import Conv 184 primitives (built as .astro). React can't import Astro. Resolution: convert all 6 primitives + MattIcon to React (.tsx). Astro renders React as static HTML by default (no hydration cost unless `client:*` directive). Pattern: **primitives in React (broadest reusability), page-wrappers in Astro**. 6 .astro files deleted (MattIcon, UserIcon, EntityPill, EntityLink, IconLabelChip, CourseAnchor). `class` → `className` for React component props in Astro callers (SubNavItem, /matt/index.astro). **New standing rule:** `feedback_reuse_existing_components.md` codifies "scan `<instance>` children, import existing primitives, never inline duplicates" — surfaced by audit revealing SocialPost inlined Avatar/ActionPill AND CourseAnchor (built earlier same conv) inlined Button styling instead of importing Button.tsx. CourseAnchor refactored same conv to use Button.tsx + `class` → `className` fix; removed wrong "React-hydration-cost" justification comment. tokens-semantic.css `.entity-student-teacher` alias added (Conv 184 probe found Matt uses Student's colors for Student-Teacher). `/matt/` showcase extended with 6 new Card sections demonstrating each primitive across 4 entity contexts + 2 CourseAnchor instances + AnalyticCount showcase. **5 strategic decisions:** (1) Standardize Conv 184 primitives + MattIcon on React (.tsx) — design-system architectural rule resolving Astro/React boundary; (2) 9 distinct anchor row components, no shared `AnchorRow` base (Option C) — per Matt's component-naming convention; (3) Extract IconLabelChip despite Matt not naming it — user directive overrides strict tokenize-only-Matt rule, honest-orphan annotation marks deviation; (4) New standing rule scan `<instance>` children + import existing primitives — codified after dual-violation audit; (5) UserIcon image-mode pulled forward to Conv 184 — `avatarUrl?` with honest-extension annotation. **6 learnings:** (1) Figma `<instance>` nodes are the design system's import boundaries — every `<instance>` in metadata should map to an imported code component; gap surfaces as missing-primitive, not as inline duplicate "for now"; (2) Astro can import React but not the reverse — primitives consumed from both contexts must be React; (3) Strict-B mirroring catches silent bugs as a side-effect — Conv 175 SubNav `active?: boolean` per-item never consumed by either caller, latent for ~9 convs until Conv 184's Figma-grounded rewrite forced re-test; (4) Figma frame-name patterns are evidence even when not named as components — but Matt's component-naming convention is the load-bearing signal for "what should be a primitive in code"; (5) UserIcon is initials, not role-icon — visual inspection from inventory screenshots unreliable; probe via `get_design_context` before building; (6) Matt's `data-name` attribute IS the translation key for instance-named primitives — even when rendered as generic `<div>`, `data-name="User Icon"` / `data-name="Entity Pill"` / `data-name="Analytic Count"` identify reuse boundaries. **5 patterns established:** primitives in React + page-wrappers in Astro; scan `<instance>` children before rendering; `data-name` as canonical translation key; strict-B mirroring catches latent bugs; frame-name reuse vs Matt-named components. **Code changes:** 8 new React .tsx files (`MattIcon.tsx`, `UserIcon.tsx`, `EntityPill.tsx`, `EntityLink.tsx`, `IconLabelChip.tsx`, `CourseAnchor.tsx`, `AnalyticCount.tsx`, `SubNavItem.astro`) + SubNav.astro rewritten + 2 callers updated for currentPath + SocialPost.tsx + _SocialPostDemo.tsx refactored + tokens-semantic.css alias + /matt/index.astro Conv 184 showcase. 6 .astro files deleted (superseded). **Docs changes:** matt-design-system.md (5 new Conv 184 subsections); `.scratch/matt-figma-pages.md` 13 new probed-frames rows; `.scratch/conv-184-subnav-base.png` + `conv-184-subnav-with-subnav.png` (Figma screenshots). **Memory changes:** 1 new file `feedback_reuse_existing_components.md` + MEMORY.md index entry. **3 new deferred items:** [CMP-CHAT] (Chat Bubble primitive 2 variants from `646:7540`); [REFACTOR-COURSEHEADER] (165 lines zero imports — replace inline elements with UserIcon + EntityPill + EntityLink per new reuse rule); [CMP-ANCH-REST] (remaining 8 anchor rows). Baseline gates clean (tsc 0; astro check 1243 files 0/0/0; dev HTTP 200). DOM verified counts: 6 UserIcon + 8 EntityPill + 15 IconLabelChip + 7 AnalyticCount + 3 CourseAnchor + 1 SocialPost (math validates total elimination of inline duplication). Branch `jfg-dev-13-matt` retained as active. RESUME-STATE.md cleared at /r-start. Next major step (lead): MMP-PH3 continuation — [CMP-CHAT] (small/focused 2-variant), [REFACTOR-COURSEHEADER] (apply reuse rule retroactively), and 8 of 9 remaining anchor rows ([CMP-ANCH-REST]); plus optional visual screenshot-diff before MMP-PH4.*

*Previously: 2026-05-23 Conv 183 — MATT-DESIGN-PUSH MMP-PH3 Component primitives IN PROGRESS (2 of 7 landed: Button + MainNav). **Conv 183 deliverables (2 PLAN subtasks completed + 1 watch-task description updated + 0 new deferred + 3 new code components + 2 code refactors + 1 docs update + 1 new memory file):** [MATT-EXEC-CMP-BTN] COMPLETE — `Button.tsx` rewritten with **strict-B 5-value `property1` enum** (`Default | Hover | Large | Small | SmallHover`) mirroring Matt's Figma Property 1 exactly. **Major finding:** Conv 178's "3-orthogonal-dimension" architecture claim was WRONG — Property 1 conflates State AND Size (5 cells, not 3-orthogonal). All CSS extracted via MCP probes of 5 Figma nodes (`40:482` section + `1:284` Default + `513:14820` Hover + `1:292` Large + `360:11906` Small + `675:12314` SmallHover). 6 Color variants preserved; Hover/SmallHover use inline-style hardcoded gradient + border (Matt's design has partial coverage — Hover is Primary-only with no Variable Mode awareness; non-Primary + Hover combos render Primary-darkened, Phase 6 [MATT-EXEC-EXT] for variant-aware extrapolation). Disabled kept as standard a11y orphan via `[disabled]` CSS rule. `_SocialPostDemo.tsx` migrated `size="sm"` → `property1="Small"`. matt-design-system.md §5 Button rewritten with empirical variant matrix replacing Conv 178 framing. [MATT-EXEC-CMP-MNV] COMPLETE — 3 new React components: `MainNav.tsx` (props-driven orchestrator, exports `NavItemData`/`NavSubItemData` interfaces), `NavItem.tsx` (3 Property 1 variants: Default+Selected flat row, Main = white pill with parent + divider + Sub Nav slot), `NavSubItem.tsx` (2 Property 1 variants: Default+Selected, color shift only). Architecture decisions D1/D2/D3 made via **AskUserQuestion + ASCII mockup previews** (user pushed back on text-only descriptions; new pattern established): **D1 = Route-driven Main pill** (auto-positions around active section, derived state, no toggle), **D2 = Keep 70px collapse mode** as Peerloop extension (Sidebar renders separate icon-only nav when collapsed since 220px Matt layout doesn't compress gracefully), **D3 = Props-driven** data model. `Sidebar.tsx` refactored to consume `MainNav`; retains Peerloop shell (brand mark + Earnings/Notifications/Profile + collapse toggle). CSS extracted via MCP probes of 4 critical variants (`108:4614` Default NavItem, `150:8585` Main NavItem, `108:4615` Default NavSubItem, `110:5097` Selected NavSubItem). matt-design-system.md got new `### MainNav (3-variant composite primitive — extracted Conv 183)` subsection. [MCP-SEL-MISFIRE] description updated with Conv 183 positive observation: 8 successful `get_design_context` calls without user pre-selection in Figma desktop — contradicts Conv 180 `reference_figma_mcp_behavior.md` selection-REQUIRED claim. **7 strategic decisions:** (1) Button strict-B single `property1` prop mirroring Matt's 5-value enum exactly; (2) MainNav D1 = Route-driven Main pill (derived state, no toggle); (3) MainNav D2 = Keep 70px collapse as Peerloop extension (isolated to Sidebar shell); (4) MainNav D3 = Props-driven data model (enables Admin/Teacher variants); (5) Figma is READ-ONLY — never call write-shaped MCP tools (user directive saved as new memory file); (6) Hover styling for non-Primary variants defers to Phase 6 extrapolation (strict-B mirror); (7) Disabled state = standard a11y orphan via `[disabled]` CSS rule (NOT a 6th Property 1 value). **6 learnings:** (1) Empirical MCP probe trumps inferred architectural documentation — Conv 178 "3-orthogonal Button" was a logical projection without probing; [EMP] rule recurring (Conv 180: 4 reversals; Conv 183: +2 more); **probe THEN write the spec, never the inverse**; (2) Matt's "Main" pill is route-driven, not click-to-expand — active-detection rule: item enters `Main` if currentPath matches it OR any child AND it has children; no ▼/▶ toggle indicator in Matt's design; (3) ASCII mockups via AskUserQuestion `preview` field as decision aid — render Matt's Figma reference in ASCII as baseline + each candidate option as ASCII showing how it differs; side-by-side monospace comparison anchors decisions visually; (4) Matt's Hover variant is Primary-Variable-Mode-specific (partial coverage gap) — `var(--background)`/`var(--border)` indirection NOT used in Hover variant; non-Primary + Hover renders Primary-darkened regardless; per tokenize-only-matt-variables, mirror literally + flag gap in code comment for Phase 6; (5) `get_design_context` may not always require pre-selection — 8 successful calls across Conv 183 contradict Conv 180 canonical claim; multiple data points across multiple convs needed before updating memory; (6) ASCII Figma reference is reusable across decision rounds — invest 60s upfront to render Matt's source in ASCII; pays off across whole decision sequence; save in scratch alongside PNG screenshot. **3 patterns established:** doc graduation for component primitives (add formal `### <Component> (extracted Conv NNN)` subsection in matt-design-system.md with Figma node IDs + variant table + extracted CSS + component shape); ASCII baseline + AskUserQuestion previews for architectural decisions; per-state Variable-Mode-awareness check when porting multi-state × multi-color components. **Code changes (3 new + 2 refactor):** `src/components/matt/MainNav.tsx` (NEW), `src/components/matt/NavItem.tsx` (NEW), `src/components/matt/NavSubItem.tsx` (NEW), `src/components/matt/Sidebar.tsx` refactored to consume MainNav while retaining Peerloop shell, `src/components/matt/ui/Button.tsx` rewritten with strict-B 5-value `property1` enum (`_SocialPostDemo.tsx` migrated as sole caller). **Docs changes:** matt-design-system.md (§5 Button rewritten + new MainNav subsection); RESUME-STATE.md deleted by /r-start (23 outstanding tasks transferred to TodoWrite). **Scratch:** `.scratch/matt-figma-pages.md` enriched (Button + MainNav node rows + architecture-finding paragraph); `.scratch/conv-183-button-section.png` (NEW); `.scratch/conv-183-mainnav-section.png` (NEW). **Memory changes:** 1 new file `feedback_never_modify_figma.md` (Figma is read-only; never call write-shaped MCP tools) + MEMORY.md index entry under §Security & Secrets. Baseline gates clean (tsc 0; astro check 1236 files 0/0/0; dev HTTP 200). Branch `jfg-dev-13-matt` retained as active. Next major step (lead): MMP-PH3 continued — 5 of 7 component primitives remain ([-SNV] / [-ENT] / [-CHT] / [-PNC] / [-BRN]).*

*Previously: 2026-05-23 Conv 182 — MATT-DESIGN-PUSH MMP-PH2 Icon registry COMPLETE + 5 doc graduations + [CASCADE-BROKEN] closed. **Conv 182 deliverables (8 PLAN subtasks completed + 0 new deferred + 1 new code component + 1 new reference doc + 2 docs updated):** [MMP-PH2] / [MATT-EXEC-CMP-ICN] code-integration COMPLETE — 39 Matt SVGs ported `.scratch/matt-main/components/icons/` → `src/components/matt/icons/svg/`; Option B chosen (SVG-files-as-source-of-truth via Vite `?raw` glob, NOT path-extracted TS registry) per honest-orphan principle. `MattIcon.astro` consumer ~40 lines via `import.meta.glob<string>('./svg/*.svg', { query: '?raw', import: 'default', eager: true })` + outer-`<svg>` strip regex + dev-only warn + dashed-square missing-icon placeholder. Fill normalization `#414141`→`currentColor` (38 bulk via perl-pi + 1 outlier `info.svg` `#1C1B1F` MD3 on-surface caught by distinct-fill audit). Baseline gates green: astro check 1233 files 0/0/0; build 6.29s; lint clean. [MEM-IP-DRIFT] COMPLETE — MEMORY.md icon-paths entry count corrected 10 → 39 (5 directional + 4 nav + 4 people + 4 content + 16 objects + 3 community + 3 brand) — Conv 180 [MEM-DRIFT-ICN] claim was wrong, caught when re-counting during MMP-PH2. [MFE-STALE] COMPLETE — `.scratch/matt-figma-extraction-today.md` (12.4 KB Conv 178 planning doc for completed work) deleted; `matt-figma/` folder confirmed absent. [MDS-CASCADE-VALIDATED] COMPLETE — `matt-design-system.md` §5 Entity caveat updated with Conv 178 root-cause validation: cascade is NOT broken — Matt's button CSS uses `var(--Background)`/`var(--Border)` (variant-scoped), NOT `var(--Entity-Background)`/`var(--Entity-Primary)` (cascading). `[CASCADE-BROKEN]` closed; "until [CASCADE-BROKEN] resolves" framing retired. [MDS-BTN-3D] COMPLETE — `matt-design-system.md` §5 Button updated with 3-orthogonal-dimension architecture callout (Color 6 × State TBD × Size 5 ≈ 90-120 cells, NOT flat 6×3 = 18); `ButtonProps` shape updated with `size?` prop placeholder + State→pseudo-class mapping. [MATT-RT-DOC] COMPLETE — `matt-pre-plan.md` §2 Implementation status subsection added (2/13 routes built table + 11/13 pending list with phase-gate annotations). [MCP-DOC] COMPLETE — new canonical `docs/reference/figma-mcp.md` created consolidating `.scratch/figma-mcp-setup.md` + `memory/reference_figma_mcp_behavior.md` (Overview, Setup, Architecture, Two tool classes, Per-target output, Output characteristics, Seat tier, Workflow patterns, Implications, Fallback paths, Related). Scratch source deleted; memory file retained as recall-shorthand. **2 strategic decisions:** (1) Matt-namespaced icon registry uses SVG files as source of truth via Vite `?raw` glob (Option B) — aligned with tokenize-only-matt-variables / honest-orphan principle; re-exports drop straight into `svg/`; (2) [CASCADE-BROKEN] closed — Matt's button CSS uses variant-scoped variables (`--Background`/`--Border`), not entity-cascade — entity cascade was never wired into Matt's button design; shapes MMP-PH3 primitive variable-cluster pattern. **5 learnings:** (1) Hex fill audit BEFORE bulk-rewrite catches Material-Icons paint defaults — Direct Material Icons exports may carry `#1C1B1F` (MD3 on-surface); audit pattern: `for f in *.svg; do for fill in $(grep -oE 'fill="[^"]*"' "$f" | sort -u); do case "$fill" in 'fill="currentColor"'|'fill="#D9D9D9"'|'fill="none"') ;; *) echo "$f: $fill" ;; esac; done; done`; (2) Vite `import.meta.glob('./svg/*.svg', { query: '?raw', import: 'default', eager: true })` returns `Record<string, string>` (path → raw text) at build time — inline SVG icon registries with zero client JS; (3) Astro `interface Props` triggers ts(6196) "declared but never used" when Props isn't referenced through type composition — fix: add `Astro.props as Props` cast, OR keep an exported type that references Props; (4) Doc graduation flow: scratch (staging) → memory (recall-shorthand) → docs/reference (canonical) — memory stays after graduation as recall-shorthand; scratch source goes; cross-link memory at bottom of docs/reference under "Related"; trigger after 2-3 convs of empirical stabilization; (5) Figma MCP `get_variable_defs` is selection-bound — no MCP tool enumerates a file's full local Variable collection; workaround = visual-absence heuristic (if no layer uses red/pink, `--carmine-red` is effectively absent regardless of Variable existence). **4 patterns established:** distinct-fill audit before bulk-rewrite; Vite `?raw` glob for inline-SVG icon registries; Astro `Props` interface usage analysis fix; doc graduation flow (scratch → memory → docs/reference). **Code changes:** 1 new component (`src/components/matt/icons/MattIcon.astro` ~40 lines) + 39 new SVG files (`src/components/matt/icons/svg/*.svg`, fills normalized to `currentColor`). **Docs changes:** 1 new canonical doc (`docs/reference/figma-mcp.md`) + 2 updated (`matt-design-system.md`, `matt-pre-plan.md`). **Memory changes:** 1 MEMORY.md one-liner correction (icon-paths 10→39). **Scratch cleanup:** 2 files deleted (`.scratch/matt-figma-extraction-today.md`, `.scratch/figma-mcp-setup.md`); 1 graduation note added to `.scratch/matt-main/components/icons/_INDEX.md`. Baseline gates clean (astro check 1233 files 0/0/0; build 6.29s; lint clean). Branch `jfg-dev-13-matt` retained as active. Next major step (lead): MMP-PH3 Component primitives via MCP-driven extraction.*

*Previously: 2026-05-23 Conv 181 — MATT-DESIGN-PUSH MMP-PH0 Discovery + MMP-PH1 Token foundation both COMPLETE; new tokenize-only-matt-variables standing principle established. **Conv 181 deliverables (4 PLAN subtasks completed + 1 new standing principle + 3 file new/rewrites in code + 3 memory files updated):** [MMP-PH0] COMPLETE — routes audited (2/12 scaffolded); 14 components + 1 layout inventoried; 3-tier token cascade in place from Conv 172; PH4 re-render target = Course In Feed (519:9096). [MMP-PH1] / [TSV] COMPLETE — 12 Color + 18 Typography Variables canonized via `get_variable_defs` direct probes; new `src/styles/tokens-typography.css` (124 lines, two leading regimes Body-small lh:1 / Body-large lh:1.5 ls:-2.2px / Headers lh:1 ls:0); bridge typography section rewritten with all 18 Tailwind 4 `--text-{name}--<modifier>` utility classes; false naming-drift alarm corrected (`Primary/Default` is Variable; "Primary/Primary" was plugin label artifact); Variable Mode validated (Course context → Primary resolves to #327D00). 6 speculative Conv 172 alert tokens isolated to dedicated "Speculative (Conv 172)" sub-blocks across 3 files (kept + flagged, not removed). [NOTE-YELLOW] COMPLETE — resolved by hardcoding inline NOT new token (probe revealed Matt's `#FFF6B8` is hardcoded hex, not a Variable); Note.tsx all 7 drifts fixed (yellow hex, border, radius 12→8, padding 16→10, gap 8→10, shadow, removed leading-relaxed since text-body-default now carries lh:1). [MCP-DRIFT-180] COMPLETE — `memory/reference_figma_mcp_behavior.md` rewritten 56→75 lines: two tool classes (selection-free vs selection-required), return-shape doc, invisible-local-Variables caveat, batch-probing pattern, plugin-rendered-labels-NOT-authoritative warning. **NEW STANDING PRINCIPLE:** `memory/feedback_tokenize_only_matt_variables.md` (50 lines) — token-ify what Matt has tokenized; hardcode what Matt has hardcoded; scaffold what Matt hasn't categorized. Honest-orphan rule: hardcoded values self-deprecate visibly; named tokens accumulate stale meaning silently. Conv 172 speculative pattern retroactively recognized as anti-pattern (preserved per Decision 1 above but not extended). MEMORY.md one-liner added under Solution Quality section. **6 learnings:** (1) Figma MCP has two tool classes — selection-free `get_metadata`/`get_libraries`/`search_design_system`/`get_screenshot` vs selection-required `get_design_context`/`get_variable_defs` (passed nodeId must match selected node exactly — passing parent or sibling fails); (2) plugin-rendered visualizations NOT authoritative for Variable names — Matt's Color Guide plugin renders "Primary/Primary" for actual `Primary/Default` Variable; source-of-truth ordering = get_variable_defs → get_design_context → get_metadata; (3) local-file Variables invisible to library-scoped MCP tools — `get_libraries` returns only subscribed external libs; existence only verifiable by finding a consuming node; defined-but-unused Variables completely invisible; (4) honest-orphan principle for token systems — hardcoded `#FFF6B8` in Note.tsx is honest if Matt changes it; `--note-yellow` token implies systematization Matt has not made and lies until updated; (5) Variable Mode observable at Variable layer via MCP — probing get_variable_defs on a node inside Course-context container returns Course-mode resolved values; same Variable consumed in different context resolves differently; (6) Tailwind 4 `--text-{name}--<modifier>` syntax consolidates typography — single utility class carries size + weight + line-height + letter-spacing via modifier-suffix in `@theme`. **3 strategic decisions:** (1) Speculative alert tokens kept + isolated to "Speculative (Conv 172)" sub-blocks (provenance comment, callsites unchanged) — Option B; (2) [NOTE-YELLOW] hardcoded inline NOT new token — probe revealed honest-orphan applies; (3) tokenize-only-matt-variables established as standing principle in memory (not just Note-specific decision). **5 patterns established:** two tool classes; efficient batch-probing via container selection; plugin-rendered visualizations NOT authoritative; local-file Variables invisible to library tools; Tailwind 4 modifier-suffix consolidation. **Code changes:** 4 files modified (`Note.tsx` 35 lines / `tokens-primitives.css` 24 / `tokens-semantic.css` 11 / `tokens-tailwind-bridge.css` 137) + 1 new file (`tokens-typography.css` 124 lines). **Memory changes:** 1 new file (`feedback_tokenize_only_matt_variables.md` 50 lines), 1 rewrite (`reference_figma_mcp_behavior.md` 56→75 lines), 2 MEMORY.md one-liner updates. Baseline gates clean (tsc + astro check 1232 files 0/0/0). Branch `jfg-dev-13-matt` retained as active. Next major step (lead): MMP-PH2 Icon registry (port 39 SVGs from `.scratch/matt-main/components/icons/` + Material icon strategy [CMP-EXT-ICN] = A).*

*Previously: 2026-05-23 Conv 180 — MATT-DESIGN-PUSH Figma MCP fully activated; Phase 4.5 reframed as 6-phase MMP mini-plan; 2 component-strategy decisions resolved. **Conv 180 deliverables (3 PLAN subtasks completed + 1 decision-task closed + 8 new deferred + MMP mini-plan spawned):** [MCP-VERIFY] COMPLETE — user did OAuth before /r-start (saving session bounce); `claude mcp list` confirms `figma: ✓ Connected`; 10+ `mcp__figma__*` tools surfaced via ToolSearch; `whoami` confirms user has Dev seat on Peerloop org pro tier (no Brian action needed). [MEM-DRIFT-ICN] COMPLETE — MEMORY.md "Icon System" line corrected: `~35 entries` → `10 entries verified Conv 180; Matt-namespaced ~45-entry parallel registry pending from MMP-PH2`. [MFP] COMPLETE — `.scratch/matt-figma-pages.md` stores 9 page URLs + node-ids + Conv 180 probe history (Components 1:269, Color Guide 1:16, α1 Happy Path 477:8493, Happy Path Home 477:8502); Content page marked 🚫 OUT OF SCOPE per user (Matt's initial value-prop exploration, not implementation). [CMP-VAR-PROMOTE-DECISION] CLOSED = A (flat icons, 9 variant entries). **2 strategic decisions captured:** [CMP-ICN-REGISTRY] = D (deferred to MMP-PH4 empirical re-render test — inferential debate without empirical signal; if MMP-PH2 must make interim choice, default to B Matt-namespaced as least irreversible); [CMP-EXT-ICN] = A (incremental Material icon harvest from MCP as Phase 5 encounters each — `stars_2`/`accessibility_new`/`how_to_reg` confirmed in Happy Path probe). **6-phase MMP mini-plan spawned** to bridge from MCP unlock to reproducible single-page MCP-driven re-render workflow before resuming bulk work: MMP-PH0 Discovery → MMP-PH1 Token foundation (unblocked by [MFP]) → MMP-PH2 Icon registry → MMP-PH3 Component primitives → MMP-PH4 Re-render test → MMP-PH5 Graduation. **6 learnings:** (1) Figma Remote MCP is link-based by design — don't enumerate; `get_metadata(fileKey)` returns only currently-scoped pages (got 2 of 9 in this conv); ANY node-id can be queried directly via user-supplied URLs (invisible-but-accessible pattern); ask user for URLs upfront via `.scratch/<project>-figma-pages.md`; (2) `get_design_context` output shape varies by node type — section nodes return sparse + drill instruction (no code), component variant nodes return typed React with inferred props (best for primitive building), page/card nodes return inlined HTML+CSS with `data-name` attributes (visual layouts); (3) Translation is mandatory — icons as `<img>` with expiring asset URLs (7d signed S3 links), components inlined as raw markup, MCP itself warns to convert to project's stack — registry-key naming DECOUPLED from MCP output; `data-name` IS the translation key; (4) Variable Mode bakes into CSS-var fallback hex — same `var(--background, …)` reference has different fallback per parent context (Course=#e8f4df green; Auto Primary=#0777b6 blue); codebase needs Variable Mode switching (likely `[data-variable-mode="course"]` selector pattern); (5) Verify external tool behavior empirically before recommending — 4+ recommendations this conv all reversed by next probe; one tool call beats one rework cycle; captured as [EMP] context in `feedback_external_source_of_truth_first.md`; (6) Matt's "Ready for Dev" labels are human-visible green banners NOT Figma's built-in flag — not API-detectable; ask designer or visually scan. **3 new memory files:** `reference_figma_mcp_behavior.md` (architecture + per-tool output + asset URLs + Variable Mode + data-name + Dev seat scope, ~85 lines); `project_matt_collaboration_style.md` (Matt thinks in Figma at all times — docs, notes, exploration); `feedback_external_source_of_truth_first.md` extended with 4th [EMP] context. **New deferred items:** [CMP-EXT-ICN] (Material icons incremental harvest); [MDR] (Dev-Ready frames lookup, user will supply later at `.scratch/matt-figma-dev-ready.md`); MMP-PH0..PH5 (6-phase mini-plan with dependency chain). **No code changes Conv 180** (entire conv was MCP-onboarding + planning); baseline gates not re-run. Branch `jfg-dev-13-matt` retained as active. Next major step (lead): MMP-PH0 Discovery sweep + MMP-PH1 Token foundation against Color Guide (1:16); resolves [TSV] task in same probe.*

*Previously: 2026-05-23 Conv 179 — MATT-DESIGN-PUSH [MCP-SETUP-WALK] lead-task advanced; Figma remote MCP server registered. **Conv 179 deliverables (2 PLAN subtasks completed + 1 superseded + 1 in-progress + 4 new deferred):** [MCP-INSTALL] COMPLETE — selected Figma's **remote** MCP server (`https://mcp.figma.com/mcp`) per vendor's documented recommendation (mid-conv pivot from original local-MCP plan after user surfaced live docs at `developers.figma.com/docs/figma-mcp-server/`). [MCP-CONFIG] COMPLETE — executed `claude mcp add --transport http figma https://mcp.figma.com/mcp`; registered in `~/.claude.json` project-scoped to peerloop-docs; `claude mcp list` confirms "Needs authentication" status. [MCP-TOKEN] superseded for primary path — remote MCP uses OAuth, no PAT required (retained as conditional fallback). [MCP-SETUP-WALK] in_progress — v2 walkthrough doc rewritten at `.scratch/figma-mcp-setup.md` (no Figma desktop or Dev seat required); OAuth flow deferred to Conv 180 since CC loads MCP server list once at session start (`/r-end` → exit → `/r-start` bridge required). [MCP-VERIFY] pending Conv 180. **TodoWrite triage 54 → 28 (47% reduction):** non-Matt/non-MCP tasks moved to PLAN.md respective blocks where they belonged; 4 "save memory" tasks (MFM Matt-catalogue extraction + STOR source-of-truth + DTU defer-to-user-supplied + VDF vendor-docs-first) consolidated into 1 file `feedback_external_source_of_truth_first.md` with 3 named contexts and distinctive code-markers preserved in MEMORY.md index for grep recall. **3 strategic decisions:** (1) Figma MCP path = Remote over Local — Figma's own docs recommend it; one-command setup vs multi-step; OAuth account-identity sidesteps Conv 169's Dev-seat blocker; works on any machine via re-running `claude mcp add` + re-auth; (2) MCP config scope = project-scoped via `.claude.json` project key — `claude mcp add` defaults to writing to user-level `~/.claude.json` but tags entries with `[project: <cwd>]` (matches original B1 intent without manual settings.json edit); each machine needs its own setup since `.claude.json` is per-machine; (3) Memory consolidation = 4 captures → 1 file with named contexts — MEMORY.md index is the bottleneck (200-line cap), not per-file count; distinctive markers preserved grep-anchored discoverability. **5 learnings:** (1) Vendor-docs-first for MCP/SDK/CLI install walkthroughs — training knowledge for vendor MCP/SDK/CLI integration is months stale (cutoff January 2026; today 2026-05-23); `WebFetch` vendor's current docs before drafting; (2) CC's MCP server list loads once at session start — `claude mcp add` writes to `~/.claude.json` but doesn't hot-reload into running session; opening another terminal doesn't help (per-process); plan MCP setup around `/r-end` → exit → `/r-start` bridge; (3) `.claude.json` MCP entries are project-scoped automatically — `claude mcp add` tags entries with `[project: <cwd>]` so MCP activates only when CC is launched from that directory; user-level file location, project-level activation; (4) TodoWrite ↔ PLAN.md hygiene threshold — when TodoWrite accumulates past ~30 tasks and many belong to inactive Blocks, move to PLAN.md; TodoWrite is conv's working set, PLAN.md is cross-conv canonical home; (5) Memory consolidation when multiple captures point at one pattern — consolidate into one file with N named contexts; expose all original code markers in MEMORY.md index for grep recall (1 rule, 1 file, multiple grep-anchored entry points). **4 new deferred Conv 179 items spawned:** [ASF] (Astro.slots.has + && short-circuit investigation surfaced Conv 175 [MSH-VIZ]); [TDS-DRIFT] (tech-doc-sweep didn't fire on matt/* additions across Convs 173-178 — baseline SHA or matchers stale); [MEM-CAP] (watch /r-prune-claude trigger at ≥80% utilization; Conv 179 baseline 59%/57%); [INV-PATH-FIX] (sweep `.scratch/matt-figma/` references → `.scratch/matt-main/`). **No code changes Conv 179** (entire conv was infra + docs + planning); baseline gates not re-run. Branch `jfg-dev-13-matt` retained as active. RESUME-STATE.md cleared at /r-start (53 pending items transferred to TodoWrite; +1 [VDF] added = 54; triaged down to 28). Next major step (lead): Conv 180 — `/mcp` → figma → Authenticate → browser Allow Access → ToolSearch verify Figma MCP tools surfaced; then resume `[CMP-ICN-REGISTRY]` decision + Phase 4.5 remaining 7 subtasks via MCP.*

*Previously: 2026-05-23 Conv 178 — MATT-DESIGN-PUSH Phase 4.5 [MATT-EXEC-CMP] scoped + [MATT-EXEC-CMP-ICN] harvest phase complete. **Conv 178 deliverables (1 PLAN block scoped + 1 harvest-phase subtask complete + 7 new deferred):** Phase 4.5 inserted between Phase 4 and Phase 5 with 8 dependency-ordered subtasks (CMP-ICN → CMP-BTN → CMP-MNV → CMP-SNV → CMP-ENT → CMP-CHT → CMP-PNC → CMP-BRN); `matt-pre-plan.md` §9 row added; total convs estimate revised 8–11 → 10–15. **[MATT-EXEC-CMP-ICN] harvest phase COMPLETE:** 39 icons extracted from Figma into `.scratch/matt-main/components/icons/` with uniform `viewBox="0 0 24 24"` (Figma export `Include bounding box ✅` setting was load-bearing); 19 renames executed with 3 semantic corrections from Matt's catalogue (newspaper→feed, mail→message, calendar_month→calendar, chat_bubble→chat, present_to_all→present, Vector.svg→user-icon); Property-1 Component variants flattened to Arrow/Level/Bookmark groups per Matt's catalogue labels; `_INDEX.md` written documenting catalogue-label-is-authority rule + Primary (8) + Secondary (31) sections. Code-integration deferred — 2 new subtasks [CMP-ICN-REGISTRY] + [CMP-VAR-PROMOTE-DECISION] capture registry-strategy + variant-promotion decisions. Buttons reconnaissance discovered 3-orthogonal-dimension Figma architecture (Color via Variable Mode × State via Property 1 × Size via 5 frame cells, NOT flat 6×3 matrix); Matt's button CSS uses `var(--Background)`/`var(--Border)` — validates [CASCADE-BROKEN] as implementation issue. **Mid-conv pivot:** project moved to client's Pro Figma account; confirmed via ToolSearch no Figma MCP connected this conv; ended conv to set up MCP off-conv and /r-start fresh. **5 strategic decisions:** (1) insert Phase 4.5 between Phase 4 and Phase 5 (preserve Phase 5 as pure thin-shell assembly); (2) dependency-ordered CMP subtasks with Icons foundational; (3) catalogue-label-is-authority for naming (overrides Figma auto-export filenames AND visual-inference guesses); (4) default-durable full 8-subtask harvest over icon-only narrow scope; (5) end Conv 178 + MCP setup between convs + /r-start fresh. **7 learnings:** (1) `.scratch/matt-main/*.svg` are CC-instructed Figma exports treated as reference-only; (2) Figma exports use source Material-Icon names not catalogue labels; (3) Figma "Include bounding box ✅" gives uniform viewBox — load-bearing for icon systems; (4) Matt's button architecture is 3-orthogonal-dimension not flat matrix; (5) Matt's button CSS uses `var(--Background)`/`var(--Border)` — cascade IS the intended pattern; (6) MCP servers load at session start — mid-conv configuration has no effect; (7) "harvest while access is available" time-bounded resource pattern. **4 patterns established:** Figma `Include bounding box ✅` default-ON for icon batches; 3-orthogonal-dimension factoring for Figma Component extraction; Phase X.5 numbering for inserting between locked phases; MCP load is session-boundary affair. **7 new deferred subtasks spawned:** [MCP-SETUP-WALK] **🔝 LEAD NEXT-CONV ITEM** (composite umbrella for MCP setup); [MCP-INSTALL] / [MCP-TOKEN] / [MCP-CONFIG] / [MCP-VERIFY] (component sub-tasks); [CMP-ICN-REGISTRY] (registry-strategy decision blocking rest of Phase 4.5); [CMP-VAR-PROMOTE-DECISION] (Arrow/Level/Bookmark variant-promotion decision). **[MATT-MCP-RETRY] superseded** by [MCP-SETUP-WALK] — Pro account now exists, new blocker is MCP server install + token + settings.json config. No code changes Conv 178; baseline gates not re-run (docs + scratch only). Next major step: [MCP-SETUP-WALK] walkthrough; then resume Phase 4.5 via MCP (CMP-ICN-REGISTRY decision + remaining 7 subtasks).*

*Previously: 2026-05-23 Conv 177 — MATT-DESIGN-PUSH unblocked: Astro stack upgrade + Vite SSR cold-start root cause + fix. **Conv 177 deliverables (2 PLAN items completed + 0 new deferred):** [NPM-UP] COMPLETE — astro 6.1.5→6.3.7, @astrojs/cloudflare 13.1.8→13.5.4, @astrojs/react 5.0.3→5.0.5, wrangler 4.81.1→4.94.0 (initial install hit ERESOLVE forcing wrangler addition; per Solution Quality default-durable). Canonical Vite dedupe/noExternal workaround attempted but FAILED — same cold-start Sidebar.tsx crash. [DSSR-SCOPE] COMPLETE — real root cause found via web research: Vite cold-start dep-discovery race (industry-wide pattern: Remix #10156, TanStack/router #4264, Storybook #32049, vitejs/vite #17979). First SSR request triggers Vite to find new imports → re-optimize `node_modules/.vite/deps_ssr/` → reload bundled React → in-flight render crashes with null hooks dispatcher → response body cut off mid-attribute. **Working fix:** `astro.config.mjs` `vite.optimizeDeps.entries: ['src/**/*.tsx', 'src/**/*.ts', 'src/**/*.astro']` + `include: ['astro/virtual-modules/transitions.js']` (entries alone insufficient — Astro virtual modules aren't reachable from scanning src/). Verified: cold-start /matt/ succeeds first request (240839 bytes, all primitives rendered, `</html>` closed, 0 ERROR lines); production build clean in 7.27s; preview /matt/ 30564 bytes, all 13 primitives present. **Cleanup sweep:** Conv 176 stateless-primitives discipline RETIRED from DEVELOPMENT-GUIDE.md; new "Vite SSR Cold-Start Dep Discovery" section documents the real bug class + fix recipe + symptom signature. ToDoItem.tsx rewritten as controlled-or-uncontrolled hybrid (proper React idiom). [AAP] re-tested against Astro 6.3.7 — still broken upstream. DEV-STAGING-SSR ON-HOLD row marked ✅ RESOLVED. **Astro warnings cleanup:** HeaderBar.astro Props cast fix (silences ts6196), CourseHeader.astro dead Button import removed; astro check 0/0/0 clean. **Side fixes:** api-test-helper.ts logger no-op stub (Astro 6.3 APIContext addition), Sidebar.tsx flex-shrink-0→shrink-0 (Tailwind v3→v4 rename, caught by /w-codecheck). **/w-codecheck all 8 PASS.** **4 strategic decisions:** (1) pair wrangler upgrade with Astro stack (avoid `--legacy-peer-deps`); (2) retire stateless-primitives discipline; (3) ToDoItem hybrid pattern; (4) don't downgrade React 19→18.2 (Vite cold-start affects React 18 too). **4 learnings:** (1) Vite cold-start dep discovery is documented industry-wide pattern — when SSR hook crashes self-heal on 2nd request, it's this class (different fix than dual React copies); (2) diagnosis can survive long because misleading symptoms cluster — "AppNavbar works but Sidebar crashes" mystery survived 3 convs because cold-start cache state masked request-order dependence; (3) `optimizeDeps.entries` recipe doesn't reach Astro virtual modules (needs `include` for each virtual module the dev log mentions in `✨ new dependencies optimized`); (4) Astro 6.3 added `logger` field to APIContext (TestAPIContext helper needs no-op stub). **3 patterns established:** diagnostic checklist for SSR hook crashes (cold-start race vs dual React vs config); Astro virtual module pre-bundling rule; cheap order-dependence probes falsify "structural" diagnoses. Branch `jfg-dev-13-matt` retained as active. RESUME-STATE.md cleared at /r-start (33 pending items transferred to TodoWrite). Next major step: `[MATT-EXEC-PG2]` Phase 5 routes (12 remaining /matt/* pages).*

*Previously: 2026-05-22 Conv 176 — MATT-DESIGN-PUSH advanced through Phase 4 scope B (the remaining 5 primitives) on `jfg-dev-13-matt`. **Conv 176 deliverables (1 major PLAN item + 4 new deferred + 1 task put ON HOLD):** [MATT-EXEC-PRM-2] Phase 4 scope B complete — 5 primitives + 1 internal demo wrapper: `Module.tsx` / `Note.tsx` / `ToDoItem.tsx` (refactored fully controlled, no `useState`) / `SocialPost.tsx` / `RoleTabBar.tsx` + `_SocialPostDemo.tsx` (internal underscore-prefixed React wrapper hosting Course-minicard embed JSX). `/matt/index.astro` extended with Phase 4 Primitives showcase section. 4 symlinks under `public/_matt-ref/` (Module/Note/SocialPost/ToDoItem.svg) for visual-diff against Matt's Figma exports. **Two Astro-Cloudflare landmines hit + worked around:** (1) `useState` in a primitive crashed plain-dev SSR body (Sidebar.tsx cascade) — not just `dev:staging` as PLAN [DEV-STAGING-SSR] documented; refactored ToDoItem to fully controlled; (2) inline JSX (`<div className=…>` and `<svg viewBox=…>`) in `.astro` expression blocks parser-rejected as documented Astro behavior — extraction-to-`_Demo.tsx` pattern established. **Visual review feedback addressed:** entity-background rendered grey not blue → root-caused as `.entity-*` cascade NOT propagating through Tailwind 4 `bg-entity-background` empirically; refactored Module + ToDoItem to direct `bg-{course,student,creator}-background` utilities matching `Button.tsx` pattern. SocialPost Course-minicard embed added via `_SocialPostDemo.tsx` extraction (inline `<div>` not supported in `.astro` expression blocks). **Web research conducted** on the two landmines: Astro #16529 still open on versions newer than ours (6.2.0 + adapter 13.3.0); `@astrojs/cloudflare 13.5.4` added optimizeDeps-forwarding-to-SSR which is the plausible missing piece that made Conv 122's earlier dedupe attempt fail. Final verification: HTTP 200, body 33,648 chars, all 5 primitives + 1 social-post-embed render, 4× `bg-student-background` / 3× `bg-course-background` / 2× `bg-creator-background` in HTML, tsc clean, astro check clean (0/0/2 pre-existing hints). **3 patterns established:** (1) `qlmanage -t -s 1200 -o /tmp file.svg` SVG→PNG visual inspection for Read-tool consumption; (2) `_Demo.tsx` extraction for rich JSX showcase content (avoids Astro expression-block JSX restrictions); (3) stateless matt/* primitives discipline (no `useState` / `useEffect` in primitives until `[DSSR-SCOPE]` resolves). **4 new deferred subtasks spawned:** `[DSSR-SCOPE]` task #26 — update PLAN's DEV-STAGING-SSR scope claim (also affects plain `npm run dev`, symptom is body cutoff not graceful island fallback); `[NOTE-YELLOW]` task #27 — add `--note-yellow: #FFF1B8` token; `[CASCADE-BROKEN]` task #28 — `.entity-*` cascade investigation; `[NPM-UP]` task #29 — **🔝 LEAD NEXT-CONV ITEM:** upgrade astro 6.1.5→6.3.7, adapter 13.1.8→13.5.4, react adapter 5.0.3→5.0.5 + retry canonical Vite dedupe/noExternal workaround + regression-test by reverting ToDoItem to hybrid form with `useState`. **`[MATT-MCP-RETRY]` put ON HOLD** per user direction (external Figma paid-seat blocker indefinite); proceeding without MCP using static SVG exports + new qlmanage workflow. Branch `jfg-dev-13-matt` retained as active. RESUME-STATE.md cleared at /r-start (25 pending items transferred to TodoWrite). Next major step: `[NPM-UP]` upgrade + workaround retry; then `[MATT-EXEC-PG2]` Phase 5 routes.*

*Previously: 2026-05-22 Conv 175 — MATT-DESIGN-PUSH advanced through Phases 2-visualization, Phase 3 first page, and Phase 4 scope A primitives — all on `jfg-dev-13-matt`. **Conv 175 deliverables (4 PLAN items + 4 commits):** [MSH-VIZ] `/matt/index.astro` shell preview stub (5750 B, gated `noNav`) — diagnosed and durable-fixed Astro Fragment-forwarding bug suppressing HeaderBar slot fallbacks (failed `Astro.slots.has + &&` short-circuit, root cause unconfirmed; moved defaults from HeaderBar to AppLayout via ternary inside *unconditional* Fragments; HeaderBar becomes pure shell primitive with no slot fallbacks; learning saved as `memory/reference_astro_slot_forwarding.md`); commit `350bf88`. [MSH-REFINE] Tailwind `lg:` breakpoint shifted 1024→1025px globally via `--breakpoint-lg: 1025px` in `tokens-tailwind-bridge.css @theme` (single source of truth, propagates to all `lg:*` callsites in matt/* AND legacy fraser/*; matches Matt's spec exactly); HeaderBar.astro cleaned (3 dead `<slot>{fallback}</slot>` removed; docstring updated to point to AppLayout for defaults + cross-reference new memory file); bundled into commit `350bf88`. [MATT-EXEC-PG1] First `/matt/course/[slug]` page end-to-end (commit `dca4614`): built `CourseHeader.astro` entity primitive (dark image hero with gradient overlay + top-right back-chevron+book overlay + 2-column layout LEFT title/tagline/metadata row creator/rating/level + RIGHT ✓-includes list + "$X • Enroll Now ›" pill; min-height 240px via inline style — Tailwind arbitrary `min-h-[NN]px` silently failed, see [TWLG-MIN-H]) and `src/pages/matt/course/[slug]/index.astro` (thin <100-line page using existing `fetchCourseTabData` loader; AppLayout entity=course; SubNav 7 course tabs About / Course Feed / Modules / Meet the Creator / Teachers / Reviews / Resources; About body 4 Cards About / What you'll learn 2-col objectives / Prerequisites / Who this is for); HTTP 200, astro check clean. [MATT-EXEC-PRM] scope A — 3 of 8 primitives + retrofit (commit pending /r-end): `Button.tsx` 6 variants × 3 sizes per matt-design-system.md §6 exactly, `Card.astro` white-fill with padding scale + optional borderless, `SectionTitle.astro` semantic level × visual size; retrofitted CourseHeader CTA → `<Button variant="course">` + course-page body sections → `<Card padding="lg">` + `<SectionTitle>` headings. **Visual-fidelity iteration vs Matt's `Course.svg`** (~6 fixes landed mid-conv via `public/_matt-ref/` symlink-diff pattern, removed pre-commit): Course Feed tab added to SubNav, objectives layout 1-col→2-col, What's Included moved to hero overlay (not body card), Meet the Creator added as SubNav tab (not body card), hero restructured to 2-column with metadata row + includes-list + Enroll Now pill, hero overlay glyphs added (back-chevron + book). User-confirmed acceptance: "looks better, items in front of the page need work, but it's enough for now" → marked complete with `[MATT-COURSE-POLISH]` spawned. **3 patterns established:** (1) Matt-page assembly — thin page composing `AppLayout(entity=course) → CourseHeader → SubNav → body Cards`; (2) AppLayout slot-default pattern — defaults via ternary inside *unconditional* Fragments using `Astro.slots.has()`; primitives carry no slot fallbacks; (3) Visual-diff symlink pattern — `public/_matt-ref/` Figma-SVG symlinks must happen BEFORE building, not after (Conv 175 learning: pre-plan §9 visual-validation gate has to fire before structural build). **5 new deferred subtasks spawned:** `[MATT-EXEC-PRM-2]` remaining 5 Phase 4 primitives; `[MATT-COURSE-POLISH]` body section visual polish; `[MATT-ICON-SWAP]` hero inline-SVG icons → icon-system in Phase 6; `[MATT-CREATOR-TAB]` /matt/course/[slug]/creator route — Phase 5; `[TWLG-MIN-H]` Tailwind 4 `min-h-[NN]px` silent failure suspected to interact with Conv 174 `--spacing-*` global override — root cause + fix is `[TSV]` follow-up. **Conv 175 was a warm restart** (counter already incremented in commit `6ddb203 Conv 175 start`; previous Conv 175 ended without /r-end; resumed in-flight [MSH-VIZ] work). Branch `jfg-dev-13-matt` already has remote tracking from Conv 174 push. RESUME-STATE.md cleared at /r-start (22 pending items transferred to TodoWrite). Next major step: `[MATT-EXEC-PRM-2]` remaining 5 Phase 4 primitives, or `[MATT-EXEC-PG2]` Phase 5 routes.*

*Previously: 2026-05-22 Conv 174 — MATT-DESIGN-PUSH Phase 1 [MATT-EXEC-TKN] + Phase 2 [MATT-EXEC-SHL] both COMPLETE on new branch `jfg-dev-13-matt` (created from `jfg-dev-12`). **Phase 1:** 3 token files authored (`src/styles/tokens-primitives.css` ~155 lines / `tokens-semantic.css` ~165 lines / `tokens-tailwind-bridge.css` ~80 lines) + `global.css` `@import` wired in. 15 color primitives kebab-case per Decision 2=B, full scaffolded scales (spacing rem-valued pixel-named per Decision 1=C, radius px, shadows, opacity, z-index, duration). 14 color semantics Title-Case-dash with cascade preserved via `var()` chains (`--Student-Primary: var(--Primary-Default)` NOT flattened to primitive). Entity multi-mode at `:root` + 3 mode classes (`.entity-creator/student/course`). Button base + 6 variant classes preserving seamless-edge pattern. **Tailwind 4 bridge override decision Conv 174 §1 = B:** include `--spacing-N` globally (572 `p-4` callsites audited; pixel-named utilities now resolve to Matt's pixel values on `jfg-dev-13-matt` branch only; `jfg-dev-12` and earlier branches unaffected). All 5 baseline gates green: tsc 0 / astro 1215/0/0/0 / build 6.13s. Phase 1 commit `579266c` (4 files, +398 lines). **Phase 2:** 5 layout-shell components authored under `src/{layouts,components}/matt/`: `HeaderBar.astro` (slot-based per Decision 7=C — header-left/center/right slots), `SubNav.astro` (vertical-left strip at lg: 196px, horizontal-scroll fallback at <lg), `Sidebar.tsx` (React island 220/70px collapsible, 5-item primary nav middle + brand top + earnings/notifications/profile bottom), `ControlBar.tsx` (React island, bottom-fixed pill, 6 nav icons with `tabletOnly` flag hiding Messages+Notifications at mobile so 4 icons at <sm + 6 icons at sm:), `AppLayout.astro` (composes all 4; Sidebar `hidden lg:flex`, HeaderBar/ControlBar `lg:hidden`; named slots header-bar/entity-header/role-tab-bar/sub-nav/default + entity prop applies `.entity-{creator|student|course}` mode class). Gates green: tsc 0 / astro 1220/0/0/0 / build 6.13s. Built CSS verified: bridge color/typography utilities (`--color-text-default`, `--color-text-primary`, `--color-border-default`, `--color-primary-light`, `--color-entity-primary`, `--color-entity-background`, `--text-body-default`) all now emit (1 occurrence each) — components triggered Tailwind 4's on-demand `@theme` emission. **3 patterns established:** (1) Tailwind 4 `@theme` tokens emit on-demand only when at least one utility class consumes them — don't panic if a freshly-authored bridge token isn't in `dist/` until a component exercises it; (2) `--spacing-N` in `@theme` overrides Tailwind utility scale globally not additively — audit usage first (`grep -rho 'p-[0-9]+'`) and decide override/namespace/omit; (3) Matt's 2-layer + 3-layer cascade preserves correctly when authored as `var()` chains — never flatten semantic-to-semantic refs (the cascade IS the value). **2 new spawned subtasks:** `[MND2]` `detect-machine.sh` still returns `Unknown (M4Pro.local)` despite Conv 168 fix (case patterns or `.local` suffix issue); `[MSH-REFINE]` 3 Phase 2 layout positioning details deferred to Phase 3 visual gate. **No visual validation in Phase 2 yet** — user's next-conv intent: review responsive layout/navbar state in browser (may require Phase 3 stub or jump into [MATT-EXEC-PG1]). Branch `jfg-dev-13-matt` not yet pushed at conv-end (first /r-end push will create remote tracking branch). RESUME-STATE.md cleared at /r-start (21 pending items transferred to TodoWrite). Next major step: `[MATT-EXEC-PG1]` Phase 3 first `/matt/*` page end-to-end.*

*Previously: 2026-05-22 Conv 173 — MATT-DESIGN-PUSH pre-plan + 8 decisions resolved (block: MATT-DESIGN-PUSH, ACTIVE). Major artifact: `docs/as-designed/matt-pre-plan.md` (~510 lines, 12 sections) — durable companion to `matt-design-system.md` covering route map (31 Matt screens → 13 `/matt/*` routes), file structure (concrete paths under `src/styles/`, `src/layouts/matt/`, `src/components/matt/{,entity,ui}/`, `src/pages/matt/`), 8 blocking decisions all resolved, Tailwind 4 bridge sketch, page assembly pattern, 11-category extrapolation enumeration, doc graduation criteria, 7-phase execution sequence (~8–11 convs estimate), risk inventory, designer-side questions. **[MATT-PRE-PLAN] task #10 COMPLETE.** **8 §4 decisions resolved via one-at-a-time walkthrough** (recommendations stood 8-of-8): (1=C) Hybrid CSS units rem/px — typography + spacing emit rem with px-named tokens; borders + hairlines + radius stay px; (2=B) kebab-case for primitives, semantics keep Title/Slash; (3=C) Hybrid Tailwind bridge file — Matt's tokens canonical, `tokens-tailwind-bridge.css` re-exports as `--color-*` for utility classes; (4=B) Coexist with existing `--color-primary-*` sky-blue scale (consolidation deferred to flip block); (5=A) `/matt/` = `/dashboard` analog member-only, visitors → `/matt/login`; (6=B) Rebuild Sidebar as new `src/components/matt/Sidebar.tsx` (reuse hooks/utilities); (7=C) Slot-based HeaderBar with named slots; (8=A) Omit footer entirely (legal/terms → Sidebar bottom or Settings). **Conv 171 Control Bar misattribution corrected:** original deliverable (d) said "Control Bar = ExploreTabBar re-skin" — actually Matt's Control Bar = primary-nav bottom-pill at tablet/mobile (NOT a role switcher); the Role Tab Bar is the Peerloop extension (ExploreTabBar re-skin), bundled into Phase 4 `[MATT-EXEC-PRM]`. **8 new execution-phase tasks spawned** in new "MATT-DESIGN-PUSH Execution Phases" section: `[MATT-EXEC-TKN]` (Phase 1 token files) → `[MATT-EXEC-SHL]` (Phase 2 layout shell) → `[MATT-EXEC-PG1]` (Phase 3 first `/matt/*` page) → `[MATT-EXEC-PRM]` (Phase 4 remaining primitives incl. [RTB]) → `[MATT-EXEC-PG2]` (Phase 5 remaining 12 routes) → `[MATT-EXEC-EXT]` (Phase 6 extrapolation primitives) → `[MATT-EXEC-GRD]` (Phase 7 doc graduation), plus cross-phase `[MATT-EXEC-FLAGS]` (verify 4 route-shape assumptions). [MDS-OQ] substantially absorbed by pre-plan §4 decisions (Q7, Q8, footer, visitor flow, inner grid all resolved; 4 minor items remain for execution phases). 3 patterns established: decision walkthrough (one-at-a-time A/B/C presentation for >3 novel decisions), pre-plan BLOCKING→RESOLVED state transition (heading + summary table), authority split framing (designer = visual / user = architect, compresses scope by an order of magnitude). No code changes; no baseline gates run this conv (planning-only). Next major step: `[MATT-EXEC-TKN]` Phase 1.*

*Previously: 2026-05-22 Conv 172 — Matt design-system extraction + token scaffolding (block: MATT-DESIGN-PUSH, newly promoted to ACTIVE this conv). Major artifact: `docs/as-designed/matt-design-system.md` refined 650 → 1169 lines. **[MDM] task #13 COMPLETE** — all 5 original Figma Dev Mode extraction batches resolved + 5 bonus batches scaffolded (Border Radius, Shadows, Opacity, Z-index, Animation Durations). Full Figma Variable extraction (35 base vars across 5 collections, 47 mode-resolved cells): Color Primitives (15), Color Semantics (14), Entity (2×4=8 multi-mode cells), Icon Size (1×2=2 multi-mode cells), Button (3×6=18 multi-mode cells with resolved-hex review row). §6 renamed "Token Extraction & Scaffolding"; Token Scaffolding Policy established (snap + pixel-named + complete-from-day-1). §4 restructured + Q7 (naming) + Q8 (units) + Q9 (Main Panel layouts) added — 9 open questions total. §2 architectural findings extended: Header Bar slot multi-content per breakpoint; Sub Nav breakpoint-varying rendering (slide-in drawer at Mobile); Control Bar correctly attributed as Matt's primary-nav primitive (NOT a role switcher — §2.6 rewritten + 7 dangling references cleaned across §1/§3/§6); new §2.7 Role Tab Bar (Peerloop extension; NOT in Matt's design — his brief was deliberately single-role); Matt-composes-pages-from-components meta-principle added. New `docs/as-designed/figma-screenshots/` folder committed (~480KB, 8 PNGs) with source artifacts catalogued in new §Source Materials section. **5 strategic decisions** captured: (1) Token Scaffolding Policy — complete-from-day-1 + pixel-named + snap; (2) Control Bar = Matt's primary-nav primitive (not role switcher); (3) Component composition principle — every Matt component → parameterized React/Astro component; (4) Preserve cascade chains in CSS — `--Student-Primary: var(--Primary-Default)` NOT `var(--americana-blue)`; (5) Commit Figma source screenshots to docs repo. Block Sequence updated: **MATT-DESIGN-PUSH promoted to ACTIVE** at top of table — the Convs 169-172 active work focus has shifted decisively from DEPLOYMENT to Matt design. 4 new deferred subtasks spawned: [RTB] Role Tab Bar design, [TSV] Token Scaffolding Verification, [MATT-MAX-WIDTH] external answer pending, [MATT-REACT-ICON-DEFAULT] icon-default change for `/matt/*`. [MATT-MCP-RETRY] partial — Brian's paid Figma seat not yet provisioned; user adopted Figma Dev Mode CSS Inspector + paste-screenshot workflow as viable interim. No code changes; no baseline gates run this conv (docs-only).*

*Previously: 2026-05-21 Conv 171 — Matt design-system foundation (block: misc — design-system intake feeding MATT-PRE-PLAN, not the implementation itself). Major artifact: authored `docs/as-designed/matt-design-system.md` (650+ lines) — graduated mid-conv from `.scratch/matt-devmode-form.md` once content stabilized into substantially-permanent spec (Strategic Context + Architectural Findings + Existing App Context + Open Questions + Color Primitives + Token Extraction Batches 1–5). Six sections; `docs/INDEX.md` entry added under "How Should It Look/Work?". Advanced [MDM] task #13: Batch 1 (Typography) COMPLETE — all 9 header + 9 body roles measured via Figma Dev Mode CSS Inspector (Inter, sizes 12/14/16/20/24/32, regular=400/medium=500/headers=500/600/body=400/500/600, line-height normal for headers + 150% for body Medium/Large + letter-spacing -0.352px on body Medium/Large); Batch 2 Desktop PARTIAL (sidebar 220/70 px, page padding 16, gutter 16, Header Bar ~40–48px breadcrumb); Batch 4 RESOLVED (2-column Sidebar + Main Panel); Batch 5 RESOLVED (Control Bar = role-perspective tabs, only when user has >1 role). Color primitives extracted (12 hex codes). Updated [MATT-PRE-PLAN] task description with strategic context (Matt = designer / user = architect authority split, /matt/* = visual re-skin of existing role-aware infrastructure NOT new architecture, happy-path = calibration set / rest of app = extrapolation test) + new primary input + 8 deliverables (a–h). 4 architectural findings persisted (no global header bar — branding in sidebar only; entity-color-coded headers as load-bearing identity contract; Control Bar Matt designed already exists in code as `ExploreTabBar`; Header Bar = re-skin of existing `Breadcrumbs.astro` with `?via=` pattern). 3 decisions recorded (DECISIONS.md to be updated): /matt/* scope strictly visual re-skin; CSS variable names match Matt's Figma Variable naming verbatim (Title-Case-Hyphenated, e.g., `--Text-Default`); Visitor = unauthenticated UI state (no schema change). 4 new deferred subtasks spawned: [MDS-OQ] resolve 6 open questions, [MDM-TAIL] complete remaining Batches, [MATT-TYPO-EXERTISE] flag typo to Matt, [MATT-DOC-READ] read 3 additional docs before [MATT-PRE-PLAN] starts. Two patterns established: form-graduation (.scratch → docs/as-designed when content stabilizes at 60%+ permanent) and Figma-Variable-naming-verbatim. Conv shape note: almost entirely strategic/design-system foundation — no source-code edits. All output in: matt-design-system.md (new), docs/INDEX.md (entry added), [MDM] + [MATT-PRE-PLAN] task descriptions, package-lock.json (incidental `npm install` no-op at /r-start). No baseline gates run this conv (no code changes).*

*Previously: 2026-05-21 Conv 170 — Matt design push pre-work (block: misc — preparation for MATT-PRE-PLAN, not the work itself). Closed 1 RESUME-STATE item: [MATT-ISOLATE] curated `.scratch/matt-figma/` (229 files, 137 MB) → `.scratch/matt-main/` (83 files, 85 MB, 38% file count / 62% size) — tokens (9 files) + layout (17) + components (14) + happy-path (42 incl. 31 canonical Content/Happy/ screens + 10 Purpose milestones + α1 overview). Fixed `typograhy-overview.png` typo + misplaced location at the copy step (renamed to `typography-overview.png` and moved into `tokens/typography/`). Authored `_README.md` with inclusion structure tree + 16-row per-category exclusion table answering "why isn't X here?" for each excluded category (Prototype copies, Section Title-N variants, Why-we-need-it justification frames, decorative quotes, social-post mockups, unnamed Frame N items, Matt's Graveyard, documentation notes). User chose Dropbox for cross-machine transfer (`.scratch/` is gitignored — git-as-transport doesn't apply). [MATT-INVENTORY-CLEANUP] effectively superseded by `matt-main` curation: the misplaced/typo'd typography overview was relocated at the copy step (source `matt-figma` left as read-only inventory); the 31-screen `Content/Happy/` implementable set is now isolated. Two learnings folded: (1) Inventories typed from screenshots can drift from disk reality — when acting on an inventory, walk actual folders before trusting filename-level claims (Conv 169's `_INVENTORY.md` mis-listed `components-overview.png` and under-counted top-level happy-path items). (2) Curation work needs a per-category exclusion table, not just an inclusion list — absence of common patterns reads as oversight rather than deliberate exclusion. New curation README pattern established. No code changes; no baseline gates re-run this conv.*

*Previously: 2026-05-21 Conv 169 — Cross-block follow-up + Matt design intake (block: DEPLOYMENT/DB-SYNC sub-block added + Conv 168 follow-ups + pre-plan only for Matt). Closed 2 RESUME-STATE items: [RAM-NONAV-SWEEP] (applied `export const noNav = true;` to 19 legitimate no-nav routes — 14 footer/marketing pages + /404 + /admin/recordings + 3 discover 301-redirects; scanner now reports `ℹ️ no-nav by design` for all 20 annotated routes; zero `⚠️ no discovered nav` warnings remain; tsc + astro check clean across 1215 files); [PROD-PW-APPLY] redirected into new DEPLOYMENT.DB-SYNC sub-block after audit revealed prod D1 3-migration drift (0002 tracker stale name, 0003 + 0004 NOT applied, `feed_visits` + `feed_activities` tables missing on prod). New DEPLOYMENT.DB-SYNC sub-block bundles 5 atomic tasks ([DB-SYNC-04] apply migration 0004 + insert tracker row; [DB-SYNC-03] tracker row only for already-converged 0003; [DB-SYNC-02-RENAME] tracker rename `0002_seed.sql` → `0002_seed_core.sql`; [PROD-PW-APPLY] full 3-step procedure absorbed; [DB-SYNC-VERIFY] convergence check). Matt design push intake: 4 directives confirmed (branch `jfg-dev-13-matt` from `jfg-dev-12`, `/matt/` top-level route for coexistence, Figma examination, style guide extraction); decisions captured (tokens as future global default consumed only by `/matt/` initially per eventual `/matt/` → `/` flip; SVG over PNG for export hedging). Figma MCP setup attempt failed (user's account lacks Dev seat — Matt's shared Dev-Mode access != MCP-capable seat; Brian setting up paid account tonight). 229 SVG/PNG files (~137 MB) exported from Figma into `.scratch/matt-figma/` across `tokens/`, `layout/`, `components/`, `happy path/`; inventory + page-panel notes persisted. 3 new deferred subtasks spawned: [MATT-MCP-RETRY], [MATT-INVENTORY-CLEANUP], [MATT-PRE-PLAN]. Four learnings: Figma MCP requires viewer's own Dev seat (not just file-level Dev Mode access); prod D1 migration drift can be invisible — tracker retains old filename after seed-split rename; Figma batch-export auto-names files after frame names, replacing manual layer-panel inventory; `Content/` sub-folder in Figma exports masks the actual screen library at one level deeper. Verified `cd ../Peerloop && npx tsc --noEmit` clean + `npm run check` clean (0/0/0 across 1215 files) after [RAM-NONAV-SWEEP]; other gates not run this conv.*

*Previously: 2026-05-21 Conv 168 — Cross-block follow-up batch, no single PLAN.md block advanced (block: misc). Closed 5 RESUME-STATE/PLAN items: [CCK-DA] v2 alias-aware schema-aware deleted_at lint (eliminates 90 v1 false positives across 18 tables; calibrated against actual Conv 117 motivating case via `git show 7df6c02` — pre-fix SQL was unqualified `deleted_at`, not qualified as session-doc summary claimed; production script at `.claude/scripts/codecheck-deleted-at.mjs` ~95 lines + harness `.scratch/cck-da-v2-test.mjs`); [MND] `detect-machine.sh` hostname match for M4Pro fixed + canonical name migration `MacMiniM4-Pro` → `MacMiniM4Pro` across 11 files (`MachineName` TS type narrowed, `vitest.global-setup.ts`, `tests/README.md` × 5, `dev-env-scan.sh` grep widened for forward+historical compat, 8 docs); [RAM-NO-NAV] `parseNoNav(content)` helper added to `scripts/route-api-map.mjs`; emit branched `ℹ️ no-nav by design` vs `⚠️ no discovered path`; applied to `/course/[slug]/[tab].astro` as first instance — declarative per-route opt-out pattern established; [PROD-PW] decisions captured in DECISIONS.md §4 (password = Peerloop2; apply deferred to bundle seed edit + UPDATE in one synchronous step; un-defer procedure documented in 3 steps); [XMV] cross-machine path-derivation verification harness built at `.claude/scripts/cross-machine-verify.sh` — 9 canonical cases under `HOME=/Users/livingroom` (M4) and `HOME=/Users/jamesfraser` (M4Pro), asserts structural-glob match, 9/9 pass; plus `--scan <file>` advisory mode; documented in `docs/as-designed/devcomputers.md § Machine Inventory > Cross-Machine Path Verification`. New tasks spawned: [RAM-NONAV-SWEEP] (apply noNav=true to remaining 19 legitimate no-nav routes), [PROD-PW-APPLY] (execute the deferred Peerloop2 rotation against prod admin). Four learnings: validate detection heuristics against the actual motivating case from git (not session-doc summary); naming-convention sweeps benefit from "code-truth" anchoring even when PLAN.md text disagrees; per-route opt-out annotation outperforms scanner-wide whitelist for "expected unreachable" routes; HOME-simulation harness with structural-glob assertions catches dual-username bugs at script-author time. Verified `cd ../Peerloop && npx tsc --noEmit` clean; other gates not run this conv.*

*Previously: 2026-05-20 Conv 167 — Quick-wins / defensive fixes / baseline maintenance, no named PLAN.md block advanced (block: misc). Closed 4 RESUME-STATE quick-wins: [CAP-DEFEND] widened `CourseAvailabilityPreview.tsx:76` early-return guard (Array.isArray + length>0) eliminating the Conv 166 "1 unhandled error" in CourseTabs tests; [RM-PARAM-BUG] added two `url.search`/`searchParams` exclusion rules to `scripts/route-matrix.mjs:normalizeDynamic` before generic `[param]` fallback, dropping the phantom `/course/[slug][param]` broken-target row and resolving `/course/[slug]/[tab]` cleanly across 18 inbound references in `page-connections.md` (4 doc files regenerated); [SEED-PW] rotated dev seed `Password1` → `Peerloop2` across 13 files (3 SQL incl. migrations-dev/0001_seed_dev.sql, README, plato-seed-staging.js, mock-data.ts `DEV_PASSWORD`, tests/helpers/test-data.ts, plato personas seed-full.ts × 9, scenarios/seed-dev-topup.ts hash, 4 e2e specs) — narrowed to dev-only after discovering same hash lives in production-safe `migrations/0002_seed_core.sql` (prod-side surfaced as new [PROD-PW] task); [WRANGLER-CMT] rewrote `wrangler.toml:107-113` 3-line staging block as 6-line comment accurately describing `CLOUDFLARE_ENV=staging` build-time selection (was misleading "→ wrangler deploy --env staging"). Ran full 5-gate baseline: tsc 0 / astro 0/0/0 across 1215 files / lint 0/0 (post-fix) / **6453/6453 tests** (207s) / build clean (~7s). Then closed 2 cleanup fixes surfaced by /w-codecheck: [CCK-LINT] eslint.config.js `ignores: '.astro/**'` → `'**/.astro/**'` (matches nested generated dirs like `src/pages/api/communities/.astro/content.d.ts`); [TW-OUTLINE] Tailwind v4 `outline-none` → `outline-hidden` × 2 in `MemberDirectory.tsx:227,270`. New deferred tasks: [PROD-PW] (prod admin seed password still `Password1` in 0002_seed_core.sql + live prod D1 — needs UPDATE migration not seed change), [CCK-DA] (w-codecheck Check #8 deleted_at heuristic emitted 90+ false positives, needs qualified-column matching per `feedback_heuristic_calibration.md`). Three learnings folded: Astro `${Astro.url.search}` query-string appenders confuse template-literal route extractors → use targeted name-based exclusion not blanket dot-strip; static "table-name-in-same-block" SQL heuristics are too coarse → require qualified `<table>.column` matching or grammar parsing; ESLint flat-config `ignores` patterns are NOT auto-recursive → prefix with `**/` for nested dirs.*

*Previously: 2026-05-20 Conv 166 — CRT block ✅ COMPLETE and archived to COMPLETED_PLAN.md. [CRT-STUDENT-EXPLICIT-SCOPE] 2-site fetch fix (`CourseTabs.tsx:131` + `ResourcesTabContent.tsx:71` now pass `scope=student` explicitly). [CRT-4] CREATOR + ADMIN + MODERATOR groups on `sessions.astro` via shared `AllSessionsTabContent` component (single component rendered under 3 group labels — purple/amber/blue, distinct tab IDs preserve URL routing). [CRT-5] Propagated all 4 role flags (`isTeacherOfCourse`, `isCreatorOfCourse`, `isAdmin`, `isModeratorOfCommunity`) to remaining 5 course-tab pages (`index`, `feed`, `learn`, `resources`, `teachers`); ResourcesTabContent role split via `canSeeAllResources = isEnrolled || isCreatorOfCourse || isAdmin || isModeratorOfCommunity`. [CRT-6] 15 component tests added (8 CourseTabs + 7 ResourcesTabContent); full 5-gate baseline green (tsc 0 / astro 1214/0/0/0 / lint 0 errors 4 pre-existing warnings / **6453/6453 tests** / build 6.49s). [CRT-DEDICATED-PAGES] single dynamic `[tab].astro` catch-all handles role-tab direct nav (whitelist + access gate redirecting to /404 or /course/<slug>); chose durable single-catch-all over 4 cloned files per Solution Quality default. Three Astro/React patterns established: pass primitive descriptors not React elements across `client:load` boundaries (CRT-3 chassis lock-in); Astro static-route precedence over dynamic routes makes catch-all safe alongside existing static `.astro` files; tsc 6133 unused-variable false-positive on Astro frontmatter requires inline expression workaround. One new spawned task: [CAP-DEFEND] (CourseAvailabilityPreview undefined-shape async crash — pre-existing latent bug surfaced during CRT-6 test runs).*

*Previously: 2026-05-20 Conv 165 — CRT block first conv. [CRT-1] loader role flags: `fetchCourseTabData` now returns `isAdmin`, `isCreatorOfCourse`, `isTeacherOfCourse`, `isModeratorOfCommunity` (creator+teacher derived from data already loaded = 0 extra queries; admin via `isUserAdmin`; moderator via new join through `progressions`); 7 SSR tests covering all role permutations on `crs-intro-to-n8n` seed fixture. [CRT-2] `/api/courses/[id]/sessions` rewritten with role precedence (admin/creator/moderator → all sessions; teacher → own; enrolled student → own; else 403); 6 endpoint tests. [CRT-2.5] dual-role regression spawned during [CRT-3] design (teacher-who-is-also-enrolled would see teaching data on student tab) — solved by adding explicit `scope=student|teacher|all` query param; caller declares intent, default-without-scope keeps highest-privilege precedence for backwards compat; 10 additional endpoint tests covering all scope branches + dual-role disambiguation. [CRT-3] Teacher vertical slice: new `TeacherSessionsTabContent` component (self-contained fetch with `scope=teacher&status=all`); first wiring attempt via `extraTabs` from `.astro` failed at runtime — Astro `client:load` JSON-serializes prop boundaries and React rejects rebuilt-element plain-objects. Refactored to pass `isTeacherOfCourse` as primitive boolean; `CourseTabs` imports `TeacherSessionsTabContent` directly and constructs the extra tab internally (wrapped in `useMemo` for stable deps). Browser-verified as Guy on `/course/intro-to-n8n/sessions`: TEACHER group with "My Teaching Sessions" tab landed-on-by-default for teacher-not-enrolled; rendered two completed teaching sessions with student names + Recording links; console clean. All 5 baseline gates green: tsc 0 / astro 0/0/0 / lint 4 pre-existing / 6438/6438 tests / build 6.68s. Two new spawned subtasks: [CRT-DEDICATED-PAGES] (manual-refresh 404s on extra-tab URLs), [CRT-STUDENT-EXPLICIT-SCOPE] (student tab needs `scope=student` to be dual-role safe). CRT block status promoted PENDING → IN PROGRESS; estimated ~1 conv remaining ([CRT-4] + [CRT-5] + [CRT-6]).*

*Previously: 2026-05-20 Conv 164 — BBB-RECORDING continued. [RV] 10-surface recording-button verification sweep complete (Sarah/Guy/Brian role rotation via direct auth API; Surfaces 1-10 all rendering shared `<RecordingLink>` bordered "Recording" affordance). [BR-NAVBAR-HYDRATE] root-caused + fixed: `AdminNavbar.tsx:90` `useState(getCurrentUser())` flipped SSR-vs-CSR render branches; mirrored AppNavbar's established `isHydrated` pattern (`useState(null)` + setIsHydrated in existing useEffect + render guard `{isHydrated && admin && (...)}`). Repo grep confirmed single isolated divergence; Conv 163 [DLE] "scope widened to non-admin pages" was a misdiagnosis — `data-astro-transition-persist="admin-navbar"` was carrying the persisted error across View Transitions. All 5 baseline gates green: tsc 0 / astro 0/0/0 across 1211 files / lint 0 errors 4 pre-existing warnings / 6415/6415 tests / build 6.43s. [CRT] verified NOT done (Sessions tab hidden for Guy/Brian on `/course/intro-to-n8n/sessions`; no role tab groupings) and promoted to own ACTIVE block — full design block written (5 acceptance criteria, file map, 7×8 role × tab matrix, 6 phases [CRT-1]…[CRT-6], estimated 2-3 convs). CourseTabs.tsx already has `extraTabs` + `groupLabel` + `roleColor` infrastructure wired; missing piece is loader role flags + `.astro` pages populating extraTabs. Three Astro/SSR learnings captured: View-Transitions persistence replays hydration errors across navigations; `isHydrated` flag is the established SSR-safe current-user pattern; direct auth-API is more reliable than React form-button click for role-switching tests.*

*Previously: 2026-05-20 Conv 163 — BBB-RECORDING continued. [REC-LABEL] completed: created `<RecordingLink>` component (`src/components/ui/RecordingLink.tsx`) — bordered text "Recording" button with dark-mode classes; applied to all 10 user-facing surfaces (8 original + 2 admin: RecordingsAdmin Open link → button, SessionsAdmin Rec column status-dot → inline button). API `/api/admin/sessions/index.ts` now returns `recording_url` in list payload (was queried/dropped). Detail panels standardized on `bg-secondary-50` + "Session Recording" heading. `docs/reference/bigbluebutton.md` UI Surfaces table updated 8 → 10. **Local dev seed parity**: added Sarah/Guy/Intro-to-n8n enrollment + completed session + module_progress + assessments + attendance to `migrations-dev/0001_seed_dev.sql` with real Blindside `recording_url` UPDATE — fresh local DBs now mirror staging for the recording flow. [DLE] dev-server "loading errors" investigation: root-caused to existing [BR-NAVBAR-HYDRATE] (Vite/Astro hydration mismatch dumps wall of terminal errors + blanks page until ~2s self-heal); scope widened — NOT admin-only as originally diagnosed. New tasks spawned: [MND] `detect-machine.sh` hostname-match fix for M4Pro, [AAP] Astro dev absolute-filesystem path leak in ClientRouter (waiting on upstream Astro fix post-6.3.6 — diagnosed to `vite-plugin-astro/compile.js:50`). User-directed: [BR-NAVBAR-HYDRATE] first task next conv after /r-start. Five-gate baseline: tsc 0 / astro 0/0/0 / lint 4 pre-existing / 6415 tests / build clean.*

*Previously: 2026-05-19 Conv 162 — BBB-RECORDING continued. [MST-REC] fixed TeacherTabContent My Sessions tab missing recording link — added `recording_url` to `SessionRow` interface + verbatim mirror of student `SessionsTabContent` bordered "Recording" button; deployed to staging (Version `36c761e7-...`), verified live by user. Discovered the 8th user-facing recording surface — [REC-LABEL] inventory updated from 7 to 8 surfaces. Skill-infrastructure work: [CPD-SWEEP] swept 10 skill files (r-start/r-commit/r-end/r-end refs/fmt-docs.md/r-timecard-day/w-post-fix/w-review-resume-state/w-sync-skills) from `$CLAUDE_PROJECT_DIR` and `$HOME` to tilde-literal `~/projects/peerloop-docs` outside quotes (eliminates `simple_expansion` permission prompts on Bash gate); `SLUG=$(echo ~/projects/peerloop-docs | tr / -)` replaces `${CLAUDE_PROJECT_DIR//\//-}` for memory-dir slug derivation. Critical M4-portability correction mid-conv: user caught literal `/Users/jamesfraser` substitution would break M4 (user `livingroom`); reverted to tilde/`$HOME`-semantics. CLAUDE.md §Path Conventions extended with tilde-everywhere rule; §Startup Hooks flagged `persist-project-dir.sh` as historical. Memory `feedback_git_dash_c_enforcement.md` documents the rule + cross-machine M4/M4Pro user mapping. Cross-machine portability verified via `HOME=/Users/livingroom` simulation; first actual M4 run will be empirical confirmation. Mid-conv staging deploy of `jfg-dev-12` branch (Version `9b170124-...`). Baselines: tsc clean (no other gates run this conv).*

*Previously: 2026-05-15 Conv 161 — BBB-RECORDING major progress. Conv 160 recovery commit (`078b75f`). Blindside reply: `getRecordings` requires `limit≤100` (fixed both diagnostic surfaces + `bbb.ts` default). [BR-PAGE] paginated `/admin/recordings` with 20-per-page paging, 2-call total derivation, AdminPagination component. [BR-TRACE] mapped all 7 user-facing recording surfaces + empirically verified on staging (1 of 8 recordings visible, 5 orphaned, 2 Greenlight-only). [TCV-REC] fixed TeacherCourseView SessionRow missing recording-link JSX, deployed to staging, verified live. Spawned 3 new deferred tasks: [BR-NAVBAR-HYDRATE] (pre-existing dev-mode hydration mismatch), [CRT] (role-aware course-page tabs), [REC-LABEL] (standardize recording-link affordances). Baselines: tsc clean / astro 0/0/0.*

*Previously: 2026-05-13 Conv 159 — BBB-RECORDING block (5 of 6 subtasks complete). [BR-DIAG] account-wide getRecordings returned 0 recordings (returncode SUCCESS); [BR-AUTO] `autoStartRecording=true` deployed at 3 sites with type-system support; [BR-ADMIN] built `/api/admin/bbb/recordings` endpoint + `/admin/recordings` page + `RecordingsAdmin.tsx` component + AdminNavbar entry; [BR-ADMIN-SCRIPT] promoted diagnostic script to `scripts/bbb-list-recordings.mjs`; [BR-REPLY] drafted and sent reply to Fred Dixon at Blindside. [BR-STATUS] (richer post-session UI for recording state) deferred pending Blindside's response. Amended `docs/reference/bigbluebutton.md` with detailed Recording Lifecycle section (159 net lines). Established `.scratch/` convention (gitignored persistent workspace). Spawned 1 new task: [AHM] (pre-existing AdminNavbar hydration mismatch). Baselines: tsc clean / astro 0/0/0.*

*Previously: 2026-05-06 Conv 150 — Infrastructure/docs work: [OPW] Conv 147 rule-strengthening watch closed (root cause: missing memory-dir sync on this machine; rule clarified). Memory M4↔Pro sync completed (31 new files copied, 2 overlaps refreshed, MEMORY.md rewritten as topical index). Tier 1+2+3 audit fixes applied (11 findings consolidated: r-end memory merge, size≠novelty rule inlined, new Baseline Verification section, output-formatting rule merges). CLAUDE.md major restructure (677→446 lines, 22→19 sections): behavioral rules retained, navigation→docs/INDEX.md (NEW), archaeology→TIMELINE.md, Block Arc→SCOPE.md. Asymmetric rule placement noted (Issue Surfacing in CLAUDE.md, Pointing Emoji + Option Phrasing in memory) — functional but inconsistent. New memory file: `feedback_conversational_brevity.md`. No feature blocks worked. [CMS] cross-machine memory sync architecture added as new deferred item.*

*Previously: 2026-04-21 Conv 144 — [VS] Stripe miss-resilience complete: all 7 scenarios live-verified on staging (S1–S7) with constructEventAsync prod-bugfix deployed (version `254fa8e9`); Stripe Mode Discipline decision recorded (local=Test, staging=Sandbox, prod=Live); 4 Phase B follow-ups added ([VD]/[VW]/[VA]/[VL]). Deprecated RESUME-STATE.md (9 tasks to TodoWrite); test suite 6409/6409 passing. Ready for Conv 145 ([VD]→[VW]→[VA]→[VL] phase). Previously Conv 143: [VH] Stripe direct-sign webhook harness (7 commands + escape hatch); [LE] eslint-react-hooks installed (0 errors, 31 warnings).*

*Previously: 2026-04-19 Conv 137 — DOC-SYNC-STRATEGY block declared complete and archived. Phase 4 deliverables: tightened 4 chronic-noise matchers in docsRegistry (stream rule split, feed→feeds keyword fix, narrowed astro/ratings patterns, react-big-calendar isolated), expanded test suite 8→15 assertions, CI `doc-drift.yml` GH Actions workflow (PR/push-to-main cross-repo checkout), stored baseline pattern (`.drift-baseline-sha` + `advance-drift-baseline.sh` + `/r-end` auto-advance). DEPLOYMENT.GHACTIONS checklist updated: `DOCS_REPO_PAT` added alongside `CLOUDFLARE_API_TOKEN`. Two Phase-2 deferred follow-ups folded into POLISH.TECHNICAL_DEBT: `detect-changes.sh`/`dev-env-scan.sh` consolidation + `resend.md` full template-table resync.*

*Previously: 2026-04-21 Conv 145 — Phase B Stripe follow-ups complete. [VD] partial-index-predicate-matching duplicate-purchase guard in `createEnrollmentFromCheckout` + `ADMIN_ALERT` warning + test. [VW] `ctx.waitUntil()` wraps for `webhook_log` INSERT on Stripe + BBB webhooks + test helper stub real-shape. [VA] `/api/admin/stripe-mode` endpoint built + deployed to staging (Version `e5f00fb0`) + verified mode aligned (Sandbox workbench). [VL] leak audit + CLI cache refresh (PP6iSq verified absent everywhere). [FD] `memory/feedback_no_paste_tokens_in_chat.md` extended to cover Claude-initiated diagnostic leaks (unsafe patterns, safer-alternatives, redactor one-liners). New deferred block STRIPE-E2E-DEV (row #20): ~160-line comprehensive E2E testing roadmap with 4 scope tiers (A paper/B scripted/C Playwright/D Claude-MCP-driven), 11-scenario matrix, prerequisites, 7 open questions for Plan Mode, risks, references. [STRIPE-UI-UPDATE] flagged as new subtask (Stripe Dashboard UI merging Test-mode into Sandboxes listing). Baselines: tsc clean / astro 0/0/0 / lint 31 pre-existing / 6410/6410 tests passing.

*Previously: 2026-04-19 Conv 140 — CC-workflow: `/r-end` skill enhancements. (A) `/w-sync-skills r-end` identified 5 portable improvements from spt-docs and 4 HARD RULES additions; decided to evolve r-end skills independently (spt-docs r-end has >30% structural divergence — same-name skills should not be merged after 3+ months of independent evolution). Saved `feedback_skill_sync_same_name_divergence.md` to memory. (B) Added `rEnd.agentModels` config section to `.claude/config.json` (learnDecide: opus, updatePlan: haiku, docs: sonnet) with per-agent `!` backtick resolution in SKILL.md Pre-computed Context + Agent N headings. (C) Ported Step 4c REASSESS OPUS TAGS from spt-docs with Peerloop-flavored rubric examples (architectural lock-in, multi-dimension design, subtle refactors, high-stakes migrations + anti-examples). (D) `/w-sync-docs` audit (no fixes applied): TEST-COVERAGE.md has 14 cosmetic drift items (summary counts off by 1-2, phantom test entry) — test runner doesn't read these, deferring cleanup. New meta-tasks spawned: `[TC]` TEST-COVERAGE.md drift cleanup pass; `[SY]` `/w-sync-skills` divergence detection logic (>30% structural divergence flag); `[PC]` pre-computed context self-verification (lookup-key echoing for "(no X config)" false-negatives).*

*Previously: 2026-04-19 Conv 136 — CC-workflow tooling only: promoted all three v2 skill pairs to canonical names — `r-commit2/SKILL.md` → `r-commit`, `r-end2/SKILL.md` → `r-end`, `r-timecard-day2/SKILL.md` → `r-timecard-day`; deleted r-end2, r-commit2, r-timecard-day2 dirs entirely. CLAUDE.md skills table simplified (removed 3 v2 rows, updated descriptions). `[XX]` code-preservation pipeline validated end-to-end (all 4 codes `[DT]`/`[DC]`/`[DW]`/`[DV]` survived Conv 135→136 round-trip). npm install ran (package-lock drift resolved). Phase 2 detect-changes.sh follow-up updated: r-end2/scripts/ copies gone, only r-end/scripts/ copies remain.*

*Previously: 2026-04-19 Conv 135 — DOC-SYNC-STRATEGY Phase 4 planned; CC-workflow meta-improvements. First real `/r-start` SessionStart-hook run surfaced 9 drift flags — triaged 1 REAL (`session-booking.md` line 35: "4-week lookahead" → "28-day lookahead (`availabilityWindowDays` default, Conv 129)" + `maxBookingDate`/`isAtMaxMonth` month-nav cap) + 8 FALSE_POSITIVE. Authored `DOC-DECISIONS.md` Section-3 entry "Tech Doc Sweep: Vendor/Area Keyword Noise" (mirrors Auth-Doc precedent): 4 chronic-noise docs (stream/ratings-feedback/react-big-calendar/astrojs) with per-doc narrow "actually review when" triggers + 4 case-by-case docs. Verified-false sub-agent claim: Group-A Explore agent reported `feeds.md` as REAL based on Conv 130 `fetchCourseTabData` consolidation; inspection of the loader return shape proved it returns course metadata, NOT feed activities — 1/9 precision confirmed, not 2/9. Classified the Phase 1–3 system as **working scaffold, not load-bearing** (11% first-run precision + CC-only-entry assumption structurally unverifiable) and added **Phase 4 — Precision & Coverage** subsection to this PLAN.md with three active tasks: `[DT]` tighten 4 chronic-noise matchers in `docsRegistry` + regression tests, `[DC]` implement CI drift-check proactively (GH Actions cross-repo workflow), `[DW]` extend `HEAD~5` to stored-baseline state. Exit criteria: FP <20% on 3 batches / CI gates merges to main / baseline-SHA advancement proven 3+ times. Phase 3 Follow-up CI bullet promoted `[x]` with cross-ref; Phase 2 known-noise follow-up checked off. Block status row updated. Meta/tool improvements (not PLAN block work): migrated CLAUDE-SAVED.md Directive 3 (👉👉👉 prefix) to `memory/feedback_pointing_emoji_prefix.md`; saved `memory/feedback_todowrite_mnemonic_codes.md` documenting the `[XX]` 2-3-letter-code convention; patched `/r-start` Step 7 to assign codes on RESUME-STATE → TodoWrite transfer; patched `/r-end` + `/r-end2` `## Remaining` templates to preserve `[XX]` codes (pipeline-symmetry — reader + writer both now uphold the convention). `persist-project-dir.sh` added to CLAUDE.md §Startup Hooks list (previously-missing project-hook bullet). First end-to-end test of `[XX]` code-preservation is Conv 136 /r-start.*

*Previously: 2026-04-19 Conv 134 — DOC-SYNC-STRATEGY Phase 3 complete (chosen scope). Measured both drift scripts on MacMiniM4 (`tech-doc-sweep.sh` 1.3s, `sync-gaps.sh` 4.5s) — runtime inversion vs. prior PLAN framing corrected. Evaluated 4 options (CI-only / git pre-commit / both / CC SessionStart hook) and chose **Option D — CC SessionStart hook** for zero-install friction on the `peerloop`-alias workflow. Authored `.claude/hooks/tech-doc-drift.sh` wrapping `tech-doc-sweep.sh` with silent-on-clean design (presence-of-output = signal; awk-extracted flagged-doc list + resolve hints when drift exists). Wired into `.claude/settings.json` as 4th SessionStart hook, after `check-env.sh`. Smoke-tested both branches (drift: 9 flagged docs from current HEAD~5; clean: exit 0 silently via `CODE_CHANGES_OVERRIDE=README.md`). Strategy doc §4 Phase 3 rewritten with runtime table + 4-option evaluation table + chosen-D rationale + deferred-A triggers. Option A (CI drift-check) deferred with explicit reactivation triggers: non-CC commit path emerges OR 10+ convs of SessionStart gaps. Option B (git pre-commit) rejected (per-clone install friction not worth it for 2-dev-machine setup). Block remains WIP until deferred CI check and 10+ conv reliability validation complete.*

*Previously: 2026-04-19 Conv 133 — DOC-SYNC-STRATEGY Phase 2 complete. Consolidated drift-detection scripts to `.claude/scripts/` (`sync-gaps.sh`, `tech-doc-sweep.sh`, `route-mapping.txt` moved; 6 orphan duplicates deleted from `r-end/scripts/` + `r-end2/scripts/`; 5 caller sites + 4 DOC-DECISIONS.md refs + 2 live config refs updated). Authored `.claude/scripts/docs-registry.mjs` (Node ESM, no deps; 4 CLI commands: `vendor-rules`, `test-shared-basenames`, `get-group`, `list-groups`). Migrated `tech-doc-sweep.sh` + `sync-gaps.sh` to read from `docsRegistry`. **Fixed latent bug** in tech-doc-sweep: bash `${rule%%|*}` was truncating multi-alternation `codePattern`s at first `|`, silently suppressing drift signal for 60+ convs — same HEAD~5 now surfaces 9 previously-hidden flags (triaged: 2 REAL fixed this conv — `docs/reference/resend.md` added 3 SessionInvite* rows + `docs/as-designed/availability-calendar.md` 4-week → 28-day lookahead + month-nav cap; 2 PARTIAL; 5 FALSE_POSITIVE). Added `.claude/scripts/test-drift-detection.sh` (8 assertions, all pass) with `CODE_CHANGES_OVERRIDE` env-hook pattern for testability. `/w-sync-docs` SKILL.md updated with registry-scripts preamble. Wrangler installed globally (v4.83.0). Phase 3 (hook/CI integration) remains; 3 known follow-ups captured (detect-changes/dev-env-scan consolidation, resend.md full template-table resync, DOC-DECISIONS noise entry).*

*Previously: 2026-04-18 Conv 132 — DOC-SYNC-STRATEGY Phase 1 complete. Authored `docs/as-designed/doc-sync-strategy.md` (~200 lines) covering problem statement, 196-doc inventory, 4-category classification (generated/driftCheck/manual/archival), `docsRegistry` JSONC schema, 3-phase rollout, answers to all 5 open questions. Merged `docsRegistry` into `.claude/config.json` (17 groups, tech-doc-sweep rules ported 1:1). Fixed 2 stale `config.json` paths (`paths.vendorDocs` → `docs/reference/`, `paths.architectureDocs` → `docs/as-designed/`). Retired 8 `_`-prefix legacy docs (~6,265 lines: `_DB-SCHEMA`, `_API`, `_SERVER`, `_STRUCTURE`, `_RESEARCH-CLAUDE`, `_DIRECTIVES`, `_PAGES`, `_SPECS`); retained `_COMPONENTS.md` as load-bearing (referenced in `/w-add-client-note` + CLAUDE.md) — reclassified from `archival` to `driftCheck` against `src/components/**`. Saved `feedback_option_phrasing.md` memory. Block status: 🔥 WIP — Phase 1 done, Phases 2 (tool migration) + 3 (hook/CI) deferred to future convs.*

*Previously: 2026-04-18 Conv 131 — Audit-cleanup batch. [RA-SSR tail] Deleted orphaned `fetchCourseDetailData` (200 lines) + 8 CDET tests + dead imports; header docstring updated CDET → CTAB. [TDS-AUTH] auth-libraries.md rewritten 505 → 151 lines as pure decision record (stale code examples removed: wrong middleware path, JWT payload shape, fictional oauth_accounts/sessions tables, SALT_ROUNDS=12 vs actual 10, JWT audience `peerloop-users` vs actual `peerloop`); API-AUTH.md OAuth cookie names corrected (`oauth_state`/`oauth_verifier` → `peerloop_oauth_state`/`peerloop_oauth_verifier` in Google + GitHub sections); google-oauth.md cross-ref clarifying OAuth-callback vs register handle schemes. [DBAPI-SUBCOM-AUDIT] DB-API.md §Authentication rewritten (6 fictional → 10 real endpoints); §Communities rewritten (7 → 18 endpoints, Active/Proposed split). DB-API.md +218 lines of net-new doc. [DEVCOMP-REVIEW] 114 session files scanned; no actionable drift — devcomputers.md accurate. [PFC PLATO-FLYWHEEL-CREATOR-GAP] plato.md Step Catalog 20 → 25 rows + new §Creator-Lifecycle Coverage Audit section (7/18 P0 stories covered, 3 partial, 8 missing across 6 themed gap groups G1–G6, 4-tier recommendations). Open question: whether to add PLATO-EXPAND as a new block pending user scope decision.*

*Previously: 2026-04-18 Conv 130 — [RA-SSR] `fetchCourseTabData` loader collapses 6 course-tab Astro pages from ~180 → ~85 lines each. [EM] 3 session-invite email templates added (create→student, accept→teacher, decline→teacher); `decline.ts` gap fixed (added missing in-app notification to teacher). [MPT] 11 multipart upload tests with manual Uint8Array body construction (jsdom FormData bug workaround); session-invite mock updated. 6404/6404 passing, tsc clean.*

*Previously: 2026-04-18 Conv 127 (TIMECARD-V2 block completed and archived to COMPLETED_PLAN.md — parameter-driven `timecard-day.js` refactor: all project literals moved to `.claude/config.json → rTimecardDay`, predicate-driven per-H4 inclusion engine replaces tier cascade so a bullet renders in every matching H4, 2-pass engine with recursive fallthrough detection, 8 named H5/1 named H6 strategies, forked `/r-end2` + `/r-commit2` with v2 commit format (`### SECTION` H3s + `Format: v2` trailer), new `docs/reference/COMMIT-MESSAGE-FORMAT.md` spec. V1 skills untouched. Also: staging D1 reset + full seed chain (dev/stripe/booking/feeds, 2022+9+46 rows + 14 Stream activities).)*

*Previously: 2026-04-18 Conv 126 (Tooling/infra — no PLAN.md tasks. Synced r-commit/r-end/r-start/r-timecard-day skills from spt-docs; authored `timecard-day.js` (1573-line deterministic timecard script) + `r-timecard-day2` skill; fixed 3 routing bugs in timecard classifier: PLAN.md/DOC-DECISIONS.md routing via docRootExclude fix, DB Changes H4 tier, docNameWhitelist for ALL-CAPS doc stems, API Changes T3b detection guarded by !isTestRelated, infraPrefixWords for db:* scripts. All fixes verified against Apr 15 + Apr 16 timecards.)*

*Previously: 2026-04-15 Conv 125 (ROLE-AUDIT drain pass — 3 of 4 remaining RA-* follow-ups closed. [RA-RES-ROLE] dropped unused `CommunityTabs.Resource.uploadedBy.role` across 8 files (13 lines, 1 LEFT JOIN eliminated). [RA-JWT] decision recorded in `docs/DECISIONS.md` §4: keep status quo, do NOT embed `isAdmin` in JWT — refresh-token-as-auth fallback widens staleness to 7 days (not 15 min). [ADR] auth-doc review: 4 tech-doc-sweep flags are expected noise, documented in `DOC-DECISIONS.md` §5 with dismissal table. Spawned [RA-SSR-LOADER] — SSR loader admin-gate site missed by Conv 123 audit. Baselines: tsc clean / astro 0/0/0 / lint 1 pre-existing. [RA-SSR] remains as only mechanical RA-* task.)*

*Previously: 2026-04-15 Conv 124 (COMMUNITY-RESOURCES block closed — Phase 8 PLATO `upload-community-resources` step added to flywheel scenario; block fully complete and archived. [RA-CLI] `MyCourses.tsx` migrated to `useCurrentUser()`; `UserProfile.tsx` + test deleted as dead code. [RA-API] spawned + closed same conv: deleted dead `/api/me/enrollments` endpoint/tests; `/api/me/stats` discovered to have never existed. Baselines: tsc clean / astro 0 errors / 369 files 6392 tests green.)*

*Previously: 2026-04-15 Conv 123 (ROLE-AUDIT block closed — audit report produced, [RA-RO] `transformRole` extract + Astro/SSR type narrowing to `'creator' | 'member'`, [RA-ADM] 3 narrow auth helpers + 9 call-sites migrated. Block removed from DEFERRED; 4 follow-up tasks spawned ([RA-CLI], [RA-SSR], [RA-JWT], [RA-RES-ROLE]). [SGA] `sync-gaps.sh` excludes `.astro/` dirs. Full five-gate baseline green: tsc 0 / astro 0/0/0 / lint 5 pre-existing / 371 files 6447 tests / build.)*

*Previously: 2026-04-15 Conv 121 (COMMUNITY-RESOURCES Phase 9 docs complete — new `docs/as-designed/r2-storage.md` + `DB-API.md §Community Resources` 6 endpoints; only P8 (PLATO) remaining in block. Drain pass closed 21 TodoWrite items across multiple blocks (see §"Conv 121 drain pass" under COMMUNITY-RESOURCES): 6 spawned, 4 of those closed same conv, net -15. Notable: [CRES-TEST-PATH], [COURSE-RES-AUTH] (spawned edge case), Conv 110 nav staleness, [DBSCHEMA-MR/CRES/SUBCOM-DUPE], [DBAPI-SUBCOM-RENAME], [PE]+[PE-OVERRIDE], [BL] dead link, [SG/SG2] sync-gaps tighten, [AS] refresh-token fallback docs. [CSS] /discover/members clipping root-caused but fix deferred to browser-enabled session.)*

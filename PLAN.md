# PLAN.md

This document tracks **current and pending work**. Completed blocks are in [plan/COMPLETED.md](plan/COMPLETED.md).

The `plan/` subdirectory holds per-block plan files for large blocks. Currently migrated:
- **MATT family** — `plan/matt/` (README + per-phase files + cutover + standin-matt). **MATT-DESIGN-PUSH ✅ CLOSED Conv 249** → [plan/COMPLETED.md](plan/COMPLETED.md) #71 (Phases 1–5 done; Phases 6–7 wound down under the Conv-239 Matt phase-out). Cutover ✅ shipped Conv 197; sibling MATT-CUTOVER still tracks PROV-MATCH-AUTO.
- **Conv 211 migration (Fork C — large blocks >80 lines)** — `plan/deployment/`, `plan/calendar/`, `plan/package-updates/`, `plan/mvp-golive/`, `plan/cert-approval/`, `plan/admin-review/`, `plan/stripe-e2e-dev/`. Each as `<slug>/README.md` (Fork Y hybrid — all 7 have sub-sections so all get subdirs).
- **ROUTE SWEEP** — `plan/route-migration/README.md` (Conv 291 reframed RTMIG-4 from a porting backlog into a **full visual-presentation sweep** of every route — 14 route-group tasks, ~50 routes, with a **per-route PAUSE protocol**: assess → surface → await refinements → do Tier-1/Tier-2 work → mark Swept. Supersedes the Conv-290 "porting homes" framing; porting is now just one kind of per-route work). The `ROUTE-MIGRATION` ACTIVE-table row is now a slim pointer; its conv-by-conv status log is archived at the tail of that README (Conv 394 [PLAN-XTRACT]).
- **Conv 394 [PLAN-XTRACT] extraction (10 blocks, PLAN.md 249 KB → 54 KB, −78%):** every inline block >5 KB was moved to a `plan/<slug>/README.md` and replaced with a slim status + `→ [plan/…/README.md]` pointer. Status logs for the two DONE blocks `ROUTE-MIGRATION` (58 KB) + `HOME-FEED-MERGE` (25 KB) were archived at the tail of their existing READMEs; new per-block READMEs were created for `TYPO-FDN`, `ROLE-STUDIOS`, `NAV-RETROFIT`, `PRIM-REGISTRY`, `LAYOUT-SG` (distinct from `plan/layout-mode/` = [LAYOUT-MODE]), `PALETTE-FDN`, `ROLE-SEMANTICS`, and a combined `plan/plato/` for `PLATO-REVIVE` + `PLATO-SEQ`. Section/subsection headings (`## ROLE-SEMANTICS`, `## ROLE-STUDIOS`, `### PLATO-REVIVE`, `### PLATO-SEQ`) were kept as slim pointers so existing anchors still resolve. The whole file is under the 25 K-token Read limit again.

Other named blocks still live inline below; per-block extraction happens incrementally as each block needs attention.

---

## Block Sequence

### ACTIVE

| Block | Name | Status |
|-------|------|--------|
| MERGE-BRIAN | Client-branch intent adoption — extract/reimplement Brian's UI intent from the agreed pivot snapshot, consequence-guarded | 🔥 IN PROGRESS (Conv 407) — **no as-is merging, ever** (user↔client conversation); review target = pivot snapshot `8a1e677f` (tip of `origin/brian-July-7`, agreed 07-20); `brian-July-20` = his post-pivot exploration branch, out of scope. Reference worktree `~/projects/Peerloop-brian` + screen-by-screen review program (order: /course → /courses → communities → shell/breadcrumbs → sessions-files feature → misc). **Fresh-docs restart late Conv 407** (user feedback: scope choices must be surfaced, premise changes need full rewrites — `memory/feedback_assess_ask_before_acting.md`): plan README rewritten from the pivot premise; **/course §1 brief DONE** (pivot-grounded at `8a1e677f`; dispositions pending side-by-side). Side-by-side environment operational (ours `:4321` + pivot `:4341`, identical dev datasets). Timecard author-allowlist protection landed ([TC-MERGE-TZ] ✅ Conv 407). Full plan + dispositions → [plan/merge-brian/README.md](plan/merge-brian/README.md). Task-board body: `CURRENT-TASKS.md § [MERGE-BRIAN-JULY7]`. |
| NAV-RETROFIT | Legacy→Matt incremental migration — retrofit legacy shell onto Matt's design | 🔥 IN PROGRESS (Conv 191, demo-driven) — legacy→Matt incremental restyle (Approach B); root cause **[DEMO-HOME]** found. Full plan + status log → [plan/nav-retrofit/README.md](plan/nav-retrofit/README.md). |
| MATT-CUTOVER | Make Matt the primary app — provenance attribution + route flip | 🟢 SUBSTANTIALLY COMPLETE — Conv 197 [PROV] + [ROUTE-FLIP] both done (43 legacy pages → `/old/`, 9 Matt → root, namespace dissolved); Conv 198 post-flip doc reconciliation; Conv 199 [PROV-SWEEP] + [PROV-MATCH]. Remaining: [PROV-MATCH-AUTO] (Figma-matching automation). → [plan/matt/cutover.md](plan/matt/cutover.md) |
| ROUTE-MIGRATION | Forward-migrate legacy `/old/*` flows onto the new root routes (post-ROUTE-FLIP) | 🟢 SWEEP COMPLETE — **[RTMIG-4] ✅ CLOSED Conv 340** (all 13 in-scope RG-* sweeps done; **RG-PUBLIC parked** until the marketing redesign). Full plan + conv-by-conv status log → [plan/route-migration/README.md](plan/route-migration/README.md). |
| BBB-RECORDING | BBB Recording Investigation — diagnose empty recordings, fix `autoStartRecording`, build account-wide diagnostic endpoint | 🔥 IN PROGRESS (Convs 159-164: [REC-LABEL] complete Conv 163; [BR-NAVBAR-HYDRATE] complete Conv 164; only [BR-STATUS] + [BR-ZERO-REPRO] deferred. [CRT] promoted to own block.) |
| CALENDAR | Platform Calendar — custom multi-view calendar component for all roles | 📋 PENDING → [plan/calendar/README.md](plan/calendar/README.md) |
| ADMIN-REVIEW | Admin System Review — testing gaps, UI consistency, cross-links, menu restructure | 📋 PENDING (promoted Conv 095) → [plan/admin-review/README.md](plan/admin-review/README.md) |
| PACKAGE-UPDATES | Package Version Upgrades — all dependencies current, new branch | ✅ COMPLETE (Convs 104-114, PR #26 merged into `staging`). CF Pages→Workers migration spawned as separate CF-WORKERS block and also complete. → [plan/package-updates/README.md](plan/package-updates/README.md) |
| PRIM-REGISTRY | Vetted-primitive registries + `data-prov` runtime conformity | 🔥 IN PROGRESS (Conv 216) — vetted-primitive registries + `data-prov` runtime conformity. Full plan + status log → [plan/prim-registry/README.md](plan/prim-registry/README.md). |
| ROLE-SEMANTICS | Canonical role semantics (`can*` permission vs `is*`/`has*` behavioral) + consolidate the 3 competing definitions | ✅ CORE CLOSED (Conv 253) + CENTRALIZATION CLOSED (Conv 254) — rule DECIDED + foundation (Conv 252); `[RS-HYBRID-FLIP]`, `[RS-SQL-SWEEP]` (24 projections + 16 EXISTS filters → fragments), the Tier-3 display-axis fix, and `[RS-MOD-FRAG]` (`isCommunityModeratorSubquery` + 2 `members/index` sites) all DONE. No standalone work remains. Only the deliverable-4 incremental call-site migration is delegated to `[RTMIG-4]`/`[ROLE-STUDIOS]` ports. **Conv 315 — the RG-PUBPROF-blocking residue cleared** (creator-loader `primary_topic_id` restored + `UserProfileHeader`→canonical `userRoles()`) → **unblocks [RG-PUBPROF]** in the route sweep. Kept inline (not archived) as a thin "core closed, tails delegated" note. → see **§ ROLE-SEMANTICS** below |
| ROLE-STUDIOS | **DECIDED (Conv 252): deconstruct `/dashboard` → role-focused workspaces + thin triage strip + first-class progression-nudge layer** | 🔥 CLIENT BLOCK RESOLVED (Conv 317) — multi-conv, #1. Decision + phased plan (Phases 0–5 incl. performing-vs-oversight model A) settled Conv 252; supersedes cluster-0 decision A. Phase 1 `[ROLE-SEMANTICS]` core ✅ Conv 253; Phase 2b `/mod` console ✅ Conv 254. **Phase 2 workspaces DONE Conv 256** — all 3 performing-role workspaces built (`/learning` Conv 255; `/creating` + `/teaching` Conv 256). **Phase 4 nudges DONE Conv 257–258** — `ProgressionNudge` island + all 5 placements live + 2 apply-destination root ports ([NUDGE-BUILD]); render-checks done + `[NUDGE-TC]` closed Conv 258; v2 progression-gap `[NUDGE-TC-V2]` ✅ BUILT Conv 286 (decision A path-capstone — gates ⑤ on `progression_position===course_count AND badge='learning_path'`; NEW `lib/progression/capstone.ts` + `ProgressionNudge` `capstone?` prop + 20 tests). **✅ CLIENT DECISION (Conv 317):** the client approved the **individual role dashboards** (`/learning` `/teaching` `/creating`) as the go-forward; the composite `/dashboard` (`UnifiedDashboard`) will **NOT** be ported and is **kept in `/old/*`** as a deprecated reference (Phase 3 "retire UnifiedDashboard" is therefore DROPPED, not executed — `/old/dashboard` stays live). The old-vs-new appearance-freeze is **lifted** → the shared dashboard comps (`EnrollmentCard`/`CertificatesSection`/`MyFeeds`) are free to conform (incidentally restyling the deprecated `/old/dashboard`, acceptable). **Unblocks [RG-WORKSPACES]** island restyles in the route sweep (see ROUTE-MIGRATION row + README). Supersedes the Conv-256 "preserve the comparison / DO NOT RETIRE" rule (kept ≠ retired; only the freeze lifts). **Available now:** island restyles #20–23 (ride RG-WORKSPACES), per-workspace admin model-A deep-links, Home rework (spun out as HOME-FEED-MERGE). → see **§ ROLE-STUDIOS** below |
| HOME-FEED-MERGE | Merge SmartFeed into Home + public/visitor (marketing) feed mode — conversion hook | ✅ **BUILD** — all phases 1–7 built (Convs 266–268); STAGING-COMPLETE Conv 262. Residual Feed/Promotion/Discovery sequence + full status log → [plan/home-feed-merge/README.md](plan/home-feed-merge/README.md). |
| LAYOUT-SG | Unified margins/layout style guide (the missing page-level layout system above the atomic spacing scale) | ✅ FOUNDATION LOCKED (Conv 289); residuals deal-with-as-they-come. Full plan + status log → [plan/layout-sg/README.md](plan/layout-sg/README.md). |
| PALETTE-FDN | CC-owned colour foundation — Matt-anchored colour scales + status hues + style-guide sweep policy (the missing colour system above the atomic token set; sibling of LAYOUT-SG) | 🟢 FOUNDATION DONE (Conv 296) — Matt-anchored colour scales + status hues + sweep policy. Full plan + status log → [plan/palette-fdn/README.md](plan/palette-fdn/README.md). |
| TYPO-FDN | CC-owned typography + spacing foundation — token-role discipline + line-height fix + per-route migration | 🔥 IN PROGRESS (Conv 298; sibling of PALETTE-FDN/LAYOUT-SG on the type/spacing axes). Full plan + conv-by-conv status log → [plan/typo-fdn/README.md](plan/typo-fdn/README.md). |

### ON-HOLD

| Block | Name | Notes |
|-------|------|-------|
| DEPLOYMENT | Deployment automation + prod cutover — spawned from CF-WORKERS | PAGES-DISCONNECT done (Conv 116). **Staging redeployed Conv 348 [STG-DEPLOY]** — jfg-dev-14 HEAD `8cc4ce7e` (app Worker `6553c1cb` + cron `e5a75e73`; destructive feeds-level DB reseed; homework file-upload browser-verified). Remaining (all prod, still deferred): GHACTIONS, PROD, STAGING-DOMAIN, DB-SYNC. → [plan/deployment/README.md](plan/deployment/README.md) |
| INTRO-SESSIONS | Intro Sessions — free 15-minute pre-enrollment calls | Schema exists (`intro_sessions`); feature not built. Discovered in TERMINOLOGY review Session 348. |
| ~~DEV-STAGING-SSR~~ | ✅ **RESOLVED Conv 177** via `[DSSR-SCOPE]` fix | The Conv 122 root-cause hypothesis (two React copies via `@astrojs/cloudflare` 13) was wrong. Real cause: Vite cold-start dep-discovery race (industry-wide, see DEVELOPMENT-GUIDE.md § Vite SSR Cold-Start Dep Discovery). Fix: `astro.config.mjs` `vite.optimizeDeps.entries` + `include: ['astro/virtual-modules/transitions.js']`. Cold-start /matt/ now succeeds first try; production build clean (7.27s); preview /matt/ renders fully with `Sidebar.tsx` useState intact. Conv 176 stateless-primitives discipline retired. |

### DEFERRED

*Reorganized Conv 095. Previous numbering in git history.*

| # | Block | Name | Notes |
|---|-------|------|-------|
| 1 | SEEDDATA | Database Seeding & Empty State | 🟡 Nearly Complete (EMPTY_STATE deferred to POLISH) |
| 2 | POLISH | Production Readiness | Validation, roles, tech debt, security, deferred features |
| 3 | MVP-GOLIVE | Production Go-Live | Absorbs OAUTH, STAGING-VERIFY, CRON-CLEANUP, RECORDING-PERSIST; **CODE-AUDIT** (Conv 397 — run React Doctor once pre-launch, reproducing the Conv 397 procedure; advisory, not a gate) → [plan/mvp-golive/README.md](plan/mvp-golive/README.md) |
| 4 | TESTING | Multi-User Testing | Merged: E2E-GAPS + E2E-LIFECYCLE + WORKFLOW-TESTS |
| 5 | IMAGES | Image Pipeline — uploads, management, optimization | Merged: FILE-UPLOADS + IMAGE-MGMT + IMAGE-OPTIMIZE |
| 6 | FEEDS-NEXT | Feed Enhancements — ranking, mobile, privacy, level matching, promotion | Merged: FEEDS + FEED-PROMOTION + FEED-PRIVACY + LEVEL-MATCH |
| 7 | OBSERVABILITY | Error Tracking, Analytics, Audit Logging | Merged: SENTRY + POSTHOG + AUDIT-LOG |
| 8 | CERT-APPROVAL | Certificate Lifecycle — student page, creator approval, PDF, public view | 7 admin/API endpoints built; public `/certificates/[id]` page added Conv 389; teacher recommend UI built Conv 390 (closes the Conv-082 zero-UI-consumer gap); scope now teaching-cert-only after DIPLOMA de-conflation → [plan/cert-approval/README.md](plan/cert-approval/README.md) |
| 9 | PUBLIC-PAGES | Public Page Coherence — header unify, legacy cleanup, footer, personalization | |
| 10 | PAGES-DEFERRED | Deferred Pages (7) | Includes story IDs |
| 11 | RATINGS-EXT | Ratings Extensions — expectations, materials rating, display | |
| 12 | EXTRA-SESSIONS | Extra Session Purchases | Beyond course plan |
| 13 | COURSE-LIMIT | Creator Course Limit | Default 3, admin-adjustable |
| 14 | AVAIL-OVERRIDES | Availability Overrides | Schema exists; feature not built |
| 16 | MSG-TEACHER | Message Teacher from Course Page | Messaging now open (Conv 110); needs UI button on course page |
| 17 | RESPONSIVE | Responsive & Mobile Review | Site-wide audit needed. **Conv 367:** min supported width **decided = 375px** (`docs/decisions/05-ui-ux-components.md`; current clean floor ~357px) — sets the parameter this audit tests against; follow-up **[MINWIDTH-320]** (3 overflow fixes to lower floor to 320px) in CURRENT-TASKS.md backlog. Point fixes landed same conv (off-grid-spacing snaps ×3; Sidebar short/landscape overlap — both archived in the Conv 367 Extract). |
| 18 | ROUTE-AUDIT | Route & Sitemap Audit | Routes vs `url-routing.md`, public/auth boundaries |
| 19 | STUMBLE-REMNANTS | STUMBLE-AUDIT Remaining Items | JWT test, 2 client decisions (member_count fixed Conv 108) |
| 20 | STRIPE-E2E-DEV | Dev-Level Stripe Integration Stress Test — real browser, real Test-mode cards, real webhook tunnel | Prerequisite for go-live confidence. Conv 145 scoped. Tiered (A/B/C/D). Complements Conv 144 staging live-verification with higher-fidelity Dev-side coverage. → [plan/stripe-e2e-dev/README.md](plan/stripe-e2e-dev/README.md) |
| 22 | ADMIN-REDIRECT-BLANK | Non-admin hitting `/admin/*` gets blank page instead of redirect | ✅ **FIXED Conv 250** (rode along with [RTMIG-ADMIN-REHOST]). **Root cause:** a `return Astro.redirect()` inside the `AdminLayout` *component* (not the page top-level) halts that component's render to empty output rather than emitting the redirect Response → blank 15-byte 200; only middleware/page-frontmatter Responses become the HTTP response. **Fix:** moved the admin-role gate into `middleware.ts` (clean 302), removed the dead `AdminLayout` block + unused imports, `middleware.test.ts` +admin-gate suite. Code `b9b1bb7c`. |
| 23 | PREFLIP-M4PRO | Retrofit MacMiniM4Pro pre-flip reference worktree + `peerloop-ref` alias | Conv 203 — **DO FIRST next conv.** Run the committed idempotent bootstrap `scripts/setup-preflip-ref.sh` on M4Pro to stand up the `~/projects/Peerloop-preflip` (:4331) reference worktree (worktree add `846bab9f^`/`608346a2` + `.dev.vars` copy + install + `db:setup:local:dev` + append `peerloop-ref` alias). Machine-local; the reference env currently exists only on M4. |
| 24 | STANDIN-MATT | Retrofit `@stand-in` pages to Matt-style (approach A) | ✅ COMPLETE (Convs 207-208, 212) — login/signup/onboarding/404 + /profile account-hub. Archived → [plan/COMPLETED.md](plan/COMPLETED.md). Detail → [plan/matt/standin-matt.md](plan/matt/standin-matt.md). Per-tab fidelity → [PROFILE-PRIM-SWEEP] (formerly [PROF-TAB-REDESIGN]; now W4 of the PRIM-REGISTRY block). **⚠️ Conv 234: 1 NEW `@stand-in` reintroduced** — `/course/[slug]/book` ([BOOK-ROUTE] tactical rehost: legacy `SessionBooking` wizard on the Matt shell). **⚠️ Conv 235: 1 MORE `@stand-in`** — root `/session/[id]` (ENROLL-NAV Prepare/Join 404 fix, legacy session room rehosted on the Matt shell). **✅ Conv 239 [SESS-GRAD]: `/session/[id]` graduated `@stand-in → @matt-inspired`** (merge — full legacy state machine re-skinned + static Matt Prepare surface; see [MATT-EXEC-PG2]). `/book` REMAINS `@stand-in` → graduates under [BOOK-WIZARD-MATT] (the booking-wizard Matt restyle, split out of [SESS-GRAD]). |
| 25 | ENROLL-NAV | Dual-zone course SubNav — Explore tabs + gated enrollment "Journey" zone | ✅ **BUILT Conv 235** (Scope A — whole state machine + rail + content port in one conv). Shipped: dual-zone `SubNav.astro` (divider + zone headers + done-✓ + muted disabled steps; flat callers unchanged), state-aware `buildCourseTabs(slug, journey)` (Benefits→Enroll Journey step; new enrolled-only **"My Sessions"** Explore tab), `computeCourseJourney()` state machine in `loaders/courses.ts` (Enroll→Payment→Book→Prepare/Join→Certificate; enrolled-only, +1 next-session query), new `MySessionsTab.astro` (`@matt-inspired`, SSR port of legacy SessionsTabContent). **Naming resolved:** Matt's "1:1 Sessions" label = the curriculum frame = existing Modules tab; the genuinely-dropped surface (student's personal *schedule*) ships as "My Sessions" in Explore, OUTSIDE the Journey. **2 review fixes:** rail added to `/success` (Payment step kept the nav); new root `/session/[id].astro` `@stand-in` (Prepare/Join was 404 — only `/old/session/[id]` existed; also fixes the same latent 404 in MyStudents/SessionHistory/StudentDashboard) carrying the course rail for the student viewer. 5 gates green (6460 tests); browser-verified as David. **⚠️ Conv 239: decision #5 + the "My Sessions in Explore" naming SUPERSEDED** — "My Sessions" moves INTO a two-tier Journey (one-time gates bracketing a recurring Sessions progress-cluster); reworked under [JOURNEY-LOOP] (DEFERRED #26). **Follow-ons:** [ENROLL-NAV-MATT-CONFIRM] (4 Matt divergences); mobile zone-divider rendering; Certificate step route (CERT-APPROVAL). → [plan/enroll-nav/README.md](plan/enroll-nav/README.md) |
| 26 | JOURNEY-LOOP | Two-tier course Journey — one-time gates + recurring Sessions progress-cluster | ✅ **BUILT Conv 240** (designed Conv 239; superseded ENROLL-NAV decision #5). Shipped the two-tier Journey: one-time **gates** (Enroll ✓ / Payment ✓ / Certificate) bracketing a recurring **Sessions cluster** (`kind:'cluster'` in `buildCourseTabs`) — meter "X/N" header (reuses the `@matt-inspired` ProgressBar) + indented children My Sessions / Book / Prepare-Join. "My Sessions" moved Explore→Journey; Certificate gates on `completed == total`. **No SQL/schema** — `computeCourseJourney()` already emitted the counts. New types `CourseTabNavLink`/`CourseTabNavCluster`; `SubNav.astro` active-matching walks cluster children. 5 gates green (suite 6459, +12 `tests/unit/journey-loop-tabs.test.ts`); prov:sweep unchanged at 6-error debt baseline; browser-verified as David on 3 routes. Overlap-dedup: rail is canonical; wizard copy reconciliation deferred to [CALENDAR2] (it rewrites the `@stand-in` wizard). `/book` dev-render gap = pre-existing `SessionBooking` React-dup dev quirk, not a regression (build renders it clean). Full detail → [plan/enroll-nav/README.md § EVOLVED + BUILT](plan/enroll-nav/README.md). |
| 27 | BOOK-WIZARD-MATT `[CALENDAR2]` | Matt restyle of the booking wizard (`SessionBooking`) | ✅ **COMPLETE Conv 242** — `/course/[slug]/book` graduated `@stand-in → @matt-inspired 622:15671`. MERGE per Matt phase-out (function-first; legacy = functional source of truth, Matt = skin): `SessionBooking.tsx` re-skinned to Matt tokens/primitives (Button/MattIcon) + Matt's date+time-**on-one-screen** pattern (month calendar + suggested-times pills); **every** legacy behavior preserved (teacher step, reschedule, invite "start now", all-booked, module banner, TZ display, error states Matt never designed); confirm step kept SEPARATE (user decision D1 — Matt's single-CTA drops non-happy-path content); status colors stay functional Tailwind (honest-orphan — Matt has no semantic error/success tokens). Inherited JOURNEY-LOOP step-6 dedup: success "Book Next" demoted to secondary vs the rail's canonical Book hub. Dev React-dup quirk clears (build renders clean). 5 gates green (suite **6458**, build clean, prov:sweep unchanged 6-debt); **SessionBooking.test.tsx rewritten** — the confirm/booking/success assertions were silently dead (broken mock time format → Invalid Date), now genuinely exercise day→time→Continue→Confirm→book (31/31). **`@stand-in` census in `src/pages/*.astro` now ZERO** — funnel fully `@matt-inspired` end-to-end. Surfaced `[TZ-AUDIT]` (server-UTC vs client-local date-bucketing) + `[OUTLINE-V4]` (✅ DONE Conv 244 — `outline-none`→`outline-hidden` ×4 in the SESS-GRAD booking files). Decisions → [plan/matt/calendar2.md](plan/matt/calendar2.md). |
| 28 | PLATO-REVIVE | Revive PLATO browser-mode after the route-flip | ✅ **DONE Conv 343** — buckets 1–3 + registry (Conv 342); **Conv 343:** member-directory `// LIVE-CONFIRM` markers resolved from source + all 4 walkthrough instances source-grounded against the redesigned pages (~50 `expect`/`pageAction` fixes). **Per-page validation became a port-audit:** 7 "missing UI" findings triaged vs legacy `608346a2` → **0 port regressions** (REDESIGN/NEVER-EXISTED only) + **3 backend-ready UI gaps** surfaced → `[PLATO-GAP]`. **Conv 344:** gaps built — A Follow + B creator self-certify + C/c1 per-module homework (5 gates GREEN, test 6697); c2 submission file-upload deferred → `[PLATO-GAP-C2]`. **Conv 345:** ✅ `[PLATO-GAP-C2]` built — homework-submission file upload (schema cols + R2 helpers + multipart submit + authed download route + student UI; 5 gates GREEN, test 6714; DOM-verified live + found/fixed a cache-leak; code `8aaaafaf`). **Conv 346:** ✅ `[HW-GRADE-UI]` built teacher-first — reviewer grading UI (NEW `GET /api/teaching/courses/[courseId]/homework` assignment-list endpoint + `HomeworkGradingPanel` + Homework tab in TeacherCourseView; +9 tests, test 6723, DOM-verified live); creator-side parity deferred → `[HW-GRADE-CREATOR]`. **Conv 347:** ✅ `[HW-GRADE-CREATOR]` built — thin "Submissions" tab in `CourseEditor` mounting the same `HomeworkGradingPanel` (no backend changes; endpoints already creator-authorized); 5 gates GREEN (test 6723), DOM-verified live. **Also Conv 347:** E2E strategy decided — `[E2E-GATE]` ✅ closed via the PLATO instanceFile-gate (3 static `Instance:` blocks → PLATO 10→13), `[E2E-MIG]` Playwright migration **dropped** (28 specs frozen as a journey reference), post-launch `[BROWSER-SMOKE-2B]` logged (`docs/decisions/06-testing-ci.md`). Baseline GREEN. Detail block below. |
| 29 | STICKY-DETAIL-P2 | Condensed pinned action bars on detail pages | ✅ **DONE Conv 360**. **Approach = merge-into-tab-strip:** opt-in `action` prop on `SubNav.astro` (+ exported `SubNavAction` type) surfaces the primary CTA in the already-sticky tab strip (right-aligned ≥md; full-width row on the mobile grid). **Top-bar layout only** — side-rail already pins the tab rail persistently, so the merged CTA is suppressed there (course carries its CTA in the vertical stepper; community in the header). **Reveal-on-stuck** (small inline-script + scoped `[data-reveal]/[data-stuck]` style, graceful no-JS fallback = always-visible): the strip CTA stays hidden until the bar actually pins (entity header scrolled off), so it doesn't stack a 3rd duplicate CTA under the hero at rest. Course (`/course/[slug]` via `CourseRail`): Enroll / Continue / Go-to-Session mirroring the `CourseHeader` hero states. Community (`/community/[slug]`): creator → Manage in the strip; **non-member → Join in the HEADER** (layout-independent, natural placement) — which **fixed a live gap** (the header CTA block was gated behind `membership`, so logged-in non-members had NO join affordance despite `FeedActivityCard`'s "Join to participate" linking here; wired to `POST /api/communities/[slug]/join` by an inline script mirroring Leave); member → Leave (header) only. Phase 1 shipped Conv 359. **Verified:** all 5 gates green + DOM-truth on `:4321` in BOTH layouts (course: hidden at rest → reveals pinned at `top:16` on scroll; community member→Leave only, non-member→header Join with correct POST wiring + no strip action; side-rail → action suppressed, header Join covers it). Course journey stepper stays non-sticky (Conv 359 Decision 5). Persistent enrollment-context strip (progress meter) NOT built — no room in the strip row; deferrable as a future micro-task. |

---

## ROLE-SEMANTICS

**Canonical role semantics (DECIDED Conv 252): split the two axes by purpose** — `can*` (permission) vs `is*`/`has*` (behavioral/state). Full canonical rule, the blast-radius audit + resolution (3 parallel Explore sweeps), and the resolution plan → **[plan/role-semantics/README.md](plan/role-semantics/README.md)**.

## ROLE-STUDIOS

**DECIDED (Conv 252): deconstruct `/dashboard` → role-focused workspaces (`/creating`, `/teaching`) + a cross-role progression-nudge layer.** Full decision record — the three cross-role needs, the two-kinds-of-role split, settled sub-decisions, Phase-0 resolutions, and the multi-conv implementation plan → **[plan/role-studios/README.md](plan/role-studios/README.md)** (nudge-phase detail in [plan/role-studios/phase-4-nudges.md](plan/role-studios/phase-4-nudges.md)).

## Cross-Conv Watch Tasks

Watch-type tasks that span multiple convs without a clear block home. Each lists an explicit trigger condition; they sit dormant until that condition fires. Consolidated Conv 211 from former Conv 150-157 / 179 / 206 drain sections. Watch-tasks already tracked in TodoWrite (`[DTUNE-WATCH]`, `[SKILL-DISCOVERY-AUDIT]`) are not duplicated here.

- [ ] **[AAP]** Astro dev-only absolute-filesystem path leak in `ClientRouter` `<script src>` — Astro 6.3.6/6.3.7 emits `<script type="module" src="/Users/jamesfraser/projects/Peerloop/node_modules/astro/components/ClientRouter.astro?astro&type=script&index=0&lang.ts">`. Root cause (v6: `compile.js:50`; **v7 confirmed Conv 402: `node_modules/astro/dist/vite-plugin-astro/compile.js:22`** — `SUFFIX += import "${compileProps.filename}?astro&type=script..."` where `compileProps.filename` is the absolute fs path; the v7 Rust-compiler swap changed `.astro`→JS compilation but NOT this vite-plugin dev-mode script-import wiring). Functionally a no-op (Vite serves 200 either way) but cross-machine portability hazard. **Scoped Conv 402: strictly DEV-ONLY — the production build is clean.** Verified `dist/client/` (browser bundle) has ZERO abs-path leaks; the `/Users/…` strings in `dist/server/*.mjs` are SSR-internal manifest metadata (`rootDir`/`outDir`/`.bin/astro`), never sent to the browser (prod pages SSR to `/_astro/*` hashed URLs). **No exact upstream issue exists** (searched — only related-but-different: withastro/astro#10198 node_modules resolution, #12804 ClientRouter script duplication). **Disposition: ACCEPT + keep this watch task** (dev no-op, prod-safe) — a local Vite-middleware workaround was judged over-engineering (Conv 402). **WAITING on upstream Astro fix — NOT fixed by Astro 7.** Conv 402 [ASTRO7] promotion re-ran the probe on the upgraded stack (astro 7.1.3 + vite 8.1.5): the leak persists — `type=script` src is still `src="/Users/jamesfraser/projects/Peerloop/node_modules/astro/components/ClientRouter.astro?astro&type=script&index=0&lang.ts"` (the `type=style` src is relative). So v7 did not carry the fix; still WAITING on upstream. Verification probe after each Astro upgrade: `curl http://localhost:4321/ | grep -oE 'src="[^"]*ClientRouter[^"]*"'` — non-absolute path = fixed. (Conv 163, retested 177; Astro-7 re-probe done Conv 402 — still leaking)

- [ ] **[PD]** Prod cron Worker deploy — block date 2026-04-28 has passed; verify whether prerequisites still hold when next picked up. (Conv 150 inception)

- [ ] **[RSC]** Conditional: pair `-c` with `-v` if MSI rsync ever gains `-v` for diagnostics — fires only on a specific edit to one of the three production rsync sites (`r-start/SKILL.md` Step 5.7 Phase 1, `r-commit/SKILL.md` Step 1.5, or `r-end/SKILL.md` Step 5b). Evaluated Conv 157: production rsync invocations don't use `-v`, so the cleaner-audit-logs benefit is invisible. Adding `-c` speculatively is over-engineering. Stays indefinitely until the trigger condition is met. (Conv 157)

- [ ] **[ASF]** Investigate `Astro.slots.has` + `&&` short-circuit interaction surfaced Conv 175 [MSH-VIZ] empty-pill bug. Conditional Fragment forwarding `<Fragment slot="x"><slot name="y" /></Fragment>` suppressed child's `<slot name="x">FALLBACK</slot>` even when slot `y` was empty; `Astro.slots.has` + `&&` short-circuit did not restore the fallback. Production workaround in place: defaults at the layout consumer via ternary inside unconditional Fragments. Root-cause investigation deferred — file an Astro issue or build a minimal repro if it bites again. Memory: `reference_astro_slot_forwarding.md`. (Conv 175)

- [ ] **[TDS-DRIFT]** `tech-doc-sweep` hook returned no recent changes despite the substantial `matt/*` additions across Convs 173-178. Investigate: drift baseline SHA at `.claude/.drift-baseline-sha` may be stale, or sweep matchers in `.claude/scripts/tech-doc-sweep.sh` may not detect `src/components/matt/*` / `src/styles/tokens-*.css` / `src/pages/matt/*` paths. Reproduce: `cat .claude/.drift-baseline-sha`, then `git -C ../Peerloop diff $(cat .claude/.drift-baseline-sha)..HEAD --stat -- 'src/components/matt/*' 'src/styles/tokens-*' 'src/pages/matt/*'`. (Conv 179)

- [ ] **[MEM-CAP]** Run `/r-prune-memory` when MEMORY.md auto-load utilization climbs above 80% (built Conv 213; **NOT** `/r-prune-claude`, which prunes the unrelated CLAUDE.md file). Conv 211 baseline 53% lines / 73% bytes; tripped 80% bytes Conv 213; **fired Conv 396** — 20304 B (79%) / 127 lines → 17979 B (70%) / 124 lines (biggest lever was NOT a pointer: the 5-line intro blockquote duplicating `CLAUDE.md §Memory`, which auto-loads anyway; both of that conv's big levers are now spent, so the next firing needs extraction or consolidation). Auto-load cap is 200 lines / 25 KB at every SessionStart (per `code.claude.com/docs/en/memory.md`); /r-start Step 5.7 Phase 2 emits a 🔴🔴🔴 alert at ≥80% on either axis. (Conv 179; skill + ref fix Conv 213)

- [ ] **[INV-PATH-FIX]** Sweep `.scratch/matt-figma/` references in code/docs → `.scratch/matt-main/`. `matt-figma` was the initial 229-file Figma export (Conv 169); `matt-main` is the curated 83-file build set (Conv 170 [MATT-ISOLATE]). Find with: `grep -rn 'matt-figma' docs/ && git -C ~/projects/Peerloop grep 'matt-figma' -- src/`. Replace path-by-path; verify each isn't an intentional historical reference. (Conv 179)

- [ ] **[COHERENCE-AMBIG-LOW]** Two LOW [AMBIGUITY] findings deferred for future calibration: §Critical Rule "multiple features" (unquantified threshold) and §Schema Discrepancy exception "unambiguously self-evident" (judgment-heavy). Accepted as natural judgment thresholds — revisit only if a concrete miscalibration appears. (Conv 206)

- [ ] **[GARBLE-WATCH]** Re-test the Conv-226 "garble" symptoms when an upstream Claude Code changelog fixes parallel tool-result delivery. Root-caused Conv 227 as an OPEN upstream bug cluster — harness parallel-tool cascade-cancel (#22264 → empty-in-UI then late/out-of-order delivery #63966/#63859/#63797) stacked with model confabulation (#63538); strongly correlated with Opus 4.8 + parallel batches + any one sibling failing (incl. our `guard-dangerous-bash.sh` PreToolUse block). Unfixed as of CC 2.1.159. Trigger: a changelog entry naming tool-result delivery / parallel-tool / cascade-cancel. Mitigation in place: verify suspicious-empty results out-of-band (cheap *different* probe), never re-spam identical calls, never narrate un-received output. Memory: `reference_term_garble_upstream_bug.md`. (Conv 227)

---

## BBB-RECORDING (Convs 159-161)

🔥 **ACTIVE** — Triggered by recording-gap in Conv 158 BBB testing. Conv 159: diagnosis confirmed `autoStartRecording` missing. Conv 161: **Blindside reply** — `getRecordings` requires `limit≤100` parameter (fixed both diagnostic surfaces); paginated `/admin/recordings` built with 2-call total derivation; all 7 user-facing recording-display surfaces verified on staging (1 of 8 orphaned recordings visible correctly). Conv 162: discovered 8th surface (TeacherTabContent My Sessions tab) and fixed it — verbatim mirror of student `SessionsTabContent` "Recording" affordance. Conv 163: [REC-LABEL] completed — shared `<RecordingLink>` component extracted, all 10 surfaces (8 + 2 admin added mid-conv) unified on Option B bordered-text "Recording" button; local dev seed now ships Sarah/Guy/Intro-to-n8n session with real Blindside `recording_url` (exact parity with staging); [DLE] investigation root-caused user-reported "loading errors" to existing [BR-NAVBAR-HYDRATE] (scope widened — not admin-only). Conv 164: [RV] 10-surface verification sweep confirmed all recording-button updates landed (Sarah/Guy/Brian role rotation, all 10 surfaces ✓). [BR-NAVBAR-HYDRATE] root-caused + fixed at AdminNavbar.tsx:90 via the established `isHydrated` flag pattern (single bug, single file — Conv 163 [DLE] "scope widened" was a misdiagnosis: the non-admin reproduction came from `data-astro-transition-persist` carrying the errored navbar across View Transitions, not a separate bug). [CRT] promoted to its own block. **Completed:** account-wide diagnostics, autoStartRecording fix deployed, paginated admin UI with 20-per-page paging, empirical UI verification on all surfaces, TeacherCourseView + TeacherTabContent recording-link bug fixes deployed to staging, 10-surface recording-link unification via `<RecordingLink>`, local dev seed parity with staging for recording flow, AdminNavbar hydration mismatch fixed.

**Subtasks:**

- [ ] **[BR-STATUS]** Add `sessions.recording_status` column with enum `none | requested | capturing | processing | published | failed` for richer post-session UI. Defer pending Blindside follow-up on server-level recording configuration + outcome of orphaned-recording investigation.

- [ ] **[BR-ZERO-REPRO]** Reproduce the 0-min empty-but-published recording state — external-blocked (needs fresh BBB test session). Prereq for [BR-STATUS] enum design (we need to know which post-session states are reachable in practice before fixing the column shape).

- [ ] **[VITE-DEPS-WATCH]** Watch for recurring Vite missing-chunk warnings during `npm run dev` / `npm run dev:staging` — watch-only; act if the warning recurs (i.e., trips dev server hot-reload or build). Carried from Conv 168 RESUME-STATE.

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

### PLATO-REVIVE — Revive PLATO browser-mode after the route-flip

✅ **DONE Conv 343.** Full revival plan + status log → [plan/plato/README.md](plan/plato/README.md#plato-revive).

### PLATO-SEQ — Waypoint-sequenced API+browser test architecture

🟢 Phases 1–4b done (Convs 379–385); only **Phase 4c** (agent-driven browser walker) remains, **post-launch-gated**. Full architecture + status log → [plan/plato/README.md](plan/plato/README.md#plato-seq).

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
- ✅ **RESOLVED Conv 390** — "Recommend for Certification" UI button (teacher side) built (`RecommendCertButton` on MyStudents + TeacherCourseView); `POST /api/me/certificates/recommend` now has UI consumers (was Conv-082 zero-consumer gap)
- ✅ **RESOLVED Conv 390** — Dashboard "Certification recommendation" attention item now links to an actionable `/teaching/students` (recommend action added there) (was Conv-082 dead-end)
- Two parallel certification paths (creator direct vs recommend/approve) with no unified admin visibility (Conv 082)

**→ PLATO (Post-MVP):**
- Create `post-enrollment` instance and `multi-student` scenario (design in `plato.md`)

### Standalone items

- [x] The Commons `member_count` denormalized counter out of sync — fixed in seed SQL via `UPDATE communities SET member_count=N` after inserts (Conv 108).
- [ ] Expired/invalid JWT session tokens — no test coverage (requires infra-level test changes to mock token expiry)

### Client decisions required

- [ ] Remove MyXXX pages (`/courses`, `/feeds`, `/communities`) — redundant with unified dashboard? Needs client confirmation.
- [ ] Home page differentiation for new members — currently shows same Twitter-like feed for everyone (Conv 067)


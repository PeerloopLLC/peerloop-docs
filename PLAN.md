# PLAN.md

This document tracks **current and pending work**. Completed blocks are in COMPLETED_PLAN.md.

---

## Block Sequence

### ACTIVE

| Block | Name | Status |
|-------|------|--------|
| CALENDAR | Platform Calendar — custom multi-view calendar component for all roles | 📋 PENDING |
| ADMIN-REVIEW | Admin System Review — testing gaps, UI consistency, cross-links, menu restructure | 📋 PENDING (promoted Conv 095) |
| COURSE-FOLLOWS | Course Follows — subscribe to course updates without enrolling | 📋 PENDING (promoted Conv 095). Schema exists (`course_follows`); no code. |
| PACKAGE-UPDATES | Package Version Upgrades — all dependencies current, new branch | ✅ COMPLETE (Convs 104-114, PR #26 merged into `staging`). CF Pages→Workers migration spawned as separate CF-WORKERS block and also complete. |

### ON-HOLD

| Block | Name | Notes |
|-------|------|-------|
| DEPLOYMENT | Deployment automation + prod cutover — spawned from CF-WORKERS | PAGES-DISCONNECT done (Conv 116). Staging green. Remaining: GHACTIONS, PROD, STAGING-DOMAIN. Deferred Conv 129 — no sub-block urgent. |
| INTRO-SESSIONS | Intro Sessions — free 15-minute pre-enrollment calls | Schema exists (`intro_sessions`); feature not built. Discovered in TERMINOLOGY review Session 348. |
| DEV-STAGING-SSR | `npm run dev:staging` React-SSR hook errors | Conv 122 root-caused: `@astrojs/cloudflare` 13 + `remoteBindings: true` loads two copies of React into SSR graph, `useState` is null on every React island. HTTP 200 still returned, islands recover on client hydration. No prod/build/test impact. Config fixes attempted (ssr.noExternal, resolve.dedupe) — both failed. Deferred indefinitely — workarounds: stage-deploy for bug repro, `wrangler d1 execute` for queries, or import staging data into local D1. |

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

### DEPLOYMENT.PROD — Production cutover

**Prerequisites (before first prod deploy):**
- [ ] Create the `peerloop` Worker in the Cloudflare Dashboard (Workers & Pages → Create → Worker → "Hello World" template → rename to `peerloop`). First `wrangler deploy` will overwrite the stub. *Note: the accidental `peerloop` Worker from Conv 114 was deleted; it no longer exists.*
- [ ] Confirm the prod KV `SESSION` namespace ID in `wrangler.toml` (`7605e3a3...`) is correct for the production account — verify in CF Dashboard that this namespace exists and is not a staging leftover. If wrong, create a new prod KV namespace and update the top-level `[[kv_namespaces]]` in `wrangler.toml`.
- [ ] Confirm prod D1 `peerloop-db` and R2 `peerloop-storage` resources exist and contain the intended production data (not test seed).
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
- [ ] Staging smoke test: `npm run dev:staging` end-to-end validate against remote staging D1/R2 — before final staging merge

### Codecheck Rule Follow-ups (discovered Conv 105 during [HW])

- [x] **[SF]** /w-codecheck rule: detect "error-captured-never-rendered" — grep-based check for `setError` without render. Implemented Conv 107. ([HD2] AST detector assessed as disproportionate — grep sufficient.)

### Test Hardening Follow-ups (discovered Conv 102)

*Surfaced during the `json<T>` sweep and pre-existing failure root-cause. Picked up opportunistically.*

- [x] **[AM]** Fixed `isSlotWithinAvailability` midnight-spanning bug — added `windowToUtc()` helper that advances end date by 1 day when `endTime <= startTime`. All 85 availability + 606 session tests pass — Conv 107
- [x] **[TT]** Swept `Date.now()+Nh` fragility in 5 high-risk test files — migrated to shared `futureUTC(days, utcHour)` helper in `tests/helpers/dates.ts`. 606/606 session tests pass — Conv 107
- [x] **[DH]** Dead helper audit — deleted 5 unused functions (`getResponseJSON`, `expectSuccess`, `expectError`, `expectJSONResponse`, `expectRedirect`) + `APIErrorResponse` interface from `api-test-helper.ts`, updated re-export index — Conv 107
- [x] **[VS]** Created `npm run verify` composite script chaining all five gates (`typecheck && check && lint && test && build`) — Conv 107

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

### MVP-GOLIVE.CRON-CLEANUP (absorbed Conv 095)

Currently `detectNoShows()` + `detectStaleInProgress()` + `reconcileBBBSessions()` run manually via admin. For production, add `scheduled()` handler.

- [ ] Investigate Astro + CF adapter dual exports (`fetch` + `scheduled`)
- [ ] Add `[triggers]` cron config to `wrangler.toml`
- [ ] Implement `scheduled()` handler (cleanup + BBB reconciliation)
- [ ] Notification batching (daily digest vs individual alerts)

### MVP-GOLIVE.STAGING-VERIFY (absorbed Conv 095)

Unified staging integration tests for all external services. Replaces BBB-VERIFY remaining items.

- [ ] Stream: verify feed creation + activity posting against staging app
- [ ] Resend: plus-addressed email capture (`fgorrie+{handle}@bio-software.com`), verify delivery
- [ ] Stripe: staging webhook end-to-end verification
- [ ] BBB: verify analytics callback, `getRecordings` format, full recording flow (webhook → cookie download → R2)

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

*Last Updated: 2026-04-19 Conv 137 — DOC-SYNC-STRATEGY block declared complete and archived. Phase 4 deliverables: tightened 4 chronic-noise matchers in docsRegistry (stream rule split, feed→feeds keyword fix, narrowed astro/ratings patterns, react-big-calendar isolated), expanded test suite 8→15 assertions, CI `doc-drift.yml` GH Actions workflow (PR/push-to-main cross-repo checkout), stored baseline pattern (`.drift-baseline-sha` + `advance-drift-baseline.sh` + `/r-end` auto-advance). DEPLOYMENT.GHACTIONS checklist updated: `DOCS_REPO_PAT` added alongside `CLOUDFLARE_API_TOKEN`. Two Phase-2 deferred follow-ups folded into POLISH.TECHNICAL_DEBT: `detect-changes.sh`/`dev-env-scan.sh` consolidation + `resend.md` full template-table resync.*

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

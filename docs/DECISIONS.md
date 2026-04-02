# DECISIONS.md

This document contains all active architectural and implementation decisions for the Peerloop project. Decisions are organized by impact level and category. When decisions conflict, the most recent one wins and supersedes earlier decisions.

**Last Updated:** 2026-04-02 Conv 077 (DOM-based toast for Astro React islands)

---

## How This Document Works

- **Latest Wins:** If a newer decision contradicts an older one, only the newer decision appears here
- **Organized by Impact:** High-impact decisions (architecture, database) appear first
- **Dates Included:** Each decision shows when it was made for audit purposes
- **Source:** Consolidated from session decision files in `docs/sessions/`

---

## 1. Architecture & Design (Highest Impact)

### Docs-Primary Claude Code Architecture (Implemented)
**Date:** 2026-02-20 (Session 229 planned, Session 232 implemented)

All documentation (~899 files, ~19 MB) migrated from code repo to `peerloop-docs` companion repo (https://github.com/PeerloopLLC/peerloop-docs). Claude Code launches from docs repo with `--add-dir ../Peerloop`. Code repo reduced from 27.6 MB to 8.6 MB (69% reduction).

**Architecture:** `peerloop-docs/` is CC home (.claude/, CLAUDE.md, docs/, planning files). `Peerloop/` is clean code repo with symlink (`docs → ../peerloop-docs/docs`) for build-time dependencies.

**Launch:** `cd ~/projects/peerloop-docs && claude --add-dir ../Peerloop`

**Setup:** Run `scripts/link-docs.sh` once per machine to create symlinks.

**Rationale:** Keeps shipping codebase clean. Docs repo doubles as Obsidian vault. Symlinks transparent to Node.js/Vite/Astro (build + all 4891 tests pass). `--add-dir` provides full tool access to code repo.

**See:** Session 232 Decisions.md for full option analysis.

### Three Separate Navigation Sets
**Date:** 2025-12-26

Maintain three architecturally separate header/footer component sets:
- **Public:** `PublicHeader`, `PublicFooter` (LandingLayout)
- **Gated:** `GatedHeader`, `GatedFooter` (AppLayout)
- **Admin:** `AdminSidebar` (AdminLayout - SPA pattern)

**Rationale:** Gives designer flexibility; Admin uses completely different pattern (SPA with left sidebar); cleaner separation of concerns.

### Role Switching via User Dropdown
**Date:** 2025-12-26

Keep role navigation in user avatar dropdown submenu, not top-level headers.

**Rationale:** Top-level role menus have real estate issues; crowded on mobile; simpler for MVP.

### Discover Panel Routes via `/discover/*`
**Date:** 2026-02-03 (Session 173), updated 2026-03-28 (Conv 042)

The DiscoverSlidePanel links to `/discover/*` routes for browsing public content within the app shell:

- `/discover/courses` - Course browse (role-aware: visitors see public view, members see role-specific tabs)
- `/discover/course/[slug]` - Course detail (role-aware, with bookmarkable tab sub-routes via `[...tab].astro`)
- `/discover/creators` - Creator listing (CRLS)
- `/discover/teachers` - Teacher directory (STDR)
- `/discover/students` - Student directory (new)
- `/discover/leaderboard` - Community leaderboard (LEAD)
- `/discover/communities` - Community browse (future)

**History:** `/discover/courses` was originally a non-role-aware browse page. Conv 042 promoted the experimental `/explore/*` role-aware pages to `/discover/*`, replacing the old browse page. The `/explore/` namespace was deleted entirely. `/course/[slug]` remains as-is pending client confirmation.

**Rationale:** PAGES-MAP.md represents pre-client-change design. The `/discover/*` namespace provides clear organization for browsing pages within the new app shell architecture. Single authoritative route per resource type — the role-aware version is strictly superior (visitors see the same content, members get role-specific tabs).

**See:** `src/components/layout/DiscoverSlidePanel.tsx`, `src/pages/discover/`

### Singular Resource Routes Convention
**Date:** 2026-02-03 (Session 175)

Individual resource pages use singular nouns; collection pages use plural:

| Pattern | Example | Description |
|---------|---------|-------------|
| `/discover/{plural}` | `/discover/creators` | Browse/listing pages |
| `/{singular}/[param]` | `/creator/[handle]` | Individual resource |
| `/{singular}/[param]/{action}` | `/course/[slug]/learn` | Resource sub-routes |

Current routes:
- `/creator/[handle]` - Creator profile (CPRO)
- `/teacher/[handle]` - Teacher profile (STPR)
- `/course/[slug]` - Course detail (CDET)
- `/course/[slug]/learn` - Course content (CCNT)
- `/course/[slug]/book` - Session booking (SBOK)

API routes remain plural (`/api/courses/`, `/api/creators/`) as a separate namespace.

**Rationale:** REST convention distinguishes collections from resources; shorter, more shareable profile URLs; profile pages are destinations, not discovery.

**See:** `src/pages/creator/`, `src/pages/teacher/`, `src/pages/course/`

### Activity vs Resource Route Namespaces
**Date:** 2026-02-04 (Session 177)

Dashboard and tool pages use **activity namespaces** (verb/gerund form), while public profile pages use **resource namespaces** (noun form):

| Namespace | Purpose | Examples |
|-----------|---------|----------|
| `/creating/*` | Creator's dashboard & tools | `/creating`, `/creating/studio`, `/creating/earnings` |
| `/teaching/*` | Teacher's dashboard & tools | `/teaching`, `/teaching/earnings`, `/teaching/students` |
| `/learning/*` | Student's dashboard & tools | `/learning` (future) |
| `/creator/*` | Creator profiles (public) | `/creator/[handle]` |
| `/teacher/*` | Teacher profiles (public) | `/teacher/[handle]` |
| `/course/*` | Course resources (public) | `/course/[slug]`, `/course/[slug]/book` |

Activity namespaces communicate "what I'm doing" and group related tools. Resource namespaces are for viewing public content.

**Rationale:** Clear separation between private dashboard tools and public profile pages; intuitive mental model; consistent with singular resource convention.

**See:** `src/pages/creating/`, `src/pages/teaching/`

### Teacher Course Detail Route: `/teaching/courses/[courseId]`
**Date:** 2026-03-25 (Conv 030)

Per-course teacher detail page uses `/teaching/courses/[courseId]` (activity namespace), not `/course/[slug]/teach` (resource namespace). Keeps the teacher in their workspace, consistent with all other `/teaching/*` routes. Uses courseId (not slug) for direct DB lookups.

**Rationale:** Activity namespace consistency; simpler auth model (all `/teaching/*` requires teacher auth); natural breadcrumb (Teaching → Course Name).

### Dedicated Teacher Resources API (Not Shared with Students)
**Date:** 2026-03-25 (Conv 030)

Teacher resources use a dedicated `GET /api/teaching/courses/[courseId]/resources` endpoint rather than extending the existing `/api/courses/[id]/resources` (which requires enrollment). The teacher endpoint includes module grouping with `module_order` and `download_count` not in the student API.

**Rationale:** Allows the teacher resources interface to evolve independently. Isolates teacher auth from student enrollment checks. Avoids widening an existing gate that was intentionally scoped to enrolled students.

### Community/Feed 1:1 Mapping
**Date:** 2026-02-04 (Session 181)

Each community has exactly one feed. The community page IS the feed. Post categorization uses tags instead of separate feeds.

| Entity | Feed Pattern |
|--------|-------------|
| Community | `community:{community_id}` - tagged posts |
| Course | `course:{course_id}` - enrolled students only |

Tag filtering via query params: `/community/the-commons?tag=announcements`

**Rationale:** Simpler data model (no separate feed entity); tags more flexible than multiple feeds; routing simplification.

**See:** `docs/as-designed/url-routing.md` (Community & Feed Architecture section), `docs/requirements/rfc/CD-036/`

### Community Routes: Hub + Subroute Tab Pattern
**Date:** 2026-02-05 (Session 186, supersedes Session 181)

Communities use the "bare = my" pattern with URL-aware tabs via subroutes:

| Route | Purpose |
|-------|---------|
| `/community` | My Communities hub (mirrors FeedSlidePanel) |
| `/community/[slug]` | Community Feed tab (default) |
| `/community/[slug]/courses` | Community Courses tab |
| `/community/[slug]/resources` | Community Resources tab |
| `/community/[slug]/members` | Community Members tab |
| `/discover/communities` | Find communities to join |

The Commons (`isSystem: true`) redirects `/community/the-commons/courses` to `/community/the-commons` since system communities don't have courses.

**Rationale:** Subroutes provide bookmarkable URLs, browser history integration, and SSR-compatible tab selection (matching the `/course/[slug]/feed` pattern). CommunityTabs receives `initialTab` prop and uses `pushState` for tab navigation.

**See:** `src/pages/community/[slug]/`, `src/components/community/CommunityTabs.tsx`, `docs/as-designed/url-routing.md`

### Aggregated `/feed` Timeline via Stream Follows
**Date:** 2026-02-05 (Session 189)

The `/feed` route displays an aggregated timeline combining posts from all sources the user follows. Uses Stream.io's `timeline:{userId}` feed which aggregates content based on follow relationships.

| Event | Stream Action |
|-------|---------------|
| User enrolls in course | `timeline:userId` follows `course:courseId` |
| User joins community | `timeline:userId` follows `community:slug` |
| User registers | `timeline:userId` follows `community:the-commons` |

FeedSlidePanel shows "Home Feed" as top item linking to `/feed`. Individual feeds (community pages, course feeds) remain accessible below.

**Rationale:** Modern UX expectation; reduces friction to catch up on all activity; Stream has built-in timeline aggregation via follows; The Commons auto-follow ensures new users see activity immediately.

**See:** `src/pages/feed.astro`, `src/lib/stream.ts` (follow/unfollow methods), `src/lib/onboarding.ts`

### No Creator Feeds - Use Communities Instead
**Date:** 2026-02-04 (Session 183)

All feeds are either community feeds or course feeds. There are no personal user or creator feeds.

| Feed Type | Route | Description |
|-----------|-------|-------------|
| Community | `/community/[slug]` | Community page IS the feed |
| Course | `/course/[slug]/feed` | Course discussion for enrolled students |
| ~~Creator~~ | ~~`/creator/[handle]/feed`~~ | **Removed** - creators create communities |

Creators who want announcement feeds should create a community (e.g., "Guy's Main Hall") with no courses, just feed and resources.

**Rationale:** Single feed concept simplifies mental model; avoids slippery slope (if creators have feeds, why not all users?); communities provide built-in structure (members, resources, progressions).

**See:** `FeedSlidePanel.tsx` (shows Communities + Course Feeds only)

### Bookmarkable Feed Tabs via Sub-Routes
**Date:** 2026-02-04 (Session 183)

Course feed tabs are implemented as sub-routes that render the same page with different active tabs (GitHub/Notion pattern):

| Route | Active Tab |
|-------|------------|
| `/course/[slug]` | About (default) |
| `/course/[slug]/feed` | Feed |
| `/course/[slug]/curriculum` | Curriculum (enrolled only) |

URL changes via `pushState` when clicking tabs; back/forward navigation works.

**Rationale:** Bookmarkable and shareable URLs; clean paths without query params; follows established patterns.

**See:** `CourseTabs.tsx`, `/course/[slug]/feed.astro`

### Progressions: Community → Progression → Course Chain
**Date:** 2026-02-04 (Session 182)

Courses belong to progressions, progressions belong to communities. This creates a three-level hierarchy for learning content organization:

| Entity | Belongs To | Contains |
|--------|------------|----------|
| Community | (top-level) | Progressions, Resources, Members |
| Progression | Community | Courses (ordered sequence) |
| Course | Progression | Sessions, Content |

Progression badges:
- `learning_path` - Multi-course sequence (e.g., "AI Fundamentals" with 2 courses)
- `standalone` - Single course (e.g., quick intro courses)

**Rationale:** Enables learning paths with course sequencing ("Course 2 of 3"); allows course copying between progressions; cleaner than direct community→course relationship.

**See:** `migrations/0001_schema.sql` (progressions table), `docs/requirements/rfc/CD-036/`

### Astro File Pattern: Flat Unless Sub-Routes Needed
**Date:** 2026-02-04 (Session 180)

Use flat files (`route.astro`) by default for Astro pages. Only use folder pattern (`route/index.astro`) when:
- Route has sibling files (e.g., `settings/index.astro` with `settings/profile.astro`)
- Route has dynamic params with sub-routes (e.g., `course/[slug]/learn.astro`)

| Pattern | When to Use |
|---------|-------------|
| `route.astro` | Leaf routes with no sub-routes |
| `route/index.astro` | Hub routes with siblings or dynamic params |

**Rationale:** Flat files reduce nesting, are easier to scan in file explorer, and make the file tree mirror the URL tree more directly. Astro produces identical routes for both patterns.

**See:** `src/pages/discover/`, `src/pages/course/[slug]/`

### Dashboard as Homepage
**Date:** 2026-01-29 (Session 145)

The homepage (`/`) now shows the dashboard layout (DashLayout) for all users—visitors and authenticated. Marketing content moved to `/welcome` (WELC).

- `/` - Dashboard hub (was `/dash`, now homepage)
- `/welcome` - Marketing landing page (was `/`)
- `/dash/*` sub-routes remain (`/dash/discover`, `/dash/courses`, `/dash/messages`, etc.)
- Uses `DashLayout.astro` with `DashNavbar.tsx` React island
- Role-aware menu items (Visitor, Student, Teacher, Creator)
- Two slide-out panels: FeedSlidePanel (full-height), MoreSlidePanel (smaller)
- Visitor-friendly: no auth redirect, shows marketing CTAs

**Rationale:** Dashboard-first experience shows the product immediately; marketing content preserved for campaigns.

**See:** `src/pages/index.astro`, `src/pages/welcome.astro`, `src/layouts/DashLayout.astro`

### Role-Based Home Page Landing
**Date:** 2026-02-01 (Session 155)

Users landing on `/` are automatically directed based on their role:

| User Type | Landing Action |
|-----------|---------------|
| Visitor | Auto-open Discover slideout |
| Student (no special roles) | Auto-open Feeds slideout |
| Teacher / Creator | Redirect to `/workspace` |
| Admin | Redirect to `/messages` |

Additionally, Admins see a "To Admin" navbar item (after "More") linking to `/admin`.

**Rationale:** Tailors the home experience to each user's primary action without adding a new "Home" navbar item. Reuses existing navigation destinations.

**See:** `src/components/layout/AppNavbar.tsx` (role-based useEffect)

### CurrentUser Global State Architecture
**Date:** 2026-02-03 (Session 171, expanded from Sessions 145, 161)

Use a `CurrentUser` class singleton stored on `window.__peerloop.currentUser` for shared user state across Astro islands.

- Single `/api/me/full` endpoint returns user identity + all course relationships + profile data
- Stale-while-revalidate: hydrate from localStorage instantly, refresh from API in background
- Course-aware role methods: `isTeacherFor(courseId)`, `isCreatorFor(courseId)`
- Explicit courseId parameters (not implicit from URL)

**Comprehensive user data (Session 171):**
- Identity: `id`, `email`, `name`, `handle`, `title`, `avatarUrl`
- Bios: `bioShort` (tagline), `bioFull` (detailed), `teachingPhilosophy`
- Contact: `website`, `location`, `linkedinUrl`, `twitterUrl`, `youtubeUrl`
- Settings: `privacyPublic`, `emailVerified`
- Capabilities: `canCreateCourses`, `canTakeCourses`, `canTeachCourses`, `canModerateCourses`, `isAdmin`
- Stats: `studentsTaught`, `coursesCreated`, `coursesCompleted`, `averageRating`, `totalReviews`
- Profile: `expertise[]` (tags), `qualifications[]` (sentences with display order)
- Stripe Connect (Session 255): `stripeAccountId`, `stripeStatus`, `stripePayoutsEnabled`, `hasStripeConnected()`

**Architectural principle:** CurrentUser is a **read-only convenience cache**, not a source of truth. Components read it for UI decisions (show/hide, badges, prompts). API endpoints always derive identity from the JWT session and query the DB — they never trust client-sent CurrentUser data. Stale data is a UX issue, not a security concern.

**Rationale:** Storage is abundant (~5MB localStorage limit, user data <10KB), network calls are expensive (latency, loading spinners), user profile data is stable within a session. Load everything once at login, use everywhere - eliminates API calls for own profile display.

**See:** `src/lib/current-user.ts`, `src/pages/api/me/full.ts`, `docs/as-designed/state-management.md`

> **Insight:** This follows a "summary vs. detail" pattern common in client-side caching. CurrentUser carries the summary (status, boolean flags, IDs) for instant UI decisions — "should I show this button?" Detailed settings pages still need their own API for the full picture (e.g., Stripe requirements, disabled reasons). The rule of thumb: if the data answers a yes/no question across multiple pages, cache it; if it's only needed on one page, fetch it there. (Session 255)

### CurrentUser Data Freshness - Window Focus Refresh
**Date:** 2026-02-01 (Session 156)

When a user returns to the browser tab, `refreshCurrentUser()` is called to fetch fresh data from `/api/me/full`. This catches external changes (admin grants capability, creator certifies ST) that occurred while the user was away.

**Implementation:** Window focus event listener in `AppNavbar.tsx`.

**Options Considered:**
1. Page navigation only (already implemented)
2. Window focus refresh ← Chosen
3. Periodic polling
4. Lightweight version check endpoint
5. SSE/WebSocket push

**Rationale:** Simple (5 lines), no server changes, covers main scenario (user away while admin makes changes). Page navigation already refreshes on route change. Polling/push are overkill for MVP.

**Note:** Client state is optimistic UI; server always validates permissions on API calls. Stale client state is a UX issue, not a security issue.

**See:** `src/components/layout/AppNavbar.tsx`, `docs/as-designed/state-management.md`

### CurrentUser Cache Structural Guard
**Date:** 2026-03-09 (Session 362)

LocalStorage cache of `MeFullResponse` is validated with `isValidCachedData()` before hydrating the `CurrentUser` singleton. Checks 6 critical fields (`user.id`, `user.name`, `user.handle`, `enrollments`, `teacherCertifications`, `createdCourses`). If validation fails, cache is silently discarded and the UI shows a brief loading skeleton until the API refresh completes.

**Trigger:** After a staging deploy, the AppNavbar flashed briefly then disappeared for users with existing localStorage data. The cached `MeFullResponse` had an incompatible shape — `JSON.parse()` succeeded but React rendered `undefined` fields as empty, causing the flash-then-vanish.

**Options Considered:**
1. Build version key — invalidate all caches on every deploy
2. Full schema validation — check every field
3. Structural guard — check only constructor-critical fields ← Chosen

**Rationale:** Build version key penalizes all users on every deploy. Schema validation creates maintenance burden. Structural guard is self-healing, zero-config, and only triggers on actual structural mismatch. Semantic staleness (correct shape, stale values) is already handled by the background API refresh.

**See:** `src/lib/current-user.ts` (`isValidCachedData`), `tests/lib/current-user-cache.test.ts`, `docs/as-designed/state-management.md` (Cache Structural Guard section)

> **Insight:** The stale-while-revalidate pattern is great for perceived performance but creates this class of bug when the API contract changes across deploys. The structural guard is the minimum viable protection — it doesn't prevent all stale data (that's the API refresh's job), it only prevents the UI from crashing on structurally incompatible data. This is the same principle behind defensive JSON parsing in any client that caches API responses. (Session 362)

### CurrentUser Version Polling for Server-Side Change Detection
**Date:** 2026-03-19 (Conv 013)

Monotonic `data_version` counter on the `users` table, bumped by mutation endpoints that change CurrentUser-relevant data. Client polls `GET /api/me/version` every 30 seconds. Version mismatch triggers `refreshCurrentUser()`.

**Rationale:** CurrentUser had no mechanism to detect external changes (admin actions, other users' enrollments, incoming messages). Dashboard API calls were serving as the de facto freshness mechanism. Version polling is the simplest approach — one column, one endpoint, one `setInterval`. Compatible with future SSE/WebSocket upgrade.

**Scope:** Only bumps for data CurrentUser carries (identity, capabilities, enrollments, certs, courses, stats, moderations, unread counts). Does NOT bump for operational data (session schedules, earnings, feed activity) — those are fetched by dashboard APIs at navigation time.

**See:** `src/lib/user-data-version.ts`, `src/pages/api/me/version.ts`, `docs/as-designed/state-management.md` (Version Polling section)

> **Insight:** This is the Meteor DDP pattern minus the push transport. Meteor's oplog tailing was just *detecting* changes — the clever part was reactive propagation. We already have reactive propagation (`setCurrentUser` → `notifyListeners` → `useCurrentUser` re-renders). The version counter is the simplest possible change detector. (Conv 013)

### CurrentUser "Consume What's Loaded" Principle
**Date:** 2026-03-19 (Conv 013)

If CurrentUser already loads data (for any reason), consume it from CurrentUser rather than re-fetching. Dashboard endpoints remain for operational/transactional data (earnings, session schedules, pending counts) that CurrentUser doesn't carry.

**Supersedes:** The earlier "summary vs. detail" rule from Session 171: *"If data answers a yes/no question across multiple pages, cache it. If it's only needed on one page, fetch it there."* That rule created a blind spot where dashboards re-fetched data CurrentUser already loaded for permission checking.

**Applied:** StudentDashboard refactor (Phase 2) will consume `useCurrentUser().getEnrollments()` instead of `fetch('/api/me/enrollments')`. TeacherDashboard and CreatorDashboard keep their endpoints (operational data is genuinely unique).

**See:** `docs/as-designed/state-management.md` (Principle section)

### Dashboard Data Flow: CurrentUser for Identity, API for Transactional
**Date:** 2026-03-26 (Conv 033)

All dashboards use `useCurrentUser()` for identity (name, handle, capabilities). Dedicated API endpoints return only transactional data (earnings, stats, pending counts, rosters). `is_available` stays in the teacher API response as operational state, not identity.

**Refines:** The "Consume What's Loaded" principle above. Conv 033 applied it uniformly: TeacherDashboard and CreatorDashboard were refactored to stop re-fetching identity from their APIs. API responses trimmed accordingly.

**Rationale:** Consistent pattern across all 4 dashboards (/learning, /teaching, /creating, /dashboard). Eliminates redundant identity fields in API payloads. Clear boundary: if CurrentUser has it, use it; if it's transactional, fetch it.

**See:** `src/components/dashboard/TeacherDashboard.tsx`, `src/components/dashboard/CreatorDashboard.tsx`

### Global State Pattern for Cross-Island Communication
**Date:** 2026-02-01 (Session 157)

Use global state on `window.__peerloop` with custom events for features that need to work across Astro React islands. This extends the CurrentUser pattern to other cross-cutting concerns.

**Applied to:** Login modal (can be triggered from any React island, executes callback after login)

**Pattern:**
- Store state on `window.__peerloop.{feature}`
- Dispatch custom events on state change (`peerloop:{feature}:change`)
- Components subscribe to events and re-render
- Pending callbacks stored globally, executed after completion

**Rationale:** Astro's multi-island architecture means each `client:load` React component is a separate React root. React Context cannot be shared between islands. Global state with events matches the established `currentUser` pattern.

**See:** `src/lib/auth-modal.ts`, `src/lib/current-user.ts`

### Admin Approach - Hybrid
**Date:** 2025-12-29

Use hybrid approach: Dedicated `/admin/*` routes + inline Context Actions.

**Rationale:** Admin dashboard for complex tasks; inline Context Actions for quick access while browsing public pages.

### Component Folder Organization: ui/, layout/, domain/
**Date:** 2026-02-01 (Session 153)

Component folders follow a "who + what" mental model:

```
src/components/
├── ui/                      # Design system primitives (charts, future: buttons, modals)
├── layout/                  # App shell (AppNavbar, Header, Footer, slide panels)
├── creators/
│   ├── profiles/            # Public-facing display
│   └── studio/              # Authoring tools
├── teachers/
│   ├── profiles/            # Public-facing display
│   └── workspace/           # Management tools
└── marketing/               # Visitor-facing (includes welcome/)
```

**Naming convention for domain subfolders:**
- `profiles/` - Public display components (cards, browse, profile views)
- `studio/` - Content authoring (editors, creation tools)
- `workspace/` - Task management (availability, earnings, sessions)

**Rationale:** Eliminates "which folder?" cognitive overhead. Names answer "who uses this?" (domain folder) and "what purpose?" (subfolder). Self-documenting import paths.

**See:** `src/components/` structure, Session 153 Decisions.md

### Context Actions Design
**Date:** 2025-12-29

- Icon-only trigger (no text label)
- Navigation to admin pages (no inline forms on public pages)
- Role-aware with sections for Admin, Creator, Teacher
- Build admin pages first (8.1-8.8), Context Actions on top (8.9)

**Rationale:** Security (privileged components not rendered for non-privileged users); simplicity (forms only in admin area).

### Explicit Feed Creation Model (Stream.io)
**Date:** 2026-01-20

Community feeds (Course Discussion, Instructor Feed) require explicit creator action to enable. Feeds are not auto-created when courses or creators are created.

- Course Discussion: Creator enables via Course Studio/Settings
- Instructor Feed: Creator enables via profile/settings
- Database flags: `discussion_feed_enabled`, `instructor_feed_enabled`
- Stream feed only created on first enable; disable hides but preserves data

**Rationale:** Resource control (not every course needs discussion); creator intent (opt-in signals commitment to moderate); Stream costs (only create feeds that will be used); progressive disclosure.

**See:** `src/pages/api/courses/[slug]/discussion-feed.ts`, `src/pages/api/me/instructor-feed.ts`

### Dedicated Stream Feed Groups
**Date:** 2026-01-20

Use dedicated feed groups in Stream Dashboard for each feed type instead of sharing a single group with ID prefixes.

- `townhall` - Main community feed (Town Hall)
- `course` - Course discussion feeds (`course:{courseId}`)
- `instructor` - Instructor feeds (`instructor:{userId}`)
- `notification` - User notifications
- `user`, `timeline`, `timeline_aggregated` - User-specific feeds

**Rationale:** Cleaner feed IDs; independent group configuration; eliminates client-side filtering; better separation of concerns.

**See:** `docs/reference/stream.md`, Stream Dashboard Feed Groups

### Stream Chat for Private Messaging
**Date:** 2026-01-21

Use Stream Chat for private messaging between students, teachers, and creators. This aligns with the existing Stream.io integration for activity feeds.

**Rationale:** Client directive; consistent with existing Stream Feeds integration; reduces vendor complexity (single real-time provider); proven scalability; feature-rich (typing indicators, read receipts, reactions, threads).

**See:** `docs/as-designed/messaging.md`

### BigBlueButton for Video Conferencing
**Date:** 2026-01-20

Use BigBlueButton (BBB) as the video conferencing platform for tutoring sessions, implemented via VideoProvider abstraction.

- VideoProvider interface in `src/lib/video/types.ts`
- BBB adapter in `src/lib/video/bbb.ts`
- Environment: `BBB_URL`, `BBB_SECRET`
- Sessions table: `bbb_meeting_id`, `bbb_internal_meeting_id`, `bbb_attendee_pw`, `bbb_moderator_pw`

**Rationale:** Client (Brian) chose BBB over PlugNmeet for video platform. VideoProvider abstraction allows future swapping if needed.

**See:** `docs/reference/bigbluebutton.md`, `src/lib/video/`

### Homepage Landing Strategy (RESOLVED)
**Date:** 2026-01-29 (Session 145)
**Status:** Resolved - Option 2 chosen

Client decided to use the app itself as the landing page. Dashboard at `/`, marketing at `/welcome`.

**Decision:** Option 2 - App as Landing
- `/` shows DashLayout (dashboard) for all users
- `/welcome` contains marketing content (moved from old `/`)
- Marketing components (`src/components/home/`) still used at `/welcome`

**See:** "Dashboard as Homepage" decision above

### Session Booking Flow — Target Design
**Date:** 2026-03-04 (Session 325), updated 2026-03-05 (Session 331)

Defined the target booking flow for multi-session courses:
- **Single session:** Student selects course → teacher already known from enrollment (skip selection) → go directly to availability for next unbooked module
- **Multi-session:** After confirming, success screen offers "Book Next Session" → advances to next unbooked module in `module_order` sequence
- **Module ordering:** Positional — modules assigned by chronological order of booked sessions, not stored at booking time. See "Positional Module Assignment" decision in Database section.
- **Session limit:** API enforces `completed + scheduled < module count`; 422 when all modules have sessions
- **Cancellation policy (Session 333):** Always allowed (per CD-033: "bail at anytime"). Late cancellations (< 24h before start) require a reason, sent to teacher as in-app notification. `is_late_cancel` flag saved for admin visibility. `cancelled_at` timestamp recorded.
- **Reschedule limit (Session 333):** Max 2 reschedules per session. 3rd attempt returns 422 with guidance to cancel and rebook. `reschedule_count` tracked per session; `can_reschedule` flag in GET response.
- **Rebooking guard (Session 333):** `POST /api/sessions` rejects if `enrollment.status` not in `('enrolled', 'in_progress')` — returns 403.
- **Mark Complete gating (Session 333):** Module completion button disabled until the module's tutoring session is `completed`. Contextual hints: "Book a session first" (linked) / "Session scheduled for [date]" / enabled. Uses existing `GET /api/sessions` with client-side module→status mapping.
- **Session completion healing (Session 334):** Teachers and creators can manually mark sessions complete via `POST /api/sessions/[id]/complete` when BBB webhook fails. Guards: must be `teacher_id` or `creator_id`, `scheduled_end` must be past. All completion paths (webhook, manual, admin) use shared `completeSession()` function.

**Rationale:** The enrollment already establishes the teacher. Modules define session content. The booking wizard should reflect both rather than requiring re-selection. Cancellation/reschedule policies balance student freedom (CD-033) with teacher accountability.

**See:** `docs/as-designed/session-booking.md`, `src/lib/booking.ts`

### Platform Terminology: GLOSSARY.md as Source of Truth
**Date:** 2026-03-05 (Session 346)

Created `GLOSSARY.md` at docs repo root as the single prescriptive source of truth for all platform terminology. Covers identity hierarchy, core domain terms, DB table naming, component naming, and URL routes. If code contradicts the glossary, the code is the bug.

**Rationale:** Naming inconsistencies ("Student-Teacher" vs "Teacher," "user" vs "member") had cascaded into schema ambiguities, code bugs (the `/discover/teachers` duplication), and documentation drift. A dedicated glossary prevents recurrence by establishing rules before code is written.

**See:** `GLOSSARY.md`

### "Teacher" Replaces "Student-Teacher" Platform-Wide
**Date:** 2026-03-05 (Session 346)

The term "Student-Teacher" (and abbreviations "S-T", "ST") is retired. Use "Teacher" everywhere — schema, code, components, API routes, UI text, documentation. Since all teachers on Peerloop are former students (that's the flywheel), the "student" prefix is redundant and confusing.

**Trigger:** `student_teachers` table name made rows look like people instead of certifications, causing a JOIN bug. The broader naming ("STCard", "st-sessions", "student_teacher_id") compounded the confusion.

**Consequence:** `student_teachers` table → `teacher_certifications`. Components: `ST*` → `Teacher*`. Routes: `/api/student-teachers/*` → `/api/teachers/*`. User story IDs (US-T###) stay frozen.

**See:** `GLOSSARY.md` §1, PLAN.md TERMINOLOGY block

### Identity Hierarchy: Visitor → Member → Student → Teacher → Creator
**Date:** 2026-03-05 (Session 346)

Formal identity hierarchy: **Visitor** (unauthenticated) → **Member** (has account) → **Student** (enrolled) → **Teacher** (certified) → **Creator** (creates courses). These are progressive and non-exclusive — one person can hold multiple roles simultaneously.

In code: `users` table and `user`/`userId` stay (universal auth convention). In UI text: "member" for authenticated, "visitor" for unauthenticated. Never call a non-logged-in person a "user" in UI text.

**Rationale:** The hierarchy maps to the Peerloop flywheel. Clear definitions prevent code that conflates different identity levels.

**See:** `GLOSSARY.md` §1

### Instructor-Only Webcam Storage
**Date:** 2026-03-27 Conv 037

Only the instructor's (Teacher's) webcam is stored in session recordings. Student webcams are not persisted.

**Rationale:** Student privacy — students may include minors. Also reduces file size significantly (~50-200MB/hour for instructor-only vs multi-stream). Blindside Networks provides per-account webcam storage configuration.

**Consequences:** Documented in POLICIES.md §6. ✅ Enabled by Blindside Networks (2026-03-29, support ticket #21121).

---

## 2. Database & Data Model (High Impact)

### TAG-TAXONOMY: categories→topics, topics→tags, drop courses.category_id
**Date:** 2026-03-28 (Conv 048)

Renamed `categories` → `topics` (15 display groups), `topics` → `tags` (55 atomic items). Dropped `user_interests`, `user_topic_interests`, `experience_level`. Repurposed `course_tags` from free-text to FK-based many-to-many. Dropped `courses.category_id` — course-topic relationships derived via `course_tags → tags.topic_id`.

**Rationale:** Original 5-table taxonomy (categories, topics, user_topic_interests, user_interests, course_tags) had confusing near-synonym names and redundant data paths. User mental model: "tags are things you attach, topics are groups you browse by." Multi-tag courses enable cross-topic discovery. Smart feed scoring moves from binary category match to graduated tag overlap.

**Consequences:** ~30 source files + ~150 test files across 6 implementation phases. Breaking change — app non-functional between Phase 1 (schema) and Phase 5 (components).

> **Insight:** Schema naming that mirrors the user's vocabulary rather than database-design conventions reduces cognitive load across the entire team. Map every table/column to its actual readers — columns written but never read are dead weight.

### TAG-TAXONOMY API: Clean Break Naming, No Aliases
**Date:** 2026-03-28 (Conv 049)

All API parameters, response fields, and variable names use new taxonomy terms (`topics`, `tags`, `topicId`, `tagId`) with zero backward-compatibility aliases. `?category=` → `?topic=`, `category_id` removed from all responses, course detail views return `tags: {id, name, topic_id}[]` instead.

**Rationale:** No external consumers depend on these API shapes yet (pre-launch). Aliases create ambiguity about which naming is "current" and accumulate as tech debt. User directive: "actively remove conveniences like aliases unless they have strategic benefit."

**Consequences:** Every frontend component fetching taxonomy data needs updating (Phase 5). Server-side topic filtering uses EXISTS subqueries through `course_tags → tags → topics` instead of direct `category_id` match.

### Schema Column Naming Convention
**Date:** 2026-03-05 (Session 346)

Adopted conventions for all schema columns: entity PKs keep `id`; FKs referencing users use `{role}_id`; actor columns use `{action}_by_user_id`; booleans use `is_`/`has_` prefix; scoped roles prefix with domain (`member_role` not `role`).

**Trigger:** `st.id` (per-course certification record) was used where `user_id` (per-person) was needed, causing duplicate teacher cards. The ambiguous column name masked the semantic error.

**Consequence:** ~926 column rename occurrences planned across schema, src, and tests. Organized as Phase 3 of TERMINOLOGY block. Includes SQL sweep for latent bugs.

**See:** `GLOSSARY.md` §4, PLAN.md TERMINOLOGY.SCHEMA

### DATE-FORMAT: Canonical Date/Time Storage and Display
**Date:** 2026-03-18 (Conv 010)

All timestamps are stored as **UTC ISO 8601 with Z suffix**: `2026-03-18T23:41:25Z`. No exceptions.

**Storage rules:**
- Application code must use `toUTCISOString()` from `src/lib/timezone.ts` when writing timestamps
- Schema defaults use `strftime('%Y-%m-%dT%H:%M:%fZ', 'now')` (`%f` = `SS.SSS` for millisecond precision matching JS)
- Seed data must use ISO 8601 with Z: `'2024-09-10T00:00:00Z'`, not `'2024-09-10 00:00:00'`
- Date-only values (e.g., `certified_date`) still use full ISO 8601 at midnight UTC: `'2024-01-15T00:00:00Z'`

**Display rules — never use raw `toLocaleDateString()`:**

| Function | Use for | Example output |
|----------|---------|----------------|
| `formatDateUTC(str, 'short')` | Date-only values (completed_at, certified_date) | `3/18/2026` |
| `formatDateUTC(str, 'medium')` | Date-only with month name | `Mar 18, 2026` |
| `formatDateUTC(str, 'long')` | Formal date display | `March 18, 2026` |
| `formatDateTimeUTC(str)` | Admin timestamps, audit logs | `Mar 18, 2026, 11:41 PM` |
| `formatLocalTime(str, tz)` | Session times (user's timezone matters) | `{ date: 'Monday, March 18', time: '4:41 PM' }` |

**Why:** SQLite's `datetime('now')` produces `2026-03-18 23:41:25` (no timezone marker). JavaScript's `new Date()` parses this as **local time**, but ISO strings with `Z` as **UTC**. Mixing formats causes dates to shift by ±1 day depending on the browser's timezone. A single canonical format eliminates the ambiguity.

**Migration complete (Conv 011):** 130+ files migrated across 5 phases — schema defaults (66), seed data (6), app writes (49 `datetime('now')` + 17 `now()` deprecation), display (58 components), verification (5901 tests passing). `now()` in `db/index.ts` marked `@deprecated` — use `toUTCISOString()` from `timezone.ts` instead.

**DATETIME-FIX addendum (Conv 027):** The Conv 011 migration converted all INSERT/UPDATE writes to ISO format but missed **read-side comparisons**. Six SQL queries used `datetime('now', '-7 days')` (space at position 10) to compare against stored ISO values (T at position 10). Since `T` (ASCII 84) > ` ` (ASCII 32) in lexicographic comparison, these comparisons were always true — silently returning all rows instead of the intended time window. Fixed by replacing `datetime('now', ...)` with `strftime('%Y-%m-%dT%H:%M:%fZ', 'now', ...)` in all comparisons. `date('now', ...)` comparisons are safe (10-char prefix sorts correctly). See `docs/reference/DB-GUIDE.md` § "SQLite DateTime Comparison Caveat".

**DATETIME-FIX addendum 2 (Conv 028):** Found the same bug in **datetime arithmetic comparisons**: `datetime(s.scheduled_end, '+1 hour') < ?` in `detectStaleInProgress()` and `datetime(?, '-5 minutes')` in `reconcileBBBSessions()`. Both fixed with `strftime('%Y-%m-%dT%H:%M:%fZ', ...)`. Added dual defense: CLAUDE.md "SQLite Datetime Rule" section (prevents AI-authored code) + `/w-codecheck` check #5 (grep-based lint, catches manual edits). Edge-case test added for the 1-hour grace period.

All formatting functions live in `src/lib/timezone.ts`. The `parseUTCDate()` bridge handles both old and new formats for any residual data.

### User Role System - Capabilities + Course Relationships
**Date:** 2026-02-02 (Session 161, supersedes 2026-01-29)

User permissions split into two categories:

**Capability Flags (what you CAN do):**
- `can_create_courses` - permission to author courses (admin grants)
- `can_take_courses` - permission to enroll (default: true)
- `can_teach_courses` - permission to be certified as teacher (admin grants)
- `can_moderate_courses` - permission to be granted mod rights (admin grants)
- `is_admin` - global admin flag (NOT course-specific)

**Course Relationships (what you ARE for specific courses):**
- `teacher_certifications`[^tc] table - teacher certification per course
- `enrollments` table - student status per course

**Removed from Schema (Session 161):**
The following deprecated flags have been REMOVED from the schema entirely:
- `is_student` - use `can_take_courses` capability
- `is_teacher`[^it] - derive from `teacher_certifications`[^tc] table
- `is_creator` - derive from `courses` table (see Permission vs State below)
- `is_moderator` - will be course-specific (future)

**Rationale:** Separates "capabilities" (admin-controlled permissions) from "roles" (course-specific relationships). A user can be a student for Course A and Teacher for Course B. Keeping deprecated flags (even with comments) led to code using the wrong fields. Removing them forces correct usage.

**See:** `src/lib/current-user.ts`, `migrations/0001_schema.sql`

### Permission vs State: The Critical Distinction
**Date:** 2026-02-02 (Session 162)

There are TWO distinct concepts that were conflated in the old `is_creator` and `is_teacher`[^it] flags:

| Concept | Type | Meaning | Storage | Can be revoked? |
|---------|------|---------|---------|-----------------|
| **Permission** | Future-looking | Can user do X? | `users.can_*` columns | Yes (admin) |
| **State** | Backward-looking | Has user done X? | Derived from tables | No (historical fact) |

**For Creators:**
- `can_create_courses = 1` → User has permission to create new courses (admin grants)
- `is_creator` (derived) → User has created course(s): `EXISTS (SELECT 1 FROM courses WHERE creator_id = ?)`

**For Teachers:**
- `can_teach_courses = 1` → User has permission to become a teacher (admin grants)
- `is_teacher`[^it] (derived) → User is certified for course(s): `EXISTS (SELECT 1 FROM teacher_certifications[^tc] WHERE user_id = ? AND is_active = 1)`

**Key Scenario - The Revoked Creator:**
```
User creates courses → is_creator = YES (historical fact)
Admin revokes permission → can_create_courses = 0
Result: User can't create NEW courses, but existing courses remain valid
        User should still access Creator Dashboard to manage existing courses
```

**Access Control Pattern:**
```sql
-- Creating new course: permission only
WHERE can_create_courses = 1

-- Creator dashboard access: permission OR has courses
WHERE can_create_courses = 1
   OR EXISTS (SELECT 1 FROM courses WHERE creator_id = user_id)

-- Browse Creators page: has courses only
WHERE EXISTS (SELECT 1 FROM courses WHERE creator_id = user_id AND deleted_at IS NULL)
```

**UI Pattern for "Create Course" button:**
- Always visible (consistency)
- Enabled only if `can_create_courses = 1`
- Disabled state shows tooltip explaining requirement

**Rationale:** This distinction allows admins to revoke creation permission while preserving existing work. A creator's courses don't disappear when they lose permission - they just can't create more.

**See:** Implementation plan in `docs/sessions/2026-02/2026-02-02_Session-162_Implementation-Plan.md`

### Creator Auto-Added as Teacher with Self-Service Control
**Date:** 2026-01-29 (Session 148)

When a Creator creates a course, they are automatically added as a Teacher for that course. The Creator can then add or remove themselves as a teacher for their own course via self-service.

**Business Rules:**
- Creator must have `can_teach_courses=1` to be eligible for auto-teacher assignment
- Creator is auto-added as teacher when course is created
- Creator can opt out (remove themselves as teacher) at any time
- Creator can re-add themselves as teacher later

**Rationale:** Most Creators will want to teach their own course initially. Self-service control allows them to step back and let other teachers handle teaching without admin intervention.

**See:** `migrations/0002_seed.sql` (Guy/Gabriel have `can_teach_courses=1`)

### D1 as Canonical Source for Data
**Date:** 2025-12-29

D1 schema is the canonical source of truth. `mock-data.ts` syncs TO D1, not vice versa.

**Rationale:** D1 migrations define canonical data; runtime mapping adds unnecessary complexity.

### Migration Architecture - Production-Safe Split Seeds
**Date:** 2026-02-05 (Session 190, supersedes 2025-12-30)

Split migrations for production safety:

```
migrations/              # PRODUCTION-SAFE (applied everywhere)
├── 0001_schema.sql      # Table definitions
└── 0002_seed_core.sql   # Essential data only (topics, tags, admin, The Commons)

migrations-dev/          # DEV ONLY (local + staging only)
└── 0001_seed_dev.sql    # Test users, courses, communities
```

**Commands:**
- `npm run db:setup:local` - Full setup with test data
- `npm run db:setup:local:clean` - Production-like (no test data)
- `npm run db:migrate:prod` - Requires typing "production" to confirm
- `npm run db:seed:prod` - **BLOCKED** (errors immediately)
- `npm run db:reset:prod` - **BLOCKED** (errors immediately)

**Rationale:** Production should never have test data. Blocking commands is safer than confirmation prompts. Separate directories ensure dev seed is never in production migration path.

**See:** `docs/as-designed/migrations.md`, `migrations/README.md`

### Layered Dev Seed: Optional Stripe Accounts via Separate File
**Date:** 2026-02-22 (Session 247)

Stripe sandbox account IDs are in a separate, opt-in seed file rather than baked into the main dev seed:

```
migrations-dev/
├── 0001_seed_dev.sql        # Users with NULL Stripe fields (automatic)
└── 0002_seed_stripe.sql     # Real Stripe sandbox acct_ IDs (opt-in)
```

**Commands:**
- `npm run db:setup:local` — Full setup, all users have NULL Stripe (test onboarding flows)
- `npm run db:seed:stripe:local` — Apply real Stripe account IDs (test payment flows)
- `npm run db:seed:stripe:staging` — Same for staging D1

**Users covered:** Guy Rymberg (creator), Sarah Miller (teacher), Marcus Thompson (teacher) — enables full creator→teacher payment split testing.

**Key convention:** `0002_seed_stripe.sql` uses only UPDATE statements (not INSERTs). Users must exist from `0001` first. Placeholder `acct_REPLACE_*` values must be replaced with real Stripe test-mode Express account IDs from the Stripe Dashboard.

**Also:** Removed fake mock IDs (`acct_mock_sarah`, `acct_mock_marcus`) from `0001_seed_dev.sql`. Mock IDs passed `IS NOT NULL` checks but failed at runtime against Stripe API — a phantom state that masked real integration issues.

**Rationale:** Base seed should represent honest application state (no Stripe = not onboarded). Stripe accounts are test infrastructure, not core dev data. Separation allows testing both flows: fresh-install (no Stripe) and payment testing (with Stripe).

**See:** `migrations-dev/README.md`, `migrations-dev/0002_seed_stripe.sql`

### INSERT OR IGNORE for Idempotent Migrations
**Date:** 2025-12-29

Use `INSERT OR IGNORE INTO` for all seed data inserts.

**Rationale:** Handles composite unique constraints better; fully idempotent; safe to re-run.

### Soft Delete Strategy
**Date:** 2025-12-29

Use soft delete with `deleted_at` timestamp for users, courses, enrollments. Added fields: `deleted_at`, `suspended_at`, `suspended_reason`.

**Rationale:** Preserves audit trail; allows recovery; maintains referential integrity.

### Dual-Machine D1 Development
**Date:** 2025-12-27
**Superseded:** 2026-02-19 — MBA-2017 retired, replaced by MacMiniM4. Both machines (MacMiniM4-Pro, MacMiniM4) now have full local D1 support. REST API fallback removed.

- MacMiniM4-Pro: Use local D1 (`--local`)
- MacMiniM4: Use local D1 (`--local`)

**Rationale:** Both machines share same `wrangler.toml`; local and remote databases are completely separate.

### Local Dev Server Against Remote Staging D1
**Date:** 2026-02-21 (Session 236)

Use `npm run dev:staging` to run the local Astro dev server connected to the remote staging D1 database. Implemented via an env-var-gated `platformProxy` option in `astro.config.mjs`: when `USE_STAGING_DB=1`, the Cloudflare adapter calls `getPlatformProxy({ environment: 'preview', remoteBindings: true })`, which uses the `[env.preview]` D1 binding (`peerloop-db-staging`).

**Trigger:** Need to reproduce bugs that staging users report, using the same data they see.

**Options Considered:**
1. Separate `astro.config.staging.mjs` — duplicates most config
2. `wrangler pages dev dist --remote` — requires build step, loses HMR ← Rejected
3. Env-var-gated `platformProxy` in existing config ← Chosen

**Rationale:** Single config file, no build step, preserves hot-reload, zero impact on default `npm run dev`. Note: writes from local dev **modify the staging database**.

> **Insight:** The Astro Cloudflare adapter's `platformProxy` option is a direct passthrough to wrangler's `getPlatformProxy()`. This means any option wrangler supports (environment selection, remote bindings, custom config paths) is available without Astro-specific configuration. The adapter is thinner than it appears. (Session 236)

**See:** `astro.config.mjs`, `package.json` (`dev:staging` script)

### D1 Reset Strategy - Schema-Driven Drop Order
**Date:** 2026-01-24

Reset D1 databases by parsing `0001_schema.sql` to determine FK dependencies, then dropping tables in reverse dependency order (children before parents).

**Implementation:**
- **Local D1:** Delete SQLite files directly (`.wrangler/state/v3/d1/miniflare-D1DatabaseObject/*.sqlite*`)
- **Remote D1:** Parse schema for `REFERENCES` clauses, topological sort, drop in reverse order

**Options Considered:**
1. `PRAGMA foreign_keys = OFF` ← **Doesn't work** - D1 enforces at platform level
2. `PRAGMA defer_foreign_keys = ON` ← **Doesn't help DROP TABLE** - only defers constraint check
3. Schema-driven dependency order ← **Chosen**

**Rationale:** D1's foreign key enforcement is immutable. The only reliable approach is to respect the FK graph. Parsing the schema file makes `0001_schema.sql` the single source of truth for both creation AND destruction order. Self-maintains as schema evolves.

**See:** `scripts/reset-d1.js`, [Cloudflare D1 Foreign Keys docs](https://developers.cloudflare.com/d1/sql-api/foreign-keys/)

### Three-Table Moderation Design
**Date:** 2026-01-21

Content moderation uses three separate tables instead of a single monolithic table:
- `content_flags` - Flagged content with cached snapshot and review status
- `moderation_actions` - Log of every action taken (dismiss, remove, warn, suspend)
- `user_warnings` - Warning records linked to users for escalation tracking

**Rationale:** Multiple actions can occur per flag; warning history needed for escalation decisions; clear separation of concerns aids querying and maintenance.

**See:** `migrations/0013_moderation.sql`, `src/pages/api/admin/moderation/`

### Two-Tier Rating System (User vs Course-Specific)
**Date:** 2026-02-04 (Session 178)

Ratings are stored at two distinct levels:

| Level | Table | Purpose | Updated By |
|-------|-------|---------|------------|
| **User-level** | `user_stats.average_rating` | Overall rating across all roles | Session ratings |
| **Teacher-course-level** | `teacher_certifications.rating`[^tc] | Rating for teaching specific course | Completion reviews only |

**Session ratings** (`session_assessments`) are diagnostic - quick pulse checks after each session. They update `user_stats` but do NOT affect teacher profile ratings.

**Completion reviews** (`enrollment_reviews`) are evaluative - comprehensive feedback when student completes the full course journey. These alone feed into `teacher_certifications.rating`[^tc].

**Rationale:** Session ratings are noisy and don't reflect overall experience. Completion reviews provide meaningful, comparable data for teacher profiles. Matches how Airbnb/Coursera work (rate after experience ends).

**See:** `src/pages/api/enrollments/[id]/review.ts`, `src/pages/api/sessions/[id]/rating.ts`

### Topics Table (Hybrid Taxonomy) for Onboarding
**Date:** 2026-02-22 (Session 252)

> **Superseded by TAG-TAXONOMY (Conv 048).** The `topics` table was renamed to `tags`, `categories` renamed to `topics`, and `user_interests`/`user_topic_interests` replaced by `user_tags`. See the Conv 048 decision above.

~~New `topics` table provides curated subtopics linked to parent categories. Used for member onboarding interest selection and future discover page filtering. ~55 topics (3-5 per category), admin-controlled.~~

~~**Rationale:** More structured than freeform `course_tags` (curated, consistent) but lighter than a full subcategories hierarchy. Existing `user_interests` table kept as-is; onboarding also syncs topic names there for backward compatibility.~~

**See:** `migrations/0001_schema.sql` (topics/tags tables), `migrations/0002_seed_core.sql` (topic/tag seeds)

### Separate member_profiles Table for Onboarding Data
**Date:** 2026-02-22 (Session 252)

Onboarding questionnaire answers (goal_learn, goal_teach, referral_source, profession, onboarding_completed_at) stored in a separate `member_profiles` table keyed by `user_id`, not as additional columns on `users`.

**Rationale:** The `users` table (30+ columns) is read on every authenticated page load via `/api/me/full`. Only `onboarding_completed_at` is surfaced in `CurrentUser` (via LEFT JOIN) for conditional navbar menu visibility. Keeps onboarding concerns isolated.

**See:** `src/pages/api/me/full.ts` (LEFT JOIN), `src/lib/current-user.ts` (hasCompletedOnboarding)

### Community Recommendations via Transitive Progression Chain
**Date:** 2026-02-22 (Session 259)

> **Partially superseded by TAG-TAXONOMY (Conv 048).** The old transitive chain via `category_id` no longer exists. `courses.category_id` was dropped; course-topic relationships now go through `course_tags → tags.topic_id → topics`. The recommendation logic in `src/pages/api/recommendations/communities.ts` may need updating to use the new tag-based path: `user_tags → tags.topic_id → topics → course_tags → courses.progression_id → progressions.community_id → communities`.

~~Communities don't have a direct `category_id`. Recommendations match transitively through existing relationships: `user_topic_interests` → `topics.category_id` → `courses.category_id` → `courses.progression_id` → `progressions.community_id` → `communities`.~~

~~**Rationale:** The schema already models this relationship — courses belong to categories AND progressions, progressions belong to communities. Using the existing chain avoids schema changes and naturally aligns with the platform's content structure. Falls back to popular communities when no transitive matches exist.~~

**See:** `src/pages/api/recommendations/communities.ts`

### Separate availability_overrides Table for Date-Specific Changes
**Date:** 2026-02-25 (Session 287)

Recurring availability rules stay in the `availability` table (keyed by `day_of_week`). Date-specific overrides (vacations, extra hours, blocked days) go in a new `availability_overrides` table (keyed by specific `date`). Calendar rendering: expand recurring rules for the visible month → overlay overrides → show merged result.

**Rationale:** Different data shapes — recurring has `day_of_week` (0-6), overrides have a specific ISO date. Combining them in one table requires nullable columns and `is_recurring` filtering on every query. Separate tables give clean queries and clear semantics.

**See:** `CURRENT-BLOCK-PLAN.md` (S-T-CALENDAR.SCHEMA section)

### Per-Course teaching_active Toggle for Creator-as-Teacher
**Date:** 2026-02-25 (Sessions 287, 289)

Add `teaching_active INTEGER NOT NULL DEFAULT 1` to `teacher_certifications`[^tc] table alongside existing `is_active`. Two independent boolean states controlled by different actors: `is_active` (admin-controlled certification) and `teaching_active` (user-controlled booking visibility). When `teaching_active=0`, the availability endpoint returns empty slots with `teaching_paused: true`. When `is_active=0`, the toggle endpoint returns 403.

**Rationale:** `teacher_certifications`[^tc] is already one-row-per-course, so per-course is the natural granularity. Separate columns avoid conflating admin authority with user preference. The toggle endpoint only writes `teaching_active`; admin endpoints only write `is_active`.

**See:** `docs/as-designed/availability-calendar.md`, `src/pages/api/me/teacher/[courseId]/toggle.ts`

### Availability is Per-Person (user_id), Not Per-Course
**Date:** 2026-02-25 (Session 288)

Availability tables (`availability`, `availability_overrides`) use `user_id` referencing `users(id)`. No `course_id` column. A teacher's time is personal — they can't teach two courses simultaneously. Per-course opt-in/out is handled by `teaching_active` on `teacher_certifications`[^tc].

**Rationale:** Simpler UX (one calendar), no cross-course double-booking risk, matches existing codebase pattern where all scheduling tables use `user_id`. CERT-AUDIT added to PLAN.md deferred queue for future `st_id` audit trail work.

**See:** `CURRENT-BLOCK-PLAN.md` (Schema Changes section, Session 288 decision note)

### DST-Safe Week Counting for Recurring Availability
**Date:** 2026-02-25 (Session 289)

Calendar-week boundaries must use calendar-day math (`Math.round(ms / msPerDay)` then `/7`), not millisecond division (`ms / msPerWeek`). DST transitions add/remove an hour, causing `Math.floor` on raw milliseconds to under/over-count weeks. Applied in both `availability-utils.ts` (client-side merge) and `teachers/[id]/availability.ts` (server-side slot generation).

**Rationale:** US spring forward (March 8, 2026) caused a 2-week recurring rule to incorrectly include week 3. `Math.round` on the day difference absorbs the ~1 hour DST shift without requiring a date library.

**See:** `docs/as-designed/availability-calendar.md` (DST-safe week counting section)

### Override Merge: Full Replacement, Not Layering
**Date:** 2026-02-25 (Session 288)

When `availability_overrides` exist for a date, they fully replace recurring rules for that date. Blocked overrides produce zero slots. Available overrides produce only the override's time range — the original recurring slot is suppressed.

**Rationale:** Simpler mental model: "I overrode March 15" means only override times show, not a confusing mix. Implemented in `availability-utils.ts` `buildMonthView()` and `GET /api/teachers/[id]/availability`.

---

### enrollments.assigned_teacher_id[^at] Stores users.id (Not teacher_certifications[^tc].id)
**Date:** 2026-03-04 (Session 324)

The `enrollments.assigned_teacher_id`[^at] FK references `users(id)` (`usr-xxx`), not `teacher_certifications(id)`[^tc] (`st-xxx`). The checkout→webhook pipeline was inserting `teacher_certifications.id` causing FK violations. Fixed by resolving `tc.id` → `tc.user_id` in `create-session.ts` and passing both IDs through Stripe metadata: `teacher_certification_id` (st-xxx, for webhook JOINs) and `assigned_teacher_id` (usr-xxx, for enrollment FK).

**Rationale:** 10+ existing consumers (admin, analytics, reviews, reassign-teacher) already correctly use `usr-xxx`. Fixing the pipeline at source was a 3-file change vs rewriting all consumers.

**See:** `src/lib/stripe.ts` (metadata), `src/pages/api/checkout/create-session.ts`, `src/lib/enrollment.ts`

### Positional Module Assignment for Sessions (Implemented)
**Date:** 2026-03-05 (Session 331, replaces Session 325 plan)

Module assignment is computed positionally at read time, not stored at booking time. Sort an enrollment's non-cancelled sessions by `scheduled_start ASC`; the Nth session teaches the Nth module (by `module_order`). `module_id` column added as nullable — NULL while `scheduled` or `in_progress` (computed dynamically), set permanently when session transitions to `completed` via BBB webhook. Sequential completion enforced: if earlier sessions are still `scheduled`, the completing session gets `module_id = NULL` (out-of-order guard).

**Trigger:** Session 325 planned storing `module_id` at booking time. During Session 331 design, realized cancellations cause stored module_ids to go stale — if session 2 of 3 is cancelled, session 3 should shift to cover module 2 automatically.

**Rationale:** Late binding keeps module order always sequential without data migration on cancellation. The computation cost (3 queries + zip) is negligible for enrollment-scoped data (3-10 sessions). Cancellation reflow is automatic.

**Implementation:** `src/lib/booking.ts` provides `resolveModuleAssignments()` as single source of truth. Session limit enforced: 422 when `completed + scheduled >= module count`. Cancelled sessions free slots. All API responses include computed module info.

**Frozen vs computable split (Session 332):** Sessions are classified as "frozen" (has non-null `module_id`) vs "computable" (null `module_id`), not by status. An `in_progress` session hasn't had its `module_id` written yet (that happens in the BBB webhook on completion), so it must be positionally computed like `scheduled` sessions.

> **Insight:** This is a form of late binding — deferring the module-to-session relationship until the last possible moment (read time for scheduled, completion time for historical). It avoids the classic problem of stored denormalized data going stale, at the cost of a small per-read computation that's negligible for the data volumes involved. (Session 331)

**See:** `src/lib/booking.ts`, `src/pages/api/webhooks/bbb.ts`, `docs/as-designed/session-booking.md`

### Session Completion Healing — Shared `completeSession()` Function
**Date:** 2026-03-05 (Session 334)

Extracted session completion logic from BBB webhook `handleRoomEnded` into a shared `completeSession(db, sessionId, endedAt?)` function in `src/lib/booking.ts`. Three callers: BBB webhook, `POST /api/sessions/[id]/complete` (teacher/creator manual), admin `PATCH /api/admin/sessions/[id]`.

**Trigger:** BBB webhook `room_ended` was the only code path that completed sessions and froze `module_id`. If the webhook failed, sessions were stuck in `in_progress` with no recovery. Admin PATCH could set status but skipped module freezing, creating data gaps.

**Options Considered:**
1. Poll BBB API on a cron — BBB doesn't retain meeting info long, adds external dependency
2. Auto-complete sessions after `scheduled_end` — too aggressive, no human confirmation
3. Teacher/Creator manual endpoint + shared function ← Chosen

**Rationale:** Follows the proven Stripe enrollment healing pattern (extract shared function → multiple callers). Teachers and creators have direct knowledge of whether a session happened. No external API dependency. Idempotent — safe to call from multiple surfaces concurrently.

**Consequence:** `completeSession()` handles sequential completion checks, `module_id` freezing, and ended_at timestamp. All completion paths produce identical database state.

> **Insight:** The "extract shared function from webhook" pattern is a reliable resilience technique. Webhooks are inherently unreliable (network failures, service outages, configuration drift). By making the webhook handler a thin caller of shared logic, you create room for manual, SSR, and cron-based healing surfaces without duplicating business rules. Stripe enrollment healing proved this in Session 324; session completion now follows the same arc. (Session 334)

**See:** `src/lib/booking.ts` (`completeSession`), `src/pages/api/sessions/[id]/complete.ts`, `src/pages/api/webhooks/bbb.ts`

### Session Invite Model for Instant Booking ("Book Now")
**Date:** 2026-03-17 Conv 004

Teacher-initiated instant session booking via a Session Invite model. Teacher sends a 30-minute-expiry invite scoped to an enrollment, delivered via the existing notification system. Student accepts with one click → session created at now+5min → both redirect to session room. Two modes: new booking (bookable modules available) or reschedule (auto-cancels next upcoming scheduled session). One pending invite per enrollment at a time.

**Rationale:** Client required teacher authorization for instant booking. Notification-based delivery reuses existing infrastructure without requiring real-time signaling (WebSocket/polling). Lazy expiry (check on access, no background job) suits Cloudflare Workers' stateless model. Positional module assignment, overbooking guards, and conflict checks all work unchanged.

> **Insight:** The "invite as authorization token" pattern cleanly separates the authorization decision (teacher) from the action (student). The invite record serves triple duty: authorization proof, audit trail, and notification linkage. This avoids coupling the booking system to a real-time coordination layer while still ensuring both parties consent. (Conv 004)

**See:** `docs/requirements/rfc/CD-037/`, `src/pages/api/session-invites/`, `src/lib/notifications.ts` (notifySessionInvite, notifySessionInviteAccepted), `docs/as-designed/session-room.md` §Session Invites

---

### Notification action_label: Store Label at Creation Time
**Date:** 2026-03-11 (Session 372)

Notifications store an `action_label TEXT` column alongside `action_url`. Each notification helper sets a contextual label ("Go to Session", "Browse Courses", "Review Application") at creation time. The UI component renders this label as an explicit button, falling back to "View" for notifications without a label.

**Rationale:** The notification creator has the best context for what the button should say. Client-side derivation from `type` would require a parallel mapping table and couldn't handle the generic `notifySystem` helper which takes arbitrary URLs.

**See:** `src/lib/notifications.ts` (all helpers), `migrations/0001_schema.sql` (notifications table)

### User Tags Level: Per-Topic Conceptually, Per-Tag in Storage
**Date:** 2026-04-01 (Conv 071)

Store `level TEXT NOT NULL DEFAULT 'beginner'` on `user_tags` (denormalized per-tag), but TopicPicker enforces same level for all tags within a topic (per-topic conceptually). API accepts both `tags: [{tagId, level}]` (new) and `tagIds: string[]` (legacy, defaults to 'beginner').

**Rationale:** Makes future Smart Feed level matching a trivial join (`user_tags.tag_id = course_tags.tag_id` + compare levels). A separate `user_topic_levels` table would normalize but add an extra join for no practical benefit. The denormalization is controlled — UI enforces the invariant.

**Consequences:** Deferred block LEVEL-MATCH (#40) in PLAN.md for Smart Feed scoring integration.

**See:** Conv 071 Decisions.md, `migrations/0001_schema.sql` (user_tags table)

### Onboarding Goals: Boolean Columns over Enum
**Date:** 2026-04-02 (Conv 076)

Replace `primary_goal TEXT` with independent `goal_learn INTEGER` / `goal_teach INTEGER` boolean columns in `member_profiles`. Learn and Teach are independent selections, not mutually exclusive — "Both" was an artifact of the old single-column design.

**Rationale:** Independent booleans scale to future goal additions without combo value explosion. Each new option is an additive column rather than an exponential expansion of valid enum strings. No existing users at this stage means schema can change freely.

> **Insight:** When modeling user preferences that may grow over time, independent boolean flags are more durable than enum columns with combo values.

---

## 3. API & Data Fetching (Medium-High Impact)

### Enrollment Self-Healing: Two-Surface Fallback for Missed Webhooks
**Date:** 2026-03-04 (Session 324)

Enrollment creation logic extracted from the Stripe webhook into shared `src/lib/enrollment.ts`. Self-healing triggers on two surfaces: (1) `/course/[slug]/success.astro` calls `createEnrollmentFromCheckout` directly in SSR when enrollment not found but `session_id` exists, (2) `/courses` dashboard checks localStorage for pending Stripe sessions on mount and calls `POST /api/stripe/verify-checkout`. Follows the same self-healing pattern as `GET /api/stripe/connect-status` (Session 223).

**Rationale:** Webhooks are unreliable when `stripe listen` isn't running (staging, client dev). The success page covers 99% of cases; localStorage bridge covers the edge case where the user skips the success page.

**See:** `src/lib/enrollment.ts`, `src/pages/api/stripe/verify-checkout.ts`, `src/pages/course/[slug]/success.astro`

---

### 4-Layer Data Fetching Architecture
**Date:** 2025-12-29

1. **Layer 1:** SSR + 5min cache for public pages (fast, SEO-optimized)
2. **Layer 2:** CSR overlay for personalization (non-blocking)
3. **Layer 3:** SSR + auth for user-specific pages (dashboards)
4. **Layer 4:** Hybrid admin (dedicated routes + Context Actions)

**Documented in:** `docs/as-designed/data-fetching.md`

### SSR Pattern for Data Fetching
**Date:** 2025-12-29

Fetch in Astro frontmatter; pass to React components as props. Components are "dumb" - just render data, no client-side fetching.

**Rationale:** Better SEO, faster initial load, simpler components.

### No Mock-Data Fallback in APIs
**Date:** 2025-12-29

APIs return 503 when D1 unavailable. No silent fallback to mock data.

**Rationale:** Fallback hides real configuration problems; false confidence in tests; fail fast is better.

### D1 Health Check Endpoint
**Date:** 2025-12-29

`/api/health/db` endpoint testing D1 connectivity, latency, table count.

**Rationale:** Explicit connectivity check useful for CI/CD and debugging.

### Server-Side Feed Operations (Proxy Pattern)
**Date:** 2026-01-19

Proxy all Stream.io feed operations through server API endpoints (`/api/feeds/townhall`) using the API secret, rather than client-side SDK with user tokens.

**Rationale:** Feed policies UI not available in Stream v2 dashboard; server-side is more secure (API secret never exposed); allows enforcing our own auth and business logic; simplifies client code (just fetch from our API); pattern scales well to other feeds.

**See:** `src/pages/api/feeds/townhall.ts`, `src/pages/api/feeds/townhall/reactions.ts`

### Stream REST API Path-Based Endpoints
**Date:** 2026-01-20

Use path-based endpoints for Stream.io reaction filtering, NOT query parameters:
- By activity: `/reaction/activity_id/{activity_id}/{kind}/`
- By reaction: `/reaction/reaction_id/{reaction_id}/{kind}/`
- By user: `/reaction/user_id/{user_id}/{kind}/`

**Rationale:** Query parameter filtering (`/reaction/?activity_id=xxx`) silently fails and returns ALL reactions. Path-based endpoints are the correct REST API format.

**See:** `src/lib/stream.ts` `StreamReactions.filter()` method

### Auth/Validation Before External Service Checks
**Date:** 2026-01-28

Endpoints should check authentication and validation (resource exists, user enrolled, etc.) BEFORE checking if external services (R2, Stripe) are available.

**Correct order:**
1. Auth check → 401 Unauthorized
2. Resource validation → 403 Forbidden, 404 Not Found
3. External service check → 503 Service Unavailable
4. Perform operation

**Rationale:**
- More efficient: don't check R2 for requests that will fail auth anyway
- Better UX: users get meaningful errors (401, 403, 404) before infrastructure errors (503)
- Easier to test: tests don't need R2/Stripe mocks for auth/validation tests

**See:** `src/pages/api/resources/[id]/download.ts`, Session 135 Decisions

### Transactional vs Notification Email Pattern
**Date:** 2026-02-21 (Session 237)

Two distinct email paths in `src/lib/email.ts`:
- **`sendEmail()`** — Transactional: always sends (receipts, enrollment confirmations, password resets). User took an explicit action and expects confirmation.
- **`sendEmailToUser()`** — Notification: checks user's preference columns before sending (session reminders, course updates, marketing). User can opt out.

**Rationale:** Transactional emails are legally and experientially expected — suppressing them breaks trust. Notification emails are optional by nature. The two-function API makes the distinction explicit at the call site.

**See:** `src/lib/email.ts`, `src/pages/api/webhooks/stripe.ts` (enrollment confirmation)

### Recommendation Scoring: 80/20 Category-to-Tag Weighting
**Date:** 2026-02-22 (Session 259)

Course recommendations use a two-signal scoring algorithm: category match = 80 points (from `user_topic_interests` → `topics.category_id` → `courses.category_id`), tag overlap = `MIN(match_count, 5) * 4` points (max 20, from `user_interests.tag` ↔ `course_tags.tag`). Courses with zero score are excluded. Backfill with popular courses when personalized results < limit.

**Rationale:** Category selection during onboarding is an explicit intent signal; tags are a weaker, granular signal. The 80/20 split ensures a course in the user's interested category always outranks one matched by tags alone. The cap at 5 matching tags prevents courses with many tags from gaming the score.

> **Insight:** The two-signal approach with a dominant primary signal is a common pattern in recommendation systems (e.g., YouTube's candidate generation vs ranking stages). It avoids the cold-start problem that pure collaborative filtering faces — we always have the onboarding signal, even for new users with no interaction history. (Session 259)

**See:** `src/pages/api/recommendations/courses.ts`

### Creator Content APIs Under `/api/me/communities`
**Date:** 2026-02-23 (Session 270)

Creator community and progression CRUD endpoints live under `/api/me/communities`, matching the existing `/api/me/courses` pattern. Public read endpoints remain at `/api/communities/`. Progression endpoints nest at `/api/me/communities/[slug]/progressions/`.

**Rationale:** `/api/me/` already means "resources owned by the authenticated user." Keeps creator writes separate from public reads without new conventions.

**See:** `src/pages/api/me/communities/`

### Community Creation Auto-Creates Default Progression
**Date:** 2026-02-23 (Session 270)

`POST /api/me/communities` atomically creates three rows in a single `batch()`: the community, a "General" progression (`badge='standalone'`, `display_order=0`), and the creator membership (`role='creator'`).

**Rationale:** A community with no progressions is useless — courses require a progression. Auto-creating "General" makes the community immediately usable. Atomic batch prevents partial state.

**See:** `src/pages/api/me/communities/index.ts`

### Course Creation Requires `progression_id` (API-Level)
**Date:** 2026-02-23 (Session 270)

`POST /api/me/courses` now requires `progression_id` in the request body (returns 400 if missing). The schema column remains nullable for backward compatibility with existing seed data. The API also auto-increments progression `course_count` and auto-updates badge from `standalone` → `learning_path` when count reaches 2+.

**Rationale:** Enforces the community → progression → course hierarchy at the API level without a breaking schema migration. Existing NULL-progression courses continue to work.

**See:** `src/pages/api/me/courses/index.ts`

### Creator Self-Certification as Teacher via Existing Endpoint
**Date:** 2026-02-25 (Session 282)

Creator self-certification uses the existing `POST /api/me/courses/[id]/teachers` endpoint with a conditional branch: when `body.user_id === creatorId`, skip the enrollment-completion check. After creating the teacher certification record, auto-set `can_teach_courses = 1` on the user so the Teaching nav item appears immediately.

**Rationale:** 10-line branch in existing endpoint vs duplicated logic in a new endpoint. The course ownership check already gates this to the actual creator.

**See:** `src/pages/api/me/courses/[id]/teachers.ts`

### Creator-as-Teacher Payment Split: 85/15 (Not 70/15/15)
**Date:** 2026-02-25 (Session 282)

When the selected teacher is also the course creator (`teacher.user_id === course.creator_id`), keep `instructorType = 'creator_as_instructor'` for the 85/15 split. This avoids a confusing double-split where both `creator_as_author` and `teacher` shares go to the same person.

**Rationale:** Clean single payment record. Creator Dashboard already queries `recipient_type IN ('creator_as_instructor', 'creator_as_author')`, so earnings display correctly without special-case aggregation.

**See:** `src/pages/api/checkout/create-session.ts`

### Feed Activity Avatar Enrichment on Read
**Date:** 2026-03-20 (Conv 023)

All feed GET endpoints (townhall, community, course) enrich Stream.io activities with fresh user avatars from D1 via `enrichActivitiesWithAvatars()`. Single batch query for all unique actors per page, failure swallowed so feeds never break.

**Rationale:** Stream stores activity metadata at write time — older posts have stale/missing `userImage`. Enrichment on read ensures fresh avatars regardless of when the post was created, and handles avatar changes instantly. No Stream API modifications needed.

**See:** `src/lib/feed-activity.ts`, `src/pages/api/feeds/townhall.ts`

### Client-Side Role Annotation via CurrentUser
**Date:** 2026-03-27 (Conv 039)

For features needing per-course role detection (e.g., role badges, role-filtered views), annotate courses on the client using CurrentUser's O(1) Map lookups rather than creating new API endpoints. The `/api/me/full` response already includes enrollments, teacher certifications, created courses, and moderated course IDs — all accessible via `isStudentFor(id)`, `isTeacherFor(id)`, `isCreatorFor(id)`, `canModerateFor(id)`.

**Rationale:** Adding a server-side role-annotated endpoint would duplicate data already in CurrentUser and add a round-trip. SSR fetches the public catalog; client overlays role data from the singleton.

**See:** `src/components/discover/role-utils.ts`, `src/lib/current-user.ts`

### UserFeedLink Carries Primitives, Not UI Types
**Date:** 2026-03-28 (Conv 043)

When extending `UserFeedLink` with role data for the explore feeds layer, use simple primitives (`parentId: string`, `roles: string[]`) rather than `RoleBadgeConfig[]`. The explore layer converts to UI badge types via `feed-role-utils.ts`.

**Rationale:** Avoids circular dependency between core `current-user.ts` and UI `explore/types.ts`. Keeps the CurrentUser data model presentation-agnostic — all consumers get role data without importing UI types. Backward-compatible since existing FeedsHub/MyFeeds ignore the new fields.

**See:** `src/lib/current-user.ts` (`UserFeedLink`, `getFeeds()`), `src/components/discover/feed-role-utils.ts`

---

## 4. Authentication & Authorization

### Custom JWT Authentication
**Date:** 2025-12-26

Use custom JWT with `jose` + `bcryptjs` + `arctic` (OAuth library).

**Rationale:** Safer than Clerk for edge deployments; Clerk has known compatibility issues with Astro + Cloudflare Pages.

### Admin Auth Pattern
**Date:** 2025-12-29

Use existing `requireRole()` function directly in API handlers. No separate admin middleware file needed.

**Rationale:** Auth system already has role-based control built in; no need for additional abstraction.

### OAuth User Creation
**Date:** 2025-12-28

OAuth creates users automatically if they don't exist. OAuth users have empty `password_hash` - cannot login with password.

### Email Verification Deferred
**Date:** 2025-12-27

Email verification deferred to Block 9 (Notifications).

**Rationale:** Block 9 handles notification infrastructure; OAuth users already verified via provider.

### Admin User Creation Requires Password
**Date:** 2026-01-25

Admin-created users via `POST /api/admin/users` must have a password. The endpoint returns 400 if password is not provided.

**Options Considered:**
1. Allow NULL `password_hash` with email-invite flow (user sets password via welcome email)
2. **Require password** (admin communicates credentials out-of-band) ← **Chosen**
3. Auto-generate random password and return in response

**Rationale:** For MVP/Genesis cohort (60-80 students with direct contact), requiring password is simplest:
- No dependency on email system (Resend domain verification not yet complete)
- User can log in immediately after admin creates account
- Admin can share credentials during onboarding calls/meetings
- No NULL handling complexity in login logic

**Post-MVP:** May revisit Option 1 (email-invite flow) for scalable self-service user creation once email infrastructure is fully configured.

**See:** `src/pages/api/admin/users/index.ts`

### JWT Auth Over Astro Sessions
**Date:** 2026-02-16

Stay with custom JWT authentication (stateless, cookie-based). Astro Sessions (server-side KV storage) evaluated and deferred to post-MVP.

**Rationale:** JWT is already built, tested across 169 API test files, and framework-agnostic. The stale-role gap (up to 15 min) is mitigated by short access token TTL and D1 re-checks on critical endpoints. Astro Sessions would add KV infrastructure dependency and couple the auth system to Astro.

**See:** `docs/as-designed/auth-sessions.md`

### Modal-Based Auth for Login and Signup
**Date:** 2026-02-16 (Session 220)

Login and signup use modals over AppLayout instead of standalone pages. The `/login` and `/signup` routes render AppLayout with `AutoOpenAuthModal` which auto-opens the appropriate modal. Dismissing leaves the user browsing as a visitor. Cross-modal switching (login ↔ signup) preserves `pendingAction` for flows like "try to enroll → auth → complete → enrollment fires."

**Rationale:** Matches the Twitter/X pattern. Enables in-context auth without page navigation. Forms are modal-only (`onSuccess` required, no redirect logic).

**See:** `src/lib/auth-modal.ts`, `src/components/auth/AuthModalRenderer.tsx`

### Password Reset as Standalone Page
**Date:** 2026-02-16 (Session 220)

Password reset uses a standalone page (`/reset-password`) within AppLayout, not a modal.

**Rationale:** Multi-state UI (form → "check your email" confirmation), reached from two contexts (login modal and settings page), and future token flow (`/reset-password?token=xyz`) all require a real page.

**See:** `src/pages/reset-password.astro`, `src/components/auth/PasswordResetForm.tsx`

### Feed Access Models
**Date:** 2026-01-20

Three community feeds with distinct access patterns:

| Feed | View | Post |
|------|------|------|
| TownHall (FEED) | Authenticated | Authenticated |
| Instructor (IFED) | Enrolled in instructor's course | Same |
| Course (CDIS) | Public | Enrolled/completed students |

**Rationale:** TownHall is platform-wide community. IFED is instructor-exclusive (social proof for paid community). CDIS allows public viewing (marketing) but restricts posting to maintain quality.

### canModerateFor() Four-Tier Check
**Date:** 2026-02-23 (Session 261, updated Session 265)

`canModerateFor(courseId)` checks four conditions in order: `isAdmin`, `isCreatorFor(courseId)`, `canModerateCourses` (global moderator), and `communityModeratedCourseIds.has(courseId)` (community moderator). The fourth check resolves community moderator authority through the Community → Progression → Course chain.

**Trigger:** Session 261 audit revealed only admin + creator were checked. Session 265 implemented the community moderator check.

**Rationale:** Each tier represents a different scope: admin (platform-wide), creator (own courses), global moderator (all courses), community moderator (courses within their assigned community). The pre-computed `communityModeratedCourseIds` Set enables O(1) lookup on the client side.

**See:** `src/lib/current-user.ts`, `src/pages/api/me/full.ts` (fetchCommunityModeratedCourseIds), `docs/reference/ROLES.md`

### Two-Tier Moderator Model
**Date:** 2026-02-23 (Session 263)

Peerloop uses a two-tier moderation model instead of a single global moderator flag:

| Tier | Name | Scope | Appointed By | Database |
|------|------|-------|-------------|----------|
| 1 | Global Moderator | All feeds, all communities | Admin (invite or direct toggle) | `users.can_moderate_courses` flag |
| 2 | Community Moderator | One community + its course feeds | Creator (from member list); Admin can also appoint | `community_moderators` table |

**Trigger:** Client needs per-community moderation. Single global flag insufficient — Creators need to appoint trusted community members for day-to-day feed oversight when they and their teachers are unavailable.

**Options Considered:**
1. **Add `moderator` to `community_members.member_role` enum** — Rejected. Dual-role problem: a user who is both a member and a moderator would need to change their `member_role` field. Current enum values (`creator`, `teacher`, `member`) are mutually exclusive in intent. Adding `moderator` conflates membership role with moderation authority.
2. **Separate `community_moderators` table** ← **Chosen.** Follows the `teacher_certifications`[^tc] pattern: per-entity relationships with their own metadata (appointed_by_user_id, revoked_by_user_id, revoke_reason). User keeps their `community_members.member_role = 'member'` AND gets a `community_moderators` row.
3. **Per-course `course_moderators` table** — Rejected. Too granular. Community is the natural scope unit — courses inherit moderation via Community → Progression → Course chain. Per-course assignment would create N moderator rows for N courses in a community when the intent is community-wide.

**Stewardship Stack (hierarchical oversight model):**
```
Creator → Teachers → Community Moderator → Global Moderator
(community owner)  (course support)  (day-to-day feed)   (platform policy)
```

**Rationale:** Community is the natural scope unit for moderation. Creators own communities. Courses belong to communities via progressions. Moderating a community implicitly covers all its course feeds. This matches how Discord and Reddit scope moderator authority (server/subreddit level, not channel level).

**See:** `docs/reference/ROLES.md` (§5 Moderator Two-Tier Model), `docs/reference/DB-GUIDE.md` (Moderation System section)

### Community Moderator Direct Appointment (Not Invite)
**Date:** 2026-02-23 (Session 263)

Community Moderators are appointed directly by the Creator from the community member list. No email invite flow — the user is already a known community member.

**Contrast with Global Moderators:**
- **Global Moderator:** Admin sends email invite → user accepts → `can_moderate_courses` set. Invite flow needed because the person may not have a Peerloop account yet.
- **Community Moderator:** Creator selects from existing member list → `community_moderators` row created immediately. No invite needed because the person is already a registered, active community member.

**Options Considered:**
1. **Reuse the moderator invite email flow** — Rejected. User is already known (they're in the community member list). An invite-accept roundtrip adds friction for no benefit. The invite flow exists for Global Moderators precisely because the invitee might not have an account.
2. **Direct appointment from member list** ← **Chosen.** Simpler UX. Creator sees member list → clicks "Appoint as Moderator" → done. Revocation is equally direct.

**Rationale:** The invite flow was designed for recruiting new platform moderators who might not exist in the system. Community moderators are selected from people who are already active members. A direct appointment is the right UX for this scenario.

**See:** `docs/reference/ROLES.md` (Tier 2: Community Moderator → How to Become)

### Two-Tier Moderation Access Pattern (requireModerationAccess)
**Date:** 2026-02-23 (Session 267)

All 6 moderation endpoints use `requireModerationAccess(cookies, jwtSecret, db)` instead of `requireRole(['admin', 'moderator'])`. The helper returns `{ session, scope }` where scope is `{ type: 'global' }` for admin/moderator (JWT) or `{ type: 'community', communityIds: [...] }` for community moderators (DB query).

**Tier capabilities:**
- **Tier 1 (global):** See all flags, dismiss, remove, warn, suspend
- **Tier 2 (community):** See community-scoped flags only, dismiss, remove. Cannot warn or suspend (enforced by `canPerformElevatedAction(scope)`)

**Scope enforcement:** Out-of-scope flags return 404 (not 403) to prevent information leakage. Queue listing (`GET /api/admin/moderation`) adds `WHERE community_id IN (...)` for Tier 2. Stats are also scoped.

**Flag community scoping:** `content_flags.community_id` (nullable, ON DELETE SET NULL) + `feed_group` track which community a flag belongs to. Townhall and profile flags have null community_id, making them invisible to Tier 2 moderators (SQL IN naturally excludes NULLs).

**Rationale:** DB-backed scope is always fresh (no stale JWT claims). JWT check happens first (fast path for admins). Typed scope object lets each endpoint enforce its own rules.

**See:** `src/lib/auth/moderation.ts`, moderation endpoints in `src/pages/api/admin/moderation/`

### Creator Access: Permission Flag vs Course State
**Date:** 2026-03-01 (Session 319)

Two distinct concepts for "is creator" exist and must be used differently:

- **Permission** (`can_create_courses` flag): "May this user create?" — set by admin approval
- **State** (course count subquery): "Has this user created?" — derived from data

**Gate rules:**
- **Create** new courses/communities → Permission only (`can_create_courses = 1`)
- **View/manage** dashboard, courses, earnings, analytics, communities → Permission OR State

**Revocation policy:** When admin revokes permission, only creation of new resources is blocked. Full access to existing courses/communities is retained (managed via ownership checks).

**Rationale:** New creators (permission=1, courses=0) must access the dashboard. Revoked creators (permission=0, courses>0) must manage existing content. The OR gate handles both. POST endpoints stay permission-only as a creation guard.

> **Insight:** Permission and state answer fundamentally different questions. Most access control systems conflate them — checking "has this user done X?" as a proxy for "may this user do X?" works until the first edge case (new user who hasn't done X yet, or revoked user who has). Separating them explicitly in the gate pattern prevents an entire category of chicken-and-egg bugs. (Session 319)

**See:** `POLICIES.md` for full policy.

### useCreatorGate Hook for Client-Side Access Gating
**Date:** 2026-03-01 (Session 320)

All `/creating/*` page components use the `useCreatorGate()` hook for client-side access gating. The hook reads `CurrentUser` global state (Permission OR State = Pattern C) with a stale-cache refresh fallback, and returns `{ status: 'loading' | 'creator' | 'not-creator', hasCourses: boolean }`.

**Components:** CreatorDashboard, CreatorStudio, CreatorAnalytics, CreatorCommunities, CreatorEarningsDetail.

**Rationale:** Before the hook, 5 components used 4 different access patterns — some checked 403 responses inline, one pre-fetched `/api/me/courses` just for a course count, and two had no check at all. The `CurrentUser` global already contains `canCreateCourses` and `hasCreatedCourses()`, making separate API calls redundant. The hook provides consistent "Creator Access Required" UI across all pages and eliminates unnecessary network requests.

**Stale-cache recovery:** If cached `CurrentUser` says "not creator," the hook calls `refreshCurrentUser()` before denying access. This handles the scenario where admin just approved a creator application while the user's tab was open.

**Security model:** The client-side gate is purely UX — it prevents wasted API calls and shows a friendly message. Server-side API gates (Pattern C on each endpoint) remain the authoritative security enforcement layer.

**See:** `POLICIES.md` §1 "Client-Side Creator Gate". `src/components/auth/useCreatorGate.ts`.

### Enforce Teacher-Enrollment Match on Session Booking
**Date:** 2026-03-04 (Session 325), updated 2026-03-16 (Session 389)

`POST /api/sessions` validates that the `teacher_id` matches `enrollment.assigned_teacher_id`[^at]. Returns 403 "Teacher does not match your enrollment" if mismatched. A student enrolled with teacher A can only book sessions with teacher A.

**Update (Session 389):** When `assigned_teacher_id` is NULL (student enrolled without selecting a teacher), the first booking assigns the selected teacher by backfilling `assigned_teacher_id` and `teacher_certification_id` on the enrollment. Subsequent bookings enforce the match. This supports the enrollment flow where `EnrollButton` doesn't always pass a `teacherId` (e.g., course detail page with no teacher pre-selected).

**Rationale:** The enrollment establishes the student→teacher relationship. Downstream actions must validate against this binding, not just validate entities independently. The NULL-backfill pattern treats "not yet assigned" differently from "assigned to someone else" — the former is a deferred choice, the latter is a security boundary.

**See:** `src/pages/api/sessions/index.ts`, `docs/as-designed/session-booking.md`

### Messaging Access Control: Relationship-Gated DMs
**Date:** 2026-03-05 (Session 338)

Direct messaging requires authentication plus a platform relationship between sender and recipient. A shared `canMessage(db, senderId, recipientId)` function enforces the policy across three API endpoints: `POST /api/conversations` (create), `POST /api/conversations/:id/messages` (send), and `GET /api/users/search` (filter).

Enforcement uses a two-layer model: Layer 1 (UX) controls button visibility on 28 audited surfaces. Layer 2 (API) is the authoritative security boundary. If layers disagree, Layer 2 wins.

Student-to-student messaging is blocked for MVP (US-S017, P2). Existing conversations remain readable but unsendable if the relationship ends.

**Rationale:** The original implementation allowed any user to message any other user, contradicting user stories (US-S016, US-S017, US-S018). Relationship gating matches design intent and prevents abuse vectors at scale.

**See:** `POLICIES.md` section 4 (rules), `docs/as-designed/messaging.md` (surface catalog + phased implementation)

> **Insight:** The user search endpoint is the natural chokepoint for messaging access control. Rather than adding complex checks at conversation creation time only, filtering the search results by relationship at the discovery layer prevents users from finding contacts they can't message. This "can't message someone you can't find" pattern is common in platforms like LinkedIn (InMail gating) and Slack (workspace boundaries). The API gate remains necessary as defense-in-depth against direct URL manipulation (`/messages?to=<id>`). (Session 338)

### Messaging Relationship Check: Three-Function Architecture
**Date:** 2026-03-05 (Session 341)

The messaging relationship check is implemented as three functions in `src/lib/messaging.ts`, each serving a different query pattern:

| Function | Use Case | Performance |
|----------|----------|-------------|
| `canMessage(db, senderId, recipientId)` | API gates (conversation creation, message sending) | Delegates to batch |
| `getMessageableFlags(db, senderId, ids[])` | List annotation (show/hide Message button per user) | O(4 queries) regardless of list size |
| `messageableContactsSQL(db, senderId)` | Search filtering (returns SQL WHERE clause) | O(1 query) + composable SQL |

`getMessageableFlags` returns `Record<string, boolean>` (annotation flags), not a filtered list. This lets callers show all users but conditionally render the Message button — display logic stays separate from messaging logic.

**Rationale:** Single-pair check is too slow for lists (N+1 queries). Batch check can't integrate with SQL LIMIT (post-query filtering breaks pagination). Three functions cover all three access patterns with the relationship rules defined in exactly one place.

**See:** `src/lib/messaging.ts`, `docs/as-designed/messaging.md` (Phase 1 complete)

### Astro Middleware for Centralized Authentication Guards
**Date:** 2026-03-29 (Conv 053)

Centralize authentication enforcement in `src/middleware.ts` with route classification. Middleware checks JWT only (no DB queries). Routes classified as `PROTECTED_PREFIXES` (match path + sub-paths, e.g., `/admin/*`) and `PROTECTED_EXACT` (match bare path only, e.g., `/community` but not `/community/[slug]`). Individual pages and API endpoints retain authorization logic (role checks, enrollment verification).

**Rationale:** Single point of enforcement, easy to extend. The two-set route classification handles Peerloop's "bare = my" URL convention (`/courses` = My Courses, `/community` = My Communities) where the bare path is member-only but sub-paths are public.

> **Insight:** When URL conventions use the same base path for both authenticated (bare) and public (with slug) content, a simple prefix match either over-blocks or under-blocks. Splitting into prefix + exact-match sets keeps the middleware declarative without restructuring URLs.

**See:** `src/middleware.ts`, `tests/middleware.test.ts` (86 tests)

### Onboarding Is UX, Not a Security Gate
**Date:** 2026-03-29 (Conv 053)

Removed onboarding enforcement from middleware entirely. OAuth callback redirects fresh users to `/onboarding` as a first-touch nudge. Pages that use interest data show component-level nudges ("complete your profile" banner). Users who skip onboarding get a degraded experience but are not trapped.

**Rationale:** Onboarding completion is a UX concern, not a security concern. Middleware should only handle authentication ("are you logged in?"), not UX flows. Simplified middleware by ~80 lines and removed `peerloop_onboarded` cookie infrastructure.

### Remove Username Field from Signup — Auto-Generate Handle Server-Side
**Date:** 2026-03-31 (Conv 067)

Username/handle field removed from the signup form entirely. Server auto-generates handle from the user's name (lowercase, strip non-alphanumeric, max 20 chars) with incrementing collision suffix (`testwalker`, `testwalker1`, `testwalker2`...). Users customize their handle later in profile settings.

**Rationale:** The handle field caused the most UX stumbles during STUMBLE-AUDIT: 3 different validators with conflicting rules, unclear auto-generation, poor collision UX, and the field felt optional but was required. Removing it reduces signup to 4 fields and follows Twitter/Discord patterns. Eliminates 4 open issues at once.

> **Insight:** When a form field generates multiple UX issues (confusion, validation mismatch, collision handling), removing it entirely is often better than fixing each issue individually. Auto-generation with later customization follows established patterns and reduces signup abandonment risk.

**See:** `src/pages/api/auth/register.ts`, `src/components/auth/SignupForm.tsx`

### Post-Signup Redirect to /onboarding
**Date:** 2026-03-31 (Conv 067)

`handleAuthSuccess()` now distinguishes signup from login via a `wasSignup` flag. After signup with no pending action (e.g., no returnUrl from ModeratorInvite), new members redirect to `/onboarding`. Login behavior unchanged — returns to previous page or home.

**Rationale:** Complements the "Onboarding Is UX, Not a Security Gate" decision (Conv 053). While onboarding isn't enforced, directing new signups there immediately gives the best first-touch experience. Pending actions (returnUrl) take priority over the onboarding redirect.

**See:** `src/lib/auth-modal.ts`

### Handle Validation: Social Platform Standard
**Date:** 2026-04-01 (Conv 068)

Unified three conflicting handle validators to a single pattern: `^[a-zA-Z][a-zA-Z0-9_]{2,19}$` — must start with letter, letters/numbers/underscores only, 3-20 chars. Single source of truth in `auth/index.ts` with `isValidHandleFormat()` boolean export for call sites.

**Rationale:** Matches Twitter/Instagram conventions. Hyphens in handles create @mention parsing ambiguity. Max 20 aligns with auto-generation cap. Existing auto-generated handles (lowercase alphanumeric) are already compliant.

> **Insight:** When multiple validators for the same field diverge across codebase locations, the fix isn't reconciling them — it's extracting a single source of truth and importing everywhere. Divergent copies will always drift again.

**See:** `src/lib/auth/index.ts`, `src/pages/api/me/profile.ts`, `src/components/settings/ProfileSettings.tsx`

---

## 5. UI/UX & Components

### Show Unavailable Teachers with Visual Distinction
**Date:** 2026-03-11 (Session 371)

On the booking page, show all certified teachers for a course — including those with no availability — rather than filtering them out. Unavailable teachers are greyed out with a "No availability" badge and cannot be selected.

**Rationale:** The client plans to allow students to message teachers/creators to request teaching. Hiding unavailable teachers would prevent discovery. Visual distinction communicates "exists but not bookable now" without removing information.

### Teacher Pre-Assignment Auto-Advance in Booking Wizard
**Date:** 2026-03-11 (Session 371)

When a student's enrollment has an `assigned_teacher_id` (set at checkout), the booking wizard auto-advances to step 2 (date selection) and shows a compact teacher banner. Step 1 remains viewable via the stepper.

**Rationale:** The teacher was already chosen at purchase. Requiring re-selection is a pointless speed bump. Auto-advance respects the constraint while keeping all information visible.

### Notification Cards: Separate Read from Navigate
**Date:** 2026-03-11 (Session 372)

Notification cards use card click to mark as read, and an explicit labeled button ("Go to Session →", "Browse Courses →") for navigation. Replaced the previous "stretch link" pattern (invisible `<a>` overlay making entire card clickable) which had three UX problems: not obvious the card is clickable, no indication of destination, and click-to-navigate collides with click-to-mark-read.

**Rationale:** Two distinct user intents (read vs navigate) need two distinct interactions. The button is discoverable on mobile where hover states don't exist, and the label tells the user exactly where they'll go.

**See:** `src/components/notifications/NotificationsList.tsx`

### Course Page Merge: Learn Tab Replaces Standalone /learn Page
**Date:** 2026-03-12 (Session 379)

Merge the learning workspace (`/course/{slug}/learn`) into the course detail page as an enrolled-only "Learn" tab with accordion modules. Remove the standalone CourseLearning orchestrator and Curriculum tab. Enrolled students default to the Learn tab; visitors see About.

**Trigger:** Students had two overlapping pages per course (detail + learn) showing duplicate content (curriculum, resources, progress, sessions). Navigation between them was confusing.

**Rationale:** Single page eliminates the navigation gap. The accordion design shows module titles when collapsed (post-purchase reassurance) and expands to full ModuleContent inline. The `/course/{slug}/learn` URL still works as a tab page, so no bookmarks break.

**Consequences:** `CourseLearning.tsx` (579 lines) and `ModuleSidebar.tsx` (110 lines) retired. New `LearnTab.tsx` (~300 lines) and `ModuleAccordion.tsx` (~130 lines) created. Curriculum tab removed. learn.astro converted from standalone to tab page pattern.

**See:** `src/components/courses/LearnTab.tsx`, `src/components/courses/ModuleAccordion.tsx`

### Teachers Tab: Assigned-Teacher Booking Gating
**Date:** 2026-03-12 (Session 379)

For enrolled students, the Teachers tab shows all course teachers but only the assigned teacher's Book Session button is active. Disabled when: (a) not the assigned teacher, or (b) all modules already have sessions booked. Added "Your Teacher" badge on the assigned teacher's card.

**Rationale:** Students should see all teachers (social proof) but shouldn't be confused by multiple active Book Session buttons when they have an assigned teacher. The gating also prevents over-booking beyond available modules.

**See:** `src/components/courses/course-tabs/TeachersTabContent.tsx`

### CourseTabs Decomposition: Per-Tab Sub-Components + extraTabs Prop
**Date:** 2026-03-27 (Conv 040)

Break CourseTabs (1392 lines) into 5 sub-component files (`AboutTabContent`, `TeachersTabContent`, `ResourcesTabContent`, `SessionsTabContent`, `course-tabs/types.ts`) plus a thin shell (~195 lines). The shell accepts `extraTabs: ExtraTabConfig[]` and `basePath` props, allowing any caller to inject role-specific tabs without modifying CourseTabs internals.

**Rationale:** Each render function was already self-contained. Decomposition solved both the monolith maintenance problem and a UX problem where role tabs (Teaching, Creator) were buried below the fold in a separate section. The shell stays role-agnostic; the explore page passes role tabs via props.

> **Insight:** Wrapping a monolith to avoid modifying it can create worse UX than the engineering cost it saves. The Conv 039 approach kept CourseTabs untouched but placed role tabs in an invisible location. The user cut through the complexity: "only one version survives" — making the wrapping workaround unnecessary friction.

**See:** `src/components/courses/CourseTabs.tsx`, `src/components/courses/course-tabs/`

### Catch-All `[...tab].astro` for Tab Sub-Routes
**Date:** 2026-03-28 (Conv 042)

Use a single `[...tab].astro` catch-all file instead of per-file sub-routes for bookmarkable tab URLs. Tab ID validation via `VALID_TABS` Set; invalid segments redirect to base course page. Applied first to `/discover/course/[slug]/[...tab].astro` (15 valid tab IDs: 6 standard + 9 role-specific).

**Rationale:** 1 file vs 8+. Adding new tabs only requires adding to the Set. SSR code is duplicated between index.astro and catch-all, but that's 2 files not 9. Could be retrofitted to `/course/[slug]/` in a future cleanup.

**See:** `src/pages/discover/course/[slug]/[...tab].astro`

### CSS-Based Image Fallbacks
**Date:** 2025-12-27

Use CSS overlay with Tailwind classes instead of external placeholder service.

**Rationale:** Full control over styling; consistent appearance; no external dependency.

### NULL Image URLs in Seed Data
**Date:** 2025-12-27

Set all `thumbnail_url` and `avatar_url` to NULL in seed data.

**Rationale:** Tests fallback rendering path; no 404 errors; clear indication real images needed.

### Toggleable Spec Panel for Development
**Date:** 2025-12-27

Implement toggle button switching between spec view and content view with localStorage persistence.

**Rationale:** Keep documentation accessible while building real content.

### Footer Version Display
**Date:** 2025-12-30

Display version after Privacy/Terms links with commit hash in tooltip. Environment badge: DEV=blue, STG=orange, hidden in PROD.

**Rationale:** Version accessible but unobtrusive; badge helps developers identify environment.

### Course Page Tab Architecture
**Date:** 2026-02-05 (Session 192)

Course detail pages (`/course/[slug]`) use a 7-tab URL-aware interface: **About → Teachers → Resources → Feed → Sessions → Learn → Curriculum**.

| Tab | Visibility | Data Strategy | Route |
|-----|-----------|---------------|-------|
| About | Public (default for visitors) | Server-side | `/course/[slug]` |
| Teachers | Public view; enrolled can book assigned teacher | Server-side (expanded teacher query) | `/course/[slug]/teachers` |
| Resources | Public preview + enrolled full | Client-side fetch (`/api/courses/:id/resources`) | `/course/[slug]/resources` |
| Feed | Enrolled only | Server-side (Stream.io) | `/course/[slug]/feed` |
| Sessions | Enrolled only | Server-side (student's sessions for this course) | `/course/[slug]/sessions` |
| Learn | Enrolled only (default for enrolled) | Server-side (accordion modules + progress) | `/course/[slug]/learn` |
| Curriculum | Enrolled only (being retired) | Server-side | `/course/[slug]/curriculum` |

**Tab ordering rationale:** Follows the student discovery journey — learn about the course, meet teachers, preview materials, see community, then engage with sessions and learning.

**Default tab behavior:** Enrolled students land on the Learn tab; visitors see the About tab. This is handled by `CourseTabs.tsx` based on enrollment state.

**Data strategy:** Tabs use server-side data (passed as props from Astro page) when the data is simple joins. Resources uses client-side fetch because the API encapsulates enrollment gating, R2 download URL generation, and public/private filtering.

**Each tab has a dedicated `.astro` page** for SSR bookmarkability, with `initialTab` prop controlling which tab renders active. Client-side tab switching uses `history.pushState` for SPA-like navigation.

**Key components:** `CourseTabs.tsx` (~195-line shell: tab bar + URL sync + `extraTabs`/`basePath` props), per-tab sub-components in `course-tabs/` (AboutTabContent, TeachersTabContent, ResourcesTabContent, SessionsTabContent), `LearnTab.tsx` (module list + progress tracking), `ModuleAccordion.tsx` (individual module card with 4 visual states: completed, future, future+booked, expanded).

**See:** `src/components/courses/CourseTabs.tsx`, `src/components/courses/course-tabs/`, `docs/as-designed/url-routing.md`

**History:** Originally 5 tabs (Session 192). Sessions and Learn tabs added (Session 377). Standalone `/course/[slug]/learn` page merged into Learn tab as accordion design (Session 379, COURSE-PAGE-MERGE). Curriculum tab will be retired (absorbed into Learn). Decomposed from 1392-line monolith into per-tab sub-components + thin shell (Conv 040).

### Breadcrumb System: Route-Based Defaults + `?via=` Context
**Date:** 2026-02-17 (Session 221)

Breadcrumbs use a reusable `Breadcrumbs.astro` component rendered inside each page's content area (above the `<h1>`). Each page defines its own breadcrumb items. Navigation context is passed via `?via=` query parameters that replace the default trail entirely.

| Via Value | Trail Example |
|-----------|--------------|
| (none/default) | `My Communities > AI Tools` |
| `discover-communities` | `Discover > Communities > AI Tools` |
| `community-courses` | `AI Tools > Courses > Intro to Claude Code` |
| `discover-courses` | `Discover > Courses > Intro to Claude Code` |

**Rationale:** Route-based defaults work for most cases. `?via=` adds context without hidden state — survives refresh, works with bookmarks, requires no client JS. Breadcrumbs are page-owned (not in layout) because top-level pages don't need them. Clean trail replacement (not dual annotation) keeps the UI simple.

**See:** `src/components/ui/Breadcrumbs.astro`, `src/pages/discover/communities.astro`, `src/pages/community/[slug]/index.astro`

### Stretched-Link Pattern for Clickable Cards with Secondary Links
**Date:** 2026-02-17 (Session 222)

Use the stretched-link pattern for any card component that has a primary clickable area with secondary links inside. Outer element is a `<div>` with `position: relative`, the primary link's `::after` pseudo-element stretches to cover the card (`after:absolute after:inset-0`), and secondary links use `relative z-10` to sit above the overlay.

**Rationale:** Nested `<a>` tags are invalid HTML and cause React hydration errors. The `<span role="link">` + `onClick` workaround loses middle-click, right-click, status bar preview, crawlability, and View Transitions. The stretched-link pattern preserves all native link behaviors for both primary and secondary links.

**See:** `src/components/courses/CourseCard.tsx`, `src/components/notifications/NotificationsList.tsx`

### Three-Tier Navigation Strategy
**Date:** 2026-02-17 (Session 222)

Three methods for navigation, each with a specific use case:
- **`<a href>`** — Default for all navigable UI elements (links, menu items, cards)
- **`navigate()` from `astro:transitions/client`** — Programmatic internal navigation after API calls (post-booking redirect, post-mutation page refresh)
- **`window.location.href`** — Reserved for auth boundary crossings (login/logout) and external URL redirects (Stripe, BBB)

**Rationale:** Auth boundaries intentionally need full page reload to clear stale React state. All other internal navigation should use View Transitions for smooth UX. External URLs can't use Astro's router.

**See:** `src/components/booking/SessionBooking.tsx` (navigate), `src/components/context-actions/ContextActionsPanel.tsx` (navigate for soft refresh)

### Dual Icon System: Separate Registries for Astro and React
**Date:** 2026-02-06

Maintain two separate icon systems: `icon-paths.ts` (raw HTML path strings for Astro's `Icon.astro`) and `icons.tsx` (JSX components for React islands). The Astro registry stores raw SVG path data as strings; the React file stores JSX components with React-style attributes (`strokeLinecap`, `strokeWidth`).

**Rationale:** Unifying them would require refactoring every React component that imports from `icons.tsx` — massive blast radius for an Astro-side cleanup. HTML attributes (`stroke-linecap`) and JSX attributes (`strokeLinecap`) are structurally different. Keeping them separate is zero-risk to the working React system. Future unification is possible but deferred.

**See:** `src/lib/icon-paths.ts`, `src/components/ui/Icon.astro`, `src/components/ui/icons.tsx`

### chart.js Replaces Recharts for Analytics Charts
**Date:** 2026-02-06 (Session 209)

Replace Recharts with chart.js + react-chartjs-2 for all analytics chart components (area, bar, pie/donut). chart.js is canvas-based and tree-shakeable via its register pattern.

**Rationale:** Recharts bundled 392 KB (115 KB gzip) — nearly 2x the React runtime — because it includes large D3 internals monolithically. chart.js with selective registration produces 188.5 KB (65.6 KB gzip), a 43% gzip reduction. Canvas rendering is better for analytics dashboards. The existing abstraction layer (`@components/ui/charts`) meant zero consumer changes.

**See:** `src/components/ui/charts/chart-setup.ts`, `src/components/ui/charts/AreaChart.tsx`

### AppNavbar: excludeCapabilities for Inverse Menu Filtering
**Date:** 2026-02-21 (Session 244)

Added `excludeCapabilities` to AppNavbar's `MenuItem` interface as the inverse of `capabilities`. Items with `capabilities` show when a user HAS any listed capability; items with `excludeCapabilities` hide when a user HAS any listed capability.

**Rationale:** Needed for "Become a Creator" (visible only to non-creators) alongside "Creating" (visible only to creators). A generic `excludeCapabilities` array is reusable for future inverse-visibility cases. A `hasCap()` helper was extracted to avoid duplicating the capability switch statement.

**See:** `src/components/layout/AppNavbar.tsx`

### Month Calendar as Single Availability Interface
**Date:** 2026-02-25 (Session 287)

The old weekly grid editor (`AvailabilityEditor.tsx`) is replaced by a month-view calendar. No separate weekly/monthly tabs. Recurring patterns are set within the same flow — after marking a day, prompt "Just this day" or "Every [Tuesday] for [N] weeks." Two interaction modes: ad hoc (click one day) and multi-select (click multiple days).

**Rationale:** Two views for overlapping concepts creates confusion. The month calendar handles everything the weekly editor does (via recurring prompt) plus date-specific overrides. One interface, two modes, recurring as an option within the flow.

**See:** `CURRENT-BLOCK-PLAN.md` (S-T-CALENDAR.INTERACTION section)

### react-day-picker v9 as Calendar Engine
**Date:** 2026-02-25 (Session 287)

Use `react-day-picker` v9 as the month grid engine for the availability calendar. It handles calendar math, keyboard navigation, and accessibility while we render fully custom `Day` components with 6 indicator types (time range, recurring, override, series-end, booked, unavailable).

**Rationale:** Only package supporting full Day component replacement AND built-in non-contiguous multi-select (`mode="multiple"`). Headless/unstyled (Tailwind-native), ~22 kB bundle, 10.6M weekly downloads, MIT. Evaluated and rejected: FullCalendar (no multi-select, opinionated CSS), react-calendar (can't replace cells), react-big-calendar (170 kB), @schedule-x (event-level only).

**See:** `CURRENT-BLOCK-PLAN.md` (S-T-CALENDAR.DESIGN-DECISIONS section)

### URL Query Params for Sub-View Navigation in Astro
**Date:** 2026-03-01 (Session 318)

Use URL query parameters (e.g., `/creating/studio?course=<id>`) for sub-view navigation within a single Astro route, rather than React state. The React component reads the param in a `useEffect` (SSR-safe), while the Astro page reads `Astro.url.searchParams` server-side for breadcrumbs and title.

**Rationale:** URL params provide refresh-safety, browser back button support, and bookmark-ability. Consistent with existing patterns (`Messages.tsx` uses `?to=`, `StripeConnectSettings.tsx` uses `?success=`). The full-page-reload tradeoff is acceptable and consistent with Astro's MPA model.

**See:** `src/components/creators/studio/CreatorStudio.tsx`, `src/pages/creating/studio.astro`

### Custom Platform Calendar Over Library
**Date:** 2026-03-05 (Session 342)

Build a fully custom `PeerloopCalendar` component with year, month, week, and day views rather than adopting react-big-calendar or another library. The component accepts typed `CalendarItem[]` arrays and renders them — it doesn't know what the items are. Role-specific pages fetch and combine data layers based on active filters.

**Trigger:** Audit found 3 independent custom month grids, no week/day views, and react-big-calendar installed but never imported. User wants year/month/week/day views for students, teachers, and admins with extensive filtering and clickable items.

**Options Considered:**
1. Adopt react-big-calendar for week/day views, keep custom month grid — mixes two systems
2. Build fully custom `PeerloopCalendar` ← Chosen
3. Use a different library (FullCalendar, etc.) — same customization friction

**Rationale:** The platform needs cell-level control: availability multi-select, heat-map year views, togglable data layers, role-specific filtering, and Tailwind styling. A library would fight every customization. Custom means the calendar grows with the platform.

**See:** PLAN.md CALENDAR block

### Smart Feed Card Visual System — Source-Type Differentiation
**Date:** 2026-03-20 (Conv 020)

Feed cards are visually differentiated by source type using a `border-l-4` colored accent bar, background tint, and optional right-side source image strip. Color mapping: townhall=`primary` (sky-blue), community=`secondary` (neutral/white), course=`indigo`. Card self-determines its color from activity data — no new props needed.

**Rationale:** Left accent bar is scannable at a glance in mixed Smart Feed, takes zero horizontal space, and composes with the existing highlight ring system (instructor/creator). Indigo used for courses because `primary` (sky-blue) and standard Tailwind `blue` are visually indistinguishable at light tint levels.

### Astro Hydration: client:only="react" for useCurrentUser() Components
**Date:** 2026-03-20 (Conv 020)

Use `client:only="react"` instead of `client:load` for any component that branches on `useCurrentUser()` in its first render. `useCurrentUser()` reads from `window.__peerloop` (not available during SSR), causing hydration mismatch when server renders a loading skeleton but client renders populated state.

**Rationale:** No SEO benefit to SSR for authenticated-only pages. `client:only` skips SSR entirely, avoiding the mismatch while giving identical user experience (loading skeleton still shows briefly from React's initial state).

### Unified Gradient+Initial Avatar Fallback (No placehold.co)
**Date:** 2026-03-20 (Conv 023)

All avatar fallbacks use the `UserAvatar` gradient+initial pattern (`bg-linear-to-br from-primary-400 to-primary-600` with white initial letter). No external `placehold.co` dependency. `UserAvatar` component supports sizes: `xs` (h-6), `sm` (h-8), `md` (h-12), `lg` (h-16), `xl` (h-24). Custom sizes use inline gradient divs with the same styling.

**Rationale:** Eliminates external service dependency, works offline, renders faster, consistent branded look across all components.

**See:** `src/components/users/UserAvatar.tsx`

### Community Cover Image Display — Icon Replacement Pattern
**Date:** 2026-03-20 (Conv 023)

Community cover images (`cover_image_url`) replace the icon/emoji square in the same layout position. Fallback chain: cover image → emoji icon → gradient. Rectangular styling (`rounded-lg object-cover`) not circular like avatars.

**Rationale:** Minimal layout change, works across all contexts (cards, headers, feed directory). Applied to community detail pages, index page, discover page, FeedsHub, and creator dashboard CommunityCard.

### Stream API Timeout (10s AbortController)
**Date:** 2026-03-20 (Conv 020)

All Stream API calls via `streamFetch()` use a 10-second `AbortController` timeout. The existing try/catch in enrichment catches the abort error and falls back to D1-only data.

**Rationale:** Without a timeout, a hanging Stream response hangs the entire Worker request indefinitely — no error, no fallback, unrecoverable even in dev. Discovered when investigating a user-facing infinite hang.

### Unified Dashboard as Additive Page (Not Replacement)
**Date:** 2026-03-25 (Conv 032)

The unified `/dashboard` page uses activity-first sections (Schedule, Needs Attention, Courses, People, Earnings) with role sub-columns, rather than role-first tabs. Original role-specific pages (`/learning`, `/teaching`, `/creating`) remain unchanged and accessible via a Dashboard Links button row at the top.

**Rationale:** Additive approach is zero-risk — composes existing components without modifying them. Activity-first grouping enables cross-role insights (e.g., merged "Needs Attention" across teacher and creator roles) that tabbed approaches cannot provide. Route consolidation deferred to after user evaluation.

> **Insight:** Activity-first vs role-first is the dashboard equivalent of the "normalize by entity vs normalize by use case" database debate. Activity-first wins when a single user holds multiple roles simultaneously, because it surfaces cross-role correlations (like a homework review that appears in both teacher and creator contexts) that role silos hide.

### Dashboard as Single Nav Entry Point
**Date:** 2026-03-26 (Conv 033)

Removed Learning, Teaching, and Creating menu items from AppNavbar. `/dashboard` is the single navigation entry point for all dashboard functionality. Role-specific pages (`/learning`, `/teaching`, `/creating`) remain accessible via direct URL and the DashboardLinks button row on `/dashboard`.

**Rationale:** Unified dashboard (Conv 032) made role-specific nav items redundant. DashboardLinks component already provides drill-down. Eliminates nav crowding. The `become-creator` CTA is retained for non-creators.

**See:** `src/components/layout/AppNavbar.tsx`, `src/components/dashboard/DashboardLinks.tsx`

### Discover Feeds: Discovery Page, Not Feed Inventory
**Date:** 2026-03-28 (Conv 044)

`/discover/feeds` reframed from "My Feeds" inventory to a visitor-accessible discovery page showing active public feeds with "Join Community →" / "View Course →" CTAs. Feeds are derivative artifacts (you get them by joining communities/enrolling in courses), so discovery targets the parent entity, not the feed itself. Reuses existing Smart Feed `getDiscoveryCandidates()` pipeline (~70% overlap). Auth users see topic-matched results; visitors see vitality-ranked popular feeds.

**Rationale:** You can't "join a feed" directly — discovery should surface active conversations with CTAs to the subscribable entity (course/community). Feed-level cards (C1) shipped first; thread-level previews (C2) deferred pending user behavior validation.

> **Insight:** When a domain object is derivative (created as a side-effect of joining something else), discovery UX should target the subscription level, not the artifact level. The artifact is the hook ("look at this conversation"), but the CTA must point to the subscribable parent.

### Admin Tab Pattern for Inline Admin Capabilities
**Date:** 2026-03-28 (Conv 046)

When an admin visits a regular page (course, community, profile), an "Admin" tab appears alongside existing role tabs (Student/Teaching/Created) showing admin-specific actions. This surfaces admin capabilities inline rather than requiring context-switching to `/admin/*` pages.

**Rationale:** Consistent with the discover pages pattern where role tabs appear based on your roles. More discoverable than a floating action button. Handles the complexity of admin also being student/teacher/creator — each role gets its own tab. Deferred to ADMIN-PAGE-ROLE block (#38) in PLAN.md.

> **Insight:** When privileged users have a dedicated admin section but zero inline presence on regular pages, they must context-switch between "browsing" and "administering." Surfacing capabilities via role tabs keeps the admin in-flow while maintaining clean separation from regular user UI.

### useAuthStatus Hook — Separate from useCurrentUser
**Date:** 2026-03-29 (Conv 052)

Added `useAuthStatus()` as a separate reactive hook rather than changing `useCurrentUser()`'s return type. Components that show skeleton loaders use `authStatus === 'loading'` to distinguish "still loading" from "not authenticated" — preventing infinite skeletons when sessions expire after SSR.

**Rationale:** Zero breaking changes across 14 existing `useCurrentUser()` consumers. Mirrors the existing `subscribeToUserChange` listener pattern. The `AuthStatus` type (`loading | authenticated | visitor | session_expired | error`) was already defined in `NetworkState` but not exposed reactively.

### Hydration-Safe Hooks by Default
**Date:** 2026-03-29 (Conv 054)

`useCurrentUser()` and `useAuthStatus()` initialize with SSR-compatible values (`null` / `'loading'`), then populate from localStorage cache in `useEffect`. This ensures the first client render matches server HTML in Astro `client:load` islands. The fix lives in the hooks themselves — not in per-component `hasMounted`/`effectiveUser` workarounds.

**Rationale:** Per-component hydration guards appeared in 3 files before the pattern was identified as systemic. Hook-level fix is 2 lines in one file vs ~15 lines across every consumer. Any future component gets hydration safety for free. Brief additive flash on discover pages (role tabs/badges appearing) is imperceptible.

**Pattern:** `useState(null)` + `useEffect(() => setState(getFromCache()), [])` instead of `useState(() => getFromCache())`.

> **Insight:** When an SSR framework hydrates client components, any hook that reads browser-only state (localStorage, cookies, window) must defer that read to useEffect. Initializing with the browser value creates a hydration mismatch on every page load — the fix must live in the hook, not in consumers, because the invariant (SSR = null) is universal.

### Vitality as Ranking Signal, Not Inclusion Gate
**Date:** 2026-03-29 (Conv 052)

Removed `vitality > 0` filter from feed discovery (5 locations across `discover.ts` and `candidates.ts`). Vitality is used only for `ORDER BY` ranking — feeds with zero activity still appear but rank last.

**Rationale:** Using vitality as an inclusion gate creates a cold-start paradox: new feeds have no posts, so they're never shown, so they can never get posts. Critical for genesis cohort when most feeds will have zero activity. "0 posts in 2 weeks" shown transparently to users.

> **Insight:** Cold-start filtering is a common trap in recommendation systems — any hard threshold that excludes items with no engagement data creates a bootstrapping paradox where new content can never gain engagement because it's never shown. Using the metric for ranking rather than gating solves this while still rewarding active content.

### DOM-Based Toast Over React State for Save Feedback in Astro Islands
**Date:** 2026-04-02 (Conv 077)

Use a standalone `showToast()` function that manipulates the DOM directly (`document.body.appendChild`), outside React's lifecycle, for transient save feedback in CourseEditor and similar Astro React islands.

**Rationale:** React state-based toast never rendered because `setCourse()` triggers Astro island remount, resetting React state before the toast renders. DOM manipulation is immune to component remounts and simpler than React portals. All save handlers across CourseEditor tabs now use `showToast()`.

> **Insight:** In hybrid frameworks like Astro where React components live inside islands, React's state lifecycle is not guaranteed to be stable — the island itself may remount. Escape hatches to the DOM are sometimes the most robust solution for transient UI that must survive framework-level re-renders.

---

## 6. Testing & CI/CD

### Branching Workflow Test Architecture
**Date:** 2026-03-05 (Session 342)

Multi-step workflow tests use a shared expensive setup (users, courses, enrollments, sessions) and branch into separate `describe` blocks at decision points. Shared helper functions (e.g., `setupCompletedSession(db)`) get to the decision point cheaply. Only branches where the decision changes downstream state are worth testing.

**Rationale:** The expensive part is building the world; branches are cheap once at the decision point. This gives N test variants for roughly the cost of 1.5 full tests. Integration tests cover branching logic (ms per branch); E2E tests cover only the 2-3 most critical happy paths.

**See:** PLAN.md WORKFLOW-TESTS block (4 workflow groups: BOOKING, COMPLETION, PAYMENT, MESSAGING)

### E2E Tests in CI with Local D1
**Date:** 2025-12-30

Keep E2E tests in CI; add `npm run db:migrate:local` step before tests.

**Rationale:** E2E in CI catches regressions; local D1 validates code works together.

### Vitest CLI Mode Only
**Date:** 2025-12-16

Use Vitest in CLI mode only (no GUI).

**Rationale:** User had bad experience with Vitest GUI; CLI-only approach is faster and more reliable.

### Playwright for E2E
**Date:** 2025-12-16

Use Playwright for E2E tests.

**Rationale:** Good Astro support; simpler than Cypress.

### Use Standard Vitest Config (Not Astro's getViteConfig)
**Date:** 2026-01-23

Use `defineConfig` from `vitest/config` instead of Astro's `getViteConfig` wrapper for test configuration.

**Rationale:** Astro's `getViteConfig()` starts file watchers that don't close properly, causing Vitest to hang after tests complete. Standard config with manual path aliases fixes this at the root cause. Tests don't need Astro-specific features.

**See:** `vitest.config.ts`, Session 71 Learnings

### Mock Astro Virtual Modules via Vitest Aliases
**Date:** 2026-02-19

Components that import Astro virtual modules (e.g., `astro:transitions/client`) fail to resolve in Vitest since the Astro Vite plugin isn't loaded. Add `resolve.alias` entries in `vitest.config.ts` pointing to mock files in `tests/helpers/`.

**Rationale:** Global aliases are cleaner than per-test `vi.mock()` calls and ensure every test file automatically gets the mock. Extends the "Standard Vitest Config" decision — since we don't use Astro's `getViteConfig`, we must manually alias any Astro virtual modules our components import.

**See:** `vitest.config.ts`, `tests/helpers/mock-astro-navigate.ts`

### E2E Flow Tests: Separate Specs per Lifecycle Phase
**Date:** 2026-03-05 (Session 335)

For multi-step flows with external dependencies (e.g., booking → BBB session → completion), create separate E2E specs per lifecycle phase rather than one monolithic test. Each spec includes dual-perspective verification (both parties see the result).

**Trigger:** Booking and session completion are naturally separated by days/weeks. Testing them as one flow requires mocking the entire middle (BBB session), creating fragile dependencies.

**Options Considered:**
1. Single test: book, mock BBB, webhook, verify — tests the chain but couples unrelated phases
2. Separate specs per phase: booking wizard + verification, webhook completion + verification ← Chosen

**Rationale:** Independent specs have no ordering dependencies, use the most appropriate strategy per phase (UI wizard for booking, direct API call for webhook), and mirror real user flows. Mock only what's environment-dependent (availability API), let everything else run real.

**Consequence:** `e2e/session-booking-flow.spec.ts` and `e2e/session-completion-flow.spec.ts`. Seed data needs "headroom" (more modules than sessions) so parallel tests can create records without exhausting capacity.

> **Insight:** The minimal mock boundary matters — mocking only the availability API (which is date/environment-dependent) while running session creation, notifications, and module resolution real gives far more confidence than mocking the whole booking endpoint. The webhook test has zero mocks, directly calling the real endpoint. (Session 335)

### E2E Tests Must Be Resilient to DB State Drift
**Date:** 2026-03-25 (Conv 029)

E2E tests that check seed data must use general assertions (regex counts, `>= 1` checks) rather than exact values. Mutation tests (delete, mark-read) permanently alter the dev D1 database, and other tests (booking flow) create additional records. Tests should verify component behavior, not specific seed data.

**Rationale:** Exact-count assertions (`toHaveCount(2)`, `getByText('2 notifications')`) break on re-runs when prior mutation tests have altered DB state. General assertions (`/\d+ notification/`, `count >= 1`) verify the same behavior without coupling to seed data. A periodic `npm run db:reset:local && npm run db:setup:local:dev` restores clean state when needed.

**Consequence:** Notification tests rewritten with general assertions. Pattern applies to any E2E test checking counts or specific records that other tests may create/modify.

### Decompose Large Components Before Testing
**Date:** 2026-01-23 (Updated: Session 75)

Before writing tests for a page component, analyze section sizes:
1. Identify any section >40 lines → extract as subcomponent
2. If 2+ sections exceed 40 lines → full decomposition warranted
3. Test subcomponents individually, then integration

**Rationale:** Original threshold (>200 lines or 5+ sections) was too coarse. A designer will be styling all pages and may significantly expand what are currently minor sections. The 40-line threshold ensures components remain testable and maintainable even after styling expansion. Decomposition also enables isolated testing, improves maintainability, and allows subcomponent reuse.

**See:** PLAN.md TESTING.PAGES process

### Retroactive Decomposition Review Results
**Date:** 2026-01-23

Reviewed 5 already-tested components that exceeded 200-line threshold:

| Component | Lines | Sections | Verdict |
|-----------|-------|----------|---------|
| CourseBrowse.tsx | 491 | 8 | HIGH priority - needs decomposition |
| SignupForm.tsx | 350 | 7 | MEDIUM - extract OAuthButtons |
| LoginForm.tsx | 238 | 6 | MEDIUM - extract OAuthButtons (shared) |
| STDirectory.tsx | 259 | 5 | Acceptable as-is |
| CreatorBrowse.tsx | 227 | 5 | Acceptable as-is |

**Key findings:**
- STDirectory and CreatorBrowse are borderline (5 sections) but well-organized; decomposition would add complexity without clear benefit
- OAuthButtons component (~80 lines of SVG) is duplicated between LoginForm and SignupForm; extraction would benefit both
- CourseBrowse has same complexity as CourseDetail; should extract FilterSidebar, FilterPills, Pagination, MobileDrawer

**See:** PLAN.md TESTING.PAGES retroactive review section

### PLATO Test Framework — API Flow Testing Layer
**Date:** 2026-03-30 (Conv 060), updated 2026-03-31 (Conv 061 — Model B pivot)

PLATO is a new test layer that tests user goals by executing API call sequences through real handlers with a real in-memory database. Unlike unit tests (which mock dependencies) or E2E tests (which drive browsers), PLATO proves the server-side write chain works end-to-end. First run (creator-publishes-course) completed in 202ms and immediately found a real production bug (`joined_via` CHECK constraint missing `'registration'`).

**Architecture (Model B — Conv 061):** Sequential DB-accumulation. Runs execute in fixed order; each deposits data into the DB. No cross-run carry state — the DB is the only truth. Supersedes Model A (composable segments with dependency graph and topological sort) because carry state hid integration gaps. Page-visit model: each run models page visits with button presses that trigger API calls. `$context` provides intra-run data flow ("what the page showed the user"); context is cleared between runs.

**Key rules:**
- **No direct DB inserts.** If PLATO can't create data through an API, that's a finding, not a reason for a workaround.
- **Happy path only.** Stumbles (bad input, wrong password) are single-step concerns tested at the unit/API layer (see STUMBLE-AUDIT block).
- **Route, not navigation.** Runs declare WHERE the action happens, not HOW the user gets there.
- **API emulation, not Playwright.** PLATO calls endpoints directly (~200ms, deterministic). Playwright is reserved for targeted E2E tests. The developer must manually walk each run in the browser to verify the UI can trigger the API calls.
- **Discovery GETs.** Runs that need data from prior runs start with a GET (the same call the page would make), not carry state.
- **`fromDB` actor resolution.** Runner queries users table by persona email — no cross-run identity carry.

**Rationale:** 6362 tests all insert data via SQL — none test the creation path. Model B breaks fast and loudly: if the DB doesn't have the data, the test fails. API emulation avoids Playwright's "fast and garbled muttering" (flakiness from hydration timing, animation delays, selector brittleness).

> **Insight:** The gap between "data exists in the database" and "the app can create that data" is invisible to conventional test suites. Seed-data-based testing creates a false sense of coverage by skipping the exact code paths users exercise. PLATO makes this gap visible by construction.

> **Insight:** Carry state between test segments is an anti-pattern for integration testing. If data must be passed explicitly between steps, you never discover that the real system doesn't provide it. Sequential DB-accumulation forces each step to discover its data the same way a user would — through the UI (or its API equivalent). The rigidity of fixed ordering is the feature, not a limitation.

**See:** `docs/as-designed/plato.md`, `tests/plato/`, `docs/reference/PLATO-GUIDE.md`, PLAN.md PLATO block

### Rename apiCalls → plannedApiCalls in Page Spec JSON
**Date:** 2026-01-27

Renamed `apiCalls` to `plannedApiCalls` across the Zod schema (`PageSpecSchema`), `PageSpecView.astro`, all 66 page JSON files, and helper scripts. The `testCoverage.apiTests` section (populated from shell scripts) serves as ground truth for what's actually built and tested.

**Rationale:** The `apiCalls` field contained a mix of implemented and aspirational endpoints (e.g., `/export` never built). Renaming to `plannedApiCalls` preserves all spec data while eliminating ambiguity. Two clear layers: "what was designed" (`plannedApiCalls`) vs "what exists" (`testCoverage.apiTests`).

**See:** `src/lib/schemas/page-spec.ts`, Session 126 Decisions

### Exclude Seed Data from Test Database
**Date:** 2026-01-28

The `resetTestDB()` function skips migration files containing "seed" in the filename. Tests use only `0001_schema.sql`, not `0002_seed.sql`.

```typescript
// In tests/helpers/test-db.ts
const files = fs.readdirSync(migrationsDir)
  .filter((f) => f.endsWith('.sql') && !f.includes('seed'))
  .sort();
```

**Options Considered:**
1. Rename seed file during tests (fragile, file system manipulation)
2. **Filter out seed files in `resetTestDB()`** ← Chosen
3. Have each test clear tables before inserting data (requires updating every test)

**Rationale:** Tests must control their own data. Seed data pollutes test state and causes:
- Count mismatches (test expects 4 enrollments, gets 10 due to seed data)
- Flaky assertions that pass due to seed data accidentally satisfying conditions
- Tests written with overly permissive assertions (`>= 4` instead of `toBe(4)`) to accommodate unknown seed data

**Consequences:**
- Tests have clean, isolated data
- Each test file sets up exactly the data it needs
- Integration tests that specifically validate seed data can use a separate `reseedTestDB()` helper

**See:** `tests/helpers/test-db.ts`, Session 135 Decisions

### SSR Testing: Extract to Testable Functions
**Date:** 2026-01-28

Extract SSR data fetching logic from .astro frontmatter to testable functions in `src/lib/ssr/`. Each page's data fetching becomes a pure function: `(db) → data | error`.

**Context:** 17 pages query D1 directly in Astro frontmatter. This layer was untested because .astro files can't be easily unit tested.

**Options Considered:**
1. **Extract to `src/lib/ssr/` functions** ← Chosen
2. Use E2E tests to implicitly cover SSR layer
3. Accept the gap for MVP

**Rationale:** Enables fast, isolated unit tests without Astro rendering complexity. E2E alone would be slow and wouldn't isolate SSR issues.

**Related:** SSR errors should show error pages, not empty content. Layouts need error boundary support.

**See:** PLAN.md TESTING.SSR, Session 138 Decisions

### API Test File Naming: Path-Mirroring Convention
**Date:** 2026-03-04 (Session 329)

Test files must mirror the API source path structure exactly. `src/pages/api/me/communities/[slug]/members.ts` → `tests/api/me/communities/[slug]/members.test.ts`.

**Rationale:** Path-mirroring enables automated coverage audits via `comm -23` between source and test paths. Flattened names (e.g., `slug-members.test.ts`) create false positives that require manual verification. The convention was already used by 95%+ of test files.

### 100% API Endpoint Test Coverage
**Date:** 2026-03-04 (Session 329)

All 211 API endpoints have corresponding test files (210 test files, with one covering 3 related progression endpoints). Each test covers at minimum: auth (401), authorization (403), success case, and error handling (503).

**Rationale:** The final 7 gaps were closed in one session. The process itself caught a real bug (`courses/[id]/sessions.ts` used invalid enrollment status `'active'`), validating the investment.

---

### Multi-User Manual Testing: Two Browser Vendors, No Code Changes
**Date:** 2026-03-12 (Session 380)

For testing two-sided interactions (student ↔ teacher, booking ↔ BBB), use two different browser vendors (e.g., Chrome + Safari) rather than code-level tab isolation. Each browser has independent cookies and localStorage, giving full session isolation with zero production code changes.

**Trigger:** User wanted per-tab localStorage scoping for simultaneous multi-user sessions.

**Options Considered:**
1. Tab-scoped auth tokens (sessionStorage + Authorization header)
2. Dev-mode impersonation (`?_as=userId` middleware)
3. Two browser vendors ← Chosen

**Rationale:** HTTP-only auth cookies are shared across all tabs in the same browser — scoping localStorage alone is insufficient. Code-level solutions would add dev-only infrastructure to the production codebase. Two browsers solve the 90% case (two simultaneous users) for free.

**See:** `docs/reference/BEST-PRACTICES.md` §8, `docs/reference/CLI-TESTING.md`

### Live Stream API Seeding for Feed E2E Tests
**Date:** 2026-03-19 (Conv 018)

Smart feed E2E tests use real Stream.io activities (not mocks) created by `scripts/seed-feeds.mjs`. The script calls the Stream REST API to create 14 activities + 17 reactions, then dual-writes `feed_activities` rows to D1 with the returned `stream_activity_id`. This ensures the full smart feed pipeline (D1 candidate selection → Stream enrichment → scoring → rendering) is tested end-to-end.

**Rationale:** The smart feed's value is its ranking algorithm, which depends on real engagement signals from Stream (`reaction_counts`). Mocking would test UI rendering but not the actual scoring. Feed seed is the only setup level that makes external API calls.

**See:** `scripts/seed-feeds.mjs`, `e2e/smart-feed.spec.ts`, `npm run db:setup:local:feeds`

### webhook_log Table for Payload Capture
**Date:** 2026-03-27 Conv 037

Added `webhook_log` table with fire-and-forget INSERTs at the top of all 3 webhook handlers (bbb.ts, bbb-analytics.ts, stripe.ts). Captures raw payloads for fixture generation and variability analysis. Auth headers are redacted for security.

**Rationale:** Durable, queryable, in-context (knows which handler received it). Payloads can be extracted via `wrangler d1 execute` for test fixture generation. May be replaced by proper API logging later.

**See:** `migrations/0001_schema.sql` (webhook_log table), `src/pages/api/webhooks/`

### PLATO Persona Fields: DB-REQUIRED vs SITE-NECESSARY
**Date:** 2026-03-31 (Conv 062)

PLATO persona files organize entity fields into two comment-delimited sections: **DB-REQUIRED** (fields needed to pass publish/validation gates) and **SITE-NECESSARY** (fields that a diligent user would fill out for a complete experience). Runs send both categories. Flat structure with no conditionals — copy a persona block and change values to create a new variant.

**Rationale:** The publish gate tests minimum validity, not user experience completeness. PLATO should model what a real user does, not just what passes validation. Section comments make the distinction self-documenting without adding runtime complexity.

> **Insight:** Test frameworks that only satisfy validation gates miss the user experience surface area — the same gap that causes empty product pages in production despite all tests passing.

**See:** `tests/plato/personas/genesis.ts`, `docs/reference/PLATO-GUIDE.md`

### PLATO Scenario Layer — Independent Goal-Driven Compositions
**Date:** 2026-03-31 (Conv 063)

PLATO gains a "Scenario" layer above individual runs. A scenario is an independent, goal-driven composition of runs with its own persona set, chain steps, and DB verification. Three scenario categories: `test` (critical path validation), `seed` (replace SQL seed data), `repro` (reproduce observed issues). Scenarios are self-contained — each declares its personas, chain order, actor bindings, and expected DB state.

**Key design choices:**
- **findBy in extractPath:** `courses.findBy(title,$persona.courseTitle).id` enables multi-course discovery without carry state. Custom parseDotPath() handles paren-aware dot splitting.
- **Actor bindings:** `RunRef.actorBindings` remaps persona keys to run actor slots, so the same run (e.g., enroll-student) works with different students without modification.
- **Scenario-level DB verification:** Per-run verify blocks are sanity gates; scenario verify proves the intended situation was reproduced with comprehensive state checks.

**Rationale:** Independent scenarios enable ad-hoc creation ("generate a new scenario to test X"). The findBy pattern is declarative and backward-compatible. Actor bindings keep runs atomic — they never know which persona is using them.

> **Insight:** Separating one-time setup operations (Stripe Connect) from per-entity operations (teacher certification) is critical for composable test runs. When a run combines both, it works for the first invocation but fails on subsequent ones. Atomic runs that do exactly one thing compose cleanly in any scenario.

**See:** `tests/plato/scenarios/`, `tests/plato/lib/types.ts` (PlatoScenario), `tests/plato/lib/api-runner.ts` (executeScenario)

### PLATO Four-Concept Taxonomy (step / scenario / persona set / instance)
**Date:** 2026-04-01 (Conv 068)

Adopted four-concept taxonomy to resolve "run" ambiguity: **Steps** are atomic action templates (data-independent). **Scenarios** compose steps into sequences with verification. **Persona Sets** provide the data. **Instances** bind scenarios to persona sets with an execution mode (test/seed/walkthrough/repro). Renamed `run` → `step` across 30+ files (~150 replacements). Instances are future work — currently implicit via hardcoded personaSet in scenario files.

**Rationale:** "Run" was both a noun (a test run) and a verb (run the test), causing confusion. The four concepts map cleanly to three use cases: canned seed data, automated test execution, and ad-hoc reproduction scenarios.

> **Insight:** When domain terminology is ambiguous between "the thing" and "the act of doing the thing" (run/run, build/build), splitting into separate concepts with distinct names eliminates an entire class of communication errors. The cost of renaming is front-loaded; the clarity benefit compounds.

**See:** `docs/as-designed/plato.md`, `tests/plato/steps/`, `tests/plato/lib/types.ts`

### PLATO Instance Architecture: Inline Scenarios + When Guards + Accumulation
**Date:** 2026-04-01 (Conv 069)

Built PlatoInstance/PlatoInstanceFile types with `when` predicate guards on StepRef, multi-instance execution against same DB (accumulation), inline scenario support, and WalkthroughCheckpoint type for STUMBLE pairing. Instances solve the general parameterization problem — any future scenario variant uses the same infrastructure.

**Rationale:** The `when` guard is the minimal mechanism for conditional steps. `executeInstanceFile()` swaps persona data per-instance and delegates to existing `executeScenario()`. The existing architecture (actorBindings, runtimeOverrides) was already designed for pluggable data — instance is the next logical layer up.

> **Insight:** When an orchestration layer works on first try with zero changes to the underlying execution engine, it validates the original architecture's extensibility. The cost of the instance system was ~300 lines of new code with no modifications to existing step execution, value resolution, or mock management.

**See:** `tests/plato/lib/types.ts`, `tests/plato/lib/api-runner.ts`, `tests/plato/instances/`

### STUMBLE-AUDIT Formalization: Lightweight Pairing with PLATO Instances
**Date:** 2026-04-01 (Conv 069) — *Superseded by BrowserIntent (Conv 074)*

Added WalkthroughCheckpoint type to PLATO instance files. Execution uses accumulate-with-checkpoints model (walk sub-flow, batch findings, pause for triage). Issues captured as TodoWrite tasks with severity (broken/confusion/cosmetic) and source tag.

**Rationale:** Instance file is the natural home for "what to check in browser." Lightweight structure avoids over-engineering while ensuring findings are captured persistently. PLATO proves API correctness; STUMBLE proves UI correctness. Contract mismatches between API response shapes and component expectations only surface when the browser actually renders — validating the complementary pairing.

### CTE Cross-Reference Limitation: Use JOINs for Enrollment Lookups in D1 INSERT
**Date:** 2026-03-31 (Conv 065)

In the D1/better-sqlite3 test environment, CTEs that reference other CTEs via scalar subqueries return NULL when used inside INSERT...SELECT statements. Single-level CTEs work fine. For enrollment lookups (which depend on user + course CTEs), use explicit JOINs on base tables instead: `FROM enrollments e JOIN users u ON e.student_id = u.id JOIN courses c ON e.course_id = c.id WHERE u.email = ? AND c.title = ?`.

**Rationale:** The CTE limitation may be a SQLite/better-sqlite3 quirk. JOINs are proven reliable, self-contained per step, and avoid silent NULL propagation. Additionally, INSERT...SELECT with UNION ALL reports success even when 0 rows are inserted, so splitting into individual INSERT steps per enrollment is more debuggable.

> **Insight:** When working with SQLite CTEs in INSERT context, prefer explicit JOINs over CTE cross-references for reliability. The verbosity cost is minor compared to the debugging cost of silent NULL propagation.

### PLATO Terminology: One System, Two Modes
**Date:** 2026-04-02 (Conv 073)

PLATO is one system with two execution modes: API mode (Vitest, in-memory DB, mocked externals) and Browser mode (dev server, real D1, real UI). "Run" = one execution of an instance. STUMBLE-AUDIT is a PLAN.md project block name only, not a separate system. Supersedes the PLATO run / STUMBLE walkthrough terminology from Conv 060.

**Rationale:** "STUMBLE" was overloaded — used as both a system name and a project block. WalkthroughCheckpoint already lives in PLATO's type system, confirming it's architecturally one system. Two modes is clearer than two systems.

### Defer PLATO Segments to PLATO-ON-STEROIDS Block
**Date:** 2026-04-02 (Conv 073)

All segment implementation deferred. Current primitives (StepRef + actorBindings + sequential instances) are sufficient for all envisioned scenarios at current scale (4 scenarios, 2 instances). Segments are DX convenience, not capability unlock.

**Rationale:** Multi-student, post-enrollment, restartability, and step group reuse all work without segments. Created PLATO-ON-STEROIDS deferred block (#41) capturing the full vision: composable data, segments, DB snapshots, automated agent walkthroughs.

> **Insight:** When a new abstraction layer doesn't unlock capabilities that existing primitives can't achieve, it's DX debt disguised as architecture. Defer until scale forces the issue.

### PLATO Snapshot Bridge: Always-Regenerate
**Date:** 2026-04-02 (Conv 073)

`better-sqlite3.serialize()` dumps in-memory DB to a Buffer, copied to wrangler's D1 SQLite file. `npm run plato:restore -- <name>` always regenerates (API-run + restore in one command). No caching — every restore regenerates from current code.

**Rationale:** API-run takes ~400ms — faster than thinking about staleness. Eliminates entire class of bugs (stale schema, stale persona data, stale steps). Snapshots are gitignored.

### BrowserIntent Replaces WalkthroughCheckpoint
**Date:** 2026-04-02 (Conv 074)

WalkthroughCheckpoint replaced by BrowserIntent: `navigate: { via, clicks: NavClick[] }` for deterministic navigation, `pageAction: string` for prose instructions, `coversStepActions` for API-run cross-reference. Navigation is structured (fail-fast on missing UI elements); page actions remain prose to avoid building a Playwright DSL.

**Rationale:** WalkthroughCheckpoints "teleported" to pages via address bar URLs instead of navigating like real users. BrowserIntent captures the deterministic navigation contract without over-engineering page interactions. The hybrid split (structured nav + prose actions) matches the natural boundary: navigation is mechanical, page actions are contextual.

> **Insight:** When automating user journeys, the navigation/action boundary is the natural seam for structured vs unstructured specification. Navigation has finite, enumerable paths through a known graph. Page actions are combinatorially complex. Structuring navigation enables fail-fast validation; keeping actions as prose avoids an ever-expanding DSL.

**See:** `tests/plato/lib/types.ts` (BrowserIntent, NavClick), `tests/plato/lib/navigation-helper.ts`

### Route↔API Map: Self-Maintaining Scanner Pipeline
**Date:** 2026-04-02 (Conv 074)

Single scanner script (`scripts/route-api-map.mjs`) generates both TypeScript lookup (`tests/plato/route-map.generated.ts`) and Markdown reference (`docs/as-designed/route-api-map.md`) from source code analysis. BFS from nav components (AppNavbar, AdminNavbar, DiscoverSlidePanel) computes reachability. Wired into `/r-end` docs agent for auto-regeneration on API/component changes.

**Rationale:** Code needs the data (PLATO navigation helpers). Humans need the reference (scenario authoring). One source of truth prevents drift. Stats: 96 pages scanned, 195 API endpoints, 89 reachable routes.

**See:** `scripts/route-api-map.mjs`, `tests/plato/route-map.generated.ts`, `docs/as-designed/route-api-map.md`

### Diagnostic Instances Are Ephemeral
**Date:** 2026-04-02 (Conv 074)

Diagnostic segments (instances created to isolate bugs) are deleted when their bugs are fixed. If the journey is independently useful, promote to a named scenario. Git history preserves the diagnostic if needed later. Taxonomy: Scenario (permanent, proves a journey), Diagnostic segment (ephemeral, isolate bugs), Derived scenario (promoted from diagnostic if useful).

**Rationale:** PLATO-REGISTRY should track permanent scenarios, not ephemeral debug probes. Accumulating stale diagnostic artifacts creates confusion about what's canonical.

### PLATO Navigation Rules: Same-Page First, Then AppNavbar
**Date:** 2026-04-02 (Conv 074)

Deterministic navigation rules for BrowserIntent: Rule (a) if target route has a link/button on the CURRENT page → `via: 'same-page'`. Rule (b) if not → start from AppNavbar, follow BFS shortest path. Implemented in `suggestNavigation()` helper. `outboundLinks` added to RouteInfo to support rule (a) checks.

**Rationale:** Users naturally click links on the current page before going to the sidebar. This matches real user behavior and produces the most natural-looking browser-runs.

**See:** `tests/plato/lib/navigation-helper.ts`

---

## 7. Development Workflow & Documentation

### Additive DB Setup Script Naming
**Date:** 2026-03-18 (Conv 006)

DB setup combo scripts follow the pattern `db:setup:{target}:{level}` where each level chains through the previous:
- `db:setup:local` — reset + migrate (production-like base)
- `db:setup:local:dev` — + dev seed
- `db:setup:local:stripe` — + Stripe sandbox accounts
- `db:setup:local:booking` — + booking test scenario
- `db:setup:local:feeds` — + Stream.io activities + D1 feed_activities (Conv 018)
- Same chain for `:staging` variants

**Rationale:** Previous names were ambiguous (`fullsetup` wasn't full, `setup:clean` was unclear, `db:setup:booking` broke the suffix pattern). The base should be minimal — suffixes add layers, not subtract. The chain mirrors data dependency order (booking needs Stripe, Stripe needs dev users).

> **Insight:** This is a general principle for layered tooling — defaults should be the safest/simplest option, with explicit opt-in for each layer of complexity. It prevents accidents (running full dev seed when you wanted production-like) and makes the dependency order self-documenting.

### cert_id vs teacher_id for SQL Alias Renames
**Date:** 2026-03-16 (Session 391)

When renaming `st_id` SQL aliases during TERMINOLOGY-CLEANUP, use `cert_id` for teacher certification record PKs (in SSR loaders) and `teacher_id` for teacher user IDs (in enrollment/earnings APIs). The names should reflect what the value actually represents, not just strip the "st" prefix.

**Rationale:** `st_id` appeared in two distinct contexts with different semantics. In SSR loaders, it's `teacher_certifications.id` (a certification record PK). In enrollment APIs, it's `users.id` (the teacher's user ID). Using `teacher_id` for both would be ambiguous.

**See:** `src/lib/ssr/loaders/teachers.ts` (cert_id), `src/pages/api/me/enrollments.ts` (teacher_id)

### Three-Layout System
**Date:** 2025-12-28

| Layout | Purpose | Header | Footer |
|--------|---------|--------|--------|
| LandingLayout | Public pages | PublicHeader | PublicFooter |
| AppLayout | Authenticated | GatedHeader | GatedFooter |
| AdminLayout | Admin area | AdminSidebar | - |

### Machine Name Standardization
**Date:** 2025-12-28
**Updated:** 2026-02-19 — Renamed `MacMini` → `MacMiniM4-Pro`, added `MacMiniM4`. Retired `MBA-2017`.

Use `MacMiniM4-Pro` and `MacMiniM4` as standard machine names in documentation.

**Rationale:** Short, unique enough for grep scanning; enables automated detection.

### Template-Based Project Initialization
**Date:** 2025-12-28

`/q-init` copies from `.claude/templates/` rather than creating from scratch.

**Rationale:** Templates maintained independently; ensures consistency; easy updates.

### Portable vs Project-Specific Docs
**Date:** 2025-12-28

- `/q-docs` - Standard docs, portable across projects
- `/q-local-docs` - Project-specific docs, customized per project

### Startup Checks via CLAUDE.md
**Date:** 2025-12-28

Add "Session Startup Check" section to CLAUDE.md for automatic checks (like RESUME-STATE.md detection).

**Rationale:** Single point of truth; no maintenance burden on individual skills.

### Always Stage All Changes in /q-commit
**Date:** 2026-01-19

Always stage all changes with `git add .` during commits. No selective staging based on perceived task relevance.

**Rationale:** Selective staging leads to orphaned changes that may be forgotten. At session end, all changes in the working directory should be committed together. If changes truly shouldn't be committed, they should be in `.gitignore` or explicitly stashed.

### Capture Planned Work Before Session End
**Date:** 2026-01-20

Use `/q-end-with-plan <description>` or `/q-end-with-plan --recent` when ending a session with planned but unstarted work.

**Rationale:** `/q-end-session` detects pending work via TodoWrite, not conversation context. If planned work isn't in TodoWrite, save state won't be triggered. This skill bridges the gap by generating todos from a description (or from recent discussion via `--recent`) before running the end-session workflow.

**See:** `~/.claude/commands/q-end-with-plan.md`

### Page JSON as Single-Lookup Source of Truth
**Date:** 2026-01-27
**Status:** DEPRECATED — JSON page specs, markdown page specs, PageSpec Astro stubs, and all related scripts/components were deleted in Sessions 307+311. See git history. Route information is in `docs/as-designed/url-routing.md` and `docs/as-designed/route-stories.md`.

Each page's JSON file (`src/data/pages/**/*.json`) served as the single place to find all related file paths.

**Rationale:** Files for one page were scattered across 6+ directory trees. Opening the JSON gave you every path without searching.

### Drop block and status From Page Metadata
**Date:** 2026-01-27

Removed `block` (build sequence number) and `status` (implementation state enum) from `PageMetadataSchema`. Deleted `PageStatusSchema` entirely.

**Rationale:** Block numbers are historical build order, no longer relevant. Status was inconsistently classified between PAGES-MAP.md and JSON. Neither provides ongoing value. PAGES-MAP.md is being repurposed as a lightweight index.

---

## 8. Deployment & Infrastructure

### React 19 SSR Fix for Cloudflare
**Date:** 2025-12-29 (updated 2026-02-16)

Add Vite alias to use `react-dom/server.edge` instead of `react-dom/server.browser`. The upstream fix (PR #12996) merged Jan 2025 but only shipped in `@astrojs/cloudflare` v13 beta (Astro 6), not the v12 stable line. The workaround is fragile — works by Vite alias resolution order coincidence, not by design. Remove when `@astrojs/cloudflare` v13+ is stable.

**Rationale:** Official workaround for MessageChannel error in Cloudflare Workers; fix applies only to production builds.

**See:** `docs/reference/astrojs.md` (Caveats section)

### Provision Cloudflare KV Namespace
**Date:** 2026-02-16

Provision KV namespace (`SESSION` binding) for all environments even though no application code actively uses it. Separate namespaces for production and preview to prevent data leakage.

**Rationale:** Satisfies the Astro Cloudflare adapter's SESSION binding requirement, prevents deploy failures, and makes KV available for future use cases (feature flags, rate limiting, caching). Free tier is generous (100K reads/day). Cost of not provisioning: potential deploy failure.

**See:** `docs/reference/cloudflare-kv.md`

### UTC ISO 8601 for All Session Times
**Date:** 2026-03-17 Conv 002

All `scheduled_start` and `scheduled_end` values stored as UTC ISO 8601 with Z suffix (e.g., `2026-03-20T18:00:00.000Z`). The POST/PATCH endpoints reject bare datetime strings. Availability API converts teacher-local times to UTC at slot generation time using `src/lib/timezone.ts` (Intl-based, no external dependencies). Browsers display times in the user's local timezone automatically via `toLocaleTimeString()` on Z-suffixed strings.

**Rationale:** Cloudflare Workers parse bare datetime strings as UTC; browsers parse them as local time. This caused session join failures (both parties got "Session time has passed" when arriving on time). Z-suffixed strings are unambiguous across all runtimes. Migration `0003_fix_session_times.sql` normalizes existing data.

> **Insight:** This is the "ambient timezone" antipattern — code implicitly relying on the runtime's default timezone. In serverless/edge where the runtime is always UTC, every datetime crossing the client/server boundary must be explicitly UTC.

### Image Service: Passthrough (No Optimization)
**Date:** 2026-02-16

Use `imageService: 'passthrough'` on the Cloudflare adapter. No Astro `<Image>` components. Plain `<img>` tags with R2 URLs. Image optimization (Cloudinary or CF Image Resizing) deferred to post-MVP.

**Rationale:** Low image volume for MVP. Optimization adds vendor complexity with no measurable benefit. The `passthrough` setting must be on the adapter constructor (not Astro's top-level `image` config) because the adapter overrides Astro's image config.

**See:** `docs/as-designed/image-handling.md`

### Merge to main for Deployment
**Date:** 2025-12-29

Merge development branch to main rather than reconfigure CF Pages branch.

**Rationale:** `main` is standard production convention; cleaner workflow.

### nodejs_compat_v2 Flag
**Date:** 2025-12-29

Use `nodejs_compat_v2` compatibility flag in wrangler.toml.

**Rationale:** Provides more Node.js APIs; better compatibility.

### Environment Detection
**Date:** 2025-12-30

- `DEV`: localhost
- `STG`: CF Pages + branch !== 'main'
- `PROD`: CF Pages + branch === 'main' or production domain

### Stream.io REST API Instead of Node SDK
**Date:** 2026-01-19

Use Stream.io REST API directly with `fetch()` and `jose` for JWT auth instead of the `getstream` Node.js SDK.

**Rationale:** The `getstream` SDK uses `http.Agent` which is incompatible with Cloudflare Workers runtime. Even with `nodejs_compat_v2` and `enable_nodejs_http_modules` flags, Cloudflare's `http.Agent` is a stub that doesn't satisfy the SDK. Code worked locally but failed on CF Pages deployment. REST API works everywhere.

**See:** `src/lib/stream.ts` for implementation, `docs/reference/stream.md` for full caveat.

### Environment Variable Architecture (CF Pages Constraints)
**Date:** 2026-02-06

Non-secret env vars are duplicated in both `.dev.vars` (local dev) and `wrangler.toml [vars]` (Cloudflare deployment). Secrets live in `.dev.vars` (local) and are set via CF dashboard (deployed). Reference files `.secrets.cloudflare.production` and `.secrets.cloudflare.preview` list all secrets for each dashboard tab.

**Rationale:** CF Pages dashboard only allows encrypted secrets when `wrangler.toml` exists — non-secrets must come from `[vars]`. Meanwhile `.dev.vars` must keep non-secrets to override production values with dev values locally. All CF secrets managed via dashboard (not CLI) because `wrangler pages secret put` has no `--env` flag for preview.

**See:** `docs/as-designed/env-vars-secrets.md` for complete reference.

### Stay on Node 22 — Node 24 Blocked by CF Pages
**Date:** 2026-02-16

Remain on Node 22.19.0. Do not upgrade to Node 24 until Cloudflare Pages adds it to their build image and Astro 5.x officially supports it. Node 22 is supported until April 2027.

**Rationale:** Two blockers: (1) CF Pages build image doesn't include Node 24 (`node-build: definition not found: 24`), (2) Astro 5.x only lists Node 18/20/22 as supported. The build warning ("LTS Maintenance mode") is informational only.

**See:** `docs/reference/cloudflare.md` (Node.js Version on CF Pages), `docs/as-designed/devcomputers.md` (Node.js Version)

### Defer Stripe Production Secrets Until Go-Live
**Date:** 2026-02-06

Do not add `STRIPE_SECRET_KEY` or `STRIPE_WEBHOOK_SECRET` to the Cloudflare Production environment until MVP go-live. Live values are stored in `.secrets.cloudflare.production` for reference but should not be entered into the CF Dashboard yet.

**Rationale:** With no Stripe secrets in production, payment endpoints fail gracefully (missing key) rather than processing real charges. This creates a clear launch gate — adding live Stripe secrets becomes an explicit go-live checklist item, not something that's been sitting there untested.

**See:** `.secrets.cloudflare.production` (Stripe section), `docs/as-designed/env-vars-secrets.md` (deployment table)

### Self-Healing API Endpoints for Stripe Status Sync
**Date:** 2026-02-18

The `connect-status` API endpoint derives the correct Stripe account status from live Stripe API data (`active` when charges + payouts + details all enabled) and automatically syncs the database when it detects drift from the stored value. This makes the endpoint write to the DB (was previously read-only).

**Rationale:** Webhooks can be missed (listener not running, network issues, race conditions). Since the endpoint already makes a Stripe API call for the boolean flags, deriving status is essentially free. The `account.updated` webhook remains as an optimization for real-time updates, but the system is correct-by-default even without it.

**See:** `src/pages/api/stripe/connect-status.ts`

### Staging Webhook Active for Stripe (Supersedes "Skip Preview Webhook")
**Date:** 2026-02-18 (Session 224, supersedes Session 223)

Register a Stripe webhook endpoint for the `staging` branch at `staging.peerloop.pages.dev/api/webhooks/stripe`. While per-commit URLs are dynamic, branch-based URLs are stable enough for Stripe webhooks. Uses "Your account" context (6 events: checkout.session.completed, charge.refunded, account.updated, transfer.created, charge.dispute.created, charge.dispute.closed). The `payout.failed` event requires a separate "Connected accounts" endpoint — deferred.

**Rationale:** The Session 223 decision was based on per-commit URLs (`<hash>.peerloop.pages.dev`). Branch-based URLs (`staging.peerloop.pages.dev`) are fixed and suitable. Having webhooks on staging enables full payment flow testing.

**See:** `docs/reference/stripe.md` (Per-Environment Webhook Configuration)

### Dispute Handling Is Critical Infrastructure
**Date:** 2026-02-18 (Session 224)

Implement `charge.dispute.created` and `charge.dispute.closed` webhook handlers as part of core payment infrastructure, not deferred/nice-to-have. Disputes are the only webhook event where silence causes automatic financial loss (Stripe rules against the platform if no evidence is submitted within 7-14 days). On dispute creation: freeze enrollment, mark transaction as disputed, notify admin. On dispute loss: cancel enrollment, reverse transfers to connected accounts to recover platform funds.

**Rationale:** Systematic audit of all Stripe API calls revealed disputes as the most dangerous unhandled event. Unlike `payout.failed` (courtesy notification) or `checkout.session.expired` (cleanup), disputes have urgent financial and operational consequences.

**See:** `src/pages/api/webhooks/stripe.ts` (handleDisputeCreated, handleDisputeClosed)

### Separate R2 Bucket for Staging/Preview
**Date:** 2026-03-27 Conv 037

Created `peerloop-storage-staging` R2 bucket, bound to preview environment in `wrangler.toml`. Production uses `peerloop-storage`.

**Rationale:** D1 and KV were already properly separated between production and preview, but R2 was shared — any test recording replication on preview would write to production R2. Separate bucket matches existing separation pattern. Free.

**See:** `wrangler.toml` (preview R2 binding), `docs/as-designed/env-vars-secrets.md`

### Staging Webhook Strategy (BBB + Stripe + Stream)
**Date:** 2026-03-27 Conv 037 (extends Session 224 Stripe-only decision)

Use `staging.peerloop.pages.dev` as stable webhook target for all vendors. BBB webhooks auto-configure per-meeting (callback URLs derived from `request.url.origin` in `join.ts` — no vendor-side config needed). Stripe requires a second Dashboard endpoint for staging. Stream.io webhooks are available but not used.

**Rationale:** Simplest approach. Staging branch already exists and is used for client approvals. No new infrastructure needed. BBB's per-meeting self-configuration is a key architectural advantage.

**See:** `docs/guides/STAGING-WEBHOOKS-SETUP.md`, `docs/reference/REMOTE-API.md` (webhook status table)

### URL-Embedded HMAC for BBB Webhook Authentication
**Date:** 2026-04-02 Conv 075

BBB's `meta_endCallbackUrl` has no built-in auth mechanism (unlike the analytics callback which uses JWT/HS512). Use HMAC-SHA256(sessionId, BBB_SECRET) as a hex token appended to the webhook URL at room creation time. The webhook handler recomputes the HMAC from the parsed roomId and verifies with constant-time comparison.

**Rationale:** BBB doesn't forward custom headers on callbacks and has no signing mechanism for `meta_endCallbackUrl`. URL-embedded HMAC is the only viable approach. Token is scoped to a specific roomId, preventing replay against different resources. CD-038 (Blindside Networks) confirmed this limitation.

> **Insight:** When a third-party service doesn't support webhook signing, URL-embedded HMAC tokens bound to a resource ID are a practical alternative. The token proves the callback was registered by your system and is scoped to a specific resource, preventing replay.

**See:** `src/lib/webhook-auth.ts`, `src/pages/api/webhooks/bbb.ts`, `src/pages/api/sessions/[id]/join.ts`

---

## 9. Feature Flags

### Two-Tier Feature Flags
**Date:** 2025-12-28

- **Core Features (Custom D1):** Feature enablement, role-based access - must always work
- **Experiments (PostHog):** A/B tests, gradual rollouts - can gracefully fail

**Rationale:** Core features need reliability; experiments can tolerate failures.

---

## 10. Admin Implementation

### Admin Starting Point
**Date:** 2025-12-29

Start with Users Admin (most frequently used; establishes CRUD pattern).

**Rationale:** Exercises all patterns (list, filter, search, detail panel, actions).

### Course Sub-Table Editing
**Date:** 2025-12-29

Use single tabbed form for course editing (all sub-tables in one page).

**Rationale:** Keeps related data together; reduces navigation; matches common UX.

### Admin Implementation Order
**Date:** 2025-12-29

1. Users Admin (complete)
2. Topics Admin (formerly Categories Admin)
3. Courses Admin
4. Enrollments Admin
5. Student-Teachers Admin

### Moderator Suspension Limits
**Date:** 2026-01-21

Moderators can issue temporary suspensions (1d, 7d, 30d) but permanent suspensions require admin role.

**Rationale:** Moderators need authority to address violations promptly, but permanent bans are high-impact decisions requiring admin oversight. Inline role check in `suspend.ts` API.

**See:** `src/pages/api/admin/moderation/[id]/suspend.ts`

### Admin Bypasses CourseRole Type System
**Date:** 2026-03-29 Conv 055

Admin is a platform-level role, not a course relationship. Rather than adding 'admin' to `CourseRole = 'student' | 'teacher' | 'creator' | 'moderator'` (which would ripple through badge rendering, listing filters, and color lookups), admin bypasses `computeRoleTabs()` entirely. ExploreCourseTabs checks `currentUser.isAdmin` directly and constructs an `ExtraTabConfig` with `roleColor: 'red'`.

**Rationale:** Admin is orthogonal to course roles — an admin can simultaneously hold student+teacher+creator roles for the same course. The `roleColorClasses` map is string-keyed (not CourseRole-keyed), so adding `'red'` is a one-line change with no type system ripple.

> **Insight:** When extending a role-aware UI with a role that's orthogonal to the existing hierarchy, bypass the role computation rather than polluting the domain type. This keeps the domain type honest and limits blast radius.

### Admin Intel Endpoints Over Client-Side Aggregation
**Date:** 2026-03-29 Conv 055

New `/api/admin/intel/*` endpoints (course, user, community, batch courses) serve lightweight aggregated summaries (counts + most-recent items) for admin content on member-side pages. These are separate from existing admin list endpoints.

**Rationale:** Existing admin endpoints are paginated list endpoints with heavy SQL joins returning full table data. AdminIntel needs 3-4 simple indexed COUNT queries for a single entity — much lighter than calling 3-5 existing endpoints and extracting counts client-side. Server-side `requireRole(['admin'])` prevents non-admin clients from even attempting the calls.

### /discover/members as Admin-Only Page
**Date:** 2026-03-29 Conv 055

New admin-only `/discover/members` page alongside existing `/discover/teachers` and `/discover/creators` (which remain available to all users).

**Rationale:** Encourages admins to use the member-facing app (developing empathy for the user experience) while providing admin-specific member browsing capabilities. The existing discover pages serve different purposes than admin member browsing.

### ADMIN-INTEL 6-Phase Block Structure
**Date:** 2026-03-29 Conv 055

Admin capabilities on member-facing pages structured as 6 phases: (1) Foundation (color, API, badge, links), (2) Course/Community tabs, (3) Profile pages, (4) /discover/members, (5) Dashboard, (6) Bidirectional links. All phases depend on Phase 1; Phases 2-6 can proceed in parallel. Supersedes deferred block #38 ADMIN-PAGE-ROLE.

**Rationale:** Single-source component pattern (one admin component per entity type with compact/full variants) prevents duplication across 14+ surfaces. Foundation-first ensures reuse.

### Comprehensive Admin Intel API, Lean Rendering
**Date:** 2026-03-29 Conv 056

Intel API endpoints return everything known about an entity from an admin perspective. Components decide what to render. "Leaner" is an optimization task for later.

**Rationale:** Starting comprehensive avoids API changes as each phase discovers its needs. User directive: "LEANER IS AN OPTIMIZATION TASK." Components are the variable — they pick from the full payload. No API changes needed during Phases 2-6.

### CONTEXT-ACTIONS-FAB Deprecated
**Date:** 2026-03-29 Conv 056

Deferred block #37 CONTEXT-ACTIONS-FAB is deprecated, superseded by ADMIN-INTEL. The FAB was an early idea for baking admin functions into the member side. ADMIN-INTEL's entity-centric approach with single-source components (compact/full variants) covers the same need more comprehensively.

**Rationale:** User confirmed: "This was a VERY early idea... We can safely deprecate the entire idea." PLAN.md updated: #37 struck through.

### Admin Color bg-red-400
**Date:** 2026-03-29 Conv 056

Admin color is `bg-red-400` (changed from red-500 in Conv 055), adjusted if contrast is poor for lettering.

### AdminBadge: Round Badge with Count
**Date:** 2026-03-29 Conv 056

AdminBadge matches the size/shape of existing role badges (RoleBadge.tsx), uses red color, displays count for urgency guidance. Not a simple dot — a full round badge like roles have.

---

## 11. New Routing

This section tracks the routing restructure initiative to reorganize pages and consolidate layouts.

### Layout Naming for Parallel Development
**Date:** 2026-02-01 (Session 150)

Renamed layouts to enable parallel development of new routing structure while keeping existing pages functional:

| Old Name | New Name | Routes |
|----------|----------|--------|
| `AppLayout.astro` | `LegacyAppLayout.astro` | 30 routes (old dashboard, settings, etc.) |
| `DashLayout.astro` | `AppLayout.astro` | 7 routes (`/`, `/dash/*`) |

**Current layout inventory:**
- `AppLayout.astro` - New dashboard layout (formerly DashLayout)
- `LegacyAppLayout.astro` - Old authenticated layout (to be phased out)
- `AdminLayout.astro` - Admin panel (unchanged)
- `LandingLayout.astro` - Public pages (unchanged)

**Rationale:** `Legacy` prefix clearly signals intent to phase out. Frees up "clean" names (`AppLayout`) for new implementation. Underscore prefix (`_AppLayout`) was rejected due to ESLint parsing issues with Astro.

**See:** `src/layouts/`, Session 150 Decisions

### Archive Pages to _src/pages/ for Routing Reset
**Date:** 2026-02-01 (Session 154)

Moved all pages except `index.astro` to `_src/pages/` using `git mv` to start fresh with routing while preserving existing code for reference.

| Location | Contents | Purpose |
|----------|----------|---------|
| `src/pages/` | Only `index.astro` | Active route: `/` only |
| `_src/pages/` | 36 files + 15 dirs | Archived for cherry-picking |

**Cherry-picking workflow:**
1. Identify page to restore
2. Move from `_src/pages/` back to `src/pages/`
3. Restore any required API routes from `_src/pages/api/`
4. Update test imports if needed

**Rationale:** Clean slate approach for routing restructure. Preserves file history via `git mv`. Underscore prefix convention signals "archived, not active" and Astro ignores it entirely.

**See:** `_src/pages/`, Session 154 Decisions

### URL Routing Architecture - "Bare = My" Convention
**Date:** 2026-02-03 (Session 169)

Adopted a routing convention where bare routes represent user's personal content, and `/discover/` prefix indicates site-wide browsing:

| Pattern | Meaning | Example |
|---------|---------|---------|
| `/thing` | My personal content | `/courses` = my enrolled courses |
| `/discover/thing` | Site-wide browse | `/discover/courses` = course catalog |
| `/@handle` | Universal user profile | `/@jane` = Jane's profile |
| `/settings/*` | Account configuration | Already implies "my" |

**Role-specific dashboards:**
- `/learning` - Student dashboard
- `/teaching` - Teacher dashboard
- `/creating` - Creator dashboard

**Profile URL resolution:**
- `/@handle` - Any user's public profile
- `/@me` - Redirects to current user's profile
- `/profile` - Redirects to `/@me`
- `/settings/profile` - Edit profile form

**Rationale:** Users spend most time with their own content. The default context should be personal; discovery is an explicit action. This is more intuitive than `/my/courses` vs `/courses`.

**See:** `docs/as-designed/url-routing.md`

### Content Hierarchy - Communities → Progressions → Courses
**Date:** 2026-02-03 (Session 169)

Established a three-level content hierarchy:

```
Creator
  └── Community (topic-focused, e.g., "n8n Automation")
        └── Progression (learning journey or standalone)
              └── Course (1-10 BBB sessions)
```

**Key rules:**
- Every course belongs to exactly ONE progression
- Every progression belongs to exactly ONE community
- Progressions are the primary discovery unit (not individual courses)
- Users purchase individual courses, but browse progressions

**Display badges:**
- 1 course in progression = "Stand-alone" badge
- 2+ courses in progression = "Learning Path" badge

**Progression order is advisory, not enforced:**
- Users can start at any course in the progression
- Experienced users may skip introductory courses
- UI shows "Recommended: Complete X first" but doesn't block

**Course copying for reuse:**
- Course can only be in ONE progression
- To reuse content in another progression, copy the course (new ID, shared resources)
- `source_course_id` tracks lineage for resource sharing

**See:** `docs/requirements/rfc/CD-036/CD-036.md`

### Feed Scoping - Four Feed Types
**Date:** 2026-02-03 (Session 169)

Feeds are scoped to one of four contexts with distinct posting permissions:

| Feed | Scope | Who Can Post | Who Can View |
|------|-------|--------------|--------------|
| **The Commons** | Platform-wide | Anyone | Everyone (including visitors) |
| **Community** | Per community | Members only | TBD (design for flexibility) |
| **Course** | Per course | Enrolled + Creator/Teacher | Enrolled students |
| **Personal** | Per user | That user | TBD (followers?) |

**Community membership is derived from enrollments:**
- No separate membership table needed
- User is member if they have enrollment in ANY course of that community

**Stream.io feed patterns:**
- Personal: `user:{user_id}`
- Community: `community:{community_id}`
- Course: `course:{course_id}`
- Commons: `commons:global`

**See:** `docs/requirements/rfc/CD-036/CD-036.md`

### Feeds as Primary Learning Surface — Phased Delivery Strategy
**Date:** 2026-03-19 (Conv 014)

Client directive: feeds provide ~50% of platform learning. Students take courses for focused learning but ask questions and get answers in feeds. This elevates feeds from navigation utility to primary learning destination.

**Strategy (2 phases):**
1. **Phase 5 (CURRENTUSER-OPTIMIZE):** MyFeeds dashboard card + refactor FeedSlidePanel to use `CurrentUser.getFeeds()` — ✅ Done Conv 015
2. **FEEDS-HUB block:** Composite `/feeds` page as full-page hub with activity indicators — ✅ Done Conv 015. Navbar "My Feeds" changed from slideout panel to `/feeds` page link. FeedSlidePanel removed from navbar (orphaned). Badge counts via FEED-INTEL D1 index.

**Rationale:** A primary learning surface needs a full page, not a 320px slideout. Phase 5 didn't create navigation ambiguity; the composite page improved the experience for the "feeds = 50% of learning" vision.

> **Insight:** The aggregated `/feed` (Stream.io timeline) and the `/feeds` hub serve different purposes: the timeline is a *social* feed (chronological posts mixed together), the hub is a *navigation* surface ("here are your feeds, pick one"). Both are needed — the hub helps students choose WHERE to post, the timeline shows WHAT's happening.

---

### FEED-INTEL: D1 Activity Index Alongside Stream.io (CQRS Hybrid)
**Date:** 2026-03-19 (Conv 015)

Stream.io flat feeds have no unread/unseen tracking, no "count since timestamp" queries, and no cross-feed aggregation. This blocks badge counts and smart surfacing. Solution: CQRS pattern — Stream remains durable content store (posts, reactions, comments, threading), D1 gets a thin metadata index (`feed_visits` + `feed_activities`) for navigation queries.

**Implementation:** Write-time indexing — INSERT into `feed_activities` alongside `stream.addActivity()`. Visit recording — upsert `feed_visits` on feed page load (offset=0 only). Badge counts — single D1 query via LEFT JOIN, zero Stream API calls. Clearing — visiting a feed updates `last_visited_at`, all prior posts become "seen."

**Update (Conv 016):** Comment endpoints DO have slug context (URL params). Dual-write added to all 5 post/comment endpoints (3 post + 2 comment). Course comments/reactions endpoints created. `enrollments.user_id` → `student_id` bug fixed in badge query.

**Rationale:** Each system does what it's good at. Stream handles fan-out, reactions, threading. D1 handles cross-feed queries and unread counts. The D1 index is rebuildable from Stream — not a new source of truth.

> **Insight:** This is textbook CQRS — the write model (Stream) optimizes for durability and fan-out, the read model (D1) optimizes for the specific queries the UI needs. The D1 index is *expendable*: a failed INSERT means a badge count is off by one, not data loss. This asymmetry makes the dual-write safe without distributed transactions.

---

### Auto-Routing FeedActivityCard via Activity Metadata
**Date:** 2026-03-19 (Conv 016)

`FeedActivityCard` derives the correct feed API base path from activity metadata (`communitySlug`, `courseSlug`) instead of requiring parent components to pass it. This ensures comments, reactions, and replies route to the correct feed-specific endpoint from any surface — dedicated feed pages, home timeline, and future surfaces like the smart feed.

**Rationale:** Stream activities carry their source context from creation time. Self-routing from data is more resilient than parent configuration — every new display surface gets correct routing automatically without knowing the routing rules.

---

### SMART-FEED: Hybrid Query Strategy (D1 + App-Side Scoring + Stream Enrichment)
**Date:** 2026-03-19 (Conv 017)

SMART-FEED uses a three-phase hybrid architecture instead of complex SQL scoring: (1) D1 selects raw candidates via the proven tuple-matching pattern from `getFeedBadgeCounts()`, (2) app code loads relationship metadata via parallel D1 queries and scores candidates in TypeScript, (3) Stream batch-fetches full activity objects and adds engagement data. Each phase is independently testable.

**Rationale:** Plan Mode verification found the original 7-JOIN CTE design fragile. The hybrid approach matches the existing architecture where `feed-badges.ts` pre-computes feed lists in app code. Scoring in TypeScript allows the algorithm to be swapped without changing the selection or enrichment layers.

> **Insight:** The `scoring.ts` module has a stable interface (`scoreCandidates(candidates, context, params)`) with swappable internals. This means the algorithm can evolve from weighted signals to ML-based ranking without any changes to candidates.ts, enrichment.ts, or the API endpoint.

---

### SMART-FEED: Discovery Cards as Flywheel Driver
**Date:** 2026-03-19 (Conv 017)

Discovery cards are included from day one — not deferred. Public community and course feeds matching user interests are surfaced to non-members with preview text, engagement social proof, and a CTA to join/enroll. Access rules: public communities only (`is_public = 1`), public course feeds only (`feed_public = 1`), no private content. Server-side dismiss tracking via `smart_feed_dismissals` table.

**Rationale:** The Genesis group (60-80 students) is the proving ground for the learn-teach-earn flywheel. Discovery drives visibility → engagement → enrollment → teaching. Waiting for a later phase would miss the testing window.

---

### SMART-FEED: Isolated Scoring Algorithm with Tunable Params
**Date:** 2026-03-19 (Conv 017)

Scoring weights and parameters stored in `platform_stats` (~12 keys with `smart_feed_*` prefix). Algorithm isolated in `src/lib/smart-feed/scoring.ts`. Discovery posts use engagement-heavy weights; member posts use tunable weights. Topic matching uses three signals: static interests (`user_topic_interests`), feed affinity (posting frequency), and category affinity — all SQL-based with no NLP or external APIs.

**Rationale:** Under 15 params fits key-value `platform_stats` rows. Algorithm isolation allows swapping the scoring function without touching candidates, enrichment, or the API layer. Topic signals are all derived from existing indexed tables.

---

### SMART-FEED: Discovery Cards Capped at 1 Per Feed
**Date:** 2026-03-30 (Conv 059)

Discovery cards are capped at 1 per feed in `applyDiversityCap()`. Discovery cards represent "this feed is active, check it out" — a feed-level suggestion, not post-level content. Multiple cards from the same discovered feed are redundant.

**Rationale:** Without the cap, users saw 3 identical cards from the same feed (e.g., "Intro to n8n") which wasted feed real estate and looked like a bug.

---

### SMART-FEED: Completed Enrollments Included in Teacher/Creator Scoring
**Date:** 2026-03-30 (Conv 059)

Teacher/creator relationship persists after course completion for Smart Feed scoring and filtering. `loadScoringContext()` queries include `'completed'` enrollment status alongside `'enrolled'` and `'in_progress'`.

**Rationale:** Students maintain meaningful relationships with their teachers after finishing a course. Excluding completed enrollments caused the "From Teachers" filter to show nothing for students who had finished their courses — poor UX that contradicts the learn-teach-earn flywheel.

> **Insight:** Role-based filters (e.g., "From Teachers") should use boolean flags computed during scoring (`isTeacherPost`, `isCreatorPost`) rather than the `surfaceReason` field, which reflects the dominant algorithm signal (recency, relationship, engagement) — not the actor's role. When recency weight (0.30) exceeds relationship weight (0.25), teacher posts surface as `'recent'` and the role filter misses them entirely.

---

### Clock Abstraction for Time-Sensitive Endpoints
**Date:** 2026-03-17

`src/lib/clock.ts` exports `getNow()` — use it instead of `new Date()` in any code that makes time-sensitive decisions (join windows, late-cancel checks, availability slot generation). Tests mock it to freeze time. Session cancel, session join, and availability endpoints updated.

**Rationale:** `new Date()` in handlers is untestable. A simple wrapper gives tests a clean mock point with zero runtime cost.

> **Insight:** The combination of clock injection + UTC test helpers + CI lint eliminated an entire class of "passes locally, fails on CI" bugs. The three tools work together: clock injection makes handler logic testable, UTC helpers make test data safe, and the lint catches regressions before they reach CI.

### UTC Test Date Helpers
**Date:** 2026-03-17

`tests/helpers/dates.ts` provides `utcDate()`, `futureUTC()`, `pastUTC()`, `nextDayOfWeekUTC()`, `toDateStringUTC()`. All test date construction should use these instead of `setHours()` or multi-arg `new Date()`. CI lint script `npm run lint:tz` flags violations.

**Rationale:** Timezone-unsafe date patterns caused 5 test failures on CI that passed locally. See BEST-PRACTICES.md §8 "Timezone Safety in Tests" for full guidelines.

---

### Enrollment Guards — Block vs Warn Strategy
**Date:** 2026-03-18

Creator self-enrollment, active teacher self-enrollment, duplicate active enrollment, and zero teachers are hard blocks (400). No availability in the configurable window is warn-only — students can still enroll because teachers may update schedules. Zero teachers triggers notification to creator + all admins.

**Rationale:** Hard blocks prevent broken business logic (creator paying themselves). Soft warn for "no availability" because availability is dynamic.

### Re-Enrollment as New Row with Partial Unique Index
**Date:** 2026-03-18

Multiple enrollment rows allowed per student+course. Completed/cancelled rows retained as history. Partial unique index `WHERE status IN ('enrolled', 'in_progress')` enforces at most one active enrollment at the DB level.

**Rationale:** Preserves completion history. Partial unique index is more reliable than app-level checks — survives race conditions and direct DB access.

> **Insight:** SQLite partial indexes (`CREATE UNIQUE INDEX ... WHERE condition`) are underused but ideal for "at most one active" patterns.

### Inactive Teacher Treated as Student for Enrollment
**Date:** 2026-03-18

Only teachers with `is_active=1` AND `teaching_active=1` are blocked from self-enrolling. Deactivated or paused teachers can enroll as regular students.

**Rationale:** Per client: "An inactive teacher is the same as a student from the POV of the course."

### Availability Summary — Public Endpoint with Optional Auth
**Date:** 2026-03-18

`GET /api/courses/:id/availability-summary` is public. Shows slot counts and next-available dates (not exact times). Optional auth to exclude self from teacher list.

**Rationale:** Teacher names/ratings already public. Slot counts add minimal privacy risk. Exact booking times remain behind authenticated booking flow.

---

## Decision Log

For historical decisions and the full rationale behind each choice, see the session files in `docs/sessions/YYYY-MM/`.

### Session Completion: Teacher/Creator Only — Students Cannot Complete
**Date:** 2026-03-24

Students are not authorized to call `POST /api/sessions/:id/complete`. Only the session's teacher or the course creator can mark a session as completed. Students who encounter a stuck session see an inline message form to notify the teacher.

**Rationale:** Completion triggers `module_id` freezing and enrollment progress tracking. Allowing students would let a no-show student mark the session as `completed` (getting module credit) instead of `no_show`. The teacher is the authority on whether the session actually occurred.

### Session Completion Defense-in-Depth Chain
**Date:** 2026-03-24

Five layers ensure sessions transition out of `in_progress`, in order of timeliness: (1) BBB `meeting-ended` webhook (real-time), (2) empty-room detection on `user-left` webhook (real-time), (3) client-side "Complete Session Now" button for teacher after `scheduledEnd` (user-initiated), (4) admin batch cleanup endpoint (manual), (5) Cloudflare Cron Trigger (deferred to pre-launch, CRON-CLEANUP block).

**Rationale:** No single mechanism is reliable. BBB webhooks can fail silently, users can close browser tabs without triggering `user-left`, and admin cleanup requires human action. Each layer catches what the previous one misses.

### completeSession() as Post-Completion Pipeline
**Date:** 2026-03-24

`completeSession()` orchestrates all post-completion behavior as a single pipeline: status transition → module freeze → module backfill (for out-of-order completions) → enrollment completion check → post-session actions (notifications + stats, async non-blocking). All completion paths (BBB webhook, manual endpoint, admin) get the full pipeline automatically.

**Rationale:** Centralizing in one function eliminates duplication across 3+ callers and guarantees consistency. Backfill and enrollment check are synchronous (their results inform notifications). Post-session actions are fire-and-forget to avoid blocking the completion response on notification/stats failures.

> **Insight:** This is a lightweight saga pattern — a sequence of steps where each informs the next, with the final step being non-blocking. Unlike a traditional saga, there's no compensation (rollback) because each step is independently valuable and idempotent.

### Publishing Gate: Tag-Based (Post TAG-TAXONOMY)
**Date:** 2026-04-01

Publishing checklist requirement changed from "Topic selected" (`!!course.topic_id`) to "At least one tag assigned" (`course.tags.length > 0` frontend, `COUNT(*) FROM course_tags` backend). Post TAG-TAXONOMY refactor, courses are discoverable via tag:tag matching — whether tags have topic associations is a data quality concern, not a publishing gate.

**Rationale:** The `courses.topic_id` column was removed in TAG-TAXONOMY (Conv 048-054) but the publish checklist still checked it. Tags are the discoverability mechanism; at least one tag is the minimum requirement.

### Enrollment: Teacher Defaults to Course Creator
**Date:** 2026-04-01

In `createEnrollmentFromCheckout()`, if `assigned_teacher_id` is null/empty in Stripe metadata, look up the course creator and assign them as the default teacher.

**Rationale:** For creator-taught courses (the most common case), the creator IS the teacher. Peer-teacher courses require explicit teacher selection during checkout, so metadata will have the value. This ensures every enrollment has a teacher assigned.

### PLATO Segments: Composability + Restartability
**Date:** 2026-04-01

Segments are named step groups (2-3 steps) with goals, transparent context flow, and DB snapshots at boundaries. New types: `PlatoSegment`, `SegmentRef` as `ChainEntry` variant. Future consideration: `$flow.state` (Node-RED `msg` pattern) for self-aware segments.

**Rationale:** Merges two goals — composability (reuse segments across scenarios) and restartability (restore pre-failure snapshot, re-run segment). Transparent context avoids input/output contract overhead. Snapshots solve partial-write problem. Full design in `docs/as-designed/plato.md`.

> **Insight:** The Node-RED `msg` pattern — a single object traveling through all nodes as both data plane and control plane — maps cleanly to PLATO's `$context`/`$flow.state` split. Per-step namespaced context prevents collisions while flow-wide state enables cross-cutting concerns (skip directives, mode flags, completion tracking). This makes segments self-aware rather than runner-directed.

---

## Terminology Footnotes

These footnotes document renames applied during the TERMINOLOGY block (Sessions 346-356). See `GLOSSARY.md` for the full terminology standard and "Teacher Replaces Student-Teacher Platform-Wide" decision above for rationale.

[^tc]: `teacher_certifications` — formerly `student_teachers`. Per-course teaching certification records. Renamed Session 349.
[^at]: `assigned_teacher_id` — formerly `student_teacher_id` (enrollments FK). References `users.id`, not `teacher_certifications.id`. Renamed Session 351.
[^it]: `is_teacher` — formerly `is_student_teacher`. Derived boolean, not a stored column. Renamed Session 349.

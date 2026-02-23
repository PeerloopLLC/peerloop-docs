# DECISIONS.md

This document contains all active architectural and implementation decisions for the Peerloop project. Decisions are organized by impact level and category. When decisions conflict, the most recent one wins and supersedes earlier decisions.

**Last Updated:** 2026-02-23 Session 270 (CREATOR-SETUP API decisions: /api/me/communities namespace, auto-create progression, require progression_id)

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

**Architecture:** `peerloop-docs/` is CC home (.claude/, CLAUDE.md, docs/, research/, RFC/, planning files). `Peerloop/` is clean code repo with symlinks (`docs → ../peerloop-docs/docs`, `research → ../peerloop-docs/research`) for build-time dependencies.

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
**Date:** 2026-02-03 (Session 173)

The DiscoverSlidePanel links to `/discover/*` routes for browsing public content within the app shell:

- `/discover/courses` - Course browse (CBRO)
- `/discover/creators` - Creator listing (CRLS)
- `/discover/teachers` - Student-Teacher directory (STDR)
- `/discover/students` - Student directory (new)
- `/discover/leaderboard` - Community leaderboard (LEAD)
- `/discover/communities` - Community browse (future)

PAGES-MAP.md routes (`/teachers`, `/creators`, `/leaderboard`) are historical references from the original design. New pages use AppLayout and live in `src/pages/discover/`.

**Rationale:** PAGES-MAP.md represents pre-client-change design. The `/discover/*` namespace provides clear organization for browsing pages within the new app shell architecture.

**See:** `src/components/layout/DiscoverSlidePanel.tsx`, `.claude/commands/L-convert-page.md`

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
- `/teacher/[handle]` - Student-Teacher profile (STPR)
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

### Community/Feed 1:1 Mapping
**Date:** 2026-02-04 (Session 181)

Each community has exactly one feed. The community page IS the feed. Post categorization uses tags instead of separate feeds.

| Entity | Feed Pattern |
|--------|-------------|
| Community | `community:{community_id}` - tagged posts |
| Course | `course:{course_id}` - enrolled students only |

Tag filtering via query params: `/community/the-commons?tag=announcements`

**Rationale:** Simpler data model (no separate feed entity); tags more flexible than multiple feeds; routing simplification.

**See:** `tech-021-url-routing.md` (Community & Feed Architecture section), `RFC/CD-036/`

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

**See:** `src/pages/community/[slug]/`, `src/components/community/CommunityTabs.tsx`, `docs/tech/tech-021-url-routing.md`

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

**See:** `migrations/0001_schema.sql` (progressions table), `RFC/CD-036/`

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
- Role-aware menu items (Visitor, Student, ST, Creator)
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
| S-T / Creator | Redirect to `/workspace` |
| Admin | Redirect to `/messages` |

Additionally, Admins see a "To Admin" navbar item (after "More") linking to `/admin`.

**Rationale:** Tailors the home experience to each user's primary action without adding a new "Home" navbar item. Reuses existing navigation destinations.

**See:** `src/components/layout/AppNavbar.tsx` (role-based useEffect)

### CurrentUser Global State Architecture
**Date:** 2026-02-03 (Session 171, expanded from Sessions 145, 161)

Use a `CurrentUser` class singleton stored on `window.__peerloop.currentUser` for shared user state across Astro islands.

- Single `/api/me/full` endpoint returns user identity + all course relationships + profile data
- Stale-while-revalidate: hydrate from localStorage instantly, refresh from API in background
- Course-aware role methods: `isStudentTeacherFor(courseId)`, `isCreatorFor(courseId)`
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

**See:** `src/lib/current-user.ts`, `src/pages/api/me/full.ts`, `docs/tech/tech-020-state-management.md`

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

**See:** `src/components/layout/AppNavbar.tsx`, `docs/tech/tech-020-state-management.md`

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
├── student-teachers/
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
- Role-aware with sections for Admin, Creator, S-T
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

**See:** `docs/tech/tech-002-stream.md`, Stream Dashboard Feed Groups

### Stream Chat for Private Messaging
**Date:** 2026-01-21

Use Stream Chat for private messaging between students, student-teachers, and creators. This aligns with the existing Stream.io integration for activity feeds.

**Rationale:** Client directive; consistent with existing Stream Feeds integration; reduces vendor complexity (single real-time provider); proven scalability; feature-rich (typing indicators, read receipts, reactions, threads).

**See:** `docs/tech/tech-018-messaging.md`

### BigBlueButton for Video Conferencing
**Date:** 2026-01-20

Use BigBlueButton (BBB) as the video conferencing platform for tutoring sessions, implemented via VideoProvider abstraction.

- VideoProvider interface in `src/lib/video/types.ts`
- BBB adapter in `src/lib/video/bbb.ts`
- Environment: `BBB_URL`, `BBB_SECRET`
- Sessions table: `bbb_meeting_id`, `bbb_internal_meeting_id`, `bbb_attendee_pw`, `bbb_moderator_pw`

**Rationale:** Client (Brian) chose BBB over PlugNmeet for video platform. VideoProvider abstraction allows future swapping if needed.

**See:** `docs/tech/tech-001-bigbluebutton.md`, `src/lib/video/`

### Homepage Landing Strategy (RESOLVED)
**Date:** 2026-01-29 (Session 145)
**Status:** Resolved - Option 2 chosen

Client decided to use the app itself as the landing page. Dashboard at `/`, marketing at `/welcome`.

**Decision:** Option 2 - App as Landing
- `/` shows DashLayout (dashboard) for all users
- `/welcome` contains marketing content (moved from old `/`)
- Marketing components (`src/components/home/`) still used at `/welcome`

**See:** "Dashboard as Homepage" decision above

---

## 2. Database & Data Model (High Impact)

### User Role System - Capabilities + Course Relationships
**Date:** 2026-02-02 (Session 161, supersedes 2026-01-29)

User permissions split into two categories:

**Capability Flags (what you CAN do):**
- `can_create_courses` - permission to author courses (admin grants)
- `can_take_courses` - permission to enroll (default: true)
- `can_teach_courses` - permission to be certified as ST (admin grants)
- `can_moderate_courses` - permission to be granted mod rights (admin grants)
- `is_admin` - global admin flag (NOT course-specific)

**Course Relationships (what you ARE for specific courses):**
- `student_teachers` table - ST certification per course
- `enrollments` table - student status per course

**Removed from Schema (Session 161):**
The following deprecated flags have been REMOVED from the schema entirely:
- `is_student` - use `can_take_courses` capability
- `is_student_teacher` - derive from `student_teachers` table
- `is_creator` - derive from `courses` table (see Permission vs State below)
- `is_moderator` - will be course-specific (future)

**Rationale:** Separates "capabilities" (admin-controlled permissions) from "roles" (course-specific relationships). A user can be a student for Course A and Student-Teacher for Course B. Keeping deprecated flags (even with comments) led to code using the wrong fields. Removing them forces correct usage.

**See:** `src/lib/current-user.ts`, `migrations/0001_schema.sql`

### Permission vs State: The Critical Distinction
**Date:** 2026-02-02 (Session 162)

There are TWO distinct concepts that were conflated in the old `is_creator` and `is_student_teacher` flags:

| Concept | Type | Meaning | Storage | Can be revoked? |
|---------|------|---------|---------|-----------------|
| **Permission** | Future-looking | Can user do X? | `users.can_*` columns | Yes (admin) |
| **State** | Backward-looking | Has user done X? | Derived from tables | No (historical fact) |

**For Creators:**
- `can_create_courses = 1` → User has permission to create new courses (admin grants)
- `is_creator` (derived) → User has created course(s): `EXISTS (SELECT 1 FROM courses WHERE creator_id = ?)`

**For Student-Teachers:**
- `can_teach_courses = 1` → User has permission to become an ST (admin grants)
- `is_student_teacher` (derived) → User is certified for course(s): `EXISTS (SELECT 1 FROM student_teachers WHERE user_id = ? AND is_active = 1)`

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

### Creator Auto-Added as ST with Self-Service Control
**Date:** 2026-01-29 (Session 148)

When a Creator creates a course, they are automatically added as a Student-Teacher (ST) for that course. The Creator can then add or remove themselves as an ST of their own course via self-service.

**Business Rules:**
- Creator must have `can_teach_courses=1` to be eligible for auto-ST assignment
- Creator is auto-added as ST when course is created
- Creator can opt out (remove themselves as ST) at any time
- Creator can re-add themselves as ST later

**Rationale:** Most Creators will want to teach their own course initially. Self-service control allows them to step back and let other STs handle teaching without admin intervention.

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
└── 0002_seed_core.sql   # Essential data only (categories, admin, The Commons)

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

**See:** `docs/tech/tech-024-migrations.md`, `migrations/README.md`

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

**Users covered:** Guy Rymberg (creator), Sarah Miller (S-T), Marcus Thompson (S-T) — enables full creator→S-T payment split testing.

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
| **ST-course-level** | `student_teachers.rating` | Rating for teaching specific course | Completion reviews only |

**Session ratings** (`session_assessments`) are diagnostic - quick pulse checks after each session. They update `user_stats` but do NOT affect ST profile ratings.

**Completion reviews** (`enrollment_reviews`) are evaluative - comprehensive feedback when student completes the full course journey. These alone feed into `student_teachers.rating`.

**Rationale:** Session ratings are noisy and don't reflect overall experience. Completion reviews provide meaningful, comparable data for ST profiles. Matches how Airbnb/Coursera work (rate after experience ends).

**See:** `src/pages/api/enrollments/[id]/review.ts`, `src/pages/api/sessions/[id]/rating.ts`

### Topics Table (Hybrid Taxonomy) for Onboarding
**Date:** 2026-02-22 (Session 252)

New `topics` table provides curated subtopics linked to parent categories. Used for member onboarding interest selection and future discover page filtering. ~55 topics (3-5 per category), admin-controlled.

**Rationale:** More structured than freeform `course_tags` (curated, consistent) but lighter than a full subcategories hierarchy. Existing `user_interests` table kept as-is; onboarding also syncs topic names there for backward compatibility.

**See:** `migrations/0001_schema.sql` (topics table), `migrations/0002_seed_core.sql` (topic seeds)

### Separate member_profiles Table for Onboarding Data
**Date:** 2026-02-22 (Session 252)

Onboarding questionnaire answers (primary_goal, referral_source, profession, onboarding_completed_at) stored in a separate `member_profiles` table keyed by `user_id`, not as additional columns on `users`.

**Rationale:** The `users` table (30+ columns) is read on every authenticated page load via `/api/me/full`. Only `onboarding_completed_at` is surfaced in `CurrentUser` (via LEFT JOIN) for conditional navbar menu visibility. Keeps onboarding concerns isolated.

**See:** `src/pages/api/me/full.ts` (LEFT JOIN), `src/lib/current-user.ts` (hasCompletedOnboarding)

### Community Recommendations via Transitive Progression Chain
**Date:** 2026-02-22 (Session 259)

Communities don't have a direct `category_id`. Recommendations match transitively through existing relationships: `user_topic_interests` → `topics.category_id` → `courses.category_id` → `courses.progression_id` → `progressions.community_id` → `communities`.

**Rationale:** The schema already models this relationship — courses belong to categories AND progressions, progressions belong to communities. Using the existing chain avoids schema changes and naturally aligns with the platform's content structure. Falls back to popular communities when no transitive matches exist.

**See:** `src/pages/api/recommendations/communities.ts`

---

## 3. API & Data Fetching (Medium-High Impact)

### 4-Layer Data Fetching Architecture
**Date:** 2025-12-29

1. **Layer 1:** SSR + 5min cache for public pages (fast, SEO-optimized)
2. **Layer 2:** CSR overlay for personalization (non-blocking)
3. **Layer 3:** SSR + auth for user-specific pages (dashboards)
4. **Layer 4:** Hybrid admin (dedicated routes + Context Actions)

**Documented in:** `docs/tech/tech-014-data-fetching.md`

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

**See:** `docs/tech/tech-027-auth-sessions.md`

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

**Trigger:** Client needs per-community moderation. Single global flag insufficient — Creators need to appoint trusted community members for day-to-day feed oversight when they and their S-Ts are unavailable.

**Options Considered:**
1. **Add `moderator` to `community_members.role` enum** — Rejected. Dual-role problem: a user who is both a member and a moderator would need to change their `role` field. Current enum values (`creator`, `student_teacher`, `member`) are mutually exclusive in intent. Adding `moderator` conflates membership role with moderation authority.
2. **Separate `community_moderators` table** ← **Chosen.** Follows the `student_teachers` pattern: per-entity relationships with their own metadata (appointed_by, revoked_by, revoke_reason). User keeps their `community_members.role = 'member'` AND gets a `community_moderators` row.
3. **Per-course `course_moderators` table** — Rejected. Too granular. Community is the natural scope unit — courses inherit moderation via Community → Progression → Course chain. Per-course assignment would create N moderator rows for N courses in a community when the intent is community-wide.

**Stewardship Stack (hierarchical oversight model):**
```
Creator → S-Ts → Community Moderator → Global Moderator
(community owner)  (course support)  (day-to-day feed)   (platform policy)
```

**Rationale:** Community is the natural scope unit for moderation. Creators own communities. Courses belong to communities via progressions. Moderating a community implicitly covers all its course feeds. This matches how Discord and Reddit scope moderator authority (server/subreddit level, not channel level).

**See:** `docs/reference/ROLES.md` (§5 Moderator Two-Tier Model), `research/DB-SCHEMA.md` (community_moderators table)

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

---

## 5. UI/UX & Components

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

Course detail pages (`/course/[slug]`) use a 5-tab URL-aware interface: **About → Teachers → Resources → Feed → Curriculum**.

| Tab | Visibility | Data Strategy | Route |
|-----|-----------|---------------|-------|
| About | Public | Server-side | `/course/[slug]` |
| Teachers | Public | Server-side (expanded S-T query) | `/course/[slug]/teachers` |
| Resources | Public preview + enrolled full | Client-side fetch (`/api/courses/:id/resources`) | `/course/[slug]/resources` |
| Feed | Public | Server-side (Stream.io) | `/course/[slug]/feed` |
| Curriculum | Enrolled only | Server-side | `/course/[slug]/curriculum` |

**Tab ordering rationale:** Follows the student discovery journey — learn about the course, meet teachers, preview materials, see community, then engage with curriculum.

**Data strategy:** Tabs use server-side data (passed as props from Astro page) when the data is simple joins. Resources uses client-side fetch because the API encapsulates enrollment gating, R2 download URL generation, and public/private filtering.

**Each tab has a dedicated `.astro` page** for SSR bookmarkability, with `initialTab` prop controlling which tab renders active. Client-side tab switching uses `history.pushState` for SPA-like navigation.

**See:** `src/components/courses/CourseTabs.tsx`, `docs/tech/tech-021-url-routing.md`

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

---

## 6. Testing & CI/CD

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

---

## 7. Development Workflow & Documentation

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

Each page's JSON file (`src/data/pages/**/*.json`) serves as the single place to find all related file paths: components (`tsxComponents[]`, `astroComponents[]`), documentation (`docs.spec`, `docs.page`, `docs.audit`), test script (`testScript`), and Astro route (`astroFile`). Schema v1.3 replaced the old single `component` string with arrays.

**Rationale:** Files for one page were scattered across 6+ directory trees. Opening the JSON gives you every path without searching.

**See:** `scripts/populate-page-metadata.ts` (auto-populates from directory walks)

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

**See:** `docs/tech/tech-016-astrojs.md` (Caveats section)

### Provision Cloudflare KV Namespace
**Date:** 2026-02-16

Provision KV namespace (`SESSION` binding) for all environments even though no application code actively uses it. Separate namespaces for production and preview to prevent data leakage.

**Rationale:** Satisfies the Astro Cloudflare adapter's SESSION binding requirement, prevents deploy failures, and makes KV available for future use cases (feature flags, rate limiting, caching). Free tier is generous (100K reads/day). Cost of not provisioning: potential deploy failure.

**See:** `docs/tech/tech-029-cloudflare-kv.md`

### Image Service: Passthrough (No Optimization)
**Date:** 2026-02-16

Use `imageService: 'passthrough'` on the Cloudflare adapter. No Astro `<Image>` components. Plain `<img>` tags with R2 URLs. Image optimization (Cloudinary or CF Image Resizing) deferred to post-MVP.

**Rationale:** Low image volume for MVP. Optimization adds vendor complexity with no measurable benefit. The `passthrough` setting must be on the adapter constructor (not Astro's top-level `image` config) because the adapter overrides Astro's image config.

**See:** `docs/tech/tech-028-image-handling.md`

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

**See:** `src/lib/stream.ts` for implementation, `docs/tech/tech-002-stream.md` for full caveat.

### Environment Variable Architecture (CF Pages Constraints)
**Date:** 2026-02-06

Non-secret env vars are duplicated in both `.dev.vars` (local dev) and `wrangler.toml [vars]` (Cloudflare deployment). Secrets live in `.dev.vars` (local) and are set via CF dashboard (deployed). Reference file `.secrets.cloudflare` lists all secrets for dashboard setup.

**Rationale:** CF Pages dashboard only allows encrypted secrets when `wrangler.toml` exists — non-secrets must come from `[vars]`. Meanwhile `.dev.vars` must keep non-secrets to override production values with dev values locally. All CF secrets managed via dashboard (not CLI) because `wrangler pages secret put` has no `--env` flag for preview.

**See:** `docs/tech/tech-026-env-vars-secrets.md` for complete reference.

### Stay on Node 22 — Node 24 Blocked by CF Pages
**Date:** 2026-02-16

Remain on Node 22.19.0. Do not upgrade to Node 24 until Cloudflare Pages adds it to their build image and Astro 5.x officially supports it. Node 22 is supported until April 2027.

**Rationale:** Two blockers: (1) CF Pages build image doesn't include Node 24 (`node-build: definition not found: 24`), (2) Astro 5.x only lists Node 18/20/22 as supported. The build warning ("LTS Maintenance mode") is informational only.

**See:** `docs/tech/tech-011-cloudflare.md` (Node.js Version on CF Pages), `docs/tech/tech-013-devcomputers.md` (Node.js Version)

### Defer Stripe Production Secrets Until Go-Live
**Date:** 2026-02-06

Do not add `STRIPE_SECRET_KEY` or `STRIPE_WEBHOOK_SECRET` to the Cloudflare Production environment until MVP go-live. Live values are stored in `.secrets.cloudflare` for reference but should not be entered into the CF Dashboard yet.

**Rationale:** With no Stripe secrets in production, payment endpoints fail gracefully (missing key) rather than processing real charges. This creates a clear launch gate — adding live Stripe secrets becomes an explicit go-live checklist item, not something that's been sitting there untested.

**See:** `.secrets.cloudflare` (production Stripe section), `docs/tech/tech-026-env-vars-secrets.md` (deployment table)

### Self-Healing API Endpoints for Stripe Status Sync
**Date:** 2026-02-18

The `connect-status` API endpoint derives the correct Stripe account status from live Stripe API data (`active` when charges + payouts + details all enabled) and automatically syncs the database when it detects drift from the stored value. This makes the endpoint write to the DB (was previously read-only).

**Rationale:** Webhooks can be missed (listener not running, network issues, race conditions). Since the endpoint already makes a Stripe API call for the boolean flags, deriving status is essentially free. The `account.updated` webhook remains as an optimization for real-time updates, but the system is correct-by-default even without it.

**See:** `src/pages/api/stripe/connect-status.ts`

### Staging Webhook Active for Stripe (Supersedes "Skip Preview Webhook")
**Date:** 2026-02-18 (Session 224, supersedes Session 223)

Register a Stripe webhook endpoint for the `staging` branch at `staging.peerloop.pages.dev/api/webhooks/stripe`. While per-commit URLs are dynamic, branch-based URLs are stable enough for Stripe webhooks. Uses "Your account" context (6 events: checkout.session.completed, charge.refunded, account.updated, transfer.created, charge.dispute.created, charge.dispute.closed). The `payout.failed` event requires a separate "Connected accounts" endpoint — deferred.

**Rationale:** The Session 223 decision was based on per-commit URLs (`<hash>.peerloop.pages.dev`). Branch-based URLs (`staging.peerloop.pages.dev`) are fixed and suitable. Having webhooks on staging enables full payment flow testing.

**See:** `docs/tech/tech-003-stripe.md` (Per-Environment Webhook Configuration)

### Dispute Handling Is Critical Infrastructure
**Date:** 2026-02-18 (Session 224)

Implement `charge.dispute.created` and `charge.dispute.closed` webhook handlers as part of core payment infrastructure, not deferred/nice-to-have. Disputes are the only webhook event where silence causes automatic financial loss (Stripe rules against the platform if no evidence is submitted within 7-14 days). On dispute creation: freeze enrollment, mark transaction as disputed, notify admin. On dispute loss: cancel enrollment, reverse transfers to connected accounts to recover platform funds.

**Rationale:** Systematic audit of all Stripe API calls revealed disputes as the most dangerous unhandled event. Unlike `payout.failed` (courtesy notification) or `checkout.session.expired` (cleanup), disputes have urgent financial and operational consequences.

**See:** `src/pages/api/webhooks/stripe.ts` (handleDisputeCreated, handleDisputeClosed)

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
2. Categories Admin
3. Courses Admin
4. Enrollments Admin
5. Student-Teachers Admin

### Moderator Suspension Limits
**Date:** 2026-01-21

Moderators can issue temporary suspensions (1d, 7d, 30d) but permanent suspensions require admin role.

**Rationale:** Moderators need authority to address violations promptly, but permanent bans are high-impact decisions requiring admin oversight. Inline role check in `suspend.ts` API.

**See:** `src/pages/api/admin/moderation/[id]/suspend.ts`

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
- `/teaching` - S-T dashboard
- `/creating` - Creator dashboard

**Profile URL resolution:**
- `/@handle` - Any user's public profile
- `/@me` - Redirects to current user's profile
- `/profile` - Redirects to `/@me`
- `/settings/profile` - Edit profile form

**Rationale:** Users spend most time with their own content. The default context should be personal; discovery is an explicit action. This is more intuitive than `/my/courses` vs `/courses`.

**See:** `docs/tech/tech-021-url-routing.md`

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

**See:** `RFC/CD-036/CD-036.md`

### Feed Scoping - Four Feed Types
**Date:** 2026-02-03 (Session 169)

Feeds are scoped to one of four contexts with distinct posting permissions:

| Feed | Scope | Who Can Post | Who Can View |
|------|-------|--------------|--------------|
| **The Commons** | Platform-wide | Anyone | Everyone (including visitors) |
| **Community** | Per community | Members only | TBD (design for flexibility) |
| **Course** | Per course | Enrolled + Creator/S-T | Enrolled students |
| **Personal** | Per user | That user | TBD (followers?) |

**Community membership is derived from enrollments:**
- No separate membership table needed
- User is member if they have enrollment in ANY course of that community

**Stream.io feed patterns:**
- Personal: `user:{user_id}`
- Community: `community:{community_id}`
- Course: `course:{course_id}`
- Commons: `commons:global`

**See:** `RFC/CD-036/CD-036.md`

---

## Decision Log

For historical decisions and the full rationale behind each choice, see the session files in `docs/sessions/YYYY-MM/`.

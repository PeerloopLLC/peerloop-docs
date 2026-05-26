# url-routing.md

## URL Routing Architecture

**Decision Date:** 2026-02-03 (Session 169)
**Last Updated:** 2026-05-26 (Conv 197 [ROUTE-FLIP]: the `/matt/*` namespace dissolved — design-system pages promoted to root, legacy app moved to `/old/*`. § Route Categories #8 rewritten for the post-flip state; §§1–7 + the file-structure tree still describe the pre-flip layout and now apply to `/old/*` — full reconciliation tracked as follow-up. See `matt-provenance.md` §8.)
**Previously:** 2026-05-20 (Conv 166 [CRT-4/5/DEDICATED-PAGES]: 4 new role-tab routes `/course/[slug]/{teaching,creator,admin,moderator}-sessions` served by dynamic `[tab].astro` catch-all; static-route precedence keeps existing 7 `.astro` files unaffected; Resources tab access expanded to creator/admin/moderator)
**Status:** Adopted
**Affects:** All page routes, navigation, links

---

## Overview

PeerLoop uses a "bare = my" routing convention where authenticated users see their personal content at bare routes, and site-wide discovery uses the `/discover/` prefix.

---

## Core Principles

| Principle | Pattern | Example |
|-----------|---------|---------|
| Bare route = My stuff | `/thing` | `/courses` = my enrolled courses |
| Discovery = Site-wide | `/discover/thing` | `/discover/courses` = course catalog |
| Singular for resources | `/thing/[id]` | `/course/python-101` (not `/courses/`) |
| Plural for collections | `/discover/things` | `/discover/courses` |
| Activity for dashboards | `/doing` | `/teaching`, `/creating`, `/learning` |
| Resource for profiles | `/thing/[id]` | `/creator/[handle]`, `/teacher/[handle]` |
| Universal profiles | `/@handle` | `/@jane` = Jane's unified profile |
| Settings are implicit | `/settings/*` | No `/my/` prefix needed |

---

## Singular vs Plural Convention

**Established:** Session 175 (2026-02-03)

| Type | Pattern | Examples |
|------|---------|----------|
| **Individual resource** | `/{singular}/[param]` | `/course/[slug]`, `/creator/[handle]` |
| **Resource sub-routes** | `/{singular}/[param]/{action}` | `/course/[slug]/learn`, `/course/[slug]/book` |
| **Discovery/collections** | `/discover/{plural}` | `/discover/courses`, `/discover/creators` |
| **Personal collections** | `/{plural}` (bare) | `/courses` (my enrolled) |
| **API endpoints** | `/api/{plural}/` | `/api/courses/`, `/api/creators/` |

**Rationale:** REST convention distinguishes collections from individual resources. Shorter URLs for profile pages are more shareable.

---

## Activity vs Resource Namespaces

**Established:** Session 177 (2026-02-04)

Dashboard and tool pages use **activity namespaces** (verb/gerund form), while public pages use **resource namespaces** (noun form):

| Namespace | Type | Purpose | Examples |
|-----------|------|---------|----------|
| `/dashboard` | Activity | Unified cross-role dashboard | `/dashboard` |
| `/creating/*` | Activity | Creator's dashboard & tools | `/creating`, `/creating/studio`, `/creating/communities`, `/creating/earnings` |
| `/teaching/*` | Activity | Teacher's dashboard & tools | `/teaching`, `/teaching/sessions`, `/teaching/earnings`, `/teaching/students` |
| `/learning/*` | Activity | Student's dashboard & tools | `/learning`, `/learning/sessions` |
| `/creator/*` | Resource | Creator profiles (public) | `/creator/[handle]` |
| `/teacher/*` | Resource | Teacher profiles (public) | `/teacher/[handle]` |
| `/course/*` | Resource | Course pages (public) | `/course/[slug]`, `/course/[slug]/book` |

**Rationale:** Clear separation between private dashboard tools ("what I'm doing") and public profile pages ("who this person is").

---

## Community & Feed Architecture

**Established:** Session 181 (2026-02-04)
**Updated:** Session 183 (2026-02-04) - Removed creator feeds

### Feed Hierarchy

```
Creator
└── Communities (many)
    ├── Community Feed (1) ← /community/[slug] (community IS the feed)
    └── Courses (many)
        └── Course Feed (1) ← /course/[slug]/feed
```

**Key Rules:**
- **1:1 Community:Feed** — Each community has exactly one feed; the community page IS the feed
- **Tags, not feeds** — Announcements, Help, etc. are post tags within a feed, not separate feeds
- **The Commons** — PeerLoop community's feed (auto-subscribed for all users)
- **No creator feeds** — Creators use communities for announcements (avoids user feed slippery slope)

### My Feeds Section (AppNavbar)

| Section | SlideOut Panel | Hub Page |
|---------|----------------|----------|
| My Communities | Communities I've joined | `/community` |
| Course Feeds | Courses I'm enrolled in | — (via `/course/[slug]/feed`) |

### Community Routes

| Route | Purpose | Auth |
|-------|---------|------|
| `/community` | My Communities hub (The Commons at top, then joined) | Optional |
| `/community/[slug]` | Community Feed tab (default) | Optional |
| `/community/[slug]/courses` | Community Courses tab | Optional |
| `/community/[slug]/resources` | Community Resources tab | Optional |
| `/community/[slug]/members` | Community Members tab | Optional |
| `/community/[slug]?tag=help` | Filtered feed view by tag | Optional |
| `/discover/communities` | Community catalog (role-aware: tabs per role, pill filters in All tab) | Public |

**Note:** The Commons (`isSystem: true`) redirects `/community/the-commons/courses` to `/community/the-commons` since system communities don't have courses.

**The Commons special case:**
- Slug: `the-commons` (or `peerloop`)
- Auto-subscribed for all users (including visitors)
- Tags for categorization: `general`, `announcements`, `help`

### Feed Routes

| Route | Purpose | Auth |
|-------|---------|------|
| `/course/[slug]/feed` | Course feed (tabbed UI) | Enrolled |
| `/feed` | Aggregated personalized feed | Required |
| `/feeds` | Feeds hub — directory of all user feeds (original FeedsHub) | Required |
| `/discover/feeds` | Feed discovery — active public feeds with CTAs to parent entities | Public |

**Note:** Creator feeds (`/creator/[handle]/feed`) were removed in Session 183. Creators should create communities for announcements.

**Note:** `/feeds` is the authenticated user's feed hub (personal directory). `/discover/feeds` is the visitor-accessible discovery page surfacing active public feeds with "Join Community" / "View Course" CTAs. Decision made Conv 044.

### Hub Page Pattern

The `/community` page mirrors the My Communities SlideOut Panel, just as `/discover` mirrors the Discovery SlideOut Panel:

```
/community                  /discover
├── The Commons             ├── Courses
├── ─────────────           ├── Members
└── [Joined communities]    ├── Communities
                            ├── Feeds
                            └── Leaderboard
```

---

## Route Categories

### 1. Personal Routes (Bare) — Requires Auth

Default context for logged-in users. "My stuff."

| Route | Purpose |
|-------|---------|
| `/community` | My Communities hub (The Commons + joined) |
| `/courses` | My enrolled courses |
| `/messages` | My messages |
| `/notifications` | My notifications |
| `/feed` | My personalized feed |
| `/feeds` | Feeds hub — directory of all user feeds |
| `/dashboard` | Unified dashboard (all roles combined, activity-first layout) |
| `/learning` | Student dashboard |
| `/learning/sessions` | My sessions (grouped by course → module) |
| `/teaching` | Teacher dashboard |
| `/teaching/students` | My students |
| `/teaching/sessions` | My sessions (grouped by course → student) |
| `/teaching/earnings` | My earnings |
| `/teaching/analytics` | My teaching stats |
| `/teaching/courses/[courseId]` | Teacher course detail (tabbed: overview, students, sessions, feed, reviews) |
| `/creating` | Creator dashboard |
| `/creating/apply` | Creator application form |
| `/creating/studio` | Course builder |
| `/creating/communities` | Community list & management |
| `/creating/communities/[slug]` | Community detail (progressions, settings) |
| `/creating/analytics` | Course stats |
| `/profile` | Redirects to `/@{myHandle}` |
| `/onboarding` | Interests & Preferences (ONBD) |

### 2. Discovery Routes (`/discover/`) — Public or Auth

Site-wide browsing and exploration.

| Route | Purpose |
|-------|---------|
| `/discover` | Discovery hub |
| `/discover/courses` | Course catalog (role-aware: tabs per role, pill filters in All tab) |
| `/discover/course/[slug]` | Course detail (role-aware: universal tabs + role-specific tabs) |
| `/discover/course/[slug]/[tab]` | Bookmarkable tab sub-route (catch-all; validates tab, redirects invalid) |
| `/discover/teachers` | ~~Teacher directory~~ → 301 redirect to `/discover/members?roles=teacher` |
| `/discover/creators` | ~~Creator directory~~ → 301 redirect to `/discover/members?roles=creator` |
| `/discover/students` | ~~Student directory~~ → 301 redirect to `/discover/members?roles=student` |
| `/discover/communities` | Community catalog (role-aware: tabs per role, pill filters in All tab) |
| `/discover/community/[slug]` | Community detail (role-aware: universal tabs + role-specific tabs) |
| `/discover/community/[slug]/[tab]` | Bookmarkable tab sub-route (catch-all; validates tab, redirects invalid) |
| `/discover/feeds` | Feed discovery — active public feeds with CTAs to parent entities (visitor-accessible) |
| `/discover/members` | Unified member directory (public — server-side search, multi-role filter, admin extras inline) |
| `/discover/leaderboard` | Leaderboard |

### 3. Resource Routes (Public Detail Pages)

Individual resource pages using **singular** nouns. Adapt based on viewer's relationship.

| Route | Purpose | Adapts How |
|-------|---------|------------|
| `/community/[slug]` | Community page (= its feed) | Member: post / Not: join |
| `/course/[slug]` | Course detail | Enrolled: Learn tab / Not enrolled: About tab |
| `/course/[slug]/learn` | Course detail (Learn tab) | Enrolled only (accordion modules + progress) |
| `/course/[slug]/feed` | Course feed (discussion) | Enrolled only |
| `/course/[slug]/book` | Book teacher session | Enrolled only |
| `/course/[slug]/sessions` | Sessions for this course | Enrolled (student tab) / Certified teacher (teaching-sessions extra tab, Conv 165 [CRT-3]) / Creator + Admin + Moderator (All Sessions extra tabs, Conv 166 [CRT-4]) |
| `/course/[slug]/teaching-sessions` | Course page with TEACHER tab pre-selected (dynamic `[tab].astro`) | Certified teacher of the course (else redirects to `/course/[slug]`) |
| `/course/[slug]/creator-sessions` | Course page with CREATOR tab pre-selected (dynamic `[tab].astro`) | Creator of the course (else redirects to `/course/[slug]`) |
| `/course/[slug]/admin-sessions` | Course page with ADMIN tab pre-selected (dynamic `[tab].astro`) | Admin (else redirects to `/course/[slug]`) |
| `/course/[slug]/moderator-sessions` | Course page with MODERATOR tab pre-selected (dynamic `[tab].astro`) | Moderator of the course's community (else redirects to `/course/[slug]`) |
| `/course/[slug]/teachers` | Teachers for this course | Public (view) / Enrolled (book assigned teacher) |
| `/course/[slug]/resources` | Course materials & downloads | Public (preview) / Enrolled OR Creator/Admin/Moderator (all — `canSeeAllResources`, Conv 166 [CRT-5]) |
| `/creator/[handle]` | Creator profile | Shows courses, portfolio |
| `/teacher/[handle]` | Teacher profile | Shows teaching stats, availability |
| `/@[handle]` | Universal profile | Role-adaptive unified view |
| `/@me` | Shortcut | Redirects to `/@{myHandle}` |
| `/verify/[id]` | Certificate verification | Public |
| `/session/[id]` | Live session room | Participants only |

**Profile URL patterns:**

| Route | Purpose | Use Case |
|-------|---------|----------|
| `/@handle` | Universal shareable profile | Social sharing, business cards |
| `/creator/[handle]` | Creator-specific view | Creator portfolio, course listings |
| `/teacher/[handle]` | Teacher-specific view | Teaching stats, booking |

**Teacher discovery paths:**

| Route | Scope | Shows |
|-------|-------|-------|
| `/course/[slug]/teachers` | Course | Teachers certified for this course (tab on course page) |
| `/discover/members?roles=teacher` | Site-wide | All teachers on platform (unified member directory) |
| `/learning` | Personal | Recent teachers on student dashboard |

### 4. Settings Routes

Account configuration. Inherently personal, no prefix needed.

| Route | Purpose |
|-------|---------|
| `/settings` | Settings hub |
| `/settings/profile` | Edit profile |
| `/settings/notifications` | Notification preferences |
| `/settings/payments` | Payment & payout setup |
| `/settings/security` | Password, 2FA |
| `/settings/interests` | Tag/interest editor (reuses TopicPicker from onboarding) |

### 5. Admin Routes

Platform administration. Role-gated.

| Route | Purpose |
|-------|---------|
| `/admin` | Admin dashboard |
| `/admin/users` | User management |
| `/admin/courses` | Course management |
| `/admin/enrollments` | Enrollment management |
| `/admin/teachers` | Teacher management |
| `/admin/payouts` | Payout management |
| `/admin/sessions` | Session management |
| `/admin/certificates` | Certificate management |
| `/admin/creator-applications` | Creator application management |
| `/admin/topics` | Topic management (formerly Category management) |
| `/admin/analytics` | Platform analytics |
| `/admin/moderation` | Moderation queue |
| `/admin/moderators` | Moderator management |
| `/admin/recordings` | BBB recordings diagnostic (account-wide count + latest 20, Conv 159) |
| `/mod` | Moderator queue (non-admin) |

### 6. Auth Routes

Authentication flows. Public.

| Route | Purpose |
|-------|---------|
| `/login` | Login |
| `/signup` | Sign up |
| `/reset-password` | Password reset |
| `/welcome` | Post-signup welcome |

### 7. Marketing Routes

Public marketing pages.

| Route | Purpose |
|-------|---------|
| `/` | Homepage |
| `/about` | About us |
| `/how-it-works` | How it works |
| `/pricing` | Pricing |
| `/faq` | FAQ |
| `/for-creators` | Creator landing page |
| `/become-a-teacher` | Teacher landing page |
| `/contact` | Contact |
| `/privacy` | Privacy policy |
| `/terms` | Terms of service |
| `/stories` | Success stories |
| `/testimonials` | Testimonials |

### 8. Design System Routes (root) + Legacy (`/old/*`) — Post-flip (Conv 197)

✅ **The flip executed Conv 197** (after the 2026-05-26 demo; see `matt-provenance.md` §8). The `/matt/*`
namespace **dissolved**: Matt's design-system pages are now the **primary app at root**, and the previous
root (legacy) app moved wholesale to **`/old/*`**. **No fallback redirects** — this is not a production
app, so legacy routes Matt hasn't rebuilt simply 404 at root; their copies live at `/old/*` (the `/api/*`
tree did NOT move — it stays at `/api/`).

> ⚠️ **Doc-consistency note:** §§1–7 above were written when the *legacy* app owned the bare routes.
> Post-flip, those descriptions now apply to the **`/old/*`** copies; the bare routes are the
> design-system pages tabled below. A full §§1–7 reconciliation to the post-flip world is tracked
> separately (it's larger than the flip itself). Treat this §8 as the authoritative post-flip map.

Design-system pages are reachable via the Matt shell's own Sidebar / ControlBar / SubNav. The placeholder
pages set `export const noNav = true` to suppress the `route-api-map` scanner's "no discovered nav" warning.

**See:** `docs/as-designed/matt-design-system/` (design spec) · `matt-pre-plan.md` (execution plan) · `matt-provenance.md` (flip record + provenance).

| Route (now root) | Purpose | Data backing |
|-------|---------|--------------|
| `/` | Shell home — exercises every AppLayout slot + primitive showcase | Static (Conv 175) |
| `/courses` | Course index (Matt-native) | `fetchCourseBrowseData` loader (Conv 192) |
| `/course/[slug]/[...tab]` | Course detail; catch-all tabs `about` (default) / `feed` / `modules` / `creator` / `teachers` / `reviews` / `resources`; invalid tab → 302 to base | Real D1 via `courses.ts` + `/api/feeds/course/[slug]` (Convs 188-190) |
| `/teachers` | Peer Teachers directory | `fetchTeacherDirectoryData` loader (Conv 193) |
| `/teachers/[handle]` | Peer Teacher profile — closes the `StudentTeacherAnchor` deep-link; 404 on unknown handle | `fetchTeacherProfileData` loader (Conv 193) |
| `/saved` | Saved / bookmarks | Placeholder empty-state — no loader yet (Conv 193) |
| `/todo` | To-Do | Placeholder — static `ToDoItem` showcase (Conv 193) |
| `/messages` | Messages | Placeholder — static `ChatBubble` thread (Conv 193) |
| `/notifications` | Notifications | Placeholder empty-state — no loader yet (Conv 193) |

Legacy pages now live under `/old/*` (e.g. `/old/dashboard`, `/old/discover`, `/old/admin/*`, `/old/course/[slug]/*`) — 43 top-level entries moved. See the regenerated `route-api-map.md` for the full post-flip route inventory.

---

## Profile URL Resolution

| Input | Resolves To |
|-------|-------------|
| `/@jane` | Jane's unified public profile |
| `/@me` | Redirect → `/@{currentUser.handle}` |
| `/profile` | Redirect → `/@{currentUser.handle}` |
| `/creator/jane` | Jane's creator-specific profile |
| `/teacher/jane` | Jane's teacher-specific profile |
| `/settings/profile` | Profile edit form |

---

---

## Why This Design

### 1. Student-First Default

Most users are students. Their primary view is personal: "my courses, my learning." Bare routes serve this majority use case.

### 2. Discovery is Intentional

Users explicitly navigate to `/discover` to find new content. This matches the learning journey: you enroll first, then learn. Discovery is exploration, not the default.

### 3. Flywheel-Aligned Routes

As users progress through the PeerLoop flywheel (Student → Teacher → Creator), their routes evolve naturally:
- `/learning` → Student phase
- `/teaching` → Teacher phase
- `/creating` → Creator phase

> **Nav simplification (Conv 033):** The AppNavbar no longer has separate menu items for `/learning`, `/teaching`, and `/creating`. The unified `/dashboard` page (Conv 032) is the single nav entry point for all dashboard activity. Role-specific pages remain accessible via direct URL and the DashboardLinks button row on `/dashboard`.

### 4. Activity vs Resource Clarity

Dashboard routes use gerunds (`/teaching`, `/creating`) to communicate "what I'm doing." Public profile routes use nouns (`/teacher/`, `/creator/`) to communicate "who this is." This prevents confusion between viewing someone's profile and accessing your own tools.

### 5. Singular Resources, Plural Collections

Following REST conventions:
- `/course/python-101` - One specific course (singular)
- `/discover/courses` - Many courses to browse (plural)
- `/courses` - My collection of enrolled courses (plural, personal)

### 6. Universal Profile URLs

The `/@handle` pattern:
- Short, memorable, shareable
- Works for all user types (students, teachers, creators)
- Adapts display based on viewer's relationship
- Standard pattern (Twitter/X, Instagram, etc.)

Role-specific routes (`/creator/[handle]`, `/teacher/[handle]`) provide focused views when the context is known.

### 7. Detail Pages Are Canonical

Course detail pages (`/course/[slug]`) are the shareable URL regardless of enrollment status. The page adapts its CTAs based on context. This is the standard e-commerce pattern.

---

## Implementation Notes

### Astro File Structure

**Convention:** Use flat files (`route.astro`) not folders (`route/index.astro`) unless sub-routes are needed.

```
src/pages/
├── community/
│   ├── index.astro               # /community (My Communities hub)
│   └── [slug]/
│       ├── index.astro           # /community/[slug] (Feed tab, default)
│       ├── courses.astro         # /community/[slug]/courses (Courses tab)
│       ├── resources.astro       # /community/[slug]/resources (Resources tab)
│       └── members.astro         # /community/[slug]/members (Members tab)
├── course/
│   └── [slug]/
│       ├── index.astro           # /course/[slug] (detail)
│       ├── learn.astro           # /course/[slug]/learn
│       ├── feed.astro            # /course/[slug]/feed (discussion)
│       ├── book.astro            # /course/[slug]/book
│       ├── sessions.astro        # /course/[slug]/sessions
│       ├── teachers.astro        # /course/[slug]/teachers
│       ├── resources.astro       # /course/[slug]/resources
│       ├── success.astro         # /course/[slug]/success
│       └── [tab].astro           # /course/[slug]/{teaching,creator,admin,moderator}-sessions
│                                 # (dynamic catch-all; whitelist + role-gate; Conv 166 [CRT-DEDICATED-PAGES];
│                                 # static .astro files above take precedence over this dynamic route)
├── creator/
│   └── [handle]/
│       └── index.astro           # /creator/[handle]
├── teacher/
│   └── [handle]/
│       └── index.astro           # /teacher/[handle]
├── discover/
│   ├── index.astro               # /discover (hub)
│   ├── courses.astro             # /discover/courses (role-aware)
│   ├── course/
│   │   └── [slug]/
│   │       ├── index.astro       # /discover/course/[slug] (role-aware detail)
│   │       └── [...tab].astro    # /discover/course/[slug]/[tab] (bookmarkable tabs)
│   ├── teachers.astro            # /discover/teachers (301 → /discover/members?roles=teacher)
│   ├── creators.astro            # /discover/creators (301 → /discover/members?roles=creator)
│   ├── students.astro            # /discover/students (301 → /discover/members?roles=student)
│   ├── communities.astro         # /discover/communities (role-aware)
│   ├── community/
│   │   └── [slug]/
│   │       ├── index.astro       # /discover/community/[slug] (role-aware detail)
│   │       └── [...tab].astro    # /discover/community/[slug]/[tab] (bookmarkable tabs)
│   ├── feeds.astro               # /discover/feeds (feed discovery, visitor-accessible)
│   ├── members.astro             # /discover/members (unified member directory, public)
│   └── leaderboard.astro         # /discover/leaderboard
├── teaching/
│   ├── index.astro               # /teaching
│   ├── students.astro            # /teaching/students
│   ├── sessions.astro            # /teaching/sessions
│   ├── earnings.astro            # /teaching/earnings
│   ├── analytics.astro           # /teaching/analytics
│   ├── availability.astro        # /teaching/availability
│   └── courses/
│       └── [courseId].astro      # /teaching/courses/[courseId]
├── creating/
│   ├── index.astro               # /creating
│   ├── apply.astro               # /creating/apply
│   ├── studio.astro              # /creating/studio
│   ├── communities/
│   │   ├── index.astro           # /creating/communities
│   │   └── [slug].astro          # /creating/communities/[slug]
│   ├── earnings.astro            # /creating/earnings
│   └── analytics.astro           # /creating/analytics
# NOTE (Conv 197 [ROUTE-FLIP]): the `matt/` sandbox DISSOLVED. Its pages are now at
# root (index.astro, courses.astro, course/[slug]/[...tab].astro, teachers.astro,
# teachers/[handle].astro, saved/todo/messages/notifications.astro — see §Route Categories #8).
# The pre-flip legacy entries shown below (dashboard, settings, course/, community/, etc.)
# now live under `old/` (e.g. src/pages/old/dashboard.astro). This tree is NOT yet rewritten
# for the post-flip layout — see route-api-map.md for the authoritative current inventory.
├── dashboard.astro               # /dashboard (unified cross-role dashboard)
├── learning.astro                # /learning
├── learning/
│   └── sessions.astro            # /learning/sessions
├── settings/
│   ├── index.astro               # /settings
│   ├── profile.astro             # /settings/profile
│   ├── notifications.astro       # /settings/notifications
│   ├── payments.astro            # /settings/payments
│   ├── security.astro            # /settings/security
│   └── interests.astro           # /settings/interests (tag editor)
├── @[handle].astro               # /@[handle] (universal profile)
├── courses.astro                 # /courses (my enrolled)
├── messages.astro                # /messages
├── notifications.astro           # /notifications
├── onboarding.astro              # /onboarding (interests & preferences)
├── feed.astro                    # /feed (aggregated timeline)
├── feeds.astro                   # /feeds (feeds hub — directory of all user feeds)
├── profile.astro                 # /profile (redirect to /@me)
├── login.astro                   # /login (modal over AppLayout)
├── signup.astro                  # /signup (modal over AppLayout)
├── reset-password.astro          # /reset-password (standalone form)
└── index.astro                   # / (homepage)
```

### Redirect Handling

#### Implemented Redirects

| Source | Destination | Type | Location |
|--------|-------------|------|----------|
| `/profile` | `/@me` | 301 (permanent) | `src/pages/profile.astro` |
| `/discover/teachers` | `/discover/members?roles=teacher` | 301 (permanent) | `src/pages/discover/teachers.astro` |
| `/discover/creators` | `/discover/members?roles=creator` | 301 (permanent) | `src/pages/discover/creators.astro` |
| `/discover/students` | `/discover/members?roles=student` | 301 (permanent) | `src/pages/discover/students.astro` |
| `/community/the-commons/courses` | `/community/the-commons` | Astro.redirect | System community special case |
| Protected routes (unauthenticated) | `/login?redirect={originalUrl}` | 302 (temporary) | Auth guards in page files + `src/lib/auth/session.ts` |
| `/api/auth/github` | GitHub OAuth URL | 302 (temporary) | OAuth initiation |
| `/api/auth/google` | Google OAuth URL | 302 (temporary) | OAuth initiation |
| OAuth callbacks (success) | `/` | 302 (temporary) | GitHub & Google callbacks |
| OAuth callbacks (error) | `/login?error={msg}` | 302 (temporary) | Error handling |

**Auth-guard pattern** — Pages requiring authentication redirect like:
```typescript
return Astro.redirect('/login?redirect=/course/${slug}/learn');
```
This is used in: `/feed`, `/course/[slug]/learn`, `/course/[slug]/book`, and client-side in Messages, PublicProfile, and EnrollButton components.

**Navigation context (`?via=`)** — Breadcrumbs use `?via=` query params to reflect how the user arrived at a page. The receiving page builds its breadcrumb trail conditionally based on the `via` value.

| `?via=` Value | Used On | Trail |
|---------------|---------|-------|
| `discover-communities` | `/community/[slug]` | Discover > Communities > [Name] |
| `discover-courses` | `/course/[slug]` | Discover > Courses > [Title] |
| `community-courses` | `/course/[slug]` | [Community] > Courses > [Title] (with `&cs=` and `&cn=` params) |
| `discover-feeds` | `/discover/community/[slug]`, `/discover/course/[slug]` | Discover > Feeds > [Name] (from feed discovery CTAs) |

Without `?via=`, pages show route-based defaults (e.g., `My Communities > [Name]`).

**See:** `docs/DECISIONS.md` §5 "Breadcrumb System", `src/components/ui/Breadcrumbs.astro`

**Data-not-found pattern** — Pages redirect when resources are missing:
```
Course not found  → /discover/courses?error=not-found
Community 404     → /404
Community 403     → /discover/communities
Not enrolled      → /course/[slug]?error=not-enrolled
```

---

## Implementation Status

**Last verified:** Session 317 (2026-03-01) — 84 .astro page files

| Category | Implemented | Pending |
|----------|-------------|---------|
| Community (`/community/*`) | 5 routes | — |
| Discovery (`/discover/*`) | 8 routes (all) | — |
| Teaching (`/teaching/*`) | 7 routes | — |
| Creating (`/creating/*`) | 7 routes | — |
| Settings (`/settings/*`) | 6 routes | — |
| Resource (`/course/*`) | 8 routes (7 static + 1 dynamic `[tab].astro` for role-tab catch-all, Conv 166) | — |
| Resource (`/creator/*`) | 1 route | — |
| Resource (`/teacher/*`) | 1 route | — |
| Profile (`/@handle`) | 1 route | — |
| Personal (bare) | 8 routes (`/learning`, `/learning/sessions`, `/feed`, `/courses`, `/messages`, `/notifications`, `/onboarding`, `/profile`) | — |
| Auth | 3 routes (`/login`, `/signup`, `/reset-password`) | 1 (`/welcome`) |
| Marketing/Legal | 12 routes (`/`, `/about`, `/how-it-works`, `/pricing`, `/for-creators`, `/become-a-teacher`, `/contact`, `/privacy`, `/terms`, `/cookies`, `/stories`, `/testimonials`) | — |
| Support | 2 routes (`/faq`, `/help`) | — |
| Browse | 2 routes (`/creators`, `/teachers`) | — |
| Blog/Company | 2 routes (`/blog`, `/careers`) | — |
| Admin (`/admin/*`) | 14 routes | — |
| Matt re-skin (`/matt/*`) — **transient** | 9 route files built (`/matt/`, `courses`, `course/[slug]/[...tab]`, `teachers`, `teachers/[handle]`, `saved`, `todo`, `messages`, `notifications`; Convs 175-193) of ~13 mapped (`matt-pre-plan.md` §2) | Rolls forward to remaining Phase 5 pages (MMP-PH5); becomes `/` at MATT-CUTOVER [ROUTE-FLIP] — see `matt-provenance.md` |
| Other | 3 routes (`/404`, `/verify/[id]`, `/session/[id]`) | — |

*Note: Marketing/Legal/Support/Browse/Blog pages are "Coming Soon" placeholders (Session 317, BROKENLINKS block).*
*Note: `/matt/*` is a transient coexistence namespace, not part of the permanent route count — see § Route Categories #8.*

---

## References

- Session 169 (2026-02-03): Initial "bare = my" convention
- Session 173 (2026-02-03): Discover panel routes
- Session 175 (2026-02-03): Singular resource routes convention
- Session 177 (2026-02-04): Activity vs resource namespaces
- Session 181 (2026-02-04): Community & Feed Architecture (1:1 community:feed, tags not feeds)
- Session 184 (2026-02-04): Removed `/course/[slug]/discuss` (superseded by `/feed`)
- Session 186 (2026-02-04): Community subroutes for URL-aware tabs (feed/courses/resources/members)
- Session 189 (2026-02-05): Removed `/teachers` and `/certificates` routes (both covered by `/learning` dashboard); Added `/feed` aggregated timeline with FeedSlidePanel "Home Feed" entry
- Session 192 (2026-02-05): Updated Implementation Status (Discovery now 7/7, Personal bare now 6/6); Documented actual redirect behavior vs aspirational migration redirects; Added Auth/Marketing/Admin/Other pending counts
- Session 317 (2026-03-01): BROKENLINKS block — 20 new pages (404, verify/[id], 17 placeholders), 42 stale `/dashboard/*` routes fixed, page count 65→84; All marketing/legal/support pages now have placeholder implementations
- Session 379 (2026-03-12): COURSE-PAGE-MERGE — `/course/[slug]/learn` merged into course detail page as Learn tab (accordion modules); Curriculum tab removed; enrolled students default to Learn tab; Teachers tab: assigned-teacher booking gating
- Conv 165 (2026-05-20) [CRT-3]: TEACHER role-tab group added to `/course/[slug]/sessions` (extra tab `teaching-sessions`, served by `TeacherSessionsTabContent`, `?scope=teacher`)
- Conv 166 (2026-05-20) [CRT-4]: CREATOR + ADMIN + MODERATOR role-tab groups added on `/course/[slug]/sessions` (extra tabs `creator-sessions`, `admin-sessions`, `moderator-sessions`, served by shared `AllSessionsTabContent`, `?scope=all`)
- Conv 166 (2026-05-20) [CRT-5]: All 4 role flags propagated to every course-tab page (`index`, `feed`, `learn`, `resources`, `sessions`, `teachers`) — previously only `sessions.astro` had `isTeacherOfCourse`; `ResourcesTabContent` access expanded via `canSeeAllResources`
- Conv 166 (2026-05-20) [CRT-DEDICATED-PAGES]: Dynamic `src/pages/course/[slug]/[tab].astro` catch-all serves the 4 role-tab URLs on manual refresh / shared bookmark; whitelist gates to the matching role flag (unknown tab → /404, lacks role → /course/[slug] preserving `Astro.url.search`); Astro static-route precedence verified empirically
- Conv 033 (2026-03-26): Removed `/learning`, `/teaching`, `/creating` from AppNavbar menu items. `/dashboard` is now the single nav entry point. Role-specific pages remain accessible via direct URL and DashboardLinks.
- Conv 111 (2026-04-13): Consolidated `/discover/teachers`, `/discover/creators`, `/discover/students` into unified `/discover/members`. Old routes now 301-redirect. Member directory opened to all users (was admin-only). DiscoverSlidePanel: 3 links → 1 "Members" link.
- Related: `docs/DECISIONS.md` (authoritative decisions)
- Related: `docs/as-designed/orig-pages-map.md` (original page inventory, pre-Twitter UI)
- Related: `docs/requirements/rfc/CD-036/` (Communities, Progressions & Feeds)
- Related: Navigation components (`AppNavbar`, `DiscoverSlidePanel`)

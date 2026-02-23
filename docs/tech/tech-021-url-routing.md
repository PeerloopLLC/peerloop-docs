# tech-021-url-routing.md

## URL Routing Architecture

**Decision Date:** 2026-02-03 (Session 169)
**Last Updated:** 2026-02-05 (Sessions 173, 175, 177, 181, 184, 186, 189, 192)
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
| `/creating/*` | Activity | Creator's dashboard & tools | `/creating`, `/creating/studio`, `/creating/earnings` |
| `/teaching/*` | Activity | Teacher's dashboard & tools | `/teaching`, `/teaching/earnings`, `/teaching/students` |
| `/learning/*` | Activity | Student's dashboard & tools | `/learning` |
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
| `/discover/communities` | Find communities to join | Public |

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

**Note:** Creator feeds (`/creator/[handle]/feed`) were removed in Session 183. Creators should create communities for announcements.

### Hub Page Pattern

The `/community` page mirrors the My Communities SlideOut Panel, just as `/discover` mirrors the Discovery SlideOut Panel:

```
/community                  /discover
├── The Commons             ├── Courses
├── ─────────────           ├── Teachers
└── [Joined communities]    ├── Creators
                            ├── Communities
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
| `/learning` | Student dashboard |
| `/teaching` | S-T dashboard |
| `/teaching/students` | My students |
| `/teaching/sessions` | My sessions |
| `/teaching/earnings` | My earnings |
| `/teaching/analytics` | My teaching stats |
| `/creating` | Creator dashboard |
| `/creating/apply` | Creator application form |
| `/creating/studio` | Course builder |
| `/creating/analytics` | Course stats |
| `/profile` | Redirects to `/@{myHandle}` |
| `/onboarding` | Interests & Preferences (ONBD) |

### 2. Discovery Routes (`/discover/`) — Public or Auth

Site-wide browsing and exploration.

| Route | Purpose |
|-------|---------|
| `/discover` | Discovery hub |
| `/discover/courses` | Course catalog |
| `/discover/teachers` | S-T directory |
| `/discover/creators` | Creator directory |
| `/discover/students` | Student directory |
| `/discover/communities` | Find communities to join |
| `/discover/leaderboard` | Leaderboard |

### 3. Resource Routes (Public Detail Pages)

Individual resource pages using **singular** nouns. Adapt based on viewer's relationship.

| Route | Purpose | Adapts How |
|-------|---------|------------|
| `/community/[slug]` | Community page (= its feed) | Member: post / Not: join |
| `/course/[slug]` | Course detail | Enrolled: "Continue" / Not: "Enroll" |
| `/course/[slug]/learn` | Course content | Enrolled only |
| `/course/[slug]/feed` | Course feed (discussion) | Enrolled only |
| `/course/[slug]/book` | Book S-T session | Enrolled only |
| `/course/[slug]/teachers` | S-Ts for this course | Public (view) / Enrolled (book) |
| `/course/[slug]/resources` | Course materials & downloads | Public (preview) / Enrolled (all) |
| `/creator/[handle]` | Creator profile | Shows courses, portfolio |
| `/teacher/[handle]` | S-T profile | Shows teaching stats, availability |
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

**S-T discovery paths:**

| Route | Scope | Shows |
|-------|-------|-------|
| `/course/[slug]/teachers` | Course | S-Ts certified for this course (tab on course page) |
| `/discover/teachers` | Site-wide | All S-Ts on platform |
| `/learning` | Personal | Recent S-Ts on student dashboard |

### 4. Settings Routes

Account configuration. Inherently personal, no prefix needed.

| Route | Purpose |
|-------|---------|
| `/settings` | Settings hub |
| `/settings/profile` | Edit profile |
| `/settings/notifications` | Notification preferences |
| `/settings/payments` | Payment & payout setup |
| `/settings/security` | Password, 2FA |

### 5. Admin Routes

Platform administration. Role-gated.

| Route | Purpose |
|-------|---------|
| `/admin` | Admin dashboard |
| `/admin/users` | User management |
| `/admin/courses` | Course management |
| `/admin/enrollments` | Enrollment management |
| `/admin/student-teachers` | S-T management |
| `/admin/payouts` | Payout management |
| `/admin/sessions` | Session management |
| `/admin/certificates` | Certificate management |
| `/admin/creator-applications` | Creator application management |
| `/admin/categories` | Category management |
| `/admin/analytics` | Platform analytics |
| `/admin/moderation` | Moderation queue |
| `/admin/moderators` | Moderator management |
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
| `/become-a-teacher` | S-T landing page |
| `/contact` | Contact |
| `/privacy` | Privacy policy |
| `/terms` | Terms of service |
| `/stories` | Success stories |
| `/testimonials` | Testimonials |

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

As users progress through the PeerLoop flywheel (Student → S-T → Creator), their routes evolve naturally:
- `/learning` → Student phase
- `/teaching` → S-T phase
- `/creating` → Creator phase

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
- Works for all user types (students, S-Ts, creators)
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
│       ├── teachers.astro        # /course/[slug]/teachers
│       ├── resources.astro       # /course/[slug]/resources
│       └── success.astro         # /course/[slug]/success
├── creator/
│   └── [handle]/
│       └── index.astro           # /creator/[handle]
├── teacher/
│   └── [handle]/
│       └── index.astro           # /teacher/[handle]
├── discover/
│   ├── index.astro               # /discover (hub)
│   ├── courses.astro             # /discover/courses
│   ├── teachers.astro            # /discover/teachers
│   ├── creators.astro            # /discover/creators
│   ├── students.astro            # /discover/students
│   ├── communities.astro         # /discover/communities
│   └── leaderboard.astro         # /discover/leaderboard
├── teaching/
│   ├── index.astro               # /teaching
│   ├── students.astro            # /teaching/students
│   ├── sessions.astro            # /teaching/sessions
│   ├── earnings.astro            # /teaching/earnings
│   ├── analytics.astro           # /teaching/analytics
│   └── availability.astro        # /teaching/availability
├── creating/
│   ├── index.astro               # /creating
│   ├── apply.astro               # /creating/apply
│   ├── studio.astro              # /creating/studio
│   ├── earnings.astro            # /creating/earnings
│   └── analytics.astro           # /creating/analytics
├── learning.astro                # /learning
├── settings/
│   ├── index.astro               # /settings
│   ├── profile.astro             # /settings/profile
│   ├── notifications.astro       # /settings/notifications
│   ├── payments.astro            # /settings/payments
│   └── security.astro            # /settings/security
├── @[handle].astro               # /@[handle] (universal profile)
├── courses.astro                 # /courses (my enrolled)
├── messages.astro                # /messages
├── notifications.astro           # /notifications
├── onboarding.astro              # /onboarding (interests & preferences)
├── feed.astro                    # /feed (aggregated)
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

Without `?via=`, pages show route-based defaults (e.g., `My Communities > [Name]`).

**See:** `DECISIONS.md` §5 "Breadcrumb System", `src/components/ui/Breadcrumbs.astro`

**Data-not-found pattern** — Pages redirect when resources are missing:
```
Course not found  → /discover/courses?error=not-found
Community 404     → /404
Community 403     → /discover/communities
Not enrolled      → /course/[slug]?error=not-enrolled
```

---

## Implementation Status

**Last verified:** Session 192 (2026-02-05)

| Category | Implemented | Pending |
|----------|-------------|---------|
| Community (`/community/*`) | 5 routes | — |
| Discovery (`/discover/*`) | 7 routes (all) | — |
| Teaching (`/teaching/*`) | 6 routes | — |
| Creating (`/creating/*`) | 5 routes | — |
| Settings (`/settings/*`) | 5 routes | — |
| Resource (`/course/*`) | 7 routes (all) | — |
| Resource (`/creator/*`) | 1 route | — |
| Resource (`/teacher/*`) | 1 route | — |
| Profile (`/@handle`) | 1 route | — |
| Personal (bare) | 7 routes (`/learning`, `/feed`, `/courses`, `/messages`, `/notifications`, `/onboarding`, `/profile`) | — |
| Auth | 3 routes (`/login`, `/signup`, `/reset-password`) | 1 (`/welcome`) |
| Marketing | 1 route (`/`) | 11 (about, pricing, faq, etc.) |
| Admin (`/admin/*`) | 0 page routes (API only) | 13 routes |
| Other | — | `/verify/[id]`, `/session/[id]` |

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
- Related: `DECISIONS.md` (authoritative decisions)
- Related: `ORIG-PAGES-MAP.md` (original page inventory, pre-Twitter UI)
- Related: `RFC/CD-036/` (Communities, Progressions & Feeds)
- Related: Navigation components (`AppNavbar`, `DiscoverSlidePanel`)

# url-routing.md

## URL Routing Architecture

**Decision Date:** 2026-02-03 (Session 169)
**Last Updated:** 2026-06-07 (Conv 245 [NOTIF-PORT + MSG-PORT]: rebuilt root `/notifications` + `/messages` — `@matt-inspired` ports of `/old/notifications` + `/old/messages` into the Matt shell, reviving the two routes deleted Conv 203. `/notifications` = `NotificationCenter` island on `GET /api/me/notifications` (per-type icon tint kept as honest-orphan). `/messages` = 5 islands under `src/components/messages/matt/` delegating to canonical `UserIcon`/`Modal`/`SearchInput`, on `/api/conversations` + `/api/me/messages` + `/api/users/search`; Sidebar gained a "Messages" NavItem (`message` MattIcon). §8 live-built table + Deleted-Conv-203 table + status banner + file tree + route-count summary updated. Legacy `/old` sources untouched. No new API endpoints.)
**Previously:** 2026-06-03 (Conv 238 [FEED-DETAIL]: new root `/feed` — `@matt-inspired` single-page port of `/old/feed` into the Matt shell (prop-less `SmartFeed` island; NOT a `[...tab]` family — a personal smart feed has no multi-tab sub-structure). Root file was missing post-route-flip (~7 dead `/feed` links 404'd) until this conv. Sidebar gained "My Feed"→/feed after Home (new `sparkles` MattIcon). §8 root-routes table row added; route maps regenerated. Adjacent link-honesty fixes: `discover.ts`/`enrichment.ts` ctaUrls + `DiscoverSlidePanel` hrefs repointed `/discover/{community,course,feeds}` → root.)
**Previously:** 2026-06-03 (Conv 237 [COMM-DETAIL]: `/community/[slug]` ported from `/old/community/[slug]/*` to a root `[...tab].astro` family (3rd such family after `/course` + `/profile`). Decision B made the bare URL an About/Overview default (legacy never had one); the Feed moved to `/community/[slug]/feed`; legacy decorative `?tag=` filter chips dropped (`[COMM-TAG-FILTER]`). Community Routes table, Feed Hierarchy, adapts-how table, and §8 Implementation Status updated.)
**Previously:** 2026-06-01 (Conv 233 [SUCCESS-ROUTE]: new addressable `/course/[slug]/success` (`@matt-source 579:16885`) — Stripe `success_url` target restored (root file was missing post-route-flip → 404'd); named file beats the `[...tab]` catch-all; preserves enrollment self-heal + ExpectationsForm. `cancel_url` → `/course/[slug]?enroll=cancelled` (transient toast). §8 root-routes + adapts-how tables updated. Conv 232 [PRECHECKOUT]: addressable `/course/[slug]/precheckout` standalone page + new `benefits` SubNav tab; both host one shared `PrecheckoutContent` body; reverses the Conv 187 non-addressable classification.)
**Previously:** 2026-05-29 (Conv 216 [VISITOR-SURFACE]: added public root `/visitor` — overlay-free logged-out account surface symmetric to `/profile` (Log-in/Sign-up links + shared `<ThemeToggle>`; authed → `/profile`); Sidebar visitor chip rewired `/login` → `/visitor`; §8 forward-migrated table + file tree updated.)
**Previously:** 2026-05-28 (Conv 212 [STANDIN-MATT]: `/profile` retrofitted from a single `@stand-in` stub into the `@matt-inspired` `/profile/[...tab]` catch-all account hub — 6-tab SubNav (Account / Edit Profile / Interests / Payments / Notifications / Security), `/settings/*` islands reused, invalid tab → base redirect; middleware moved `/profile` `PROTECTED_EXACT` → `PROTECTED_PREFIXES` so all sub-tabs are protected; §8 root-routes table + file tree updated. Last `@stand-in` page closed.)
**Previously:** 2026-05-27 (Conv 203 [ROUTE-MIGRATION + RTMIG-4 pilot]: deleted 6 Matt-placeholder root routes — `/saved`, `/todo`, `/teachers`, `/messages`, `/notifications`, `/earnings` — so links 404 honestly until rebuilt; Home (`/`) rebuilt from the `/old` dashboard in the Matt shell (RTMIG-4 pilot, approach A); added `/dev/*` design sandbox (`/dev/primitives`, `/dev/saved`, `/dev/todo`); removed Peer Teachers + Earnings from Sidebar; §8 + file tree + Implementation Status updated. Prior, Conv 201: 5 routes forward-migrated from `/old/*` to root — `/login`, `/signup`, `/onboarding`, `/earnings`, `/profile`; `AuthModalRenderer` mounted in `AppLayout`; post-login redirect `/dashboard`→`/`.)
**Previously:** 2026-05-26 (Conv 198 [URLDOC-RECONCILE]: post-flip reconciliation. §§1–7 are retained as the **canonical URL architecture** — the bare-route grammar Matt's root app inherits — with a status banner at § Route Categories noting which routes are built at root vs. currently served under `/old/*`. The file-structure tree was rewritten for the post-flip layout. § Route Categories #8 (Conv 197) remains the authoritative root/legacy split. See `matt-provenance.md` §8.)
**Previously:** 2026-05-26 (Conv 197 [ROUTE-FLIP]: the `/matt/*` namespace dissolved — design-system pages promoted to root, legacy app moved to `/old/*`. § Route Categories #8 rewritten for the post-flip state.)
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
    ├── Community Feed (1) ← /community/[slug]/feed (Conv 237: moved off bare URL; bare = About)
    └── Courses (many)
        └── Course Feed (1) ← /course/[slug]/feed
```

**Key Rules:**
- **1:1 Community:Feed** — Each community has exactly one feed; reachable at `/community/[slug]/feed` (bare `/community/[slug]` is the About overview as of Conv 237 — the feed is one tab among About/Feed/Courses/Resources/Members)
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
| `/community` | My Communities hub (legacy `/old/community`; root `/community` is `PROTECTED_EXACT` honest-404 placeholder) | Optional |
| `/community/[slug]` | Community About/Overview tab (default) — **built at root Conv 237** | Optional |
| `/community/[slug]/feed` | Community Feed tab (the townhall for The Commons) | Optional |
| `/community/[slug]/courses` | Community Courses tab (dropped for `isSystem` communities) | Optional |
| `/community/[slug]/resources` | Community Resources tab | Optional |
| `/community/[slug]/members` | Community Members tab | Optional |
| `/discover/communities` | Community catalog (role-aware: tabs per role, pill filters in All tab) | Public |

**Note (Conv 237 [COMM-DETAIL]):** `/community/[slug]` was ported from `/old/community/[slug]/*` to a root `[...tab].astro` family mirroring `/course/[slug]` and `/profile` (the standardized `[...tab].astro` + `_*-tabs.ts` + `SubNav` triad — now a 3-family pattern). Decision B made the bare URL an **About/Overview** default (legacy never had one); the feed moved to `/community/[slug]/feed`. The legacy `?tag=help` filter chips were decorative (never consumed) and dropped — real tag filtering tracked as `[COMM-TAG-FILTER]`.

**Note:** The Commons (`isSystem: true`) redirects `/community/the-commons/courses` to `/community/the-commons` since system communities don't have courses; `/community/the-commons/feed` is the TownHallFeed (`/api/feeds/townhall` is hardwired to `the-commons`).

**The Commons special case:**
- Slug: `the-commons` (or `peerloop`)
- Auto-subscribed for all users (including visitors)
- Tags for categorization: `general`, `announcements`, `help`

### Feed Routes

| Route | Purpose | Auth |
|-------|---------|------|
| `/course/[slug]/feed` | Course feed (tabbed UI) | Enrolled |
| `/feed` | Aggregated personalized feed | Required |
| `/feeds` | Feeds discover destination — discovery grid + role-aware "Your Feeds" directory (Matt sibling of /communities, /members; Conv 224) | Public |
| `/discover/feeds` | Feed discovery — active public feeds with CTAs to parent entities | Public |

**Note:** Creator feeds (`/creator/[handle]/feed`) were removed in Session 183. Creators should create communities for announcements.

**Note (updated Conv 224):** `/feeds` is now the **public Matt discover destination** — it folds the old `/discover/feeds` discovery grid together with a role-aware "Your Feeds" directory, mirroring `/communities` + `/members`. It was removed from `PROTECTED_EXACT` (auth-optional; the "Your Feeds" section is server-gated inside the page). The legacy auth-required FeedsHub composite is unmounted and destined for the `/` landing page (`[HOME-FEEDSHUB]`); legacy `/old/feeds` + `/old/discover/feeds` still self-guard. (Original split was a Conv 044 decision; superseded here.)

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

> 🧭 **Post-flip status (Conv 197 [ROUTE-FLIP]; root set extended Conv 201 [ROUTE-MIGRATION]).** Categories
> 1–7 below describe the **canonical URL architecture** — the bare-route grammar the app is built around,
> independent of which app layer currently serves each route. After the flip, the **root namespace** is owned
> by Matt's design system, which has so far rebuilt the pages listed in **§8** (`/` — rebuilt as the real
> dashboard Conv 203, `/courses`, `/course/[slug]/[...tab]`) plus the
> **forward-migrated auth + nav-skeleton routes** added Conv 201 (`/login`, `/signup`, `/onboarding`,
> `/profile`). The 6 Matt placeholder routes (`/saved`, `/todo`, `/teachers`, `/messages`, `/notifications`,
> `/earnings`) were **deleted Conv 203** — those links 404 by design until each is rebuilt (RTMIG-4);
> `/messages` + `/notifications` have since been rebuilt as real `@matt-inspired` root pages (Conv 245),
> leaving `/saved`, `/todo`, `/teachers`, `/earnings` still 404.
> **Every other route in §§1–7 currently resolves under
> `/old/*`** (e.g. `/dashboard` → `/old/dashboard`, `/admin/users` → `/old/admin/users`) until Matt's system
> rolls it forward to root (tracked as MMP-PH5 / RTMIG-4 et al.); at that point the route returns to its bare
> form here with no change to its design. The `/api/*` tree never moved.
> For the authoritative *current* inventory of what physically resolves where, see `route-api-map.md`; this
> section is the design reference, not the live build state.

### 1. Personal Routes (Bare) — Requires Auth

Default context for logged-in users. "My stuff."

| Route | Purpose |
|-------|---------|
| `/community` | My Communities hub (The Commons + joined) |
| `/courses` | My enrolled courses *(grammar only — the live root `/courses` diverged Conv 204: it is now a **public** browse gateway, see §8)* |
| `/messages` | My messages |
| `/notifications` | My notifications |
| `/feed` | My personalized feed |
| `/feeds` | Feeds discover destination — discovery grid + role-aware "Your Feeds" directory (Conv 224) |
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
| `/community/[slug]` | Community About/Overview (default tab; feed at `/community/[slug]/feed`) | Member: post in Feed / Not: join |
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
| `/course/[slug]/success` | Post-checkout enrollment confirmation (`@matt-source 579:16885`); Stripe `success_url` target — congrats card + Schedule-first-session card (real curriculum) + CourseHeader Enrolled hero. Preserves enrollment self-heal + ExpectationsForm. Named file beats `[...tab]` catch-all (Conv 233 [SUCCESS-ROUTE]; root file was missing post-route-flip → 404'd until this conv) | Real D1 via `courses.ts` (self-heals enrollment from `session_id`) |
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

> ⚠️ **Doc-consistency note:** §§1–7 above are the **canonical URL design** (see the status banner at the
> top of § Route Categories). The routes Matt's root app has *not yet* rebuilt currently resolve under
> **`/old/*`**; the bare routes Matt *has* built are tabled below. Treat this §8 + the status banner as the
> authoritative post-flip root/legacy split, and `route-api-map.md` as the live inventory.

Design-system pages are reachable via the Matt shell's own Sidebar / ControlBar / SubNav. The placeholder
pages set `export const noNav = true` to suppress the `route-api-map` scanner's "no discovered nav" warning.

**See:** `docs/as-designed/matt-design-system/` (design spec) · `matt-pre-plan.md` (execution plan) · `matt-provenance.md` (flip record + provenance).

| Route (now root) | Purpose | Data backing |
|-------|---------|--------------|
| `/` | Home dashboard — rebuilt from the `/old` dashboard in the Matt shell (RTMIG-4 pilot, approach A); header + onboarding nudge + 2 `ActionCard`s + Recent-Activity `EmptyState` + auth-reveal script | `GET /api/me/full` + `/api/me/version` (Conv 203; was static shell-preview through Conv 175-201) |
| `/courses` | **Public** course-browse gateway (Matt-native) — role tabs + level/topic/text filters over the full catalog; diverged from the bare-route "my enrolled courses" grammar (§1) when made public Conv 204 (removed from middleware `PROTECTED_EXACT`); islands `CoursesRoleTabs` / `CoursesCatalog` / `CoursesFilters` (DISC-DROP, supersedes /discover course catalog) | `fetchCourseBrowseData` loader (Conv 192; `primary_topic_id` fix Conv 204) |
| `/course/[slug]/[...tab]` | Course detail; catch-all tabs `about` (default) / `benefits` / `feed` / `modules` / `creator` / `teachers` / `reviews` / `resources`; invalid tab → 302 to base. `benefits` (Conv 232 [PRECHECKOUT]) hosts the shared `PrecheckoutContent` body in-shell (showHero=false) | Real D1 via `courses.ts` + `/api/feeds/course/[slug]` (Convs 188-190) |
| `/course/[slug]/precheckout` | Standalone purchase-pitch page (`@matt-source 558:15067`); same shared `PrecheckoutContent` body as the `benefits` tab but in its own breadcrumb/back chrome (showHero=true, no SubNav); CTA → Stripe. Sibling `precheckout.astro` takes Astro route precedence over the `[...tab]` catch-all (Conv 232 [PRECHECKOUT]) | Real D1 via `courses.ts` |
| `/course/[slug]/success` | Stripe Checkout `success_url` target (`@matt-source 579:16885`) — post-checkout enrollment confirmation; congrats card + Schedule-first-session (real curriculum) + CourseHeader Enrolled hero; preserves enrollment self-heal + ExpectationsForm. Sibling `success.astro` beats the `[...tab]` catch-all. Root file was missing post-route-flip (`success` ∉ VALID_TABS → 302-bounced) until this conv (Conv 233 [SUCCESS-ROUTE]). `cancel_url` → `/course/[slug]?enroll=cancelled` (transient toast via `CheckoutCancelToast`, no page) | Real D1 via `courses.ts` |
| `/feed` | Aggregated personalized "My Feed" (`@matt-inspired`) — single-page port of `/old/feed` into the Matt shell (AppLayout + SectionTitle + breadcrumb + OnboardingNudgeBanner + prop-less `SmartFeed` island, `max-w-2xl`, `noNav`). Root file was missing post-route-flip (~7 dead `/feed` links 404'd) until this conv (Conv 238 [FEED-DETAIL]). Single-page port, not a `[...tab]` family — a personal smart feed has no multi-tab sub-structure. Sidebar gained "My Feed"→/feed after Home (new `sparkles` MattIcon). `PROTECTED_EXACT` guard already existed; page also `getSession`-redirects | `SmartFeed` island (existing) |
| `/notifications` | My notifications (`@matt-inspired`) — root port of `/old/notifications` into the Matt shell (`NotificationCenter` island). Rebuilds the route deleted Conv 203 with real backing. Per-type notification icon tint kept as honest-orphan (default Tailwind palette, 18 types) while shell/card/pills/typography use Matt tokens — type colour-coding is meaningful content, not re-skinned away. Legacy `NotificationsList` untouched (Conv 245 [NOTIF-PORT]) | `GET /api/me/notifications` |
| `/messages` | My messages (`@matt-inspired`) — root port of `/old/messages` into the Matt shell; 5 islands under `src/components/messages/matt/` (Avatar, ConversationList, MessageThread, NewConversationModal, MessagesCenter) that delegate to canonical `UserIcon`/`Modal`/`SearchInput` + shared `../types` helpers (no duplication). Rebuilds the route deleted Conv 203 with real backing. Legacy islands untouched. Sidebar gained a "Messages" NavItem (`message` MattIcon, expanded + collapsed) (Conv 245 [MSG-PORT]) | `GET /api/conversations`, `/api/me/messages`, `/api/users/search` |

**Deleted Conv 203 (Matt placeholders → 404 by design).** These root pages were demo/placeholder chrome (Conv
193) with no real backing; their links now 404 honestly until each is rebuilt per-page (RTMIG-4). Dangling
links from other pages are accepted by design (the "unbuilt routes 404" honesty signal — see memory
`project_route_404_honesty_standin.md`):

| Route (deleted) | Was | 
|-------|---------|
| `/teachers` | Peer Teachers directory (placeholder, Conv 193) |
| `/saved` | Saved / bookmarks (placeholder empty-state) |
| `/todo` | To-Do (static `ToDoItem` showcase) |
| `/earnings` | Earnings (Conv 201 honest-stub; deleted Conv 203) |

*(`/messages` and `/notifications`, deleted Conv 203, were **rebuilt as real `@matt-inspired` root pages Conv 245** — see the live-built table above.)*

**Dev sandbox (`/dev/*`, Conv 203).** Off the canonical app — not in §§1–7. Holds the archived primitives
showcase that used to live at `/`, plus dev-scoped mirrors of placeholder pages. Self-contained dev subnav
(Overview / Saved / To-Do).

| Route | Purpose |
|-------|---------|
| `/dev/primitives` | Primitives/components showcase (archived from `/` Conv 203) |
| `/dev/saved` | Dev mirror of Saved — uses the extracted `EmptyState` primitive |
| `/dev/todo` | Dev mirror of To-Do |

**Forward-migrated to root (Conv 201 [ROUTE-MIGRATION]).** Promoted from `/old/*` as the minimum to make the
new root app usable (auth loop + main-nav skeleton) ahead of the per-page `/old/*` → root conversion (RTMIG-4).
Reuse existing components on the new `AppLayout`; Matt restyle deferred.

| Route (now root) | Purpose | Data backing | Auth |
|-------|---------|--------------|------|
| `/login` | Login (reuses `AutoOpenAuthModal`; authed → `/`) | Static; `AuthModalRenderer` now mounted globally in `AppLayout` | Public |
| `/signup` | Sign up (same, `mode=signup`) | Static | Public |
| `/onboarding` | Interests & Preferences (reuses `OnboardingProfile`) | `/api/me/onboarding-profile`, `/api/tags` | Required (PROTECTED_EXACT) |
| `/profile/[...tab]` | Account hub — catch-all 6-tab SubNav (Account / Edit Profile / Interests / Payments / Notifications / Security); `/settings/*` islands reused; invalid tab → redirect to base (Conv 212, `@matt-inspired`) | `POST /api/auth/logout` → `/` + per-tab settings-island APIs | Required (PROTECTED_PREFIXES — guards all sub-tabs) |
| `/visitor` | Logged-out account surface — overlay-free `@matt-inspired` page symmetric to `/profile`: lists Log-in/Sign-up as links to the standalone auth pages + a shared `<ThemeToggle>`; authed visitors bounce to `/profile`. Sidebar visitor chip points here (Conv 216) | Static; `ThemeToggle` localStorage `theme` | Public (authed → `/profile`) |

*(`/earnings`, also forward-migrated Conv 201, was deleted Conv 203 as a Matt placeholder — see the Deleted table in §8.)*

**Notes (Conv 201):**
- `AuthModalRenderer` is now mounted once in `AppLayout` (was only in legacy `AppNavbar` → dead in the new shell). Restores app-wide inline `openLoginModal()`.
- Post-login default redirect changed `/dashboard` → `/` in `src/lib/auth-modal.ts` (legacy `/dashboard` no longer at root).
- `/onboarding` added to middleware `PROTECTED_EXACT`; logged-out access → `/login?redirect=…`. (`/earnings` was also added Conv 201 but the route was deleted Conv 203.) `/profile` was moved `PROTECTED_EXACT` → `PROTECTED_PREFIXES` in Conv 212 when it became the `/profile/[...tab]` family, so every sub-tab is protected.
- The root `/login`, `/signup`, `/onboarding`, `/profile/[...tab]` here are distinct from §6 Auth / §1 Personal canonical entries — those describe the design; this is the live root build state.

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

**Post-flip layout (Conv 197 [ROUTE-FLIP]).** The root namespace holds Matt's design-system pages (only
those rebuilt so far — see §8); the entire legacy app moved to `src/pages/old/`. The `api/` tree did **not**
move. `route-api-map.md` is the authoritative live inventory; the tree below is the structural overview.

```
src/pages/
│
│  ── Root = Matt's design system (only the pages rebuilt so far; see § Route Categories #8) ──
├── index.astro                   # / (Home dashboard — rebuilt from /old in Matt shell, Conv 203 RTMIG-4 pilot)
├── courses.astro                 # /courses (Matt-native course index)
├── course/
│   └── [slug]/
│       ├── [...tab].astro         # /course/[slug]/[...tab] (about|benefits|feed|modules|creator|teachers|reviews|resources)
│       ├── precheckout.astro      # /course/[slug]/precheckout (Conv 232 — standalone PrecheckoutContent; named file beats [...tab] catch-all)
│       └── _course-tabs.ts        # tab whitelist/config (leading _ = not a route)
├── dev/                          # /dev/* design sandbox (Conv 203 — off canonical app)
│   ├── primitives.astro          # /dev/primitives (showcase archived from / )
│   ├── saved.astro               # /dev/saved (uses extracted EmptyState)
│   └── todo.astro                # /dev/todo
├── login.astro                   # /login (Conv 201 — promoted; reuses AutoOpenAuthModal)
├── signup.astro                  # /signup (Conv 201 — mode=signup)
├── visitor.astro                 # /visitor (Conv 216 — logged-out account surface; links + ThemeToggle; authed → /profile)
├── onboarding.astro              # /onboarding (Conv 201 — reuses OnboardingProfile)
├── profile/
│   ├── [...tab].astro            # /profile/[...tab] (Conv 212 — @matt-inspired 6-tab account hub)
│   └── _profile-tabs.ts          # buildProfileTabs() SSOT (6 items)
├── notifications.astro           # /notifications (Conv 245 — @matt-inspired root port; NotificationCenter)
├── messages.astro                # /messages (Conv 245 — @matt-inspired root port; 5 islands under components/messages/matt/)
├── 404.astro                     # 404 (root)
│  ── Deleted Conv 203 (Matt placeholders → 404 by design): saved.astro, todo.astro,
│     earnings.astro, teachers.astro (messages + notifications rebuilt Conv 245) ──
├── api/                          # /api/* — NOT moved by the flip; stays at root
│
│  ── Legacy app — moved wholesale to /old/* (mirrors the pre-flip layout) ──
│     Every §§1–7 route the design references currently resolves here until rolled forward.
└── old/
    ├── index.astro                # /old (legacy homepage)
    ├── dashboard.astro            # /old/dashboard (unified cross-role dashboard)
    ├── community/
    │   ├── index.astro            # /old/community (My Communities hub)
    │   └── [slug]/{index,courses,resources,members}.astro
    ├── course/
    │   └── [slug]/{index,learn,feed,book,sessions,teachers,resources,success}.astro
    │       + [tab].astro           # role-tab catch-all (Conv 166; static files take precedence)
    ├── creator/[handle]/index.astro
    ├── teacher/[handle]/index.astro
    ├── discover/
    │   ├── {index,courses,creators,students,teachers,communities,feeds,members,leaderboard}.astro
    │   ├── course/[slug]/{index,[...tab]}.astro
    │   └── community/[slug]/{index,[...tab]}.astro
    ├── teaching/
    │   ├── {index,students,sessions,earnings,analytics,availability}.astro
    │   └── courses/[courseId].astro
    ├── creating/
    │   ├── {index,apply,studio,earnings,analytics}.astro
    │   └── communities/{index,[slug]}.astro
    ├── learning.astro             # /old/learning
    ├── learning/sessions.astro
    ├── settings/{index,profile,notifications,payments,security,interests}.astro
    ├── @[handle].astro            # /old/@[handle] (universal profile)
    ├── courses.astro              # /old/courses (my enrolled)
    ├── feed.astro · feeds.astro · messages.astro · notifications.astro
    ├── onboarding.astro · profile.astro (→ /@me)
    ├── admin/{index,users,courses,enrollments,teachers,payouts,sessions,certificates,
    │          creator-applications,topics,analytics,moderation,moderators,recordings}.astro
    ├── login.astro · signup.astro · reset-password.astro
    ├── session/[id].astro · verify/[id].astro
    └── about · how-it-works · pricing · faq · for-creators · become-a-teacher · contact
        · privacy · terms · cookies · stories · testimonials · blog · careers · help
        (marketing / legal / support .astro placeholders)
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
| Matt design system (**root**, post-flip Conv 197) | Real pages built at root: `/` (dashboard, Conv 203), `/courses`, `/course/[slug]/[...tab]` (incl. booking/precheckout/success sub-routes, Convs 175-235), `/community/[slug]/[...tab]` (Conv 237 [COMM-DETAIL] — 3rd `[...tab].astro` family after course + profile), `/feed` (Conv 238), and `/notifications` + `/messages` (Conv 245 — rebuilt from the Conv-203 placeholders into real `@matt-inspired` ports). The 5 placeholder routes (`/saved`, `/todo`, `/teachers`, `/messages`, `/notifications`) were **deleted Conv 203**; `/messages` + `/notifications` have since been **rebuilt Conv 245**, leaving `/saved`, `/todo`, `/teachers` still 404. `/teachers/[handle]` was **deleted Conv 207** (zero live callers — Conv 193 pre-emptive). (Not exhaustive — `route-api-map.md` is the authoritative current root inventory.) | Roll-forward of remaining pages tracked as MMP-PH5 / RTMIG-4; until then those routes resolve under `/old/*` — see `matt-provenance.md` §8 |
| Forward-migrated to root (Conv 201 [ROUTE-MIGRATION]) | 4 pages still live (`/login`, `/signup`, `/onboarding`, `/profile/[...tab]`) — auth loop + account hub; reuse existing components. `/profile` was a `@stand-in` stub until Conv 212 [STANDIN-MATT] retrofitted it into the `@matt-inspired` `/profile/[...tab]` 6-tab account hub. (`/earnings` was promoted Conv 201, deleted Conv 203.) | Per-page `/old/*` → root conversion continues as RTMIG-4; per-tab `/profile` fidelity deferred to PROF-TAB-REDESIGN |
| Dev sandbox (`/dev/*`, Conv 203) | 3 routes (`/dev/primitives`, `/dev/saved`, `/dev/todo`) — off canonical app | — |
| Legacy app (`/old/*`) | 43 top-level entries moved wholesale by the flip (full pre-flip route set) | Retired incrementally as Matt's system reclaims each route at root |
| Other | 3 routes (`/404`, `/verify/[id]`, `/session/[id]`) | — |

*Note: Marketing/Legal/Support/Browse/Blog pages are "Coming Soon" placeholders (Session 317, BROKENLINKS block).*
*Note: post-flip (Conv 197), the root namespace is owned by Matt's design system and the legacy app lives at `/old/*` — see § Route Categories #8 + the status banner. The counts above predate the flip's `/old/*` move; `route-api-map.md` is the authoritative current inventory.*

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
- Conv 197 (2026-05-26) [ROUTE-FLIP]: `/matt/*` namespace dissolved — Matt's design system promoted to root, legacy app moved to `/old/*`, `/api/*` unmoved. § Route Categories #8 rewritten.
- Conv 198 (2026-05-26) [URLDOC-RECONCILE]: §§1–7 retained as canonical URL design + post-flip status banner (which routes are at root vs. `/old/*`); file-structure tree rewritten for the post-flip layout; Implementation Status `/matt/*` row replaced with root/legacy split.
- Conv 201 (2026-05-26) [ROUTE-MIGRATION]: forward-migrated 5 routes off `/old/*` to root (`/login`, `/signup`, `/onboarding`, `/earnings`, `/profile`) as the minimum to make the new root app usable; `AuthModalRenderer` mounted globally in `AppLayout`; post-login default redirect `/dashboard`→`/` (`src/lib/auth-modal.ts`); `/earnings`/`/onboarding`/`/profile` added to middleware `PROTECTED_EXACT`. §8, file tree, and Implementation Status extended. Per-page conversion continues as RTMIG-4.
- Conv 203 (2026-05-27) [ROUTE-MIGRATION + RTMIG-4 pilot]: deleted 6 Matt-placeholder root routes (`/saved`, `/todo`, `/teachers`, `/messages`, `/notifications`, `/earnings`) so their links 404 by design until rebuilt (memory `project_route_404_honesty_standin.md`); rebuilt Home (`/`) from the `/old` dashboard in the Matt shell (RTMIG-4 pilot, approach A: legacy body into Matt shell) — now calls `/api/me/full` + `/api/me/version`; added `/dev/*` design sandbox (`/dev/primitives` = showcase archived from `/`, `/dev/saved`, `/dev/todo`); removed Peer Teachers + Earnings from Sidebar. `/teachers/[handle]` retained (StudentTeacherAnchor target). §8, banner, file tree, Implementation Status updated. New primitives `ActionCard` + `EmptyState`.
- Conv 207 (2026-05-28) [STANDIN-MATT]: deleted `/teachers/[handle]` (zero live callers — Conv 193 pre-emptive build, `StudentTeacherAnchor` not yet consumed by any production page); `teachers/` directory removed. §8 table row removed, file tree pruned, banner + Implementation Status updated.
- Conv 212 (2026-05-28) [STANDIN-MATT]: retrofitted the last `@stand-in` page — `/profile` became the `@matt-inspired` `/profile/[...tab]` catch-all account hub (`profile/{[...tab].astro,_profile-tabs.ts}`, 2nd instance of the `_`-prefixed tab-config idiom after `course/`). 6-tab SubNav (Account / Edit Profile / Interests / Payments / Notifications / Security) flattens the `/settings` hub by reusing its 5 React islands; invalid tab → base redirect. Middleware moved `/profile` `PROTECTED_EXACT` → `PROTECTED_PREFIXES` (+4 sub-route protection tests). `lock.svg` harvested for the Security tab (MattIcon registry 53→54). §8 root-routes table + file tree updated; route maps regenerated. Per-tab faithful Matt redesign deferred to [PROF-TAB-REDESIGN].
- Conv 238 (2026-06-03) [FEED-DETAIL]: added root `/feed` — `@matt-inspired` single-page port of `/old/feed` into the Matt shell (AppLayout + SectionTitle + breadcrumb + OnboardingNudgeBanner + prop-less `SmartFeed` island, `max-w-2xl`, `noNav`; `getSession` redirect on top of the existing `PROTECTED_EXACT` guard). The legacy `/feed` was a single 40-line SmartFeed page (no `/feed/[slug]` family ever existed or was linked) so this is a single-page port, NOT the `[...tab]` triad — the FEED-DETAIL task's "4th tab family" premise was falsified by reading the legacy source. Root file was missing post-route-flip → ~7 bare-`/feed` links 404'd until now. Sidebar NAV + COLLAPSED_NAV gained "My Feed"→/feed after Home (new harvested `sparkles` MattIcon; "My" prefix + Home-adjacent position disambiguate from the existing "Feeds" discover destination). Adjacent link-honesty: `api/feeds/discover.ts` + `smart-feed/enrichment.ts` ctaUrls and `DiscoverSlidePanel` Feeds/Courses hrefs repointed `/discover/{community,course,feeds}` → root (`/community/`, `/course/`, `/feeds`, `/courses`). §8 root-routes table row added; header + this changelog updated; route maps regenerated.
- Conv 237 (2026-06-03) [COMM-DETAIL]: ported `/community/[slug]` from `/old/community/[slug]/*` to a root `[...tab].astro` family (`community/{[...tab].astro,_community-tabs.ts}`) — the 3rd instance of the `[...tab].astro` + `_*-tabs.ts` + `SubNav` triad after `/course/` and `/profile/`. Decision B: the bare URL renders a NEW About/Overview default (legacy never had one), so the canonical Feed URL moved to `/community/[slug]/feed`; tabs = About / Feed / Courses (dropped for `isSystem`) / Resources / Members. Decision A: host bio threaded through `fetchCommunityDetailData` (`users.bio_short` join, no schema change). Legacy decorative `?tag=` filter chips dropped (never consumed → `[COMM-TAG-FILTER]`); dead "Leave" button noted. The 628-line `CommunityTabs` island decomposed into per-URL server tabs + 2 new client islands (`CommunityMembersTab`, `CommunityResourcesTab`). The Commons pinned as a distinct cover-image card on `/communities` (fulfills previously-404 home/feed links to `/community/the-commons`). Community Routes table, Feed Hierarchy, adapts-how table, §8 Implementation Status, and header updated; route maps regenerated.
- Related: `docs/DECISIONS.md` (authoritative decisions)
- Related: `docs/as-designed/orig-pages-map.md` (original page inventory, pre-Twitter UI)
- Related: `docs/requirements/rfc/CD-036/` (Communities, Progressions & Feeds)
- Related: Navigation components (`AppNavbar`, `DiscoverSlidePanel`)

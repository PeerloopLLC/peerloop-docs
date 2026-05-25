> **Matt Design System** · [Index](./INDEX.md) · [Pre-plan](../matt-pre-plan.md)

## 3. Existing App Context

This section consolidates what's already true in the Peerloop codebase so [MATT-PRE-PLAN] doesn't re-discover or re-design things that exist.

### URL routing — established conventions

**Source of truth:** `docs/as-designed/url-routing.md`.

| Pattern                        | Meaning                 | Example                                                    |
| ------------------------------ | ----------------------- | ---------------------------------------------------------- |
| Bare route                     | "my stuff" (auth-gated) | `/courses` = my enrolled, `/feed` = my timeline            |
| `/discover/*`                  | site-wide discovery     | `/discover/courses` = catalog                              |
| `/{singular}/[param]`          | individual resource     | `/course/[slug]`, `/teacher/[handle]`, `/creator/[handle]` |
| `/{singular}/[param]/{action}` | resource sub-route      | `/course/[slug]/learn`, `/course/[slug]/feed`              |
| `/{plural}`                    | personal collection     | `/courses` (my enrolled)                                   |
| `/{verb-ing}/*`                | role dashboard          | `/teaching/*`, `/creating/*`, `/learning/*`                |
| `/{noun}/[handle]`             | public profile          | `/teacher/[handle]`                                        |
| `/@[handle]`                   | universal profile       | `/@jane`                                                   |
| `/settings/*`                  | account config          | no `/my/` prefix                                           |

**Status:** 84 `.astro` page files exist (Session 317 verification). All major route categories are implemented.

### Course routes — what `/matt/course/[slug]/*` mirrors

| Existing route                      | Purpose                                               |
| ----------------------------------- | ----------------------------------------------------- |
| `/course/[slug]`                    | About/Learn (Astro decides tab based on enrollment)   |
| `/course/[slug]/learn`              | Learn tab (enrolled)                                  |
| `/course/[slug]/feed`               | Course discussion feed (enrolled)                     |
| `/course/[slug]/book`               | Book a teacher session (enrolled)                     |
| `/course/[slug]/sessions`           | Sessions list (role-aware: extra tabs per role)       |
| `/course/[slug]/teaching-sessions`  | TEACHER role-tab pre-selected (dynamic `[tab].astro`) |
| `/course/[slug]/creator-sessions`   | CREATOR role-tab pre-selected                         |
| `/course/[slug]/admin-sessions`     | ADMIN role-tab pre-selected                           |
| `/course/[slug]/moderator-sessions` | MODERATOR role-tab pre-selected                       |
| `/course/[slug]/teachers`           | Teachers list                                         |
| `/course/[slug]/resources`          | Course materials                                      |

The dynamic `src/pages/course/[slug]/[tab].astro` catch-all (Conv 166 [CRT-DEDICATED-PAGES]) is the existing implementation of the role-perspective URL pattern. **This is what the Role Tab Bar's role tabs will navigate between.**

#### `/matt/course/[slug]/[...tab]` — implemented route shape (Conv 188 [MATT-EXEC-PG2])

The `/matt/*` re-skin of course tabs is a **catch-all rest route** mirroring the legacy `discover/course/[slug]/[...tab].astro` precedent:

- **File:** `src/pages/matt/course/[slug]/[...tab].astro` — catch-all tab route. `src/pages/matt/course/[slug]/index.astro` (the About tab, Conv 187) is left untouched and handles the bare base URL.
- **Tab guard:** `VALID_TABS = feed / modules / creator / teachers / reviews / resources`. An unrecognized tab segment 302-redirects to the course base URL.
- **Shell:** breadcrumb + `<SubNav>` + `<CourseHeader>` is duplicated across `index.astro` and `[...tab].astro` (per the chosen structure decision below); the per-tab body is selected by a `tab ===` switch.
- **Per-tab bodies:** each tab renders a dedicated body component in `src/components/matt/course/`. **All six tabs are now built (Conv 189 [CRTTAB]/[RVWTAB]/[MODTAB]/[FEEDTAB]):**

| Tab | Body component | Data source |
| --- | --- | --- |
| `creator` | `CreatorTab.astro` | Identity/bio/stats real (creator loader row); Expertise/Philosophy/Qualifications/Why-Learn have **no schema backing** → rendered as static grey via a `staticContent` prop (see decision below) |
| `reviews` | `ReviewsTab.astro` | Real `course_reviews` (rating/body/author/timestamp) via a new loader query; reaction pills static (no reactions table); reuses `CourseEmbedCard` |
| `modules` | `ModulesTab.astro` | Real `course_curriculum` 1:1 session cards (number/title/description/duration); sub-count + posts pill omitted (no schema source) |
| `feed` | `MattCourseFeed.tsx` (client island) | Real Stream-backed activities via the existing `GET /api/feeds/course/[slug]` (same API the legacy `CourseFeed.tsx` uses); composer + `SocialPost` list |
| `teachers` | `TeachersTab.astro` | Built Conv 188 |
| `resources` | `ResourcesTab.astro` | Built Conv 188 |

**Per-tab data verdicts (Conv 189 [CRTTAB]–[FEEDTAB]).** Each tab's data strategy was decided only after probing the actual schema/seed/API — not from the Figma frame alone. The four tabs landed on three different verdicts (Creator = static grey for unbacked sections; Reviews/Modules = real via existing tables read by loader queries; Feed = real via the existing feed API as a client island). Defaulting all tabs to one approach would have been wrong in 3 of 4 cases.

**`staticContent` grey-provenance pattern (Conv 189 [CRTTAB]).** Per user directive ("do NOT extend the schema in any way; render Matt's no-counterpart content as grey text exactly as shown"), `CreatorTab` renders unbacked (no-schema) sections in grey (`text-text-tertiary`, grey expertise pills) to mark them as static mock. Matt's verbatim copy lives as `CREATOR_STATIC` constants in the route file. A flag restores full color without markup change when real data arrives. No migration.

**`CourseEmbedCard.tsx` (Conv 189).** Shared embedded-course card primitive (used by ReviewsTab + MattCourseFeed). Distinct from `CourseAnchor`: no pill, stacked metadata.

**Loader change (Conv 189).** `fetchCourseTabData` in `src/lib/ssr/loaders/courses.ts` gained a `reviews` field (a `course_reviews` JOIN `users` query) plus a shared `courseEmbed`. This **reads the existing `course_reviews` table — not a schema change**; the query runs for all course tabs.

**Structure decision (Conv 188, user-chosen Option A):** per-tab `.astro` body components rendered by the `tab ===` switch, shell duplicated across the two route files, `index.astro` (About) untouched. Chosen over extracting a shared `CourseTabShell` — lowest risk to just-validated Conv 187 work; mirrors the legacy discover precedent (shell duplicated in 2 route files). Shell duplication between `index.astro` and `[...tab].astro` is an accepted trade-off (flagged for future dedup if PG2 churns tabs).

**Tab body realities (Conv 188 probe).** Matt's course-tab frames are bespoke page-level **card composites** (SessionCard / ReviewCard / TeacherCard), not thin anchor-list shells — the Ready-for-Dev lookup's earlier "expected primitives" were inferences, not probes. Frames are happy-path instance snapshots of one demo course in a specific state (Resources = empty state; Modules = 2-session demo). Faithful building reproduces the drawn state; populated/other states are Phase-6 [MATT-EXEC-EXT] extrapolation. (All six tabs built as of Conv 189 — see the tab table above.)

**Modules domain model (Conv 188 decision).** Session↔Module is **1:1** — every session has exactly one Module. Matt's (and creators') nested "Modules" are **Sub-Modules** (a term misuse); there is no session→many-modules data model. ModulesTab (built Conv 189 [MODTAB]) renders one card per `course_curriculum` row (number/title/description/duration, all real); the "N Sub-Modules" sub-count and "posts" pill are **omitted** (no schema source — faking counts would mislead, unlike CreatorTab's verbatim prose). See memory `project_module_submodule_model.md`.

### Existing role-aware components (Role Tab Bar source — built Conv 042-044)

**Source directory:** `src/components/discover/`. **Doc:** `docs/reference/_COMPONENTS.md` § "Explore Components".

| Component                                                  | Role                                                                                                                                                                        |
| ---------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `RoleBadge`                                                | Pill showing viewer's role for a course/community. 3 sizes (sm / md / compact). Colors: student=blue, teacher=green, creator=purple, moderator=amber. Inactive = secondary. |
| `RoleBadgeRow`                                             | Multiple badges in flex row                                                                                                                                                 |
| `ExploreTabBar`                                            | Top-level tab switcher with role-colored tabs + count badges. **This IS the Role Tab Bar pattern source — re-skin with Matt's tokens for `/matt/*`.**                       |
| `RolePillFilters`                                          | Multi-select role toggle pills (only renders pills for roles the user actually has)                                                                                         |
| `ExploreCourseTabs`                                        | Wrapper around `CourseTabs` that injects role-specific tabs into the detail page tab bar                                                                                    |
| `ExploreCommunityTabs`                                     | Same for community pages                                                                                                                                                    |
| `ExploreCourseHero` / `ExploreCommunityHero`               | Hero + "Your Role:" badges below                                                                                                                                            |
| `ExploreCard` / `ExploreCommunityCard` / `ExploreFeedCard` | Cards with role badge overlay                                                                                                                                               |

**Implication:** The **Role Tab Bar** (Peerloop extension — NOT a Matt primitive) is a visual re-skin of `ExploreTabBar`. The role-encoding, tab-switching, count-badging logic is all already wired up. `/matt/` just provides Matt's visual treatment (sizes, colors, typography from the token system). Matt's own `components/Control Bar.svg` is a different thing — the bottom-nav primary-nav strip used at tablet-portrait/mobile breakpoints, not a role switcher.

### Role detection — `CurrentUser` singleton

`CurrentUser` (client-side singleton) provides O(1) role detection. Existing role-aware components read it directly. Methods:

- `getRoleBadges(courseId)` → role config for that entity
- Reads enrollments, certifications, created courses, moderated courses
- Source: implementation referenced throughout Conv 042-044 components

### Schema role flags → Matt's role enumeration

| Matt's role | Schema field                              | Notes                                             |
| ----------- | ----------------------------------------- | ------------------------------------------------- |
| Teacher     | `is_teacher = 1`                          | —                                                 |
| Student     | derived (≥1 enrollment)                   | Enrollment-based, not a flag                      |
| Visitor     | no auth                                   | UX state only — confirmed Conv 171 — no DB change |
| Creator     | `can_create_courses = 1` OR `has_courses` | "Permission OR State" pattern (POLICIES §1)       |
| Admin       | `is_admin = 1`                            | —                                                 |
| Moderator   | `is_moderator = 1`                        | —                                                 |

**Source:** `docs/POLICIES.md` §1 (Creator Access Control) and §8 (Member Search & Discovery, role badges table).

### Layout shell — existing vs Matt's

**Current pattern** (per MEMORY.md):

- `AppLayout.astro` — primary layout with persistent left sidebar
- `AppNavbar` — sidebar nav, role-based menu items, `startsWith` path matching for sub-route highlight
- `AppHeader` — legacy, used by `LegacyAppLayout.astro`

**Matt's design:** Sidebar (220 expanded / 70 collapsed) + Main Panel (16px gutter). NO global top header. Branding sidebar-only.

**Mapping:** `AppNavbar`'s role-based menu becomes Matt's sidebar visual (PeerLoop branding top, primary nav middle, Profile bottom). **Implemented Conv 190** — `AppLayout.astro` itself was rewritten to Matt's "Layout Desktop" (grey page + floating white card, transparent sidebar), not wrapped by a separate `MattLayout`. See §5 "App shell — Matt Layout Desktop" for the implemented anatomy + `roles.ts` helper.

### Breadcrumb / Header Bar — `?via=` query-param pattern

The thin breadcrumb strip at the top of the Main Panel (what Matt calls "Header Bar") is implemented today via the `?via=` query-param pattern.

| `?via=` value          | Trail rendered                                           |
| ---------------------- | -------------------------------------------------------- |
| `discover-communities` | Discover > Communities > [Name]                          |
| `discover-courses`     | Discover > Courses > [Title]                             |
| `community-courses`    | [Community] > Courses > [Title] (with `&cs=` and `&cn=`) |
| `discover-feeds`       | Discover > Feeds > [Name]                                |

Component: `src/components/ui/Breadcrumbs.astro`. **Source:** `docs/DECISIONS.md` §5 "Breadcrumb System".

**Implication:** Matt's Header Bar is `<Breadcrumbs>` with new visual styling. The data plumbing exists.

### Page auth tiers (POLICIES §7)

| Tier             |          Auth          | Examples                                                                        |
| ---------------- | :--------------------: | ------------------------------------------------------------------------------- |
| Public-static    |           No           | `/login`, `/signup`                                                             |
| Public-browsable | Optional (enhances UX) | `/discover/*`, `/course/[slug]`, `/@[handle]`                                   |
| Member-only      |        Required        | `/dashboard`, `/learning`, `/teaching`, `/settings/*`, `/community`, `/courses` |
| Role-gated       | Required + role check  | `/admin/*` (admin), `/creating/*` (creator)                                     |

Enforcement: middleware (`src/middleware.ts`) handles auth; layouts handle role-gating (`AdminLayout.astro`). The middleware never queries DB.

### Existing UI primitives we'll re-skin

From `docs/reference/_COMPONENTS.md` § "UI Primitives" (`src/components/ui/`):

- `Icon.astro` (build-time SVG, zero JS) backed by `src/lib/icon-paths.ts`
- `icons.tsx` (React icon library, ~96 exports)
- `brand-icons.tsx` (Google, GitHub, Stripe, etc.)
- `Breadcrumbs.astro` — Header Bar implementation
- `Modal.tsx` / `ConfirmModal.tsx` / `FormModal.tsx`
- `charts/` — Library-agnostic chart components

Matt's `components/` SVG primitives (Brand, Button Primary, Main Nav, Sub Nav, Module, Chat, Entities, Icons, Note, Section Title, Social Post, To Do Item, Post Anchors) map mostly onto existing concepts. Need a one-to-one mapping table during [MATT-PRE-PLAN].

### Component patterns established (per MEMORY.md)

- **React icons** (`icons.tsx`): `({ className = 'h-5 w-5' }: IconProps)` — accept `className` prop, default size, inherits `currentColor`
- **Astro icons** (`Icon.astro`): `<Icon name="profile" class="w-6 h-6 text-purple-600" />` — zero JS, build-time SVG
- **Icon registry** (`src/lib/icon-paths.ts`): ~35 raw HTML path strings for Astro builds

### Docs [MATT-PRE-PLAN] should read first

Priority order:

1. **`docs/as-designed/url-routing.md`** — full route map; identify the existing route that each of Matt's 31 happy-path screens mirrors
2. **`docs/reference/_COMPONENTS.md`** — full component inventory; map Matt's components/\*.svg primitives to existing components
3. **`docs/POLICIES.md`** — §1 (Creator gates), §7 (Page auth), §8 (Role badges)
4. **`docs/as-designed/orig-pages-map.md`** — original page architecture (pre-Twitter UI pivot) for historical context (referenced from INDEX, not yet read in this conv)
5. **`docs/GLOSSARY.md`** — official terminology for naming `/matt/*` files consistently (not yet read in this conv)
6. **`docs/DECISIONS.md`** — full architecture decisions list, especially §5 (Breadcrumb System) and any decision related to layouts

### Files to read in `../Peerloop/src/` during [MATT-PRE-PLAN]

For the layout shell design:

- `src/layouts/AppLayout.astro` — the current persistent-sidebar shell to re-skin
- `src/components/AppNavbar.*` — sidebar navigation component
- `src/components/ui/Breadcrumbs.astro` — Header Bar implementation
- `src/middleware.ts` — auth gating

For the **Role Tab Bar** (Peerloop extension — not in Matt's design):

- `src/components/discover/RoleBadge.*` — visual role pill (3 sizes)
- `src/components/discover/ExploreTabBar.*` — the Role Tab Bar pattern source (re-skin target)
- `src/components/discover/ExploreCourseTabs.*` — role-specific tab injection
- `src/pages/course/[slug]/[tab].astro` — dynamic role-tab catch-all
- `src/lib/CurrentUser.*` (or equivalent) — client-side role singleton

### Important historical context

- **Session 379 (COURSE-PAGE-MERGE):** `/course/[slug]/learn` merged into course detail page as Learn tab (accordion modules); Curriculum tab removed. Affects how Matt's Course detail screens map.
- **Conv 042–044 (EXPLORE-COURSES, EXPLORE-COMMUNITIES-FEEDS):** Built the entire role-aware component system Matt's design now reuses visually.
- **Conv 110–111:** Open messaging; unified `/discover/members` (was 3 separate routes).
- **Conv 033:** AppNavbar simplified — `/dashboard` is single nav entry point for all role dashboards (no separate `/learning`, `/teaching`, `/creating` menu items).
- **Conv 165–166 (CRT-3/4/5/DEDICATED-PAGES):** Added role-tab routes to course detail pages — direct implementation of the URL pattern the **Role Tab Bar** will navigate between.

---


# Matt Design System

🚧 **Working draft — Conv 171+.** Token extraction in progress (Batch 1 done, Batches 2–5 partial). Will mature as the Matt design push proceeds. At the end of [MATT-PRE-PLAN], this doc becomes the authoritative spec for `/matt/*` re-skin work and the extrapolation guide for the rest of the app.

**Related task:** [MDM] (TodoWrite #13 — token extraction) feeds this doc; [MATT-PRE-PLAN] (TodoWrite #10) consumes it.
**Companion doc:** [matt-pre-plan.md](matt-pre-plan.md) — execution plan (route map, file structure, blocking decisions, phase sequence) for the `/matt/*` re-skin. Reading order: this doc first (*what*), pre-plan second (*how*).

---

## 1. Strategic Context

**Why Matt came in late.** The app was deliberately built ~5 months BEFORE bringing in a designer, so Matt would design against a functional, complex reality — not speculate about one. This avoids the common failure mode of designers producing imperfect mockups of flows they don't yet understand.

**Matt's brief.** Simplify, design, and present the **80/20 Pareto perspective** for the student → teacher journey. Matt's value-proposition focus is **proving the flywheel that Peerloop is built on: turning students into teachers.** The 31 happy-path screens are the **first leg** of that flywheel journey, captured with deliberately simplified single-role views (which is why multi-role complexity was kept out of Matt's brief — it would have slowed him down without adding value to the core flywheel demonstration).

**The user's 3-part job:**

1. ✅ Make sure the app is fully functional first (achieved across the prior ~170 convs)
2. 🚧 Merge Matt's perspectives into the working app (this is `/matt/*` re-skin work)
3. 🚧 Extrapolate Matt's designs to the rest of the app (the ~84 existing pages Matt didn't draw)

**Implication for the design system.** Matt's 31 happy-path screens are the **calibration set** for a design language; the **~84 existing pages are the extrapolation test.** This raises the bar:

- **Tokens** must be complete and consistent enough that an unseen page (e.g. `/admin/payouts`, `/settings/security`) can be styled correctly from tokens alone, without inventing values mid-implementation.
- **Layout primitives** must compose into shapes Matt never drew (admin multi-pane layouts, modal-heavy flows, settings forms, error states).
- **Component primitives** must cover patterns the happy path doesn't exercise (data tables, complex forms, empty/error/loading states for less-glamorous pages).
- **The North Star tiebreaker for any visual decision:** does this surface the flywheel? Does this lower the friction of the student → teacher transition?

**Action item for [MATT-PRE-PLAN]:** explicitly enumerate **what's missing from Matt's set** — gaps in his happy-path visual language that we'll need to fill with extrapolation judgment. Surface these during planning, not piecemeal during implementation. Candidates so far: admin layouts, data tables, complex forms, error/empty/loading states, the **Role Tab Bar** (multi-role perspective switcher — Matt didn't draw it because his design doesn't account for users holding multiple roles for the same entity).

**Authority split.**

- **Matt's design = visual spec for the happy path.** Use it for tokens, primitive components, page-shell layout, entity-header treatment.
- **Existing Peerloop app = behavioral spec.** Routing, data fetching, role logic, multi-role switching, permission gating — all live in the real app. The happy path was _deliberately simplified_ to spare Matt from the full multi-role complexity.
- **`/matt/*` is visual re-skinning, not architecture work.** Each `/matt/*` route corresponds to an existing page; we wrap its existing data/behavior in Matt's tokens + components.

---

## 2. Architectural Findings

Derived Conv 171 from review of Home, Course, and Teacher happy-path screens.

### Two-panel desktop architecture

- Persistent: **Sidebar** (left) + **Main Panel** (right). Matt may use different names in Figma.
- Sidebar widths: 220px expanded, 70px collapsed. User-controlled toggle (not viewport-driven).
- 16px horizontal gutter between Sidebar and Main Panel.
- Sidebar is shared shell — Matt did NOT repeat it in every page mockup, but it is part of every page at runtime.

### No global top header bar

- Branding ("PeerLoop" + logo) lives in the Sidebar's top-left corner.
- User identity (profile chip) lives in the Sidebar's bottom-left corner.
- Primary nav (Home, Courses, Peer Teachers) lives in the Sidebar middle.
- Earnings + Notifications also live in the Sidebar (lower section).
- `MattLayout.astro` should NOT define a top-of-viewport header slot.

### Page-level "Header Bar" = top-of-page slot with breakpoint-varying content

The Header Bar is a SLOT, not a single component. Its content changes dramatically across breakpoints (confirmed Conv 172 from observation of Desktop, Tablet Portrait, and Mobile page-structure frames):

- **Desktop (≥1025px):** thin breadcrumb / back-nav strip at top of Main Panel. Examples: "Home / Community" on Home page, "← Home / Creator Profile" on Teacher page. Height ~40–48px.
- **Tablet Portrait (≤1024px):** brand strip — ∞ logo + "PeerLoop" wordmark, centered. Height 24px. Positioning: `position: fixed; top: 48px;`
- **Mobile (≤640px):** brand strip + flanking nav icons — Messages (envelope, left) + ∞ logo and "PeerLoop" wordmark (center) + Notifications (bell, right). 3-slot horizontal layout. Height ~40px (eyeball).

⚠️ **Architectural implication.** `MattLayout.astro`'s Header Bar slot is NOT static content with CSS breakpoint styling — its **children differ by breakpoint** (Messages and Notifications icons exist only at mobile; brand-only at tablet; breadcrumb-only at desktop). Resolve during [MATT-PRE-PLAN]: does the Header Bar component take breakpoint-conditional children itself, or do pages pass different slot content per viewport? Flagged Conv 172.

### Entity-typed page headers below the Header Bar

Each entity type gets its own visually distinctive header zone, color-keyed to the semantic palette:

- **Course Header** (`layout/Course Header.svg`) — dark image hero with title + metadata + CTA
- **Teacher / Creator Header** — purple-blue card (matches `creator-primary` = `#584DF4`)
- **Student Header** (presumed) — `student-primary` blue (`americana-blue` = `#0777B6`)

This is a load-bearing architectural pattern, not decoration: **entity primary color must flow into the entity-header component.**

### Sub Nav pattern (breakpoint-varying)

The Sub Nav carries page sections (Course Feed / About / Sessions / Reviews / Resources / Teachers). Like the Header Bar, its rendering changes by breakpoint:

- **Desktop (≥1025px):** vertical-left tab strip — sits to the LEFT of the actual page content within the Main Panel.
- **Tablet Portrait (≤1024px):** TBD — confirm during [MATT-PRE-PLAN]. Likely vertical-left still, narrower.
- **Mobile (≤640px):** **slide-in NavBar from left** (Matt's intent, confirmed Conv 172). The vertical strip becomes a drawer that slides in from the left edge on demand, freeing the cramped main content area.

This is the `components/Sub Nav.svg` primitive — NOT the Control Bar.

⚠️ **Architectural implication.** Like the Header Bar, the Sub Nav has at least two distinct rendering modes — inline-vertical at desktop vs. left-slide drawer at mobile. `MattLayout.astro` needs a second breakpoint-aware composition pair beyond the Header Bar. Resolve during [MATT-PRE-PLAN].

### Control Bar (Matt's primitive) = primary-nav strip

- Matt's `components/Control Bar.svg` primitive.
- On desktop: not present — primary nav lives in the Sidebar.
- On tablet portrait (≤1024px): bottom-fixed pill containing 6 nav icons (Home / Saved / Courses / Messages / Notifications / To-Do). Replaces Sidebar nav when there's no room for a sidebar.
- Height (tablet portrait): 48px. Positioning: `position: fixed; left: auto; right: auto; bottom: 48px;`
- Mobile (≤640px): bottom-fixed pill containing **4 nav icons** (Home / Saved / Courses / To-Do). **Messages and Notifications are NOT here** — they move UP to the Header Bar at this breakpoint, freeing space in the narrower bottom pill. Height 49px. Positioning: `position` not specified in Figma; `bottom: 23px; left/right: 24px` (the pill is inset from viewport edges). Matt didn't specify a unified Page Padding at mobile — each fixed bar carries its own offsets, so this isn't part of a body-level shell.
- ⚠️ **Conv 171 attribution was wrong.** The original §2 entry described Control Bar as a "role-perspective tab switcher (only appears when user has multiple roles)." That conflated Matt's primitive with a Peerloop-specific need. Matt's design doesn't account for multi-role users at all — his brief was deliberately simplified, Teacher and Student each get their own pages, no multi-role overlay. The role-perspective switcher is OUR extension: the **Role Tab Bar** (next sub-section). Corrected Conv 172.

### Role Tab Bar (Peerloop extension — NOT in Matt's design)

**Why it exists.** Matt's brief was deliberately simplified to single-role views — Teacher and Student each get their own pages in his 31 happy-path screens. He drew no UI for a user who holds multiple roles for the same entity (Creator + Teacher + Moderator on their own course, etc.). That abstraction isn't in his mental model, so we won't get a visual spec from him. We extrapolate from his token system + the existing `ExploreTabBar`.

**What it does.** Visual switcher that lets a multi-role user toggle the role perspective they're viewing an entity from. Tabs represent **roles**, not page sections. The Sub Nav (vertical-left tab strip with About / Sessions / Reviews / Resources / Teachers) stays STABLE across role switches — same structural skeleton. The CONTENT inside each Sub Nav section is role-filtered. Per-row data in lists is also role-contextualized.

**When it appears.** Only when the current user holds multiple roles for the entity being viewed.

**Position in the layout shell.** Inside the Main Panel: directly below the Entity Header (Course / Teacher / etc.), above the Sub Nav + content row.

**Visual source.** Re-skin of existing `src/components/discover/ExploreTabBar.*` (Conv 042-044). The role-colored-tabs-with-count-badges primitive is already built — Role Tab Bar wraps it in Matt's tokens (typography, spacing, role-primary colors per §5).

**Concrete example.** A user who is Creator + Teacher + Moderator for their own Course sees the Role Tab Bar with 3 role tabs. Clicking "Creator" shows revenue + enrollment data + edit affordances; clicking "Teacher" shows live-session + grading affordances; clicking "Moderator" shows post-moderation + reporting tools. All three views share the same Sub Nav (Course Feed / About / Sessions / Reviews / Resources / Teachers).

**Tracked as `[RTB]`** in TodoWrite for design during [MATT-PRE-PLAN].

### Layout shell composition inside the Main Panel

```
┌────────────────────────────────────────────┐
│  Header Bar        (breadcrumb / back)     │ ~40-48px
├────────────────────────────────────────────┤
│  Entity Header     (Course / Teacher / …)  │ only on entity pages
├────────────────────────────────────────────┤
│  Role Tab Bar      (Peerloop ext.)         │ only if user has >1 role
├────────────────────────────────────────────┤
│  ┌─Sub Nav─┬───── Page content ─────────┐  │ Sub Nav vertical-left,
│  │ Feed    │                            │  │ content role-filtered
│  │ About   │                            │  │
│  │ ...     │                            │  │
│  └─────────┴────────────────────────────┘  │
└────────────────────────────────────────────┘
```

Each row is optional and orthogonal to the others.

### Roles in this design

Matt's design enumerates 6 roles:

1. **Teacher**
2. **Student**
3. **Visitor** — unauthenticated UI state, NO DB presence. A "user" who hasn't logged in.
4. **Creator**
5. **Admin**
6. **Moderator**

5 of these (Student, Teacher, Creator, Admin, Moderator) are documented in `CLAUDE.md § Key Roles` and already modeled in the existing schema. **Visitor is a UI concept only** — confirmed Conv 171 — no schema change required. The existing app already handles unauthenticated users; we use that same logic.

### Matt composes pages from reusable components (Conv 172 — confirmed)

**Observation.** Matt builds his pages by **assembling Figma components and instancing them**, not by drawing each page as a one-off layout. Confirmed Conv 172 via:

- The Button collection inspection — 6 style modes × 3 properties is a single parameterized component, not 18 separate copies. The same pattern applies to other primitives Matt has built (Sub Nav, Module, Note, Section Title, Social Post, To Do Item, Post Anchors — see `components/*.svg` inventory in `.scratch/matt-main/`).
- Per-instance overrides are how the same component renders different page content (e.g., a Course Header instance overrides title text, hero image, while inheriting the structural skeleton from the parent component).

**Implementation principle: mirror Matt's pattern in our React + Astro stack.**

1. **Every Matt component becomes a React or Astro component with parameters.** Default values come from the component-level definition (matching Matt's Figma defaults); overrides happen at the instance (call) site via props.
   - Example: `<CourseHeader title={course.title} heroImage={course.image} ctaLabel="Enroll" />` — title, hero, CTA are call-site overrides; structural skeleton (image-hero layout, title typography, CTA button placement) comes from the component definition.

2. **Variant props for multi-mode components.** Matt's Button has 6 style modes (Primary / Outlined / Course / Student / Creator / Default). The React `Button` takes a `variant` prop with a literal union type (`variant: 'primary' | 'outlined' | 'course' | 'student' | 'creator' | 'default'`). The variant drives token selection (e.g., `'course'` mode pulls `Course/Background` for background, `Course/Primary` for color). Same pattern for any other multi-mode component Matt ships.

3. **Slots / children for content composition.** Components that wrap content (Cards, Modals, Layouts) use Astro `<slot>` or React `children` so the instance can pass arbitrary content while preserving the structural skeleton. This is Matt's "instance overrides" pattern translated to code.

4. **Astro vs React split per component.** Both serve the same goal but at different layers:
   - **Astro** for static structural shells (page-level layouts, Header Bar skeleton, Sub Nav skeleton, static Card frames). Zero JS shipped to the client. Use `Astro.props` + `<slot>`.
   - **React** for interactive UI (Button click handlers, Modal open/close state, Drawer slide-in animation, multi-role Role Tab Bar selection). Use TypeScript `interface` props + `children`.
   - When in doubt, start with Astro and promote to a React island only when interactivity is genuinely needed.

5. **No one-off pages.** A `/matt/course/[slug]/about` page should NOT be a custom layout — it composes from primitives: `<MattLayout>`, `<CourseHeader>`, `<RoleTabBar>`, `<SubNav>`, `<Card>` primitives, etc., with URL data wired in. Page files become thin composition layers, not layout authors.

**Implication for the architectural questions already flagged.** This principle also resolves (or at least narrows) several earlier ⚠️ items:
- Header Bar slot carrying different content per breakpoint (§2.3 ⚠) → component with breakpoint-aware children prop or `variant` prop.
- Sub Nav inline-vs-drawer per breakpoint (§2.5 ⚠) → component with a `mode: 'inline' | 'drawer'` prop.
- Role Tab Bar with variable count of role tabs (§2.7) → component with `roles: Role[]` prop.

**Mapping to existing app.** Many primitives already exist (see §3 — `RoleBadge`, `ExploreTabBar`, `Breadcrumbs.astro`, etc.). The `/matt/*` work is largely re-skinning these with Matt's tokens, NOT building new components from scratch. Full Matt-component → existing-React/Astro-component mapping table is a sub-deliverable of [MATT-PRE-PLAN] (#10).

### Implications for component architecture

- Most non-trivial display + action components will take an `activeRole` input and render conditionally — **but this is already true in the existing app**; we don't need to invent it.
- The **Role Tab Bar** (Peerloop extension) visually represents existing role-context state; we don't design the role-context state itself.
- Role-encoding mechanism (URL / global / per-entity) — **whatever the existing codebase already does**; check before building the Role Tab Bar component, don't ask Matt.
- The Role Tab Bar will NOT appear in any of Matt's 31 happy-path screens (his design doesn't account for multi-role users at all); no visual spec from Matt. Extrapolate from his tokens + existing `ExploreTabBar` skeleton.
- **Matt's Control Bar** (separate primitive) = bottom-nav strip that appears on tablet portrait / mobile when Sidebar isn't shown. Different component, different layout slot — do not confuse with Role Tab Bar.

---

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

**Mapping:** `MattLayout.astro` is a visual re-skin of `AppLayout.astro`. `AppNavbar`'s role-based menu becomes Matt's sidebar visual (PeerLoop branding top, primary nav middle, Earnings/Notifications/Profile bottom).

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

## 4. Open Questions

Consolidated across the architectural review and source-doc review. Resolve during [MATT-PRE-PLAN] before token files are finalized.

**Visual / interaction:**

1. **Visitor flow on currently-Member-only pages.** Matt's design enumerates Visitor as a role. POLICIES §7 lists pages as Member-only (`/community`, `/courses`, etc.) that the middleware redirects to `/login`. Does Matt's design imply some of these should become Public-browsable for Visitors? Or does Visitor only see Public-browsable pages? — Likely the latter; confirm during [MATT-PRE-PLAN].
2. **Account dropdown.** Existing `UserMenu` component has role-based menu items (My Learning / My Teaching / Creator Studio / Settings / Sign Out). Where does this live in Matt's design? The Teacher screen sidebar shows the profile chip at the bottom — does it open this menu on click?
3. **Footer.** Existing app has `PublicFooter` / `GatedFooter`. Matt's screens don't show a footer. Decision needed: does Matt's design omit footers entirely, or is it just not shown in the happy-path screens?

**Structural:**

4. **Inner column grid inside Main Panel** — Matt's screens show flexible width content. Is there a fixed N-column inner grid, or is the Main Panel just fluid width with content blocks stacking naturally? **Working answer Conv 172 (Batch 4):** no formal grid; fluid-width content with primitives composing naturally. Verification pending — if a Matt populated-page frame shows a Figma layout-grid overlay, override this answer.
5. **Featured-course card on Home page** — is the dark hero on Home the same component as the full Course Header (just rendered in a smaller container), or a distinct "Featured Course" variant?
6. **Free Teacher badge on Teacher page** — green-tinted badge with "Schedule Live Session" CTA. Is this a Teacher state-variant (free vs paid) or a per-page badge component?
9. **Distinct Main Panel inner layouts** *(Conv 172 addition).* Matt's 31 happy-path screens contain multiple distinct inner-Main-Panel layout shapes: Home community feed; Course detail (Course Header + vertical Sub Nav + tab content); Teacher profile (Teacher Header + Sub Nav); Discover / Explore pages; possibly Settings, Admin, and others. The §2 layout-shell ASCII diagram captures only the Course-detail variant. How do we catalog and abstract these inner-shell layout variants for `MattLayout.astro` slot design? Likely: enumerate per-page-type during [MATT-PRE-PLAN], group by shape, identify shared primitives.

**Implementation** *(added Conv 172)***:**

8. **CSS length units.** What units should the token system use? Tailwind 4 natively uses indexed names + rem values (`--spacing-1: 0.25rem`). We've chosen pixel NAMES (Conv 172 — `--space-4`), but unit-VALUES are orthogonal:
   - **Pure px:** concrete, predictable, matches measurements. No accessibility scaling.
   - **Pure rem:** accessibility-correct (respects user font-size). Creates awkward `--space-4: 0.25rem` mapping.
   - **Hybrid:** rem for typography + spacing, px for borders + UI hairlines. Common design-system convergence.

   Decision affects all of `tokens-primitives.css` — wrong call means a global find-replace later. Token NAMES are decided (pixel-named, Conv 172) — this is about VALUES.

**Designer-side:**

7. **Typo to flag with Matt:** Teacher page says "**Exertise**" — should be "**Expertise**".

---

## 5. Color Primitives

### Variable Collection Inventory (Conv 172, [TSV] refined Conv 181)

Matt's Figma Local Variables panel exposes 5 collections. Documenting them here so future extraction work has a complete picture:

| Collection | Matt's count | Documented in this doc | Gap |
|---|:---:|:---:|:---:|
| Button | 3 (× 6 modes = 18 cells) | 3 (table below) | 0 (closed Conv 172) |
| Color Primitives | 13 verified + 2 speculative | 15 (table below) | 0 (closed Conv 172; 2 reclassified Conv 181) |
| Color Semantics | 12 verified + 2 speculative | 14 (table below) | 0 (closed Conv 172; 2 reclassified Conv 181) |
| Entity | 2 (× 4 modes = 8 cells) | 2 (table below) | 0 (closed Conv 172) |
| Icon Size | 1 (× 2 modes) | 1 (table below) | 0 (closed Conv 172) |
| **Typography** *(Conv 181 addition)* | **18 (8 Body + 10 Header)** | **18 (§6 Batch 1)** | **0 (closed Conv 181 [TSV])** |

**Total: 35 + 18 = 53 variables across 6 collections.** No Spacing / Sizing / Layout collection exists — confirmed Conv 172. See §6 Batch 3.

**Conv 181 [TSV] reclassifications.** Visual sweep + `get_variable_defs` probe found no red/pink usage anywhere in Matt's current Figma pages. Two primitive entries (`alert light`, `carmine-red`) + two semantic entries (`Alert/Default`, `Alert/Light`) were retained as **speculative** scaffolding for Phase 6 [MATT-EXEC-EXT] alert/error UI extrapolation. Now isolated in dedicated "Speculative (Conv 172)" sub-blocks in `tokens-primitives.css` + `tokens-semantic.css` + `tokens-tailwind-bridge.css` with provenance comments. **NEW STANDING PRINCIPLE (Conv 181):** going forward, tokens are added ONLY when Matt has formalized them as Figma Variables — see `feedback_tokenize_only_matt_variables.md`. The speculative pattern is preserved (the 4 entries above) but NOT extended.

**🎉 All 6 collections fully documented (Conv 172 + Conv 181):**
- Color Primitives (13 verified + 2 speculative / 15 total)
- Color Semantics (12 verified + 2 speculative / 14 total)
- Button (3/3 × 6 modes = 18 cells)
- Entity (2/2 × 4 modes = 8 cells)
- Icon Size (1/1 × 2 modes = 2 cells)
- **Typography (18/18 — 8 Body + 10 Header)** *(Conv 181)*

**Variable-grid total: 47 + 18 = 65 mode-resolved cells across 53 base variables.** (Flat collections contribute their variable count directly; multi-mode collections contribute `variables × modes` cells.)

**[TSV] outcome (Conv 181):**
- Color primitives + semantics → 12 of 15 + 12 of 14 verified via `get_variable_defs(477:8502)` (Content/Happy/Home frame); 2+2 reclassified as speculative
- Typography → all 18 Variables extracted into `src/styles/tokens-typography.css` (124 lines, Conv 181); 5 from Home frame + 8 Body from 40:485 + 10 Header from 40:493
- Variable Mode confirmed live (Course context → Primary resolves to `#327D00`)
- Naming drift on `Primary/Default` was a false alarm — plugin-rendered label `Primary/Primary` was misleading; actual Variable name matches local
- **Remaining extraction work:** none — token extraction phase complete. [TSV] task closed.

---

### Documented Color Primitives

**All 15 entries extracted Conv 172** from direct inspection of Matt's Figma Local Variables panel — Color Primitives collection. (Initial 12 came from `tokens/color-guide-overview.png` in Conv 171; remaining 3 + naming corrections came from `docs/as-designed/figma-screenshots/variables-collections-list.png` and a follow-up Color Primitives navigation Conv 172.) Two pairs flagged as low-contrast and worth spot-checking. Sorted alphabetically by Matt's literal name (uppercase letters and spaces sort earlier per ASCII).

| Token name (Matt's Figma) | Hex | Notes |
|---|---|---|
| `alert light` ⚠ **speculative (Conv 181)** | `#FFDEE5` | **Conv 172 extrapolation; NOT in Matt's current Figma per Conv 181 [TSV] visual sweep + probe.** Light pink; retained for Phase 6 alert/error UI extrapolation. Isolated in `tokens-primitives.css` "Speculative" sub-block. Verify or remove during Phase 6 [MATT-EXEC-EXT]. |
| `americana-blue` | `#0777B6` | Used for `Primary > Primary` + `Student > Primary` + `Text > Primary` semantics |
| `Ashy Blue` | `#EAEFF5` | Used for `Border > Default` semantic. ⚠ Naming: Matt uses Title Case WITH SPACE here (previously documented as `ashy-blue`). |
| `carmine-red` ⚠ **speculative (Conv 181)** | `#FF0038` | **Conv 172 extrapolation; NOT in Matt's current Figma per Conv 181 [TSV] visual sweep + probe.** Bright red; retained for Phase 6 alert/error UI extrapolation. Isolated in `tokens-primitives.css` "Speculative" sub-block. Verify or remove during Phase 6 [MATT-EXEC-EXT]. |
| `dark-green` | `#327D00` | Used for `Course > Primary` semantic |
| `gray-100` | `#F1F1F1` | — |
| `gray-600` | `#767676` | Used for `Text > Tertiary` semantic |
| `gray-base` | `#414141` | Used for `Text > Default` semantic — confirmed in Figma Variable export as `var(--Text-Default, #414141)` |
| `lavender-blue` | `#E0E8FF` | Used for `Creator > Background` semantic |
| `medium-green` | `#41A300` | — |
| `pastel-blue` | `#F1F9FF` | Used for `Primary > Light` + `Student > Background` semantics — ⚠ low-contrast, worth spot-checking |
| `pastel-green` | `#E8F4DF` | Used for `Course > Background` semantic — ⚠ low-contrast, worth spot-checking |
| `purple-blue` | `#584DF4` | Used for `Creator > Primary` semantic. **Conv 172 correction: previously documented as `#5840F4` (Conv 171 transcription typo). Figma's authoritative value is `#584DF4`.** |
| `vibrant-blue` | `#1586C5` | — |
| `white` | `#FFFFFF` | **NEW Conv 172** — basic white; used in Button Outlined mode background, Button Primary mode color |

**Naming convention inconsistency in Matt's primitives (Conv 172 finding):** Matt's 15 primitives use three different naming conventions within the same collection — kebab-case (`pastel-blue`, `dark-green`), Title Case with space (`Ashy Blue`), and lowercase with space (`alert light`). This is a Figma-side inconsistency that propagates to CSS variable naming. Decision needed during [MATT-PRE-PLAN]: honor Matt's literal names (problematic — CSS variables can't contain spaces) OR normalize to a single convention (recommended: kebab-case everywhere, with a mapping note for `Ashy Blue` and `alert light`). Tracked under [TSV].

**Implicit alert/error state support (Conv 172 finding — RETRACTED Conv 181):** Conv 172 initially reported that Matt's primitives included error/warning state colors (`alert light` + `carmine-red`). Conv 181 [TSV] visual sweep + `get_variable_defs` probe found NO red/pink usage anywhere in Matt's current Figma pages. The two entries are now classified as Conv 172 speculative extrapolation, NOT Matt-extracted. They are retained in `tokens-primitives.css` + `tokens-semantic.css` "Speculative" sub-blocks for Phase 6 [MATT-EXEC-EXT] scaffolding, but the `Alert/Background` + `Alert/Primary` semantic aliases are similarly speculative — confirm or remove during Phase 6 when Matt's alert/error UI lands.

### Color Semantics (all 14 entries extracted Conv 172)

Matt's Color Semantics is a 14-variable collection that references either primitives directly OR other semantics (creating a 2-layer indirection pattern — see finding below). Sorted by Matt's Figma group structure (Creator / Student / Course / Text / Border / Primary / Alert):

| Semantic | Direct reference | Resolves to (if indirect) |
|---|---|---|
| **Creator/Primary** | `purple-blue` | `#584DF4` |
| **Creator/Background** | `lavender-blue` | `#E0E8FF` |
| **Student/Primary** | `Primary/Default` *(semantic)* | → `americana-blue` (`#0777B6`) |
| **Student/Background** | `Primary/Light` *(semantic)* | → `pastel-blue` (`#F1F9FF`) |
| **Course/Primary** | `dark-green` | `#327D00` |
| **Course/Background** | `pastel-green` | `#E8F4DF` |
| **Text/Default** | `gray-base` | `#414141` |
| **Text/Tertiary** | `gray-600` | `#767676` |
| **Text/Primary** | `Primary/Default` *(semantic)* | → `americana-blue` (`#0777B6`) |
| **Border/Default** | `Ashy Blue` | `#EAEFF5` |
| **Primary/Default** | `americana-blue` | `#0777B6` |
| **Primary/Light** | `pastel-blue` | `#F1F9FF` |
| **Alert/Default** ⚠ **speculative (Conv 181)** | `carmine-red` *(speculative)* | `#FF0038` |
| **Alert/Light** ⚠ **speculative (Conv 181)** | `alert light` *(speculative)* | `#FFDEE5` |

**2-layer indirection pattern (Conv 172 finding — load-bearing).** Three semantics (`Student/Primary`, `Student/Background`, `Text/Primary`) reference ANOTHER semantic rather than a primitive directly. The cascade: `Student/Primary → Primary/Default → americana-blue`. The pattern's purpose: changing the brand-primary value at `Primary/Default` propagates automatically to all downstream semantics, preserving design coherence without manual updates.

**Implementation rule (Conv 172 decision):** Preserve this cascade in our CSS variable system. Author:

```css
--Primary-Default: var(--americana-blue);
--Student-Primary: var(--Primary-Default);   /* indirect — preserves cascade */
--Text-Primary:    var(--Primary-Default);   /* indirect — preserves cascade */
```

NOT:

```css
--Student-Primary: var(--americana-blue);    /* WRONG — flattens cascade */
--Text-Primary:    var(--americana-blue);    /* WRONG — flattens cascade */
```

The cascade IS the value of the semantic layer; flattening it destroys design coherence.

**Conv 171 misclassification corrected (Conv 172):** The previous "Entity (composite — used for entity badges)" line has been REMOVED from this section. Entity is a separate Figma Variable collection (2 vars, see §5 Variable Collection Inventory above). It will be documented when we extract that collection.

**Conv 171 sub-key naming corrected (Conv 172):** The previous doc had `Primary/Primary` as a sub-key. Matt's actual sub-key is `Primary/Default`. Corrected throughout.

**Naming convention (Conv 172 refinement):** Matt's Color Semantics use **Title Case with slash separator** (`Text/Default`, `Course/Background`, `Alert/Light`) — consistent throughout this collection. CSS variables can't contain slashes, so the conversion is `Text/Default` → `--Text-Default`. This preserves Title Case and is unambiguous to paste-back from Figma Dev Mode. The Color PRIMITIVES naming is more chaotic (see naming-inconsistency note above the primitives table). **[TSV] tracks both naming questions.**

### Entity (multi-mode collection — extracted Conv 172)

Entity is a **2-variable, 4-mode collection** — same architectural pattern as the Button collection. The 2 variables (`Primary` and `Background`) take different values depending on which mode is active. This is the mechanism Matt uses to let entity-typed components inherit role-context colors automatically.

|  | **Default** | **Creator** | **Student** | **Course** |
|---|---|---|---|---|
| **Primary** | `Text/Default` *(semantic, → `gray-base` `#414141`)* | `Creator/Primary` *(semantic, → `purple-blue` `#584DF4`)* | `Student/Primary` *(semantic, → `Primary/Default` → `americana-blue` `#0777B6`)* | `Course/Primary` *(semantic, → `dark-green` `#327D00`)* |
| **Background** | `gray-100` *(primitive, `#F1F1F1`)* | `Creator/Background` *(semantic, → `lavender-blue` `#E0E8FF`)* | `Student/Background` *(semantic, → `Primary/Light` → `pastel-blue` `#F1F9FF`)* | `Course/Background` *(semantic, → `pastel-green` `#E8F4DF`)* |

**3-layer cascade (Conv 172 finding — extends the 2-layer pattern from Color Semantics).** Student's chain is the longest: `Entity/Primary[Student] → Student/Primary → Primary/Default → americana-blue` (3 indirection hops to the primitive). Creator / Course / Default modes have 2 hops because their semantics reference primitives directly. The full token graph layered:

```
Primitive          Semantic              Entity-mode (context-resolved)
(physical hex)     (role-aliased)        (consumed by entity-typed components)
─────────────      ───────────────       ──────────────────────────────────
americana-blue  ←  Primary/Default   ←   Entity/Primary[Student]
                                          (via Student/Primary)
purple-blue     ←  Creator/Primary   ←   Entity/Primary[Creator]
dark-green      ←  Course/Primary    ←   Entity/Primary[Course]
gray-base       ←  Text/Default      ←   Entity/Primary[Default]
gray-100        ←  (none)            ←   Entity/Background[Default]
```

(Default mode for Background skips the semantic layer and references `gray-100` directly — minor inconsistency in Matt's design but not blocking.)

**Implementation rule (CSS variables with mode-switching):**

```css
/* Default mode at :root */
:root {
  --Entity-Primary:    var(--Text-Default);
  --Entity-Background: var(--gray-100);
}

/* Entity-context modifiers — parent container sets the mode via class */
.entity-creator {
  --Entity-Primary:    var(--Creator-Primary);
  --Entity-Background: var(--Creator-Background);
}
.entity-student {
  --Entity-Primary:    var(--Student-Primary);     /* preserves 2-layer cascade */
  --Entity-Background: var(--Student-Background);
}
.entity-course {
  --Entity-Primary:    var(--Course-Primary);
  --Entity-Background: var(--Course-Background);
}
```

Child components consume `var(--Entity-Primary)` and `var(--Entity-Background)` blindly — they don't need to know which entity they're in. The class on a parent container switches the values cascading down.

**⚠ Conv 176 caveat — cascade does NOT propagate through Tailwind 4 `@theme` intermediate utilities.** Empirically, when a child consumes the entity color through Tailwind 4 utilities (`bg-entity-background`, `text-entity-primary`) generated by the `@theme` bridge (`--color-entity-background: var(--Entity-Background)` etc.), the override does NOT propagate — children render the `:root` default (`gray-100`, grey) regardless of the `.entity-student` / `.entity-course` parent class. Root cause unconfirmed (possibly Tailwind 4 inlining the value statically, or the `@theme`-generated `--color-*` indirection resolving once at `:root` time). Tracked as [CASCADE-BROKEN] task #28. Direct consumption of `var(--Entity-Background)` in handwritten CSS (e.g., `.matt-card { background: var(--Entity-Background); }`) is **expected** to still propagate correctly because the resolution happens at use-site — but this has not been verified post-Conv 176.

**Working rule until [CASCADE-BROKEN] resolves:** matt/* primitives that need active-state entity coloring use direct per-entity Tailwind utilities (`bg-student-background`, `text-creator-primary`, etc.) keyed off an `entity` prop — same six-variant pattern as `Button.tsx`. The `.entity-*` cascade described in this section is reserved for components that consume Matt CSS variables directly without going through the Tailwind bridge (e.g., `entity/CourseHeader.astro`); those need separate verification. See DEVELOPMENT-GUIDE.md §"Direct Entity Tailwind Utilities in matt/* Primitives (Conv 176)" for the pattern and `src/components/matt/ui/Module.tsx` / `ToDoItem.tsx` for examples.

**Architectural implication.** This is the missing mechanism for how §2.4's "Entity-typed page headers" (Course Header, Teacher Header, Student Header) inherit role-context colors. Matt's `<CourseHeader>` doesn't hard-code `#327D00` — it consumes `--Entity-Primary`, and a parent `<MattLayout entity="course">` (or `.entity-course` class on the route) sets the mode. This is what makes the "Matt composes pages from reusable components" principle (§2) actually deliver on its promise of role-contextualized visuals without per-component variant proliferation. **Subject to [CASCADE-BROKEN] verification** — if CourseHeader-style components also fail to propagate, the cascade mechanism may need to be retired in favor of explicit per-entity utilities everywhere.

**Same multi-mode pattern appears in Button** (6 modes × 3 properties — see `variables-button-collection.png`). The unified architectural finding: **Matt uses multi-mode Figma Variables to encode context-aware token resolution.** It's the design system's mechanism for context inheritance.

### Icon Size (multi-mode collection — extracted Conv 172)

Icon Size is a **1-variable, 2-mode collection** — the simplest multi-mode pattern in Matt's design. The `Size` variable takes a different numeric value depending on mode.

|  | **Medium** | **Small** |
|---|:---:|:---:|
| **Size** | `24` | `20` |

Both values land on the 4-base spacing scale — they match `--space-24` and `--space-20` from §6 Batch 3. Matt has formalized only 2 icon sizes — no Large or XL.

**Mapping to existing React icons (§3 reference).** The current convention is `({ className = 'h-5 w-5' }: IconProps)`. Tailwind's `h-5 w-5` resolves to `1.25rem = 20px`, which corresponds to Matt's **Small** mode. So the existing app currently defaults to Small icons. When re-skinning for `/matt/*`, the explicit size choice should be:

- **Medium (24px)** for primary navigation icons (Mobile Header Bar mail/bell, Mobile Control Bar nav icons, Tablet Portrait Control Bar icons), prominent action buttons, entity-header CTAs.
- **Small (20px)** for inline / secondary icons (text-row affordances, badges, inline meta indicators).

**Implementation rule (CSS variables):**

```css
:root {
  --Icon-Size-Medium: 24px;  /* matches --space-24 */
  --Icon-Size-Small:  20px;  /* matches --space-20 */
}
```

For the existing React icon convention, either:

- Change the default prop from `'h-5 w-5'` (20px) to `'h-6 w-6'` (24px = Matt's Medium) — makes Medium the default
- Or keep Small default and explicitly opt into Medium at each prominent-icon callsite via `className="h-6 w-6"` (or a `size="md"` prop)

This is a one-line change in the icon component but a system-wide consequence. Decision tracked under [TSV] / [MATT-PRE-PLAN].

### Button (multi-mode collection — extracted Conv 172)

Button is a **3-variable, 6-mode collection** — Matt's largest multi-mode collection (18 mode-resolved cells). The 3 variables (`Background`, `Color`, `Border`) take different values depending on which mode is active.

|  | **Primary** | **Outlined** | **Course** | **Student** | **Creator** | **Default** |
|---|---|---|---|---|---|---|
| **Background** | `Text/Primary`<br>→ `#0777B6` | `white`<br>→ `#FFFFFF` | `Course/Background`<br>→ `#E8F4DF` | `Student/Background`<br>→ `#F1F9FF` | `Creator/Background`<br>→ `#E0E8FF` | `gray-100`<br>→ `#F1F1F1` |
| **Color** | `white`<br>→ `#FFFFFF` | `Text/Primary`<br>→ `#0777B6` | `Course/Primary`<br>→ `#327D00` | `Student/Primary`<br>→ `#0777B6` | `Creator/Primary`<br>→ `#584DF4` | `Text/Default`<br>→ `#414141` |
| **Border** | `Primary/Default`<br>→ `#0777B6` | `Primary/Default`<br>→ `#0777B6` | `Course/Background`<br>→ `#E8F4DF` | `Student/Background`<br>→ `#F1F9FF` | `Creator/Background`<br>→ `#E0E8FF` | `gray-100`<br>→ `#F1F1F1` |

**Resolved hex values shown for visual review only.** The first line in each cell is Matt's actual variable reference; the second line is the hex it resolves to after walking the cascade through §5 Color Semantics + Color Primitives. **Implementation MUST use the cascade chain via `var()`, NOT the literal hex** — the cascade is the design system's resilience (per the 2-layer indirection finding in §5 Color Semantics). Flattening loses propagation.

**Seamless-edge pattern (Conv 172 finding — load-bearing design choice).** In the Border row, the role-themed modes (Course / Student / Creator) and Default mode use the **same value** for Background AND Border — creating an invisible border, soft pill aesthetic. Only the brand modes (Primary / Outlined) have a visible border via `Primary/Default`. This means Matt's Button has **two visual personalities**:

- **Definitive CTAs** — Primary (filled blue) and Outlined (white-with-blue-outline) — for brand-level actions like "Enroll", "Sign Up", "Submit".
- **Soft pills** — Course / Student / Creator / Default — invisible border, context-tinted background — for inline / contextual actions like "Add to favorites" within a Course Header, "Follow" within a Teacher card.

The Button component re-skin during [MATT-PRE-PLAN] should preserve this dual-archetype distinction, not flatten it into "just pick a color."

**Implementation rule (CSS variables with variant-class switching):**

```css
.button {
  background: var(--Button-Background);
  color: var(--Button-Color);
  border: 1px solid var(--Button-Border);
}

.button-primary {
  --Button-Background: var(--Text-Primary);
  --Button-Color:      var(--white);
  --Button-Border:     var(--Primary-Default);
}
.button-outlined {
  --Button-Background: var(--white);
  --Button-Color:      var(--Text-Primary);
  --Button-Border:     var(--Primary-Default);
}
.button-course {
  --Button-Background: var(--Course-Background);
  --Button-Color:      var(--Course-Primary);
  --Button-Border:     var(--Course-Background);   /* seamless edge */
}
.button-student {
  --Button-Background: var(--Student-Background);
  --Button-Color:      var(--Student-Primary);
  --Button-Border:     var(--Student-Background);  /* seamless edge */
}
.button-creator {
  --Button-Background: var(--Creator-Background);
  --Button-Color:      var(--Creator-Primary);
  --Button-Border:     var(--Creator-Background);  /* seamless edge */
}
.button-default {
  --Button-Background: var(--gray-100);
  --Button-Color:      var(--Text-Default);
  --Button-Border:     var(--gray-100);            /* seamless edge */
}
```

**React component shape:**

```tsx
type ButtonVariant =
  | 'primary'      // brand CTA — filled blue, visible border
  | 'outlined'     // brand CTA — white fill, visible blue border
  | 'course'       // soft pill — course-themed, seamless edge
  | 'student'      // soft pill — student-themed, seamless edge
  | 'creator'      // soft pill — creator-themed, seamless edge
  | 'default';     // soft pill — neutral gray, seamless edge

interface ButtonProps {
  variant?: ButtonVariant;  // default: 'primary'
  children: React.ReactNode;
  onClick?: () => void;
  disabled?: boolean;
}
```

The component just toggles `className={\`button button-${variant}\`}` and the CSS variables resolve. No per-mode logic in the component body — that's the value of the multi-mode pattern.

**Pattern note.** The Default mode (`Text/Default` + `gray-100`) mirrors Entity's Default mode (also `Text/Default` + `gray-100`). Matt uses a consistent neutral-fallback for the "no role context" case across multi-mode collections.

### Multi-mode collection pattern (Conv 172 — unified architectural finding)

With Icon Size closed, Matt's full multi-mode use across his 5 collections is visible:

| Collection | Type | Modes | Variables | Purpose |
|---|---|---|---|---|
| Button | multi-mode | 6 (Primary / Outlined / Course / Student / Creator / Default) | 3 (Background / Color / Border) | Component variants |
| Entity | multi-mode | 4 (Default / Creator / Student / Course) | 2 (Primary / Background) | Role-context inheritance |
| Icon Size | multi-mode | 2 (Medium / Small) | 1 (Size) | Sizing variant |
| Color Primitives | flat | — | 15 | Value layer (hex codes) |
| Color Semantics | flat (grouped) | — | 14 | Aliased role colors |

**Pattern:** multi-mode collections are for **context / variant / size switching**. Flat collections are the **value-layer foundation**. Translates to CSS variable cascade scoped by class (Entity), discrete named variables (Icon Size), or component prop unions (Button).

---

## 6. Token Extraction & Scaffolding (Working Section)

🚧 **In progress.** Two activities coexist in this section:

1. **Matt-extraction** (Batches 1–5): pull values from Matt's Figma file where he formalized them.
2. **Scaffolding** (Batches 6–10): for token types Matt did NOT formalize, adopt a complete standard scale from day 1 with Matt's observed values flagged inside for later tuning.

### Token Scaffolding Policy (Conv 172) — narrowed by Conv 181 principle

For any token type Matt did NOT formalize as Figma Variables, we adopt a **complete standard scale from day 1** rather than waiting for Matt to fill gaps. Token NAMES are the stable interface; VALUES are tuneable. Reasoning:

- Extrapolation to ~84 unseen pages requires values Matt never specified.
- Tailwind 4 alignment (Peerloop's CSS framework) lights up `p-1` / `p-2` / etc. utilities for free.
- Matt's observed values fit cleanly inside the standard scales.
- Matt-extracted values are flagged within each scale so a future Matt-feedback pass can tune specifically those without disrupting names.

**Decisions (Conv 172):**

1. **Adopt complete 4-base scale** (Tailwind-aligned) from day 1 — values can change later.
2. **Pixel-named tokens** where the value is a single pixel measurement (`--space-4` = 4px, `--radius-8` = 8px). Semantic names for compound values (shadows). Percentage-named for opacity (`--opacity-50` = 0.50). Level-named for z-index (`--z-30` = 30). Ms-named for durations (`--duration-300` = 300ms).
3. **Snap policy:** Matt's measurements within 1-3px of a scale value are snapped to the scale value during extraction (e.g., 17px → 16, 23px → 24, 49px → 48). Documented per-batch with before/after for traceability.

After scaffolding is in place, a follow-up extraction pass examines each scaffolded type against Matt's actual usage and tunes specific token values where Matt's design implies a different value. Tracked as `[TSV]` in TodoWrite.

**Conv 181 narrowing — "tokenize only Matt's Variables" principle.** The Conv 172 policy above governs the *scaffolded scale categories* (spacing, radius, shadows, opacity, z-index, durations) — these stay scaffolded and Tailwind-aligned. But for *individual values that appear in Matt's design* (a specific color hex, a specific component dimension), Conv 181 established a standing rule: **a value becomes a token ONLY when Matt has formalized it as a Figma Variable** (verifiable via `get_variable_defs`). Otherwise the value is hardcoded inline at the consuming component, with the expectation that it migrates to a token only if/when Matt formalizes it.

Rationale: a hardcoded hex (e.g. Note's `#FFF6B8` background) breaks visibly in diff if Matt changes it; a named token (e.g. `--note-yellow`) accumulates stale meaning silently. The "honest-orphan" principle: the absence of a Figma Variable IS the signal NOT to tokenize. See `memory/feedback_tokenize_only_matt_variables.md` for the full rule + probe protocol + motivating case (Conv 181 [NOTE-YELLOW] — Note primitive's yellow + border + dimensions verified hardcoded in Matt's Figma, fixed inline in `Note.tsx` with no new tokens added).

**Implication for the §5 speculative entries.** The 4 entries (`alert light`, `carmine-red`, `Alert/Default`, `Alert/Light`) were added Conv 172 under the old policy. Per Decision 1 from Conv 181 they are preserved as historical scaffolding — but the pattern is NOT extended going forward.

### How to use this section

1. Open Matt's Figma file. Click the **`</>`** icon (top-right) to enter **Dev Mode**.
2. Click any element. The right-side Inspector panel shows CSS-ready values.
3. **Easiest source:** scroll the Inspector to the **Typography / CSS code block** (white box with numbered lines). Every value you need is there in `font-family: ...; font-size: ...;` format. Copy directly.
4. Fill in the blanks below. Replace `___` with the value you see.
5. If you can't find a value, leave `???` — CC will fill in a sensible default with a `/* TODO */` comment.
6. **Priority order:** Batch 1 → Batch 2 first (these unblock the token layer). Batches 3–5 are optimization.

**Stuck?** Screenshot the Figma Inspector panel and paste it back — CC can read off the values from the screenshot.

### Batch 1 — Typography ✅ EXTRACTED (Conv 181 [TSV])

**Status:** All 18 typography Variables extracted into `src/styles/tokens-typography.css` (Conv 181, 124 lines). 8 Body + 10 Header variables verified via `get_variable_defs` on Typography page (40:493 Headers section, 40:485 Body section) and Home frame (477:8502).

**Two leading regimes confirmed:**
- Body small (12-14px) + ALL Headers (14-32px) → `lh: 1` (100%), `ls: 0`
- Body large (16-20px) → `lh: 1.5` (150%), `ls: -2.2px`

**Weight conventions:** Regular = 400, "Medium" = 500, "Bold" / "Medium Bold" = 600 (Semi Bold). Header X Regular = 500 (NOT browser default 700) — `text-hN` utility forces Matt's Medium.

**Bridge consumption:** `tokens-tailwind-bridge.css` re-exports all 18 as Tailwind 4 compound utility classes via `--text-{name}--<modifier>` syntax. Each utility carries size + weight + line-height + letter-spacing in one class:
- Body: `text-body-default`, `text-body-default-medium`, `text-body-small`, `text-body-small-medium`, `text-body-medium`, `text-body-medium-bold`, `text-body-large`, `text-body-large-medium`
- Headers: `text-h1` through `text-h5` (Medium 500) + `text-h1-bold` through `text-h5-bold` (Semi Bold 600)

**Source reference (preserved for historical context):** raw values copied from the `Headers` frame and the `Body` frame (both tagged "Ready for dev" in green). Original form-style block kept below for traceability.

**What to do** *(now historical — extraction complete)*: ~~Click each text sample. Inspector shows `font-family`, `font-size`, `font-weight`, `line-height`, `letter-spacing` in CSS format. Copy values into the blanks.~~

#### Headers

```
Header 1:
  font-family:    Inter
  font-size:      32px
  font-weight:    500
  line-height:    normal
  letter-spacing: (not shown — skip)
  color-token:    var(--Text-Default, #414141)   ← bonus: Matt uses Figma Variables

Header 1 Bold:
  font-weight:    600 (only need weight — rest matches Header 1)

Header 2:
  font-size:      24px
  font-weight:    500
  line-height:    normal

Header 2 Bold:
  font-weight:    600

Header 3:
  font-size:      20px
  font-weight:    500
  line-height:    normal

Header 3 Bold:
  font-weight:    600

Header 4:
  font-size:      16px
  font-weight:    500
  line-height:    normal

Header 4 Bold:
  font-weight:    600

Header 5:
  font-size:      14px
  font-weight:    500
  line-height:    normal

Header 5 Bold:
  font-weight:    600
```

#### Body

```
Body Default:
  font-family:    same (skip if same as Header 1 — just write "same")
  font-size:      14px
  font-weight:    400
  line-height:    normal

Body Default Medium:
  font-weight:    500

Body Small:
  font-size:      12px
  font-weight:    400
  line-height:    normal

Body Small Medium:
  font-weight:    500

Body Medium:
  font-size:      16px
  font-weight:    400
  line-height:    150% *24px*
  letter-spacing: -0.352px

Body Medium Bold:
  font-weight:    600

Body Large:
  font-size:      20px
  font-weight:    400
  line-height:    150% *24px*
  letter-spacing: -0.352px

Body Large Medium:
  font-weight:    500
```

### Batch 2 — Layout dimensions

**Where:** The four page-structure frames (`Desktop + Tablet Landscape`, `Tablet Nav Collapsed > 1025`, `Tablet Portrait page structure <= 1024`, `Mobile page structure <= 640px`) plus the helper frames `Header Bar`, `Control Bar`, `Sidebar Width`, `Navigation Width`, `Page Padding`.

**What to do:** Select a frame or element. The W (width) and H (height) values are at the top of the Inspector. For padding/gutters, _hover_ over the spacing between elements — Figma highlights the gap in pink with the px value.

#### Desktop (≥1025px)

```
Shell architecture: Two-panel — Sidebar (left, persistent) + Main Panel (right).
                    Primary nav lives in the Sidebar. Matt's Control Bar primitive
                    is NOT present at this breakpoint (it's the tablet/mobile
                    bottom-nav substitute for the absent Sidebar).

Sidebar width (expanded):    220px
Sidebar width (collapsed):   70px
Navigation width:            same as Sidebar (Matt uses both terms interchangeably)

Inside the Main Panel (top to bottom):

Header Bar height:           40px (thin breadcrumb / back-nav strip
                              at top of Main Panel; e.g. "Home / Community" or
                              "← Home / Creator Profile". NOT a global top nav.)
Entity Header height:        40px (varies by entity — Course / Teacher / Creator;
                              measure per entity type)
Role Tab Bar height:         ~36px (guess, as no examples from Matt) (Peerloop extension — inside Main Panel between
                              Entity Header and Sub Nav row; renders only when the
                              current user has multiple roles for the entity. See [RTB].)
Sub Nav width (vertical):    196px (left-edge tab strip inside Main Panel —
                              Course Feed / About / Sessions / Reviews / Resources / Teachers)

NOT present at this breakpoint:
Control Bar:                 absent on desktop. Matt's `components/Control Bar.svg`
                              primitive is the bottom-nav strip used on tablet portrait
                              and mobile (see those breakpoints below).

Outer dimensions:

Page Padding (outer gutter): 16px
Gutter between Sidebar and Main Panel (horizontal): 16px
Main content max-width:      not specified in Figma. **Asked Matt** (Conv 172) — awaiting answer.
                              NON-BLOCKING: fall back to fluid width (fills the Main Panel
                              width remaining after the Sidebar) until Matt confirms a cap.
```

#### Tablet Portrait (≤1024px)

```
Shell architecture:      Single-column — Sidebar is REPLACED (not collapsed/drawered).
                         Layout-shell swap at the 1024px boundary. Matt's Control Bar
                         (primary-nav primitive) substitutes for the absent Sidebar by
                         occupying the bottom-of-viewport slot.

Top of viewport:

  Header Bar height:     24px
  Header Bar content:    PeerLoop brand (∞-style logo + "PeerLoop" wordmark, centered)
  Header Bar positioning: position: fixed; left: auto; right: auto; top: 48px;
                         (sits 48px below viewport top — the 48px is page-padding-top,
                         not another element)
  ⚠ Note: On Desktop the Header Bar slot carries breadcrumb ("Home / Community"); on
    Tablet Portrait it carries brand content. Possibly Matt reuses the slot label for
    different content per breakpoint, OR brand strip ≠ Header Bar and breadcrumb is
    omitted entirely at this breakpoint. Confirm during [MATT-PRE-PLAN].

Bottom of viewport:

  Control Bar height:    48px
  Control Bar content:   Floating pill, 6 nav icons centered —
                         Home / Saved / Courses (grad-cap) / Messages / Notifications / To-Do (checklist).
                         Active icon: blue with soft circular background tint.
                         Inactive icons: dark monochrome.
  Control Bar positioning: position: fixed; left: auto; right: auto; bottom: 48px;
                         (sits 48px above viewport bottom — the 48px is page-padding-bottom)

Inside the Main Panel (between Header Bar and Control Bar):

  Entity Header height:  ??? (likely matches Desktop; confirm)
  Role Tab Bar:          ??? (Peerloop extension — responsive treatment TBD. On Desktop
                         it sits inside Main Panel between Entity Header and Sub Nav.
                         With narrower content area here, may need inline-scroll, drawer,
                         or stacked treatment. Tracked in [RTB].)
  Sub Nav:               ??? (vertical-left tab strip — same as Desktop, narrower?)

Outer dimensions:

Page Padding:            top/bottom: 48px, left/right: 168px
```

**Architectural note (Conv 172):** This is a **layout-shell swap**, not a responsive sidebar collapse. `MattLayout.astro` will need a breakpoint-driven branch at 1024px:

- Above 1024px → two-panel (Sidebar + Main Panel, per §2)
- At/below 1024px → single-column with top brand strip + bottom tab bar overlays, both `position: fixed`

Note that the Header Bar slot is reused across breakpoints but carries DIFFERENT CONTENT — breadcrumb on desktop, brand strip on tablet portrait (flagged ⚠ inline above). The Control Bar primitive is NOT a desktop component at all; it appears only at this breakpoint and below, substituting for the absent Sidebar. (Promoted to §2 Architectural Findings Conv 172.)

#### Mobile (≤640px)

```
Shell architecture:      Single-column (same shell-swap pattern as Tablet Portrait —
                         Sidebar REPLACED, Matt's Control Bar occupies the bottom slot).
                         RESTRUCTURED nav distribution: Messages and Notifications move
                         FROM the bottom Control Bar TO the top Header Bar (4 icons in
                         bottom pill vs 6 on Tablet Portrait). Header Bar gains nav
                         children — it's no longer just a brand strip at this breakpoint.

Top of viewport:

  Header Bar height:     44px
  Header Bar content:    3-slot horizontal layout:
                           LEFT:    Envelope icon (Messages, monochrome)
                           CENTER:  ∞-style logo + "PeerLoop" wordmark
                           RIGHT:   Bell icon (Notifications, monochrome)
  Header Bar positioning: not specified in Figma (position: not specified; top: 17px; Left/right padding 20px)

Bottom of viewport:

  Control Bar height:    49px
  Control Bar content:   Floating pill assumed (not specified in Figma), 4 nav icons evenly spaced —
                           Home (active, blue with soft circular tint) /
                           Saved (bookmark) / Courses (grad-cap) / To-Do (checklist).
                         Messages and Notifications NOT here — moved to Header Bar.
  Control Bar positioning:  (position: not specified in Figma; bottom: 23px; Left/right: 24px)

Inside the Main Panel:

  Entity Header height:  not shown as a frame (likely matches Desktop / Tablet Portrait; confirm)
  Role Tab Bar:          ??? (responsive treatment — even tighter than Tablet Portrait;
                         likely needs inline-scroll or stacked treatment. See [RTB].)
  Sub Nav:               intent by Matt is a slide-in NavBar from left (vertical-left strip in tight space; may collapse to
                         horizontal scroll or dropdown)

Outer dimensions:

Page Padding:            not specified. Header bar and control bar have different paddings from viewport. L/R ~16-20px (visual estimate — much tighter than Tablet
                         Portrait's 168px since viewport is narrower);
                         top/bottom: ??? (needs Dev Mode)
```

### Batch 3 — Spacing scale

**Where:** Any layout frame. Also check Figma's left panel for a **Variables** or **Local Styles** section — Dev Mode often lists all spacing tokens in one place.

```
**Status:** Matt did NOT formalize spacing as Figma Variables (Conv 172). His Local Variables panel shows 5 collections — Button, Color Primitives, Color Semantics, Entity, Icon Size — none for spacing. Per §6 Token Scaffolding Policy, we adopt the full Tailwind-aligned 4-base scale.

**Working scale (Conv 172 — full extrapolated, pixel-named, snap policy applied):**

| Token name | Value | Source |
|---|---|---|
| `--space-4` | 4px | scaffolded (no Matt evidence) |
| `--space-8` | 8px | scaffolded (no Matt evidence) |
| `--space-12` | 12px | scaffolded (no Matt evidence) |
| `--space-16` | 16px | ✓ Matt-extracted — Desktop Page Padding + Sidebar↔Main gutter; has its own SVG in `.scratch/matt-main/` |
| `--space-20` | 20px | ✓ Matt-extracted — Mobile Header Bar L/R padding; has its own SVG |
| `--space-24` | 24px | ✓ Matt-extracted — Tablet Portrait Header Bar height; Mobile Control Bar L/R offset |
| `--space-32` | 32px | scaffolded (no Matt evidence) |
| `--space-40` | 40px | scaffolded (no Matt evidence) |
| `--space-48` | 48px | ✓ Matt-extracted — Tablet Portrait Control Bar height; Page Padding top/bottom; Header Bar top offset; Control Bar bottom offset |
| `--space-64` | 64px | scaffolded (no Matt evidence) |

**Snap policy applied to Matt's off-scale Mobile measurements (Conv 172):**

| Matt's raw value | Where measured | Snapped to | Delta | Notes |
|---|---|:---:|:---:|---|
| 17px | Mobile Header Bar top offset | `--space-16` | 1px | almost certainly eyeballing |
| 23px | Mobile Control Bar bottom offset | `--space-24` | 1px | almost certainly eyeballing |
| 44px | Mobile Header Bar height | `--space-48` | 4px | flag for [TSV] — could also be `--space-40` |
| 49px | Mobile Control Bar height | `--space-48` | 1px | 49 was likely 48 rounding drift |
| 168px | Tablet Portrait L/R Page Padding | NOT TOKENIZED | n/a | one-off centered-column outer gutter; stays as literal `168px`. Revisit during [MATT-PRE-PLAN] — could become a `--gutter-tablet-portrait` semantic token if reused. |

**Implementation note:** When writing `tokens-primitives.css`, define all 10 spacing tokens. The 4 Matt-confirmed values (`--space-16`, `--space-20`, `--space-24`, `--space-48`) are the highest-confidence; the 6 scaffolded values are starting points that [TSV] will tune.
```

### Batch 4 — Page structure (grid)

**Status (Conv 172):** No evidence of a formal multi-column grid in Matt's design. Working assumption: the Main Panel uses **fluid-width content with primitives composing naturally**, NOT a Bootstrap-style N-column grid.

**Evidence supporting "no formal grid":**
- The three page-structure frames (Desktop, Tablet Portrait, Mobile) show empty rectangles — no column overlay or guide rendered.
- Course detail screens compose Sub Nav (vertical-left strip, fixed-width) + content panel (right, flexible). That's a 2-shape primitive composition, not a 12-column grid.
- No "Grid" / "Columns" / "Layout" Figma Variable collection — confirmed Conv 172 via Local Variables panel inspection (only 5 collections, none grid-related).
- The "Matt composes pages from reusable components" principle (§2) implies layout comes from primitive composition rather than a system-wide column grid.

```
Page layout shape:    2-column at Desktop (Sidebar + Main Panel);
                      single-column at Tablet Portrait + Mobile (shell-swap to
                      top brand strip + bottom Control Bar).

Inner column grid:    NONE observed. Working assumption: fluid-width content with
                      primitives composing naturally.

If a page needs grid:  Use Tailwind's grid utilities ad-hoc (`grid grid-cols-N`)
                       for that specific shape (e.g. admin dashboards with
                       multi-column data tables). Do NOT define a system-wide
                       N-column scaffold.

Column count:          n/a (no global grid)
Gutter width:          n/a (use spacing tokens from Batch 3 ad-hoc — `--space-16`
                       between cards, `--space-24` for section gaps, etc.)
Max content width:     not specified in Figma; **asked Matt** (Conv 172, alongside
                       max-width question). NON-BLOCKING — fall back to fluid until
                       Matt confirms. See §6 Batch 2 Desktop for the same flag.
```

⚠ **Verification opportunity:** If a Matt populated-page frame (Home, Course detail, Teacher) shows a grid overlay in Figma (`Shift+G` toggles layout grids), capture a screenshot — Matt's intent overrides this assumption. Until then, treat "no formal grid" as the working answer. Resolves §4 Q4.

### Batch 5 — Role Tab Bar (Peerloop extension, NOT in Matt's design)

**Where to source from:** NOT Matt's Figma — Matt didn't draw this primitive. Re-skin target is `src/components/discover/ExploreTabBar.*` (Conv 042-044). Visual treatment extrapolates from Matt's tokens (typography from Batch 1, spacing from Batch 3 once filled, role-primary colors from §5).

```
Role Tab Bar appears: ONLY when the current user has multiple roles for the entity
                      being viewed. Tabs represent role perspectives, not page
                      sections. Roles: Teacher, Student, Visitor, Creator, Admin,
                      Moderator. Sub Nav sections remain stable across roles; the
                      CONTENT inside each section is role-filtered.

Position in layout shell: Inside the Main Panel, directly below the Entity Header
                          (Course/Teacher/etc.) and above the Sub-Nav-plus-content row.

Role Tab Bar height:  ??? (TBD during [RTB] design — extrapolate from existing
                      ExploreTabBar dimensions + Matt's spacing scale once Batch 3 done)

Responsive treatment: TBD — at tablet portrait / mobile, with narrower content area,
                      may need inline-scroll, drawer, or stacked treatment. Tracked in [RTB].
```

**Matt's Control Bar (separate primitive — note):** Matt's `components/Control Bar.svg` is the bottom-nav primary-nav strip used on tablet portrait (48px tall, captured in Batch 2) and mobile (TBD). It is NOT this Role Tab Bar. Different component, different layout slot, different function — do not confuse them. The earlier conflation is documented in §2 ⚠️ block.

### Batch 6 — Border Radius scaffold (Conv 172)

**Status:** Scaffolded with Tailwind-aligned defaults, pending Matt-extraction pass [TSV]. Matt's design uses rounded pill corners (Control Bar bottom pill on Tablet Portrait + Mobile) but exact radius values are not yet extracted.

| Token name | Value | Source |
|---|---|---|
| `--radius-0` | 0 | scaffolded |
| `--radius-2` | 2px | scaffolded |
| `--radius-4` | 4px | scaffolded |
| `--radius-6` | 6px | scaffolded |
| `--radius-8` | 8px | scaffolded |
| `--radius-12` | 12px | scaffolded |
| `--radius-16` | 16px | scaffolded |
| `--radius-24` | 24px | scaffolded |
| `--radius-full` | 9999px | scaffolded (pill / fully-rounded) |

⚠ [TSV] follow-up: extract Matt's specific radii for cards, buttons, modals, the floating Control Bar pill (almost certainly `--radius-full`), and any other rounded UI element.

### Batch 7 — Shadows scaffold (Conv 172)

**Status:** Scaffolded with Tailwind-aligned defaults (semantic naming, since shadows are compound values), pending Matt-extraction pass [TSV]. Matt's floating Control Bar pills clearly have shadow, but specific values not yet extracted.

| Token name | Value | Source |
|---|---|---|
| `--shadow-sm` | `0 1px 2px 0 rgb(0 0 0 / 0.05)` | scaffolded |
| `--shadow-md` | `0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1)` | scaffolded |
| `--shadow-lg` | `0 10px 15px -3px rgb(0 0 0 / 0.1), 0 4px 6px -4px rgb(0 0 0 / 0.1)` | scaffolded |
| `--shadow-xl` | `0 20px 25px -5px rgb(0 0 0 / 0.1), 0 8px 10px -6px rgb(0 0 0 / 0.1)` | scaffolded |
| `--shadow-2xl` | `0 25px 50px -12px rgb(0 0 0 / 0.25)` | scaffolded |
| `--shadow-inner` | `inset 0 2px 4px 0 rgb(0 0 0 / 0.05)` | scaffolded |
| `--shadow-none` | `none` | scaffolded |

⚠ [TSV] follow-up: extract Matt's shadow values on the floating Control Bar pills, modal overlays, dropdown menus, and any elevated card.

### Batch 8 — Opacity scaffold (Conv 172)

**Status:** Scaffolded with Tailwind-aligned defaults (percentage-named to match value), pending Matt-extraction pass [TSV].

| Token name | Value | Source |
|---|---|---|
| `--opacity-0` | 0 | scaffolded |
| `--opacity-5` | 0.05 | scaffolded |
| `--opacity-10` | 0.10 | scaffolded |
| `--opacity-20` | 0.20 | scaffolded |
| `--opacity-25` | 0.25 | scaffolded |
| `--opacity-30` | 0.30 | scaffolded |
| `--opacity-40` | 0.40 | scaffolded |
| `--opacity-50` | 0.50 | scaffolded |
| `--opacity-60` | 0.60 | scaffolded |
| `--opacity-70` | 0.70 | scaffolded |
| `--opacity-75` | 0.75 | scaffolded |
| `--opacity-80` | 0.80 | scaffolded |
| `--opacity-90` | 0.90 | scaffolded |
| `--opacity-95` | 0.95 | scaffolded |
| `--opacity-100` | 1 | scaffolded |

⚠ [TSV] follow-up: confirm whether inactive icon states (Header Bar / Control Bar) use opacity vs. a separate gray color. Most likely the latter (Matt's inactive icons are dark monochrome), but confirm.

### Batch 9 — Z-index scaffold (Conv 172)

**Status:** Scaffolded with Tailwind-aligned defaults (level-named to match Tailwind convention). Semantic mapping suggested — confirm during [MATT-PRE-PLAN].

| Token name | Value | Source |
|---|---|---|
| `--z-0` | 0 | scaffolded |
| `--z-10` | 10 | scaffolded |
| `--z-20` | 20 | scaffolded |
| `--z-30` | 30 | scaffolded |
| `--z-40` | 40 | scaffolded |
| `--z-50` | 50 | scaffolded |
| `--z-auto` | auto | scaffolded |

**Suggested semantic mapping** (confirm during [MATT-PRE-PLAN]):

- `--z-10`: Sticky elements (sticky headers, sticky breadcrumbs)
- `--z-20`: Dropdown menus, popovers, tooltips
- `--z-30`: Fixed Mobile/Tablet Portrait nav bars (Matt's Control Bar + Header Bar)
- `--z-40`: Sub Nav slide-in drawer (Mobile)
- `--z-50`: Modals, dialogs, top-level overlays

### Batch 10 — Animation Durations scaffold (Conv 172)

**Status:** Scaffolded with Tailwind-aligned defaults (ms-named to match value). Matt's design is static SVG, so timing is purely scaffolded — ALL values pending [MATT-PRE-PLAN] decision based on app feel.

| Token name | Value | Source |
|---|---|---|
| `--duration-75` | 75ms | scaffolded |
| `--duration-100` | 100ms | scaffolded |
| `--duration-150` | 150ms | scaffolded |
| `--duration-200` | 200ms | scaffolded |
| `--duration-300` | 300ms | scaffolded |
| `--duration-500` | 500ms | scaffolded |
| `--duration-700` | 700ms | scaffolded |
| `--duration-1000` | 1000ms | scaffolded |

**Suggested semantic mapping** (confirm during [MATT-PRE-PLAN]):

- `--duration-150`: Hover state transitions, button press feedback
- `--duration-200`: Dropdown open/close, popover fade
- `--duration-300`: Tab switches, drawer slide-in (Sub Nav Mobile), page-level transitions
- `--duration-500`: Modal/dialog appearance
- `--duration-1000`: Long-running progress indicators (loading states)

---

## Source Materials

Figma screenshots and other source artifacts used to extract values for this doc. All stored in `docs/as-designed/figma-screenshots/` (committed to git for traceability — when Figma is unavailable or Matt's file changes, the doc still reads as standalone evidence).

### Page-structure frames (Matt's responsive specs)

- `tablet-portrait-page-structure.png` *(Conv 172)* — Matt's "Tablet Portrait page structure <= 1024" frame. Source for §6 Batch 2 Tablet Portrait values (Header Bar positioning at `top: 48px`; Control Bar positioning at `bottom: 48px`; Page Padding 48px top/bottom + 168px L/R).
- `mobile-page-structure.png` *(Conv 172)* — Matt's "Mobile page structure <= 640px" frame, marked "Ready for dev" in Figma. Source for §6 Batch 2 Mobile values (3-slot Header Bar with Messages icon / brand / Notifications icon; 4-icon Control Bar with Messages and Notifications relocated to the Header Bar).

### Figma Variables modal

- `variables-collections-list.png` *(Conv 172)* — Full Local Variables modal showing all 5 collections + counts: Button (3), Color Primitives (15), Color Semantics (14), Entity (2), Icon Size (1). Source for §5 Variable Collection Inventory and the §6 Batch 3 conclusive finding (no Spacing collection exists; scaffold from Tailwind defaults instead).
- `variables-button-collection.png` *(Conv 172)* — Button collection detail showing 6 style modes (Primary / Outlined / Course / Student / Creator / Default) × 3 properties (Background / Color / Border) = 18 mode-resolved cells. Source for §5 Button section — closed the 3-entry gap; revealed the **seamless-edge pattern** (themed modes use same value for Background AND Border → invisible border, soft-pill aesthetic) and the **two button archetypes** (definitive CTAs vs. soft pills) that the React component design must preserve.
- `variables-color-primitives-collection.png` *(Conv 172)* — Color Primitives collection detail showing all 15 entries (Name + Value columns). Source for §5 Color Primitives table — closed the 3-entry gap (added `white`, `alert light`, `carmine-red`), fixed the `purple-blue` hex typo (`#5840F4` → `#584DF4`), and surfaced the naming-convention inconsistency (kebab-case / Title Case-with-space / lowercase-with-space mixed in one collection).
- `variables-color-semantics-collection.png` *(Conv 172)* — Color Semantics collection detail showing all 14 entries grouped by category (Creator / Student / Course / Text / Border / Primary / Alert) with their reference values. Source for §5 Color Semantics table — closed the 2-entry gap (added `Alert/Default`, `Alert/Light`), surfaced the **2-layer indirection pattern** (Student/Text reference `Primary/Default`, not primitives directly — load-bearing cascade), corrected the Conv 171 misclassification of "Entity" as a semantic (it's a separate collection), and corrected the `Primary/Primary` → `Primary/Default` sub-key name.
- `variables-entity-collection.png` *(Conv 172)* — Entity collection detail showing the multi-mode matrix: 2 variables (Primary / Background) × 4 modes (Default / Creator / Student / Course) = 8 cells. Source for §5 Entity section — closed the 2-entry gap; revealed Entity is a **multi-mode collection** (same pattern as Button) used for entity-typed components to inherit role-context colors via CSS variable cascade; extended the cascade to **3 layers** at peak (Student mode chains through Student/Primary → Primary/Default → americana-blue). Unified architectural finding: Matt uses multi-mode Figma Variables as the mechanism for context-aware token resolution.
- `variables-icon-size-collection.png` *(Conv 172)* — Icon Size collection detail showing the simplest multi-mode: 1 variable (Size) × 2 modes (Medium = 24, Small = 20). Source for §5 Icon Size section — closed the last (1-entry) gap; both values land on the 4-base spacing scale (`--space-24` and `--space-20`); surfaced the concrete finding that the existing React icon default (`h-5 w-5` = 20px) corresponds to Matt's Small mode (not Medium), with one-line consequences for the `/matt/*` re-skin. Final piece confirming the Multi-mode Collection Pattern as a system-wide Matt-design-system mechanism.

---

## Document Lineage

- **Conv 171:** Initial form created in `.scratch/matt-devmode-form.md` as token-extraction lookup; grew through architectural findings + strategic context + existing-app-context review; graduated to `docs/as-designed/matt-design-system.md` at end of Conv 171.
- **Conv 172:** Major refinement pass.
  - **§2 Architectural Findings:** generalized **Header Bar** from "thin breadcrumb" to "slot with breakpoint-varying content" (Desktop = breadcrumb; Tablet Portrait = brand strip; Mobile = brand + Messages + Notifications icons); generalized **Sub Nav** to breakpoint-varying (Desktop = vertical-left; Mobile = slide-in drawer); corrected **Control Bar** mis-attribution — Matt's Control Bar is the primary-nav bottom-pill primitive at tablet/mobile, NOT a role switcher; carved out **Role Tab Bar** as a Peerloop extension for multi-role users (Matt's design doesn't account for them); added **"Matt composes pages from reusable components"** meta-principle confirming the parameterized-component pattern.
  - **§4 Open Questions:** restructured + added Q8 (CSS length units — px/rem/hybrid) and Q9 (distinct Main Panel inner layouts).
  - **§5 Color Primitives:** added **Variable Collection Inventory** of Matt's 5 Figma collections (Button × 3, Color Primitives × 15, Color Semantics × 14, Entity × 2, Icon Size × 1); extracted ALL 35 variables Conv 172 — every collection closed via direct Figma navigation (Color Primitives, Color Semantics, Entity multi-mode matrix, Icon Size multi-mode matrix, Button multi-mode matrix with resolved-hex review row). Surfaced architectural findings: 2-layer + 3-layer cascade chains; multi-mode collection pattern unified across Button + Entity + Icon Size; seamless-edge Button pattern; dual button archetypes (definitive CTAs vs soft pills); Conv 171 typo + misclassification corrections (`purple-blue` `#5840F4` → `#584DF4`; `Primary/Primary` → `Primary/Default`; Entity removed from semantic aliases — it's a separate collection).
  - **§6 Token Extraction & Scaffolding:** renamed from "Token Extraction"; added **Token Scaffolding Policy** (snap policy + pixel-named tokens + complete-from-day-1); filled Batch 2 for all three breakpoints from user-supplied Figma screenshots; rewrote Batch 3 with full 10-token spacing scale + snap table; rewrote Batch 5 as Role Tab Bar (Peerloop extension); added scaffolding Batches 6–10 (Border Radius × 9, Shadows × 7, Opacity × 15, Z-index × 7, Animation Durations × 8).
  - **New § "Source Materials":** catalogues 4 Figma screenshots saved to `docs/as-designed/figma-screenshots/` (page-structure frames for Tablet Portrait + Mobile; Variables collections list + Button collection detail).
  - **TodoWrite additions:** `[RTB]` (design Role Tab Bar); `[TSV]` (verify scaffolded token values against Matt's design across spacing, radius, shadows, opacity, z-index, durations).
- **Conv 181:** [MMP-PH1] Phase 1 token foundation — completed [TSV] task on Color + Typography. Empirically refined [TSV] / token system findings:
  - **§5 Color Primitives + Color Semantics:** 13 of 15 primitives + 12 of 14 semantics verified via `get_variable_defs(477:8502)` (Content/Happy/Home frame). Two pairs (`alert light`/`carmine-red` + `Alert/Default`/`Alert/Light`) reclassified as **speculative Conv 172 extrapolation** after visual sweep confirmed no red/pink usage in Matt's current Figma. All 4 isolated into "Speculative (Conv 172)" sub-blocks in `tokens-primitives.css` + `tokens-semantic.css` + `tokens-tailwind-bridge.css`. Variable Mode confirmed live at the `get_variable_defs` layer (Course context → Primary resolves to `#327D00` dark-green). Naming-drift alarm on `Primary/Default` was false (plugin-rendered label artifact, not Variable name).
  - **§5 Variable Collection Inventory:** added 6th collection — **Typography (18 Variables = 8 Body + 10 Header)** — fully extracted into NEW file `src/styles/tokens-typography.css` (124 lines). Two leading regimes identified: Body small (12-14px) + Headers (14-32px) at `lh:1`/`ls:0`; Body large (16-20px) at `lh:1.5`/`ls:-2.2px`. Bridge re-exports all 18 via Tailwind 4's `--text-{name}--<modifier>` compound-utility syntax.
  - **§6 Token Scaffolding Policy:** narrowed by Conv 181's **"tokenize only Matt's Variables"** standing principle (`memory/feedback_tokenize_only_matt_variables.md`). Going forward, individual values become tokens ONLY if Matt has formalized them as Figma Variables (probe-verified via `get_variable_defs`); the scaffolded-scale policy (spacing/radius/shadows/etc.) is unchanged. Note primitive Conv 181 [NOTE-YELLOW] aligned to Matt's exact Figma spec (yellow `#FFF6B8`, border `#F1E9B0`, radius 8, padding 10, gap 10, exact shadow) with all values hardcoded inline — no new `--note-yellow` token.
  - **§6 Batch 1 Typography:** marked ✅ EXTRACTED. Original fill-in form preserved below for traceability.
  - **Variable Mode + MCP behavior:** also extended `memory/reference_figma_mcp_behavior.md` from 56→75 lines with two-tool-class distinction (selection-free vs. selection-required) and efficient batch-probing pattern.
  - **TodoWrite completed:** `[MMP-PH1]`, `[TSV]`, `[NOTE-YELLOW]`, `[MCP-DRIFT-180]`, `[MMP-PH0]`.

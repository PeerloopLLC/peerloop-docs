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

#### `/matt/course/[slug]/[...tab]` — implemented route shape (Conv 188 [MATT-EXEC-PG2])

The `/matt/*` re-skin of course tabs is a **catch-all rest route** mirroring the legacy `discover/course/[slug]/[...tab].astro` precedent:

- **File:** `src/pages/matt/course/[slug]/[...tab].astro` — catch-all tab route. `src/pages/matt/course/[slug]/index.astro` (the About tab, Conv 187) is left untouched and handles the bare base URL.
- **Tab guard:** `VALID_TABS = feed / modules / creator / teachers / reviews / resources`. An unrecognized tab segment 302-redirects to the course base URL.
- **Shell:** breadcrumb + `<SubNav>` + `<CourseHeader>` is duplicated across `index.astro` and `[...tab].astro` (per the chosen structure decision below); the per-tab body is selected by a `tab ===` switch.
- **Per-tab bodies:** each tab renders a dedicated body component in `src/components/matt/course/` (e.g. `ResourcesTab.astro`, `TeachersTab.astro`). Built tabs render the composite; unbuilt tabs render a placeholder.

**Structure decision (Conv 188, user-chosen Option A):** per-tab `.astro` body components rendered by the `tab ===` switch, shell duplicated across the two route files, `index.astro` (About) untouched. Chosen over extracting a shared `CourseTabShell` — lowest risk to just-validated Conv 187 work; mirrors the legacy discover precedent (shell duplicated in 2 route files). Shell duplication between `index.astro` and `[...tab].astro` is an accepted trade-off (flagged for future dedup if PG2 churns tabs).

**Tab body realities (Conv 188 probe).** Matt's course-tab frames are bespoke page-level **card composites** (SessionCard / ReviewCard / TeacherCard), not thin anchor-list shells — the Ready-for-Dev lookup's earlier "expected primitives" were inferences, not probes. Frames are happy-path instance snapshots of one demo course in a specific state (Resources = empty state; Modules = 2-session demo). Faithful building reproduces the drawn state; populated/other states are Phase-6 [MATT-EXEC-EXT] extrapolation. Remaining tabs ([CRTTAB] [RVWTAB] [MODTAB]) are tracked in PLAN.md.

**Modules domain model (Conv 188 decision).** Session↔Module is **1:1** — every session has exactly one Module. Matt's (and creators') nested "Modules" are **Sub-Modules** (a term misuse); there is no session→many-modules data model. ModulesTab builds each card as one session/module with an inner "N Sub-Modules" count. See memory `project_module_submodule_model.md`.

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

**⚠ Conv 176 caveat — cascade does NOT propagate through Tailwind 4 `@theme` intermediate utilities.** Empirically, when a child consumes the entity color through Tailwind 4 utilities (`bg-entity-background`, `text-entity-primary`) generated by the `@theme` bridge (`--color-entity-background: var(--Entity-Background)` etc.), the override does NOT propagate — children render the `:root` default (`gray-100`, grey) regardless of the `.entity-student` / `.entity-course` parent class. Root cause unconfirmed at Conv 176 (possibly Tailwind 4 inlining the value statically, or the `@theme`-generated `--color-*` indirection resolving once at `:root` time). Direct consumption of `var(--Entity-Background)` in handwritten CSS (e.g., `.matt-card { background: var(--Entity-Background); }`) is **expected** to still propagate correctly because the resolution happens at use-site — but this had not been verified at Conv 176.

**✅ Conv 178 validation — root cause is an implementation issue, not a Tailwind 4 cascade failure.** [CASCADE-BROKEN] was inspected during Buttons reconnaissance and validated as an implementation finding: Matt's button CSS uses `var(--Background)` and `var(--Border)` (variant-scoped variable names that change with the button's `variant` prop), **not** `var(--Entity-Background)` / `var(--Entity-Primary)` (the cascading entity variables). The cascade isn't broken — it was never wired into Matt's button design in the first place. Implication: the entity cascade is intended for components that explicitly opt in (Course Header, Teacher Header, etc.), not for every primitive. Multi-variant primitives like Buttons use a different mechanism — variant-prop selection — which is parallel to, but independent of, the entity cascade. Buttons can still recolor based on entity context, but via the `variant` prop being set to `'course'`/`'student'`/`'creator'`, not via `.entity-*` parent classes.

**Working rule (Conv 178 onward):** matt/* primitives that need entity-context coloring use direct per-entity Tailwind utilities or variant-prop selection — same six-variant pattern as `Button.tsx`. The `.entity-*` cascade described in this section applies only to components Matt explicitly wired with `--Entity-*` variables (entity headers, route-level entity color hints). The Conv 176 working-rule wording ("until [CASCADE-BROKEN] resolves") is retired; [CASCADE-BROKEN] is closed. See DEVELOPMENT-GUIDE.md §"Direct Entity Tailwind Utilities in matt/* Primitives (Conv 176)" for the pattern and `src/components/matt/ui/Module.tsx` / `ToDoItem.tsx` for examples.

**✅ Conv 188 root-cause + fix — `@theme inline` is required for cascade-driven entity tokens.** The Conv 176 caveat ("cascade does NOT propagate through `@theme` utilities", root cause unconfirmed) was definitively diagnosed and fixed in Conv 188. The bug: `tokens-tailwind-bridge.css` declared `--color-entity-primary: var(--Entity-Primary)` (and `-background`) inside a plain `@theme { }` block. Tailwind 4's plain `@theme` resolves the inner `var(--Entity-*)` **once, at `:root` time** — so the generated utility bakes in the `:root` default (`gray-base #414141` / `gray-100 #F1F1F1`) and ignores the use-site `.entity-*` cascade. This silently rendered EntityPill / EntityLink / UserIcon-initials role colors in the gray default app-wide whenever they appeared inside an `.entity-*` subtree. **Fix:** move the two cascade-driven entity tokens to a separate `@theme inline { }` block, which emits the variable reference directly (`background-color: var(--color-entity-background)`) so it re-evaluates at the element where the `.entity-*` class is in scope:

```css
/* Static design tokens stay in plain @theme — resolved once at :root */
@theme { /* --color-primary, --color-course-*, etc. */ }

/* Cascade-driven tokens (set per-subtree by .entity-* classes) MUST be inline */
@theme inline {
  --color-entity-primary:    var(--Entity-Primary);
  --color-entity-background: var(--Entity-Background);
}
```

**Standing rule:** static tokens → plain `@theme`; any token whose value is overridden by a parent class (`.entity-*`) and consumed via a Tailwind utility (`bg-entity-*`, `text-entity-*`) → `@theme inline`. Handwritten CSS consuming `var(--Entity-*)` directly was always correct (resolves at use-site); only the `@theme`-generated utility indirection needed the `inline` form. This resolves the Conv 176/187 "subject to verification" hedge — the cascade mechanism is sound and retained; the bug was a Tailwind-bridge authoring error, not a cascade-design failure.

**Architectural implication.** This is the missing mechanism for how §2.4's "Entity-typed page headers" (Course Header, Teacher Header, Student Header) inherit role-context colors. Matt's `<CourseHeader>` doesn't hard-code `#327D00` — it consumes `--Entity-Primary`, and a parent `<MattLayout entity="course">` (or `.entity-course` class on the route) sets the mode. This is what makes the "Matt composes pages from reusable components" principle (§2) actually deliver on its promise of role-contextualized visuals without per-component variant proliferation. Verified working app-wide once the `@theme inline` fix landed (Conv 188).

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

### Button (multi-mode collection — extracted Conv 172, dimensionality refined Conv 178)

Button's **color dimension** is a 3-variable, 6-mode collection (18 mode-resolved cells). The 3 variables (`Background`, `Color`, `Border`) take different values depending on which color mode is active. This section covers the color dimension in full; State and Size dimensions are described in the "3-orthogonal-dimension architecture" callout below.

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

**Conv 183 update — Conv 178's 3-orthogonal claim was wrong; Property 1 conflates State and Size.** Empirical MCP probe of Button Primary section (`40:482`) in Conv 183 [MATT-EXEC-CMP-BTN] revealed Matt encodes State + Size as a single 5-value `Property 1` enum, NOT two orthogonal dimensions. Five drawn variants:

| Property 1 | Outer padding | Label container | Typography | Icon size | Background | Border |
|---|---|---|---|---|---|---|
| `Default`     | `p-[10px]`           | `px-[8px]`  | `text-body-default` (Inter R 14, lh 100%) | 20px | `var(--background, #0777b6)` | `var(--border, #0777b6)` |
| `Hover`       | `p-[10px]`           | `px-[8px]`  | `text-body-default` (Inter R 14)          | 20px | HARDCODED gradient: 10% black on `rgb(7,119,182)` | HARDCODED `#066ba4` |
| `Large`       | `p-[10px]`           | `px-[16px]` | `text-h2` (Inter M 24, lh 100%)           | 24px | `var(--background, #0777b6)` | `var(--border, #0777b6)` |
| `Small`       | `px-[10px] py-[6px]` | `px-[8px]`  | `text-body-small` (Inter R 12, lh 100%)   | 20px | `var(--background, #0777b6)` | `var(--border, #0777b6)` |
| `Small Hover` | `px-[10px] py-[6px]` | `px-[8px]`  | `text-body-small` (Inter R 12)            | 20px | HARDCODED gradient: 10% black on `rgb(7,119,182)` | `var(--border, #0777b6)` |

**Constants across all 5 variants.** `rounded-[39px]` (pill — 39 > height/2 for all sizes); `inline-flex items-center justify-center`; `border-solid`; `text-[color:var(--color, white)]`. Outer padding `p-[10px]` is constant between Default/Hover/Large (only Small variants drop to `py-[6px]`). Small icons are NOT smaller than Default — both 20px.

**Variants Matt did NOT draw — known coverage gaps.** (1) Large Hover is missing; the State × Size cross-product has 5 of 6 cells. (2) No `Disabled` Property 1 value — accessibility falls to native HTML `<button disabled>` + CSS `[disabled]` rule. (3) Only 4 of the 6 Color modes (Primary / Outlined / Course / Student) are instantiated in usage examples below the variants frame — Creator + Default modes exist in the Color collection but no Button instance demonstrates them.

**Hover variants are Primary-specific.** The hardcoded `rgb(7, 119, 182)` (≈ `#0777b6`) base + `#066ba4` border in the Hover variant target the Primary Variable Mode literally. They are not parameterized through `var(--background)`/`var(--border)`. Combining `variant="course"` with `property1="Hover"` (or any non-Primary variant) is **undefined in Matt's source**. Per `feedback_tokenize_only_matt_variables.md` ("hardcode what Matt has hardcoded"), our React Button reproduces Matt's literal styling verbatim — non-Primary + Hover renders the Primary-darkened gradient anyway, mismatching the variant. Proper variant-aware hover extrapolation is Phase 6 [MATT-EXEC-EXT] work.

A minor Matt inconsistency to preserve: the **Hover** variant fully hardcodes its border (`#066ba4`) AND background (gradient), while **Small Hover** keeps the border as `var(--border, #0777b6)` and only hardcodes the background. This is likely a Figma oversight, not a deliberate design choice, but Button.tsx mirrors it.

**React component shape (Conv 183, decided B per /r-start Conv 183 — single `property1` prop mirrors Matt's Figma enum):**

```tsx
type ButtonVariant = 'primary' | 'outlined' | 'course' | 'student' | 'creator' | 'default';
type ButtonProperty1 = 'Default' | 'Hover' | 'Large' | 'Small' | 'SmallHover';

interface ButtonProps {
  variant?: ButtonVariant;      // default: 'primary' — Color dimension
  property1?: ButtonProperty1;  // default: 'Default' — State+Size dimension (matches Matt's Figma)
  children: React.ReactNode;
  onClick?: () => void;
  // ...native button/anchor attributes including `disabled`, `href`, etc.
}
```

Hover/SmallHover are explicit Property 1 values that the caller picks — NOT CSS `:hover` pseudo-classes. This is the strict-B "mirror Matt exactly" interpretation; ergonomic but unidiomatic for web (a wrapper component is needed if you want mouseover to swap the prop automatically). Idiomatic CSS `:hover` styling is intentionally NOT layered on top — that would be a Phase 6 extrapolation.

Implementation lives at `../Peerloop/src/components/matt/ui/Button.tsx` (Conv 183 rewrite).

### MainNav (3-variant composite primitive — extracted Conv 183)

Not a multi-mode collection — included here for grouping with Button as primary user-facing primitives. Matt's Figma "Main Nav" section (`108:4468`) decomposes into two component primitives + one orchestrating composite:

| Component | Figma node | Property 1 variants | Dimensions |
|---|---|---|---|
| Nav Item | `110:5090` (frame) | Default (`108:4614`, 220×24) / Selected (`110:5091`, 220×24) / Main (`150:8585`, 220×132) | 220px wide; Default+Selected are flat rows, Main is a white pill containing parent + Sub Nav slot |
| Nav Sub Item | `110:5096` (frame) | Default (`108:4615`, 118×20) / Selected (`110:5097`, 118×20) | 118px standalone, full-width when nested in a Main pill (with 8px left indent applied by parent slot) |
| Main Nav | `150:8666` (master) + `513:15755` (usage) | (no Property 1 — orchestrating composite) | 220px wide, N Nav Items stacked with `gap-[16px]` |

**Property 1=Main is route-driven** (Conv 183 D1 decision). The white pill auto-positions around the active nav section based on `currentPath`. At most one Nav Item is in `Main` state at a time. NOT a click-to-expand drawer — the visual is fully derived from the route, with no user toggle. Selected = active row that has no children (no expansion needed). The visual rule:

```
ROUTE = /matt/feed           ROUTE = /matt/courses

┌─────────────────────┐      ┌─────────────────────┐
│ ╭─────────────────╮ │      │ 🏠 Home             │
│ │ 🏠 Home         │ │      │ ╭─────────────────╮ │
│ │ ─────────────── │ │      │ │ 📚 Courses      │ │
│ │ 📅 Community    │ │      │ ╰─────────────────╯ │
│ │    Feed (active)│ │      │ 🎓 Peer Teachers    │
│ ╰─────────────────╯ │      └─────────────────────┘
│ 📚 Courses          │
│ 🎓 Peer Teachers    │
└─────────────────────┘
```

**Main pill styling (Figma 150:8585):** `bg-white border border-[rgba(0,0,0,0.1)] drop-shadow-[0px_5px_6.05px_rgba(0,0,0,0.04)] flex flex-col gap-[16px] items-start p-[20px] rounded-[20px] w-[220px]`. Internal divider is an SVG line at 180px wide separating parent from Sub Nav slot. Sub Nav slot: `flex flex-col gap-[16px] items-start pl-[8px] w-full` — 8px left indent applied uniformly.

**Typography per row:**

| Row | Label | Sub-text (optional) | Icon |
|---|---|---|---|
| Nav Item parent | `text-body-medium-bold` (Inter Semi Bold 16, lh 1.5, ls -2.2px) | `text-body-default-medium` (Inter Medium 14) | 24px |
| Nav Sub Item | `text-body-default-medium` (Inter Medium 14) | `text-body-small` (Inter Regular 12) | 20px |

**Color rule (Default → Selected/Main shift):**

| State | Nav Item label | Nav Sub Item label | Sub-text |
|---|---|---|---|
| Default | `text-text-default` (`#414141`) | `text-text-default` | `text-text-default` |
| Selected | `text-text-primary` (`#0777b6`) | `text-primary-default` (`#0777b6`) | stays `text-text-default` |
| Main (parent only) | `text-text-primary` | (n/a) | stays `text-text-default` |

The sub-text stays muted gray regardless of selection state — this is a deliberate hierarchy choice in Matt's design.

**Variants Matt did NOT draw — known gaps.** (1) No `Hover` state for Nav Item or Nav Sub Item — hover affordance falls to CSS `:hover` (orphan, like Button's Disabled state). (2) No `Disabled` state. (3) Nav Sub Item Property 1=Default in isolation (118×20) is too short to render sub-text; when nested inside a Main pill, it renders full-width and can show sub-text. The 118×20 abstract spec captures the icon+label-only case; full nested usage extends the height.

**React component shape (Conv 183 D3 decision = props-driven):**

```tsx
interface NavSubItemData {
  label: string;
  href: string;
  icon?: ReactNode;
  subText?: string;
  trailingIcon?: ReactNode;
}

interface NavItemData {
  label: string;
  href: string;
  icon?: ReactNode;
  subText?: string;
  children?: NavSubItemData[];  // presence + active child → Main pill
}

<MainNav items={NAV_ARRAY} currentPath={pathname} />
```

Active-detection rule: an item enters `Main` state if `currentPath` matches the item OR any of its children AND the item has children. An item enters `Selected` state if `currentPath` matches the item but it has no children. Children render `Selected` if `currentPath` matches the child, else `Default`.

Implementation lives at `../Peerloop/src/components/matt/` (Conv 183):
- `NavSubItem.tsx` — 2 Property 1 variants
- `NavItem.tsx` — 3 Property 1 variants (Default/Selected = flat row; Main = white pill)
- `MainNav.tsx` — orchestrator (props-driven, route-aware)
- `Sidebar.tsx` — Peerloop shell consuming MainNav + 70px collapse toggle + brand + Earnings/Notifications/Profile auxiliary section (collapse mode is a Peerloop extension per Conv 183 D2; Matt drew only the 220px expanded form)

### SubNav (3-variant row primitive + Selected-with-children expanded variant — extracted Conv 184)

The secondary/page-section nav primitive — distinct from the MainNav `Nav Sub Item` (which is the in-MainNav-pill child row). SubNav Items are a standalone row primitive used in the SubNav container (e.g., course-page tabs like About / Modules / Reviews). Matt's Figma Components page has two SubNav-related sections:

| Section node | Section name | Frame | Variants | Purpose |
|---|---|---|---|---|
| `502:12864` | "Sub Nav" | `494:11653` Sub Nav Item | 3 Property 1: Default (`494:11652`), Hover (`533:9687`), Selected (`494:11654`) — each 196×44 | Base row primitive (three states of a single row) |
| `622:18616` | "Sub Nav" (a.k.a. "Sub Nav With Sub nav") | `622:18618` Sub Nav Item With Sub nav | 1 Property 1: Selected (`622:18625`), 196×104 | Expanded variant rendered when an active SubNav row has children |

The Conv 183 "open question" speculating whether the second section was a multi-level variant resolves as: **no** — it is the **Selected-state expanded form** of the base row. Matt has a literal text annotation at the top of section `502:12864` reading "**To Do: Need 3+ Levels**" (node `502:12866`) — designer note that deeper nesting beyond one child level is unfinished. This primitive supports 1 level of children; multi-level nesting is deferred to Phase 6 [MATT-EXEC-EXT].

**Base row styling (Property 1 = Default / Hover / Selected, all 196×44):**

```
<a flex items-center gap-[10px] p-[10px] w-[196px] rounded-[10px] [bg]>
  <icon 24×24 />
  <span text-body-default [text-color] flex-1 />
</a>
```

| Property 1 | Background | Label / icon color | Use |
|---|---|---|---|
| Default | (transparent) | `text-default` (`#414141`) | Idle row |
| Hover | `--ashy-blue` (`#EAEFF5`) | `text-default` (`#414141`) | Pointer hover — applied via `:hover` CSS, NOT a passable property value |
| Selected | `--primary/light` (`#F1F9FF`) | `--primary/default` (`#0777B6`) | Active row matching `currentPath` |

**Selected-with-children expanded variant (196×104):** auto-rendered when `property1=Selected` AND the item has non-empty `subItems`. Mirrors Matt's separate Figma frame (`622:18625`) as a conditional render branch (same pattern as NavItem's Main variant Conv 183).

```
<div flex flex-col gap-[10px] p-[10px] w-[196px] rounded-[10px] bg-primary-light>
  <a parent-row icon 24 + label text-body-default primary />
  <a child-row px-[9px] gap-[8px] icon 20×20 + label text-body-small primary />
  <a child-row …>
</div>
```

Notably, child rows inside the expanded variant use a *different* sizing scale than the base Sub Nav Item (icon 20 vs 24, label 12px vs 14px) — they are NOT recursive Sub Nav Items. Matt drew them as internal styling unique to the expanded variant.

**Strict-B mirror choices in the implementation:**
- **Token literals over entity-cascade.** The Conv 175/176 stub used `bg-entity-background text-entity-primary` (entity-aware extrapolation). Matt's actual Figma uses fixed `--primary/light` and `--primary/default` — not entity-cascade. Entity-aware SubNav is Phase 6 [MATT-EXEC-EXT] territory.
- **Hover is :hover CSS, not a prop.** Matt's Hover variant exists in his Figma but it represents pointer-driven mode, not a caller-passed configuration. The component supports `property1 = 'Default' | 'Selected'` only.
- **Default-with-children not drawn.** Matt only drew Selected-with-children. Inactive items with children render as the Default base row in this primitive; the deeper-nesting design is part of the "Need 3+ Levels" TODO.

**Container layout (Peerloop extrapolation — Matt didn't draw the assembled container):**
- ≥1024px: vertical-left strip, 196px wide, `gap-[10px]`, `border-r border-border-default`
- <1024px: horizontal-scroll fallback (existing Phase 2 stub behavior preserved). Each row keeps its 196×44 dimensions via `shrink-0`. Matt mentioned a left-edge slide-in drawer for mobile per Conv 172 / §2.5 — that's a Phase 6 [MATT-EXEC-EXT] task.

**Container API change from Conv 175/176 stub:**
- OLD: caller pre-computed `active?: boolean` per item (silently never fired — neither existing caller passed it; latent bug since Conv 175)
- NEW: caller passes `currentPath` once; container derives active state via `href` matching (MainNav pattern Conv 183)

**Container component shape:**

```ts
interface SubNavSubItem { label: string; href: string; icon?: string; }
interface SubNavRootItem {
  label: string;
  href: string;
  icon?: string;
  subItems?: SubNavSubItem[];  // presence + active → expanded variant
}

<SubNav items={NAV_ARRAY} currentPath={Astro.url.pathname} />
```

Active-matching rules (most-specific-match-wins, Conv 188): the container computes the single **longest** matching href across all items + subItems and marks only that one `Selected`; all others are `Default`. The expanded variant auto-triggers when Selected AND subItems is non-empty.

**⚠ Conv 188 fix — prefix-match bug.** The Conv 184 implementation used a per-item `path === href || path.startsWith(href + '/')` test. Because a section-index item (e.g. course **About**, whose href `/matt/course/[slug]` is a *prefix* of every sibling tab href like `/feed`, `/modules`, …), that item stayed `Selected` on every child tab route — two rows highlighted at once. The fix replaces per-item prefix testing with a single-pass longest-matching-href computation: exact matches win naturally (an exact href equals the full path), and nested routes resolve to their own row. One rule handles base + nested routes without per-item flags.

**Files (Conv 184, active-match fix Conv 188):**
- `../Peerloop/src/components/matt/SubNavItem.astro` — row primitive (Default/Selected variants + auto-expanded form)
- `../Peerloop/src/components/matt/SubNav.astro` — container (route-aware, props-driven, vertical-desktop / horizontal-mobile responsive; most-specific-match-wins active state)

### Entity primitives + Anchor rows (Conv 184)

Re-categorization following user directive (Conv 184): the **Entities** section (`40:484`) and **Post Anchors** section (`188:4804`) are NOT single primitives — they are compositional sub-libraries. Decomposed per Conv 184 [MATT-EXEC-CMP-ENT] / [-CHIP] / [-ANCH-COURSE] into leaf primitives + per-content-type anchor row components.

**Leaf primitives** (extracted from `Entities` section + recurring patterns):

| Primitive | Figma source | Dimensions | Cascade behavior | Code file |
|---|---|---|---|---|
| **UserIcon** | `1:35` | 40×40 initials avatar | `bg-entity-background` + `text-entity-primary` (initials inside cascade) | `matt/entity/UserIcon.tsx` |
| **EntityPill** | `1:42` | rounded-[33px] px-[8px] py-[2px] text-12 | `bg-entity-background` + `text-entity-primary` | `matt/entity/EntityPill.tsx` |
| **EntityLink** | `1:52` | text-[14px] Inter Medium underline | `text-entity-primary` only (no bg) | `matt/entity/EntityLink.tsx` |
| **IconLabelChip** | NOT named in Figma — extracted from `Frame 150/152/160` recurring pattern in Post Anchors (`317:10566` + 25+ instances) | inline-flex gap-[6px], icon 20×20, label text-[12px] | **NOT cascade** — `tone` prop drives color: `default` = fixed `text-text-tertiary` (`#767676`) gray (light bg); `on-dark` = white (dark-hero overlay), added Conv 187 [DARK-HERO-VARS] | `matt/ui/IconLabelChip.tsx` |

**Entity cascade machinery** (already wired Conv 172, verified Conv 184):

Parents apply a class — `.entity-course`, `.entity-creator`, `.entity-student`, or `.entity-student-teacher` (alias for Student, added Conv 184) — and child primitives consume `bg-entity-background` and `text-entity-primary` via Tailwind utility wrappers around `--Entity-Background` and `--Entity-Primary` CSS variables. Probed colors (Conv 184 from `1:63 / 1:64 / 1:65 / 1:305`):

| Context | bg | text |
|---|---|---|
| Default (no class) | `#F1F1F1` gray | `#414141` Text-Default |
| `.entity-creator` | `#E0E8FF` lilac | `#584DF4` purple |
| `.entity-student` | `#F1F9FF` lt blue | `#0777B6` brand blue |
| `.entity-student-teacher` | (alias of Student) | (alias of Student) |
| `.entity-course` | `#E8F4DF` lt green | `#327D00` dark green |

Notably the Entity collection in Matt's Figma has 4 modes (Default/Creator/Student/Course) — there's no separate Student-Teacher Variable set; Matt drew Student-Teacher with Student's colors. The alias class encodes this empirical observation explicitly so anchor-row callers can mark the contextual role precisely.

**Anchor row components** (per content type — Conv 184 design decision: 9 distinct components, no shared `AnchorRow` base):

Built Conv 184: `CourseAnchor.astro` (mirrors `317:10557` Post Anchors Course row). Remaining 8 (`Creator`, `Certification`, `Module`, `Resource`, `Review`, `Student-Teacher`, `Video Clip`, `Milestone`) deferred to `[CMP-ANCH-REST]` — Phase 5.

**Architectural rationale** (Conv 184 user decision):
- Matt drew the 9 anchor rows with **identical inner frame names** (`Frame 153` row wrapper, `Frame 161` leading composite, `Frame 152` chip group, `Frame 150` individual chip) — evidence of a shared visual shape
- BUT he named each anchor by content type (Course / Creator / Module …), NOT by a shape-type
- AND the data shapes are heterogeneous (Course has `creator/rating/level`, Module has `course-name`, Milestone has `milestone-text`) — no clean unified API for a generic `AnchorRow`

Per `feedback_tokenize_only_matt_variables.md`: extract what Matt named (leaf primitives), don't extract what he didn't (no `AnchorRow` base). The IconLabelChip extraction is an explicit exception — user directive overrode the "Matt didn't name it" caution since the pattern repeats 25+ times.

**CourseAnchor layout** (extracted from `317:10557`):

```
<article class="entity-course border border-border-default rounded-[12px] px-[20px] py-[12px]">
  <div class="flex items-end justify-between">
    <div class="flex flex-col gap-[6px]">              {/* leading */}
      <EntityPill label="Course" />                    {/* cascades via parent */}
      <div class="flex gap-[8px] items-center">
        <MattIcon name="course" class="size-[24px]" />
        <h3 class="text-body-medium-bold">{title}</h3>  {/* text stays text-default */}
      </div>
    </div>
    <div class="flex gap-[10px]">                      {/* metadata chips */}
      <IconLabelChip icon="creator" label={...} />     {/* neutral gray */}
      <IconLabelChip icon="ratings" label={...} />
      <IconLabelChip icon="level-beginner" label={...} />
    </div>
    <a class="bg-entity-background text-entity-primary rounded-[39px] ...">  {/* CTA cascades */}
      Learn More <MattIcon name="arrow-right" class="size-[20px]" />
    </a>
  </div>
</article>
```

**CourseHeader re-validated to Matt's frame (Conv 187 [DARK-HERO-VARS]) — supersedes Conv 184/185 [REFACTOR-COURSEHEADER]:** `matt/entity/CourseHeader.astro` was converted to `CourseHeader.tsx` and re-validated against Matt's Figma "Course Header" **Default** variant (`517:8935`, component set `517:8934`). Matt's current frame shows ALL hero metadata — creator, rating, students, level — as plain **white icon+name chips** over a dark image, NOT the UserIcon-avatar + "Creator" EntityPill + EntityLink trio the Conv 184/185 build had drifted to. Per `feedback_external_source_of_truth_first.md` (Matt's frame is canonical; same C178-REVAL precedent as Conv 185), the trio was replaced by `IconLabelChip tone="on-dark"` ×4 — the same primitive every other metadata chip and CourseInFeed use. The entity-creator trio still has a home in the future "Meet the Creator" tab (Phase 5), just not in this hero. A missing student-count chip was added; the title was corrected to 32px. The `CreatorRef` `slug`/`initials`/`avatarUrl` fields are retained but reserved for the creator tab (the hero chip uses `name` only).

**Dark-hero Button confirmed unneeded — closes [DARK-HERO-VARS]:** both heroes (Course In Feed `519:9096` + Course Header `517:8935`) use Buttons that carry their OWN light pill backgrounds (back affordance = Primary-Light `526:9556`; Enroll CTA = Course-green `526:9501`). So no dark-hero `Button` variant is needed. The dark-hero split is resolved by the `IconLabelChip tone="on-dark"` variant alone (the chip half); the Button half was a non-issue. This closes the `[DARK-HERO-VARS]` task. Only the Default variant is built — Enrolled (`597:6504`) + Scheduled (`685:13240`) are follow-ups.

**CTA-button duplication caveat:** the CourseAnchor CTA is an `<a>` styled to match Button Primary in Course Variable Mode (`bg-entity-background` + `text-entity-primary` + `rounded-[39px]`). Conv 183 built `Button.tsx` (React) as the canonical button primitive — using it inside an Astro component would require React hydration for a static link. Per Conv 184 pragmatic choice, CTA styling is inlined here. Phase 6 candidate: extract a shared `MattCTA.astro` (Astro) that mirrors Button Primary's styling for non-React contexts, OR convert Button.tsx to Astro since it has no client state.

### CourseInFeed dark-hero card (Conv 187 [MMP-PH4])

Built Conv 187 from Matt's "Course In Feed" instance (`519:9096`, α1 Happy Path) — an instance of the Layout-page component set `502:12911` (which also carries a `Property 1=Mobile` variant, deferred to Phase 6). `matt/entity/CourseInFeed.tsx` is the home/feed course recommendation card and the sibling dark-hero composite to `CourseHeader` (same chip/Button pattern). Visually verified live in the Chrome bridge — 245px height matches Matt's instance exactly.

Composition (per `feedback_reuse_existing_components.md` — no inlined duplicates): `<EntityPill>` (recommendation-reason pill, under `.entity-course`) + `<IconLabelChip tone="on-dark">` ×4 (creator / rating / students / level) + `<Button variant="course">` ("Learn More" CTA, light pill survives the dark hero) + `<MattIcon>` (course glyph + arrow-right).

Documented strict-B drifts: (1) Matt exports the whole card as a clickable `<a>` with a nested "Learn More" `<a>` — invalid nested-interactive HTML; here the card is a non-interactive `<article>` and the Button is the only real link (whole-card-click is an app-integration concern, not a primitive concern); (2) image scrim approximated with a CSS top-down dark gradient (Matt's Figma mask-alpha + backdrop-blur is non-portable); (3) the 32px Inter Bold title is hardcoded per the honest-orphan rule (`feedback_tokenize_only_matt_variables.md`) — it is not a tokenized type style.

### Conv 184 audit + React-primitive standardization

User-directed audit Conv 184 surfaced that pre-strict-B components (`SocialPost.tsx`, `CourseHeader.astro` and the original Conv 184 Astro primitives) inlined duplicates of components Matt drew as primitives in his Figma. Per the new standing rule (`feedback_reuse_existing_components.md`): before rendering any Figma frame in code, scan its `<instance>` children and import existing components rather than inlining.

**Standardization on React primitives (Conv 184).** The Astro/React boundary is asymmetric — Astro can import React (Astro renders React statically by default), but React can't import Astro. To enable cross-context reuse (SocialPost.tsx React composite needs UserIcon, AnalyticCount, etc. while Astro pages also need them), all Conv 184 primitives + MattIcon converted from `.astro` to `.tsx`:

- `MattIcon.tsx` — icon registry (same `?raw` glob, React rendering). **Conv 187 [CMP-ICN-REGISTRY]:** now reads each SVG's intrinsic `viewBox` (default `0 0 24 24`) instead of hardcoding a 24×24 wrapper, so Material icons shipped on the 20dp grid (`stars-2.svg`, `accessibility-new.svg`) render at native size beside the 24dp icons. Existing 24×24 icons are unaffected (fallback matches). The Conv 182 "all icons 24×24" uniformity constraint is dropped — the registry is now size-agnostic.
- `UserIcon.tsx` — extended with `avatarUrl?` prop for image-mode (documented strict-B extrapolation per `feedback_tokenize_only_matt_variables.md`)
- `EntityPill.tsx`
- `EntityLink.tsx`
- `IconLabelChip.tsx`
- `CourseAnchor.tsx`
- `AnalyticCount.tsx` (new — extracted from SocialPost's inline `ActionPill`)

Astro pages (e.g., `/matt/index.astro`, `CourseAnchor.astro` previously) import these React components and they render as static HTML at SSR with zero JS hydration cost. The pattern: **primitives in React (broadest reusability), page-wrappers in Astro (static-first)**.

### AnalyticCount primitive (Conv 184)

Built Conv 184 [CMP-ANALYTIC] from Matt's Figma `516:15960` (inside Social Post section). Property 1 auto-flips based on caller's `label` value:

| Property 1 | Trigger | Background | Border | Icon color | Label color |
|---|---|---|---|---|---|
| Default | `label === 0` or empty | `#F6F6F6` | `rgba(88,77,244,0.14)` (Creator-Primary @ 14%) | `--primary/default` | `text-text-tertiary` |
| 1+ | `label > 0` or non-empty | `--primary/light` | `--border/default` | `--primary/default` | `--primary/default` |

Both share: `inline-flex items-center gap-[4px] px-[9px] py-[5px] rounded-[33px] border border-solid`. Icon is `text-[14px]` Inter Semi Bold. Label is `text-[12px]` Inter Semi Bold.

Notable: in Default state, the icon stays brand-blue (`--primary/default`), while the LABEL is muted gray. Only the label color flips between states. The border on Default uses Creator-Primary at 14% alpha — a deliberate hint-of-color on the muted state, NOT a generic gray. Mirrored literally; this is Matt's pattern, not extrapolation.

### SocialPost composition refactor (Conv 184)

Per the new "use existing components" rule, `SocialPost.tsx` refactored Conv 184 to compose from primitives instead of inlining:

| Element | Before Conv 184 (inline) | After Conv 184 |
|---|---|---|
| Author avatar | `Avatar()` helper duplicating cascade colors + `<img>` fallback | `<UserIcon initials avatarUrl label />` |
| Role chip | Custom `<span>` wrapping `roleIcon: ReactNode` + `roleLabel: string` | `<IconLabelChip icon={author.roleIconName} label={author.roleLabel} />` |
| Footer like badge | `ActionPill({icon, count})` inline helper | `<AnalyticCount icon="👍" label={likes} />` |
| Footer love badge | (didn't exist — Matt drew 3 badges; Conv 175 had 2) | `<AnalyticCount icon="💕" label={loves} />` |
| Footer comment badge | Inline custom span with avatar previews | `<AnalyticCount icon="💬" label={commentersLabel ?? comments} />` |
| Course-card embed | `CourseEmbed()` inline helper duplicating CourseAnchor's structure | `<CourseAnchor ... />` passed via `embed: ReactNode` prop |

**API breaking changes** (`_SocialPostDemo.tsx` updated accordingly):
- `SocialPostAuthor.roleIcon: ReactNode` → `SocialPostAuthor.roleIconName?: string` (MattIcon name)
- `commenters: SocialPostCommenter[]` removed (Matt didn't draw the avatar-preview strip; the `commentersLabel` text alone suffices in the 💬 AnalyticCount)
- Added `loves?: number` to match Matt's 3-badge footer (`516:15859`)

### Astro Props convention (Conv 184 — `as Props` assertion)

Across Matt's Astro components, use `const { … } = Astro.props as Props;` rather than relying on Astro's auto-Props inference. The explicit assertion:

1. Marks the `Props` interface as referenced (Astro check otherwise emits `ts(6196)` "declared but never used").
2. Carries the typed shape through default-value destructuring so mapped arrays (e.g., `items.map((item) => …)`) infer the item type correctly instead of falling back to `any`.

Card.astro happens to work without the assertion (simpler destructure shape) but HeaderBar.astro and the Conv 184 SubNav components confirm the assertion is the safer default. New Astro components in the Matt namespace should use this pattern.

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

### Brand primitive — Logo + LogoMark (Conv 185)

Built Conv 185 [MATT-EXEC-CMP-BRN] from Matt's Figma Brand section (`40:481`). Two primitives, six total variants, four SVG assets — each Matt hand-tuned with a distinct viewBox (different MD5s; not CSS-resizable from a single source).

| Primitive | Figma node | Property 1 variants | Files |
|---|---|---|---|
| **LogoMark** | `35:144` | Default / Medium / Small (each its own SVG) | `matt/brand/LogoMark.tsx` + `matt/brand/svg/logomark-{default,medium,small}.svg` |
| **Logo** | `1:270` | Large / Medium / Small | `matt/brand/Logo.tsx` + `matt/brand/svg/peerloop-wordmark-large.svg` |

**Logo composition rule:**
- **Large** stacks `<LogoMark property1="Default" />` + a separate PeerLoop wordmark SVG (Matt drew the wordmark as a pure-vector typographic asset, not browser-rendered text).
- **Medium** + **Small** use `<LogoMark property1="{Medium|Small}" />` + Inter Semi Bold inline text for the wordmark — at the smaller sizes Matt expects text rendering, not the vector wordmark.

**SVG-asset pipeline (per Conv 185 Figma MCP finding — see `memory/reference_figma_mcp_behavior.md`):** `get_design_context` returns `<img src="https://www.figma.com/api/mcp/asset/<uuid>">` markup for vector layers, and the URL serves raw SVG (not raster PNG). Pipeline: `curl -sSL -o file.svg <url>` then `perl -pi -e 's/fill="var\(--fill-0, #[0-9A-Fa-f]+\)"/fill="currentColor"/g'` to normalize Figma's `--fill-0` Variable-fallback pattern for Tailwind theming. SVGs ship inline via `dangerouslySetInnerHTML` (same pattern as MattIcon's Vite `?raw` glob in Conv 182).

**React component shape:**

```tsx
export type LogoMarkVariant = 'Default' | 'Medium' | 'Small';
export type LogoVariant = 'Large' | 'Medium' | 'Small';

<LogoMark property1="Default" />               // 24×24 default sizing
<Logo property1="Large" />                     // stacked LogoMark + wordmark SVG
<Logo property1="Medium" className="..." />    // LogoMark + Inter text
```

**Sidebar wiring (Conv 185):** `matt/Sidebar.tsx` placeholder `∞ PeerLoop` text replaced with `<Logo property1="Medium" />` (expanded sidebar state) / `<LogoMark property1="Default" />` (collapsed 70px state).

### ChatBubble primitive (Conv 185)

Built Conv 185 [CMP-CHAT] from Matt's Figma Chat section (`646:7540`). 2 Property 1 variants, each with its own tail SVG. Matt drew the Default and Us tails as separate pre-mirrored SVG files (different MD5s) rather than relying on CSS transforms — trust the export and ship both SVGs as-is.

| Property 1 | Tail position | Background | Color | Tail color |
|---|---|---|---|---|
| Default | bottom-left | `bg-gray-100` (`#F1F1F1`) | `text-text-default` | `currentColor` (gray-100 fill via parent color class) |
| Us | bottom-right | `bg-primary-default` (`#0777B6`) | `text-white` | `currentColor` (primary-default fill via parent color class) |

**Drift from strict-B (Conv 185 decision):** Matt's Figma frame is 159×35 px ("Text" placeholder). The component dropped the fixed `w-[159px]` in favor of `inline-flex max-w-[280px]` content-sizing — Matt's 159px is a Figma drawing placeholder, not a chat-UX rule. 280px is an industry-standard cap for narrow chat columns. `className` overrides allow strict mirroring (`!w-[159px]`) or column-stretch (`!w-full`) when callers need it. Documented inline in component docstring.

**React component shape:**

```tsx
export type ChatBubbleVariant = 'Default' | 'Us';
<ChatBubble property1="Us">Message text</ChatBubble>
```

Implementation: `matt/chat/ChatBubble.tsx` + `matt/chat/svg/tail-{default,us}.svg`.

### Module + ToDoItem v2 strict-B rewrites (Conv 185 [C178-REVAL])

Conv 185 audit re-probed `Module.tsx` + `ToDoItem.tsx` against Matt's Figma and found significant Conv 178 drift in both. Rewrote both from scratch to strict-B mirror.

**Module (Figma `655:9156`):**

| Aspect | Conv 178 (pre-rewrite) | Conv 185 (strict-B) |
|---|---|---|
| Variants | 4 (`entity: 'course'/'student'/'creator'/'default'`) | 2 (`property1: 'Default' \| 'Current'`) |
| Title weight | Semibold (600) | Medium (500) |
| Title + duration layout | 3 separate lines | Single inline row |
| Width | unspecified | 220px |
| Active-state color | per-entity cascade | Single hardcoded `--primary/light` (`#F1F9FF`) |

**ToDoItem (Figma `649:8041`):**

| Aspect | Conv 178 (pre-rewrite) | Conv 185 (strict-B) |
|---|---|---|
| Checkbox | 24×24 rounded-6 | 20×20 rounded-[5px] |
| Title weight | Semibold (600) | Medium (500) |
| Subtitle weight | Regular (400) | Medium (500) |
| Width | unspecified | 289px |
| Variants | `entity` prop (4 colors) | `checked` boolean (Matt only drew Default/Checked) |
| Active-color | per-entity cascade | Single hardcoded `--pastel-blue` (`#F1F9FF`) |

**Strict-B principle reinforced (Conv 185):** when Matt's Figma has N variants, mirror those exact labels via `property1` enum — don't extrapolate to entity-collection unless Matt drew 4 entity colors for that primitive. The Conv 178 `entity` prop was extrapolation, not Matt's intent. Removing it simplifies API and prevents callers from passing `entity="creator"` and seeing wrong colors. See `memory/feedback_tokenize_only_matt_variables.md` for the underlying rule.

**Files (Conv 185 rewrites):**
- `matt/ui/Module.tsx` — 2 variants (Default/Current), 220px width, Medium font weight, single title+duration line, no `entity` prop
- `matt/ui/ToDoItem.tsx` — 20×20 rounded-[5px] checkbox, Medium font weights, 289px width, no `entity` prop

Only consumer is `/matt/index.astro` showcase (Module hits in `ModuleAccordion.tsx`/`ModuleContent` are unrelated existing components). Showcase callers updated.

### SectionTitle name-collision (Conv 185 [C178-REVAL] finding — NOT a drift)

Re-probing Matt's `Section Title` Figma frame (`722:14801`) Conv 185 revealed it's a **1280×96px dev-status banner** (WIP orange / Dev Ready green / Archived red) using TT Norms Pro Mono font — a Figma-internal document-organization marker (Matt uses it to label which sections are ready for dev work), NOT a product primitive.

Our code's `matt/ui/SectionTitle.astro` is a generic content heading using Inter that wraps an h-tag — entirely different purpose. Same name, different domains; no drift to fix. The collision is documented here so future probes don't try to "mirror" Matt's banner into our SectionTitle component — that would never go in the actual product.

**Pattern (Conv 185 learning):** before assuming a Figma frame maps to a code component, check whether the frame is a product element or a design-system meta element (status badges, version stamps, designer notes). Visual-canvas furniture isn't always a primitive.

### Anchor row primitives — 8 remaining (Conv 185 [CMP-ANCH-REST])

Built Conv 185 — the 8 remaining anchor row primitives from Matt's Post Anchors section (`188:4804`), filling out the set started Conv 184 with `CourseAnchor.tsx`. All 9 anchors now exist; design decision per Conv 184 user directive (9 distinct components, no shared `AnchorRow` base) preserved.

| Component | Figma | EntityPill | Cascade | CTA | Notes |
|---|---|---|---|---|---|
| **CreatorAnchor** | `188:4804` Creator row | "Creator" | `.entity-creator` | Button variant=creator "Learn More" | Mirror of CourseAnchor shape |
| **CertificationAnchor** | Certification row | (none) | — | (none) | Title-only anchor |
| **ModuleAnchor** | Module row | (none) | — | (none) | Title + courseName subtitle |
| **ResourceAnchor** | Resource row | (none) | — | Button default variant "View" | — |
| **ReviewAnchor** | Review row | (none) | — | Button default variant "Read" | — |
| **StudentTeacherAnchor** | Student-Teacher row | "Suggested" (NOT "Student-Teacher" — Matt's text) | `.entity-student-teacher` (alias of `.entity-student`) | Button variant=student "View Teacher" | Pill label drift from class name is intentional |
| **VideoClipAnchor** | Video Clip row | (none) | — | Button default variant "Watch" | 123×69 thumbnail with inline-SVG play-circle overlay; uses `chat` icon as substitute for `video_comment` (deferred `[VIDEO-COMMENT-ICN]`) and inline SVG for `play_circle` (deferred `[PLAY-CIRCLE-ICN]`) |
| **MilestoneAnchor** | Milestone row | (none) | — | Button default variant "View" | — |

**Files (Conv 185):** `matt/entity/{Creator,Certification,Module,Resource,Review,StudentTeacher,VideoClip,Milestone}Anchor.tsx`.

**Pattern (per Conv 184 [CourseAnchor] foundation):** `<article class="entity-{role} border border-border-default rounded-[12px] px-[20px] py-[12px]">` shell. Components without an EntityPill (Certification/Module/Resource/Review/Milestone) omit both the pill and the `.entity-*` cascade since they have no role-context. Components without a CTA (Certification/Module) end the leading-composite without a trailing Button.

**Deferred sub-tasks:** `[VIDEO-COMMENT-ICN]` (harvest Material icon for VideoClipAnchor — currently `chat`), `[PLAY-CIRCLE-ICN]` (harvest Material `play_circle` — currently inline SVG placeholder). Both queued for `[CMP-EXT-ICN]` icon harvest.

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

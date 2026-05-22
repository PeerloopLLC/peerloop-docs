# Matt Design System

🚧 **Working draft — Conv 171+.** Token extraction in progress (Batch 1 done, Batches 2–5 partial). Will mature as the Matt design push proceeds. At the end of [MATT-PRE-PLAN], this doc becomes the authoritative spec for `/matt/*` re-skin work and the extrapolation guide for the rest of the app.

**Related task:** [MDM] (TodoWrite #13 — token extraction) feeds this doc; [MATT-PRE-PLAN] (TodoWrite #10) consumes it.

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

**Action item for [MATT-PRE-PLAN]:** explicitly enumerate **what's missing from Matt's set** — gaps in his happy-path visual language that we'll need to fill with extrapolation judgment. Surface these during planning, not piecemeal during implementation. Candidates so far: admin layouts, data tables, complex forms, error/empty/loading states, multi-role Control Bar variants (Matt drew the primitive but not in context).

**Authority split.**
- **Matt's design = visual spec for the happy path.** Use it for tokens, primitive components, page-shell layout, entity-header treatment.
- **Existing Peerloop app = behavioral spec.** Routing, data fetching, role logic, multi-role switching, permission gating — all live in the real app. The happy path was *deliberately simplified* to spare Matt from the full multi-role complexity.
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

### Page-level "Header Bar" = thin breadcrumb / back-nav strip

- Sits at the top of the Main Panel.
- Examples observed: "Home / Community" on Home page, "← Home / Creator Profile" on Teacher page.
- Estimated height: 40–48px (needs measurement from standalone Header Bar frame).

### Entity-typed page headers below the Header Bar

Each entity type gets its own visually distinctive header zone, color-keyed to the semantic palette:

- **Course Header** (`layout/Course Header.svg`) — dark image hero with title + metadata + CTA
- **Teacher / Creator Header** — purple-blue card (matches `creator-primary` = `#5840F4`)
- **Student Header** (presumed) — `student-primary` blue (`americana-blue` = `#0777B6`)

This is a load-bearing architectural pattern, not decoration: **entity primary color must flow into the entity-header component.**

### Sub Nav pattern (vertical-left)

- Course and Teacher detail pages use a vertical tab strip on the left side of the Main Panel (Course Feed / About / Sessions / Reviews / Resources / Teachers).
- This is the `components/Sub Nav.svg` primitive — NOT the Control Bar.
- The tab strip sits to the LEFT of the actual page content within the Main Panel.

### Control Bar = role-perspective tab switcher (NOT a generic toolbar)

- Appears ONLY when the current user holds multiple roles for the entity being viewed.
- Tabs represent **roles**, not page sections. Roles: Teacher, Student, Visitor, Creator, Admin, Moderator.
- The Sub Nav (vertical-left tab strip with About / Reviews / Resources / etc.) stays STABLE across roles — same structural skeleton.
- The CONTENT inside each Sub Nav section is role-filtered. Same page, different perspectives.
- Per-row data in lists is also role-contextualized.
- Vertical position: directly below the Entity Header (Course / Teacher / etc.), above the Sub Nav + content row, inside the Main Panel.
- Height: TBD — needs Figma measurement.

**Concrete example:** A user who is Creator + Teacher + Moderator for their own Course will see the Control Bar with 3 role tabs. Clicking "Creator" shows revenue + enrollment data + edit affordances; clicking "Teacher" shows live-session + grading affordances; clicking "Moderator" shows post-moderation + reporting tools. All three views share the same Sub Nav (Course Feed / About / Sessions / Reviews / Resources / Teachers).

### Layout shell composition inside the Main Panel

```
┌────────────────────────────────────────────┐
│  Header Bar        (breadcrumb / back)     │ ~40-48px
├────────────────────────────────────────────┤
│  Entity Header     (Course / Teacher / …)  │ only on entity pages
├────────────────────────────────────────────┤
│  Control Bar       (role tabs)             │ only if user has >1 role
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

### Implications for component architecture

- Most non-trivial display + action components will take an `activeRole` input and render conditionally — **but this is already true in the existing app**; we don't need to invent it.
- The Control Bar component visually represents existing role-context state; we don't design the role-context state itself.
- Role-encoding mechanism (URL / global / per-entity) — **whatever the existing codebase already does**; check before building the Control Bar component, don't ask Matt.
- The Control Bar may not appear in any of Matt's 31 happy-path screens (because the happy path is single-role by design); we have Matt's visual spec from the standalone `Control Bar.svg` annotation, that's enough to build it.

---

## 3. Existing App Context

This section consolidates what's already true in the Peerloop codebase so [MATT-PRE-PLAN] doesn't re-discover or re-design things that exist.

### URL routing — established conventions

**Source of truth:** `docs/as-designed/url-routing.md`.

| Pattern | Meaning | Example |
|---|---|---|
| Bare route | "my stuff" (auth-gated) | `/courses` = my enrolled, `/feed` = my timeline |
| `/discover/*` | site-wide discovery | `/discover/courses` = catalog |
| `/{singular}/[param]` | individual resource | `/course/[slug]`, `/teacher/[handle]`, `/creator/[handle]` |
| `/{singular}/[param]/{action}` | resource sub-route | `/course/[slug]/learn`, `/course/[slug]/feed` |
| `/{plural}` | personal collection | `/courses` (my enrolled) |
| `/{verb-ing}/*` | role dashboard | `/teaching/*`, `/creating/*`, `/learning/*` |
| `/{noun}/[handle]` | public profile | `/teacher/[handle]` |
| `/@[handle]` | universal profile | `/@jane` |
| `/settings/*` | account config | no `/my/` prefix |

**Status:** 84 `.astro` page files exist (Session 317 verification). All major route categories are implemented.

### Course routes — what `/matt/course/[slug]/*` mirrors

| Existing route | Purpose |
|---|---|
| `/course/[slug]` | About/Learn (Astro decides tab based on enrollment) |
| `/course/[slug]/learn` | Learn tab (enrolled) |
| `/course/[slug]/feed` | Course discussion feed (enrolled) |
| `/course/[slug]/book` | Book a teacher session (enrolled) |
| `/course/[slug]/sessions` | Sessions list (role-aware: extra tabs per role) |
| `/course/[slug]/teaching-sessions` | TEACHER role-tab pre-selected (dynamic `[tab].astro`) |
| `/course/[slug]/creator-sessions` | CREATOR role-tab pre-selected |
| `/course/[slug]/admin-sessions` | ADMIN role-tab pre-selected |
| `/course/[slug]/moderator-sessions` | MODERATOR role-tab pre-selected |
| `/course/[slug]/teachers` | Teachers list |
| `/course/[slug]/resources` | Course materials |

The dynamic `src/pages/course/[slug]/[tab].astro` catch-all (Conv 166 [CRT-DEDICATED-PAGES]) is the existing implementation of the role-perspective URL pattern. **This is what the Control Bar's role tabs will navigate between.**

### Existing role-aware components (Matt's Control Bar primitives — built Conv 042-044)

**Source directory:** `src/components/discover/`. **Doc:** `docs/reference/_COMPONENTS.md` § "Explore Components".

| Component | Role |
|---|---|
| `RoleBadge` | Pill showing viewer's role for a course/community. 3 sizes (sm / md / compact). Colors: student=blue, teacher=green, creator=purple, moderator=amber. Inactive = secondary. |
| `RoleBadgeRow` | Multiple badges in flex row |
| `ExploreTabBar` | Top-level tab switcher with role-colored tabs + count badges. **This IS the Control Bar pattern.** |
| `RolePillFilters` | Multi-select role toggle pills (only renders pills for roles the user actually has) |
| `ExploreCourseTabs` | Wrapper around `CourseTabs` that injects role-specific tabs into the detail page tab bar |
| `ExploreCommunityTabs` | Same for community pages |
| `ExploreCourseHero` / `ExploreCommunityHero` | Hero + "Your Role:" badges below |
| `ExploreCard` / `ExploreCommunityCard` / `ExploreFeedCard` | Cards with role badge overlay |

**Implication:** Matt's Control Bar component is a visual re-skin of `ExploreTabBar`. The role-encoding, tab-switching, count-badging logic is all already wired up. `/matt/` just provides Matt's visual treatment (sizes, colors, typography from the token system).

### Role detection — `CurrentUser` singleton

`CurrentUser` (client-side singleton) provides O(1) role detection. Existing role-aware components read it directly. Methods:
- `getRoleBadges(courseId)` → role config for that entity
- Reads enrollments, certifications, created courses, moderated courses
- Source: implementation referenced throughout Conv 042-044 components

### Schema role flags → Matt's role enumeration

| Matt's role | Schema field | Notes |
|---|---|---|
| Teacher | `is_teacher = 1` | — |
| Student | derived (≥1 enrollment) | Enrollment-based, not a flag |
| Visitor | no auth | UX state only — confirmed Conv 171 — no DB change |
| Creator | `can_create_courses = 1` OR `has_courses` | "Permission OR State" pattern (POLICIES §1) |
| Admin | `is_admin = 1` | — |
| Moderator | `is_moderator = 1` | — |

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

| `?via=` value | Trail rendered |
|---|---|
| `discover-communities` | Discover > Communities > [Name] |
| `discover-courses` | Discover > Courses > [Title] |
| `community-courses` | [Community] > Courses > [Title] (with `&cs=` and `&cn=`) |
| `discover-feeds` | Discover > Feeds > [Name] |

Component: `src/components/ui/Breadcrumbs.astro`. **Source:** `docs/DECISIONS.md` §5 "Breadcrumb System".

**Implication:** Matt's Header Bar is `<Breadcrumbs>` with new visual styling. The data plumbing exists.

### Page auth tiers (POLICIES §7)

| Tier | Auth | Examples |
|---|:---:|---|
| Public-static | No | `/login`, `/signup` |
| Public-browsable | Optional (enhances UX) | `/discover/*`, `/course/[slug]`, `/@[handle]` |
| Member-only | Required | `/dashboard`, `/learning`, `/teaching`, `/settings/*`, `/community`, `/courses` |
| Role-gated | Required + role check | `/admin/*` (admin), `/creating/*` (creator) |

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
2. **`docs/reference/_COMPONENTS.md`** — full component inventory; map Matt's components/*.svg primitives to existing components
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

For the role-aware Control Bar:
- `src/components/discover/RoleBadge.*` — visual role pill (3 sizes)
- `src/components/discover/ExploreTabBar.*` — the Control Bar pattern
- `src/components/discover/ExploreCourseTabs.*` — role-specific tab injection
- `src/pages/course/[slug]/[tab].astro` — dynamic role-tab catch-all
- `src/lib/CurrentUser.*` (or equivalent) — client-side role singleton

### Important historical context

- **Session 379 (COURSE-PAGE-MERGE):** `/course/[slug]/learn` merged into course detail page as Learn tab (accordion modules); Curriculum tab removed. Affects how Matt's Course detail screens map.
- **Conv 042–044 (EXPLORE-COURSES, EXPLORE-COMMUNITIES-FEEDS):** Built the entire role-aware component system Matt's design now reuses visually.
- **Conv 110–111:** Open messaging; unified `/discover/members` (was 3 separate routes).
- **Conv 033:** AppNavbar simplified — `/dashboard` is single nav entry point for all role dashboards (no separate `/learning`, `/teaching`, `/creating` menu items).
- **Conv 165–166 (CRT-3/4/5/DEDICATED-PAGES):** Added role-tab routes to course detail pages — direct implementation of Matt's Control Bar pattern URLs.

---

## 4. Open Questions

Consolidated across the architectural review and source-doc review. Resolve during [MATT-PRE-PLAN] before token files are finalized.

**Visual / interaction:**
1. **Visitor flow on currently-Member-only pages.** Matt's design enumerates Visitor as a role. POLICIES §7 lists pages as Member-only (`/community`, `/courses`, etc.) that the middleware redirects to `/login`. Does Matt's design imply some of these should become Public-browsable for Visitors? Or does Visitor only see Public-browsable pages? — Likely the latter; confirm during [MATT-PRE-PLAN].
2. **Account dropdown.** Existing `UserMenu` component has role-based menu items (My Learning / My Teaching / Creator Studio / Settings / Sign Out). Where does this live in Matt's design? The Teacher screen sidebar shows the profile chip at the bottom — does it open this menu on click?
3. **Footer.** Existing app has `PublicFooter` / `GatedFooter`. Matt's screens don't show a footer. Decision needed: does Matt's design omit footers entirely, or is it just not shown in the happy-path screens?

**Structural:**
4. **Inner column grid inside Main Panel** — Matt's screens show flexible width content. Is there a fixed N-column inner grid, or is the Main Panel just fluid width with content blocks stacking naturally? (Batch 4 question — needs answer)
5. **Featured-course card on Home page** — is the dark hero on Home the same component as the full Course Header (just rendered in a smaller container), or a distinct "Featured Course" variant?
6. **Free Teacher badge on Teacher page** — green-tinted badge with "Schedule Live Session" CTA. Is this a Teacher state-variant (free vs paid) or a per-page badge component?

**Designer-side:**
7. **Typo to flag with Matt:** Teacher page says "**Exertise**" — should be "**Expertise**".

---

## 5. Color Primitives

12 hex codes extracted from `tokens/color-guide-overview.png` (Conv 171). Two pairs flagged as low-contrast and worth spot-checking via Figma Dev Mode.

| Token name | Hex | Notes |
|---|---|---|
| `ashy-blue` | `#EAEFF5` | Used for `Border > Default` semantic |
| `americana-blue` | `#0777B6` | Used for `Primary > Primary` + `Student > Primary` + `Text > Primary` semantics |
| `dark-green` | `#327D00` | Used for `Course > Primary` semantic |
| `gray-100` | `#F1F1F1` | — |
| `gray-600` | `#767676` | Used for `Text > Tertiary` semantic |
| `gray-base` | `#414141` | Used for `Text > Default` semantic — confirmed in Figma Variable export as `var(--Text-Default, #414141)` |
| `lavender-blue` | `#E0E8FF` | Used for `Creator > Background` semantic |
| `medium-green` | `#41A300` | — |
| `pastel-blue` | `#F1F9FF` | Used for `Primary > Light` + `Student > Background` semantics — ⚠ low-contrast, worth spot-checking |
| `pastel-green` | `#E8F4DF` | Used for `Course > Background` semantic — ⚠ low-contrast, worth spot-checking |
| `purple-blue` | `#5840F4` | Used for `Creator > Primary` semantic |
| `vibrant-blue` | `#1586C5` | — |

**Semantic aliases** (role-based, reference primitives):
- **Border** {Default → `ashy-blue`}
- **Course** {Background → `pastel-green`, Primary → `dark-green`}
- **Creator** {Background → `lavender-blue`, Primary → `purple-blue`}
- **Primary** {Light → `pastel-blue`, Primary → `americana-blue`}
- **Student** {Background → `pastel-blue`, Primary → `americana-blue`}
- **Text** {Default → `gray-base`, Primary → `americana-blue`, Tertiary → `gray-600`}
- **Entity** (composite — used for entity badges)

**Naming convention:** When writing `tokens-primitives.css`, use Matt's Title-Case-Hyphenated Figma Variable names verbatim (e.g., `--Text-Default`, not `--color-text-default`) so paste-back from Figma Dev Mode is lossless.

---

## 6. Token Extraction (Working Section)

🚧 **In progress.** Fill in remaining batches as you have Figma Dev Mode access. Batches 1 and 2 (partial) are complete enough to start drafting token files; Batches 3–5 sharpen the layout shell spec.

### How to use this section

1. Open Matt's Figma file. Click the **`</>`** icon (top-right) to enter **Dev Mode**.
2. Click any element. The right-side Inspector panel shows CSS-ready values.
3. **Easiest source:** scroll the Inspector to the **Typography / CSS code block** (white box with numbered lines). Every value you need is there in `font-family: ...; font-size: ...;` format. Copy directly.
4. Fill in the blanks below. Replace `___` with the value you see.
5. If you can't find a value, leave `???` — CC will fill in a sensible default with a `/* TODO */` comment.
6. **Priority order:** Batch 1 → Batch 2 first (these unblock the token layer). Batches 3–5 are optimization.

**Stuck?** Screenshot the Figma Inspector panel and paste it back — CC can read off the values from the screenshot.

### Batch 1 — Typography

**Where:** The `Headers` frame and the `Body` frame (both tagged "Ready for dev" in green).

**What to do:** Click each text sample. Inspector shows `font-family`, `font-size`, `font-weight`, `line-height`, `letter-spacing` in CSS format. Copy values into the blanks.

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
Sidebar width (expanded):    220px
Sidebar width (collapsed):   70px
Navigation width:            same as Sidebar (Matt uses both terms interchangeably)
Header Bar height:           ~40-48px (estimated — thin breadcrumb / back-nav strip
                              at top of Main Panel; NOT a global top nav. Confirmed
                              by Home and Teacher screens: "Home / Community" and
                              "← Home / Creator Profile" strips at top of content.)
Control Bar height:          ??? (not visible on Home / Course / Teacher screens —
                              check standalone Control Bar frame in Figma; likely
                              a horizontal toolbar used on list/index pages)
Page Padding (outer gutter): 16px
Main content max-width:      ??? (if capped — leave ??? if it just fills available space)
Gutter between Sidebar and Main Panel (horizontal): 16px
```

#### Tablet Portrait (≤1024px)

```
Sidebar/nav treatment:   ___ (pick one or describe: hidden / drawer / always-collapsed / other)
Page Padding:            ___
Header Bar height:       ___ (skip if same as Desktop)
```

#### Mobile (≤640px)

```
Nav treatment:           ___ (pick one or describe: hamburger drawer / bottom tab bar / slide-in / other)
Page Padding:            ___
Header Bar height:       ___ (skip if same as Desktop)
```

### Batch 3 — Spacing scale

**Where:** Any layout frame. Also check Figma's left panel for a **Variables** or **Local Styles** section — Dev Mode often lists all spacing tokens in one place.

```
Named spacing values that exist (check all that apply):
[ ] 4px
[ ] 8px
[ ] 12px
[ ] 16px   (confirmed — has its own SVG)
[ ] 20px   (confirmed — has its own SVG)
[ ] 24px
[ ] 32px
[ ] 40px
[ ] 48px
[ ] 64px
[ ] Other: ___
```

### Batch 4 — Page structure (grid)

**Where:** The `Desktop + Tablet Landscape` frame or `Page Template` frame.

```
Page layout shape:   2-column (Sidebar + Main Panel) — confirmed by user.
                     Matt may use other names for these panels in Figma.

Does the main content area have an inner column grid? ??? (not yet inspected)

If yes:
  Column count:     ___
  Gutter width:     ___
  Max content width: ___
```

### Batch 5 — Control Bar visibility

**Where:** Inspect the `Control Bar` frame, plus look at several `happy-path/screens/*` to see if/when it appears.

```
Control Bar appears: ONLY when the current user has multiple roles for the entity
                     being viewed. The tabs represent role perspectives, not page
                     sections. Roles: Teacher, Student, Visitor, Creator, Admin,
                     Moderator. Sub Nav sections remain stable across roles; the
                     CONTENT inside each section is role-filtered.

Position relative to Header Bar: directly below Entity Header (Course/Teacher/etc.)
                                 and above the Sub-Nav-plus-content row, inside
                                 the Main Panel.

Control Bar height: ??? (still needs Figma measurement from standalone frame)
```

---

## Document Lineage

- **Conv 171:** Initial form created in `.scratch/matt-devmode-form.md` as token-extraction lookup; grew through architectural findings + strategic context + existing-app-context review; graduated to `docs/as-designed/matt-design-system.md` at end of Conv 171.

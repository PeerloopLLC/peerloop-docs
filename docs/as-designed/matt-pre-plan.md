# Matt `/matt/*` Pre-Plan

🚧 **Working draft — Conv 173.** Plans the execution of the `/matt/*` re-skin. Becomes the authoritative blueprint after the open decisions in §4 are resolved.

> ✅ **Post-flip note (Conv 197 [ROUTE-FLIP]):** the `/matt/*` namespace has since **dissolved** — the
> design system is now the root app and legacy moved to `/old/*`. Every `/matt/...` path in this doc's
> route-map table now reads as the bare root path (`/matt/courses` → `/courses`, etc.). This doc is kept
> as the historical build blueprint; for the live post-flip route map see `url-routing.md` §8 and
> `route-api-map.md`. Flip record: `matt-provenance.md` §8.

**Primary input:** `docs/as-designed/matt-design-system.md` (the spec — *what* we're building).
**This doc:** *how* we ship it.
**Tracking:** PLAN.md → MATT-DESIGN-PUSH block, [MATT-PRE-PLAN] task.

---

## 1. Purpose & Out-of-Scope

### What this doc DOES

- Maps Matt's 31 happy-path screens onto concrete `/matt/*` routes
- Specifies file structure for tokens, layout shell, primitives, and pages
- Surfaces the novel architectural decisions that must resolve **before** code is written
- Sequences the execution phases (what unblocks what) for follow-up `[MATT-EXEC-*]` blocks

### What this doc does NOT do

- Write code — no `.css`, `.astro`, or `.tsx` files land in this conv
- Re-design what the spec already settled (tokens, multi-mode collections, layout shell composition — see `matt-design-system.md`)
- Plan the flip (`/matt/*` → `/*` and current `/*` → `/old/*`). Now scoped as the **MATT-CUTOVER** block (design settled Conv 195 — see `matt-provenance.md`); legacy prefix is `/old` (superseded the earlier `/fraser/` naming).

### Coexistence architecture (Conv 169 directive)

Matt's work lives ALONGSIDE the existing app on branch `jfg-dev-13-matt` until a later flip block. During this window:

- Existing routes are unchanged
- New `/matt/*` routes shadow their existing counterparts
- New components live under temporary `matt/` subdirectories — file *names* match the future-default names so the flip is a directory move, not a rename
- New tokens use future-default identity per PLAN.md DECISIONS §3 (e.g., `tokens.css`, not `matt-tokens.css`)

---

## 2. Route Map (Deliverable A)

Maps Matt's 31 canonical screens (`.scratch/matt-main/happy-path/screens/`) onto the existing route system (`docs/as-designed/url-routing.md`) and the new `/matt/*` mirror.

### Coverage summary

| Layer                | Count | Notes                                                                                          |
| -------------------- | :---: | ---------------------------------------------------------------------------------------------- |
| Matt's screens       |  31   | 31 SVGs across 5 entity types (Home, Course, Teacher, Session, Certification)                  |
| Distinct UI states   |  ~30  | Some screens are state variants of the same route (Course Purchased, Home Enrolled, etc.)      |
| Distinct routes      |  13   | Many states share a route; differences come from data + Role Tab Bar selection                 |
| Existing routes hit  |  13   | All `/matt/*` routes have a direct existing-app counterpart — `/matt/*` is re-skin, not new IA |

### Full mapping

| Matt screen(s)                                                                                                      | State variant(s)                                            | Existing route                            | New route                              | Notes                                                                                                                                       |
| ------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------- | ----------------------------------------- | -------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- |
| `Home.svg`, `Home Enrolled.svg`, `Home Course Completed.svg`                                                        | Visitor, enrolled student, completed student                | `/dashboard` (member-only) or `/` (index) | `/matt/`                               | Single route; data + Role Tab Bar drive the 3 states. **Decision required**: does `/matt/` = `/dashboard` (auth) or `/` (visitor)? See §4-5. |
| `Course.svg`, `Course About.svg`, `Course Modules.svg`, `Course Purchased.svg`                                      | Unenrolled-about, enrolled-modules, post-purchase           | `/course/[slug]`                          | `/matt/course/[slug]`                  | Tab selection (About vs Learn) is enrollment-driven, same as existing app                                                                   |
| `Course Resources.svg`                                                                                              | enrolled                                                    | `/course/[slug]/resources`                | `/matt/course/[slug]/resources`        | Static-route precedence via existing `[tab].astro` catch-all                                                                                |
| `Course Reviews.svg`                                                                                                | —                                                           | `/course/[slug]/reviews`                  | `/matt/course/[slug]/reviews`          | Route exists already                                                                                                                        |
| `Course Teachers.svg`, `Course Teachers Enrolled.svg`, `Course Teachers Enrolled Scheduled.svg`                     | Browse, enrolled-no-session, enrolled-with-session          | `/course/[slug]/teachers`                 | `/matt/course/[slug]/teachers`         | State variants are data-driven                                                                                                              |
| `Course Creator.svg`, `Course Creator-1.svg` … `-4.svg`                                                             | Creator-role view across 5 sub-tabs (overview, modules etc) | `/course/[slug]/creator-sessions` etc.    | `/matt/course/[slug]?role=creator`     | These are role-perspective views — see "Role-tab URL pattern" below                                                                         |
| `Purchase Course.svg`, `Purchase Course Success.svg`                                                                | Checkout, success                                           | `/course/[slug]/checkout` (or `/book`)    | `/matt/course/[slug]/checkout`         | **Decision required**: confirm checkout route name against existing app                                                                     |
| `Teacher.svg`, `Teacher-1.svg` … `-3.svg`                                                                           | 4 viewing-context variants                                  | `/teacher/[handle]`                       | `/matt/teacher/[handle]`               | Variants are role-context or data-driven                                                                                                    |
| `Teacher Schedule.svg`                                                                                              | —                                                           | `/teacher/[handle]/schedule` (or `/book`) | `/matt/teacher/[handle]/schedule`      | **Decision required**: confirm booking route                                                                                                |
| `Session Prepare.svg`                                                                                               | Pre-session lobby                                           | `/session/[id]/prepare` (or `/[id]`)      | `/matt/session/[id]/prepare`           | **Decision required**: confirm pre-session route — may be modal on `/learning/sessions`                                                     |
| `Session During.svg`, `Session During With Video.svg`, `Session During Notes open.svg`, `Session During Notes open-1.svg` | Live-session UI states                                | `/session/[id]/room` (or `/[id]`)         | `/matt/session/[id]/room`              | All 4 variants are runtime UI state, not separate routes                                                                                    |
| `Session After.svg`                                                                                                 | Post-session feedback / wrap                                | `/session/[id]/after` (or feedback URL)   | `/matt/session/[id]/after`             | **Decision required**: confirm post-session route                                                                                           |
| `Certification.svg`                                                                                                 | —                                                           | `/certification/[id]` or `/learning/certifications/[id]` | `/matt/certification/[id]` | **Decision required**: confirm certification route shape                                                                                    |

### Role-tab URL pattern (Course Creator series)

Existing app uses dedicated route segments for role-tab views (`/course/[slug]/creator-sessions`, `/teaching-sessions`, etc. — see `docs/as-designed/url-routing.md` Conv 166 [CRT-DEDICATED-PAGES]). The Role Tab Bar Matt's design implicitly requires (§2 of spec) is a UI control over **which role-perspective URL we route to** — clicking "Creator" navigates to `/matt/course/[slug]/creator-sessions`, etc.

**Open question** — does the Role Tab Bar at `/matt/*` reuse the existing role-perspective routes (`/creator-sessions`, `/teaching-sessions`, …) or adopt a query-param shape (`?role=creator`)? Recommended: **reuse existing routes** — they exist, they work, the dynamic `[tab].astro` catch-all is built. No new routing.

### Route generation strategy

Astro page files in `src/pages/matt/...` mirror the existing tree but use `MattLayout.astro` and Matt's primitives. Each page file is thin — it imports the same data fetcher the original page uses (DB query / API call) and composes primitives. No business logic duplication.

### Implementation status (as of Conv 182, MMP-PH2)

Built (2/13):

| Route | File | Status |
|---|---|---|
| `/matt/` | `src/pages/matt/index.astro` | ✅ Home — built earlier convs |
| `/matt/course/[slug]` | `src/pages/matt/course/[slug]/index.astro` | ✅ Course detail — built earlier convs; body polish pending under [MATT-COURSE-POLISH] |

Pending (11/13), gated by MMP-PH3 (component primitives) → MMP-PH4 (re-render test) → MMP-PH5/[MATT-EXEC-PG2] (thin-shell page assembly):

- `/matt/course/[slug]/resources`
- `/matt/course/[slug]/reviews`
- `/matt/course/[slug]/teachers`
- `/matt/course/[slug]/creator-sessions` (Role Tab Bar — see "Role-tab URL pattern" above; query-param `?role=creator` form decided against)
- `/matt/course/[slug]/checkout`
- `/matt/teacher/[handle]`
- `/matt/teacher/[handle]/schedule`
- `/matt/session/[id]/prepare`
- `/matt/session/[id]/room`
- `/matt/session/[id]/after`
- `/matt/certification/[id]`

Five of the eleven pending carry "Decision required" markers in the Full Mapping table above — these resolve naturally during MATT-EXEC-FLAGS (task #20 in TodoWrite), which verifies the 4 route-shape assumptions before Phase 5 begins.

---

## 3. File Structure (Deliverables B + C + D)

Concrete files this plan will produce — names, paths, and what they own.

### Tokens (Deliverable B)

```
../Peerloop/src/styles/
├── global.css                              # existing — keep unchanged for now
├── tokens-primitives.css                   # NEW — Matt's 15 color primitives + scaffolded scales
├── tokens-semantic.css                     # NEW — Matt's 14 semantics + multi-mode variants
└── tokens-tailwind-bridge.css              # NEW — opt-in Tailwind 4 @theme remapping (see §4 Decision 3)
```

- **Format:** Tailwind-4-aware CSS. Plain CSS variables at `:root`. No Sass, no PostCSS plugins.
- **Naming:** preserves Matt's Title-Case-with-slash naming for **semantics** (`--Text-Default`, `--Course-Primary`). **Primitives** require naming normalization — see §4 Decision 2.
- **Cascade preservation rule** (load-bearing — see spec doc §5): semantics that reference other semantics use `var()`, NOT primitive flattening. The cascade IS the design system's resilience.
- **Import chain:** `global.css` → `@import './tokens-primitives.css'; @import './tokens-semantic.css';` (so tokens are available to Tailwind utilities and to `MattLayout`'s scoped CSS).

### Layout shell (Deliverable C)

```
../Peerloop/src/layouts/matt/
├── AppLayout.astro                         # NEW — the /matt/* page shell (replaces AppLayout.astro for /matt/* routes)
└── LandingLayout.astro                     # NEW (likely) — for unauthenticated /matt/ visitor flow if confirmed
```

- **Naming principle** (PLAN.md DECISIONS §3 generalized): files take their future-default names. The `matt/` subdirectory is the temporary disambiguator. After the flip, files move up one level, overwriting the existing layouts.
- **MattLayout responsibilities:**
  - Two-panel desktop shell (Sidebar 220px expanded / 70px collapsed + Main Panel, 16px gutter — per spec §2)
  - Breakpoint shell-swap at 1024px → single-column with fixed Header Bar + fixed Control Bar
  - Header Bar slot with breakpoint-varying content (breadcrumb / brand / brand+icons — see §4 Decision 7)
  - Inner row slots: Entity Header + Role Tab Bar + Sub Nav + page content

### Components (Deliverable D)

```
../Peerloop/src/components/matt/
├── Sidebar.tsx                             # NEW — Matt's left sidebar (brand top / nav middle / earnings+notifications+profile bottom)
├── HeaderBar.astro                         # NEW — top-of-page slot (breadcrumb at desktop, brand strip at tablet, brand+icons at mobile)
├── ControlBar.tsx                          # NEW — Matt's primary-nav bottom pill (tablet portrait 6 icons, mobile 4 icons)
├── RoleTabBar.tsx                          # NEW — Peerloop extension; multi-role perspective switcher (re-skin of ExploreTabBar)
├── SubNav.astro                            # NEW — vertical-left tab strip at desktop, slide-in drawer at mobile
├── entity/
│   ├── CourseHeader.astro                  # NEW — dark image hero with title + metadata + CTA
│   ├── TeacherHeader.astro                 # NEW — Creator-Primary purple-blue card
│   ├── StudentHeader.astro                 # NEW — Student-Primary blue card
│   └── CreatorHeader.astro                 # NEW — same as Teacher visually; semantic distinction for analytics
└── ui/
    ├── Button.tsx                          # NEW — Matt's 6-variant Button (primary, outlined, course, student, creator, default)
    ├── Card.astro                          # NEW — Matt's Card primitive
    ├── Module.tsx                          # NEW — Module / lesson row component
    ├── SocialPost.tsx                      # NEW — Social post / feed item component
    ├── Note.tsx                            # NEW — Matt's Note primitive (annotated text block)
    ├── SectionTitle.astro                  # NEW — Section heading primitive
    └── ToDoItem.tsx                        # NEW — To-Do row component
```

**Existing-component → Matt-component mapping** (re-skin scope, not rebuild):

| Existing component                            | Matt primitive       | Strategy                                                                                            |
| --------------------------------------------- | -------------------- | --------------------------------------------------------------------------------------------------- |
| `src/components/layout/AppNavbar.tsx`         | Sidebar              | Rebuild from scratch — different IA (brand top / nav middle / earnings+profile bottom)              |
| `src/components/ui/Breadcrumbs.astro`         | HeaderBar (desktop)  | Re-skin — same data shape (BreadcrumbItem[]), new visual; wrap in HeaderBar component               |
| `src/components/discover/ExploreTabBar.tsx`   | RoleTabBar           | Re-skin — same role-colored-tab-with-count pattern; rebuild visual with Matt tokens                 |
| `src/components/discover/RoleBadge.*`         | (used inside Sidebar)| Reuse as-is initially; consider Matt-token re-skin in [TSV]                                         |
| `src/components/layout/Footer.astro`          | (none — likely omitted) | Matt's design shows no footer; confirm during [MATT-EXEC] — see §4 Decision 8                    |
| `src/components/layout/AppHeader.tsx`         | (deprecated)         | Not used in `/matt/*` — legacy top-header pattern. No Matt counterpart.                             |
| `src/components/layout/UserAccountDropdown.tsx` | Sidebar bottom profile chip | Reuse menu logic; re-skin trigger affordance                                                  |

### Pages (Deliverable E)

```
../Peerloop/src/pages/matt/
├── index.astro                             # Home / Dashboard
├── course/[slug]/
│   ├── index.astro
│   ├── resources.astro
│   ├── reviews.astro
│   ├── teachers.astro
│   ├── checkout.astro
│   └── [tab].astro                         # role-tab catch-all (matches existing pattern)
├── teacher/[handle]/
│   ├── index.astro
│   └── schedule.astro
├── session/[id]/
│   ├── prepare.astro
│   ├── room.astro
│   └── after.astro
└── certification/[id].astro
```

**Page assembly pattern** — every page file is thin (target: <80 lines):

```astro
---
// Existing data fetcher — no duplication
import { getCourseBySlug } from '@lib/data/courses';
import AppLayout from '@/layouts/matt/AppLayout.astro';
import CourseHeader from '@components/matt/entity/CourseHeader.astro';
import SubNav from '@components/matt/SubNav.astro';
import RoleTabBar from '@components/matt/RoleTabBar';

const { slug } = Astro.params;
const course = await getCourseBySlug(slug);  // existing data shape, no changes
---

<AppLayout title={course.title} entity="course">
  <CourseHeader course={course} />
  <RoleTabBar client:load roles={course.viewerRoles} />
  <SubNav slot="sub-nav" items={course.tabs} active="about" />
  <slot>
    {/* page body composes from primitives */}
  </slot>
</AppLayout>
```

No business logic, no data transformations — just primitive composition with existing data fed in.

---

## 4. Open Decisions (RESOLVED Conv 173)

All 8 decisions resolved with the user Conv 173. Recommendations stood — no overrides.

### Resolution summary

| # | Decision | Choice | Resolution |
|---|---|---|---|
| 1 | CSS length units | **C** | Hybrid — rem for typography + spacing (with pixel-named tokens like `--space-4: 0.25rem`); px for borders + 1px hairlines + `--radius-*` |
| 2 | Primitive naming normalization | **B** | Force kebab-case everywhere for primitives (`ashy-blue`, `alert-light`); semantics keep `Title-Case/with-slash` form |
| 3 | Tailwind 4 `@theme` integration | **C** | Hybrid bridge file — Matt's tokens own canonical names in `tokens-primitives.css` + `tokens-semantic.css`; `tokens-tailwind-bridge.css` re-exports as `--color-*` for utility-class ergonomics |
| 4 | Primary color coexistence | **B** | Coexist — existing `--color-primary-*` scale untouched; Matt's tokens live in parallel; `/matt/*` doesn't import old scale; consolidation deferred to flip block |
| 5 | `/matt/` index route | **A** | Member-only `/dashboard` analog; visitors redirect to `/matt/login` |
| 6 | Sidebar approach | **B** | Rebuild as new `Sidebar.tsx`; reuse hooks/utilities (CurrentUser, modal utils, UserAccountDropdown); fresh component skeleton matching Matt's IA |
| 7 | HeaderBar architecture | **C** | Slot-based — `<HeaderBar>` exposes named slots (`header-left`, `header-center`, `header-right`); pages pass content; layout owns breakpoint outer structure. Same pattern applied to SubNav. |
| 8 | Footer in `MattLayout` | **A** | Omit entirely; legal/terms/contact links relocated to Sidebar bottom or Settings sub-route (TBD during execution) |

Recommendations and tradeoffs preserved below for traceability — they're not blocking anymore, but they record *why* each choice was made.

### Decision 1 — CSS length units (spec doc §4 Q8)

**Question:** px, rem, or hybrid for the token system?

| Option | Pros | Cons |
| ------ | ---- | ---- |
| A) Pure px | Concrete, predictable, matches Matt's measurements 1:1 | No accessibility scaling (user font-size pref ignored) |
| B) Pure rem | Accessibility-correct | Pixel-named tokens (`--space-4`) get awkward rem values (`0.25rem`) |
| C) **Hybrid: rem for typography + spacing, px for borders + hairlines** | Standard design-system convergence; accessibility where it matters, predictability where it doesn't | Two-rule system to remember |

**Recommendation: C (Hybrid).** Typography tokens emit rem (`--text-base: 1rem`); spacing emits rem with px-named tokens (`--space-4: 0.25rem`); borders and 1px UI hairlines stay as px. This matches Tailwind 4's native convention and the broader design-system industry.

### Decision 2 — Primitive naming normalization

**Question:** Matt's 15 primitives use 3 conventions in one collection (`pastel-blue`, `Ashy Blue`, `alert light`). CSS variables can't contain spaces. How do we name them?

| Option | Pros | Cons |
| ------ | ---- | ---- |
| A) Match Matt's literal Figma names with case-sensitive normalization (`Ashy-Blue`, `alert-light`) | Maximum traceability to Figma | Mixed-case is ugly; Dev Mode paste-back needs manual case adjustment |
| B) **Force kebab-case everywhere (`ashy-blue`, `alert-light`)** | Consistent, ergonomic, conventional CSS | Loses literal-paste-back from Matt's `Ashy Blue` — but the mapping is trivial (`Ashy Blue` → `ashy-blue`) |
| C) Match each token's original case (kebab where kebab, Title for `Ashy Blue` → `Ashy-Blue`, lowercase for `alert light` → `alert-light`) | Highest fidelity | Three styles in one file; codebase grep ambiguity (`Ashy-Blue` vs `ashy-blue`) |

**Recommendation: B (kebab-case everywhere for PRIMITIVES).** Semantics already use Title-Case-with-slash (`Text/Default`) which is unambiguous; primitives don't have that constraint and benefit from convention. Flag Matt's inconsistency back to him for v2 (already in [TSV]).

### Decision 3 — Tailwind 4 `@theme` integration shape

**Question:** Matt's semantic tokens (`--Text-Default`) don't fit Tailwind 4's expected `--color-foo` shape (which generates `bg-foo`, `text-foo` utilities). Three options:

| Option | Pros | Cons |
| ------ | ---- | ---- |
| A) **Matt's tokens stay OUTSIDE `@theme`; consume via `bg-[var(--Text-Default)]` arbitrary-value syntax** | Cleanest separation; tokens-primitives + tokens-semantic stay pristine; no name munging | Slightly verbose at call sites; no Tailwind utility shortcuts |
| B) Mirror Matt's tokens INTO `@theme` with Tailwind-shaped names (`--color-text-default`) | Tailwind utility classes work (`bg-text-default`) | Name munging conflicts with PLAN.md "Figma Variable names verbatim" directive; two names for one concept |
| C) Hybrid via `tokens-tailwind-bridge.css` — Matt's tokens own canonical names; bridge file imports Matt tokens and re-exports as Tailwind-shaped names in `@theme` | Utility shortcuts WHERE they matter; canonical names unchanged | Two CSS layers to grok; potential drift if bridge falls behind primary tokens |

**Recommendation: C (Hybrid bridge file).** The bridge file is small, explicit, and lives next to the canonical files so drift is grep-visible. Tailwind 4 supports any `--color-*` in `@theme` automatically generating utility classes — we get `bg-course-primary`, `text-text-default`, etc. as a bonus to direct `var()` consumption.

### Decision 4 — Primary color coexistence (Matt's `americana-blue` vs existing `--color-primary-*`)

**Question:** The existing `global.css` `@theme` block defines `--color-primary-50…950` as a sky-blue scale. Matt's `americana-blue` (`#0777B6`) is roughly that scale's 700/800 step. During the coexistence period (until the future flip), how do these two systems live together?

| Option | Pros | Cons |
| ------ | ---- | ---- |
| A) Replace existing primary scale with a Matt-derived scale | Single source of truth | Breaks every non-`/matt/*` page styled with current primary — visible color change everywhere |
| B) **Coexist — existing primary stays; Matt's tokens live in parallel; `/matt/*` pages don't import the old scale** | Zero risk to existing app; clean separation during transition | Two color systems in one codebase until the flip |
| C) Bridge — emit existing `--color-primary-*` names from Matt's `--Primary-Default` | Tailwind utility classes that use `primary-*` work in `/matt/*` too | Couples Matt's tokens to legacy naming; harder to flip later |

**Recommendation: B (Coexist).** The future flip is the moment to consolidate, not now. Coexistence has zero risk and matches the Conv 169 "/matt/* alongside existing" directive.

### Decision 5 — `/matt/` index route (Home)

**Question:** Matt's `Home.svg` series (3 state variants — visitor / enrolled / completed) maps onto which existing route?

- `/dashboard` is **member-only** (POLICIES §7); visitors get redirected to login
- `/` is the **public landing** (`src/pages/index.astro`)
- Matt's Home has a community-feed style with role-conditional content — closer to `/dashboard` than `/`

| Option | Pros | Cons |
| ------ | ---- | ---- |
| A) **`/matt/` = `/dashboard` analog (member-only); visitors see `/matt/login` flow** | Matches Matt's design intent (community feed for authenticated user) | Visitor on `/matt/` gets a redirect — no public landing in `/matt/*` for now |
| B) `/matt/` = `/` analog (public landing); add `/matt/dashboard` separately | Visitor-friendly entry to `/matt/*` | Doubles the home routes; Matt didn't draw a separate landing |
| C) `/matt/` is auth-tier-detecting — visitor sees landing variant, member sees dashboard variant | One route, three states | Complex SSR logic on a route Matt didn't design for |

**Recommendation: A.** Visitors who land at `/matt/` redirect to `/matt/login` (which we'll build alongside `/matt/`). When the flip happens, `/matt/` → `/dashboard` and the existing index → `/old/`.

### Decision 6 — Sidebar: rebuild vs re-skin

**Question:** `AppNavbar` (629 lines, React) has role-based menu logic, slide-out panels, View Transitions persistence, and stale-while-revalidate user loading. Matt's Sidebar has a different IA (brand top / primary nav middle / earnings+notifications+profile bottom).

| Option | Pros | Cons |
| ------ | ---- | ---- |
| A) Re-skin AppNavbar — keep all existing logic, swap visual classes for Matt tokens | Reuses 629 lines of working code; fastest path | Forces Matt's IA into the existing AppNavbar tree; risk of visual compromises |
| B) **Rebuild as Matt-side `Sidebar.tsx` — reuse hooks/utilities (CurrentUser, openLoginModal) but new component skeleton** | Clean IA match to Matt's design; testable in isolation | Duplicates plumbing (View Transitions persist, mobile hamburger, etc.) |

**Recommendation: B (Rebuild as new component).** AppNavbar's role-based menu logic is plumbing that lives in `@lib/current-user` and modal utilities — those get imported. The component skeleton itself (DOM shape, panels, hamburger) is visual and is what Matt redesigned. Rebuilding is more durable; re-skinning a 629-line React tree carries hidden visual compromises.

### Decision 7 — HeaderBar architecture (breakpoint-varying content)

**Question:** Matt's HeaderBar has 3 distinct shapes (breadcrumb at desktop, brand strip at tablet portrait, brand + Messages + Notifications icons at mobile — per spec §2). How does the component own this?

| Option | Pros | Cons |
| ------ | ---- | ---- |
| A) Single component with breakpoint-conditional internal JSX; props for current breadcrumb items | One component to import; matches Matt's "single Header Bar primitive" Figma model | All 3 shapes' DOM ships at every breakpoint; CSS hides what shouldn't show |
| B) Three separate components; layout chooses one via CSS `display:none` at the layout level | Each component is single-purpose, testable | Three imports; layout glue is uglier |
| C) **Slot-based: `<HeaderBar>` exposes `<slot name="left">`, `<slot name="center">`, `<slot name="right">`; page passes content; component renders slots present** | Maximum flexibility; matches the Figma slot mental model; pages opt into the shape they need | Pages have to know the slot names; small learning curve |

**Recommendation: C (Slot-based).** Astro `<slot name=…/>` is built for exactly this; the layout supplies the breakpoint-conditional outer structure (mobile = 3-slot row; tablet = centered single slot; desktop = breadcrumb container) and the page supplies the content (`Messages` icon, breadcrumb items, etc.). Single component, breakpoint-driven outer container, page-driven inner content.

### Decision 8 — Footer

**Question:** Matt's screens show no footer. The existing app has `PublicFooter` / `GatedFooter`. Is `/matt/*` footer-less?

| Option | Recommendation                                                                                  |
| ------ | ----------------------------------------------------------------------------------------------- |
| —      | **MattLayout omits footer entirely.** Confirm with Matt later if a v2 footer is expected; he hasn't drawn one in the happy path. Tracked as a [MATT-EXEC] follow-up Q. |

### PLAN.md correction (housekeeping)

PLAN.md's `[MATT-PRE-PLAN]` deliverable (d) still reads: *"Control Bar = `ExploreTabBar` re-skin"* — the Conv 171 misattribution. Spec doc §2 corrected this Conv 172: Matt's Control Bar = primary-nav bottom-pill at tablet/mobile; the Role Tab Bar is the Peerloop extension that re-skins `ExploreTabBar`. Update PLAN.md after this pre-plan lands.

---

## 5. Tailwind 4 Wiring (Deliverable F)

Approach driven by Decision 3 above. Assuming **Recommendation C (Hybrid bridge file):**

```css
/* tokens-tailwind-bridge.css */

@import './tokens-primitives.css';
@import './tokens-semantic.css';

@theme {
  /* Tailwind-shaped re-exports — Matt's tokens stay canonical;
     these are auxiliary so utility classes work. */
  --color-text-default: var(--Text-Default);
  --color-text-tertiary: var(--Text-Tertiary);
  --color-text-primary: var(--Text-Primary);
  --color-course-primary: var(--Course-Primary);
  --color-course-background: var(--Course-Background);
  --color-creator-primary: var(--Creator-Primary);
  --color-creator-background: var(--Creator-Background);
  --color-student-primary: var(--Student-Primary);
  --color-student-background: var(--Student-Background);
  --color-primary-default: var(--Primary-Default);
  --color-primary-light: var(--Primary-Light);
  --color-alert-default: var(--Alert-Default);
  --color-alert-light: var(--Alert-Light);
  --color-border-default: var(--Border-Default);

  /* Entity multi-mode tokens — consumed via .entity-* parent class */
  --color-entity-primary: var(--Entity-Primary);
  --color-entity-background: var(--Entity-Background);

  /* Typography ramp — UPDATED Conv 181 [TSV] to use Tailwind 4 modifier-suffix
     syntax, so each `text-{name}` utility emits size + weight + line-height +
     letter-spacing in one class. 18 utility classes total (8 Body + 10 Header).
     Full definitions live in `tokens-typography.css` (Conv 181, 124 lines);
     bridge just re-exports under Tailwind-shaped names.
     Original size-only entries (below) are pre-Conv-181 — REPLACED by the new
     compound syntax. Pattern: `--text-{name}--size`, `--text-{name}--weight`,
     `--text-{name}--line-height`, `--text-{name}--letter-spacing`. */
  --font-sans: 'Inter', system-ui, sans-serif;

  /* Sample (full set in tokens-tailwind-bridge.css): */
  --text-h1: var(--h1-size);
  --text-h1--line-height: var(--h1-line-height);
  --text-h1--font-weight: var(--h1-weight);
  --text-h1--letter-spacing: var(--h1-letter-spacing);
  /* ...repeat for h1-bold, h2/h2-bold, ..., h5/h5-bold, body-{default,default-medium,small,small-medium,medium,medium-bold,large,large-medium} */

  /* Spacing — pixel-named, rem-valued */
  --spacing-4: 0.25rem;
  --spacing-8: 0.5rem;
  --spacing-12: 0.75rem;
  --spacing-16: 1rem;
  --spacing-20: 1.25rem;
  --spacing-24: 1.5rem;
  --spacing-32: 2rem;
  --spacing-40: 2.5rem;
  --spacing-48: 3rem;
  --spacing-64: 4rem;

  /* Radius / shadow / opacity / z-index / duration tokens emit here too —
     see spec doc §6 Batches 6–10 for full lists. */
}
```

**Result:** Pages can use **either** form:

```astro
<!-- Direct var consumption (Matt-canonical) -->
<div style={{ background: 'var(--Course-Primary)' }}>…</div>

<!-- Tailwind utility (bridged) -->
<div class="bg-course-primary">…</div>
```

Both reach the same physical color via the same cascade. Drift between the two requires actively editing the bridge file — grep-visible if it happens.

---

## 6. Page Assembly Pattern (Deliverable E)

Already sketched in §3 above. Repeated principles:

1. **Pages are thin** (target <80 lines, hard ceiling 120). If a page file grows past that, extract a primitive — page files compose, don't author.
2. **Existing data fetchers, unchanged.** `getCourseBySlug(slug)`, `getCurrentUser()`, `getEnrollment(userId, courseId)` — same as legacy app.
3. **Role detection via `CurrentUser`** (spec §3) — Role Tab Bar reads `currentUser.getRoleBadges(courseId)`.
4. **No business logic in `/matt/*` page files.** If a page needs new logic, that logic goes in `src/lib/...` (shared with existing pages or `/matt/*`-only as appropriate).
5. **Tabs use the existing `[tab].astro` catch-all pattern** for role-perspective routing (per `url-routing.md`).

### Phase 4 patterns (Conv 176 — established during `[MATT-EXEC-PRM-2]`)

**~~Stateless primitives discipline~~ — retired Conv 177.** The Conv 176 "no `useState` / `useEffect` in matt/* primitives" discipline was a mitigation for a misdiagnosed bug (presumed dual-React-copy invalid-hook-call). Conv 177 [DSSR-SCOPE] identified the real cause as a Vite cold-start optimizeDeps race, fixed structurally via `vite.optimizeDeps.entries + include: ['astro/virtual-modules/transitions.js']` in `astro.config.mjs`. Matt/* primitives may now use hooks freely. ToDoItem.tsx was returned to a controlled-or-uncontrolled hybrid (`checked?` controlled, `defaultChecked?` uncontrolled, internal `useState(defaultChecked)`). See DEVELOPMENT-GUIDE.md §"Vite SSR Cold-Start Dep Discovery (Conv 177 [DSSR-SCOPE] resolved)" and DECISIONS.md §5 "Matt-Design Primitives May Use Hooks Freely".

**Entity coloring — `@theme inline` cascade OR direct utilities.** Matt's §5 cascade (`bg-entity-background` → `var(--Entity-Background)` → `.entity-student` override) appeared not to propagate in Conv 176 — active rows rendered grey (`:root` default). **Conv 188 root-caused this:** the entity tokens were declared in a plain `@theme { }` block, which resolves `var(--Entity-*)` once at `:root`. Moving them to `@theme inline { }` fixed propagation app-wide; the cascade is now confirmed working through Tailwind utilities. [CASCADE-BROKEN] is resolved. Either approach is valid: the `.entity-*` cascade for components reading an ancestor's entity context, or per-entity utilities (`bg-student-background`, etc., matching `Button.tsx`'s six-variant pattern) for primitives with a discrete `entity` prop. See DEVELOPMENT-GUIDE.md §"`@theme inline` for Cascade-Driven Entity Tokens (Conv 188)".

**`_Demo.tsx` extraction for rich JSX in `.astro` showcases.** Astro's expression-block parser accepts only component references in `{...}` prop positions — raw `<svg>` / `<div>` with attributes crash with `Expected ">" but found "<attribute>"`. When a showcase page needs to demonstrate a primitive with rich JSX content (e.g., SocialPost + embedded Course minicard), extract the wrapper into a React file alongside the primitive, underscore-prefixed (e.g., `_SocialPostDemo.tsx`), and mount it in the `.astro` page as a single `<SocialPostDemo />` reference. See DEVELOPMENT-GUIDE.md §"Astro Expression-Block Only Accepts Component References (Conv 176)".

**SVG → PNG visual reference workflow.** macOS `qlmanage -t -s 1200 -o /tmp file.svg` rasterizes Figma SVG exports to PNG that the Read tool can display visually. Used by Conv 176 to decode Matt's Module / Note / SocialPost / ToDoItem layouts before authoring the primitives. Faster than the [MPV] browser workflow when Chrome MCP is unavailable.

---

## 7. Extrapolation Enumeration (Deliverable G)

Matt drew 31 happy-path screens. The codebase has ~84 page files (Session 317 verification). Matt's design system needs to extrapolate to the rest. This section enumerates **what's missing from Matt's visual language** so we surface gaps during planning, not piecemeal during implementation.

### Categories Matt didn't cover

| Category                       | Examples (existing routes)                                  | Token / primitive needs                                                                                          |
| ------------------------------ | ----------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------- |
| **Admin layouts**              | `/admin/users`, `/admin/courses`, `/admin/recordings`       | Data tables; multi-pane layouts; bulk-action toolbars; admin-only sidebar items                                  |
| **Settings forms**             | `/settings/profile`, `/settings/security`, `/settings/payouts` | Form inputs (text, select, toggle, multi-select); labeled field groups; save/cancel sticky bars               |
| **Data tables**                | Member directory, course listings, payout history           | Table primitives; sort/filter chips; pagination; empty-state row                                                |
| **Empty / error / loading**    | Every route's pre-data state                                | Empty-state illustration slots; error toast; skeleton loader; 404 / 500 / 403 page shells                       |
| **Modal-heavy flows**          | Authentication modals, Stripe checkout, video session join | Modal primitive (Matt likely has one — confirm with Matt's `components/`); confirm/cancel patterns; focus trap   |
| **Visitor (unauth) browsable** | `/discover/*`, public profiles                              | Unauthenticated header treatment; signup CTAs; "view more requires login" gates                                  |
| **Onboarding**                 | `/onboarding`                                               | Step-progress indicator; multi-step form; tag-picker primitive                                                   |
| **Notifications / Messages**   | `/notifications`, `/messages`                               | Notification row primitive (unread state, time-relative); message thread layout; reply input                     |
| **Role-gated dashboards**      | `/teaching/*`, `/creating/*`, `/admin/*`                    | Role-tinted layout chrome (Course-Primary / Creator-Primary / Admin TBD); KPI cards; sparkline charts            |
| **Stripe / payment**           | Checkout flow, payout settings                              | Form input variants (card, expiry, CVC); status indicators (pending / paid / failed); receipt layout              |
| **Search / filter**            | `/discover/members`, `/discover/courses`                    | Search input variants; multi-role filter chips; sort dropdown                                                    |

### Implications for token system

- **Form-input tokens (NOT in spec doc):** Matt's screens don't show form inputs. We'll scaffold from Tailwind defaults; flag for [TSV] follow-up.
- **Status-state colors:** the spec doc has `Alert/Default` + `Alert/Light` for error states but no success, warning, or info equivalents. Scaffold three more (`Success/*`, `Warning/*`, `Info/*`) extrapolating from existing app conventions; flag for Matt to confirm in v2.
- **Skeleton / shimmer:** loading-state visual not in Matt's design. Scaffold from Tailwind defaults; revisit if Matt has a preference.
- **Admin role color:** Matt's semantic palette has Creator / Student / Course but no Admin or Moderator. Existing `RoleBadge` uses amber for moderator. Decision needed: do Admin / Moderator inherit Matt's existing palette (e.g., a neutral gray) or get new role-primary colors? Flag for Matt v2 input; default to neutral `Text-Default` until decided.

### Implications for primitives

- **Form input primitive** — `MattInput.tsx` with variants (text, email, password, textarea, select). Compose from Matt's typography + spacing + Border/Default.
- **Status pill / toast** — derive from Button "soft pill" archetype + Alert colors.
- **Skeleton loader** — primitive that pulses at `--opacity-50` → `--opacity-100`; uses `gray-100` background.
- **Modal frame** — confirm Matt has a Modal primitive; if not, build from Card + overlay + close button.
- **Empty-state slot** — illustration slot + heading + CTA; reusable across routes.

---

## 8. Doc Graduation Criteria (Deliverable H)

`matt-design-system.md` currently has a `🚧 Working draft` banner (line 3). Banner comes off when ALL of these ship:

- [x] All 4 token files (`tokens-primitives.css`, `tokens-semantic.css`, `tokens-tailwind-bridge.css`, and integration into `global.css` import chain) exist and pass `npm run build` *(landed Conv 174 [MATT-EXEC-TKN] Phase 1; commit `579266c`)*. **Conv 181 [TSV] addition:** new file `src/styles/tokens-typography.css` (124 lines, 18 Variables = 8 Body + 10 Header) imported by the bridge; typography section of the bridge rewritten with Tailwind 4 compound-utility syntax.
- [ ] `MattLayout.astro` exists, renders at all 3 breakpoints (desktop ≥ 1025px, tablet portrait ≤ 1024px, mobile ≤ 640px), and at least one `/matt/*` page uses it end-to-end
- [ ] Open Decisions §4 1–8 are all marked resolved (this doc's §4 transitions from "BLOCKING" to "RESOLVED" with the choice recorded)
- [ ] All 5 entity-color modes verified visually (Default / Creator / Student / Course / *Admin/Moderator placeholders*)
- [ ] All 6 Button variants render correctly with seamless-edge pattern preserved for the soft-pill modes
- [ ] At least one Course-detail page (`/matt/course/[slug]`) is fully functional with real data — covers Tab Bar, Entity Header, Sub Nav, content
- [ ] Tailwind utilities `bg-course-primary`, `text-text-default`, etc. resolve correctly in dev build
- [x] `[TSV]` task complete *(Conv 181 [MMP-PH1])* — Color (12/15 primitives + 12/14 semantics verified, 4 entries reclassified as speculative) + Typography (18/18 Variables extracted into new file) both fully canonized. Remaining scaffolded scales (spacing/radius/shadows/opacity/z-index/durations) still pending Matt review but the structural verification is done.

At banner-removal, `matt-design-system.md` becomes the authoritative spec; this `matt-pre-plan.md` doc archives to "Historical — see git history" status.

---

## 9. Execution Sequence

Each phase is a candidate for its own follow-up `[MATT-EXEC-*]` block. Phases are sequential — later phases depend on earlier ones.

| Phase | Block code         | Deliverables                                                        | Dependencies                                       | Conv estimate |
| ----- | ------------------ | ------------------------------------------------------------------- | -------------------------------------------------- | ------------- |
| 1     | `[MATT-EXEC-TKN]`  | tokens-primitives.css, tokens-semantic.css, tokens-tailwind-bridge.css; global.css import chain; build passes | §4 Decisions 1, 2, 3, 4 resolved | 1 conv        |
| 2     | `[MATT-EXEC-SHL]`  | MattLayout.astro (`src/layouts/matt/AppLayout.astro`); Sidebar.tsx; HeaderBar.astro; ControlBar.tsx; SubNav.astro | Phase 1; §4 Decisions 6, 7, 8 resolved             | 1–2 convs     |
| 3     | `[MATT-EXEC-PG1]`  | First `/matt/*` page end-to-end — recommend `/matt/course/[slug]` (highest-value validation) | Phase 2; real course data; CourseHeader primitive  | 1 conv        |
| 4     | `[MATT-EXEC-PRM]`  | Remaining primitives (Button variants, Card, Module, SocialPost, Note, SectionTitle, ToDoItem); RoleTabBar | Phase 3                                            | 1–2 convs     |
| 4.5   | `[MATT-EXEC-CMP]`  | Component import from Matt's Figma Components page (Icons, Buttons audit, Main Nav, Sub Nav upgrade, Entities incl. entity headers, Chat, Post Anchors, Brand verify) — **inserted Conv 178** to keep Phase 5 as pure thin-shell assembly | Phase 4; `.scratch/matt-main/components/` SVGs    | 2–4 convs     |
| 5     | `[MATT-EXEC-PG2]`  | Remaining `/matt/*` pages (12 remaining routes) | Phase 4.5                                          | 2–3 convs     |
| 6     | `[MATT-EXEC-EXT]`  | Extrapolation primitives (form inputs, skeleton, modal, empty-state, status pill) | Phase 5                                            | 1–2 convs     |
| 7     | `[MATT-EXEC-GRD]`  | Doc graduation — flip 🚧 banner off matt-design-system.md; archive matt-pre-plan.md | Phases 1–6 complete; checklist §8 green            | <0.5 conv     |
|       | (`[TSV]`) ✅       | Token Scaffolding Verification — **completed Conv 181 [MMP-PH1]** (Color + Typography canonized; scaffolded scales still pending review) | Phase 1 complete                                   | 1 conv        |
|       | (`[RTB]`)          | Role Tab Bar visual design — runs in parallel with Phase 4          | Phase 3 complete                                   | 0.5 conv      |

**Total estimate:** 10–15 convs end-to-end (revised Conv 178 — Phase 4.5 added). Could compress if multiple phases bundle into one conv when scope allows.

### Critical-path validation gate

After Phase 3 (first `/matt/*` page live), pause for **user validation**: does the actual rendered page match Matt's Figma for the same screen? Visual diff (screenshot vs Figma export). If yes, full speed. If no, retreat to Phase 1/2 and tune tokens before continuing.

---

## 10. Risk Inventory

| Risk                                                                    | Likelihood | Impact | Mitigation                                                                                                                          |
| ----------------------------------------------------------------------- | :--------: | :----: | ----------------------------------------------------------------------------------------------------------------------------------- |
| Matt's design omits multi-role users; Role Tab Bar (Peerloop extension) ships untested against Matt | High | Medium | [RTB] gets explicit design + screenshot review with the user before merging into `/matt/*` pages                                    |
| Two-system color coexistence drifts (old `primary` and new `Primary/Default` diverge by accident) | Medium | Low | Grep guard during PR review; `[TSV]` includes a "no orphaned --color-primary-* usage in /matt/* tree" check                         |
| Figma MCP still unavailable post-MATT-MCP-RETRY                         | Medium    | Low    | Spec doc is already self-contained; MCP would have been an ergonomic upgrade, not a blocker                                          |
| Tailwind 4 `@theme` bridge causes utility-class generation slowdown     | Low        | Low    | Bridge file is small; Tailwind 4's JIT handles it fast; benchmark if build time creeps                                              |
| Matt comes back with corrections to tokens already shipped              | Medium    | Low    | Token NAMES are stable per Scaffolding Policy; VALUES are tuneable. A correction is one `var()` value swap, not a refactor.         |
| Extrapolation pages (admin, settings, forms) hit token gaps mid-implementation | High | Medium | §7 enumeration above pre-identifies gaps; [TSV] catches scaffolded-vs-Matt-actual mismatches before they ship to the user-visible UI |
| Astro absolute-path leak ([AAP]) affects `/matt/*` cross-machine portability | Low | Low | External-blocked; affects dev only, not prod                                                                                        |
| `MattLayout` Header Bar slot model (Decision 7) doesn't generalize cleanly to `/matt/session/[id]/room` (live-session UI, possibly no Header Bar) | Medium | Low | Session room may opt out of layout chrome entirely — design considers a "chrome-less" `MattLayout` variant in Phase 2                |

---

## 11. Outstanding Designer-Side Questions

Tracked in spec doc §4 — pending Matt's answer or non-blocking-fallback:

- **Q1 Visitor flow on Member-only pages** — does Matt's design imply some become Public-browsable, or Visitor only sees existing Public-browsable? Working assumption: Visitor only sees Public-browsable.
- **Q2 Account dropdown** — where does the existing `UserMenu` live in Matt's design? Working assumption: triggered from the Sidebar bottom profile chip.
- **Q3 Footer** — Matt's screens have no footer. Working assumption: `/matt/*` is footer-less.
- **Q5 Featured-course Home hero** — same component as Course Header or distinct? Working assumption: distinct "FeaturedCourseCard" variant; CourseHeader is for the `/course/[slug]` route only.
- **Q6 Free Teacher badge** — state-variant or per-page component? Working assumption: state-variant of Teacher metadata block.
- **Q7 "Exertise" typo** — confirm Matt typo, request fix.
- **Desktop max-width** — Matt confirmed no fixed cap; fluid fill until otherwise specified.
- **44px Mobile Header Bar height** — snap to `--space-48` or `--space-40`? Tracked in [TSV].
- **Primitive naming convention** — three-style mix in one collection. Recommendation §4 Decision 2 above resolves at our end; flag back to Matt for v2.

---

## 12. Document Lineage

- **Conv 173:** Initial creation. Pulled from spec doc + curated build set + existing-app component review. Decision recommendations baked in; user confirmation needed before phase 1 begins.
- **Conv 176:** §6 Phase 4 patterns added (stateless primitives discipline, direct entity utilities, `_Demo.tsx` extraction, qlmanage SVG→PNG workflow) — discovered during `[MATT-EXEC-PRM-2]` Module/Note/SocialPost/ToDoItem/RoleTabBar builds. Cross-references to DEVELOPMENT-GUIDE.md sections added Conv 176.
- **Conv 177:** §6 "Stateless primitives discipline" annotated as retired ([DSSR-SCOPE] resolved via Vite `optimizeDeps.entries + include`, astro stack upgraded to 6.3.7 + cloudflare 13.5.4 + react 5.0.5 + wrangler 4.94.0). Direct entity utilities pattern and `_Demo.tsx` extraction pattern remain in force.
- **Conv 181:** [MMP-PH1] Phase 1 token foundation completed [TSV]. §5 Tailwind 4 bridge — typography ramp REPLACED with Tailwind 4 modifier-suffix syntax to emit size + weight + line-height + letter-spacing per `text-{name}` utility class. New file `src/styles/tokens-typography.css` (124 lines, 18 Variables = 8 Body + 10 Header) imported by bridge. §8 Doc Graduation — [TSV] checkbox marked complete; Phase 1 token deliverables expanded to include the typography file. §9 Execution Sequence — `[TSV]` marked ✅ done (Color + Typography canonized; scaffolded scales still pending review). Also documented new "tokenize-only-matt-variables" principle in DEVELOPMENT-GUIDE.md and `matt-design-system.md` §6 — going forward, individual values become tokens ONLY if Matt has formalized them as Figma Variables (`get_variable_defs` probe is the authority).

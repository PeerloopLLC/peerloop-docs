> **Matt Design System** · [Index](./INDEX.md) · [Pre-plan](../matt-pre-plan.md)

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

5. **No one-off pages.** A `/course/[slug]/about` page should NOT be a custom layout — it composes from primitives: `<MattLayout>`, `<CourseHeader>`, `<RoleTabBar>`, `<SubNav>`, `<Card>` primitives, etc., with URL data wired in. Page files become thin composition layers, not layout authors.

**Implication for the architectural questions already flagged.** This principle also resolves (or at least narrows) several earlier ⚠️ items:
- Header Bar slot carrying different content per breakpoint (§2.3 ⚠) → component with breakpoint-aware children prop or `variant` prop.
- Sub Nav inline-vs-drawer per breakpoint (§2.5 ⚠) → component with a `mode: 'inline' | 'drawer'` prop.
- Role Tab Bar with variable count of role tabs (§2.7) → component with `roles: Role[]` prop.

**Mapping to existing app.** Many primitives already exist (see §3 — `RoleBadge`, `ExploreTabBar`, `Breadcrumbs.astro`, etc.). The design-system work is largely re-skinning these with Matt's tokens, NOT building new components from scratch. Full Matt-component → existing-React/Astro-component mapping table is a sub-deliverable of [MATT-PRE-PLAN] (#10).

### Implications for component architecture

- Most non-trivial display + action components will take an `activeRole` input and render conditionally — **but this is already true in the existing app**; we don't need to invent it.
- The **Role Tab Bar** (Peerloop extension) visually represents existing role-context state; we don't design the role-context state itself.
- Role-encoding mechanism (URL / global / per-entity) — **whatever the existing codebase already does**; check before building the Role Tab Bar component, don't ask Matt.
- The Role Tab Bar will NOT appear in any of Matt's 31 happy-path screens (his design doesn't account for multi-role users at all); no visual spec from Matt. Extrapolate from his tokens + existing `ExploreTabBar` skeleton.
- **Matt's Control Bar** (separate primitive) = bottom-nav strip that appears on tablet portrait / mobile when Sidebar isn't shown. Different component, different layout slot — do not confuse with Role Tab Bar.

---


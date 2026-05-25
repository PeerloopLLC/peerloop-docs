> **Matt Design System** · [Index](./INDEX.md) · [Pre-plan](../matt-pre-plan.md)

## 5b. Component Primitives

*Continuation of §5 — the component-primitive catalog (Button onward). Color/token primitives are in [05-color-and-tokens.md](./05-color-and-tokens.md).*

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
| Main Nav | `150:8666` (master) + `513:15755` (usage) | (no Property 1 — orchestrating composite) | 220px wide, N Nav Items stacked with `gap-[24px]` (widened from `gap-[16px]` Conv 190 [SBAR-REWRITE]; the Main pill's *internal* gap stays `gap-[16px]`) |

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
| Nav Item parent | `text-body-medium-bold` (Inter Semi Bold 16, lh 1.5, ls -0.022em) | `text-body-default-medium` (Inter Medium 14) | 24px |
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

Active-detection rule **(revised Conv 190 [SBAR-REWRITE]):** the active top-level item is **ALWAYS** rendered as the `Main` white pill, whether or not it has children — an item enters `Main` state if `currentPath` matches the item OR any of its children. (Previously `Main` required children and a childless active item rendered as flat `Selected`; that distinction was dropped so every active section pops as the pill against the grey page.) When the active item has children, they render inside the pill: `Selected` if `currentPath` matches the child, else `Default`. `matchHref` treats `/matt` exactly and otherwise matches `currentPath === href || currentPath.startsWith(href + '/')`.

Implementation lives at `../Peerloop/src/components/matt/` (Conv 183):
- `NavSubItem.tsx` — 2 Property 1 variants
- `NavItem.tsx` — 3 Property 1 variants (Default/Selected = flat row; Main = white pill)
- `MainNav.tsx` — orchestrator (props-driven, route-aware); outer stack `gap-[24px]` (Conv 190)
- `Sidebar.tsx` — Peerloop shell consuming MainNav + collapse toggle + brand + Profile cluster (collapse mode is a Peerloop extension per Conv 183 D2; Matt drew only the 220px expanded form). Rewritten Conv 190 — see next subsection.

### App shell — Matt "Layout Desktop" (implemented Conv 190 [SBAR-REWRITE])

Conv 190 rewrote both `Sidebar.tsx` **and** the page shell `AppLayout.astro` to match Matt's "Layout Desktop" frame (`81:1483`). This supersedes the high-level "visual re-skin of `AppLayout`" framing in §3 "Layout shell — existing vs Matt's" — `AppLayout` itself was rewritten, not wrapped.

**Shell anatomy (the grey-page / white-card pattern):**

```
┌──────────────────────────────────────────────┐  ← page bg #f8fafc (grey)
│            ┌───────────────────────────────┐  │
│  Sidebar   │                               │  │  ← content is a floating
│ (transp.)  │   white rounded-20 card       │  │     white card w/ soft shadow
│            │   (Main Panel)                │  │
│  ▸ active  │                               │  │
│   = WHITE  │                               │  │
│     pill   └───────────────────────────────┘  │
└──────────────────────────────────────────────┘
```

- **Page background** `#f8fafc` (grey); the Main Panel is a **floating white `rounded-[20px]` card** with a soft shadow. The sidebar itself is **transparent** (sits on the grey page).
- **Load-bearing interaction:** the active-nav **white pill** (MainNav `Main` variant) only reads as "active" *because* the page behind the sidebar is grey. Sidebar-only changes won't look right without the grey-page / white-card shell — the two are a single design unit.
- **Collapse** is a `«` **double-chevron** at the sidebar top-right (icon `chevrons-left`, harvested Conv 190 as the **43rd Matt SVG** from Figma `keyboard_double_arrow_left`). Collapsed mode still renders the icon-only nav (Conv 183 D2 Peerloop extension).
- **Branding:** Logo rendered at **`Small`** size (was `Medium`).
- **Profile cluster** (sidebar bottom): real avatar + name + a role descriptor line (e.g. "Admin + 2 more"). The descriptor comes from `describeRoles()` (below). Visitor (unauthenticated) renders a fallback identity. *Only the Visitor state was visually verified Conv 190; the logged-in Profile row needs a real login to confirm — tracked as `[MATT-PROFILE-VERIFY]`.*

**Role-display helper — `src/lib/roles.ts` (NEW Conv 190):**

- `userRoles(caps)` → ordered `Role[]` from capability flags, hierarchy **Admin > Creator > Teacher > Moderator > Student** (Student is the base-only role).
- `describeRoles(caps)` → compact label: 1 role → the role name; 2 roles → `"A, B"` (higher first); 3+ → `"A + N more"`; no roles → `"Visitor"` fallback.
- Consumed by `AppLayout.astro` (fetches the user, passes the descriptor into the Sidebar Profile cluster). Reuse `describeRoles` anywhere a compact multi-role label is needed.

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


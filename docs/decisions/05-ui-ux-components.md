> **Part of the [DECISIONS](../DECISIONS.md) set** · [full index](INDEX.md) · [chronological log](decision-log.md)
> Decisions are **latest-wins** — a newer decision supersedes an older one. Content is the verbatim section from the pre-split DECISIONS.md (Conv 228).

## 5. UI/UX & Components

### Net-New Admin Pages Marked `@matt-inspired`, Not `@stand-in`
**Date:** 2026-06-12 (Conv 276)

Net-new admin pages (no `/old/admin` legacy origin, no Figma source frame) carry the `@matt-inspired` provenance marker rather than `@stand-in`. Established by `/admin/promotion-settings`: although every other admin page is `@stand-in` (rehosted from `/old/admin`), a page built fresh from existing admin primitives has no legacy origin, so the `@stand-in` "rehosted legacy" clause would be false.

**Rationale:** Honest provenance — `@stand-in` is the transient legacy-rehost marker; a page with neither a `/old` ancestor nor a Figma frame is `@matt-inspired` by definition. Sets the precedent for future net-new admin pages.

**See:** `src/pages/admin/promotion-settings.astro`; Conv 276.

### Role-Workspace Sidebar IA — Dedicated "Workspaces" Group
**Date:** 2026-06-09 (Conv 255)

Role-workspace nav entries (`/learning`, later `/teaching`+`/creating`) get a **dedicated labeled "WORKSPACES" group** in the expanded sidebar's top region (divider + uppercase label), between the top MainNav cluster and the bottom utility cluster. Rejected: folding them into the top MainNav cluster (alongside Home/My Feed/Courses), and the bottom utility cluster (the Admin/Moderation gated-NavItem precedent). The COLLAPSED_NAV rail gets a matching `Learning` icon. `/learning` is ungated; `/teaching` (isTeacher) + `/creating` (isCreator) join as gated siblings once `isTeacher`/`isCreator` land on `SidebarUser`.

**Rationale:** This is novel sidebar IA — the choice sets placement for all three workspaces. A dedicated group is the most scalable for the trio and visually separates "do my role work" from discovery (top) and utility (bottom).

**Consequences:** `Sidebar.tsx` gained the WORKSPACES group + a COLLAPSED_NAV Learning icon; future convs add `isTeacher`/`isCreator` to `SidebarUser` for the gated siblings.

**See:** `src/components/Sidebar.tsx`; Conv 255.

### Shared `PromoteButton` Across Both Live Feed Renderers; `SocialPost` Gains a Passive `actions` Slot
**Date:** 2026-06-11 (Conv 269)

The Promote button lives in one shared `src/components/feed/PromoteButton.tsx` (owns the password modal + idempotent POST + "Promoted" flip), themed per surface via `className`. Both live feed renderers use it: `FeedActivityCard` (community, refactored onto it) and `MattCourseFeed`→`SocialPost` (course). Because the Matt `SocialPost` primitive is intentionally display-only, it gained an optional `actions?: ReactNode` footer slot it merely renders — interactivity lives in the child the parent passes; callers omitting `actions` render byte-identically. Rejected: duplicating the modal+fetch logic in each renderer.

**Rationale:** DRY — the password/idempotency logic has one home and can't drift between surfaces. The passive-slot pattern lets a display-only primitive host an interactive child without breaking its "no interactivity" contract. (The second live renderer was only discovered via a DOM-truth browser check — the course feed mounts `MattCourseFeed`, not the legacy `CourseFeed`/`FeedActivityCard`; green unit tests don't reveal which island a route mounts.)

**Consequences:** New `PromoteButton.tsx`; `FeedActivityCard` refactored onto it; `SocialPost` gained the `actions` slot; `MattCourseFeed` wired via that slot. `src/components/{feed/PromoteButton,community/FeedActivityCard,ui/SocialPost,course/MattCourseFeed}.tsx`.

### Two-Tier Course Journey Expressed in the SubNav Builder, `CourseJourneyState` Kept Flat
**Date:** 2026-06-04 (Conv 240)

The course-SubNav "Journey" funnel renders a two-tier model — one-time gates (Enroll · Payment · Certificate) bracketing a recurring "X of N" Sessions progress-cluster (`kind:'cluster'`: meter header + My Sessions / Book / Prepare-Join children). That distinction is built in `buildCourseTabs` (`_course-tabs.ts`) via a `CourseTabNavLink | CourseTabNavCluster` discriminated union — **not** in the data layer. `CourseJourneyState` stays flat (`completedCount / scheduledCount / totalModules / bookableCount / nextSessionId / isComplete`); it is not nested into `gates {…}` / `sessions {…}` objects despite the literal [JOURNEY-LOOP] step wording.

**Rationale:** The flat state already carries every field the cluster needs; nesting is cosmetic but churns the interface, `computeCourseJourney`, the NOT_ENROLLED default, and 4 callers' field reads for zero behavioral gain. The conceptual two-tier split belongs at the render/builder layer, where the gates-vs-cluster distinction actually materializes. No loader/schema change needed.

**Consequences:** Smaller blast radius — the change is centralized to `_course-tabs.ts` + `SubNav.astro` (cluster render branch reuses the `@matt-inspired` `ProgressBar` for the meter; active-matching walks cluster children). "My Sessions" moved Explore→Journey; Certificate gate `done` when `isComplete || completedCount===totalModules`. Documented as a deliberate spec deviation in `plan/enroll-nav/README.md`.

**See:** `src/pages/course/[slug]/_course-tabs.ts`, `src/components/SubNav.astro`, `tests/unit/journey-loop-tabs.test.ts`; Conv 240.

### Matt-Design Leaf Primitives Standardized on React (.tsx); Astro for Page-Wrappers
**Date:** 2026-05-24 (Conv 184)

All `src/components/matt/**` leaf primitives are authored in React (`.tsx`). Astro page-wrappers and shells (`AppLayout.astro`, route files under `src/pages/matt/*`, `SubNav.astro`, `SubNavItem.astro`) may import them and render as static HTML at SSR (no JS bundle cost unless a `client:*` directive is added). Files converted Conv 184: MattIcon, UserIcon, EntityPill, EntityLink, IconLabelChip, CourseAnchor. AnalyticCount was born in React.

**Rationale:** Astro renders imported React components as static HTML by default; React has no native way to render `.astro` components. When a primitive may be consumed from BOTH Astro and React contexts (typical for design-system leaves), authoring in React removes the architectural seam. Conv 184 hit the asymmetry when SocialPost.tsx (React) needed to import the originally-Astro Conv 184 primitives — forced a six-file conversion to break the boundary.

**Consequences:** Astro callers pass `className` (React prop name), not Astro's `class`. Existing Astro-side callers (SubNavItem.astro, `/matt/index.astro` showcase, CourseHeader.astro residue) work transparently after import-path + `class`→`className` updates. Future Astro/React seam questions resolve to "primitives are React; pages are Astro." Six superseded `.astro` files deleted Conv 184.

**See:** `src/components/matt/icons/MattIcon.tsx`, `src/components/matt/entity/UserIcon.tsx`, `src/components/matt/entity/EntityPill.tsx`, `src/components/matt/entity/EntityLink.tsx`, `src/components/matt/entity/CourseAnchor.tsx`, `src/components/matt/ui/IconLabelChip.tsx`, `src/components/matt/ui/AnalyticCount.tsx`

### 3-Marker Page-Provenance Convention (`@stand-in` / `@matt-source` / `@matt-inspired`)
**Date:** 2026-05-28 (Conv 207)

Every non-legacy page (`.astro` or page-level `.tsx`) carries exactly ONE of three provenance markers as a top-of-file doc-comment:

- `@stand-in` — transient marker on a legacy-rehost page that needs retrofit (Conv 203 origin)
- `@matt-source <figma-nodeId>` — 1:1 port from a specific Matt-designed Figma frame; may carry multiple nodeIds when a page composes several frames (e.g. `course/[slug]/[...tab].astro` lists 8: Course Feed + 6 tabs + Hero Course Header)
- `@matt-inspired` — built with Matt tokens/primitives/design language but no source Figma frame exists

**Unmarked = legacy.** `dev/*` pages opt-out of the convention. Applied this conv to login/signup/onboarding/index/courses (`@matt-inspired`), course/[slug]/[...tab] (`@matt-source`, 8 frames), 404 (`@stand-in`).

**Rationale:** Existing `@matt-source` was only on leaf components/tokens with 1:1 frame mapping (Conv 195). Pages are orchestrators and may have no source frame at all — they deserve their own marker class. `@matt-inspired` makes "built from Matt's design language" greppable so it can be promoted to `@matt-source` if/when a Figma frame lands. User explicitly endorsed: *"those pages that have none of those are legacy"*.

**Consequences:** Followups spawned — [PROV-CODIFY] (CLAUDE.md + matt-design-system docs), [PROV-SWEEP-MI] (teach prov-sweep.ts about `@matt-inspired`), [STANDIN-404] (404.astro retrofit). Form primitives stay in `PHASE6_EXTRAPOLATION_CANDIDATES` (component-level marker); page marker is distinct.

### Matt's Figma Is Now Layout-Only; CC Owns Page Consistency; Tablet = Wider-Mobile
**Date:** 2026-06-15 (Conv 289)

The Matt phase-out reaches its endpoint: **Matt's Figma is consulted for LAYOUT only — not page designs.** CC owns making the app look and feel consistent using Matt's layout system + tokens; we no longer port Matt *page* frames. The **sole live exception is the novel mobile treatment** (well-framed by Matt). **Tablet (md, 768–1023) = "wider mobile," not desktop** (client preference; aligns with the existing shell-swap-at-`lg`). The non-negotiable floor still holds: **no `/old/*` functionality is lost**. Page conversion continues on the Tier-1/Tier-2 model but is now driven by **CC's consistency judgment on the locked layout foundation**, not by waiting for Matt page frames.

**Rationale:** Matt's page frames stopped arriving; the desktop + mobile layout system he *did* draw is complete enough to be the durable foundation. Treating absent page frames as blockers would stall conversion indefinitely. **Supersedes** the Conv-239 "Matt Phase-Out — Pages Default to @matt-inspired" execution posture: Matt frames are no longer even a preferred-when-available *page* spec — they are layout-only.

**See:** decision-log.md (Conv 289), `docs/as-designed/matt-design-system/08-layout-and-margins.md` §8.3.3, `11-new-routing.md` §Tier-1/Tier-2 Page-Conversion Strategy, memory `project_matt_phaseout_inspired_default`.

### `matt-embedded`: Provenance by Curation, Not Pixel-Origin
**Date:** 2026-05-26 (Conv 197)

A third `@matt-source` provenance class, `matt-embedded`, marks Material-design glyphs that Matt placed into his own Figma frames (e.g. `stars_2`/`accessibility_new` embedded in his Social Post) but never catalogued as design-system icons. Authorship is decided by *curation*, not who drew the pixels: a Material glyph Matt selected into his frame is Matt-authoritative (cite his containing frame); the identical glyph *we* harvested independently (Conv 193 nav-chrome icons) is ours. The class is recorded as the `source` field in `icon-provenance.ts`.

**Rationale:** Consistent with the Conv 195 marker principle that the marker — not pixel-origin — is the authorship signal. Material glyphs have no single owner, so "who drew it" is undecidable; "did Matt curate it into his design" is verifiable from the Figma frame.

**Consequences:** `matt-provenance.md` §9 documents the third class; the 53-icon registry encodes per-icon source (`matt` / `matt-embedded` / ours). `chevrons-left`/`folder` absent from Matt's file → ours; the 10 Conv-193 Material nav glyphs stay ours.

**See:** `docs/as-designed/matt-provenance.md` §9, `src/components/icons/icon-provenance.ts`, `src/components/icons/_INDEX.md`

### MATT-CUTOVER Layout Collision → Legacy to `/old`, Matt Canonical
**Date:** 2026-05-26 (Conv 197)

When the ROUTE-FLIP promoted Matt's design to the root app, the `AppLayout.astro` name collided (legacy + Matt). Resolution: legacy `AppLayout.astro` moves to `layouts/old/AppLayout.astro` (61 refs rewritten); Matt's becomes the canonical `layouts/AppLayout.astro` (9 refs). The full `src/components/matt/*` namespace was dissolved into the `components/` root (83 imports), `/matt/*` URLs flipped to `/`, and 43 legacy page entries relocated to `/old`. No fallback redirects (not production).

**Rationale:** Follows the established `/old` domain principle (Conv 195) and avoids confusion with the pre-existing `LegacyAppLayout.astro`. Path aliases (`@components/`/`@layouts/`, 0 relative page imports) meant file moves broke no imports — the flip reduced to `git mv` + rewriting move-target alias strings and `/matt` URL literals.

**Consequences:** Other legacy layouts (LegacyAppLayout/Admin/Landing) untouched. `MainNav`/`ControlBar` home active-matching rewritten to exact-match `'/'` (a blind `/matt/`→`/` replace inside a `startsWith` check breaks highlighting). [URLDOC-RECONCILE] (#27) tracks the still-pending url-routing.md §§1–7 + file-tree rewrite for the post-flip layout.

**See:** `docs/as-designed/url-routing.md` §8, `src/layouts/AppLayout.astro`, `src/layouts/old/AppLayout.astro`

### Anchor Rows: 9 Distinct Components, No Shared `AnchorRow` Base
**Date:** 2026-05-24 (Conv 184)

Matt's 9 Post Anchor row types (Course / Creator / Certification / Module / Resource / Review / Student-Teacher / Video Clip / Milestone) are each their own React component composing from leaf primitives (`UserIcon`, `EntityPill`, `IconLabelChip`, `Button`, `MattIcon`). NO shared `AnchorRow` base primitive. Reuse happens at the leaf-primitive level, not the row-shape level. CourseAnchor.tsx shipped Conv 184; remaining 8 tracked as `[CMP-ANCH-REST]` for Phase 5.

**Rationale:** Matt's identical inner-frame names (`Frame 153/161/152/150`) across the 9 anchor types are structural evidence of shared shape, but Matt named ONLY the content types — never extracted a generic `AnchorRow` component. Per `feedback_tokenize_only_matt_variables.md`, extract what Matt named, don't extract what he didn't. The data shapes per anchor type are also heterogeneous (course title vs creator bio vs review stars) and would force a slot-heavy abstraction that ages badly. User explicitly chose "9 different components, no shared shape, but re-using other primitives" after considering shared-base alternatives.

**Consequences:** Each new anchor row builds top-down composing existing leaves; no AnchorRow.tsx to maintain. IconLabelChip extracted as an exception (extracted despite Matt not naming it) because user directive ("re-use") plus 25+ occurrences justified the strict-B deviation — annotated in IconLabelChip.tsx header per honest-orphan principle.

**See:** `src/components/matt/entity/CourseAnchor.tsx`, `src/components/matt/ui/IconLabelChip.tsx`

### Tokenize Only What Matt Has Tokenized in Figma (honest-orphan principle)
**Date:** 2026-05-23 (Conv 181)

For all `src/components/matt/**` and `src/styles/tokens-*.css` work: token-ify what Matt has tokenized as a Figma Variable; hardcode (inline Tailwind arbitrary value or hex literal) what Matt has hardcoded; scaffold (token-ify with explicit "Speculative" provenance comment) what Matt hasn't categorized yet. The authoritative signal is whether `get_variable_defs` on a consuming Figma node returns the value as a named Variable — presence/absence in that response IS the decision criterion. Do NOT add a local-only token (e.g., `--note-yellow`) for a value Matt has hardcoded in Figma.

**Rationale:** A hardcoded hex in a `.tsx` file is honest if Matt later changes the value or removes the component — breakage is obvious in diff. A named token implies a level of systematization Matt has NOT made; if Matt changes the value, the token name lies until manually updated. Hardcoded values are self-deprecating; named tokens accumulate stale meaning silently. Imposing our own tokens on values Matt hasn't systematized creates a divergent style guide that ages badly. Conv 181 [NOTE-YELLOW] motivating case: probe revealed Matt's Note yellow (`#FFF6B8` + `#F1E9B0` border) is hardcoded hex in Figma, not a Variable — Note.tsx aligned via inline hex, no `--note-yellow` token added.

**Consequences:** Conv 172's "speculative token" pattern (extrapolating tokens like `--alert-light`, `--carmine-red` from designer absence) retroactively recognized as anti-pattern; preserved this conv per Decision 1 (sub-block isolation) but explicitly NOT extended going forward. Future drift detection becomes mechanical: grep for hardcoded hex in `src/components/matt/**`, periodically re-probe `get_variable_defs`, migrate inline → token when Matt promotes a value to a Variable. Probe protocol: `get_variable_defs` on the consuming node IS the authority; `get_design_context` surfaces hardcoded values as non-Variable usage.

**See:** `memory/feedback_tokenize_only_matt_variables.md`, `src/components/matt/ui/Note.tsx`, `src/styles/tokens-primitives.css` (Speculative sub-block)

### Speculative Tokens Isolated in Dedicated Sub-Blocks with Provenance Comments
**Date:** 2026-05-23 (Conv 181)

When token entries exist in `src/styles/tokens-*.css` that are NOT confirmed in Matt's current Figma (typically Conv 172 extrapolation), move them out of the alphabetical primary list into a dedicated "Speculative (Conv NNN)" sub-block at the end of each file with a provenance comment explaining: source conv, why retained (e.g., Phase 6 extrapolation scaffolding), verify-or-remove milestone. Header counts must reflect Matt-verified vs total. Bridge re-exports follow the same pattern so callsites continue resolving unchanged. Per Decision "Tokenize Only What Matt Has Tokenized" (above), this pattern is preserved for existing speculative entries but NOT extended going forward.

**Rationale:** Honest about provenance without losing scaffolding. Callsites that already reference the token resolve unchanged. Phase 6 [MATT-EXEC-EXT] alert/error UI work doesn't need to rediscover what was scaffolded. Inline `/* Speculative — not in Matt's Figma per Conv 181 — verify or remove during Phase 6 */` comments survive future audits.

**Consequences:** Applied in Conv 181 to `--alert-light` + `--carmine-red` (tokens-primitives.css), `--Alert-Default` + `--Alert-Light` (tokens-semantic.css), and `--color-alert-default` + `--color-alert-light` bridge re-exports. Header updated from "(15)" to "13 Matt-verified". Pattern only applies to pre-existing speculative entries — new speculative tokens should NOT be added per the "Tokenize Only What Matt Has Tokenized" principle.

**See:** `src/styles/tokens-primitives.css`, `src/styles/tokens-semantic.css`, `src/styles/tokens-tailwind-bridge.css`

### Matt-Design Primitives May Use Hooks Freely (Conv 176 stateless-primitives discipline retired)
**Date:** 2026-05-23 (Conv 177) — supersedes Conv 176

`src/components/matt/**` primitive components MAY use `useState`/`useEffect`/etc. The Conv 176 "stateless-primitives discipline" was a mitigation for a misdiagnosed bug (presumed dual-React-copy invalid-hook-call) and is retired. The actual root cause was a Vite cold-start optimizeDeps race, now fixed structurally via `astro.config.mjs` Vite config (see Vite Cold-Start Dep Discovery entry below). Interactive primitives can own their own local state when appropriate; controlled/uncontrolled hybrids (see ToDoItem entry below) are the React-idiomatic shape for primitives that support both modes.

**Rationale:** Conv 177 web research identified the symptom as the industry-wide Vite cold-start dep-discovery race (Remix #10156, TanStack/router #4264, Storybook #32049, Vite #17979/#17986), not a React-copy duplication issue. The 2-line Vite `optimizeDeps.entries + include: ['astro/virtual-modules/transitions.js']` fix eliminates the cold-start crash entirely; production builds were never affected. With the underlying bug fixed, the ergonomics tax of stateless-only primitives is unnecessary. Sidebar.tsx (1 useState, hookful all along) works fine in dev and production.

**Consequences:** ToDoItem.tsx rewritten as controlled-or-uncontrolled hybrid (see next entry). Module/Note/SocialPost/RoleTabBar remain hookless because their current behavior doesn't require local state — not because hooks are forbidden. Future matt/* primitives free to choose the right shape per component. DEVELOPMENT-GUIDE.md "Stateless Primitives" section replaced with "Vite SSR Cold-Start Dep Discovery" documenting the real diagnosis and fix recipe.

**See:** `astro.config.mjs` (Vite optimizeDeps block), `docs/reference/DEVELOPMENT-GUIDE.md` § Vite SSR Cold-Start Dep Discovery, `src/components/matt/ui/ToDoItem.tsx`

### Matt-Design ToDoItem Uses Controlled-or-Uncontrolled Hybrid Pattern
**Date:** 2026-05-23 (Conv 177)

`ToDoItem.tsx` exposes both `checked?: boolean` (controlled mode) and `defaultChecked?: boolean` (uncontrolled mode) props. Internal `useState(defaultChecked)` holds state when uncontrolled; click toggles internal state when uncontrolled OR calls `onChange` when controlled. The component picks the mode at runtime via `const isControlled = controlledChecked !== undefined`. This is the standard React idiom for primitives that support both modes (matching `<input>`, `<select>`, etc.).

**Rationale:** Existing showcase callsites pass `checked={false}` and `checked={true}` as display-only static states — hybrid mode keeps these working (controlled, no onChange = no toggle, visual variants). Future production callers can use either mode: controlled when state is parent-owned (database-backed enrolled lists, multi-component sync), uncontrolled when the primitive is self-contained (one-off demos, prerequisites lists). Any React contributor recognizes the pattern.

**Consequences:** `ToDoItem.tsx` API: `checked?: boolean` + `defaultChecked?: boolean = false` + `onChange?: (checked: boolean) => void`. Existing showcase usage works unchanged. Other matt/* primitives may adopt the same shape when they need both modes.

**See:** `src/components/matt/ui/ToDoItem.tsx`

### Cascade-Driven Tailwind 4 Tokens Require `@theme inline`, Not Plain `@theme` (Conv 188 — root cause of [CASCADE-BROKEN])
**Date:** 2026-05-24 (Conv 188)

The Conv 176 "use direct entity utilities, not the cascade" workaround (below) is now explained and fixed. Root cause: in Tailwind 4, `@theme { --color-entity-background: var(--Entity-Background) }` resolves the inner `var(--Entity-Background)` **once at `:root`**, so the generated `bg-entity-background` / `text-entity-primary` utilities always emit the `:root` default and ignore the `.entity-*` cascade set on an ancestor. **Cascade-driven tokens (values that change per-subtree via `.entity-*` classes) MUST live in an `@theme inline` block**, which emits the variable reference verbatim so it re-evaluates at the consuming element. Static design tokens stay in plain `@theme`. Fix landed by moving `--color-entity-primary` + `--color-entity-background` to `@theme inline` in `tokens-tailwind-bridge.css`.

This bug had silently rendered EntityPill / EntityLink / UserIcon-initials role colors as the grey default app-wide whenever inside an `.entity-*` context. With the fix, the `.entity-*` cascade + `bg-entity-*` utilities now work — the Conv 176 direct-utility workaround is no longer required for new work (existing direct-utility primitives may stay; mixing is acceptable).

**Consequences:** `roleDot` corner-dot on UserIcon (the trigger) now resolves `--Entity-Primary` correctly. Entity-heavy pages change appearance app-wide (intended correction) — worth an eyeball pass. Supersedes the "exact failure mode unknown" hedge in the Conv 176 entry below.

**See:** `src/styles/tokens-tailwind-bridge.css`, `src/components/matt/entity/UserIcon.tsx`

### Matt-Design Primitives Use Direct Entity Utilities, Not the `.entity-*` Cascade
**Date:** 2026-05-22 (Conv 176)

> **Conv 188 update:** Root cause found and fixed — see "Cascade-Driven Tailwind 4 Tokens Require `@theme inline`" above. The cascade now works; this entry's workaround is retained for historical context and remains valid for existing direct-utility primitives.

Inside matt/* primitive components, color/entity context is implemented via direct entity-specific Tailwind utilities keyed off the `entity` prop (`bg-student-background`, `text-creator-primary`, `bg-course-background`, etc.) — matching the Button.tsx six-variant pattern. Do NOT rely on the parent class cascade `.entity-student { --Entity-Background: var(--Student-Background); }` combined with `bg-entity-background`. The `.entity-*` cascade can still be used on non-primitive components that consume canonical Matt CSS variables (`var(--Entity-Background)`) directly without going through the Tailwind bridge.

**Rationale:** Conv 176 found that the documented cascade (matt-design-system.md §5) does NOT propagate through Tailwind 4's `@theme`-generated `--color-entity-background` intermediate. Empirically the active background renders as the `:root` default (grey) even with `.entity-student` and `bg-entity-background` on the same element. Exact failure mode is unknown — possibly Tailwind 4 computes `--color-entity-background` once at `:root` time, or Vite's transform inlines the value statically. Direct utilities work reliably and match the existing `Button.tsx` precedent. Reliability over elegance until [CASCADE-BROKEN] (task #28) isolates a repro and either fixes the cascade or retires it from the docs.

**Consequences:** Module.tsx + ToDoItem.tsx ship with direct entity utilities per `entity` prop. matt-design-system.md §5 needs an addendum describing when the cascade works and when not. CourseHeader.astro and similar components that work visually need separate verification — they may already use direct utilities under the hood, or they may genuinely consume `var(--Entity-Background)` (not through Tailwind) and the cascade works there.

**See:** `src/components/matt/ui/Module.tsx`, `src/components/matt/ui/ToDoItem.tsx`, `src/components/ui/Button.tsx`

### Rich JSX Prop Content for React Islands Lives in `_Demo.tsx` Wrappers, Not `.astro` Expression Blocks
**Date:** 2026-05-22 (Conv 176)

When a React component prop requires rich JSX content (e.g., an embedded card, a complex icon, structured markup), do NOT inline the JSX inside `.astro` expression blocks (`<Component embed={<div>...</div>} />`). Extract the consumer into a React `.tsx` component file (underscore-prefixed for internal/showcase usage, e.g., `_SocialPostDemo.tsx`) and reference it from `.astro` as a single component reference: `<SocialPostDemo />`. Inside the `.tsx` file, normal JSX (`className=`) is legal.

**Rationale:** Astro's `.astro` expression-block parser only accepts `{<Component />}` (capitalized component references) — NOT raw HTML elements like `{<div>…</div>}` or `{<svg viewBox=…/>}`. This is documented Astro behavior, not a bug ([roadmap discussion #716](https://github.com/withastro/roadmap/discussions/716) tracks broader JSX support but nothing has shipped). Conv 176 hit two distinct parser crashes (`Expected ">" but found "viewBox"`, `Expected ">" but found "className"`) before web research confirmed the design constraint. Working WITH the grain via component-reference extraction is more durable than waiting on Astro to expand the expression-block syntax. The `_Demo.tsx` underscore-prefix also cleanly separates showcase wrappers from production page files.

**Consequences:** SocialPost's Course-minicard embed extracted to `src/components/matt/ui/_SocialPostDemo.tsx`. `_Demo.tsx` extraction pattern documented as the canonical solution. matt-pre-plan.md should document this for Phase 5 page builds. Working alternatives for simple cases: pass an emoji string (`icon="⌘"`), or pass a React component reference (`icon={<MyIcon />}` if `MyIcon` is an imported `.tsx` component).

**See:** `src/components/matt/ui/_SocialPostDemo.tsx`, `src/pages/matt/index.astro`

### Matt-Design AppLayout Owns Slot Defaults via Unconditional Fragment + Ternary
**Date:** 2026-05-22 (Conv 175)

For matt/* layout shells with breakpoint-conditional named slots, default content lives at the layout/consumer level (AppLayout.astro) via a ternary inside an *unconditional* Fragment. Primitive shell components (e.g., HeaderBar.astro) carry NO `<slot>{fallback}</slot>` fallbacks. Single source of truth for defaults.

**Rationale:** Astro counts a Fragment-wrapped forwarded slot as "filled" even when the forwarded inner slot is empty, suppressing the child component's `<slot>FALLBACK</slot>` content. `Astro.slots.has + &&` short-circuit did NOT restore the fallback (root cause unconfirmed — either Astro's short-circuit `{false && <Fragment/>}` produces a Fragment-shaped result counted as "filled" OR `Astro.slots.has` returned true unexpectedly). The dual-layer fallback pattern is too fragile to rely on regardless.

**Pattern:**
```astro
<HeaderBar>
  <Fragment slot="header-center">
    {Astro.slots.has('header-bar-mobile-center')
      ? <slot name="header-bar-mobile-center" />
      : <span data-matt="brand-mark">∞ PeerLoop</span>}
  </Fragment>
</HeaderBar>
```

**Consequences:** HeaderBar.astro slot fallbacks removed; docstring points consumers to AppLayout for defaults. Trade-off: pages using HeaderBar directly (without AppLayout) lose the defaults — acceptable per HeaderBar's docstring noting direct use is rare. Saved learning at `memory/reference_astro_slot_forwarding.md`.

**See:** `src/layouts/matt/AppLayout.astro`, `src/components/matt/HeaderBar.astro`

### Matt-Design Tailwind `lg:` Breakpoint Shifted Globally to 1025px
**Date:** 2026-05-22 (Conv 175)

`tokens-tailwind-bridge.css` `@theme` overrides `--breakpoint-lg: 1025px`. Every `lg:*` callsite — matt/* AND legacy fraser/* pages — now activates at ≥1025px instead of the Tailwind default ≥1024px.

**Rationale:** Matt's spec uses 1025px as the desktop boundary. Single source of truth via the global override matches Matt's design exactly. Same low-blast-radius reasoning as the Conv 174 global `--spacing-N` override on the Matt branch. Alternatives considered: custom `matt:` breakpoint (scoped but verbose, every `lg:*` rewrite); accept the 1px shift (visually identical, only matters exactly at 1024px) — both rejected for fidelity-to-spec.

**Consequences:** Visual impact only at the 1024px edge case. The branch `jfg-dev-13-matt` ships this token override alongside the Conv 174 `--spacing-N` global override; both auto-revert when the branch is rebased away.

**See:** `src/styles/tokens-tailwind-bridge.css`

### Astro→React `client:*` Boundaries Receive Primitives, Not Constructed ReactNode Trees
**Date:** 2026-05-20 (Conv 165)

When an Astro page needs a React island (`client:load` / `client:visible` / `client:idle`) to render role-specific or page-specific content, pass **primitive descriptors** (booleans, strings, IDs) as props and let the island import its own child components and build the JSX internally. Do NOT construct `ReactNode` instances (`createElement(...)` or JSX) in the `.astro` frontmatter and pass them through to the island.

**Rationale:** Astro hydrates `client:*` components by JSON-serializing their props server-side and re-parsing them in the browser. A `ReactElement` instance survives `JSON.stringify` (its `$$typeof`, `type`, `key`, `props`, `_owner`, `_store` fields are enumerable) but is rebuilt as a *plain object*, not a real React element — React rejects it with "Objects are not valid as a React child (found: object with keys {$$typeof, type, key, props, _owner, _store})". TypeScript accepts the pattern because `ReactNode` is the correct type at the boundary, but the runtime contract fails. The serialization invariant is not modeled in the type system, so 5/5 baseline gates can pass while the page is broken at hydration.

**Consequences:** `CourseTabs` (Conv 165 [CRT]) accepts `isCreatorOfCourse` / `isTeacherOfCourse` / `isAdmin` / `isModeratorOfCommunity` flags rather than an `extraTabs` array of constructed React nodes; the component imports `TeacherSessionsTabContent` (and future role components) directly and builds the extra-tab groups internally. Future role-aware tab groups in [CRT-4]/[CRT-5] follow the same pattern. The `extraTabs?` prop on `CourseTabs` stays in the interface as an escape hatch for non-Astro callers but is unused from `.astro`. Any conv that introduces a new prop shape on a `client:*` island MUST browser-verify before claiming the slice is done.

**See:** `src/components/courses/CourseTabs.tsx`, `src/components/courses/course-tabs/TeacherSessionsTabContent.tsx`, `src/pages/course/[slug]/sessions.astro`

### Role-Aware Course Tabs: Shared Component When Scope is Identical, Per-Scope Component When It Differs
**Date:** 2026-05-20 (Conv 166)

When multiple role groups (CREATOR / ADMIN / MODERATOR) consume identical data (`?scope=all`) and need identical UI affordances, they share **one** React component (`AllSessionsTabContent`) rendered under multiple group labels via distinct tab IDs (`creator-sessions` / `admin-sessions` / `moderator-sessions`). When a role consumes a different scope (TEACHER → `?scope=teacher`), it gets its own component (`TeacherSessionsTabContent`). The decision rule is **shape of data + UI, not role name**.

**Rationale:** Three components rendering identical data and UI would diverge over time for cosmetic reasons. A single component with externally-supplied group label is the durable shape. Distinct tab IDs preserve per-role URL routing (e.g., `/course/<slug>/admin-sessions` bookmark goes to the ADMIN group's tab). Multi-role users (rare: e.g., creator who is also admin) see redundant group tabs — acceptable cost; verified seed data has Brian as admin and Guy as creator (disjoint), so the redundancy is mostly theoretical.

**Consequences:** `CourseTabs.tsx`'s `extraTabs` useMemo pushes CREATOR (purple), ADMIN (amber), MODERATOR (blue) groups when the corresponding role flag is true; each group has one `AllSessionsTabContent` tab. Future role-aware tabs follow the rule: same-scope-and-UI → reuse the shared component; different-scope-or-UI → new component file.

**See:** `src/components/courses/CourseTabs.tsx`, `src/components/courses/course-tabs/AllSessionsTabContent.tsx`

### Show Unavailable Teachers with Visual Distinction
**Date:** 2026-03-11 (Session 371)

On the booking page, show all certified teachers for a course — including those with no availability — rather than filtering them out. Unavailable teachers are greyed out with a "No availability" badge and cannot be selected.

**Rationale:** The client plans to allow students to message teachers/creators to request teaching. Hiding unavailable teachers would prevent discovery. Visual distinction communicates "exists but not bookable now" without removing information.

### Teacher Pre-Assignment Auto-Advance in Booking Wizard
**Date:** 2026-03-11 (Session 371)

When a student's enrollment has an `assigned_teacher_id` (set at checkout), the booking wizard auto-advances to step 2 (date selection) and shows a compact teacher banner. Step 1 remains viewable via the stepper.

**Rationale:** The teacher was already chosen at purchase. Requiring re-selection is a pointless speed bump. Auto-advance respects the constraint while keeping all information visible.

### Notification Cards: Separate Read from Navigate
**Date:** 2026-03-11 (Session 372)

Notification cards use card click to mark as read, and an explicit labeled button ("Go to Session →", "Browse Courses →") for navigation. Replaced the previous "stretch link" pattern (invisible `<a>` overlay making entire card clickable) which had three UX problems: not obvious the card is clickable, no indication of destination, and click-to-navigate collides with click-to-mark-read.

**Rationale:** Two distinct user intents (read vs navigate) need two distinct interactions. The button is discoverable on mobile where hover states don't exist, and the label tells the user exactly where they'll go.

**See:** `src/components/notifications/NotificationsList.tsx`

### Course Page Merge: Learn Tab Replaces Standalone /learn Page
**Date:** 2026-03-12 (Session 379)

Merge the learning workspace (`/course/{slug}/learn`) into the course detail page as an enrolled-only "Learn" tab with accordion modules. Remove the standalone CourseLearning orchestrator and Curriculum tab. Enrolled students default to the Learn tab; visitors see About.

**Trigger:** Students had two overlapping pages per course (detail + learn) showing duplicate content (curriculum, resources, progress, sessions). Navigation between them was confusing.

**Rationale:** Single page eliminates the navigation gap. The accordion design shows module titles when collapsed (post-purchase reassurance) and expands to full ModuleContent inline. The `/course/{slug}/learn` URL still works as a tab page, so no bookmarks break.

**Consequences:** `CourseLearning.tsx` (579 lines) and `ModuleSidebar.tsx` (110 lines) retired. New `LearnTab.tsx` (~300 lines) and `ModuleAccordion.tsx` (~130 lines) created. Curriculum tab removed. learn.astro converted from standalone to tab page pattern.

**See:** `src/components/courses/LearnTab.tsx`, `src/components/courses/ModuleAccordion.tsx`

### Teachers Tab: Assigned-Teacher Booking Gating
**Date:** 2026-03-12 (Session 379)

For enrolled students, the Teachers tab shows all course teachers but only the assigned teacher's Book Session button is active. Disabled when: (a) not the assigned teacher, or (b) all modules already have sessions booked. Added "Your Teacher" badge on the assigned teacher's card.

**Rationale:** Students should see all teachers (social proof) but shouldn't be confused by multiple active Book Session buttons when they have an assigned teacher. The gating also prevents over-booking beyond available modules.

**See:** `src/components/courses/course-tabs/TeachersTabContent.tsx`

### CourseTabs Decomposition: Per-Tab Sub-Components + extraTabs Prop
**Date:** 2026-03-27 (Conv 040)

Break CourseTabs (1392 lines) into 5 sub-component files (`AboutTabContent`, `TeachersTabContent`, `ResourcesTabContent`, `SessionsTabContent`, `course-tabs/types.ts`) plus a thin shell (~195 lines). The shell accepts `extraTabs: ExtraTabConfig[]` and `basePath` props, allowing any caller to inject role-specific tabs without modifying CourseTabs internals.

**Rationale:** Each render function was already self-contained. Decomposition solved both the monolith maintenance problem and a UX problem where role tabs (Teaching, Creator) were buried below the fold in a separate section. The shell stays role-agnostic; the explore page passes role tabs via props.

> **Insight:** Wrapping a monolith to avoid modifying it can create worse UX than the engineering cost it saves. The Conv 039 approach kept CourseTabs untouched but placed role tabs in an invisible location. The user cut through the complexity: "only one version survives" — making the wrapping workaround unnecessary friction.

**See:** `src/components/courses/CourseTabs.tsx`, `src/components/courses/course-tabs/`

### Catch-All `[...tab].astro` for Tab Sub-Routes
**Date:** 2026-03-28 (Conv 042)

Use a single `[...tab].astro` catch-all file instead of per-file sub-routes for bookmarkable tab URLs. Tab ID validation via `VALID_TABS` Set; invalid segments redirect to base course page. Applied first to `/discover/course/[slug]/[...tab].astro` (15 valid tab IDs: 6 standard + 9 role-specific).

**Rationale:** 1 file vs 8+. Adding new tabs only requires adding to the Set. SSR code is duplicated between index.astro and catch-all, but that's 2 files not 9. Could be retrofitted to `/course/[slug]/` in a future cleanup.

**See:** `src/pages/discover/course/[slug]/[...tab].astro`

### CSS-Based Image Fallbacks
**Date:** 2025-12-27

Use CSS overlay with Tailwind classes instead of external placeholder service.

**Rationale:** Full control over styling; consistent appearance; no external dependency.

### NULL Image URLs in Seed Data
**Date:** 2025-12-27

Set all `thumbnail_url` and `avatar_url` to NULL in seed data.

**Rationale:** Tests fallback rendering path; no 404 errors; clear indication real images needed.

### Toggleable Spec Panel for Development
**Date:** 2025-12-27

Implement toggle button switching between spec view and content view with localStorage persistence.

**Rationale:** Keep documentation accessible while building real content.

### Footer Version Display
**Date:** 2025-12-30

Display version after Privacy/Terms links with commit hash in tooltip. Environment badge: DEV=blue, STG=orange, hidden in PROD.

**Rationale:** Version accessible but unobtrusive; badge helps developers identify environment.

### Course Page Tab Architecture
**Date:** 2026-02-05 (Session 192)

Course detail pages (`/course/[slug]`) use a 7-tab URL-aware interface: **About → Teachers → Resources → Feed → Sessions → Learn → Curriculum**.

| Tab | Visibility | Data Strategy | Route |
|-----|-----------|---------------|-------|
| About | Public (default for visitors) | Server-side | `/course/[slug]` |
| Teachers | Public view; enrolled can book assigned teacher | Server-side (expanded teacher query) | `/course/[slug]/teachers` |
| Resources | Public preview + enrolled full | Client-side fetch (`/api/courses/:id/resources`) | `/course/[slug]/resources` |
| Feed | Enrolled only | Server-side (Stream.io) | `/course/[slug]/feed` |
| Sessions | Enrolled only | Server-side (student's sessions for this course) | `/course/[slug]/sessions` |
| Learn | Enrolled only (default for enrolled) | Server-side (accordion modules + progress) | `/course/[slug]/learn` |
| Curriculum | Enrolled only (being retired) | Server-side | `/course/[slug]/curriculum` |

**Tab ordering rationale:** Follows the student discovery journey — learn about the course, meet teachers, preview materials, see community, then engage with sessions and learning.

**Default tab behavior:** Enrolled students land on the Learn tab; visitors see the About tab. This is handled by `CourseTabs.tsx` based on enrollment state.

**Data strategy:** Tabs use server-side data (passed as props from Astro page) when the data is simple joins. Resources uses client-side fetch because the API encapsulates enrollment gating, R2 download URL generation, and public/private filtering.

**Each tab has a dedicated `.astro` page** for SSR bookmarkability, with `initialTab` prop controlling which tab renders active. Client-side tab switching uses `history.pushState` for SPA-like navigation.

**Key components:** `CourseTabs.tsx` (~195-line shell: tab bar + URL sync + `extraTabs`/`basePath` props), per-tab sub-components in `course-tabs/` (AboutTabContent, TeachersTabContent, ResourcesTabContent, SessionsTabContent), `LearnTab.tsx` (module list + progress tracking), `ModuleAccordion.tsx` (individual module card with 4 visual states: completed, future, future+booked, expanded).

**See:** `src/components/courses/CourseTabs.tsx`, `src/components/courses/course-tabs/`, `docs/as-designed/url-routing.md`

**History:** Originally 5 tabs (Session 192). Sessions and Learn tabs added (Session 377). Standalone `/course/[slug]/learn` page merged into Learn tab as accordion design (Session 379, COURSE-PAGE-MERGE). Curriculum tab will be retired (absorbed into Learn). Decomposed from 1392-line monolith into per-tab sub-components + thin shell (Conv 040).

### Breadcrumb System: Route-Based Defaults + `?via=` Context
**Date:** 2026-02-17 (Session 221)

Breadcrumbs use a reusable `Breadcrumbs.astro` component rendered inside each page's content area (above the `<h1>`). Each page defines its own breadcrumb items. Navigation context is passed via `?via=` query parameters that replace the default trail entirely.

| Via Value | Trail Example |
|-----------|--------------|
| (none/default) | `My Communities > AI Tools` |
| `discover-communities` | `Discover > Communities > AI Tools` |
| `community-courses` | `AI Tools > Courses > Intro to Claude Code` |
| `discover-courses` | `Discover > Courses > Intro to Claude Code` |

**Rationale:** Route-based defaults work for most cases. `?via=` adds context without hidden state — survives refresh, works with bookmarks, requires no client JS. Breadcrumbs are page-owned (not in layout) because top-level pages don't need them. Clean trail replacement (not dual annotation) keeps the UI simple.

**See:** `src/components/ui/Breadcrumbs.astro`, `src/pages/discover/communities.astro`, `src/pages/community/[slug]/index.astro`

### Stretched-Link Pattern for Clickable Cards with Secondary Links
**Date:** 2026-02-17 (Session 222)

Use the stretched-link pattern for any card component that has a primary clickable area with secondary links inside. Outer element is a `<div>` with `position: relative`, the primary link's `::after` pseudo-element stretches to cover the card (`after:absolute after:inset-0`), and secondary links use `relative z-10` to sit above the overlay.

**Rationale:** Nested `<a>` tags are invalid HTML and cause React hydration errors. The `<span role="link">` + `onClick` workaround loses middle-click, right-click, status bar preview, crawlability, and View Transitions. The stretched-link pattern preserves all native link behaviors for both primary and secondary links.

**See:** `src/components/courses/CourseCard.tsx`, `src/components/notifications/NotificationsList.tsx`

### Three-Tier Navigation Strategy
**Date:** 2026-02-17 (Session 222)

Three methods for navigation, each with a specific use case:
- **`<a href>`** — Default for all navigable UI elements (links, menu items, cards)
- **`navigate()` from `astro:transitions/client`** — Programmatic internal navigation after API calls (post-booking redirect, post-mutation page refresh)
- **`window.location.href`** — Reserved for auth boundary crossings (login/logout) and external URL redirects (Stripe, BBB)

**Rationale:** Auth boundaries intentionally need full page reload to clear stale React state. All other internal navigation should use View Transitions for smooth UX. External URLs can't use Astro's router.

**See:** `src/components/booking/SessionBooking.tsx` (navigate), `src/components/context-actions/ContextActionsPanel.tsx` (navigate for soft refresh)

### Dual Icon System: Separate Registries for Astro and React
**Date:** 2026-02-06

Maintain two separate icon systems: `icon-paths.ts` (raw HTML path strings for Astro's `Icon.astro`) and `icons.tsx` (JSX components for React islands). The Astro registry stores raw SVG path data as strings; the React file stores JSX components with React-style attributes (`strokeLinecap`, `strokeWidth`).

**Rationale:** Unifying them would require refactoring every React component that imports from `icons.tsx` — massive blast radius for an Astro-side cleanup. HTML attributes (`stroke-linecap`) and JSX attributes (`strokeLinecap`) are structurally different. Keeping them separate is zero-risk to the working React system. Future unification is possible but deferred.

**See:** `src/lib/icon-paths.ts`, `src/components/ui/Icon.astro`, `src/components/ui/icons.tsx`

### chart.js Replaces Recharts for Analytics Charts
**Date:** 2026-02-06 (Session 209)

Replace Recharts with chart.js + react-chartjs-2 for all analytics chart components (area, bar, pie/donut). chart.js is canvas-based and tree-shakeable via its register pattern.

**Rationale:** Recharts bundled 392 KB (115 KB gzip) — nearly 2x the React runtime — because it includes large D3 internals monolithically. chart.js with selective registration produces 188.5 KB (65.6 KB gzip), a 43% gzip reduction. Canvas rendering is better for analytics dashboards. The existing abstraction layer (`@components/ui/charts`) meant zero consumer changes.

**See:** `src/components/ui/charts/chart-setup.ts`, `src/components/ui/charts/AreaChart.tsx`

### AppNavbar: excludeCapabilities for Inverse Menu Filtering
**Date:** 2026-02-21 (Session 244)

Added `excludeCapabilities` to AppNavbar's `MenuItem` interface as the inverse of `capabilities`. Items with `capabilities` show when a user HAS any listed capability; items with `excludeCapabilities` hide when a user HAS any listed capability.

**Rationale:** Needed for "Become a Creator" (visible only to non-creators) alongside "Creating" (visible only to creators). A generic `excludeCapabilities` array is reusable for future inverse-visibility cases. A `hasCap()` helper was extracted to avoid duplicating the capability switch statement.

**See:** `src/components/layout/AppNavbar.tsx`

### Month Calendar as Single Availability Interface
**Date:** 2026-02-25 (Session 287)

The old weekly grid editor (`AvailabilityEditor.tsx`) is replaced by a month-view calendar. No separate weekly/monthly tabs. Recurring patterns are set within the same flow — after marking a day, prompt "Just this day" or "Every [Tuesday] for [N] weeks." Two interaction modes: ad hoc (click one day) and multi-select (click multiple days).

**Rationale:** Two views for overlapping concepts creates confusion. The month calendar handles everything the weekly editor does (via recurring prompt) plus date-specific overrides. One interface, two modes, recurring as an option within the flow.

**See:** `CURRENT-BLOCK-PLAN.md` (S-T-CALENDAR.INTERACTION section)

### react-day-picker v9 as Calendar Engine
**Date:** 2026-02-25 (Session 287)

Use `react-day-picker` v9 as the month grid engine for the availability calendar. It handles calendar math, keyboard navigation, and accessibility while we render fully custom `Day` components with 6 indicator types (time range, recurring, override, series-end, booked, unavailable).

**Rationale:** Only package supporting full Day component replacement AND built-in non-contiguous multi-select (`mode="multiple"`). Headless/unstyled (Tailwind-native), ~22 kB bundle, 10.6M weekly downloads, MIT. Evaluated and rejected: FullCalendar (no multi-select, opinionated CSS), react-calendar (can't replace cells), react-big-calendar (170 kB), @schedule-x (event-level only).

**See:** `CURRENT-BLOCK-PLAN.md` (S-T-CALENDAR.DESIGN-DECISIONS section)

### URL Query Params for Sub-View Navigation in Astro
**Date:** 2026-03-01 (Session 318)

Use URL query parameters (e.g., `/creating/studio?course=<id>`) for sub-view navigation within a single Astro route, rather than React state. The React component reads the param in a `useEffect` (SSR-safe), while the Astro page reads `Astro.url.searchParams` server-side for breadcrumbs and title.

**Rationale:** URL params provide refresh-safety, browser back button support, and bookmark-ability. Consistent with existing patterns (`Messages.tsx` uses `?to=`, `StripeConnectSettings.tsx` uses `?success=`). The full-page-reload tradeoff is acceptable and consistent with Astro's MPA model.

**See:** `src/components/creators/studio/CreatorStudio.tsx`, `src/pages/creating/studio.astro`

### Custom Platform Calendar Over Library
**Date:** 2026-03-05 (Session 342)

Build a fully custom `PeerloopCalendar` component with year, month, week, and day views rather than adopting react-big-calendar or another library. The component accepts typed `CalendarItem[]` arrays and renders them — it doesn't know what the items are. Role-specific pages fetch and combine data layers based on active filters.

**Trigger:** Audit found 3 independent custom month grids, no week/day views, and react-big-calendar installed but never imported. User wants year/month/week/day views for students, teachers, and admins with extensive filtering and clickable items.

**Options Considered:**
1. Adopt react-big-calendar for week/day views, keep custom month grid — mixes two systems
2. Build fully custom `PeerloopCalendar` ← Chosen
3. Use a different library (FullCalendar, etc.) — same customization friction

**Rationale:** The platform needs cell-level control: availability multi-select, heat-map year views, togglable data layers, role-specific filtering, and Tailwind styling. A library would fight every customization. Custom means the calendar grows with the platform.

**See:** PLAN.md CALENDAR block

### Smart Feed Card Visual System — Source-Type Differentiation
**Date:** 2026-03-20 (Conv 020)

Feed cards are visually differentiated by source type using a `border-l-4` colored accent bar, background tint, and optional right-side source image strip. Color mapping: townhall=`primary` (sky-blue), community=`secondary` (neutral/white), course=`indigo`. Card self-determines its color from activity data — no new props needed.

**Rationale:** Left accent bar is scannable at a glance in mixed Smart Feed, takes zero horizontal space, and composes with the existing highlight ring system (instructor/creator). Indigo used for courses because `primary` (sky-blue) and standard Tailwind `blue` are visually indistinguishable at light tint levels.

### Astro Hydration: client:only="react" for useCurrentUser() Components
**Date:** 2026-03-20 (Conv 020)

Use `client:only="react"` instead of `client:load` for any component that branches on `useCurrentUser()` in its first render. `useCurrentUser()` reads from `window.__peerloop` (not available during SSR), causing hydration mismatch when server renders a loading skeleton but client renders populated state.

**Rationale:** No SEO benefit to SSR for authenticated-only pages. `client:only` skips SSR entirely, avoiding the mismatch while giving identical user experience (loading skeleton still shows briefly from React's initial state).

### Unified Gradient+Initial Avatar Fallback (No placehold.co)
**Date:** 2026-03-20 (Conv 023)

All avatar fallbacks use the `UserAvatar` gradient+initial pattern (`bg-linear-to-br from-primary-400 to-primary-600` with white initial letter). No external `placehold.co` dependency. `UserAvatar` component supports sizes: `xs` (h-6), `sm` (h-8), `md` (h-12), `lg` (h-16), `xl` (h-24). Custom sizes use inline gradient divs with the same styling.

**Rationale:** Eliminates external service dependency, works offline, renders faster, consistent branded look across all components.

**See:** `src/components/users/UserAvatar.tsx`

### Community Cover Image Display — Icon Replacement Pattern
**Date:** 2026-03-20 (Conv 023)

Community cover images (`cover_image_url`) replace the icon/emoji square in the same layout position. Fallback chain: cover image → emoji icon → gradient. Rectangular styling (`rounded-lg object-cover`) not circular like avatars.

**Rationale:** Minimal layout change, works across all contexts (cards, headers, feed directory). Applied to community detail pages, index page, discover page, FeedsHub, and creator dashboard CommunityCard.

### Stream API Timeout (10s AbortController)
**Date:** 2026-03-20 (Conv 020)

All Stream API calls via `streamFetch()` use a 10-second `AbortController` timeout. The existing try/catch in enrichment catches the abort error and falls back to D1-only data.

**Rationale:** Without a timeout, a hanging Stream response hangs the entire Worker request indefinitely — no error, no fallback, unrecoverable even in dev. Discovered when investigating a user-facing infinite hang.

### Unified Dashboard as Additive Page (Not Replacement)
**Date:** 2026-03-25 (Conv 032)

The unified `/dashboard` page uses activity-first sections (Schedule, Needs Attention, Courses, People, Earnings) with role sub-columns, rather than role-first tabs. Original role-specific pages (`/learning`, `/teaching`, `/creating`) remain unchanged and accessible via a Dashboard Links button row at the top.

**Rationale:** Additive approach is zero-risk — composes existing components without modifying them. Activity-first grouping enables cross-role insights (e.g., merged "Needs Attention" across teacher and creator roles) that tabbed approaches cannot provide. Route consolidation deferred to after user evaluation.

> **Insight:** Activity-first vs role-first is the dashboard equivalent of the "normalize by entity vs normalize by use case" database debate. Activity-first wins when a single user holds multiple roles simultaneously, because it surfaces cross-role correlations (like a homework review that appears in both teacher and creator contexts) that role silos hide.

### Dashboard as Single Nav Entry Point
**Date:** 2026-03-26 (Conv 033)

Removed Learning, Teaching, and Creating menu items from AppNavbar. `/dashboard` is the single navigation entry point for all dashboard functionality. Role-specific pages (`/learning`, `/teaching`, `/creating`) remain accessible via direct URL and the DashboardLinks button row on `/dashboard`.

**Rationale:** Unified dashboard (Conv 032) made role-specific nav items redundant. DashboardLinks component already provides drill-down. Eliminates nav crowding. The `become-creator` CTA is retained for non-creators.

**See:** `src/components/layout/AppNavbar.tsx`, `src/components/dashboard/DashboardLinks.tsx`

### Discover Feeds: Discovery Page, Not Feed Inventory
**Date:** 2026-03-28 (Conv 044)

`/discover/feeds` reframed from "My Feeds" inventory to a visitor-accessible discovery page showing active public feeds with "Join Community →" / "View Course →" CTAs. Feeds are derivative artifacts (you get them by joining communities/enrolling in courses), so discovery targets the parent entity, not the feed itself. Reuses existing Smart Feed `getDiscoveryCandidates()` pipeline (~70% overlap). Auth users see topic-matched results; visitors see vitality-ranked popular feeds.

**Rationale:** You can't "join a feed" directly — discovery should surface active conversations with CTAs to the subscribable entity (course/community). Feed-level cards (C1) shipped first; thread-level previews (C2) deferred pending user behavior validation.

> **Insight:** When a domain object is derivative (created as a side-effect of joining something else), discovery UX should target the subscription level, not the artifact level. The artifact is the hook ("look at this conversation"), but the CTA must point to the subscribable parent.

### Admin Tab Pattern for Inline Admin Capabilities
**Date:** 2026-03-28 (Conv 046)

When an admin visits a regular page (course, community, profile), an "Admin" tab appears alongside existing role tabs (Student/Teaching/Created) showing admin-specific actions. This surfaces admin capabilities inline rather than requiring context-switching to `/admin/*` pages.

**Rationale:** Consistent with the discover pages pattern where role tabs appear based on your roles. More discoverable than a floating action button. Handles the complexity of admin also being student/teacher/creator — each role gets its own tab. Deferred to ADMIN-PAGE-ROLE block (#38) in PLAN.md.

> **Insight:** When privileged users have a dedicated admin section but zero inline presence on regular pages, they must context-switch between "browsing" and "administering." Surfacing capabilities via role tabs keeps the admin in-flow while maintaining clean separation from regular user UI.

### useAuthStatus Hook — Separate from useCurrentUser
**Date:** 2026-03-29 (Conv 052)

Added `useAuthStatus()` as a separate reactive hook rather than changing `useCurrentUser()`'s return type. Components that show skeleton loaders use `authStatus === 'loading'` to distinguish "still loading" from "not authenticated" — preventing infinite skeletons when sessions expire after SSR.

**Rationale:** Zero breaking changes across 14 existing `useCurrentUser()` consumers. Mirrors the existing `subscribeToUserChange` listener pattern. The `AuthStatus` type (`loading | authenticated | visitor | session_expired | error`) was already defined in `NetworkState` but not exposed reactively.

### Hydration-Safe Hooks by Default
**Date:** 2026-03-29 (Conv 054)

`useCurrentUser()` and `useAuthStatus()` initialize with SSR-compatible values (`null` / `'loading'`), then populate from localStorage cache in `useEffect`. This ensures the first client render matches server HTML in Astro `client:load` islands. The fix lives in the hooks themselves — not in per-component `hasMounted`/`effectiveUser` workarounds.

**Rationale:** Per-component hydration guards appeared in 3 files before the pattern was identified as systemic. Hook-level fix is 2 lines in one file vs ~15 lines across every consumer. Any future component gets hydration safety for free. Brief additive flash on discover pages (role tabs/badges appearing) is imperceptible.

**Pattern:** `useState(null)` + `useEffect(() => setState(getFromCache()), [])` instead of `useState(() => getFromCache())`.

> **Insight:** When an SSR framework hydrates client components, any hook that reads browser-only state (localStorage, cookies, window) must defer that read to useEffect. Initializing with the browser value creates a hydration mismatch on every page load — the fix must live in the hook, not in consumers, because the invariant (SSR = null) is universal.

### Vitality as Ranking Signal, Not Inclusion Gate
**Date:** 2026-03-29 (Conv 052)

Removed `vitality > 0` filter from feed discovery (5 locations across `discover.ts` and `candidates.ts`). Vitality is used only for `ORDER BY` ranking — feeds with zero activity still appear but rank last.

**Rationale:** Using vitality as an inclusion gate creates a cold-start paradox: new feeds have no posts, so they're never shown, so they can never get posts. Critical for genesis cohort when most feeds will have zero activity. "0 posts in 2 weeks" shown transparently to users.

> **Insight:** Cold-start filtering is a common trap in recommendation systems — any hard threshold that excludes items with no engagement data creates a bootstrapping paradox where new content can never gain engagement because it's never shown. Using the metric for ranking rather than gating solves this while still rewarding active content.

### DOM-Based Toast Over React State for Save Feedback in Astro Islands
**Date:** 2026-04-02 (Conv 077)

Use a standalone `showToast()` function that manipulates the DOM directly (`document.body.appendChild`), outside React's lifecycle, for transient save feedback in CourseEditor and similar Astro React islands.

**Rationale:** React state-based toast never rendered because `setCourse()` triggers Astro island remount, resetting React state before the toast renders. DOM manipulation is immune to component remounts and simpler than React portals. All save handlers across CourseEditor tabs now use `showToast()`.

> **Insight:** In hybrid frameworks like Astro where React components live inside islands, React's state lifecycle is not guaranteed to be stable — the island itself may remount. Escape hatches to the DOM are sometimes the most robust solution for transient UI that must survive framework-level re-renders.

### Shared UI Utilities with Callback-in-State Confirm Pattern
**Date:** 2026-04-03 (Conv 079)

Extracted `showToast()` from CourseEditor into shared `src/lib/toast.ts` and created `src/components/ui/ConfirmModal.tsx` as the first shared UI component. All 18 files with alert()/confirm() calls now import from these shared locations. The ConfirmModal uses a callback-in-state pattern: a single `useState<ConfirmState | null>` where the state object includes an `onConfirm` async callback, handling unlimited confirm dialogs per component without N separate state variables.

**Rationale:** 18 files with ~73 alert()/confirm() calls would have required ~500 lines of duplicated inline code. Shared utilities provide single source of truth, consistent UX, and isolated testability. The `src/components/ui/` directory is established as the home for reusable UI components.

> **Insight:** The callback-in-state pattern (storing an async function inside useState) is a powerful way to handle N different confirmation flows in a single component. Each call site creates a closure capturing its action-specific context, while the modal component handles its own loading/error state and auto-closes on success — cleanly separating "what to confirm" from "how to confirm."

### Unified Member Directory Replaces Three Discover Pages
**Date:** 2026-04-13 (Conv 111)

Consolidated /discover/teachers, /discover/creators, /discover/students into a single /discover/members page with server-side search, multi-role OR filtering, 5 sort options, and Load More UX. Old URLs 301-redirect with role query params. Admin extras (email, status, last active) shown inline rather than on a separate route. "Student" defined as having >= 1 enrollment (not `can_take_courses` capability). Creators without active courses get a dimmed badge (opacity-50).

**Rationale:** Three pages had client-side-only filtering on capped datasets (50-100 records), creating deceptive search UX. Consolidation simplifies navigation (3 links → 1), eliminates the search cap problem, and reduces code (~2350 lines removed, ~450 added). Single mental model for member discovery.

> **Insight:** Client-side search on a pre-loaded subset is a deceptive UX anti-pattern — the search bar implies full-text capability but silently returns incomplete results. If you cap the dataset with LIMIT, you must also cap user expectations (remove the search bar) or move search server-side.

**See:** `src/pages/api/members/index.ts`, `src/components/discover/MemberDirectory.tsx`, `src/components/discover/MemberCard.tsx`

---

### Shared `<RecordingLink>` Component for All Recording-Link Surfaces
**Date:** 2026-05-20 (Conv 163)

All 10 recording-link surfaces (student/teacher session lists, course tab rows, completed-session detail panels, admin recordings list, admin sessions row) render via a single `src/components/ui/RecordingLink.tsx` component — a bordered text "Recording" button (`border-secondary-300 px-3 py-1.5 text-sm`, dark-mode-aware, `target="_blank" rel="noopener noreferrer"`). Detail panels keep their `bg-secondary-50` panel container + "Session Recording" heading but render the same `<RecordingLink>` inline.

**Rationale:** Pre-Conv 163 had 4 inconsistent affordance patterns (icon+tooltip, bordered text, filled icon+"Watch", panel + text link) across the surfaces. One mental model for users, one component to maintain, no fuzzy "dashboard vs tab" split rule. User chose Option B (bordered text everywhere) over Option A (icon-only) and Option C (hybrid by surface type).

**Consequences:** New surfaces displaying a recording URL must import `<RecordingLink>` — do not roll a new `<a target="_blank">`. `/api/admin/sessions` list endpoint gained `recording_url` in its response shape (was queried but dropped). `docs/reference/bigbluebutton.md` UI Surfaces table is authoritative (10 surfaces).

**See:** `src/components/ui/RecordingLink.tsx`, `docs/reference/bigbluebutton.md` § UI Surfaces

---

### /matt/* Scope = Visual Re-Skin of Existing Pages, Not Architecture Work
**Date:** 2026-05-21 (Conv 171)

The `/matt/*` route tree is exclusively a **visual re-skin** of existing Peerloop pages. Each /matt/* route mirrors an existing route and wraps existing data + role logic + permissions in Matt's design language. No schema changes, no new role-encoding, no new behavioral architecture.

**Rationale:** The existing app already handles all multi-role complexity (ExploreTabBar, RoleBadge, CurrentUser singleton, dynamic `[tab].astro` catch-all from Conv 165-166). Matt deliberately worked from a simplified single-role happy-path view — the user is the architect; Matt is the visual designer. Re-implementing behavior under /matt/* would be wasteful and create drift between /matt/* and the rest of the app.

**Consequences:** [MATT-PRE-PLAN] scope shrinks to token files, layout shell visual re-skin, component primitive visual re-skin, and page assembly using existing behavior. What Matt calls "Control Bar" = visual re-skin of `ExploreTabBar`. What Matt calls "Header Bar" = visual re-skin of `Breadcrumbs.astro` (which already supports `?via=` query-param navigation context). Matt's 6th role "Visitor" maps to the existing unauthenticated state (no DB row, middleware-gated) — no schema change. Tokens-as-future-default (Conv 169) flip remains a layout-import swap, not a behavioral migration.

**See:** `docs/as-designed/matt-design-system.md` § Authority Split, `src/components/discover/ExploreTabBar.tsx`, `src/components/ui/Breadcrumbs.astro`

---

### CSS Variable Naming Matches Figma Variable Names Verbatim (Title-Case-Hyphenated)
**Date:** 2026-05-21 (Conv 171)

`tokens-primitives.css` and `tokens-semantic.css` use Matt's exact Figma Variable names — Title-Case-Hyphenated (e.g., `--Text-Default`, `--Course-Primary`) — NOT Tailwind's lowercase-hyphenated convention (e.g., `--color-text-default`).

**Rationale:** Figma Dev Mode exports Figma Variables as real CSS custom properties (`color: var(--Text-Default, #414141);`). Matching the source naming verbatim makes future paste-back from Dev Mode one-to-one lossless — no translation layer between Figma source and CSS implementation. Reduces drift risk.

**Consequences:** Tailwind 4 `@theme` block must reference these custom property names directly. Standard Tailwind utility classes (e.g., `bg-primary`) need explicit theme mappings rather than automatic naming derivation. The Figma Variable namespace IS the contract; do not impose a separate convention on top.

**See:** `docs/as-designed/matt-design-system.md` § Color Primitives → naming convention

---

### Token Scaffolding Policy: Complete-From-Day-1, Pixel-Named, Snap Off-Scale Values
**Date:** 2026-05-22 (Conv 172)

For Matt-design token extraction, adopt a complete standard scale from day 1 across ALL unformalized token types (spacing, border-radius, shadows, opacity, z-index, animation durations) — not just the ~4 values Matt explicitly drew. Token names are pixel-keyed (`--space-4` = 4px, `--space-16` = 16px). Matt's off-scale measurements within 1-3px of a standard scale value are snapped (17→16, 23→24, 49→48, 44→48); only intentional one-off literals (e.g., 168px page padding) are preserved exactly.

**Rationale:** Extrapolating Matt's 31 happy-path screens to the ~84-page full app requires values Matt didn't draw. Shipping only Matt's 4 confirmed values forces ad-hoc additions later, which drift. Token NAMES are the stable interface (consumed by component CSS); VALUES are tuneable via `[TSV]` follow-up against Matt's design. Tailwind 4 alignment (4-base scale) lights up `p-1`/`p-2`/etc. utility classes for free. User-confirmed rationale: "I see great value in setting up all of the variables/systems at the beginning. We can always change the values."

**Consequences:** `matt-design-system.md` §6 expanded from 5 Matt-extraction batches to 10 (Border Radius × 9, Shadows × 7, Opacity × 15, Z-index × 7, Animation Durations × 8 scaffolded). `[TSV]` task #15 queued for follow-up verification pass to surface any snap that doesn't match Matt's design intent.

**See:** `docs/as-designed/matt-design-system.md` §6 Token Extraction & Scaffolding, §Token Scaffolding Policy

---

### Preserve Cascade Chains in CSS — Never Flatten Downstream Semantics to Primitives
**Date:** 2026-05-22 (Conv 172)

When authoring `tokens-semantics.css`, downstream semantic variables MUST reference upstream semantics, not the primitives they ultimately resolve to. Example: `--Student-Primary: var(--Primary-Default);` is correct; `--Student-Primary: var(--americana-blue);` is wrong even though both produce the same color today.

**Rationale:** Color Semantics extraction revealed Matt uses 2-layer indirection in his Figma Variables: `Student/Primary → Primary/Default → americana-blue`. Entity adds a third layer: `Entity/Primary[Student] → Student/Primary → Primary/Default → americana-blue`. The cascade IS the design system's resilience — changing the brand-primary value at `Primary/Default` should propagate automatically to all downstream semantics without manual updates. Flattening destroys this propagation; an "americana-blue" rename or value change would force editing every downstream consumer.

**Consequences:** Documented as implementation rule in §5 Color Semantics + Entity sections of `matt-design-system.md`. Will guide `tokens-semantics.css` authoring during [MATT-PRE-PLAN]. CSS variable mode-switching (e.g., `.entity-course { --Entity-Primary: var(--Course-Primary); }`) is the parent-class cascade pattern that consumes this indirection.

**See:** `docs/as-designed/matt-design-system.md` §5 Variable Collection Inventory → Color Semantics + Entity

---

### Matt-Composes-Pages-From-Components → We Mirror With Parameterized React/Astro
**Date:** 2026-05-22 (Conv 172)

Matt builds Figma pages by instantiating reusable components with per-instance overrides — confirmed by his Button collection (6-mode multi-variant) and `components/*.svg` inventory. We mirror this in code: every Matt component becomes a parameterized React or Astro component. Defaults come from component-level definition; overrides at call-site via props. Variant props (literal union types) for multi-mode components. Astro for static structural shells, React for interactive UI. Slots/children for content composition. No one-off pages — pages are thin composition layers over primitive components.

**Rationale:** Matt's Figma practice (components + instances) directly maps to our React/Astro component model. Mirroring his composition layer preserves design coherence and avoids re-deriving the pattern for each primitive. Discovered after observing Button's 6-mode variant collection + page-structure frames showing the same primitives (Header Bar, Sub Nav, Control Bar) reused across all 31 happy-path screens with different content/positioning per breakpoint.

**Consequences:** Header Bar, Sub Nav, Control Bar, Role Tab Bar all become parameterized components — not breakpoint-specific page-level CSS. Resolves earlier ⚠ items (Header Bar slot content differs per breakpoint; Sub Nav drawer at Mobile; Role Tab Bar as Peerloop extension) via the same composition principle. `MattLayout.astro` is a thin shell that wires slots; primitives carry their own breakpoint-aware variants.

**See:** `docs/as-designed/matt-design-system.md` §2 Architectural Findings → "Matt composes pages from reusable components"

---

### Matt's Control Bar = Bottom-Nav Primary-Nav Primitive (NOT a Role Switcher)
**Date:** 2026-05-22 (Conv 172) — supersedes Conv 171 §2.6 attribution

Matt's "Control Bar" is the bottom-nav primary-nav strip primitive that appears on Tablet Portrait + Mobile (absent on Desktop, where the Sidebar carries primary nav). It is NOT a role-perspective switcher. Role-perspective switching is OUR Peerloop extension, a separate component named **Role Tab Bar**, NOT in Matt's design.

**Rationale:** Tablet Portrait screenshot extraction surfaced direct evidence — the floating 6-icon pill at the bottom of the viewport is what Matt labels "Control Bar." User confirmed: "Matt's design doesn't take any account of roles. To him the only roles are teacher and student and they each get their own pages." Matt's brief was deliberately single-role; he doesn't draw multi-role UI. Conv 171 misattributed Control Bar based on missing Tablet Portrait evidence.

**Consequences:** `matt-design-system.md` §2.6 rewritten; new §2.7 "Role Tab Bar (Peerloop extension)" added; 7 dangling Control Bar references cleaned across §1/§3/§6. `[RTB]` task #14 queued to design the Role Tab Bar component during [MATT-PRE-PLAN] (extrapolated from Matt's tokens + existing `ExploreTabBar` from Conv 042-044).

**See:** `docs/as-designed/matt-design-system.md` §2.6 Control Bar + §2.7 Role Tab Bar

---

### Matt Design CSS Length Units: Hybrid (rem for typography + spacing; px for borders + hairlines)
**Date:** 2026-05-22 (Conv 173)

Matt-design token system emits hybrid CSS length units. Typography emits rem (`--text-base: 1rem`). Spacing emits rem with pixel-anchored names (`--space-4: 0.25rem`). Border-width tokens, 1px UI hairlines, and `--radius-*` stay as px. Mental rule: "rem unless it's a border."

**Rationale:** Standard design-system convergence — Tailwind 4, Material, IBM Carbon all use this pattern. Accessibility where it matters (text scales with user pref); predictability where it doesn't (a `1px` divider stays `1px`). Matches Tailwind 4's native convention so `@theme` integration is frictionless. Pure px would have foreclosed accessibility scaling permanently; pure rem would have introduced naming/value mismatch.

**Consequences:** All token files in Phase 1 (`[MATT-EXEC-TKN]`) emit hybrid units. Spacing token names stay pixel-anchored (`--space-4`, `--space-16`, etc.) but values are rem. Border-width tokens and 1px UI hairlines stay px. `--radius-*` stays px (small absolute sizes, no accessibility concern).

**See:** `docs/as-designed/matt-pre-plan.md` §4 Decision 1

---

### Matt Design Primitive Naming Normalized to kebab-case; Semantics Keep Title/Slash Form
**Date:** 2026-05-22 (Conv 173)

`tokens-primitives.css` emits 15 kebab-case variables (`--ashy-blue`, `--alert-light`, `--americana-blue`, etc.) — normalizing Matt's mixed Figma conventions (kebab-case + Title Case with space + lowercase with space). `tokens-semantic.css` keeps Matt's Title-Case-Hyphenated convention verbatim (`--Text-Default`, `--Course-Primary`). Two conventions in two files, internally consistent.

**Rationale:** Conv 171's "Figma Variable names verbatim" directive remains true for SEMANTICS where Matt's naming is already consistent and CSS-compatible. Primitives are normalized because Matt's own inconsistency would otherwise propagate into our code permanently. The two outliers (`Ashy Blue`, `alert light`) translate to kebab-case trivially — no real fidelity loss. Inconsistency flagged back to Matt for v2 (already in `[TSV]` task).

**Consequences:** `tokens-primitives.css` emits 15 kebab-case variables; `tokens-semantic.css` emits 14 Title/Slash-formatted variables. The two-convention split is the design — each file internally consistent.

**See:** `docs/as-designed/matt-pre-plan.md` §4 Decision 2

---

### Matt Design Tailwind 4 Integration: Hybrid Bridge File `tokens-tailwind-bridge.css`
**Date:** 2026-05-22 (Conv 173)

Phase 1 ships 3 token files: `tokens-primitives.css` (canonical, kebab-case), `tokens-semantic.css` (canonical, Title/Slash), and `tokens-tailwind-bridge.css` (~30 lines) which re-exports semantics as Tailwind-shaped names via `@theme { --color-text-default: var(--Text-Default); ... }`. Both call-site forms work: `bg-[var(--Course-Primary)]` (canonical, arbitrary-value syntax) and `bg-course-primary` (utility class via bridge).

**Rationale:** Best-of-both — canonical Matt-shaped names ARE the source of truth (Conv 171 directive); the bridge gives utility-class ergonomics for the cases (mostly colors) where they matter. Drift is grep-visible because the bridge file is small, in-tree, and updated alongside primary tokens. IDE autocomplete works via the bridge entries.

**Consequences:** Phase 1 ships 3 token files instead of 2. Drift requires actively editing the bridge file. Future primitive/semantic additions need a one-line bridge mapping if utility-class consumption is desired.

**See:** `docs/as-designed/matt-pre-plan.md` §4 Decision 3 + §5 Tailwind 4 Wiring

---

### Matt Design Bridge Includes `--spacing-N` — Accept Global Tailwind Utility-Scale Override on `jfg-dev-13-matt`
**Date:** 2026-05-22 (Conv 174)

`tokens-tailwind-bridge.css` `@theme` block includes `--spacing-4` through `--spacing-64` mapping to canonical `--space-N` tokens (Matt's pixel-named scale; e.g. `--spacing-4: var(--space-4)` = 0.25rem = 4px). Setting `--spacing-N` in Tailwind 4 @theme overrides the default multiplicative utility rule for that N globally. Result: every `p-4`/`m-4`/`gap-4`/`px-4`/`py-4` callsite on `jfg-dev-13-matt` for N ∈ {4,8,12,16,20,24,32,40,48,64} resolves to Matt's pixel value, not Tailwind's default. The existing app has 572 `p-4` callsites alone — these visually shrink 4× (1rem → 0.25rem) on the Matt branch until the flip.

**Rationale:** User chose option B over (A) omit spacing from bridge — forces `/matt/*` to use `p-[var(--space-N)]` (verbose), or (C) Matt-namespaced `--spacing-m4` prefix — ugly utility names. Pre-plan §5 spec called for spacing in the bridge; honoring that intent over "coexist" (Decision 4=B) is the explicit trade-off. Branch (`jfg-dev-13-matt`) is the future-default identity destination — existing-app utility values are transitional pending the flip block. Tightest semantics, lowest friction for `/matt/*` development. Mixed scale on legacy pages is acceptable cost.

**Consequences:** Mixed-scale on `jfg-dev-13-matt`: `p-1` = 4px (multiplicative default), `p-4` = 4px (overridden), `p-5` = 20px (multiplicative), `p-8` = 8px (overridden). Other branches (`jfg-dev-12` and earlier) unaffected. Future tuning of canonical `--space-N` auto-propagates to all utility callsites via the `var()` chain. Pixel-named tokens (`--space-16` = 16px) mean what they say across both Matt's `/matt/*` pages AND the legacy app utility callsites on this branch.

**See:** Conv 174 Decision 1; `src/styles/tokens-tailwind-bridge.css`

---

### Legacy `--spacing-N` Regression — Retrofit Legacy onto Matt, Don't Revert (Conv 191)
**Date:** 2026-05-25 (Conv 191)

The Conv 174 `--spacing-N` global override (above) bit the legacy demo home page: AppNavbar `w-64` rendered at 64px not 256px (every legacy utility in {4,8,12,16,20,24,32,40,48,64} ~4× too small app-wide; steps NOT in that set — 2, 2.5, 3, 6 — fall back to `calc(--spacing * N)` and are unaffected, which is why `p-6` content looked fine while `w-64`/`h-4` broke). **Decision: do not revert** — `/matt` depends on the override and Matt styling is the final resting place for style. Instead migrate legacy components ONTO Matt incrementally (NAV-RETROFIT block). Step 1 restyled AppNavbar in place (Approach B, not a component swap — Matt's `NavItem` is href-only and a swap would lose badge/auth/mobile/onClick) to `w-[220px]`, Matt typography, brand-blue flat active pill.

**Rationale:** Reverting would break `/matt`. Restyle-in-place keeps legacy behavior while adopting Matt's look; Approach A (swap to Matt MainNav/NavItem) deferred until B settles.

**Consequences:** New follow-up sweep tasks: `[NAV-SIBLINGS]` (AdminNavbar/AppHeader `w-64`, MoreSlidePanel `left-64`), `[LEGACY-SPACING-AUDIT]` (broader legacy sweep for the hijacked-step set), `[NAV-ICON-SWAP]`. "New Design"→`/matt/` and a TEMP "Classic App"→`/` demo bridge added bidirectionally.

**Update (Conv 192):** `[LEGACY-SPACING-AUDIT]` quantified the blast radius — **3,894** hijacked-step utilities across **354 legacy files** depend on the OLD (Tailwind) meaning, vs only **11 `matt/` files** that depend on the NEW (Matt) meaning. With the asymmetry now known, the user **reaffirmed "do not revert and do not mass-convert"**: legacy components get fixed in place (arbitrary `[Npx]`) only as the legacy→Matt migration reaches them, since a 354-file mechanical sweep would be thrown away. `[LEGACY-SPACING-AUDIT]` stays an opportunistic per-component task, not a sweep. Fixed in place this conv: `Footer.astro` (full + compact variants, 7 utilities) and `index.astro` dashboard main panel (`h-12 w-12` icon containers + clock → `h-[48px]`, 4 spacing utilities).

**See:** Conv 174 `--spacing-N` entry above; `src/components/layout/AppNavbar.tsx`, `src/components/layout/Footer.astro`, `src/pages/index.astro`, `src/layouts/AppLayout.astro`

---

### View-Transition Persisted Islands Drop Island-Unique Arbitrary Tailwind Utilities (Conv 191)
**Date:** 2026-05-25 (Conv 191)

`transition:persist` islands (e.g. AppNavbar) keep their DOM across client-side View-Transition navigations, but each route only ships the CSS bundle for the utilities IT uses. After / → /matt → /, arbitrary utilities used ONLY by the persisted legacy island (`py-[10px]`) had **0 stylesheet rules** (padding collapsed to 0) while utilities also referenced by the destination route (`w-[220px]`, `gap-[12px]`) survived. Two related VT gotchas surfaced same conv: (1) inline `<script>` in `.astro` runs once at parse, NOT after VT navigations — bind one-time DOM init (e.g. auth-card reveal) to `document.addEventListener('astro:page-load', …)`; (2) a duplicate `style` JSX attr is silently dropped (Vite WARN only) — always MERGE into the existing `style`.

**Rationale:** VT swaps the destination route's CSS bundle in; island-unique arbitrary utilities aren't in it. Likely dev-only (prod ships a single global Tailwind CSS that is never swapped) — not yet verified against a prod build.

**Consequences:** Pattern for persisted-island layout: use standard non-hijacked Tailwind steps (always globally generated) for layout; use inline `style` for one-off px (220px, 16px) immune to CSS swaps. `astro:page-load` binding for VT-safe one-time DOM init. DOM ground truth (`getComputedStyle`/`getBoundingClientRect`/`elementFromPoint`) + dev log over screenshots for dimensional/stacking verification (`feedback_dom_truth_over_screenshots.md`).

**See:** `src/components/layout/AppNavbar.tsx`, `src/components/layout/DiscoverSlidePanel.tsx`, `src/pages/index.astro`

---

### `/matt/courses` Is a Thin Matt-Native Index, Not a Copy of `/discover/courses` (Conv 192)
**Date:** 2026-05-25 (Conv 192)

The `/matt/course/[slug]` family had no reachable index — `/matt/index.astro`'s SubNav already linked to `/matt/courses`, which 404'd. Rather than copy `/discover/courses.astro` and re-target its links, `src/pages/matt/courses.astro` was built fresh (approach B): Matt `AppLayout` + SubNav, reusing the existing `fetchCourseBrowseData` loader, rendering a grid of existing `CourseEmbedCard` (whose CTA already targets `/matt/course/[slug]`). DOM-verified: 6 cards, 6 CTAs all resolving to `/matt/course/[slug]`.

**Options Considered:**
1. Copy `/discover/courses` + parameterize the link base — the `/discover/course/${slug}` hrefs are hardcoded in shared `ExploreCard.tsx`/`ExploreCourseTabs.tsx`/`ExploreTeachingTab.tsx`/`ExploreAllTab.tsx`, so retargeting means forking or prop-threading 5+ production components; also drags in legacy styling + filters/recommendations/admin-intel
2. Thin Matt-native index reusing the existing loader + Matt cards ← Chosen
3. Minimal throwaway gateway

**Rationale:** Cards that own their own hrefs sidestep the shared-component link problem entirely; the destination matches Matt styling; reuses already-built primitives and the canonical loader (convention-compliant, no inline query).

**Consequences:** New page; no shared components forked. Discover unification deferred (`[DISC-UNIFY]` #29) — the loader lacks `primary_topic_id`, which `/discover/courses` needs before it can migrate onto `fetchCourseBrowseData`.

**See:** `src/pages/matt/courses.astro`, `src/lib/.../fetchCourseBrowseData`, `src/components/.../CourseEmbedCard.tsx`

---

### Matt Design Color Coexistence: Existing `--color-primary-*` Sky-Blue Scale Untouched
**Date:** 2026-05-22 (Conv 173)

The existing `global.css` `@theme` block defining `--color-primary-50` through `-950` (sky-blue) stays unchanged. Matt's tokens (primitives + semantics + bridge) live in parallel files. `/matt/*` pages don't import the old scale; they consume Matt's tokens directly or via the bridge. Future flip block will consolidate by removing the old scale.

**Rationale:** Conv 169 directive ("coexist alongside existing") + zero risk to existing app. Replacement would have caused subtle blue shifts on every non-`/matt/*` page overnight — confounders the testing phase doesn't need. Two color systems in one codebase is a manageable mental tax until the flip; consolidation is the flip's job, not Phase 1's.

**Consequences:** `global.css` import chain includes both the existing `@theme` and the new Matt token files. Mental rule for devs: "which blue? which route?" — `/matt/*` uses Matt's blue; everywhere else uses existing primary. Future flip is a one-PR removal of the old scale.

**See:** `docs/as-designed/matt-pre-plan.md` §4 Decision 4

---

### `/matt/` Index Route: Member-Only (Analog of `/dashboard`)
**Date:** 2026-05-22 (Conv 173)

`/matt/` is the member-only home — `AppLayout` (Matt's), JWT-gated by middleware. Visitor flow redirects to `/matt/login` (built alongside; re-skin of existing `/login` page). Matt's `Home.svg` series (community-feed style for authenticated user) maps directly. After the future flip, `/matt/` → `/dashboard` and existing `index.astro` → `/fraser/`.

**Rationale:** Matches Matt's design intent (community feed for authenticated user). Clear auth tier per POLICIES §7. Simple route logic — no auth-tier-detecting branch in one page file. Visitor handling adds one small route (`/matt/login`) instead of one complex SSR-branching root page. Rejected alternatives: public-landing analog (doubles home routes; Matt drew only one Home), auth-tier-detecting single route (confuses POLICIES §7 auth tiers).

**Consequences:** Phase 5 (`[MATT-EXEC-PG2]`) includes `/matt/login.astro` as an explicit deliverable alongside `/matt/index.astro`. The login flow re-skins the existing `/login` page's auth-modal trigger pattern; no new business logic.

**See:** `docs/as-designed/matt-pre-plan.md` §4 Decision 5

---

### Matt Design Sidebar: Build Fresh `matt/Sidebar.tsx` (Not Re-Skin of AppNavbar)
**Date:** 2026-05-22 (Conv 173)

`src/components/matt/Sidebar.tsx` is built fresh from scratch, not derived from `src/components/layout/AppNavbar.tsx` (629 lines with role-based menus, slide-out panels, View Transitions persistence, SWR user loading, mobile hamburger). Hooks/utilities are imported from existing modules: `@lib/current-user`, `openLoginModal`, `UserAccountDropdown`, icon components. View Transitions persist + mobile hamburger logic re-implemented (small — ~30 lines each).

**Rationale:** AppNavbar's role-based menu *logic* lives in `@lib/current-user` and modal utilities (which we import); what's component-specific is DOM shape + panels + IA — exactly what Matt redesigned. Rebuilding lets Matt's IA (brand top / nav middle / earnings+notifications+profile bottom; no slide-out panels) land cleanly without hidden visual compromises. Re-skin would defer the rebuild to the flip block anyway.

**Consequences:** Phase 2 (`[MATT-EXEC-SHL]`) includes a fresh `Sidebar.tsx`. Existing `AppNavbar.tsx` stays untouched (used by all non-`/matt/*` routes). At flip time, `mv src/components/matt/Sidebar.tsx src/components/layout/Sidebar.tsx` (or similar) overwrites AppNavbar; non-`/matt/*` routes update imports.

**See:** `docs/as-designed/matt-pre-plan.md` §4 Decision 6

---

### Matt Design HeaderBar / SubNav: Astro Named-Slot Components
**Date:** 2026-05-22 (Conv 173)

`HeaderBar.astro` exposes three named slots — `<slot name="header-left" />`, `<slot name="header-center" />`, `<slot name="header-right" />`. Layout's breakpoint logic decides outer container (mobile = 3-slot flex row; tablet = centered single slot; desktop = breadcrumb container). Pages opt into the shape they need by passing slot content. SubNav follows the same slot-based pattern per spec §2.5.

**Rationale:** Matt's HeaderBar has 3 distinct content shapes by breakpoint (Desktop = breadcrumb strip; Tablet Portrait = centered brand strip; Mobile = 3-slot row Messages/brand/Notifications). DOM children differ by breakpoint, not just CSS. Astro's named-slot primitive was designed for this. Single import, breakpoint-driven outer container, page-driven inner content. Mobile-only icons (Messages, Notifications) live in the page that needs them, not bundled into a desktop DOM that hides them. Rejected alternatives: breakpoint-conditional internal JSX (all DOM ships everywhere; CSS hides what shouldn't show), three separate components (three imports per page; duplicates breakpoint logic at callsite).

**Consequences:** Phase 2 `HeaderBar.astro` exposes 3 named slots. SubNav follows the same slot-based pattern. Adding a fourth breakpoint shape later doesn't require changing the component — just updating the layout's outer-container CSS.

**See:** `docs/as-designed/matt-pre-plan.md` §4 Decision 7

---

### `MattLayout` Has No Footer
**Date:** 2026-05-22 (Conv 173)

`MattLayout` does not render any footer. Matt's 31 screens show no footer anywhere; respecting his omission rather than smuggling in existing `PublicFooter`/`GatedFooter`. Legal/terms/contact links relocated to Sidebar bottom area near the profile chip, or a Settings sub-route, or Matt's v2 if he designs one.

**Rationale:** Faithful to Matt's design. Cleaner mobile UX (Matt's Mobile already has fixed-bottom Control Bar at 49px). Extrapolation would risk getting it wrong with no Matt-spec to validate against.

**Consequences:** Phase 2 `MattLayout` has no footer slot/element. Phase 5 ensures legal/terms links surface somewhere (recommendation: Sidebar bottom). Flag remains in `matt-pre-plan.md` §11 for Matt-side resolution in v2.

**See:** `docs/as-designed/matt-pre-plan.md` §4 Decision 8 + §11 Designer-Side Questions

---

### Matt's Catalogue Label is Authoritative for Figma-Extracted Asset Naming
**Date:** 2026-05-23 (Conv 178)

When extracting assets (icons, components) from Figma, the **designer's catalogue label** is the authority for codebase naming — NOT Figma's auto-export filename and NOT visual inference. Figma exports assets named after their Material-Icon source (`newspaper.svg`, `mail.svg`, `calendar_month.svg`, `chat_bubble.svg`, `present_to_all.svg`) but Matt's catalogue labels them `Feed`, `Message`, `Calendar`, `Chat`, `Present`. Property variant Components (`Property 1=Up/Down/Left/Right`) are Matt's "Arrow" component (not Chevron, not Caret).

**Workflow:** Build the rename map as a side-by-side: extracted-filename + catalogue-label + final-codebase-name. Catalogue label is the tie-breaker.

**Rationale:** If we lock in Figma's auto-export names, every page consuming "the feed icon" would have to know to look up `newspaper` — broken discoverability. Matt designs the system; his naming is the contract. 3 of the 6 Conv-178 icons would have been wrong by visual guess alone (Arrow not Chevron, Feed not Newspaper, Message not Mail).

**Consequences:** 19 of 39 Conv-178 icons renamed to Matt's labels. `_INDEX.md` (`.scratch/matt-main/components/icons/_INDEX.md`) documents the rule + the 6 Material-Icon→Matt-label corrections. Pattern applies to all future Figma extractions (Buttons, Main Nav, Sub Nav, Entities, Chat, Post Anchors, Brand).

**See:** `.scratch/matt-main/components/icons/_INDEX.md`

---

### Figma Export Setting: "Include bounding box ✅" for Icon Batches
**Date:** 2026-05-23 (Conv 178)

For any icon batch extracted from Figma, "Include bounding box" must be ON. Without it, Figma exports SVGs tight to visible geometry — a tall narrow icon gets `viewBox="0 0 18 22"` while a short wide one gets `viewBox="0 0 24 19"`. With it ON, every icon gets uniform `viewBox="0 0 24 24"` matching Matt's canvas, making `<Icon class="h-6 w-6" />` render every icon at matching visual size.

**Other Figma export settings for icon batches:** Color profile `sRGB` (explicit, not "same as file"), Ignore overlapping layers ✅, Include id ✅, Outline Text ☐.

**Rationale:** Without uniform viewBox, sizing fights happen at every Tailwind class call site. With it, sizing is uniform and utility classes work as expected across the whole set. Verified Conv 178: all 39 extracted icons came out with `viewBox="0 0 24 24"`.

**Consequences:** Default ON for icon batches. Default OFF for illustrations/artwork where SVG should crop to actual content.

---

### Matt Icon Registry: Flat Variants for Arrow/Level/Bookmark (No React Primitive Wrappers)
**Date:** 2026-05-23 (Conv 180)

Matt's Icons section has 3 component sets with internal variants (Arrow: 4 directions; Level: 3 difficulties; Bookmark: 2 states). All 9 variants become standalone flat entries in the icon registry (`arrow-right`, `arrow-left`, `arrow-up`, `arrow-down`, `level-beginner`, `level-intermediate`, `level-advanced`, `bookmark-default`, `bookmark-filled`) rather than being wrapped in typed React primitives like `<Arrow direction="right" />` or `<Bookmark filled />`.

**Rationale:** User preference. Trade-off: dynamic usage now requires string concatenation (`<Icon name={`level-${course.difficulty}`} />`) instead of typed-prop ergonomics. Selected over option B (React primitive wrappers) and C (hybrid).

**Consequences:** Total registry projected at ~45 entries (36 base + 9 variant). Verify final count when MMP-PH2 builds the registry.

---

### Material Design Icons: Incremental Per-Encounter Figma MCP Harvest
**Date:** 2026-05-23 (Conv 180)

When Matt's Figma designs use Material Design icons (`stars_2`, `accessibility_new`, `how_to_reg` discovered Conv 180) that are NOT in his curated 39-icon Icons section, harvest them incrementally per-encounter from Figma MCP rather than installing the `@material-design-icons/svg` npm package.

**Rationale:** Per-icon cost via MCP probe (extract SVG path, add to registry) is small. Avoids upfront npm dependency cost (option B) and avoids consuming Matt's time asking him to promote external icons into his Icons section (option C). Total scope unknown until all 12+ Phase 5 pages walked.

**Consequences:** When MCP output contains an unfamiliar `data-name`, query that node directly via MCP and add the SVG path to the icon registry. Task #28 [CMP-EXT-ICN] stays pending until Phase 5 encounters Material icons during implementation.

### Matt-Namespaced Icon Registry Uses SVG Files as Source of Truth (Vite `?raw` Glob), Not Path-Extracted TS Registry
**Date:** 2026-05-23 (Conv 182)

The Matt-namespaced icon registry stores SVG files at `src/components/matt/icons/svg/*.svg` and consumes them via `import.meta.glob<string>('./svg/*.svg', { query: '?raw', import: 'default', eager: true })` in `MattIcon.astro`. This is distinct from the existing `src/lib/icon-paths.ts` path-string registry pattern (consumed by `Icon.astro`) — Matt's icons stay as SVG files, not hand-transcribed `<path>` strings.

**Rationale:** Aligns with the Conv 181 "tokenize-only-matt-variables" / honest-orphan principle — keep Matt's exact artifact (the SVG file) as the canonical thing rather than translating into our format. Re-exports from Figma drop straight into `svg/` and are picked up by the next build with no registry edits. Trade-off accepted: no compile-time `MattIconName` union (runtime lookup + dev-only warn for unknown names) — registry shape stays provisional until PH4 empirical re-render determines whether type-safety is justified.

**Consequences:** New `src/components/matt/icons/` tree with `MattIcon.astro` consumer + `svg/*.svg` files (39 at landing). Vite glob is new for this codebase. All future Matt icon drops follow this pattern. Fill normalization is required before commit: `s/fill="#414141"/fill="currentColor"/g` plus a distinct-fill audit step for outliers (e.g., `info.svg` arrived with `#1C1B1F` MD3 on-surface default).

**See:** `src/components/matt/icons/MattIcon.astro`, `src/components/matt/icons/svg/`, `src/lib/icon-paths.ts` (parallel pattern)

### MattIcon Reads Each SVG's Intrinsic viewBox — Registry Absorbs Non-24dp Icons
**Date:** 2026-05-24 (Conv 187, supersedes Conv 182 24×24 uniformity)

`MattIcon.tsx` reads each SVG's own `viewBox` (default 24×24 when absent) rather than hardcoding a 24×24 wrapper. Icons are stored at their native size — the first 20×20 Material harvests (`stars-2.svg`, `accessibility-new.svg`) coexist with the 39 existing 24×24 icons with no rescaling. Rejected alternative: rescaling new icons to 24×24 via `<g transform="scale(1.2)">`.

**Rationale:** Durable — future Material harvests at any grid "just work" with no per-file transform special-casing. Existing 24×24 icons render identically via the default fallback. Resolves the deferred [CMP-ICN-REGISTRY] question (was held open from Conv 182 pending PH4 empirical re-render).

**Consequences:** `MattIcon.tsx` is now size-agnostic; the Conv 182 "all icons 24×24" registry-uniformity constraint is dropped. New icon SVGs ship at whatever grid Figma supplies. Fill-normalization step unchanged (`var(--fill-0,…)`→`currentColor`, mask rect→`#D9D9D9`).

**See:** `src/components/matt/icons/MattIcon.tsx`, `src/components/matt/icons/svg/stars-2.svg`, `src/components/matt/icons/svg/accessibility-new.svg`

### CourseHeader Dark-Hero Re-Validated to Matt's Frame — Reverses Conv 184/185 Creator Trio
**Date:** 2026-05-24 (Conv 187, supersedes Conv 184/185 creator-trio decision)

`CourseHeader` (converted `.astro`→`.tsx`) renders course metadata as white `IconLabelChip` `tone="on-dark"` chips over the dark hero image, matching Matt's Course Header Default frame (`517:8935`). This reverses the Conv 184/185 `UserIcon`+`EntityPill`+`EntityLink` creator trio, which did not match Matt's actual frame. The trio is deferred to the future "Meet the Creator" tab.

**Rationale:** External-source-of-truth rule + the C178-REVAL precedent (Conv 185 reversed earlier visual-inspection interpretations the same way). Matt's frame is canonical; the trio was built from a misframed reconnaissance assumption. User confirmed ("B" — keep the reversal). Surfaced under MMP-PH4's live re-render gate, not from spec reading.

**Consequences:** Course page hero now matches Matt (white chips, course CTA button, Primary-Light back button, added student count). `[DARK-HERO-VARS]` closed — both heroes use light-bg pills so no Button dark variant is needed. `matt-design-system.md` still documents the old trio — doc-sync pending (TaskCreate'd). Only the Default variant was re-validated; Enrolled (`597:6504`) + Scheduled (`685:13240`) variants remain unbuilt.

**See:** `src/components/matt/CourseHeader.tsx`, `src/pages/matt/course/[slug]/index.astro`, `src/components/matt/ui/IconLabelChip.tsx`

### Matt's Button CSS Uses Variant-Scoped Variables, Not the Entity Cascade ([CASCADE-BROKEN] Closed)
**Date:** 2026-05-23 (Conv 182, validates Conv 178 finding)

Matt's button CSS uses `var(--Background)` and `var(--Border)` — variant-scoped variables tied to the button's `variant` prop — NOT `var(--Entity-Background)` / `var(--Entity-Primary)` (the cascading entity variables). The Conv 176 "entity cascade doesn't propagate through Tailwind 4 @theme" symptom is therefore not a broken cascade — Matt's button design simply does not consume entity variables. [CASCADE-BROKEN] is closed.

**Rationale:** The Conv 178 Dev Mode CSS inspection revealed Matt's intent: the entity cascade is intended only for components Matt explicitly wired with `--Entity-*` variables (entity headers, route-level entity color hints). Multi-variant primitives like Buttons use a parallel-but-independent variant-prop mechanism. This shapes how MMP-PH3 component primitives are built — variant-prop primitives don't need to consume `--Entity-*`; they need their own `--{Primitive}-{Background,Color,Border}` variable cluster scoped to each variant class.

**Consequences:** `matt-design-system.md` §5 Entity updated with a "Conv 178 validation" follow-up paragraph (Conv 176 symptom paragraph preserved for historical record). "Until [CASCADE-BROKEN] resolves" hedging retired across docs. MMP-PH3 [MATT-EXEC-CMP-BTN] proceeds with confidence on the variant-prop pattern (matches existing `Button.tsx`). Supersedes the Conv 176 "Matt-Design Primitives Use Direct Entity Utilities, Not the `.entity-*` Cascade" entry's open-question framing.

**See:** `docs/as-designed/matt-design-system.md` §5 Entity, `src/components/ui/Button.tsx`

### Matt Button: Single `property1` Prop Mirrors Figma's 5-Value Enum (Strict-B)
**Date:** 2026-05-23 (Conv 183)

`src/components/matt/ui/Button.tsx` exposes a single `property1` prop accepting `'Default' | 'Hover' | 'Large' | 'Small' | 'SmallHover'` — a 1:1 mirror of Matt's Figma Property 1 enum on Button (node `40:482`). Hover and SmallHover are explicit caller-picked states, NOT CSS `:hover` pseudo-class behavior. State and Size are intentionally conflated in this enum because Matt encoded them conflated. The orthogonal `size` prop (Conv 175/176 placeholder) and the Conv 178 "3-orthogonal" doc framing are both retired.

**Rationale:** Source-of-truth fidelity over React idiom, per the `tokenize-only-matt-variables` principle ("hardcode what Matt has hardcoded; tokenize what Matt has tokenized"). MCP probe of `40:482` empirically falsified Conv 178's "3-orthogonal-dimension" claim (Color × State × Size) — Property 1 is actually a flat 5-value enum (Default + Hover + Large + Small + Small Hover, with Large Hover undrawn). Re-orthogonalizing in React would diverge from Matt's source and obscure the empirical reality.

**Consequences:** Callers must manually swap `Default` → `Hover` on mouseover (a wrapper component is appropriate for typical interactivity). Six Color variants (Primary, Outlined, Course, Student, Creator, Default) preserved orthogonally — these ARE Variable-Mode-aware in Matt's source. Hover and SmallHover variants apply Matt's literal hardcoded gradient + `#066ba4` border via inline style (no `--background` / `--border` indirection in Matt's source for these — see Hover-Primary-Specific Gap entry below). Disabled state preserved as a CSS-level `[disabled]` a11y orphan, NOT a 6th `property1` value.

**See:** `src/components/matt/ui/Button.tsx`, `docs/as-designed/matt-design-system.md` §5

### Matt Button Hover Variant Is Primary-Only (Partial Coverage Gap, Deferred to Phase 6)
**Date:** 2026-05-23 (Conv 183)

The `Hover` and `SmallHover` `property1` values render Matt's literal Primary-blue gradient + hardcoded `#066ba4` border regardless of the `variant` (color) prop. Combining `variant="course"` with `property1="Hover"` produces a darkened Primary-blue button, NOT a darkened Course-green one. This mirrors Matt's Figma exactly — his Hover variants do not consume `var(--background)` / `var(--border)` indirection; they hardcode the Primary blue.

**Rationale:** Strict-B fidelity to Matt's source. Per `feedback_tokenize_only_matt_variables.md`, "hardcode what Matt has hardcoded." Proper variant-aware hover styling would require new tokens (e.g., `--Course-Background-Hover`) which Matt has not drawn — inventing them now would violate the tokenize-only-matt-variables principle. The gap is documented and deferred to Phase 6 [MATT-EXEC-EXT] extrapolation work, where multi-state × multi-color coverage gaps get filled.

**Consequences:** Button.tsx comment block notes the gap. matt-design-system.md §5 Button section documents the partial coverage. Phase 6 [MATT-EXEC-EXT] is the place to address it if hover-color-coherence becomes important. When porting any multi-state × multi-color component from Figma, check each state for Variable-Mode-awareness independently — token-collection presence does not guarantee every state uses it.

**See:** `src/components/matt/ui/Button.tsx`, `docs/as-designed/matt-design-system.md` §5

### Matt MainNav Main Pill Is Route-Driven, Not Click-to-Expand
**Date:** 2026-05-23 (Conv 183)

`src/components/matt/MainNav.tsx` renders the "Main" pill state of a Nav Item as a route-derived visual — the pill auto-positions around the active section based on `currentPath`, never via user toggle. At most one Main pill exists at a time. Active-detection rule: an item enters `Main` state if `currentPath` matches it OR any child AND it has children; `Selected` if it matches but has no children; else `Default`. Children inside a Main pill render `Selected` if `currentPath` matches the child.

**Rationale:** Matt's Figma (Main Nav section `108:4468`) has no toggle indicator (▼/▶) anywhere in the design — visual cues for click-to-expand are absent. The "Main" naming supports active-section-display interpretation (vs. "Expanded"). The assembled usage example (`513:15755`) shows exactly ONE Main item with active child inline + N Default siblings, consistent with single-active-section behavior. Pure-function-of-(currentPath, items[]) architecture avoids React state in MainNav itself — sidebar collapse state stays in the Sidebar shell.

**Consequences:** `MainNav.tsx` is stateless; takes `items: NavItemData[]` and `currentPath: string` props. No expand/collapse state in MainNav. Sibling parents always render Default unless their route is current. Pattern reusable for future role-specific sidebars (Admin/Teacher/Student) by supplying different NAV arrays.

**See:** `src/components/matt/MainNav.tsx`, `src/components/matt/NavItem.tsx`, `src/components/matt/NavSubItem.tsx`

### Matt MainNav Uses Props-Driven Data Model (`items: NavItemData[]`)
**Date:** 2026-05-23 (Conv 183)

`MainNav.tsx` accepts navigation data as an `items: NavItemData[]` prop — the caller (e.g., `Sidebar.tsx`) defines the nav structure as a module constant and passes it in. `NavItemData` and `NavSubItemData` interfaces are exported from `MainNav.tsx`. This matches the existing `CourseTabs.tsx` pattern and enables Admin/Teacher/Student sidebar variants from one component.

**Rationale:** Lower-cost decision now than retrofitting later. The primitive is reusable; hardcoding the NAV array inside MainNav would force role-specific copies of the component. The current `Sidebar.tsx` still hardcodes its NAV array as a module constant, but the array passes through to MainNav as a prop — MainNav itself is uncoupled from any specific role.

**Consequences:** `NavItemData` and `NavSubItemData` interfaces exported from `MainNav.tsx` for use by callers. Future role-specific sidebars (e.g., `AdminSidebar.tsx`, `TeacherSidebar.tsx`) can supply their own NAV arrays to a single shared `MainNav` primitive.

**See:** `src/components/matt/MainNav.tsx`, `src/components/matt/Sidebar.tsx`

---

### `useRoleTabs` Owns the Shared Role-Tab Mechanics; Feeds Excluded by Structure
**Date:** 2026-05-31 (Conv 228)

The role-tab mechanics duplicated across the Courses and Communities adapters — hash-init state, hash-sync + `<entity>:tabchange` dispatch, reset-on-logout, map→`RoleTab[]` — are extracted into a shared `useRoleTabs({validTabs, eventName, visibleTabs})` hook (`src/components/useRoleTabs.ts`). The hook OWNS the mechanics and RECEIVES the caller's `useMemo`-derived `visibleTabs`; each adapter keeps its own role-source derivation memo. FeedsDirectory is deliberately excluded (renders its catalog inline, has no sibling-island event, carries extra concerns).

**Options Considered:**
1. Hook receives a derivation callback + deps — rejected (reintroduces the pass-a-function-to-a-hook stale-memo problem)
2. Hook receives caller-derived `visibleTabs`; owns only mechanics ← Chosen

**Rationale:** Passing derived data in (rather than a derivation callback) keeps each component's memo deps natural and lint-clean and means the hook needn't call `useCurrentUser`. The Feeds exclusion is structural, not arbitrary.

**Consequences:** −57 net lines across the two adapters; new `src/components/useRoleTabs.ts`; CoursesRoleTabs + CommunitiesRoleTabs rewritten to consume it.

**See:** `src/components/useRoleTabs.ts`, `CoursesRoleTabs.tsx`, `CommunitiesRoleTabs.tsx`, Conv 228 Decisions.md §2.

---

### Admin Attention Badge Restored on Listing Cards Only; Detail-Page Admin Tab Deferred to RTMIG-4
**Date:** 2026-05-31 (Conv 228)

The per-card admin-intel attention badge (dropped by the Conv 205/221 filter-only ports) is restored on `CourseCatalogCard` + `CommunityCatalogCard` via an opt-in `adminBadgeCount?` prop rendering `<AdminBadge>` (top-right of thumbnail), fed by the admin-gated batch endpoint `/api/admin/intel/{courses,communities}?ids=` keyed to the visible "all"-page IDs (cap 50). The detail-page "Admin" extra-tab is NOT rebuilt — it lives on not-yet-ported detail pages and belongs to the RTMIG-4 detail ports.

**Rationale:** The filter-only ports dropped only the listing surface; the batch endpoints + `AdminBadge` component still exist, so restoration is pure client wiring. The detail-page admin tab is out of scope until its detail page is ported (cards remain 404-honest).

**Consequences:** +21 lines per island (CoursesCatalog + CommunitiesCatalog gain the batch fetch) + opt-in prop per card; no API or schema change.

**See:** `CourseCatalogCard.tsx`, `CommunityCatalogCard.tsx`, `CoursesCatalog.tsx`, `CommunitiesCatalog.tsx`, Conv 228 Decisions.md §3.

---


### Legacy Is the Functional Source of Truth; Matt Is the Skin (Happy-Path-Only)
**Date:** 2026-06-04 (Conv 242)

When a Matt frame redesigns a working legacy surface but drops non-happy-path behavior, **keep the legacy functionality and drape Matt's style onto it** — Matt's designs are happy-path-only. First applied to CALENDAR2: Matt's booking frame (`622:15671`) folds date+time+confirm into a single CTA, but the legacy `SessionBooking` wizard's separate **confirm step** carries the booking summary + reschedule context that the single CTA drops. The re-skin merged date+time onto one screen (per Matt) but **kept the confirm step + step indicator**, swapped in Button/MattIcon, and left status colors as functional Tailwind (Matt has no semantic error/success tokens).

**Rationale:** Matt's design is naive about the non-happy paths that happen during booking; the legacy app is more functional but less polished. Re-skinning while silently dropping behavior is a failed port, not a simplification.

**See:** `src/components/booking/SessionBooking.tsx`, `src/pages/course/[slug]/book.astro`, `project_matt_phaseout_inspired_default` memory; Conv 242 Decisions.md §2.

---

### Relative Day/Time Display Is Formatted Client-Side in the Viewer's TZ (`<time datetime>` + `astro:page-load`)
**Date:** 2026-06-04 (Conv 242)

For TZ-fragile relative-time surfaces (e.g. Matt's "Tomorrow • 9:00 AM" upcoming-session label in the CourseHeader Scheduled variant), keep the ISO UTC timestamp in the data and **format the day + time on the client in the browser's timezone** via a `<time datetime={iso} data-session-time>` element upgraded by an `astro:page-load` script. This is the only option correct on **both** the relative-day AND the time-of-day; absolute server-side rendering leaves the time wrong, and server-relative-with-flag ships debt. The `<time>`-upgrade idiom is reusable by the forthcoming [TZ-AUDIT] sweep.

**Rationale:** "Local" on a Cloudflare Worker = UTC, so any server-side day/time bucketing is off-by-one for far-TZ viewers. Formatting client-side without hydrating the host is the durable display pattern; it pre-solves a TZ-audit slice instead of adding to the debt.

**See:** `src/components/entity/CourseHeader.tsx`, `src/pages/course/[slug]/[...tab].astro`; Conv 242 Decisions.md §3.

---

### Milestone Composer Is a New Focused Island + Shared `postCourseFeed()` Helper (Not a `mode` Prop on MattCourseFeed)
**Date:** 2026-06-06 (Conv 243)

The enrollment-milestone composer on `/course/[slug]/success` (`@matt-source 729:15940`) ships as a new focused `MilestoneComposer.tsx` island, **not** as a `mode="milestone"` branch on `MattCourseFeed`. The course-feed POST contract moves into a shared `src/lib/feeds.ts` `postCourseFeed(slug, text)` helper that both islands call. Posting is real (enrolled student has `canPost: true`; `/old` had only a static bullet, so no behavior lost). The embedded course card reuses `CourseEmbedCard` with a new `showCta?: boolean` prop (default true) passed `false` — post-enrollment an "Enroll Now" CTA is nonsensical.

**Rationale:** The Figma frame diverges from MattCourseFeed (milestone meta row + embedded course card + distinct copy, no feed list), so a `mode` prop would bloat the shared Feed-tab component with milestone-only branching. A focused component + shared post helper keeps both lean; extending `CourseEmbedCard` (default true) reuses the primitive with zero churn to existing call sites.

**See:** `src/components/course/MilestoneComposer.tsx`, `src/lib/feeds.ts`, `src/components/entity/CourseEmbedCard.tsx`, `src/pages/course/[slug]/success.astro`; Conv 243 Decisions.md §1–2.

---

### Aggregated Home-Feed Post Is Display-Only (Teaser), Native Feeds Keep Interactivity
**Date:** 2026-06-10 (Conv 260)

The Matt-redesigned post in the **aggregated Home feed** ([POST-MATT]) is **display-only** social proof — reaction/comment pills are non-interactive; the user clicks through to the source. Interactivity (clickable reactions, CommentSection) stays on the legacy `FeedActivityCard` in the **native** course/community/system feeds, which remain out of scope. The build reused existing Conv-184 Matt primitives (`SocialPost` shell, `AnalyticCount` pills, `CourseAnchor` embed) — no new primitives — and collapsed to a thin `FeedPost.tsx` Activity→SocialPost adapter plus one guarded `SocialPost.feedLink` prop. Two non-colliding click targets: the embedded anchor → its own promo (its CTA), and a discrete "in {feed}" header link → the post's home feed; the card is **not** a single whole-card link (that would swallow the anchor's CTA). Matt's green "Learn More" CTA (#327D00 / #E8F4DF) resolves to the existing Button `variant="course"` (`--Course-Primary`/`--Course-Background`) — no new green variant/token.

**Rationale:** Display-only in the aggregated feed is simpler AND better product — it drives users into communities/courses (flywheel) and sidesteps mixed-source reaction-API / optimistic-update / visitor-can't-react problems. It also matches what `SocialPost` (pure-render) and `FeedActivityCard`'s existing `showFeedLink` mode already pointed at, dissolving the "preserve 502 lines of interactivity" port risk — that work simply stays in `FeedActivityCard`.

**Consequences:** `SocialPost` gained a guarded optional `feedLink` prop (ours-extension; default undefined → existing callers byte-identical). New `FeedPost.tsx` + `_FeedPostDemo.tsx` + `FeedPost.test.tsx` (8 tests); mounted on `/dev/primitives`. Relative-time ("2h") deferred (uses full `formatDateTimeUTC` for now, ties to [TZ-AUDIT]); [SHOWMORE] folded in as char-based v1 for the aggregated post only.

**See:** `src/components/feed/FeedPost.tsx`, `src/components/ui/SocialPost.tsx`, `plan/home-feed-merge/post-format-matt.md`; Conv 260 Decisions.md §1–2.

---

### Per-Post Promote "Hot" Highlight: Dedicated Dial + Stateless In-Card Elevation (FEED-U3d [U3D-POST])
**Date:** 2026-06-14 (Conv 279)

The per-post promote affordance gains an attention-drawing "hot" state on high-engagement posts, settled as two coupled decisions:

- **Dedicated engagement dial.** A 4th `promo_%` dial `promo_post_min_engagement` (default 3, `stat-promo-004`) governs when a post is "hot" — admin-tunable alongside the existing three, surfaced as a 4th card in Promotion Settings (grid → 2×2). **Not** reused from the entity dial `promo_nudge_min_engagement`: post interactions (reactions + comments) and entity members are different units; one shared integer would be semantically muddy. `0` = always highlight.
- **Stateless, in-card.** The highlight is computed every render from live Stream `reaction_counts` (no storage) — it vanishes when the post is promoted (button → "Promoted") or cools below the floor. Visually it's the existing in-card `PromoteButton` swapped to an accented HOT_TRIGGER state (indigo pill, flame icon, "Resonating — promote" cue), owned **inside** the component so the two render paths (`FeedActivityCard`; `MattCourseFeed`→`SocialPost`→`PromoteButton`) can't drift. New pure `lib/promotion/engagement.ts` (`postEngagement`/`isPromoteHot`, client-bundle-safe, no D1). The per-post model (`PromoteButton` + reaction_counts) is entirely distinct from the entity model (`PromoteNudge` + promotable-entities) — they share only the verb "promote."

**Rationale:** Stateless sidesteps the localStorage cache-staleness bug class ([NUDGE-CACHE-FLASH]); in-card elevation reuses one component and auto-covers every feed where `canPromote` is set (course + community); centralized styling can't drift across render paths. Only renders where `canPromote` is true — SmartFeed/HomeFeed/TownHallFeed don't set it, so out of scope.

**Consequences:** New `platform_stats` row `stat-promo-004`; admin Promotion Settings now edits 4 dials. `PromoteButton` gains a `hot` prop; `ml-auto` moved to a wrapper span in `FeedActivityCard` (hot mode discards the caller's className). `postPromoteFloor` threaded parallel to `canPromote` through course/community GETs → CourseFeed/CommunityFeed/MattCourseFeed → FeedActivityCard. Completes the FEED-U3 (home-feed-merge) block.

**See:** `src/lib/promotion/engagement.ts`, `src/lib/promotion/config.ts`, `src/components/feed/PromoteButton.tsx`, `src/components/community/FeedActivityCard.tsx`, `src/components/admin/PromotionSettingsAdmin.tsx`; Conv 279 Decisions.md §1–2.

### Select Primitive Gains a `clearable` Mode (Filter Dropdowns Return to "All")
**Date:** 2026-06-16 (Conv 292)

The `Select` form primitive gains a `clearable` prop: the placeholder empty option renders `disabled={!clearable}`, so a clearable Select's empty option is re-selectable (the user can return to the "All" / no-filter state). The Courses filter dropdowns (Level, Length, Topic) opt in; Sort stays required (non-clearable). Rejected: per-filter explicit `{value:'', label:'All X'}` option in each call site.

**Rationale:** One primitive change fixes all current and future filter-selects rather than touching each call site. The previous default (placeholder `<option value="" disabled>`) trapped any value-selected dropdown — once a value was picked, "All" was unreachable.

**See:** `src/components/form/Select.tsx`, `src/components/courses/CoursesFilters.tsx`; Conv 292 Decisions.md §2.

### Dismissible UI Always Reappears on Reload in Dev/Staging (`ephemeral-dismiss.ts`)
**Date:** 2026-06-16 (Conv 292)

Dismissible UI (onboarding nudge, recommendation bands) reads its dismissed state through a new `src/lib/ephemeral-dismiss.ts` helper. `readDismissed(key)` returns `false` (always-show) when running in dev (`import.meta.env.DEV`), on localhost, or on a `*staging*` hostname; production persists dismissal in localStorage as before. Wired into OnboardingNudgeBanner, RecommendedCourses, RecommendedCommunities. Rejected: manually clearing localStorage each time; a build-time `PUBLIC_` env var (deferred as the more-robust upgrade path).

**Rationale:** Dismissed-and-hidden UI is unaccounted for while building/reviewing pages, and the client tests on staging — keeping these surfaces visible there is essential. The helper is self-contained with no config wiring and covers the known staging URL immediately. Caveat: keys on hostname containing "staging"; upgrade path is a `PUBLIC_` env var.

**See:** `src/lib/ephemeral-dismiss.ts`; memory `project_ephemeral_dismiss_dev_staging`; Conv 292 Decisions.md §3.

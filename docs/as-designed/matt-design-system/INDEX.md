# Matt Design System

🚧 **Working draft — Conv 171+.** Token extraction in progress (Batch 1 done, Batches 2–5 partial). Will mature as the Matt design push proceeds. At the end of [MATT-PRE-PLAN], this doc becomes the authoritative spec for the design-system build and the extrapolation guide for the rest of the app.

> 🧭 **Post-flip note (Conv 197 [ROUTE-FLIP]).** This spec was written while the design system was being built in a **`/matt/*` sandbox namespace**. That namespace **dissolved** at the Conv 197 cutover: Matt's design system became the **root app**, the legacy app moved to **`/old/*`**, and all component/page files were promoted out of `matt/` (e.g. `src/components/matt/X` → `src/components/X`, `src/pages/matt/course/…` → `src/pages/course/…`). Concrete file paths and route examples below have been updated to their post-flip locations; where this spec still narrates "the `/matt/*` re-skin work" as a *concept*, read it as "building the root design system." See `matt-provenance.md` §8 and `url-routing.md` § Route Categories #8.

**Related task:** [MDM] (TodoWrite #13 — token extraction) feeds this doc; [MATT-PRE-PLAN] (TodoWrite #10) consumes it.
**Companion doc:** [matt-pre-plan.md](../matt-pre-plan.md) — execution plan (route map, file structure, blocking decisions, phase sequence) for the `/matt/*` re-skin. Reading order: this doc first (*what*), pre-plan second (*how*).


---

## Document Map

This spec was split from a single 1,717-line file into concern-scoped sections (Conv 192). Read in order, or jump to a section:

| # | Section | Contents |
|---|---------|----------|
| 1 | [Strategic Context](./01-strategic-context.md) | Why the re-skin, goals, what "Matt design" means |
| 2 | [Architectural Findings](./02-architecture.md) | Two-panel shell, header bar, nav patterns, roles, component-composition model |
| 3 | [Existing App Context](./03-app-context.md) | URL routing, course routes, role detection, re-skin targets, files to read |
| 4 | [Open Questions](./04-open-questions.md) | Unresolved design/architecture questions (living) |
| 5a | [Color & Token Primitives](./05-color-and-tokens.md) | Variable inventory, color primitives + semantics, Entity color modes, Icon Size |
| 5b | [Component Primitives](./06-component-primitives.md) | Button, MainNav, SubNav, Entity/Anchor rows, CourseInFeed, AnalyticCount, SocialPost, Brand, ChatBubble, Module/ToDoItem + conventions |
| 6 | [Token Extraction & Scaffolding](./07-token-scaffolding.md) | Working section — 10 token batches (typography, layout, spacing, grid, radius, shadows, opacity, z-index, animation) |
| 8 | [Layout & Margins](./08-layout-and-margins.md) | 🚧 Gap analysis → style guide: content-width / gutter / container / utility-column rules; the "margin jar" + Figma open-questions checklist (Conv 288) |

> **Companion:** [matt-pre-plan.md](../matt-pre-plan.md) — the execution plan (*how*) that consumes this spec (*what*).

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
  - **§5 Variable Collection Inventory:** added 6th collection — **Typography (18 Variables = 8 Body + 10 Header)** — fully extracted into NEW file `src/styles/tokens-typography.css` (124 lines). Two leading regimes identified: Body small (12-14px) + Headers (14-32px) at `lh:1`/`ls:0`; Body large (16-20px) at `lh:1.5`/`ls:-0.022em` (Figma `-2.2` is a percentage, corrected Conv 190). Bridge re-exports all 18 via Tailwind 4's `--text-{name}--<modifier>` compound-utility syntax.
  - **§6 Token Scaffolding Policy:** narrowed by Conv 181's **"tokenize only Matt's Variables"** standing principle (`memory/feedback_tokenize_only_matt_variables.md`). Going forward, individual values become tokens ONLY if Matt has formalized them as Figma Variables (probe-verified via `get_variable_defs`); the scaffolded-scale policy (spacing/radius/shadows/etc.) is unchanged. Note primitive Conv 181 [NOTE-YELLOW] aligned to Matt's exact Figma spec (yellow `#FFF6B8`, border `#F1E9B0`, radius 8, padding 10, gap 10, exact shadow) with all values hardcoded inline — no new `--note-yellow` token.
  - **§6 Batch 1 Typography:** marked ✅ EXTRACTED. Original fill-in form preserved below for traceability.
  - **Variable Mode + MCP behavior:** also extended `memory/reference_figma_mcp_behavior.md` from 56→75 lines with two-tool-class distinction (selection-free vs. selection-required) and efficient batch-probing pattern.
  - **TodoWrite completed:** `[MMP-PH1]`, `[TSV]`, `[NOTE-YELLOW]`, `[MCP-DRIFT-180]`, `[MMP-PH0]`.

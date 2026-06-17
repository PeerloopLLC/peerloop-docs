> **Matt Design System** · [Index](./INDEX.md) · [Pre-plan](../matt-pre-plan.md)

## 5. Colour System — Primitives, Semantics & Derived Scales

### 5.0 Colour Foundation — Derived Role Scales (Conv 296 [PALETTE-FDN])

> This is the **operative colour layer for new work.** The Variable-collection
> tables below (*Documented Color Primitives*, *Color Semantics*, *Entity*, …)
> remain the canonical record of Matt's raw Figma extraction — the **source
> layer** these scales anchor on. When colouring or sweeping a `@matt-source` /
> `@matt-inspired` surface, reach for the role scales here first.

**Why this layer exists.** Matt formalized 15 *disjointed* colour primitives + 14 role semantics (the *Documented Color Primitives* + *Color Semantics* tables below) but **no numeric tonal scales**, only 3 grays (no full neutral ramp), and **no status hues** (red/amber were speculative, never in his Figma). A provenance-scoped sweep of the Matt surfaces (Conv 296) found **3,708 Tailwind-default colour utilities across 198 files**, spanning the full `50→900` ramp across ~10 hue families (gray 1080 · red 694 · green 499 · indigo 469 · amber 332 · blue 189 · purple 165 · …). PALETTE-FDN resolves that disjointed system into coherent, Matt-anchored **role scales**.

**Two parallel axes — don't conflate them:**
- **Matt's role semantics** (`Primary` / `Course` / `Creator` / `Student` / `Text` / `Border` / `Entity` — see *Color Semantics* + *Entity* below) — the canonical *role/context* layer. **Unchanged.** Still the source of truth for entity-context colouring and the cascade.
- **PALETTE-FDN derived scales** (below) — a parallel *tonal* layer for the colours Matt never scaled: neutrals, brand/info ramps, and status. They **anchor on** Matt's primitives via `var()` wherever a value coincides (a *map*), minting new values only for the gaps.

**The role scales** (defined in `tokens-primitives.css` → re-exported by `tokens-tailwind-bridge.css` as `--color-{role}-{step}` → utilities `bg-/text-/border-/ring-{role}-{step}`). `(M)` = exact Matt primitive (map); `mint` = new value. **DRAFT values — pending designer tuning.**

| Role | Steps | Anchors | Absorbs (Tailwind-default usage) |
|---|---|---|---|
| **neutral** | `50` mint · `100`=gray-100 (M) · `300` mint · `500`=gray-600 (M) · `700`=gray-base (M) · `900` mint | Matt grays | gray + slate (1170) — bg / border / muted / body / heading |
| **brand** | `100` mint · `300`=purple-blue (M) · `500` mint | purple-blue #584DF4 | indigo + purple (634) — primary actions / focus |
| **info** | `100`=pastel-blue (M) · `300`=vibrant-blue (M) · `500`=americana-blue (M) | Matt blues | blue (189) — links / info chips |
| **success** | `100`=pastel-green (M) · `300`=medium-green (M) · `500`=dark-green (M) | Matt greens | green + emerald (511) — ✓ completed / valid state |
| **error** | `100`=alert-light (M) · `300`=`#E11D3F` tuned · `500`=`#B0102F` tuned | alert-light (M) + tuned crimson | red (694) — destructive / invalid |
| **warning** | `100`/`300`/`500` **all mint** | *Matt-harmonized amber (Matt had none)* | amber + yellow + orange − stars (~400) |
| **star** | `star` (single) mint | rating gold | amber-400 / yellow-400 (~54) — rating stars |

**Depth rule (Conv 296 decision):** neutrals get a deeper ramp (~6 steps) because they carry 4–6 distinct roles (bg / border / muted text / body / heading); accent + status roles stay at ≤3 (tint `100` / base `300` / strong `500`).

**Status roles are PREDETERMINED, not sweep-contingent (Conv 296 decision).** `error` / `warning` / `success` are guaranteed foundation roles — every product needs them — designed deliberately and **harmonized with Matt's palette** (`warning` is minted as a Matt-fit hue, not snapped to Tailwind amber). The sweep *quantifies blast radius and tunes values*; it does **not** gate a role's existence. This restores the original PALETTE-FDN charter. (The Conv-181 `alert-light` primitive anchors `error-100`; `carmine-red` seeded `error-300` but was tuned off its neon — see the *Documented Color Primitives* notes below.)

#### Sweep policy — "map or flag" (the recurring-colour SOP)

When a route sweep (RT-MIG / RG-*) encounters a Tailwind-default utility or hard-hex on a Matt surface, **classify before swapping** (the Conv-295 hard-hex precedent: a value may be a primitive-signature, not a stray):

1. **Primitive-signature** — the value IS a Matt primitive's documented signature (e.g. `#f6f6f6`+`rgba(88,77,244,.14)` = `AnalyticCount` Default) → **adopt the primitive/component**, don't tokenize separately.
2. **Role/brand colour** — maps onto a role scale → swap to the token: neutrals→`neutral-{step}`, primary action/focus→`brand-*`, links/info→`info-*`, success state→`success-*`, destructive/invalid→`error-*`, caution→`warning-*`, rating→`star`.
3. **Shared convention / recurring (≥3 sites)** — **tokenize app-wide ONCE**, at whatever route it ripened on, swapping every known site together (log in `tier2-primitive-ledger.md`). **NEVER** map a recurring value piecemeal to the nearest token per-route — that silently diverges (gray-100 `#F1F1F1` ≠ `#F6F6F6`; Conv 295 reverted exactly this).
4. **No fitting token** — **FLAG** it (ledger row) rather than forcing a wrong map. It becomes a candidate for a new scale step or a designer decision. A flag is a legitimate outcome; a wrong map is not.

The map-or-flag discipline keeps the palette converging instead of accreting per-route one-offs.

#### Conv-181 rule — amended per Conv-289 CC-ownership

The Conv-181 standing principle (*"tokens are added ONLY when Matt has formalized them as Figma Variables"*, `feedback_tokenize_only_matt_variables.md`) is **amended, not revoked**:
- It **still governs Matt's role semantics** — do **not** invent new `Creator`/`Course`/`Student`/entity roles or re-anchor Matt's existing semantics without his source.
- But per **Conv-289** (Matt phase-out; Figma now layout-only, CC owns page/system consistency), **CC now owns the categories Matt left blank** — neutral tonal ramps, status hues (error/warning/success), and the brand/info tonal scales. CC may mint **Matt-harmonized** tokens there. PALETTE-FDN's derived scales are exactly this exercise.

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

**↑ UPDATE Conv 296 [PALETTE-FDN].** These two primitives seeded the **`error` role scale** (`error-100`=`alert-light` (M); `error-300`/`500` since **tuned** — see below). Per the Conv-289 CC-ownership amendment, status hues are CC-owned predetermined deliverables, so the error role is live rather than Phase-6-deferred. The legacy `--Alert-Default`/`--Alert-Light` semantic aliases + their `--color-alert-*` bridge re-exports remain in place (untouched, non-breaking) and are slated for retirement once their call-sites migrate to `error-*`. **TUNED Conv 296 (swatch-board review):** Matt's speculative `carmine-red #FF0038` read garish/hot-pink against the palette and illegible as error *text*, so `error-300`/`500` were toned to `#E11D3F`/`#B0102F` (credible crimson); `error-100` keeps `alert-light`. `--carmine-red` is retained as a primitive but is no longer the live error default.

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

**Working rule (Conv 178 onward):** Matt's primitives that need entity-context coloring use direct per-entity Tailwind utilities or variant-prop selection — same six-variant pattern as `Button.tsx`. The `.entity-*` cascade described in this section applies only to components Matt explicitly wired with `--Entity-*` variables (entity headers, route-level entity color hints). The Conv 176 working-rule wording ("until [CASCADE-BROKEN] resolves") is retired; [CASCADE-BROKEN] is closed. See DEVELOPMENT-GUIDE.md §"`@theme inline` for Cascade-Driven Entity Tokens (Conv 188 — resolves [CASCADE-BROKEN])" for the pattern and `src/components/ui/Module.tsx` / `ToDoItem.tsx` for examples.

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

**Mapping to existing React icons (§3 reference).** The current convention is `({ className = 'h-5 w-5' }: IconProps)`. Tailwind's `h-5 w-5` resolves to `1.25rem = 20px`, which corresponds to Matt's **Small** mode. So the existing app currently defaults to Small icons. When re-skinning for the design system, the explicit size choice should be:

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


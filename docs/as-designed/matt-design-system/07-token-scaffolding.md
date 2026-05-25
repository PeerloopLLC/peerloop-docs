> **Matt Design System** · [Index](./INDEX.md) · [Pre-plan](../matt-pre-plan.md)

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
- Body large (16-20px) → `lh: 1.5` (150%), `ls: -0.022em` (Figma `-2.2` = `-2.2%`, NOT `-2.2px`; ≈ `-0.352px` at 16px — corrected Conv 190 [MATT-COURSE-POLISH])

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


# ICON-SIZING — finish the icon-size token migration, with proof

**Focus:** Migrate ~2,000 dimension classnames onto the Conv-419 icon token axis, and be able to
*demonstrate* no page shipped a mis-sized icon — not merely believe it.
**Status:** 🔥 IN PROGRESS (Conv 419 — foundation + standard done; Phases 1–2 built)
**Task code:** `[ICON-TOK]` · related `[ICON-4PX]` (residue), `[RG-PUBLIC]` (gates one file)

---

## Why this block exists

`[ICON-4PX]` looked like 44 bad classnames. Measuring it showed something structural: the Conv-174
`--spacing-*` override redefines ten numbers — `4, 8, 12, 16, 20, 24, 32, 40, 48, 64` — from
Tailwind's "N units" to "N pixels". Every *other* number keeps the multiplier. So `h-4` renders 4px
and `h-5` renders 20px, in identical syntax, and nothing in the source says which you're getting.

That shipped 4px icons, two near-invisible 4px checkboxes, and five `ui/icons.tsx` component
**defaults** that made every un-overridden chevron in the app 4px.

Conv 419 fixed the unambiguous half (43 sites), built the token axis, and agreed the standard. What
remains is the bulk migration — and the harder problem, which is proving it landed.

## The standard (decided Conv 419)

Spacing (`p`/`m`/`gap`) keeps the numeric scale; that is what the override was *for*, and it is
settled at 4,711 uses vs 55 arbitrary. Dimensions split three ways **by role**:

| Role | Family | Unit | Example |
|---|---|---|---|
| **Inline** — sits beside text | `size-icon-inline-{sm,md,lg}` | **em** — tracks the label | glyph before a button label, chevron in a row, star before a rating |
| **Standalone** — no adjacent text | `size-icon-{12…64}` | **rem** — tracks the root | nav-rail icon, icon-only button, empty-state mark |
| **Neither** — not an icon | arbitrary px | px | 6px unread dot, 16px avatar, 36px tap target, logo, `ui/icons.tsx` defaults |

Rationale, ratios and the verified measurements live in
[matt-design-system/05-color-and-tokens.md § Icon Size](../../docs/as-designed/matt-design-system/05-color-and-tokens.md).

## Scale

| | count |
|---|---|
| `.astro` pages (route-matrix) | 67 |
| icon-component usages | **860** (199 `MattIcon` + 661 `ui/icons`) |
| `ui/icons.tsx` exports | 98 |
| bare-numeric `w-`/`h-`/`size-`, overridden ten | **878** ← ambiguous, mean N px |
| bare-numeric, non-overridden N | **546** ← ambiguous, mean N × 4 px |
| arbitrary `size-[Npx]` / `w-[Npx]` / `h-[Npx]` | **605** |
| routes swept so far | 18 of 67 |

**Latent trap:** those 546 non-overridden uses (`h-5`, `h-6`, `h-10`) are correct *today* purely
because 5, 6 and 10 aren't in the override set. Adding any of them later 4×-shrinks all of them
silently. Migration removes that landmine.

---

## Why a threshold scanner is not enough

Conv 419 used a "flag anything under 12px" sweep. It found the 4px class and nothing else. It cannot see:

- icons that are too **big** (`size-icon-64` where 16 was meant)
- icons **slightly** wrong — 20 where 24 was intended, the under-specified-classname case
- icons with **no size class at all** — falls back to SVG intrinsic or 100% of container
- the **49 routes never visited**
- modals, empty states, error states, per-role variants, mobile viewport
- and the one that matters most after migration: **an inline icon still on fixed px looks perfect at
  the default font.** The defect is invisible precisely where you would look for it.

## The completeness proof

Run every sweep **twice — root font at 16px, then 24px.**

After migration, an *inline* icon whose rendered size does not change is provably still on fixed px:
a missed site. This converts "did we get them all?" from a coverage argument into a measurement.
The same double-run catches containers that didn't grow with their icon — anything clipped by or
overflowing its parent at 24px.

Around that, three layers:

- **Static (total coverage, no browser).** Every one of the 860 icon usages must carry exactly one
  size class — an AST/source pass catches the missing-class case everywhere, which runtime can only
  catch where you navigate. Plus the bare-numeric ban.
- **Baseline-and-diff.** Capture every icon's rendered box, class and adjacent font-size *before*
  migrating; afterwards classify each delta as unchanged / changed-by-design / unexplained. Without
  a before, "is 20px right here?" has no answer.
- **Absolute invariants**, baseline-independent: nothing under 12px; nothing over 64px unmarked;
  every inline icon within ~0.8×–2.0× its adjacent font-size (this is the under-specification catch).

State coverage (modals, empty, per-role) leans on **PLATO** rather than a fresh harness.

---

## Phases

Order is set by dependencies, not preference.

### Phase 1 — Static guard ✅ BUILT (Conv 419)

`npm run check:icons` (`scripts/check-icon-sizing.ts`). **Must come first:** migrating 2,000 sites
without it means new violations land behind the sweep faster than it advances.

Rules: bare-numeric `w-`/`h-`/`size-` (both ambiguity classes) · icon usages with no size class ·
arbitrary px on an icon component. **New-violations-only**, against a committed baseline
(`scripts/icon-sizing-baseline.json`) — the same shape as `KNOWN_ORPHANS`, because a hard gate would
be red on day one with 878 pre-existing hits. The baseline shrinks as phases land; it must never grow.

### Phase 2 — Runtime scanner + captured baseline ✅ BUILT (Conv 419)

`npm run icons:scan` (`scripts/icon-scan.mjs`). Crawls routes at both root font sizes, measures every
icon-ish element, applies the absolute invariants, and writes/diffs a baseline. **Must precede
migration** — there is no "before" afterwards.

### Phase 3 — Classify by role 📋

Tag every dimension site inline / standalone / neither. **This is the judgment and the bulk of the
work.** Conv 419 tried a text-adjacency heuristic and it misclassified even the profile-header
Message buttons, which are plainly icon+label — so this needs reading, assisted by tooling, not
tooling alone. Settled sub-case: the 5 `ui/icons.tsx` defaults stay rem permanently, because a
default cannot know its call site.

Also settles the not-an-icon set: `size-[6px]`/`[8px]` status + unread **dots**, `size-[22px]`
toggle **knob**, `size-[36px]` hit-target **containers**, 16px **avatars**. Snapping those to the
ladder would double a dot.

### Phase 4 — Migrate in tranches 📋

By role, then by value, re-running both scanners after each tranche. Not one sweep. Suggested order:
`ui/icons.tsx` defaults → standalone → inline → the arbitrary-px 605. Every bare-numeric class has a
deterministic true value (overridden → N px, else → N × 4 px), so the mechanical part scripts cleanly;
the classification from Phase 3 is what decides the target family.

### Phase 5 — Completeness proof 📋

Full double-root-font sweep across all 67 routes plus PLATO state coverage. Any inline icon that
doesn't move between 16px and 24px root is a missed site. Any clipped/overflowing element is a
container that didn't follow its icon.

### Phase 6 — Tighten the guard 📋

Once no arbitrary px remains on icon elements, promote those rules from warn to error and drive the
baseline to zero. Decide then whether the `--spacing-*` numeric override should be renamed outright
so no number can ever be misread again — the deeper fix this block only works around.

---

## Open questions

- **`em` ratios.** `md` = 1.15em was anchored on `--body-default-size` (14px) to make migration
  visually neutral there. Icons beside `text-body-small` (12px) or `text-h2` (24px) shift. Confirm
  against real pages in Phase 4 rather than assuming three steps suffice.
- **Matt's ladder.** He formalized only Small 20 / Medium 24. We ship 11 steps because 16px is the
  most-used size (72 sites) and isn't in his set. If Matt returns to the project, reconcile.
- **Pixel-grid softness.** At a 1.3× root font a 20px glyph renders 26px and can sit off-grid.
  Accepted trade; revisit if it reads badly at large font sizes.

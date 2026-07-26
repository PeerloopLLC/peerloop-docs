# ICON-SIZING — finish the icon-size token migration, with proof

**Focus:** Migrate ~1,700 dimension classnames onto the Conv-419 icon token axis, and be able to
*demonstrate* no page shipped a mis-sized icon — not merely believe it.
**Status:** 🔥 IN PROGRESS (Conv 420 — two migration tranches landed; baseline **1,363**, down from 1,694.
Conv 419 built the foundation, standard and Phases 1–2 at baseline 1,694, itself down from 1,863 after
that conv's `[MKTDEAD]` dead-code purge)
**Task code:** `[ICON-TOK]` · related `[ICON-4PX]` (residue), `[RG-PUBLIC]` (gates one file), `[MKTDEAD]` (shrank the baseline)

---

## Why this block exists

`[ICON-4PX]` looked like 44 bad classnames. Measuring it showed something structural: the Conv-174
`--spacing-*` override redefines ten numbers — `4, 8, 12, 16, 20, 24, 32, 40, 48, 64` — from
Tailwind's "N units" to "N pixels". Every *other* number keeps the multiplier. So `h-4` renders 4px
and `h-5` renders 20px, in identical syntax, and nothing in the source says which you're getting.

That shipped 4px icons, two near-invisible 4px checkboxes, and five `ui/icons.tsx` component
**defaults** that made every un-overridden chevron in the app 4px.

Conv 419 fixed the unambiguous half (43 sites — **honestly 38**: the reachability check afterwards
showed 5 had landed on dead code, which `[MKTDEAD]` then deleted), built the token axis, and agreed
the standard. What remains is the bulk migration — and the harder problem, which is proving it landed.

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

Re-measured **after** `[MKTDEAD]` (Conv 419) deleted 80 dead-marketing files; the pre-purge figures
are kept alongside because 169 baseline violations — a full **10%** — lived in code no route could
reach, and a census that counts them over-scopes the migration.

| | Conv 420 | Conv 419 | pre-`[MKTDEAD]` |
|---|---|---|---|
| `.astro` pages (route-matrix) | 67 | 67 | 67 |
| icon-component usages | 626 (198 `MattIcon` + 428 `ui/icons`) | 626 | 860 |
| `ui/icons.tsx` exports | 98 | 98 | 98 |
| **`check:icons` baseline total** | **1,363** | 1,694 | 1,863 |
| — bare-numeric, overridden ten | **806** ← ambiguous, mean N px | 898 | — |
| — bare-numeric, non-overridden N | **370** ← ambiguous, mean N × 4 px | 558 | — |
| — of the overridden ten, actually **on an icon** | ~421 (was ~501 pre-tranche-2) | — | — |
| — of the overridden ten, **not an icon** (skeletons, badge circles, dots, avatars) | ~390 — out of scope for this axis | — | — |
| — arbitrary px *on an icon component* | **187** | 192 | — |
| — icon usage with **no size class at all** | **0** (rule was wrong — see below) | 46 | 51 |
| arbitrary `size-[Npx]`/`w-[Npx]`/`h-[Npx]` site-wide | 557 | 562 | 605 |
| routes swept so far | 18 of 67 | 18 of 67 | — |

**Latent trap:** those non-overridden uses (`h-5`, `h-6`, `h-10`) are correct *today* purely
because 5, 6 and 10 aren't in the override set. Adding any of them later 4×-shrinks all of them
silently. Migration removes that landmine — Conv 420's tranche took the single most-repeated instance
of it (94 icon-component defaults) off the board.

### ⚠️ The "46 no-size-class usages" finding was wrong (corrected Conv 420)

Conv 419 called these *"the sharpest finding — icons with no sizing input at all"* and made them lead
Phase 4. Reading all 46 (rather than grepping them) showed the rule's true count was **zero**. Every
one was a false positive, in one of two ways:

- **14 were avatars, not icons.** Each flagged `UserIcon` imports `@components/entity/UserIcon` — a
  `@matt-source 1:35` initials/image avatar with a typed `size?: 24 | 40` prop, which the standard
  puts in the "neither" bucket. The rule matched on the *name* ending in `Icon`.
- **32 were sized one level in** — either a `className = 'h-5 w-5'` parameter default (`MattIcon`, the
  `ui/icons.tsx` family) or a wrapper that hard-codes it (`QuickActionIcon` → `size-20`, `SortIcon` →
  `size-icon-16`). Those *definition* lines are genuine violations where they're bare-numeric, and R1
  already counts them; flagging the call sites too double-counted one defect as many.

The rule now asks the question it always meant to — is there provably no sizing input *anywhere*, at
the call site or in the component — via a structural `selfSizingIcons()` pre-pass rather than a
hand-maintained allowlist (which would rot). Verified by injecting a genuinely unsized icon: caught,
exit 1. **46 of the −246 baseline drop is this correction, not migration**; the honest migration figure
is 200.

**The transferable lesson.** This is the fifth consecutive task premise written by reading the
*implementation* rather than enumerating the *consumers* (after `[CANMSG]`, `[MSG-ADOPT-A]`,
`[MSG-ADOPT-B]`, `[COURSETAB-HASH]` in Convs 418–419). The check costs one tool call. Re-test the
premise of every remaining phase here before executing it.

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

`npm run check:icons` (`scripts/check-icon-sizing.ts`). **Must come first:** migrating ~1,700 sites
without it means new violations land behind the sweep faster than it advances.

Rules: bare-numeric `w-`/`h-`/`size-` (both ambiguity classes) · icon usages with no size class ·
arbitrary px on an icon component. **New-violations-only**, against a committed baseline
(`scripts/icon-sizing-baseline.json`) — the same shape as `KNOWN_ORPHANS`, because a hard gate would
be red on day one. `--update-baseline` is the only mutation path, so growth is always a reviewable
diff. The baseline shrinks as phases land; it must never grow. **First movement was not a migration:**
`[MKTDEAD]` took it **1,863 → 1,694** by deleting dead code, which is also the measurement that proved
10% of the census was unreachable.

- [ ] **Lint rule banning bare numbers on `w-`/`h-`/`size-`.** `check:icons` only refuses *new*
      violations relative to a baseline a developer can re-generate. Without an editor-visible rule the
      next `h-4 w-4` lands unnoticed and is discovered by measurement again. (Ships with Phase 6's
      warn→error promotion, or earlier if the migration outpaces it.)

### Phase 2 — Runtime scanner + captured baseline ✅ BUILT (Conv 419)

`npm run icons:scan` (`scripts/icon-scan.mjs`). Crawls 26 routes at both root font sizes, measures every
icon-ish element, applies the absolute invariants, and writes/diffs a baseline. **Must precede
migration** — there is no "before" afterwards.

The `inline-ratio` invariant first produced **38 false positives** (course thumbnails, 48px avatars,
empty-state illustrations) by keying on "is there text nearby". Re-keying on **geometry** — does the
icon *vertically overlap* its text (beside) or not (stacked above) — took it to zero. A checker that
cries wolf gets ignored, which is the same failure new-violations-only baselining exists to prevent.

⚠️ **The instrument was built after the change it was meant to measure.** Conv 419's 43-site
`[ICON-4PX]` migration is already *inside* both baselines, so it went unverified against a before-state
and this block cannot retroactively answer "did it break anything". Everything from Phase 4 onward does
have a genuine before; that gap is confined to those 43 sites.

### Phase 3 — Classify by role 🔄 (started Conv 420)

Tag each baselined site inline / standalone / neither. **This is the judgment and the bulk of the
work, and it needs reading rather than grepping** — Conv 419 tried a text-adjacency heuristic and it
misclassified even the profile-header Message buttons, which are plainly icon+label. Tooling assists;
it does not decide.

Also settles the not-an-icon set: `size-[6px]`/`[8px]` status + unread **dots**, `size-[22px]`
toggle **knob**, `size-[36px]` hit-target **containers**, **avatars** (`entity/UserIcon`, which owns
this via a typed `size` prop). Snapping those to the ladder would double a dot.

**Settled Conv 420 — icon-component defaults are standalone rem.** A default cannot know its call
site, so it cannot be `em`. All 94 now name their size: `size-icon-20` (92 `ui/icons.tsx` + `MattIcon`)
and `size-icon-24` (`MenuIcon`), joining the 5 chevrons already on `size-icon-16`.

**Settled Conv 420 — a nav row with a label is standalone, not inline** (user decision). AdminNavbar's
17 menu glyphs sit beside `text-body-small` = **12px** labels, where the em ladder reaches only
13.8px (`md`) or 17.4px (`lg`) against today's 20px. Two things decided it: the standard's own
examples list "nav-rail icon" as *standalone*, and `[ADMIN-CONF-POLICY]` makes the admin label
deliberately small — a poor thing to chain a glyph to. This is the first real answer to the block's
open question about em ratios: **the three inline steps are anchored on 14px body text and do not
serve a 12px label.** Expect the same call at other `text-body-small` sites.

### Phase 4 — Migrate in tranches 🔄

By role, then by value, re-running both scanners after each tranche. Not one sweep. Every bare-numeric
class has a deterministic true value (overridden → N px, else → N × 4 px), so the mechanical part
scripts cleanly; the classification from Phase 3 is what decides the target family.

Remaining order: standalone → inline → the arbitrary px. (The "46 no-size-class usages" that Conv 419
put first turned out not to exist — see the Scale section.)

- [x] **Tranche 1 — icon-component defaults (Conv 420).** 94 defaults → **200 violations cleared**,
      the single highest-leverage edit available: `MattIcon.tsx:43` alone corrects every un-classed
      `MattIcon` site-wide, AdminNavbar's 17 included. **Provably neutral** — `h-5 w-5` resolves to
      `calc(0.25rem × 5)` = 1.25rem, identical to `--icon-20`; `h-6 w-6` = 1.5rem = `--icon-24`. Both
      land on Matt's own formalized steps (Small 20 / Medium 24). Also migrated in the same pass: the
      6 local wrappers behind the false-positive call sites (`QuickActionIcon`, `ActivityIcon`,
      `ResourceIcon`, `TypeIcon`, and `PromoteButton`'s three local svgs → `size-icon-inline-md`, its
      genuine inline case at a 14px label). Runtime scan: **no regression**, 0 findings on all 26
      routes bar the parked 11.
      - ⚠️ **Honest limit:** most of the 200 was *ambiguity* removal, not a rendered-size change —
        `h-5 w-5` was already rem, so the `% scale with root` meters did not move. The gain is that
        the sizes are now named and the 5-joins-the-override-set landmine is defused for 94 sites.
        Only the 7 wrapper/PromoteButton sites actually moved fixed-px → rem/em.
- [x] **Tranche 2 — large standalone icons (Conv 420).** 44 sites / 85 classes at 32/40/48/64px →
      `size-icon-{32,40,48,64}`. Baseline 1,448 → **1,363**. Chosen as the lowest-judgment slice: at
      that size an icon is essentially never inline, and reading all 44 confirmed it — every one is an
      empty-state mark (`text-center py-32/48`, `mx-auto`, `text-neutral-300`), an image placeholder,
      or a badge-circle's contents. Zero inline cases.
      - **Premise re-tested first, and it was over-scoped again.** R1 matches *any* `w-/h-/size-N`
        class, not only icons, so the "891 sites that shipped 4px icons" is really **~501 icon classes
        + ~390 non-icon ones** — skeleton loader bars, badge circles, unread dots, avatar `<img>`s, and
        one text-column width. Those 390 are out of scope for the icon axis entirely (the standard
        keeps them on px); they remain ambiguous, but that is a different axis's problem.
      - **Hazard avoided: no blind sed.** `w-64 h-64` and `h-48 w-48` occur *both* as icon sizes and as
        the wrapper circles those icons sit inside (`mx-auto w-64 h-64 rounded-full` around a
        `w-32 h-32` glyph). A global replace would have resized the containers too. Each edit was
        scoped to the icon tag on its own line; one multi-line `<svg>` fell out of that and was done
        by hand.
      - **Verification is partial and that is the honest word for it.** `icons:scan` reports no
        regression, but a direct probe showed why that is weak evidence here: **4 of the 44** rendered
        (on `/admin`) and grew correctly at a 24px root; the other **40 never render under seeded
        data**, because empty-state marks are behind "list is empty" conditions no route walk reaches.
        `/learning` measured identically before and after. This is the "modals, empty states, error
        states" gap named above, now with a number against it — **Phase 5 must drive empty states
        deliberately, not hope to pass through them.**
      - **Same probe did verify tranche 1:** 33 elements on `size-icon-20`/`size-icon-16`, all 33
        growing at a 24px root.
      - **One test was coupled to the literal classname** — `svg.w-48.h-48` in `CreatorStudio.test.tsx`
        — and failed. Behaviour was unchanged; only the class moved. Swept `tests/` for the other
        migrated classnames: no further coupling.
      - **Scanner note (checked, no action):** `MAX_ICON_PX = 64` will *not* start false-positiving as
        icons become rem. `invariants()` evaluates size rules over the **16px** measurements only; the
        24px run feeds the scale/overflow comparison. So `size-icon-48` reads 48px there, not 72px.
- [x] **Mandatory per-tranche reachability check.** Run `.claude/scripts/codecheck-orphan-components.mjs`
      over every file in a tranche **before** editing it. Conv 419 measured that **5 of its 43 icon
      fixes landed on dead code** — hitting `TestimonialsBrowse`, the same file Conv 404's `[A11Y]`
      batch already wasted a fix on 15 convs earlier. tsc/lint/tests/build are all green over dead
      code, so nothing else in the pipeline catches it. *Conv 420: ran clean — `PASS`, every component
      route-reachable, no wasted edits.*
- [ ] **`[ICON-4PX]` residue** — `/become-a-teacher`, 11 measured findings, gated behind the parked
      `[RG-PUBLIC]`. A deliberate park, not a blocker; fold into whichever tranche runs when the
      marketing redesign is scheduled.

### Phase 5 — Completeness proof 📋

Full double-root-font sweep across all 67 routes plus PLATO state coverage. Any inline icon that
doesn't move between 16px and 24px root is a missed site. Any clipped/overflowing element is a
container that didn't follow its icon.

### Phase 6 — Tighten the guard 📋

Once no arbitrary px remains on icon elements, promote those rules from warn to error and drive the
baseline to zero. Ship the **bare-number lint rule** listed under Phase 1 here if it hasn't landed
earlier. Decide then whether the `--spacing-*` numeric override should be renamed outright so no
number can ever be misread again — the deeper fix this block only works around.

---

## Open questions

- **`em` ratios — partly answered Conv 420, and the answer was "they don't stretch".** `md` = 1.15em
  was anchored on `--body-default-size` (14px). Against a `text-body-small` (12px) label the ladder
  tops out at 17.4px (`lg`), so it cannot express AdminNavbar's 20px glyphs at all. That case was
  resolved by classifying the nav as **standalone** rather than by adding a step — the right call
  there, but it is a workaround, and a genuine 12px-label *inline* icon still has no home. Decide
  whether to add a step or re-anchor when the first such site appears; `text-h2` (24px) is still
  unconfirmed either way.
- **Matt's ladder.** He formalized only Small 20 / Medium 24. We ship 11 steps because 16px is the
  most-used size (72 sites) and isn't in his set. If Matt returns to the project, reconcile.
- **Pixel-grid softness.** At a 1.3× root font a 20px glyph renders 26px and can sit off-grid.
  Accepted trade; revisit if it reads badly at large font sizes.

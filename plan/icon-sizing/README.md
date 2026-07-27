# ICON-SIZING — finish the icon-size token migration, with proof

**Focus:** Migrate ~1,700 dimension classnames onto the Conv-419 icon token axis, and be able to
*demonstrate* no page shipped a mis-sized icon — not merely believe it.
**Status:** 🟢 MIGRATION COMPLETE (Conv 421) — **no live icon-size debt remains anywhere.** Governed icon
debt is **25**, all of them in the parked `BecomeATeacherPage` (gated behind `[RG-PUBLIC]`). Phases 1–4
are done; **Phases 5 (completeness proof) and 6 (tighten the guard) remain**, plus the two open questions
below. Trajectory: baseline 1,863 → 1,694 (Conv 419 `[MKTDEAD]` purge) → 1,337 (Conv 420, three tranches)
→ 1,150 (tranche 4) → 1,143 → **560 governed + 532 informational** (tranche 7's axis split) → **25**
(tranche 3b's mechanical sweep).
**Task code:** `[ICON-TOK]` · related `[ICON-4PX]` (residue, now exactly 25 classes), `[RG-PUBLIC]` (gates
the one remaining file), `[MKTDEAD]` (shrank the baseline), `[ICON-AUDIT]` (Conv 421 course-correction)

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
the standard. Convs 420–421 then ran the bulk migration to ground: **the icon axis is now migrated and
the harder problem — proving it landed — is half done.** 437 migrated icons are measured correct at two
root font sizes across 18 routes; the other **49 routes, plus empty/modal/error states, are still
unproven** (Phase 5), and the guard has not yet been promoted to a hard error (Phase 6).

## The standard (decided Conv 419)

Spacing (`p`/`m`/`gap`) keeps the numeric scale; that is what the override was *for*, and it is
settled at 4,711 uses vs 55 arbitrary. Dimensions split **two ways** by role (simplified from three
in Conv 421, when the em inline family was rescinded):

| Role | Family | Unit | Example |
|---|---|---|---|
| **An icon** — any glyph, text beside it or not | `size-icon-{12…64}` | **rem** — tracks the root | nav-rail icon, icon-only button, empty-state mark, glyph before a button label, chevron in a row, star before a rating |
| **Not an icon** | arbitrary px | px | 6px unread dot, 16px avatar, 36px tap target, logo, `ui/icons.tsx` defaults |

> **Rescinded (Conv 421):** a third family — `size-icon-inline-{sm,md,lg}`, em-valued, for icons
> beside text — existed from Conv 419 until Conv 421. It never fired (three dodges: AdminNavbar, the
> 12px glyph group, the 187-site arbitrary-px tranche), `-sm`/`-lg` were never used once, `em`
> resolves against the container's font-size rather than the sibling label's, and its 14px anchor
> capped at 17.4px against this app's 12px labels. Removing it makes the ~500 remaining 16/20/24px
> sites mechanical rather than judgment calls.

Rationale and the verified measurements live in
[matt-design-system/05-color-and-tokens.md § Icon Size](../../docs/as-designed/matt-design-system/05-color-and-tokens.md).

## Scale

Re-measured **after** `[MKTDEAD]` (Conv 419) deleted 80 dead-marketing files; the pre-purge figures
are kept alongside because 169 baseline violations — a full **10%** — lived in code no route could
reach, and a census that counts them over-scopes the migration.

| | **Conv 421** | Conv 420 | Conv 419 | pre-`[MKTDEAD]` |
|---|---|---|---|---|
| `.astro` pages (route-matrix) | 67 | 67 | 67 | 67 |
| icon-component usages | `MattIcon` re-censused at **199** call sites (`[ICON-AUDIT]`); `ui/icons` not re-counted | 626 (198 `MattIcon` + 428 `ui/icons`) | 626 | 860 |
| `ui/icons.tsx` exports | — | 98 | 98 | 98 |
| **`check:icons` governed total** | **25** — all in the parked `BecomeATeacherPage` | **1,337** | 1,694 | 1,863 |
| **informational total** (measured, ungated) | **532** — split out by tranche 7 | — (conflated into the total) | — | — |
| — bare-numeric, overridden ten | superseded by the governed/informational split | **788** ← ambiguous, mean N px | 898 | — |
| — bare-numeric, non-overridden N | superseded by the governed/informational split | **362** ← ambiguous, mean N × 4 px | 558 | — |
| — of the overridden ten, actually **on an icon** | **25** left (was ~369; 539 swept in tranche 3b) | ~369, now all ≥16px | — | — |
| — of the overridden ten, **not an icon** (skeletons, badge circles, dots, avatars) | **532** exactly, now measured — dots 114 / skeletons 64 / avatars 33 / media 29 / boxes | ~390 (estimate) — out of scope for this axis | — | — |
| — arbitrary px *on an icon component* | **0** — class retired (tranche 4) | **187** | 192 | — |
| — icon usage with **no size class at all** | **0** | **0** (rule was wrong — see below) | 46 | 51 |
| arbitrary `size-[Npx]`/`w-[Npx]`/`h-[Npx]` site-wide | — (icon share is 0; the remainder is genuine non-icon px, which the standard keeps) | 557 | 562 | 605 |
| routes swept so far | 18 of 67 | 18 of 67 | 18 of 67 | — |
| migrated icons verified live at two root font sizes | **437 / 437** exact at 16px, **437 / 437** growing at 24px | 33 (probe) + 4 of 44 empty-state marks | — | — |

> The Conv-420 "~390 non-icon" figure was an **estimate**; tranche 7 measured it and found **532**, plus
> two pure-noise sources the estimate never saw (51 fraction false positives, 94 `min-`/`max-` mislabels).
> The governed total therefore fell 1,143 → 560 *before* a single class was migrated — see tranche 7.

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
premise of every remaining phase here before executing it. *Conv 421 kept doing exactly that, and the
practice paid both ways: tranche 2's and the Conv-420 premises were over-scoped again, while **tranches
4 and 3b were the first premises to survive re-testing** and were executed as written. Generalised into
`memory/feedback_retest_task_premise_before_executing.md` — the root cause is reading a thing's own
definition and inferring what its consumers do, with three faces: **count, reachability, context**.*

### `[ICON-AUDIT]` — the mid-block audit that re-targeted the work (Conv 421)

Prompted by a standing user concern that the migration might have drifted the app's appearance. All four
prior icon commits (`8dbdd41f`, `65bd6456`, `c429f150`, `41c19000`) were audited **from the diffs plus a
live 20-route browser walk** — deliberately *not* from this plan's own summaries — resolving every changed
dimension class through the ten-value override table to a rendered pixel value.

**The concern itself was answered: appearance had not drifted.** 153 of 206 changed dimension lines (74%)
were pixel-identical; the 53 that moved were almost all `4px → 16px` restorations of icons that had been
shipping as near-invisible specks. The live walk found zero sub-11px glyphs except one.

But four real problems surfaced, and they set the rest of the conv's agenda:

1. **The migration was landing where nothing renders.** `/course/[slug]` rendered 26 icons and **0**
   tokened; `/courses` rendered 87 and **1**. → re-targeted at the Matt surface (tranche 4).
2. **5 changed files had been deleted two commits later by `[MKTDEAD]`** — effort spent on code that no
   longer exists, the same failure mode the standing reachability check exists to prevent.
3. **"`MattIcon`'s default fixes it site-wide" was 23 of 199 call sites.** The other **176 pass their own
   `className`**, so tranche 1's headline overstated its reach — the default only governs the un-classed
   minority. Recorded here because tranche 1 below still reads as the stronger claim.
4. **The baseline conflated migration, deletion and rule-narrowing** into one falling number, so it could
   not be read as progress. → fixed by tranche 7's governed/informational split.

`[HDR-AVATAR]` was also logged out of this walk (→ tranche 6).

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

### Phase 3 — Classify by role ✅ SETTLED (Convs 420–421)

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

**Settled Conv 421 — the inline/standalone judgment was abolished, and the classifier made structural.**
Rescinding the em family (tranche 5) collapsed the role question from three ways to two, so "is this icon
beside text?" stopped being a question the migration had to answer at all — which is what turned the
remaining ~500 sites from judgment calls into the mechanical sweep of tranche 3b. The residual
icon-vs-not-an-icon call is now made **by the checker itself**, structurally: match offsets tested against
ranges from whole icon **tags** *and* icon component **definition bodies** (tranche 7). Line proximity was
tried and rejected — it misread infinite-scroll sentinel `<div>`s as icons.

### Phase 4 — Migrate in tranches ✅ COMPLETE (bar the parked residue)

By role, then by value, re-running both scanners after each tranche. Not one sweep. Every bare-numeric
class has a deterministic true value (overridden → N px, else → N × 4 px), so the mechanical part
scripts cleanly; the classification from Phase 3 is what decides the target family.

Planned order was standalone → inline → arbitrary px. What actually ran: defaults (1) → large standalone
(2) → the sub-12px defects (3a) → **arbitrary px (4)**, pulled forward by `[ICON-AUDIT]` → the em rescind
(5) → `[HDR-AVATAR]` (6) → the axis split (7) → **the mechanical sweep (3b)**, which the rescind had turned
from a judgment exercise into a script. The "46 no-size-class usages" Conv 419 put first turned out not to
exist — see the Scale section. **All tranches are landed; the only remaining icon debt is the 25-class
parked residue at the foot of this list.**

- [x] **Tranche 1 — icon-component defaults (Conv 420).** 94 defaults → **200 violations cleared**,
      the single highest-leverage edit available: `MattIcon.tsx:43` alone corrects every un-classed
      `MattIcon` site-wide, AdminNavbar's 17 included. **Provably neutral** — `h-5 w-5` resolves to
      `calc(0.25rem × 5)` = 1.25rem, identical to `--icon-20`; `h-6 w-6` = 1.5rem = `--icon-24`. Both
      land on Matt's own formalized steps (Small 20 / Medium 24). Also migrated in the same pass: the
      6 local wrappers behind the false-positive call sites (`QuickActionIcon`, `ActivityIcon`,
      `ResourceIcon`, `TypeIcon`, and `PromoteButton`'s three local svgs → `size-icon-inline-md`,
      believed at the time to be its genuine inline case at a 14px label — *that belief was wrong and
      those 3 svgs became a shipped defect; see tranche 5*). Runtime scan: **no regression**, 0 findings
      on all 26 routes bar the parked 11.
      - ⚠️ **Honest limit:** most of the 200 was *ambiguity* removal, not a rendered-size change —
        `h-5 w-5` was already rem, so the `% scale with root` meters did not move. The gain is that
        the sizes are now named and the 5-joins-the-override-set landmine is defused for 94 sites.
        Only the 7 wrapper/PromoteButton sites actually moved fixed-px → rem/em.
      - ⚠️ **Corrected by `[ICON-AUDIT]` (Conv 421): "site-wide" was 23 of 199 `MattIcon` call sites.**
        The other **176 pass their own `className`**, which overrides the default — so this edit's real
        reach was the un-classed minority, not the whole app. The claim above is left standing as what
        was believed at the time; this is the measured figure.
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
- [x] **Tranche 3a — the sub-12px group turned out to be two real defects, not ambiguity (Conv 420).**
      Baseline 1,363 → **1,337**. Working down from the smallest rendered sizes found the only two
      places in the app where the override had shipped something visibly wrong:
      - **`ModeratorInvite.tsx` — a whole component written in Tailwind-v3 semantics.** Measured live
        at `/invite/mod/<bad-token>`: the error glyph rendered **8×8px inside a 16×16px circle**, on a
        card with **8px** padding, because the author wrote `w-8 h-8` / `w-16 h-16` / `p-8` meaning
        32 / 64 / 32. This is what a person sees when a moderator invite link is bad, expired or
        accepted. **The icon axis alone could not fix it** — moving the glyph to 32px inside a
        container that stayed 16px would overflow. **User decision: fix the whole component**,
        crossing into the spacing scale the standard otherwise excludes, as a bounded one-component
        exception. 90 classes converted to the codebase's literal-px convention (`p-8`→`p-32`,
        `space-y-4`→`space-y-16`, and the two skeleton bars that were rendering at 8px and 4px), icons
        to `size-icon-32`/`-20`, the circles to `size-[64px]`. Re-measured after: **64×64 circle,
        32×32 icon, 32px padding**, palette and button intact. 36 component tests still pass.
      - **`PublicProfile.tsx:290`** — an error-state mark at **12px where `h-12 w-12` meant 48px**.
        Its card already used modern Matt tokens, so only the icon was wrong → `size-icon-48`,
        matching the pattern tranche 2 established for exactly this shape.
      - **The legacy-semantics class is bounded — worth knowing, and it is small.** Only **7** files
        use the v3-era palette at all, and only **2** of those carry overridden icon classes: this one
        and `BecomeATeacherPage` (parked behind `[RG-PUBLIC]`, and the source of all 11 remaining
        runtime findings). So there is no third such component waiting.
      - ⚠️ Only the **error** state was live-verified. Success / declined / valid-invite states share
        the same card markup but need a valid token to render.
- [x] **Tranche 4 — the whole `icon-arbitrary-px` class, on the Matt surface (Conv 421).** 187 → **0**,
      baseline 1,337 → **1,150**, 69 files, 187 line-for-line edits. Re-targeted here after the
      `[ICON-AUDIT]` walk found the block had been migrating where nothing renders (`/course/[slug]`
      rendered 26 icons and **0** tokened; `/courses` 87 and **1**). **First tranche whose premise
      survived re-testing** — R3 matches only icon-component tags, so all 187 were real icons
      (166 `<MattIcon>` + 21 `ui/icons.tsx`), zero avatars/logos/skeleton bars, unlike tranche 2's 891.
      Distribution 62×20 · 61×24 · 26×16 · 10×48 · 10×14 · 7×32 · 4×18 · 2×40 · 2×28 · 2×12 · 1×19.
      **Provably neutral** — all 11 `--icon-N` tokens verified pixel-identical to their names at a
      16px root. The one off-scale value (`size-[19px]`) snapped to `size-icon-20` per user decision.
      Scoped per tag, never a file-wide sed; the script's non-square guard correctly refused one
      conditional ternary (`MessageUserButton`, hand-edited) and 3 reflowed multi-line tags were
      restored. **Proof: 232 migrated icons render across 10 routes — 232/232 at their exact named px
      at a 16px root, 232/232 grew at a 24px root.** 5 gates green (suite 6131). Code `31251d82`.
- [x] **Tranche 5 — rescind the em inline family (Conv 421).** `--icon-inline-{sm,md,lg}` deleted from
      primitives + the `--spacing-*` bridge; all 6 call sites → `size-icon-16` (16.1px → 16px). The
      rule is now **two-way**. This closes the block's longest-open decision rather than deferring it a
      fourth time — see the callout under *Standard* above for the four findings. Scanner rule widened
      `inline-did-not-scale` → `tokened-did-not-scale` (every token is rem now, so *any* `size-icon-*`
      that measures the same at both roots is provably still pinned). 5 gates green + `icons:scan` no
      regression.
      - **✅ Verified in place (second pass) — and it was a repair, not just a simplification.** The
        first attempt failed only because the probe used `brian`, who is neither a teacher nor a
        creator; the routes 200'd and rendered an empty profile. Re-run against real seed entities
        (`/teacher/guy-rymberg`, `/creator/gabriel-rymberg`, `/@guy-rymberg` — `PublicProfile` lives
        at `/@[handle]`, not `/profile/` — and `/course/ai-tools-overview/feed` signed in as admin,
        since `canPromote` needs admin / course creator / certified teacher), **all 4 files render at
        16×16px, zero stale `size-icon-inline-*`.**
      - **The counterfactual is the real finding.** Re-applying `1.15em` to the same live elements
        measures what the em token had been shipping: **6 of 7 PromoteButton icons sit in a 12px
        container → 13.8px, a −2.2px / −14% shrink**; only the one at 14px was neutral (+0.09px).
        Conv 420 migrated those svgs from a literal 16px believing it "the genuine inline case at a
        14px label" — **the label is 12px**, so they silently shrank and shipped that way, uncaught
        because the site was never live-verified. Finding 4 of the rescind, demonstrated on the em
        family's own flagship use.
- [x] **Tranche 6 — `[HDR-AVATAR]`: repair the legacy shell header (Conv 421).** The tasked defect
      was one line (`layout/Header.tsx:137`, an avatar at `h-8 w-8` = 8px). **Not fixable in
      isolation:** measured live, the bar itself is `h-16` meaning 64px and rendering **17px**, with
      28px logo text overflowing it — a 32px avatar in a 17px bar is worse, not better. Same
      situation as `ModeratorInvite` (tranche 3a), so the same remedy: 15 classes converted whole to
      the literal-px convention. The task was also under-scoped — `h-8 w-8` appears **twice**, on the
      `<img>` and on the initials-fallback `<div>`. **Blast radius 21 pages via `LandingLayout`, 7 of
      them live non-`/old`:** every 404, `/receipt/[id]` (a Conv-410 deliverable), `/certificates/[id]`,
      `/diploma/[id]`, `/verify/[id]`, `/invite/mod/[token]` — whose *content* tranche 3a repaired
      while leaving this shell around it. Fingerprint worth remembering: padding was
      `px-4 sm:px-6 lg:px-8` → **4px → 24px → 8px**, increasing then *decreasing*, because 6 is not
      in the override set. Verified 17px → 65px, avatar 8px → 32px; `icons:scan` no longer reports
      the `8×8 near "Sarah Miller"` finding. Code `530b306f`.
- [x] **Tranche 7 — split the icon axis out of the dimension count (Conv 421).** Baseline
      **1,143 → 560 governed + 532 informational**. Scoped first by measuring, not assuming; three
      inflation sources found, of which only one was the known "non-icon" problem:
      - **51 fraction false positives** — `\b` before `/` is a boundary, so `w-1/2` matched as `w-1`.
        Pure noise: a percentage width never consults the spacing scale.
      - **94 `min-`/`max-` mislabels** — `\b` after a hyphen is a boundary, so `min-w-0` matched as
        `w-0`, reported under a class name **absent from the file** and therefore ungreppable. Real
        ambiguity, but on a box constraint, not an icon.
      - **~418 non-icon elements** — dots (114), skeletons (64), avatars (33), media (29), boxes.
      R1 now classifies structurally: match offset tested against ranges from whole icon **tags**
      (reusing R3's matcher, so multi-line tags work) **and** icon component **definition bodies**
      (where a `className = 'h-5 w-5'` default sizes every un-classed call site — tranche 1's 200
      violations came from 94 of those). Line proximity was tried and rejected: it misread
      infinite-scroll sentinels as icons. Calibrated per `[CMH]` before commit — 14 regex cases + an
      injected 6-shape probe, all correct, gate correctly flags the probe. Code `14f56f7c`.
- [x] **Tranche 3b — the mechanical sweep (Conv 421). Icon debt 560 → 25.** 539 classes across 99
      files, 311 insertions / 311 deletions, line-for-line. Premise re-derived against the checker
      (not the scoping script) before the first edit, per `[PREMISE]` — and it **held**: 539 of 560
      had an exact `--icon-N` at the size they already rendered. **All 25 remaining are in
      `BecomeATeacherPage`**, parked behind `[RG-PUBLIC]` and already tracked as `[ICON-4PX]`.
      - **Two bugs in the sweep itself — one caught, one shipped.** (i) The first pass ran one
        string regex over each whole file, so a single apostrophe in JSX prose (`don't`) mis-paired
        every quote after it and silently skipped the rest of that file — **80 misses**. Rewritten to
        scan strings *locally inside each icon tag*, where a mis-pair cannot propagate; containment
        also tightened so **both ends** of a string must sit in the same icon region (checking only
        the start would let a mis-parsed literal reach out and rewrite non-icon classes).
        (ii) Whitespace collapse damaged template-literal formatting. This one **shipped**: the fix
        stopped newlines being eaten but still collapsed runs of 2+ spaces *anywhere*, including
        continuation-line indentation, so `HomeworkEditor.tsx:553-554` went out in `4a653e96` with a
        template literal flattened to a single space of indent. Syntactically valid, all 5 gates
        green, purely cosmetic — but it shipped, and the r-end docs agent caught it, not me. Fixed at
        r-end. **A whitespace-normalising codemod must anchor to line starts**, and the
        `dimension-bare-numeric` invariant below proves nothing about formatting.
      - **The check that mattered:** `dimension-bare-numeric` measured **532 before and after**, so
        zero non-icon classes were touched — the pairing bug caused misses only, never wrong
        conversions. That single number is the cheapest possible proof and is worth re-running on any
        future sweep.
      - **Verified live across 18 routes: 437 migrated icons render, 437/437 at their exact named px
        at a 16px root, 437/437 grew at a 24px root** (232 last tranche). Code `4a653e96`.
- [x] **Scanner false positive fixed (Conv 421), surfaced by the sweep.** `tokened-did-not-scale`
      fired on `/admin`. Not a real defect: `collect()` skips zero-size elements, so anything
      changing visibility between the two passes shifts the array — and **at a 24px root a
      `size-icon-16` measures 24px, exactly matching a `size-icon-24` from the 16px pass**, so a
      one-element shift reads as "did not scale". The passes are now paired by a **stamped element
      id** rather than array position (the `% scale with root` summary too). Direct measurement
      confirmed every `size-icon-24` on `/admin` scales 24 → 36px. Lesson: pair by identity, never by
      index, whenever two measurement passes can differ in membership.
- [ ] **Mandatory per-tranche reachability check — standing, re-runs every tranche.** Run `.claude/scripts/codecheck-orphan-components.mjs`
      over every file in a tranche **before** editing it. Conv 419 measured that **5 of its 43 icon
      fixes landed on dead code** — hitting `TestimonialsBrowse`, the same file Conv 404's `[A11Y]`
      batch already wasted a fix on 15 convs earlier. tsc/lint/tests/build are all green over dead
      code, so nothing else in the pipeline catches it. *Conv 420: ran clean — `PASS`, every component
      route-reachable, no wasted edits.* **Conv 421 widened what "reachable" has to mean.**
      `[ICON-AUDIT]` found the check is necessary but not sufficient on two axes: (i) 5 files edited by
      earlier tranches were **deleted two commits later** by `[MKTDEAD]`, which no pre-edit check can
      foresee; (ii) route-reachable is not the same as *icon*-reachable — `/course/[slug]` was fully
      reachable yet rendered 26 icons of which **0** were tokened, so tranches were landing on files that
      render nothing this axis governs. Pair the orphan check with a **render census** of the target
      surface before choosing a tranche, not just after.
- [ ] **`[ICON-4PX]` residue — now the block's *entire* remaining icon debt, and it is exactly 25
      classes.** All 25 sit in `BecomeATeacherPage` (`/become-a-teacher`), the second and last of the 7
      legacy-v3-semantics files, gated behind the parked `[RG-PUBLIC]` marketing redesign. Conv 421's
      sweep (3b) cleared everything around it, so **no live icon-size debt remains anywhere else in the
      app.** A deliberate park, not a blocker; fold into whichever tranche runs when the marketing
      redesign is scheduled. Being legacy-v3 throughout, expect the `ModeratorInvite` / `Header`
      remedy — repair the component whole — rather than an icon-axis-only edit.

### Phase 5 — Completeness proof ✅ (Conv 422)

Full double-root-font sweep across every in-scope route plus the states a route walk never reaches.
Any icon that doesn't move between a 16px and a 24px root is a missed site; any clipped or
overflowing element is a container that didn't follow its icon.

**Conv 421 got the *rendered* half a long way:** 437 migrated icons across **18 routes** measured at both
roots, **437/437** at their exact named px at 16px and **437/437** growing at 24px. The scanner's
completeness rule was also widened `inline-did-not-scale` → `tokened-did-not-scale`, which — now that
every token is rem — makes *any* `size-icon-*` measuring identically at both roots provable evidence of
a missed site, across the whole axis rather than just the inline arm.

**Conv 422 closed the coverage half, and it caught something.**

- [x] **Route coverage: 50 of 50 in-scope pages.** 80 distinct URLs / 95 route-states, up from 26.
      **The "67 routes" figure was wrong for this purpose** — it counted `/old/*` (14,
      retire-by-default) and `/dev/*` (3, provenance opt-out). The governed surface is **50**, and six
      of those are `[...tab]` catch-alls rendering 2–7 tabs each, so the real surface is larger than a
      page count suggests. Coverage is now *computed* (route list matched against the page files using
      Astro's own specificity ordering), not asserted — the first version of that probe reported 4
      false gaps by letting `course/[slug]/[...tab]` claim `/course/x/book`.
- [x] **Empty states.** Driven by scanning the list routes a second time as `usr-admin`. The driver
      must be data-empty **and capability-bearing**: the obvious pick (`fraser@meristics.com`, 0
      enrollments / 0 notifications / 0 conversations) also has **0 capability flags**, so /teaching
      and /creating bounce it instead of rendering an empty list. *"0 rows" is not "renders the empty
      state" — the route guard decides.*
- [x] **`ModeratorInvite` — 4 of its 5 view states now measured** (`valid`, `error`, `success`,
      `declined`), plus the decline **confirmation modal**. Only the transient `loading` is unmeasured.
      `success`/`declined` exist only after a POST, so they needed the new opt-in
      `--drive-invite accept|decline` mode, which clicks through the flow. It consumes the seed's
      pending invite (and `accept` grants a real moderator role), so it is deliberately **not** wired
      into `npm run icons:scan`; restore with `npm run db:setup:local:dev`. Every `size-icon-*` in
      those states scaled (16→24, 32→48, 20→30); the only non-scaling elements were `size-[32px]`
      avatars, correctly arbitrary px.

**What the widened sweep found — 4 non-icons wrongly tokened by tranche 2** (`c429f150`). A course
thumbnail `<img>` and its placeholder `<div>` (`CoursePerformanceTable.tsx:144,147`) and two skeleton
bars (`:71`, `AdminDashboard.tsx:333`) had been converted from `h-N w-[Npx]` to `size-icon-N w-[Npx]`.
Not cosmetic: the token sets height while the adjacent `w-[Npx]` wins for width, so **height scaled
with the root font while width stayed pinned** — the thumbnail distorts from 56×40 to 56×60 at a 24px
root. Each was also a permanent false positive in `tokened-did-not-scale`, i.e. a mis-classified
element was poisoning the block's own completeness instrument. Fixed to `h-[40px]`/`h-[24px]`/`h-[32px]`
— pixel-identical at the default root (40/24/32 are all in the override set, so `h-N` already meant N
px), and the governed/informational counts both stayed put (25 / 532), confirming the edits landed in
neither bucket. A source-wide check for the same shape (a token co-occurring with a competing `w-`/`h-`)
now returns **0**.

**This is the phase justifying its own cost.** Tranche 2's record already admitted R1 matched ~44%
non-icon elements; these four are the ones that made it into an actual edit, and no static rule caught
them — only rendering the page at two root sizes did.

**Scanner robustness (same conv).** One bad seed email aborted the entire run at route 46 of 95,
losing every later group; a failed login now skips that user's group and continues. Logins are grouped
per user (6 rather than 95).

### Per-element call-site attribution ✅ (Conv 422)

Phase 5's page-level coverage could not answer *"which source sites have never rendered at all?"* This
closes that. **The planned approach was killed by its own spike, which is the point of spiking.**

**Why a build-time stamp cannot work.** The intended design was a dev-only babel/Vite transform
stamping `data-icon-src="file:line"` at each call site. `MattIcon` and every component in
`ui/icons.tsx` have **closed prop interfaces** (`{name, className}` / `{className}`, no `...rest`), so
an injected attribute is silently dropped. Making it work would have meant changing shared production
primitives to serve a dev-only measurement — a bad trade, and one only visible by reading the
components first.

**What works instead — zero production footprint.** React 19 **did** remove `_debugSource` (verified
empirically, not taken from memory), but `_debugStack` survives and carries the JSX creation stack.
The `<svg>`'s own stack points at the icon component's internals (`MattIcon.tsx:71`); one fiber up —
the `<MattIcon>` element itself — points at the caller (`Sidebar:351`). So: **walk up while
`className` is the same string; the outermost such fiber is where the class was written.** An
un-classed `<FeedIcon />` is the deliberate exception — the walk stops at the `<svg>` and attributes to
`icons.tsx`, which is correct, because that is where the class literally lives and where the static
inventory counts it. **95% of rendered tokened icons attribute** (252 of 265 over 6 routes). No babel
plugin, no Vite transform, no production change, no prod-build risk.

**Two limits encoded in the tool, not glossed.**

1. **Line numbers are transformed-module lines, not source lines** — `IconLabelChip.tsx:43` in the
   served module is an interface declaration in the `.tsx`. They are valid as *stable per-site
   identities* (distinct sites get distinct numbers; a site rendered in a loop keeps one), so the
   ledger aggregates **per file** and never prints a source line it cannot stand behind.
2. **`.astro` icons have no React fiber** (SSR without a `client:*` directive), so they are outside
   this method entirely — 61 static sites and 151 rendered icons, reported as a **named blind spot**
   rather than counted as residue.

**The ledger (97 route-states):**

```
629 static `size-icon-*` sites across 176 files · 238 proven rendered (38%)
    107 component DEFAULTS  +  522 call sites
  + 61 sites in .astro files — not attributable by this method
120 files carry at least one unproven site
```

**Reading it honestly — the largest single block is not a coverage gap.** `ui/icons.tsx` shows 99 of
99 unproven, 98 of them defaults. Measured: the file exports **98** icon components each defaulting to
`size-icon-20`, but only **6 usages in the whole app omit `className`** (4 of those in the parked
`BecomeATeacherPage`) against **381** that pass their own. Those defaults are **near-dead by
construction**, not un-swept. This is the third independent measurement undercutting the Conv-420
"component defaults are the high-leverage target" claim, after the audit's "MattIcon's default fires on
23 of 199 call sites".

**The residue is state-coverage, not dead code.** `codecheck-orphan-components.mjs` returns
**PASS — every `src/components/**` component is route-reachable**, so every unproven site sits in code a
user can reach; it simply never rendered under the states driven. The remaining work is therefore
driving interaction-gated UI (dropdown menus, slide-over panels, modals) and loading/skeleton states —
now a **named, countable list per file** rather than an unbounded worry.

**⚠️ The ledger's own first output was wrong, and the number is what caught it.** It reported **625 of
690** sites as "component defaults" — including 27 in `Sidebar.tsx`, a consumer. The regex used
`className\s*=\s*`, and `\s*` matches zero spaces, so it swallowed JSX attributes (`className="..."`)
along with genuine destructuring defaults (`className = '...'`). The code comment stated the rule
correctly; the regex did not implement it. `\s+` fixes it — true split **107 defaults / 457 JSX
attributes / 61 `.astro`**. Same lesson as the Conv-421 index-pairing false positive: *verify the
instrument against a number you can predict before quoting its output.*

### Phase 6 — Tighten the guard 📋

Once no arbitrary px remains on icon elements, promote those rules from warn to error and drive the
baseline to zero. Ship the **bare-number lint rule** listed under Phase 1 here if it hasn't landed
earlier. Decide then whether the `--spacing-*` numeric override should be renamed outright so no
number can ever be misread again — the deeper fix this block only works around.

**Now genuinely in reach (Conv 421).** The precondition is met — `icon-arbitrary-px` is retired (0) and
the governed total is **25**, all of them behind one parked task. So:

- [ ] **Promote the governed icon rules warn → error** once `[RG-PUBLIC]` clears the last 25, driving the
      governed baseline to **zero**. This is now a single-file dependency, not a migration.
- [ ] **Decide the fate of the 532 `dimension-bare-numeric` sites** (new, Conv 421) — the informational
      tier is a holding pattern, not a destination. Until they get an owning axis or an explicit permanent
      carve-out, "the baseline reaches zero" means only the icon half. See the open question below.
- [ ] **Ship the bare-number lint rule** (carried from Phase 1) — `check:icons` still only refuses *new*
      violations against a re-generatable baseline; nothing is editor-visible.

---

## Open questions

- ~~**`em` ratios**~~ — **✅ CLOSED Conv 421 by rescinding the family outright** (tranche 5). The block's
  longest-open question, dodged three times, is not answered so much as dissolved: there are no em tokens
  left to ratio. The four findings that decided it are in the callout under *The standard*. The residual
  worry it encoded — "a 12px-label inline icon has no home" — is moot under the two-way rule, where such an
  icon simply takes `size-icon-16` like any other. Conv 421's counterfactual measurement showed the ladder
  had been *actively harmful* where it did fire: 6 of 7 `PromoteButton` icons were rendering at 13.8px, a
  −14% shrink, because their container is 12px.
- **The 532 non-icon bare-numerics — whose axis?** (opened Conv 420 as "~390"; **measured at 532 by
  Conv 421's tranche 7**, which also split them out of the governed total into an `informational` tier.)
  Dots (114), skeletons (64), avatars (33), media (29), boxes. The standard puts them in the "neither"
  bucket, so *this* axis does not govern them — yet they carry exactly the same `N`-means-two-things
  ambiguity. They are now **measured and reported but ungated**, which stops them distorting this block's
  progress metric but is explicitly a holding pattern. Decide: their own axis, an arbitrary-px sweep, or an
  explicit permanent carve-out. Note the two *pure noise* sources tranche 7 removed are already gone and
  are not part of the 532 — 51 fraction false positives (`w-1/2` matched as `w-1`) and 94 `min-`/`max-`
  mislabels (`min-w-0` reported as `w-0`, under a class name absent from the file and therefore ungreppable).
- **Matt's ladder.** He formalized only Small 20 / Medium 24. We ship 11 steps because 16px is the
  most-used size (72 sites) and isn't in his set. If Matt returns to the project, reconcile.
- **Pixel-grid softness.** At a 1.3× root font a 20px glyph renders 26px and can sit off-grid.
  Accepted trade; revisit if it reads badly at large font sizes.

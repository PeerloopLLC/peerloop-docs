# State — Conv 425 (2026-07-28 ~04:49)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Took MERGE-BRIAN §2 (`/courses`) from an empty plan section to complete: inventoried 16 mechanisms from
the pivot snapshot, dispositioned every one (3 ADOPT · 12 ADAPT · 1 DROP), then built all 14 that were
buildable across three tiers plus both standing findings. Two mechanisms are gated on new prerequisite
tasks rather than dropped, because verification showed each would otherwise strand a surface with no
other home. Closed with a self-audit, a full narrow-width sweep, and an empty-state copy fix. 6 code
commits (`f2c4dd80`→`cd0f36e9`) + 6 docs commits; suite 6131 → 6165; 5 gates green throughout.

## Key Context

- **§2 is complete for everything buildable.** Only M3 (role tabs) and M4 (recommendations carousel)
  remain, each gated on a new task — `[ROLE-CRS-LIST]` and `[REC-REHOME]`, both now `[Opus]`-tagged and
  queued at #2/#3. Neither is blocked on a decision; they are blocked on building the destination first.
  **`[REC-REHOME]`'s destination is still open** — Home is the obvious candidate but `[FEEDS]` (Conv 267)
  bars re-adding panel surfaces to `/`. Decide that before starting it.
- **The single most transferable lesson: an off-screen Chrome window corrupts both scripted behaviour
  and screenshots.** `visibilityState: "hidden"` makes programmatic smooth scrolling a no-op and
  throttles React re-renders, AND any region past the screen edge captures as flat dark while its DOM is
  correct. Two "failures" this conv were that one cause; the user diagnosed it. Before concluding
  "doesn't render", check `visibilityState` and whether the element's rect exceeds `innerWidth`, then run
  the loud-mutation test (force `background:red`, re-shoot). Written up as `[BRIDGE-OFFSCREEN-WINDOW]`.
- **Verify against consumers, not string matches.** `formatPrice` looked like 11 call sites; 6 of those
  files define their own local copy and never imported the shared helper — which is why an admin test
  asserting `$199.00` survived the change. Real count: 4, one being the receipt page, which is what
  produced the `formatPriceExact` carve-out. Same `[PREMISE]` shape as the plan's own stale M11 entry
  ("reuse the primitive we built" — the primitive didn't exist; Conv 410 had landed inline markup).
- **A variant switch is a silent orphan-maker.** Moving `/courses` to `cover-story` left the
  `stacked + context="catalog"` path unreachable while tsc, lint and 6155 tests stayed green. Caught only
  by a deliberate self-audit; removed. Register newly-stamped components on landing too — three new ones
  took `prov:sweep` 11→17 before being registered back to baseline.
- **`flex-wrap` cannot push a sibling to its own row** — flex items shrink before they wrap, so the
  375px title fix needed an explicit `flex-col … @xl:flex-row`.
- **The `[VPHARNESS]` iframe harness is the only way to check widths** (`resize_window` never applies
  width). `/courses` is now swept clean 320→1280. That also cleared one of `[MINWIDTH-320]`'s three
  blockers — `MembersFilters` and the Home feed-card button remain, both unverified.
- **Not fixed, deliberately:** the four role-tab empty states ignore their own `sub` filter, so a student
  on `sub=completed` is told they have never enrolled. Same defect class as the all-tab copy fixed this
  conv, but those tabs retire once `[ROLE-CRS-LIST]` lands. Recorded in `[COURSES-FIXES]` with file/line.
- `docs/as-designed/matt-design-system/08-layout-and-margins.md` was corrected at `/r-end` — it still
  described `/courses` as a `ListingShell` page. It is a `manual` doc, so the docs agent correctly left
  the call to the main context.
- For the task backlog see `CURRENT-TASKS.md` — do not re-list here.

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context.

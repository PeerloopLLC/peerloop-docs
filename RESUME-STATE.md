# State — Conv 420 (2026-07-26 ~20:45)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Four `[ICON-TOK]` tranches took the icon-sizing baseline from **1,694 → 1,337** — 46 of that a
measurement correction, **311 genuine migration**. Every tranche's premise turned out to be wrong
before it was executed, always over-scoped, which is now the conv's real finding and has been written
into memory. The last tranche stopped being a migration and became two repairs: a whole component
rendering an 8px glyph in a 16px circle, and a 12px error mark that should have been 48px. Six code
commits and five docs commits pushed mid-conv; this is the bookkeeping commit. Suite steady at 6131,
5 gates green throughout.

## Key Context

- **Re-test every tranche premise before executing it — the check is one tool call and it has now hit
  seven times.** Conv 420 alone: the tasked "46 icons with no size class" were **all** false positives
  (14 avatars with a typed `size` prop, 32 sized by a component default already counted elsewhere), and
  the "891 sites that shipped 4px icons" is really ~501 icons + ~390 skeleton bars, badge circles, dots
  and avatars that the icon axis does not govern. Both were written from the scanner's output shape
  rather than the code it pointed at. Memory: `feedback_retest_task_premise_before_executing.md`.
- **Look for the upstream default before migrating call sites.** Tranche 1 cleared 200 violations with
  94 edits because `MattIcon.tsx:43` and the `ui/icons.tsx` family sit above every un-classed usage.
  Verify numerical identity first — `h-5 w-5` = `calc(0.25rem × 5)` = 1.25rem = `--icon-20` — so the
  change is provably neutral rather than hopefully so.
- **The em ladder is the block's next real decision, and it has now been dodged twice.** Its three
  steps are anchored on 14px body text, so against a 12px label they top out at 17.4px. Both times it
  came up (AdminNavbar, then the 12px glyph group) it was resolved by classifying *around* the ladder.
  Tranche 3b is ~369 classes at 16/20/24px where most glyphs sit beside text — settle it first, or a
  third workaround gets baked in.
- **"No regression" from `icons:scan` is not evidence about code it never rendered.** A direct probe
  showed only **4 of tranche 2's 44** sites actually render under seeded data; the rest are empty-state
  marks behind "list is empty" conditions. Phase 5 must drive empty/error states deliberately. The
  probe pattern that answers this: query `[class*="size-icon-"]`, measure at 16px and 24px root, count
  how many grew.
- **`icons:scan --json` emits per-route summaries (`{count, scaled}`), not raw measurements** — the
  header claim was wrong and is now fixed in both the script and `SCRIPTS.md`. A grep for token names
  in that dump returns 0 and does *not* mean the migration failed.
- **The legacy-Tailwind-semantics class is bounded and now closed except for one parked file.** Only 7
  files use the v3-era palette; only 2 carried overridden icon classes. `ModeratorInvite` was repaired
  (user authorised crossing into the spacing scale as a one-component exception); `BecomeATeacherPage`
  remains parked behind `[RG-PUBLIC]` and is the source of all 11 remaining runtime findings.
- **Dev server:** `localhost:4321`, never `127.0.0.1`. `npx astro dev stop` / `status` / `logs` exist —
  use them instead of `kill` against `lsof`. A 500 naming `deps_ssr/…` means `rm -rf node_modules/.vite`.
- **MEMORY.md is at 76% of the auto-load cap** after an inline compaction of 11 bloated index lines; a
  full `/r-prune-memory` consolidation run is still owed. See `[MEM-PRUNE]`.
- For the task backlog see `CURRENT-TASKS.md` — do not re-list here.

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context.

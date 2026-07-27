# State — Conv 421 (2026-07-27 ~08:55)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Opened with a concern that the icon-sizing work had drifted the app's appearance. An audit answered
it — **it had not** (153 of 206 changed dimension lines were pixel-identical) — but found the work had
been measuring the wrong thing and landing on surfaces that barely render. The rest of the conv acted
on that: retired the arbitrary-px class on the Matt surface, rescinded the em inline-icon family,
repaired the legacy shell header, split the guard's metric into governed vs informational, and ran the
mechanical sweep. **Icon debt went 1,337 → 25, and all 25 remaining sit in the parked
`BecomeATeacherPage`** — no live icon-size debt remains anywhere in the app. 6 code commits, 7 docs
commits, 5 gates green throughout (suite 6131).

## Key Context

- **`[ICON-TOK]` migration is done; the block is not.** Phases 1–4 complete. **Phase 5 (completeness
  proof) and Phase 6 (tighten the guard) remain** — 437 icons are proven correct at two root font
  sizes across 18 routes, but **49 of 67 routes are unswept**, and empty/modal/error states have never
  been driven deliberately. Do not read "migration complete" as "block closed".
- **The icon rule is now TWO-way, not three.** rem (`size-icon-N`) for any icon; arbitrary px only for
  genuine non-icons. The em family `--icon-inline-{sm,md,lg}` was **deleted** — a tombstone comment in
  `tokens-primitives.css` carries the four findings so it doesn't get re-proposed. Rescinding it turned
  out to be a **repair**: a counterfactual measurement showed it had been rendering 6 of 7
  `PromoteButton` icons at 13.8px (−14%) since Conv 420, because their container is 12px, not the 14px
  the record claimed.
- **`check:icons` now reports two tiers.** `icon-bare-numeric-*` is **gated** (baseline 25);
  `dimension-bare-numeric` is **measured but not gated** (532 — skeletons, dots, avatars, media,
  boxes, `min-`/`max-`). The headline total is the migration target, so it reads as progress. Whether
  the 532 get their own axis is **the block's live open question**, now a Phase 6 subtask.
- **Two verification patterns worth reusing.** (1) *The invariant counter* — before a codemod, pick a
  number it must not move (`dimension-bare-numeric` = 532) and check it either side; one number ruled
  out the whole wrong-conversion failure mode. (2) *The counterfactual* — to learn what a removed token
  had been rendering, re-apply its value to the live element and measure.
- **Three of this conv's own instruments produced false positives**, all caught by checking a number
  rather than re-reading code: a line-proximity classifier misread sentinel `<div>`s as icons; a
  whole-file string regex desynchronised on an apostrophe in JSX prose (80 silent misses); and the new
  `tokened-did-not-scale` rule paired two measurement passes **by array index** — at a 24px root a
  `size-icon-16` measures 24px, exactly matching a `size-icon-24` from the 16px pass. Pair by identity,
  never by index.
- **One cosmetic residue shipped and was fixed at r-end** — `HomeworkEditor.tsx:553-554` had its
  template-literal indentation flattened by the whitespace collapse. The r-end docs agent caught it,
  not me; my "caught before damage" claim was corrected across the Extract, plan and PLAN.md.
- **Seed-data facts that cost time this conv:** teachers are derived from `teacher_certifications`
  (there is no `teachers` table) — `guy-rymberg`/`sarah-miller`/`marcus-t`; creators are
  `guy-rymberg`/`gabriel-rymberg`; `PublicProfile` lives at **`/@[handle]`**, not `/profile/[handle]`;
  `PromoteButton` needs `canPromote` (admin / course creator / certified teacher). A route returning
  **200 with an empty shell** looks identical to an unwired component — check the loader's predicate.
- **Dev server:** `localhost:4321`, never `127.0.0.1`. Use `npx astro dev stop|status|logs`.
  Playwright scripts must resolve from inside `~/projects/Peerloop`.
- For the task backlog see `CURRENT-TASKS.md` — do not re-list here.

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context.

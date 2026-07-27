# State — Conv 422 (2026-07-27 ~12:55)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Closed `[ICON-TOK]` **Phase 5** (completeness proof) and then went further than the phase asked:
route coverage went from 26 URLs to **50 of 50 in-scope pages** (80 URLs / 97 route-states) with empty
and post-POST states driven deliberately, and per-element **call-site attribution** now answers which
*source sites* have provably rendered — the residue Phase 5 had only been able to name. The widened
sweep earned its cost by catching 4 non-icons that Conv 420's tranche 2 had wrongly tokened. Phases
1–5 are done; only Phase 6 remains. 2 code commits, 2 docs commits (+ bookkeeping), 5 gates green
(suite 6131).

## Key Context

- **The block's central claim is now much stronger, and its limits are written down.** 1,858 tokened
  renders measured at two root font sizes across 97 route-states, **zero `tokened-did-not-scale`**;
  and the ledger says **238 of 629** attributable source sites have provably rendered. Do not read
  38% as "62% broken" — see the next two bullets.
- **The biggest unproven block is not a coverage gap.** `ui/icons.tsx` shows 99 of 99 unproven, 98 of
  them component defaults. Measured: only **6 usages app-wide omit `className`** (4 in the parked
  `BecomeATeacherPage`) against **381** that pass their own — the defaults are near-dead by
  construction. Third independent measurement undercutting the Conv-420 "component defaults are the
  high-leverage target" claim.
- **The residue is state-coverage, not dead code.** `codecheck-orphan-components.mjs` returns PASS,
  so every unproven site is route-reachable and simply never rendered under the states driven. The
  remaining work is interaction-gated UI (dropdowns, slide-overs, modals) and loading skeletons — now
  a countable per-file list.
- **Attribution technique + its two hard limits.** React 19 **removed `_debugSource`** (verified
  empirically); `_debugStack` survives and carries the JSX creation stack. Walk up while `className`
  is the same string → the call site. A build-time stamp was tried first and **cannot work**:
  `MattIcon` and all 98 `ui/icons.tsx` components have closed prop interfaces (no `...rest`), so an
  injected attribute is dropped. Limits: (1) stack line numbers are **transformed-module** lines, not
  source lines — valid as site *identities*, so the ledger aggregates per file; (2) `.astro` icons
  have **no React fiber** (61 sites) — a named blind spot, not residue.
- **Empty-state driver rule:** must be data-empty **and capability-bearing**. `fraser@meristics.com`
  has 0 rows but 0 capability flags, so guarded routes bounce it. Use **`usr-admin`** (all three
  flags, zero data).
- **`--drive-invite accept|decline` MUTATES the dev DB** (consumes the seed pending invite; `accept`
  grants a real moderator role) and **returns early without running the main sweep**. Restore with
  `npm run db:setup:local:dev`. It is deliberately not wired into `npm run icons:scan`.
- **Three instruments built this conv produced wrong output before being corrected** — the coverage
  probe (matched routes in file order instead of Astro specificity → 4 false gaps), the ledger's
  defaults classifier (`\s*` matches zero spaces → 625 of 690 mislabelled), and two figures I quoted
  from raw greps rather than the ledger's own classifier (95 vs 97 route-states; "457 JSX attributes"
  vs the true 522 call sites, caught by the r-end plan agent). Every one was caught by a number
  looking implausible, not by re-reading code. **Predict a number before trusting the tool that
  produces it.**
- **Phase 6 is what's left:** warn→error promotion (blocked behind `[RG-PUBLIC]` clearing the last 25
  in `BecomeATeacherPage`), the **532-site decision** (own axis vs permanent carve-out — explicitly
  the user's call, not pre-empted), and the editor-visible bare-number lint rule.
- For the task backlog see `CURRENT-TASKS.md` — do not re-list here.

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context.

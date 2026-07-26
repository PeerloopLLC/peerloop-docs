# State — Conv 419 (2026-07-26 ~17:00)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Closed the **MESSAGES mini-plan M1–M6** (M5 `[MSG-ADOPT-B]` 10/10 live-verified, M6 `[MSG-CLEANUP]`), then followed the two defects M5's verification surfaced much further than they were scoped. `[COURSETAB-HASH]` turned out to be the same three-state hydration race as `[MSGBOOT]` in a different consumer. `[ICON-4PX]` grew into a design decision, a new token axis, two verification tools, a PLAN block — and finally `[MKTDEAD]`, which deleted 80 dead files after settling *by measurement* which orphan oracle to trust. Four code commits and six docs commits pushed mid-conv; this is the bookkeeping commit. Suite ended at **6131** (down from 6586 purely because 455 tests covered deleted code), 5 gates green throughout.

## Key Context

- **The conv's through-line is that four task premises were wrong, all the same way.** `[CANMSG]`, `[MSG-ADOPT-A]`, `[MSG-ADOPT-B]` and `[COURSETAB-HASH]` were each written by reading the *implementation* rather than enumerating the *consumers*. Expect this on `[ICON-TOK]` Phase 3 and re-test the premise before executing — the check is one tool call and it hit four times.
- **The icon standard is decided and documented; do not re-derive it.** Three-way split by role: inline (beside text) → `size-icon-inline-{sm,md,lg}` in **em**, standalone → `size-icon-N` in **rem**, and dots/avatars/hit-targets/`ui/icons.tsx` defaults → fixed px. Rationale + verified measurements live in `matt-design-system/05-color-and-tokens.md § Icon Size`; the 6-phase sequence is in `plan/icon-sizing/README.md`.
- **Matt formalized icon sizes and we had never used them** — his Figma "Icon Size" collection is Small 20 / Medium 24, now marked `✓ Matt` in `tokens-primitives.css` with the other nine steps CC-owned. 16px, the app's most-used size (72 sites), is not in his set. Reconcile if he returns to the project.
- **The orphan oracle is settled: sourcemap `sources`.** Temporarily add `vite.build.sourcemap` to `astro.config.mjs`, build, union the `sources` arrays of every `dist/**/*.map`, restore. It found 56 where the route detector found 53 and knip found 14. Both other tools are defeated by barrels in opposite directions — a **dead** barrel keeps a component alive for knip; a **live** barrel with an unconsumed re-export hides one from route-reachability. Do **not** name-match against minified `dist/`; that was tried and was wrong in both directions.
- **Two things are genuinely unverified about the icon work**, and they are the honest next steps rather than open questions: the **46 icon usages with no size class at all** (found statically, never measured — they render at *something* right now), and the absence of a true "before" baseline for the 43-site change, since `icons:scan` was built after it. The before is reconstructable from `73d9f416`.
- **`[ICON-TOK]` Phase 4 must run the reachability check per tranche.** 5 of this conv's 43 icon fixes landed on dead code — a repeat of Conv 404's `[A11Y]` failure, on the same file, 15 convs later. At 1,694-site scale that mistake is expensive.
- **Dev server:** use `localhost:4321`, not `127.0.0.1` — the astro dev daemon binds `[::1]` only. Playwright scripts must run from inside `~/projects/Peerloop`.
- For the task backlog see `CURRENT-TASKS.md` — do not re-list here.

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context.

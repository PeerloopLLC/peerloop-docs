# State — Conv 424 (2026-07-27 ~16:20)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Closed the ICON-SIZING block: all six phases are complete, the icon guard is a hard absolute gate at zero
governed violations, and the last parked residue is gone. Before that, falsified the memo that had quietly
demoted the Chrome bridge to a dead end, and proved the Conv-423 spacing change safe across every canonical
route — visually and arithmetically. Two standing open questions were settled by user decision. 2 commits
(code `4e45bc14`, docs `e40104b`) plus this conv's bookkeeping; 5 gates green (suite 6131 / 395 files).

## Key Context

- **The recurring shape this conv, three times in three different tools: a success-shaped failure.**
  `navigate` returns `"Navigated to …"` while the tab sits on `chrome-error://chromewebdata/`;
  `resize_window` reports `"Successfully resized … to 1600x1000"` while width never moves off 1156;
  `--update-baseline` would happily snapshot violations away. **After any state-changing call, read the
  state back.** This is the single most transferable thing from the conv.
- **The bridge works — always `localhost:4321`, never `127.0.0.1`.** `astro dev` binds `[::1]` only, so
  the IPv4 literal has nothing listening. The Conv-413 "proxy in its profile" diagnosis is **disproven**
  (the bridge loads a throwaway IPv4-bound server fine). The old memo also contradicted itself — it
  claimed curl 200 on *both* literals while stating the `[::1]`-only bind. Memory rewritten as
  `[BRIDGE-OK-USE-LOCALHOST]`; Playwright is a fallback, not the default.
- **`resize_window` cannot set width** — use the exact-size same-origin **iframe harness**. Two
  non-obvious parts: the app's own CSS reset caps embedded elements at `max-width:100%` and silently
  clamps the iframe (override `!important` alongside `width`/`min-width`), and leave scale slack or the
  capture crops the last ~16 CSS px. Tracked as `[VPHARNESS]` / `[BRIDGE-RESIZE]`.
- **Half the remaining "icon violations" were never icons.** `iconRanges()` windowed each icon definition
  as `[def.start, nextDef.start ?? text.length]`, so the last definition in a file claimed every offset to
  EOF. 13 of 25. Any `[start, nextMatch ?? end]` windowing needs a second bound — and verify the fix did
  not over-correct (injection: still caught, 12 → 14). **Fourth time** this block's headline number
  carried non-defects.
- **The spacing sweep is provably complete, not just spot-checked.** Every overridden number and every
  `N→N×4` output is a multiple of 4, so surviving non-multiples are exactly the missed sites: 92
  survivors ↔ 92 pre-sweep fractional utilities, 1:1, zero mismatches. Look for an invariant the *unfixed*
  cases violate rather than sampling routes.
- **Resolve imports, never grep the tag name.** "6 usages omit className, 4 in BecomeATeacherPage" was
  entirely name collisions (local `CheckIcon`/`CloseIcon` wrappers, a different `entity/UserIcon`). True
  figure: **0 of 395**. I produced two wrong intermediate answers before resolving imports.
- **Three defects found on touched pages were all PRE-EXISTING** — each needed its own proof (component
  byte-identical across the sweep / value present at `dc1f031e~1` / number in the override set). Proximity
  to a change is not causation. They are `[ADMIN-OVFLW]`, `[LH1]`, and the known `[ICON-4PX]` icons.
- **Open policy call for next conv: `[GATEPAR]`.** `npm run verify` now runs `check:icons`;
  `/w-codecheck` does not, and CLAUDE.md §Baseline Verification still says five gates. Decide whether the
  icon guard is a sixth baseline gate, then make all three agree.
- **A Python bounded-slice edit destroyed the `### Phase 6` section** of `plan/icon-sizing/README.md` and
  it was committed that way in `e40104b`; the `/r-end` update-plan agent caught and restored it. Read
  prose back after a programmatic multi-line deletion.
- ICON-SIZING was deliberately **not archived** — `[ICON-STATES]` (drive interaction-gated/loading states
  over 528 attributable call sites) is genuine outstanding work. `[ICON-LIC]` stays parked on MVP-GOLIVE.
- For the task backlog see `CURRENT-TASKS.md` — do not re-list here.

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context.

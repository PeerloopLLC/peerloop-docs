# State — Conv 423 (2026-07-27 ~14:15)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

Fixed the numeric-spacing ambiguity that the entire ICON-SIZING block was built to work around — at
the root, in one line, rather than at call sites. Tailwind v4's base `--spacing` multiplier is now
`0.0625rem`, so a bare number means its own pixel count for **every** N, including ones nobody has
typed yet. 449 call sites that relied on the old ×4 reading were rewritten `N → N×4`, provably
value-preserving. Then closed the block's icon loose ends: rules reframed, informational tier retired,
Phase 6's lint rule cancelled, `[ICON-AUDIT]` closed, and the `--icon-N` family kept by user decision.
2 code commits, 2 docs commits (+ bookkeeping), 5 gates green (suite 6131).

## Key Context

- **The block's founding premise is gone.** `h-4` meaning 4px while `h-5` meant 20px — the split that
  shipped 4px icons — no longer exists. Conv 174 overrode ten *names*; it never touched the **base
  multiplier**, which is where Tailwind v4 resolves every un-named number (`calc(var(--spacing) * N)`).
  Every `--space-N` *and* `--icon-N` token was already exactly `N × 0.0625rem`, so the base was simply
  off by 4×. Verified by compiling the real stylesheet, not read from docs.
- **Blast radius was proven before anything was edited: one line differs in 185 KB of compiled CSS.**
  Every emitted utility rule is byte-identical, so all 4,911 overridden-number sites are untouched.
  That measurement is the reason this was safe to do in a single conv.
- **`npm run spacing:scan` is new** and is the standing proof: the invariant "a spacing class `X-N`
  measures N px" simultaneously covers the base change *and* all 449 rewrites, so no before-run is
  needed. 4,206 strict measurements / 12 routes / 0 mismatches. It excludes variant-shadowed base
  classes — without that it reports 184 false mismatches.
- **Scoping a rejected option produced the winning one.** Pricing the "rename the override" idea at
  4,911 sites / 295 files also surfaced the 4,911-vs-361 distribution, which is what pointed at the
  base multiplier. Worth repeating: look at the distribution the count came from, not just the total.
- **Three instruments were wrong before correction** — SQL `%Y-%m-01` read as a margin utility, diff
  hunks paired by index, and 184 variant-shadowed "mismatches". Each caught by a number looking
  implausible. Predict the magnitude before trusting a new instrument.
- **`--icon-N` is KEPT (user decision)** — behaviourally redundant now (`size-icon-16` ≡ `size-16`) but
  it is the only record of *which elements are icons*, and retiring it is a one-way door on four convs
  of identification work. Rationale rewritten in the design-system SoT (`[TOKDOC]`).
- **Next conv is already scoped, positions 1–2 on the board.** `[BRIDGE-DIAG]` (tagged `[Opus]`) —
  re-test the premise **first**; the Conv-413 memo recorded a workaround and was never diagnosed, and a
  fallback that quietly became the default is the actual finding. Then `[SPACING-VIS]` — Chrome-bridge
  visual pass at a 16px base over every affected route. What is proven is value-preservation; what is
  **not** proven is appearance.
- Phase 6 now reduces to one item: warn→error promotion, still gated on `[RG-PUBLIC]` clearing 25
  sites in `BecomeATeacherPage`.
- For the task backlog see `CURRENT-TASKS.md` — do not re-list here.

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context.

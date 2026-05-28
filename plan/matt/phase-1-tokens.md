# Phase 1 — Tokens [MATT-EXEC-TKN]

**Status:** ✅ COMPLETE (Conv 174)
**Family:** matt
**Spec:** `docs/as-designed/matt-pre-plan.md` §9 Phase 1
**Tokens code:** `src/styles/tokens-primitives.css`, `tokens-semantic.css`, `tokens-tailwind-bridge.css`, `tokens-typography.css` (added Conv 181)

---

## Summary

Phase 1 token files landed on `jfg-dev-13-matt` (branched from `jfg-dev-12`).

- `src/styles/tokens-primitives.css` (~155 lines, 15 colors kebab-case per Decision 2 + 9 radius / 7 shadows / 15 opacity / 7 z-index / 8 duration / 10 spacing rem-pixel-named per Decision 1=C)
- `src/styles/tokens-semantic.css` (~165 lines, 14 semantics Title-Case-dash with cascade preserved via `var()` chains — `--Student-Primary: var(--Primary-Default)` NOT flattened, Entity multi-mode at `:root` + 3 mode classes, Icon-Size 2 tokens, Button base + 6 variant classes with seamless-edge pattern)
- `src/styles/tokens-tailwind-bridge.css` (~80 lines, color re-exports additive, Matt typography ramp additive, **spacing override per Conv 174 user choice B** — `--spacing-4: var(--space-4)` through `--spacing-64`, accepting global utility-scale break across non-`/matt/*` per Decision §1 below)
- `src/styles/global.css` updated with single `@import './tokens-tailwind-bridge.css';` line.

Snap policy applied (44/49→48, 17→16, 23→24). All 5 baseline gates green (tsc 0 / astro 1215/0/0/0 / build 6.13s). Built CSS verified: cascade chains intact, existing `--color-primary-*` untouched.

## Conv 174 — Phase 1 landed

**Strategic decisions captured:**

- **§1 Include `--spacing-N` in Tailwind bridge (accept global utility-scale break)** — Pre-authoring audit found 572 `p-4` callsites + many `m-N`/`gap-N`/`px-N` in existing app. Adding `--spacing-4: 0.25rem` (Matt's 4px) overrides Tailwind's default `p-4=1rem` globally on this branch. User chose option B (include per pre-plan §5) over option A (omit) or C (Matt-namespace). Consequence: all `p-N`/`m-N`/`gap-N`/`px-N`/`py-N` callsites on `jfg-dev-13-matt` where N ∈ {4,8,12,16,20,24,32,40,48,64} now resolve to Matt's pixel-named values. Effective scale is mixed (`p-1=4` multiplicative; `p-4=4` overridden; `p-5=20` multiplicative). `jfg-dev-12` and earlier branches unaffected — change is scoped to `jfg-dev-13-matt` until flip.
- **§2 Branch `jfg-dev-13-matt` created from `jfg-dev-12` for `/matt/*` coexistence** — per matt-pre-plan.md §1 directive. All Conv 174 code commits land on `jfg-dev-13-matt`; docs commits remain on `main`.

**Patterns established:**

- **Tailwind 4 `@theme` tokens emit on-demand, not eagerly** — Phase 1's built CSS contained ZERO of Matt's bridge color tokens (`--color-text-default`, `--color-course-primary`, etc.) because no component consumed them yet. Phase 2 components then used them → rebuilt CSS contained all of them. Verification protocol when adding new bridge tokens = "write component that consumes it, rebuild, re-grep dist/" — don't panic if a freshly-authored bridge token isn't in `dist/` until a component exercises it. (Learning #1)
- **`--spacing-N` overrides Tailwind utility scale globally, not additively** — Setting `--spacing-N: VALUE` in `@theme` overrides the `p-N`/`m-N`/`gap-N` utility rule globally for that N. Audit usage first (`grep -rho 'p-[0-9]+'`) and decide explicitly: override, namespace, or omit. Don't follow a spec doc's bridge sketch literally without checking utility-class collision. (Learning #2)
- **Matt's 2-layer + 3-layer cascade preserves correctly when authored as `var()` chains** — Authored `--Student-Primary: var(--Primary-Default)` instead of flat primitive ref. Browser resolves CSS variable chains lazily — `:root` declaration order doesn't matter; chains work as long as each link is defined on the matching cascade context. Never flatten when extracting a design system that uses semantic-to-semantic refs — the cascade IS the value. (Learning #3)

## Conv 181 — MMP-PH1 Token foundation (verification + typography canonization)

**[TSV] Token Scaffolding Verification COMPLETE** via direct-probe sweep:

- **12 Color Variables verified** (10 hits + 2 Conv 172 speculative isolated to "Speculative (Conv 172)" sub-blocks across 3 files). False naming-drift alarm corrected: `Primary/Default` was the actual Variable name; "Primary/Primary" was a plugin-rendered Color Guide label artifact.
- **18 Typography Variables canonized** (8 Body + 10 Header) into new `src/styles/tokens-typography.css` (124 lines, two leading regimes: Body small 12-14px lh:1 ls:0 / Body large 16-20px lh:1.5 ls:-2.2px / Headers lh:1 ls:0).
- Bridge typography section rewritten with all 18 Tailwind 4 `--text-{name}--<modifier>` utility classes carrying size + weight + lh + ls in one class.
- **Critical drift identified + fixed:** local `text-h1` utility had no weight (browser bold 700); Matt's Headers carry Medium 500 / Semi Bold 600.

**Speculative alert tokens — keep + isolate (Option B):** 6 Conv 172 speculative entries (`--alert-light`/`--carmine-red` primitives + `--Alert-Default`/`--Alert-Light` semantics + 2 bridge re-exports) moved to dedicated "Speculative (Conv 172)" sub-blocks across `tokens-primitives.css` / `tokens-semantic.css` / `tokens-tailwind-bridge.css` with provenance comments (verify or remove during Phase 6).

**Tailwind 4 `--text-{name}--<modifier>` consolidation** — single utility class carries size + weight + line-height + letter-spacing via modifier-suffix pattern in `@theme`. Setting `--text-body-default`, `--text-body-default--line-height`, `--text-body-default--font-weight`, `--text-body-default--letter-spacing` emits a `text-body-default` utility applying all four CSS properties.

## Conv 190 — letter-spacing token fix (design-system-wide)

`tokens-typography.css` had baked Figma's `-2.2` tracking as `-2.2px` across all four "Body larger sizes" tokens — Figma's value is `-2.2%` = `-0.022em` (~6× too tight). Fixed all four (body-medium, -medium-bold, -large, -large-medium). Surfaced by user-reported crammed "Entrepreneur" text in `text-body-medium-bold`.

## Open

- [ ] **[MND2]** Conv 174 — `detect-machine.sh` still returns `Unknown (M4Pro.local)` on M4Pro despite Conv 168 [MND] fix. Hostname-glob match issue persists. (Non-MATT — listed here because it surfaced during Phase 1 commits.)

---
name: project_spacing_snap_over_matt_exception
description: "Conformance SPACING axis snaps off-scale @matt-source spacing to the nearest 4px scale step (round-half-up on ties) — NOT kept as a sanctioned exception — even when Figma confirms the off-scale value is Matt's exact value. Overrides the §170 keep-as-exception rule for the spacing axis only; Colour keeps its exception model."
metadata: 
  node_type: memory
  type: project
  originSessionId: d409fd5b-3296-436b-94fb-7dafac3c9ff5
  modified: 2026-07-24T00:18:14.049Z
---

**DECIDED Conv 305 ([CDETAIL-CONF]).** For the conformance **spacing axis**, off-scale `@matt-source` spacing **snaps to the nearest 4px scale step** — NOT kept as a sanctioned exception — **even when Figma confirms the off-scale value is Matt's exact value**. Canonical case: CourseHeader's `px-[60px]`/`gap-[10px]`/`gap-[19px]` were Figma-verified (`517:8935`) as Matt's literal values, and the user *still* chose snap over matt-faithful.

**Why:** the [SPACING-4PX-SWEEP] goal is a strict scale; the NAV-RETROFIT bridge only defines the named set `{4,8,12,16,20,24,32,40,48,64}`px, so an off-scale arbitrary carries no token and would leak forever.

**How to apply:** snap to nearest step, **ties round UP** (`gap-[10px]`→`gap-12`, `gap-[6px]`→`gap-8`); `px-[60px]`→`px-64`, `gap-[19px]`→`gap-20`, `gap-x-[30px]`→`gap-x-32`. On-scale arbitraries (`gap-[16px]`→`gap-16`) = the zero-change tokenization already standard. **SPACING-ONLY** — Colour keeps its exception model (image-backdrop hexes, scrims, `#000` author names, shadows remain sanctioned keeps). SoT: `plan/typo-fdn/migration-ledger.md` §170 carve-out; governs all remaining route-sweep / [SPACING-4PX-SWEEP] spacing work. Relates to [[feedback_port_functionality_and_styling]].

**🔴 SILENT-FALLTHROUGH TRAP (Conv 409, live-caught).** The named set above is the ONLY set of defined `--spacing-N` tokens (N=px). Using a token **outside** it — e.g. `py-28`, `px-40`-when-unscanned — does **NOT** error or no-op: Tailwind v4's dynamic scale silently resolves `py-28` to **`28 × 0.25rem = 112px`** (stock 4px-per-unit), not 28px. In MERGE-BRIAN §1 M1 this made a "compressed" `CourseHeader` hero 224px of padding (350px total) instead of the intended slim band; fixing to a DEFINED token (`py-16 sm:py-20`) dropped it to 166px. **Rule: only use spacing values from `{4,8,12,16,20,24,32,40,48,64}`; anything else compiles to a stock-Tailwind px value ≠ its number and can't be caught by tsc/lint/build — only a DOM measure (`getComputedStyle`) reveals it.** (28 and 36 are common off-set traps.)

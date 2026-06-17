# State — Conv 296 (2026-06-17 ~16:15)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-14`, docs: `main`

## Summary

PALETTE-FDN colour foundation conv. Reframed (user) to a **provenance-scoped** sweep — only `@matt-source`/`@matt-inspired` surfaces (found 3,708 Tailwind-default colour utils across 198 files; Matt has 15 disjointed primitives, no numeric scales, no status hue). Decided depth (neutrals ~6 / accents ≤3), blue split (brand=purple-blue / info=americana), distinct success role, and **predetermined + Matt-harmonized status roles**. Wired the derived role scales into the 3-layer token cascade, rewrote style-guide §05 with the **map-or-flag sweep policy** + Conv-181→289 amendment, re-aligned `/courses` (8 swaps) and `/` SmartFeed onto the tokens (FeedActivityCard recolor **deferred** to its ReactionButton extraction), and tuned the error hue off Matt's neon carmine (`#FF0038`→`#E11D3F`). All gates + build + browser DOM-truth verified. Committed code `431ab1c1` + docs `47bb575`.

## Completed

- [x] PALETTE-FDN foundation: provenance-scoped sweep + catalogue, derived role scales wired (primitives + bridge), style-guide §05 + map-or-flag policy, error-hue tune
- [x] Decisions: provenance scope, neutrals~6/accents≤3, blue split, distinct success, predetermined status hues, FeedActivityCard deferral
- [x] `/courses` re-aligned (`bg-secondary-100`→`bg-neutral-100` ×8); `/` SmartFeed legacy block re-aligned
- [x] 4 codecheck gates + build green; browser DOM-truth + visual verify; error tune confirmed on swatch board

## Remaining

**PALETTE-FDN tail (foundation done — these are mechanical):**
- [ ] [PALETTE-FDN] (#31) Migration tail: FeedActivityCard 57-util recolor **at the ReactionButton/IconButton extraction** (full deterministic mapping in `plan/route-migration/tier2-primitive-ledger.md`); full per-route colour migration rides each RT-MIG sweep; retire legacy `--color-secondary-*`/`--color-primary-*` ramp once all consumers migrated. Optional further hex tuning (warning amber, info 300/500 separation) at user discretion.

**Route sweep (RTMIG-4) — RG-COURSES now unblocked by PALETTE-FDN:**
- [ ] [RG-COURSES] (#10, in_progress) 2/5 swept. Routes 3–5 (`/book`, `/precheckout`, `/success`) **UNBLOCKED** — PALETTE-FDN landed the status/neutral scale they were waiting on.
- [ ] [RTMIG-4] umbrella · [RG-ADMIN] · [RG-PUBPROF] [Opus] (blocked by ROLE-SEMANTICS) · [RG-AUTH] · [ROLE-SEMANTICS] [Opus] · [RG-PROFILE] · [RG-COMMS] · [RG-DISCOVER] · [RG-WORKSPACES] [Opus] ⛔client · [RG-MESSAGES]/[RG-NOTIFS]/[RG-SESSIONS]/[RG-MOD]/[RG-PUBLIC] (deferred)
- [ ] [OLD-PORTED-CLEANUP] · [PREFLIP-WT] · [E2E-MIG] · [E2E-GATE] (blocked by E2E-MIG) · [ICN-NS] · [TZ-AUDIT] [Opus] · [DOCGEN-SPEC] · [V217-WATCH] · [MEM-PRUNE] · [LAYOUT-SG] · [PROV-STAMP-GAPS] · [HOME-FIXES] · [COURSES-FIXES] (open: [FILTERS-RESPONSIVE], [TYPO-REVIEW]) · [M4-ZGUARD] · [RSTART-DIFFGATE]

## TodoWrite Items

- [ ] #1 [RTMIG-4] · #2 [RG-ADMIN] · #3 [RG-PUBPROF] [Opus] · #4 [RG-AUTH] · #5 [ROLE-SEMANTICS] [Opus] · #6 [OLD-PORTED-CLEANUP] · #7 [PREFLIP-WT] · #8 [RG-WORKSPACES] [Opus] · #9 [RG-PROFILE] · #10 [RG-COURSES] (in_progress, 2/5) · #11 [RG-COMMS] · #12 [RG-DISCOVER] · #13 [E2E-MIG] · #14 [E2E-GATE] · #15 [ICN-NS] · #16 [TZ-AUDIT] [Opus] · #17 [DOCGEN-SPEC] · #18 [V217-WATCH] · #19 [MEM-PRUNE] · #20 [LAYOUT-SG] · #21 [RG-MESSAGES] · #22 [RG-NOTIFS] · #23 [RG-SESSIONS] · #24 [RG-MOD] · #25 [RG-PUBLIC] · #26 [PROV-STAMP-GAPS] · #27 [HOME-FIXES] · #28 [COURSES-FIXES] · #29 [M4-ZGUARD] · #30 [RSTART-DIFFGATE] · #31 [PALETTE-FDN]

## Key Context

- **PALETTE-FDN foundation is LIVE.** Derived role scales in `src/styles/tokens-primitives.css` ("Derived tonal scales" section) → re-exported as `--color-{role}-{step}` in `tokens-tailwind-bridge.css`. Utilities: `bg-/text-/border-{neutral|brand|info|success|error|warning}-{step}` + `star`. Each step is `(M)` map (var to Matt primitive) or `mint`. **DRAFT values — tunable in one place.**
- **Sweep policy = map-or-flag** (style-guide §5.0): classify a colour before swapping (primitive-signature→adopt; role→map; recurring ≥3→tokenize app-wide once; no fit→flag). Carries the Conv-295 hard-hex precedent.
- **Status hues are CC-owned predetermined** (Conv-289 amendment to the Conv-181 only-Matt-variables rule). error tuned off carmine; `--carmine-red` primitive retained but not the live default.
- **FeedActivityCard recolor deferred** — mapping (indigo→brand, slate→neutral, blue→info, purple→brand, red→error, green→success) logged in `tier2-primitive-ledger.md` ReactionButton row. Do it WITH the extraction, not piecemeal.
- **Legacy-survivor grep gotcha:** match `(primary|secondary)-[0-9]+` numerically — Matt semantics `primary-default`/`primary-light` false-positive on `[class*=primary-]`.
- **Commits this conv:** code `431ab1c1` (8 files), docs `47bb575` (3 files). Code repo `jfg-dev-14`.
- **MEMORY.md ~84%** of SessionStart cap → **[MEM-PRUNE] #19** still live.
- Local dev server was left running on `:4322` (may need a manual stop).

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.

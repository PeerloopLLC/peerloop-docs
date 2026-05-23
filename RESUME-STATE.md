# State — Conv 181 (2026-05-23 ~17:55)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Conv 181 completed MMP-PH0 (Discovery) and MMP-PH1 (Token foundation) of the Matt Mini-Plan, plus closed [TSV], [MCP-DRIFT-180], and [NOTE-YELLOW]. Verified all 12 Matt-canonical color Variables + 12 semantics + Variable Mode wiring against Figma via `get_variable_defs` probes. Canonized all 18 Matt typography Variables (8 Body + 10 Header) into new `tokens-typography.css` with Tailwind 4 modifier-suffix utility classes. Established a new standing design-system principle (`feedback_tokenize_only_matt_variables.md`): token-ify only what Matt has tokenized as Figma Variables; hardcode what Matt has hardcoded (no `--note-yellow`-style speculative tokens going forward); scaffold what Matt hasn't categorized. Rewrote `reference_figma_mcp_behavior.md` with the two-tool-class distinction (selection-free vs selection-required) discovered during [TSV]. Note.tsx aligned to Matt's exact Figma spec with 6 visual drifts fixed (yellow hex, border, radius, padding, gap, shadow). All builds clean throughout.

## Completed

- [x] [MMP-PH0] Phase 0: Discovery
- [x] [MMP-PH1] [Opus] Phase 1: Token foundation
- [x] [TSV] Token Scaffolding Verification (closed with 12 colors + 18 typography Variables verified)
- [x] [MCP-DRIFT-180] reference_figma_mcp_behavior.md rewritten with two tool classes
- [x] [NOTE-YELLOW] closed under new tokenize-only-matt-variables principle

## Remaining

🔝 **LEAD next-conv task:** [MMP-PH2] [Opus] Phase 2: Icon registry — port 39 Matt icons from `.scratch/matt-main/components/icons/` to Matt-namespaced registry, finalize [CMP-ICN-REGISTRY] shape (deferred to PH4 empirical re-render test), implement Material icon strategy (decided = A incremental harvest). This is the biggest concrete remaining gap and unblocks PH3 + PH4 transitively.

**MMP mini-plan continuation:**
- [ ] [MMP-PH2] [Opus] Phase 2: Icon registry — finalize [CMP-ICN-REGISTRY] + port 39 SVGs + Material icon strategy
- [ ] [MMP-PH3] [Opus] Phase 3: Component primitives — per-primitive MCP queries + builds + substitution table [blocked by MMP-PH2]
- [ ] [MMP-PH4] [Opus] Phase 4: Re-render test — MCP-source Course In Feed (519:9096) + translate + visual diff [blocked by MMP-PH3]
- [ ] [MMP-PH5] Phase 5: Graduation — promote scratch artifacts to docs + 2nd-page validation (Content/Happy/Home 477:8502) [blocked by MMP-PH4]

**Decision tracking (folded into mini-plan):**
- [ ] [CMP-ICN-REGISTRY] [Opus] DEFERRED to MMP-PH4 — re-render empirically determines registry shape [blocked by MMP-PH4]
- [ ] [CMP-EXT-ICN] DECIDED = A (incremental Material icon harvest) — ongoing per-icon work during Phase 5

**Phase 3+ primitive builds (folds into MMP-PH3):**
- [ ] [MATT-EXEC-CMP-BTN] [Opus] Buttons primitive — informed by [MDS-BTN-3D] 3D architecture finding
- [ ] [MATT-EXEC-CMP-MNV] MainNav primitive
- [ ] [MATT-EXEC-CMP-SNV] SubNav primitive (Conv 180: Sub Nav appears twice on Components page — 502:12864 and 622:18616 "Sub Nav With Sub nav" — verify multi-level variant)
- [ ] [MATT-EXEC-CMP-ENT] [Opus] Entry primitive
- [ ] [MATT-EXEC-CMP-CHT] Chits/Chips primitive
- [ ] [MATT-EXEC-CMP-PNC] Pencils primitive
- [ ] [MATT-EXEC-CMP-BRN] Brand component verification
- [ ] [MATT-EXEC-CMP-ICN] Icon component port (folds into MMP-PH2)

**Docs / informational notes (folds into MMP-PH5):**
- [ ] [MDS-BTN-3D] Buttons 3D architecture docs note for matt-design-system.md
- [ ] [MDS-CASCADE-VALIDATED] Cascade validation docs note for matt-design-system.md
- [ ] [MFE-STALE] matt-figma-export folder is stale — folds into MMP-PH5 graduation
- [ ] [MCP-DOC] Document Figma MCP usage patterns — folds into MMP-PH5 graduation
- [ ] [MATT-RT-DOC] Triage /matt/* route docs

**Phase 5-7 carryforward:**
- [ ] [MATT-EXEC-FLAGS] Verify 4 route-shape assumptions before Phase 5
- [ ] [MATT-EXEC-PG2] [Opus] Phase 5: build 12 /matt/* routes (thin-shell page assembly)
- [ ] [MATT-EXEC-EXT] [Opus] Phase 6: extrapolation primitives (11 categories Matt didn't draw) — speculative alert tokens get verified-or-removed here under new tokenize-only-matt-variables principle
- [ ] [MATT-EXEC-GRD] Phase 7: doc graduation
- [ ] [MATT-COURSE-POLISH] Body polish on /matt/course/[slug]
- [ ] [MATT-CREATOR-TAB] /matt/course/[slug]/creator route
- [ ] [MATT-ICON-SWAP] Hero overlay inline-SVG → icon-system in Phase 6
- [ ] [RTB] [Opus] Role Tab Bar design-spec

**User-supplied later:**
- [ ] [MDR] Dev-Ready frames lookup (user-supplied, later)

**Conv 181 watch tasks (new):**
- [ ] [MCP-SEL-MISFIRE] Watch for repeat Figma MCP selection-state proxy misfires — if recurs in next 1-2 convs, extend `reference_figma_mcp_behavior.md` with diagnostic workflow
- [ ] [LH-VERIFY] Verify Figma `lineHeight:100` interpretation as ratio 1.0 against rendered Matt designs — load-bearing for MMP-PH4 visual diff

## TodoWrite Items

All 30 pending tasks above will be re-loaded into TodoWrite by `/r-start` Step 7. Codes preserved verbatim per `feedback_todowrite_mnemonic_codes.md`.

## Key Context

- **Conv 181 will be committed in Step 6** (this is pre-commit state). Code repo: 5 files modified/new in `src/styles/` + `src/components/matt/ui/`. Docs repo: RESUME-STATE.md will be re-written by this Step 5 immediately after deletion by /r-start. Memory changes: 1 new file + 1 rewritten + MEMORY.md 2 edits — synced to mirror in Step 5b before commit.

- **New tokens-typography.css** (`src/styles/tokens-typography.css`) defines all 18 Matt typography Variables. Bridge consumes them via `--text-{name}--<modifier>` syntax. Available utility classes: `text-body-default`, `text-body-default-medium`, `text-body-small`, `text-body-small-medium`, `text-body-medium`, `text-body-medium-bold`, `text-body-large`, `text-body-large-medium`, `text-h1`..`text-h5`, `text-h1-bold`..`text-h5-bold`.

- **Critical typography drift fix:** Header utilities (`text-h1`..`text-h5`) now carry weight Medium 500 (matching Matt's Variables). Before Conv 181 they defaulted to browser bold 700 for `<h1>` etc. All existing callsites of `text-h1`..`text-h5` in `/matt/*` pages now render with Matt's correct Medium weight.

- **Speculative tokens** (`--alert-light`, `--carmine-red`, `--Alert-Default`, `--Alert-Light` + bridge re-exports) preserved in dedicated "Speculative (Conv 172)" sub-blocks across primitives/semantic/bridge with provenance comments. Per `feedback_tokenize_only_matt_variables.md`: this is a precedent NOT to extend going forward. Phase 6 [MATT-EXEC-EXT] will verify-or-remove.

- **New standing principle** (`memory/feedback_tokenize_only_matt_variables.md`): token-ify only Matt's Variables; hardcode Matt's hardcoded hex; scaffold what Matt hasn't categorized. Probe via `get_variable_defs` (selection-required); presence/absence in the response IS the decision criterion. Honest-orphan principle. Applies to all future MMP-PH3+ primitive builds.

- **Figma MCP behavior** (`memory/reference_figma_mcp_behavior.md` rewritten): two tool classes — **selection-FREE** (`get_metadata`, `get_libraries`, `search_design_system`, `get_screenshot`) vs **selection-REQUIRED** (`get_design_context`, `get_variable_defs` — both need user-clicked layer in Figma desktop AND passed nodeId must match selection). Local-file Variables INVISIBLE to `get_libraries`/`search_design_system` (subscribed only). Batch-probe by selecting container frames. Plugin-rendered Color Guide labels (`"Primary/Primary"`) are NOT authoritative Variable names (actual: `Primary/Default`).

- **PH4 re-render target** picked Conv 181 [MMP-PH0]: `Course In Feed` (node 519:9096). Already probed Conv 180. Exercises Variable Mode (Course context) + Matt icons + Material icons + Entity Pill + Button Primary. Smaller surface than `Content/Happy/Home` (477:8502) for first PH4 pass.

- **Note.tsx** aligned to Matt's exact Figma spec via `get_design_context(652:8646)` probe. All 6 drifts fixed: yellow hex #FFF1B8 → #FFF6B8, added 1px #F1E9B0 border, radius 12px → 8px, padding 16px → 10px, gap 8px → 10px, shadow → exact custom value. All values hardcoded inline (no new tokens added) per new principle.

- **`leading-relaxed` precedent removed** from Note.tsx body text — `text-body-default` utility now carries lh:1 (matching Matt's Body/Body Default Variable spec). Watch for similar drift in other Matt primitives if they use `leading-*` Tailwind utilities — they may now conflict with the newly-canonized typography Variable line-heights. Worth a quick grep during MMP-PH3 builds.

- **MMP-PH2 starting point:** `.scratch/matt-main/components/icons/` contains 39 harvested SVGs from Conv 178 with uniform `viewBox="0 0 24 24"` and renamed per Matt's catalogue (3 semantic corrections noted in `_INDEX.md`: `newspaper→feed`, `mail→message`, `calendar_month→calendar`; mystery `Vector.svg → user-icon`; Property-1 Component variants flattened to Arrow/Level/Bookmark groups). Decisions [CMP-ICN-REGISTRY] (registry shape) is DEFERRED to PH4 empirical re-render; PH2 just ports the SVGs into a structure that's testable.

- **Conv 181 docs touched by docs agent:** `matt-design-system.md` (§5 Variable Collection Inventory updated, typography 6th collection added, Conv 181 reclassifications), `matt-pre-plan.md` (§5 Tailwind bridge typography ramp updated, §8 [TSV] marked done, §12 Document Lineage), `DEVELOPMENT-GUIDE.md` (new "Tokenize Only Matt's Variables" section). Will be committed in Step 6.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.

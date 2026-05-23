# State — Conv 180 (2026-05-23 ~15:45)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Conv 180 activated Figma Remote MCP (Dev seat on Peerloop org confirmed via whoami), then ran deep empirical investigation of MCP behavior against Matt's PeerLoop Pro Figma file (`UpDNMiIEO8y3J7ZHkm356b`). Key discoveries: MCP is link-based by design (user-as-navigator pattern), page listing returns only currently-scoped pages but ANY node-id is invisible-but-accessible, `get_design_context` returns inlined markup with `data-name` translation keys + CSS-var-with-baked-fallback colors, translation is mandatory regardless of naming convention. Material Design icons appear inline in Matt's Happy Path designs (3 confirmed: `stars_2`, `accessibility_new`, `how_to_reg`). Created 8-task 6-phase mini-plan (MMP-PH0..5 + MFP + MDR) with dependency graph for reproducing Matt's Figma renderings in our app. Captured 2 new memories + extended 1 (Figma MCP behavior reference, Matt-collaboration project context, EMP empirical-testing context). User supplied 9-page URL lookup → stored at `.scratch/matt-figma-pages.md`. Resolved 3 [Opus] decisions: registry shape deferred to MMP-PH4, variant promotion = flat icons (A), Material icons = incremental harvest (A).

## Completed

- [x] [MCP-VERIFY] (#1) — Figma MCP OAuth confirmed + ToolSearch verified tools surfacing
- [x] [MEM-DRIFT-ICN] (#27) — MEMORY.md icon-paths.ts line corrected (~35 → 10 entries verified Conv 180)
- [x] [MFP] (#35) — Page URL lookup stored at `.scratch/matt-figma-pages.md` (9 pages + Conv 180 frame probes cross-referenced)
- [x] [CMP-VAR-PROMOTE-DECISION] (#4) — DECIDED = A flat icons (9 variant entries: arrow-right/left/up/down + level-* + bookmark-default/filled); implementation lands in MMP-PH2
- [x] [CMP-EXT-ICN] (#28) — Strategy DECIDED = A incremental Material icon harvest as Phase 5 encounters them; per-icon implementation stays open under task #28

## Remaining

🔝 **LEAD next-conv task:** Three runnable-now starting points (no blockers): `[MMP-PH0]` Discovery, `[MMP-PH1]` Token foundation (now unblocked since MFP complete), `[MMP-PH2]` Icon registry. Recommended start: PH0 (cheap, ~15min discovery informs everything else).

**Mini-plan (6 phases + 2 lookups):**

- [ ] [MMP-PH0] Phase 0: Discovery — `ls /matt/*` routes, audit existing scaffolding, pick re-render test target
- [ ] [MMP-PH1] [Opus] Phase 1: Token foundation — Color Guide + Typography MCP probes + CSS variable + Variable Mode implementation
- [ ] [MMP-PH2] [Opus] Phase 2: Icon registry — finalize [CMP-ICN-REGISTRY] (deferred) + port 39 SVGs + Material icon strategy (folds in #2, #3, #4-decided, #22, #28-decided)
- [ ] [MMP-PH3] [Opus] Phase 3: Component primitives — per-primitive MCP queries + builds + substitution table (folds in #5-#11, #12, #24). Blocked by PH1+PH2
- [ ] [MMP-PH4] [Opus] Phase 4: Re-render test — MCP-source test page from PH0 + translate + visual diff (resolves deferred [CMP-ICN-REGISTRY]). Blocked by PH3
- [ ] [MMP-PH5] Phase 5: Graduation — promote scratch artifacts to docs + 2nd-page validation (folds in #14, #15, #23). Blocked by PH4

**Decision tracking:**

- [ ] [CMP-ICN-REGISTRY] (#3) [Opus] — DEFERRED to MMP-PH4 (blocked by #33); re-render empirically determines registry shape
- [ ] [CMP-EXT-ICN] (#28) — DECIDED = A; ongoing per-icon harvest during Phase 5

**Phase 5+ carryforward (not yet sequenced):**

- [ ] [MATT-EXEC-CMP-BTN] (#5) [Opus] — folds into MMP-PH3
- [ ] [MATT-EXEC-CMP-MNV] (#6) — folds into MMP-PH3
- [ ] [MATT-EXEC-CMP-SNV] (#7) — folds into MMP-PH3
- [ ] [MATT-EXEC-CMP-ENT] (#8) [Opus] — folds into MMP-PH3
- [ ] [MATT-EXEC-CMP-CHT] (#9) — folds into MMP-PH3
- [ ] [MATT-EXEC-CMP-PNC] (#10) — folds into MMP-PH3
- [ ] [MATT-EXEC-CMP-BRN] (#11) — folds into MMP-PH3
- [ ] [MATT-EXEC-CMP-ICN] (#2) — folds into MMP-PH2
- [ ] [MDS-BTN-3D] (#12) — informs MMP-PH3 Buttons build
- [ ] [MDS-CASCADE-VALIDATED] (#13) — docs note for matt-design-system.md
- [ ] [MFE-STALE] (#14) — folds into MMP-PH5 graduation
- [ ] [MCP-DOC] (#15) — folds into MMP-PH5 graduation
- [ ] [MATT-EXEC-FLAGS] (#16) — verify 4 route-shape assumptions before Phase 5
- [ ] [MATT-EXEC-PG2] (#17) [Opus] — Phase 5: 12 /matt/* routes
- [ ] [MATT-EXEC-EXT] (#18) [Opus] — Phase 6: extrapolation primitives
- [ ] [MATT-EXEC-GRD] (#19) — Phase 7: doc graduation
- [ ] [MATT-COURSE-POLISH] (#20) — body polish on /matt/course/[slug]
- [ ] [MATT-CREATOR-TAB] (#21) — /matt/course/[slug]/creator route
- [ ] [MATT-ICON-SWAP] (#22) — hero overlay inline-SVG → icon-system in Phase 6
- [ ] [MATT-RT-DOC] (#23) — triage /matt/* route docs
- [ ] [RTB] (#24) [Opus] — Role Tab Bar design-spec
- [ ] [TSV] (#25) — Token Scaffolding Verification (Color Guide node-id 1:16 captured)
- [ ] [NOTE-YELLOW] (#26) — add `--note-yellow` token
- [ ] [MDR] (#36) — Dev-Ready frames lookup (user-supplied, later)

## TodoWrite Items

All 33 pending tasks above will be re-loaded into TodoWrite by `/r-start` Step 7. Codes preserved verbatim per `feedback_todowrite_mnemonic_codes.md`.

## Key Context

- **Figma Remote MCP**: registered + authenticated + tool-verified. `claude mcp list` shows `figma: ✓ Connected`. ToolSearch needed to load tools mid-conv (they're not auto-loaded). Behavior reference at `memory/reference_figma_mcp_behavior.md` — link-based by design, `data-name` = translation key, asset URLs expire 7d, Variable Mode bakes into CSS-var fallback hex, search_design_system returns subscribed libs only.

- **Figma file**: `UpDNMiIEO8y3J7ZHkm356b` (PeerLoop Pro). 9 pages — full URL lookup at `.scratch/matt-figma-pages.md`. Key node-ids: Color Guide `1:16`, Typography `36:255`, Components `1:269`, α1 Happy Path `419:6162` (Greek alpha). Content page (`40:476`) is 🚫 OUT OF SCOPE (Matt's value-prop exploration). Documentation page (`3:17`) is Matt's working notes, not engineer-facing reference.

- **User seat**: Dev seat on Peerloop org confirmed. Sufficient for all reads we need. Brian's seat-assignment conversation is moot (already provisioned).

- **Matt collaboration style** (new memory `project_matt_collaboration_style.md`): Matt keeps ALL working material in Figma — specs, notes, decisions, value-prop. WE produce markdown specs from Figma probes. Don't ask Matt for external docs.

- **Variable Mode = CSS-var fallback baking**: `var(--background,#0777b6)` = Auto Primary mode; `var(--background,#e8f4df)` = Course mode (pastel-green). Same variable name, different fallback per parent context. MMP-PH1 needs to implement Variable Mode switching (likely `[data-variable-mode="course"]` selector pattern — to confirm).

- **Material icons inline**: 3 confirmed (`stars_2`, `accessibility_new`, `how_to_reg`); more likely in other Happy Path frames. Strategy A: harvest each via MCP `get_design_context` on the node when first encountered, add to registry.

- **Sub Nav appears twice on Components page**: `502:12864` and `622:18616` (the second is "Sub Nav With Sub nav"). Likely multi-level variant pair. Verify at MMP-PH3.

- **`--color` variable on Button Primary**: NOT in the Color Guide extracted catalog. Suggests per-component sub-token Variables exist beyond global ones. Verify at MMP-PH1 via `get_variable_defs` on individual component nodes.

- **Conv 180 memory creations** (in live, will sync to mirror at /r-end Step 5b — will appear in this conv's commit):
  - `reference_figma_mcp_behavior.md` (NEW, ~85 lines)
  - `project_matt_collaboration_style.md` (NEW)
  - `feedback_external_source_of_truth_first.md` (EXTENDED with [EMP] context)
  - `MEMORY.md` (3 line edits: icon-paths.ts count fix + 2 new entries)

- **Critical user feedback this conv**: "I don't want recommendations prematurely and you have been giving me recommendations after every question." Captured as `[EMP]` context in `feedback_external_source_of_truth_first.md`. Future-me: test before recommending; one tool call beats one rework cycle.

- **Carry-over for /r-start**: at Step 7, transfer all 33 above into TodoWrite preserving codes (per `feedback_todowrite_mnemonic_codes.md`).

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.

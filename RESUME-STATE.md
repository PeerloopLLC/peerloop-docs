# State — Conv 179 (2026-05-23 ~12:30)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Conv 179 was a bridge conv: walked through Figma MCP setup ([MCP-SETUP-WALK]), discovered (after user pointed at Figma's docs) that Figma recommends the **Remote MCP server** (`https://mcp.figma.com/mcp`) over the local Dev-Mode-MCP path I had drafted v1. Rewrote walkthrough as v2; registered the MCP via `claude mcp add --transport http figma https://mcp.figma.com/mcp` (entry now in `~/.claude.json` project-scoped to peerloop-docs, status "Needs authentication"). OAuth itself requires a fresh CC session — `/r-end` → exit → `/r-start` to bridge into Conv 180 where `/mcp` → figma → Authenticate completes setup. Also did major TodoWrite triage (54 → 28) per user request: 13 tasks already in PLAN deleted, 3 resolved/superseded deleted, 4 net-new items added to PLAN Conv 179 Items, 4 memory captures consolidated into one new memory file (`feedback_external_source_of_truth_first.md`) with 3 named contexts (vendor docs / Matt's catalogue / user-supplied source material). No code changes.

## Completed

- [x] Conv 179 start (/r-start) — counter 178→179, 53 tasks transferred + 1 added (=54)
- [x] Figma MCP walkthrough v1 drafted then rewritten as v2 (Remote-MCP path) at `.scratch/figma-mcp-setup.md`
- [x] `claude mcp add --transport http figma https://mcp.figma.com/mcp` executed; verified via `claude mcp list`
- [x] Diagnosed session-restart requirement for MCP activation (per-process MCP list)
- [x] TodoWrite triage: 54 → 28 (47% reduction)
- [x] Memory file `feedback_external_source_of_truth_first.md` authored (consolidates MFM + STOR + DTU + VDF)
- [x] MEMORY.md index updated with `## External Source-of-Truth` section
- [x] PLAN.md `## Conv 179 Items` section added with 4 entries (ASF, TDS-DRIFT, MEM-CAP, INV-PATH-FIX)

## Remaining

🔝 **LEAD next-conv task:** complete the Figma MCP OAuth flow → unblocks the entire `[MATT-EXEC-CMP-*]` dependency chain.

**MCP completion (3 immediate steps in Conv 180):**

- [ ] **[MCP-VERIFY]** Type `/mcp` in Conv 180 → select figma → Authenticate → browser Allow Access. Then `ToolSearch query: figma` to confirm tools surface as `mcp__figma__*`.

**Phase 4.5 [MATT-EXEC-CMP] — Component Import (8 subtasks, dependency-ordered):**

- [ ] **[MATT-EXEC-CMP-ICN]** Icons — harvest complete; pending registry-integration phase (blocked by CMP-ICN-REGISTRY decision)
- [ ] **[CMP-ICN-REGISTRY] [Opus]** Decide registry strategy: extend existing `icon-paths.ts` + `icons.tsx` vs matt-namespaced layer vs section-grouped. Blocks rest of Phase 4.5.
- [ ] **[CMP-VAR-PROMOTE-DECISION] [Opus]** Decide Arrow/Level/Bookmark — flat icons (`<Icon name="arrow-up" />`) vs React primitives (`<Arrow direction="up" />` / `<Level value={N} />` / `<Bookmark filled />`).
- [ ] **[MATT-EXEC-CMP-BTN] [Opus]** Buttons audit vs Matt's 3-orthogonal-dimension architecture (Color × State × Size; ~15 captures vs 120 flat-matrix)
- [ ] **[MATT-EXEC-CMP-MNV]** Main Nav primitive (blocked by ICN-REGISTRY)
- [ ] **[MATT-EXEC-CMP-SNV]** Sub Nav upgrade + mobile drawer (blocked by ICN-REGISTRY)
- [ ] **[MATT-EXEC-CMP-ENT] [Opus]** Entities multi-primitive + entity headers (TeacherHeader, StudentHeader, CreatorHeader)
- [ ] **[MATT-EXEC-CMP-CHT]** Chat primitive (blocked by ICN-REGISTRY)
- [ ] **[MATT-EXEC-CMP-PNC]** Post Anchors primitive (blocked by ICN-REGISTRY)
- [ ] **[MATT-EXEC-CMP-BRN]** Brand verify/build

**Doc updates triggered by Conv 178/179 findings:**

- [ ] **[MDS-BTN-3D]** Update matt-design-system.md §6 Buttons → 3-orthogonal-dimension architecture
- [ ] **[MDS-CASCADE-VALIDATED]** Add Conv 178 cascade-validation note to matt-design-system.md
- [ ] **[MFE-STALE]** Supersede `.scratch/matt-figma-extraction-today.md` (now stale post-Pro-account pivot)
- [ ] **[MCP-DOC]** Promote Figma MCP setup from `.scratch/` to canonical docs after Conv 180 verification. Novel-decision: which canonical location (devcomputers.md §MCP-Servers vs new docs/as-designed/mcp-servers.md). Present options before authoring.

**Phase 5-7 carryforward:**

- [ ] **[MATT-EXEC-FLAGS]** Verify 4 route-shape assumptions before Phase 5 starts
- [ ] **[MATT-EXEC-PG2] [Opus]** Phase 5: 12 /matt/* routes (blocked by [MATT-EXEC-CMP] parent)
- [ ] **[MATT-EXEC-EXT] [Opus]** Phase 6: extrapolation primitives
- [ ] **[MATT-EXEC-GRD]** Phase 7: doc graduation
- [ ] **[MATT-COURSE-POLISH]** Body section visual polish on /matt/course/[slug]
- [ ] **[MATT-CREATOR-TAB]** /matt/course/[slug]/creator route (Phase 5 sub-task)
- [ ] **[MATT-ICON-SWAP]** Hero overlay inline-SVG icons → icon-system in Phase 6
- [ ] **[MATT-RT-DOC]** Triage /matt/* route documentation in url-routing.md
- [ ] **[RTB] [Opus]** Design Role Tab Bar — finalize design-spec doc
- [ ] **[TSV]** Token Scaffolding Verification
- [ ] **[NOTE-YELLOW]** Add `--note-yellow` token

## TodoWrite Items

(28 visible — 25 pending below. Per `/r-start` Step 7 transfer rule, these get re-loaded into TodoWrite at next conv start.)

- [ ] #5: [MCP-VERIFY] Verify tools appear via ToolSearch after /r-start
- [ ] #6: [MATT-EXEC-CMP-ICN] Icons — harvest complete; pending registry-integration phase
- [ ] #7: [CMP-ICN-REGISTRY] Decide registry strategy: extend existing icon-paths.ts vs matt-namespace vs section-grouped [Opus]
- [ ] #8: [CMP-VAR-PROMOTE-DECISION] Decide Arrow/Level/Bookmark — flat icons or React primitives [Opus]
- [ ] #9: [MATT-EXEC-CMP-BTN] Buttons audit vs Matt's 3-orthogonal-dimension architecture [Opus]
- [ ] #10: [MATT-EXEC-CMP-MNV] Main Nav primitive
- [ ] #11: [MATT-EXEC-CMP-SNV] Sub Nav upgrade + mobile drawer
- [ ] #12: [MATT-EXEC-CMP-ENT] Entities multi-primitive + entity headers [Opus]
- [ ] #13: [MATT-EXEC-CMP-CHT] Chat primitive
- [ ] #14: [MATT-EXEC-CMP-PNC] Post Anchors primitive
- [ ] #15: [MATT-EXEC-CMP-BRN] Brand verify/build
- [ ] #16: [MDS-BTN-3D] Update matt-design-system.md §6 Buttons → 3-orthogonal-dimension architecture
- [ ] #17: [MDS-CASCADE-VALIDATED] Add Conv 178 cascade-validation note to matt-design-system.md
- [ ] #18: [MFE-STALE] Supersede `.scratch/matt-figma-extraction-today.md` when MCP online
- [ ] #23: [MATT-EXEC-FLAGS] Verify 4 route-shape assumptions before Phase 5 starts
- [ ] #24: [MATT-EXEC-PG2] Phase 5: 12 /matt/* routes [Opus]
- [ ] #25: [MATT-EXEC-EXT] Phase 6: extrapolation primitives [Opus]
- [ ] #26: [MATT-EXEC-GRD] Phase 7: doc graduation
- [ ] #27: [MATT-COURSE-POLISH] Body section visual polish on /matt/course/[slug]
- [ ] #28: [MATT-CREATOR-TAB] /matt/course/[slug]/creator route (Phase 5 sub-task)
- [ ] #29: [MATT-ICON-SWAP] Hero overlay inline-SVG icons → icon-system in Phase 6
- [ ] #32: [MATT-RT-DOC] Triage /matt/* route documentation in url-routing.md
- [ ] #33: [RTB] Design Role Tab Bar — finalize design-spec doc [Opus]
- [ ] #34: [TSV] Token Scaffolding Verification
- [ ] #35: [NOTE-YELLOW] Add `--note-yellow` token
- [ ] #55: [MCP-DOC] Promote Figma MCP setup from `.scratch/` to canonical docs after Conv 180 verification

## Key Context

- **MCP registry state:** `~/.claude.json` has `figma: https://mcp.figma.com/mcp (HTTP) - ! Needs authentication`, project-scoped to `/Users/livingroom/projects/peerloop-docs`. The registration **is durable** across CC restarts — only the OAuth handshake is pending. Conv 180's first move: `/mcp` → figma → Authenticate.

- **Per-machine MCP setup:** `.claude.json` is NOT git-synced. M4Pro will need its own one-time `claude mcp add --transport http figma https://mcp.figma.com/mcp` plus a separate OAuth handshake. The project-scoping tag means the entry won't activate when CC runs in other projects on the same machine.

- **Walkthrough doc v2** is at `~/projects/peerloop-docs/.scratch/figma-mcp-setup.md` (gitignored). Remote-MCP path is primary; local Dev-Mode MCP documented as fallback; community `figma-developer-mcp` as second-fallback. The doc has the per-machine setup instructions for M4Pro under "User side."

- **Brian outreach** sent earlier this conv asked for Dev seat assignment. Likely unnecessary for the remote path but harmless. If Brian replies before Conv 180, no action needed unless OAuth surfaces an "account not authorized for this file" error — in which case Dev seat may still be required.

- **Tailwind 4 + 3-orthogonal-dimension Button architecture (Conv 178 discovery, still needs landing):** Matt's button CSS uses `var(--Background)`/`var(--Border)` directly (validates [CASCADE-BROKEN] is implementation issue on our side). Architecture is Color × State × Size, NOT 6×3 flat matrix. Spec doc §6 needs rewriting before [MATT-EXEC-CMP-BTN] starts — that's [MDS-BTN-3D].

- **Branch state:** `jfg-dev-13-matt` holds all Matt design work (Convs 169-179). Conv 179 will commit PLAN.md + RESUME-STATE.md changes to the docs repo via /r-end Step 6. Code repo is clean — no /r-end commit for Peerloop this conv.

- **Diagnostic patterns for Conv 180:**
  - After `/r-start`, immediately `/mcp` → figma → Authenticate (don't wait — let OAuth run while loading TodoWrite state)
  - After Authenticate succeeds, `ToolSearch query: figma` to confirm tools surface
  - If OAuth fails or "no file access" — Brian's Dev seat may still be needed; fall back to local-MCP path in the walkthrough doc
  - First MCP-using task: [CMP-ICN-REGISTRY] decision — use MCP to re-read Matt's Figma to confirm icon structure before deciding registry approach

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.

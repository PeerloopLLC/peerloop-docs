# State — Conv 187 (2026-05-24 ~16:14)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Conv 187 closed MMP-PH4 (Course In Feed re-render, visually verified live in the Chrome bridge) and resolved a cluster of coupled tasks: the icon registry now reads per-icon viewBox (absorbed two 20×20 Material icons among 24×24 siblings), IconLabelChip gained a `tone="on-dark"` variant, and CourseHeader was re-validated to Matt's actual Default frame (`.astro`→`.tsx`, reversing the Conv 184/185 creator-trio to a plain white chip per the C178-REVAL/source-of-truth precedent). Also confirmed all Figma read tools are selection-free with an explicit nodeId (retiring the "selection-required" class), and resolved [MATT-EXEC-FLAGS] on the **addressability** axis (which screens need a jump-to URL) rather than page-count. All work committed (code `ead81ada` + `cea3def0`; docs through this /r-end). Next lead: MMP-PH5 / SUBNAV-ROUTING / PG2 — all now unblocked.

## Completed

- [x] [MMP-PH4] Course In Feed re-rendered + visually verified (live in Chrome bridge)
- [x] [CMP-ICN-REGISTRY] per-icon viewBox decision + implementation (MattIcon size-agnostic)
- [x] [STARS2-ICN] + [ACCESSIBILITY-ICN] harvested (native 20×20)
- [x] [DARK-HERO-VARS] IconLabelChip on-dark + applied to both heroes; Button variant confirmed unneeded
- [x] CourseHeader re-validated to Matt's Default frame (.astro→.tsx); matt-design-system.md doc-synced (docs agent)
- [x] [GVD-SELFREE-VERIFY] + [MCP-SEL-MISFIRE] — Figma read tools confirmed selection-free
- [x] [MATT-IDX-AUDIT] — 6 placeholder cards → Card
- [x] [MATT-EXEC-FLAGS] — resolved on addressability axis (table in lookup § Route Addressability)

## Remaining

**Lead candidates (Matt build-out — all now unblocked):**
- [ ] [MMP-PH5] Phase 5: Graduation — promote scratch + Content/Happy/Home re-render
- [ ] [MATT-SUBNAV-ROUTING] Wire SubNav to URL-aware active-state + create `/matt/course/[slug]/[...tab].astro` (mirror `discover/course/[slug]/[...tab].astro`; VALID_TABS: about/feed/modules/creator/teachers/reviews/resources)
- [ ] [MATT-EXEC-PG2] Phase 5: build remaining /matt/* routes (thin-shell page assembly; addressable routes per § Route Addressability)
- [ ] [MATT-EXEC-EXT] [Opus] Phase 6: extrapolation primitives (11 categories Matt didn't draw) + CourseInFeed Mobile variant (502:12958) + dark-hero IconLabelChip already done
- [ ] [MATT-EXEC-GRD] Phase 7: doc graduation
- [ ] [MMP-PH3] Parent block — substantially advanced (all 13 named primitives built; remaining = extrapolation)
- [ ] [RTB] [Opus] Role Tab Bar design-spec
- [ ] [CH-VARIANTS] Build CourseHeader Enrolled (597:6504) + Scheduled (685:13240) variants (only Default re-validated)
- [ ] [MATT-COURSE-POLISH] Body polish on /matt/course/[slug]
- [ ] [MATT-ICON-SWAP] Hero overlay inline-SVG → icon-system in Phase 6

**Asset harvest (additive, premature until their frames are deep-probed):**
- [ ] [HOWTOREG-ICN] Harvest how_to_reg Material icon (needed by MMP-PH5 Happy Path home)
- [ ] [VIDEO-COMMENT-ICN] Harvest video_comment Material icon (VideoClipAnchor has chat-icon substitute)
- [ ] [PLAY-CIRCLE-ICN] Harvest play_circle Material icon (VideoClipAnchor has inline-SVG substitute)

**Tooling + docs:**
- [ ] [ASSET-SWEEP-GATE] Add Figma-URL grep guard to /w-codecheck
- [ ] [FIGMA-MCP-DOC-HARVEST] Add "asset harvest discipline" section to docs/reference/figma-mcp.md
- [ ] [MFRD-GRADUATE] Graduate matt-frames-ready-for-dev.md from .scratch/ to docs/reference/
- [ ] [ESOT-STRUCTURE] Strengthen feedback_external_source_of_truth_first.md with "probe before claiming structure" rule
- [ ] [BROWSER-FALLBACK] Document Playwright chromium as fallback when Chrome MCP disconnects

**Permanent / watch tasks:**
- [ ] [MFRD-LOOKUP] Maintain Matt Ready-for-Dev frames drift lookup (permanent)
- [ ] [TXTBTN] Watch for "inline text-styled action button" pattern across Phase 5 routes
- [ ] [LH-VERIFY] Verify Figma lineHeight:100 interpretation as ratio 1.0 (load-bearing for visual diffs)
- [ ] [MEM-CAP-WATCH] Monitor MEMORY.md cap; prune by Conv 190 (was ~74% bytes at Conv 187 /r-start)

## TodoWrite Items

All 22 pending tasks above carry their mnemonic codes (preserved for cross-conv reference). `[Opus]` on: [MATT-EXEC-EXT], [RTB].

## Key Context

- **Route addressability resolved (Conv 187 [MATT-EXEC-FLAGS]):** full table in `.scratch/matt-frames-ready-for-dev.md` § Route Addressability. Addressable: Course tabs (`[...tab]`), Enroll Success (Stripe `success_url`, hard), Choose Teacher, Session (`/matt/session/[id]`, ONE state-driven route — phases derive from status), Home/Feed. Non-addressable (overlays/states): Enroll pre-checkout, Session Scheduled, Home/Course Completed. Implementation mirrors legacy (`course/[slug]/{[...tab],success,book}`, `session/[id]`). Decide addressability, defer page-count — see `memory/feedback_routing_addressability_first.md`.
- **Figma read tools are ALL selection-free with an explicit nodeId** (confirmed Conv 187; `reference_figma_mcp_behavior.md` updated). The drift-lookup workflow needs no designer present.
- **Matt's hero frames are master/instance:** Layout-page "Hero X" = component SET with variants; α1-Happy-Path "X" = instance. Course In Feed has a Mobile variant (502:12958, Phase 6); Course Header has Default/Enrolled/Scheduled (only Default built — see [CH-VARIANTS]).
- **CourseHeader is now `.tsx`** (was `.astro`) — caller import in `course/[slug]/index.astro` already updated.
- **Branch `jfg-dev-13-matt`** retained. All gates green this conv (tsc 0, astro check 0/0/0, build, lint).

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.

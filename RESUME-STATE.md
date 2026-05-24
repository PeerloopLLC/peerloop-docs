# State — Conv 183 (2026-05-23 ~21:35)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Conv 183 delivered two MMP-PH3 primitives end-to-end: **Button** (rewrite of Conv 175/176 scaffold to strict-B `property1` 5-value enum mirroring Matt's Figma exactly — 5 variants empirically extracted) and **MainNav** (3 net-new components — MainNav.tsx, NavItem.tsx, NavSubItem.tsx — plus Sidebar.tsx refactor with route-driven Main pill, props-driven data model, 70px collapse retained as Peerloop extension). All baselines green: tsc exit 0, astro check 1236 files 0/0/0, SSR HTML verified. Conv 178's "3-orthogonal" Button architecture claim formally retracted in matt-design-system.md §5; new MainNav subsection added. New memory rule landed: Figma is read-only (never call write-shaped MCP tools — `feedback_never_modify_figma.md`).

## Completed

- [x] [MATT-EXEC-CMP-BTN] Buttons primitive — strict-B `property1` 5-value enum + 6 Color variants
- [x] [MATT-EXEC-CMP-MNV] MainNav primitive — 3 new components + Sidebar.tsx refactor
- [x] matt-design-system.md §5 Button rewritten with Conv 183 findings
- [x] matt-design-system.md new MainNav subsection added
- [x] .scratch/matt-figma-pages.md enriched with Conv 183 probe data
- [x] feedback_never_modify_figma.md memory saved + indexed
- [x] Task #22 [MCP-SEL-MISFIRE] updated with positive observation

## Remaining

🔝 **LEAD next-conv task:** [MMP-PH3] continuation — next primitive build. Per task ordering, **[MATT-EXEC-CMP-SNV] SubNav** is the natural next step (parallels the MainNav build pattern; the multi-level-variant verification 502:12864 vs 622:18616 is a small architectural decision that benefits from the same MCP-probe-then-build cadence used Conv 183). Alternative: **[MATT-EXEC-CMP-ENT] Entry** unblocks MMP-PH4 Course In Feed re-render sooner.

**MMP mini-plan continuation:**
- [ ] [MMP-PH3] [Opus] Phase 3: Component primitives — per-primitive MCP queries + builds + substitution table (in_progress; 2 of 7 primitives complete after Conv 183)
- [ ] [MMP-PH4] [Opus] Phase 4: Re-render test — Course In Feed (519:9096) + translate + visual diff [blocked by MMP-PH3]
- [ ] [MMP-PH5] Phase 5: Graduation — promote scratch + Content/Happy/Home re-render [blocked by MMP-PH4]

**Decision tracking (folded into mini-plan):**
- [ ] [CMP-ICN-REGISTRY] [Opus] Registry shape deferred to MMP-PH4 empirical re-render [blocked by MMP-PH4]
- [ ] [CMP-EXT-ICN] Incremental Material harvest (decided = A), ongoing during Phase 5

**Phase 3 remaining primitive builds (fold into MMP-PH3):**
- [ ] [MATT-EXEC-CMP-SNV] [Opus] SubNav primitive — verify multi-level variant (502:12864 vs 622:18616)
- [ ] [MATT-EXEC-CMP-ENT] [Opus] Entry primitive — Entity-cascade (4 modes Course/Student/Creator/Default)
- [ ] [MATT-EXEC-CMP-CHT] Chits/Chips primitive
- [ ] [MATT-EXEC-CMP-PNC] Pencils primitive
- [ ] [MATT-EXEC-CMP-BRN] Brand component verification

**Phase 5-7 carryforward:**
- [ ] [MATT-EXEC-FLAGS] Verify 4 route-shape assumptions before Phase 5
- [ ] [MATT-EXEC-PG2] [Opus] Phase 5: build 11 remaining /matt/* routes (thin-shell page assembly)
- [ ] [MATT-EXEC-EXT] [Opus] Phase 6: extrapolation primitives (11 categories Matt didn't draw); speculative Conv 172 alert tokens get verified-or-removed here under tokenize-only-matt-variables principle; also hover-color-extrapolation work for Button non-Primary variants
- [ ] [MATT-EXEC-GRD] Phase 7: doc graduation
- [ ] [MATT-COURSE-POLISH] Body polish on /matt/course/[slug]
- [ ] [MATT-CREATOR-TAB] /matt/course/[slug]/creator route
- [ ] [MATT-ICON-SWAP] Hero overlay inline-SVG → icon-system in Phase 6
- [ ] [RTB] [Opus] Role Tab Bar design-spec

**User-supplied later:**
- [ ] [MDR] Dev-Ready frames lookup (user-supplied, later)

**Watch tasks (carrying forward):**
- [ ] [MCP-SEL-MISFIRE] Watch for repeat Figma MCP selection-state proxy misfires (Conv 183 positive observation: `get_design_context` succeeded WITHOUT pre-selection in 8 calls — contradicts Conv 180 memory; need more data points before updating)
- [ ] [LH-VERIFY] Verify Figma `lineHeight:100` interpretation as ratio 1.0 against rendered Matt designs (load-bearing for MMP-PH4 visual diff)

**Conv 183 new follow-ups:**
- [ ] [C178-REVAL] [Opus] Re-validate Conv 178 "reconnaissance" claims in matt-design-system.md against current MCP probes — Conv 178 had 2 documented factual errors (3-orthogonal Button claim; 5-size-cells framing) that survived to Conv 183 unprobed. Recommend running this re-validation during Phase 6 [MATT-EXEC-EXT].
- [ ] [MEM-CAP-WATCH] Monitor MEMORY.md cap; prune by Conv 190 if growth continues — currently 62% lines / 70% bytes, estimated post-Conv-183 ~63% / 71%.

## TodoWrite Items

All 23 pending tasks above will be re-loaded into TodoWrite by `/r-start` Step 7. Codes preserved verbatim per `feedback_todowrite_mnemonic_codes.md`.

## Key Context

- **Conv 183 will be committed in Step 6 of this /r-end.** Docs repo at this point: 1 modified (matt-design-system.md) + 1 deleted (RESUME-STATE.md from /r-start) + 3 new (Extract.md, Learnings.md, Decisions.md) + 2 new scratch PNGs + 1 modified scratch (matt-figma-pages.md) + 1 new memory file + 1 modified MEMORY.md + this RESUME-STATE.md + PLAN.md update from update-plan agent + DECISIONS.md / DOC-DECISIONS.md / TIMELINE.md updates from learn-decide agent. Code repo: 3 modified (Sidebar.tsx, Button.tsx, _SocialPostDemo.tsx) + 3 new (MainNav.tsx, NavItem.tsx, NavSubItem.tsx). Memory mirror sync runs in Step 5b before commit.

- **Button.tsx API change (BREAKING from Conv 175/176):** `size` prop renamed to `property1` with new enum values `'Default' | 'Hover' | 'Large' | 'Small' | 'SmallHover'`. Old values `'sm' | 'md' | 'lg'` no longer accepted. Only one caller existed (`_SocialPostDemo.tsx`) — migrated to `property1="Small"`. Future callers must use the new enum. Hover/SmallHover variants apply Matt's hardcoded Primary-blue gradient via inline style — these are caller-picked states NOT CSS :hover.

- **MainNav active-detection rule:** an item enters `Main` state if currentPath matches it OR any child AND it has children. `Selected` if matches but no children. Children render `Selected` if currentPath matches the child, else `Default`. The pill auto-positions based on route — at most ONE Main pill visible at a time. NOT click-to-expand.

- **MainNav data shape:**
  ```tsx
  import MainNav, { type NavItemData } from '@components/matt/MainNav';
  const NAV: NavItemData[] = [
    { label, href, icon, subText?, children?: NavSubItemData[] }
  ];
  <MainNav items={NAV} currentPath={pathname} />
  ```

- **Sidebar shell (Peerloop extension) preserved:** 220 ↔ 70 collapse toggle + brand mark + Earnings/Notifications/Profile auxiliary section. When collapsed (70px), renders separate icon-only nav — NOT via MainNav (which assumes 220px). NAV data array lives inside Sidebar.tsx as a module constant (props-driven principle satisfied — MainNav itself is reusable; only the current Sidebar consumer hardcodes its NAV).

- **Hover gap deferred to Phase 6 [MATT-EXEC-EXT]:** Matt's Button Hover + SmallHover variants only have proper styling for Primary Variable Mode. Non-Primary + Hover combos render Primary-darkened gradient regardless of variant. Per strict-B, mirror literally; proper variant-aware extrapolation is Phase 6 work.

- **Figma is READ-ONLY:** new standing rule per `feedback_never_modify_figma.md` (Conv 183 explicit user directive). Never call `mcp__figma__use_figma` / `create_new_file` / `upload_assets` / `add_code_connect_map` / `send_code_connect_mappings` or any other write-shaped Figma MCP tool. Only read tools permitted.

- **Conv 178 factual errors flagged for re-validation:** Conv 178's "3-orthogonal" Button framing and "5 size cells side-by-side" both were inferential leaps. Other Conv 178 claims in matt-design-system.md should be re-probed empirically before being treated as canonical. Tracked as [C178-REVAL].

- **`get_design_context` selection-required claim weakening:** Conv 183 ran 8 successful `get_design_context` calls without pre-selection in Figma desktop. Memory `reference_figma_mcp_behavior.md` claims it's selection-REQUIRED. Watching via [MCP-SEL-MISFIRE]; if reproducibly works without selection in Conv 184+, the memory should be relaxed.

- **MEMORY.md cap at 70% bytes** at conv start. Conv 183 added 1 line (the feedback_never_modify_figma.md index entry). Estimated 71% bytes post-conv. Under 80% cap. Monitor via [MEM-CAP-WATCH].

- **`text-h2` token bridge utility** exists (`tokens-tailwind-bridge.css:135`) — Inter Medium 24px, lh 100%, ls 0. Used by Button Large variant + available for other primitives needing Header 2.

- **Doc graduation pattern (Conv 182 + Conv 183 reinforcement):** When a Matt primitive lands, add a formal `### <Component> (extracted Conv NNN)` subsection in `matt-design-system.md` with: Figma node IDs, Property 1 variant table, extracted CSS, React component shape, file paths. Scratch + memory are staging — docs/as-designed/ is canonical.

- **ASCII baseline + AskUserQuestion previews** — new collaboration pattern established Conv 183. When text descriptions of UX/architecture are insufficient, render Matt's Figma reference as ASCII (saved in scratch), then use AskUserQuestion with `preview` fields showing each option as side-by-side ASCII. User picks visually. Applied successfully to D1/D2/D3 MainNav decisions.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.

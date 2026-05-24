# State — Conv 185 (2026-05-24 ~08:48)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Conv 185 cleared all 5 Q1/Q2 carry-forward audit items from Conv 184: built Brand primitive (Logo + LogoMark, 4 SVGs), built ChatBubble primitive (2 variants with mirrored tail SVGs), strict-B rewrites of Module + ToDoItem (dropped `entity` over-engineering, fixed font weights + checkbox geometry to match Matt's spec exactly), refactored CourseHeader's creator section to use UserIcon + EntityPill + EntityLink trio in entity-creator cascade, and built all 8 remaining Post Anchor row primitives (Creator/Certification/Module/Resource/Review/StudentTeacher/VideoClip/Milestone). New finding documented in memory: Figma MCP asset URLs return SVG (not PNG) for vector sources. Sidebar now uses Matt's Logo Medium / LogoMark Default. All 13 of Matt's named primitives now built — MMP-PH4 (Course In Feed re-render visual diff) is empirically buildable as the next conv's LEAD.

## Completed

- [x] [MATT-EXEC-CMP-BRN] Brand primitive (Logo + LogoMark, 4 SVGs, Sidebar wired, /matt/ showcase + visual ✓)
- [x] [CMP-CHAT] Chat Bubble primitive (2 tail SVGs, showcase + visual ✓)
- [x] [C178-REVAL] Re-validate Module/ToDoItem/SectionTitle/SocialPost — Module + ToDoItem strict-B rewrites; SectionTitle name-collision documented (Matt's = Figma-internal dev-status banner, our code's = generic heading); SocialPost composition was validated Conv 184
- [x] [REFACTOR-COURSEHEADER] CourseHeader creator section uses UserIcon + EntityPill + EntityLink in entity-creator cascade; caller passes `data.creator.handle` + `data.creator.avatar_url`
- [x] [CMP-ANCH-REST] 8 remaining anchor row primitives — all in /matt/ showcase + visual ✓

## Remaining

🔝 **LEAD next-conv task:** [MMP-PH4] [Opus] Phase 4 — re-render Course In Feed (`519:9096`) using the now-complete primitive set + visual diff against Matt's Figma. With CourseAnchor + 8 anchor rows + Module + ToDoItem + ChatBubble + Brand + all Conv 184 primitives in place, every named primitive from Matt's Components page is built. Course In Feed re-render is empirically buildable.

**MMP mini-plan continuation:**
- [ ] [MMP-PH3] Parent block — substantially advanced this conv (all 13 named primitives built); remaining items are dark-hero variants + missing icons
- [ ] [MMP-PH4] [Opus] Phase 4: Re-render Course In Feed (519:9096) + translate + visual diff ← LEAD
- [ ] [MMP-PH5] Phase 5: Graduation — promote scratch + Content/Happy/Home re-render

**New deferred items from Conv 185 audit:**
- [ ] [DARK-HERO-VARS] [Opus] Build dark-hero variants of IconLabelChip + Button so CourseHeader rating/level/CTA can use design-system primitives (deferred from REFACTOR-COURSEHEADER — multi-dimension design balancing Matt's light-bg specs vs dark-hero accessibility)
- [ ] [VIDEO-COMMENT-ICN] Harvest `video_comment` Material icon (VideoClipAnchor uses `chat` as substitute)
- [ ] [PLAY-CIRCLE-ICN] Harvest `play_circle` Material icon (VideoClipAnchor uses inline SVG placeholder)
- [ ] [ESOT-STRUCTURE] Strengthen `feedback_external_source_of_truth_first.md` with "probe before claiming structure" rule (Conv 185 [C178-REVAL] surfaced 3 separate Conv 178 misframings — Module, ToDoItem, SectionTitle name collision)
- [ ] [BROWSER-FALLBACK] Document Playwright chromium as fallback path when Chrome MCP extension disconnects (Conv 185 [MATT-EXEC-CMP-BRN] hit this; ~250MB persistent in ~/Library/Caches/ms-playwright/)

**Decision tracking (folded into mini-plan):**
- [ ] [CMP-ICN-REGISTRY] [Opus] Registry shape deferred to MMP-PH4 empirical re-render
- [ ] [CMP-EXT-ICN] Incremental Material harvest (decided = A), ongoing during Phase 5; folds VIDEO-COMMENT-ICN + PLAY-CIRCLE-ICN

**Phase 5-7 carryforward:**
- [ ] [MATT-EXEC-FLAGS] Verify 4 route-shape assumptions before Phase 5
- [ ] [MATT-EXEC-PG2] Phase 5: build 11 remaining /matt/* routes (thin-shell page assembly)
- [ ] [MATT-EXEC-EXT] [Opus] Phase 6: extrapolation primitives (11 categories Matt didn't draw); folds [DARK-HERO-VARS] dark-mode work; speculative Conv 172 alert tokens verified-or-removed here; hover-color-extrapolation for Button non-Primary variants
- [ ] [MATT-EXEC-GRD] Phase 7: doc graduation
- [ ] [MATT-COURSE-POLISH] Body polish on /matt/course/[slug]
- [ ] [MATT-CREATOR-TAB] /matt/course/[slug]/creator route
- [ ] [MATT-ICON-SWAP] Hero overlay inline-SVG → icon-system in Phase 6
- [ ] [RTB] [Opus] Role Tab Bar design-spec

**User-supplied later:**
- [ ] [MDR] Dev-Ready frames lookup (user-supplied, later)

**Watch tasks (carrying forward):**
- [ ] [MCP-SEL-MISFIRE] Watch for repeat Figma MCP selection-state proxy misfires. Conv 185 added many more data points of selection-free probing succeeding — reference_figma_mcp_behavior.md should be revisited soon
- [ ] [LH-VERIFY] Verify Figma `lineHeight:100` interpretation as ratio 1.0 against rendered Matt designs (load-bearing for MMP-PH4 visual diff)
- [ ] [MEM-CAP-WATCH] Monitor MEMORY.md cap; prune by Conv 190 if growth continues — should be ~74% bytes post-Conv-185

## TodoWrite Items

All pending tasks above are persisted here and will be re-loaded into TodoWrite by `/r-start` Step 7. Codes preserved verbatim per `feedback_todowrite_mnemonic_codes.md`. `[Opus]` suffixes preserved (6 tasks: #2 MMP-PH4, #9 CMP-ICN-REGISTRY, #13 MATT-EXEC-EXT, #18 RTB, #23 DARK-HERO-VARS, plus the inherited C178-REVAL tag is now closed).

## Key Context

- **Conv 185 will be committed in Step 6 of this /r-end.** Docs repo: 1 deleted (RESUME-STATE.md from /r-start; this file replaces it), plus untracked Extract + Learnings + Decisions + memory mirror updates + matt-design-system.md edits + PLAN.md + DECISIONS.md + DOC-DECISIONS.md + TIMELINE.md changes. Code repo: 6 modified + 17 untracked (Brand × 2 .tsx + 4 SVG, Chat × 1 .tsx + 2 SVG, 8 anchor .tsx). Memory mirror sync runs in Step 5b before commit.

- **All 13 of Matt's named Components are now built:** Icons (39 SVGs), Brand (Logo + LogoMark), Entities (UserIcon + EntityPill + EntityLink + IconLabelChip), Button Primary, Main Nav (MainNav + NavItem + NavSubItem), Sub Nav (SubNav + SubNavItem), Social Post (SocialPost + AnalyticCount), Post Anchors (9 anchor row types), Chat (ChatBubble), To Do Item, Note, Module, Section Title (name-collision, our code's is a generic heading). MMP-PH4 visual diff is the empirical validation.

- **New standing finding:** Figma MCP `get_design_context` asset URLs (`/api/mcp/asset/<uuid>`) return **SVG content** for vector sources, not raster PNG. Documented in `reference_figma_mcp_behavior.md` + MEMORY.md index line. Pattern: `curl -sSL -o file.svg "https://..."` then `perl -pi -e 's/fill="var\(--fill-0, #[0-9A-Fa-f]+\)"/fill="currentColor"/g'` for Tailwind theming.

- **Conv 178 factual-error pattern fully validated:** [C178-REVAL] found 3 separate Conv 178 misframings (Module + ToDoItem entity over-engineering + SectionTitle name collision). All from visual-inspection inferences without `get_design_context`. New task [ESOT-STRUCTURE] queued to strengthen `feedback_external_source_of_truth_first.md`.

- **Dark-hero vs light-bg primitive split** is a real architectural constraint. CourseHeader's image hero requires light-on-dark text; IconLabelChip and Button as built today only work on light backgrounds. CourseHeader rating/level/CTA stay inline pending [DARK-HERO-VARS]. This pattern will recur whenever Matt's primitives are used in dark contexts.

- **ChatBubble drifts from Matt's 159px canvas placeholder** to `inline-flex max-w-[280px]` — UX-driven decision documented in component docstring. Allows real chat messages to size to content.

- **Playwright chromium installed (~250MB persistent)** — Chrome MCP extension was disconnected mid-conv; `osascript`+`screencapture` kept capturing desktop wallpaper. Playwright proved reliable for headless screenshots; cached at `~/Library/Caches/ms-playwright/`. Task [BROWSER-FALLBACK] queued to document for future convs.

- **8 design-artifact screenshots retained in `.scratch/screenshots/`** — Conv 185 verification artifacts for Brand, Chat, Module/ToDoItem refactor, CourseHeader, 8 anchors. Per `.scratch/README.md` convention, .scratch is gitignored persistent workspace.

- **`<instance>` translation key principle** (per `feedback_reuse_existing_components.md`) drove all 8 anchor row builds and CourseHeader refactor. Each Figma `<instance name="...">` mapped to an existing primitive import — Brand's wordmark, Chat's tail, every anchor's EntityPill/IconLabelChip/Button. Zero inline duplicates.

- **MEMORY.md cap status** estimated ~74% bytes after Conv 185 sync (1 memory file augmented — `reference_figma_mcp_behavior.md` got the new SVG-asset paragraph). Still under 80% cap. Monitor via [MEM-CAP-WATCH].

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.

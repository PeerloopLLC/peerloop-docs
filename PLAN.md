# PLAN.md

This document tracks **current and pending work**. Completed blocks are in COMPLETED_PLAN.md.

---

## Block Sequence

### ACTIVE

| Block | Name | Status |
|-------|------|--------|
| MATT-DESIGN-PUSH | Matt Design System — intake, spec doc, token extraction, scaffolding, pre-plan, execution | 🔥 IN PROGRESS (Convs 169-183: intake → curated build set → spec doc → Figma Variable extraction + scaffolding policy → pre-plan + 8 decisions Conv 173 → Conv 174 Phases 1-2 complete → Conv 175 Phases 2-viz / 3 / 4-scope-A complete → Conv 176 Phase 4 scope B (5 primitives + stateless discipline as workaround for misdiagnosed SSR crash) → Conv 177 [NPM-UP] + [DSSR-SCOPE] resolved (Astro stack upgrade + Vite cold-start dep-discovery fix; stateless discipline retired) → **Conv 178: scoped Phase 4.5 [MATT-EXEC-CMP] (component import for 7 remaining items from Matt's Figma Components page + Brand verification) between Phase 4 and Phase 5 — keeps Phase 5 as pure thin-shell assembly. 8 dependency-ordered subtasks added to PLAN + TodoWrite (CMP-ICN → CMP-BTN → CMP-MNV → CMP-SNV → CMP-ENT → CMP-CHT → CMP-PNC → CMP-BRN). Mid-conv discovered user's Figma Dev Mode trial ends today — pivoted to "harvest while access is available" mode. **[MATT-EXEC-CMP-ICN] harvest phase COMPLETE:** 39 icons extracted from Figma into `.scratch/matt-main/components/icons/` with uniform `viewBox="0 0 24 24"` (Include-bounding-box ✅ setting was load-bearing); 19 renames executed with 3 semantic corrections from Matt's catalogue (newspaper→feed, mail→message, calendar→from calendar_month, etc.); Property-1 Component variants flattened to Arrow/Level/Bookmark groups; mystery Vector.svg labelled `user-icon`; `_INDEX.md` written documenting catalogue-label-is-authority rule + Primary (8) + Secondary (31) sections. Buttons reconnaissance discovered 3-orthogonal-dimension Figma architecture (Color via Variable Mode × State via Property 1 × Size via 5 frame cells) — spec doc §6 flat-matrix framing needs update next conv. [CASCADE-BROKEN] validated as implementation issue (Matt's button CSS uses `var(--Background)`/`var(--Border)`). **Mid-conv pivot:** project moved to client's Pro Figma account — MCP server setup required between convs; ended conv to set up MCP off-conv and /r-start fresh.** **Conv 179: MCP setup lead-task advanced — registered Figma remote MCP server + walkthrough doc v2 + OAuth deferred to Conv 180.** Pivoted mid-conv from local-MCP (Figma desktop + Dev seat + manual settings.json) to Figma's documented *remote* MCP (`https://mcp.figma.com/mcp` + OAuth, no Dev seat required) after user surfaced Figma's official docs. Executed `claude mcp add --transport http figma https://mcp.figma.com/mcp` — registered in `~/.claude.json` project-scoped to peerloop-docs; `claude mcp list` shows status "Needs authentication". OAuth flow (`/mcp` → figma → Authenticate → browser Allow) requires fresh CC session since MCP server list loads once at session start. TodoWrite triaged 54 → 28 (47% reduction): non-Matt/non-MCP tasks moved to PLAN.md respective blocks; consolidated 4 "save memory" tasks (MFM + STOR + DTU + VDF) into 1 file `feedback_external_source_of_truth_first.md` with 3 named contexts. 4 new deferred Conv 179 items spawned: [ASF] / [TDS-DRIFT] / [MEM-CAP] / [INV-PATH-FIX]. **Conv 180: Figma MCP fully activated + Phase 4.5 reframed as 6-phase MMP mini-plan.** [MCP-VERIFY] complete — OAuth done pre-/r-start (`figma: ✓ Connected`); 10+ `mcp__figma__*` tools surfaced; user has Dev seat on Peerloop org pro tier. **Critical learning Conv 180:** Figma Remote MCP is link-based by design — `get_metadata(fileKey)` returns only currently-scoped pages (2 of 9 in this conv); ANY node-id can be queried directly via user-supplied URLs (invisible-but-accessible). Pivoted from "enumerate the file" to user-supplied URL lookup. [MFP] complete — `.scratch/matt-figma-pages.md` stores 9 page URLs + probe history; Content page marked OUT OF SCOPE per user. **Translation is mandatory** — MCP renders icons as `<img>` with expiring asset URLs, components inlined as raw markup; `data-name` IS the translation key. Original Phase 4.5 subtasks (CMP-BTN..CMP-BRN) reframed as 6-phase MMP-PH0..5 mini-plan with MCP-native extraction before bulk work. **2 decisions resolved Conv 180:** [CMP-ICN-REGISTRY] = D (deferred to MMP-PH4 empirical re-render test); [CMP-VAR-PROMOTE-DECISION] = A (flat icons, 9 variant entries); [CMP-EXT-ICN] = A (incremental Material harvest). 3 new memory files: `reference_figma_mcp_behavior.md`, `project_matt_collaboration_style.md`, [EMP] context added to `feedback_external_source_of_truth_first.md`. [MEM-DRIFT-ICN] complete — MEMORY.md corrected `~35 entries` → `10 entries verified`. **Conv 181: MMP-PH0 Discovery + MMP-PH1 Token foundation both COMPLETE.** [MMP-PH0] discovery confirmed PH1 ~80% already in place + PH3 ~80% already in place + PH2 0% done (39 Matt icons still in `.scratch/`); Course In Feed (519:9096) picked as MMP-PH4 re-render target. [MMP-PH1] / [TSV] full token canonization via `get_variable_defs` direct probes — 12 colors + 18 typography Variables verified (8 Body + 10 Header). New file `src/styles/tokens-typography.css` (124 lines, two leading regimes); bridge typography section rewritten with all 18 Tailwind 4 `--text-{name}--<modifier>` utility classes. False naming-drift alarm corrected — Variable is `Primary/Default` not `Primary/Primary` (plugin-rendered Color Guide label was the artifact). 6 speculative Conv 172 alert tokens isolated to dedicated "Speculative (Conv 172)" sub-blocks across 3 files (kept + flagged, not removed). [NOTE-YELLOW] resolved by hardcoding inline NOT new token (probe revealed Matt's `#FFF6B8` is hardcoded hex, not a Variable) — Note.tsx all 7 drifts fixed (background hex, border, radius/padding/gap/shadow, leading). **New standing principle:** `feedback_tokenize_only_matt_variables.md` — token-ify what Matt has tokenized; hardcode what Matt has hardcoded; honest-orphan rule (Conv 172's speculative pattern preserved but not extended). [MCP-DRIFT-180] memory file rewrite — `reference_figma_mcp_behavior.md` 56→75 lines with two tool classes (selection-free vs selection-required), `get_variable_defs` return-shape, invisible-local-Variables caveat, efficient batch-probing pattern. Baseline gates clean (tsc + astro check 1232 files 0/0/0). Next major step (lead): MMP-PH2 Icon registry (port 39 SVGs + Material icon strategy). → **Conv 182: MMP-PH2 Icon registry COMPLETE + doc graduations.** 39 Matt SVGs ported from `.scratch/matt-main/components/icons/` → `src/components/matt/icons/svg/` (chosen Option B — SVG-files-as-source-of-truth via Vite `?raw` glob, NOT path-extracted TS registry); `MattIcon.astro` consumer with `import.meta.glob<string>('./svg/*.svg', { query: '?raw', import: 'default', eager: true })` + outer-`<svg>` strip regex; fill normalization `#414141` → `currentColor` (38 bulk via perl-pi + 1 outlier `info.svg` `#1C1B1F` MD3 on-surface caught by distinct-fill audit). Build clean 6.29s; astro check 1233 files 0/0/0. Folded into MMP-PH2 satisfies [MATT-EXEC-CMP-ICN] (code-integration phase) + collapses original Phase 4.5 subtask. **5 doc-graduation tasks closed Conv 182:** [MEM-IP-DRIFT] (MEMORY.md icon-paths entry count corrected 10 → 39 with breakdown); [MFE-STALE] (`.scratch/matt-figma-extraction-today.md` deleted); [MDS-CASCADE-VALIDATED] (`matt-design-system.md` §5 Entity caveat updated with Conv 178 root-cause validation — `[CASCADE-BROKEN]` closed); [MDS-BTN-3D] (`matt-design-system.md` §5 Button updated with 3-orthogonal-dimension architecture callout from Conv 178); [MATT-RT-DOC] (`matt-pre-plan.md` §2 Implementation status subsection added — 2/13 built, 11/13 pending); [MCP-DOC] (new canonical `docs/reference/figma-mcp.md` consolidating `.scratch/figma-mcp-setup.md` + `memory/reference_figma_mcp_behavior.md`; scratch source deleted, memory file retained as recall-shorthand). New pattern established: **doc graduation flow** scratch (staging) → memory (recall-shorthand) → docs/reference (canonical). Next major step (lead): MMP-PH3 Component primitives via MCP-driven extraction. → **Conv 183: MMP-PH3 Component primitives IN PROGRESS — 2 of 7 landed.** [MATT-EXEC-CMP-BTN] Button rewritten with strict-B 5-value `property1` enum (Default/Hover/Large/Small/SmallHover) mirroring Matt's Figma exactly; Conv 178's "3-orthogonal-dimension" claim retracted as misframed — Property 1 conflates State + Size. CSS extracted via MCP probes of 5 Figma nodes (40:482 section + 5 variant nodes). Hover/SmallHover use inline-style hardcoded gradient (Matt's partial coverage — Hover Primary-only, no Variable Mode awareness). 6 Color variants preserved; Disabled kept as standard a11y orphan via `[disabled]` CSS. [MATT-EXEC-CMP-MNV] MainNav landed as 3 new components (MainNav.tsx props-driven orchestrator + NavItem.tsx 3-variant Default/Selected/Main + NavSubItem.tsx 2-variant Default/Selected); Sidebar.tsx refactored to consume MainNav while retaining Peerloop shell. Architecture decisions D1/D2/D3 established new collaboration pattern: **AskUserQuestion + ASCII mockup previews** when text-only descriptions are insufficient for UX/architecture decisions (user pushed back on text-only decisions → ASCII baseline + side-by-side option previews resolved D1/D2/D3 visually). D1 = Route-driven Main pill (auto-positions around active section, derived state, no toggle); D2 = Keep 70px collapse mode as Peerloop extension (Sidebar renders separate icon-only nav when collapsed); D3 = Props-driven data model. New memory file `feedback_never_modify_figma.md` (Figma is read-only; never call write-shaped MCP tools — user directive). matt-design-system.md §5 Button rewritten with empirical variant matrix + new MainNav subsection added. Baselines: tsc 0; astro check 1236 0/0/0; dev HTTP 200. 5 of 7 MMP-PH3 component primitives remain: [-SNV] / [-ENT] / [-CHT] / [-PNC] / [-BRN]. → **Conv 184: MMP-PH3 advanced — SubNav + Entity collection decomposition + SocialPost refactor + new standing rule.** [MATT-EXEC-CMP-SNV] complete (resolved Conv 183 "Need 3+ Levels" open question — base + Selected-expanded, NOT multi-level; rebuilt as `SubNav.astro` container + `SubNavItem.astro` 3-variant; fixed latent Conv 175 silent bug via `currentPath`-derived active state). User reframed Entities + Post Anchors as collections — Option C architecture locked in: 4 leaf primitives extracted ([CMP-UICN] UserIcon initials avatar / [CMP-EPILL] EntityPill / [CMP-ELINK] EntityLink / [CMP-CHIP] IconLabelChip the user-directive exception per honest-orphan); first anchor row [CMP-ANCH-COURSE] CourseAnchor composing them + Button; 8 anchors remain ([CMP-ANCH-REST]). Then full SocialPost closure via [CMP-ANALYTIC] AnalyticCount primitive + [CMP-UICN-IMG] UserIcon `avatarUrl?` strict-B extrapolation + [REFACTOR-SOCIALPOST] removing all inline duplicates (Avatar/ActionPill/LikeIcon/CommentIcon). Astro/React boundary cascade forced standardization: **all Conv 184 primitives + MattIcon on React (.tsx); 6 .astro files converted and deleted** (Astro imports React but not reverse). New standing rule `feedback_reuse_existing_components.md`: scan `<instance>` children, import existing primitives, never inline duplicates — surfaced by Conv 184 audit that caught SocialPost inlining Avatar/ActionPill AND CourseAnchor (built earlier same conv) inlining Button styling; CourseAnchor refactored same conv to use Button.tsx. tokens-semantic.css `.entity-student-teacher` alias added. /matt/ showcase extended with 6 new Card sections. Baselines green: tsc 0; astro check 1243 0/0/0; dev HTTP 200. DOM verified: 6 UserIcon, 8 EntityPill, 15 IconLabelChip, 7 AnalyticCount, 3 CourseAnchor, 1 SocialPost — math validates total elimination of inline duplication. 3 new deferred items: [CMP-CHAT] / [REFACTOR-COURSEHEADER] / [CMP-ANCH-REST]. → **Conv 185: MMP-PH3 audit-driven follow-throughs — all 5 Q1/Q2 carry-forward items COMPLETE in one conv.** User redirected from auto-recommended MMP-PH4 to the Conv 184 audit table; CC sequenced BRN → CHAT → C178-REVAL → CMP-ANCH-REST (Q1 NEW primitives first so re-probes see full vocabulary, then audit, then largest batch last). **[MATT-EXEC-CMP-BRN] Brand primitive** (Logo 3 variants + LogoMark 3 variants from `40:481` / `1:270` / `35:144`; 4 SVGs downloaded with `fill="var(--fill-0, #hex)"` Variable-fallback pattern normalized to `currentColor`; Sidebar wired Medium expanded / Default collapsed). **[CMP-CHAT] Chat Bubble primitive** (2 variants Default/Us from `646:7540`; Matt drew pre-mirrored shapes not CSS transforms; **strict-B drift**: `inline-flex max-w-[280px]` instead of Matt's 159px placeholder — documented in docstring). **[C178-REVAL] re-validation** found significant Conv 178 drift in all 3 newly-probed: Module rewritten with 2 variants Default/Current matching Matt's `property1` enum (dropped over-engineered 4-color `entity` prop — single hardcoded `--Primary-Light`); ToDoItem rewritten with 20×20 rounded-[5px] checkbox (was 24×24), Medium weights, dropped `entity` prop; **SectionTitle name-collision discovered** — Matt's is a Figma-internal dev-status banner (WIP/Ready/Archived, 1280×96px, TT Norms Pro Mono), NOT a product component; our `SectionTitle.astro` is a generic content heading (Inter) — different purposes, documented in matt-design-system.md but unchanged. SocialPost re-probe skipped (already validated Conv 184). **[REFACTOR-COURSEHEADER]** creator section refactored to UserIcon + EntityPill + EntityLink trio in `.entity-creator` cascade; `CreatorRef` interface extended with optional `slug`/`initials`/`avatarUrl`; caller updated to pass `creator.handle` + `creator.avatar_url`. Rating/level/CTA STAY INLINE per **dark-hero vs light-bg primitive split** constraint (IconLabelChip uses gray `text-text-tertiary`; Button is light-bg optimized — both invisible against light hero overlays). **[CMP-ANCH-REST]** all 8 anchor row components built in single batch: CreatorAnchor (entity-creator, "Learn More" CTA), CertificationAnchor (no pill, no CTA), ModuleAnchor (no pill, no CTA), ResourceAnchor ("View" CTA), ReviewAnchor ("Read" CTA), StudentTeacherAnchor (entity-student-teacher, pill "Suggested" — NOT "Student-Teacher" per Matt; "View Teacher" CTA), VideoClipAnchor (123×69 thumbnail with inline-SVG play-circle overlay; chat icon as substitute for `video_comment`; "Watch" CTA), MilestoneAnchor (no pill, "View" CTA). **All Matt's named primitives now built — 13/13 of Components page complete** (MMP-PH3 substantially complete; remaining gaps are Phase 6 extrapolation work: dark-hero variants + 2 missing Material icons). **3 new deferred items:** [DARK-HERO-VARS] / [VIDEO-COMMENT-ICN] / [PLAY-CIRCLE-ICN]. **New Figma MCP empirical finding:** asset URLs preserve source format — vector sources return SVG (with `fill="var(--fill-0, #hex)"`), raster sources return PNG. Captured in `reference_figma_mcp_behavior.md` + MEMORY.md. Chrome MCP extension disconnected mid-conv; installed Playwright chromium (~250MB) for programmatic screenshot verification — used for all 5 carry-forward items. 17 new files (8 anchor .tsx + Logo + LogoMark + ChatBubble + 6 SVG assets + 2 new subdirs brand/ + chat/). Baseline gates clean; branch `jfg-dev-13-matt` retained.) → **Conv 187: MMP-PH4 re-render test COMPLETE + per-icon viewBox registry + CourseHeader re-validated to Matt's frame + addressability-first routing.** [MMP-PH4] Course In Feed (`519:9096`) re-rendered as `CourseInFeed.tsx` (props-driven dark-hero card; EntityPill + 4 on-dark IconLabelChips + course Button + MattIcon); live-verified in Chrome bridge at 245px (exact match). The re-render gate surfaced both designed-for assumptions: (1) [CMP-ICN-REGISTRY] RESOLVED = per-icon intrinsic viewBox in `MattIcon.tsx` (icons stored native size; size-agnostic) when `stars_2`+`accessibility_new` arrived at 20×20 vs the 24×24 grid — [STARS2-ICN]+[ACCESSIBILITY-ICN] harvested; (2) **CourseHeader creator-trio drift** caught on the sibling course page → `CourseHeader.astro`→`.tsx` re-validated to Matt's Default frame `517:8935` (all metadata = white on-dark IconLabelChips, NOT the Conv 184/185 UserIcon+EntityPill+EntityLink trio; trio reserved for future Meet-the-Creator tab; user confirmed "B"). [DARK-HERO-VARS] COMPLETE via IconLabelChip `tone="on-dark"`; Button dark variant confirmed unneeded. [MATT-IDX-AUDIT] 6 article→Card. [MATT-EXEC-FLAGS] RESOLVED on addressability axis (user reframe: needs-a-URL ≠ how-many-files): addressable = Course tabs / Enroll Success (Stripe) / Choose Teacher / Session (one state-driven `/session/[id]`) / Home-Feed; non-addressable = Enroll pre-checkout / Session Scheduled / Home-Course-Completed; saved as `feedback_routing_addressability_first.md`. [GVD-SELFREE-VERIFY]+[MCP-SEL-MISFIRE] closed — all Figma read tools selection-free with explicit nodeId; "selection-required" class retired in `reference_figma_mcp_behavior.md`. 2 commits (`ead81ada` CourseInFeed+viewBox+SVGs+chip+showcase, `cea3def0` CourseHeader+Card-ify); docs `06d33a0`. 2 new deferred: [CH-DOCSYNC] (matt-design-system.md CourseHeader trio→chip doc-sync), [CH-VARIANTS] (CourseHeader Enrolled `597:6504` + Scheduled `685:13240`). All 5 gates green; branch `jfg-dev-13-matt` retained. MMP-PH5 / MATT-SUBNAV-ROUTING / MATT-EXEC-PG2 unblocked.) → **Conv 188: [MATT-SUBNAV-ROUTING] COMPLETE + MATT-EXEC-PG2 course-tab family decomposed.** `/matt/course/[slug]/[...tab].astro` catch-all route landed (VALID_TABS feed/modules/creator/teachers/reviews/resources + 302-on-invalid + shell + per-tab switch); fixed a latent SubNav active-state bug (startsWith-prefix → most-specific-match-wins; About stopped staying Selected on child tabs); routing demoed live across all 7 tabs (GIF). PG2 course tabs decomposed via Option A (per-tab `.astro` bodies + `tab ===` switch, index.astro untouched): [RESTAB] + [TCHTAB] built (Resources empty state + `folder.svg` 42nd icon; Teachers bio-card from live D1 SSR loader, role-based entity palette); [CRTTAB]/[RVWTAB]/[MODTAB] pending; Enroll/Session families remain under PG2. [MOD-SCHEMA] resolved (Session↔Module 1:1; Matt "Module"=Sub-Module; memory `project_module_submodule_model.md`). [ENTITY-CASCADE-BUG] fixed (cascade-driven entity tokens moved to `@theme inline` — plain `@theme` had silently broken EntityPill/EntityLink/UserIcon role colors app-wide); surfaced via opt-in `roleDot` on UserIcon. 4 new deferred: [SHOWMORE] / [SNV-ICONS] / [MNV-STYLE] / [MEM-ICON-COUNT]. Full baseline: build 6.30s clean; test 6453 passed/371 files. Branch `jfg-dev-13-matt`.) → **Conv 189: MATT-EXEC-PG2 course-tab family COMPLETE — remaining 4 tabs built.** [CRTTAB] CreatorTab built (`CreatorTab.astro`): identity/bio/3 computed stat chips from real loader data; the 4 sections with no schema counterpart (Expertise / Teaching Philosophy / Qualifications / Why-Learn) render Matt's verbatim copy as **static grey** via a `staticContent` prop — NO schema change per user directive (`CREATOR_STATIC` constants in route; flip flag restores color when data arrives). Cosmetic fixes: `leading-normal` workaround for global `--body-default-line-height: 1` ([LH-VERIFY] now has visible evidence), Matt's light-blue quote bg restored. [RVWTAB] ReviewsTab built reading the **existing** `course_reviews` table via a new loader query (rating/body/author/timestamp real; reaction pills static — no reactions table). [MODTAB] ModulesTab built one card per `course_curriculum` row (1:1 per [MOD-SCHEMA]; number/title/description/duration real; "N Modules" sub-count + "posts" pill omitted per user "omit both"). [FEEDTAB] Course Feed tab built `MattCourseFeed.tsx` client island on the **existing** `GET /api/feeds/course/[slug]` (same Stream-backed API the legacy `CourseFeed.tsx` uses — real posts, not static; corrected my own earlier "needs Stream integration" conclusion after user pointed to the legacy feed). Extracted `CourseEmbedCard.tsx` (shared embedded-course card; Reviews refactored to reuse). **All six course sub-tabs now render in `[...tab].astro`** (feed/modules/creator/teachers/reviews/resources). **Key learning:** per-tab data strategy is only knowable after probing actual schema/seed/API — 4 tabs, 4 different verdicts (Creator static / Reviews+Modules real-via-existing-table / Feed real-via-existing-API); defaulting all to one approach would have been wrong in 3 of 4. **3 decisions:** (1) CreatorTab unbacked sections = static grey, no schema; (2) Reviews+Feed use real data via existing tables/APIs; (3) Modules = 1 card per curriculum row, omit unbacked counts. **Code:** `courses.ts` loader (+`reviews` query), `[...tab].astro` (4 branches + `CREATOR_STATIC` + shared `courseEmbed` + viewer query), NEW `CreatorTab.astro` / `ReviewsTab.astro` / `ModulesTab.astro` / `MattCourseFeed.tsx` / `CourseEmbedCard.tsx`. All 5 gates green (test 6453 pass). **3 new deferred:** [CRS-MOBILE] (no mobile breakpoint on course SubNav+tabs), [FEED-COMPOSER-USER] (logged-out composer "?" avatar), [COURSE-TAGS-LOADER] (latent `course_tags` SELECT * typing mismatch). Branch `jfg-dev-13-matt` retained. Next major step (lead): Enroll family / Session family under [MATT-EXEC-PG2], or [MMP-PH5] graduation.) → **Conv 190: MATT-EXEC-PG2 course-tab polish + Sidebar/shell rewrite to Matt's Layout Desktop.** Fixed two Conv 189 bugs ([COURSE-TAGS-LOADER] `course_tags` JOIN tags for real names; [REVIEW-COUNT] header count `rating_count`→`reviews.length`). [SNV-ICONS] DONE — Matt-sourced SubNav leading icons (Course Feed=feed / Modules=module / Resources=resource / Reviews=review / Teachers=student-teacher / Meet the Creator=creator; About=`info` documented extrapolation, Decision 4) probed from `419:6162`. Browser verification surfaced a **duplicated-route bug** (a second `courseTabs` array in `index.astro` left About iconless) → **[RTCONS]** consolidation (Decision 1): extracted shared `_course-tabs.ts` (`buildCourseTabs`, `_`-prefix excludes from routing), folded About into `[...tab].astro` as the empty-segment `'about'` view, deleted `index.astro`, regenerated `route-map.generated.ts`; all 7 routes + invalid-tab 302 verified (no loop). [MNV-STYLE] DONE — Sidebar emoji placeholders → MattIcon glyphs. [SBAR-STICKY] sidebar viewport-pinned (`lg:sticky lg:top-0 lg:h-screen`). [MATT-COURSE-POLISH] — SubNav `lg:sticky lg:self-start` + a **design-system-wide letter-spacing token bug** fixed (Figma `-2.2` = `-2.2%` = `-0.022em`, had been baked `-2.2px` ~6× too tight across all four "Body larger sizes" tokens; surfaced via crammed "Entrepreneur" text). User then judged the sidebar still off Matt → **[SBAR-REWRITE]** (Decision 2, scope B = sidebar AND shell): probed `81:1483`; shell `AppLayout` now grey page (`#f8fafc`) + floating white rounded-20 content card + transparent sidebar; Sidebar active = always-white pill, `«` double-chevron collapse (harvested `keyboard_double_arrow_left` → `chevrons-left.svg`, **43rd icon**), bottom Profile cluster with role descriptions; Logo `Medium`→`Small`, `MainNav` gap `16`→`24` + active→'Main' pill regardless of children, `UserIcon` `size` prop (24/40); new `src/lib/roles.ts` (`userRoles`/`describeRoles`, hierarchy Admin>Creator>Teacher>Moderator>Student, multi-role label + Visitor fallback, Decision 3) consumed by `AppLayout`. Verified `/matt/` Home-pill, collapsed mode, course page, Visitor state live; logged-in Profile row NOT yet visually verified → [PROF-ROW-VERIFY] deferred (user tests real login as Brian off-chat). Password-rotation lookup: latest Conv 167 / 2026-05-20 (`14ca0e02`). All 5 baseline gates green (test 6453 passed / 371 files). Branch `jfg-dev-13-matt` retained; dev server left running on 4321. Next major step (lead): Enroll family / Session family under [MATT-EXEC-PG2], or [MMP-PH5] graduation. → **Conv 192: doc-infra split + /matt/courses index.** **[MDS-SPLIT]** matt-design-system.md (1,717 lines) split into `docs/as-designed/matt-design-system/` folder (INDEX + 7 concern files 01–07; §5 split at line 642 into `05-color-and-tokens.md` + `06-component-primitives.md`); old path → stub with §N→file mapping; byte-for-byte lossless verified (reconstruction diff); `docs/INDEX.md` repointed; convention recorded in `DOC-DECISIONS.md` §2. [CH-DOCSYNC] confirmed ALREADY DONE (Conv 187 docs agent — CourseHeader trio→chip reversal at lines 1005–1007). **[MATT-COURSES-INDEX]** new `src/pages/matt/courses.astro` (approach B — thin Matt-native index reusing existing `fetchCourseBrowseData` loader + `CourseEmbedCard` grid; CTA already targets `/matt/course/[slug]`); fills the gap where `/matt/index.astro`'s SubNav linked to `/matt/courses` (was 404). DOM-verified 6 cards / 6 CTAs. Spawned [DISC-UNIFY] (migrate `/discover/courses` onto `fetchCourseBrowseData`; needs `primary_topic_id` added to loader).) → **Conv 193: MATT-SUBNAV-STUBS + URLDOC-MATT + 2 doc graduations.** **[MATT-SUBNAV-STUBS] DONE** (scope = option C: all 5 missing top-level routes + `/matt/teachers/[handle]` detail, per-route stub depth — recorded 3-route scope undercounted; StudentTeacherAnchor deep-links to the detail route): 6 /matt pages built — `/matt/teachers` (thin-functional, `fetchTeacherDirectoryData` + StudentTeacherAnchor rows), `/matt/teachers/[handle]` (thin-functional, `fetchTeacherProfileData`, 404 on unknown), `/matt/todo` (ToDoItem showcase), `/matt/messages` (ChatBubble thread), `/matt/saved` + `/matt/notifications` (honest empty-states); fixed `icon="people"`→`student`; new pattern = **per-route stub depth** (thin-functional where a loader exists, else honest empty-state/primitive-showcase); DOM smoke-tested all 6 (200s; teacher detail rendered real `guy-rymberg`, bad handle → 404, 7 anchor rows). Route maps regenerated. **[URLDOC-MATT] DONE** — `/matt/*` backfilled into `url-routing.md` (new §8 transient namespace + file-structure subtree + Implementation Status row + header). **[MMP-PH5] promotion half DONE** (the roll-forward half REMAINS — see deferred #15): `.scratch/matt-figma-pages.md` graduated → `docs/as-designed/matt-figma-pages.md` (header canonicalized, scratch deleted, INDEX.md row added); 2 of 3 MMP-PH5 sub-items ([MFE-STALE], [MCP-DOC]) were already done Conv 182. **[MFRD-GRADUATE] DONE** — `.scratch/matt-frames-ready-for-dev.md` graduated → `docs/reference/matt-frames-ready-for-dev.md` via cp+Edit (byte-fidelity for the 138-line lookup table; hit the cp-created-file-needs-Read-before-Edit gotcha); INDEX.md row added; [MFRD-LOOKUP] repointed to docs path. **Learning:** machine-pinned scratch files (gitignored, lived only on MacMiniM4) graduate on the authoring machine — once in committed docs they sync to both machines and lose the machine-pin. Gates: astro check 0/0/0, lint, build. Branch `jfg-dev-13-matt`. Next major step (lead): [MMP-PH5] roll-forward half (11 Phase-5 pages via MCP), or Enroll/Session families under [MATT-EXEC-PG2].) |
| NAV-RETROFIT | Legacy→Matt incremental migration — retrofit legacy shell onto Matt's design | 🔥 IN PROGRESS (Conv 191, demo-driven). **Root cause found ([DEMO-HOME]):** Conv 174 added `@import tokens-tailwind-bridge.css` to `global.css`; the bridge's `@theme` `--spacing-*` block aliases Tailwind's numeric scale to Matt's literal-px scale (`--spacing-64: var(--space-64)` = 64px), silently shrinking EVERY legacy spacing utility in the set {4,8,12,16,20,24,32,40,48,64} ~4× app-wide since Conv 174 (`w-64`→64px, `h-4`→4px). Tests never caught it (CSS not unit-tested); `/matt` unaffected (uses arbitrary `[Npx]` + bare numerics that EXPECT Matt's scale). **Strategy (user decision):** `/matt` is the final design destination — do NOT revert the override (would break `/matt`); instead migrate legacy components ONTO Matt's design incrementally. **Approach B chosen** (restyle legacy in place, preserve behavior; approach A = swap to Matt components, possibly later). **Conv 191 DONE — AppNavbar step 1 + bidirectional demo bridge:** `<aside>` `w-64`→`w-[220px]` + `AppLayout` main `lg:ml-64`→`lg:ml-[220px]`; rows restyled to Matt (`text-body-medium-bold` label + 12px `text-body-small` desc via `line-clamp-2`, `gap-[12px]`, brand-blue flat "Selected" active — white pill deferred until grey shell); chevrons `h-4 w-4`→`size-[16px]` (Discover + user item + dropdown close); both slideouts (`DiscoverSlidePanel`, `UserAccountDropdown`) `left-64`→`left-[220px]`. Bidirectional nav: AppNavbar "New Design"→`/matt/` (top item, SparklesIcon); Matt `Sidebar.tsx` NAV+COLLAPSED_NAV "Classic App"→`/` (arrow-left, marked **TEMP demo bridge** for easy removal). Round-trip verified in Chrome bridge; all 5 gates green (tsc/check 1264 0/0/0/lint/test 6453/build 6.43s). **Conv 191 follow-up — 3 View-Transition regressions found+fixed via the / → New-Design → Classic-App round-trip** (all DOM-verified, NOT screenshot — see `feedback_dom_truth_over_screenshots.md`): (1) navbar items bunched (island-unique `py-[10px]` dropped when /matt CSS swapped in → standard `gap-3/px-2/py-2.5/p-3`); (2) Messages quick-action card vanished (inline reveal `<script>` doesn't re-run on VT → bound to `astro:page-load`); (3) Discover/User slideouts behind navbar (island-unique `left-[220px]` dropped + a **duplicate-`style` JSX bug** that silently dropped the first fix → merged into single inline `style`, DOM-confirmed left:220 flush + on-top). Sweep: only `index.astro` had a VT-fragile inline script; AdminNavbar shares the bug class (admin-only, [NAV-SIBLINGS]). **Conv 192 — home-page spacing fixes + [LEGACY-SPACING-AUDIT] resolved (do-nothing-broad):** Fixed the home footer (`Footer.astro` full + compact variants — 7 hijacked-step utilities → arbitrary px `py-[48px]`/`px-[16px]`/`lg:px-[32px]`/`gap-[32px]`/`pt-[32px]`/`gap-[16px]`/`mt-[16px]`) and the dashboard main panel (`index.astro` — icon containers + clock `h-12 w-12`→`h-[48px] w-[48px]` were clipping 24px glyphs to 12px boxes; `mb-8`→`mb-[32px]`, `gap-4`→`gap-[16px]`, `mb-4`→`mb-[16px]`, `py-8`→`py-[32px]`), both DOM-verified in Chrome bridge. **[LEGACY-SPACING-AUDIT] quantified + decided:** override hijacks **3,894** utilities across **354 legacy files** vs only **11 `matt/` files** that depend on the new meaning — asymmetry would justify reverting, BUT user chose **do-nothing-broad / fix per-component as legacy→Matt conversion reaches each** (the mechanical sweep would be thrown away by the migration; reaffirms Conv 191 "don't revert"). Remediation recipe per component: convert hijacked-step utilities to arbitrary `[Npx]`. **Conv 193 — AdminNavbar retrofit + both-nav icon swap; group #4–#8 resolved.** **[NAV-SIBLINGS] narrowed to AdminNavbar-only + DONE** (Decision: AppHeader excluded — speculative, never client-reviewed, public-facing visitor→member surface most likely to be redesigned; MoreSlidePanel deferred → new [MSP-COUPLING]): AdminNavbar un-broke 9 hijacked-step spacing utils (avatars `h-8`→`size-[32px]`, header `h-16`→`h-[64px]`, paddings `p-4`→`p-[16px]`, etc.) + rail `w-64`→`w-[220px]` + coupled `AdminLayout` `lg:ml-64`→`lg:ml-[220px]` + content padding + stale docstring; dark theme kept. **[NAV-ICON-SWAP] DONE** (user directive: match from Matt43 ∪ Material Design icons, dashed-border any unmatched): probed both navs' icon inventories + Matt's 43-set — Matt's set is product-oriented (no nav-chrome/admin-tooling glyphs), so ~half the nav icons had no Matt equivalent; harvested 10 Material-outlined icons (menu, search, admin-panel-settings, chevron-right, group, label, assignment, videocam, warning, person-add) via curl from the marella mirror into the MattIcon registry (**43→53**, fills normalized to `currentColor` — MattIcon wrapper is `fill="none"` so harvested paths MUST carry explicit fill); swapped BOTH AppNavbar + AdminNavbar to MattIcon; removed legacy `@components/ui/icons` imports from both; zero dashed-border cases (Material covered every gap); all 21 referenced names validated to resolve to real files; provenance documented in MEMORY.md. **[LEGACY-SPACING-AUDIT] recipe applied** to AdminNavbar (the per-component remediation form, as decided Conv 192). **[NAV-APP-A] deferred — continue approach B** (approach-A component swap would moot #4/#5 work; matches standing Conv 191 decision). **[VTPRD] DROPPED** (no recoverable scope — deleting beat guessing). VT-drop learning: arbitrary utilities are safe within a route family (AdminNavbar persists only admin→admin, every admin route generates its classes) — only cross-family island-unique arbitrary utilities (Conv 191 slideout offsets) need inlining. Baselines: tsc 0; astro check 1271 0/0/0; lint; build. **NOT visually verified** — both navs auth-gated; mechanism proven (harvested `menu` icon renders in real SSR output, zero placeholders) but logged-in look unconfirmed. AppHeader intentionally NOT retrofitted (speculative public surface). **Conv 194 — both Conv 193 PENDING items closed + 1 latent bug fixed + 1 new bug found.** **[MSP-COUPLING] RESOLVED by deletion** — live-DOM check showed `MoreSlidePanel.tsx` is dead code (superseded by `UserAccountDropdown`, zero consumers); every feature has a home (dark-mode + Help + Settings in UserAccountDropdown; Privacy in Footer); deleted file + barrel export + stale `AppLayout.astro` comment (incl. 256px→220px rail drift). **[LH-VERIFY] DONE** — both navbars visually verified in Chrome bridge: AppNavbar (Guy session, 220px rail @left:0, 0 dashed icons, slideouts at left:220) + AdminNavbar (Brian session, 220px rail, main margin-left:220px, 15 MattIcons, 0 dashed, 14 links; flat-list by design, no slide-out). **[MPB] FIXED** — AppNavbar slide-out panels (`DiscoverSlidePanel` + `UserAccountDropdown`) bled ~220px over content below `lg` (closed `-translate-x-full` from left:220 was only occluded by the rail, not truly off-viewport; rail goes off-canvas below lg, exposing them); fixed with self-sufficient inline closed-transform `translateX(calc(-100% - 220px))` (viewport-independent, survives VT swaps) in both panels. **NEW BUG [ADMIN-REDIRECT-BLANK]** — authenticated non-admin hitting `/admin/*` gets a blank 15-byte 200 instead of redirect to `/`; clean dev restart falsified the optimize-deps hypothesis; mechanism unexplained (why `AdminLayout` line 37 `Astro.redirect('/')` yields blank 200 while line 34 `/login` redirect yields clean 302) → deferred to DEFERRED #27. Also confirmed [CRS-MOBILE] + course-page entity-vis audit (no issues; see those subtasks). Branch `jfg-dev-13-matt`. |
| BBB-RECORDING | BBB Recording Investigation — diagnose empty recordings, fix `autoStartRecording`, build account-wide diagnostic endpoint | 🔥 IN PROGRESS (Convs 159-164: [REC-LABEL] complete Conv 163; [BR-NAVBAR-HYDRATE] complete Conv 164; only [BR-STATUS] + [BR-ZERO-REPRO] deferred. [CRT] promoted to own block.) |
| CALENDAR | Platform Calendar — custom multi-view calendar component for all roles | 📋 PENDING |
| ADMIN-REVIEW | Admin System Review — testing gaps, UI consistency, cross-links, menu restructure | 📋 PENDING (promoted Conv 095) |
| PACKAGE-UPDATES | Package Version Upgrades — all dependencies current, new branch | ✅ COMPLETE (Convs 104-114, PR #26 merged into `staging`). CF Pages→Workers migration spawned as separate CF-WORKERS block and also complete. |

### ON-HOLD

| Block | Name | Notes |
|-------|------|-------|
| DEPLOYMENT | Deployment automation + prod cutover — spawned from CF-WORKERS | PAGES-DISCONNECT done (Conv 116). Staging green. Remaining: GHACTIONS, PROD, STAGING-DOMAIN. Deferred Conv 129 — no sub-block urgent. |
| INTRO-SESSIONS | Intro Sessions — free 15-minute pre-enrollment calls | Schema exists (`intro_sessions`); feature not built. Discovered in TERMINOLOGY review Session 348. |
| ~~DEV-STAGING-SSR~~ | ✅ **RESOLVED Conv 177** via `[DSSR-SCOPE]` fix | The Conv 122 root-cause hypothesis (two React copies via `@astrojs/cloudflare` 13) was wrong. Real cause: Vite cold-start dep-discovery race (industry-wide, see DEVELOPMENT-GUIDE.md § Vite SSR Cold-Start Dep Discovery). Fix: `astro.config.mjs` `vite.optimizeDeps.entries` + `include: ['astro/virtual-modules/transitions.js']`. Cold-start /matt/ now succeeds first try; production build clean (7.27s); preview /matt/ renders fully with `Sidebar.tsx` useState intact. Conv 176 stateless-primitives discipline retired. |

### DEFERRED

*Reorganized Conv 095. Previous numbering in git history.*

| # | Block | Name | Notes |
|---|-------|------|-------|
| 1 | SEEDDATA | Database Seeding & Empty State | 🟡 Nearly Complete (EMPTY_STATE deferred to POLISH) |
| 2 | POLISH | Production Readiness | Validation, roles, tech debt, security, deferred features |
| 3 | MVP-GOLIVE | Production Go-Live | Absorbs OAUTH, STAGING-VERIFY, CRON-CLEANUP, RECORDING-PERSIST |
| 4 | TESTING | Multi-User Testing | Merged: E2E-GAPS + E2E-LIFECYCLE + WORKFLOW-TESTS |
| 5 | IMAGES | Image Pipeline — uploads, management, optimization | Merged: FILE-UPLOADS + IMAGE-MGMT + IMAGE-OPTIMIZE |
| 6 | FEEDS-NEXT | Feed Enhancements — ranking, mobile, privacy, level matching, promotion | Merged: FEEDS + FEED-PROMOTION + FEED-PRIVACY + LEVEL-MATCH |
| 7 | OBSERVABILITY | Error Tracking, Analytics, Audit Logging | Merged: SENTRY + POSTHOG + AUDIT-LOG |
| 8 | CERT-APPROVAL | Certificate Lifecycle — student page, creator approval, PDF, public view | 7 admin/API endpoints built, 0 UI pages |
| 9 | PUBLIC-PAGES | Public Page Coherence — header unify, legacy cleanup, footer, personalization | |
| 10 | PAGES-DEFERRED | Deferred Pages (7) | Includes story IDs |
| 11 | RATINGS-EXT | Ratings Extensions — expectations, materials rating, display | |
| 12 | EXTRA-SESSIONS | Extra Session Purchases | Beyond course plan |
| 13 | COURSE-LIMIT | Creator Course Limit | Default 3, admin-adjustable |
| 14 | AVAIL-OVERRIDES | Availability Overrides | Schema exists; feature not built |
| 15 | EMAIL-TZ | Per-User Timezone in Emails | Requires `timezone` column on users |
| 16 | MSG-TEACHER | Message Teacher from Course Page | Messaging now open (Conv 110); needs UI button on course page |
| 17 | RESPONSIVE | Responsive & Mobile Review | Site-wide audit needed |
| 18 | ROUTE-AUDIT | Route & Sitemap Audit | Routes vs `url-routing.md`, public/auth boundaries |
| 19 | STUMBLE-REMNANTS | STUMBLE-AUDIT Remaining Items | JWT test, 2 client decisions (member_count fixed Conv 108) |
| 20 | STRIPE-E2E-DEV | Dev-Level Stripe Integration Stress Test — real browser, real Test-mode cards, real webhook tunnel | Prerequisite for go-live confidence. Conv 145 scoped. Tiered (A/B/C/D). Complements Conv 144 staging live-verification with higher-fidelity Dev-side coverage. |
| 21 | DISC-UNIFY | Migrate `/discover/courses` onto `fetchCourseBrowseData` loader | Conv 192 — would let `/matt/courses` and legacy discover share one loader. Blocked: `fetchCourseBrowseData` lacks `primary_topic_id` (discover filters on it). Add the field to the loader first. |
| 22 | ADMIN-REDIRECT-BLANK | Non-admin hitting `/admin/*` gets blank page instead of redirect | Conv 194 — authenticated non-admin (Guy, `is_admin=0` confirmed in D1) gets a blank 15-byte 200 on all `/admin/*` instead of a redirect to `/`. Unauthenticated `/admin` → clean 302 → `/login` (no-session branch works); authenticated non-admin → `AdminLayout` line 37 `Astro.redirect('/')` yields blank 200, NOT 302. Clean dev restart falsified the Vite optimize-deps hypothesis. **Mechanism unexplained** — why does line 37's redirect differ from line 34's (`/login`, no-session) clean 302? Needs focused investigation. |

---

## Conv 150-157 Deferred Tasks

Infrastructure, memory-sync, skill-authoring, and timecard enhancement work surfaced deferred architectural items:

- [x] **[MND]** Conv 168 — Fixed `detect-machine.sh` hostname match for M4Pro (added `*M4Pro*` + `*M4-Pro*` case patterns; emits `MacMiniM4Pro`). Also migrated canonical name across 11 files (`MachineName` TS type narrowed to `'MacMiniM4Pro' | 'MacMiniM4' | 'CI' | 'unknown'`, `vitest.global-setup.ts`, `tests/README.md` × 5, `dev-env-scan.sh` grep widened to accept `MacMiniM4Pro|MacMiniM4-Pro|MacMiniM4` for forward + historical compat, plus 8 docs: CLAUDE.md, devcomputers.md, env-vars-secrets.md, dev-setup.md, skills-system.md, COMMIT-MESSAGE-FORMAT.md, DEVELOPMENT-GUIDE.md, cloudflare.md). See DECISIONS.md decision 1 — code-truth conflict resolved by migrating code TO PLAN form (no-hyphen). tsc clean.

- [ ] **[AAP]** Astro dev-only absolute-filesystem path leak in `ClientRouter` `<script src>` — Astro 6.3.6 emits `<script type="module" src="/Users/jamesfraser/projects/Peerloop/node_modules/astro/components/ClientRouter.astro?astro&type=script&index=0&lang.ts">` (absolute filesystem path leaks into URL). Root cause: `node_modules/astro/dist/vite-plugin-astro/compile.js:50` — `import "${compileProps.filename}?astro&type=script..."` where `compileProps.filename` is absolute. Verified by `npm pack astro@6.3.6` + diff (latest stable has identical buggy line). Naïve relative-path fix doesn't work (Vite resolves relative imports against importer = same .astro file = absolute). Functionally a no-op (Vite serves 200 either way) but cross-machine portability hazard. **WAITING on upstream Astro fix post-6.3.7.** Conv 177: re-tested against Astro 6.3.7 — still broken upstream (absolute path still leaks in ClientRouter src). Verification probe after each Astro upgrade: `curl http://localhost:4321/ | grep -oE 'src="[^"]*ClientRouter[^"]*"'` — non-absolute path = fixed. (Conv 163, retested 177)

- [x] **[CAP-DEFEND]** Conv 167 — Widened `CourseAvailabilityPreview.tsx:76` early-return guard from `!data || data.teacherCount === 0` to `!data || !Array.isArray(data.teachers) || data.teachers.length === 0`. Defensive against any "data shaped but teachers absent" case (e.g., `{}` mock fallback that crashed `data.teachers.map(...)`). CourseTabs test 19/19 passes with 0 unhandled errors (was "1 unhandled error" in Conv 166).

- [x] **[PROD-PW]** Conv 168 — Decisions captured in `docs/DECISIONS.md` §4 "Prod admin seed password: rotate to 'Peerloop2', apply deferred". Decision: password = `Peerloop2` (matches dev); apply deferred to bundle seed edit + `wrangler d1 execute` UPDATE in one synchronous step. Counter-option (strong random + 1Password) explicitly preserved for "revisit if/when team grows." Un-defer procedure documented (3 numbered steps including bcryptjs hash location + `wrangler d1 execute` command shape). Apply tracked separately as [PROD-PW-APPLY] (see Conv 168 section). (Conv 167 surfaced, Conv 168 decided)

- [x] **[CCK-DA]** Conv 168 — Redesigned `/w-codecheck` Check 8 as alias-aware schema-aware lint. New v2 algorithm parses FROM/JOIN/INTO/UPDATE → alias-to-table map; for each `<token>.deleted_at` resolves via map and flags only if owning table lacks column; for each unqualified `deleted_at` flags only when NONE of the FROM/JOIN tables has the column. Calibrated against actual Conv 117 motivating case (verified via `git show 7df6c02`): pre-fix SQL was `SELECT ... FROM communities WHERE slug = ? AND deleted_at IS NULL` — **unqualified** filter, not qualified as session-doc summary claimed. v2 fires on this case with correct reasoning. Test harness `.scratch/cck-da-v2-test.mjs` with `--fixture` (Conv 117 reproduction) + `--counter` (5 hand-built cases, 3 silent / 2 fire — 5/5 pass). Production script at `.claude/scripts/codecheck-deleted-at.mjs` (~95 lines, replaces inline `node -e` in SKILL.md). Live codebase: 0 violations (vs v1's 90 across 18 tables). `w-codecheck/SKILL.md` Check 8 section rewritten with v2 binding-aware approach + calibration history. (Conv 167 surfaced, Conv 168 fixed)

- [ ] **[PD]** Prod cron Worker deploy — block date 2026-04-28 has passed; verify whether prerequisites still hold when next picked up. (Conv 150 inception)

- [ ] **[RSC]** Conditional: pair `-c` with `-v` if MSI rsync ever gains `-v` for diagnostics — watch-task, fires only on a specific edit to one of the three production rsync sites (`r-start/SKILL.md` Step 5.7 Phase 1, `r-commit/SKILL.md` Step 1.5, or `r-end/SKILL.md` Step 5b). Evaluated Conv 157: production rsync invocations don't use `-v`, so the cleaner-audit-logs benefit is invisible. Adding `-c` speculatively is over-engineering. Rewritten as precondition-bound rule to avoid bit-rot — task stays indefinitely until the trigger condition (adding `-v` for diagnostics) is met. (Conv 157)

- [x] **[BIV]** Bilateral verification reminder — retired Conv 155. The /r-start Step 5.7 forensics block (Conv 155) uses `diff -rq` directly, encoding the bidirectional check in code. No remaining manual file-list walks in tree-comparison logic. Reminder superseded by structural fix. (Conv 150 inception; scope tightened Conv 153; retired Conv 155)

- [x] **[MPP]** Memory path portability rewrite — convert hardcoded usernames to portable placeholders. Edited 3 files (`MEMORY.md`, `feedback_git_dash_c_enforcement.md`, `feedback_check_memory_before_directive_save.md`) replacing `/Users/jamesfraser/...` and `/Users/livingroom/...` with `~/projects/...` syntax (tilde expansion works on both machines). Verified end-to-end with `git -C ~/projects/...` runtime tests. (Conv 152)

- [x] **[MPS]** M4Pro memory sync — apply Conv 152 [MPP] + frontmatter fix to converge M4Pro with M4 state. Executed Conv 153: located tarball, backed up M4Pro dir, extracted and spot-checked 4 content differences, applied via rsync, ran full L1-L4 verification ladder (frontmatter clean, path-portability expected 1 hit, byte-equivalent match, tilde-expansion runtime verified). M4Pro now matches M4 byte-for-byte; bidirectional sync ban lifted. (Conv 153)

- [x] **[MSI]** Memory-sync skill integration — skill-based cross-machine memory sync via mirror in-repo, rsync-backed, self-bootstrapping. /r-start syncs mirror→live (mirror frozen at start of conv, live is working copy), /r-commit and /r-end sync live→mirror, git transports state to other machine. No separate manifest or checksum index — git history IS the ledger. Approved design Conv 154; implementation completed: 3 skill files edited (r-start/r-commit/r-end), Step 5.7/1.5/5b added respectively, path derivation via `$HOME` + `${CLAUDE_PROJECT_DIR//\//-}`, mirror dir bootstrapped and committed by Conv 154's /r-end. Conv 155: first cross-machine sync verified (M4Pro /r-start pulled M4's mirror, 51 files byte-identical); presync forensics + data-loss halt added to Step 5.7 (auto-backup on `Only in $LIVE` detection). Conv 156: Step 5.7 redesigned to always-pause on non-empty diff (not just data-loss); two-phase split; three question shapes (empty=silent, normal=yes/no, data-loss=A/B/C+auto-backup). (Conv 154-156)

  - [x] **[MSI-RE]** /r-end Step 5b added (live → mirror rsync before COMMIT). (Conv 154)
  - [x] **[MSI-RC]** /r-commit Step 1.5 added (live → mirror rsync before staging). (Conv 154)
  - [x] **[MSI-RS]** /r-start Step 5.7 added (mirror → live rsync, followed by explicit Read MEMORY.md). (Conv 154)
  - [x] **[MSI-VERIFY]** First end-to-end verification across machines — after M4's /r-end seeds mirror and pushes, M4Pro's next /r-start applies it; validate live dirs match byte-for-byte. (Conv 155 ✓ — 51 files, byte-identical)
  - [x] **[SDD]** /r-start Step 5.7: display incoming-diff inline, not just log — superseded and absorbed by Conv 156 larger redesign (always-pause on non-empty diff).
  - [x] **[MSI-RENAME]** Renamed `feedback_msi_first_sync_data_loss_window.md` → `feedback_msi_sync_user_checkpoint.md` (Conv 157) — filename now matches broadened content. Live updated; /r-commit Step 1.5 propagated to mirror. MEMORY.md link target updated. Historical references in DOC-DECISIONS.md / TIMELINE.md / session extracts left intact (accurate as past state).

## Conv 168 Items

**Completed Conv 168 (cross-block follow-up batch — no single PLAN block advanced):**

- [x] **[CCK-DA]** Conv 168 — `/w-codecheck` Check 8 v2 alias-aware heuristic eliminates 90 v1 false positives across 18 tables; calibrated against actual Conv 117 motivating case via `git show 7df6c02`. See Conv 150-157 Deferred Tasks section above for detail.

- [x] **[MND]** Conv 168 — `detect-machine.sh` hostname match for M4Pro + canonical name migration `MacMiniM4-Pro` → `MacMiniM4Pro` across 11 files. See Conv 150-157 Deferred Tasks section above + DECISIONS.md §4 decision 1.

- [x] **[RAM-NO-NAV]** Conv 168 — `parseNoNav(content)` helper added to `scripts/route-api-map.mjs:90-99`; emit branched (`ℹ️ no-nav by design` vs `⚠️ no discovered path`); applied to `/course/[slug]/[tab].astro` as first instance. Establishes declarative per-route opt-out pattern (vs central whitelist). New `export const noNav = true;` convention; remaining 19 legitimate no-nav routes tracked as `[RAM-NONAV-SWEEP]` below.

- [x] **[PROD-PW]** Conv 168 — Decisions captured in DECISIONS.md §4. Apply tracked as `[PROD-PW-APPLY]` below. See Conv 150-157 Deferred Tasks section above for detail.

- [x] **[XMV]** Conv 168 — Cross-machine path-derivation verification harness built at `.claude/scripts/cross-machine-verify.sh`. Runs 9 canonical path-derivation cases under `HOME=/Users/livingroom` (M4) and `HOME=/Users/jamesfraser` (M4Pro) via `bash -c` subshells, asserts each output matches a structural glob (e.g., `/Users/*/projects/peerloop-docs`), prints side-by-side comparisons, exits non-zero on any case failure. 9/9 pass. Plus `--scan <file>` advisory mode lists every tilde / `$HOME` / `$CLAUDE_PROJECT_DIR` reference in a target file (no pass/fail). Documented under "Cross-Machine Path Verification" subsection in `docs/as-designed/devcomputers.md § Machine Inventory`. Encodes the Conv 162 tilde-everywhere sweep's invariants as a runnable regression test. Retires the recurring "front-load cross-machine verification before locking sweep rules" meta-task that had been in RESUME-STATE for 4 convs.

**New deferred subtasks spawned Conv 168:**

- [x] **[RAM-NONAV-SWEEP]** Conv 169 — Applied `export const noNav = true;` to all 19 remaining legitimate no-nav routes: footer pages (`/about`, `/become-a-teacher`, `/blog`, `/careers`, `/contact`, `/cookies`, `/faq`, `/for-creators`, `/how-it-works`, `/pricing`, `/privacy`, `/stories`, `/terms`, `/testimonials`), `/404`, admin-only `/admin/recordings`, and 301-redirect shims (`/discover/creators`, `/discover/students`, `/discover/teachers`). Scanner now reports `ℹ️ no-nav by design` for all 20 annotated routes (including Conv 168's `/course/[slug]/[tab]`); zero `⚠️ no discovered nav` warnings remain. Verified `tsc --noEmit` clean + `npm run check` clean (0 errors / 0 warnings / 0 hints across 1215 files).

- [→] **[PROD-PW-APPLY]** Conv 169 — Redirected into `DEPLOYMENT.DB-SYNC` (see Active: DEPLOYMENT block above). Discovery: prod D1 has wider drift (missing migrations 0003 + 0004, plus stale `0002_seed.sql` tracker name) that warrants bundling with the password rotation rather than applying in isolation. Bundle when the DEPLOYMENT block is actively worked.

## Conv 169 Items

**Completed Conv 169 (cross-block follow-up batch + Matt design intake — no single PLAN block advanced):**

- [x] **[RAM-NONAV-SWEEP]** Conv 169 — see Conv 150-157 Deferred Tasks section above for detail (19 `.astro` files annotated with `export const noNav = true;` + reason comment; scanner now reports `ℹ️ no-nav by design` for all 20 annotated routes; tsc + astro check clean).

- [x] **[PROD-PW-APPLY-REDIRECT]** Conv 169 — Discovered prod D1 has 3-migration drift (0002 tracker name stale, 0003 + 0004 not applied; `feed_visits` / `feed_activities` missing). Reverted in-flight seed edit. Added new `DEPLOYMENT.DB-SYNC` sub-block bundling password rotation with schema convergence + tracker cleanup (see Active: DEPLOYMENT). Decision recorded in this conv's session doc and extract Decisions §1.

- [x] **[MATT-INTAKE]** Conv 169 — Designer (Matt) hired; received 4 directives (branch `jfg-dev-13-matt` from `jfg-dev-12`, `/matt/` top-level route for coexistence, examine Figma for happy-path pages, extract style guide from Figma). Confirmed: tokens designed as future global default consumed only by `/matt/` initially (per eventual flip plan: `/matt/` → `/`, current `/` → `/fraser`); SVG batch-export over PNG. Figma MCP setup attempt failed (user's account lacks Dev seat — Brian setting up paid account tonight). Pre-execution data gathered: 229 SVG/PNG files exported from Figma (137 MB across `tokens/`, `layout/`, `components/`, `happy path/` in `.scratch/matt-figma/`). Inventory + page-panel notes persisted to `.scratch/matt-figma/_INVENTORY.md` and `.scratch/matt-figma/overview/pages-panel.md`. No code work this conv — plan + execute next two convs.

**New deferred subtasks spawned Conv 169:**

- [→] **[MATT-MCP-RETRY]** Conv 178 — **SUPERSEDED by [MCP-SETUP-WALK]** (see Conv 178 Items below). Original ON-HOLD rationale (Brian's paid-seat blocker) no longer applies — client's Pro Figma account now exists with project loaded. New blocker is MCP server install + token + settings.json config (multi-step user-side work between convs). Track as [MCP-SETUP-WALK] composite. (Conv 169 inception → Conv 171 partial / interim Dev Mode CSS Inspector workaround → Conv 176 ON HOLD → Conv 178 superseded by Pro-account path)

- [→] **[MATT-INVENTORY-CLEANUP]** Conv 170 — Partially addressed by [MATT-ISOLATE] curation pass: the misplaced/typo'd `tokens/color-guide/typograhy-overview.png` was renamed to `typography-overview.png` and moved to `tokens/typography/` *at the copy step into `matt-main`* (source file in `matt-figma` left untouched per "matt-figma is read-only inventory" stance). Classification of the 31 canonical `happy path/Content/Happy/` screens implicitly resolved (they form the core of the curated set). Remaining scope: the original triage of `.scratch/matt-figma/` top-level `happy path/Frame N.svg` items is no longer needed — the curated `matt-main` set is the implementable subset, and the source folder retains everything else for fallback reference. Effectively superseded by `matt-main` + its `_README.md` exclusion table.

- [x] **[MATT-PRE-PLAN]** Conv 173 — Pre-plan landed at `docs/as-designed/matt-pre-plan.md` (~510 lines): 12 sections covering route map (31 Matt screens → 13 `/matt/*` routes), file structure (tokens / layout / components / pages), 8 blocking decisions all resolved with user (see matt-pre-plan.md §4 Resolution summary), Tailwind 4 bridge sketch, page assembly pattern, extrapolation enumeration (11 categories Matt didn't draw + token/primitive gaps), doc graduation criteria, 7-phase execution sequence (`[MATT-EXEC-TKN]` → `[MATT-EXEC-SHL]` → `[MATT-EXEC-PG1]` → `[MATT-EXEC-PRM]` → `[MATT-EXEC-PG2]` → `[MATT-EXEC-EXT]` → `[MATT-EXEC-GRD]`, ~8–11 convs estimate), risk inventory. **8 Decisions resolved Conv 173:** (1=C) Hybrid units rem/px; (2=B) kebab-case for primitives, semantics keep Title/Slash; (3=C) Hybrid Tailwind bridge file; (4=B) Coexist with existing `--color-primary-*`; (5=A) `/matt/` = `/dashboard` analog, visitors → `/matt/login`; (6=B) Rebuild Sidebar as new component; (7=C) Slot-based HeaderBar; (8=A) Omit footer. **Conv 171 misattribution corrected:** original deliverable (d) said "Control Bar = ExploreTabBar re-skin" — Conv 172 spec doc §2 already corrected this: Matt's **Control Bar** is the primary-nav bottom-pill primitive at tablet/mobile (NOT a role switcher); the **Role Tab Bar** is the Peerloop extension for multi-role users — that's the ExploreTabBar re-skin. Spawned 7 new follow-up tasks for phases [MATT-EXEC-TKN] through [MATT-EXEC-GRD] — see new deferred entries below.

## Conv 170 Items

**Completed Conv 170 (Matt design push pre-work — no single PLAN block advanced):**

- [x] **[MATT-ISOLATE]** Conv 170 — Curated `.scratch/matt-figma/` (229 files, 137 MB) → `.scratch/matt-main/` (83 files, 85 MB) as the focused, MacMiniM4-portable build set for the `/matt/*` happy-path pages. Includes: tokens (9 files: 5 color-guide SVGs + 2 typography SVGs + 2 overview PNGs), layout (17 files: page-structure SVGs across breakpoints + primitives + 2 spacing tokens + overview PNG), components (14 files: 13 base-component SVGs + 1 layers-panel PNG), happy-path (42 files: α1 overview + 10 Purpose milestones + 31 canonical Content/Happy/ screens). Excludes Prototype copies, Section Title-N variants, "Why we need it_" justification frames, decorative quotes, social-post mockups, unnamed Frame N items, Matt's Graveyard, and documentation notes (16-row exclusion table in `_README.md`). Fixed `typograhy-overview.png` typo + misplaced location at the copy step. Transferred to MacMiniM4 via Dropbox (per user choice). One curation-pattern learning: pair every inclusion manifest with a per-category exclusion table to prevent re-litigation.

## Conv 171 Items

**Completed Conv 171 (Matt design-system foundation — no single PLAN block advanced):**

- [x] **[MDS]** Conv 171 — Authored `docs/as-designed/matt-design-system.md` (650+ lines) as the durable spec doc for the `/matt/*` design system. Graduated mid-conv from `.scratch/matt-devmode-form.md` after the form had accumulated substantial permanent content (Strategic Context, Architectural Findings, Existing App Context, Open Questions). Six sections: Strategic Context, Architectural Findings (with ASCII layout-shell diagram + roles enumeration), Existing App Context (URL routing, course routes, role-aware components like `ExploreTabBar`/`RoleBadge`, `CurrentUser` singleton, schema role-flag mapping, layout-shell mapping, `?via=` breadcrumb pattern, auth tiers, UI primitives, file-path index), Open Questions (6 outstanding), Color Primitives (12 hex codes extracted), Token Extraction (working section with Batches 1–5 in-progress). `.scratch/matt-devmode-form.md` deleted. `docs/INDEX.md` updated with entry under "How Should It Look/Work?" 🚧 working-draft marker. Established 2 patterns: form-graduation (.scratch → docs/as-designed when content stabilizes at 60%+ permanent) and Figma-Variable-naming-verbatim (Title-Case-Hyphenated CSS custom property names matching Matt's Dev Mode exports, e.g., `--Text-Default` not `--color-text-default`).

- [x] **[MDM]** Conv 171-172 — Created TodoWrite task #13 with full 5-batch Figma Dev Mode extraction form. **Completed Conv 172**: all 5 batches resolved + 5 bonus batches scaffolded. Batch 1 (Typography) COMPLETE Conv 171: all 9 header + 9 body roles measured via Figma Dev Mode + user data entry. Batch 2 (Page Structure) COMPLETE Conv 172: Desktop / Tablet Portrait / Mobile all filled with breakpoint-varying Header Bar slot (Desktop = breadcrumb; Tablet Portrait = brand strip; Mobile = brand + Messages + Notifications icons) + Sub Nav drawer-at-Mobile pattern + per-bar positioning. Batch 3 (Spacing) COMPLETE Conv 172: full 10-token Tailwind-aligned 4-base scale + snap table (17→16, 23→24, 44/49→48; 168px preserved as one-off literal). Batch 4 (Inner Grid) COMPLETE Conv 172: working answer — no formal multi-column grid in Matt's design; ad-hoc `grid grid-cols-N` per page shape. Batch 5 (Control Bar) RESOLVED Conv 172: Control Bar = Matt's primary-nav primitive on tablet/mobile (NOT a role switcher); §6 Batch 5 reframed as Role Tab Bar (Peerloop extension, not in Matt's design). Bonus Batches 6-10 scaffolded Conv 172: Border Radius (9), Shadows (7), Opacity (15), Z-index (7), Animation Durations (8). **All 35 Figma Variables extracted** across 5 collections (Color Primitives 15, Color Semantics 14, Entity 2×4=8 cells, Icon Size 1×2=2 cells, Button 3×6=18 cells with resolved-hex review row). Multi-mode pattern documented as system-wide CSS variable cascade architecture.

- [x] **[MATT-MCP-RETRY]** Conv 171 (partial) — Confirmed MCP still not set up (Brian's paid Figma seat not yet provisioned). User adopted Figma Dev Mode CSS Inspector + paste-screenshot workflow as viable interim. Task remains open for genuine MCP setup retry on next conv.

**Updated task descriptions (Conv 171):**

- [→] **[MATT-PRE-PLAN]** Conv 171 — Description updated with strategic context (Matt = designer / user = architect authority split, /matt/* = visual re-skinning of existing role-aware infrastructure not new architecture, happy path = calibration set / rest of app = extrapolation test). Primary input now `docs/as-designed/matt-design-system.md` (replacing `.scratch/matt-devmode-form.md`). Plan structure extended with deliverables (g) Extrapolation enumeration and (h) Doc graduation. Decisions captured: Visitor = unauthenticated UI state (no schema change); CSS variable names match Matt's Figma Variable naming verbatim; /matt/* scope strictly visual re-skin.

**New deferred subtasks spawned Conv 171:**

- [→] **[MDS-OQ]** Conv 173 — Substantially absorbed by `matt-pre-plan.md` §4 decisions: **Q7** (naming) resolved by Decision 2 (kebab-case for primitives; semantics keep Title/Slash); **Q8** (units) resolved by Decision 1 (Hybrid rem/px); **Footer presence** resolved by Decision 8 (Omit); **Visitor flow on Member-only pages** resolved by Decision 5 (`/matt/` member-only, visitors → `/matt/login`); **Inner column grid** working answer formalized in pre-plan §6 (no formal multi-column grid). Remaining: Account dropdown placement, Featured-course-card variant, Free Teacher badge component, **Q9** Distinct Main Panel inner layouts — all deferred to execution-phase implementation (`[MATT-EXEC-PG1]` through `[MATT-EXEC-PG2]`) where each page's exact layout will be discovered against Matt's screens.

- [x] **[MDM-TAIL]** Conv 172 — Completed alongside [MDM]: all 5 batches resolved + 5 bonus batches scaffolded. See Conv 172 Items below for detail.

- [ ] **[MATT-TYPO-EXERTISE]** Flag typo to Matt: "Exertise" → "Expertise" on Teacher Profile page header.

- [ ] **[MATT-DOC-READ]** Read 3 design-relevant docs not yet read this conv before [MATT-PRE-PLAN] starts: `docs/as-designed/orig-pages-map.md`, `docs/GLOSSARY.md`, `docs/DECISIONS.md` (latter for the existing role/auth decisions that bound visual re-skin scope).

## Conv 172 Items

**Completed Conv 172 (MATT-DESIGN-PUSH active — Matt design-system extraction + token scaffolding):**

- [x] **[MDS-EXPAND]** Conv 172 — Major refinement pass on `docs/as-designed/matt-design-system.md` (650 → 1169 lines). §2 architectural findings extended (Header Bar slot multi-content per breakpoint; Sub Nav drawer at Mobile; Control Bar correctly attributed as primary-nav primitive; Role Tab Bar added as Peerloop extension; Matt-composes-pages-from-components meta-principle). §4 restructured + Q7 (naming) + Q8 (units) + Q9 (Main Panel layouts) added — 9 open questions total. §5 closed: full Variable Collection Inventory + 35 variables across 5 collections (Color Primitives 15, Color Semantics 14, Entity 2×4, Icon Size 1×2, Button 3×6 with resolved-hex review row) + unified Multi-mode pattern finding. §6 renamed to "Token Extraction & Scaffolding"; Token Scaffolding Policy added; Batch 2 filled for all breakpoints; Batches 6-10 scaffolded (Border Radius, Shadows, Opacity, Z-index, Animation Durations). New Source Materials section catalogues 8 source PNGs in `docs/as-designed/figma-screenshots/` (committed ~480KB).

- [x] **[MDM]** Conv 172 — All 5 original batches resolved + 5 bonus batches scaffolded. See updated [MDM] entry under Conv 171 Items above.

- [x] **[MDM-TAIL]** Conv 172 — Closed via [MDM] completion. Batch 2 Tablet + Mobile filled; Batch 3 spacing scale resolved with full 10-token scale; Batch 4 inner grid working answer captured (no formal grid in Matt's design); Batch 5 Control Bar reframed as Role Tab Bar (Peerloop extension).

**Strategic decisions captured Conv 172:**

- **Token Scaffolding Policy** (Decision §1) — Adopt complete standard scale from day 1 across ALL unformalized token types (spacing, border-radius, shadows, opacity, z-index, animation durations). Pixel-named tokens (`--space-4` = 4px). Snap policy: Matt's off-scale measurements within 1-3px of a scale value are snapped (17→16, 23→24, 49→48, 44→48).

- **Control Bar disambiguation** (Decision §2) — Matt's Control Bar = bottom-nav primary-nav strip primitive (appears on tablet portrait + mobile; absent on desktop where Sidebar carries primary nav). Role-perspective switching is Peerloop's extension: **Role Tab Bar**, NOT in Matt's design (his brief was deliberately single-role).

- **Component composition principle** (Decision §3) — Every Matt component becomes a React or Astro component with parameters. Variant props (literal union types) for multi-mode components. Astro for static shells, React for interactive UI. Slots/children for content composition. No one-off pages.

- **Preserve cascade chains in CSS** (Decision §4) — Author CSS variables to preserve Matt's full indirection chain. Downstream semantics reference upstream semantics, NOT the primitives they resolve to. The cascade IS the design system's resilience.

- **Source artifacts committed** (Decision §5) — Figma source screenshots committed to `docs/as-designed/figma-screenshots/` for traceability.

**New deferred subtasks spawned Conv 172:**

- [ ] **[RTB]** Design Role Tab Bar — Peerloop extension to Matt's design (multi-role perspective switcher; Matt's brief was single-role). Created Conv 172 (TodoWrite #14). Extrapolate from Matt's tokens + existing `ExploreTabBar` (Conv 042-044). Deferred to [MATT-PRE-PLAN].

- [x] **[TSV]** Conv 181 — Token Scaffolding Verification COMPLETE via [MMP-PH1] direct-probe sweep. **12 Color Variables verified** (10 hits + 2 Conv 172 speculative isolated to "Speculative (Conv 172)" sub-blocks across 3 files); false naming-drift alarm corrected (`Primary/Default` was actual Variable name; "Primary/Primary" was plugin-rendered Color Guide label artifact). **18 Typography Variables canonized** (8 Body + 10 Header) into new `src/styles/tokens-typography.css` (124 lines, two leading regimes: Body small 12-14px lh:1 ls:0 / Body large 16-20px lh:1.5 ls:-2.2px / Headers lh:1 ls:0); bridge typography section rewritten with all 18 Tailwind 4 `--text-{name}--<modifier>` utility classes carrying size+weight+lh+ls in one class. Critical drift identified + fixed: local `text-h1` utility had no weight (browser bold 700); Matt's Headers carry Medium 500 / Semi Bold 600. Original (b) Mobile Header Bar height snap deferred — not reached this conv. (c) extrapolated scales N/A since the verification revealed Variables exist for most categories. `[TWLG-MIN-H]` arbitrary-value behavior not investigated this conv (separate sub-issue).

- [ ] **[MATT-MAX-WIDTH]** Confirm Matt's intent on Desktop max-width (asked externally Conv 172; non-blocking with fluid-width fallback). Inline doc tracking, no separate task escalation needed.

- [ ] **[MATT-REACT-ICON-DEFAULT]** Change React icon default for `/matt/*` from `h-5 w-5` (= 20px = Matt's Small mode) to `h-6 w-6` (= 24px = Matt's Medium mode) for prominent contexts. Deferred to [MATT-PRE-PLAN].

## Conv 174 Items

**Completed Conv 174 (MATT-DESIGN-PUSH active — Phase 1 + Phase 2 of `matt-pre-plan.md` §9 execution):**

- [x] **[MATT-EXEC-TKN]** Conv 174 — Phase 1 complete. See MATT-DESIGN-PUSH Execution Phases below for detail.

- [x] **[MATT-EXEC-SHL]** Conv 174 — Phase 2 complete. See MATT-DESIGN-PUSH Execution Phases below for detail.

**Strategic decisions captured Conv 174:**

- **§1 Include `--spacing-N` in Tailwind bridge (accept global utility-scale break)** — Pre-authoring audit found 572 `p-4` callsites + many `m-N`/`gap-N`/`px-N` in existing app. Adding `--spacing-4: 0.25rem` (Matt's 4px) overrides Tailwind's default `p-4=1rem` globally on this branch. User chose option B (include per pre-plan §5) over option A (omit) or C (Matt-namespace). Consequence: all `p-N`/`m-N`/`gap-N`/`px-N`/`py-N` callsites on `jfg-dev-13-matt` where N ∈ {4,8,12,16,20,24,32,40,48,64} now resolve to Matt's pixel-named values. Effective scale is mixed (`p-1=4` multiplicative; `p-4=4` overridden; `p-5=20` multiplicative). `jfg-dev-12` and earlier branches unaffected — change is scoped to `jfg-dev-13-matt` until flip.

- **§2 Branch `jfg-dev-13-matt` created from `jfg-dev-12` for /matt/* coexistence** — per matt-pre-plan.md §1 directive. All Conv 174 code commits land on `jfg-dev-13-matt`; docs commits remain on `main`.

**Patterns established Conv 174:**

- **Tailwind 4 `@theme` tokens emit on-demand, not eagerly** — Phase 1's built CSS contained ZERO of Matt's bridge color tokens (`--color-text-default`, `--color-course-primary`, etc.) because no component consumed them yet. Phase 2 components then used them → rebuilt CSS contained all of them. Verification protocol when adding new bridge tokens = "write component that consumes it, rebuild, re-grep dist/" — don't panic if a freshly-authored bridge token isn't in `dist/` until a component exercises it. (Learning #1)

- **`--spacing-N` overrides Tailwind utility scale globally, not additively** — Setting `--spacing-N: VALUE` in `@theme` overrides the `p-N`/`m-N`/`gap-N` utility rule globally for that N. Audit usage first (`grep -rho 'p-[0-9]+'`) and decide explicitly: override, namespace, or omit. Don't follow a spec doc's bridge sketch literally without checking utility-class collision. (Learning #2)

- **Matt's 2-layer + 3-layer cascade preserves correctly when authored as `var()` chains** — Authored `--Student-Primary: var(--Primary-Default)` instead of flat primitive ref. Browser resolves CSS variable chains lazily — `:root` declaration order doesn't matter; chains work as long as each link is defined on the matching cascade context. Never flatten when extracting a design system that uses semantic-to-semantic refs — the cascade IS the value. (Learning #3)

**New deferred subtasks spawned Conv 174:**

- [ ] **[MND2]** `detect-machine.sh` still returns `Unknown (M4Pro.local)` on M4Pro despite Conv 168 [MND] fix. Verified live: `hostname -s` returns bare `M4Pro` and case patterns `*M4Pro*` + `*M4-Pro*` either don't match or hostname is read in a form with `.local` suffix the glob misses. `~/.claude/.machine-name` cache file persists the stale value across sessions — must be refreshed to test. Conv 174 used canonical "MacMiniM4Pro" in commits per prior-commit precedent.

- [x] **[MSH-REFINE]** Conv 175 — Phase 2 MattLayout shell refinements completed. (a) Tailwind `lg:` breakpoint shifted 1024→1025px via `--breakpoint-lg: 1025px` global override in `tokens-tailwind-bridge.css @theme` (single source of truth, propagates to all `lg:*` callsites in both matt/* and legacy fraser/*); (b) tablet HeaderBar top:48px applied; (c) tablet main content `pt-[88px]` clearance applied. Also cleaned HeaderBar.astro: removed dead `<slot>{fallback}</slot>` content from 3 slot wrappers (defaults moved to AppLayout per slot-forwarding fix — see Decision 2 below); docstring updated to point to AppLayout for defaults and cross-reference `memory/reference_astro_slot_forwarding.md`. `npm run check` clean (0 errors, 0 warnings, 1 pre-existing hint).

- [x] **[MSH-VIZ]** Conv 175 — Phase 2 shell preview validated in browser. Created `/matt/index.astro` stub (5750 B, gated `noNav`) exercising every AppLayout slot for breakpoint regression checks. Confirmed shell renders at desktop (1300×713) + tablet (800×900) + mobile. Diagnosed and fixed Astro slot-forwarding suppression bug: `<Fragment slot="x"><slot name="y" /></Fragment>` in AppLayout marked HeaderBar's slot as "filled (with empty content)" even when the page didn't fill the inner slot, suppressing HeaderBar's `<slot name="x">FALLBACK</slot>` fallback. `Astro.slots.has + &&` short-circuit fix DID NOT work (root cause unconfirmed). Durable fix landed: moved defaults from HeaderBar to AppLayout via ternary inside *unconditional* Fragments (`{Astro.slots.has('x') ? <slot name="x" /> : <span>default</span>}`). Saved `memory/reference_astro_slot_forwarding.md` documenting the bug + repro pattern + failed-fix attempt + durable fix.

**Carry-forward observations (next conv):**

- Phase 2 visual validation completed Conv 175 via `/matt/index.astro` stub ([MSH-VIZ]). Phase 3 [MATT-EXEC-PG1] also completed Conv 175 — `/matt/course/[slug]` page renders end-to-end with iterative visual-diff against Matt's `Course.svg`. Phase 4 [MATT-EXEC-PRM] scope A (Button/Card/SectionTitle) landed and retrofitted.

## Conv 175 Items

**Completed Conv 175 (MATT-DESIGN-PUSH active — Phases 2 visualization, Phase 3 first page, Phase 4 scope A primitives):**

- [x] **[MSH-VIZ]** Conv 175 — see Conv 174 Items deferred subtasks above for detail (`/matt/index.astro` stub + Astro slot-forwarding bug diagnosis + durable fix in AppLayout + `memory/reference_astro_slot_forwarding.md`).

- [x] **[MSH-REFINE]** Conv 175 — see Conv 174 Items deferred subtasks above for detail (Tailwind `--breakpoint-lg: 1025px` global override + HeaderBar dead-fallback cleanup + docstring update).

- [x] **[MATT-EXEC-PG1]** Conv 175 — see MATT-DESIGN-PUSH Execution Phases below for detail (first `/matt/course/[slug]` page end-to-end; `CourseHeader.astro` entity primitive; thin page composition with `fetchCourseTabData` loader; SubNav 7 tabs; About body 4 Cards).

- [x] **[MATT-EXEC-PRM]** Conv 175 — scope A complete (3 of 8 primitives); see MATT-DESIGN-PUSH Execution Phases below for detail (Button/Card/SectionTitle + CourseHeader CTA + course-page body retrofit + visual-diff iteration vs Matt's `Course.svg`).

**Strategic decisions captured Conv 175:**

- **Slot-forwarding fix lives in AppLayout via unconditional Fragment + ternary** — single source of truth for defaults at the layout consumer; HeaderBar becomes a pure shell primitive with no slot fallbacks. Trade-off: pages using HeaderBar directly (without AppLayout) lose the defaults — acceptable per HeaderBar's docstring noting direct use is rare.

- **Tailwind `lg:` breakpoint shifted 1024→1025px globally** via `--breakpoint-lg: 1025px` in `tokens-tailwind-bridge.css @theme`. Single source of truth, propagates to every `lg:*` callsite in both matt/* and legacy fraser/* pages. Matches Matt's spec exactly. Visual impact only at the 1024px edge case. Same low-blast-radius reasoning as Conv 174 global spacing override.

- **Phase 4 scope A: ship Button + Card + SectionTitle + retrofit, defer 5 primitives** — highest-leverage primitives (used everywhere) shipped first; retrofitting existing CourseHeader CTA and About body produces immediate visible improvement. Remaining 5 primitives are dep'd on Phase 5 pages.

- **"What's included" lives in the CourseHeader hero overlay, not the About body** — matches Matt's design; hero is the conversion-density block. CourseHeader takes `includes` prop; body now has 4 Cards (About / What you'll learn / Prerequisites / Who this is for) instead of 5.

- **"Meet the Creator" is a SubNav tab, not an About body section** — matches Matt's design. Creator-tab route deferred to Phase 5 as `[MATT-CREATOR-TAB]`. Course-page SubNav now: About / Course Feed / Modules / Meet the Creator / Teachers / Reviews / Resources.

**Patterns established Conv 175:**

- **Matt-page assembly pattern** — thin page (<100 lines) composing `AppLayout(entity=course) → CourseHeader → SubNav → body Cards with SectionTitle headings`. First instance at `src/pages/matt/course/[slug]/index.astro`; follow this shape for future /matt/* pages.

- **AppLayout slot-default pattern** — defaults live in AppLayout via ternary inside *unconditional* Fragments using `Astro.slots.has()` to decide between page override and default. Primitives (HeaderBar) carry no slot fallbacks.

- **Visual-diff symlink pattern** — `public/_matt-ref/` (gitignored or removed pre-commit) symlinks Matt's Figma SVG exports so chrome can fetch them for side-by-side diff. Use BEFORE building, not after. Pre-plan §9 visual-validation gate has to fire BEFORE the structural build, not after (Conv 175 learning: built Phase 3 + Phase 4 entirely against pre-plan prose without opening Matt's SVG; visual was far off; mid-conv pivot to symlink-diff worked but should have been Step 1).

**New deferred subtasks spawned Conv 175:**

- [ ] **[MATT-COURSE-POLISH]** Body section visual polish — user noted "items in front of the page need work" after hero refinement landed. Course page body Cards (About / What you'll learn / Prerequisites / Who this is for) need typography/spacing/visual tuning to match Matt's `Course About.svg`.

- [x] **[MATT-ICON-SWAP]** Conv 194 — **DONE on the inline-SVG goal.** The original target (`CourseHeader.astro` inline-SVG paths) no longer exists — the file became `CourseHeader.tsx`, which has 0 inline SVGs and uses full MattIcon; the live `CourseHero.tsx` also has 0 inline SVGs (uses `@components/ui/icons` React primitives). Residual: the live hero is still on the legacy icon set, not MattIcon → folded into [MATT-EXEC-EXT] (Phase 6) as the live-hero→MattIcon migration.

- [→] **[MATT-CREATOR-TAB]** Conv 186 — **REPLACED by [MATT-SUBNAV-ROUTING]** (see Conv 186 Items below). Course SubNav routing pattern resolved as `/matt/course/[slug]/[...tab].astro` mirroring existing `/discover/course/[slug]/[...tab].astro` — Creator is now one of 6 tabs in `VALID_TABS = ['about','modules','reviews','resources','teachers','creator']`, not a separate route.

- [ ] **[TWLG-MIN-H]** Tailwind 4 arbitrary-value `min-h-[480px]` (and later `min-h-[240px]`) didn't take effect on `CourseHeader.astro` despite the class appearing in rendered HTML — Tailwind didn't generate the CSS rule. Workaround: inline `style="min-height: 240px"` in the bgStyle string. Suspect interaction with Conv 174 `--spacing-*` global override (the override may affect Tailwind 4's arbitrary-value parsing for height-axis utilities). Root cause + fix is a `[TSV]` follow-up — when bundling all breakpoint/spacing discrepancies together, audit arbitrary-value behavior too.

## Conv 176 Items

**Completed Conv 176 (MATT-DESIGN-PUSH active — Phase 4 scope B remaining 5 primitives + Astro-Cloudflare landmines research):**

- [x] **[MATT-EXEC-PRM-2]** Conv 176 — see MATT-DESIGN-PUSH Execution Phases below for detail (5 primitives `Module.tsx` / `Note.tsx` / `ToDoItem.tsx` / `SocialPost.tsx` / `RoleTabBar.tsx` + `_SocialPostDemo.tsx` internal wrapper + showcase wired into `/matt/index.astro` Phase 4 Primitives section + tsc + astro check clean).

- [⏸️] **[MATT-MCP-RETRY]** Conv 176 — Put **ON HOLD** per user direction (external Figma paid-seat blocker indefinite). Updated entry under Conv 169 Items above with on-hold rationale + reassess trigger.

**Strategic decisions captured Conv 176:**

- **Refactor `ToDoItem` from hybrid controlled+uncontrolled to fully controlled (no `useState`)** — Triggered by `[DSSR-SCOPE]` React-hooks-null SSR crash cascading from ToDoItem's `useState` through Sidebar.tsx, zero-ing the entire page body. Discipline rule established: matt/* primitives must be stateless / fully controlled until `[DSSR-SCOPE]` upstream-fixed.

- **Direct entity-specific Tailwind utilities, not `.entity-*` cascade, inside matt/* primitives** — Matt's documented multi-mode cascade (`:root` default → `.entity-student` override → `bg-entity-background` consumer) does not propagate empirically through Tailwind 4's `@theme`-generated intermediates; renders as `:root` default (grey) regardless of overriding class. Switched Module + ToDoItem to direct `bg-{course,student,creator}-background` utilities matching `Button.tsx`'s six-variant pattern. Reserve cascade for non-primitive components consuming `var(--Entity-Background)` directly. Tracked as `[CASCADE-BROKEN]` for root-cause investigation.

- **Extract `_Demo.tsx` for rich JSX showcase content; don't inline in `.astro`** — Astro `.astro` expression-block parser rejects `<div className=…>` AND `<div class=…>` AND inline `<svg viewBox=…>` (only accepts component references). Web research confirmed by-design Astro behavior (roadmap discussion #716 tracks broader JSX support; no upgrade fixes this). Pattern: extract embed JSX into underscore-prefixed React file, reference from `.astro` as `<SomeDemo />`.

- **Upgrade Astro stack next conv + retry the canonical [DSSR-SCOPE] dedupe/noExternal workaround** — `[NPM-UP]` task #29 created as **🔝 LEAD NEXT-CONV ITEM**. Web research findings: (1) Astro issue #16529 still open on versions newer than ours (6.2.0 + adapter 13.3.0), but Cloudflare workers-sdk #11825 closed with workaround; (2) `@astrojs/cloudflare 13.5.4` added optimizeDeps-forwarding-to-SSR which is the plausible missing piece that made Conv 122's earlier dedupe attempt fail; (3) Astro 6.3.7 may have addressed `[TWLG-MIN-H]` and `[AAP]`. Procedure: upgrade astro `6.1.5 → 6.3.7`, `@astrojs/cloudflare 13.1.8 → 13.5.4`, `@astrojs/react 5.0.3 → 5.0.5`; apply `resolve.dedupe: ["react", "react-dom"]` + `ssr.noExternal: ["react", "react-dom"]` in Vite config; verify by reverting ToDoItem to hybrid form with `useState`.

**Patterns established Conv 176:**

- **`qlmanage` SVG→PNG visual inspection** — `qlmanage -t -s 1200 -o /tmp file.svg` rasterizes SVG to a Read-tool-viewable PNG (~1 sec per SVG). Bypasses both the SVG-text-too-dense-for-Read issue and the no-Chrome-MCP-driving issue. Should be added to `[MPV]` workflow / `matt-pre-plan.md`.

- **`_Demo.tsx` extraction for rich JSX showcase content** — underscore-prefixed React component files alongside primitives; `.astro` showcase pages mount them as single component references. Avoids Astro expression-block JSX restrictions.

- **Stateless matt/* primitives discipline** — no `useState` / `useEffect` in primitive components until `[DSSR-SCOPE]` resolves. Parent owns state; primitives are fully controlled. (Same shape as existing `Button.tsx` / `Card.astro` / `SectionTitle.astro`.)

- **Direct entity utility per variant** — match `Button.tsx` pattern (`bg-{course,student,creator}-background` keyed by `entity` prop) instead of relying on `.entity-*` cascade.

**New deferred subtasks spawned Conv 176:**

- [x] **[DSSR-SCOPE]** Conv 177 — **RESOLVED.** Root cause was NOT React/Cloudflare-adapter dual-copy as Conv 122/176 hypothesized; it was Vite's default lazy dep discovery causing a cold-start race (documented industry-wide: Remix #10156, TanStack/router #4264, Storybook #32049, vitejs/vite #17979). First SSR request triggers Vite to find a new import → re-optimize `node_modules/.vite/deps_ssr/` → reload bundled React → in-flight render crashes with null hooks dispatcher → response body cut off mid-attribute. Subsequent requests work; production builds unaffected entirely. **Fix:** `astro.config.mjs` `vite.optimizeDeps.entries: ['src/**/*.tsx', 'src/**/*.ts', 'src/**/*.astro']` + `include: ['astro/virtual-modules/transitions.js']`. Verified: cold-start /matt/ now succeeds first request (240839 bytes, all primitives rendered, `</html>` closed, 0 ERROR lines, 0 mid-session re-optimize); production build clean in 7.27s; preview /matt/ 30564 bytes, all 13 primitives present. Sidebar.tsx `useState` works fine. DEV-STAGING-SSR row removed from ON-HOLD. Conv 176 stateless-primitives discipline retired from DEVELOPMENT-GUIDE.md.

- [x] **[NOTE-YELLOW]** Conv 181 — Resolved by **hardcoding inline, NOT adding new token.** `get_design_context(652:8646)` probe revealed Matt's yellow (`#FFF6B8` background + `#F1E9B0` border) is hardcoded hex in Figma, NOT a Variable — no `--note-yellow` to surface. Note.tsx aligned to exact Figma spec: yellow hex corrected (`#FFF1B8` → `#FFF6B8`), 1px border `#F1E9B0` added, radius 12→8, padding 16→10, gap 8→10, shadow `shadow-sm` → exact custom value, `leading-relaxed` removed (drift vs `text-body-default` canonized lh:1). All values inline as Tailwind arbitrary values per new **tokenize-only-matt-variables principle** (`memory/feedback_tokenize_only_matt_variables.md`): token-ify what Matt has tokenized; hardcode what Matt has hardcoded; honest-orphan rule.

- [ ] **[CASCADE-BROKEN]** Conv 176 — `.entity-*` multi-mode cascade NOT propagating through Tailwind `bg-entity-background` empirically (despite logically-correct CSS chain per spec). Active background renders as `:root` default (`--gray-100`, grey) instead of overridden `--Student-Background` (pastel-blue). Suspect Tailwind 4's `@theme`-generated `--color-entity-background` is computed once at `:root` time rather than re-resolving per-element, OR Vite's transform inlines the value statically. Workaround landed Conv 176 (matt/* primitives use direct `bg-{entity}-background` utilities). Need: isolated repro outside of full app shell (probably 5-min minimal HTML test) → decide whether to fix the cascade OR retire the pattern from `matt-design-system.md §5`. Load-bearing for `CourseHeader.astro` / `TeacherHeader` inheritance if those use the cascade — verify under same investigation.

- [x] **[NPM-UP]** Conv 177 — **COMPLETE.** Astro stack upgraded: astro 6.1.5→6.3.7, @astrojs/cloudflare 13.1.8→13.5.4, @astrojs/react 5.0.3→5.0.5, wrangler 4.81.1→4.94.0 (initial install hit ERESOLVE — `@astrojs/cloudflare@13.5.4` requires `wrangler@^4.83.0`; added wrangler@4.94.0 to upgrade set per Solution Quality default-durable). Canonical Vite dedupe workaround attempted in `astro.config.mjs` but FAILED — Sidebar.tsx still crashed on cold-start with same symptom. **Real root cause found via web research (Remix #10156, TanStack #4264, Storybook #32049, vitejs/vite #17979):** Vite cold-start dep-discovery race, NOT dual React copies. First SSR request triggers Vite to find a new import → re-optimize `node_modules/.vite/deps_ssr/` → reload bundled React → in-flight render crashes with null hooks dispatcher. Subsequent requests work; production builds unaffected. **Working fix:** `astro.config.mjs` `vite.optimizeDeps.entries: ['src/**/*.tsx', 'src/**/*.ts', 'src/**/*.astro']` + `include: ['astro/virtual-modules/transitions.js']` (entries alone was insufficient because Astro virtual modules aren't reachable via src/ scanning). Verified: cold-start /matt/ now succeeds first request (240839 bytes, all primitives rendered, `</html>` closed, 0 ERROR lines); production build clean in 7.27s; preview /matt/ 30564 bytes, all 13 primitives present. ToDoItem.tsx rewritten as controlled-or-uncontrolled hybrid (proper React idiom). Sidebar.tsx flex-shrink-0→shrink-0 (Tailwind v3→v4 rename, caught by /w-codecheck). DEVELOPMENT-GUIDE.md stateless-primitives section replaced with "Vite SSR Cold-Start Dep Discovery" section. api-test-helper.ts logger no-op stub added (Astro 6.3 APIContext addition). HeaderBar.astro Props cast fix + CourseHeader.astro dead Button import removed (astro check hints). /w-codecheck all 8 PASS.

## Conv 177 Items

**Completed Conv 177 (MATT-DESIGN-PUSH active — Astro stack upgrade + DSSR-SCOPE root-cause + fix):**

- [x] **[NPM-UP]** Conv 177 — see Conv 176 Items deferred subtasks above for detail (astro 6.1.5→6.3.7, @astrojs/cloudflare 13.1.8→13.5.4, @astrojs/react 5.0.3→5.0.5, wrangler 4.81.1→4.94.0; canonical dedupe workaround failed; real fix is `vite.optimizeDeps.entries` + `include: ['astro/virtual-modules/transitions.js']`).

- [x] **[DSSR-SCOPE]** Conv 177 — see Conv 176 Items deferred subtasks above for detail (root cause = Vite cold-start dep-discovery race, NOT dual React copies; fix in `astro.config.mjs` Vite config; ON-HOLD DEV-STAGING-SSR row marked RESOLVED; Conv 176 stateless-primitives discipline retired).

**Strategic decisions captured Conv 177:**

- **Pair wrangler upgrade with the Astro stack upgrade** — `@astrojs/cloudflare@13.5.4` requires `wrangler@^4.83.0` (project had 4.81.1). Chose adding `wrangler@4.94.0` to the upgrade set (option B) over `--legacy-peer-deps` (papers over real version skew). Per CLAUDE.md §Solution Quality: default to durable.

- **Retire the stateless-primitives discipline** — Conv 176's discipline ("matt/* primitives must be stateless / no useState") was responding to a misdiagnosed problem. Real bug is fixable with a 2-line config change. DEVELOPMENT-GUIDE.md section replaced with "Vite SSR Cold-Start Dep Discovery" documenting the real bug class + fix recipe + symptom signature for future recurrence detection.

- **ToDoItem uses controlled-or-uncontrolled hybrid pattern** — three valid API shapes considered (fully controlled / uncontrolled only / hybrid); chose hybrid matching React standard idiom. Existing showcase callsites with `checked={false}`/`checked={true}` keep working (controlled, no onChange = no toggle); future production callers can use either mode.

- **Don't downgrade React to 18.2** — technet-experts article suggested React 19→18.2 downgrade as a "stable" fix; rejected because Vite cold-start pattern affects React 18 projects too (Storybook #32049, Remix #10156 reporters on R18). The crash isn't a React-version problem.

**Patterns established Conv 177:**

- **Diagnostic checklist for SSR hook crashes:** (1) Does the same request reliably reproduce after fresh server start? → cold-start race (this class). (2) Does the crash persist across multiple requests? → duplicate React copies (#11825 class). (3) Does production build reproduce? → fundamental config issue. Two crash classes share the same error message — distinguish by request-order behavior.

- **Astro virtual module pre-bundling:** any Astro virtual module that appears in `✨ new dependencies optimized: <X>` dev log should be added to `optimizeDeps.include`. New Astro features that introduce new virtual modules may need re-adding.

- **Cheap order-dependence probes falsify "structural" diagnoses:** when a hypothesis requires increasingly elaborate explanations to fit the data, test for order-dependence/cache state before adding complexity. A second probe of an earlier-failing condition (e.g., `/matttest` probe Conv 177) can break a "structural" illusion cheaply.

**New deferred subtasks spawned Conv 177:**

- None — all surfaced issues fixed inline this conv.

## Conv 178 Items

**Completed Conv 178 (MATT-DESIGN-PUSH active — Phase 4.5 [MATT-EXEC-CMP] scoped + CMP-ICN harvest phase):**

- [x] **Phase 4.5 [MATT-EXEC-CMP] scoped** — 8 dependency-ordered subtasks (CMP-ICN → CMP-BTN → CMP-MNV → CMP-SNV → CMP-ENT → CMP-CHT → CMP-PNC → CMP-BRN) inserted between Phase 4 (PRM-2 complete) and Phase 5 (PG2 pending). `matt-pre-plan.md` §9 row added; total convs estimate revised 8–11 → 10–15. TodoWrite #32 parent + #33-#40 subtasks; #34/#35/#36/#38/#39 (icon-consumers) blocked by #33 (CMP-ICN); PG2 (#2) blocked by #32.

- [x] **[MATT-EXEC-CMP-ICN]** Conv 178 harvest + Conv 182 code-integration **COMPLETE** — folded into [MMP-PH2]. See MATT-DESIGN-PUSH Execution Phases below for detail.

- [x] **Time-bounded resource harvest pivot** — Mid-conv discovered Figma Dev Mode trial ends today; drafted `.scratch/matt-figma-extraction-today.md` (~250 lines, 3-tier priority structure); pre-created 9 subfolders under `.scratch/matt-main/components/{icons,buttons,main-nav,sub-nav,entities,chat,post-anchors,brand,dev-mode-css}/`. Pro-account pivot superseded the deadline framing but the harvest workflow established the pattern.

- [x] **Buttons reconnaissance discovered 3-orthogonal-dimension architecture** — Color via Variable Mode × State via Property 1 × Size via 5 frame cells (NOT flat 6×3 matrix as spec doc §6 framed). Matt's button CSS uses `var(--Background)`/`var(--Border)` — validates [CASCADE-BROKEN] as implementation issue, not design choice.

- [→] **Pro account pivot — MCP setup required between convs** — Confirmed via ToolSearch no Figma MCP connected this conv. End-conv + off-conv MCP setup + /r-start fresh is the correct sequencing (MCP loads at session start).

**Strategic decisions captured Conv 178:**

- **Insert Phase 4.5 [MATT-EXEC-CMP] between Phase 4 and Phase 5** — Phase 5 = 12 routes across multiple convs; without CMP, each route fragments component-build decisions across convs and risks inconsistency. Numbering as 4.5 (not re-numbering 5→6) keeps `matt-pre-plan.md` §9 phase anchors stable.

- **Dependency-ordered CMP subtasks with Icons foundational** — Icons consumed by every other component (Buttons icon-leading, Main Nav, Sub Nav, Chat, Post Anchors); wired in TodoWrite as #34/#35/#36/#38/#39 blocked by #33. Prevents future conv from picking up CMP-BTN before icons exist.

- **Catalogue-label-is-authority for naming** — Matt's catalogue labels override both Figma's auto-export filenames (Material-Icon source names) AND visual-inference guesses. Renamed `newspaper→feed`, `mail→message`, `calendar_month→calendar`; Property variants flattened per Matt's terms (Arrow not Chevron; Level; Bookmark default/filled).

- **Default-durable: full 8-subtask harvest over icon-only narrow scope** — Per CLAUDE.md §Solution Quality, harvest-while-access-is-available trumps narrow-scope-today when the access window itself is the constraint. Even though the Dev Mode deadline turned out to be soft (Pro account came online same day), the pattern protects against cliff-edge access loss.

- **End Conv 178; configure Figma MCP between convs; /r-start fresh with MCP active** — MCP unlocks structured-data extraction far faster than screenshot+Dev Mode capture loop; continuing the manual workflow is wasted effort if MCP is hours away. Today's work needs durable commit before context risks getting lost.

**Patterns established Conv 178:**

- **Figma export `Include bounding box ✅` is load-bearing for icon systems** — Without it, Figma exports SVGs tight to visible geometry → per-icon `viewBox` varies → `<Icon class="h-6 w-6" />` renders different visual sizes. With it, all 39 icons came out with `viewBox="0 0 24 24"` matching Matt's canvas. Default ON for icon batches; default OFF for illustrations.

- **3-orthogonal-dimension factoring for Figma Component extraction** — Color (Variable Mode) × State (Property 1) × Size (frame cells) for buttons, factored independently rather than cross-product. Reduces worst-case 120-cell matrix to ~15-capture practical case.

- **Phase X.5 numbering for inserting a phase between locked phases** — preserves anchor stability vs re-numbering. First instance: Phase 4.5 between Phase 4 (PRM-2) and Phase 5 (PG2) in MATT-DESIGN-PUSH.

- **MCP load is a session-boundary affair, not a runtime one** — MCP configuration must be in place before session start. Plan MCP setup work around conv boundaries: (a) /r-end existing conv, (b) install/configure MCP between convs, (c) /r-start fresh, (d) verify presence via ToolSearch in new conv before relying on it.

**New deferred subtasks spawned Conv 178:**

- [→] **[MCP-SETUP-WALK]** Conv 179 — Walkthrough authored + executed for primary path; OAuth deferred to Conv 180. **Pivot mid-conv:** original plan was the Figma *local* Dev Mode MCP (desktop install + Dev seat + manual `settings.json` edit). User pointed at Figma's live docs (`developers.figma.com/docs/figma-mcp-server/`) which recommend the *remote* hosted MCP. v2 walkthrough rewritten at `.scratch/figma-mcp-setup.md` (no Figma desktop or Dev seat required). [MCP-INSTALL] + [MCP-CONFIG] executed via `claude mcp add --transport http figma https://mcp.figma.com/mcp` (registered in `~/.claude.json` project-scoped to peerloop-docs). [MCP-VERIFY] (#5) still pending — requires fresh CC session to surface the entry; OAuth (`/mcp` → figma → Authenticate → browser Allow) is the Conv 180 lead. Learning: CC loads MCP server list once at session start; `claude mcp add` writes to disk but does not hot-reload — plan MCP setup around `/r-end` → exit → `/r-start` boundaries.

- [x] **[MCP-INSTALL]** Conv 179 — Selected Figma's official **remote** MCP server (`https://mcp.figma.com/mcp`) per Figma's documented recommendation. Community `figma-developer-mcp` retained as fallback.

- [→] **[MCP-TOKEN]** Conv 179 — Superseded for primary path. Remote MCP uses OAuth (browser-based Allow Access), no PAT required. Kept as conditional fallback if community MCP path is ever revived.

- [x] **[MCP-CONFIG]** Conv 179 — Replaced manual `settings.json` edit with `claude mcp add --transport http figma https://mcp.figma.com/mcp`. Output: registered in `~/.claude.json` tagged `[project: /Users/livingroom/projects/peerloop-docs]` — effectively project-scoped per CC's own scoping mechanism (matches original B1 intent). `claude mcp list` confirms: `figma: https://mcp.figma.com/mcp (HTTP) - ! Needs authentication`. Each machine needs its own `claude mcp add` invocation (`.claude.json` is per-machine, not git-synced) — documented in v2 walkthrough doc.

- [x] **[MCP-VERIFY]** Conv 180 — Figma Remote MCP authenticated and verified. User completed OAuth via `/mcp` BEFORE invoking `/r-start` (slash-command output showed `Authentication successful. Connected to figma.`); `claude mcp list` confirmed `figma: ✓ Connected`; ToolSearch verified 10+ `mcp__figma__*` tools surfaced (`get_design_context`, `get_screenshot`, `get_metadata`, `get_variable_defs`, `get_libraries`, `search_design_system`, `whoami`, etc.); `mcp__figma__whoami` confirmed user has **Dev seat** on Peerloop org (pro tier) — Phase 4.5 work unblocked immediately, no waiting for Brian's seat re-assignment. (Conv 180)

- [x] **[CMP-ICN-REGISTRY]** Conv 187 — **RESOLVED via MMP-PH4 re-render test = per-icon viewBox.** When `stars_2` + `accessibility_new` arrived from Figma at native 20×20 while existing 39 icons are 24×24 (MattIcon hardcoded a 24×24 wrapper), the re-render forced the registry shape decision. Chose A (per-icon intrinsic viewBox in `MattIcon.tsx`, default 24×24) over rescale-via-`<g transform>`. Icons stored at native size; MattIcon now size-agnostic so future Material harvests at any grid "just work"; existing 24×24 icons render identically via default fallback. (Conv 178 spawned; Conv 180 deferred to MMP-PH4; Conv 187 resolved.)

- [x] **[CMP-VAR-PROMOTE-DECISION]** Conv 180 — **Decision = A: flat icons.** Arrow / Level / Bookmark Component-variant groups stay as 9 flat registry entries: `arrow-right`, `arrow-left`, `arrow-up`, `arrow-down`, `level-beginner`, `level-intermediate`, `level-advanced`, `bookmark-default`, `bookmark-filled`. Trade-off accepted: dynamic usage requires string concatenation (`<Icon name={`level-${course.difficulty}`} />`) instead of typed-prop ergonomics. Total registry will be ~45 entries (36 base + 9 variant). Coordinated with [CMP-ICN-REGISTRY] (which defers shape decision to MMP-PH4). (Conv 178 spawned; Conv 180 decided)

- [→] **[MATT-MCP-RETRY]** Conv 178 — Superseded by [MCP-SETUP-WALK]. Original ON-HOLD rationale (Brian's paid-seat blocker) no longer applies — client's Pro account now exists. Merge into MCP-SETUP-WALK as the active inheritor.

## Conv 179 Items

- [ ] **[ASF]** Investigate `Astro.slots.has` + `&&` short-circuit interaction surfaced Conv 175 [MSH-VIZ] empty-pill bug. Conditional Fragment forwarding `<Fragment slot="x"><slot name="y" /></Fragment>` suppressed child's `<slot name="x">FALLBACK</slot>` even when slot `y` was empty; `Astro.slots.has` + `&&` short-circuit did not restore the fallback. Production workaround in place: defaults at the layout consumer via ternary inside unconditional Fragments. Root-cause investigation deferred — file an Astro issue or build a minimal repro if it bites again. Captured in memory as `reference_astro_slot_forwarding.md`.

- [ ] **[TDS-DRIFT]** `tech-doc-sweep` hook returned no recent changes despite the substantial `matt/*` additions across Convs 173-178 (new tokens, new layout shells, new primitives, new pages). Investigate: drift baseline SHA at `.claude/.drift-baseline-sha` may be stale, or sweep matchers in `.claude/scripts/tech-doc-sweep.sh` may not detect `src/components/matt/*` / `src/styles/tokens-*.css` / `src/pages/matt/*` paths. Reproduce: `cat .claude/.drift-baseline-sha`, then `git -C ../Peerloop diff $(cat .claude/.drift-baseline-sha)..HEAD --stat -- 'src/components/matt/*' 'src/styles/tokens-*' 'src/pages/matt/*'` to see whether files-changed are visible to the matchers.

- [ ] **[MEM-CAP]** Schedule a `/r-prune-claude` pass when MEMORY.md auto-load utilization climbs above 80% (Conv 179 baseline: 59% lines / 57% bytes — not urgent, watch-task only). Auto-load cap is 200 lines / 25 KB at every SessionStart (per `code.claude.com/docs/en/memory.md`); /r-start Step 5.7 Phase 2 emits a 🔴🔴🔴 alert at ≥80% on either axis. Adding the `## External Source-of-Truth` section in Conv 179 grew MEMORY.md by 1 section + 1 line; subsequent net-growth convs without prune will close the gap.

- [ ] **[INV-PATH-FIX]** Sweep `.scratch/matt-figma/` references in code/docs → `.scratch/matt-main/`. `matt-figma` was the initial 229-file Figma export (Conv 169); `matt-main` is the curated 83-file build set (Conv 170 [MATT-ISOLATE]). Active references in Matt design docs (matt-design-system.md, matt-pre-plan.md) or `src/` may still point at the read-only inventory dir instead of the canonical build set. Find with: `grep -rn 'matt-figma' docs/ && git -C ~/projects/Peerloop grep 'matt-figma' -- src/`. Replace path-by-path; verify each isn't an intentional historical reference.

## Conv 180 Items

**Completed Conv 180 (MATT-DESIGN-PUSH active — Figma MCP activation + Phase 4.5 mini-plan + 2 decisions):**

- [x] **[MCP-VERIFY]** Conv 180 — see Conv 178/179 Items above for detail (Figma Remote MCP authenticated via OAuth pre-/r-start; `claude mcp list` confirms `figma: ✓ Connected`; 10+ `mcp__figma__*` tools surfaced via ToolSearch; user has Dev seat on Peerloop org pro tier — work unblocked).

- [x] **[MEM-DRIFT-ICN]** Conv 180 — MEMORY.md "Icon System" line corrected: `~35 entries` → `10 entries (verified Conv 180; Matt-namespaced ~45-entry parallel registry pending from MMP-PH2)`. Verified `src/lib/icon-paths.ts` actual count via direct probe.

- [x] **[MFP]** Conv 180 — Page URL lookup stored at `.scratch/matt-figma-pages.md` — 9-page table with node-ids, URLs, probe status, known content. Cross-references Conv 180 probe history (Components 1:269 / Color Guide 1:16 / α1 Happy Path 477:8493 / "Happy Path Home" 477:8502). Layout / Documentation pages marked `?` pending probe; Content page marked 🚫 OUT OF SCOPE per user (Matt's initial value-proposition exploration, not implementation source). Unblocks MMP-PH1.

- [x] **[CMP-VAR-PROMOTE-DECISION]** Conv 180 — Decided A: flat icons (see updated entry under Conv 179 Items above). 9 variant entries in registry; trade-off accepted.

**Strategic decisions captured Conv 180:**

- **Use Dev seat (not Full seat) for Figma MCP work** — Dev seat provides all reads needed (`get_design_context`, `get_metadata`, `get_screenshot`, `get_variable_defs`, `get_libraries`, `search_design_system`, `whoami`) and removes accidental-edit risk at the API boundary. Initially recommended Full seat for write flexibility; user pushed back preferring the structural safety guarantee. `whoami` confirmed user already has Dev seat assigned — no Brian action needed.

- **[CMP-ICN-REGISTRY] deferred to MMP-PH4** — Inferential debate without empirical signal; the re-render test will reveal whether registry shape actually affects build velocity. If MMP-PH2 must make interim choice, default to B (Matt-namespaced) — least irreversible.

- **[CMP-EXT-ICN] = A (incremental Material icon harvest)** — when MCP output contains an unfamiliar `data-name` (e.g., `stars_2`, `accessibility_new`, `how_to_reg` found inline in Happy Path), query that node directly via MCP, extract SVG path, add to icon registry. Per-icon cost small; avoids upfront `@material-design-icons/svg` dependency.

- **Storage location for Figma URL lookups: `.scratch/matt-figma-pages.md`** — gitignored, persistent across convs, promotes to `docs/as-designed/matt-figma-pages.md` at MMP-PH5 graduation. Same pattern for future `.scratch/matt-figma-dev-ready.md` (task [MDR] when supplied).

**Patterns established Conv 180:**

- **Figma Remote MCP is link-based by design — don't enumerate** — The API is designed for user-as-navigator: user copies a Figma link (right-click → "Copy link to selection"), pastes URL, AI queries that specific node. `get_metadata(fileKey)` page listing returns only currently-scoped pages (got 2 of 9 in this conv) but ANY node-id can be queried directly (invisible-but-accessible pattern). Ask user for page URLs upfront; store as `.scratch/<project>-figma-pages.md`. Per Figma docs: *"The remote Figma MCP server is link-based."*

- **MCP `get_design_context` output shape varies by node type** — Section nodes return sparse metadata + "drill into sublayers" (no code). Component variant nodes return typed React with **inferred props** (`hasLabel`, `hasLeadingIcon`, etc.) — most useful for primitive building. Page/card nodes return inlined HTML+CSS with `data-name` attributes (NOT named component references) — useful for visual layouts.

- **Translation is mandatory — there is no paste-in workflow** — MCP renders icons as `<img>` with expiring asset URLs (7-day signed Figma S3 links), components inlined as raw markup, and MCP itself explicitly warns: *"The generated React+Tailwind code MUST be converted to match the target project's technology stack."* Registry-key naming is DECOUPLED from MCP output — a translation table handles mapping regardless of key choice. The `data-name` attribute IS the translation key.

- **Variable Mode bakes into CSS-var fallback hex** — MCP renders CSS variables with the parent context's Variable Mode resolved into the fallback (e.g., Course card has `var(--background,#e8f4df)`; Auto Primary button has `var(--background,#0777b6)` — same variable name, different fallback per parent context). Implication: codebase needs to define those CSS variables AND implement Variable Mode switching (likely `[data-variable-mode="course"]` selector pattern).

- **Verify external tool behavior empirically before recommending** — Made 4+ recommendations this conv about Figma MCP that were all reversed by next probe (page-filtering being Dev-seat related, `search_design_system` for icon discovery, MCP returning name-referenced components, registry naming optimizing for paste-in). One tool call beats one rework cycle. Captured as [EMP] context in `feedback_external_source_of_truth_first.md`.

- **Matt's "Ready for Dev" labels are human-visible, not API-readable** — Matt erects green-banner "Ready For Dev" label frames above each finished frame; Figma's built-in frame-level Dev-Ready flag is NOT used. Dev-Ready status is NOT API-detectable in this file. To know what's Ready for Dev, ask designer or visually scan.

- **Matt thinks in Figma at all times** — Documentation page, notes, exploration — everything Matt produces lives in Figma. Treat Figma as his primary working surface; don't expect parallel doc-system artifacts. (Captured as `project_matt_collaboration_style.md`.)

**New deferred subtasks spawned Conv 180:**

- [→] **[CMP-EXT-ICN]** Conv 186 — **DELETED.** Replaced by 5 specific harvest tasks ([VIDEO-COMMENT-ICN], [PLAY-CIRCLE-ICN], [STARS2-ICN], [ACCESSIBILITY-ICN], [HOWTOREG-ICN]) plus a generalized side-effect discovery rule codified into [MFRD-LOOKUP]'s drift-check workflow (every deep `get_design_context` probe scans `<img data-name>` instances and auto-creates `[<ICON>-ICN]` tasks for unharvested icons). Umbrella task was vague and easy to forget; side-effect mechanism is automatic. See Conv 186 Items below for the 5 specific tasks + workflow.

- [→] **[MDR]** Conv 186 — **REPLACED by [MFRD-LOOKUP]** (see Conv 186 Items below). Lookup file landed at `.scratch/matt-frames-ready-for-dev.md` with 32 rows covering Components + Happy Path + Layout pages (all Matt's currently Ready-for-Dev frames as of 2026-05-24). Includes drift-check workflow + side-effect Material-icon discovery rule. Permanent maintenance tracked as [MFRD-LOOKUP].

**MATT-DESIGN-PUSH Mini-Plan (MMP) — 6-phase sequence spawned Conv 180:**

Bridges from Conv 180's Figma MCP unlock to a reproducible single-page MCP-driven re-render workflow before resuming Phase 4.5 bulk work. Mini-plan replaces the original Phase 4.5 "harvest while access is available" approach with MCP-native extraction. Sits BEFORE [MATT-EXEC-CMP] continuation as the workflow-validation gate.

- [x] **[MMP-PH0]** Conv 181 — Phase 0 Discovery COMPLETE. Routes audited (2/12 scaffolded: `matt/index.astro` + `matt/course/[slug]/index.astro`); components inventoried (1 layout + 14 components: Sidebar, HeaderBar, ControlBar, SubNav, RoleTabBar, CourseHeader, Button, Card, Module, Note, SectionTitle, SocialPost, ToDoItem, _SocialPostDemo); tokens audited (3-tier cascade in place from Conv 172: primitives + semantic + bridge + global). Discovery surfaced: PH1 ~80% already done, PH3 ~80% already done, PH2 0% done (39 Matt icons still in `.scratch/` unported). Re-render target picked for MMP-PH4: **Course In Feed (519:9096)** — smaller surface, already probed Conv 180, exercises Variable Mode + icons + 2 primitives.

- [x] **[MMP-PH1]** Conv 181 — Phase 1 Token foundation COMPLETE. Color + Typography Variables both fully canonized via direct `get_variable_defs` probes (selection-required pattern discovered this conv). Color: 12 verified + 2 Conv 172 speculative isolated. Typography: 18 Variables formalized into new `src/styles/tokens-typography.css` + bridge typography rewritten with all 18 Tailwind utility classes. Variable Mode validated (Course context → Primary resolves to #327D00 dark-green). See [TSV] entry above for full detail.

- [x] **[MMP-PH2]** Conv 182 — Phase 2 Icon registry COMPLETE. **Chose Option B: SVG-files-as-source-of-truth via Vite `?raw` glob** (not path-extracted TS registry — keeps Matt's exact artifact canonical per Conv 181 tokenize-only-matt-variables / honest-orphan principle). Created `src/components/matt/icons/` (filing per user choice). 39 Matt SVGs copied from `.scratch/matt-main/components/icons/` to `src/components/matt/icons/svg/`. Fill normalization via perl-pi: `s/fill="#414141"/fill="currentColor"/g` (38 files); 1 outlier `info.svg` carried `fill="#1C1B1F"` (Material Design 3 `on-surface` default, direct Material Icons export) caught by distinct-fill audit and normalized. `MattIcon.astro` consumer (~40 lines): `import.meta.glob<string>('./svg/*.svg', { query: '?raw', import: 'default', eager: true })` + outer-`<svg>` strip regex + `<svg viewBox="0 0 24 24" set:html={inner}/>` wrapper. Dev-only warn on unknown name; missing-icon dashed-square placeholder. Removed useless `export type MattIconName = keyof typeof innerByName` (innerByName typed `Record<string, string>` so keyof = bare `string`); added `Astro.props as Props` cast to satisfy tsc usage analysis. Baseline gates green: astro check 1233 files 0/0/0 (+1 from PH1's 1232); build 6.29s; lint clean. Test suite skipped (purely additive change). Folded into MMP-PH2: original [MATT-EXEC-CMP-ICN] code-integration phase satisfied. Trade-off accepted: no compile-time `MattIconName` union (runtime lookup + dev-only warn) — registry shape provisional, MMP-PH4 empirical re-render will validate. Graduation note added to `.scratch/matt-main/components/icons/_INDEX.md`. Material Design icons strategy [CMP-EXT-ICN] = A unchanged (incremental harvest during MMP-PH3/Phase 5 as encountered).

- [x] **[MMP-PH3]** Conv 185 — Phase 3: Component primitives **COMPLETE**. All 13 of Matt's named primitives built across Convs 183-185 + Conv 178 audit-driven re-validation closed: [MATT-EXEC-CMP-BTN] (Button, Conv 183), [MATT-EXEC-CMP-MNV] (MainNav + NavItem + NavSubItem, Conv 183), [MATT-EXEC-CMP-SNV] (SubNav + SubNavItem, Conv 184), [CMP-UICN] / [CMP-EPILL] / [CMP-ELINK] / [CMP-CHIP] (4 leaf primitives from Entities decomposition, Conv 184), [CMP-ANCH-COURSE] (first anchor row, Conv 184), [CMP-ANALYTIC] (Social Post footer badge, Conv 184), [REFACTOR-SOCIALPOST] (Conv 184), [CMP-CHAT] (Chat Bubble, Conv 185), [CMP-ANCH-REST] (8 anchor rows, Conv 185), [REFACTOR-COURSEHEADER] (creator section, Conv 185), [MATT-EXEC-CMP-BRN] (Logo + LogoMark, Conv 185). Also Conv 185 audit fixes: [C178-REVAL] Module + ToDoItem refactored to strict-B (dropped over-engineered `entity` prop, fixed Conv 178 drift); SectionTitle name-collision documented (Matt's = Figma dev-status banner, ours = generic content heading — not a drift, separate purposes). Remaining gaps are Phase 6 extrapolation work: [DARK-HERO-VARS], [VIDEO-COMMENT-ICN], [PLAY-CIRCLE-ICN]. Unblocks [MMP-PH4] re-render test.

- [x] **[MMP-PH4]** Conv 187 — Phase 4: Re-render test **COMPLETE**. Picked Course In Feed (`519:9096`, Default variant of set `502:12911`; Mobile variant deferred to Phase 6). Built `CourseInFeed.tsx` (props-driven dark-hero feed card composing EntityPill + 4 on-dark IconLabelChips + course Button + MattIcon). Re-render gate surfaced two assumptions: (1) 20-vs-24 icon-grid registry mismatch → empirically resolved [CMP-ICN-REGISTRY]; (2) CourseHeader creator-trio drift (caught when checking sibling course page) → CourseHeader re-validated to Matt's Default frame. Live-verified in Chrome bridge (245px height matches Matt's instance exactly); all 5 gates green. Committed `ead81ada` + `cea3def0`.

- [ ] **[MMP-PH5]** Phase 5: Graduation — promote `.scratch/matt-figma-pages.md` → `docs/as-designed/matt-figma-pages.md`; supersedes `matt-figma-extraction-today.md` ([MFE-STALE]); promotes Figma MCP setup walkthrough from `.scratch/figma-mcp-setup.md` → canonical docs ([MCP-DOC]); rolls forward to remaining 11 Phase 5 pages via MCP. (Blocked by [MMP-PH4].) **Conv 191: promotion half also machine-pinned — the source `.scratch/matt-figma-*.md` files live ONLY on MacMiniM4 (gitignored, never synced); scratch→docs graduation must run on the authoring machine, not MacMiniM4Pro.**

## Conv 181 Items

**Completed Conv 181 (MATT-DESIGN-PUSH active — MMP-PH0 Discovery + MMP-PH1 Token foundation + new tokenize-only-matt-variables principle):**

- [x] **[MMP-PH0]** Conv 181 — Phase 0 Discovery COMPLETE. See MMP entry above for detail (routes 2/12 scaffolded; 14 components + 1 layout inventoried; tokens 3-tier cascade in place; PH4 re-render target = Course In Feed 519:9096).

- [x] **[MMP-PH1]** Conv 181 — Phase 1 Token foundation COMPLETE. See MMP entry above for detail (12 Color + 18 Typography Variables canonized; new `tokens-typography.css` 124 lines; bridge typography rewritten with 18 Tailwind 4 `--text-{name}--<modifier>` utility classes; Variable Mode validated).

- [x] **[TSV]** Conv 181 — Token Scaffolding Verification COMPLETE — see Conv 172 Items above for detail.

- [x] **[NOTE-YELLOW]** Conv 181 — Resolved by hardcoding inline, NOT adding new token — see Conv 176 Items deferred subtasks above for detail. Note.tsx all 7 drifts fixed (background hex, border, radius, padding, gap, shadow, leading).

- [x] **[MCP-DRIFT-180]** Conv 181 — `memory/reference_figma_mcp_behavior.md` rewritten from 56 → 75 lines. Two tool classes documented: **selection-free** (`get_metadata`, `get_libraries`, `search_design_system`, `get_screenshot`) and **selection-required** (`get_design_context`, `get_variable_defs` — passed nodeId must match selected node exactly). `get_variable_defs` return-shape doc, invisible-local-Variables caveat (`get_libraries` returns only subscribed external libraries; local Variables only visible by probing consuming nodes), efficient batch-probing pattern (select a container frame, all descendants' Variables returned), Variable Mode observability at Variable layer, plugin-rendered labels NOT authoritative warning (Color Guide plugin renders `Primary/Primary` for an actual `Primary/Default` Variable). MEMORY.md one-liner updated to lead with two-tool-class distinction + key markers. Corrects the Conv 180 reference memory which implied all tools work by node-id alone.

**Strategic decisions captured Conv 181:**

- **Speculative alert tokens: keep + isolate (Option B)** — 6 Conv 172 speculative entries (`--alert-light`/`--carmine-red` primitives + `--Alert-Default`/`--Alert-Light` semantics + 2 bridge re-exports) moved to dedicated "Speculative (Conv 172)" sub-blocks across `tokens-primitives.css` / `tokens-semantic.css` / `tokens-tailwind-bridge.css` with provenance comments ("not in Matt's current Figma per Conv 181 probe; retained for Phase 6 [MATT-EXEC-EXT] alert/error UI extrapolation; verify or remove during Phase 6"). Header counts updated (15 → "13 Matt-verified"). Callsites resolve unchanged.

- **[NOTE-YELLOW] hardcoded inline (NOT new token)** — `get_design_context(652:8646)` probe revealed Matt's yellow IS hardcoded hex (`#FFF6B8` background, `#F1E9B0` border), NOT a Figma Variable. Adding `--note-yellow` token would imply systematization Matt has not made; honest-orphan principle says hardcoded values are self-deprecating (breakage obvious in diff) while named tokens accumulate stale meaning silently.

- **NEW STANDING PRINCIPLE: tokenize only Matt's Variables** — `memory/feedback_tokenize_only_matt_variables.md` (50 lines) establishes the rule for all future /matt/* token decisions: token-ify what Matt has tokenized (Figma Variable presence is the signal); hardcode what Matt has hardcoded (matches design integrity, fix when Matt categorizes); scaffold what Matt hasn't categorized (border radius, spacing — our own scale, Matt overrides when he adds his). Probe protocol: `get_variable_defs` is the authority. Conv 172's speculative-token pattern retroactively recognized as anti-pattern (preserved per Decision 1 above but not extended). MEMORY.md one-liner added under Solution Quality section with `**bold**` rule statement.

**Patterns established Conv 181:**

- **Figma MCP two tool classes — selection-free vs selection-required** — `get_metadata`, `get_libraries`, `search_design_system`, `get_screenshot` accept any nodeId. `get_design_context`, `get_variable_defs` require user to select a specific layer in Figma desktop AND the passed nodeId must match the selected node exactly (passing parent or sibling fails). When MCP returns "select a layer first", check (a) Figma desktop is active window, (b) specific layer selected (not canvas), AND (c) passed nodeId matches selected node.

- **Efficient batch-probing via container selection** — `get_variable_defs` returns all Variables consumed by descendants in one call. Conv 181: Headers section → 10 Variables; Body section → 8 Variables. For comprehensive Variable audits, ask user to select a container frame.

- **Plugin-rendered visualizations are NOT authoritative Variable names** — Matt's Color Guide is plugin-generated; renders "Primary/Primary" for an actual `Primary/Default` Variable. Always verify Variable names via `get_variable_defs`, NEVER `get_metadata` text-label content. Source-of-truth ordering: (1) `get_variable_defs` on consuming node, (2) `get_design_context` for hardcoded hex, (3) `get_metadata` labels (display only).

- **Local-file Variables invisible to library-scoped MCP tools** — `get_libraries` returns only subscribed external libraries; `search_design_system` searches same external scope. Variable existence can only be verified by finding a consuming node and probing `get_variable_defs`. Variables defined-but-unused are completely invisible.

- **Tailwind 4 `--text-{name}--<modifier>` consolidation** — single utility class carries size + weight + line-height + letter-spacing via modifier-suffix pattern in `@theme`. Setting `--text-body-default`, `--text-body-default--line-height`, `--text-body-default--font-weight`, `--text-body-default--letter-spacing` emits a `text-body-default` utility applying all four CSS properties.

**New deferred subtasks spawned Conv 181:**

- None — all surfaced findings were resolved this conv.

## Conv 182 Items

**Completed Conv 182 (MATT-DESIGN-PUSH active — MMP-PH2 Icon registry + 5 doc graduations):**

- [x] **[MMP-PH2]** Conv 182 — Phase 2 Icon registry COMPLETE. See MMP-PH2 entry in MATT-DESIGN-PUSH Execution Phases below for full detail (39 SVGs ported to `src/components/matt/icons/svg/`; `MattIcon.astro` Vite `?raw` glob consumer; fill normalization `#414141`→`currentColor` with `info.svg` outlier `#1C1B1F` MD3 on-surface caught by distinct-fill audit).

- [x] **[MATT-EXEC-CMP-ICN]** Conv 182 — Code-integration phase folded into [MMP-PH2]. Closes the Conv 178 harvest + Conv 182 integration arc.

- [x] **[MEM-IP-DRIFT]** Conv 182 — MEMORY.md "Icon System" line corrected. Old: "10 entries of raw HTML path strings". New: "39 entries of raw HTML path strings (5 directional + 4 nav + 4 people + 4 content + 16 objects + 3 community + 3 brand; re-counted Conv 182). Matt-namespaced parallel registry landed Conv 182 as `src/components/matt/icons/MattIcon.astro` + `svg/*.svg` (Vite `?raw` glob, 39 SVGs, fills normalized to currentColor)." Discovered mid-conv when re-counting `src/lib/icon-paths.ts` produced 39 entries (5 directional + 4 nav + 4 people + 4 content + 16 objects + 3 community + 3 brand) — not 10 as MEMORY.md line 21 claimed (Conv 180 [MEM-DRIFT-ICN] claim was wrong).

- [x] **[MFE-STALE]** Conv 182 — Stale `.scratch/matt-figma-extraction-today.md` (12.4 KB Conv 178 planning doc for completed extraction work) deleted. `matt-figma/` folder confirmed already absent (curated to `matt-main/` Conv 170 per PLAN.md). Active references preserved: `.scratch/matt-figma-pages.md` (Conv 180 active reference) and `.scratch/matt-main/` (current canonical) untouched.

- [x] **[MDS-CASCADE-VALIDATED]** Conv 182 — `docs/as-designed/matt-design-system.md` §5 Entity cascade caveat reframed. Kept original Conv 176 paragraph (historical symptom record) and added "✅ Conv 178 validation" paragraph: cascade is NOT broken — Matt's button CSS uses `var(--Background)`/`var(--Border)` (variant-scoped variables tied to `variant` prop), NOT `var(--Entity-Background)`/`var(--Entity-Primary)` (the cascading entity variables). Cascade was never wired into Matt's button design in the first place. Retired "until [CASCADE-BROKEN] resolves" wording — [CASCADE-BROKEN] closed. Shapes how MMP-PH3 primitive builds: variant-prop primitives use parallel-but-independent variable cluster scoped to each variant class.

- [x] **[MDS-BTN-3D]** Conv 182 — `docs/as-designed/matt-design-system.md` §5 Button section updated. Updated heading to "extracted Conv 172, dimensionality refined Conv 178". Updated opening to clarify 18-cells table covers Color dimension only. Added "Conv 178 update — 3-orthogonal-dimension architecture" callout with dimensions table (Color 6 / State TBD / Size 5), updated React `ButtonProps` shape with `size?` prop placeholder and State→pseudo-class mapping. Total cells ≈ 90-120 (NOT flat 6×3 = 18). Noted [MATT-EXEC-CMP-BTN] (now reframed as MMP-PH3 portion) is the gate that resolves the State enum and 5 size cells.

- [x] **[MATT-RT-DOC]** Conv 182 — `docs/as-designed/matt-pre-plan.md` §2 Route Map "Implementation status (as of Conv 182, MMP-PH2)" subsection added. 13 planned routes; actual `/matt/*` routes in code: 2 (`/matt/` + `/matt/course/[slug]`). 2/13 built table + 11/13 pending list with phase-gate annotations. 5 of 11 pending carry "Decision required" markers (resolved naturally during [MATT-EXEC-FLAGS]).

- [x] **[MCP-DOC]** Conv 182 — New canonical `docs/reference/figma-mcp.md` created consolidating `.scratch/figma-mcp-setup.md` (5.4 KB Conv 179 walkthrough) + `memory/reference_figma_mcp_behavior.md` (75 lines empirical behavior). Sections: Overview, Setup (3 steps), Architecture (link-based), Two tool classes (selection-free vs selection-required), Per-target output shape, Output characteristics (`data-name`, color vars, Variable Mode, plugin labels, asset URLs, "SUPER CRITICAL" translation notice), Seat tier, Workflow patterns (user-as-navigator, batch-probing, token verification via visual-absence heuristic), Implications at decision points, Fallback paths (local MCP, community MCP), Related links. Superseded `.scratch/figma-mcp-setup.md` deleted. `docs/INDEX.md` needs no update (vendor reference docs covered by wildcard `docs/reference/*.md (vendor)` line). Memory file retained as recall-shorthand (graduation pattern: scratch → memory → docs/reference; scratch source goes, memory stays).

**Strategic decisions captured Conv 182:**

- **Matt-namespaced icon registry uses SVG files as source of truth (Vite `?raw` glob), not path-extracted TS registry (Option B)** — Aligned with Conv 181 tokenize-only-matt-variables / honest-orphan principle: keep Matt's exact artifact (the SVG file) as the canonical thing, don't translate into our format unless we have to. Re-exports from Figma drop straight into `svg/`. Trade-off accepted: no compile-time `MattIconName` union (runtime lookup + dev-only warn) — registry shape provisional, MMP-PH4 empirical re-render will validate whether type-safety is justified. File location: `src/components/matt/icons/` per user choice.

- **[CASCADE-BROKEN] closed — Matt's button CSS uses variant-scoped variables, not entity-cascade variables** — Conv 178 finding validated as architecturally meaningful: entity cascade is intended only for components Matt explicitly wired with `--Entity-*` variables (entity headers, route-level entity color hints). Multi-variant primitives like Buttons use parallel-but-independent variant-prop mechanism. Shapes how MMP-PH3 component primitives are built — variant-prop primitives need their own `--{Primitive}-{Background,Color,Border}` variable cluster scoped to each variant class.

**Patterns established Conv 182:**

- **Hex fill audit before bulk-rewrite catches Material-Icons paint defaults** — When normalizing fills across an icon set exported from Figma, run a distinct-fill audit BEFORE assuming a single hex value covers all icons. Direct Material Icons exports may carry `#1C1B1F` (MD3 on-surface) instead of the designer's chosen color. Audit pattern: `for f in *.svg; do for fill in $(grep -oE 'fill="[^"]*"' "$f" | sort -u); do case "$fill" in 'fill="currentColor"'|'fill="#D9D9D9"'|'fill="none"') ;; *) echo "$f: $fill" ;; esac; done; done`. For future Figma re-exports into `src/components/matt/icons/svg/`, run this audit before commit.

- **Vite `import.meta.glob('./svg/*.svg', { query: '?raw', import: 'default', eager: true })` for inline-SVG icon registries** — Returns `Record<string, string>` (path → raw text) at build time. Combined with outer-`<svg>` strip regex, gives inline-able body content that the Astro component wraps with new `<svg viewBox="0 0 24 24" set:html={inner}/>`. Build resolves the glob; no runtime cost. Future re-exports: drop SVG file into `svg/` + run fill-normalization step + build picks it up automatically — no registry edits required.

- **Astro `interface Props` triggers ts(6196) when not referenced through type composition** — Astro's special-casing of `interface Props` for `Astro.props` typing isn't automatic — tsc still needs Props referenced somewhere. Fix: when writing a new `.astro` component, if `Props` isn't referenced through type composition (e.g., a `name: SomeName | string` referencing an exported type), add `as Props` to the `Astro.props` destructuring line.

- **Doc graduation flow: scratch (staging) → memory (recall-shorthand) → docs/reference (canonical)** — Empirical discoveries about external tools (vendors, MCPs, SDKs) flow through three stages: (1) Scratch — walkthrough or investigation file during the discovery conv (2) Memory — rule-shorthand encoded for fast cross-conv recall during work (3) Docs/Reference — canonical reference doc once empirical findings stabilize. Memory file stays after graduation (it's the recall-shorthand version); scratch source goes (its content is now in git via the reference doc). Cross-link memory file at bottom of docs/reference doc under "Related". Pattern triggered when empirical findings stabilize after 2-3 convs of discovery.

- **Figma MCP `get_variable_defs` is selection-bound — token-verification has no direct MCP call** — Because `get_variable_defs` returns only Variables consumed by the selected node, AND `get_libraries`/`search_design_system` enumerate subscribed libraries (not local file Variables), there is NO MCP tool that enumerates a file's full local Variable collection. The workaround is the **visual-absence heuristic**: if no layer in any page uses red/pink, `--carmine-red` is effectively absent regardless of whether the Variable record technically exists. This is the basis for `feedback_tokenize_only_matt_variables.md`. When asked "does Matt have a token for X?" the answer must come from `get_variable_defs(<node that uses X>)`, not from `get_libraries` or `search_design_system`.

**New deferred subtasks spawned Conv 182:**

- None — all surfaced findings were resolved this conv.

## Conv 183 Items

**Completed Conv 183 (MATT-DESIGN-PUSH active — MMP-PH3 Component primitives, 2 of 7 landed: Button + MainNav):**

- [x] **[MATT-EXEC-CMP-BTN]** Conv 183 — Button COMPLETE via strict-B 5-value `property1` enum mirroring Matt's Figma. See `[MATT-EXEC-CMP-BTN]` entry in MATT-DESIGN-PUSH Execution Phases below for full detail. Major finding: Conv 178's "3-orthogonal-dimension" architecture claim was WRONG — Property 1 conflates State + Size (5 cells: Default/Hover/Large/Small/SmallHover, not 3-orthogonal). matt-design-system.md §5 Button rewritten with empirical variant matrix replacing Conv 178 framing.

- [x] **[MATT-EXEC-CMP-MNV]** Conv 183 — MainNav COMPLETE as 3 new React components + Sidebar.tsx refactor. See `[MATT-EXEC-CMP-MNV]` entry in MATT-DESIGN-PUSH Execution Phases below for full detail. Architecture decisions D1/D2/D3 established new collaboration pattern: AskUserQuestion + ASCII mockup previews for visual UX/architecture decisions when text descriptions are insufficient.

- [x] **[MCP-SEL-MISFIRE]** Conv 183 — Watch task description updated with Conv 183 positive observation: 8 successful `get_design_context` calls across Button + MainNav variants ran without user pre-selection in Figma desktop, contradicting Conv 180 `reference_figma_mcp_behavior.md` claim that the tool is selection-REQUIRED. Logged as ongoing watch (multiple data points across multiple convs needed before updating canonical memory).

**Strategic decisions captured Conv 183:**

- **Button: strict-B single `property1` prop (Decision 1)** — `property1` accepts `'Default' | 'Hover' | 'Large' | 'Small' | 'SmallHover'` (NOT separate `size` + CSS `:hover`). Hover/SmallHover are caller-picked explicit states, not CSS pseudo-class behavior. Mirrors Matt's Figma exactly per tokenize-only-matt-variables principle.

- **MainNav D1: Route-driven Main pill** — Pill auto-positions around active section based on currentPath; at most one pill at a time; derived visual not user-controlled state. An item enters `Main` if currentPath matches it OR any child AND it has children. No expand/collapse UI in MainNav.

- **MainNav D2: Keep 70px collapse as Peerloop extension** — Sidebar.tsx retains 220 ↔ 70 toggle; collapsed mode renders separate icon-only nav (NOT via MainNav, since Matt's 220px layout doesn't compress gracefully). Deviation isolated to Sidebar shell, MainNav itself faithful to Matt.

- **MainNav D3: Props-driven data model** — `MainNav` accepts `items: NavItem[]` prop. Enables future Admin/Teacher/Student sidebar variants from one component. NavItemData + NavSubItemData interfaces exported.

- **Figma is read-only — never call write-shaped MCP tools** — User explicitly stated "We are not to change Figma at all." Saved as new memory file `feedback_never_modify_figma.md`. Only read-tools permitted (`get_metadata`, `get_design_context`, `get_screenshot`, `get_variable_defs`, `get_libraries`, `search_design_system`, `get_figjam`, `whoami`); `mcp__figma__use_figma`, `create_new_file`, `upload_assets`, `add_code_connect_map`, `send_code_connect_mappings`, etc. all OUT OF SCOPE.

- **Hover styling for non-Primary variants: defer to Phase 6 extrapolation** — Matt drew Hover styling ONLY for Primary Variable Mode; `var(--background)`/`var(--border)` NOT used in Hover variant. Non-Primary + Hover combos render Matt's literal Primary-blue-darkened (strict mirror); proper variant-aware extrapolation requires new tokens that would violate tokenize-only-matt-variables principle. Phase 6 [MATT-EXEC-EXT] is the resolution point.

- **Disabled state: standard a11y orphan** — Matt's Property 1 enum has NO Disabled value. Keep native HTML `<button disabled>` + CSS `[disabled]:opacity-50 disabled:cursor-not-allowed` as CSS-level orphan. NOT a 6th Property 1 value — preserves Matt's 5-value enum exactly.

**Patterns established Conv 183:**

- **Empirical MCP probe trumps inferred architectural documentation** — Conv 178 "3-orthogonal Button" claim was a logical projection without probing; one MCP `get_metadata(40:482)` call revealed it as wrong (Property 1 is 5-value enum). [EMP] rule recurring (Conv 180: 4 reversals; Conv 183: +2 more). **Probe THEN write the spec, never the inverse.** When transcribing Figma into docs, every claim should be tied to a specific probed node ID.

- **ASCII mockups via AskUserQuestion `preview` field for visual decisions** — When proposing architectural / UX decisions that text alone cannot convey: (1) render Matt's Figma reference in ASCII as the baseline (save to `.scratch/`), (2) render each candidate option as ASCII showing how it differs, (3) use AskUserQuestion previews so the user picks visually rather than parsing prose descriptions. Side-by-side monospace comparison anchors decisions for the whole session.

- **Matt's Main pill = active-section visual, not click-to-expand** — Active-detection rule for sidebar nav: item enters `Main` if currentPath matches it OR any child AND it has children. No ▼/▶ toggle indicator anywhere in Matt's design. Render active path as one contiguous visual unit. (Pattern applies to future Admin/Teacher sidebars.)

- **Matt's design system has partial state-by-color coverage** — Hover variant Variable-Mode-aware-ness checks must run per-state independently. Mere presence of color tokens in collection doesn't guarantee every state uses them. Per tokenize-only-matt-variables: mirror Matt's partial coverage literally; flag the gap in component comment block for Phase 6.

- **Doc graduation for component primitives** — When a Matt primitive lands (Conv 182 icons, Conv 183 Button + MainNav), add a formal `### <Component> (extracted Conv NNN)` subsection in `matt-design-system.md` documenting: Figma node IDs, Property 1 variant table, extracted CSS, React component shape, implementation file paths. This is the canonical record; scratch and memory are staging.

**New memory file Conv 183:**

- `feedback_never_modify_figma.md` (NEW) — Figma is read-only; never call write-shaped MCP tools. Indexed in MEMORY.md.

**New deferred subtasks spawned Conv 183:**

- None — all Conv 183 work mapped 1:1 onto existing PLAN tasks. No new deferred items.

## Conv 184 Items

**Completed Conv 184 (MATT-DESIGN-PUSH active — MMP-PH3 continued: SubNav + Entity decomposition + SocialPost refactor + new standing rule):**

- [x] **[MATT-EXEC-CMP-SNV]** Conv 184 — SubNav COMPLETE. See `[MATT-EXEC-CMP-SNV]` entry under MMP-PH3 sub-tasks above. Resolves Conv 183 "Need 3+ Levels" open question (NOT multi-level — base + Selected-expanded). Also fixed latent Conv 175 silent bug (`active` prop never consumed) via `currentPath`-derived state.

- [x] **[CMP-UICN]** / **[CMP-EPILL]** / **[CMP-ELINK]** / **[CMP-CHIP]** Conv 184 — 4 leaf primitives extracted from Entities collection (decomposition per user reframe — Option C). React `.tsx` files at `src/components/matt/entity/`. IconLabelChip is the deliberate strict-B deviation (Matt didn't name it; user "make these reusable" directive justifies; honest-orphan annotation in file header).

- [x] **[CMP-ANCH-COURSE]** Conv 184 — CourseAnchor COMPLETE (first anchor row of 9). Composes UserIcon + EntityPill + IconLabelChip + Button + MattIcon. Locks in Option C architecture: 9 distinct row components, no shared base. After Conv 184's reuse-rule, refactored CTA from inline button styling to `<Button variant="course" property1="Default" />`.

- [x] **[CMP-ANALYTIC]** Conv 184 — AnalyticCount COMPLETE. Extracted from SocialPost.tsx inline `ActionPill()` helper. Two variants Default and `1+` with auto-flip behavior. Built React .tsx; `src/components/matt/ui/AnalyticCount.tsx`.

- [x] **[CMP-UICN-IMG]** Conv 184 — UserIcon extended with `avatarUrl?` for image-mode (production avatars). Strict-B extrapolation honestly annotated in file header per `feedback_tokenize_only_matt_variables.md`.

- [x] **[REFACTOR-SOCIALPOST]** Conv 184 — SocialPost.tsx + _SocialPostDemo.tsx fully refactored to use Conv 184 primitives. All inline duplicates removed (Avatar, ActionPill, LikeIcon, CommentIcon). Breaking API changes: `roleIcon: ReactNode` → `roleIconName?: string`, added `loves?: number`, removed `commenters` prop. _SocialPostDemo uses `<CourseAnchor>` as embed.

- [x] **All Conv 184 primitives + MattIcon standardized on React (.tsx)** Conv 184 — Astro can import React but not the reverse. 6 .astro files converted (MattIcon, UserIcon, EntityPill, EntityLink, IconLabelChip, CourseAnchor) and deleted. Pattern: **primitives in React (broadest reusability), page-wrappers in Astro.**

- [x] **tokens-semantic.css `.entity-student-teacher` alias** Conv 184 — Added (Conv 184 probe found Matt uses Student's colors for Student-Teacher).

- [x] **/matt/ design-review page Conv 184 showcase** Conv 184 — 6 new Card sections demonstrating each primitive across 4 entity contexts + 2 CourseAnchor instances + AnalyticCount showcase. Imports switched to React .tsx versions.

**Strategic decisions captured Conv 184:**

- **Standardize Conv 184 primitives + MattIcon on React (.tsx)** — All design-system leaf primitives are React. Astro page-wrappers may import them and render as static HTML at SSR (no JS bundle cost unless `client:*` directive). Resolves Astro/React boundary as architectural rule.

- **9 distinct anchor row components, no shared `AnchorRow` base (Option C)** — Per `feedback_tokenize_only_matt_variables.md`: extract what Matt named (each anchor by content type). Heterogeneous data per anchor type also resists clean abstraction. Reuse happens at leaf-primitive level, not row-shape level.

- **Extract IconLabelChip despite Matt not naming it** — User directive "make these reusable" overrides strict tokenize-only-Matt rule. 25+ instances across Post Anchors + Social Post. Honest-orphan annotation in file header marks the deviation for future audit.

- **New standing rule: scan `<instance>` children, import existing primitives, never inline duplicates** — Codified as `memory/feedback_reuse_existing_components.md` after Conv 184 audit revealed SocialPost inlined Avatar/ActionPill, and CourseAnchor (built earlier same conv) inlined Button styling. Rule requires `get_metadata` scan of `<instance>` children before any Figma render.

- **UserIcon image-mode pulled forward to Conv 184** — `avatarUrl?` prop added to UserIcon.tsx with explicit annotation. Real avatars are a production requirement Matt didn't draw; documented extension is honest extrapolation; wrapper or deferral would violate the new use-existing-primitives rule.

**Patterns established Conv 184:**

- **Primitives in React (.tsx), page-wrappers in Astro** — design-system architectural rule.

- **Scan `<instance>` children before rendering** — every Figma instance maps to an imported component or surfaces as a missing-primitive gap.

- **`data-name` is Figma's reliable component-instance label** — even when rendered markup is a generic `<div>`. Translation key for primitives (per `reference_figma_mcp_behavior.md`).

- **Strict-B mirroring catches latent bugs as a side-effect** — Conv 175 SubNav `active?: boolean` per-item bug was invisible until Conv 184 forced a Figma-grounded rewrite. Re-tests every assumption.

- **Frame-name reuse is structural evidence, but Matt's component-naming convention is the load-bearing signal** — for "what should be a primitive in code." Per tokenize-only-matt-variables.

**New memory file Conv 184:**

- `feedback_reuse_existing_components.md` (NEW) — scan `<instance>` children, import existing primitives, never inline duplicates. Indexed in MEMORY.md.

**New deferred subtasks spawned Conv 184:**

- [x] **[CMP-CHAT]** Conv 185 — Chat Bubble primitive COMPLETE. See Conv 185 Items below.
- [x] **[REFACTOR-COURSEHEADER]** Conv 185 — Creator section refactored to UserIcon + EntityPill + EntityLink trio in entity-creator cascade; rating/level/CTA stay inline pending [DARK-HERO-VARS]. See Conv 185 Items below.
- [x] **[CMP-ANCH-REST]** Conv 185 — All 8 remaining anchor row components built (Creator/Certification/Module/Resource/Review/Student-Teacher/Video Clip/Milestone). See Conv 185 Items below.

**Carry-forward observations Conv 184:**

- Visual screenshot-diff of CourseAnchor / SocialPost render vs Figma `317:10557` / `40:528` flagged but not blocking; reasonable to take before MMP-PH4 to validate strict-B fidelity. (Conv 185 installed Playwright chromium for programmatic screenshots — used to verify all Conv 185 primitives.)

## Conv 185 Items

**Completed Conv 185 (MATT-DESIGN-PUSH active — MMP-PH3 audit-driven follow-throughs: 5 carry-forward items closed in one conv):**

- [x] **[MATT-EXEC-CMP-BRN]** Conv 185 — Brand primitive COMPLETE (Logo + LogoMark). See MMP-PH3 execution-phases section above for detail. Mid-conv discovery: Figma MCP asset URLs return SVG for vector sources (not raster PNG) — `<img src>` markup in `get_design_context` output points at endpoint that preserves source format. Captured in `reference_figma_mcp_behavior.md` + MEMORY.md.

- [x] **[CMP-CHAT]** Conv 185 — Chat Bubble primitive COMPLETE. See MMP-PH3 execution-phases section above for detail.

- [x] **[C178-REVAL]** Conv 185 — Re-validate Module / ToDoItem / SectionTitle / SocialPost against Matt's Figma. Significant Conv 178 drift found in all 3 newly-probed:
  - **Module**: rewrote with 2 variants (Default/Current) matching Matt's exact `property1` enum, 220px width, Medium font weight, single title+duration line, dropped over-engineered `entity` prop (Matt's "active" state uses single hardcoded `--Primary-Light`, NOT 4-color entity cascade).
  - **ToDoItem**: rewrote with 20×20 rounded-[5px] checkbox (was 24×24 rounded-6), Medium font weights, 289px width, dropped `entity` prop. Kept idiomatic `checked: boolean` API.
  - **SectionTitle**: NAME COLLISION discovered — Matt's "Section Title" is a Figma-internal dev-status banner (WIP orange / Dev Ready green / Archived red, 1280px wide, TT Norms Pro Mono font), NOT a product component. Our `SectionTitle.astro` is a generic content heading (Inter). Different purposes; documented in matt-design-system.md but unchanged. Spawned learning #4 in extract: "design-system meta elements aren't always product primitives."
  - **SocialPost**: skipped re-probe — composition fidelity already validated Conv 184.
  
  Verified Module + ToDoItem are only used in `/matt/index.astro` showcase before refactoring (safe). Updated showcase callers. Screenshot confirms correct rendering.

- [x] **[REFACTOR-COURSEHEADER]** Conv 185 — Creator section refactored to UserIcon + EntityPill + EntityLink trio per new reuse rule. See MMP-PH3 execution-phases section above for detail. Spawned [DARK-HERO-VARS] for the rating/level/CTA carve-out.

- [x] **[CMP-ANCH-REST]** Conv 185 — All 8 remaining anchor row components built in single batch. See MMP-PH3 execution-phases section above for detail.

**Strategic decisions captured Conv 185:**

- **Sequence the 5 audit items: BRN → CHAT → C178-REVAL → CMP-ANCH-REST** — User redirected from auto-recommended MMP-PH4 to the Q1/Q2 carry-forward audit table; asked CC to choose ordering. Chose composite sequence (build all Q1 NEW primitives FIRST so C178-REVAL re-probes see the full vocabulary, then audit, then mass-produce 8 anchors last) over smallest-first / audit-first / anchors-first. Rationale: building primitives before validating them avoids re-probing later when more primitives exist; largest batch goes last when patterns are well-established. Consequence: completed all 5 in one conv with clean baselines throughout.

- **ChatBubble width drifts from Matt's 159px canvas placeholder** — Drop strict-B mirror for this single dimension; use `inline-flex max-w-[280px]` content-sized default with optional className override. Matt's 159px is a Figma drawing placeholder, not a UX rule; chat bubbles MUST size to content. Documented in component docstring so the drift is explicit, not silent.

- **Drop `entity` prop from Module and ToDoItem** — Strict-B match to Matt's exact 2 variants per primitive (not 4 entity-color variants). The `entity` prop was Conv 178 extrapolation. Removing it simplifies the API and prevents callers from passing `entity="creator"` and seeing wrong colors (Matt's Module Current is always blue, regardless of entity context).

- **CourseHeader CTA + rating/level stay inline (not refactored to Button + IconLabelChip)** — Limit refactor scope per task description. CourseHeader has a dark-image hero background; IconLabelChip uses `text-text-tertiary` (gray, poor contrast on dark) and Button is light-bg-optimized (white/pastel fills with dark text — invisible against light hero overlays). Creator cluster works on dark because Creator-primary purple #584DF4 is dark enough. Spawned [DARK-HERO-VARS] to build dark-hero variants of IconLabelChip + Button.

**Patterns established Conv 185:**

- **Figma MCP asset URLs preserve source format** — `get_design_context` returns `<img src>` markup pointing at `https://www.figma.com/api/mcp/asset/<uuid>`. Vector sources return SVG (with `fill="var(--fill-0, #hex)"` Variable-fallback pattern); raster sources return PNG. Pattern: `curl -sSL -o file.svg "https://www.figma.com/api/mcp/asset/<uuid>"` then `perl -pi -e 's/fill="var\(--fill-0, #[0-9A-Fa-f]+\)"/fill="currentColor"/g'` to normalize for Tailwind theming. Same conversion pattern as MattIcon's Vite `?raw` glob. `get_screenshot` continues to return PNG regardless.

- **Pre-mirrored asset SVGs vs CSS-transform mirroring** — Matt may draw each variant as a separate pre-mirrored SVG file rather than using CSS transforms. Trust the export: download both SVG files and use them as-is (each ~3KB). Trying to "optimize" to one SVG + CSS transform discards Matt's intent for zero size benefit.

- **Conv 178 reconnaissance over-engineered with `entity` prop on non-entity primitives** — When a component has variants in Matt's Figma, mirror those variant labels exactly via `property1` enum. Don't extrapolate to entity-collection unless Matt explicitly drew 4 entity colors for that primitive. Strict-B mirror is the safer default; reserve `entity` cascade for primitives Matt drew as multi-entity (UserIcon, EntityPill, EntityLink, Button which has 6 variants including 3 entity ones).

- **Playwright fallback when Chrome MCP bridge is flaky** — Chrome MCP extension disconnected mid-conv; `osascript activate + screencapture -x` kept grabbing desktop wallpaper instead of the Chrome window. Installed Playwright chromium (~250MB one-time via `npx playwright install chromium`) and used it for programmatic headless screenshots. Persists in `~/Library/Caches/ms-playwright/` for future convs.

- **Design-system meta elements aren't always product primitives** — Before assuming a Figma frame maps to a code component, check if the frame is a product element or a design-system meta element (status badges, version stamps, designer notes). Matt's "Section Title" is a 1280×96px dev-status banner (WIP/Ready/Archived), NOT a product primitive — it's Figma-internal document organization. Visual-canvas furniture isn't always a primitive.

**New deferred subtasks spawned Conv 185:**

- [x] **[DARK-HERO-VARS]** Conv 187 — **COMPLETE.** Added `tone="default"|"on-dark"` prop to `IconLabelChip.tsx` (on-dark = white icon+label for dark-image heroes); applied to both Course In Feed (4 chips) and the re-validated CourseHeader (4 chips). **Button dark variant confirmed unneeded** — both heroes use light-bg pill CTAs (course Button with white/pastel fill + dark text reads fine over the hero scrim), so no dark Button variant was required. Closes the [REFACTOR-COURSEHEADER] carve-out.

- [ ] **[VIDEO-COMMENT-ICN]** Harvest `video_comment` Material icon — VideoClipAnchor currently uses `chat` icon as substitute pending the real icon. Folds into [CMP-EXT-ICN] incremental Material harvest pattern.

- [ ] **[PLAY-CIRCLE-ICN]** Harvest `play_circle` Material icon — VideoClipAnchor currently uses inline-SVG placeholder. Folds into [CMP-EXT-ICN] incremental Material harvest pattern.

**Carry-forward observations Conv 185:**

- Conv 178 factual-error pattern fully validated this conv. [C178-REVAL] found drift in Module + ToDoItem + a name collision in SectionTitle — three distinct misframes from Conv 178's "reconnaissance" work. [MCP-SEL-MISFIRE] is also drift from over-confident initial probes. Conv 178's pattern of "visual-inspection inferences without `get_design_context`" surfaced in 3 separate places in this audit. Suggests strengthening `feedback_external_source_of_truth_first.md` with a specific "probe before claiming structure" line, OR adding a Conv-178-specific watch task. (Captured in extract §Uncategorized.)

## Conv 186 Items

**Completed Conv 186 (MATT-DESIGN-PUSH active — Matt frames Ready-for-Dev drift lookup landed + 5 audit-driven follow-throughs):**

- [x] **[SP-AUDIT]** Conv 186 — SocialPost.tsx subtree audited against existing primitives per `feedback_reuse_existing_components.md`. File is clean — every visual element resolves to its canonical primitive (UserIcon / IconLabelChip / AnalyticCount / EntityLink). One borderline finding: SocialPost "Show More" button uses inline `text-text-primary` underline styling — close to EntityLink but semantically/visually mismatched (button vs anchor, fixed vs entity-cascade color). Tracked as [TXTBTN] watch-task for repeat pattern across Phase 5.

- [x] **[ASSET-SWEEP]** Conv 186 — Verified zero embedded Figma URLs in `src/`. Swept `grep -rE 'figma\.com|mcp/asset' src/` → 0 matches. 45 SVGs already harvested permanently (39 icons + 4 brand + 2 chat). No expiry-window exposure exists today.

- [x] **[MFRD-DESIGN]** Conv 186 — Designed drift-detection workflow: cheap status-banner probes compare stored "Last Touched" to current value per frame; deep `get_design_context` probe only on date mismatch; every deep probe scans `<img data-name>` instances and auto-creates `[<ICON>-ICN]` tasks for unharvested Material icons. Verified Matt's banner schema first (3 text nodes: title, status, date) before bulk population.

- [x] **[MFRD-SEED]** Conv 186 — Seeded `.scratch/matt-frames-ready-for-dev.md` with 32 rows covering Matt's currently Ready-for-Dev frames as of 2026-05-24. Breakdown by parent page: **Components ✅ 12/12** (Icons + Buttons + Main Nav + Sub Nav + Entities + Chat + Modules + To Do List + Notes + Brand + Social Posts + Post Anchors); **Happy Path ✅ 14/14** (Home/Feed + 6 Course SubNav tabs About/Modules/Reviews/Resources/Teachers/Creator + Enroll funnel Purchase Course/Success/Choose Teacher/Session Scheduled + Session lifecycle Prepare/During/After + Home/Course Completed); **Layout ✅ 5/5** (Layout Desktop/Tablet/Mobile + Hero Course In Feed + Hero Course Header). Schema: Frame URL + Status URL + Parent Page + Last Touched (raw + ISO) + Probe Status. Per-page completeness markers added.

- [x] **[SUBNAV-PATTERN]** Conv 186 — Course SubNav route shape resolved by reading existing `/discover/course/[slug]/index.astro` + `[...tab].astro`. Pattern: Astro rest-spread dynamic route with `VALID_TABS` const + redirect-on-invalid + React island handling History API. Path-based (not query-string) — bookmarkable per user requirement. Matt's Course mirrors as `/matt/course/[slug]/[...tab].astro` with `VALID_TABS = ['about','modules','reviews','resources','teachers','creator']`. Spawned [MATT-SUBNAV-ROUTING] for implementation; resolved sub-assumption (e) of [MATT-EXEC-FLAGS].

- [x] **[TASK-CLEANUP]** Conv 186 — Deleted 3 redundant tasks: `[CMP-EXT-ICN]` (#10, replaced by 5 specific harvest tasks + drift-check side-effect rule); `[MATT-CREATOR-TAB]` (#16, replaced by [MATT-SUBNAV-ROUTING] — Creator is now one of 6 tabs in `VALID_TABS`); `[MDR]` (#19, placeholder completed by [MFRD-LOOKUP]).

**Strategic decisions captured Conv 186:**

- **Matt Course SubNav routing = path-based `[...tab].astro`** — Mirrors existing `/discover/course/[slug]/[...tab].astro` exactly (Astro rest-spread + `VALID_TABS` validation + React island for History API). Bookmarkable URLs match user requirement; SSR-friendly defaults; team has validated pattern. Spawned [MATT-SUBNAV-ROUTING] (#31) for implementation. Resolved sub-assumption (e) of [MATT-EXEC-FLAGS].

- **Drift-detection lookup at `.scratch/matt-frames-ready-for-dev.md` (graduates to `docs/reference/` at MMP-PH5)** — Per Conv 182 scratch→memory→docs graduation flow. Scratch staging avoids polluting `docs/reference/` with mid-design data while file is still churning. Conv 186 added 32 rows + 3 completeness markers in one conv — graduation now justified at next decision point (next conv or MMP-PH4). Permanent task `[MFRD-LOOKUP]` (#30) tracks the lifecycle.

- **Side-effect Material-icon discovery via drift-check workflow** — Every deep `get_design_context` probe scans `<img data-name="...">` instances and auto-creates `[<ICON>-ICN]` TaskCreate for unharvested icons. Codified into `[MFRD-LOOKUP]` workflow section 5. Replaced umbrella `[CMP-EXT-ICN]` task (vague, easy to forget) with automatic mechanism.

- **Add `Parent Page` column to lookup schema** — Sorting/filtering by Parent Page becomes trivial; per-page completeness markers become straightforward; no restructure needed when new pages are added. Both name + node-id stored (e.g., `α1 Happy Path (\`419:6162\`)`).

**Patterns established Conv 186:**

- **Spatial banner-to-section derivation reliable on Matt's Figma** — All product-section banners on Components page sit at y=785 directly above their sections at y=981+. The one off-axis case (Brand at y=-266 above Brand at y=-70) is the only deviation. 11/11 derived mappings matched expected sections in parallel-probe verification. Spatial reasoning from `get_metadata` outputs is a valid short-circuit when frame layout is predictable.

- **Matt's "Last Touched" is the single drift signal** — Three text nodes per banner (title, status, date) all come back from a single `get_design_context` call — no need to drill into sub-nodes. Date format `May 20, '26` is unstable for diff (Matt could type `May 20, 2026` or `5/20/26`); always store both raw + ISO for stable comparison.

- **`Home /` vs `Page /` prefix convention** — Matt's frame-banner titles use a deliberate prefix: `Home /` denotes a state or variant of the home page (Feed default, Course Completed celebration); `Page /` denotes a standalone destination screen. Affects routing: Home variants could be states/overlays of an existing route; Page-prefixed screens need their own files. Added as 7th sub-assumption to [MATT-EXEC-FLAGS].

- **The lookup-driven discovery loop exposes architecture, not just data** — As 32 rows accumulated, route-family clusters emerged organically (Components singletons / Home variants / Course SubNav tabs / Page-prefixed flows including Enroll funnel + Session lifecycle). The lookup is *encoding architecture* as a side-effect of cataloging design state. Worth using this pattern for future intake of design data.

- **Matt's review passes are batched, not incremental** — All 32 rows added this conv share `Last Touched May 20, '26`. Matt promotes many frames to Ready For Dev in single review sessions, not incrementally. Future drift checks should expect bulk-update patterns — when a new Last Touched date appears on N>5 banners simultaneously, that's one Matt session; treat as one response unit.

- **Figma MCP `get_design_context` works without selection on remote MCP** — Conv 180 `reference_figma_mcp_behavior.md` classified `get_design_context` as "selection-REQUIRED" (needs user-clicked layer in Figma desktop). Conv 186 evidence: 11+ parallel probes against arbitrary node-IDs returned full JSX without any active Figma desktop selection. With explicit node-IDs the selection requirement is bypassed; "selection-required" applies only when probing the *currently-selected* node without supplying an explicit ID. Memory entry update needed (captured in extract §Uncategorized).

- **Name-collision drift catches: section-name vs banner-title** — Two cases this conv: section frame `Button Primary` (`40:482`) has banner title `Buttons` (plural); user-supplied label `Page Template` maps to Matt's banner `Layout Desktop`. Per `feedback_external_source_of_truth_first.md` designer-supplied-catalogues rule, the banner is the authoritative product label. Preserve both in lookup: banner as canonical title, frame name as cross-reference, user label as semantic alias when supplied.

- **`ControlBar.tsx` purpose discovered retroactively via lookup** — `ControlBar.tsx` existed in `/matt/` directory but was not on Matt's Components page — flagged as "page-level shell" in Conv 185. When row 14 (Page / Session During) was added Conv 186, ControlBar.tsx's purpose became obvious — it's the in-session control bar for the active video call view (wraps BBB/PlugNmeet via VideoProvider abstraction). Orphaned components without a clear design home often resolve when more design data is captured. Don't delete; wait for the lookup to fill in.

**New deferred subtasks spawned Conv 186:**

- [ ] **[TXTBTN]** Conv 186 — Watch task: "inline text-styled action button" pattern repeating across Phase 5 routes. SocialPost.tsx "Show More" button (line 134-142) uses inline `text-text-primary underline` styling — close to EntityLink semantics but mismatched (button vs anchor, fixed vs entity-cascade color). Track for repeat occurrences; consolidate into a new primitive (e.g., `TextButton`) if 3+ instances appear during Phase 5.

- [x] **[MATT-IDX-AUDIT]** Conv 187 — **COMPLETE.** Audited `src/pages/matt/index.astro` per `feedback_reuse_existing_components.md`; converted 6 placeholder `<article>` cards (hand-rolled Card output) to `<Card>`. Gates green.

- [x] **[STARS2-ICN]** Conv 187 — **COMPLETE.** Harvested `stars_2` from Figma asset URL (native 20×20); wrote `stars-2.svg` (fill `var(--fill-0,white)` → `currentColor`, mask rect → `#D9D9D9`). Renders correctly beside 24×24 siblings via the per-icon viewBox registry. Consumed by CourseInFeed.

- [x] **[ACCESSIBILITY-ICN]** Conv 187 — **COMPLETE.** Harvested `accessibility_new` from Figma asset URL (native 20×20); wrote `accessibility-new.svg` (same normalization as stars-2). Consumed by CourseInFeed.

- [ ] **[HOWTOREG-ICN]** Conv 186 — Harvest `how_to_reg` Material icon. Identified during Happy Path probing. Folds into the side-effect harvest workflow codified in [MFRD-LOOKUP].

- [ ] **[ASSET-SWEEP-GATE]** Conv 186 — Add Figma-URL grep guard to `/w-codecheck` as a Check 9: `grep -rE 'figma\.com|mcp/asset' src/` → must return 0 matches. Prevents 7-day expiring URLs from sneaking into committed code. Codifies the Conv 186 [ASSET-SWEEP] verification as a permanent gate.

- [ ] **[FIGMA-MCP-DOC-HARVEST]** Conv 186 — Add "asset harvest discipline" section to `docs/reference/figma-mcp.md`. Document: (a) the 7-day expiry constraint on `mcp/asset` URLs; (b) the curl + perl-pi normalization pattern for vector source SVGs (`fill="var(--fill-0, #hex)"` → `currentColor`); (c) the side-effect Material-icon harvest workflow tied to drift-check probes; (d) the [ASSET-SWEEP-GATE] codecheck guard.

- [ ] **[MFRD-LOOKUP]** Conv 186 — Permanent maintenance task for `.scratch/matt-frames-ready-for-dev.md`. Lifecycle: (a) populate as user supplies URL pairs; (b) run drift checks via cheap status-banner probes comparing stored Last Touched to current; (c) when drift detected, deep-probe frame to surface changes; (d) every deep probe scans `<img data-name>` instances and auto-creates `[<ICON>-ICN]` tasks for unharvested icons; (e) graduates to `docs/reference/matt-frames-ready-for-dev.md` at MMP-PH5 (or earlier per Conv 186 §Uncategorized recommendation — file is now 32 rows + completeness markers, substantially complete).

- [x] **[MATT-SUBNAV-ROUTING]** Conv 186→188 — **COMPLETE Conv 188.** Created `/matt/course/[slug]/[...tab].astro` mirroring `/discover/course/[slug]/[...tab].astro`: `VALID_TABS = ['feed','modules','creator','teachers','reviews','resources']`, invalid → 302 redirect to base, shell (breadcrumb + SubNav + CourseHeader) + per-tab placeholder body. Fixed a latent `SubNav.astro` active-state bug — `startsWith` prefix matching kept the section-index item (About, whose href is a prefix of all tab hrefs) Selected on every child route; replaced with **most-specific-match-wins** (single longest matching href across items+subItems). Routing demonstrated live in the Chrome bridge across all 7 tabs (URL reported per click; `matt-subnav-routing.gif` exported → `.scratch/screenshots/`). Verified via curl: base→About Selected; `/feed`→Feed Selected + About demoted; `/bogus`→302. Gates green (tsc 0; astro check 1256 0/0/0; lint clean). Replaced the deleted [MATT-CREATOR-TAB] — Creator is now one of the tabs, not a separate route.

**Carry-forward observations Conv 186:**

- **`reference_figma_mcp_behavior.md` memory entry has a stale claim.** Says `get_design_context` requires user-clicked layer selection. Conv 186 evidence (11+ parallel probes against explicit node-IDs without Figma desktop selection) contradicts this. Memory update needed: distinguish "selection-free with explicit node-ID" from "selection-required when probing the user's current selection".

- **Lookup file ready for `docs/reference/` graduation now, not at MMP-PH5.** Originally planned to graduate at MMP-PH5, but the file is now 32 rows + 3 completeness markers + full workflow doc — substantially complete. Earlier graduation (next conv or MMP-PH4) would put it in canonical location while it's fresh.

## Conv 187 Items

**Completed Conv 187 (MATT-DESIGN-PUSH active — MMP-PH4 re-render + per-icon viewBox + CourseHeader re-validation + addressability resolution):** see [MMP-PH4], [CMP-ICN-REGISTRY], [DARK-HERO-VARS], [STARS2-ICN], [ACCESSIBILITY-ICN], [MATT-IDX-AUDIT], [MATT-EXEC-FLAGS] entries (checked off above). Also closed memory-verification tasks [GVD-SELFREE-VERIFY] + [MCP-SEL-MISFIRE] — `get_variable_defs(519:9096)` probed with explicit nodeId and no Figma desktop selection returned the full Variable map, confirming ALL Figma read tools are selection-free given a nodeId; "selection-required" tool class retired in `reference_figma_mcp_behavior.md` + MEMORY.md.

**CourseHeader re-validated to Matt's Default frame (reverses Conv 184/185 creator trio):** Probed `517:8935` (Default variant of 3-variant set `517:8934`) → found `CourseHeader.astro` had drifted. Matt shows all metadata as plain WHITE IconLabelChips over the dark image, NOT the UserIcon + EntityPill + EntityLink creator trio Convs 184/185 built. Rewrote `CourseHeader.astro` → `CourseHeader.tsx` to match Matt (white on-dark IconLabelChip ×4, course Button CTA, Primary-Light back button, added missing student count). User confirmed ("B" — keep the reversal). The trio still belongs in the future "Meet the Creator" tab. (External-source-of-truth + C178-REVAL precedent.)

**New deferred subtasks spawned Conv 187:**

- [ ] **[CH-DOCSYNC]** Conv 187 — `matt-design-system.md` doc-sync: replace the CourseHeader creator-trio documentation (UserIcon + EntityPill + EntityLink) with the re-validated IconLabelChip on-dark chip rendering. Doc still describes the old trio. Routed to this /r-end's docs agent + TaskCreate.

- [ ] **[CH-VARIANTS]** Conv 187 — Build CourseHeader Enrolled (`597:6504`) + Scheduled (`685:13240`) variants. Only the Default variant was re-validated/built this conv. Sequence when MMP-PH5 touches enrolled-state course pages.

## Conv 188 Items

**Completed Conv 188 (MATT-DESIGN-PUSH active — MMP-PH4.5 SubNav routing + course-tab decomposition):** [MATT-SUBNAV-ROUTING] done (SubNav most-specific active-state fix + `[...tab].astro` route; routing demoed live, GIF exported); [RESTAB] + [TCHTAB] course-tab bodies built (Option A per-tab components); [MOD-SCHEMA] resolved (Session↔Module 1:1, Matt "Module"=Sub-Module); [ENTITY-CASCADE-BUG] fixed. See those entries (checked off above) + the [MATT-EXEC-PG2] subtask list. Branch `jfg-dev-13-matt` retained; full baseline run (build 6.30s clean; test 6453 passed / 371 files).

- [x] **[MOD-SCHEMA]** Conv 188 — RESOLVED. Matt's Modules frame groups "N Modules" under "1-on-1 Sessions", conflicting with the 1:1 session-module design. User clarified the real product model: every session has exactly one Module; Matt's/creators' nested "Modules" are **Sub-Modules** (term misuse). No session→many-modules data model needed. Saved to memory `project_module_submodule_model.md`; unblocks [MODTAB] (build each card as one session/module with an inner "N Sub-Modules" count).

- [x] **[ENTITY-CASCADE-BUG]** Conv 188 — FIXED. A role-color "corner dot" reading `var(--Entity-Primary)` rendered gray; live-DOM probe showed the var correct at the element but computed color = `:root` default. Root cause: `tokens-tailwind-bridge.css` declared cascade-driven `--color-entity-primary/background` under plain `@theme`, which resolves the inner `var(--Entity-*)` once at `:root` so utilities ignore the use-site cascade. This had **silently broken EntityPill / EntityLink / UserIcon-initials role colors app-wide** (all rendered the gray default inside `.entity-*` contexts). Fixed by moving the two entity tokens to a new `@theme inline` block (emits the variable reference directly so it re-evaluates at the element). Re-verified on the showcase: pills now resolve Course/Creator/Student backgrounds; role dot purple. Surfaced via the opt-in `roleDot` prop added to `UserIcon.tsx` (enabled in TeachersTab; default off, existing avatars unchanged). **New standing pattern:** cascade-driven Tailwind 4 tokens MUST live in `@theme inline`; static tokens stay in plain `@theme`.

**New deferred subtasks spawned Conv 188:**

- [ ] **[SHOWMORE]** Conv 188 — Show-More affordance for Teachers + Reviews tabs. Matt's frames show a "Show More" control; omitted from the Conv 188 TeachersTab build (single bio card shown). Build when populating multi-item states.

- [x] **[SNV-ICONS]** Conv 188 → **DONE Conv 190.** Probed Matt's course page `419:6162` for the real SubNav glyphs and mapped through the icon catalogue: Course Feed=`feed` (newspaper), Modules=`module` (memory), Resources=`resource` (library_books), Reviews=`review` (rate_review), Teachers=`student-teacher` (grad cap), Meet the Creator=`creator`. About has NO icon'd row in Matt's SubNav (Peerloop-added overview) → `info` as a documented extrapolation (Decision 4). Wired `icon` into the route's `courseTabs` array (now `buildCourseTabs` in `_course-tabs.ts`).

- [x] **[MNV-STYLE]** Conv 188 → **DONE Conv 190** (then superseded/extended by [SBAR-REWRITE]). Replaced Sidebar emoji placeholders (🏠📚🎓💰🔔👤◀) with MattIcon glyphs (home/course/student-teacher/feed/earnings/notifications/user-icon/arrow-left) probed from Matt's Main Nav `108:4468`. NavItem typography already Matt-faithful from Conv 183. The deeper font-weight/size/description + active-pill mismatches the user later reported drove the full [SBAR-REWRITE] (see below).

- [ ] **[MEM-ICON-COUNT]** Conv 188 — MEMORY.md Icon System count is stale (now **43** Matt SVGs after `folder.svg` Conv 188 + `chevrons-left.svg` Conv 190 harvests; also reconcile any `MattIcon.tsx` references). Update the count.

- [x] **[CRS-MOBILE]** Conv 189 → **DONE Conv 194** (literal scope). At ~500–768px the course SubNav + tabs do NOT overflow/clip/wrap (scrollW 282 == clientW); AppNavbar rail correctly off-canvas with hamburger present. (Chrome on macOS clamps the window to ~500px min, so true 375/390 phone width couldn't be reached — verified at the narrowest reachable width.) This verify surfaced the AppNavbar slide-out panel bleed below lg → fixed as [MPB] (see NAV-RETROFIT status line). Any deeper Matt-frame mobile breakpoint work for the per-tab bodies remains under [MATT-EXEC-EXT] Phase 6 responsive.

- [ ] **[FEED-COMPOSER-USER]** Conv 189 — On `/matt/` the Feed composer shows a "?" avatar / disabled state when logged-out (`canPost` false). Acceptable for the design demo but note for the real auth-aware flow.

- [x] **[COURSE-TAGS-LOADER]** Conv 189 → **FIXED Conv 190.** The `course_tags` junction has no `name` column, so `SELECT *` typed `CourseTag={tag_id,name}` left `name` undefined at runtime. Added `JOIN tags t ON ct.tag_id = t.id` (`courses.ts:327`), selecting `ct.tag_id, t.name ORDER BY t.display_order`. Verified tsc 0 / `tests/ssr/courses.test.ts` 20/20.

## Conv 190 Items

**Completed Conv 190 (MATT-DESIGN-PUSH active — MATT-EXEC-PG2 course-tab polish + Sidebar/shell rewrite):** course-tab bug-fixes ([COURSE-TAGS-LOADER]+[REVIEW-COUNT]), SubNav leading icons ([SNV-ICONS]), the duplicated-route consolidation ([RTCONS]), sidebar emoji→MattIcon ([MNV-STYLE]), and a full Sidebar+shell rewrite to Matt's Layout Desktop ([SBAR-REWRITE], scope B). See the checked-off entries above + the [MATT-EXEC-PG2] subtask list. All five baseline gates green this conv (test 6453 passed / 371 files). Branch `jfg-dev-13-matt` retained; dev server left running on 4321 per user request.

- [x] **[REVIEW-COUNT]** Conv 190 — `[...tab].astro:224` Reviews header passed `data.course.rating_count` (34 — the star-rating denominator) above only 2 rendered review cards; swapped to `data.reviews.length`.

- [x] **[RTCONS]** Conv 190 — Consolidated the two course-page routes into one catch-all (Decision 1). Browser verification of [SNV-ICONS] found icons rendered on `/feed` etc. but NOT the bare About page — a second `courseTabs` array lived in a separate `index.astro`. First extracted a shared `_course-tabs.ts` (`buildCourseTabs(slug)`, `_`-prefix excludes from routing), then folded About into `[...tab].astro` as the empty-segment `'about'` view (renders body instead of redirecting), added conditional title/breadcrumb, deleted `index.astro`, regenerated `route-map.generated.ts`. Verified all 7 routes + invalid-tab 302 (no loop). Removes the whole "edited one route, forgot the other" drift class + the redirect-loop lock-in.

- [x] **[SBAR-STICKY]** Conv 190 — Sidebar aux cluster (Earnings/Notifications/Profile) sat at page-bottom not viewport-bottom (the `<aside>` stretched to full body height; `flex-1` nav pushed aux down). Added `lg:sticky lg:top-0 lg:h-screen lg:overflow-y-auto`. Verified pinned while scrolling. (Same flex-child stretch root cause later seen on SubNav — fixed via `self-start` in [MATT-COURSE-POLISH].)

- [x] **[MATT-COURSE-POLISH]** Conv 190 — Made the course SubNav `lg:sticky lg:top-16 lg:self-start` (self-start collapses it to content height so the border-r divider doesn't trail into empty space + gives sticky slack); bumped main bottom padding. **Letter-spacing token fix (design-system-wide):** `tokens-typography.css` had baked Figma's `-2.2` tracking as `-2.2px` across all four "Body larger sizes" tokens — Figma's value is `-2.2%` = `-0.022em` (~6× too tight). Fixed all four (body-medium, -medium-bold, -large, -large-medium). Surfaced by user-reported crammed "Entrepreneur" text in `text-body-medium-bold`.

- [x] **[SBAR-REWRITE]** Conv 190 — Sidebar + shell rewritten to match Matt's Layout Desktop `81:1483` (Decision 2 — scope B: sidebar AND shell, so the active pill pops against a grey page). **Shell** (`AppLayout.astro`): page bg `#f8fafc`, content = white rounded-20 card + shadow, sidebar transparent, body `lg:p-16 lg:gap-16`, now fetches the logged-in user. **Sidebar** (`Sidebar.tsx`): collapse `«` double-chevron top-right (harvested `keyboard_double_arrow_left` → `chevrons-left.svg`, **43rd icon**), active item = white pill always, bottom cluster with descriptions (Earnings+"Learn More", Notifications, Profile). Supporting: `MainNav.tsx` active→'Main' pill regardless of children + gap `16→24`; `UserIcon.tsx` gained `size` prop (24/40); Logo sized `Medium`→`Small` per user. **Profile role logic** — new `src/lib/roles.ts` (`userRoles()` + `describeRoles()`) on hierarchy Admin>Creator>Teacher>Moderator>Student (sourced from `UserProfileHeader.tsx`; Student base-only): 1 role→role, 2→"A, B" higher-first, 3+→"A + N more"; Visitor when not logged in (filled `user-icon` circle + "Visitor", links `/login`). `AppLayout` selects all 5 capability flags and builds the label via `describeRoles` (Decision 3). Verified `/matt/` Home-pill, collapsed mode, course page, and the Visitor state live.

**New deferred subtasks spawned Conv 190:**

- [ ] **[PROF-ROW-VERIFY]** Conv 190 — Visually verify the logged-in Sidebar Profile row (avatar + name + e.g. "Admin + N more"). Only the Visitor fallback was confirmed in-browser this conv (dev session isn't authenticated; user logs in as Brian off-chat via real password entry). The `describeRoles` logic is type-checked and traced correct but the avatar+name+role rendering hasn't been eyeballed.

## Conv 192 Items

**Completed Conv 192 (NAV-RETROFIT home-page spacing fixes + MATT-DESIGN-PUSH doc split + /matt/courses index):** home footer + dashboard main-panel spacing fixed in place (NAV-RETROFIT, hijacked-step utilities → arbitrary px), [LEGACY-SPACING-AUDIT] quantified (3,894 utilities / 354 files vs 11 matt files) and decided do-nothing-broad; matt-design-system.md split into a folder ([MDS-SPLIT]) + DOC-DECISIONS.md convention entry; new `/matt/courses` index ([MATT-COURSES-INDEX], approach B). See checked-off entries below + the updated NAV-RETROFIT / MATT-DESIGN-PUSH block status lines. No baseline gate run claimed this conv (doc-split + new thin page + spacing-utility swaps; gates carried unverified from Conv 191).

- [x] **[FOOTER-PAD]** Conv 192 — `Footer.astro` full + compact variants: 7 hijacked-step utilities → arbitrary px (`py-[48px]`/`px-[16px]`/`lg:px-[32px]`/`gap-[32px]`/`pt-[32px]`/`gap-[16px]`/`mt-[16px]`). Restores home-page footer padding without reverting the Conv 174 spacing bridge. DOM-verified in Chrome bridge (compact variant = logged-in dashboard).

- [x] **[DASH-ICONS]** Conv 192 — `index.astro` dashboard main panel: icon containers + clock `h-12 w-12`→`h-[48px] w-[48px]` (the hijacked `12`-step had clipped 24px glyphs into 12px boxes), plus `mb-8`→`mb-[32px]`, `gap-4`→`gap-[16px]`, `mb-4`→`mb-[16px]`, `py-8`→`py-[32px]`. Verified live.

- [x] **[LEGACY-SPACING-AUDIT]** Conv 192 — quantified the Conv 174 spacing-bridge blast radius (**3,894** hijacked-step utilities across **354 legacy files** vs **11 `matt/` files** depending on the new meaning) and resolved it: **do-nothing-broad** — leave the override, fix spacing per-component as the legacy→Matt migration reaches each (the mechanical sweep would be discarded by that migration; reaffirms Conv 191 "don't revert" with the asymmetry now known). Stays open as an opportunistic per-component reminder, NOT a sweep. Remediation recipe: hijacked-step utility → arbitrary `[Npx]`.

- [x] **[CH-DOCSYNC]** Conv 192 — verified ALREADY DONE (no action). matt-design-system.md (now `06-component-primitives.md`) lines 1005–1007 already document the Conv 187 CourseHeader creator-trio→on-dark-chip reversal; completed by Conv 187's docs agent, correctly absent from TodoWrite.

- [x] **[MDS-SPLIT]** Conv 192 — matt-design-system.md (1,717 lines / 145 KB, 6 numbered sections, §5 conflating 3 concerns) split into `docs/as-designed/matt-design-system/` (INDEX.md + 01–07 concern files via `sed` line-range slices + breadcrumb headers; §5 split at line 642/Button into `05-color-and-tokens.md` + `06-component-primitives.md`). Old path → stub pointer with §N→file mapping. **Byte-for-byte lossless** verified (reconstructed split body vs original line range = identical diff). `docs/INDEX.md` line 88 repointed to the folder INDEX. Convention recorded in `DOC-DECISIONS.md` §2 (contrasted vs Conv 173 single-file pre-plan decision: living multi-concern spec vs one-time artifact). 103 inbound refs (mostly immutable session archives) preserved via the stub at near-zero cost.

- [x] **[MATT-COURSES-INDEX]** Conv 192 — new `src/pages/matt/courses.astro` (approach B — thin Matt-native index: Matt AppLayout + SubNav, reuses existing `fetchCourseBrowseData` loader, grid of existing `CourseEmbedCard` whose CTA already targets `/matt/course/[slug]`). Fills the 404 where `/matt/index.astro`'s SubNav linked to `/matt/courses`. Rejected approach A (copy `/discover/courses` + retarget link base — the `/discover/course/${slug}` hrefs are hardcoded in shared `ExploreCard.tsx`/`ExploreCourseTabs.tsx`/role-tab components, so retargeting = forking 5+ production components). DOM-verified: 6 cards, 6 CTAs all `/matt/course/[slug]`, click-through resolves.

**New deferred subtask spawned Conv 192** (also in DEFERRED table row 21):

- [ ] **[DISC-UNIFY]** Conv 192 — Migrate `/discover/courses` onto `fetchCourseBrowseData` so legacy discover and `/matt/courses` share one loader. Blocked: `fetchCourseBrowseData` lacks `primary_topic_id` (discover filters on it) — add the field to the loader first.

## MATT-DESIGN-PUSH Execution Phases (spawned Conv 173 from [MATT-PRE-PLAN])

All 7 phases follow `docs/as-designed/matt-pre-plan.md` §9 execution sequence. Each phase is its own conv (or bundles when scope allows). Decisions locked Conv 173 — see `matt-pre-plan.md` §4 Resolution summary.

- [x] **[MATT-EXEC-TKN]** Conv 174 — Phase 1 token files landed on `jfg-dev-13-matt` (branched from `jfg-dev-12`). `src/styles/tokens-primitives.css` (~155 lines, 15 colors kebab-case per Decision 2 + 9 radius/7 shadows/15 opacity/7 z-index/8 duration/10 spacing rem-pixel-named per Decision 1=C), `src/styles/tokens-semantic.css` (~165 lines, 14 semantics Title-Case-dash with cascade preserved via `var()` chains — `--Student-Primary: var(--Primary-Default)` NOT flattened, Entity multi-mode at :root + 3 mode classes, Icon-Size 2 tokens, Button base + 6 variant classes with seamless-edge pattern), `src/styles/tokens-tailwind-bridge.css` (~80 lines, color re-exports additive, Matt typography ramp additive, **spacing override per Conv 174 user choice B** — `--spacing-4: var(--space-4)` through `--spacing-64`, accepting global utility-scale break across non-`/matt/*` per Decision §1 below). `src/styles/global.css` updated with single `@import './tokens-tailwind-bridge.css';` line. Snap policy applied (44/49→48, 17→16, 23→24). All 5 baseline gates green (tsc 0 / astro 1215/0/0/0 / build 6.13s). Built CSS verified: cascade chains intact, existing `--color-primary-*` untouched.

- [x] **[MATT-EXEC-SHL]** Conv 174 — Phase 2 layout shell landed. 5 components authored under `src/{layouts,components}/matt/`: `HeaderBar.astro` (slot-based per Decision 7=C — header-left/center/right slots; fixed-top at <lg; mobile=brand+icons row, tablet portrait=centered brand), `SubNav.astro` (items-prop based; vertical-left strip at lg: 196px wide; horizontal-scroll fallback at <lg as Phase 4 drawer stub), `Sidebar.tsx` (React island, useState toggle expanded/collapsed 220/70px, 5-item primary nav + earnings/notifications/profile chip + brand), `ControlBar.tsx` (React island, bottom-fixed pill, 6 nav icons with `tabletOnly` flag — 4 icons at <sm + 6 icons at sm:; z-30), `AppLayout.astro` (composes all 4; Sidebar `hidden lg:flex`, HeaderBar/ControlBar `lg:hidden`; named slots header-bar/entity-header/role-tab-bar/sub-nav + default; entity prop applies `.entity-{creator|student|course}` class). Gates green: tsc 0 / astro 1220/0/0/0 / build 6.13s. Built CSS verified: bridge color/typography utilities (`--color-text-default`, `--color-entity-background`, `--text-body-default`, etc.) now emit because components consumed them — confirms Tailwind 4's on-demand `@theme` emission behavior (see Conv 174 Learning #1). 3 positioning refinements deferred → `[MSH-REFINE]`.

- [x] **[MATT-EXEC-PG1]** Conv 175 — Phase 3 first `/matt/course/[slug]` page end-to-end. Built `src/components/matt/entity/CourseHeader.astro` (dark image hero with gradient overlay; iterated to 2-column layout: LEFT title + tagline + metadata row creator/rating/level; RIGHT ✓-includes list + "$X • Enroll Now ›" pill; top-right overlay back-chevron + book glyph; min-height 240px via inline style — see [TWLG-MIN-H]) and `src/pages/matt/course/[slug]/index.astro` (thin page using existing `fetchCourseTabData` loader; AppLayout entity=course; SubNav 7 course tabs: About / Course Feed / Modules / Meet the Creator / Teachers / Reviews / Resources; About body with 4 Cards: About / What you'll learn (2-col objectives) / Prerequisites / Who this is for). HTTP 200, astro check clean. Visual diff iteration vs Matt's `Course.svg` complete.

- [→] **[MATT-EXEC-PRM]** Conv 175 — Phase 4 scope A complete (3 of 8 primitives + retrofit). Built: `Button.tsx` (6 variants primary/outlined/course/student/creator/default × 3 sizes sm/md/lg; renders `<a>` if href else `<button>`; matt-design-system.md §6 Button table exactly), `Card.astro` (white-fill container with padding scale sm=12/md=16/lg=24/none + optional borderless), `SectionTitle.astro` (semantic level h2/h3/h4 × visual size large/medium/small). Retrofitted CourseHeader CTA to `<Button variant="course">`; retrofitted course-page body 5 sections → 4 sections each wrapped in `<Card padding="lg">` with `<SectionTitle>` headings (What's included moved to hero overlay per visual diff). Visual fidelity iteration with Matt's `Course.svg` — 6 fixes landed (Course Feed tab, 2-col objectives, What's Included as hero overlay, Meet the Creator as SubNav tab not body card, hero 2-column restructure, hero overlay glyphs). Remaining 5 primitives spawned as [MATT-EXEC-PRM-2].

- [x] **[MATT-EXEC-PRM-2]** Conv 176 — Phase 4 scope B complete: 5 primitives + 1 internal demo wrapper landed on `jfg-dev-13-matt`. `Module.tsx` (lesson row icon+eyebrow/title/duration, default/active states, direct entity-utility variants), `Note.tsx` (sticky-note pastel-yellow annotation `#FFF1B8` until `[NOTE-YELLOW]` token lands), `ToDoItem.tsx` (**fully controlled — no `useState`**, parent owns checked+onChange; green-filled checkbox glyph; direct entity-utility for active row), `SocialPost.tsx` (composite feed item: author header + body + optional embed slot + footer like/comment/commenters), `RoleTabBar.tsx` (Peerloop multi-role tab switcher; anchor + button modes; role-specific primary/background tokens; safety-returns null when ≤1 role), `_SocialPostDemo.tsx` (internal underscore-prefixed React wrapper hosting Course-minicard embed JSX). `/matt/index.astro` extended with Phase 4 Primitives showcase section. Final verification: HTTP 200, body 33,648 chars, 4× `bg-student-background` / 3× `bg-course-background` / 2× `bg-creator-background` in HTML, all 5 primitives + 1 social-post-embed render, tsc clean, astro check clean (0/0/2 pre-existing hints). Remaining entity headers (`TeacherHeader`, `StudentHeader`, `CreatorHeader`) deferred to Phase 5 alongside the routes that consume them.

- [x] **[MATT-EXEC-CMP]** Phase 4.5 — Component Import from Matt's Figma Components page (spawned Conv 178). **Substantially complete Conv 185** — all 13 of Matt's named primitives now built (ICN → BTN → MNV → SNV → ENT decomposition → CHAT → ANCH-REST → BRN + REFACTOR-COURSEHEADER). Remaining gaps are Phase 6 extrapolation work: [DARK-HERO-VARS], [VIDEO-COMMENT-ICN], [PLAY-CIRCLE-ICN] (each tracked in DEFERRED). Phase 5 [MATT-EXEC-PG2] now unblocked as pure thin-shell assembly. Per-subtask pattern: open Figma SVG → `qlmanage -t -s 1200 -o /tmp <file>.svg` SVG→PNG inspection (per [MPV]) → spec variants/props/breakpoints/states → build .tsx (React island) or .astro (static) in `src/components/matt/ui/` for primitives or `src/components/matt/` for composites → add to `/matt/index.astro` showcase section → visual-diff vs SVG → all 5 baseline gates green. Subtasks dependency-ordered (each foundational for the next):
  - [x] **[MATT-EXEC-CMP-ICN]** Conv 178 harvest + Conv 182 code-integration **COMPLETE** — folded into [MMP-PH2]. Harvest (Conv 178): 39 icons extracted from Figma with uniform `viewBox="0 0 24 24"`, 19 renames with 3 Material-Icon→Matt-label semantic corrections, Property-1 variants flattened to Arrow/Level/Bookmark, `_INDEX.md` documents catalogue-label-is-authority rule. Code-integration (Conv 182): `src/components/matt/icons/MattIcon.astro` consumer via Vite `?raw` glob + 39 SVGs in `svg/` subdir; fills normalized to `currentColor` (1 MD3 `#1C1B1F` outlier caught + fixed). See [MMP-PH2] above for full detail.
  - [x] **[MATT-EXEC-CMP-BTN]** Conv 183 — Buttons COMPLETE. `Button.tsx` rewritten with **strict-B 5-value `property1` enum** (`Default | Hover | Large | Small | SmallHover`) mirroring Matt's Figma Property 1 exactly (Conv 178's "3-orthogonal" framing retracted as misframed — Property 1 conflates State + Size). All CSS extracted via MCP probes of 5 Figma nodes (`40:482` section + `1:284` Default + `513:14820` Hover + `1:292` Large + `360:11906` Small + `675:12314` SmallHover). 6 Color variants preserved; Hover/SmallHover use inline-style hardcoded gradient + border (Matt's design has partial coverage — Hover is Primary-only with no Variable Mode awareness; non-Primary + Hover combos render Primary-darkened, Phase 6 [MATT-EXEC-EXT] for variant-aware extrapolation). Disabled kept as standard a11y orphan via `[disabled]` CSS rule. `_SocialPostDemo.tsx` migrated `size="sm"` → `property1="Small"`. matt-design-system.md §5 Button rewritten with empirical variant matrix. tsc 0; astro check 1233 0/0/0; dev HTTP 200.
  - [x] **[MATT-EXEC-CMP-MNV]** Conv 183 — Main Nav COMPLETE. 3 new components: `MainNav.tsx` (props-driven orchestrator, exports `NavItemData`/`NavSubItemData` interfaces), `NavItem.tsx` (3 Property 1 variants: Default+Selected flat row, Main = white pill with parent + divider + Sub Nav slot), `NavSubItem.tsx` (2 Property 1 variants: Default+Selected, color shift only). Architecture decisions (D1/D2/D3) made via **AskUserQuestion + ASCII mockup previews** (user pushed back on text-only descriptions → established new pattern of rendering Matt's Figma reference + each candidate option as side-by-side ASCII): **D1 = Route-driven Main pill** (auto-positions around active section, derived state, no toggle), **D2 = Keep 70px collapse mode** as Peerloop extension (Sidebar.tsx renders separate icon-only nav when collapsed since 220px Matt layout doesn't compress gracefully), **D3 = Props-driven** data model (`items: NavItem[]` enables Admin/Teacher sidebar variants from one component). `Sidebar.tsx` refactored to consume `MainNav`; retains Peerloop shell (brand mark + Earnings/Notifications/Profile + collapse toggle). CSS extracted via MCP probes of 4 critical variants (`108:4614` Default NavItem, `150:8585` Main NavItem, `108:4615` Default NavSubItem, `110:5097` Selected NavSubItem). matt-design-system.md got new `### MainNav (3-variant composite primitive — extracted Conv 183)` subsection. tsc 0; astro check 1236 0/0/0; dev HTTP 200 with SSR confirming Home as Main pill + Community Feed as Selected child.
  - [x] **[MATT-EXEC-CMP-SNV]** Conv 184 — Sub Nav COMPLETE. Rewrote `SubNav.astro` container + new `SubNavItem.astro` (3 Property 1 variants Default/Hover/Selected + Selected-with-subnav expanded). Resolved Conv 183 "Need 3+ Levels" open question via Figma probe of `502:12864` (base) + `622:18616` (expanded) — NOT multi-level, it's base + Selected-expanded. Switched container to `currentPath`-derived active state (fixing latent Conv 175 bug where `active` per-item was never consumed). Added `as Props` Astro assertion. 2 callers updated (`/matt/index.astro` + `/matt/course/[slug]/index.astro`) to pass `currentPath={Astro.url.pathname}`. matt-design-system.md + `.scratch/matt-figma-pages.md` updated with probe findings.
  - [x] **[CMP-UICN]** Conv 184 — UserIcon primitive COMPLETE. Built as React `UserIcon.tsx` (initials avatar with entity-cascade colors; later extended with `avatarUrl?` for image-mode — see [CMP-UICN-IMG]). Probe of `1:35` revealed Matt drew initials-only, NOT a role-icon container (corrects earlier visual-inspection assumption). New leaf primitive; first of Entities collection decomposition (Option C per user direction).
  - [x] **[CMP-EPILL]** Conv 184 — EntityPill primitive COMPLETE. React `EntityPill.tsx` role-context badge. Confirmed inherits via Entity cascade (`bg-entity-background` / `text-entity-primary`).
  - [x] **[CMP-ELINK]** Conv 184 — EntityLink primitive COMPLETE. React `EntityLink.tsx` clickable entity-name text link.
  - [x] **[CMP-CHIP]** Conv 184 — IconLabelChip primitive COMPLETE. React `IconLabelChip.tsx` icon+small-label metadata pair (icon 20 + label 12 tertiary gray, regardless of entity context). Recurring 25+ instances across Post Anchors + Social Post. **Exception to tokenize-only-matt-variables principle** — extracted despite Matt not naming it as a Figma component, justified by explicit user "make these reusable" directive; honest-orphan marker in file header documents the deviation.
  - [x] **[CMP-ANCH-COURSE]** Conv 184 — CourseAnchor COMPLETE (first anchor row). React `CourseAnchor.tsx` composing UserIcon + EntityPill + IconLabelChip + Button + MattIcon. Locks in Option C architecture: 9 distinct anchor row components, no shared `AnchorRow` base.
  - [x] **[CMP-ANALYTIC]** Conv 184 — AnalyticCount primitive COMPLETE. React `AnalyticCount.tsx` Social Post footer count badge — Default and 1+ variants with auto-flip-based-on-label behavior. Extracted from SocialPost.tsx inline `ActionPill()` helper.
  - [x] **[CMP-UICN-IMG]** Conv 184 — UserIcon extended with `avatarUrl?` for image-mode (strict-B extrapolation per `feedback_tokenize_only_matt_variables.md`; header annotated). Pulled forward from Phase 6 because SocialPost refactor needed real user images.
  - [x] **[REFACTOR-SOCIALPOST]** Conv 184 — SocialPost.tsx + _SocialPostDemo.tsx refactored to use Conv 184 primitives. Removed inline `Avatar()` / `ActionPill()` / `LikeIcon` / `CommentIcon`; imports UserIcon + IconLabelChip + AnalyticCount; flattened header to Matt's strict-B layout; replaced footer with 3 `<AnalyticCount>` instances (added `loves?` prop); removed avatar-preview commenters strip (Conv 175 extrapolation not in Matt's design). Breaking change: `roleIcon: ReactNode` → `roleIconName?: string` (MattIcon name); removed `commenters: SocialPostCommenter[]` prop. _SocialPostDemo uses `<CourseAnchor>` as embed (replacing inline `CourseEmbed()`). **All Conv 184 primitives + MattIcon standardized on React (.tsx)** — Astro can import React but not the reverse, so primitives that may be consumed from both contexts must be React; 6 .astro files converted to .tsx and deleted.
  - [x] **[CMP-CHAT]** Conv 185 — Chat Bubble primitive COMPLETE. 2 variants Default/Us from Matt's `646:7540` (159×35; same viewBox `0 0 18.3597 15.0811`, but different paths — Matt drew pre-mirrored shapes rather than CSS transforms). `ChatBubble.tsx` with `property1: 'Default' | 'Us'` strict-B enum, currentColor tail with matching `text-*` class per variant (`text-gray-100` / `text-primary-default`). **Drift from strict-B:** dropped Matt's 159px canvas width in favor of `inline-flex max-w-[280px]` content-sizing (Matt's 159px is a Figma drawing placeholder, not a UX rule); documented in component docstring. /matt/ showcase added with 4 stacked messages (2 Default left + 2 Us right). Screenshot confirms correct rendering.
  - [x] **[CMP-ANCH-REST]** Conv 185 — All 8 remaining anchor row components COMPLETE. Built in single batch after probing 3 most-distinct shapes (Creator, Student-Teacher, Video Clip) to confirm structure: **CreatorAnchor** (entity-creator cascade, EntityPill "Creator", Button variant=creator "Learn More"); **CertificationAnchor** (no pill, no CTA); **ModuleAnchor** (no pill, no CTA); **ResourceAnchor** (no pill, default-variant Button "View"); **ReviewAnchor** (no pill, default-variant Button "Read"); **StudentTeacherAnchor** (entity-student-teacher cascade, pill label "Suggested" — NOT "Student-Teacher" per Matt's text; Button variant=student "View Teacher"); **VideoClipAnchor** (123×69 thumbnail with inline-SVG play-circle overlay; chat icon as substitute for `video_comment` — pending [VIDEO-COMMENT-ICN]; "Watch" button); **MilestoneAnchor** (no pill, default-variant Button "View"). 8 Card showcases added to /matt/ with realistic mock data. Screenshot confirms all 8 render correctly. (Locks in Option C: 9 distinct anchor row components, no shared base.)
  - [x] **[REFACTOR-COURSEHEADER]** Conv 185 — Creator section refactored to UserIcon + EntityPill + EntityLink trio in `.entity-creator` cascade per new reuse rule. Extended `CreatorRef` interface with optional `slug`, `initials`, `avatarUrl`. Updated caller `/matt/course/[slug]/index.astro` to pass `data.creator.handle` + `data.creator.avatar_url`. DOM screenshot confirms all 3 primitives render. **Caveat documented:** Rating/level/CTA stay inline because dark-hero contrast is incompatible with light-bg-optimized primitives (IconLabelChip uses `text-text-tertiary` gray; Button uses light bg). Spawned [DARK-HERO-VARS] as follow-up.
  - [x] **[MATT-EXEC-CMP-BRN]** Conv 185 — Brand primitive COMPLETE. Probed Matt's Brand section (`40:481`) containing Logo (`1:270`, 3 variants Large/Medium/Small) and Logo Mark (`35:144`, 3 variants Default/Medium/Small). Downloaded 4 SVGs (curl revealed Figma MCP asset URLs return SVG for vector sources — captured as Conv 185 learning in `reference_figma_mcp_behavior.md`). Normalized fills `var(--fill-0, #hex)` → `currentColor` via perl-pi. Wrote `LogoMark.tsx` (3 variants with their own hand-tuned viewBoxes — distinct MD5s per variant) and `Logo.tsx` (3 variants — Large stacks LogoMark Default + PeerLoop wordmark SVG; Medium/Small use Inter Semi Bold text). Refactored `Sidebar.tsx:85-91` from placeholder `∞ PeerLoop` text to use Logo Medium (expanded) / LogoMark Default (collapsed). /matt/ showcase added; Playwright screenshot verified all 6 variants. Final Components-page status: 100% Matt's named primitives built (13/13).

  Estimate: 2–4 convs total (CMP-ICN may be ~1 conv on its own; CMP-CHT + CMP-PNC + CMP-BRN can bundle if small). On completion: Matt's Components page reaches 100% coverage; Phase 5 [MATT-EXEC-PG2] unblocked as pure assembly work.

- [ ] **[MATT-EXEC-PG2]** Phase 5 — Remaining `/matt/*` pages. **Course-tab family decomposed Conv 188** (Decision: Option A — per-tab `.astro` body components rendered by a `tab ===` switch in `[...tab].astro`; index.astro/About untouched; shell duplicated across the two route files, accepted, noted for future dedup). **All 6 course tabs now built (Conv 188 [RESTAB]+[TCHTAB]; Conv 189 [CRTTAB]+[RVWTAB]+[MODTAB]+[FEEDTAB]) — the course-tab family is complete.** The **Enroll family** (`/matt/course/[slug]/checkout`) and **Session family** (`/matt/session/[id]/{prepare,room,after}`) plus `/matt/`, `/matt/login`, `/matt/teacher/[handle]`, `/matt/teacher/[handle]/schedule`, `/matt/certification/[id]` remain under this parent. Conv 188 triage corrected the Ready-for-Dev lookup (rows 3-8): the course tabs are NEW page-level card composites (SessionCard / ReviewCard / TeacherCard), NOT thin anchor-list shells as the lookup's "expected primitives" guessed; Matt's frames are happy-path instance snapshots (Resources = empty state only). **Depends on [MATT-EXEC-CMP] (Phase 4.5) completion** so all consumed components exist before pages assemble them; existing data fetchers reused. **Conv 190 shell rewrite ([SBAR-REWRITE], Decision 2):** the `/matt/*` shell now matches Matt's Layout Desktop `81:1483` — grey page bg (`#f8fafc`) + floating white rounded content card, transparent sidebar with always-white active pill, `«` double-chevron collapse, and a role-aware bottom Profile cluster (`src/lib/roles.ts` `describeRoles`; Visitor fallback when logged out). This is shell/assembly work shared by every remaining PG2 page, landed ahead of the Enroll/Session families.
  - [x] **[RESTAB]** ResourcesTab Conv 188 — built Matt's empty state; harvested `folder.svg` (40px Material icon, 42nd Matt icon) normalized to `currentColor`; wired into `[...tab].astro` switch; static (no API). Verified live.
  - [x] **[TCHTAB]** TeachersTab Conv 188 — header + bio-card composite reading live D1 via the SSR loader; role-based entity palette (`.entity-creator` purple = Creator / `.entity-student-teacher` blue, reconciling Conv 184's blue claim); Button `variant="student" property1="Small"`; mail icon = `message` (Conv 178 rename); stat chips mapped to real loader data (students_taught / rating_count) not Matt's demo "Courses Created". Verified live. Surfaced + fixed [ENTITY-CASCADE-BUG].
  - [x] **[CRTTAB]** CreatorTab Conv 189 — built props-driven (`CreatorTab.astro`) composing UserIcon/EntityPill/Button/IconLabelChip/MattIcon; identity/bio/3 computed stat chips from real loader data. The 4 sections with no schema counterpart (Expertise / Teaching Philosophy / Qualifications / Why-Learn) render Matt's verbatim copy as **static grey** via a `staticContent` prop (no schema change, per user directive — flip flag to restore color when data arrives); `CREATOR_STATIC` constants in the route. Cosmetic fixes: `leading-normal` on wrapping text (works around global `--body-default-line-height: 1`, root-cause deferred to [LH-VERIFY]); restored Matt's light-blue quote background. Verified live. (Bottom-spacing folded into [MATT-COURSE-POLISH]; mobile → new [CRS-MOBILE].)
  - [x] **[RVWTAB]** ReviewsTab Conv 189 — built (`ReviewsTab.astro`) reading the existing `course_reviews` table via a new loader query (not a schema change): per-review rating/body/author/timestamp real; reaction pills static (no reactions table). Reuses UserIcon/MattIcon/IconLabelChip/Button + the extracted `CourseEmbedCard`. Verified live.
  - [x] **[MODTAB]** ModulesTab Conv 189 — built (`ModulesTab.astro`) one card per `course_curriculum` row (1:1 per [MOD-SCHEMA]); number/title/description/duration all real (titles match Matt verbatim on `intro-to-claude-code`). The "N Modules" sub-count + "posts" pill omitted (no schema source; user chose "omit both"). Verified live.
  - [x] **[FEEDTAB]** Course Feed tab Conv 189 — built `MattCourseFeed.tsx` client island fetching the **existing** `GET /api/feeds/course/[slug]` (real Stream-backed activities; same API the legacy `CourseFeed.tsx` uses). Composer + SocialPost list; real posts verified live, no console errors. Frame `480:10833` user-supplied. Extracted `CourseEmbedCard.tsx` (shared embedded-course card) and refactored ReviewsTab to reuse it; added a viewer query + shared `courseEmbed` to the route. All six course sub-tabs now render in `[...tab].astro` (feed/modules/creator/teachers/reviews/resources).
  - **Conv 190 polish (course-tab family):** fixed two Conv 189 bugs ([COURSE-TAGS-LOADER] JOIN tags + [REVIEW-COUNT] reviews.length); added Matt-sourced SubNav leading icons ([SNV-ICONS]); **consolidated the two course-page routes into one catch-all** ([RTCONS], Decision 1 — `index.astro` deleted, About now the empty-segment `'about'` view, shared `_course-tabs.ts` is the single SubNav-config source for the former two files, eliminating the duplicated-shell drift class). Made the SubNav sticky (`self-start`) + fixed a design-system-wide letter-spacing token bug ([MATT-COURSE-POLISH]).

- [ ] **[MATT-EXEC-EXT]** Phase 6 — Extrapolation primitives (per matt-pre-plan.md §7): form-input variants (text/email/password/textarea/select), skeleton loader, modal frame, empty-state slot, status pill/toast for Alert/Success/Warning/Info states (Success/Warning/Info scaffolded — flag for Matt v2). Establishes coverage for the ~70 pages Matt didn't draw. **+ live-hero→MattIcon migration** (folded in from [MATT-ICON-SWAP] Conv 194): the live `CourseHero.tsx` still uses legacy `@components/ui/icons` React primitives, not MattIcon — migrate when the legacy course page graduates to Matt components. **+ deeper mobile breakpoint work** for the `/matt/` course per-tab bodies (folded in from [CRS-MOBILE] Conv 194 — literal SubNav scope verified fine, but Matt's frames have a fuller mobile breakpoint not yet built).

- [ ] **[MATT-EXEC-GRD]** Phase 7 — Doc graduation. Flip 🚧 banner off `matt-design-system.md`; archive `matt-pre-plan.md` to historical status. All 8 doc-graduation criteria green (matt-pre-plan.md §8). End of MATT-DESIGN-PUSH block; transition to flip planning (separate future block).

- [x] **[MATT-EXEC-FLAGS]** Conv 187 — **RESOLVED on the addressability axis.** User reframed the route-shape question away from single-vs-multi-page to: does each screen need a jump-to/deep-link/redirect URL (addressability is implementation-independent; file-count is a deferrable build detail). Resolution table (recorded in `.scratch/matt-frames-ready-for-dev.md` § Route Addressability; principle saved as `feedback_routing_addressability_first.md` + MEMORY.md): **Addressable** — Course tabs (`[...tab]`), Enroll Success (Stripe `success_url`, hard requirement), Choose Teacher, Session (`/session/[id]`, ONE state-driven route rendering Prepare/During/After from status), Home/Feed. **Non-addressable (overlays/states)** — Enroll pre-checkout, Session Scheduled, Home/Course Completed. Implementation mirrors legacy patterns. Unblocks MMP-PH5 / [MATT-SUBNAV-ROUTING] / [MATT-EXEC-PG2]. (Sub-assumption (e) was resolved Conv 186; remaining sub-assumptions a–d, f–h now subsumed under addressability decisions — file-count deferred to build.)

## Conv 157 Timecard Enhancement Items

- [x] **[TC-OPT-OBSIDIAN]** Obsidian vault integration for `/r-timecard-day` output (Conv 157 ✅). Moved vault-write from `.timecard.md` in repo to timed files in Obsidian vault. Config: `rTimecardDay.vaultPath = "~/Obsidian Vaults/main2025/_projects/Peerloop/timecards"` (tilde-portable for M4/M4Pro via `$HOME` runtime expansion). Filename format: `Peerloop Timecard • Coding • <H3-title> • <startTimeNoColon>.md` (e.g., `Peerloop Timecard • Coding • May 6, 2026 • 0910.md`). Vault file replaces `.timecard.md` write. Obsidian Sync auto-propagates to both machines. Script: `placeholderNames[]` field added to JSON output; SKILL.md Step 4 rewritten to drive from array via literal substitution (eliminates regex-scanning bug). Step 5 three-branch flow: dir-missing → STOP, file-exists → halt-and-ask, else → write+open. Verified cross-machine portability (M4Pro `$HOME=/Users/jamesfraser` → correct path derivation).

## BBB-RECORDING (Convs 159-161)

🔥 **ACTIVE** — Triggered by recording-gap in Conv 158 BBB testing. Conv 159: diagnosis confirmed `autoStartRecording` missing. Conv 161: **Blindside reply** — `getRecordings` requires `limit≤100` parameter (fixed both diagnostic surfaces); paginated `/admin/recordings` built with 2-call total derivation; all 7 user-facing recording-display surfaces verified on staging (1 of 8 orphaned recordings visible correctly). Conv 162: discovered 8th surface (TeacherTabContent My Sessions tab) and fixed it — verbatim mirror of student `SessionsTabContent` "Recording" affordance. Conv 163: [REC-LABEL] completed — shared `<RecordingLink>` component extracted, all 10 surfaces (8 + 2 admin added mid-conv) unified on Option B bordered-text "Recording" button; local dev seed now ships Sarah/Guy/Intro-to-n8n session with real Blindside `recording_url` (exact parity with staging); [DLE] investigation root-caused user-reported "loading errors" to existing [BR-NAVBAR-HYDRATE] (scope widened — not admin-only). Conv 164: [RV] 10-surface verification sweep confirmed all recording-button updates landed (Sarah/Guy/Brian role rotation, all 10 surfaces ✓). [BR-NAVBAR-HYDRATE] root-caused + fixed at AdminNavbar.tsx:90 via the established `isHydrated` flag pattern (single bug, single file — Conv 163 [DLE] "scope widened" was a misdiagnosis: the non-admin reproduction came from `data-astro-transition-persist` carrying the errored navbar across View Transitions, not a separate bug). [CRT] promoted to its own block. **Completed:** account-wide diagnostics, autoStartRecording fix deployed, paginated admin UI with 20-per-page paging, empirical UI verification on all surfaces, TeacherCourseView + TeacherTabContent recording-link bug fixes deployed to staging, 10-surface recording-link unification via `<RecordingLink>`, local dev seed parity with staging for recording flow, AdminNavbar hydration mismatch fixed.

**Subtasks:**

- [x] **[BR-DIAG]** Conv 159: Account-wide `getRecordings` check (finding: 0 recordings, eliminated webhook/config hypotheses).

- [x] **[BR-AUTO]** Conv 159: Added `autoStartRecording: true` to 3-layer fallback in types + `bbb.ts` + `join.ts`.

- [x] **[BR-ADMIN]** Conv 159: Built `/api/admin/bbb/recordings` endpoint + `/admin/recordings` page + RecordingsAdmin component + menu entry.

- [x] **[BR-ADMIN-SCRIPT]** Conv 159: Promoted diagnostic script to `Peerloop/scripts/bbb-list-recordings.mjs`.

- [x] **[BR-REPLY]** Conv 159: Drafted Blindside reply with diagnostic findings and questions.

- [x] **[BR-MENU]** Conv 161: Verified Recordings menu entry exists in AdminNavbar.

- [x] **[BR-OFFSET-PROBE]** Conv 161: Confirmed Blindside supports `offset` parameter (Blindside-specific, not standard BBB).

- [x] **[BR-PAGE]** Conv 161: Rewrote `/admin/recordings` with 20-per-page pagination (2-call total derivation for BBB), shared AdminPagination component, page/limit state management, prev/next navigation.

- [x] **[BR-TRACE]** Conv 161: Mapped all 7 user-facing recording-display surfaces; traced all 8 BBB recordings across staging/prod D1 (1 visible, 5 orphaned, 2 Greenlight-only). Cross-verified API returns correct `recording_url` on all surfaces.

- [x] **[TCV-REC]** Conv 161: Fixed TeacherCourseView SessionRow missing recording-link bug (JSX was reading type but not rendering field); added PlayCircleIcon conditional block; deployed to staging; verified live.

- [x] **[MST-REC]** Conv 162: Fixed TeacherTabContent My Sessions tab missing recording link — added `recording_url: string | null` to `SessionRow` interface and mirrored student `SessionsTabContent`'s bordered text "Recording" button verbatim in `SessionRowView`. API endpoint `/api/teaching/courses/[courseId].ts` already returned `recording_url` (client-side gap only — same root-cause shape as Conv 161 [TCV-REC]). Deployed to staging (Version `36c761e7-...`), verified live by user. Discovery: this is the 8th user-facing recording surface, not 7 as [BR-TRACE] mapped in Conv 161 — [REC-LABEL] inventory updated below.

- [x] **[BR-NAVBAR-HYDRATE]** Conv 161 → Conv 164 (Conv 163 [DLE] "scope widened to non-admin pages" was a misdiagnosis — one bug, one file). Root cause: `AdminNavbar.tsx:90` `useState<CurrentUser|null>(getCurrentUser())` read localStorage/window in the initializer, so SSR returned `null` while CSR returned a hydrated user — flipping the `{admin && (<div>...)}` block at lines 181-198. Fix: mirrored AppNavbar's established `isHydrated` flag pattern — `useState(null)` + `setIsHydrated(true)` in the existing useEffect + render guard `{isHydrated && admin && (...)}`. Repo-wide grep `useState[<(].*getCurrentUser\(\)` returned exactly one hit, confirming the bug was isolated. Conv 163 [DLE] reproduction on non-admin pages came from `data-astro-transition-persist="admin-navbar"` carrying the persisted (already-errored) AdminNavbar across View Transitions — not a separate bug surface. All 5 baseline gates green (tsc / astro 0/0/0 across 1211 files / lint 0 errors 4 pre-existing warnings / 6415 tests / build 6.43s). 2 edits to `src/components/layout/AdminNavbar.tsx` (8 lines net).

- [x] **[CRT]** Promoted to its own ACTIVE block (designed Conv 164); completed Conv 165-166. See COMPLETED_PLAN.md.

- [x] **[REC-LABEL]** Conv 161 (extended Conv 162, completed Conv 163). Created `<RecordingLink>` component (`src/components/ui/RecordingLink.tsx`): bordered text "Recording" button with dark-mode classes, `target="_blank" rel="noopener noreferrer"`, single variant. Applied to all 10 user-facing surfaces (the original 8 plus admin/recordings list and admin/sessions Recording column, added Conv 163 per user request). API endpoint `/api/admin/sessions/index.ts` now returns `recording_url` in list payload (was queried but dropped before). Detail panels (#1 SessionCompletedView, #7 admin SessionDetailContent) standardized on `bg-secondary-50` + "Session Recording" heading + `<RecordingLink>`. Old icon-only+tooltip and "Watch" affordances retired. `docs/reference/bigbluebutton.md` UI Surfaces table updated 8 → 10. All 5 baseline gates green (tsc / astro 0/0/0 / lint 4 pre-existing / 6415 tests / build).

- [ ] **[BR-STATUS]** Add `sessions.recording_status` column with enum `none | requested | capturing | processing | published | failed` for richer post-session UI. Defer pending Blindside follow-up on server-level recording configuration + outcome of orphaned-recording investigation.

- [ ] **[BR-ZERO-REPRO]** Reproduce the 0-min empty-but-published recording state — external-blocked (needs fresh BBB test session). Prereq for [BR-STATUS] enum design (we need to know which post-session states are reachable in practice before fixing the column shape).

- [ ] **[VITE-DEPS-WATCH]** Watch for recurring Vite missing-chunk warnings during `npm run dev` / `npm run dev:staging` — watch-only; act if the warning recurs (i.e., trips dev server hot-reload or build). Carried from Conv 168 RESUME-STATE.

## Conv 158 Timecard Model & Sub-Agent Testing — ABANDONED (Conv 160)

Multi-model exploration for `/r-timecard-day` dropped. Sub-agent dispatch was cost-prohibitive (Sonnet sub-agent 60-300s vs Opus baseline 15s) and Haiku exhibited hallucinated permission asks. Items [TC-SONNET-FG], [TC-HAIKU-FG], [TC-PARAM-OUTPATH], [TC-GLIDE-DOC] all retired. Skill runs on whatever model the caller invokes it under; no further investment planned.

---


## Follow-ups: COMMUNITY-RESOURCES (Conv 124, block closed)

COMMUNITY-RESOURCES block closed Conv 124 — Phase 8 PLATO step `upload-community-resources` added to flywheel scenario (JSON-link path, 2 resources via `repeat`, discovery GET on `/api/me/communities` for cross-step slug). All 9 phases complete. Remaining follow-ups:

- [x] **[MPT]** Conv 130 — Multipart file-upload happy-path tests for POST community resources: 11 tests (8 happy-path + 3 validation), manual Uint8Array multipart body construction to bypass jsdom FormData serialization bug; session-invite mock updated. 6404/6404 tests passing.
- [x] **[COURSE-RES-AUTH-EDGE]** Conv 129 — `download.ts` enrollment gate: added `AND deleted_at IS NULL`; disputed enrollments retain access (product decision). tsc clean.
- [x] **[BKC-NEXT]** Conv 129 — SessionBooking next-month nav capped at today+28 days (`maxBookingDate`/`isAtMaxMonth` computed values; next-month button disabled at horizon).
- [x] **[BKC-FETCH]** Conv 129 — `availability-summary.ts` default `availabilityWindowDays` corrected from `'30'` to `'28'`; both surfaces now aligned on 28 days.
- [x] **[CODECHECK-SQL]** Conv 129 — `/w-codecheck` Check #8 added: schema-aware SQL lint parses `deleted_at` table list dynamically, scans template-literal SQL blocks, flags co-occurrence with non-`deleted_at` tables.
- [x] **[CSS]** Conv 128 — `/discover/members` bottom-row clipping fixed. Removed `<div className="h-14 lg:hidden" />` spacer from AppNavbar; added `pt-14 lg:pt-6` to AppLayout content div. Verified in browser (desktop + mobile viewport).
- [x] **[DBAPI-SUBCOM-AUDIT]** Conv 131 — structural audit complete. §Authentication rewritten (6 fictional → 10 real endpoints with `peerloop_access`/`peerloop_refresh` cookies + `recordLogin()` side-effects + Stream.io/Google/GitHub OAuth externals). §Communities rewritten (7 → 18 endpoints: 15 active + 3 explicitly-proposed in a separated subsection; removed Conv 121 audit banner). DB-API.md +218 net lines (net-new documentation, not drift).

---

## Follow-ups: ROLE-AUDIT (Conv 123, block closed)

ROLE-AUDIT block closed Conv 123 — audit report produced (`docs/reference/role-audit-2026-04-15.md`), codebase materially cleaner than framing suggested (zero stale role constructs, zero SSR duplication bugs). Closed in-conv: [RA-RO] (`transformRole` extract + 6-file Astro narrowing + `CommunityTabs`/SSR loader types narrowed to `'creator' | 'member'` + `RoleBadge` collapse), [RA-ADM] (3 narrow helpers in `src/lib/auth/session.ts`: `isUserAdmin`, `getUserPermissionFlags`, `getAllAdminUserIds`; 9 sites migrated; 3 moderator sites intentionally inline by superset-query rule).

Remaining spawned follow-ups:

- [x] **[RA-CLI]** Conv 124 — `MyCourses.tsx` migrated to `useCurrentUser()` + `useAuthStatus()` (derived enrollments via `user.getEnrollments()`, heal path calls `refreshCurrentUser`). `UserProfile.tsx` discovered to be dead code (zero src/.astro callers) and deleted along with its 36-test file. Spawned + closed **[RA-API]** same conv.
- [x] **[RA-API]** Conv 124 — Deleted dead `/api/me/enrollments` endpoint + 18-test file + stale negative-assertion test in `StudentDashboard.test.tsx`; regenerated `tests/plato/route-map.generated.ts` + `docs/as-designed/route-api-map.md`. Discovered `/api/me/stats` endpoint never existed (phantom URL masked by `.catch(() => null)` in the now-deleted `UserProfile.tsx`).
- [x] **[RA-SSR]** Conv 130 — Collapsed all 6 `course/[slug]/*.astro` SSR frontmatter queries into `fetchCourseTabData` loader (11-query `Promise.all`, `CourseTabData` interface, enrollment check + `canPost` derivation). Each page reduced ~180 → ~85 lines. Named `fetchCourseTabData` (not `fetchCourseDetailData`) to avoid collision with existing function of different shape. **Tail Conv 131:** Deleted the now-orphaned legacy `fetchCourseDetailData` loader (200 lines) + `CourseDetailData` interface + 2 dead `mock-data` imports + `src/lib/ssr/index.ts` re-exports + 8-test CDET describe block in `tests/ssr/courses.test.ts`. Header docstring updated (CDET → CTAB). tsc clean; 21 → 13 tests passing.
- [x] **[RA-SSR-LOADER]** Conv 128 — `src/lib/ssr/loaders/communities.ts:471-476` raw `SELECT is_admin` replaced with `isUserAdmin(db, userId)` helper. tsc clean.
- [x] **[RA-JWT]** Conv 125 — Decision recorded in `docs/DECISIONS.md` §4: **keep status quo, do NOT embed `isAdmin` in JWT.** Load-bearing reason: refresh-token-as-auth fallback (`session.ts:88-94`) widens staleness to 7 days (not 15 min as the audit framed), which is incompatible with instant admin-revocation for security-sensitive gates. Revisit only if admin-gate P95 latency measurably regresses. Spawned `[RA-SSR-LOADER]` for missed site in `ssr/loaders/communities.ts:471-476`.
- [x] **[RA-RES-ROLE]** Conv 125 — Dropped unused `CommunityTabs.Resource.uploadedBy.role` field. Removed `role` from 8 files (6 Astro pages + CommunityTabs.tsx type + SSR loader type, ResourceRow interface, SQL SELECT, and `LEFT JOIN community_members` that existed *only* to supply this field). 13 lines deleted; query now 1 JOIN lighter.

### Conv 123 drain pass (infra)

- [x] **[SGA]** — `sync-gaps.sh` `find` excludes `.astro/` generated-content dirs in API + tests sections (fixes `src/pages/api/**/.astro/content.d.ts` false positives; 241 API routes documented clean).

---

## Deferred: TESTING

**Focus:** Multi-user testing — E2E Playwright flows, branching workflow integration tests, admin test gaps
**Status:** 📋 PENDING
**Merged Conv 095:** E2E-GAPS + E2E-LIFECYCLE + WORKFLOW-TESTS + ADMIN-REVIEW.TESTING

### TESTING.E2E — Playwright Multi-User Flows

*Two-browser Playwright tests for flows not coverable by integration tests*

- [ ] Session invite: Teacher sends → Student accepts → Session created → Both in room
- [ ] Session invite variants: reschedule, expired, decline
- [ ] Booking wizard: teacher select → date → time → confirm → session room
- [ ] Booking reschedule: cancel old → pick new time
- [ ] Session lifecycle: join → video room → completion → rating (two-browser)
- [ ] Notifications: User A action → User B notification badge + page update
- [ ] Messages: User A sends → User B conversation + badge update

### TESTING.WORKFLOW — Branching Integration Tests

*Multi-step flows with decision-point variants. Shared setup → branch at decision point → verify different downstream state.*

| Workflow | Branches | Value |
|----------|----------|-------|
| **Booking→Session→Completion** | book, join/no-show, complete (single/final), cancel (on-time/late), reschedule (under/at limit) | Highest — most user-facing |
| **Completion→Cert→Teacher** | rate/skip, recommend/decline, certify/reject, first booking as Teacher (full flywheel) | High — core product thesis |
| **Payment** | checkout success/abandon, refund, dispute open/close (won/lost), payout fail | Medium — webhook chains |
| **Messaging** | start convo (allowed/403), send after relationship ends, admin bypass | Low — relationship gates removed (Conv 110 open messaging); admin rules still testable |

Existing partial coverage: `tests/api/sessions/`, `tests/api/webhooks/stripe.ts`, `tests/lib/messaging.test.ts`, `tests/integration/message-lifecycle.test.ts`, `tests/integration/notification-lifecycle.test.ts`

### TESTING.ADMIN — Admin Test Gaps

*From Conv 080 audit. 81 of 96 admin components/APIs tested (~1900 tests).*

**Category 1 — Decision Data (12 untested GET `[id].ts` endpoints):**
admin/enrollments, teachers, certificates, courses, sessions, users, payouts, topics, moderation, intel/courses, intel/dashboard, intel/communities. Highly templatable — same auth→404→200+shape pattern.

**Category 2 — Action Execution (2 components):**
ModeratorsAdmin (invite/revoke/remove), TopicsAdmin (reorder/CRUD). API tests exist but component→API wiring untested.

**Category 3 — Shared Infrastructure (5 primitives):**
AdminDataTable, AdminDetailPanel, AdminFilterBar, AdminPagination, AdminActionMenu. Tested indirectly. Recommended: test DataTable + DetailPanel directly (highest cascade risk), skip others.

---

## Completed: CF-WORKERS (Conv 114)

**Focus:** Migrate Cloudflare Pages → Workers with Static Assets (Astro 6 + adapter 13 requires Workers)
**Status:** ✅ COMPLETE (Conv 114, branch `jfg-dev-12`)
**Tech Doc:** `docs/reference/cloudflare.md` (§Cloudflare Workers Deployment)

**Summary:** Staging deployed at `peerloop-staging.brian-1dc.workers.dev`. Smoke test green: SSR routes, D1/R2/KV/ASSETS bindings all working, `ENVIRONMENT` baked into bundle as `STG`. The Conv 113 postbuild patch was removed.

### CF-WORKERS.MIGRATE — Pages → Workers Migration

- [x] Create Workers project in Cloudflare Dashboard (`peerloop-staging` created by user)
- [x] Update `wrangler.toml` for Workers with Static Assets format
- [x] Migrate D1, R2, KV bindings to Workers config (same account-level IDs)
- [ ] Configure custom domain / DNS routing for Workers (**deferred** — using `.workers.dev` default for staging)
- [x] Verify `[env.staging]` bindings work (renamed from `[env.preview]`)
- [x] Test deployment end-to-end (build → deploy → verify all routes)
- [x] Remove temporary `scripts/fix-pages-wrangler.mjs` and `postbuild` npm script
- [x] Update `docs/reference/cloudflare.md` to reflect Workers setup
- [x] Update CI/CD if any Pages-specific configuration exists (removed `CF_PAGES` env var usage)

**Follow-ups tracked in DEPLOYMENT block below.**

---

## Active: DEPLOYMENT

**Focus:** Complete the CF Workers rollout — production cutover and automation.
**Status:** 📋 PENDING (spawned from CF-WORKERS Conv 114)
**Tech Doc:** `docs/reference/cloudflare.md` (§Cloudflare Workers Deployment)

### DEPLOYMENT.GHACTIONS — GitHub Actions auto-deploy workflow

- [ ] `.github/workflows/deploy.yml` — auto-deploy on push to staging/main
- [ ] Configure GitHub repo secrets: `CLOUDFLARE_API_TOKEN` (deploy), `DOCS_REPO_PAT` (doc-drift workflow cross-repo checkout of peerloop-docs — PAT needs `repo` read scope)
- [ ] Build + run tests + deploy (staging env)
- [ ] Main branch deploys to production (once prod cutover done)

### DEPLOYMENT.PAGES-DISCONNECT — Disable old Pages auto-deploy ✅ COMPLETE (Conv 116)

**Resolved:** Client uninstalled the Cloudflare Pages GitHub App from `PeerloopLLC`. Pushes to `staging`/`main` no longer trigger broken CF Pages builds.

- [x] **GitHub-side:** Cloudflare Pages GitHub App uninstalled from `PeerloopLLC` org.

**Do NOT delete the Pages project itself** — production still serves from it until DEPLOYMENT.PROD completes.

### DEPLOYMENT.DB-SYNC — Prod D1 schema/data convergence (Conv 169 discovery)

**Status:** 📋 PENDING — pre-cutover prerequisite. Discovered Conv 169 while preparing [PROD-PW-APPLY]: prod D1 has drifted vs local + staging. Bundling all prod D1 mutations (schema-sync + password rotation + tracker-cleanup) into one synchronous sweep.

**Drift state (live, captured Conv 169):**

| Migration | Local | Staging | Production |
|---|:---:|:---:|:---:|
| 0001_schema.sql | ✅ | ✅ | ✅ |
| 0002_seed_core.sql | ✅ | ✅ | ⚠️ recorded under old name `0002_seed.sql` |
| 0003_fix_session_times.sql | ✅ | ✅ | ❌ **NOT APPLIED** (would be no-op — `sessions_missing_z = 0`) |
| 0004_feed_activity_index.sql | ✅ | ✅ | ❌ **NOT APPLIED** — `feed_visits` / `feed_activities` tables missing on prod |

**Live prod row counts (Conv 169):** 9 users (including `usr-admin`), 6 sessions, 0 sessions missing `Z` suffix.

**Tasks (run as one bundle when ready to apply):**

- [ ] **[DB-SYNC-04]** Apply `migrations/0004_feed_activity_index.sql` to prod via `wrangler d1 execute peerloop-db --remote --file migrations/0004_feed_activity_index.sql`. Creates `feed_visits` + `feed_activities` tables + 2 indexes. Real schema gap — any feed-intel code path that reads/writes these tables will fail on prod until applied. Then insert tracker row: `wrangler d1 execute peerloop-db --remote --command="INSERT INTO d1_migrations (name, applied_at) VALUES ('0004_feed_activity_index.sql', strftime('%Y-%m-%dT%H:%M:%fZ', 'now'))"`.

- [ ] **[DB-SYNC-03]** Insert tracker row for `0003_fix_session_times.sql` without running the SQL (already-converged data — prod has zero bare-string sessions): `wrangler d1 execute peerloop-db --remote --command="INSERT INTO d1_migrations (name, applied_at) VALUES ('0003_fix_session_times.sql', strftime('%Y-%m-%dT%H:%M:%fZ', 'now'))"`. Tracker-only — keeps `wrangler d1 migrations list` clean.

- [ ] **[DB-SYNC-02-RENAME]** Rename the stale tracker entry `0002_seed.sql` → `0002_seed_core.sql` to match the current filename: `wrangler d1 execute peerloop-db --remote --command="UPDATE d1_migrations SET name = '0002_seed_core.sql' WHERE name = '0002_seed.sql'"`. Cosmetic — but `wrangler d1 migrations list` will then return clean "No migrations to apply" instead of falsely listing 0002_seed_core.sql as pending.

- [ ] **[PROD-PW-APPLY]** Execute the deferred `Peerloop2` rotation against prod admin (was Conv 168 deferred, redirected here Conv 169). **Three sub-steps, all in this same DB-SYNC bundle:**
  1. Edit `migrations/0002_seed_core.sql:172` — replace the `Password1` hash (`$2b$10$Mc4KOG9BDrsrhzJZznRipeGBmQbYHxxxa..IIemgOSUIpMq0wxJk6`) with the `Peerloop2` hash (`$2b$10$tQMUTTuSbJiuqpITHrCN7.PMrqqkJTZROlbhZkPfvLKYEtcAsflXi`) — same hash used in `migrations-dev/0001_seed_dev.sql` and `src/lib/mock-data.ts:1485`. Update the file comment at line 168 too.
  2. `wrangler d1 execute peerloop-db --remote --command="UPDATE users SET password_hash = '<hash>' WHERE id = 'usr-admin'"` against prod.
  3. Verify by logging into prod as `admin@peerloop.com` / `Peerloop2`.

- [ ] **[DB-SYNC-VERIFY]** Final convergence check — `wrangler d1 migrations list peerloop-db --remote` should report "No migrations to apply"; spot-check `SELECT name FROM sqlite_master WHERE name IN ('feed_visits','feed_activities')` returns both; spot-check `SELECT substr(password_hash,1,12) FROM users WHERE id='usr-admin'` returns `$2b$10$tQMU...` (Peerloop2) not `$2b$10$Mc4K...` (Password1).

**Rationale for bundling:** Each individual task is small and could be done separately, but the DECISIONS.md §4 principle ("bundle so live prod and seed never disagree") generalizes — applying these one-by-one over multiple convs leaves prod in successively-different intermediate states, none of which match any reference (local/staging/seed-file). Batching makes the diff a single atomic step.

**Why not run now (Conv 169):** User direction — route into the existing pre-production block rather than mutate prod mid-conv. Apply when the DEPLOYMENT block is actively being worked.

### DEPLOYMENT.PROD — Production cutover

**Prerequisites (before first prod deploy):**
- [ ] Create the `peerloop` Worker in the Cloudflare Dashboard (Workers & Pages → Create → Worker → "Hello World" template → rename to `peerloop`). First `wrangler deploy` will overwrite the stub. *Note: the accidental `peerloop` Worker from Conv 114 was deleted; it no longer exists.*
- [ ] Confirm the prod KV `SESSION` namespace ID in `wrangler.toml` (`7605e3a3...`) is correct for the production account — verify in CF Dashboard that this namespace exists and is not a staging leftover. If wrong, create a new prod KV namespace and update the top-level `[[kv_namespaces]]` in `wrangler.toml`.
- [ ] Confirm prod D1 `peerloop-db` and R2 `peerloop-storage` resources exist and contain the intended production data (not test seed). **Tracked separately: DEPLOYMENT.DB-SYNC above covers prod D1 migration convergence.**
- [ ] Upload production secrets to the `peerloop` Worker via `wrangler secret bulk` — JWT_SECRET, BBB_SECRET, RESEND_API_KEY, STRIPE_SECRET_KEY (live `sk_live_...`, not test), STRIPE_WEBHOOK_SECRET (separate prod webhook in Stripe Dashboard), STREAM_API_SECRET (prod Stream.io key). See `docs/reference/cloudflare.md` §Secrets for the bulk-upload recipe. **Do NOT reuse staging secrets for production.**

**Cutover:**
- [ ] Deploy `peerloop` Worker via `npm run deploy:prod` (tests `confirm-prod.js`)
- [ ] Smoke test the `.workers.dev` URL before any DNS change
- [ ] Configure custom domain routing in CF dashboard (`peerloop.com` → Worker)
- [ ] Verify production DNS resolves to Worker, not old Pages project
- [ ] Delete the old CF Pages project (after prod cutover verified stable)

### DEPLOYMENT.STAGING-DOMAIN — Staging custom domain (optional)

- [ ] If desired: `staging.peerloop.com` → Worker Routes (replaces `.workers.dev`)

### DEPLOYMENT.STAGING-FOLLOWUPS — Discovered during Conv 116 staging verification

- [x] **[VS]** Staging seed scripts unblocked — fixed 3 stale `--env preview` references in `scripts/reset-d1.js` (2) + `scripts/plato-seed-staging.js` (1); live reset → migrate → seed:staging → seed:booking:staging → seed-feeds.mjs all green (Conv 116)
- [x] **[SF]** SSR self-fetch 404 regression on Workers — refactored 8 community/discover `.astro` pages + 3 `/api/communities/*` handlers to use new `src/lib/ssr/loaders/communities.ts`; extended `SSRDataError` with UNAUTHORIZED/FORBIDDEN; ~750 LOC net deletion; all 4 community slugs + 3 API endpoints return 200 on staging; 6392/6392 tests pass (Conv 116)
- [x] **[CF-TOKEN]** Rotated `CLOUDFLARE_API_TOKEN` to User API Token `peerloop-wrangler-full` with D1/Workers/KV/R2/Observability/Routes + User:Memberships:Read + User:User Details:Read; set `CLOUDFLARE_ACCOUNT_ID` in `.dev.vars` to disambiguate multi-account token (Conv 116)
- [ ] **[RS]** `scripts/reset-d1.js` doesn't drop orphan tables outside current schema — Conv 116 staging reset left legacy `users`, `user_interests`, `user_topic_interests`, `categories` tables (not in `0001_schema.sql`) that FK-blocked the drop-in-dependency-order pass. Required manual DROP. Fix: query `sqlite_master` for ALL non-system tables, not just ones in current schema.
- [ ] **[DS]** `npm run dev:staging` doesn't actually use remote bindings — `remoteBindings: true` in adapter 13 config appears to be a no-op. Dev server reads empty local miniflare D1 sandbox instead of remote staging D1. Suspect adapter 13 / vite-plugin 1.31.2 regression. Blocks the "post-adapter-migration smoke test" workflow that would have caught [SF] earlier.
- [ ] **[PE]** `platform_stats.environment` marker row not seeded by `migrations/0002_seed_core.sql` — `/api/debug/db-env` returns 'unknown' for remote D1s even when data is correctly populated.

**Learning (folded into tech docs by r-end):** CF Workers + Static Assets route SSR self-fetches to the Assets layer which 404s plain-text; `[assets].run_worker_first` has ZERO effect on Worker-internal subrequests (only external-edge routing). Fix was Path B — refactor to direct loader imports — per CLAUDE.md §Solution Quality.

---

## Active: CALENDAR

**Focus:** Custom multi-view calendar component system serving all platform roles
**Status:** 📋 PENDING
**Session:** 342

**Vision:** A single, versatile custom calendar component that powers every time-based view on the platform — student schedules, S-T availability and sessions, admin oversight, and activity history. Supports year, month, week, and day views with role-specific data layers, filtering, and clickable items. Built custom (not wrapping a library) to fully control rendering, interaction, and data integration.

### Current State

The platform has three separate calendar-like UIs, each built independently:

| Component | Views | Limitation |
|---|---|---|
| `AvailabilityCalendar` | Month only | No week/day; cell interaction is availability-specific |
| `SessionBooking` (step 2) | Month only | Date picker only; no time-axis view |
| `AvailabilityQuickView` | Static week dots | Not interactive; summary only |

All other schedule UIs (TeacherUpcomingSessions, SessionHistory, StudentDashboard) are lists or tables with no calendar visualization. `react-big-calendar` is installed but unused.

### CALENDAR.CORE — Base Component Architecture

*The shared calendar engine that all role-specific views build on*

- [ ] `PeerloopCalendar` base component with view modes: Year, Month, Week, Day
- [ ] View switcher UI (toolbar with Year | Month | Week | Day toggle)
- [ ] Navigation controls (prev/next, today button, date range display)
- [ ] Timezone-aware date handling (all views respect user timezone)
- [ ] Slot rendering system — calendar "items" rendered as colored blocks/badges:
  - Items have: title, time range, color/category, click handler, optional icon
  - Week/Day views: time-axis layout (vertical hours, items as positioned blocks)
  - Month view: items as compact badges within day cells
  - Year view: heat-map style (activity density per day)
- [ ] Filter bar — toggle data layers on/off (checkboxes or pills)
- [ ] Click-through — items are clickable, navigate to detail page or open detail modal
- [ ] Responsive: week/day views scroll horizontally on mobile; month/year stack vertically
- [ ] Empty state handling per view mode

**Design principle:** The calendar component knows how to render items in time. It does NOT know what the items are. Each integration passes typed item arrays with colors, labels, and click targets.

### CALENDAR.STUDENT — Student Schedule View

*Replace the flat list on StudentDashboard with a real calendar*

- [ ] Week view (default) showing upcoming sessions across all enrolled courses
- [ ] Day view for detailed single-day schedule
- [ ] Month view for planning ahead
- [ ] Data layers:
  - Booked sessions (color-coded by course)
  - Available booking slots (if enrollment has remaining sessions)
- [ ] Click session → navigate to `/session/:id`
- [ ] Click available slot → navigate to booking flow
- [ ] Integration point: StudentDashboard and/or dedicated `/schedule` page

### CALENDAR.TEACHER — Teacher Schedule View

*Unified Teacher calendar replacing AvailabilityQuickView + TeacherUpcomingSessions*

- [ ] Week view (default) showing sessions + availability on the same time axis
- [ ] Day view for detailed daily schedule
- [ ] Month view (replaces or augments existing AvailabilityCalendar)
- [ ] Data layers (toggleable):
  - Booked sessions (color-coded by course or student)
  - Availability windows (recurring slots as background shading)
  - Availability overrides (blocked time, adjusted hours)
  - Buffer time between sessions (visual gap)
- [ ] Click session → navigate to `/session/:id`
- [ ] Click availability block → edit availability
- [ ] Integration point: TeacherDashboard and/or `/teaching/schedule`

**Note:** The existing AvailabilityCalendar with its multi-select-days-and-set-times interaction may remain as a separate editing UI. The CALENDAR.TEACHER view is for *viewing* the schedule, not editing availability.

### CALENDAR.ADMIN — Admin Oversight Calendar

*Platform-wide activity calendar with extensive filtering*

- [ ] All four views: Year, Month, Week, Day
- [ ] Data layers (toggleable, expect this list to grow):
  - **Sessions:** All platform sessions (booked, completed, cancelled, no-show)
  - **Enrollments:** Enrollment events (new, completed, dropped, refunded)
  - **Community activity:** Townhall feed posts, community feed posts
  - **Course activity:** New courses published, materials updated
  - **User events:** Signups, S-T certifications, creator applications
  - **Payments:** Checkout completions, refunds, disputes, payouts
  - **Notifications:** System notifications sent
- [ ] Filters:
  - By role: Student, S-T, Creator, Admin
  - By course: specific course or all
  - By user: specific user or all
  - By event type: sessions, enrollments, community, payments, etc.
  - By status: active, completed, cancelled, etc.
  - Date range quick-picks: Today, This Week, This Month, This Quarter
- [ ] Click any item → navigate to its detail page (session detail, enrollment detail, user profile, etc.)
- [ ] Year view as activity heat map (GitHub-contribution-style) for spotting trends
- [ ] Export/print view (stretch goal)
- [ ] Integration point: Admin dashboard, possibly `/admin/calendar`

### CALENDAR.MIGRATE — Migrate Existing Calendar UIs

*After core is built, migrate existing custom grids to the new system*

- [ ] Evaluate whether `AvailabilityCalendar` editing interaction can use the new month grid or needs to stay separate
- [ ] Migrate `SessionBooking` date picker step to use new month view
- [ ] Replace `AvailabilityQuickView` with a compact week view from the new system
- [ ] Remove `react-big-calendar` from `package.json` (never used, dead dependency)

### CALENDAR.ICS
*.ics calendar file attachments for session booking emails*

**Current state:** `SessionBookingEmail.tsx` sends booking confirmation with BBB link. No `.ics` (iCalendar) file attached. (Capabilities review Session 359)

- [ ] Generate `.ics` file content for booked sessions (VEVENT with start/end, BBB join URL, attendees)
- [ ] Attach `.ics` to `SessionBookingEmail` and `SessionRescheduledEmail`

### Design Notes

**Data fetching pattern:** Each data layer is an independent API call. The calendar component accepts `items: CalendarItem[]` and the parent page fetches and combines layers based on active filters. This keeps the calendar component pure and testable.

```typescript
// Shared item type all data layers produce
interface CalendarItem {
  id: string;
  title: string;
  start: Date;
  end: Date;
  category: string;       // 'session' | 'enrollment' | 'availability' | 'feed' | ...
  color: string;           // Tailwind color class or hex
  icon?: string;           // Optional icon identifier
  href?: string;           // Click-through URL
  onClick?: () => void;    // Or custom click handler
  metadata?: Record<string, unknown>; // Role-specific extra data
}
```

**Phased delivery:** CORE → STUDENT → TEACHER → ADMIN → MIGRATE. Each phase delivers value independently. The admin calendar (most complex) comes last because it has the most data layers and benefits from patterns established in the simpler views.

**Why custom, not react-big-calendar:** The platform needs cell-level control that libraries don't provide — availability multi-select, heat-map year views, togglable data layers with role-specific filtering, and consistent styling with the existing Tailwind design system. A library would fight us on every customization. Building custom means the calendar grows with the platform.

**Week/Day vs Month are architecturally different:** Month view is a grid of day cells with badges. Week/Day views have a vertical time axis (e.g., 6am-10pm) where items are absolutely positioned blocks based on start/end time. The core component must handle both layout modes.

---


## Planned: PACKAGE-UPDATES

**Focus:** Upgrade all npm dependencies to latest versions, on a dedicated branch
**Status:** 🔥 IN PROGRESS (Convs 104-113) — Phases 1-6 complete; PR #26 created (jfg-dev-11 → staging) for client review (Conv 113); CF Pages build failure discovered + temp postbuild patch deployed to staging; Phase 2b deferred (ecosystem gap). **Branch:** `jfg-dev-11` (promoted from `jfg-dev-10up`). Merge target: staging (PR #26). **Five-gate baseline** clean (tsc 0, astro 0, lint 4 pre-existing, tests 6391/6391, build; Conv 111).

**Completed:**
- Phase 1 minor/patch bumps; Stripe apiVersion → `2026-02-25.clover`; `getStripe()` helper — Conv 100
- Phase 2-prep: Centralized Cloudflare env access (`getEnv`/`requireEnv`/`getR2`), ~95 files migrated — Conv 100
- Phase 2a: Astro 5.18 → 6.1.5, `@astrojs/cloudflare` 12.6 → 13.1.8, `@astrojs/react` 4.4 → 5.0.3, Vite 6 → 7, `cloudflare:workers` env import + vitest alias, `src/env.d.ts` rewrite — Conv 101
- Phase 3 baseline-clearing: 18 pre-existing tsc errors eliminated via `json<T>` codemod (1,587 sites / 198 files, ts-morph), 5 time-fragile session test failures fixed with `futureAt(daysFromNow, utcHour)` helper — Conv 102
- Phase 3 proper: `zod ^3.25.76 → ^4.3.6` (dedupes with Astro's vendored copy; ZERO first-party imports — investigated in [ZU]: added 2026-01-08 for PageSpec, orphaned by Session 307's 40k-line delete) — Conv 104
- Phase 4: `stripe ^20.1.0 → ^22.0.1`; `apiVersion '2026-02-25.clover' → '2026-03-25.dahlia'` (single tsc error, one-line fix); [SD] changelog audit completed same-conv (checkout UI mode + Capabilities risk requirements both unaffected; documented in `docs/reference/stripe.md` as template for future bumps) — Conv 104
- Phase 5: `better-sqlite3 ^11.10.0 → ^12.8.0`, `eslint ^9.39.4 → ^10.2.0`, `jsdom ^27.4.0 → ^29.0.2`, `@cloudflare/workers-types` nightly — Conv 104
- [LD] ESLint drift cleanup: 45 → 0 problems (13 unused imports, 17 unused args, 1 stale `eslint-disable`, 5 redundant-any casts fixed; 2 half-wired `setActionLoading` + 7 `CourseEditor` state vars prefixed `_` and flagged as [HW]); `eslint.config.js` extended with `varsIgnorePattern`/`destructuredArrayIgnorePattern` on `^_` — Conv 104
- **Astro check gap closed** — `npm run check` added to CI (`lint-and-typecheck` job), `CLAUDE.md` Development Commands, `/w-codecheck` SKILL.md, `docs/reference/BEST-PRACTICES.md` (3 baseline blocks), and memory (`feedback_baseline_includes_astro_check.md`). New baseline = five gates. Conv 102's "clean baselines" claim retroactively incomplete — Conv 104
- [AC] 10 astro check errors fixed: `CourseTag` consolidation (renamed junction → `CourseTagRow`, canonicalized display shape in `lib/db/types.ts`, deleted duplicates in `mock-data.ts` + `course-tabs/types.ts`; zero `.astro` edits needed); `creator/[handle]/index.astro` `primary_topic_id` added; `discover/course/[slug]/[...tab].astro` TabId narrowing; `CourseTabs.initialTab` widened to `TabId | (string & {})` to match runtime — Conv 104
- [AH] 27 astro check hints cleaned: 14 test files (unused imports/vars), `booking.ts` dead `enrollmentId` param, 2 unused `via` params in `.astro`, `FormModal` `FormEvent → SyntheticEvent` (React 19), deleted orphaned `tests/plato/steps/_chain.ts`, `feed-activity.test.ts` half-wired upsert test completed with missing assertion — Conv 104
- [HW] Half-wired features cleanup: discovered both features were superseded legacy state (not missing UI). Deleted 3 unused `_error`/`_successMessage` state pairs + `actionLoading` dead state in ModerationAdmin/ModeratorQueue/CourseEditor (3 files, 11+/46-); FormModal + backdrop already provides action lockout; showToast already provides feedback. 4 pre-existing silent-failure `setError(err...)` sites in TeachersTab + PeerLoopFeaturesTab replaced with `showToast(..., 'error', 5000)` (net UX improvement). Five-gate baseline still green — Conv 105
- [P6] Five-gate baseline re-verified on `jfg-dev-10up` HEAD (3e15f8a): tsc 0 / astro 0 / eslint 0/0 / tests 6399/6399 / build 6.03s — Conv 106
- [P6] Broader docs sweep for stale version mentions: 3 live "Astro 5.x" references refreshed to "Astro 6.x" with current Node ranges (`docs/DECISIONS.md` Stay-on-Node-22 decision — preserved 2026-02-16 date, added 2026-04-11 update note; `docs/as-designed/devcomputers.md`; `docs/reference/cloudflare.md`). Sessions archive confirmed frozen — Conv 106
- TodoWrite backlog clearance (33/34 items): doc fixes ([DR] DOC-DECISIONS, [RT] DB-GUIDE, [FL] BEST-PRACTICES, [CK] cloudflare-kv, [AS] auth docs), bug fixes ([AM] midnight-spanning availability, [CC] Astro content config, [DH] dead test helpers, [DL] locals param verified active), skill fixes ([RS] /r-end timing note, [RD] /r-start dedup guard, [CP] /r-timecard-day paths, [SG] sync-gaps.sh, [TD] tech-doc-sweep.sh, [PM] extract-manifest path), codecheck ([SF]+[LE] 2 new rules), sweeps ([VS] `npm run verify`, [TT] futureUTC test helper, [HD] helpers.md inventory). 5 items assessed and closed as low-value ([HD2], [OD], [SD2], [SV], [PG]) — Conv 107
- [S1] Schema: `primary_topic_id` restored to `courses` table + seed data + types — Conv 108
- [S2] Schema: `homework_submissions.student_user_id` → `student_id` renamed across schema, seed, types, tests — Conv 108
- [S3] Code: `teacher-dashboard.ts` `assigned_teacher_id` → `teacher_id` fix — Conv 108
- E2E suite: all 6 pre-existing failures fixed (login race, browse-enroll redirect, admin-overview selectors, session-completion-flow rewrite, smart-feed simplification, session-booking fallback) — 137/137 passing Conv 108
- PLATO flywheel snapshot pipeline: `snapshot: true` at file level + `metadata.sqlite` filter in restore script — Conv 108
- PLATO flywheel browser walkthrough: all 14 intents verified (Mara Chen creator side + Alex Rivera student→teacher side) — Conv 108
- [FE] LoginForm inner try-catch for non-JSON error responses — Conv 108
- [LS] `login.astro` + `signup.astro` server-side `getSession()` redirect for authenticated users — Conv 108
- [CM] `member_count` fixed in seed SQL: `UPDATE communities SET member_count=N` after `community_members` inserts (core: 1, dev: 11) — Conv 108
- Late cancellation test timing fix: `futureUTC(0, 14)` → `Date.now() + 4h` — Conv 108
- `/w-codecheck` `error-captured-never-rendered` grep: added `error ||` variant — Conv 108
- `jfg-dev-11` branch created from `jfg-dev-10up` — Conv 108
- Session invite fire-and-forget bug fix: `await` added to `notifySessionInvite()` and `notifySessionInviteAccepted()` in both endpoints (Workers can kill unawaited promises) — Conv 109
- Session invite two-user integration tests: 9 tests covering notification isolation, badge counts, acceptance flow — Conv 109
- PLATO session-invite: steps (send + accept), scenario (12-step chain), instance (6 browser intents), browser walkthrough verified — Conv 109
- Session expiry UX: expired identity localStorage, "Welcome back [Name]" with email pre-fill, "Not [Name]?" escape hatch — Conv 109
- Dev-mode login endpoint (`/api/auth/dev-login`): passwordless login gated on `import.meta.env.DEV` for PLATO testing — Conv 109
- 26 tests for session expiry UX (current-user-cache 10, auth-modal 6, dev-login 10) — Conv 109
- Removed 3× `setTimeout` hacks from existing `session-invite-notifications.test.ts` — Conv 109
- Five-gate baseline: tsc 0 / lint 0 / tests 6410/6410 / build — Conv 109
- Dev environment fix: npm install (Cloudflare adapter 12→13) + vite cache clear — Conv 110
- AppNavbar simplification: commented out 5 menu items (feeds, courses, communities, teaching, creating) — client-approved — Conv 110
- index.astro: My Courses card commented out, Messages card auth-only (hidden for visitors) — Conv 110
- Open messaging: `getMessageableFlags()` simplified (3 relationship queries → 1 existence check), `messageableContactsSQL()` simplified (6 EXISTS → `u.deleted_at IS NULL`), 125 lines removed — Conv 110
- Updated messaging tests (5 expectations in messaging.test.ts, 1 in can-message API test) — Conv 110
- Updated POLICIES.md section 4 + messaging.md for open messaging model — Conv 110
- Five-gate baseline: tsc 0 / lint 0 / tests 6435/6435 / build — Conv 110
- Unified member directory: consolidated /discover/teachers, /discover/creators, /discover/students into single /discover/members page with server-side search, multi-role OR filter, 5 sort options, Load More UX — Conv 111
- GET /api/members endpoint with optional auth (admin extras inline), expertise batch-fetch — Conv 111
- MemberRole types, MEMBER_ROLE_COLORS, MemberRoleBadge/MemberRoleBadgeRow components with dimmed variant — Conv 111
- MemberCard + MemberDirectory React components — Conv 111
- /discover/members opened to all users (admin gate removed); DiscoverSlidePanel consolidated (3 links → 1); discover hub updated — Conv 111
- 301 redirects: /discover/teachers → /discover/members?roles=teacher, /discover/creators → ?roles=creator, /discover/students → ?roles=student — Conv 111
- Deleted 4 old components (TeacherDirectory, CreatorBrowse, StudentDirectory, DiscoverMembers) + 2 old test files (~2350 lines removed) — Conv 111
- 24 API tests for /api/members (role derivation, filtering, search, sorting, pagination, admin privileges) — Conv 111
- Five-gate baseline: tsc 0 / astro 0 / lint 4 pre-existing / tests 6391/6391 / build — Conv 111
- PLATO browse-members step (read-only, 4 query variations) + member-directory scenario + instance (8 BrowserIntents); SQL top-up for privacy_public. 10/10 PLATO tests — Conv 112
- Browser smoke test of /discover/members: initial load, All Members, Creator filter, multi-role, search — all verified — Conv 112
- Fixed MemberDirectory.tsx hydration race: AbortController + rolesKey serialization (Creator filter empty on initial load) — Conv 112
- Fixed `users.last_login` never written: `recordLogin()` helper added to `session.ts`, called from all 4 auth endpoints — Conv 112
- Fixed stale `DISCOVER_LINKS` in `route-api-map.mjs` for Conv 111 consolidation — Conv 112
- Documented Chrome MCP image dimension limits + PLATO snapshot strategy in BROWSER-TESTING.md — Conv 112
- Created PR #26 (jfg-dev-11 → staging) for client review — Conv 113
- Installed `gh` CLI on MacMiniM4 (v2.89.0) — Conv 113
- Diagnosed CF Pages build failure: Astro 6 + `@astrojs/cloudflare@13` targets Workers, not Pages — Conv 113
- Deployed temporary `postbuild` script (`scripts/fix-pages-wrangler.mjs`) to staging — patches adapter-generated wrangler.json to pass Pages validation — Conv 113
- Documented Astro 6 + Pages incompatibility in `docs/reference/cloudflare.md` — Conv 113

### Phase 2a Follow-ups

- [ ] Drop `_locals` parameter from `getEnv`/`getDB`/`getR2` helpers in a dedicated sweep commit (Fork 2 = X deferral from Conv 101; ~130 call sites) — task [DL] *(Conv 107: investigated, `locals` param is actively used for `__testEnv` injection — not dead code. The `_locals` unused-parameter version does not exist. Task reframed: the sweep would remove the parameter from production call sites where `__testEnv` is never passed, but this is low-value.)*
- [ ] End-to-end validate `npm run dev:staging` with `CLOUDFLARE_ENV=preview` against remote staging D1/R2 — task [DV] *(folded into PLATO testing phase)*

### Phase 2b — TypeScript 5→6 (deferred, ecosystem gap) — task [T6]

*Blocked by peer deps — Astro 6 vendors `tsconfck` pinned to TS ^5.0.0; `@astrojs/check` and `@typescript-eslint/*` not yet TS 6 compatible. TS 6.0.2 is a "bridge release" toward the TS 7 native rewrite.*

- [ ] Criteria to revisit: `npm ls typescript` shows no "invalid peer" markers for `@astrojs/check`, `@typescript-eslint/*`, and Astro-vendored `tsconfck`
- [ ] typescript 5.9.3 → 6.x
- [ ] Fix type errors surfaced by TS 6
- [ ] Run full five-gate baseline

### Phase 6 — Cleanup + PR merge — task [P6]

- [x] Verify five-gate baseline on final commit (tsc / astro check / lint / test / build) — Conv 106
- [x] Update any remaining docs referencing old versions — Conv 106 (3 "Astro 5.x" → "Astro 6.x" refreshes)
- [x] ~~Add ESLint rule or `/w-codecheck` grep check enforcing: no direct `locals.runtime?.env?.*` access outside helper files~~ — implemented as `/w-codecheck` grep rule (Conv 107), not ESLint
- [x] ~~`gh pr create jfg-dev-10up → jfg-dev-9`~~ — **Superseded (Conv 108):** `jfg-dev-10up` promoted to latest working branch; no merge back to `jfg-dev-9`
- [x] Fix all remaining E2E failures (4 pre-existing: login race, browse-enroll redirect, admin-overview, session-completion-flow rewrite) — Conv 108 (137/137 passing)
- [x] PLATO manual testing — flywheel all 14 intents verified (Conv 108); Stripe checkout required manual user intervention (known limitation — Chrome MCP can't interact with external Stripe pages)
- [x] Post-PLATO: five-gate baseline + E2E full pass — Conv 108 (tsc 0 / lint 0 / tests 6399/6399 / build / E2E 18 passed)
- [x] Browser smoke test of /discover/members — Creator filter, multi-role, search, All Members all verified — Conv 112
- [x] Staging smoke test: `npm run dev:staging` end-to-end validate against remote staging D1/R2 — before final staging merge — ✅ verified Conv 146 (seed-feeds are always fresh on each invocation; Smart feeds consistent with decay parameters)

### Codecheck Rule Follow-ups (discovered Conv 105 during [HW])

- [x] **[SF]** /w-codecheck rule: detect "error-captured-never-rendered" — grep-based check for `setError` without render. Implemented Conv 107. ([HD2] AST detector assessed as disproportionate — grep sufficient.)

### Test Hardening Follow-ups (discovered Conv 102)

*Surfaced during the `json<T>` sweep and pre-existing failure root-cause. Picked up opportunistically.*

- [x] **[AM]** Fixed `isSlotWithinAvailability` midnight-spanning bug — added `windowToUtc()` helper that advances end date by 1 day when `endTime <= startTime`. All 85 availability + 606 session tests pass — Conv 107
- [x] **[TT]** Swept `Date.now()+Nh` fragility in 5 high-risk test files — migrated to shared `futureUTC(days, utcHour)` helper in `tests/helpers/dates.ts`. 606/606 session tests pass — Conv 107
- [x] **[DH]** Dead helper audit — deleted 5 unused functions (`getResponseJSON`, `expectSuccess`, `expectError`, `expectJSONResponse`, `expectRedirect`) + `APIErrorResponse` interface from `api-test-helper.ts`, updated re-export index — Conv 107
- [x] **[VS]** Created `npm run verify` composite script chaining all five gates (`typecheck && check && lint && test && build`) — Conv 107

### ESLint v10 Post-Upgrade Gotcha (surfaced Conv 143)

**Breaking change:** ESLint v10 treats unknown rules in `// eslint-disable[-next-line]` directives as **hard errors** (in v9 they were silently ignored). This means any disable comment referencing a rule whose plugin isn't registered in `eslint.config.js` will fail the lint gate with `"Definition for rule 'X/Y' was not found"`.

**How it surfaced:** Phase 5 (Conv 104) bumped `eslint ^9.39.4 → ^10.2.0`; the same conv's `[LD]` drift cleanup removed 1 stale `eslint-disable` directive as part of the transition. Conv 143 later registered `eslint-plugin-react-hooks@^7.1.1` as part of `[LE]` and discovered pre-existing `react-hooks/exhaustive-deps` disable comments that v10 had been failing hard on (`"Definition for rule 'react-hooks/exhaustive-deps' was not found"`). Registering the plugin made Conv 143 dual-purpose: it activated the intended `rules-of-hooks: error` / `exhaustive-deps: warn` *and* cleared the lint errors v10 had been rejecting.

**Pattern for the next ESLint major-version bump:**
1. List disable directives referencing non-core rules:
   ```bash
   cd ../Peerloop && grep -rn "eslint-disable" src/ | grep -v "no-unused\|@typescript"
   ```
2. Cross-check each referenced rule/plugin against the registered plugins in `eslint.config.js`.
3. For each mismatch, either register the missing plugin or delete the now-dead disable comment.
4. Run `npm run lint` — clean exit is the only acceptable post-bump state; unknown-rule errors are hard gates, not warnings.

**Cross-reference:** `docs/reference/DEVELOPMENT-GUIDE.md §"ESLint Configuration (Conv 143)"` — plugin registry + effective-config check (`npm run lint -- --print-config <file>`).

---

## Nearly Complete: SEEDDATA

Database seeding strategy and empty state handling.
**Status:** 🟡 NEARLY COMPLETE (only EMPTY_STATE remaining, deferred to POLISH)

**Completed:** Full seed data overhaul (Session 285). All 59 tables seeded. Conv 083 password standardization (all `Password1`). PLATO seed path activated. Two parallel seed paths: SQL (`db:setup:*`) and PLATO (`plato:seed*`).

### SEEDDATA.EMPTY_STATE (Deferred → POLISH)
- [ ] Test each page with zero records
- [ ] Verify empty state messages display correctly
- [ ] Test first-user / first-course / first-enrollment flows

---

## Deferred: POLISH

Production readiness items.

### POLISH.VALIDATION
- [ ] API request body validation (Zod)
- [ ] Webhook payload validation (Stripe, BBB)
- [ ] Form validation schemas
- [ ] Environment variable validation

### POLISH.ROLES
- [ ] Course-scoped vs global role semantics
- [ ] Multi-role user navigation
- [ ] Admin impersonation model
- [ ] Admin user creation UI (from ROLES.CREATE_UI)

### POLISH.TECHNICAL_DEBT
- [ ] Status field inconsistency (boolean vs enum) + type-safe helpers
- [x] Full getNow() sweep (Conv 090)
- [ ] MergedPeople.tsx broken `/@[uuid]` URLs (Conv 047)
- [x] Replace all `prompt()` calls with FormModal (Conv 080)
- [x] `users.last_login` column is dead — never written to by any code, always NULL; admin analytics `/api/admin/analytics` queries it for "active in last 30/60 days" returning 0 for all users (Conv 111) — **Fixed Conv 112:** `recordLogin()` helper added to `session.ts`, called from all 4 auth endpoints
- [ ] Consolidate `detect-changes.sh` + `dev-env-scan.sh` from `r-end/scripts/` to `.claude/scripts/` — same pattern as Conv 133's consolidation (deferred from DOC-SYNC-STRATEGY Phase 2)
- [ ] Full resync of `docs/reference/resend.md` template table — phantom entries (`BookingConfirmationEmail`, `SessionCompletedEmail`) + ~9 real templates missing (SessionBooking, SessionCancelled, SessionRescheduled, FeedbackReminder, ModeratorInvite, EnrollmentConfirmation, CertificateIssued, 3× CreatorApplication); Conv 133 only fixed the 3 SessionInvite rows (deferred from DOC-SYNC-STRATEGY Phase 2)
- [x] **[LE-TRIAGE]** — Completed: see COMPLETED_PLAN.md §POLISH.LINT_EXHAUSTIVE_DEPS (Conv 147-149)


### POLISH.SECURITY_HARDENING
- [ ] Audit logging for admin actions (see OBSERVABILITY.AUDIT-LOG)
- [ ] Rate limiting on sensitive endpoints
- [ ] Explicit role checks where derived permissions are used
- [ ] Proper token refresh flow — refresh token currently used as direct auth credential in `getSession()` fallback, granting 7-day privileged API access after 15-min access token expires. Needs: refresh endpoint + client auto-refresh + getSession fix (Conv 112)

### POLISH.DEFERRED_FEATURES
- [ ] Session reminders (Cloudflare cron)
- [ ] Compatible member matching (Jaccard similarity)
- [ ] User → Member rename (platform-wide)
- [ ] Community filtering by topic on `/discover/communities`
- [ ] Remove MyXXX pages — pending client agreement (Conv 054)
- [ ] Smart Feed algorithm UX simplification (Conv 059)
- [ ] Student profile — "Following Courses" section using `GET /api/me/course-follows` (deferred from COURSE-FOLLOWS block, Conv 138)
- [x] Email notification fallback for session invites — Conv 130: 3 email templates (SessionInviteEmail, SessionInviteAcceptedEmail, SessionInviteDeclinedEmail); fire-and-forget on create/accept/decline paths; also fixed gap in decline.ts (missing in-app notification to teacher added). All use `session_booked` preference type.

---

## Deferred: MVP-GOLIVE

**Focus:** Production readiness for all external service providers
**Status:** ⏸️ DEFERRED (until launch decision)
**Last Audited:** Session 223 (2026-02-18)

All code is implemented and tested in dev/preview environments. Go-live requires adding production secrets to Cloudflare, registering endpoints in provider dashboards, and verifying DNS/domain configuration. No code changes expected — this is all infrastructure and configuration.

### Production Readiness Scorecard

| Provider | Code | Dev/Preview | Prod Secrets | Prod Config | Ready? |
|----------|:----:|:-----------:|:------------:|:-----------:|:------:|
| **Stripe** | ✅ | ✅ Staging webhook active | ❌ Deferred | ❌ Prod webhook not registered | 🟡 |
| **Stream.io** | ✅ | ✅ | ❌ Not set | ⚠️ Verify feed groups in prod app | 🟡 |
| **Resend** | ✅ | ✅ | ❌ Not set | ❌ Domain not verified, DNS not set | 🔴 |
| **BigBlueButton** | ✅ | ✅ Blindside Networks | ❌ Not set | ❌ Prod webhook not registered | 🟡 |
| **Google OAuth** | ✅ | ❌ No credentials | ❌ Not set | ❌ Not registered in Google Console | 🔴 |
| **GitHub OAuth** | ✅ | ❌ No credentials | ❌ Not set | ❌ Not registered in GitHub | 🔴 |
| **Cloudflare** | ✅ | ✅ | ❌ Not set | ✅ Bindings configured | 🟡 |

### MVP-GOLIVE.AUTH
*Re-evaluate auth approach before launch*

- [ ] Re-evaluate JWT auth vs Astro Sessions — assess whether any workarounds during development would be better served by session-based auth (see `docs/as-designed/auth-sessions.md`)

### MVP-GOLIVE.STRIPE
*Payment processing and marketplace payouts*
**Tech Doc:** `docs/reference/stripe.md` (comprehensive webhook docs added Session 223)

**What's done:** Complete Stripe Connect integration — checkout, transfers (with idempotency keys), refunds, 7 webhook handlers (including dispute handling with transfer reversal), self-healing status sync, Express onboarding flow tested end-to-end. Staging webhook active at `staging.peerloop.pages.dev` (Session 224). Enrollment self-healing fallback for missed webhooks — success page SSR + /courses localStorage bridge (Session 324). Fixed `enrollments.student_teacher_id` FK mismatch (was inserting st-xxx instead of usr-xxx, Session 324). Fixed teacher profile session count JOINs and ST booking URL pre-selection (Session 324).

**Go-live steps:**
- [ ] Add `STRIPE_SECRET_KEY` (`sk_live_...`) to CF Dashboard Production secrets
- [ ] Register webhook endpoint in Stripe Dashboard (live mode):
  - URL: `https://<production-domain>/api/webhooks/stripe`
  - Events: `checkout.session.completed`, `charge.refunded`, `account.updated`, `transfer.created`, `charge.dispute.created`, `charge.dispute.closed`
- [ ] Copy generated `whsec_...` to CF Dashboard as `STRIPE_WEBHOOK_SECRET`
- [ ] Update `STRIPE_PUBLISHABLE_KEY` in `wrangler.toml` top-level `[vars]` to `pk_live_...`
- [ ] Test with real $1 charge → verify webhook arrives → refund immediately
- [ ] Configure Stripe branding (Dashboard → Settings → Branding):
  - [ ] Update account display name from "Alpha Peer LLC" to "Peerloop"
  - [ ] Upload Peerloop logo/icon (appears on Connect onboarding left panel)
  - [ ] Set brand color and accent color to match Peerloop palette

**Caveat:** Live-mode keys were intentionally deferred (Session 207, tech-026) to prevent accidental real charges during development.

**Pre-launch hardening:**
- [ ] Stripe Event Polling via Cron Trigger — catch-up for missed webhooks (enrollment self-healing done in Session 324; still needed for transfers, disputes, payout failures)
- [ ] Extended self-healing — reconcile transfer/dispute status on relevant page loads (enrollment self-healing done in Session 324; extend pattern to other entities)
- [ ] Dynamic admin lookup for dispute notifications (currently hardcoded to `'usr-admin'`; should query for admin role)
- [ ] Dispute evidence submission tooling (currently admin responds via Stripe Dashboard directly)
- [ ] `payout.failed` webhook endpoint (requires separate Connected accounts webhook in Stripe Dashboard)
- [ ] `checkout.session.expired` handler (clean up pending enrollments from abandoned checkouts)
- [ ] `transfer.reversed` handler (safety net for confirming transfer reversals)
- [ ] `/api/dev/simulate-checkout` endpoint (dev-only, skips Stripe Checkout redirect for faster manual testing)

### MVP-GOLIVE.STREAM
*Activity feeds (GetStream.io)*
**Tech Doc:** `docs/reference/stream.md`

**What's done:** REST API client (edge-compatible, no Node SDK), feed groups configured in dev app, enrollment-triggered follow relationships, course discussion feeds.

**Current config:**
- Dev/Preview app: `1457190` (configured in `wrangler.toml [env.preview.vars]`)
- Production app: `1456912` (configured in `wrangler.toml` top-level `[vars]`)

**Go-live steps:**
- [ ] Add `STREAM_API_SECRET` (prod app secret) to CF Dashboard Production secrets
- [ ] Verify Stream Dashboard (prod app `1456912`) has all feed groups:
  - `townhall` (flat), `course` (flat), `community` (flat)
  - `notification` (notification), `timeline` / `timeline_aggregated` (aggregated)
- [ ] Test feed creation and activity posting against prod app
- [ ] Verify token generation works with prod app credentials

**Note:** `STREAM_API_KEY` and `STREAM_APP_ID` are non-secrets already in `wrangler.toml`.

### MVP-GOLIVE.RESEND
*Transactional email*
**Tech Doc:** `docs/reference/resend.md`

**What's done:** SDK integrated, React Email templates framework, Cloudflare Workers compatible.

**API key status:** Verified working (Session 252, 2026-02-22). Dev key can send emails successfully. Without a verified domain, Resend restricts recipients to the account owner's email only.

**Go-live steps (CRITICAL — has lead time):**
- [ ] **Domain verification** — see **RESEND-DOMAIN** section above (moved out of go-live; do ASAP to unblock testing)
- [ ] Add `RESEND_API_KEY` (prod key `re_ZpBp...`) to CF Dashboard Production secrets
- [ ] Complete email templates: welcome, verification, password reset, session booking, payment receipt
- [ ] Test email delivery to real inboxes (check spam scoring)
- [ ] Implement email verification flow (depends on domain verification)
- [ ] Test moderator invite flow end-to-end (email delivery requires domain verification)
- [ ] (Optional) Configure Resend webhooks for bounce/complaint handling

**Caveat:** Without domain verification, emails send from `onboarding@resend.dev` which looks unprofessional and may be spam-filtered. Start DNS setup early.

### MVP-GOLIVE.BBB
*Video sessions (BigBlueButton via Blindside Networks)*
**Tech Doc:** `docs/reference/bigbluebutton.md`

**What's done:** VideoProvider interface, BBB adapter (with `!` encoding and URL normalization fixes), session CRUD + join + reschedule APIs, webhook handler, `/session/[id]` page, SessionRoom with `window.open()` + polling, recording endpoint, StudentDashboard upcoming sessions. Blindside Networks selected as managed BBB provider (no self-hosting needed).

**Go-live steps:**
- [ ] Get production BBB_SECRET from Blindside Networks (Binoy Wilson, `binoy.wilson@blindsidenetworks.com`)
- [ ] Add `BBB_SECRET` to CF Dashboard Production secrets
- [ ] `BBB_URL` already in `wrangler.toml` for all environments
- [ ] Configure BBB webhooks to call `https://<production-domain>/api/webhooks/bbb`
- [ ] Test meeting creation, join URLs, and recording with Blindside server

**Note:** No server provisioning needed — Blindside Networks provides managed BBB SaaS.

### MVP-GOLIVE.OAUTH
*Social login (Google + GitHub)*
**Tech Doc:** `docs/reference/google-oauth.md`

See OAUTH block for full checklist.

**Key lead-time item:** Google OAuth consent screen verification takes **1-2 weeks** for apps with >100 users. Start early.

### MVP-GOLIVE.CLOUDFLARE
*Infrastructure: D1, R2, KV, Pages*

**What's done:** All bindings configured in `wrangler.toml`. D1 databases exist (`peerloop-db` for prod, `peerloop-db-staging` for preview). R2 bucket `peerloop-storage` configured for both environments. KV namespace `SESSION` removed Conv 095 (unused — re-add for feature flags post-MVP).

**Go-live steps:**
- [ ] Add all secrets to CF Dashboard Production tab:
  - `JWT_SECRET` (generate fresh with `openssl rand -base64 32`)
  - All provider secrets listed above (Stripe, Stream, Resend, BBB, OAuth)
- [ ] Run `npm run db:migrate:prod` to apply schema to production D1
- [ ] Run `npm run db:setup:local:clean` to test fresh-install flow (no dev seed data)
- [ ] Verify R2 bucket permissions for production reads/writes
- [ ] Re-add KV `SESSION` namespace if feature flags needed (removed Conv 095)
- [ ] Configure custom domain in CF Pages (e.g., `peerloop.com`)
- [ ] Set up DNS records pointing domain to CF Pages

### MVP-GOLIVE.DOMAIN
*Production domain setup (prerequisite for most providers)*

**Why this matters:** Most provider registrations (Stripe webhook URL, OAuth callback URLs, Resend domain verification) require knowing the **exact production domain**. This should be decided first.

- [ ] Decide production domain (e.g., `peerloop.com`, `app.peerloop.com`)
- [ ] Configure domain in Cloudflare DNS
- [ ] Point domain to CF Pages deployment
- [ ] Verify HTTPS is working
- [ ] Update all provider configurations with final domain

### MVP-GOLIVE.EXECUTION_ORDER

Recommended order based on dependencies and lead times:

| Step | Provider | Why This Order | Lead Time |
|------|----------|---------------|-----------|
| 1 | **Domain** | All other providers need the production URL | Hours |
| 2 | **Cloudflare** | Secrets + DB migration; foundation for everything | Hours |
| 3 | **Resend** | DNS verification has variable wait time | Hours-24h |
| 4 | **Google OAuth** | Consent screen verification takes 1-2 weeks | **1-2 weeks** |
| 5 | **GitHub OAuth** | Quick registration, no verification needed | Minutes |
| 6 | **Stream.io** | Just add secret + verify feed groups | Minutes |
| 7 | **Stripe** | Register webhook + add secrets; test last | Hours |
| 8 | **BBB** | Heaviest infra; can defer if needed | Days-weeks |

### MVP-GOLIVE.OAUTH (absorbed Conv 095)

Code implemented and tested for both Google and GitHub OAuth. Missing: app registrations in provider consoles.

- [ ] Google: Create project, consent screen, OAuth Client ID, redirect URIs, add secrets to CF
- [ ] GitHub: Create OAuth App, callback URL, add secrets to CF
- [ ] Google consent screen verification: **1-2 weeks** for >100 users — start early
- [ ] See `docs/reference/google-oauth.md` for full walkthrough

### MVP-GOLIVE.CRON-CLEANUP (absorbed Conv 095; extended Conv 141 / Phase B)

**Status:** Phase A (infra) ✅ COMPLETE | Phase B (BBB-FIX) ✅ COMPLETE (Conv 142) | Awaiting 1-week staging health gate before Prod deploy

Currently `detectNoShows()` + `detectStaleInProgress()` + `reconcileBBBSessions()` run manually via admin. For production, add automated scheduled runs.

**Architectural decision (Conv 141):** `@astrojs/cloudflare 13` does not expose `workerEntryPoint` — the Astro Worker cannot cleanly add a `scheduled()` export. Decision: deploy cron as a **separate standalone Worker** (`peerloop-cron` / `peerloop-cron-staging`) sharing D1/R2 bindings via binding IDs. Cleaner separation, reusable for future Stripe polling cron.

**Phase A (Infra) — COMPLETE:**

- [x] Investigate Astro + CF adapter dual exports (`fetch` + `scheduled`) — resolved: adapter doesn't support; use separate Worker
- [x] Refactor `src/pages/api/admin/sessions/cleanup.ts` — extracted shared logic into `src/lib/cleanup.ts` (called by both the admin endpoint and the cron Worker)
- [x] Create `../Peerloop/workers/cron/` standalone Worker — `wrangler.toml`, `src/index.ts` with `scheduled()` export, shared D1/R2 bindings
- [x] Add `[triggers.crons]` to cron Worker's wrangler.toml (`*/15 * * * *` staging, `*/30 * * * *` prod)
- [x] Add npm scripts `deploy:cron:staging` / `deploy:cron:prod`
- [x] Deploy to staging; verified `wrangler tail` shows scheduled runs ✅ **First run 2026-04-21T09:30:35Z recovered 1 real missed BBB recording_ready webhook**

**Phase B scope (driven by `docs/as-designed/webhook-miss-resilience.md`):**

- [x] BBB-FIX: one-sided-crash timeout — `detectOrphanedParticipants()` function wired before `detectStaleInProgress` (Conv 142)
- [x] BBB-FIX: `INSERT OR IGNORE` guard on `participant_joined` attendance insert with partial unique index (Conv 142)
- [x] BBB-FIX: `duration_minutes` fallback — `completeSession()` backfill via `COALESCE(started_at, ?)` (Conv 142)
- [ ] Prod cron deploy — `deploy:cron:prod` + set prod BBB_SECRET (awaiting 1-week staging health gate, ~2026-04-28)
- [ ] Notification batching (daily digest vs individual alerts) — deferred; low priority until volume grows

### MVP-GOLIVE.STAGING-VERIFY (absorbed Conv 095)

Unified staging integration tests for all external services. Replaces BBB-VERIFY remaining items.

**Webhook miss-resilience (BBB + Stripe — Conv 141/143/144):** ✅ Phase A complete for both providers. BBB scenarios live-verified Conv 141/142. Stripe: direct-sign harness Conv 143, all 7 scenarios live-verified on staging Conv 144. Phase A uncovered a **production-blocker Stripe bug** (`constructEvent` → `constructEventAsync` — SubtleCryptoProvider sync-context failure on CF Workers since the Conv 114 migration; every Stripe webhook silently HTTP 400'd in staging). Fix deployed Conv 144. Three Phase B Stripe follow-ups added: [VD] `(student, course)` UNIQUE race, [VW] `webhook_log` `ctx.waitUntil()`, [VA] STRIPE_SECRET_KEY mode audit.

- [x] BBB: Harness extended + live-verified on staging; Phase B BBB-FIX block scoped; see CRON-CLEANUP
- [x] [VH] Stripe direct-sign POST helper — 7 events (`stripe-*-direct`) + `stripe-direct-raw` (Conv 143)
- [x] [VS] Stripe staging end-to-end verification — Conv 144: all 7 scenarios LIVE (S1–S7). See `docs/as-designed/webhook-miss-resilience.md §Stripe live-verified scenarios (Conv 144)`. Also hardened harness with `STUDENT_ID`/`COURSE_ID`/`SESSION_ID`/`TEACHER_ID`/`CREATOR_ID`/`TEACHER_CERT_ID` env-var overrides (was only `PENDING_ENR`/`CHECKOUT_ID`/`PI_ID`/`AMOUNT`). Also landed Stripe Mode Discipline decision (local=Test, staging=Sandbox, prod=Live) in `docs/DECISIONS.md §8` + `docs/reference/stripe.md`
- [x] **[Stripe constructEventAsync fix]** Prod-blocker bugfix (Conv 144) — `src/lib/stripe.ts` + `src/pages/api/webhooks/stripe.ts:64` switched to `await constructEventAsync()`. Deployed to staging 2026-04-21 version `254fa8e9`. Unit tests (17/17) pass
- [ ] Stream: verify feed creation + activity posting against staging app
- [ ] Resend: plus-addressed email capture (`fgorrie+{handle}@bio-software.com`), verify delivery
- [x] **[VD]** `handleCheckoutCompleted` early-return on `(student, course)` dedup (Phase B Stripe — Conv 145). Added partial-index-predicate-matching SELECT in `src/lib/enrollment.ts` after existing `pending_enrollment_id` idempotency check; matches `status IN ('enrolled', 'in_progress')` predicate exactly; on collision logs `ADMIN_ALERT duplicate_enrollment_attempt` warning and returns existing enrollment ID idempotently. Test added: `blocks duplicate-purchase when (student, course) already active`. Avoids SQLITE_CONSTRAINT_UNIQUE → HTTP 500 → Stripe retry storm when a fresh `pending_enrollment_id` collides with an existing enrollment for same student + course.
- [x] **[VW]** `webhook_log` INSERT wrapped in `ctx.waitUntil()` for Stripe + BBB (Phase B Stripe — Conv 145). Wrapped fire-and-forget `db.prepare(...).run().catch(...)` in `locals.cfContext.waitUntil(...)` at `src/pages/api/webhooks/stripe.ts:75-85` and `src/pages/api/webhooks/bbb.ts:80-90`; updated test helper `cfContext` stub from `{}` to real shape with `waitUntil` + `passThroughOnException` no-ops. Fixes default-case (short-path) events losing their log entry due to fire-and-forget race with Worker context termination.
- [x] **[VA]** Audit staging Worker `STRIPE_SECRET_KEY` is a Sandbox `sk_test_` (not Test-mode) (Phase B Stripe — Conv 145). Built admin-gated `/api/admin/stripe-mode` endpoint (`src/pages/api/admin/stripe-mode.ts` + 4 tests) using `stripe.accounts.retrieveCurrent()`; deployed to staging Version `e5f00fb0`; verified staging account_id `acct_1SkSfYRu7i9fxxy0` = Sandbox workbench (not Test-mode `acct_1SkSfMRyHGcVUhoO`); mode aligned with webhook secret. Mode-split risk averted: `stripe.transfers.list()` will work correctly (no mode mismatch → reversals run as designed).
- [x] **[VL]** Rotate leaked `sk_test_...PP6iSq` Test-mode key (Phase B Stripe — Conv 145). Safe-grep audit: 5 occurrences in docs-repo Extracts (all redacted stubs, no full value leaked); `.dev.vars` clean; code repo clean. Stripe CLI cache refreshed via `stripe login` (Test-mode Standard key now current); final verification `grep -c "PP6iSq" ~/.config/stripe/config.toml` → 0. Hygiene complete; Test-mode only — does NOT affect Sandbox/staging or Live.
- [ ] **[STRIPE-UI-UPDATE]** Update `docs/reference/stripe.md` §Stripe Mode Discipline + §Per-Environment Webhook Configuration with note about Stripe Dashboard UI merging Test-mode into the Sandboxes listing page (screenshot: banner "Test mode is now part of sandboxes, so you can manage all of your test environments in one place.") — account-level isolation unchanged (`acct_1SkSfMRyHGcVUhoO` Test vs `acct_1SkSfYRu7i9fxxy0` Sandbox), but navigation has shifted from separate toggle to unified Sandboxes page. Discovered Conv 145 [VA] verification step.

### MVP-GOLIVE.RECORDING-PERSIST (absorbed Conv 095)

Cookie-based `.m4v` download implemented (Conv 037). Remaining:

- [ ] Verify `recording_url` populated by webhook on live BBB session
- [ ] Verify cookie-based download produces valid `.m4v`
- [ ] Confirm BBB shared secret matches `BBB_SECRET`
- [ ] Recording playback/download UI on session detail page
- [ ] Admin: expose `recording_size_bytes`, query recording status across sessions

---

## Deferred: PAGES-DEFERRED

**Focus:** 7 pages deferred per client directive — not yet designed for the Twitter-style left-side menu layout
**Status:** ⏸️ DEFERRED (post-MVP, pending client direction)
**Unimplemented stories:** 6 (US-S065, US-M004, US-C026, US-S081, US-P097, US-P099)

**Open question:** Current app pages use a Twitter-like left-side menu navigation. These more traditional/standard pages need layout decisions — do they use the same left-side menu pattern, or a different layout?

| Code | Page | Route | Stories | Notes |
|------|------|-------|---------|-------|
| HELP | Summon Help | `/help` | *(see GOODWILL block)* | Blocked on goodwill system |
| BLOG | Blog | `/blog` | — | Content not ready |
| CARE | Careers | `/careers` | — | Content not ready |
| CHAT | Course Chat | `/courses/:slug/chat` | US-S065, US-M004 | Superseded by community feeds |
| CNEW | Creator Newsletters | `/creating/newsletters` | US-C026 | Post-MVP |
| SUBCOM | Sub-Community | `/groups/:id` | US-S081, US-P097 | Post-MVP |
| CLOG | Changelog | `/changelog` | US-P099 | Gap story — no route exists yet |

---

## Deferred: RATINGS-EXT

**Focus:** Extended ratings features beyond core session/completion reviews
**Status:** 📋 PLANNING
**Tech Doc:** `docs/as-designed/ratings-feedback.md`

**Context:** Core rating system is complete (session assessments + completion reviews). These extensions add richer feedback dimensions and display.

### RATINGS-EXT.EXPECTATIONS

*Capture student goals/expectations at enrollment time*

- [ ] `enrollment_expectations` table (schema in tech-022)
- [ ] POST endpoint to capture expectations post-purchase
- [ ] Optional update after each session
- [ ] Display in completion review context ("did course meet expectations?")

### RATINGS-EXT.MATERIALS

*Separate course content quality rating from teaching quality*

- [ ] `course_reviews` table with optional sub-ratings (clarity, relevance, depth)
- [ ] Add `rating` and `rating_count` columns to `courses` table
- [ ] Two-part completion review modal (teaching + materials)
- [ ] Course page displays materials rating separately from Teacher rating
- [ ] Creator analytics: materials feedback breakdown

### RATINGS-EXT.DISPLAY

*Surface ratings in more places*

- [ ] Show completion reviews on Teacher public profile page
- [ ] Rating trend charts in Teacher/Creator analytics dashboards

---

## Deferred: EMAIL-TZ

**Focus:** Format notification/email times in recipient's local timezone
**Status:** 📋 PENDING
**Conv:** 002

**Context:** Conv 002 completed UTC-TIMES (session timezone normalization). Emails currently show times in UTC with "UTC" label. For polish, format in recipient's timezone — requires adding `timezone` column to users table and querying it during notification formatting.

- [ ] Add `timezone TEXT` column to users table (IANA timezone string, e.g., `America/New_York`)
- [ ] Populate during onboarding or profile settings (detect from browser `Intl.DateTimeFormat().resolvedOptions().timeZone`)
- [ ] Use `formatLocalTime(utcIso, userTimezone)` in session creation, reschedule, and cancellation email formatting
- [ ] Use `formatLocalTime()` in in-app notification text

---

## Deferred: PUBLIC-PAGES

**Focus:** Unified header/footer/nav/currentUser strategy for public-facing pages
**Status:** 📋 PENDING
**Session:** 385

**Context:** Session 385 audit found three layout/header components serving different page types, each with independent auth patterns:

| Layout | Header Component | Auth Pattern | Pages |
|--------|-----------------|--------------|-------|
| `AppLayout` | `AppNavbar.tsx` | `initializeCurrentUser()` (full `/api/me/full`) | ~54 authenticated pages |
| `AdminLayout` | `AdminNavbar.tsx` | `initializeCurrentUser()` (full `/api/me/full`) | 14 admin pages |
| `LandingLayout` | `Header.tsx` | `fetch('/api/auth/session')` (lightweight) | ~26 public pages |
| `LegacyAppLayout` | `AppHeader.tsx` | `fetch('/api/auth/session')` + notification count | Deprecated, still mounted |

**Problems to solve:**

1. **Header.tsx uses stale role booleans** — `/api/auth/session` returns `is_student`, `is_teacher`, `is_creator` as flat DB flags, not derived from actual course relationships. A user with `can_create_courses=true` but zero created courses shows "Creator Dashboard" link incorrectly.

2. **Header.tsx `getDashboardLink()` duplicates AppNavbar logic** — role-priority routing (admin → creator → teacher → student) is implemented independently in both components with different field names (`is_admin` vs `isAdmin`).

3. **No shared footer** — public and app pages have no consistent footer component. Marketing pages need footer nav (About, Privacy, Terms, etc.), app pages may need a slimmer version.

4. **AppHeader.tsx (legacy) is a dead-end** — has its own mobile sidebar with hardcoded routes that don't match AppNavbar. Should be removed once all pages use AppLayout.

5. **Public pages can't personalize for returning users** — e.g., `/courses` could show "Continue Learning" for enrolled courses, but Header.tsx doesn't initialize currentUser and there's no `getCurrentUserIfCached()` helper.

### PUBLIC-PAGES.HEADER-UNIFY

*Unify Header.tsx auth with currentUser cache*

- [ ] Add `getCurrentUserIfCached()` to `current-user.ts` — reads localStorage only, no fetch, returns `CurrentUser | null`
- [ ] Refactor `Header.tsx` to use `getCurrentUserIfCached()` instead of `/api/auth/session`
- [ ] Fall back to lightweight session fetch only if no cache exists (first-time visitor who never visited an AppLayout page)
- [ ] Replace stale `is_teacher`/`is_creator` booleans with currentUser's `isActiveTeacher()`/`hasCreatedCourses()` for accurate dashboard routing
- [ ] Extract shared `getDashboardLink(user)` utility used by both Header and AppNavbar

### PUBLIC-PAGES.LEGACY-CLEANUP

*Remove AppHeader.tsx and LegacyAppLayout*

- [ ] Audit which pages (if any) still use `LegacyAppLayout.astro`
- [ ] Migrate remaining pages to `AppLayout.astro`
- [ ] Delete `AppHeader.tsx` and `LegacyAppLayout.astro`
- [ ] Remove `AppHeader` from any component exports/barrels

### PUBLIC-PAGES.FOOTER

*Shared footer component for public and app pages*

- [ ] Design footer structure (links, social, copyright)
- [ ] Create `Footer.astro` component (zero JS, build-time)
- [ ] Add to `LandingLayout.astro`
- [ ] Decide whether app pages need a footer variant (likely no — sidebar layout doesn't need one)

### PUBLIC-PAGES.PERSONALIZATION

*Returning-user awareness on public pages (stretch)*

- [ ] `/courses` — show "Continue Learning" badge on enrolled courses via `getCurrentUserIfCached()`
- [ ] `/` (landing) — show "Go to Dashboard" instead of "Get Started" for cached users
- [ ] `EnrollButton` on public course pages — instant "Go to Course" for enrolled users (no fetch needed)

---

## Deferred: CERT-APPROVAL

**Focus:** Full certificate lifecycle — creator approval UI, student certificate page, PDF generation & R2 storage, dead link fixes
**Status:** 📋 PENDING
**Origin:** Session 359 (capabilities review), Conv 007 (seed data review), Session 390 (LearnTab blocker), Conv 042 (CompletedTabContent dead link)

### What Exists

| Piece | Status | Location |
|-------|--------|----------|
| `certificates` table | ✅ Full schema | `migrations/0001_schema.sql:650` — id, user_id, course_id, type (completion/mastery/teaching), status (pending/issued/revoked), certificate_url (always NULL), recommended_by, issued_by |
| Admin list/create | ✅ Built | `GET/POST /api/admin/certificates` — paginated listing with status/type filters + stats |
| Admin approve | ✅ Built | `POST /api/admin/certificates/[id]/approve` — pending→issued, syncs `teacher_certifications` for teaching certs, sends email via Resend (`CertificateIssuedEmail`) + notification |
| Admin reject | ✅ Built | `POST /api/admin/certificates/[id]/reject` — hard-deletes pending cert |
| Admin revoke | ✅ Built | `POST /api/admin/certificates/[id]/revoke` — issued→revoked, deactivates teaching cert if applicable |
| Teacher recommend | ✅ Built | `POST /api/me/certificates/recommend` — teacher recommends enrolled student, creates `pending` cert (validates: active teacher, certified for course, student enrolled, student completed for teaching certs) |
| My certificates | ✅ Built | `GET /api/me/certificates` — user's own certs with course/issuer joins |
| Public verify | ✅ Built | `GET /api/certificates/[id]/verify` — no-auth verification endpoint |
| CompletedTabContent | ⚠️ Dead link | `src/components/discover/detail-tabs/CompletedTabContent.tsx:40` — links to `/course/[slug]/certificate` (doesn't exist), has "coming soon" disclaimer |
| LearnTab | ⚠️ TODO | `src/components/courses/LearnTab.tsx:382` — commented TODO for certificate link |

### What's Missing

**The certificate lifecycle has 5 gaps:**

1. **Creator has no approval UI** — Only admin can approve/reject. The flywheel requires creators to certify their own students. Creator dashboard has no pending-certificates view.
2. **Creator not notified** — When a teacher recommends a student, no notification goes to the course creator. Only admin would see it.
3. **No student certificate page** — `/course/[slug]/certificate` doesn't exist. Two UI elements link to it (CompletedTabContent, LearnTab TODO).
4. **No PDF generation** — No library installed, no template designed, `certificate_url` is always NULL. R2 helpers exist (`src/lib/r2.ts`) but no cert-specific upload code.
5. **No public certificate view** — The verify endpoint returns JSON; there's no shareable HTML page for a certificate.

### CERT-APPROVAL.PHASE-1 — Dead Link Fix + Student Certificate Page

*Minimum viable: show certificate status to students who earned one, fix dead links*

- [ ] Create `/course/[slug]/certificate` page (Astro SSR)
  - Fetch user's certificate for this course via `GET /api/me/certificates` (filter by course)
  - States: not-authenticated → login redirect, no-certificate → "not earned", pending → "awaiting approval", issued → certificate display, revoked → revoked message
  - Issued state: show course name, student name, issue date, certificate ID, issuer name, type badge
  - If `certificate_url` exists: "Download PDF" button (for Phase 3)
  - If `certificate_url` is NULL: "PDF coming soon" note (graceful degradation)
  - Public share link: `/certificates/[id]/verify` (already exists as API, needs HTML page — see Phase 4)
- [ ] Fix CompletedTabContent dead link (`src/components/discover/detail-tabs/CompletedTabContent.tsx:40`)
  - Link should go to `/course/${courseSlug}/certificate` — URL is correct, just needs the page to exist
  - Remove "coming soon" disclaimer once page is live
- [ ] Fix LearnTab TODO (`src/components/courses/LearnTab.tsx:382`)
  - Add "View Certificate" link in completion celebration card
- [ ] Tests: certificate page rendering (all 5 states), auth redirect, data display

### CERT-APPROVAL.PHASE-2 — Creator Approval Flow

*Creator-facing certification management — the flywheel step where creators certify graduates*

- [ ] `GET /api/me/courses/[id]/pending-certificates` — list pending certs for a creator's course
- [ ] `POST /api/me/courses/[id]/certificates/[certId]/approve` — creator approves (reuse approve logic from admin endpoint, verify creator owns course)
- [ ] `POST /api/me/courses/[id]/certificates/[certId]/reject` — creator rejects with reason
- [ ] Creator notification: when teacher recommends a student, notify the course creator (new notification type: `cert.recommendation_received`)
- [ ] Creator dashboard UI: "Pending Certifications" section or tab showing students awaiting approval
  - Student name, course, recommending teacher, recommendation date
  - Approve / Reject buttons with confirmation
- [ ] Student notification on approval/rejection (approval notification already exists via admin flow — verify it fires for creator approval too)
- [ ] Tests: creator approval/rejection, authorization (only course creator can approve), notification delivery
- [ ] Build "Recommend for Certification" UI button on teacher-facing student views (Conv 082: `POST /api/me/certificates/recommend` has zero UI consumers)
- [ ] Fix dashboard attention item "Certification recommendation" → link to actionable destination (currently `/teaching/students` has no recommend action)
- [ ] Unified admin visibility for both certification paths (creator direct writes to `teacher_certifications` only; recommend/approve writes to `certificates` then syncs — admin Certificate Management page only shows `certificates` table)

### CERT-APPROVAL.PHASE-3 — PDF Generation & R2 Storage

*Generate certificate PDFs on approval and store to R2*

- [ ] Choose PDF library — candidates: `pdf-lib` (lightweight, no native deps, CF Workers compatible), `@react-pdf/renderer` (React-based templates), or server-side HTML→PDF
  - **Constraint:** Must work in Cloudflare Workers environment (no Puppeteer/Chrome)
- [ ] Design certificate template: course name, student name, date, certificate ID, type badge, creator signature area, verification QR code
- [ ] `generateCertificatePDF(cert)` function in `src/lib/certificates.ts`
- [ ] Hook into approve endpoint: generate PDF → upload to R2 at `certificates/{cert_id}/certificate.pdf` → store URL in `certificates.certificate_url`
- [ ] Update student certificate page: when `certificate_url` exists, show "Download PDF" button
- [ ] Seed data: add sample certificate URLs once generation works
- [ ] Tests: PDF generation, R2 upload, URL storage

### CERT-APPROVAL.PHASE-4 — Public Certificate Page (Optional)

*Shareable HTML certificate view — currently verify endpoint is JSON-only*

- [ ] Create `/certificates/[id]` public page (no auth required)
  - Shows: recipient, course, issuer, date, type, validity status
  - Revoked certs: show revoked status with date
  - QR code linking back to this page for physical certificate verification
- [ ] Update student certificate page: "Share" button with copyable public URL
- [ ] Consider: Open Graph meta tags for social sharing preview

---

## Post-MVP Phases

*After PMF confirmation:*

| Phase | Purpose | Notes |
|-------|---------|-------|
| 11 | Goodwill Points System | 25 stories (23 P2, 2 P3). Points engine, summon help, tiers, anti-gaming. Detail in git history (removed Conv 095). Source: CD-010, CD-011, CD-023. |
| 12 | Gamification (leaderboards, badges) | Partially covered by GOODWILL |
| 13 | Database Backups & Disaster Recovery | |
| 14 | Full Legal/Compliance Review | |
| 15 | Scalability Optimization | |
| 16 | Mobile/PWA + R2 Video Streaming | |
| 17 | User Documentation/Help Center | |
| 18 | Localization/i18n | |
| 19 | Feature Flags | Re-add KV bindings + KV-backed flags. See `docs/reference/cloudflare-kv.md`. KV removed Conv 095. |
| 20 | Payment Escrow | Not implemented — immediate transfer + clawback. Client decides (US-P074/75/76). |
| 21 | Session Credits | Schema exists, dispute path works. Redemption depends on GOODWILL. |

*Additional deferred features:*
- Certificate PDF generation (→ CERT-APPROVAL.PHASE-3)
- "Schedule Later" video booking (from VIDEO block)
- Feed promotion (→ FEEDS-NEXT.PROMOTION, 3 stories)
- PLATO: supporting runs, browser tests, harvest, docs, persona tags, runner design flaw, next-gen (design in `plato.md`)

---

## Unimplemented Story Summary

**32 stories** remain unimplemented out of 402 total (92% complete). All are P2 or P3 — **zero P0/P1 gaps**.

| Block | Stories | Priority | Notes |
|-------|---------|----------|-------|
| GOODWILL | 25 | P2 (23), P3 (2) | Largest cluster — full subsystem |
| FEEDS-NEXT.PROMOTION | 3 | P2 (1), P3 (2) | Depends on GOODWILL + FEEDS-NEXT.RANKING |
| PAGES-DEFERRED (CHAT) | 2 | P2 | Superseded by community feeds |
| PAGES-DEFERRED (SUBCOM) | 2 | P3 | User-created study groups |
| PAGES-DEFERRED (CNEW) | 1 | P3 | Creator newsletters |
| PAGES-DEFERRED (CLOG) | 1 | P2 | Changelog — gap story, no route |
| **Total** | **34** | | |

*Source: [ROUTE-STORIES.md](docs/as-designed/route-stories.md) §10 (On-Hold) and §11 (Gap)*

*Note: Count is 34 including US-P053 and US-P082 which have routes (`/discover/leaderboard`) but are blocked on the goodwill points data they need to display.*

---

## Active: ADMIN-REVIEW

**Focus:** Admin system review — testing gaps, UI consistency, cross-links, menu restructure, settings UI
**Status:** 📋 PENDING (promoted to active Conv 095)
**Absorbs:** ROLES (create UI, audit), ADMIN-SETTINGS-UI
**Conv:** 080 (audit only)

**Risk model:** 2 max users, high trust. Admins develop usage patterns and don't exercise breadth/edge cases. Regressions in decision-data (what the admin sees) or action-execution (what the admin does) are silently catastrophic — wrong data leads to wrong decisions, broken actions fail without the admin realizing.

**Audit baseline (Conv 080):**

| Layer | Source | Tested | Tests | File Coverage |
|-------|--------|--------|-------|---------------|
| Admin components | 28 | 19 | ~876 | 68% |
| Admin APIs | 67 | 55 | ~916 | 82% |
| Admin intel | — | 6 | ~50 | separate |
| Moderator component | 1 | 1 | 59 | 100% |
| **Total** | **96** | **81** | **~1900** | |

**Also completed Conv 080:** Replaced all 23 `prompt()` calls with `FormModal` across 6 admin/moderation files. Created `src/components/ui/FormModal.tsx`. Updated 2 test files.

### ADMIN-REVIEW.TESTING

**Gate question (ask at block start):** Full test implementation for all gaps, or risk-profile-prioritized subset?

#### Category 1: Decision Data — must be correct

These show admins the data they use to make decisions. Wrong/missing fields → wrong decisions.

| Gap | What It Shows | Decision It Feeds |
|-----|--------------|-------------------|
| `CreatorApplicationDetailContent` | Application for creator role | Approve/deny creator |
| `ModeratorDetailContent` | Moderator info + activity | Remove moderator |
| `UserEditModal` | Role editing form | Role assignment (escalation risk) |
| 12 × `[id].ts` API endpoints | Single-record fetch for detail panels | All detail views — a regressed field is invisible to the admin |

The 12 missing API endpoints (all GET single-record):
- `admin/enrollments/[id].ts`
- `admin/teachers/[id].ts`
- `admin/certificates/[id].ts`
- `admin/courses/[id].ts`
- `admin/sessions/[id].ts`
- `admin/users/[id].ts`
- `admin/payouts/[id].ts`
- `admin/topics/[id].ts`
- `admin/moderation/[id].ts`
- `admin/intel/courses.ts`
- `admin/intel/dashboard.ts`
- `admin/intel/communities.ts`

These are highly templatable — same pattern (auth, 404, 200 + shape validation) repeated 12 times.

#### Category 2: Action Execution — must be bulletproof

Components that trigger irreversible or hard-to-reverse operations. API tests exist but component→API wiring is untested.

| Gap | Actions | Risk |
|-----|---------|------|
| `ModeratorsAdmin` | Invite (FormModal), revoke, remove | Permission escalation/revocation |
| `TopicsAdmin` | Reorder, CRUD topics/tags | Affects course categorization site-wide |

#### Category 3: Shared Infrastructure — cascade risk

Building blocks used by every admin view. Currently tested only indirectly through parent components. A regression breaks N tests simultaneously, making root-cause diagnosis harder.

| Gap | Used By | Role |
|-----|---------|------|
| `AdminDataTable` | Every admin list view | Sorting, row selection, rendering |
| `AdminDetailPanel` | Every admin detail view | Panel open/close, sections, fields |
| `AdminFilterBar` | Every admin list view | Search, filter dropdowns |
| `AdminPagination` | Every admin list view | Page navigation, items-per-page |
| `AdminActionMenu` | Every row action | Action buttons, variants, disabled |

#### Approach options

| Option | Strategy | Sequence | Trade-off |
|--------|----------|----------|-----------|
| A | Bottom-up | Primitives → Actions → Data → APIs | Clean isolation, more upfront work |
| B | Risk-first | Actions → Data → Primitives → APIs | Highest-risk first, harder diagnosis |
| C | Hybrid | `AdminDataTable` + `AdminDetailPanel` → `ModeratorsAdmin` + `TopicsAdmin` → Detail contents → APIs. Skip `AdminFilterBar`/`Pagination`/`ActionMenu` (well-exercised indirectly). | Best risk/effort ratio |

**Recommendation:** Option C (hybrid) — gets infrastructure diagnostic value for the two highest-cascade primitives, then closes the action-execution and decision-data gaps. The 12 API endpoints batch separately regardless of option.

#### Quality notes from Conv 080 audit

- API tests use real `better-sqlite3` via `describeWithTestDB` — not mocks. Strong pattern.
- Component tests use `@testing-library/react` + `userEvent` — real interaction, not implementation-detail testing.
- `beforeEach` resets DB state — no cross-test contamination.
- No admin E2E tests — component fetch URLs aren't verified against actual API routes. A URL typo passes both layers independently.
- Test counts per file range from 15 (CreatorApplicationsAdmin) to 70 (ModerationDetailContent) — indicating depth varies.

### ADMIN-REVIEW.MENU

**Gate question (ask at block start):** Confirm current menu structure is still accurate before making changes.

#### Current Menu Structure (12 items in 3 groups)

```
OVERVIEW
└─ Dashboard (/admin)

MANAGEMENT (9 items)
├─ Users          ├─ Courses        ├─ Topics
├─ Enrollments    ├─ Teachers       ├─ Sessions
├─ Payouts        ├─ Certificates   └─ Creator Apps

MODERATION (2 items)
├─ Moderation Queue
└─ Moderators

HIDDEN (no menu entry)
└─ Analytics (/admin/analytics) — accessible by URL only
```

#### Assessment

**A. Missing from menu:**
- `/admin/analytics` exists as a full page but has no sidebar entry. Admin must know the URL.

**B. Grouping doesn't match workflow:**

The flat MANAGEMENT list has 9 items in alphabetical-ish order. But admins think in workflows, not entity types. Related items aren't adjacent:

| Workflow | Current Items (scattered) |
|----------|--------------------------|
| User lifecycle | Users → Creator Apps → Teachers → Certificates |
| Course lifecycle | Courses → Topics → Enrollments → Sessions |
| Money | Payouts (alone) |

**Recommendation:** Regroup by workflow proximity:

```
OVERVIEW
└─ Dashboard
└─ Analytics                          ← promote from hidden

PEOPLE
├─ Users
├─ Creator Apps                       ← adjacent to Users (user applies → admin reviews)
├─ Teachers                           ← certified users
└─ Moderators                         ← moved from MODERATION group

COURSES & LEARNING
├─ Courses
├─ Topics                             ← course metadata
├─ Enrollments                        ← students in courses
├─ Sessions                           ← scheduled learning
└─ Certificates                       ← completion artifacts

OPERATIONS
├─ Payouts                            ← money
└─ Moderation Queue                   ← content review
```

This groups 12+1 items into 4 semantic clusters. The admin's eye can scan to the right section by intent ("I need to deal with a person" vs "I need to check a course-related thing").

**C. Cross-linking between admin views:**

The `admin-links.ts` module provides `?highlight=` navigation between admin list views. Currently supported:

| From Detail Panel | Can Navigate To |
|-------------------|-----------------|
| User → | Profile page (member-facing) |
| Course → | Course page, Creator profile |
| Enrollment → | Course page (but NOT student profile) |
| Session → | Course page (but NOT student/teacher profiles, NOT enrollment) |
| Certificate → | Profile page, Course page |
| Payout → | Recipient profile (but NOT individual splits/transactions) |
| Moderation → | Target user profile (but NOT flagger profile) |

**Missing cross-links (high value for admin workflow):**

| Gap | Why It Matters |
|-----|---------------|
| Session → Student/Teacher profiles | Admin resolving session dispute needs to see participant history |
| Session → Enrollment | Admin needs enrollment context (payment, progress) for session issues |
| Enrollment → Student profile | Admin reviewing enrollment can't quickly check student status |
| Payout → Source enrollments/courses | Admin verifying payout can't trace to originating transactions |
| Moderation → Flagger profile | Admin assessing credibility of flag can't see who flagged it |

**D. Dual-link pattern: admin-to-admin + admin-to-member (both required):**

**Design principle:** The admin↔member boundary is intentionally bidirectional. Existing `memberUrlFor` links (`/@handle`, `/discover/course/slug`) let admins cross into the member side to see what members experience and use the ADMIN-INTEL overlays available there. This is by design — it keeps admins "in touch" with the member experience and puts decision-making apparatus on the member side.

**What's missing** is the other direction: admin-to-admin links that stay within the admin system. From SessionDetail, clicking a student name should offer BOTH `/@handle` (see them as a member) AND `/admin/users?highlight={userId}` (see them in admin context among like users). The `admin-links.ts` infrastructure already supports this via `adminUrlFor`.

**Implementation pattern:** For each entity reference in a detail panel, show two links:
- 🔗 `adminUrlFor(type, id)` — opens in admin context (primary, labeled e.g. "Admin →")
- 👤 `memberUrlFor(type, slug)` — opens in member context (secondary, labeled e.g. "Member →")

**CRITICAL: Never remove existing `memberUrlFor` links.** They are the admin's window into the member experience. Admin-to-admin links are additive.

### ADMIN-REVIEW.UI

**Gate question (ask at block start):** Confirm the functional/convenient priority still holds — not a visual polish pass.

**Design principles for this subblock:**
- Not pretty, but functional and convenient. Related items easily reachable from inside pages. Sidebar as secondary navigation.
- **Bidirectional boundary crossing:** Admin↔Member boundary is intentionally porous. Admin-to-member links (`memberUrlFor`) let admins experience the app as members see it + use ADMIN-INTEL overlays. Admin-to-admin links (`adminUrlFor`) let admins see entities in admin context among like entities. Both directions must coexist — never remove one to add the other.

#### Assessment: What works well

1. **Shared component architecture is strong.** All list views use `AdminFilterBar → AdminDataTable → AdminPagination → AdminDetailPanel` consistently. Pattern is learned once, works everywhere.
2. **Detail panels are rich.** `PanelSection` / `PanelField` / `StatusBadge` / `RoleBadge` give uniform information density.
3. **Action patterns are consistent.** ConfirmModal (now + FormModal) → toast → list refresh. Predictable feedback loop.
4. **Dashboard provides genuine operational value.** Alerts, quick actions, session cleanup, recent activity — not just vanity metrics.

#### Assessment: Friction points

**F1. Inconsistent status filtering patterns**

| View | Status Selection | Pattern |
|------|-----------------|---------|
| Users, Courses, Enrollments, Teachers, Sessions | Dropdown filter | Standard |
| Certificates | Tab bar (`all \| pending \| issued \| revoked`) | Outlier |
| Payouts | Hybrid: pending tab + dropdown for others | Outlier |

Admin learns dropdown pattern, hits tabs in Certificates, hits hybrid in Payouts. Recommendation: standardize on dropdowns for all, OR standardize on tabs for views where status is the primary workflow axis (Certificates, Payouts, Moderation). Pick one and apply consistently.

**F2. Dead feature: EnrollmentsAdmin stats**

API returns `stats: {total, active, completed, cancelled}` — component fetches but never renders them. Either display as summary cards above the table (like Dashboard metrics) or stop fetching.

**F3. PayoutsAdmin pending mode is a different UI entirely**

Pending tab shows grouped-by-recipient expandable view. All other tabs show standard table. This is the only view with two fundamentally different layouts. Recommendation: either make the grouped view the standard (with status column to distinguish), or split into two pages (`/admin/payouts` for history, `/admin/payouts/pending` for processing).

**F4. Missing admin-to-admin cross-links in detail panels (additive — keep member links)**

Detail panels link to member-facing pages (`/@handle`, `/discover/course/slug`) — this is intentional and must be preserved. These links let admins cross into the member experience to see what members see and use ADMIN-INTEL overlays for in-context decision-making.

What's missing is the **complementary** admin-to-admin direction. An admin investigating a session dispute who wants to see the student's admin record has to:
1. Open session detail
2. Note the student name
3. Close panel
4. Navigate to Users
5. Search for the student
6. Open their detail

Should be: click student name in session detail → `/admin/users?highlight={userId}` (admin view) alongside the existing `/@handle` (member view).

The `admin-links.ts` infrastructure exists for this (`adminUrlFor('user', id)` → `/admin/users?highlight={id}`). It's just not wired into most detail content components.

**Implementation:** Dual-link pattern per entity reference — admin link (primary) + member link (secondary, existing). See .MENU §D for pattern details.

**Priority detail panels for admin-to-admin wiring:**
- `SessionDetailContent` — student, teacher, enrollment links
- `EnrollmentDetailContent` — student link
- `PayoutDetailContent` — source course/enrollment links
- `ModerationDetailContent` — flagger link

**F5. No filter persistence across navigation**

Navigating away from a filtered list and returning clears all filters. Admin must re-enter search criteria. Low-cost fix: store filter state in URL query params (already partially supported via `?highlight=`).

**F6. TopicsAdmin has no detail panel**

Only admin view without a detail panel. Cannot view topic metadata, associated course count, or tag usage. Actions are limited to reorder and delete. Recommendation: add a lightweight detail panel showing course count, creation date, and usage stats.

**F7. Admin page-level auth guard gap (Conv 082)** ✅ Fixed Conv 083

~~Non-admin users can navigate to `/admin/*` pages and see the full admin sidebar layout before the API rejects the data request.~~ Auth guard added to `AdminLayout.astro` — checks JWT, verifies session, confirms admin role. Unauthenticated → `/login`, non-admin → `/`.

**F8. ModeratorsAdmin has no detail panel content**

`ModeratorDetailContent.tsx` exists as a file but its completeness should be verified at block start. If the panel shows basic info only, it should display moderation activity stats (flags reviewed, actions taken).

#### Recommended execution order

1. **Menu restructure** (ADMIN-REVIEW.MENU) — regroup sidebar, promote Analytics, add admin-to-admin links in detail panels
2. **Filter consistency** (F1) — pick tabs vs dropdowns and standardize
3. **Cross-link wiring** (F4) — wire `adminUrlFor` into detail content components (SessionDetail, EnrollmentDetail, PayoutDetail, ModerationDetail)
4. **Dead feature cleanup** (F2, F3) — render EnrollmentsAdmin stats or remove; decide on PayoutsAdmin pending layout
5. **Filter persistence** (F5) — URL query param state for filters
6. **TopicsAdmin detail panel** (F6) — lightweight panel with course count
7. **ModeratorsAdmin detail panel** (F8) — verify and enhance if needed

Items 1-4 are functional improvements (convenience, workflow). Items 5-7 are polish (nice-to-have for 2-user system).

### ADMIN-REVIEW.ROLES (absorbed from ROLES block)

*Role management additions. EDIT_UI complete (Session 280).*

- [ ] Admin user creation UI (UserCreateModal → `POST /api/admin/users`)
- [ ] Role change audit trail (subsumed by OBSERVABILITY.AUDIT-LOG)

### ADMIN-REVIEW.SETTINGS (absorbed from ADMIN-SETTINGS-UI)

*Admin UI for editing `platform_stats` values*

- [ ] Settings page: edit `availability_window_days`, 13 `smart_feed_*` parameters
- [ ] Validate ranges, show current values, save confirmation

---

## Deferred: IMAGES

**Focus:** Image pipeline — upload endpoints, management UI, delivery optimization
**Status:** 📋 PENDING
**Merged Conv 095:** FILE-UPLOADS + IMAGE-MGMT + IMAGE-OPTIMIZE

**Current state:** R2 helpers exist (`src/lib/r2.ts`). Image display complete (Conv 023: unified fallback, community covers, FeedsHub images). Schema columns exist. No POST upload endpoints. Dev seed uses static placeholder avatar.

### IMAGES.UPLOADS — Upload Endpoints

- [ ] `POST /api/me/avatar` — accept image, validate size/type, resize to 200x200, upload to R2 `avatars/{user_id}/`
- [ ] `POST /api/courses/[slug]/materials` — file type validation, upload to R2 `courses/{course_id}/materials/`
- [ ] `POST /api/courses/[slug]/thumbnail` — course thumbnail upload (creator)
- [ ] `POST /api/communities/[slug]/cover` — community cover upload (creator)
- [ ] Profile settings UI: upload button, preview, remove option

### IMAGES.OPTIMIZE — Delivery Optimization (post-MVP)

- [ ] Choose service: CF Image Resizing (stay in ecosystem) vs Cloudinary (richer transforms)
- [ ] URL helper for transform URLs, responsive `srcset`, `loading="lazy"`, WebP/AVIF auto-format
- [ ] Trigger: image count >100, mobile perf bottleneck, or video thumbnails needed

---

## Deferred: FEEDS-NEXT

**Focus:** Feed enhancements — ranking, mobile performance, privacy, level matching, promotion
**Status:** 📋 PENDING
**Merged Conv 095:** FEEDS + FEED-PROMOTION + FEED-PRIVACY + LEVEL-MATCH
**Tech Doc:** `docs/reference/stream.md`

### FEEDS-NEXT.RANKING — Algorithmic Feed Ordering

*Requires paid Stream tier — awaiting client input*

- [ ] Confirm client wants ranked feeds (paid tier cost)
- [ ] Configure ranking formula: `decay_gauss(time) * pinned * priority * content_type_weights`
- [ ] User preference weights in D1 (announcements, courses, community)
- [ ] Pin posts: creator/admin pin/unpin action + `is_pinned` field in Stream activities

### FEEDS-NEXT.MOBILE — Feed Performance

- [ ] Verify pagination with `limit` + `offset`/`id_lt` in all queries
- [ ] Feed caching (React Query or similar)
- [ ] Loading skeletons for pagination
- [ ] 3G simulation testing

### FEEDS-NEXT.PRIVACY — Feed Visibility Toggle

*Schema: `communities.is_public` exists. Courses need `feed_public` column.*

- [ ] Privacy toggle UI + API for communities and course feeds
- [ ] SMART-FEED discovery already respects flags (Conv 017)

### FEEDS-NEXT.LEVEL-MATCH — Proficiency-Based Recommendations

*Schema ready: `user_tags.level` column (Conv 071)*

- [ ] Compare `user_tags.level` with `courses.level` in `scoreCandidates()`
- [ ] Boost/penalize course recommendations by alignment

### FEEDS-NEXT.PROMOTION — Paid/Points-Based Promotion (Post-MVP)

*Depends on GOODWILL (points) + RANKING (weighted display). 3 stories (US-S071, US-P085, US-C047).*

- [ ] Student: spend goodwill points to promote posts
- [ ] Creator: pay (Stripe) for promoted course placement

---

## Deferred: OBSERVABILITY

**Focus:** Error tracking, product analytics, user activity audit logging
**Status:** 📋 PENDING
**Merged Conv 095:** SENTRY + POSTHOG + AUDIT-LOG

### OBSERVABILITY.ERROR-TRACKING — Sentry

**Problem:** 176 API files use bare `console.error` (~292 call sites) — ephemeral on CF Workers.
**Tech Doc:** `docs/reference/sentry.md`

- [ ] Install `@sentry/astro` + `@sentry/cloudflare`, add DSN to envs
- [ ] Create `src/lib/sentry.ts` shared capture utilities
- [ ] Migrate routes in priority order: payment/webhook → auth → user-facing → admin → feed
- [ ] React Error Boundary on key components
- [ ] Wire user identification into CurrentUser
- [ ] Alert rules + Slack integration
- [ ] Source map upload in deploy pipeline

### OBSERVABILITY.ANALYTICS — PostHog

**Tech Doc:** `docs/reference/posthog.md`. Free tier covers Genesis (1M events/mo).

- [ ] Install `posthog-js`, add Astro/React integration
- [ ] Key events: `course_viewed`, `enrollment_started/completed`, `session_booked/completed`, `certificate_earned`, `became_student_teacher`
- [ ] Session replays
- [ ] Feature flags for A/B experiments

### OBSERVABILITY.AUDIT-LOG — User Activity Log

**Design:** Custom D1-backed. Schema and action codes designed (detail in git history, Conv 095). Recommendation: Option A (custom D1) for MVP, CF Workers Logs as complement.

- [ ] `audit_log` table in schema + `src/lib/audit.ts` with fire-and-forget `logAction()`
- [ ] Instrument: auth, enrollment, session, payment, certificate, admin, profile, course endpoints
- [ ] Admin UI: `/admin/audit-log` with date/user/action filters, single-user timeline, CSV export
- [ ] Retention: 90-day default, R2 archival for expired logs
- [ ] Subsumes ROLES.AUDIT (role changes logged here)

---

## Deferred: STUMBLE-REMNANTS

**Focus:** Deferred findings from STUMBLE-AUDIT walkthroughs (Conv 067-088)
**Status:** 📋 PENDING

### Cross-referenced (tracked in other blocks)

These items are already detailed in their respective blocks — listed here for traceability back to the walkthrough that found them.

**→ CERT-APPROVAL:**
- Broken route: `/course/[slug]/certificate` — page doesn't exist, linked from discover pages (Conv 068)
- No "Recommend for Certification" UI button (teacher side) — `POST /api/me/certificates/recommend` has zero UI consumers (Conv 082)
- Dashboard "Certification recommendation" attention item links to `/teaching/students` which has no recommend action — dead-end (Conv 082)
- Two parallel certification paths (creator direct vs recommend/approve) with no unified admin visibility (Conv 082)

**→ PLATO (Post-MVP):**
- Create `post-enrollment` instance and `multi-student` scenario (design in `plato.md`)

### Standalone items

- [x] The Commons `member_count` denormalized counter out of sync — fixed in seed SQL via `UPDATE communities SET member_count=N` after inserts (Conv 108).
- [ ] Expired/invalid JWT session tokens — no test coverage (requires infra-level test changes to mock token expiry)

### Client decisions required

- [ ] Remove MyXXX pages (`/courses`, `/feeds`, `/communities`) — redundant with unified dashboard? Needs client confirmation.
- [ ] Home page differentiation for new members — currently shows same Twitter-like feed for everyone (Conv 067)

---

## Deferred: STRIPE-E2E-DEV

**Focus:** End-to-end Stripe integration stress test run at the Dev level — real browser, real Test-mode cards, real `stripe listen` webhook tunnel — as a rehearsal before Staging and Prod rollouts
**Status:** 📋 DEFERRED — scoped Conv 145, ready for Plan Mode
**Priority:** High — prerequisite for go-live confidence
**Origin:** Conv 145 [VD/VW/VA/VL] drain pass exposed that our existing confidence in Stripe rests on three disjoint surfaces (unit tests, harness-driven direct-sign webhook replay, one-time staging live-verification). None of them covers the "real user in a real browser with real card input routing to a real tunnel" path. That's the gap this block closes.

### Why this block exists

Conv 144 proved that integration-level Stripe bugs are real, non-theoretical, and can hide for months:
- `constructEvent` → `constructEventAsync` on CF Workers — every staging webhook had been HTTP 400'd for ~8 weeks before live-verification caught it
- `(student, course)` UNIQUE collision on duplicate-purchase — would have been a retry storm in production
- `webhook_log` INSERT racing Worker termination on short-path handlers — forensics-critical data loss

Each of those surfaced only when a real webhook hit a real handler in a real environment. Unit tests with mocks couldn't see them. The harness direct-sign tool is good for scenario-matrix coverage but can't catch runtime-specific bugs. The staging live-verification is high-value but expensive (needs deploy + Sandbox Dashboard setup + secret rotation discipline) and therefore rare — once per block, roughly.

Dev-level E2E fills the rapid-iteration slot: fix a bug, rerun the scenario in under 2 minutes, no deploy, no shared state, no coordination. That's what turns "probably works" into "demonstrably works" at the velocity of normal development.

### Current confidence surface (as of Conv 145)

| Surface | Coverage | Misses |
|---|---|---|
| Vitest unit tests (`tests/api/webhooks/stripe.test.ts`, 18 tests) | Handler logic with mocked Stripe SDK | Runtime bugs (async/sync crypto), frontend integration, real Stripe event shapes, DB sequence effects |
| Harness direct-sign replay (`scripts/trigger-webhook.sh`) | Signature verification + handler dispatch for 7 event types locally and on staging | Real card-entry UI, real Checkout session state, connected-account onboarding, dispute lifecycle |
| Staging live-verification (Conv 144, 7 scenarios S1–S7) | Real Worker runtime + real Sandbox Stripe + real webhook tunnel | One-shot, not CI-gated; requires deploy cycle; rare to re-run; no browser-driven UI step |
| `/api/admin/stripe-mode` diagnostic (Conv 145 [VA]) | Mode alignment at any time, for any env with the endpoint deployed | Doesn't exercise the payment flow itself |

**What nothing on this list covers**: a student clicks Enroll on the course page → arrives at Stripe Checkout → types `4242 4242 4242 4242` → returns to `/success` → the success page SSR self-heals → enrollment appears in the app navigation → an email gets sent. That full-stack path is the actual production user flow, and today it has zero automated coverage.

### What Dev E2E testing buys us — and why it matters for Staging and Live

The value chain is three-layered:

**Dev layer (this block):** high-fidelity, low-cost, fast iteration
- Catches handler-integration bugs that unit tests can't see (wrong redirect URL, missing DB field, silent failure in error path, race conditions between webhook handler and success-page SSR)
- Exercises the *browser-to-Stripe-to-handler-to-DB-to-UI* loop in its entirety
- Makes edge cases cheap to probe: declined cards, dispute cards, 3DS-required cards, expired cards, zero-decimal currencies
- Anyone on the team can reproduce a reported bug locally in minutes
- Shared vocabulary: "run scenario S4" becomes a thing people say, not a thing they reinvent

**Staging layer (already established by Conv 144):** Worker runtime + real Stripe infrastructure
- Catches bugs that only appear in the Cloudflare Worker runtime (SubtleCryptoProvider, execution time limits, `waitUntil` lifecycle)
- Validates secret-slot discipline (STRIPE_SECRET_KEY ↔ STRIPE_WEBHOOK_SECRET alignment within the Sandbox workbench)
- Exercises the direct-to-Stripe webhook delivery path without a local tunnel in between
- Expensive per run — deploy cycle, Sandbox Dashboard setup, secret rotation discipline — so typically one full pass per significant Stripe change

**Live layer (future go-live):** real money, real customers, one-shot
- The $1 real-charge smoke test during go-live is the final verification
- No acceptable failure rate for integration bugs — customer trust is set by their first interaction
- Anything caught here is a reputation-damaging incident, not a bug report

**The compounding effect:** each layer catches a different class of issue. Dev layer catches *functional* issues cheaply; Staging layer catches *runtime / infrastructure* issues at moderate cost; Live layer is the final confirmation. Skipping the Dev layer means functional bugs get caught at Staging cost or (worse) Live cost. The Conv 144 bugs that hid for 8 weeks are a preview of how much you pay for a missing Dev-layer tier.

**What this block does NOT replace:**
- The 18 unit tests (different abstraction, sub-second feedback)
- The staging live-verification pass (different infrastructure, Worker-specific)
- The eventual Live $1 smoke test during go-live cutover

### Scope tiers (pick one as MVP, layer others later)

**Tier A — Paper walkthrough** (~60 min, docs only)
- New `docs/guides/stripe-dev-e2e.md` with prerequisite checklist, 11 numbered scenarios (see table below), expected DB state + verification query for each, screenshot checkpoints, troubleshooting table
- Test-card appendix (the 6 standard Stripe magic numbers: success `4242…`, decline `4000…0002`, insufficient funds `4000…9995`, 3DS-required `4000…3155`, dispute `4000…9979`, expired `4000…0069`)
- `stripe trigger` recipe appendix for CLI-synthesized events (dispute flow specifically)

**Tier B — Scripted orchestrator** (adds ~90 min on top of A, one new script)
- `scripts/dev-stripe-smoke.sh` automates the deterministic scenarios (direct-signed `checkout.session.completed` → verify DB → direct-signed `charge.refunded` → verify DB → etc.), leveraging existing `scripts/trigger-webhook.sh`. Manual UI-driven steps (real card payment, real onboarding) stay manual.

**Tier C — Playwright E2E suite** (~half-day, new test files)
- `tests/e2e/stripe-smoke.spec.ts` drives a real browser against `npm run dev:webhooks`. Stripe Checkout iframe interaction is the tricky part. Flagged as `describe.skip` in CI by default (requires live Stripe CLI auth) but runnable locally via `npm run test:e2e:stripe`.

**Tier D — Claude-MCP-driven interactive verification** (new idea surfaced Conv 145)
- Claude drives Chrome via the claude-in-chrome MCP bridge, starts `stripe listen` as a background process, walks through scenarios, produces a pass/fail report with screenshots. Not CI-grade; session-grade. Lets a human ask "verify scenario S6 still works" and get a report in ~5 minutes without writing or running test code themselves. Feasibility hinges on whether the MCP bridge handles Stripe's cross-origin iframes cleanly — unknown until tried.

### Scenarios to cover (minimum set, 11 rows)

| # | Scenario | Driver | Webhook(s) | DB effect to verify | Notes |
|---|---|---|---|---|---|
| 1 | Creator onboarding happy path | Browser + Stripe Express form | `account.updated` | `users.stripe_account_status='active'`, `stripe_payouts_enabled=1` | Requires completing Stripe Connect Express UI in Test mode |
| 2 | Enrollment, valid card | Browser + card `4242…` | `checkout.session.completed` → `transfer.created` (platform) | New rows in `enrollments`, `transactions`, `payment_splits` (2-3 per enrollment); course `student_count++` | Happy path — most common real flow |
| 3 | Enrollment, declined card | Browser + card `4000…0002` | None (Stripe declines before session completes) | No DB change | User sees error in Checkout UI |
| 4 | Enrollment, 3DS-required | Browser + card `4000…3155` | `checkout.session.completed` (after 3DS challenge) | Same as #2 | Exercises the 3DS flow real European traffic will use |
| 5 | Full refund | Admin UI | `charge.refunded` | `enrollments.status='cancelled'`, `transactions.status='refunded'`, `payment_splits.status='reversed'`; Stream unfollow | Admin-initiated from `/admin/payments` |
| 6 | Partial refund | Admin UI | `charge.refunded` | `transactions.status='partially_refunded'`, enrollment stays active | Admin 50% refund |
| 7 | Dispute created | Card `4000…9979` or `stripe trigger` | `charge.dispute.created` | `enrollments.status='disputed'`, `transactions.status='disputed'`, admin notification created | Duplicate-purchase [VD] guard also applies here — student stays disputed if they try to re-enroll |
| 8 | Dispute won | `stripe trigger charge.dispute.closed` | `charge.dispute.closed` (status=won) | Enrollment restored to `'enrolled'`, transaction `'completed'` | Requires CLI-synthesized event |
| 9 | Dispute lost | `stripe trigger` + Dashboard update | `charge.dispute.closed` (status=lost) | Enrollment cancelled, transfers reversed, admin notification | Exercises the full transfer-reversal path |
| 10 | Account status change → restricted | Sandbox Dashboard action | `account.updated` | `users.stripe_account_status='restricted'` | Disable payouts in Sandbox test-account settings |
| 11 | Self-healing path (webhook miss) | Browser + simulated webhook drop | — (no event) | `/api/stripe/verify-checkout` + success.astro SSR heal create the enrollment on success-page load | Verifies the Session 324 self-heal fallback still works; simulate by stopping `stripe listen` right before completing checkout, then restarting + visiting `/success` |

### Pre-requisites / preconditions this block needs

- [ ] Local D1 seeded with `db:setup:local:stripe` — produces at least one Creator with Test-mode `stripe_account_id`, at least one Teacher with a certification, at least one priced course (`price_cents > 0`)
- [ ] Stripe CLI authenticated to Test mode — `stripe login` into the default workbench, not Sandbox. CLI config currently in state verified Conv 145 [VL]
- [ ] `.dev.vars` holds Test-mode `sk_test_` / `pk_test_` + current `whsec_` from `stripe listen` (stable per-machine — changes only on re-auth)
- [ ] No second `stripe listen` process running (two tunnels compete for the same account's events)
- [ ] `/api/admin/stripe-mode` endpoint (Conv 145 [VA]) is available on Dev — trivially so, since it's in `src/pages/api/admin/` — for parallel diagnostic use during testing

### Open questions for Plan Mode

1. **Which tier is the right MVP?** Default recommendation: Tier A (paper walkthrough) — highest leverage per hour, foundation for the others, surfaces ambiguities a script would otherwise have to resolve. B and C and D can layer on.
2. **Does the Chrome MCP bridge handle Stripe Checkout iframes?** Answer is unknown until we try. If yes, Tier D becomes very attractive (Claude-driven rehearsals on demand). If no, fallback is `stripe trigger` for the webhook step with browser only for pre-checkout and post-success.
3. **Do we repeat the full matrix on Sandbox (staging) after Dev passes?** Conv 144 did scenarios S1–S7 on Sandbox; this block would add 4 more (onboarding, 3DS, partial refund, self-heal). Staging matrix should grow to match, but schedule (before each Stripe-touching PR? monthly? pre-go-live only?) is a Plan Mode question.
4. **Do we need a Dev counterpart to `/api/admin/stripe-mode` for webhook-secret verification?** An endpoint that returns the currently-loaded `STRIPE_WEBHOOK_SECRET` *hash* (not value) would let us verify `stripe listen`'s whsec matches `.dev.vars` without a diff on the filesystem. Marginal value; flag for discussion.
5. **Does Stripe Dashboard's Test-mode-into-Sandboxes-listing UI change (noted Conv 145 [VA] screenshot) require any doc updates before we write the walkthrough?** Probably a one-paragraph note in the Tier A prerequisites section, but worth verifying current state against the doc before writing.
6. **Is there value in adding `charge.succeeded` and `payment_intent.succeeded` to the coverage matrix?** Current handler doesn't subscribe to them (handler uses `checkout.session.completed` as the creation trigger), but Stripe fires them too. Plan Mode should decide: ignore, observe-only, or wire them up.
7. **Seed-data sensitivity:** the existing `stripe` seed (`migrations-dev/0002_seed_stripe.sql`) pre-fills `stripe_account_id` values for seed Creators. Are these real Test-mode `acct_...` that work against the current Test-mode workbench, or fake strings? If fake, #1 onboarding is the actual first step for every fresh Dev setup — which reshapes the walkthrough.

### Risks / unknowns flagged for Plan Mode

- 🟠 **Stripe Checkout iframe automation** untested with claude-in-chrome MCP — may force Tier D into a hybrid browser/CLI shape
- 🟠 **`stripe trigger`'s payloads are generic**, not tied to real charges — scenarios #8 and #9 may require Sandbox-side dispute-state manipulation to produce realistic test state
- 🟠 **Connected-account webhook testing** (e.g., `payout.failed`) needs `stripe listen --forward-connect-to` separately — either second tunnel or different URL routing. Currently deferred in `stripe.md` as "requires separate Connected-accounts webhook endpoint"
- 🟠 **Dispute-card `4000…9979` timing** — Stripe normally takes minutes to fire `charge.dispute.created` after a dispute card is used; the walkthrough should note the expected latency so scenarios don't look "stuck"
- 🟢 **Cost:** Test-mode charges are free — no real-money risk at any point

### Exit criteria

**Minimum (Tier A):**
- `docs/guides/stripe-dev-e2e.md` exists, covers all 11 scenarios, has been run end-to-end by at least one team member with pass notes attached
- Every scenario has a documented expected DB state + verification query + at least one screenshot

**Stretch (Tier B/C/D):**
- Tier B scripted orchestrator produces green for 5 consecutive runs across 2 days
- Tier C Playwright suite runs clean locally, `describe.skip` gate in CI documented
- Tier D: a Claude-driven interactive session successfully walks through ≥ 6 of 11 scenarios with screenshot trail

**Confidence signal:** after this block, the answer to "would we be comfortable doing the go-live $1 smoke test today?" shifts from "mostly, but we'd double-check things" to "yes — we have a rehearsal we've run end-to-end".

### References

- `docs/DECISIONS.md §8 Stripe Mode Discipline` — the env × mode mapping
- `docs/reference/stripe.md §Stripe Mode Discipline (CRITICAL)`, `§Per-Environment Webhook Configuration`, `§Connected Accounts Are Per-Mode AND Per-Environment`
- `docs/as-designed/webhook-miss-resilience.md` — Stripe events + Conv 144 live-verified S1–S7 scenarios (starting point for our 11-scenario matrix)
- `scripts/dev-webhooks.sh` + `scripts/trigger-webhook.sh` — existing Dev harness
- `scripts/check-env.sh` — Dev prerequisite validator (called by `dev-webhooks.sh`)
- `tests/api/webhooks/stripe.test.ts` — 18 unit tests; don't duplicate this coverage
- `src/pages/api/webhooks/stripe.ts` + `src/lib/enrollment.ts` — current handler entry points (post-Conv 145 [VD]/[VW])
- `src/pages/api/admin/stripe-mode.ts` (Conv 145 [VA]) — the mode-diagnostic endpoint to call during/before each scenario
- Conv 144 Extract + Conv 145 Extract — the integration-bug history this block is designed to prevent repeating

---

*Last Updated: 2026-05-25 Conv 194 — NAV-RETROFIT verification + cleanup (both Conv 193 PENDING items closed). **[MSP-COUPLING] RESOLVED by deletion** — `MoreSlidePanel.tsx` was dead code (superseded by `UserAccountDropdown`, zero consumers; every feature has a home — dark-mode/Help/Settings in UserAccountDropdown, Privacy in Footer); deleted file + barrel export + stale `AppLayout.astro` comment (incl. 256px→220px rail drift). **[LH-VERIFY] DONE** — both navbars visually verified in Chrome bridge (AppNavbar via Guy session: 220px rail @left:0, 0 dashed icons; AdminNavbar via Brian: 220px rail, 15 MattIcons, 0 dashed, 14 links, flat-list by design). **[MPB] FIXED** — AppNavbar slide-out panels (`DiscoverSlidePanel` + `UserAccountDropdown`) bled ~220px over content below `lg` (closed state was only occluded by the rail, not truly off-viewport); fixed with self-sufficient inline closed-transform `translateX(calc(-100% - 220px))` (viewport-independent, survives VT swaps). **[MATT-ICON-SWAP] DONE** (inline-SVG goal — target `CourseHeader.astro` no longer exists; live-hero→MattIcon residual folded into [MATT-EXEC-EXT]). **[CRS-MOBILE] DONE** (literal scope — course SubNav+tabs don't overflow at ~500–768px; deeper Matt-frame mobile work folded into [MATT-EXEC-EXT]). **NEW BUG [ADMIN-REDIRECT-BLANK]** (DEFERRED #22) — authenticated non-admin hitting `/admin/*` gets a blank 15-byte 200 instead of redirect to `/`; clean dev restart falsified the optimize-deps hypothesis; mechanism (why `AdminLayout` line 37 redirect ≠ line 34's clean 302) unexplained. **Learnings:** running the app at multiple widths+roles catches occlusion/redirect bugs static reading can't; hide states must be self-sufficiently off-viewport; falsify your own hypothesis before asserting a cause; a user's "wrong" symptom hypothesis can be the productive triangulation lead. **Code:** deleted `MoreSlidePanel.tsx`; edited `DiscoverSlidePanel.tsx`, `UserAccountDropdown.tsx`, `layout/index.ts`, `AppLayout.astro`. tsc + astro check clean (no full baseline run claimed — verification + targeted bug-fix conv). Branch `jfg-dev-13-matt`. Both NAV-RETROFIT and MATT-DESIGN-PUSH stay IN PROGRESS. Next major step (lead): investigate [ADMIN-REDIRECT-BLANK], MATT-DESIGN-PUSH Enroll/Session families, [MMP-PH5] roll-forward half, or [DISC-UNIFY].*

*Previously: 2026-05-25 Conv 192 — NAV-RETROFIT home-page spacing fixes + MATT-DESIGN-PUSH doc-infra split + /matt/courses index. **NAV-RETROFIT:** fixed the home footer (`Footer.astro` both variants) and dashboard main-panel icons (`index.astro` `h-12 w-12`→`h-[48px]`, was clipping 24px glyphs) by converting hijacked spacing-bridge utilities to arbitrary px in place; DOM-verified in Chrome bridge. **[LEGACY-SPACING-AUDIT] resolved (do-nothing-broad):** override hijacks 3,894 utilities / 354 legacy files vs only 11 matt files — user chose to leave the bridge and fix per-component as the legacy→Matt migration reaches each (mechanical sweep would be thrown away); reaffirms Conv 191 "don't revert". **MATT-DESIGN-PUSH [MDS-SPLIT]:** matt-design-system.md (1,717 lines) split into `docs/as-designed/matt-design-system/` folder (INDEX + 01–07; §5 split at Button into color-tokens + component-primitives); old path → stub with §N→file mapping; byte-for-byte lossless verified; `docs/INDEX.md` repointed; convention recorded in `DOC-DECISIONS.md` §2. [CH-DOCSYNC] confirmed already done (Conv 187). **[MATT-COURSES-INDEX]:** new `src/pages/matt/courses.astro` (approach B — thin Matt-native index reusing `fetchCourseBrowseData` + `CourseEmbedCard` grid; CTA already targets `/matt/course/[slug]`); fills the SubNav 404; DOM-verified 6 cards/6 CTAs. **1 new deferred:** [DISC-UNIFY] (migrate `/discover/courses` onto `fetchCourseBrowseData`; needs `primary_topic_id` added to loader). No baseline gate run claimed this conv (doc-split + thin page + spacing-utility swaps — gates carried unverified from Conv 191). Branch `jfg-dev-13-matt`. Both NAV-RETROFIT and MATT-DESIGN-PUSH stay IN PROGRESS. Next major step (lead): [NAV-ICON-SWAP] / [NAV-SIBLINGS], MATT-DESIGN-PUSH Enroll/Session families, or [DISC-UNIFY].*

*Previously: 2026-05-25 Conv 191 — NAV-RETROFIT block opened (demo-driven legacy→Matt incremental migration). **Conv 191 deliverables:** root cause of an app-wide spacing regression found ([DEMO-HOME]) — Conv 174's `tokens-tailwind-bridge.css` `@theme` `--spacing-*` block silently shrank every legacy spacing utility in {4,8,12,16,20,24,32,40,48,64} ~4× since Conv 174 (`w-64`→64px); strategy (user) = do NOT revert (would break `/matt`), migrate legacy ONTO Matt incrementally (approach B). AppNavbar step 1 restyled to Matt (220px width, `text-body-medium-bold`/12px `text-body-small`, brand-blue flat active, `size-[16px]` chevrons, both slideouts `left-[220px]`); bidirectional demo bridge (AppNavbar "New Design"→`/matt/`; Matt Sidebar "Classic App"→`/`, TEMP). 3 View-Transition regressions found+fixed via the / → New-Design → Classic-App round-trip, all DOM-verified not screenshot (island-unique arbitrary-utility drop; inline-`<script>` not re-running on VT → `astro:page-load`; duplicate-`style` JSX silently dropped). [MDET] global machine-detection fixed (detect-machine.sh → canonical MacMiniM4Pro, committed global `98cc4c4`); 5 small carry-forwards closed ([MEM-ICON-COUNT] 43 icons, [MDS-SHELL] doc sync, [VIDEO-COMMENT-ICN] chat→video-comment swap, [MATT-PROFILE-VERIFY] user-verified). New memory `feedback_dom_truth_over_screenshots.md`. **3 new deferred (under NAV-RETROFIT):** [NAV-ICON-SWAP] / [NAV-SIBLINGS] (AdminNavbar/AppHeader `w-64` + MoreSlidePanel `left-64`) / [LEGACY-SPACING-AUDIT]. **Blocker:** [MMP-PH5] promotion half is machine-pinned to MacMiniM4 (source `.scratch/` files never synced). All 5 gates green (test 6453 / build 6.43s); commits code `c5ad1b6`+`be462d5`, docs `377ac5c`+`ac3e2cb`. Branch `jfg-dev-13-matt` retained. NAV-RETROFIT stays IN PROGRESS. Next major step (lead): [NAV-ICON-SWAP] / [NAV-SIBLINGS] / [LEGACY-SPACING-AUDIT] sweep, or possible approach-A component swap; MATT-DESIGN-PUSH Enroll/Session families still open.*

*Previously: 2026-05-25 Conv 190 — MATT-DESIGN-PUSH active — MATT-EXEC-PG2 course-tab polish + Sidebar/shell rewrite to Matt's Layout Desktop. **Conv 190 deliverables (8 subtasks completed + 1 new deferred):** [COURSE-TAGS-LOADER] fixed (`course_tags` JOIN tags for real names) + [REVIEW-COUNT] fixed (header count → `reviews.length`); [SNV-ICONS] DONE — Matt-sourced course SubNav leading icons (About=`info` extrapolation); [RTCONS] route consolidation (Decision 1 — `index.astro` deleted, About folded into `[...tab].astro` empty-segment `'about'` view, shared `_course-tabs.ts` single SubNav-config source; surfaced by a browser-found duplicated `courseTabs` array); [MNV-STYLE] DONE — Sidebar emoji → MattIcon; [SBAR-STICKY] sidebar viewport-pinned; [MATT-COURSE-POLISH] SubNav sticky + design-system-wide letter-spacing token fix (Figma `-2.2` = `-0.022em`, was `-2.2px` ~6× too tight across 4 "Body larger sizes" tokens); [SBAR-REWRITE] (Decision 2, scope B) — shell `#f8fafc` grey page + floating white rounded content card + transparent sidebar, always-white active pill, `«` double-chevron collapse (`chevrons-left.svg` = 43rd icon), role-aware bottom Profile cluster via new `src/lib/roles.ts` `describeRoles` (hierarchy Admin>Creator>Teacher>Moderator>Student, Visitor fallback, Decision 3), Logo Small + MainNav gap-24. **4 decisions:** (1) consolidate the two course routes into one catch-all; (2) scope B rewrite Sidebar AND shell (grey page enables the active pill contrast); (3) `roles.ts` multi-role `describeRoles` + Visitor; (4) About SubNav icon = `info` (Peerloop extrapolation). **Key learning:** browser verification catches duplicated-source bugs static checks can't (the iconless About page exposed a second `courseTabs` copy). **Code:** `courses.ts` (tag JOIN), `[...tab].astro` (REVIEW-COUNT + About `'about'` segment + `buildCourseTabs`), NEW `_course-tabs.ts` / `src/lib/roles.ts` / `icons/svg/chevrons-left.svg`, `Sidebar.tsx` rewrite, `AppLayout.astro` shell, `MainNav.tsx`, `SubNav.astro`, `UserIcon.tsx`, `tokens-typography.css`, `route-map.generated.ts` (-index.astro). All 5 gates green (test 6453 pass / 371 files). **1 new deferred:** [PROF-ROW-VERIFY] (logged-in Profile row not yet visually verified — only Visitor confirmed). Branch `jfg-dev-13-matt` retained; dev server left running on 4321. Next major step (lead): Enroll family / Session family under [MATT-EXEC-PG2], or [MMP-PH5] graduation.*

*Previously: 2026-05-24 Conv 189 — MATT-DESIGN-PUSH active — MATT-EXEC-PG2 course-tab family COMPLETE (all 6 course sub-tabs built). **Conv 189 deliverables (4 subtasks completed + 3 new deferred):** [CRTTAB] CreatorTab built — identity/bio/3 stat chips from real loader data; the 4 no-schema sections (Expertise / Teaching Philosophy / Qualifications / Why-Learn) render Matt's verbatim copy as static grey via a `staticContent` prop, NO schema change per user directive (`CREATOR_STATIC` constants in route); cosmetic fixes (`leading-normal` line-height workaround → [LH-VERIFY] now has visible evidence, light-blue quote bg restored). [RVWTAB] ReviewsTab built reading the existing `course_reviews` table via a new loader query (rating/body/author/timestamp real; reaction pills static). [MODTAB] ModulesTab built 1 card per `course_curriculum` row (1:1 per [MOD-SCHEMA]; sub-count + posts pill omitted per user "omit both"). [FEEDTAB] Course Feed tab built `MattCourseFeed.tsx` client island on the existing `GET /api/feeds/course/[slug]` (same Stream-backed API as legacy `CourseFeed.tsx` — real posts, corrected an earlier "needs Stream integration" conclusion). Extracted `CourseEmbedCard.tsx` (shared embedded-course card; Reviews refactored to reuse). All six course sub-tabs now render in `[...tab].astro` (feed/modules/creator/teachers/reviews/resources). **3 decisions:** (1) CreatorTab unbacked sections = static grey, no schema; (2) Reviews+Feed use real data via existing tables/APIs; (3) Modules = 1 card per curriculum row, omit unbacked counts. **Key learning:** per-tab data strategy is only knowable after probing the actual schema/seed/API (4 tabs, 4 different verdicts; a one-size default would have been wrong 3 of 4 times). **Code:** `src/lib/ssr/loaders/courses.ts` (+`reviews` query), `[...tab].astro` (4 branches + `CREATOR_STATIC` + shared `courseEmbed` + viewer query); NEW `CreatorTab.astro` / `ReviewsTab.astro` / `ModulesTab.astro` / `MattCourseFeed.tsx` / `CourseEmbedCard.tsx`. **No doc authorship** (session bookkeeping only). **3 new deferred:** [CRS-MOBILE] (no mobile breakpoint on course SubNav+tab layout), [FEED-COMPOSER-USER] (logged-out composer "?" avatar), [COURSE-TAGS-LOADER] (latent `course_tags` SELECT * typing mismatch). All 5 gates green (test 6453 pass). Branch `jfg-dev-13-matt` retained. Next major step (lead): Enroll family / Session family under [MATT-EXEC-PG2], or [MMP-PH5] graduation.*

*Previously: 2026-05-24 Conv 188 — MATT-DESIGN-PUSH active — MMP-PH4.5 SubNav routing COMPLETE + course-tab family decomposed + [MOD-SCHEMA] + [ENTITY-CASCADE-BUG] resolved. **Conv 188 deliverables (5 subtasks completed + 4 new deferred):** [MATT-SUBNAV-ROUTING] COMPLETE — `/matt/course/[slug]/[...tab].astro` catch-all route (`VALID_TABS` = feed/modules/creator/teachers/reviews/resources, invalid → 302, shell + per-tab switch) + a latent `SubNav.astro` active-state bug fixed (startsWith-prefix → most-specific-match-wins; About no longer stays Selected on child tabs); routing demonstrated live in Chrome bridge across all 7 tabs, `matt-subnav-routing.gif` → `.scratch/screenshots/`. **[MATT-EXEC-PG2] course-tab family decomposed** (Decision Option A — per-tab `.astro` body components + `tab ===` switch, index.astro/About untouched, shell duplicated across the 2 route files): [RESTAB] ResourcesTab built (Matt's empty state; `folder.svg` harvested = 42nd Matt icon); [TCHTAB] TeachersTab built (bio-card composite reading live D1 via SSR loader; role-based entity palette `.entity-creator` purple / `.entity-student-teacher` blue; stat chips mapped to real loader data not Matt's demo); [CRTTAB] / [RVWTAB] / [MODTAB] remain pending; Enroll + Session families still under PG2 parent. Conv 188 triage corrected Ready-for-Dev lookup rows 3-8 (tabs are NEW card composites, not anchor-list shells; Matt frames are happy-path instance snapshots). **[MOD-SCHEMA] RESOLVED** — Session↔Module is 1:1; Matt's/creators' nested "Modules" = Sub-Modules (term misuse); no session→many-modules data model; saved to memory `project_module_submodule_model.md`. **[ENTITY-CASCADE-BUG] FIXED** — cascade-driven `--color-entity-primary/background` moved from plain `@theme` to `@theme inline` (plain `@theme` flattened `var(--Entity-*)` against `:root`, silently breaking EntityPill / EntityLink / UserIcon role colors app-wide); surfaced via opt-in `roleDot` prop on `UserIcon.tsx`. **3 decisions:** (1) PG2 course tabs = per-tab components, shell duplicated; (2) Modules model Session↔Module 1:1, Matt "Module"=Sub-Module; (3) role-color cue = opt-in corner role dot. **3 learnings:** Tailwind 4 `@theme` flattens cascade-driven tokens (use `@theme inline`); most-specific-match-wins for section-index nav active-state; Ready-for-Dev "expected primitives" are inferences, always probe the frame. **Code:** `SubNav.astro` (active-state fix), `UserIcon.tsx` (roleDot), `tokens-tailwind-bridge.css` (@theme inline), NEW `ResourcesTab.astro` / `TeachersTab.astro` / `[...tab].astro` / `icons/svg/folder.svg`. **Docs/scratch:** `matt-frames-ready-for-dev.md` rows 3-8 corrected; new `memory/project_module_submodule_model.md` + MEMORY.md pointer; `matt-subnav-routing.gif`. **4 new deferred:** [SHOWMORE] (Teachers+Reviews show-more), [SNV-ICONS] (course SubNav leading icons), [MNV-STYLE] (Sidebar emoji icons + type mismatch vs Matt Layouts), [MEM-ICON-COUNT] (MEMORY.md icon count stale → 42). Full baseline: build 6.30s clean; test 6453 passed / 371 files. Branch `jfg-dev-13-matt` retained. Next major step (lead): continue [MATT-EXEC-PG2] — wire remaining course tabs ([CRTTAB] / [RVWTAB] / [MODTAB]) and/or [MMP-PH5] graduation.*

*Previously: 2026-05-24 Conv 187 — MATT-DESIGN-PUSH active — MMP-PH4 re-render test COMPLETE + per-icon viewBox registry + CourseHeader re-validated to Matt's Default frame + addressability-first routing resolution. **Conv 187 deliverables (8 PLAN subtasks completed + 2 new deferred + 6 code/asset files touched across 2 commits):** [MMP-PH4] Course In Feed (`519:9096`) re-rendered as `CourseInFeed.tsx` (props-driven dark-hero card composing EntityPill + 4 on-dark IconLabelChips + course Button + MattIcon) — live-verified in Chrome bridge at 245px (matches Matt's instance exactly); the re-render gate surfaced the two assumptions it was designed to catch. [CMP-ICN-REGISTRY] RESOLVED = per-icon intrinsic viewBox in `MattIcon.tsx` (default 24×24) over rescale-via-transform — icons stored at native size, MattIcon now size-agnostic so future Material harvests at any grid "just work". [STARS2-ICN] + [ACCESSIBILITY-ICN] harvested from Figma asset URLs at native 20×20 (fills normalized to `currentColor`, mask rect `#D9D9D9`). [DARK-HERO-VARS] COMPLETE — `tone="default"|"on-dark"` prop on IconLabelChip applied to both heroes; **Button dark variant confirmed unneeded** (both heroes use light-bg pill CTAs). [MATT-IDX-AUDIT] 6 placeholder `<article>` cards → `<Card>`. [MATT-EXEC-FLAGS] RESOLVED on the addressability axis (user reframe): addressable = Course tabs, Enroll Success (Stripe success_url), Choose Teacher, Session (ONE state-driven `/session/[id]`), Home/Feed; non-addressable = Enroll pre-checkout, Session Scheduled, Home/Course Completed; file-count deferred to build. [GVD-SELFREE-VERIFY] + [MCP-SEL-MISFIRE] closed — `get_variable_defs` confirmed selection-free with explicit nodeId; "selection-required" tool class retired. **CourseHeader re-validated to Matt's Default frame `517:8935` (reverses Conv 184/185 creator trio):** `CourseHeader.astro` → `CourseHeader.tsx`; Matt shows all metadata as white on-dark IconLabelChips, NOT the UserIcon+EntityPill+EntityLink trio (which now belongs in the future Meet-the-Creator tab); user confirmed ("B" — keep the reversal). **3 decisions:** (1) icon registry absorbs non-24dp icons via per-icon viewBox; (2) CourseHeader re-validated to Matt's frame; (3) Matt-flow routes decided by addressability not page-count (saved as `feedback_routing_addressability_first.md`). **4 learnings:** all Figma read tools are selection-free with an explicit nodeId; master/instance is the recurring shape for Matt's hero frames (probe `get_metadata` on the section to enumerate variants first); addressability not page-count is the load-bearing routing decision; re-render-and-verify catches drift that building-from-spec misses. **Code commits:** `ead81ada` (CourseInFeed + per-icon viewBox + 2 SVGs + IconLabelChip on-dark + showcase), `cea3def0` (CourseHeader re-validation + 6 article→Card). **Docs commit:** `06d33a0` (`reference_figma_mcp_behavior.md` selection-required class retired; new `feedback_routing_addressability_first.md`; MEMORY.md index). **Scratch:** `.scratch/matt-frames-ready-for-dev.md` rows 31/32 resolved + Route Addressability section. **2 new deferred items:** [CH-DOCSYNC] (matt-design-system.md doc-sync — replace CourseHeader creator-trio docs with the IconLabelChip chip; routed to docs agent + TaskCreate), [CH-VARIANTS] (CourseHeader Enrolled `597:6504` + Scheduled `685:13240` variants — only Default built; sequence at MMP-PH5 enrolled-state pages). All 5 baseline gates green (tsc 0; astro check 0/0/0; build clean). Branch `jfg-dev-13-matt` retained. Next major step (lead): **[MMP-PH5]** Phase 5 graduation — promote scratch lookups to `docs/`, then roll forward to remaining `/matt/*` routes via MCP (now addressability-resolved as thin-shell assembly).*

*Previously: 2026-05-24 Conv 186 — MATT-DESIGN-PUSH active — Matt frames Ready-for-Dev drift lookup landed (32 rows across Components ✅ + Happy Path ✅ + Layout ✅) + Course SubNav routing pattern resolved + 3 redundant tasks deleted + 9 new deferred subtasks spawned. **Conv 186 deliverables (6 PLAN subtasks completed + 9 new deferred + 3 tasks deleted + 1 sub-assumption of [MATT-EXEC-FLAGS] resolved):** [SP-AUDIT] SocialPost subtree audit clean per `feedback_reuse_existing_components.md`; [ASSET-SWEEP] verified zero embedded Figma URLs in `src/`; [MFRD-DESIGN] drift-detection workflow designed (cheap status-banner probes for "Last Touched" comparison + deep probe on date mismatch + side-effect Material-icon harvest); [MFRD-SEED] `.scratch/matt-frames-ready-for-dev.md` populated with 32 rows + 3 completeness markers; [SUBNAV-PATTERN] resolved Course SubNav route shape — mirror `/discover/course/[slug]/[...tab].astro` (Astro rest-spread + VALID_TABS + path-based bookmarkable); [TASK-CLEANUP] deleted 3 redundant tasks ([CMP-EXT-ICN] / [MATT-CREATOR-TAB] / [MDR]). **4 strategic decisions:** (1) Matt Course SubNav routing = path-based `[...tab].astro` mirroring `/discover/course`; (2) Drift-detection lookup at `.scratch/matt-frames-ready-for-dev.md` (graduates to `docs/reference/` at MMP-PH5 or sooner); (3) Side-effect Material-icon discovery via drift-check workflow (replaces umbrella [CMP-EXT-ICN] with automatic mechanism); (4) `Parent Page` column added to lookup schema. **8 patterns/learnings established:** (1) Spatial banner-to-section derivation reliable on Matt's Figma (y=785 alignment); (2) Matt's "Last Touched" is the single drift signal (3 text nodes per banner, single `get_design_context` call); (3) `Home /` vs `Page /` prefix convention (variants vs standalone pages); (4) The lookup-driven discovery loop exposes architecture as side-effect of cataloging design state; (5) Matt's review passes are batched, not incremental (treat bulk-update patterns as one response unit); (6) Figma MCP `get_design_context` works without selection on remote MCP when explicit node-IDs supplied (contradicts Conv 180 memory entry — selection only required when probing the *currently-selected* node); (7) Name-collision drift catches: section-name vs banner-title (banner wins); (8) `ControlBar.tsx` purpose discovered retroactively via lookup row 14 (Session During). **Code changes:** None — purely doc/scratch work. **Docs changes:** None (RESUME-STATE.md deleted by /r-start). **Scratch changes:** NEW file `.scratch/matt-frames-ready-for-dev.md` (32-row lookup with schema, drift-check workflow, completeness markers, drift-check history). **Tasks created Conv 186 (9 new deferred):** [TXTBTN], [MATT-IDX-AUDIT], [STARS2-ICN], [ACCESSIBILITY-ICN], [HOWTOREG-ICN], [ASSET-SWEEP-GATE], [FIGMA-MCP-DOC-HARVEST], [MFRD-LOOKUP], [MATT-SUBNAV-ROUTING]. **Tasks deleted Conv 186 (3 redundant):** [CMP-EXT-ICN] (#10, superseded by 5 specific harvest tasks + drift-check side-effect rule); [MATT-CREATOR-TAB] (#16, replaced by [MATT-SUBNAV-ROUTING] — Creator is now one of 6 tabs in `VALID_TABS`); [MDR] (#19, placeholder completed by [MFRD-LOOKUP]). **[MATT-EXEC-FLAGS] sub-assumption (e) RESOLVED** (Matt Course SubNav = mirror `/discover/course/[slug]/[...tab].astro`); 6 of 7 sub-assumptions remain (expanded from 4 to 7: added (f) Enroll funnel route family, (g) Session lifecycle routes, (h) Home variant route shape). Branch `jfg-dev-13-matt` retained (no code changes this conv). Open question: Is `Hero Course in Feed` (502:12911) identical to `Course In Feed` (519:9096) or do they have subtle differences? Verify at MMP-PH4 kickoff. Next major step (lead): **[MMP-PH4]** Re-render Course In Feed (519:9096) + translate + visual diff — empirically buildable with full primitive vocabulary (and now with drift lookup as canonical reference for what's Ready-for-Dev).*

*Previously: 2026-05-24 Conv 185 — MATT-DESIGN-PUSH MMP-PH3 audit-driven follow-throughs — all 5 Q1/Q2 carry-forward items from Conv 184 audit COMPLETE in one conv. **Conv 185 deliverables (5 carry-forward items closed + 3 new deferred + 11 new code components + 6 SVG assets + 2 new subdirs + 1 memory file update):** User redirected from auto-recommended MMP-PH4 to the Conv 184 audit table; CC sequenced BRN → CHAT → C178-REVAL → CMP-ANCH-REST (build all Q1 NEW primitives FIRST so re-probes see full vocabulary, then audit, then largest batch last). **[MATT-EXEC-CMP-BRN] Brand primitive** — Logo (3 variants Large/Medium/Small) + LogoMark (3 variants Default/Medium/Small) from Matt's `40:481`/`1:270`/`35:144`. 4 SVGs downloaded via `curl` to discover Figma MCP asset URLs return SVG for vector sources (not raster PNG) — new MCP empirical finding captured in `reference_figma_mcp_behavior.md` + MEMORY.md. Fills normalized `var(--fill-0, #hex)` → `currentColor` via perl-pi. Refactored `Sidebar.tsx:85-91` from placeholder `∞ PeerLoop` text to Logo Medium (expanded) / LogoMark Default (collapsed). Playwright screenshot verified all 6 variants. **[CMP-CHAT] Chat Bubble primitive** — 2 variants Default/Us from `646:7540` (159×35; Matt drew pre-mirrored shapes rather than CSS transforms). `ChatBubble.tsx` with `property1: 'Default' | 'Us'` strict-B enum, currentColor tail with matching `text-*` class per variant. **Strict-B drift documented:** `inline-flex max-w-[280px]` content-sized default instead of Matt's 159px Figma placeholder (159px is drawing scaffold, not UX rule). **[C178-REVAL] re-validation** found significant Conv 178 drift in all 3 newly-probed: **Module** rewritten with 2 variants Default/Current matching Matt's `property1` enum (dropped over-engineered 4-color `entity` prop — Matt's "active" uses single hardcoded `--Primary-Light`), 220px width, Medium font weight, single title+duration line; **ToDoItem** rewritten with 20×20 rounded-[5px] checkbox (was 24×24 rounded-6), Medium font weights, 289px width, dropped `entity` prop, kept idiomatic `checked: boolean` API; **SectionTitle NAME COLLISION discovered** — Matt's "Section Title" is a Figma-internal dev-status banner (WIP orange/Dev Ready green/Archived red, 1280×96px, TT Norms Pro Mono font) — NOT a product component; our `SectionTitle.astro` is a generic content heading (Inter) — different purposes; documented but unchanged; **SocialPost** re-probe skipped (already validated Conv 184). Verified Module + ToDoItem are only used in `/matt/index.astro` showcase before refactoring (safe). **[REFACTOR-COURSEHEADER]** Creator section refactored to UserIcon + EntityPill + EntityLink trio in `.entity-creator` cascade; extended `CreatorRef` interface with optional `slug`/`initials`/`avatarUrl`; updated caller `/matt/course/[slug]/index.astro` to pass `data.creator.handle` + `data.creator.avatar_url`. **Caveat:** Rating/level/CTA stay inline because dark-hero contrast is incompatible with light-bg-optimized primitives (IconLabelChip uses `text-text-tertiary` gray; Button is light-bg-optimized). Spawned [DARK-HERO-VARS] for follow-up. **[CMP-ANCH-REST]** All 8 remaining anchor row components built in single batch: CreatorAnchor (entity-creator, "Learn More" CTA); CertificationAnchor (no pill, no CTA); ModuleAnchor (no pill, no CTA); ResourceAnchor (default Button "View"); ReviewAnchor (default Button "Read"); StudentTeacherAnchor (entity-student-teacher, pill "Suggested" — NOT "Student-Teacher" per Matt's text; "View Teacher" CTA); VideoClipAnchor (123×69 thumbnail with inline-SVG play-circle overlay; chat icon as substitute for `video_comment` pending [VIDEO-COMMENT-ICN]; "Watch" CTA); MilestoneAnchor (no pill, default Button "View"). Locks in Option C: 9 distinct anchor row components, no shared base. **All 13 of Matt's named Components-page primitives now built** — MMP-PH3 substantially complete; remaining gaps are Phase 6 extrapolation work. **4 strategic decisions:** (1) Sequence BRN → CHAT → C178-REVAL → CMP-ANCH-REST (composite ordering over smallest-first / audit-first / anchors-first); (2) ChatBubble drifts from Matt's 159px canvas placeholder (`inline-flex max-w-[280px]` default with optional className override); (3) Drop `entity` prop from Module + ToDoItem (strict-B match to Matt's 2 variants); (4) CourseHeader CTA + rating/level stay inline pending [DARK-HERO-VARS]. **5 patterns established:** (1) Figma MCP asset URLs preserve source format (vector → SVG with `fill="var(--fill-0, #hex)"`, raster → PNG); (2) pre-mirrored asset SVGs vs CSS-transform mirroring (Matt may draw each variant as separate pre-mirrored SVG); (3) Conv 178 reconnaissance over-engineered with `entity` prop on non-entity primitives (strict-B mirror is safer default); (4) Playwright fallback when Chrome MCP bridge is flaky; (5) design-system meta elements aren't always product primitives (Matt's SectionTitle = Figma-internal dev-status banner). **Code changes:** 11 new component files (Logo.tsx + LogoMark.tsx + ChatBubble.tsx + 8 anchor .tsx) + 6 SVG assets + 2 new subdirs `matt/brand/` + `matt/chat/`; Module.tsx + ToDoItem.tsx rewritten (113 → 113 lines and 84 → 84 lines respectively, dropping `entity` prop); Sidebar.tsx Brand integration (11 line delta); CourseHeader.astro creator-section refactor (36 line delta); `/matt/index.astro` showcase extended with 175 line delta (Brand 2 Cards + Chat 1 Card + 8 Anchor Cards + updated Module/ToDoItem callers). **Docs changes:** none (memory + extract only). **Memory changes:** `reference_figma_mcp_behavior.md` augmented with SVG-asset-format finding; MEMORY.md index line updated with Conv 185 reference + perl-normalize command. **3 new deferred items:** [DARK-HERO-VARS] (build dark-hero variants of IconLabelChip + Button so CourseHeader rating/level/CTA can be refactored); [VIDEO-COMMENT-ICN] (harvest Material icon — VideoClipAnchor uses `chat` as substitute); [PLAY-CIRCLE-ICN] (harvest Material icon — VideoClipAnchor uses inline-SVG placeholder). **Package changes:** Installed Playwright chromium browser (~250MB one-time via `npx playwright install chromium`) for programmatic screenshot verification — Chrome MCP extension disconnected mid-conv; `osascript` + `screencapture -x` kept grabbing desktop wallpaper. Persists in `~/Library/Caches/ms-playwright/`. Branch `jfg-dev-13-matt` retained. RESUME-STATE.md cleared at /r-start. Next major step (lead): **[MMP-PH4]** Re-render Course In Feed (519:9096) + translate + visual diff — now empirically buildable with full primitive vocabulary.*

*Previously: 2026-05-24 Conv 184 — MATT-DESIGN-PUSH MMP-PH3 continued — SubNav + Entity collection decomposition (Option C) + SocialPost full closure + new reuse standing rule. **Conv 184 deliverables (12 PLAN subtasks completed + 3 new deferred + 8 new code components + 1 new memory file + 6 .astro→.tsx conversions + 1 new entity-class alias):** [MATT-EXEC-CMP-SNV] COMPLETE — `SubNav.astro` rewritten with `currentPath`-derived active state (fixing latent Conv 175 silent bug); new `SubNavItem.astro` 3 Property 1 variants (Default/Hover/Selected) + Selected-with-subnav expanded conditional render. Resolved Conv 183 "Need 3+ Levels" open question via Figma probes (`502:12864` base + `622:18616` expanded) — NOT multi-level, it's base + Selected-expanded. User reframed Entities + Post Anchors as collections; Option C architecture locked in: **9 distinct anchor row components, no shared `AnchorRow` base** — Matt's component-naming convention is the load-bearing signal per `feedback_tokenize_only_matt_variables.md`, and heterogeneous data per anchor type resists clean abstraction. [CMP-UICN] / [CMP-EPILL] / [CMP-ELINK] / [CMP-CHIP] — 4 leaf primitives extracted from Entities decomposition; IconLabelChip is the deliberate strict-B deviation (Matt didn't name it; user "make these reusable" directive justifies; honest-orphan annotation in file header). [CMP-ANCH-COURSE] CourseAnchor first anchor row (composes UserIcon + EntityPill + IconLabelChip + Button + MattIcon). [CMP-ANALYTIC] AnalyticCount primitive extracted from SocialPost inline `ActionPill()` helper (2 variants Default/1+ auto-flip). [CMP-UICN-IMG] UserIcon extended with `avatarUrl?` strict-B extrapolation for production avatars; honest-orphan annotation in file header. [REFACTOR-SOCIALPOST] SocialPost.tsx + _SocialPostDemo.tsx fully refactored — removed inline Avatar / ActionPill / LikeIcon / CommentIcon constants; imports UserIcon + IconLabelChip + AnalyticCount + CourseAnchor (embed); flattened header to Matt's strict-B layout; replaced footer with 3 `<AnalyticCount>` instances + added `loves?` prop; removed avatar-preview commenters strip (Conv 175 extrapolation not in Matt's design). Breaking API: `roleIcon: ReactNode` → `roleIconName?: string`; removed `commenters` prop. **Astro/React boundary cascade forced full standardization on React (.tsx)** — SocialPost.tsx (React) needed to import Conv 184 primitives (built as .astro). React can't import Astro. Resolution: convert all 6 primitives + MattIcon to React (.tsx). Astro renders React as static HTML by default (no hydration cost unless `client:*` directive). Pattern: **primitives in React (broadest reusability), page-wrappers in Astro**. 6 .astro files deleted (MattIcon, UserIcon, EntityPill, EntityLink, IconLabelChip, CourseAnchor). `class` → `className` for React component props in Astro callers (SubNavItem, /matt/index.astro). **New standing rule:** `feedback_reuse_existing_components.md` codifies "scan `<instance>` children, import existing primitives, never inline duplicates" — surfaced by audit revealing SocialPost inlined Avatar/ActionPill AND CourseAnchor (built earlier same conv) inlined Button styling instead of importing Button.tsx. CourseAnchor refactored same conv to use Button.tsx + `class` → `className` fix; removed wrong "React-hydration-cost" justification comment. tokens-semantic.css `.entity-student-teacher` alias added (Conv 184 probe found Matt uses Student's colors for Student-Teacher). `/matt/` showcase extended with 6 new Card sections demonstrating each primitive across 4 entity contexts + 2 CourseAnchor instances + AnalyticCount showcase. **5 strategic decisions:** (1) Standardize Conv 184 primitives + MattIcon on React (.tsx) — design-system architectural rule resolving Astro/React boundary; (2) 9 distinct anchor row components, no shared `AnchorRow` base (Option C) — per Matt's component-naming convention; (3) Extract IconLabelChip despite Matt not naming it — user directive overrides strict tokenize-only-Matt rule, honest-orphan annotation marks deviation; (4) New standing rule scan `<instance>` children + import existing primitives — codified after dual-violation audit; (5) UserIcon image-mode pulled forward to Conv 184 — `avatarUrl?` with honest-extension annotation. **6 learnings:** (1) Figma `<instance>` nodes are the design system's import boundaries — every `<instance>` in metadata should map to an imported code component; gap surfaces as missing-primitive, not as inline duplicate "for now"; (2) Astro can import React but not the reverse — primitives consumed from both contexts must be React; (3) Strict-B mirroring catches silent bugs as a side-effect — Conv 175 SubNav `active?: boolean` per-item never consumed by either caller, latent for ~9 convs until Conv 184's Figma-grounded rewrite forced re-test; (4) Figma frame-name patterns are evidence even when not named as components — but Matt's component-naming convention is the load-bearing signal for "what should be a primitive in code"; (5) UserIcon is initials, not role-icon — visual inspection from inventory screenshots unreliable; probe via `get_design_context` before building; (6) Matt's `data-name` attribute IS the translation key for instance-named primitives — even when rendered as generic `<div>`, `data-name="User Icon"` / `data-name="Entity Pill"` / `data-name="Analytic Count"` identify reuse boundaries. **5 patterns established:** primitives in React + page-wrappers in Astro; scan `<instance>` children before rendering; `data-name` as canonical translation key; strict-B mirroring catches latent bugs; frame-name reuse vs Matt-named components. **Code changes:** 8 new React .tsx files (`MattIcon.tsx`, `UserIcon.tsx`, `EntityPill.tsx`, `EntityLink.tsx`, `IconLabelChip.tsx`, `CourseAnchor.tsx`, `AnalyticCount.tsx`, `SubNavItem.astro`) + SubNav.astro rewritten + 2 callers updated for currentPath + SocialPost.tsx + _SocialPostDemo.tsx refactored + tokens-semantic.css alias + /matt/index.astro Conv 184 showcase. 6 .astro files deleted (superseded). **Docs changes:** matt-design-system.md (5 new Conv 184 subsections); `.scratch/matt-figma-pages.md` 13 new probed-frames rows; `.scratch/conv-184-subnav-base.png` + `conv-184-subnav-with-subnav.png` (Figma screenshots). **Memory changes:** 1 new file `feedback_reuse_existing_components.md` + MEMORY.md index entry. **3 new deferred items:** [CMP-CHAT] (Chat Bubble primitive 2 variants from `646:7540`); [REFACTOR-COURSEHEADER] (165 lines zero imports — replace inline elements with UserIcon + EntityPill + EntityLink per new reuse rule); [CMP-ANCH-REST] (remaining 8 anchor rows). Baseline gates clean (tsc 0; astro check 1243 files 0/0/0; dev HTTP 200). DOM verified counts: 6 UserIcon + 8 EntityPill + 15 IconLabelChip + 7 AnalyticCount + 3 CourseAnchor + 1 SocialPost (math validates total elimination of inline duplication). Branch `jfg-dev-13-matt` retained as active. RESUME-STATE.md cleared at /r-start. Next major step (lead): MMP-PH3 continuation — [CMP-CHAT] (small/focused 2-variant), [REFACTOR-COURSEHEADER] (apply reuse rule retroactively), and 8 of 9 remaining anchor rows ([CMP-ANCH-REST]); plus optional visual screenshot-diff before MMP-PH4.*

*Previously: 2026-05-23 Conv 183 — MATT-DESIGN-PUSH MMP-PH3 Component primitives IN PROGRESS (2 of 7 landed: Button + MainNav). **Conv 183 deliverables (2 PLAN subtasks completed + 1 watch-task description updated + 0 new deferred + 3 new code components + 2 code refactors + 1 docs update + 1 new memory file):** [MATT-EXEC-CMP-BTN] COMPLETE — `Button.tsx` rewritten with **strict-B 5-value `property1` enum** (`Default | Hover | Large | Small | SmallHover`) mirroring Matt's Figma Property 1 exactly. **Major finding:** Conv 178's "3-orthogonal-dimension" architecture claim was WRONG — Property 1 conflates State AND Size (5 cells, not 3-orthogonal). All CSS extracted via MCP probes of 5 Figma nodes (`40:482` section + `1:284` Default + `513:14820` Hover + `1:292` Large + `360:11906` Small + `675:12314` SmallHover). 6 Color variants preserved; Hover/SmallHover use inline-style hardcoded gradient + border (Matt's design has partial coverage — Hover is Primary-only with no Variable Mode awareness; non-Primary + Hover combos render Primary-darkened, Phase 6 [MATT-EXEC-EXT] for variant-aware extrapolation). Disabled kept as standard a11y orphan via `[disabled]` CSS rule. `_SocialPostDemo.tsx` migrated `size="sm"` → `property1="Small"`. matt-design-system.md §5 Button rewritten with empirical variant matrix replacing Conv 178 framing. [MATT-EXEC-CMP-MNV] COMPLETE — 3 new React components: `MainNav.tsx` (props-driven orchestrator, exports `NavItemData`/`NavSubItemData` interfaces), `NavItem.tsx` (3 Property 1 variants: Default+Selected flat row, Main = white pill with parent + divider + Sub Nav slot), `NavSubItem.tsx` (2 Property 1 variants: Default+Selected, color shift only). Architecture decisions D1/D2/D3 made via **AskUserQuestion + ASCII mockup previews** (user pushed back on text-only descriptions; new pattern established): **D1 = Route-driven Main pill** (auto-positions around active section, derived state, no toggle), **D2 = Keep 70px collapse mode** as Peerloop extension (Sidebar renders separate icon-only nav when collapsed since 220px Matt layout doesn't compress gracefully), **D3 = Props-driven** data model. `Sidebar.tsx` refactored to consume `MainNav`; retains Peerloop shell (brand mark + Earnings/Notifications/Profile + collapse toggle). CSS extracted via MCP probes of 4 critical variants (`108:4614` Default NavItem, `150:8585` Main NavItem, `108:4615` Default NavSubItem, `110:5097` Selected NavSubItem). matt-design-system.md got new `### MainNav (3-variant composite primitive — extracted Conv 183)` subsection. [MCP-SEL-MISFIRE] description updated with Conv 183 positive observation: 8 successful `get_design_context` calls without user pre-selection in Figma desktop — contradicts Conv 180 `reference_figma_mcp_behavior.md` selection-REQUIRED claim. **7 strategic decisions:** (1) Button strict-B single `property1` prop mirroring Matt's 5-value enum exactly; (2) MainNav D1 = Route-driven Main pill (derived state, no toggle); (3) MainNav D2 = Keep 70px collapse as Peerloop extension (isolated to Sidebar shell); (4) MainNav D3 = Props-driven data model (enables Admin/Teacher variants); (5) Figma is READ-ONLY — never call write-shaped MCP tools (user directive saved as new memory file); (6) Hover styling for non-Primary variants defers to Phase 6 extrapolation (strict-B mirror); (7) Disabled state = standard a11y orphan via `[disabled]` CSS rule (NOT a 6th Property 1 value). **6 learnings:** (1) Empirical MCP probe trumps inferred architectural documentation — Conv 178 "3-orthogonal Button" was a logical projection without probing; [EMP] rule recurring (Conv 180: 4 reversals; Conv 183: +2 more); **probe THEN write the spec, never the inverse**; (2) Matt's "Main" pill is route-driven, not click-to-expand — active-detection rule: item enters `Main` if currentPath matches it OR any child AND it has children; no ▼/▶ toggle indicator in Matt's design; (3) ASCII mockups via AskUserQuestion `preview` field as decision aid — render Matt's Figma reference in ASCII as baseline + each candidate option as ASCII showing how it differs; side-by-side monospace comparison anchors decisions visually; (4) Matt's Hover variant is Primary-Variable-Mode-specific (partial coverage gap) — `var(--background)`/`var(--border)` indirection NOT used in Hover variant; non-Primary + Hover renders Primary-darkened regardless; per tokenize-only-matt-variables, mirror literally + flag gap in code comment for Phase 6; (5) `get_design_context` may not always require pre-selection — 8 successful calls across Conv 183 contradict Conv 180 canonical claim; multiple data points across multiple convs needed before updating memory; (6) ASCII Figma reference is reusable across decision rounds — invest 60s upfront to render Matt's source in ASCII; pays off across whole decision sequence; save in scratch alongside PNG screenshot. **3 patterns established:** doc graduation for component primitives (add formal `### <Component> (extracted Conv NNN)` subsection in matt-design-system.md with Figma node IDs + variant table + extracted CSS + component shape); ASCII baseline + AskUserQuestion previews for architectural decisions; per-state Variable-Mode-awareness check when porting multi-state × multi-color components. **Code changes (3 new + 2 refactor):** `src/components/matt/MainNav.tsx` (NEW), `src/components/matt/NavItem.tsx` (NEW), `src/components/matt/NavSubItem.tsx` (NEW), `src/components/matt/Sidebar.tsx` refactored to consume MainNav while retaining Peerloop shell, `src/components/matt/ui/Button.tsx` rewritten with strict-B 5-value `property1` enum (`_SocialPostDemo.tsx` migrated as sole caller). **Docs changes:** matt-design-system.md (§5 Button rewritten + new MainNav subsection); RESUME-STATE.md deleted by /r-start (23 outstanding tasks transferred to TodoWrite). **Scratch:** `.scratch/matt-figma-pages.md` enriched (Button + MainNav node rows + architecture-finding paragraph); `.scratch/conv-183-button-section.png` (NEW); `.scratch/conv-183-mainnav-section.png` (NEW). **Memory changes:** 1 new file `feedback_never_modify_figma.md` (Figma is read-only; never call write-shaped MCP tools) + MEMORY.md index entry under §Security & Secrets. Baseline gates clean (tsc 0; astro check 1236 files 0/0/0; dev HTTP 200). Branch `jfg-dev-13-matt` retained as active. Next major step (lead): MMP-PH3 continued — 5 of 7 component primitives remain ([-SNV] / [-ENT] / [-CHT] / [-PNC] / [-BRN]).*

*Previously: 2026-05-23 Conv 182 — MATT-DESIGN-PUSH MMP-PH2 Icon registry COMPLETE + 5 doc graduations + [CASCADE-BROKEN] closed. **Conv 182 deliverables (8 PLAN subtasks completed + 0 new deferred + 1 new code component + 1 new reference doc + 2 docs updated):** [MMP-PH2] / [MATT-EXEC-CMP-ICN] code-integration COMPLETE — 39 Matt SVGs ported `.scratch/matt-main/components/icons/` → `src/components/matt/icons/svg/`; Option B chosen (SVG-files-as-source-of-truth via Vite `?raw` glob, NOT path-extracted TS registry) per honest-orphan principle. `MattIcon.astro` consumer ~40 lines via `import.meta.glob<string>('./svg/*.svg', { query: '?raw', import: 'default', eager: true })` + outer-`<svg>` strip regex + dev-only warn + dashed-square missing-icon placeholder. Fill normalization `#414141`→`currentColor` (38 bulk via perl-pi + 1 outlier `info.svg` `#1C1B1F` MD3 on-surface caught by distinct-fill audit). Baseline gates green: astro check 1233 files 0/0/0; build 6.29s; lint clean. [MEM-IP-DRIFT] COMPLETE — MEMORY.md icon-paths entry count corrected 10 → 39 (5 directional + 4 nav + 4 people + 4 content + 16 objects + 3 community + 3 brand) — Conv 180 [MEM-DRIFT-ICN] claim was wrong, caught when re-counting during MMP-PH2. [MFE-STALE] COMPLETE — `.scratch/matt-figma-extraction-today.md` (12.4 KB Conv 178 planning doc for completed work) deleted; `matt-figma/` folder confirmed absent. [MDS-CASCADE-VALIDATED] COMPLETE — `matt-design-system.md` §5 Entity caveat updated with Conv 178 root-cause validation: cascade is NOT broken — Matt's button CSS uses `var(--Background)`/`var(--Border)` (variant-scoped), NOT `var(--Entity-Background)`/`var(--Entity-Primary)` (cascading). `[CASCADE-BROKEN]` closed; "until [CASCADE-BROKEN] resolves" framing retired. [MDS-BTN-3D] COMPLETE — `matt-design-system.md` §5 Button updated with 3-orthogonal-dimension architecture callout (Color 6 × State TBD × Size 5 ≈ 90-120 cells, NOT flat 6×3 = 18); `ButtonProps` shape updated with `size?` prop placeholder + State→pseudo-class mapping. [MATT-RT-DOC] COMPLETE — `matt-pre-plan.md` §2 Implementation status subsection added (2/13 routes built table + 11/13 pending list with phase-gate annotations). [MCP-DOC] COMPLETE — new canonical `docs/reference/figma-mcp.md` created consolidating `.scratch/figma-mcp-setup.md` + `memory/reference_figma_mcp_behavior.md` (Overview, Setup, Architecture, Two tool classes, Per-target output, Output characteristics, Seat tier, Workflow patterns, Implications, Fallback paths, Related). Scratch source deleted; memory file retained as recall-shorthand. **2 strategic decisions:** (1) Matt-namespaced icon registry uses SVG files as source of truth via Vite `?raw` glob (Option B) — aligned with tokenize-only-matt-variables / honest-orphan principle; re-exports drop straight into `svg/`; (2) [CASCADE-BROKEN] closed — Matt's button CSS uses variant-scoped variables (`--Background`/`--Border`), not entity-cascade — entity cascade was never wired into Matt's button design; shapes MMP-PH3 primitive variable-cluster pattern. **5 learnings:** (1) Hex fill audit BEFORE bulk-rewrite catches Material-Icons paint defaults — Direct Material Icons exports may carry `#1C1B1F` (MD3 on-surface); audit pattern: `for f in *.svg; do for fill in $(grep -oE 'fill="[^"]*"' "$f" | sort -u); do case "$fill" in 'fill="currentColor"'|'fill="#D9D9D9"'|'fill="none"') ;; *) echo "$f: $fill" ;; esac; done; done`; (2) Vite `import.meta.glob('./svg/*.svg', { query: '?raw', import: 'default', eager: true })` returns `Record<string, string>` (path → raw text) at build time — inline SVG icon registries with zero client JS; (3) Astro `interface Props` triggers ts(6196) "declared but never used" when Props isn't referenced through type composition — fix: add `Astro.props as Props` cast, OR keep an exported type that references Props; (4) Doc graduation flow: scratch (staging) → memory (recall-shorthand) → docs/reference (canonical) — memory stays after graduation as recall-shorthand; scratch source goes; cross-link memory at bottom of docs/reference under "Related"; trigger after 2-3 convs of empirical stabilization; (5) Figma MCP `get_variable_defs` is selection-bound — no MCP tool enumerates a file's full local Variable collection; workaround = visual-absence heuristic (if no layer uses red/pink, `--carmine-red` is effectively absent regardless of Variable existence). **4 patterns established:** distinct-fill audit before bulk-rewrite; Vite `?raw` glob for inline-SVG icon registries; Astro `Props` interface usage analysis fix; doc graduation flow (scratch → memory → docs/reference). **Code changes:** 1 new component (`src/components/matt/icons/MattIcon.astro` ~40 lines) + 39 new SVG files (`src/components/matt/icons/svg/*.svg`, fills normalized to `currentColor`). **Docs changes:** 1 new canonical doc (`docs/reference/figma-mcp.md`) + 2 updated (`matt-design-system.md`, `matt-pre-plan.md`). **Memory changes:** 1 MEMORY.md one-liner correction (icon-paths 10→39). **Scratch cleanup:** 2 files deleted (`.scratch/matt-figma-extraction-today.md`, `.scratch/figma-mcp-setup.md`); 1 graduation note added to `.scratch/matt-main/components/icons/_INDEX.md`. Baseline gates clean (astro check 1233 files 0/0/0; build 6.29s; lint clean). Branch `jfg-dev-13-matt` retained as active. Next major step (lead): MMP-PH3 Component primitives via MCP-driven extraction.*

*Previously: 2026-05-23 Conv 181 — MATT-DESIGN-PUSH MMP-PH0 Discovery + MMP-PH1 Token foundation both COMPLETE; new tokenize-only-matt-variables standing principle established. **Conv 181 deliverables (4 PLAN subtasks completed + 1 new standing principle + 3 file new/rewrites in code + 3 memory files updated):** [MMP-PH0] COMPLETE — routes audited (2/12 scaffolded); 14 components + 1 layout inventoried; 3-tier token cascade in place from Conv 172; PH4 re-render target = Course In Feed (519:9096). [MMP-PH1] / [TSV] COMPLETE — 12 Color + 18 Typography Variables canonized via `get_variable_defs` direct probes; new `src/styles/tokens-typography.css` (124 lines, two leading regimes Body-small lh:1 / Body-large lh:1.5 ls:-2.2px / Headers lh:1 ls:0); bridge typography section rewritten with all 18 Tailwind 4 `--text-{name}--<modifier>` utility classes; false naming-drift alarm corrected (`Primary/Default` is Variable; "Primary/Primary" was plugin label artifact); Variable Mode validated (Course context → Primary resolves to #327D00). 6 speculative Conv 172 alert tokens isolated to dedicated "Speculative (Conv 172)" sub-blocks across 3 files (kept + flagged, not removed). [NOTE-YELLOW] COMPLETE — resolved by hardcoding inline NOT new token (probe revealed Matt's `#FFF6B8` is hardcoded hex, not a Variable); Note.tsx all 7 drifts fixed (yellow hex, border, radius 12→8, padding 16→10, gap 8→10, shadow, removed leading-relaxed since text-body-default now carries lh:1). [MCP-DRIFT-180] COMPLETE — `memory/reference_figma_mcp_behavior.md` rewritten 56→75 lines: two tool classes (selection-free vs selection-required), return-shape doc, invisible-local-Variables caveat, batch-probing pattern, plugin-rendered-labels-NOT-authoritative warning. **NEW STANDING PRINCIPLE:** `memory/feedback_tokenize_only_matt_variables.md` (50 lines) — token-ify what Matt has tokenized; hardcode what Matt has hardcoded; scaffold what Matt hasn't categorized. Honest-orphan rule: hardcoded values self-deprecate visibly; named tokens accumulate stale meaning silently. Conv 172 speculative pattern retroactively recognized as anti-pattern (preserved per Decision 1 above but not extended). MEMORY.md one-liner added under Solution Quality section. **6 learnings:** (1) Figma MCP has two tool classes — selection-free `get_metadata`/`get_libraries`/`search_design_system`/`get_screenshot` vs selection-required `get_design_context`/`get_variable_defs` (passed nodeId must match selected node exactly — passing parent or sibling fails); (2) plugin-rendered visualizations NOT authoritative for Variable names — Matt's Color Guide plugin renders "Primary/Primary" for actual `Primary/Default` Variable; source-of-truth ordering = get_variable_defs → get_design_context → get_metadata; (3) local-file Variables invisible to library-scoped MCP tools — `get_libraries` returns only subscribed external libs; existence only verifiable by finding a consuming node; defined-but-unused Variables completely invisible; (4) honest-orphan principle for token systems — hardcoded `#FFF6B8` in Note.tsx is honest if Matt changes it; `--note-yellow` token implies systematization Matt has not made and lies until updated; (5) Variable Mode observable at Variable layer via MCP — probing get_variable_defs on a node inside Course-context container returns Course-mode resolved values; same Variable consumed in different context resolves differently; (6) Tailwind 4 `--text-{name}--<modifier>` syntax consolidates typography — single utility class carries size + weight + line-height + letter-spacing via modifier-suffix in `@theme`. **3 strategic decisions:** (1) Speculative alert tokens kept + isolated to "Speculative (Conv 172)" sub-blocks (provenance comment, callsites unchanged) — Option B; (2) [NOTE-YELLOW] hardcoded inline NOT new token — probe revealed honest-orphan applies; (3) tokenize-only-matt-variables established as standing principle in memory (not just Note-specific decision). **5 patterns established:** two tool classes; efficient batch-probing via container selection; plugin-rendered visualizations NOT authoritative; local-file Variables invisible to library tools; Tailwind 4 modifier-suffix consolidation. **Code changes:** 4 files modified (`Note.tsx` 35 lines / `tokens-primitives.css` 24 / `tokens-semantic.css` 11 / `tokens-tailwind-bridge.css` 137) + 1 new file (`tokens-typography.css` 124 lines). **Memory changes:** 1 new file (`feedback_tokenize_only_matt_variables.md` 50 lines), 1 rewrite (`reference_figma_mcp_behavior.md` 56→75 lines), 2 MEMORY.md one-liner updates. Baseline gates clean (tsc + astro check 1232 files 0/0/0). Branch `jfg-dev-13-matt` retained as active. Next major step (lead): MMP-PH2 Icon registry (port 39 SVGs from `.scratch/matt-main/components/icons/` + Material icon strategy [CMP-EXT-ICN] = A).*

*Previously: 2026-05-23 Conv 180 — MATT-DESIGN-PUSH Figma MCP fully activated; Phase 4.5 reframed as 6-phase MMP mini-plan; 2 component-strategy decisions resolved. **Conv 180 deliverables (3 PLAN subtasks completed + 1 decision-task closed + 8 new deferred + MMP mini-plan spawned):** [MCP-VERIFY] COMPLETE — user did OAuth before /r-start (saving session bounce); `claude mcp list` confirms `figma: ✓ Connected`; 10+ `mcp__figma__*` tools surfaced via ToolSearch; `whoami` confirms user has Dev seat on Peerloop org pro tier (no Brian action needed). [MEM-DRIFT-ICN] COMPLETE — MEMORY.md "Icon System" line corrected: `~35 entries` → `10 entries verified Conv 180; Matt-namespaced ~45-entry parallel registry pending from MMP-PH2`. [MFP] COMPLETE — `.scratch/matt-figma-pages.md` stores 9 page URLs + node-ids + Conv 180 probe history (Components 1:269, Color Guide 1:16, α1 Happy Path 477:8493, Happy Path Home 477:8502); Content page marked 🚫 OUT OF SCOPE per user (Matt's initial value-prop exploration, not implementation). [CMP-VAR-PROMOTE-DECISION] CLOSED = A (flat icons, 9 variant entries). **2 strategic decisions captured:** [CMP-ICN-REGISTRY] = D (deferred to MMP-PH4 empirical re-render test — inferential debate without empirical signal; if MMP-PH2 must make interim choice, default to B Matt-namespaced as least irreversible); [CMP-EXT-ICN] = A (incremental Material icon harvest from MCP as Phase 5 encounters each — `stars_2`/`accessibility_new`/`how_to_reg` confirmed in Happy Path probe). **6-phase MMP mini-plan spawned** to bridge from MCP unlock to reproducible single-page MCP-driven re-render workflow before resuming bulk work: MMP-PH0 Discovery → MMP-PH1 Token foundation (unblocked by [MFP]) → MMP-PH2 Icon registry → MMP-PH3 Component primitives → MMP-PH4 Re-render test → MMP-PH5 Graduation. **6 learnings:** (1) Figma Remote MCP is link-based by design — don't enumerate; `get_metadata(fileKey)` returns only currently-scoped pages (got 2 of 9 in this conv); ANY node-id can be queried directly via user-supplied URLs (invisible-but-accessible pattern); ask user for URLs upfront via `.scratch/<project>-figma-pages.md`; (2) `get_design_context` output shape varies by node type — section nodes return sparse + drill instruction (no code), component variant nodes return typed React with inferred props (best for primitive building), page/card nodes return inlined HTML+CSS with `data-name` attributes (visual layouts); (3) Translation is mandatory — icons as `<img>` with expiring asset URLs (7d signed S3 links), components inlined as raw markup, MCP itself warns to convert to project's stack — registry-key naming DECOUPLED from MCP output; `data-name` IS the translation key; (4) Variable Mode bakes into CSS-var fallback hex — same `var(--background, …)` reference has different fallback per parent context (Course=#e8f4df green; Auto Primary=#0777b6 blue); codebase needs Variable Mode switching (likely `[data-variable-mode="course"]` selector pattern); (5) Verify external tool behavior empirically before recommending — 4+ recommendations this conv all reversed by next probe; one tool call beats one rework cycle; captured as [EMP] context in `feedback_external_source_of_truth_first.md`; (6) Matt's "Ready for Dev" labels are human-visible green banners NOT Figma's built-in flag — not API-detectable; ask designer or visually scan. **3 new memory files:** `reference_figma_mcp_behavior.md` (architecture + per-tool output + asset URLs + Variable Mode + data-name + Dev seat scope, ~85 lines); `project_matt_collaboration_style.md` (Matt thinks in Figma at all times — docs, notes, exploration); `feedback_external_source_of_truth_first.md` extended with 4th [EMP] context. **New deferred items:** [CMP-EXT-ICN] (Material icons incremental harvest); [MDR] (Dev-Ready frames lookup, user will supply later at `.scratch/matt-figma-dev-ready.md`); MMP-PH0..PH5 (6-phase mini-plan with dependency chain). **No code changes Conv 180** (entire conv was MCP-onboarding + planning); baseline gates not re-run. Branch `jfg-dev-13-matt` retained as active. Next major step (lead): MMP-PH0 Discovery sweep + MMP-PH1 Token foundation against Color Guide (1:16); resolves [TSV] task in same probe.*

*Previously: 2026-05-23 Conv 179 — MATT-DESIGN-PUSH [MCP-SETUP-WALK] lead-task advanced; Figma remote MCP server registered. **Conv 179 deliverables (2 PLAN subtasks completed + 1 superseded + 1 in-progress + 4 new deferred):** [MCP-INSTALL] COMPLETE — selected Figma's **remote** MCP server (`https://mcp.figma.com/mcp`) per vendor's documented recommendation (mid-conv pivot from original local-MCP plan after user surfaced live docs at `developers.figma.com/docs/figma-mcp-server/`). [MCP-CONFIG] COMPLETE — executed `claude mcp add --transport http figma https://mcp.figma.com/mcp`; registered in `~/.claude.json` project-scoped to peerloop-docs; `claude mcp list` confirms "Needs authentication" status. [MCP-TOKEN] superseded for primary path — remote MCP uses OAuth, no PAT required (retained as conditional fallback). [MCP-SETUP-WALK] in_progress — v2 walkthrough doc rewritten at `.scratch/figma-mcp-setup.md` (no Figma desktop or Dev seat required); OAuth flow deferred to Conv 180 since CC loads MCP server list once at session start (`/r-end` → exit → `/r-start` bridge required). [MCP-VERIFY] pending Conv 180. **TodoWrite triage 54 → 28 (47% reduction):** non-Matt/non-MCP tasks moved to PLAN.md respective blocks where they belonged; 4 "save memory" tasks (MFM Matt-catalogue extraction + STOR source-of-truth + DTU defer-to-user-supplied + VDF vendor-docs-first) consolidated into 1 file `feedback_external_source_of_truth_first.md` with 3 named contexts and distinctive code-markers preserved in MEMORY.md index for grep recall. **3 strategic decisions:** (1) Figma MCP path = Remote over Local — Figma's own docs recommend it; one-command setup vs multi-step; OAuth account-identity sidesteps Conv 169's Dev-seat blocker; works on any machine via re-running `claude mcp add` + re-auth; (2) MCP config scope = project-scoped via `.claude.json` project key — `claude mcp add` defaults to writing to user-level `~/.claude.json` but tags entries with `[project: <cwd>]` (matches original B1 intent without manual settings.json edit); each machine needs its own setup since `.claude.json` is per-machine; (3) Memory consolidation = 4 captures → 1 file with named contexts — MEMORY.md index is the bottleneck (200-line cap), not per-file count; distinctive markers preserved grep-anchored discoverability. **5 learnings:** (1) Vendor-docs-first for MCP/SDK/CLI install walkthroughs — training knowledge for vendor MCP/SDK/CLI integration is months stale (cutoff January 2026; today 2026-05-23); `WebFetch` vendor's current docs before drafting; (2) CC's MCP server list loads once at session start — `claude mcp add` writes to `~/.claude.json` but doesn't hot-reload into running session; opening another terminal doesn't help (per-process); plan MCP setup around `/r-end` → exit → `/r-start` bridge; (3) `.claude.json` MCP entries are project-scoped automatically — `claude mcp add` tags entries with `[project: <cwd>]` so MCP activates only when CC is launched from that directory; user-level file location, project-level activation; (4) TodoWrite ↔ PLAN.md hygiene threshold — when TodoWrite accumulates past ~30 tasks and many belong to inactive Blocks, move to PLAN.md; TodoWrite is conv's working set, PLAN.md is cross-conv canonical home; (5) Memory consolidation when multiple captures point at one pattern — consolidate into one file with N named contexts; expose all original code markers in MEMORY.md index for grep recall (1 rule, 1 file, multiple grep-anchored entry points). **4 new deferred Conv 179 items spawned:** [ASF] (Astro.slots.has + && short-circuit investigation surfaced Conv 175 [MSH-VIZ]); [TDS-DRIFT] (tech-doc-sweep didn't fire on matt/* additions across Convs 173-178 — baseline SHA or matchers stale); [MEM-CAP] (watch /r-prune-claude trigger at ≥80% utilization; Conv 179 baseline 59%/57%); [INV-PATH-FIX] (sweep `.scratch/matt-figma/` references → `.scratch/matt-main/`). **No code changes Conv 179** (entire conv was infra + docs + planning); baseline gates not re-run. Branch `jfg-dev-13-matt` retained as active. RESUME-STATE.md cleared at /r-start (53 pending items transferred to TodoWrite; +1 [VDF] added = 54; triaged down to 28). Next major step (lead): Conv 180 — `/mcp` → figma → Authenticate → browser Allow Access → ToolSearch verify Figma MCP tools surfaced; then resume `[CMP-ICN-REGISTRY]` decision + Phase 4.5 remaining 7 subtasks via MCP.*

*Previously: 2026-05-23 Conv 178 — MATT-DESIGN-PUSH Phase 4.5 [MATT-EXEC-CMP] scoped + [MATT-EXEC-CMP-ICN] harvest phase complete. **Conv 178 deliverables (1 PLAN block scoped + 1 harvest-phase subtask complete + 7 new deferred):** Phase 4.5 inserted between Phase 4 and Phase 5 with 8 dependency-ordered subtasks (CMP-ICN → CMP-BTN → CMP-MNV → CMP-SNV → CMP-ENT → CMP-CHT → CMP-PNC → CMP-BRN); `matt-pre-plan.md` §9 row added; total convs estimate revised 8–11 → 10–15. **[MATT-EXEC-CMP-ICN] harvest phase COMPLETE:** 39 icons extracted from Figma into `.scratch/matt-main/components/icons/` with uniform `viewBox="0 0 24 24"` (Figma export `Include bounding box ✅` setting was load-bearing); 19 renames executed with 3 semantic corrections from Matt's catalogue (newspaper→feed, mail→message, calendar_month→calendar, chat_bubble→chat, present_to_all→present, Vector.svg→user-icon); Property-1 Component variants flattened to Arrow/Level/Bookmark groups per Matt's catalogue labels; `_INDEX.md` written documenting catalogue-label-is-authority rule + Primary (8) + Secondary (31) sections. Code-integration deferred — 2 new subtasks [CMP-ICN-REGISTRY] + [CMP-VAR-PROMOTE-DECISION] capture registry-strategy + variant-promotion decisions. Buttons reconnaissance discovered 3-orthogonal-dimension Figma architecture (Color via Variable Mode × State via Property 1 × Size via 5 frame cells, NOT flat 6×3 matrix); Matt's button CSS uses `var(--Background)`/`var(--Border)` — validates [CASCADE-BROKEN] as implementation issue. **Mid-conv pivot:** project moved to client's Pro Figma account; confirmed via ToolSearch no Figma MCP connected this conv; ended conv to set up MCP off-conv and /r-start fresh. **5 strategic decisions:** (1) insert Phase 4.5 between Phase 4 and Phase 5 (preserve Phase 5 as pure thin-shell assembly); (2) dependency-ordered CMP subtasks with Icons foundational; (3) catalogue-label-is-authority for naming (overrides Figma auto-export filenames AND visual-inference guesses); (4) default-durable full 8-subtask harvest over icon-only narrow scope; (5) end Conv 178 + MCP setup between convs + /r-start fresh. **7 learnings:** (1) `.scratch/matt-main/*.svg` are CC-instructed Figma exports treated as reference-only; (2) Figma exports use source Material-Icon names not catalogue labels; (3) Figma "Include bounding box ✅" gives uniform viewBox — load-bearing for icon systems; (4) Matt's button architecture is 3-orthogonal-dimension not flat matrix; (5) Matt's button CSS uses `var(--Background)`/`var(--Border)` — cascade IS the intended pattern; (6) MCP servers load at session start — mid-conv configuration has no effect; (7) "harvest while access is available" time-bounded resource pattern. **4 patterns established:** Figma `Include bounding box ✅` default-ON for icon batches; 3-orthogonal-dimension factoring for Figma Component extraction; Phase X.5 numbering for inserting between locked phases; MCP load is session-boundary affair. **7 new deferred subtasks spawned:** [MCP-SETUP-WALK] **🔝 LEAD NEXT-CONV ITEM** (composite umbrella for MCP setup); [MCP-INSTALL] / [MCP-TOKEN] / [MCP-CONFIG] / [MCP-VERIFY] (component sub-tasks); [CMP-ICN-REGISTRY] (registry-strategy decision blocking rest of Phase 4.5); [CMP-VAR-PROMOTE-DECISION] (Arrow/Level/Bookmark variant-promotion decision). **[MATT-MCP-RETRY] superseded** by [MCP-SETUP-WALK] — Pro account now exists, new blocker is MCP server install + token + settings.json config. No code changes Conv 178; baseline gates not re-run (docs + scratch only). Next major step: [MCP-SETUP-WALK] walkthrough; then resume Phase 4.5 via MCP (CMP-ICN-REGISTRY decision + remaining 7 subtasks).*

*Previously: 2026-05-23 Conv 177 — MATT-DESIGN-PUSH unblocked: Astro stack upgrade + Vite SSR cold-start root cause + fix. **Conv 177 deliverables (2 PLAN items completed + 0 new deferred):** [NPM-UP] COMPLETE — astro 6.1.5→6.3.7, @astrojs/cloudflare 13.1.8→13.5.4, @astrojs/react 5.0.3→5.0.5, wrangler 4.81.1→4.94.0 (initial install hit ERESOLVE forcing wrangler addition; per Solution Quality default-durable). Canonical Vite dedupe/noExternal workaround attempted but FAILED — same cold-start Sidebar.tsx crash. [DSSR-SCOPE] COMPLETE — real root cause found via web research: Vite cold-start dep-discovery race (industry-wide pattern: Remix #10156, TanStack/router #4264, Storybook #32049, vitejs/vite #17979). First SSR request triggers Vite to find new imports → re-optimize `node_modules/.vite/deps_ssr/` → reload bundled React → in-flight render crashes with null hooks dispatcher → response body cut off mid-attribute. **Working fix:** `astro.config.mjs` `vite.optimizeDeps.entries: ['src/**/*.tsx', 'src/**/*.ts', 'src/**/*.astro']` + `include: ['astro/virtual-modules/transitions.js']` (entries alone insufficient — Astro virtual modules aren't reachable from scanning src/). Verified: cold-start /matt/ succeeds first request (240839 bytes, all primitives rendered, `</html>` closed, 0 ERROR lines); production build clean in 7.27s; preview /matt/ 30564 bytes, all 13 primitives present. **Cleanup sweep:** Conv 176 stateless-primitives discipline RETIRED from DEVELOPMENT-GUIDE.md; new "Vite SSR Cold-Start Dep Discovery" section documents the real bug class + fix recipe + symptom signature. ToDoItem.tsx rewritten as controlled-or-uncontrolled hybrid (proper React idiom). [AAP] re-tested against Astro 6.3.7 — still broken upstream. DEV-STAGING-SSR ON-HOLD row marked ✅ RESOLVED. **Astro warnings cleanup:** HeaderBar.astro Props cast fix (silences ts6196), CourseHeader.astro dead Button import removed; astro check 0/0/0 clean. **Side fixes:** api-test-helper.ts logger no-op stub (Astro 6.3 APIContext addition), Sidebar.tsx flex-shrink-0→shrink-0 (Tailwind v3→v4 rename, caught by /w-codecheck). **/w-codecheck all 8 PASS.** **4 strategic decisions:** (1) pair wrangler upgrade with Astro stack (avoid `--legacy-peer-deps`); (2) retire stateless-primitives discipline; (3) ToDoItem hybrid pattern; (4) don't downgrade React 19→18.2 (Vite cold-start affects React 18 too). **4 learnings:** (1) Vite cold-start dep discovery is documented industry-wide pattern — when SSR hook crashes self-heal on 2nd request, it's this class (different fix than dual React copies); (2) diagnosis can survive long because misleading symptoms cluster — "AppNavbar works but Sidebar crashes" mystery survived 3 convs because cold-start cache state masked request-order dependence; (3) `optimizeDeps.entries` recipe doesn't reach Astro virtual modules (needs `include` for each virtual module the dev log mentions in `✨ new dependencies optimized`); (4) Astro 6.3 added `logger` field to APIContext (TestAPIContext helper needs no-op stub). **3 patterns established:** diagnostic checklist for SSR hook crashes (cold-start race vs dual React vs config); Astro virtual module pre-bundling rule; cheap order-dependence probes falsify "structural" diagnoses. Branch `jfg-dev-13-matt` retained as active. RESUME-STATE.md cleared at /r-start (33 pending items transferred to TodoWrite). Next major step: `[MATT-EXEC-PG2]` Phase 5 routes (12 remaining /matt/* pages).*

*Previously: 2026-05-22 Conv 176 — MATT-DESIGN-PUSH advanced through Phase 4 scope B (the remaining 5 primitives) on `jfg-dev-13-matt`. **Conv 176 deliverables (1 major PLAN item + 4 new deferred + 1 task put ON HOLD):** [MATT-EXEC-PRM-2] Phase 4 scope B complete — 5 primitives + 1 internal demo wrapper: `Module.tsx` / `Note.tsx` / `ToDoItem.tsx` (refactored fully controlled, no `useState`) / `SocialPost.tsx` / `RoleTabBar.tsx` + `_SocialPostDemo.tsx` (internal underscore-prefixed React wrapper hosting Course-minicard embed JSX). `/matt/index.astro` extended with Phase 4 Primitives showcase section. 4 symlinks under `public/_matt-ref/` (Module/Note/SocialPost/ToDoItem.svg) for visual-diff against Matt's Figma exports. **Two Astro-Cloudflare landmines hit + worked around:** (1) `useState` in a primitive crashed plain-dev SSR body (Sidebar.tsx cascade) — not just `dev:staging` as PLAN [DEV-STAGING-SSR] documented; refactored ToDoItem to fully controlled; (2) inline JSX (`<div className=…>` and `<svg viewBox=…>`) in `.astro` expression blocks parser-rejected as documented Astro behavior — extraction-to-`_Demo.tsx` pattern established. **Visual review feedback addressed:** entity-background rendered grey not blue → root-caused as `.entity-*` cascade NOT propagating through Tailwind 4 `bg-entity-background` empirically; refactored Module + ToDoItem to direct `bg-{course,student,creator}-background` utilities matching `Button.tsx` pattern. SocialPost Course-minicard embed added via `_SocialPostDemo.tsx` extraction (inline `<div>` not supported in `.astro` expression blocks). **Web research conducted** on the two landmines: Astro #16529 still open on versions newer than ours (6.2.0 + adapter 13.3.0); `@astrojs/cloudflare 13.5.4` added optimizeDeps-forwarding-to-SSR which is the plausible missing piece that made Conv 122's earlier dedupe attempt fail. Final verification: HTTP 200, body 33,648 chars, all 5 primitives + 1 social-post-embed render, 4× `bg-student-background` / 3× `bg-course-background` / 2× `bg-creator-background` in HTML, tsc clean, astro check clean (0/0/2 pre-existing hints). **3 patterns established:** (1) `qlmanage -t -s 1200 -o /tmp file.svg` SVG→PNG visual inspection for Read-tool consumption; (2) `_Demo.tsx` extraction for rich JSX showcase content (avoids Astro expression-block JSX restrictions); (3) stateless matt/* primitives discipline (no `useState` / `useEffect` in primitives until `[DSSR-SCOPE]` resolves). **4 new deferred subtasks spawned:** `[DSSR-SCOPE]` task #26 — update PLAN's DEV-STAGING-SSR scope claim (also affects plain `npm run dev`, symptom is body cutoff not graceful island fallback); `[NOTE-YELLOW]` task #27 — add `--note-yellow: #FFF1B8` token; `[CASCADE-BROKEN]` task #28 — `.entity-*` cascade investigation; `[NPM-UP]` task #29 — **🔝 LEAD NEXT-CONV ITEM:** upgrade astro 6.1.5→6.3.7, adapter 13.1.8→13.5.4, react adapter 5.0.3→5.0.5 + retry canonical Vite dedupe/noExternal workaround + regression-test by reverting ToDoItem to hybrid form with `useState`. **`[MATT-MCP-RETRY]` put ON HOLD** per user direction (external Figma paid-seat blocker indefinite); proceeding without MCP using static SVG exports + new qlmanage workflow. Branch `jfg-dev-13-matt` retained as active. RESUME-STATE.md cleared at /r-start (25 pending items transferred to TodoWrite). Next major step: `[NPM-UP]` upgrade + workaround retry; then `[MATT-EXEC-PG2]` Phase 5 routes.*

*Previously: 2026-05-22 Conv 175 — MATT-DESIGN-PUSH advanced through Phases 2-visualization, Phase 3 first page, and Phase 4 scope A primitives — all on `jfg-dev-13-matt`. **Conv 175 deliverables (4 PLAN items + 4 commits):** [MSH-VIZ] `/matt/index.astro` shell preview stub (5750 B, gated `noNav`) — diagnosed and durable-fixed Astro Fragment-forwarding bug suppressing HeaderBar slot fallbacks (failed `Astro.slots.has + &&` short-circuit, root cause unconfirmed; moved defaults from HeaderBar to AppLayout via ternary inside *unconditional* Fragments; HeaderBar becomes pure shell primitive with no slot fallbacks; learning saved as `memory/reference_astro_slot_forwarding.md`); commit `350bf88`. [MSH-REFINE] Tailwind `lg:` breakpoint shifted 1024→1025px globally via `--breakpoint-lg: 1025px` in `tokens-tailwind-bridge.css @theme` (single source of truth, propagates to all `lg:*` callsites in matt/* AND legacy fraser/*; matches Matt's spec exactly); HeaderBar.astro cleaned (3 dead `<slot>{fallback}</slot>` removed; docstring updated to point to AppLayout for defaults + cross-reference new memory file); bundled into commit `350bf88`. [MATT-EXEC-PG1] First `/matt/course/[slug]` page end-to-end (commit `dca4614`): built `CourseHeader.astro` entity primitive (dark image hero with gradient overlay + top-right back-chevron+book overlay + 2-column layout LEFT title/tagline/metadata row creator/rating/level + RIGHT ✓-includes list + "$X • Enroll Now ›" pill; min-height 240px via inline style — Tailwind arbitrary `min-h-[NN]px` silently failed, see [TWLG-MIN-H]) and `src/pages/matt/course/[slug]/index.astro` (thin <100-line page using existing `fetchCourseTabData` loader; AppLayout entity=course; SubNav 7 course tabs About / Course Feed / Modules / Meet the Creator / Teachers / Reviews / Resources; About body 4 Cards About / What you'll learn 2-col objectives / Prerequisites / Who this is for); HTTP 200, astro check clean. [MATT-EXEC-PRM] scope A — 3 of 8 primitives + retrofit (commit pending /r-end): `Button.tsx` 6 variants × 3 sizes per matt-design-system.md §6 exactly, `Card.astro` white-fill with padding scale + optional borderless, `SectionTitle.astro` semantic level × visual size; retrofitted CourseHeader CTA → `<Button variant="course">` + course-page body sections → `<Card padding="lg">` + `<SectionTitle>` headings. **Visual-fidelity iteration vs Matt's `Course.svg`** (~6 fixes landed mid-conv via `public/_matt-ref/` symlink-diff pattern, removed pre-commit): Course Feed tab added to SubNav, objectives layout 1-col→2-col, What's Included moved to hero overlay (not body card), Meet the Creator added as SubNav tab (not body card), hero restructured to 2-column with metadata row + includes-list + Enroll Now pill, hero overlay glyphs added (back-chevron + book). User-confirmed acceptance: "looks better, items in front of the page need work, but it's enough for now" → marked complete with `[MATT-COURSE-POLISH]` spawned. **3 patterns established:** (1) Matt-page assembly — thin page composing `AppLayout(entity=course) → CourseHeader → SubNav → body Cards`; (2) AppLayout slot-default pattern — defaults via ternary inside *unconditional* Fragments using `Astro.slots.has()`; primitives carry no slot fallbacks; (3) Visual-diff symlink pattern — `public/_matt-ref/` Figma-SVG symlinks must happen BEFORE building, not after (Conv 175 learning: pre-plan §9 visual-validation gate has to fire before structural build). **5 new deferred subtasks spawned:** `[MATT-EXEC-PRM-2]` remaining 5 Phase 4 primitives; `[MATT-COURSE-POLISH]` body section visual polish; `[MATT-ICON-SWAP]` hero inline-SVG icons → icon-system in Phase 6; `[MATT-CREATOR-TAB]` /matt/course/[slug]/creator route — Phase 5; `[TWLG-MIN-H]` Tailwind 4 `min-h-[NN]px` silent failure suspected to interact with Conv 174 `--spacing-*` global override — root cause + fix is `[TSV]` follow-up. **Conv 175 was a warm restart** (counter already incremented in commit `6ddb203 Conv 175 start`; previous Conv 175 ended without /r-end; resumed in-flight [MSH-VIZ] work). Branch `jfg-dev-13-matt` already has remote tracking from Conv 174 push. RESUME-STATE.md cleared at /r-start (22 pending items transferred to TodoWrite). Next major step: `[MATT-EXEC-PRM-2]` remaining 5 Phase 4 primitives, or `[MATT-EXEC-PG2]` Phase 5 routes.*

*Previously: 2026-05-22 Conv 174 — MATT-DESIGN-PUSH Phase 1 [MATT-EXEC-TKN] + Phase 2 [MATT-EXEC-SHL] both COMPLETE on new branch `jfg-dev-13-matt` (created from `jfg-dev-12`). **Phase 1:** 3 token files authored (`src/styles/tokens-primitives.css` ~155 lines / `tokens-semantic.css` ~165 lines / `tokens-tailwind-bridge.css` ~80 lines) + `global.css` `@import` wired in. 15 color primitives kebab-case per Decision 2=B, full scaffolded scales (spacing rem-valued pixel-named per Decision 1=C, radius px, shadows, opacity, z-index, duration). 14 color semantics Title-Case-dash with cascade preserved via `var()` chains (`--Student-Primary: var(--Primary-Default)` NOT flattened to primitive). Entity multi-mode at `:root` + 3 mode classes (`.entity-creator/student/course`). Button base + 6 variant classes preserving seamless-edge pattern. **Tailwind 4 bridge override decision Conv 174 §1 = B:** include `--spacing-N` globally (572 `p-4` callsites audited; pixel-named utilities now resolve to Matt's pixel values on `jfg-dev-13-matt` branch only; `jfg-dev-12` and earlier branches unaffected). All 5 baseline gates green: tsc 0 / astro 1215/0/0/0 / build 6.13s. Phase 1 commit `579266c` (4 files, +398 lines). **Phase 2:** 5 layout-shell components authored under `src/{layouts,components}/matt/`: `HeaderBar.astro` (slot-based per Decision 7=C — header-left/center/right slots), `SubNav.astro` (vertical-left strip at lg: 196px, horizontal-scroll fallback at <lg), `Sidebar.tsx` (React island 220/70px collapsible, 5-item primary nav middle + brand top + earnings/notifications/profile bottom), `ControlBar.tsx` (React island, bottom-fixed pill, 6 nav icons with `tabletOnly` flag hiding Messages+Notifications at mobile so 4 icons at <sm + 6 icons at sm:), `AppLayout.astro` (composes all 4; Sidebar `hidden lg:flex`, HeaderBar/ControlBar `lg:hidden`; named slots header-bar/entity-header/role-tab-bar/sub-nav/default + entity prop applies `.entity-{creator|student|course}` mode class). Gates green: tsc 0 / astro 1220/0/0/0 / build 6.13s. Built CSS verified: bridge color/typography utilities (`--color-text-default`, `--color-text-primary`, `--color-border-default`, `--color-primary-light`, `--color-entity-primary`, `--color-entity-background`, `--text-body-default`) all now emit (1 occurrence each) — components triggered Tailwind 4's on-demand `@theme` emission. **3 patterns established:** (1) Tailwind 4 `@theme` tokens emit on-demand only when at least one utility class consumes them — don't panic if a freshly-authored bridge token isn't in `dist/` until a component exercises it; (2) `--spacing-N` in `@theme` overrides Tailwind utility scale globally not additively — audit usage first (`grep -rho 'p-[0-9]+'`) and decide override/namespace/omit; (3) Matt's 2-layer + 3-layer cascade preserves correctly when authored as `var()` chains — never flatten semantic-to-semantic refs (the cascade IS the value). **2 new spawned subtasks:** `[MND2]` `detect-machine.sh` still returns `Unknown (M4Pro.local)` despite Conv 168 fix (case patterns or `.local` suffix issue); `[MSH-REFINE]` 3 Phase 2 layout positioning details deferred to Phase 3 visual gate. **No visual validation in Phase 2 yet** — user's next-conv intent: review responsive layout/navbar state in browser (may require Phase 3 stub or jump into [MATT-EXEC-PG1]). Branch `jfg-dev-13-matt` not yet pushed at conv-end (first /r-end push will create remote tracking branch). RESUME-STATE.md cleared at /r-start (21 pending items transferred to TodoWrite). Next major step: `[MATT-EXEC-PG1]` Phase 3 first `/matt/*` page end-to-end.*

*Previously: 2026-05-22 Conv 173 — MATT-DESIGN-PUSH pre-plan + 8 decisions resolved (block: MATT-DESIGN-PUSH, ACTIVE). Major artifact: `docs/as-designed/matt-pre-plan.md` (~510 lines, 12 sections) — durable companion to `matt-design-system.md` covering route map (31 Matt screens → 13 `/matt/*` routes), file structure (concrete paths under `src/styles/`, `src/layouts/matt/`, `src/components/matt/{,entity,ui}/`, `src/pages/matt/`), 8 blocking decisions all resolved, Tailwind 4 bridge sketch, page assembly pattern, 11-category extrapolation enumeration, doc graduation criteria, 7-phase execution sequence (~8–11 convs estimate), risk inventory, designer-side questions. **[MATT-PRE-PLAN] task #10 COMPLETE.** **8 §4 decisions resolved via one-at-a-time walkthrough** (recommendations stood 8-of-8): (1=C) Hybrid CSS units rem/px — typography + spacing emit rem with px-named tokens; borders + hairlines + radius stay px; (2=B) kebab-case for primitives, semantics keep Title/Slash; (3=C) Hybrid Tailwind bridge file — Matt's tokens canonical, `tokens-tailwind-bridge.css` re-exports as `--color-*` for utility classes; (4=B) Coexist with existing `--color-primary-*` sky-blue scale (consolidation deferred to flip block); (5=A) `/matt/` = `/dashboard` analog member-only, visitors → `/matt/login`; (6=B) Rebuild Sidebar as new `src/components/matt/Sidebar.tsx` (reuse hooks/utilities); (7=C) Slot-based HeaderBar with named slots; (8=A) Omit footer entirely (legal/terms → Sidebar bottom or Settings). **Conv 171 Control Bar misattribution corrected:** original deliverable (d) said "Control Bar = ExploreTabBar re-skin" — actually Matt's Control Bar = primary-nav bottom-pill at tablet/mobile (NOT a role switcher); the Role Tab Bar is the Peerloop extension (ExploreTabBar re-skin), bundled into Phase 4 `[MATT-EXEC-PRM]`. **8 new execution-phase tasks spawned** in new "MATT-DESIGN-PUSH Execution Phases" section: `[MATT-EXEC-TKN]` (Phase 1 token files) → `[MATT-EXEC-SHL]` (Phase 2 layout shell) → `[MATT-EXEC-PG1]` (Phase 3 first `/matt/*` page) → `[MATT-EXEC-PRM]` (Phase 4 remaining primitives incl. [RTB]) → `[MATT-EXEC-PG2]` (Phase 5 remaining 12 routes) → `[MATT-EXEC-EXT]` (Phase 6 extrapolation primitives) → `[MATT-EXEC-GRD]` (Phase 7 doc graduation), plus cross-phase `[MATT-EXEC-FLAGS]` (verify 4 route-shape assumptions). [MDS-OQ] substantially absorbed by pre-plan §4 decisions (Q7, Q8, footer, visitor flow, inner grid all resolved; 4 minor items remain for execution phases). 3 patterns established: decision walkthrough (one-at-a-time A/B/C presentation for >3 novel decisions), pre-plan BLOCKING→RESOLVED state transition (heading + summary table), authority split framing (designer = visual / user = architect, compresses scope by an order of magnitude). No code changes; no baseline gates run this conv (planning-only). Next major step: `[MATT-EXEC-TKN]` Phase 1.*

*Previously: 2026-05-22 Conv 172 — Matt design-system extraction + token scaffolding (block: MATT-DESIGN-PUSH, newly promoted to ACTIVE this conv). Major artifact: `docs/as-designed/matt-design-system.md` refined 650 → 1169 lines. **[MDM] task #13 COMPLETE** — all 5 original Figma Dev Mode extraction batches resolved + 5 bonus batches scaffolded (Border Radius, Shadows, Opacity, Z-index, Animation Durations). Full Figma Variable extraction (35 base vars across 5 collections, 47 mode-resolved cells): Color Primitives (15), Color Semantics (14), Entity (2×4=8 multi-mode cells), Icon Size (1×2=2 multi-mode cells), Button (3×6=18 multi-mode cells with resolved-hex review row). §6 renamed "Token Extraction & Scaffolding"; Token Scaffolding Policy established (snap + pixel-named + complete-from-day-1). §4 restructured + Q7 (naming) + Q8 (units) + Q9 (Main Panel layouts) added — 9 open questions total. §2 architectural findings extended: Header Bar slot multi-content per breakpoint; Sub Nav breakpoint-varying rendering (slide-in drawer at Mobile); Control Bar correctly attributed as Matt's primary-nav primitive (NOT a role switcher — §2.6 rewritten + 7 dangling references cleaned across §1/§3/§6); new §2.7 Role Tab Bar (Peerloop extension; NOT in Matt's design — his brief was deliberately single-role); Matt-composes-pages-from-components meta-principle added. New `docs/as-designed/figma-screenshots/` folder committed (~480KB, 8 PNGs) with source artifacts catalogued in new §Source Materials section. **5 strategic decisions** captured: (1) Token Scaffolding Policy — complete-from-day-1 + pixel-named + snap; (2) Control Bar = Matt's primary-nav primitive (not role switcher); (3) Component composition principle — every Matt component → parameterized React/Astro component; (4) Preserve cascade chains in CSS — `--Student-Primary: var(--Primary-Default)` NOT `var(--americana-blue)`; (5) Commit Figma source screenshots to docs repo. Block Sequence updated: **MATT-DESIGN-PUSH promoted to ACTIVE** at top of table — the Convs 169-172 active work focus has shifted decisively from DEPLOYMENT to Matt design. 4 new deferred subtasks spawned: [RTB] Role Tab Bar design, [TSV] Token Scaffolding Verification, [MATT-MAX-WIDTH] external answer pending, [MATT-REACT-ICON-DEFAULT] icon-default change for `/matt/*`. [MATT-MCP-RETRY] partial — Brian's paid Figma seat not yet provisioned; user adopted Figma Dev Mode CSS Inspector + paste-screenshot workflow as viable interim. No code changes; no baseline gates run this conv (docs-only).*

*Previously: 2026-05-21 Conv 171 — Matt design-system foundation (block: misc — design-system intake feeding MATT-PRE-PLAN, not the implementation itself). Major artifact: authored `docs/as-designed/matt-design-system.md` (650+ lines) — graduated mid-conv from `.scratch/matt-devmode-form.md` once content stabilized into substantially-permanent spec (Strategic Context + Architectural Findings + Existing App Context + Open Questions + Color Primitives + Token Extraction Batches 1–5). Six sections; `docs/INDEX.md` entry added under "How Should It Look/Work?". Advanced [MDM] task #13: Batch 1 (Typography) COMPLETE — all 9 header + 9 body roles measured via Figma Dev Mode CSS Inspector (Inter, sizes 12/14/16/20/24/32, regular=400/medium=500/headers=500/600/body=400/500/600, line-height normal for headers + 150% for body Medium/Large + letter-spacing -0.352px on body Medium/Large); Batch 2 Desktop PARTIAL (sidebar 220/70 px, page padding 16, gutter 16, Header Bar ~40–48px breadcrumb); Batch 4 RESOLVED (2-column Sidebar + Main Panel); Batch 5 RESOLVED (Control Bar = role-perspective tabs, only when user has >1 role). Color primitives extracted (12 hex codes). Updated [MATT-PRE-PLAN] task description with strategic context (Matt = designer / user = architect authority split, /matt/* = visual re-skin of existing role-aware infrastructure NOT new architecture, happy-path = calibration set / rest of app = extrapolation test) + new primary input + 8 deliverables (a–h). 4 architectural findings persisted (no global header bar — branding in sidebar only; entity-color-coded headers as load-bearing identity contract; Control Bar Matt designed already exists in code as `ExploreTabBar`; Header Bar = re-skin of existing `Breadcrumbs.astro` with `?via=` pattern). 3 decisions recorded (DECISIONS.md to be updated): /matt/* scope strictly visual re-skin; CSS variable names match Matt's Figma Variable naming verbatim (Title-Case-Hyphenated, e.g., `--Text-Default`); Visitor = unauthenticated UI state (no schema change). 4 new deferred subtasks spawned: [MDS-OQ] resolve 6 open questions, [MDM-TAIL] complete remaining Batches, [MATT-TYPO-EXERTISE] flag typo to Matt, [MATT-DOC-READ] read 3 additional docs before [MATT-PRE-PLAN] starts. Two patterns established: form-graduation (.scratch → docs/as-designed when content stabilizes at 60%+ permanent) and Figma-Variable-naming-verbatim. Conv shape note: almost entirely strategic/design-system foundation — no source-code edits. All output in: matt-design-system.md (new), docs/INDEX.md (entry added), [MDM] + [MATT-PRE-PLAN] task descriptions, package-lock.json (incidental `npm install` no-op at /r-start). No baseline gates run this conv (no code changes).*

*Previously: 2026-05-21 Conv 170 — Matt design push pre-work (block: misc — preparation for MATT-PRE-PLAN, not the work itself). Closed 1 RESUME-STATE item: [MATT-ISOLATE] curated `.scratch/matt-figma/` (229 files, 137 MB) → `.scratch/matt-main/` (83 files, 85 MB, 38% file count / 62% size) — tokens (9 files) + layout (17) + components (14) + happy-path (42 incl. 31 canonical Content/Happy/ screens + 10 Purpose milestones + α1 overview). Fixed `typograhy-overview.png` typo + misplaced location at the copy step (renamed to `typography-overview.png` and moved into `tokens/typography/`). Authored `_README.md` with inclusion structure tree + 16-row per-category exclusion table answering "why isn't X here?" for each excluded category (Prototype copies, Section Title-N variants, Why-we-need-it justification frames, decorative quotes, social-post mockups, unnamed Frame N items, Matt's Graveyard, documentation notes). User chose Dropbox for cross-machine transfer (`.scratch/` is gitignored — git-as-transport doesn't apply). [MATT-INVENTORY-CLEANUP] effectively superseded by `matt-main` curation: the misplaced/typo'd typography overview was relocated at the copy step (source `matt-figma` left as read-only inventory); the 31-screen `Content/Happy/` implementable set is now isolated. Two learnings folded: (1) Inventories typed from screenshots can drift from disk reality — when acting on an inventory, walk actual folders before trusting filename-level claims (Conv 169's `_INVENTORY.md` mis-listed `components-overview.png` and under-counted top-level happy-path items). (2) Curation work needs a per-category exclusion table, not just an inclusion list — absence of common patterns reads as oversight rather than deliberate exclusion. New curation README pattern established. No code changes; no baseline gates re-run this conv.*

*Previously: 2026-05-21 Conv 169 — Cross-block follow-up + Matt design intake (block: DEPLOYMENT/DB-SYNC sub-block added + Conv 168 follow-ups + pre-plan only for Matt). Closed 2 RESUME-STATE items: [RAM-NONAV-SWEEP] (applied `export const noNav = true;` to 19 legitimate no-nav routes — 14 footer/marketing pages + /404 + /admin/recordings + 3 discover 301-redirects; scanner now reports `ℹ️ no-nav by design` for all 20 annotated routes; zero `⚠️ no discovered nav` warnings remain; tsc + astro check clean across 1215 files); [PROD-PW-APPLY] redirected into new DEPLOYMENT.DB-SYNC sub-block after audit revealed prod D1 3-migration drift (0002 tracker stale name, 0003 + 0004 NOT applied, `feed_visits` + `feed_activities` tables missing on prod). New DEPLOYMENT.DB-SYNC sub-block bundles 5 atomic tasks ([DB-SYNC-04] apply migration 0004 + insert tracker row; [DB-SYNC-03] tracker row only for already-converged 0003; [DB-SYNC-02-RENAME] tracker rename `0002_seed.sql` → `0002_seed_core.sql`; [PROD-PW-APPLY] full 3-step procedure absorbed; [DB-SYNC-VERIFY] convergence check). Matt design push intake: 4 directives confirmed (branch `jfg-dev-13-matt` from `jfg-dev-12`, `/matt/` top-level route for coexistence, Figma examination, style guide extraction); decisions captured (tokens as future global default consumed only by `/matt/` initially per eventual `/matt/` → `/` flip; SVG over PNG for export hedging). Figma MCP setup attempt failed (user's account lacks Dev seat — Matt's shared Dev-Mode access != MCP-capable seat; Brian setting up paid account tonight). 229 SVG/PNG files (~137 MB) exported from Figma into `.scratch/matt-figma/` across `tokens/`, `layout/`, `components/`, `happy path/`; inventory + page-panel notes persisted. 3 new deferred subtasks spawned: [MATT-MCP-RETRY], [MATT-INVENTORY-CLEANUP], [MATT-PRE-PLAN]. Four learnings: Figma MCP requires viewer's own Dev seat (not just file-level Dev Mode access); prod D1 migration drift can be invisible — tracker retains old filename after seed-split rename; Figma batch-export auto-names files after frame names, replacing manual layer-panel inventory; `Content/` sub-folder in Figma exports masks the actual screen library at one level deeper. Verified `cd ../Peerloop && npx tsc --noEmit` clean + `npm run check` clean (0/0/0 across 1215 files) after [RAM-NONAV-SWEEP]; other gates not run this conv.*

*Previously: 2026-05-21 Conv 168 — Cross-block follow-up batch, no single PLAN.md block advanced (block: misc). Closed 5 RESUME-STATE/PLAN items: [CCK-DA] v2 alias-aware schema-aware deleted_at lint (eliminates 90 v1 false positives across 18 tables; calibrated against actual Conv 117 motivating case via `git show 7df6c02` — pre-fix SQL was unqualified `deleted_at`, not qualified as session-doc summary claimed; production script at `.claude/scripts/codecheck-deleted-at.mjs` ~95 lines + harness `.scratch/cck-da-v2-test.mjs`); [MND] `detect-machine.sh` hostname match for M4Pro fixed + canonical name migration `MacMiniM4-Pro` → `MacMiniM4Pro` across 11 files (`MachineName` TS type narrowed, `vitest.global-setup.ts`, `tests/README.md` × 5, `dev-env-scan.sh` grep widened for forward+historical compat, 8 docs); [RAM-NO-NAV] `parseNoNav(content)` helper added to `scripts/route-api-map.mjs`; emit branched `ℹ️ no-nav by design` vs `⚠️ no discovered path`; applied to `/course/[slug]/[tab].astro` as first instance — declarative per-route opt-out pattern established; [PROD-PW] decisions captured in DECISIONS.md §4 (password = Peerloop2; apply deferred to bundle seed edit + UPDATE in one synchronous step; un-defer procedure documented in 3 steps); [XMV] cross-machine path-derivation verification harness built at `.claude/scripts/cross-machine-verify.sh` — 9 canonical cases under `HOME=/Users/livingroom` (M4) and `HOME=/Users/jamesfraser` (M4Pro), asserts structural-glob match, 9/9 pass; plus `--scan <file>` advisory mode; documented in `docs/as-designed/devcomputers.md § Machine Inventory > Cross-Machine Path Verification`. New tasks spawned: [RAM-NONAV-SWEEP] (apply noNav=true to remaining 19 legitimate no-nav routes), [PROD-PW-APPLY] (execute the deferred Peerloop2 rotation against prod admin). Four learnings: validate detection heuristics against the actual motivating case from git (not session-doc summary); naming-convention sweeps benefit from "code-truth" anchoring even when PLAN.md text disagrees; per-route opt-out annotation outperforms scanner-wide whitelist for "expected unreachable" routes; HOME-simulation harness with structural-glob assertions catches dual-username bugs at script-author time. Verified `cd ../Peerloop && npx tsc --noEmit` clean; other gates not run this conv.*

*Previously: 2026-05-20 Conv 167 — Quick-wins / defensive fixes / baseline maintenance, no named PLAN.md block advanced (block: misc). Closed 4 RESUME-STATE quick-wins: [CAP-DEFEND] widened `CourseAvailabilityPreview.tsx:76` early-return guard (Array.isArray + length>0) eliminating the Conv 166 "1 unhandled error" in CourseTabs tests; [RM-PARAM-BUG] added two `url.search`/`searchParams` exclusion rules to `scripts/route-matrix.mjs:normalizeDynamic` before generic `[param]` fallback, dropping the phantom `/course/[slug][param]` broken-target row and resolving `/course/[slug]/[tab]` cleanly across 18 inbound references in `page-connections.md` (4 doc files regenerated); [SEED-PW] rotated dev seed `Password1` → `Peerloop2` across 13 files (3 SQL incl. migrations-dev/0001_seed_dev.sql, README, plato-seed-staging.js, mock-data.ts `DEV_PASSWORD`, tests/helpers/test-data.ts, plato personas seed-full.ts × 9, scenarios/seed-dev-topup.ts hash, 4 e2e specs) — narrowed to dev-only after discovering same hash lives in production-safe `migrations/0002_seed_core.sql` (prod-side surfaced as new [PROD-PW] task); [WRANGLER-CMT] rewrote `wrangler.toml:107-113` 3-line staging block as 6-line comment accurately describing `CLOUDFLARE_ENV=staging` build-time selection (was misleading "→ wrangler deploy --env staging"). Ran full 5-gate baseline: tsc 0 / astro 0/0/0 across 1215 files / lint 0/0 (post-fix) / **6453/6453 tests** (207s) / build clean (~7s). Then closed 2 cleanup fixes surfaced by /w-codecheck: [CCK-LINT] eslint.config.js `ignores: '.astro/**'` → `'**/.astro/**'` (matches nested generated dirs like `src/pages/api/communities/.astro/content.d.ts`); [TW-OUTLINE] Tailwind v4 `outline-none` → `outline-hidden` × 2 in `MemberDirectory.tsx:227,270`. New deferred tasks: [PROD-PW] (prod admin seed password still `Password1` in 0002_seed_core.sql + live prod D1 — needs UPDATE migration not seed change), [CCK-DA] (w-codecheck Check #8 deleted_at heuristic emitted 90+ false positives, needs qualified-column matching per `feedback_heuristic_calibration.md`). Three learnings folded: Astro `${Astro.url.search}` query-string appenders confuse template-literal route extractors → use targeted name-based exclusion not blanket dot-strip; static "table-name-in-same-block" SQL heuristics are too coarse → require qualified `<table>.column` matching or grammar parsing; ESLint flat-config `ignores` patterns are NOT auto-recursive → prefix with `**/` for nested dirs.*

*Previously: 2026-05-20 Conv 166 — CRT block ✅ COMPLETE and archived to COMPLETED_PLAN.md. [CRT-STUDENT-EXPLICIT-SCOPE] 2-site fetch fix (`CourseTabs.tsx:131` + `ResourcesTabContent.tsx:71` now pass `scope=student` explicitly). [CRT-4] CREATOR + ADMIN + MODERATOR groups on `sessions.astro` via shared `AllSessionsTabContent` component (single component rendered under 3 group labels — purple/amber/blue, distinct tab IDs preserve URL routing). [CRT-5] Propagated all 4 role flags (`isTeacherOfCourse`, `isCreatorOfCourse`, `isAdmin`, `isModeratorOfCommunity`) to remaining 5 course-tab pages (`index`, `feed`, `learn`, `resources`, `teachers`); ResourcesTabContent role split via `canSeeAllResources = isEnrolled || isCreatorOfCourse || isAdmin || isModeratorOfCommunity`. [CRT-6] 15 component tests added (8 CourseTabs + 7 ResourcesTabContent); full 5-gate baseline green (tsc 0 / astro 1214/0/0/0 / lint 0 errors 4 pre-existing warnings / **6453/6453 tests** / build 6.49s). [CRT-DEDICATED-PAGES] single dynamic `[tab].astro` catch-all handles role-tab direct nav (whitelist + access gate redirecting to /404 or /course/<slug>); chose durable single-catch-all over 4 cloned files per Solution Quality default. Three Astro/React patterns established: pass primitive descriptors not React elements across `client:load` boundaries (CRT-3 chassis lock-in); Astro static-route precedence over dynamic routes makes catch-all safe alongside existing static `.astro` files; tsc 6133 unused-variable false-positive on Astro frontmatter requires inline expression workaround. One new spawned task: [CAP-DEFEND] (CourseAvailabilityPreview undefined-shape async crash — pre-existing latent bug surfaced during CRT-6 test runs).*

*Previously: 2026-05-20 Conv 165 — CRT block first conv. [CRT-1] loader role flags: `fetchCourseTabData` now returns `isAdmin`, `isCreatorOfCourse`, `isTeacherOfCourse`, `isModeratorOfCommunity` (creator+teacher derived from data already loaded = 0 extra queries; admin via `isUserAdmin`; moderator via new join through `progressions`); 7 SSR tests covering all role permutations on `crs-intro-to-n8n` seed fixture. [CRT-2] `/api/courses/[id]/sessions` rewritten with role precedence (admin/creator/moderator → all sessions; teacher → own; enrolled student → own; else 403); 6 endpoint tests. [CRT-2.5] dual-role regression spawned during [CRT-3] design (teacher-who-is-also-enrolled would see teaching data on student tab) — solved by adding explicit `scope=student|teacher|all` query param; caller declares intent, default-without-scope keeps highest-privilege precedence for backwards compat; 10 additional endpoint tests covering all scope branches + dual-role disambiguation. [CRT-3] Teacher vertical slice: new `TeacherSessionsTabContent` component (self-contained fetch with `scope=teacher&status=all`); first wiring attempt via `extraTabs` from `.astro` failed at runtime — Astro `client:load` JSON-serializes prop boundaries and React rejects rebuilt-element plain-objects. Refactored to pass `isTeacherOfCourse` as primitive boolean; `CourseTabs` imports `TeacherSessionsTabContent` directly and constructs the extra tab internally (wrapped in `useMemo` for stable deps). Browser-verified as Guy on `/course/intro-to-n8n/sessions`: TEACHER group with "My Teaching Sessions" tab landed-on-by-default for teacher-not-enrolled; rendered two completed teaching sessions with student names + Recording links; console clean. All 5 baseline gates green: tsc 0 / astro 0/0/0 / lint 4 pre-existing / 6438/6438 tests / build 6.68s. Two new spawned subtasks: [CRT-DEDICATED-PAGES] (manual-refresh 404s on extra-tab URLs), [CRT-STUDENT-EXPLICIT-SCOPE] (student tab needs `scope=student` to be dual-role safe). CRT block status promoted PENDING → IN PROGRESS; estimated ~1 conv remaining ([CRT-4] + [CRT-5] + [CRT-6]).*

*Previously: 2026-05-20 Conv 164 — BBB-RECORDING continued. [RV] 10-surface recording-button verification sweep complete (Sarah/Guy/Brian role rotation via direct auth API; Surfaces 1-10 all rendering shared `<RecordingLink>` bordered "Recording" affordance). [BR-NAVBAR-HYDRATE] root-caused + fixed: `AdminNavbar.tsx:90` `useState(getCurrentUser())` flipped SSR-vs-CSR render branches; mirrored AppNavbar's established `isHydrated` pattern (`useState(null)` + setIsHydrated in existing useEffect + render guard `{isHydrated && admin && (...)}`). Repo grep confirmed single isolated divergence; Conv 163 [DLE] "scope widened to non-admin pages" was a misdiagnosis — `data-astro-transition-persist="admin-navbar"` was carrying the persisted error across View Transitions. All 5 baseline gates green: tsc 0 / astro 0/0/0 across 1211 files / lint 0 errors 4 pre-existing warnings / 6415/6415 tests / build 6.43s. [CRT] verified NOT done (Sessions tab hidden for Guy/Brian on `/course/intro-to-n8n/sessions`; no role tab groupings) and promoted to own ACTIVE block — full design block written (5 acceptance criteria, file map, 7×8 role × tab matrix, 6 phases [CRT-1]…[CRT-6], estimated 2-3 convs). CourseTabs.tsx already has `extraTabs` + `groupLabel` + `roleColor` infrastructure wired; missing piece is loader role flags + `.astro` pages populating extraTabs. Three Astro/SSR learnings captured: View-Transitions persistence replays hydration errors across navigations; `isHydrated` flag is the established SSR-safe current-user pattern; direct auth-API is more reliable than React form-button click for role-switching tests.*

*Previously: 2026-05-20 Conv 163 — BBB-RECORDING continued. [REC-LABEL] completed: created `<RecordingLink>` component (`src/components/ui/RecordingLink.tsx`) — bordered text "Recording" button with dark-mode classes; applied to all 10 user-facing surfaces (8 original + 2 admin: RecordingsAdmin Open link → button, SessionsAdmin Rec column status-dot → inline button). API `/api/admin/sessions/index.ts` now returns `recording_url` in list payload (was queried/dropped). Detail panels standardized on `bg-secondary-50` + "Session Recording" heading. `docs/reference/bigbluebutton.md` UI Surfaces table updated 8 → 10. **Local dev seed parity**: added Sarah/Guy/Intro-to-n8n enrollment + completed session + module_progress + assessments + attendance to `migrations-dev/0001_seed_dev.sql` with real Blindside `recording_url` UPDATE — fresh local DBs now mirror staging for the recording flow. [DLE] dev-server "loading errors" investigation: root-caused to existing [BR-NAVBAR-HYDRATE] (Vite/Astro hydration mismatch dumps wall of terminal errors + blanks page until ~2s self-heal); scope widened — NOT admin-only as originally diagnosed. New tasks spawned: [MND] `detect-machine.sh` hostname-match fix for M4Pro, [AAP] Astro dev absolute-filesystem path leak in ClientRouter (waiting on upstream Astro fix post-6.3.6 — diagnosed to `vite-plugin-astro/compile.js:50`). User-directed: [BR-NAVBAR-HYDRATE] first task next conv after /r-start. Five-gate baseline: tsc 0 / astro 0/0/0 / lint 4 pre-existing / 6415 tests / build clean.*

*Previously: 2026-05-19 Conv 162 — BBB-RECORDING continued. [MST-REC] fixed TeacherTabContent My Sessions tab missing recording link — added `recording_url` to `SessionRow` interface + verbatim mirror of student `SessionsTabContent` bordered "Recording" button; deployed to staging (Version `36c761e7-...`), verified live by user. Discovered the 8th user-facing recording surface — [REC-LABEL] inventory updated from 7 to 8 surfaces. Skill-infrastructure work: [CPD-SWEEP] swept 10 skill files (r-start/r-commit/r-end/r-end refs/fmt-docs.md/r-timecard-day/w-post-fix/w-review-resume-state/w-sync-skills) from `$CLAUDE_PROJECT_DIR` and `$HOME` to tilde-literal `~/projects/peerloop-docs` outside quotes (eliminates `simple_expansion` permission prompts on Bash gate); `SLUG=$(echo ~/projects/peerloop-docs | tr / -)` replaces `${CLAUDE_PROJECT_DIR//\//-}` for memory-dir slug derivation. Critical M4-portability correction mid-conv: user caught literal `/Users/jamesfraser` substitution would break M4 (user `livingroom`); reverted to tilde/`$HOME`-semantics. CLAUDE.md §Path Conventions extended with tilde-everywhere rule; §Startup Hooks flagged `persist-project-dir.sh` as historical. Memory `feedback_git_dash_c_enforcement.md` documents the rule + cross-machine M4/M4Pro user mapping. Cross-machine portability verified via `HOME=/Users/livingroom` simulation; first actual M4 run will be empirical confirmation. Mid-conv staging deploy of `jfg-dev-12` branch (Version `9b170124-...`). Baselines: tsc clean (no other gates run this conv).*

*Previously: 2026-05-15 Conv 161 — BBB-RECORDING major progress. Conv 160 recovery commit (`078b75f`). Blindside reply: `getRecordings` requires `limit≤100` (fixed both diagnostic surfaces + `bbb.ts` default). [BR-PAGE] paginated `/admin/recordings` with 20-per-page paging, 2-call total derivation, AdminPagination component. [BR-TRACE] mapped all 7 user-facing recording surfaces + empirically verified on staging (1 of 8 recordings visible, 5 orphaned, 2 Greenlight-only). [TCV-REC] fixed TeacherCourseView SessionRow missing recording-link JSX, deployed to staging, verified live. Spawned 3 new deferred tasks: [BR-NAVBAR-HYDRATE] (pre-existing dev-mode hydration mismatch), [CRT] (role-aware course-page tabs), [REC-LABEL] (standardize recording-link affordances). Baselines: tsc clean / astro 0/0/0.*

*Previously: 2026-05-13 Conv 159 — BBB-RECORDING block (5 of 6 subtasks complete). [BR-DIAG] account-wide getRecordings returned 0 recordings (returncode SUCCESS); [BR-AUTO] `autoStartRecording=true` deployed at 3 sites with type-system support; [BR-ADMIN] built `/api/admin/bbb/recordings` endpoint + `/admin/recordings` page + `RecordingsAdmin.tsx` component + AdminNavbar entry; [BR-ADMIN-SCRIPT] promoted diagnostic script to `scripts/bbb-list-recordings.mjs`; [BR-REPLY] drafted and sent reply to Fred Dixon at Blindside. [BR-STATUS] (richer post-session UI for recording state) deferred pending Blindside's response. Amended `docs/reference/bigbluebutton.md` with detailed Recording Lifecycle section (159 net lines). Established `.scratch/` convention (gitignored persistent workspace). Spawned 1 new task: [AHM] (pre-existing AdminNavbar hydration mismatch). Baselines: tsc clean / astro 0/0/0.*

*Previously: 2026-05-06 Conv 150 — Infrastructure/docs work: [OPW] Conv 147 rule-strengthening watch closed (root cause: missing memory-dir sync on this machine; rule clarified). Memory M4↔Pro sync completed (31 new files copied, 2 overlaps refreshed, MEMORY.md rewritten as topical index). Tier 1+2+3 audit fixes applied (11 findings consolidated: r-end memory merge, size≠novelty rule inlined, new Baseline Verification section, output-formatting rule merges). CLAUDE.md major restructure (677→446 lines, 22→19 sections): behavioral rules retained, navigation→docs/INDEX.md (NEW), archaeology→TIMELINE.md, Block Arc→SCOPE.md. Asymmetric rule placement noted (Issue Surfacing in CLAUDE.md, Pointing Emoji + Option Phrasing in memory) — functional but inconsistent. New memory file: `feedback_conversational_brevity.md`. No feature blocks worked. [CMS] cross-machine memory sync architecture added as new deferred item.*

*Previously: 2026-04-21 Conv 144 — [VS] Stripe miss-resilience complete: all 7 scenarios live-verified on staging (S1–S7) with constructEventAsync prod-bugfix deployed (version `254fa8e9`); Stripe Mode Discipline decision recorded (local=Test, staging=Sandbox, prod=Live); 4 Phase B follow-ups added ([VD]/[VW]/[VA]/[VL]). Deprecated RESUME-STATE.md (9 tasks to TodoWrite); test suite 6409/6409 passing. Ready for Conv 145 ([VD]→[VW]→[VA]→[VL] phase). Previously Conv 143: [VH] Stripe direct-sign webhook harness (7 commands + escape hatch); [LE] eslint-react-hooks installed (0 errors, 31 warnings).*

*Previously: 2026-04-19 Conv 137 — DOC-SYNC-STRATEGY block declared complete and archived. Phase 4 deliverables: tightened 4 chronic-noise matchers in docsRegistry (stream rule split, feed→feeds keyword fix, narrowed astro/ratings patterns, react-big-calendar isolated), expanded test suite 8→15 assertions, CI `doc-drift.yml` GH Actions workflow (PR/push-to-main cross-repo checkout), stored baseline pattern (`.drift-baseline-sha` + `advance-drift-baseline.sh` + `/r-end` auto-advance). DEPLOYMENT.GHACTIONS checklist updated: `DOCS_REPO_PAT` added alongside `CLOUDFLARE_API_TOKEN`. Two Phase-2 deferred follow-ups folded into POLISH.TECHNICAL_DEBT: `detect-changes.sh`/`dev-env-scan.sh` consolidation + `resend.md` full template-table resync.*

*Previously: 2026-04-21 Conv 145 — Phase B Stripe follow-ups complete. [VD] partial-index-predicate-matching duplicate-purchase guard in `createEnrollmentFromCheckout` + `ADMIN_ALERT` warning + test. [VW] `ctx.waitUntil()` wraps for `webhook_log` INSERT on Stripe + BBB webhooks + test helper stub real-shape. [VA] `/api/admin/stripe-mode` endpoint built + deployed to staging (Version `e5f00fb0`) + verified mode aligned (Sandbox workbench). [VL] leak audit + CLI cache refresh (PP6iSq verified absent everywhere). [FD] `memory/feedback_no_paste_tokens_in_chat.md` extended to cover Claude-initiated diagnostic leaks (unsafe patterns, safer-alternatives, redactor one-liners). New deferred block STRIPE-E2E-DEV (row #20): ~160-line comprehensive E2E testing roadmap with 4 scope tiers (A paper/B scripted/C Playwright/D Claude-MCP-driven), 11-scenario matrix, prerequisites, 7 open questions for Plan Mode, risks, references. [STRIPE-UI-UPDATE] flagged as new subtask (Stripe Dashboard UI merging Test-mode into Sandboxes listing). Baselines: tsc clean / astro 0/0/0 / lint 31 pre-existing / 6410/6410 tests passing.

*Previously: 2026-04-19 Conv 140 — CC-workflow: `/r-end` skill enhancements. (A) `/w-sync-skills r-end` identified 5 portable improvements from spt-docs and 4 HARD RULES additions; decided to evolve r-end skills independently (spt-docs r-end has >30% structural divergence — same-name skills should not be merged after 3+ months of independent evolution). Saved `feedback_skill_sync_same_name_divergence.md` to memory. (B) Added `rEnd.agentModels` config section to `.claude/config.json` (learnDecide: opus, updatePlan: haiku, docs: sonnet) with per-agent `!` backtick resolution in SKILL.md Pre-computed Context + Agent N headings. (C) Ported Step 4c REASSESS OPUS TAGS from spt-docs with Peerloop-flavored rubric examples (architectural lock-in, multi-dimension design, subtle refactors, high-stakes migrations + anti-examples). (D) `/w-sync-docs` audit (no fixes applied): TEST-COVERAGE.md has 14 cosmetic drift items (summary counts off by 1-2, phantom test entry) — test runner doesn't read these, deferring cleanup. New meta-tasks spawned: `[TC]` TEST-COVERAGE.md drift cleanup pass; `[SY]` `/w-sync-skills` divergence detection logic (>30% structural divergence flag); `[PC]` pre-computed context self-verification (lookup-key echoing for "(no X config)" false-negatives).*

*Previously: 2026-04-19 Conv 136 — CC-workflow tooling only: promoted all three v2 skill pairs to canonical names — `r-commit2/SKILL.md` → `r-commit`, `r-end2/SKILL.md` → `r-end`, `r-timecard-day2/SKILL.md` → `r-timecard-day`; deleted r-end2, r-commit2, r-timecard-day2 dirs entirely. CLAUDE.md skills table simplified (removed 3 v2 rows, updated descriptions). `[XX]` code-preservation pipeline validated end-to-end (all 4 codes `[DT]`/`[DC]`/`[DW]`/`[DV]` survived Conv 135→136 round-trip). npm install ran (package-lock drift resolved). Phase 2 detect-changes.sh follow-up updated: r-end2/scripts/ copies gone, only r-end/scripts/ copies remain.*

*Previously: 2026-04-19 Conv 135 — DOC-SYNC-STRATEGY Phase 4 planned; CC-workflow meta-improvements. First real `/r-start` SessionStart-hook run surfaced 9 drift flags — triaged 1 REAL (`session-booking.md` line 35: "4-week lookahead" → "28-day lookahead (`availabilityWindowDays` default, Conv 129)" + `maxBookingDate`/`isAtMaxMonth` month-nav cap) + 8 FALSE_POSITIVE. Authored `DOC-DECISIONS.md` Section-3 entry "Tech Doc Sweep: Vendor/Area Keyword Noise" (mirrors Auth-Doc precedent): 4 chronic-noise docs (stream/ratings-feedback/react-big-calendar/astrojs) with per-doc narrow "actually review when" triggers + 4 case-by-case docs. Verified-false sub-agent claim: Group-A Explore agent reported `feeds.md` as REAL based on Conv 130 `fetchCourseTabData` consolidation; inspection of the loader return shape proved it returns course metadata, NOT feed activities — 1/9 precision confirmed, not 2/9. Classified the Phase 1–3 system as **working scaffold, not load-bearing** (11% first-run precision + CC-only-entry assumption structurally unverifiable) and added **Phase 4 — Precision & Coverage** subsection to this PLAN.md with three active tasks: `[DT]` tighten 4 chronic-noise matchers in `docsRegistry` + regression tests, `[DC]` implement CI drift-check proactively (GH Actions cross-repo workflow), `[DW]` extend `HEAD~5` to stored-baseline state. Exit criteria: FP <20% on 3 batches / CI gates merges to main / baseline-SHA advancement proven 3+ times. Phase 3 Follow-up CI bullet promoted `[x]` with cross-ref; Phase 2 known-noise follow-up checked off. Block status row updated. Meta/tool improvements (not PLAN block work): migrated CLAUDE-SAVED.md Directive 3 (👉👉👉 prefix) to `memory/feedback_pointing_emoji_prefix.md`; saved `memory/feedback_todowrite_mnemonic_codes.md` documenting the `[XX]` 2-3-letter-code convention; patched `/r-start` Step 7 to assign codes on RESUME-STATE → TodoWrite transfer; patched `/r-end` + `/r-end2` `## Remaining` templates to preserve `[XX]` codes (pipeline-symmetry — reader + writer both now uphold the convention). `persist-project-dir.sh` added to CLAUDE.md §Startup Hooks list (previously-missing project-hook bullet). First end-to-end test of `[XX]` code-preservation is Conv 136 /r-start.*

*Previously: 2026-04-19 Conv 134 — DOC-SYNC-STRATEGY Phase 3 complete (chosen scope). Measured both drift scripts on MacMiniM4 (`tech-doc-sweep.sh` 1.3s, `sync-gaps.sh` 4.5s) — runtime inversion vs. prior PLAN framing corrected. Evaluated 4 options (CI-only / git pre-commit / both / CC SessionStart hook) and chose **Option D — CC SessionStart hook** for zero-install friction on the `peerloop`-alias workflow. Authored `.claude/hooks/tech-doc-drift.sh` wrapping `tech-doc-sweep.sh` with silent-on-clean design (presence-of-output = signal; awk-extracted flagged-doc list + resolve hints when drift exists). Wired into `.claude/settings.json` as 4th SessionStart hook, after `check-env.sh`. Smoke-tested both branches (drift: 9 flagged docs from current HEAD~5; clean: exit 0 silently via `CODE_CHANGES_OVERRIDE=README.md`). Strategy doc §4 Phase 3 rewritten with runtime table + 4-option evaluation table + chosen-D rationale + deferred-A triggers. Option A (CI drift-check) deferred with explicit reactivation triggers: non-CC commit path emerges OR 10+ convs of SessionStart gaps. Option B (git pre-commit) rejected (per-clone install friction not worth it for 2-dev-machine setup). Block remains WIP until deferred CI check and 10+ conv reliability validation complete.*

*Previously: 2026-04-19 Conv 133 — DOC-SYNC-STRATEGY Phase 2 complete. Consolidated drift-detection scripts to `.claude/scripts/` (`sync-gaps.sh`, `tech-doc-sweep.sh`, `route-mapping.txt` moved; 6 orphan duplicates deleted from `r-end/scripts/` + `r-end2/scripts/`; 5 caller sites + 4 DOC-DECISIONS.md refs + 2 live config refs updated). Authored `.claude/scripts/docs-registry.mjs` (Node ESM, no deps; 4 CLI commands: `vendor-rules`, `test-shared-basenames`, `get-group`, `list-groups`). Migrated `tech-doc-sweep.sh` + `sync-gaps.sh` to read from `docsRegistry`. **Fixed latent bug** in tech-doc-sweep: bash `${rule%%|*}` was truncating multi-alternation `codePattern`s at first `|`, silently suppressing drift signal for 60+ convs — same HEAD~5 now surfaces 9 previously-hidden flags (triaged: 2 REAL fixed this conv — `docs/reference/resend.md` added 3 SessionInvite* rows + `docs/as-designed/availability-calendar.md` 4-week → 28-day lookahead + month-nav cap; 2 PARTIAL; 5 FALSE_POSITIVE). Added `.claude/scripts/test-drift-detection.sh` (8 assertions, all pass) with `CODE_CHANGES_OVERRIDE` env-hook pattern for testability. `/w-sync-docs` SKILL.md updated with registry-scripts preamble. Wrangler installed globally (v4.83.0). Phase 3 (hook/CI integration) remains; 3 known follow-ups captured (detect-changes/dev-env-scan consolidation, resend.md full template-table resync, DOC-DECISIONS noise entry).*

*Previously: 2026-04-18 Conv 132 — DOC-SYNC-STRATEGY Phase 1 complete. Authored `docs/as-designed/doc-sync-strategy.md` (~200 lines) covering problem statement, 196-doc inventory, 4-category classification (generated/driftCheck/manual/archival), `docsRegistry` JSONC schema, 3-phase rollout, answers to all 5 open questions. Merged `docsRegistry` into `.claude/config.json` (17 groups, tech-doc-sweep rules ported 1:1). Fixed 2 stale `config.json` paths (`paths.vendorDocs` → `docs/reference/`, `paths.architectureDocs` → `docs/as-designed/`). Retired 8 `_`-prefix legacy docs (~6,265 lines: `_DB-SCHEMA`, `_API`, `_SERVER`, `_STRUCTURE`, `_RESEARCH-CLAUDE`, `_DIRECTIVES`, `_PAGES`, `_SPECS`); retained `_COMPONENTS.md` as load-bearing (referenced in `/w-add-client-note` + CLAUDE.md) — reclassified from `archival` to `driftCheck` against `src/components/**`. Saved `feedback_option_phrasing.md` memory. Block status: 🔥 WIP — Phase 1 done, Phases 2 (tool migration) + 3 (hook/CI) deferred to future convs.*

*Previously: 2026-04-18 Conv 131 — Audit-cleanup batch. [RA-SSR tail] Deleted orphaned `fetchCourseDetailData` (200 lines) + 8 CDET tests + dead imports; header docstring updated CDET → CTAB. [TDS-AUTH] auth-libraries.md rewritten 505 → 151 lines as pure decision record (stale code examples removed: wrong middleware path, JWT payload shape, fictional oauth_accounts/sessions tables, SALT_ROUNDS=12 vs actual 10, JWT audience `peerloop-users` vs actual `peerloop`); API-AUTH.md OAuth cookie names corrected (`oauth_state`/`oauth_verifier` → `peerloop_oauth_state`/`peerloop_oauth_verifier` in Google + GitHub sections); google-oauth.md cross-ref clarifying OAuth-callback vs register handle schemes. [DBAPI-SUBCOM-AUDIT] DB-API.md §Authentication rewritten (6 fictional → 10 real endpoints); §Communities rewritten (7 → 18 endpoints, Active/Proposed split). DB-API.md +218 lines of net-new doc. [DEVCOMP-REVIEW] 114 session files scanned; no actionable drift — devcomputers.md accurate. [PFC PLATO-FLYWHEEL-CREATOR-GAP] plato.md Step Catalog 20 → 25 rows + new §Creator-Lifecycle Coverage Audit section (7/18 P0 stories covered, 3 partial, 8 missing across 6 themed gap groups G1–G6, 4-tier recommendations). Open question: whether to add PLATO-EXPAND as a new block pending user scope decision.*

*Previously: 2026-04-18 Conv 130 — [RA-SSR] `fetchCourseTabData` loader collapses 6 course-tab Astro pages from ~180 → ~85 lines each. [EM] 3 session-invite email templates added (create→student, accept→teacher, decline→teacher); `decline.ts` gap fixed (added missing in-app notification to teacher). [MPT] 11 multipart upload tests with manual Uint8Array body construction (jsdom FormData bug workaround); session-invite mock updated. 6404/6404 passing, tsc clean.*

*Previously: 2026-04-18 Conv 127 (TIMECARD-V2 block completed and archived to COMPLETED_PLAN.md — parameter-driven `timecard-day.js` refactor: all project literals moved to `.claude/config.json → rTimecardDay`, predicate-driven per-H4 inclusion engine replaces tier cascade so a bullet renders in every matching H4, 2-pass engine with recursive fallthrough detection, 8 named H5/1 named H6 strategies, forked `/r-end2` + `/r-commit2` with v2 commit format (`### SECTION` H3s + `Format: v2` trailer), new `docs/reference/COMMIT-MESSAGE-FORMAT.md` spec. V1 skills untouched. Also: staging D1 reset + full seed chain (dev/stripe/booking/feeds, 2022+9+46 rows + 14 Stream activities).)*

*Previously: 2026-04-18 Conv 126 (Tooling/infra — no PLAN.md tasks. Synced r-commit/r-end/r-start/r-timecard-day skills from spt-docs; authored `timecard-day.js` (1573-line deterministic timecard script) + `r-timecard-day2` skill; fixed 3 routing bugs in timecard classifier: PLAN.md/DOC-DECISIONS.md routing via docRootExclude fix, DB Changes H4 tier, docNameWhitelist for ALL-CAPS doc stems, API Changes T3b detection guarded by !isTestRelated, infraPrefixWords for db:* scripts. All fixes verified against Apr 15 + Apr 16 timecards.)*

*Previously: 2026-04-15 Conv 125 (ROLE-AUDIT drain pass — 3 of 4 remaining RA-* follow-ups closed. [RA-RES-ROLE] dropped unused `CommunityTabs.Resource.uploadedBy.role` across 8 files (13 lines, 1 LEFT JOIN eliminated). [RA-JWT] decision recorded in `docs/DECISIONS.md` §4: keep status quo, do NOT embed `isAdmin` in JWT — refresh-token-as-auth fallback widens staleness to 7 days (not 15 min). [ADR] auth-doc review: 4 tech-doc-sweep flags are expected noise, documented in `DOC-DECISIONS.md` §5 with dismissal table. Spawned [RA-SSR-LOADER] — SSR loader admin-gate site missed by Conv 123 audit. Baselines: tsc clean / astro 0/0/0 / lint 1 pre-existing. [RA-SSR] remains as only mechanical RA-* task.)*

*Previously: 2026-04-15 Conv 124 (COMMUNITY-RESOURCES block closed — Phase 8 PLATO `upload-community-resources` step added to flywheel scenario; block fully complete and archived. [RA-CLI] `MyCourses.tsx` migrated to `useCurrentUser()`; `UserProfile.tsx` + test deleted as dead code. [RA-API] spawned + closed same conv: deleted dead `/api/me/enrollments` endpoint/tests; `/api/me/stats` discovered to have never existed. Baselines: tsc clean / astro 0 errors / 369 files 6392 tests green.)*

*Previously: 2026-04-15 Conv 123 (ROLE-AUDIT block closed — audit report produced, [RA-RO] `transformRole` extract + Astro/SSR type narrowing to `'creator' | 'member'`, [RA-ADM] 3 narrow auth helpers + 9 call-sites migrated. Block removed from DEFERRED; 4 follow-up tasks spawned ([RA-CLI], [RA-SSR], [RA-JWT], [RA-RES-ROLE]). [SGA] `sync-gaps.sh` excludes `.astro/` dirs. Full five-gate baseline green: tsc 0 / astro 0/0/0 / lint 5 pre-existing / 371 files 6447 tests / build.)*

*Previously: 2026-04-15 Conv 121 (COMMUNITY-RESOURCES Phase 9 docs complete — new `docs/as-designed/r2-storage.md` + `DB-API.md §Community Resources` 6 endpoints; only P8 (PLATO) remaining in block. Drain pass closed 21 TodoWrite items across multiple blocks (see §"Conv 121 drain pass" under COMMUNITY-RESOURCES): 6 spawned, 4 of those closed same conv, net -15. Notable: [CRES-TEST-PATH], [COURSE-RES-AUTH] (spawned edge case), Conv 110 nav staleness, [DBSCHEMA-MR/CRES/SUBCOM-DUPE], [DBAPI-SUBCOM-RENAME], [PE]+[PE-OVERRIDE], [BL] dead link, [SG/SG2] sync-gaps tighten, [AS] refresh-token fallback docs. [CSS] /discover/members clipping root-caused but fix deferred to browser-enabled session.)*

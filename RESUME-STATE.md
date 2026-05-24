# State — Conv 184 (2026-05-24 ~07:13)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Conv 184 delivered a substantial chunk of MMP-PH3 component primitives + a major audit-driven refactor. Built: SubNav primitive (strict-B from `502:12864`/`622:18616`), 4 entity leaf primitives (UserIcon with `avatarUrl?` extension, EntityPill, EntityLink, IconLabelChip), CourseAnchor (first of 9 anchor row types), and AnalyticCount. Standardized all Conv 184 primitives + MattIcon on React (.tsx) so they're consumable from both Astro and React contexts. Refactored SocialPost.tsx + _SocialPostDemo to use the new primitives — eliminated inline `Avatar()` / `ActionPill()` / `CourseEmbed()` duplicates. New standing rule: scan `<instance>` children before rendering any Figma frame, import existing components — never inline duplicates.

## Completed

- [x] [MATT-EXEC-CMP-SNV] SubNav primitive (strict-B mirror, base + Selected-expanded variants)
- [x] [CMP-UICN] UserIcon (40×40 initials avatar)
- [x] [CMP-UICN-IMG] UserIcon extended with `avatarUrl?` for image-mode (documented extrapolation)
- [x] [CMP-EPILL] EntityPill primitive
- [x] [CMP-ELINK] EntityLink primitive
- [x] [CMP-CHIP] IconLabelChip primitive
- [x] [CMP-ANALYTIC] AnalyticCount primitive (extracted from SocialPost ActionPill inline)
- [x] [CMP-ANCH-COURSE] CourseAnchor first anchor row
- [x] [REFACTOR-SOCIALPOST] SocialPost.tsx + _SocialPostDemo refactored to use primitives
- [x] All Conv 184 primitives + MattIcon standardized on React (.tsx)
- [x] `.entity-student-teacher` alias in tokens-semantic.css
- [x] /matt/ design-review page Conv 184 showcase (6 new Card sections)
- [x] New standing rule: `feedback_reuse_existing_components.md`

## Remaining

🔝 **LEAD next-conv task:** [MMP-PH4] Phase 4 — re-render Course In Feed (`519:9096`) using the new primitives + visual diff. With CourseAnchor + the 4 leaf primitives + AnalyticCount in place, the test target is empirically buildable. [Opus] tagged — involves the `[CMP-ICN-REGISTRY]` decision (whether to promote Arrow/Level/Bookmark variants to component primitives or keep flat names) based on observed re-render fidelity.

**MMP mini-plan continuation:**
- [ ] [MMP-PH3] Phase 3: Component primitives — parent block; substantial progress this conv (6 new primitives), 8 anchor rows + Chat + Brand remain
- [ ] [MMP-PH4] [Opus] Phase 4: Re-render test — Course In Feed (519:9096) + translate + visual diff
- [ ] [MMP-PH5] Phase 5: Graduation — promote scratch + Content/Happy/Home re-render

**New components remaining (Q1 audit):**
- [ ] [CMP-CHAT] Build Chat (Chat Bubble) primitive — 2 variants Default/Us from `646:7540`
- [ ] [MATT-EXEC-CMP-BRN] Brand component verification (Logo + Logo Mark)
- [ ] [CMP-ANCH-REST] Remaining 8 anchor row components (Creator, Certification, Module, Resource, Review, Student-Teacher, Video Clip, Milestone)

**Pre-strict-B refactors (Q2 audit residue):**
- [ ] [REFACTOR-COURSEHEADER] CourseHeader.astro — replace inline elements with UserIcon + EntityPill + EntityLink
- [ ] [C178-REVAL] [Opus] Re-validate Conv 178 "reconnaissance" claims via current MCP probes (Module.tsx, ToDoItem.tsx, SectionTitle.astro, SocialPost composition fidelity)

**Decision tracking (folded into mini-plan):**
- [ ] [CMP-ICN-REGISTRY] [Opus] Registry shape deferred to MMP-PH4 empirical re-render
- [ ] [CMP-EXT-ICN] Incremental Material harvest (decided = A), ongoing during Phase 5

**Phase 5-7 carryforward:**
- [ ] [MATT-EXEC-FLAGS] Verify 4 route-shape assumptions before Phase 5
- [ ] [MATT-EXEC-PG2] Phase 5: build 11 remaining /matt/* routes (thin-shell page assembly)
- [ ] [MATT-EXEC-EXT] [Opus] Phase 6: extrapolation primitives (11 categories Matt didn't draw); speculative Conv 172 alert tokens verified-or-removed here; hover-color-extrapolation for Button non-Primary variants; UserIcon image-avatar Phase 6 cleanup
- [ ] [MATT-EXEC-GRD] Phase 7: doc graduation
- [ ] [MATT-COURSE-POLISH] Body polish on /matt/course/[slug]
- [ ] [MATT-CREATOR-TAB] /matt/course/[slug]/creator route
- [ ] [MATT-ICON-SWAP] Hero overlay inline-SVG → icon-system in Phase 6
- [ ] [RTB] [Opus] Role Tab Bar design-spec

**User-supplied later:**
- [ ] [MDR] Dev-Ready frames lookup (user-supplied, later)

**Watch tasks (carrying forward):**
- [ ] [MCP-SEL-MISFIRE] Watch for repeat Figma MCP selection-state proxy misfires. Conv 184 adds 15+ new data points of `get_design_context` succeeding WITHOUT pre-selection. Probably time to relax `reference_figma_mcp_behavior.md` next conv.
- [ ] [LH-VERIFY] Verify Figma `lineHeight:100` interpretation as ratio 1.0 against rendered Matt designs (load-bearing for MMP-PH4 visual diff)
- [ ] [MEM-CAP-WATCH] Monitor MEMORY.md cap; prune by Conv 190 if growth continues — currently 63% lines / 71% bytes post-Conv-184. 1 new memory file added (`feedback_reuse_existing_components.md`).

## TodoWrite Items

All 21 pending tasks above are persisted here and will be re-loaded into TodoWrite by `/r-start` Step 7. Codes preserved verbatim per `feedback_todowrite_mnemonic_codes.md`. `[Opus]` suffixes preserved (5 tasks: #2 MMP-PH4, #4 CMP-ICN-REGISTRY, #13 MATT-EXEC-EXT, #18 RTB, #22 C178-REVAL).

## Key Context

- **Conv 184 will be committed in Step 6 of this /r-end.** Docs repo: 1 modified (matt-design-system.md +193 lines), 1 deleted (RESUME-STATE.md from /r-start), plus untracked new Extract/Learnings/Decisions/screenshots + new memory file + this RESUME-STATE.md + PLAN/DECISIONS/DOC-DECISIONS/TIMELINE updates. Code repo: 7 modified, 1 deleted (MattIcon.astro), 8 new (.tsx files). Memory mirror sync runs in Step 5b before commit.

- **Architecture standardization Conv 184: primitives in React (.tsx), page-wrappers in Astro.** Astro renders React components as static HTML by default — zero hydration cost. React can't import Astro, so primitives (which may be consumed from both contexts) must be React. Pattern: `<Button variant="course" href={href}>...</Button>` works identically in both file types; Astro callers pass `className` (React prop name) not `class`.

- **New standing rule:** `feedback_reuse_existing_components.md` — before rendering any Figma frame, call `get_metadata` and audit every `<instance name="…">` child. Each instance name maps to an existing imported component or surfaces as a missing-primitive gap. NEVER inline a duplicate of an existing primitive. Astro/React boundary is NOT a valid friction reason — Astro renders React statically.

- **Entity cascade fully wired** in `tokens-semantic.css` — parent applies `.entity-course | .entity-creator | .entity-student | .entity-student-teacher` class, child primitives consume `bg-entity-background` and `text-entity-primary` (Tailwind utilities wrapping `--Entity-Background` / `--Entity-Primary` vars). Student-Teacher aliases Student (probed Conv 184 — Matt drew them with identical colors).

- **SocialPost API breaking changes** (Conv 184 refactor): `SocialPostAuthor.roleIcon: ReactNode` → `SocialPostAuthor.roleIconName?: string` (MattIcon name); `commenters: SocialPostCommenter[]` prop REMOVED (Matt didn't draw the avatar-preview strip); added `loves?: number` to match Matt's 3-badge footer (`516:15859`). Only caller (`_SocialPostDemo.tsx`) updated.

- **CourseAnchor.tsx uses `<Button variant="course" property1="Default">` for its CTA** — Conv 184 retroactive application of `feedback_reuse_existing_components.md` to the just-built component. The earlier inlined CTA styling was replaced.

- **9 distinct anchor row components, no shared `AnchorRow` base** — Conv 184 user decision Option C. Each anchor type is its own React component composing from leaf primitives. CourseAnchor is the first; 8 remaining (`[CMP-ANCH-REST]`) follow the same pattern but with content-type-specific layouts.

- **MEMORY.md cap at 71% bytes** (estimated post-Conv-184). One new memory file added: `feedback_reuse_existing_components.md`. Index line added to MEMORY.md. Under 80% cap. Monitor via `[MEM-CAP-WATCH]`.

- **Figma `<instance>` is the load-bearing translation key.** Matt's `data-name="User Icon"`, `data-name="Entity Pill"`, `data-name="Analytic Count"`, `data-name="course"`, `data-name="Button Primary"` etc. mark his component-library reuse boundaries. These are how we know which code primitive to import on every Figma render.

- **Astro `as Props` assertion pattern** — `const { ... } = Astro.props as Props;` needed for Astro's TS narrowing through default-value destructuring (otherwise the `Props` interface reads as unused AND inferred types fall back to `any`). Card.astro works without it; HeaderBar.astro + Conv 184 SubNav.astro/SubNavItem.astro require it. Document in matt-design-system.md updated this conv.

- **Conv 178 factual-error pattern repeated Conv 184.** Conv 178 wrongly claimed Button had "3 orthogonal dimensions"; Conv 184 initially assumed UserIcon was a role-icon container before probing. Both errors came from visual-inspection inferences without `get_design_context`. `[C178-REVAL]` watch task tracks; potential `feedback_external_source_of_truth_first.md` strengthening flagged as uncategorized observation.

- **`get_design_context` selection-required claim further weakened.** Conv 184 ran 15+ successful calls WITHOUT pre-selecting any Figma node. `reference_figma_mcp_behavior.md` still claims selection is REQUIRED. Strong evidence for relaxing the rule next conv via `[MCP-SEL-MISFIRE]` watch task.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.

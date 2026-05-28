# Phase 4.5 — Component import [MATT-EXEC-CMP] + MMP

**Status:** ✅ SUBSTANTIALLY COMPLETE (Conv 185, 13/13 Matt-named primitives built; MMP-PH4 re-render gate Conv 187)
**Family:** matt
**Spec:** `docs/as-designed/matt-pre-plan.md` §9 (Phase 4.5 inserted between Phase 4 and Phase 5)
**Components code:** `src/components/matt/ui/*` (now under `src/components/ui/*` post-Conv 197 flip)

---

## Summary

Phase 4.5 was inserted between Phase 4 (primitives) and Phase 5 (remaining pages) so the components Phase 5 pages assemble would all exist first. Spawned Conv 178 with 8 dependency-ordered subtasks (ICN → BTN → MNV → SNV → ENT → CHAT → ANCH-REST → BRN). **Conv 185:** 13/13 Matt-named primitives built. **Conv 187 MMP-PH4:** re-render test (Course In Feed `519:9096`) confirmed pipeline works end-to-end. Remaining gaps are Phase 6 extrapolation work ([DARK-HERO-VARS] ✅ Conv 187; [VIDEO-COMMENT-ICN], [PLAY-CIRCLE-ICN] pending; see [phase-6-ext.md](phase-6-ext.md)).

The **MATT-DESIGN-PUSH Mini-Plan (MMP)** is a 6-phase sequence (PH0–PH5) spawned Conv 180 to bridge from Figma MCP unlock to a reproducible single-page MCP-driven re-render workflow before resuming Phase 4.5 bulk work. PH4 was the re-render gate; PH5 is graduation (scratch → docs/reference promotions) — still pending.

## Per-subtask pattern

Open Figma SVG → `qlmanage -t -s 1200 -o /tmp <file>.svg` SVG→PNG inspection (per [MPV]) → spec variants/props/breakpoints/states → build .tsx (React island) or .astro (static) in `src/components/matt/ui/` for primitives or `src/components/matt/` for composites → add to `/matt/index.astro` showcase section → visual-diff vs SVG → all 5 baseline gates green.

## Subtask checklist (Matt's Components page)

- [x] **[MATT-EXEC-CMP-ICN]** Conv 178 harvest + Conv 182 code-integration **COMPLETE** — folded into [MMP-PH2]. Harvest (Conv 178): 39 icons extracted from Figma with uniform `viewBox="0 0 24 24"`, 19 renames with 3 Material-Icon→Matt-label semantic corrections, Property-1 variants flattened to Arrow/Level/Bookmark, `_INDEX.md` documents catalogue-label-is-authority rule. Code-integration (Conv 182): `src/components/matt/icons/MattIcon.astro` consumer via Vite `?raw` glob + 39 SVGs in `svg/` subdir; fills normalized to `currentColor` (1 MD3 `#1C1B1F` outlier caught + fixed). See MMP-PH2 below.
- [x] **[MATT-EXEC-CMP-BTN]** Conv 183 — Buttons COMPLETE. `Button.tsx` rewritten with **strict-B 5-value `property1` enum** (`Default | Hover | Large | Small | SmallHover`) mirroring Matt's Figma Property 1 exactly (Conv 178's "3-orthogonal" framing retracted as misframed — Property 1 conflates State + Size). All CSS extracted via MCP probes of 5 Figma nodes (`40:482` section + `1:284` Default + `513:14820` Hover + `1:292` Large + `360:11906` Small + `675:12314` SmallHover). 6 Color variants preserved; Hover/SmallHover use inline-style hardcoded gradient + border (Matt's design has partial coverage — Hover is Primary-only with no Variable Mode awareness; non-Primary + Hover combos render Primary-darkened, Phase 6 [MATT-EXEC-EXT] for variant-aware extrapolation). Disabled kept as standard a11y orphan via `[disabled]` CSS rule.
- [x] **[MATT-EXEC-CMP-MNV]** Conv 183 — Main Nav COMPLETE. 3 new components: `MainNav.tsx` (props-driven orchestrator, exports `NavItemData`/`NavSubItemData` interfaces), `NavItem.tsx` (3 Property 1 variants: Default+Selected flat row, Main = white pill with parent + divider + Sub Nav slot), `NavSubItem.tsx` (2 Property 1 variants: Default+Selected, color shift only). Architecture decisions (D1/D2/D3) made via AskUserQuestion + ASCII mockup previews — established new collaboration pattern. **D1 = Route-driven Main pill** (auto-positions around active section, derived state, no toggle), **D2 = Keep 70px collapse mode** as Peerloop extension (Sidebar.tsx renders separate icon-only nav when collapsed since 220px Matt layout doesn't compress gracefully), **D3 = Props-driven** data model (`items: NavItem[]` enables Admin/Teacher sidebar variants from one component). `Sidebar.tsx` refactored to consume `MainNav`.
- [x] **[MATT-EXEC-CMP-SNV]** Conv 184 — Sub Nav COMPLETE. Rewrote `SubNav.astro` container + new `SubNavItem.astro` (3 Property 1 variants Default/Hover/Selected + Selected-with-subnav expanded). Resolved Conv 183 "Need 3+ Levels" open question via Figma probe — NOT multi-level, it's base + Selected-expanded. Switched container to `currentPath`-derived active state (fixing latent Conv 175 bug where `active` per-item was never consumed).
- [x] **[CMP-UICN]** / **[CMP-EPILL]** / **[CMP-ELINK]** / **[CMP-CHIP]** Conv 184 — 4 leaf primitives from Entities collection decomposition (Option C per user direction). React .tsx files at `src/components/matt/entity/`. **[CMP-CHIP]** IconLabelChip is the deliberate strict-B deviation (Matt didn't name it as a Figma component, user "make these reusable" directive justifies; honest-orphan marker in file header).
- [x] **[CMP-ANCH-COURSE]** Conv 184 — CourseAnchor COMPLETE (first anchor row of 9). Composes UserIcon + EntityPill + IconLabelChip + Button + MattIcon. Locks in Option C architecture: 9 distinct anchor row components, no shared `AnchorRow` base.
- [x] **[CMP-ANALYTIC]** Conv 184 — AnalyticCount COMPLETE. Extracted from SocialPost.tsx inline `ActionPill()` helper. Two variants Default and `1+` with auto-flip behavior.
- [x] **[CMP-UICN-IMG]** Conv 184 — UserIcon extended with `avatarUrl?` for image-mode (strict-B extrapolation; header annotated). Pulled forward from Phase 6 because SocialPost refactor needed real user images.
- [x] **[REFACTOR-SOCIALPOST]** Conv 184 — SocialPost.tsx + _SocialPostDemo.tsx fully refactored to use Conv 184 primitives. Removed inline duplicates (Avatar, ActionPill, LikeIcon, CommentIcon). Breaking API: `roleIcon: ReactNode` → `roleIconName?: string`, added `loves?: number`, removed `commenters` prop. All Conv 184 primitives + MattIcon standardized on React (.tsx) — 6 .astro files converted and deleted.
- [x] **[CMP-CHAT]** Conv 185 — Chat Bubble primitive COMPLETE. 2 variants Default/Us from Matt's `646:7540`. **Drift from strict-B:** dropped Matt's 159px canvas width in favor of `inline-flex max-w-[280px]` content-sizing (Matt's 159px is a Figma drawing placeholder, not a UX rule); documented in component docstring.
- [x] **[CMP-ANCH-REST]** Conv 185 — All 8 remaining anchor row components COMPLETE. CreatorAnchor / CertificationAnchor / ModuleAnchor / ResourceAnchor / ReviewAnchor / StudentTeacherAnchor / VideoClipAnchor / MilestoneAnchor. 8 Card showcases added to `/matt/`. Screenshot confirms all 8 render correctly. (Locks in Option C: 9 distinct anchor row components, no shared base.)
- [x] **[REFACTOR-COURSEHEADER]** Conv 185 — Creator section refactored to UserIcon + EntityPill + EntityLink trio in `.entity-creator` cascade per new reuse rule. Spawned [DARK-HERO-VARS] for the rating/level/CTA carve-out (closed Conv 187). **Reversed Conv 187** — CourseHeader re-validated to Matt's Default frame (creator trio belongs in future "Meet the Creator" tab; CourseHeader uses white IconLabelChip ×4 on-dark). See [phase-3-pg1.md](phase-3-pg1.md).
- [x] **[MATT-EXEC-CMP-BRN]** Conv 185 — Brand primitive COMPLETE. Probed Matt's Brand section (`40:481`) containing Logo (`1:270`, 3 variants Large/Medium/Small) and Logo Mark (`35:144`, 3 variants Default/Medium/Small). Downloaded 4 SVGs (curl revealed Figma MCP asset URLs return SVG for vector sources). Wrote `LogoMark.tsx` and `Logo.tsx`. Refactored `Sidebar.tsx:85-91` from placeholder `∞ PeerLoop` text. Final Components-page status: 100% Matt's named primitives built (13/13).

## MMP-PH0 through MMP-PH4

- [x] **[MMP-PH0]** Conv 181 — Phase 0 Discovery COMPLETE. Routes audited (2/12 scaffolded); components inventoried (1 layout + 14 components); tokens audited (3-tier cascade in place from Conv 172). Re-render target picked: **Course In Feed (`519:9096`)** — smaller surface, exercises Variable Mode + icons + 2 primitives.
- [x] **[MMP-PH1]** Conv 181 — Phase 1 Token foundation COMPLETE. Color + Typography Variables both fully canonized. (Detail in [phase-1-tokens.md](phase-1-tokens.md).)
- [x] **[MMP-PH2]** Conv 182 — Phase 2 Icon registry COMPLETE. **Chose Option B: SVG-files-as-source-of-truth via Vite `?raw` glob** (not path-extracted TS registry — keeps Matt's exact artifact canonical per Conv 181 tokenize-only-matt-variables / honest-orphan principle). `src/components/matt/icons/svg/*.svg` (39 files) + `MattIcon.astro` consumer. Fill normalization via perl-pi `s/fill="#414141"/fill="currentColor"/g` (38 files); 1 outlier `info.svg` carried `fill="#1C1B1F"` (Material Design 3 `on-surface` default, direct Material Icons export) caught by distinct-fill audit and normalized. Trade-off accepted: no compile-time `MattIconName` union (runtime lookup + dev-only warn).
- [x] **[MMP-PH3]** Conv 185 — Phase 3 Component primitives COMPLETE — all 13 of Matt's named primitives built across Convs 183-185 + audit-driven re-validation (`[C178-REVAL]`: Module + ToDoItem refactored to strict-B, dropped over-engineered `entity` prop; SectionTitle name-collision documented).
- [x] **[MMP-PH4]** Conv 187 — Phase 4 Re-render test COMPLETE. Picked Course In Feed (`519:9096`, Default variant of set `502:12911`; Mobile variant deferred to Phase 6). Built `CourseInFeed.tsx` (props-driven dark-hero feed card composing EntityPill + 4 on-dark IconLabelChips + course Button + MattIcon). Re-render gate surfaced two assumptions: (1) 20-vs-24 icon-grid registry mismatch → empirically resolved `[CMP-ICN-REGISTRY]`; (2) CourseHeader creator-trio drift → CourseHeader re-validated to Matt's Default frame. Live-verified in Chrome bridge (245px height matches Matt's instance exactly). Committed `ead81ada` + `cea3def0`.
- [ ] **[MMP-PH5]** Phase 5 Graduation — promote `.scratch/matt-figma-pages.md` → `docs/as-designed/matt-figma-pages.md`; supersedes `matt-figma-extraction-today.md` (done as `[MFE-STALE]` Conv 182); promotes Figma MCP setup walkthrough (done as `[MCP-DOC]` Conv 182); rolls forward to remaining 11 Phase 5 pages via MCP. (Blocked by [MMP-PH4] — now unblocked.) **Conv 191: promotion half also machine-pinned** — the source `.scratch/matt-figma-*.md` files live ONLY on MacMiniM4 (gitignored, never synced); scratch→docs graduation must run on the authoring machine, not MacMiniM4Pro.

## Conv 178 — Phase 4.5 scoped + ICN harvest + pivots

- Phase 4.5 [MATT-EXEC-CMP] scoped — 8 dependency-ordered subtasks inserted between Phase 4 (PRM-2 complete) and Phase 5 (PG2 pending). matt-pre-plan.md §9 row added; total convs estimate revised 8–11 → 10–15.
- [MATT-EXEC-CMP-ICN] harvest phase: 39 icons extracted from Figma with uniform `viewBox="0 0 24 24"` (Include-bounding-box ✅ load-bearing); 19 renames executed with 3 Material-Icon → Matt-label semantic corrections (newspaper→feed, mail→message, calendar→calendar_month); Property-1 Component variants flattened to Arrow/Level/Bookmark groups; mystery Vector.svg labelled `user-icon`; `_INDEX.md` documents catalogue-label-is-authority rule + Primary (8) + Secondary (31) sections.
- Time-bounded resource harvest pivot — mid-conv discovered Figma Dev Mode trial ends today; drafted `.scratch/matt-figma-extraction-today.md` (~250 lines, 3-tier priority structure); pre-created 9 subfolders. Pro-account pivot superseded the deadline framing but the harvest workflow established the pattern.
- Buttons reconnaissance discovered 3-orthogonal-dimension architecture — later retracted Conv 183 (`property1` is a 5-value enum, NOT 3-orthogonal).
- Pro account pivot — MCP setup required between convs.

**Decisions:**

- **Insert Phase 4.5 [MATT-EXEC-CMP] between Phase 4 and Phase 5** — Phase 5 = 12 routes across multiple convs; without CMP, each route fragments component-build decisions across convs and risks inconsistency. Numbering as 4.5 (not re-numbering 5→6) keeps `matt-pre-plan.md` §9 phase anchors stable.
- **Dependency-ordered CMP subtasks with Icons foundational** — Icons consumed by every other component (Buttons icon-leading, Main Nav, Sub Nav, Chat, Post Anchors); wired in TodoWrite as #34/#35/#36/#38/#39 blocked by #33.
- **Catalogue-label-is-authority for naming** — Matt's catalogue labels override both Figma's auto-export filenames AND visual-inference guesses.
- **End Conv 178; configure Figma MCP between convs; /r-start fresh with MCP active.**

**Patterns:**

- **Figma export `Include bounding box ✅` is load-bearing for icon systems** — Without it, Figma exports SVGs tight to visible geometry → per-icon `viewBox` varies → `<Icon class="h-6 w-6" />` renders different visual sizes. Default ON for icon batches; default OFF for illustrations.
- **Phase X.5 numbering for inserting a phase between locked phases** — preserves anchor stability vs re-numbering. First instance: Phase 4.5 between Phase 4 (PRM-2) and Phase 5 (PG2).
- **MCP load is a session-boundary affair, not a runtime one** — MCP configuration must be in place before session start.

## Conv 179 — [MCP-SETUP-WALK] + memory cap watch

- `[MCP-SETUP-WALK]` Walkthrough authored + executed for primary path; OAuth deferred to Conv 180. **Pivot mid-conv:** original plan was the Figma *local* Dev Mode MCP (desktop install + Dev seat + manual `settings.json` edit). User pointed at Figma's live docs (`developers.figma.com/docs/figma-mcp-server/`) which recommend the *remote* hosted MCP. v2 walkthrough rewritten at `.scratch/figma-mcp-setup.md` (no Figma desktop or Dev seat required).
- `[MCP-INSTALL]` + `[MCP-CONFIG]` executed via `claude mcp add --transport http figma https://mcp.figma.com/mcp` (registered in `~/.claude.json` project-scoped to peerloop-docs).
- `[MCP-VERIFY]` (still pending) — requires fresh CC session to surface the entry; OAuth (`/mcp` → figma → Authenticate → browser Allow) is the Conv 180 lead.
- **Learning:** CC loads MCP server list once at session start; `claude mcp add` writes to disk but does not hot-reload — plan MCP setup around `/r-end` → exit → `/r-start` boundaries.

**Open (non-MATT):**

- [ ] **[ASF]** Investigate `Astro.slots.has` + `&&` short-circuit interaction surfaced Conv 175 [MSH-VIZ] empty-pill bug. Production workaround in place. Root-cause investigation deferred. Captured in `memory/reference_astro_slot_forwarding.md`.
- [ ] **[TDS-DRIFT]** `tech-doc-sweep` hook returned no recent changes despite the substantial `matt/*` additions across Convs 173-178. Investigate drift baseline SHA or sweep matchers.
- [ ] **[MEM-CAP]** Schedule a `/r-prune-claude` pass when MEMORY.md auto-load utilization climbs above 80% (Conv 179 baseline: 59% lines / 57% bytes). **Done Conv 206 [MEM-CAP-WATCH].**
- [ ] **[INV-PATH-FIX]** Sweep `.scratch/matt-figma/` references in code/docs → `.scratch/matt-main/`. (`matt-figma` was the initial 229-file Figma export Conv 169; `matt-main` is the curated 83-file build set from Conv 170 [MATT-ISOLATE].)

## Conv 180 — Figma MCP activation + mini-plan + 2 decisions

- `[MCP-VERIFY]` Figma Remote MCP authenticated and verified. User completed OAuth via `/mcp` BEFORE invoking `/r-start`; `claude mcp list` confirmed `figma: ✓ Connected`; 10+ `mcp__figma__*` tools surfaced; `mcp__figma__whoami` confirmed user has **Dev seat** on Peerloop org (pro tier) — Phase 4.5 work unblocked immediately.
- `[MEM-DRIFT-ICN]` MEMORY.md "Icon System" line corrected: `~35 entries → 10 entries`.
- `[MFP]` Page URL lookup stored at `.scratch/matt-figma-pages.md` — 9-page table.
- `[CMP-VAR-PROMOTE-DECISION]` Decided A: flat icons. 9 variant entries in registry; trade-off accepted (dynamic usage requires string concatenation).
- **MMP 6-phase sequence spawned** — bridges from Conv 180's Figma MCP unlock to a reproducible single-page MCP-driven re-render workflow before resuming Phase 4.5 bulk work.

**Decisions:**

- **Use Dev seat (not Full seat) for Figma MCP work** — Dev seat provides all reads needed and removes accidental-edit risk at the API boundary.
- **`[CMP-EXT-ICN] = A`** incremental Material icon harvest — when MCP output contains an unfamiliar `data-name`, query that node directly via MCP, extract SVG path, add to icon registry. Per-icon cost small. (Later DELETED Conv 186 — replaced by 5 specific harvest tasks + drift-check side-effect rule.)
- **Storage location for Figma URL lookups: `.scratch/matt-figma-pages.md`** — gitignored, persistent across convs.

**Patterns (`reference_figma_mcp_behavior.md` evolution):**

- **Figma Remote MCP is link-based by design — don't enumerate.** Per Figma docs: *"The remote Figma MCP server is link-based."* User copies a Figma link, pastes URL, AI queries that specific node. Ask user for page URLs upfront.
- **MCP `get_design_context` output shape varies by node type.** Section nodes return sparse metadata. Component variant nodes return typed React with inferred props. Page/card nodes return inlined HTML+CSS with `data-name` attributes.
- **Translation is mandatory — there is no paste-in workflow.** MCP renders icons as `<img>` with expiring asset URLs (7-day signed Figma S3 links); registry-key naming is DECOUPLED from MCP output. The `data-name` attribute IS the translation key.
- **Variable Mode bakes into CSS-var fallback hex.** MCP renders CSS variables with the parent context's Variable Mode resolved into the fallback (e.g., Course card has `var(--background,#e8f4df)`).
- **Verify external tool behavior empirically before recommending** — Made 4+ recommendations this conv about Figma MCP that were all reversed by next probe. One tool call beats one rework cycle. Captured as [EMP] in `feedback_external_source_of_truth_first.md`.
- **Matt's "Ready for Dev" labels are human-visible, not API-readable** — Matt erects green-banner "Ready For Dev" label frames; Figma's built-in frame-level Dev-Ready flag is NOT used.
- **Matt thinks in Figma at all times** — captured as `project_matt_collaboration_style.md`.

## Conv 181 — MMP-PH1 + standing principle

- `[MMP-PH0]` Discovery COMPLETE; `[MMP-PH1]` Token foundation COMPLETE. (Detail in [phase-1-tokens.md](phase-1-tokens.md).)
- `[NOTE-YELLOW]` Resolved by hardcoding inline. (Detail in [phase-4-prm.md](phase-4-prm.md).)
- `[MCP-DRIFT-180]` `memory/reference_figma_mcp_behavior.md` rewritten from 56 → 75 lines. Two tool classes documented: **selection-free** vs **selection-required**. (Later retired Conv 187 — ALL tools are selection-free with explicit nodeId.)
- **NEW STANDING PRINCIPLE: tokenize only Matt's Variables** — `memory/feedback_tokenize_only_matt_variables.md` (50 lines) establishes the rule for all future /matt/* token decisions.

## Conv 182 — MMP-PH2 + 5 doc graduations + `[CASCADE-BROKEN]` closed

- `[MMP-PH2]` Icon registry COMPLETE — 39 SVGs ported to `src/components/matt/icons/svg/`; `MattIcon.astro` Vite `?raw` glob consumer; fill normalization with `info.svg` outlier `#1C1B1F` MD3 on-surface caught.
- `[MATT-EXEC-CMP-ICN]` Code-integration phase folded into `[MMP-PH2]`.
- `[MEM-IP-DRIFT]` MEMORY.md "Icon System" line corrected — 39 entries (5 directional + 4 nav + 4 people + 4 content + 16 objects + 3 community + 3 brand). Conv 180 `[MEM-DRIFT-ICN]` claim was wrong.
- `[MFE-STALE]` Stale `.scratch/matt-figma-extraction-today.md` deleted.
- `[MDS-CASCADE-VALIDATED]` `matt-design-system.md` §5 Entity cascade caveat reframed. `[CASCADE-BROKEN]` closed — Matt's button CSS uses `var(--Background)`/`var(--Border)` (variant-scoped variables tied to `variant` prop), NOT `var(--Entity-Background)`/`var(--Entity-Primary)`. Cascade was never wired into Matt's button design.
- `[MDS-BTN-3D]` matt-design-system.md §5 Button section updated with Conv 178 3-orthogonal callout (later retracted Conv 183).
- `[MATT-RT-DOC]` matt-pre-plan.md §2 Route Map "Implementation status (as of Conv 182, MMP-PH2)" subsection added.
- `[MCP-DOC]` New canonical `docs/reference/figma-mcp.md` created consolidating walkthrough + behavior reference.

**Decisions:**

- **Matt-namespaced icon registry uses SVG files as source of truth (Vite `?raw` glob), not path-extracted TS registry (Option B)** — Aligned with Conv 181 tokenize-only-matt-variables / honest-orphan principle.
- **`[CASCADE-BROKEN]` closed** — Multi-variant primitives like Buttons use parallel-but-independent variant-prop mechanism. Reserve entity cascade for components Matt explicitly wired with `--Entity-*` variables.

**Patterns:**

- **Hex fill audit before bulk-rewrite catches Material-Icons paint defaults** — Direct Material Icons exports may carry `#1C1B1F` (MD3 on-surface). Run distinct-fill audit BEFORE assuming a single hex value covers all icons.
- **Vite `import.meta.glob('./svg/*.svg', { query: '?raw', import: 'default', eager: true })`** for inline-SVG icon registries.
- **Astro `interface Props` triggers ts(6196) when not referenced through type composition** — Fix: add `as Props` to the `Astro.props` destructuring line.
- **Doc graduation flow: scratch (staging) → memory (recall-shorthand) → docs/reference (canonical).** Memory file stays after graduation; scratch source goes.
- **Figma MCP `get_variable_defs` is selection-bound — token-verification has no direct MCP call.** Workaround is the **visual-absence heuristic**: if no layer uses red/pink, `--carmine-red` is effectively absent.

## Conv 183 — MMP-PH3 (Button + MainNav)

- `[MATT-EXEC-CMP-BTN]` Button COMPLETE — strict-B 5-value `property1` enum. (Detail in subtask checklist above.)
- `[MATT-EXEC-CMP-MNV]` MainNav COMPLETE — D1/D2/D3 via AskUserQuestion + ASCII mockup previews.
- `[MCP-SEL-MISFIRE]` Watch task: 8 successful `get_design_context` calls without user pre-selection, contradicting Conv 180 selection-REQUIRED claim. Logged as ongoing watch (later closed Conv 187).
- **Figma is read-only — never call write-shaped MCP tools** — User: *"We are not to change Figma at all."* Saved as `memory/feedback_never_modify_figma.md`.

**Patterns:**

- **Empirical MCP probe trumps inferred architectural documentation** — Conv 178 "3-orthogonal Button" claim was a logical projection without probing; one MCP `get_metadata(40:482)` call revealed it as wrong. **Probe THEN write the spec, never the inverse.**
- **ASCII mockups via AskUserQuestion `preview` field for visual decisions** — render Matt's Figma reference in ASCII + each candidate option side-by-side; user picks visually.
- **Matt's design system has partial state-by-color coverage** — Hover variant Variable-Mode-aware-ness checks must run per-state independently. Per tokenize-only-matt-variables: mirror Matt's partial coverage literally; flag gap in component comment for Phase 6.
- **Doc graduation for component primitives** — when a Matt primitive lands, add a formal `### <Component> (extracted Conv NNN)` subsection in `matt-design-system.md`.

## Conv 184 — MMP-PH3 (SubNav + Entity decomposition + SocialPost refactor + new standing rule)

- `[MATT-EXEC-CMP-SNV]` SubNav COMPLETE; `[CMP-UICN]`/`[CMP-EPILL]`/`[CMP-ELINK]`/`[CMP-CHIP]` 4 entity leaf primitives; `[CMP-ANCH-COURSE]` CourseAnchor; `[CMP-ANALYTIC]` AnalyticCount; `[CMP-UICN-IMG]` UserIcon image-mode; `[REFACTOR-SOCIALPOST]`.
- All Conv 184 primitives + MattIcon standardized on React (.tsx). 6 .astro files converted and deleted.
- `tokens-semantic.css .entity-student-teacher` alias added (Matt uses Student's colors for Student-Teacher).

**Decisions:**

- **Standardize primitives on React (.tsx)** — All design-system leaf primitives are React. Astro page-wrappers may import and render as static HTML at SSR (no JS bundle cost unless `client:*` directive).
- **9 distinct anchor row components, no shared `AnchorRow` base (Option C)** — Per tokenize-only-matt-variables: extract what Matt named.
- **Extract IconLabelChip despite Matt not naming it** — User directive "make these reusable" overrides strict rule. 25+ instances. Honest-orphan annotation in file header.
- **New standing rule: scan `<instance>` children, import existing primitives, never inline duplicates** — Codified as `memory/feedback_reuse_existing_components.md`.

**Patterns:**

- **Primitives in React (.tsx), page-wrappers in Astro** — design-system architectural rule.
- **Scan `<instance>` children before rendering** — every Figma instance maps to an imported component or surfaces as a missing-primitive gap.
- **`data-name` is Figma's reliable component-instance label** — even when rendered markup is a generic `<div>`.
- **Strict-B mirroring catches latent bugs as a side-effect** — Conv 175 SubNav `active?` per-item bug was invisible until Conv 184 forced a Figma-grounded rewrite.

## Conv 185 — MMP-PH3 audit-driven follow-throughs (5 in one conv)

- `[MATT-EXEC-CMP-BRN]` Brand primitive COMPLETE (Logo + LogoMark).
- `[CMP-CHAT]` Chat Bubble COMPLETE.
- `[C178-REVAL]` Re-validate Module / ToDoItem / SectionTitle / SocialPost against Matt's Figma. Conv 178 drift found in 3; rewrote Module + ToDoItem to strict-B; SectionTitle name-collision documented (Matt's = Figma dev-status banner, ours = generic content heading — separate purposes).
- `[REFACTOR-COURSEHEADER]` Creator section refactored (later reversed Conv 187).
- `[CMP-ANCH-REST]` All 8 remaining anchor rows in single batch.

**Decisions:**

- **Sequence the 5 audit items: BRN → CHAT → C178-REVAL → CMP-ANCH-REST** — build primitives before validating, mass-produce 8 anchors last when patterns are well-established.
- **ChatBubble width drifts from Matt's 159px canvas placeholder** — Matt's 159px is a Figma drawing placeholder, not a UX rule.
- **Drop `entity` prop from Module and ToDoItem** — Strict-B match to Matt's exact 2 variants per primitive.
- **CourseHeader CTA + rating/level stay inline (not refactored)** — dark-image hero background incompatible with light-bg-optimized primitives. Spawned `[DARK-HERO-VARS]`.

**Patterns:**

- **Figma MCP asset URLs preserve source format** — vector sources return SVG; raster return PNG. `curl -sSL -o file.svg "https://www.figma.com/api/mcp/asset/<uuid>"` then perl-pi normalize `fill="var(--fill-0, #hex)"` → `currentColor`. (`reference_figma_mcp_behavior.md` updated.)
- **Pre-mirrored asset SVGs vs CSS-transform mirroring** — Matt may draw each variant as a separate pre-mirrored SVG. Trust the export.
- **Conv 178 reconnaissance over-engineered with `entity` prop on non-entity primitives** — Strict-B mirror is the safer default; reserve entity cascade for primitives Matt drew as multi-entity.
- **Playwright fallback when Chrome MCP bridge is flaky** — `npx playwright install chromium` (~250MB one-time) for programmatic headless screenshots.
- **Design-system meta elements aren't always product primitives** — Matt's "Section Title" is a 1280×96px dev-status banner, NOT a product primitive.

## Conv 186 — Matt frames Ready-for-Dev drift lookup + 5 audit-driven follow-throughs

- `[SP-AUDIT]` SocialPost.tsx subtree audited; file clean. One borderline finding: SocialPost "Show More" inline `text-text-primary` underline → tracked as `[TXTBTN]`.
- `[ASSET-SWEEP]` Verified zero embedded Figma URLs in `src/` (45 SVGs already harvested permanently).
- `[MFRD-DESIGN]` Designed drift-detection workflow.
- `[MFRD-SEED]` Seeded `.scratch/matt-frames-ready-for-dev.md` with 32 rows.
- `[SUBNAV-PATTERN]` Course SubNav route shape resolved by reading existing `/discover/course/[slug]/index.astro` + `[...tab].astro`. Pattern: Astro rest-spread + `VALID_TABS` const + redirect-on-invalid + React island handling History API. Path-based (bookmarkable). Matt's Course mirrors as `/matt/course/[slug]/[...tab].astro` with `VALID_TABS = ['about','modules','reviews','resources','teachers','creator']`. Spawned `[MATT-SUBNAV-ROUTING]`.
- `[TASK-CLEANUP]` Deleted 3 redundant tasks: `[CMP-EXT-ICN]` (replaced by 5 specific harvest tasks + drift-check side-effect rule); `[MATT-CREATOR-TAB]` (replaced by `[MATT-SUBNAV-ROUTING]`); `[MDR]` (placeholder completed by `[MFRD-LOOKUP]`).

**Decisions:**

- **Matt Course SubNav routing = path-based `[...tab].astro`** — Mirrors existing pattern. Bookmarkable URLs.
- **Drift-detection lookup at `.scratch/matt-frames-ready-for-dev.md` (graduates to `docs/reference/` at MMP-PH5)** — Per Conv 182 scratch→memory→docs graduation flow.
- **Side-effect Material-icon discovery via drift-check workflow** — Every deep `get_design_context` probe scans `<img data-name>` instances and auto-creates `[<ICON>-ICN]` tasks for unharvested icons.
- **Add `Parent Page` column to lookup schema** — Sorting/filtering trivial.

**Patterns:**

- **Spatial banner-to-section derivation reliable on Matt's Figma** — All product-section banners on Components page sit at y=785 directly above their sections at y=981+. Spatial reasoning from `get_metadata` outputs is a valid short-circuit.
- **Matt's "Last Touched" is the single drift signal** — Date format unstable for diff; always store both raw + ISO.
- **`Home /` vs `Page /` prefix convention** — Matt's frame-banner titles use deliberate prefixes: `Home /` denotes a state/variant of the home page; `Page /` denotes a standalone destination screen. Affects routing.
- **The lookup-driven discovery loop exposes architecture, not just data** — route-family clusters emerged organically as 32 rows accumulated.
- **Matt's review passes are batched, not incremental** — bulk-update patterns expected.
- **Figma MCP `get_design_context` works without selection on remote MCP** — Conv 180 classification revised: ALL Figma read tools are selection-free with explicit nodeId.
- **Name-collision drift catches: section-name vs banner-title** — banner is authoritative product label per designer-supplied-catalogues rule.
- **`ControlBar.tsx` purpose discovered retroactively via lookup** — Orphaned components without a clear design home often resolve when more design data is captured.

## Conv 187 — MMP-PH4 re-render + per-icon viewBox + CourseHeader re-validation + addressability resolution

- `[MMP-PH4]` Re-render test COMPLETE — Course In Feed `519:9096`.
- `[CMP-ICN-REGISTRY]` RESOLVED via re-render test — chose A (per-icon intrinsic viewBox in `MattIcon.tsx`, default 24×24) over rescale-via-`<g transform>`. Icons stored at native size; MattIcon now size-agnostic.
- `[DARK-HERO-VARS]` COMPLETE — Added `tone="default"|"on-dark"` prop to `IconLabelChip.tsx`; applied to both Course In Feed (4 chips) and the re-validated CourseHeader (4 chips). Button dark variant confirmed unneeded.
- `[STARS2-ICN]` + `[ACCESSIBILITY-ICN]` harvested.
- `[MATT-IDX-AUDIT]` `src/pages/matt/index.astro` audited per reuse rule; 6 placeholder `<article>` cards converted to `<Card>`.
- `[MATT-EXEC-FLAGS]` RESOLVED on addressability axis. (See Decisions in [README.md](README.md).)
- `[GVD-SELFREE-VERIFY]` + `[MCP-SEL-MISFIRE]` closed — `get_variable_defs(519:9096)` probed with explicit nodeId and no Figma desktop selection returned the full Variable map, confirming ALL Figma read tools are selection-free given a nodeId; "selection-required" tool class retired in `reference_figma_mcp_behavior.md` + MEMORY.md.

**CourseHeader re-validated to Matt's Default frame (reverses Conv 184/185 creator trio):** see [phase-3-pg1.md](phase-3-pg1.md).

## Open

- [ ] **[MMP-PH5]** Phase 5 Graduation — TodoWrite #14, [Opus]. Promote remaining scratch docs; roll forward to remaining Phase 5 pages via MCP.
- [ ] **[MMP-PH3]** TodoWrite #16 — likely a stale carry-over after Conv 185 MMP-PH3 close. Reconcile in /r-end.
- [ ] **[VIDEO-COMMENT-ICN]** Harvest `video_comment` Material icon — VideoClipAnchor currently uses `chat` icon as substitute. Folds into `[CMP-EXT-ICN]` incremental Material harvest pattern. (See [phase-6-ext.md](phase-6-ext.md).)
- [ ] **[PLAY-CIRCLE-ICN]** Harvest `play_circle` Material icon — VideoClipAnchor currently uses inline-SVG placeholder. (See [phase-6-ext.md](phase-6-ext.md).)
- [ ] **[HOWTOREG-ICN]** Conv 186 — Harvest `how_to_reg` Material icon.
- [ ] **[ASSET-SWEEP-GATE]** Conv 186 — Add Figma-URL grep guard to `/w-codecheck` as Check 9: `grep -rE 'figma\.com|mcp/asset' src/` → must return 0 matches.
- [ ] **[FIGMA-MCP-DOC-HARVEST]** Conv 186 — Add "asset harvest discipline" section to `docs/reference/figma-mcp.md`.
- [ ] **[MFRD-LOOKUP]** Conv 186 — Permanent maintenance task for `.scratch/matt-frames-ready-for-dev.md`.
- [ ] **[CH-VARIANTS]** Conv 187 — Build CourseHeader Enrolled (`597:6504`) + Scheduled (`685:13240`) variants. Sequence when MMP-PH5 touches enrolled-state course pages.
- [ ] **[CH-DOCSYNC]** Conv 187 → verified ALREADY DONE Conv 192 (matt-design-system.md `06-component-primitives.md` lines 1005–1007 document the CourseHeader on-dark-chip rendering).
- [ ] **[TXTBTN]** Conv 186 — Watch task: "inline text-styled action button" pattern. Consolidate into a new `TextButton` primitive if 3+ instances appear during Phase 5.
- [ ] **[MEM-ICON-COUNT]** Conv 188 — MEMORY.md Icon System count is stale (now 43 Matt SVGs after `folder.svg` Conv 188 + `chevrons-left.svg` Conv 190; later 53 by Conv 197). Update the count.

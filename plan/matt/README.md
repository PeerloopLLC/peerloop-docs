# MATT design system — plan index

The MATT design system push migrates Peerloop's UI to designer Matt's Figma design language. This directory contains the per-phase plans, the cutover block, and the standin retrofit work.

**Status:** 🔥 IN PROGRESS — Phase 5 (course-tab family complete; Enroll-family precheckout ✅ Conv 232; success ✅ Conv 233; booking `@stand-in` ✅ Conv 234; ENROLL-NAV dual-zone SubNav + Journey + "My Sessions" + `/session/[id]` `@stand-in` ✅ Conv 235; **`/session/[id]` graduated `@matt-inspired` ✅ Conv 239 [SESS-GRAD]**; two-tier course Journey ✅ Conv 240 [JOURNEY-LOOP]; **`/book` graduated `@matt-inspired` ✅ Conv 242 [CALENDAR2]** — `@stand-in` census in `src/pages` now ZERO, funnel fully Matt end-to-end; **CourseHeader Scheduled variant ✅ Conv 242 [CH-VARIANTS]**; **[SUCCESS-COMMUNITY] ✅ Conv 243** (MilestoneComposer — funnel's last Matt feature); 5 remaining routes pending). **Matt phase-out (Conv 239):** Matt's designs now "nice-to-have"; pages default `@matt-inspired`, decided page-by-page, function-first. Phases 1–4.5 ✅; Phase 6 (extrapolation) builds lazily per page; Phase 7 (doc graduation) pending block close. Cutover (route-flip) ✅ shipped Conv 197.

**Spec docs:**
- `docs/as-designed/matt-pre-plan.md` — the original 12-section pre-plan (route map, file structure, 8 blocking decisions, Tailwind 4 bridge, extrapolation enumeration, 7-phase execution sequence, doc graduation criteria). Locked Conv 173.
- `docs/as-designed/matt-design-system/` — the living design-system spec (7 numbered files split from the original 1717-line matt-design-system.md per Conv 192 [MDS-SPLIT]).
- `docs/as-designed/matt-provenance.md` — page + component provenance rules; route-flip §8; PROV-MATCH §10.
- `docs/as-designed/matt-frames-ready-for-dev.md` — drift-detection lookup of Matt's currently Ready-for-Dev frames (graduated from `.scratch/` Conv 198).
- `docs/reference/figma-mcp.md` — Figma MCP setup + empirical behavior reference.

## Phase table

| Phase | Code | File | Status |
|---|---|---|---|
| 1 — Tokens | `[MATT-EXEC-TKN]` | [phase-1-tokens.md](phase-1-tokens.md) | ✅ Conv 174 |
| 2 — Layout shell | `[MATT-EXEC-SHL]` | [phase-2-shell.md](phase-2-shell.md) | ✅ Conv 174 (+ Conv 175 refinements) |
| 3 — First page | `[MATT-EXEC-PG1]` | [phase-3-pg1.md](phase-3-pg1.md) | ✅ Conv 175 |
| 4 — Primitives | `[MATT-EXEC-PRM]` / `[MATT-EXEC-PRM-2]` | [phase-4-prm.md](phase-4-prm.md) | ✅ Conv 175 (A) + Conv 176 (B) + Conv 177 (DSSR fix) |
| 4.5 — Component import | `[MATT-EXEC-CMP]` / MMP | [phase-4.5-cmp.md](phase-4.5-cmp.md) | ✅ Conv 185 (13/13 primitives) — MMP-PH4 re-render Conv 187 |
| 5 — Remaining pages | `[MATT-EXEC-PG2]` | [phase-5-pg2.md](phase-5-pg2.md) | 🔥 IN PROGRESS — course-tab family done Conv 188–190; precheckout ✅ Conv 232; success ✅ Conv 233; booking `@stand-in` ✅ Conv 234; ENROLL-NAV ✅ Conv 235; `/session/[id]` graduated `@matt-inspired` ✅ Conv 239 [SESS-GRAD]; two-tier Journey ✅ Conv 240 [JOURNEY-LOOP]; `/book` graduated `@matt-inspired` ✅ Conv 242 [CALENDAR2] (`@stand-in` census now ZERO) + CourseHeader Scheduled variant ✅ Conv 242 [CH-VARIANTS]; success Phase 2 composer ✅ Conv 243 [SUCCESS-COMMUNITY]; 5 other routes pending |
| 6 — Extrapolation | `[MATT-EXEC-EXT]` | [phase-6-ext.md](phase-6-ext.md) | → ongoing (build lazily per page) |
| 7 — Doc graduation | `[MATT-EXEC-GRD]` | [phase-7-grd.md](phase-7-grd.md) | [ ] pending |

## Sibling blocks (matt family)

| Block | File | Status |
|---|---|---|
| MATT-CUTOVER (route flip + post-flip reconciliation) | [cutover.md](cutover.md) | 🟢 substantially complete (Convs 197–199); PROV-MATCH-AUTO open |
| STANDIN-MATT (legacy-rehost page retrofit) | [standin-matt.md](standin-matt.md) | ✅ COMPLETE (Conv 212) — /profile account-hub scaffold; 0 @stand-in remain; per-tab redesign → #33 |

## Decisions (locked Conv 173 + amendments)

The 8 blocking decisions from `matt-pre-plan.md` §4 Resolution summary remain the durable charter. Subsequent amendments worth noting at this level:

- **Conv 174 §1** — Include `--spacing-N` in Tailwind bridge (accepted global utility-scale break on `jfg-dev-13-matt` for 572 `p-4` callsites; consequence per phase-1-tokens.md).
- **Conv 175** — Slot-default fix lives in AppLayout via unconditional Fragment + ternary; HeaderBar carries no slot fallbacks (see `memory/reference_astro_slot_forwarding.md`).
- **Conv 175** — Tailwind `lg:` breakpoint shifted 1024→1025px globally via `--breakpoint-lg: 1025px` in `tokens-tailwind-bridge.css @theme`.
- **Conv 177** — Real fix for DSSR cold-start crash is `vite.optimizeDeps.entries` + `include: ['astro/virtual-modules/transitions.js']` (NOT React dual-copy as Conv 176 hypothesized). Stateless-primitives discipline retired.
- **Conv 178** — Phase 4.5 numbered explicitly to preserve §9 anchor stability (not re-numbered 5→6).
- **Conv 181** — **NEW STANDING PRINCIPLE: tokenize only Matt's Variables** (`feedback_tokenize_only_matt_variables.md`). Token-ify what Matt tokenized; hardcode what Matt hardcoded; scaffold what Matt hasn't categorized. Probe protocol: `get_variable_defs` is the authority.
- **Conv 183** — Figma is READ-ONLY (`feedback_never_modify_figma.md`); never call write-shaped MCP tools.
- **Conv 184** — Primitives in React (.tsx), page-wrappers in Astro. Scan `<instance>` children before rendering; never inline duplicates (`feedback_reuse_existing_components.md`).
- **Conv 187** — Route shape resolved by **addressability** (does each screen need a jump-to/deep-link/redirect URL?), NOT page-count. Implementation mirrors legacy patterns. (`feedback_routing_addressability_first.md`)
- **Conv 188** — Cascade-driven Tailwind 4 tokens MUST live in `@theme inline`; static tokens stay in plain `@theme` (`[ENTITY-CASCADE-BUG]` resolution).
- **Conv 190** — Course-page routes consolidated into one catch-all (`[...tab].astro`, `_course-tabs.ts` shared SubNav-config) eliminating the duplicated-shell drift class.
- **Conv 192** — `matt-design-system.md` split into a folder of 7 concern files (`[MDS-SPLIT]`); convention recorded in `DOC-DECISIONS.md §2`.
- **Conv 197** — Route flip executed: 43 legacy pages → `/old/`, 9 Matt pages → root, `matt/*` namespace dissolved. See [cutover.md](cutover.md).
- **Conv 207** — 3-marker page provenance convention adopted (`@stand-in` / `@matt-source <nodeId>` / `@matt-inspired`). Codified Conv 208 in `matt-provenance.md §11`.

## Pre-execution intake (Convs 168–172)

The pre-execution intake spans Convs 168–172. Detail lives in `docs/as-designed/matt-pre-plan.md` and `docs/as-designed/matt-design-system/` (the spec docs). High-level conv-by-conv:

- **Conv 168** — `[MATT-INTAKE]` scope set: matt branched from `jfg-dev-12`, `/matt/*` namespace for coexistence, SVG batch-export over PNG, MCP setup deferred (no Dev seat yet).
- **Conv 169** — 4 client directives received; 229 SVG/PNG files exported to `.scratch/matt-figma/`; inventory + page-panel notes persisted.
- **Conv 170** — `[MATT-ISOLATE]` curation: `.scratch/matt-figma/` (229 files / 137 MB) → `.scratch/matt-main/` (83 files / 85 MB) as the focused build set. Established curation-pattern learning: pair every inclusion manifest with a per-category exclusion table.
- **Conv 171** — `[MDS]` `docs/as-designed/matt-design-system.md` (650+ lines) authored as the durable spec doc. Form-graduation pattern established (`.scratch` → `docs/as-designed` when content stabilizes at 60%+ permanent).
- **Conv 172** — `[MDM]` + `[MDM-TAIL]` all 5 Figma Dev Mode batches resolved + 5 bonus batches scaffolded. **35 Figma Variables extracted** across 5 collections. Multi-mode pattern documented as system-wide CSS variable cascade architecture. Token Scaffolding Policy + Control Bar disambiguation + Component composition principle + Preserve cascade chains decisions captured.

## Conv timeline (canonical execution)

| Conv | Phase | Highlights |
|---|---|---|
| 173 | pre-plan | `[MATT-PRE-PLAN]` landed at `docs/as-designed/matt-pre-plan.md` with 8 decisions resolved. 7-phase execution sequence locked. |
| 174 | 1 + 2 | Tokens + shell landed (`jfg-dev-13-matt` branch). |
| 175 | 2-viz + 3 + 4A | Slot-forwarding bug fix, `/matt/index` stub, `/matt/course/[slug]` first page, Button + Card + SectionTitle primitives. |
| 176 | 4B | 5 primitives (Module/Note/ToDoItem/SocialPost/RoleTabBar). Misdiagnosed [DSSR-SCOPE] crash drove stateless-primitives discipline as workaround. |
| 177 | infra | `[NPM-UP]` Astro stack upgrade + `[DSSR-SCOPE]` real root cause (Vite cold-start dep-discovery race). Stateless discipline retired. |
| 178 | 4.5 setup | Phase 4.5 `[MATT-EXEC-CMP]` scoped (8 dependency-ordered subtasks). Icons harvest from Figma Dev Mode. Pro-account pivot. |
| 179 | 4.5 prep | `[MCP-SETUP-WALK]` v1 walkthrough; v2 pivot to Figma's official remote hosted MCP. |
| 180 | 4.5 prep | `[MCP-VERIFY]` Figma Remote MCP authenticated. 4 reversed recommendations captured as `[EMP]` learning. |
| 181 | MMP-PH1 | Token foundation: 12 Color + 18 Typography Variables canonized. New `tokens-typography.css`. `[NOTE-YELLOW]` resolved by hardcoding inline → **tokenize-only-matt-variables principle** codified. |
| 182 | MMP-PH2 | Icon registry: 39 SVGs ported via Vite `?raw` glob. `[CASCADE-BROKEN]` closed (entity cascade was never wired into Matt's button design). 5 doc graduations. |
| 183 | MMP-PH3 (1/3) | Buttons (strict-B 5-value `property1` enum mirroring Matt's Figma exactly — Conv 178 "3-orthogonal" framing retracted). MainNav + NavItem + NavSubItem (Decisions D1/D2/D3 via ASCII mockup previews). |
| 184 | MMP-PH3 (2/3) | SubNav (resolved Conv 183 "Need 3+ Levels"; fixed Conv 175 latent bug). Entities decomposition: UserIcon/EntityPill/EntityLink/IconLabelChip. CourseAnchor (first of 9 anchor rows). SocialPost refactor. Primitives standardized on React (.tsx). New rule: scan `<instance>` children, import existing primitives. |
| 185 | MMP-PH3 (3/3) | Chat Bubble; 8 remaining anchor rows in single batch; CourseHeader creator-trio refactor; Brand primitive (Logo + LogoMark). Matt's Components page reaches 13/13. `[C178-REVAL]` Module + ToDoItem refactored to strict-B. |
| 186 | drift lookup | `[MFRD-LOOKUP]` 32-row Ready-for-Dev frame catalogue. Side-effect Material-icon discovery rule codified. `[MATT-SUBNAV-ROUTING]` planned. |
| 187 | MMP-PH4 | Re-render test: CourseInFeed (`519:9096`). Per-icon viewBox registry. CourseHeader re-validated to Matt's Default frame (creator trio reversed). `[MATT-EXEC-FLAGS]` resolved on addressability axis. |
| 188 | Phase 5 begin | `[MATT-SUBNAV-ROUTING]` SubNav most-specific active fix + `[...tab].astro` route. `[RESTAB]` + `[TCHTAB]` course-tab bodies built (Option A per-tab components). `[MOD-SCHEMA]` resolved (Session↔Module 1:1). `[ENTITY-CASCADE-BUG]` fixed. |
| 189 | Phase 5 cont. | `[CRTTAB]` + `[RVWTAB]` + `[MODTAB]` + `[FEEDTAB]` — all 6 course tabs now built. `CourseEmbedCard.tsx` shared embedded-course card extracted. |
| 190 | Phase 5 polish | Sidebar + shell rewritten to match Matt's Layout Desktop `81:1483` (`[SBAR-REWRITE]`). Course-page routes consolidated (`[RTCONS]`). Letter-spacing token bug fix (Figma `-2.2%` ≠ `-2.2px`). |
| 192 | Phase 5 + doc split | `[MDS-SPLIT]` matt-design-system.md → folder of 7 numbered files. `[MATT-COURSES-INDEX]` `/matt/courses` thin Matt-native index page. `[LEGACY-SPACING-AUDIT]` quantified blast radius + decided do-nothing-broad. |
| 195 | cutover spawn | MATT-CUTOVER block spawned with the "after today's demo (2026-05-26)" trigger. |
| 197 | cutover | `[PROV]` 35 components + token blocks marked `@matt-source`; `[ROUTE-FLIP]` 43 legacy → `/old/`, 9 Matt → root. |
| 198 | post-flip | Doc reconciliation batch #25–28. New pattern: treatment is a function of doc TYPE. |
| 199 | prov detection | `[PROV-SWEEP]` thin validator + candidate registry; `[PROV-MATCH]` no confirmed collisions. |
| 203 | RTMIG-4 | Home port surfaced Phase-6 gaps: `EmptyState.astro`, `ActionCard.astro`, `clock.svg` icon, `OnboardingNudgeBanner` Matt restyle. |
| 207 | STANDIN-MATT | 3 of 4 remaining `@stand-in` pages converted (`/login` + `/signup` + `/onboarding`). 11 new form/UI primitives. 3-marker page-provenance convention adopted. |
| 208 | STANDIN closing | `[STANDIN-404]` + `[PROV-CODIFY]` + `[PROV-SWEEP-MI]` (3 Conv 207 deferred → Conv 208 closed). **/profile retrofit attempted then reverted** (marker flip ≠ retrofit; still pending). |
| 232 | Phase 5 (Enroll) | `[PRECHECKOUT]` Enroll-family page shipped — addressability audit reversed Conv 187 → addressable; user-refined hybrid (one `PrecheckoutContent.astro`, two shells: `/precheckout` standalone + `/benefits` SubNav tab); `EnrollButton variant="matt"` reuse; both CTAs → Stripe. |
| 233 | Phase 5 (Success) | `[PRECHECKOUT-EARN]` wired to real per-course teacher-earnings aggregate. `[SUCCESS-ROUTE]` Phase 1 — root `/course/[slug]/success` (`@matt-source 579:16885`) ported (fixes the Stripe `success_url` 302-bounce): congrats card + real-data first-session card + `[CH-VARIANTS]` Enrolled variant; self-heal + ExpectationsForm preserved; `verified`+`av-timer` icons (54→56). Checkout fail/cancel: `expired` webhook intentionally-not-handled comment fix + `cancel_url` `?enroll=cancelled` toast. `[SUCCESS-COMMUNITY]` (Phase 2 composer) spawned. |
| 242 | Phase 5 (booking close) | `[CALENDAR2]` `/book` graduated `@stand-in → @matt-inspired 622:15671` (MERGE re-skin, function-first; Matt date+time-on-one-screen; confirm step kept separate; every legacy behavior preserved) → **`@stand-in` census in `src/pages` now ZERO**, funnel fully Matt end-to-end. SessionBooking.test rewritten (confirm/booking/success assertions were silently dead — Invalid-Date mock). `[CH-VARIANTS]` Scheduled variant (`@matt-source 685:13240`) + loader `nextSession` + viewer-local `<time>`/`astro:page-load` upgrade; fixed CourseHeader prov NODE-MISMATCH (sweep 6→5). Spinoffs `[TZ-AUDIT]` #46 + `[OUTLINE-V4]` #45. |
| 243 | Phase 5 (success composer) | `[SUCCESS-COMMUNITY]` success-page Phase 2 — `MilestoneComposer` island (`@matt-source 729:15940`) posts the enrollment milestone to the course feed via new shared `postCourseFeed()` (`src/lib/feeds.ts`, also adopted by `MattCourseFeed`); `CourseEmbedCard` gained `showCta`. Frame diverges from `MattCourseFeed`'s composer → focused new component, not a `mode` prop. Enrolled student qualifies (`canPost: true`); no legacy behavior lost. prov:sweep 6→4 (gen:registries registered MilestoneComposer + self-healed PrecheckoutContent); suite 6458, build ✓. Finishes the Matt enrollment funnel's last feature. |
| 244 | triage + prov debt closeout | `[PROV-SWEEP-DEBT]` cleared the standing prov:sweep debt **4→0**: registered `av-timer`/`verified` in `icon-provenance.ts` (`source:'ours'`) + `MySessionsTab` in `matt-inspired-registry.ts`; dropped the `SubNavItemDisabled` `data-prov-name` stamp (state variant of the already-`@matt-source` `SubNavItem`, not a distinct primitive). `[OUTLINE-V4]` done — `outline-none`→`outline-hidden` ×4 in the SESS-GRAD booking files. Triage closed several PRIM follow-ups (see PRIM-REGISTRY row). Found the Matt Sidebar 404s on `/notifications` + `/messages` is legacy-only/absent → `[NOTIF-PORT]`/`[MSG-PORT]` queued next conv (see ROUTE-MIGRATION row). |
| 245 | NOTIF/MSG port (Tier-1) | `[NOTIF-PORT]` + `[MSG-PORT]` BOTH DONE — root `/notifications` (`@matt-inspired`, AppLayout + new `NotificationCenter.tsx`, full behavior parity) + root `/messages` (new + 5 Matt islands `src/components/messages/matt/*`, reuses `UserIcon`/`Modal`/`SearchInput`; 10s REST polling, `?to=`/`?conversation=` deep-links, new-convo modal+search, unread, mobile split). Messages NavItem added to Sidebar bottom-cluster + COLLAPSED_NAV. Legacy `/old/*` left untouched. 6 gates green (suite 6458). Detail in ROUTE-MIGRATION row. |
| 247 | NOTIF/MSG verify + infra | `[NOTIFMSG-VERIFY]` — Conv 245 ports browser-verified (/chrome bridge vs :4331 preflip ref) AND legacy↔new source parity-diffed (2 parallel agents): **both faithful, ZERO dropped behaviors** (all 8 notification actions + 18 types + filters/states; messages every endpoint/deep-link/poll/modal — modal even GAINED Esc/focus-trap/scroll-lock via reused primitives). Read-only verification, not a new port. Spun out `[TOWNHALL-SELECT]` #25 (root `community/TownHallFeed` uses raw `<select>` ×2 → fold into community-port verification). Infra: `[DONEGREP]` hardened r-start no-shrink grep patterns; `[BAK-ARTIFACT]` no-op; `[SELECT-AUDIT]` healthy (Select primitive correctly on Matt surfaces; 24 raw-select sites are legacy backlog, ride RTMIG-4). |

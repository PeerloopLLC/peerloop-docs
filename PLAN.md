# PLAN.md

This document tracks **current and pending work**. Completed blocks are in COMPLETED_PLAN.md.

---

## Block Sequence

### ACTIVE

| Block | Name | Status |
|-------|------|--------|
| MATT-DESIGN-PUSH | Matt Design System — intake, spec doc, token extraction, scaffolding, pre-plan, execution | 🔥 IN PROGRESS (Convs 169-177: intake → curated build set → spec doc → Figma Variable extraction + scaffolding policy → pre-plan + 8 decisions Conv 173 → Conv 174 Phases 1-2 complete → Conv 175 Phases 2-viz / 3 / 4-scope-A complete → Conv 176 Phase 4 scope B (5 primitives + stateless discipline as workaround for misdiagnosed SSR crash) → **Conv 177: [NPM-UP] + [DSSR-SCOPE] resolved. Astro stack upgraded (astro 6.1.5→6.3.7, @astrojs/cloudflare 13.1.8→13.5.4, @astrojs/react 5.0.3→5.0.5, wrangler 4.81.1→4.94.0). Real root cause of "useState SSR crash" identified: Vite cold-start dep-discovery race (industry-wide pattern — Remix #10156, TanStack #4264, Storybook #32049). Fix: `astro.config.mjs` `vite.optimizeDeps.entries` + `include: ['astro/virtual-modules/transitions.js']`. Conv 176 stateless-primitives discipline RETIRED. ToDoItem.tsx rewritten as controlled-or-uncontrolled hybrid. DEVELOPMENT-GUIDE.md "Vite SSR Cold-Start Dep Discovery" section replaces stateless-primitives discipline. /w-codecheck all 8 PASS.** Next major step: [MATT-EXEC-PG2] Phase 5 routes.) |
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

- [⏸️] **[MATT-MCP-RETRY]** Conv 176 — **ON HOLD** per user direction ("something is holding up the process and I can't wait for it"). External Figma paid-seat blocker indefinitely. Proceeding without MCP using static SVG exports under `.scratch/matt-main/` + new qlmanage SVG→PNG visual-inspection workflow (Conv 176 [MPV] addendum). Reassess when user signals unblock. (Conv 169 inception → Conv 171 partial / interim Dev Mode CSS Inspector workaround → Conv 176 ON HOLD)

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

- [ ] **[TSV]** Token Scaffolding Verification — examine Matt's values against scaffolded defaults across all token types. Includes: (a) naming convention normalization for Matt's primitives (kebab-case vs Title Case vs lowercase-with-space), (b) verify Mobile Header Bar height snap (44 → 40 or 48 — 4px delta, ambiguous), (c) confirm extrapolated scales fit Matt's unseen pages. Created Conv 172 (TodoWrite #15).

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

- [ ] **[MATT-ICON-SWAP]** Hero overlay inline-SVG icons (chevron, book, person, star, graduation-cap) should swap to a proper icon-system primitive in Phase 6 [MATT-EXEC-EXT]. Currently authored as inline SVG paths in `CourseHeader.astro`.

- [ ] **[MATT-CREATOR-TAB]** Build `/matt/course/[slug]/creator` route — Phase 5. SubNav tab "Meet the Creator" already added Conv 175; route renders a creator-detail panel for the course's creator. Legacy app's `/course/[slug]/creator-sessions` is the closest analog.

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

- [ ] **[NOTE-YELLOW]** Conv 176 — Add `--note-yellow: #FFF1B8` token to `src/styles/tokens-primitives.css` (currently arbitrary literal in `Note.tsx` with TODO comment). Coordinate with `[TSV]` token-scaffolding verification pass — Matt's design uses a pastel-yellow not in his documented token set.

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

## MATT-DESIGN-PUSH Execution Phases (spawned Conv 173 from [MATT-PRE-PLAN])

All 7 phases follow `docs/as-designed/matt-pre-plan.md` §9 execution sequence. Each phase is its own conv (or bundles when scope allows). Decisions locked Conv 173 — see `matt-pre-plan.md` §4 Resolution summary.

- [x] **[MATT-EXEC-TKN]** Conv 174 — Phase 1 token files landed on `jfg-dev-13-matt` (branched from `jfg-dev-12`). `src/styles/tokens-primitives.css` (~155 lines, 15 colors kebab-case per Decision 2 + 9 radius/7 shadows/15 opacity/7 z-index/8 duration/10 spacing rem-pixel-named per Decision 1=C), `src/styles/tokens-semantic.css` (~165 lines, 14 semantics Title-Case-dash with cascade preserved via `var()` chains — `--Student-Primary: var(--Primary-Default)` NOT flattened, Entity multi-mode at :root + 3 mode classes, Icon-Size 2 tokens, Button base + 6 variant classes with seamless-edge pattern), `src/styles/tokens-tailwind-bridge.css` (~80 lines, color re-exports additive, Matt typography ramp additive, **spacing override per Conv 174 user choice B** — `--spacing-4: var(--space-4)` through `--spacing-64`, accepting global utility-scale break across non-`/matt/*` per Decision §1 below). `src/styles/global.css` updated with single `@import './tokens-tailwind-bridge.css';` line. Snap policy applied (44/49→48, 17→16, 23→24). All 5 baseline gates green (tsc 0 / astro 1215/0/0/0 / build 6.13s). Built CSS verified: cascade chains intact, existing `--color-primary-*` untouched.

- [x] **[MATT-EXEC-SHL]** Conv 174 — Phase 2 layout shell landed. 5 components authored under `src/{layouts,components}/matt/`: `HeaderBar.astro` (slot-based per Decision 7=C — header-left/center/right slots; fixed-top at <lg; mobile=brand+icons row, tablet portrait=centered brand), `SubNav.astro` (items-prop based; vertical-left strip at lg: 196px wide; horizontal-scroll fallback at <lg as Phase 4 drawer stub), `Sidebar.tsx` (React island, useState toggle expanded/collapsed 220/70px, 5-item primary nav + earnings/notifications/profile chip + brand), `ControlBar.tsx` (React island, bottom-fixed pill, 6 nav icons with `tabletOnly` flag — 4 icons at <sm + 6 icons at sm:; z-30), `AppLayout.astro` (composes all 4; Sidebar `hidden lg:flex`, HeaderBar/ControlBar `lg:hidden`; named slots header-bar/entity-header/role-tab-bar/sub-nav + default; entity prop applies `.entity-{creator|student|course}` class). Gates green: tsc 0 / astro 1220/0/0/0 / build 6.13s. Built CSS verified: bridge color/typography utilities (`--color-text-default`, `--color-entity-background`, `--text-body-default`, etc.) now emit because components consumed them — confirms Tailwind 4's on-demand `@theme` emission behavior (see Conv 174 Learning #1). 3 positioning refinements deferred → `[MSH-REFINE]`.

- [x] **[MATT-EXEC-PG1]** Conv 175 — Phase 3 first `/matt/course/[slug]` page end-to-end. Built `src/components/matt/entity/CourseHeader.astro` (dark image hero with gradient overlay; iterated to 2-column layout: LEFT title + tagline + metadata row creator/rating/level; RIGHT ✓-includes list + "$X • Enroll Now ›" pill; top-right overlay back-chevron + book glyph; min-height 240px via inline style — see [TWLG-MIN-H]) and `src/pages/matt/course/[slug]/index.astro` (thin page using existing `fetchCourseTabData` loader; AppLayout entity=course; SubNav 7 course tabs: About / Course Feed / Modules / Meet the Creator / Teachers / Reviews / Resources; About body with 4 Cards: About / What you'll learn (2-col objectives) / Prerequisites / Who this is for). HTTP 200, astro check clean. Visual diff iteration vs Matt's `Course.svg` complete.

- [→] **[MATT-EXEC-PRM]** Conv 175 — Phase 4 scope A complete (3 of 8 primitives + retrofit). Built: `Button.tsx` (6 variants primary/outlined/course/student/creator/default × 3 sizes sm/md/lg; renders `<a>` if href else `<button>`; matt-design-system.md §6 Button table exactly), `Card.astro` (white-fill container with padding scale sm=12/md=16/lg=24/none + optional borderless), `SectionTitle.astro` (semantic level h2/h3/h4 × visual size large/medium/small). Retrofitted CourseHeader CTA to `<Button variant="course">`; retrofitted course-page body 5 sections → 4 sections each wrapped in `<Card padding="lg">` with `<SectionTitle>` headings (What's included moved to hero overlay per visual diff). Visual fidelity iteration with Matt's `Course.svg` — 6 fixes landed (Course Feed tab, 2-col objectives, What's Included as hero overlay, Meet the Creator as SubNav tab not body card, hero 2-column restructure, hero overlay glyphs). Remaining 5 primitives spawned as [MATT-EXEC-PRM-2].

- [x] **[MATT-EXEC-PRM-2]** Conv 176 — Phase 4 scope B complete: 5 primitives + 1 internal demo wrapper landed on `jfg-dev-13-matt`. `Module.tsx` (lesson row icon+eyebrow/title/duration, default/active states, direct entity-utility variants), `Note.tsx` (sticky-note pastel-yellow annotation `#FFF1B8` until `[NOTE-YELLOW]` token lands), `ToDoItem.tsx` (**fully controlled — no `useState`**, parent owns checked+onChange; green-filled checkbox glyph; direct entity-utility for active row), `SocialPost.tsx` (composite feed item: author header + body + optional embed slot + footer like/comment/commenters), `RoleTabBar.tsx` (Peerloop multi-role tab switcher; anchor + button modes; role-specific primary/background tokens; safety-returns null when ≤1 role), `_SocialPostDemo.tsx` (internal underscore-prefixed React wrapper hosting Course-minicard embed JSX). `/matt/index.astro` extended with Phase 4 Primitives showcase section. Final verification: HTTP 200, body 33,648 chars, 4× `bg-student-background` / 3× `bg-course-background` / 2× `bg-creator-background` in HTML, all 5 primitives + 1 social-post-embed render, tsc clean, astro check clean (0/0/2 pre-existing hints). Remaining entity headers (`TeacherHeader`, `StudentHeader`, `CreatorHeader`) deferred to Phase 5 alongside the routes that consume them.

- [ ] **[MATT-EXEC-PG2]** Phase 5 — Remaining `/matt/*` pages (12 routes — `/matt/`, `/matt/login`, `/matt/teacher/[handle]`, `/matt/teacher/[handle]/schedule`, `/matt/session/[id]/{prepare,room,after}`, `/matt/certification/[id]`, `/matt/course/[slug]/{resources,reviews,teachers,checkout}`). Thin .astro shells composing primitives; existing data fetchers reused.

- [ ] **[MATT-EXEC-EXT]** Phase 6 — Extrapolation primitives (per matt-pre-plan.md §7): form-input variants (text/email/password/textarea/select), skeleton loader, modal frame, empty-state slot, status pill/toast for Alert/Success/Warning/Info states (Success/Warning/Info scaffolded — flag for Matt v2). Establishes coverage for the ~70 pages Matt didn't draw.

- [ ] **[MATT-EXEC-GRD]** Phase 7 — Doc graduation. Flip 🚧 banner off `matt-design-system.md`; archive `matt-pre-plan.md` to historical status. All 8 doc-graduation criteria green (matt-pre-plan.md §8). End of MATT-DESIGN-PUSH block; transition to flip planning (separate future block).

- [ ] **[MATT-EXEC-FLAGS]** Cross-phase follow-ups identified by matt-pre-plan.md §2 route-mapping pass — verify against current codebase before phase 5 lands: (a) `/course/[slug]/checkout` route name (vs `/book`?), (b) `/teacher/[handle]/schedule` route (vs `/book?teacher=`?), (c) `/session/[id]/{prepare,room,after}` route shapes (vs single `/session/[id]`?), (d) certification route — `/certification/[id]` vs `/learning/certifications/[id]`?

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

*Last Updated: 2026-05-23 Conv 177 — MATT-DESIGN-PUSH unblocked: Astro stack upgrade + Vite SSR cold-start root cause + fix. **Conv 177 deliverables (2 PLAN items completed + 0 new deferred):** [NPM-UP] COMPLETE — astro 6.1.5→6.3.7, @astrojs/cloudflare 13.1.8→13.5.4, @astrojs/react 5.0.3→5.0.5, wrangler 4.81.1→4.94.0 (initial install hit ERESOLVE forcing wrangler addition; per Solution Quality default-durable). Canonical Vite dedupe/noExternal workaround attempted but FAILED — same cold-start Sidebar.tsx crash. [DSSR-SCOPE] COMPLETE — real root cause found via web research: Vite cold-start dep-discovery race (industry-wide pattern: Remix #10156, TanStack/router #4264, Storybook #32049, vitejs/vite #17979). First SSR request triggers Vite to find new imports → re-optimize `node_modules/.vite/deps_ssr/` → reload bundled React → in-flight render crashes with null hooks dispatcher → response body cut off mid-attribute. **Working fix:** `astro.config.mjs` `vite.optimizeDeps.entries: ['src/**/*.tsx', 'src/**/*.ts', 'src/**/*.astro']` + `include: ['astro/virtual-modules/transitions.js']` (entries alone insufficient — Astro virtual modules aren't reachable from scanning src/). Verified: cold-start /matt/ succeeds first request (240839 bytes, all primitives rendered, `</html>` closed, 0 ERROR lines); production build clean in 7.27s; preview /matt/ 30564 bytes, all 13 primitives present. **Cleanup sweep:** Conv 176 stateless-primitives discipline RETIRED from DEVELOPMENT-GUIDE.md; new "Vite SSR Cold-Start Dep Discovery" section documents the real bug class + fix recipe + symptom signature. ToDoItem.tsx rewritten as controlled-or-uncontrolled hybrid (proper React idiom). [AAP] re-tested against Astro 6.3.7 — still broken upstream. DEV-STAGING-SSR ON-HOLD row marked ✅ RESOLVED. **Astro warnings cleanup:** HeaderBar.astro Props cast fix (silences ts6196), CourseHeader.astro dead Button import removed; astro check 0/0/0 clean. **Side fixes:** api-test-helper.ts logger no-op stub (Astro 6.3 APIContext addition), Sidebar.tsx flex-shrink-0→shrink-0 (Tailwind v3→v4 rename, caught by /w-codecheck). **/w-codecheck all 8 PASS.** **4 strategic decisions:** (1) pair wrangler upgrade with Astro stack (avoid `--legacy-peer-deps`); (2) retire stateless-primitives discipline; (3) ToDoItem hybrid pattern; (4) don't downgrade React 19→18.2 (Vite cold-start affects React 18 too). **4 learnings:** (1) Vite cold-start dep discovery is documented industry-wide pattern — when SSR hook crashes self-heal on 2nd request, it's this class (different fix than dual React copies); (2) diagnosis can survive long because misleading symptoms cluster — "AppNavbar works but Sidebar crashes" mystery survived 3 convs because cold-start cache state masked request-order dependence; (3) `optimizeDeps.entries` recipe doesn't reach Astro virtual modules (needs `include` for each virtual module the dev log mentions in `✨ new dependencies optimized`); (4) Astro 6.3 added `logger` field to APIContext (TestAPIContext helper needs no-op stub). **3 patterns established:** diagnostic checklist for SSR hook crashes (cold-start race vs dual React vs config); Astro virtual module pre-bundling rule; cheap order-dependence probes falsify "structural" diagnoses. Branch `jfg-dev-13-matt` retained as active. RESUME-STATE.md cleared at /r-start (33 pending items transferred to TodoWrite). Next major step: `[MATT-EXEC-PG2]` Phase 5 routes (12 remaining /matt/* pages).*

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

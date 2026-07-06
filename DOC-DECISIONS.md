# DOC-DECISIONS.md

This document tracks decisions about **how the peerloop-docs repo itself works** — its organization, workflows, conventions, and tooling. For Peerloop application decisions (code, schema, UI), see `docs/DECISIONS.md`.

**Last Updated:** 2026-07-06 Conv 367 (No persistent dev server — CC spins up an ephemeral on-demand `npm run dev` and tears it down; reverses the "reuse always-open :4321" rule — §3 Claude Code Workflow)

---

## How This Document Works

- **Latest Wins:** If a newer decision contradicts an older one, only the newer decision appears here
- **Organized by Category:** Repo architecture, CC workflow, Obsidian, conventions
- **Dates Included:** Each decision shows when it was made and which session
- **Source:** Consolidated from session decision files in `docs/sessions/`
- **Updated By:** `/r-learn-decide` emits docs-repo decisions here

---

## 1. Repo Architecture

### Cross-Cutting / Shared-Surface "Backward-Pointer" Closes the Route-Sweep Seam (Conv 304)
**Date:** 2026-06-19 (Conv 304)

"Swept = all member routes conform or their exceptions are consciously allowed" leaves one seam: a shared component changed *after* some routes are already swept can silently un-conform those swept routes. The adopted model: sweep "done = client-showable"; shared components conform at **first-touch** (conformant-is-conformant); residual risk lands only on **unswept** routes (acceptable — they aren't demoed). The one closed leak — backward propagation from a *late change* to an already-conformed shared surface — is handled by a **backward-pointer**: any shared surface with **≥2 swept consumers** records its swept-route back-pointers, so a later change re-glances those routes. It rides the existing ledgers (README + tier2-primitive-ledger), not a new tracker.

**Rationale:** Respects the user's demo-friendly model (the user's pushback that risk lands on unswept, not swept, routes was conceded). The only structural leak is closed by a cheap pointer rather than CC's heavier verify-once-at-freeze ledger. Rejected: fix-as-we-go-verify-at-next-route (leaks orphans) and the freeze-ledger (over-engineered).

**Consequences:** `plan/route-migration/README.md` § "Cross-cutting / shared-surface handling — the backward-pointer" + tier2-ledger convention + memory `feedback_route_sweep_pause_protocol`. `[XCUT-BACKREF]` #33 retro-seeds back-pointers for surfaces already shared across the 3 swept groups.

**See:** `plan/route-migration/README.md`; `plan/route-migration/tier2-primitive-ledger.md`; `memory/feedback_route_sweep_pause_protocol.md`; Conv 304 Decisions §2.

### Favour Durable Decisions Over Faster Options (Project Guiding Principle)
**Date:** 2026-04-10 (Conv 100)

When presenting or weighing options, always present the most durable/rigorous alternative alongside any quick fix, and answer decisively when asked "which is durable?". The software should be characterized by a small number of overview directives adhered to by default and broken only for sound reasons.

**Rationale:** User stated verbatim: "I am less concerned about disruptions and more concerned about a stable outcome that survives. Are we making a convenient 'fix' to expedite moving on... or should we opt for a more encompassing solution that will last?" Accumulated quick fixes create long-term debt; stability over speed is the guiding lens. Anchored to Conv 100's Stripe apiVersion bump decision (bump pin + consolidate call sites > pin cast hacks).

**See:** `feedback_no_simplest_fix.md` in Claude memory (verbatim framing + signal checklists).

### RTMIG-4 Reframed as a 14-Group Visual-Presentation Route Sweep
**Date:** 2026-06-16 (Conv 291)

RTMIG-4 is no longer a porting backlog but a full visual-presentation sweep of **every** root route (even already-ported ones), organized into 14 `RG-*` route-group tasks. The unit is a route's `.astro` page, but scope = the whole rendered page + every subcomponent; porting is just one kind of per-route work. Each route runs a canonical **8-step process**: (1) assess Tier-1, (2) assess Tier-2 via `/w-prim-candidates`→ledger (log ALL candidates), (3) surface, (4) PAUSE — no code until cleared, (5) do ripe work, (6) browser-verify, (7) user out-of-scope review → dedicated `[<ROUTE>-FIXES]` task (capture, don't solution), (8) mark Swept. Tier-2 cross-route candidates accumulate in a route-scoped ledger (`plan/route-migration/tier2-primitive-ledger.md`), not a task — primitives extract at the route that completes the 3rd instance (Rule-of-Three). Swept = Tier-1 done + Tier-2 fully assessed + browser-verified + out-of-scope captured; un-ripe ledger candidates don't block Swept.

**Rationale:** Matches the user's intent (route as the lens for visual assessment) with exhaustive coverage. TodoWrite has no parent/child, so the durable per-page checklist lives in the README while TodoWrite holds the 14 group tasks. A cross-cutting Tier-2 task would only "close" a route; the ledger drives the actual extract-at-maturity mechanism and makes impact visible even for one-offs. Relaxes the Conv-219 "Tier-2 = one deferred cross-cutting pass" framing.

**See:** `plan/route-migration/README.md` (§ Working protocol); `plan/route-migration/tier2-primitive-ledger.md`; `memory/feedback_route_sweep_pause_protocol.md`; Conv 291 Decisions §1–3.

### Cross-Cutting Sweep Ledger Tracks Components (SoT), Derives Route Completion — TYPO-FDN
**Date:** 2026-06-18 (Conv 298)

A cross-cutting style sweep (TYPO-FDN typography/spacing, and retroactively colour) is tracked in a committed **component-level** ledger — `plan/typo-fdn/migration-ledger.md`, one row per component with per-axis checkboxes (Type/Spacing/Colour ☐/☑) and routes cross-referenced. A route is "swept" **only when all its components are ☑** — route completion is *derived*, not tracked directly. Rejected: a route/page-level checklist, which can't express "this shared piece is pending across N routes" and so renders a deferred shared component (e.g. FeedActivityCard) invisible — exactly the hole that let PALETTE-FDN's deferred `[FAC-RECOLOR]` rot.

**Rationale:** Shared components are tracked once; no route can claim done while a shared piece is ☐. The audit must be a committed artifact (not chat scrollback) or it evaporates — "light + defer" with no checkbox has no completion mechanism. This is the missing mechanism both the colour and type sweeps needed.

**See:** `plan/typo-fdn/migration-ledger.md`; `docs/as-designed/matt-design-system/09-typography.md` §9.4a; Conv 298 Decisions §3, Learnings §4.

### Style-Guide Conformance is a 4th "Swept" Gate Riding the RTMIG-4 Route Sweep
**Date:** 2026-06-18 (Conv 299)

Type/Spacing/Colour conformance (line-height folded into Type) is now a **4th gate** in the route-sweep "Swept" definition — alongside Tier-1 done, Tier-2 assessed, and browser-verified. The TYPO-FDN ledger (`plan/typo-fdn/migration-ledger.md`, retitled **Style-Guide Conformance Ledger**) becomes the per-route conformance checklist; TYPO-FDN/PALETTE-FDN are no longer parallel blocks chasing Home+/courses but the *foundations* plus the `/`+`/courses` backfill, with all other in-scope routes conforming as they're swept. **Conformance scope (IN/OUT):** IN = RG-HOME, RG-COURSES, RG-COMMS, RG-DISCOVER, RG-MESSAGES, RG-NOTIFS, RG-PROFILE, RG-SESSIONS, RG-PUBPROF, RG-MOD, RG-WORKSPACES, RG-AUTH; OUT (structural sweep only) = `/old/*`, RG-ADMIN, RG-PUBLIC (marketing, redesign-likely) — ~31 routes + all `/old` excluded.

**Rationale:** PALETTE-FDN's colour migration already "rode the sweep" per-route; extending the same model to type/spacing unifies the mechanism and closes the "Swept but not conformant" gap (RG-HOME/RG-COURSES were Swept yet TYPO-FDN sat at 3/23 components). Conformance effort belongs on user-facing surfaces that matter now — admin/marketing/legacy don't earn it.

**See:** `plan/route-migration/README.md` (§Style-guide conformance + §Conformance scope); `plan/typo-fdn/migration-ledger.md`; Conv 299 Decisions §1–2, Learnings §1.

### Reconcile a Prose SoT Against the Structured-Oracle SoT by Deep-Verify Before Backfill (Conv 326)
**Date:** 2026-06-23 (Conv 326)

When the route-migration README (prose, DOM-verified-per-state) and the conformance ledger (component-level oracle) disagree, **deep-verify the disputed groups against the 3-axis gate before backfilling the ledger to match the prose** — never trust prose "Swept" claims as a backfill source. The two SoTs silently diverged ~Conv 317 (conformance recorded inline in README prose during RG-WORKSPACES decomposition, ledger stopped being updated), leaving 3 README-"done" groups (RG-COMMS, RG-PUBPROF `/creator`, RG-WORKSPACES `/teaching*`+`/creating*`) absent from the oracle. Deep-verify (4 parallel agents walking component trees + grepping Type/Spacing/Colour) **falsified** the done-claims — all 3 had genuine forbidden-token residuals — so the ledger was **not** backfilled; re-sync (backfill + README correction) is deferred until residuals are actually fixed and re-verified.

**Rationale:** A SoT claim is a hypothesis until verified this conv (Baseline Verification). Backfilling the oracle from unverified prose would have propagated the false done-claim into the oracle, defeating its purpose. The README's "Swept = client-showable" had drifted ahead of "actually conformant." Reconciliation = cross-check claims against ground-truth, not trust prose (also: `@stand-in` grep must read the *active* marker line — history comments cause false positives).

**See:** `.scratch/2026-06-23-rtmig4-reconciliation-deepverify.md`; `plan/route-migration/README.md`; `plan/typo-fdn/migration-ledger.md`; `[RTMIG-RECON]` #27; Conv 326 Decisions §1–2, Learnings §3.

### Port = MOVE-not-copy a `/old/*` Page to Its Target Route (reverses Conv 221)
**Date:** 2026-06-08 (Conv 250)

Porting/rehosting a legacy page `git mv`s it from `/old/*` to its target route — the `/old` copy is NOT retained. This reverses the Conv-221 keep-`/old`-live rule: `/old` no longer doubles as a live production rollback or behavioral-reference baseline. The move commit becomes the behavior-diff baseline, and ports edit the moved file in place.

**Rationale:** `/old` served two jobs and both are now covered better elsewhere — behavioral reference by the preflip worktree (`peerloop-ref`) + git history (which preserves the files regardless), and live production rollback was already moot (nothing links to `/old`). For *code* archaeology the live-repo copy beats the worktree (current imports, zero setup). Matt's phase-out (Conv 239) made the parallel `/old` copy throwaway weight that kept causing file yo-yo. `[PREFLIP-WT]` re-scoped to "keep until client-vet"; `[OLD-PORTED-CLEANUP]` (#21) deletes the 44 already-ported `/old/*` copies now stale under this policy.

**See:** `memory/project_old_pages_no_delete_until_vetted.md`; `plan/route-migration/README.md` (§ Migration policy); Conv 250 Decisions §1.

### `/old`-Retirement Recovery = Git History (commit 608346a2) + Tombstone Commit + Docs Ledger — No Archive Folder (Conv 338)
**Date:** 2026-06-26 (Conv 338)

Retiring a legacy/orphaned page or component recovers from git history — the permanent anchor is the pre-flip snapshot commit `608346a2` (also live as the preflip worktree `peerloop-ref` :4331). No `/_archive` folder. Discoverability is provided by a **tombstone commit** (atomic deletion commit whose message carries the restore command) plus a **retirement ledger** section in `plan/route-migration/README.md`. Applies the Conv-311 "No Archive Folders" policy and the Conv-250 MOVE-not-copy convention to *code* retirement specifically.

**Rationale:** Git already preserves everything losslessly; an archive folder duplicates git, fights tsc/lint/build (needs excludes), rots, and diverges from the Conv-250 convention. Discoverability is solved once by the tombstone commit + docs ledger, not by carrying dead code around. Chosen over a belt-and-suspenders archive-and-commit.

**See:** `plan/route-migration/README.md` (§ OLD-PORTED-CLEANUP — retirement ledger); Conv 338 Decisions §1; tombstone commits `232e5e2e` (code) / `f2a88cf` (docs).

### Discover-Destination Tier-1 Port Recipe = Mirror `/courses`
**Date:** 2026-05-30 (Conv 221)

Porting an `/old/discover/*` destination to a Matt root page follows the `/courses` build (fidelity A): Matt shell (AppLayout) + Matt-restyled recommendations + inline-Matt role tabs (don't mutate the legacy ExploreTabBar) + Matt catalog card + search-only filter; forward-link to root detail routes that 404-honestly until built. The shared RoleTabBar primitive extraction is deferred to Tier-2 (DISC-RTB-RECONCILE, on Rule-of-Three). "Parity" means matching the new-design sibling — including its intentional omissions (admin-intel badges, sort/pagination) — not the legacy original.

**Rationale:** A strict shell-wrap (Matt frame, legacy guts) ships a half-migrated look. Compromising on role-tabs specifically inflates the eventual shared-primitive extraction because the legacy instance would have to be Matt-converted first. Mirroring the sibling keeps the converted-pages yardstick honest and the Tier-1/Tier-2 boundary clean.

**See:** `src/pages/communities.astro`, `src/components/communities/`; DISC-COMM (#29); DISC-DROP umbrella (#5).

### `/r-commit` Mid-Conv Is Allowed for Strategic Snapshots
**Date:** 2026-04-10 (Conv 100)

The memory rule "always use /r-end to commit, never /r-commit directly" applies to isolated commits. For strategic mid-conv snapshots within a multi-phase work block, `/r-commit` is appropriate when the conversation continues into the next phase. `/r-end` remains the sole owner of session doc creation at end-of-conv.

**Rationale:** `feedback_always_r_end.md` exists to prevent overlapped session docs. A mid-conv `/r-commit` only commits code — it doesn't create session docs — so the rules don't conflict. Recognized exception, not a rule change.

### Dual-Repo: Docs Separated from Code
**Date:** 2026-02-20 (Session 229 planned, Session 232 implemented)

All documentation (~899 files, ~19 MB) lives in `peerloop-docs`. Application code lives in `Peerloop`. Two sibling repos in the same parent directory.

**Trigger:** Code repo cluttered with ~861 documentation files that don't belong in a shipping codebase. Client needs a clean code repo.

**Options Considered:**
1. Keep everything in one repo (status quo)
2. Symlink repo folders INTO an Obsidian vault
3. Move docs OUT of repo into a vault, symlink back ← Chosen
4. Copy/sync approach between two locations

**Rationale:** Docs repo doubles as Obsidian vault. Claude Code follows symlinks transparently. Code repo reduced 69% (27.6 MB → 8.6 MB). Client gets browsable knowledge base as separate deliverable.

**See:** Session 232 Decisions.md

### Docs Repo as CC Home
**Date:** 2026-02-20 (Session 232)

Claude Code launches from `peerloop-docs/` with `--add-dir ../Peerloop`. The `.claude/` directory, CLAUDE.md, hooks, commands, and config all live here.

**Launch pattern:** `cd ~/projects/peerloop-docs && claude --add-dir ../Peerloop`

**Rationale:** CC home should be where the most context lives. Documentation, research, planning, and session history provide richer project context than code alone. `--add-dir` grants full tool access to the code repo.

**Consequence:** `$CLAUDE_PROJECT_DIR` always resolves to `peerloop-docs/`. Hooks referencing code repo must use `$CLAUDE_PROJECT_DIR/../Peerloop/...`.

### Same GitHub Organization
**Date:** 2026-02-20 (Session 229)

Both repos hosted in `PeerloopLLC` GitHub org.

**Rationale:** Both repos discoverable together. Client already has org access. Simplest permission model.

### Relative Symlinks for Portability
**Date:** 2026-02-20 (Session 229)

All cross-repo symlinks use relative paths (`../peerloop-docs/docs`, not `~/projects/peerloop-docs/docs`).

**Options Considered:**
1. Absolute paths — tied to specific home directory
2. Relative paths ← Chosen
3. Environment variable paths — adds complexity

**Rationale:** Works on any machine where both repos are cloned into the same parent directory. No hardcoded home directory paths. `scripts/link-docs.sh` creates the symlinks.

### Symlinks Over Copies for Build Dependencies
**Date:** 2026-02-20 (Session 232)

Code repo has symlink (`Peerloop/docs → ../peerloop-docs/docs`) created by `scripts/link-docs.sh` and gitignored.

**Options Considered:**
1. Modify build scripts to accept configurable paths
2. Symlink docs/ back into code repo ← Chosen
3. Copy files as a build step

**Rationale:** Symlinks transparent to Node.js/Vite/Astro with zero code changes. Build (0 errors) + full test suite (4891 assertions) pass without script modifications.

### CLAUDE.md as Symlink
**Date:** 2026-02-20 (Session 229)

Code repo's CLAUDE.md is a symlink to `../peerloop-docs/CLAUDE.md`. No pre-testing required — symlink resolution is an OS-level guarantee.

**Fallback:** If CC ever fails to follow the symlink, replace with a real file containing a pointer to the docs repo.

### GLOSSARY.md: Root-Level Terminology Reference
**Date:** 2026-03-05 (Session 346)

Created `GLOSSARY.md` at docs repo root as the prescriptive source of truth for all platform terminology. Covers identity hierarchy (Visitor → Member → Student → Teacher → Creator → Moderator → Admin), core domain terms, DB table naming targets, component naming conventions, and ambiguous terms to avoid.

**Trigger:** Naming inconsistencies across code, schema, and docs caused real bugs and made the codebase harder to navigate. "Student-Teacher" vs "Teacher" was the highest-impact example that prompted the glossary.

**Governance:** If code contradicts the glossary, the code is the bug. New terms must be added to the glossary before being used. Historical session docs are exempt from retroactive updates.

**See:** `docs/GLOSSARY.md`, `docs/DECISIONS.md` §1 (three related decisions)

---

## 2. Folder Structure

### Drop the PLAN.md Narrative `*Last Updated:*` Trail Entirely
**Date:** 2026-05-28 (Conv 211)

The reverse-stacked `*Last Updated: Conv N — [narrative]*` trail that `/r-end` had been prepending to the bottom of PLAN.md is deleted, and `/r-end`'s `fmt-update-plan.md` is updated to forbid future writes (explicit anti-pattern note + strengthened "Do NOT put in PLAN.md" list). The drift source was `fmt-update-plan.md` action #5 "Update Last Updated footer timestamp," which had drifted into writing full narrative paragraphs with chronological PREVIOUS chains.

**Rationale:** `/r-end` already writes 3 files per conv under `docs/sessions/YYYY-MM/` (Extract, Decisions, Learnings). The Extract IS the canonical per-conv narrative. The PLAN.md trail was a denormalized echo with zero unique value. The "readable from PLAN.md alone" use case the trail served is itself broken now that PLAN.md is a thin index post-Conv-210/211 migration. Splitting the trail by block (rejected option) was actively argued against — entries are narrative-shaped and resist clean splits.

**Consequences:** PLAN.md drops ~100 lines per conv of redundant content; `/r-end` doc-bookkeeping load drops. The `fmt-update-plan.md` anti-pattern note also forbids inventing a "Next Steps" footer (the same drift class — action #4 referenced a section that doesn't exist).

### Don't Annotate PLAN.md Prose With Volatile TodoWrite Task-Ids (PLAN-RENUM)
**Date:** 2026-06-15 (Conv 286)

PLAN.md must not carry `[CODE] #NN` / `[CODE] (#NN…)` task-id annotations — volatile TodoWrite ids that renumber every conv and rot in place. Such code-adjacent annotations are stripped (Conv 286 removed 33). Legitimate `#N` references are preserved: PR numbers, `COMPLETED.md` refs, upstream GitHub issue ids (5-digit), prose-woven sentence refs, and ranges. Discriminate by digit-width (≤3 = task-id, 5 = issue) plus `[CODE]`-bracket adjacency. The durable fix is go-forward discipline (don't write TodoWrite ids into PLAN.md prose), not periodic re-stripping.

**Rationale:** TodoWrite ids are session-scoped and renumber; embedding them in the cross-conv PLAN.md surface produces stale, misleading cross-references that are expensive to audit as convs accumulate. The bare-prose refs are genuine sentence content and can't be mechanically stripped, so prevention beats cleanup. Pairs with the `feedback_fix_docs_inline_not_rend.md` memory (fix doc cross-refs inline; don't rely on `/r-end`'s update-plan agent, which only touches active-block subtasks/status cells).

**Consequences:** 21 PLAN.md lines changed (one range corruption caught + fixed pre-commit). A blind strip would conflate the three `#N` namespaces — the discriminator (digit-width + `[CODE]`-adjacency) is required.

### Cross-Conv Watch Tasks Consolidated into a Single PLAN.md Section (Not TodoWrite)
**Date:** 2026-05-28 (Conv 211)

The 8 unique pending watch-tasks previously scattered across 3 Conv-N drain sections (150-157, 179, 206) are consolidated into a new `## Cross-Conv Watch Tasks` section in PLAN.md, between Block Sequence tables and BBB-RECORDING. Items are NOT migrated into TodoWrite. Items already in TodoWrite ([DTUNE-WATCH] #26, [SKILL-DISCOVERY-WATCH] #27) are explicitly not duplicated.

**Rationale:** PLAN.md keeps watch-tasks visible in the project's forward-looking surface. TodoWrite is for current-session work; watch-tasks span many sessions and the trigger conditions matter more than the per-session tracking. A standalone `plan/watch-tasks.md` file (rejected B option) added a step (open a separate file) without solving a real problem.

**Consequences:** 3 mixed Conv-N drain sections collapse into 1 clean watch-task surface (8 items, each with explicit trigger condition). 4 other Conv-N sections delete entirely per the next decision below.

### Conv-N Drain Sections With Zero Unique Pending Content Get Deleted, Not Archived
**Date:** 2026-05-28 (Conv 211)

Conv-N drain sections in PLAN.md (e.g., "Conv 168 Items," "Conv 200 Items") with 100% done bullets — or only pending items already tracked in TodoWrite — are awk-deleted entirely rather than archived per-section in `plan/COMPLETED.md`. The principle extends `fmt-update-plan.md`'s "PLAN.md contains only work that remains to be done" to chronological drain sections.

**Rationale:** Per-conv archival is what `docs/sessions/YYYY-MM/<timestamp> Extract.md` is for. `plan/COMPLETED.md` is for block-level closure entries, not chronological drains. Git log + grep for `[CODE]` recovers any granular detail if needed.

**Consequences:** 4 sections removed from PLAN.md (Conv 168, Conv 169, Conv 157 Timecard, Conv 200) without loss of recoverable information. Total PLAN.md size after Conv 211 retrofit: 530 lines (down from 1933 at conv start, −72.6%).

### Plan-File Restructuring: `plan/` Directory + Per-Block Subdirectories (MATT Migrated First)
**Date:** 2026-05-28 (Conv 210)

PLAN.md at 2700+ lines was unmanageable and growing. Adopted a hybrid plan-file structure: thin PLAN.md index at root (ACTIVE table now uses 3-5 line B-richness summaries + `→ [plan/<slug>/README.md]` links for migrated blocks; ON-HOLD/DEFERRED stay one-liner + link). New `plan/` directory at peerloop-docs root holds per-block subdirectories (e.g., `plan/matt/` with README + cutover + 7 phase files + standin-matt). Migrated MATT-DESIGN-PUSH this conv as both the growth driver and the pattern-establisher; other ~29 blocks migrate one-at-a-time as each gets active attention. `COMPLETED_PLAN.md` moved to `plan/COMPLETED.md` via `git mv` (12 references updated across config + 6 skill files + CLAUDE.md + 2 docs).

**Rationale:** PLAN.md will balloon further as `@matt-inspired`/`@matt-source` page conversions land — the MATT block alone justified extraction. Hybrid mode (PLAN.md index for non-migrated blocks, per-block subdirectory for migrated ones) avoids both the bulk mechanical work of full migration and the "half-done" smell of pure design. Per-block subdirectories with README + per-phase files preserve substantive history at finer granularity than a flat per-block file. Lazy migration (only when block gets attention) avoids investing in blocks that may not need attention soon.

**Consequences:** PLAN.md down 30% (2769 → 1933 lines). 11 new files under `plan/matt/` (~804 lines total). `/r-start` SKILL.md Step 8 now crawls `plan/*/README.md` (head -40 per file) for migrated-block WIP. 21 pure-MATT Conv N Items sections removed from PLAN.md (extracted into the relevant phase file's per-conv subsection). `plan/COMPLETED.md` stays terse per `fmt-update-plan.md`; migrated blocks mark their README "✅ COMPLETE" in place when done rather than moving content into COMPLETED.md. Year-rollover (`COMPLETED-001-200.md`) is the fallback if growth ever happens. Non-migrated PLAN.md ACTIVE rows (NAV-RETROFIT, ROUTE-MIGRATION, etc.) keep their pre-existing long-cell narratives until their own migration moment.

**See:** `plan/matt/README.md` (overview), `plan/matt/{cutover,phase-1-tokens,phase-2-shell,phase-3-pg1,phase-4-prm,phase-4.5-cmp,phase-5-pg2,phase-6-ext,phase-7-grd,standin-matt}.md`, `.claude/skills/r-start/SKILL.md` Step 8, `CLAUDE.md`, Conv 210 Decisions.md §1-7.

### Repository Layout
**Date:** 2026-02-20 (Session 232, updated Session 233)

```
peerloop-docs/
├── .claude/                  # CC configuration
│   ├── commands/             # Slash commands (project-specific -local variants)
│   ├── hooks/                # SessionStart hooks
│   ├── settings.json         # Permissions & hook config
│   └── config.json           # Project paths & feature flags
├── .obsidian/                # Obsidian vault config (gitignored, local per user)
├── CLAUDE.md                 # Full project guidance for CC
├── PLAN.md                   # Current & pending work
├── COMPLETED_PLAN.md         # Completed work
├── DOC-DECISIONS.md               # This file — docs repo decisions
├── SESSION-INDEX.md          # Session log index
├── docs/
│   ├── sessions/             # Development session logs (by month)
│   ├── DECISIONS.md          # Peerloop application decisions
│   ├── GLOSSARY.md           # Platform terminology
│   ├── POLICIES.md           # Platform behavior policies
│   ├── reference/            # CLI, API, testing docs, coding standards
│   ├── vendors/              # Vendor/service decision docs
│   ├── architecture/         # Architecture & design docs
│   └── guides/               # How-to guides
└── scripts/
    └── link-docs.sh          # Symlink setup for code repo
```

### What Goes Where

| Content Type | Location | Committed? |
|-------------|----------|:----------:|
| CC commands, hooks, config | `.claude/` | Yes |
| Obsidian vault config | `.obsidian/` | No |
| Application decisions | `docs/DECISIONS.md` | Yes |
| Docs-repo decisions | `DOC-DECISIONS.md` | Yes |
| Current/pending work | `PLAN.md` | Yes |
| Session logs | `docs/sessions/YYYY-MM/` | Yes |
| Technology decisions | `docs/reference/*.md`, `docs/as-designed/*.md` | Yes |
| Specifications & schemas | `docs/reference/`, `docs/requirements/` | Yes |
| Client change requests | `docs/requirements/rfc/CD-XXX/` | Yes |
### Docs Folder Reorganization: vendors/ + architecture/
**Date:** 2026-03-09 (Session 362)

Split `docs/tech/` into `docs/reference/` (19 files — external service/library decisions) and `docs/as-designed/` (13 files — internal design patterns). Dropped `tech-0XX-` numbering prefix, using descriptive names (e.g., `stripe.md`, `state-management.md`). Moved 9 root files to appropriate folders (DECISIONS.md, GLOSSARY.md, POLICIES.md → `docs/`; BEST-PRACTICES.md → `docs/reference/`; navigation docs → `docs/as-designed/`; USER-STORIES-MAP.md → `docs/requirements/`).

**Trigger:** `docs/tech/` had drifted to contain both vendor evaluations and internal architecture docs. Deciding where new docs should go required guessing.

**Consequences:** 42 files moved, ~200 references updated across ~65 files. Session logs left unchanged — `docs/DOCS-REORG-MAP.md` serves as old→new path lookup. Config updated: `techDocs` key in `.claude/config.json` replaced with `vendorDocs` + `architectureDocs`.

> **Insight:** Three reorganizations in this project followed the same pattern: incremental drift → cognitive threshold → systematic reorganization (terminology ~960 files, page specs ~312 files, docs folders ~65 files). The mapping document is the critical artifact — it costs nothing to create and makes the historical record navigable forever. (Session 362)

### Session Logs Immutable During Reorganizations
**Date:** 2026-03-09 (Session 362)

When reorganizing folder structure or renaming files, session logs are NOT updated. They reference the paths that existed at the time. A mapping document (`docs/DOCS-REORG-MAP.md`) provides old→new lookup.

**Rationale:** Session logs are historical records. Changing paths retroactively makes them less accurate. The terminology block (Sessions 346-356) updated session logs, but that was a content change (wrong terms), not a structural reorganization.

### No Archive Folders — Use Git History
**Date:** 2026-02-28 (Session 311)

When deleting large batches of files, do not archive them into an `archive/` subfolder. Git history preserves everything with full commit context. Archive folders just move clutter around and create their own maintenance burden (references to update, contents to eventually question again).

**Rationale:** Sessions 307-311 progressively archived 312 PageSpec files (17MB) into `docs/archive/`, then deleted the archive entirely when it proved useless. Skip the intermediate step in future.

### Skill Interplay Merged Into skills-system.md
**Date:** 2026-04-06 (Conv 089)

All skill documentation (architecture + runtime interplay) lives in one file: `docs/as-designed/skills-system.md`. SPT had a separate `SKILL-INTERPLAY.md`; Peerloop merged the content into the existing file.

**Rationale:** One file for both how skills are built and how they interact at runtime. Peerloop doesn't have a `docs/as-built/` directory, so a separate file would create an orphan.

### docsRegistry: pattern-based shared registry for doc-aware tooling
**Date:** 2026-04-18 (Conv 132)

`.claude/config.json.docsRegistry` is the canonical shared registry for all doc-aware tools (`sync-gaps.sh`, `tech-doc-sweep.sh`, `/w-sync-docs`). Schema: `groups[]` with `id`, `category` (`generated` | `driftCheck` | `manual` | `archival`), `pattern`/`patterns`/`docs`, `sourceOfTruth`, `checks`, `consumers`. Groups use globs for scale with `notPattern` for exclusions; explicit `docs` arrays for mixed-ownership groups.

**Rationale:** Three sibling drift tools each carried their own hardcoded lists — adding a new tech vendor meant editing three bash files. Per-file registry rejected as too noisy for 200+ docs; tree-level convention rejected as too coarse (`_COMPONENTS.md` is driftCheck while siblings are archival). Pattern-based + overrides captures both shape and exceptions. Full design in `docs/as-designed/doc-sync-strategy.md`.

### Default Doc Maintenance Tier Is `manual` — driftCheck Is Opt-In (Conv 200)
**Date:** 2026-05-26 (Conv 200)

The 4 docsRegistry categories ARE the doc maintenance tiers: `driftCheck` = auto-maintained (drift hook + /r-end docs agent + sync-gaps act on it), everything else (`manual`, `generated`, `archival`) is editorial/leave-alone. The `doc-category` matcher in `docs-registry.mjs` resolves any path NOT in a driftCheck group to `manual` — so new/unclassified docs cost zero maintenance by default. `tech-doc-sweep.sh` is gated on `category==driftCheck`; vendor-docs reclassified `driftCheck`→`manual` (keyword rules RETAINED as a code→vendor knowledge map, only the *output* is gated). `api-docs` kept as driftCheck (route-coverage check is cheap/mechanical). Implemented across `config.json`, `docs-registry.mjs`, `tech-doc-sweep.sh`, `r-end/SKILL.md` + `refs/fmt-docs.md` (Agent 3 driftCheck-only, "no docs" valid), CLAUDE.md ("When Working with a Technology" rewrite + Maintenance-Tiers table), `doc-sync-strategy.md` §8.

**Rationale:** The recurring doc-maintenance wall-time comes from the *obligation to keep docs current*, not the doc count. Inverting the default (unmaintained unless opted in) reclaims that time with a small diff and makes future docs free by default. Chosen over tagging ~90 docs with explicit tier headers, and over deleting vendor keyword rules (which would have forced a test-suite rewrite). Centralizes policy in the registry `category` field; all consumers inherit it.

### `docs/archive/` Folder for Frozen-but-Referenced Docs (Refines "No Archive Folders") (Conv 200)
**Date:** 2026-05-26 (Conv 200)

Superseded docs that still have live incoming references move to `docs/archive/` (not deleted) with a `🗄️ ARCHIVED` provenance banner; live refs are repointed. 4 frozen docs moved (admin-intel-plan, plato-implementation-plan, comp-cloudflare-vs-vercel, STORY-GAP-ANALYSIS); `orig-pages-map.md` left in place (6 active incoming refs, already `archival` category). Vendor docs reclassified to `manual` get a `📌 Snapshot — official source canonical` banner; accurate vendor docs are NOT mass-trimmed (low-value busywork that risks losing Peerloop-specific gotchas). Only `reactjs.md` (actively misleading "Alpha Peer" pre-build snapshot) was refreshed.

**Rationale:** Refines the Session 311 "No Archive Folders" policy rather than reversing it — that policy targets *bulk deletion of dead files* (312 PageSpec files), where git history suffices. A handful of frozen docs that are still *referenced* benefit from a stable, banner-marked location so links don't break and readers know the content is point-in-time. Git preserves everything regardless.

### Legacy `_`-Prefix Doc Retirement (Conv 132)
**Date:** 2026-04-18 (Conv 132)

Deleted 8 `_`-prefix legacy docs (~6,265 lines): `_DB-SCHEMA.md`, `_API.md`, `_SERVER.md` (reference/), `_STRUCTURE.md`, `_RESEARCH-CLAUDE.md` (as-designed/), `_DIRECTIVES.md`, `_PAGES.md`, `_SPECS.md` (requirements/). Retained `_COMPONENTS.md` (1,761 lines) — load-bearing, referenced by `/w-add-client-note` and CLAUDE.md; reclassified from `archival` to `driftCheck` against `src/components/**`.

**Rationale:** The 8 deleted files were either pre-rebrand "Alpha Peer" artifacts or GATHER/RUN-001 stubs with newer canonical successors. Git history preserves them — no archive folder (per existing "No Archive Folders" policy, Session 311). Retirement audit pattern: grep `.claude/skills/**` and top-level `CLAUDE.md` before proposing any doc for deletion.

### Subsystem-Design Docs Live in `docs/as-designed/`
**Date:** 2026-04-18 (Conv 132)

System-design docs describing how a `.claude/` subsystem works (e.g., `skills-system.md`, `doc-sync-strategy.md`) belong in `docs/as-designed/`, not `docs/reference/`. `reference/` is for usage-oriented material (CLI, API, vendor docs); root level is for project-wide governance ledgers (DECISIONS.md, POLICIES.md).

**Rationale:** Matches existing `docs/as-designed/skills-system.md` placement and CLAUDE.md's documentation map. Prevents ambiguity when authoring future subsystem docs.

### `.scratch/` Gitignored Persistent Workspace Convention
**Date:** 2026-05-13 (Conv 159)

`.scratch/` at docs-repo root is a gitignored persistent workspace where CC may freely write files that need to survive conversation scrollback but aren't worth committing — draft messages (emails, Slack replies), before/after snapshots tracking specific changes, skill execution logs, intermediate artifacts, paste-ins. Two-tier documentation: short pointer in CLAUDE.md §Scratch Space, detailed conventions in `.scratch/README.md` (gitignored alongside contents).

**Trigger:** User explicitly requested a place to park files (the Fred-at-Blindside draft email in particular) that survive past conversation scrollback. Noted the pattern works well in other CC projects.

**Options Considered:**
1. Use `/tmp/` for scratch (ephemeral; lost on reboot; subagent sandbox blocks it)
2. Use `.scratch/` gitignored folder at docs-repo root ← Chosen
3. Use Obsidian vault for scratch

**Rationale:** Persistence across conversations is the key property — scrollback lost vs scratch file re-readable. Gitignored prevents accidentally committing drafts/notes/dumps. Local-only matches scratch semantics; mirror sync would clutter both machines. Pattern proven on other CC projects.

**Consequences:** Future CC pre-authorized to write here without checking. Repo root has one more entry (`.scratch/`). Not synced between machines (intentional — scratch is per-machine, per-conversation context). Boundary explicit in README "Not for" section: secrets, repo content, memory content.

> **Insight:** Two-tier documentation (CLAUDE.md pointer + artifact-internal README) mirrors how the project documents technology stacks — short pointer is always-loaded, detailed reference is on-demand. Generalizes to any project convention worth documenting durably without bloating CLAUDE.md.

**See:** `CLAUDE.md` §Scratch Space, `.scratch/README.md`, `.gitignore`

---

### Scratch Workspace = Real `_scratch/` Dir + `.scratch` Compat Symlink (Obsidian Visibility) (Conv 300)
**Date:** 2026-06-18 (Conv 300)

The scratch workspace's REAL directory is now `_scratch/`; `.scratch` is a symlink → `_scratch`. Both gitignored. This makes the workspace visible inside Obsidian (peerloop-docs is itself a vault) — Obsidian canonicalizes a symlink to its real path and then hides dot-targets, so a `_scratch → .scratch` symlink stayed hidden; only flipping the REAL dir to a non-dot name surfaces it. Every existing `.scratch/` reference (~477 across ~140 files) resolves unchanged through the compat symlink, so the net tracked change is 2 lines of `.gitignore`. Machine-local: re-create the flip per machine; do NOT delete the `.scratch` symlink or revert.

**Rationale:** Surfaces scratch artifacts in Obsidian without rewriting ~477 references; the symlink absorbs the entire blast radius. Refines the Conv-159 `.scratch/` convention (the real path changed name; the `.scratch/` interface is preserved).

**See:** `.gitignore`; `memory/project_scratch_obsidian_symlink.md`; Conv 300 Decisions §1, Learnings §1.

---

### Figma Source Screenshots Committed to `docs/as-designed/figma-screenshots/`
**Date:** 2026-05-22 (Conv 172)

Figma Variables / page-structure / component-collection screenshots used as source material for `docs/as-designed/matt-design-system.md` are committed to `docs/as-designed/figma-screenshots/` (NOT `.scratch/`, NOT discarded). Each PNG is catalogued inline in the spec doc's "Source Materials" section noting what it sourced. ~480KB for 8 PNGs (Conv 172 baseline) is negligible bloat.

**Trigger:** User: "The variables screenshots I showed your earlier. Is there a place for these in your design?"

**Options Considered:**
1. Discard sources — extracted data is in the doc
2. Save to `.scratch/matt-main/figma-screenshots/` (gitignored, local-only)
3. Save to `docs/as-designed/figma-screenshots/` (committed, near the doc) ← Chosen

**Rationale:** Source artifacts disconnect from doc text easily — without commitment, future readers can't verify any extraction decision against its origin. Co-locating PNGs with the spec doc (same folder under `docs/as-designed/`) makes provenance discoverable. Gitignored `.scratch/` loses sources on machine swap and doesn't propagate cross-machine via Obsidian sync; committed gives durable cross-machine availability. Pattern generalizes to any spec doc derived from external visual source material.

**Consequences:** Created `docs/as-designed/figma-screenshots/` with 8 PNGs (Conv 172 baseline; 4 page-structure frames + 5 variable-collection screenshots, one removed as wrong-target). Added "Source Materials" section to `matt-design-system.md` cataloguing each PNG with what it sourced. Future Matt-related screenshots land in the same folder.

**See:** `docs/as-designed/figma-screenshots/`, `docs/as-designed/matt-design-system.md` §Source Materials

---

### Matt Pre-Plan Doc: Single File `docs/as-designed/matt-pre-plan.md` Paired With Spec
**Date:** 2026-05-22 (Conv 173)

The Matt-design execution plan lives as a single file at `docs/as-designed/matt-pre-plan.md` (~510 lines, 12 sections), paired with the spec doc `matt-design-system.md` via a Companion-doc cross-reference at the top of the spec ("Reading order: this doc first — *what*, pre-plan second — *how*"). Matches the existing `*-plan.md` pattern (`admin-intel-plan.md`, `plato-implementation-plan.md`). At doc graduation (Phase 7 `[MATT-EXEC-GRD]`), the 🚧 banner on the spec flips AND the pre-plan archives to historical status.

**Options Considered:**
1. Directory `docs/as-designed/matt-pre-plan/` with sub-files per deliverable — over-engineered for a one-time planning artifact
2. Single file `docs/as-designed/matt-pre-plan.md` ← Chosen
3. Append as new section to `matt-design-system.md` — conflates spec (*what*) with plan (*how*)

**Rationale:** Established docs-tree pattern (no novelty). Single file is the right size for a 12-section plan (~510 lines is browsable in one read). Spec + plan as paired artifacts means each can evolve at its own pace; flipping the 🚧 banner on the spec doesn't require touching the plan.

**Consequences:** New file lands in `docs/as-designed/`. `docs/INDEX.md` may need an entry under "How Should It Look/Work?". Doc-graduation criteria (§8 of pre-plan) include flipping the 🚧 banner on the spec AND archiving the pre-plan to historical status when Phase 7 completes.

**See:** `docs/as-designed/matt-pre-plan.md`, `docs/as-designed/matt-design-system.md` Companion-doc cross-reference

---

### Pre-Plan §"Open Decisions": "BLOCKING → RESOLVED Conv N" Heading Transition
**Date:** 2026-05-22 (Conv 173)

When a pre-plan section gates downstream execution, title it `## N. Open Decisions (BLOCKING)`. At resolution, edit the heading to `## N. Open Decisions (RESOLVED Conv N)` and prepend a 1-row-per-decision resolution-summary table at the top of the section. Individual decision analyses stay intact below for traceability.

**Rationale:** Pre-plan docs are time-staged artifacts. State transitions belong in the section heading itself so a reader skimming the doc 3 convs later sees status at a glance. Don't delete the original "BLOCKING" framing — convert it (heading + summary table) so the gate path is preserved. The 8-decision resolution in Conv 173 §4 of `matt-pre-plan.md` is the motivating case.

**Consequences:** Future pre-plan docs follow the same convention. Reviewers can scan the table-of-contents to find unresolved gates. Doc-graduation criteria (when `[MATT-EXEC-GRD]` runs) check that all `BLOCKING` headings have transitioned to `RESOLVED Conv N`.

**See:** `docs/as-designed/matt-pre-plan.md` §4 "Open Decisions (RESOLVED Conv 173)"

---

### `.scratch/<project>-figma-pages.md` URL-Lookup Pattern for Multi-Page Figma Files
**Date:** 2026-05-23 (Conv 180)

When using Figma Remote MCP against a file with multiple pages, store user-supplied page URLs in `.scratch/<project>-figma-pages.md` as a build-phase lookup table. Promote to `docs/as-designed/<project>-figma-pages.md` at the corresponding execution-phase graduation step (e.g., MMP-PH5 for Matt-design push).

**Rationale:** Figma Remote MCP is link-based by design — `get_metadata(fileKey)` returns only currently-scoped pages, not the full file. The user-as-navigator workflow requires URL persistence across convs. `.scratch/` is the right home during build phase (gitignored, high update frequency); committed `docs/as-designed/` is the right home at graduation per the established `.scratch/` → `docs/as-designed/` promotion pattern.

**Consequences:** Conv 180 created `.scratch/matt-figma-pages.md` with 9 pages + probe history. Dev-Ready frames lookup will follow the same pattern at `.scratch/matt-figma-dev-ready.md` ([MDR] task #36). At MMP-PH5 graduation, both files promote to `docs/as-designed/`.

**See:** `.scratch/matt-figma-pages.md`; `memory/reference_figma_mcp_behavior.md`

### `.scratch/matt-frames-ready-for-dev.md` Drift-Detection Lookup + Side-Effect Icon Discovery
**Date:** 2026-05-24 (Conv 186)

Permanent drift-detection lookup at `.scratch/matt-frames-ready-for-dev.md`: one row per Matt-promoted "Ready For Dev" frame, capturing Frame URL, Status banner URL, Parent Page (name + node-id), banner Title, Status, raw Last Touched, ISO Last Touched. Two workflows attach:

1. **Drift check** — cheap parallel probes of all stored Status banners; compare current Last Touched to stored; any mismatch triggers a deep `get_design_context` probe of the corresponding Frame to surface what changed.
2. **Side-effect Material-icon discovery** — every deep frame probe scans `<img data-name="…">` instances and auto-creates `[<ICON>-ICN]` TaskCreate entries for unharvested icons.

File graduates to `docs/reference/matt-frames-ready-for-dev.md` at MMP-PH5 per the established scratch→memory→docs flow. Maintenance tracked permanently in `[MFRD-LOOKUP]` (#30).

**Rationale:** The user-as-navigator workflow needs persistent state for drift comparison — banner text isn't programmatically discoverable except by probe. Side-effect icon discovery replaces an umbrella "incremental harvest" task (vague, easy to forget) with an automatic trigger that fires every time a frame is deep-probed for any reason. Per CLAUDE.md §Solution Quality default-durable rule, the lookup-as-architecture-encoding pattern surfaces route families and assumptions as a free side-effect of the cataloging work.

**Consequences:** Conv 186 seeded 32 rows covering Components (12) + Happy Path (15) + Layout (5) pages — all carry `Last Touched May 20, '26`. Four route families surfaced organically: Components singletons, Home variants, Course SubNav tabs, Page-prefixed flows (Enroll funnel + Session lifecycle). `[CMP-EXT-ICN]` umbrella task deleted; 5 specific icon harvest tasks remain.

**See:** `.scratch/matt-frames-ready-for-dev.md`; `memory/reference_figma_mcp_behavior.md`

---

### Oversized `as-designed` Specs Split Into a Folder (INDEX + Concern Files + Stub Pointer)
**Date:** 2026-05-25 (Conv 192)

When an `as-designed` spec outgrows a single browsable file (~1,500+ lines), split it into a `docs/as-designed/<name>/` folder: an `INDEX.md` (overview + navigation table + appendices such as Source Materials / Document Lineage) plus one concern-scoped file per major section. Leave the original `<name>.md` path as a short **stub** — a pointer to `INDEX.md` plus an "old §N → new file" mapping table — so inbound links (including immutable `docs/sessions/` archives and `§N`-anchored references) keep resolving without rewriting history. Anchored to `matt-design-system.md` (1,717 lines → folder of `INDEX.md` + 7 concern files `01`–`07`).

**Contrast with the single-file pre-plan decision (Conv 173):** the Matt *pre-plan* was deliberately kept a single file because it is a ~510-line one-time planning artifact (a directory was rejected there as over-engineered). This decision applies to the opposite case — a large, multi-concern, *living* spec whose sections evolve independently. The trigger is **size + living-multi-concern**, not doc type per se.

**Options Considered:**
1. Leave as one 1,717-line file — too large to navigate; §5 alone conflated three concerns (color tokens / component primitives / conventions)
2. Folder + `INDEX.md` + concern files + stub pointer ← Chosen
3. Delete the old path and rewrite all inbound refs — breaks the "Session Logs Immutable" convention (103 inbound refs, most in dated session archives)

**Rationale:** Concern-scoped files are independently browsable and editable; the stub preserves every inbound link at near-zero cost (no session-archive rewrites). Split executed via `sed` line-range slices and verified **byte-for-byte lossless** against the original body before the stub overwrote the source.

**Consequences:** `matt-design-system.md` → stub; new `matt-design-system/` folder (`INDEX.md` + `01-strategic-context` … `07-token-scaffolding`). `docs/INDEX.md` updated to point at the folder `INDEX.md`. The 🚧-banner doc-graduation step (Phase 7 `[MATT-EXEC-GRD]`) now flips the banner in `INDEX.md`. Future oversized `as-designed` specs follow this pattern.

**See:** `docs/as-designed/matt-design-system/INDEX.md`; stub at `docs/as-designed/matt-design-system.md`; contrast entry "Matt Pre-Plan Doc: Single File" (Conv 173)

---

### Split Monolithic `docs/DECISIONS.md` Into a `docs/decisions/` Folder + Pointer Root
**Date:** 2026-05-31 (Conv 228)

The 4572-line `docs/DECISIONS.md` was split into a `docs/decisions/` folder: eleven topic chunks (`01`–`11-*.md`, grouped by impact, curated latest-wins) + `decision-log.md` (the chronological dated log) + `terminology-footnotes.md` + an `INDEX.md` listing all 396 decision titles with write-path rules. The root `docs/DECISIONS.md` becomes a thin pointer to the folder, preserving its 189 inbound refs. Follows the same recipe as the matt-design-system split (sed line-range slices, verified 396/396 `###` preserved, stub overwrites source).

**Options Considered:**
1. Chronological chunks by conv-range — rejected
2. Topic chunks by the existing 11 sections ← Chosen
3. Root file deleted vs. kept as pointer — kept as pointer (preserves 189 refs)

**Rationale:** Matches the existing 11-section structure + the matt-design-system folder-split precedent; keeps the chronological log intact for contradiction-checking; the pointer root keeps every inbound ref resolving. The user initially preferred chronological chunks but deferred ("I was wrong about the chronology … you're in a better position to know what works best for you").

**Write-path:** New decisions go to the matching topic chunk (`01`–`11`, latest-wins) + a dated entry appended at the bottom of `decision-log.md` + the title added to `INDEX.md`. 4 skills (`r-end`, `w-post-fix`, `w-sync-docs`, `r-commit`) + `.claude/config.json` still name `DECISIONS.md` as a write target → retargeting tracked by **[DEC-SKILL-SYNC]** (#35); until then route inline "update DECISIONS.md" edits to the correct chunk.

**See:** `docs/decisions/INDEX.md`; pointer root `docs/DECISIONS.md`; Conv 228 Decisions.md §1.

---

## 3. Claude Code Workflow

### No Persistent Dev Server — CC Spins Up an Ephemeral On-Demand `npm run dev` and Tears It Down (Conv 367)
**Date:** 2026-07-06 (Conv 367)

Reverses the prior "keep the always-open `:4321` dev server and reuse it" convention. There is **no long-running dev server**; when CC needs browser/DOM verification it starts `npm run dev` on-demand and kills it when the check is done. Root cause that forced the reversal: a dev server launched via a Claude **background shell** is a child of the long-lived `claude` CLI process (not the conversation), so `/clear` wipes the context but does **not** restart the CLI or kill/untrack its background shells — the server orphaned and ran 22h across cleared convs, and made `/quit` warn about a running background shell. The old orphaned tree was re-homed to the user's terminal and killed. Exercised 3× this conv (spin up → DOM-verify → tear down → confirm `:4321` free), each clean.

**Rationale:** The ephemeral pattern avoids the orphaned-CLI-shell class entirely — nothing survives past the check that launched it, so `/quit` stays clean and no stray server lingers across convs. User chose "I spin up an ephemeral one" over asking the user to start it or a check-then-ask flow.

**See:** `docs/sessions/2026-07/20260706_1447 Decisions.md` §1, Learnings §4; `memory/feedback_persistent_dev_server_4321.md` (rewritten) + MEMORY.md index pointer.

### Neutralize CC's `AskUserQuestion` AFK Auto-Proceed via `CLAUDE_AFK_TIMEOUT_MS` in Both Settings Scopes (`[AFK-CFG]`, Conv 361)
**Date:** 2026-07-03 (Conv 361)

CC v2.1.198+ added an **AFK auto-proceed**: an unanswered `AskUserQuestion` auto-continues after `CLAUDE_AFK_TIMEOUT_MS` (default 60000 ms) with a "proceed using your best judgment" harness-injected message — which directly conflicts with this project's consent discipline (a non-answer ≠ consent). The user (who called it "potentially disastrous") is having it neutralized. There is **no boolean disable** and `0` is a trap (fires *immediately*), so it is set to `2147483647` (max int32, ~24.8 days) in **both** `~/.claude/settings.json` (global, all projects this machine) **and** the git-tracked project `.claude/settings.json` (syncs to M4). Set via the `env` block (same channel as the working `CLAUDE_CODE_DISABLE_MOUSE`); read at session start, so effective next launch. Companion `CLAUDE_AFK_COUNTDOWN_MS` (default 20000) controls the on-screen warning and was left alone.

**Rationale:** The risk is universal (all projects → global) and the user works cross-machine (git-tracked project settings auto-sync to M4), so **both** scopes are needed. Verified the var name + semantics against the official CC docs (`code.claude.com/docs/en/env-vars.md`), not inferred. `0` rejected (immediate-fire trap); a shell-alias export rejected (doesn't cover both machines / all launch paths).

**See:** `docs/sessions/2026-07/20260703_1246 Decisions.md` §1, Learnings §1; `.claude/settings.json` (project) + `~/.claude/settings.json` (local); commit docs `3e15079`.

### Adopt the spt `CURRENT-TASKS.md` Task-Persistence Model — Split, Don't Merge (Conv 350)
**Date:** 2026-06-29 (Conv 350)

Task persistence moves from the old split (RESUME-STATE-Remaining + a machine-local `.scratch/conv-tasks.md`) to the spt model, which **splits three roles, it does not merge them**: (1) `CURRENT-TASKS.md` at the docs-repo root = the durable git-tracked task store (Ordered / Unordered+Parked / Completed-this-conv, `[TAG]`-keyed, hand-editable, **never deleted**); (2) `RESUME-STATE.md` **demoted to narrative-only** per-conv handoff (still deleted+rebuilt, keeps its Branch line so `conv-branch-check.sh` + `[RSTART-DIFFGATE]` need no repointing); (3) the machine-local `conv-tasks.md` is **retired**. The refresh is a Claude-executed **preserve-then-overlay** full Write (reconstructed from the old file, never Edit/delete/reorder). Two parameters lock the cadence: **active-only TodoWrite hydration** (DEC-350-2 — `/r-start` leaves TodoWrite empty; TaskCreate reusing the `[CODE]` only when an item is started) and **checkpoint-refresh, not live-sync** (DEC-350-3 — refresh at `/r-commit`, `/r-end`, new `/r-update-tasks`; a mid-conv crash loses the in-conv task delta, accepted). Multi-conv block `[CURTASKS]`: Phase 1 (design + seed `CURRENT-TASKS.md` with the transitional banner + `PLAN.md § CURTASKS`) done Conv 350; the skill cutover is Phases 2–5.

**Rationale:** `conv-tasks.md` ballooned from a throwaway current-conv reading aid into a semi-persistent backlog mirror, and being machine-local (gitignored) it was stale-on-return by the count of convs run on the other machine — which also systematically false-halted the no-shrink reconciliation guard on every machine-switch. One git-tracked file is identical on both machines, ends both the staleness and the guard, and gives a persistent readable "what I'm working on" surface the machine-local file could never provide cross-machine. Demoting (not deleting) RESUME-STATE keeps the branch-check scripts working untouched. Active-only hydration keeps the spinner clean and the at-risk checkpoint delta small. Rejected: A (re-separate back to ephemeral — loses persistence) and C (patch the machine-switch reconciliation only — keeps the fragile split).

**Consequences:** New root `CURRENT-TASKS.md` (NEW Conv 350, `310da50`) + `PLAN.md § CURTASKS` design block (Why / split architecture / DEC-350-1/-2/-3 / 5-phase plan / rewire surface). Phases 2–5 rewire the skills: read path (`/r-start` drops the RESUME-STATE→TodoWrite transfer), write path (`/r-end`/`/r-commit` + new `/r-update-tasks`), scripts/config, docs/memory. DEC-350-3 crash-resilience trade flagged revisitable at cutover.

**See:** `docs/sessions/2026-06/20260629_2056 Decisions.md` §1–3, Learnings §1–3; `PLAN.md § CURTASKS`; `CURRENT-TASKS.md`; `~/projects/spt-docs/CURRENT-TASKS.md` (source model).

### `[CURTASKS]` Cutover Landed — `CURRENT-TASKS.md` Model Goes Live (Phases 2–3) + 2 Execution Refinements (Conv 351)
**Date:** 2026-06-30 (Conv 351)

Conv 351 executed the skill cutover for the Conv-350 architecture: a **full atomic flip** of all four task-lifecycle skills in one commit, de-risked as build → dry-run → flip. Built `/r-update-tasks` (the **preserve-then-overlay** refresh engine), then flipped `/r-start` (active-only hydration, no RESUME-STATE→TodoWrite transfer), `/r-end` Step 5 (refresh `CURRENT-TASKS.md` + narrative-only RESUME-STATE), and `/r-commit` Step 0 (boundary refresh). Atomic because the read and write paths are coupled — a half-flip would silently drop the backlog; risk was bought down by dry-running the engine mechanically (single insertion hunk, 14 preserved, 5 new above PARKED, zero loss) and by taking the first **live** write on the lower-stakes `/r-commit` Step 0 before the full-scale `/r-end`. Two execution-time refinements not specified by the Conv-350 design: (1) **3 load-bearing H2 anchors** (🔥 Ordered / 📋 Unordered backlog / ✅ Completed this conv) — peerloop drops spt's 4th `## 🔴 In progress` section and renders in-progress inline as the Ordered header glyph `· 🔄 Active ·` (in-progress is conv-ephemeral, owned by TodoWrite, resolves at `/r-end`); (2) the **overlay rule** — only `TaskList` `in_progress` (→ force `· 🔄 Active ·`) and `completed` (→ move to Completed) are authoritative; a matched `pending` **preserves the file's hand-set `★ Next`/`📋 Planned`/`⏸️ On hold` symbol verbatim** (flat `pending` carries no priority granularity, so never downgrade), and the [TWAO] guard means an unmatched file row is **never** dropped (active-only TodoWrite makes unmatched the normal case).

**Rationale:** The coupled read/write paths have no safe intermediate state, so an atomic flip is the only correct sequencing — and a mechanical dry-run plus a lower-stakes first-live write make it safe. The 3-anchor collapse keeps the parser contract minimal and avoids duplicating TodoWrite with a persistent In-progress section. The pending-preserve + never-drop-unmatched rules make the refresh idempotent and non-destructive to hand-edits — re-runnable any number of times without eroding the user's curated ordering.

**Consequences:** Docs `217b8ad` (4 skills, +275/−177): NEW `.claude/skills/r-update-tasks/SKILL.md`; flipped `r-start`/`r-end`/`r-commit`. `RESUME-STATE.md` demoted to narrative-only (Branch line kept); `CURRENT-TASKS.md` got its first live refresh (transitional banner auto-cleared, CT-* → Completed). The write path is live-tested; the **read** path (`/r-start` Step 7/7.5/7.6/8 against a narrative-only RESUME-STATE) is unverified until next conv's first `/r-start`. Phases 4–5 (scripts/config + docs/memory cleanup; full retirement of `.scratch/conv-tasks.md` references) deferred.

**See:** `docs/sessions/2026-06/20260630_0944 Decisions.md` §1–3, Learnings §1–3; `.claude/skills/r-update-tasks/SKILL.md`; `PLAN.md § CURTASKS`; the Conv-350 entry above (architecture).

### `[CURTASKS]` Block CLOSED — Phases 4–5 Cleanup + Two Retirement Conventions (Conv 352)
**Date:** 2026-06-30 (Conv 352)

Conv 352 finished the cutover (Phases 4–5: scripts/config + docs/memory cleanup) and **closed the `[CURTASKS]` block (all 5 phases done)**. The read path was exercised cleanly for the first time by this conv's `/r-start`. Two retirement decisions landed: (1) **`w-review-resume-state` retired, not retargeted** — its premise was loading a *task-bearing* RESUME-STATE and acting on its "Remaining" checklist, a premise the cutover deleted; RESUME-STATE is now transient narrative (`/r-start` already surfaces it) and `CURRENT-TASKS.md` is hand-editable + self-documenting, so a `w-review-current-tasks` retarget would be a thin wrapper over "open the file" (the skill had no live invokers). (2) **Retire-and-replace, not rewrite-in-place, for memory files whose filename encodes the retired model** — `feedback_resume_state_as_todowrite_persistence` + `feedback_conv_tasks_live_sync` were deleted and one accurately-named `feedback_current_tasks_persistence` created (collapsing 2 MEMORY.md pointers to 1). The sweep scope was set by **PLAN.md § CURTASKS's frozen-list** (`docs/sessions/**` + `docs/decisions/*` + historical records), not raw grep volume; a **role-aware "wrong-model" grep** (RESUME-STATE co-occurring with todowrite/transfer/remaining/ledger) then caught 4 incidental memory edits a literal `conv-tasks` grep missed.

**Rationale:** Rewriting content under a contradictory filename is worse than deleting and renaming — memory-discipline's "delete wrong memories" extends to the slug, not just the body — and the consolidation trims the MEMORY.md index by a line (helps the 86% cap). A plan that pre-declares its frozen set is the scoping authority; sweeping by the changed concept's *role* (not just its renamed file) is what catches references that name no retired file but still describe the retired behavior.

**Consequences:** Docs `2478a4e` (24 files, +62/−184): `.claude/skills/w-review-resume-state/` DELETED; `config.json` ×3 rTimecardDay exclusion lists + `COMMIT-MESSAGE-FORMAT.md` + `resume-state-check.sh` (CURRENT-TASKS.md treated as bookkeeping, parallel to RESUME-STATE.md); `skills-system.md` (state-file model + 2 data-flow diagrams + role cells, 2 w-review rows removed), `CLAUDE-OFFLOAD.md` (w-review row removed), `doc-sync-strategy.md`, `staging-deploy-runbook.md`, `CLAUDE.md` ×2, `VERNACULAR.md`, `r-end` SKILL example; memory consolidation (2 retired → 1 new `feedback_current_tasks_persistence` + 7 incidental edits, one backlink repointed). `PLAN.md § CURTASKS` marked ✅ DONE (migrates to `plan/COMPLETED.md` at r-end). MEMORY.md cap 87%→86%.

**See:** `docs/sessions/2026-06/20260630_1116 Decisions.md` §1–2, Learnings §1–4; `memory/feedback_current_tasks_persistence.md`; `PLAN.md § CURTASKS`; the Conv-350 (architecture) + Conv-351 (cutover) entries above.

### MEMORY.md Auto-Load Cap Solved by Two-Tier HOT/COLD Index — Keep in MEMORY.md, Not CLAUDE.md (Conv 353) — *superseded Conv 358 (see below)*
**Date:** 2026-06-30 (Conv 353)

With MEMORY.md at 86% of the 25 KB SessionStart auto-load cap (and rising ~1 conv at a time, the `/r-prune-memory` re-flatten lever exhausted), the [MEM-CAP-ARCH] diagnosis confirmed the cap is **"first 200 lines OR first 25 KB, whichever comes first"** and that for this index **bytes bind (86%) far before lines (62%)** — content past the threshold is silently not loaded. Two architectural facts were established: (1) **only MEMORY.md auto-loads; the 82 sub-files load on-demand**, and `@path` imports are CLAUDE.md-only and load at launch *without* reducing context — so there is no lever to auto-load more than 25 KB of index; (2) plain markdown links `[link](file.md)` are inert, so the index could equally live in *uncapped* CLAUDE.md with sub-files still on-demand (net startup context unchanged ~22 KB either way). The decision — after pressure-testing the CLAUDE.md-relocation alternative — is to **keep the index in MEMORY.md as a two-tier structure**: 🔥 **HOT** (always-on rules, full marker-rich lines, placed *first* so they're never truncated) + 📇 **COLD** (situational long-tail, terse one-liners preserving marker/[CODE]/trigger). **New memories default to COLD; promote to HOT deliberately.** A one-time archive pass moved nothing (no entry confidently dead — BBB-VERIFY is an ambiguous forward intention; preflip is referenced by the live [PREFLIP-WT] Parked task).

**Rationale:** MEMORY.md is framed as "background context", CLAUDE.md as "instructions"; a situational-recall index is genuinely background, so relocating it to CLAUDE.md would mis-frame it and dilute adherence to the real behavioral rules. Tiering bounds growth (per-entry cost ~halved going forward: new COLD entries ~150 B vs the old ~286 B median) and HOT-first ordering structurally protects the always-on rules from truncation. The byte relief comes entirely from tiering, not archiving.

**Consequences:** Live MEMORY.md rewritten **86%→71% (18,066 B)**, all 82 entries intact (22 HOT + 60 COLD), 0 broken links. CLAUDE.md gained a **§Memory Index Tiering** section recording the default-COLD write-time rule (`9 ++`). Phase 1 (rewrite + CLAUDE.md rule) done this conv; **Phase 2 — rewrite `/r-prune-memory` to enforce the grammar (default new entries COLD, tier-aware flatten, periodic re-tier) — deferred to next conv.** Projection miss flagged: estimated ~13.5 KB, delivered 18 KB (HOT lines are the longest by design + COLD ran ~150 B not the projected 110 B).

**See:** `docs/sessions/2026-06/20260630_1314 Decisions.md` §1–2, Learnings §1–3; `code.claude.com/docs/en/memory.md` (cap spec); CLAUDE.md §Memory Index Tiering; MEMORY.md preamble; `PLAN.md` / `CURRENT-TASKS.md` [MEM-CAP-ARCH] Phase 2.

### MEMORY.md HOT/COLD Two-Tier Retired — Full-Collapse to Single-Tier Index + Rules Consolidated into CLAUDE.md (Conv 358)
**Date:** 2026-07-02 (Conv 358)

Revisits the Conv-353 decision (keep the index in MEMORY.md as two-tier HOT/COLD) with new evidence. Starting [MEM-CAP-ARCH] Phase 2 (build a `/r-prune-memory` enforcer for the HOT/COLD grammar), a **calibration** of the auto-re-tier heuristic against the hand-tiered file showed content-keyword re-tiering **misfires** (2/2 false demotions on ground-truth; project facts carry "NEVER"/"always" too; CLAUDE.md cross-ref is non-discriminating) — no classifier can be trusted to maintain the split. A read-only **audit** of all 22 HOT entries vs CLAUDE.md then found the HOT tier is a **three-way conflation with 0 pure duplicates**: **8 HYBRID** (the one-line rule already in CLAUDE.md → the HOT pointer is redundant), **10 UNIQUE-RULE** (genuine always-on rules *absent* from CLAUDE.md — incl. the security/safety guards no-paste-secrets, no-tool-spam, explicit-approval, git-`-C`, staging-is-only-deploy-target), **4 SITUATIONAL** (trigger-gated, mis-filed). Decision: **full-collapse** — author the 10 unique rules into CLAUDE.md (terse rule + memory pointer; incident detail stays in the sub-file), re-flatten the 8 redundant + 10 unique into a single "Rule detail & incident-history" section, move the 4 situational into topic subsections, and **empty the HOT tier so MEMORY.md is one flat situational-recall index**. The Phase-2 tier-enforcer is retired (nothing left to enforce).

**Rationale:** Both CLAUDE.md and the MEMORY.md HOT tier auto-load every session, so moving the 10 always-on rules to CLAUDE.md is ~context-neutral but consolidates *all* standing rules into one home — resolving the framing muddle Conv 353 left open (always-on rules are *instructions*, not the *background* MEMORY.md is framed as). The situational long-tail correctly stays in MEMORY.md; moving *it* into CLAUDE.md would dilute the rules + lose the 25 KB forcing function (the half Conv 353 was right to reject). No-loss: all 82 sub-files kept; the 22 formerly-HOT pointers become terse incident-history / situational lines. Triggered by the user detecting rising complexity + loss of a clear mental model for MEMORY.md.

**Consequences:** CLAUDE.md gained **§Guards** + **§Task Persistence** + 5 in-place rule lines, and §Memory Index Tiering was replaced by a single-tier **§Memory** note (344 lines / 30.8 KB — over the 250-line soft threshold → `/r-prune-claude` follow-on queued). MEMORY.md rewritten single-tier **71%→66% (16,853 B)**, 82 pointers intact, 0 orphans/dupes/broken links. The only tier-grammar locations were CLAUDE.md §Memory Index Tiering + the MEMORY.md preamble (no skills encode it — the 7 skill "tier" grep hits were all `## 🔥 Ordered` task-list emoji). Supersedes the Conv-353 keep-two-tier decision above.

**See:** CLAUDE.md §Guards / §Task Persistence / §Memory; MEMORY.md preamble + "Rule detail & incident-history" section; the Conv-353 entry above (superseded); `CURRENT-TASKS.md` [MEM-CAP-ARCH]; `.scratch/conv-turns.md` (Conv 358 audit trail).

### Cross-Machine /r-end Salvage — Push Code (API-Free), Hold Docs for the Owning Machine (Conv 329)
**Date:** 2026-06-23 (Conv 329)

When a conv's `/r-end` is blocked on one machine (e.g. a persistent Anthropic API 500 parked at the Step-4d pre-commit checkpoint) and its work is stranded — committed-but-unpushed code + uncommitted doc extracts — the recovery is **split by repo, not copied wholesale**: the stranded machine pushes its **code** commits via a plain terminal `git push` (API-independent, no Claude needed), and the live machine pulls + does **code-only** work, **holding the docs repo** (no commits, no `/r-end`) until the owning machine properly closes its own docs. Code commits are branch-shared and safe to move; docs are conv/machine-attributed and a foreign-machine commit corrupts the owner's timecard. **Ordering matters:** get the stranded machine's commits to origin BEFORE the live machine adds new commits on top, or the paused r-end can no longer fast-forward-push afterward.

**Rationale:** Timecard attribution requires a conv's docs to be committed from the machine that ran it, under that conv. Copying everything to the live machine would let it finish faster but corrupt the owner's timecard; redoing the stranded work would create divergent duplicate commits on one branch. Splitting by repo recovers the at-risk code immediately while preserving correct attribution. The reconciliation is then driven by a `## ⚠️ CROSS-MACHINE CONCURRENCY` hand-off block atop the stranded conv's RESUME-STATE (don't re-do shipped work, carry forward new tasks, expect a RESUME-STATE conflict, FF-pull).

**Consequences:** Conv 328 (stranded on M4) pushed its 4 code commits → M4Pro pulled cleanly + closed `[WS-GLYPHS]` #28; M4 later closed its own docs (`5341657`+`8cb6186`), lifting the hold the same conv. Recovery pattern (verify-hashes → push-from-stranded-machine → FF-pull → reconcile per RESUME-STATE hand-off note) captured as Conv 329 Learnings 1–3.

**See:** `docs/sessions/2026-06/20260623_1141 Learnings.md` §1–3; `docs/sessions/2026-06/20260623_1141 Decisions.md` §1.

### M4Pro Browser Reservation — Brave Personal, Chrome `/chrome`-Bridge-Only (Conv 311)
**Date:** 2026-06-20 (Conv 311)

On M4Pro the user runs **Brave for all personal browsing** and **reserves the Google Chrome app exclusively for `/chrome` bridge testing** — "if you see Chrome running it is serving a Claude Code session." CC must never drive or kill Brave; a running Chrome belongs to the bridge. Brave (`/Applications/Brave Browser.app`) and Chrome (`/Applications/Google Chrome.app`) are distinct at the pid level, and a `Helper`-filtered process read can falsely look like a zombie — so investigate before acting on any "kill this browser" instruction. When the bridge lists a browser but `list_connected_browsers` returns `[]` after Chrome starts, the fix is **re-logging into the Claude extension inside Chrome**, not restarting CC.

**Rationale:** A "destroy the invisible browser" instruction was issued against what turned out to be the user's live Brave session (40+ renderers, tabs from today); executing it would have lost real work. Surfacing the corrected picture before acting prevented data loss and established the durable reservation.

**See:** `memory/reference_chrome_bridge_island_stale_cache.md`; Conv 311 Decisions.md §1, Learnings.md §1–2.

### `USER-WIP.md` — User-Authored, Git-Tracked, CC-Read-Only, r-end-Auto-Saved (Conv 304)
**Date:** 2026-06-19 (Conv 304)

A single file `USER-WIP.md` at the docs-repo root is the **one** exception to the "CC is sole author" invariant: the user edits it directly (without CC) to track their own work-in-progress and carry it across convs. It is **git-tracked** (for cross-machine sync), CC treats it **read-only**, and `/r-end` **Step 1.5** auto-commits it as its own separate commit *before* the Extract — keeping the user's WIP out of the change-narrative and never tripping `/r-start`'s dirty-repo HALT. `/r-start` is left unmodified (its dirty HALT remains a rare-case crash safety net).

**Rationale:** Cross-machine carry-over requires git, not a gitignore. Auto-saving at r-end avoids the dirty HALT without weakening it as a crash net; a separate pre-Extract commit isolates the user's notes from the conv's change story. Chosen over (a) gitignore (no cross-machine sync) and (b) track-but-no-skill-change (manual commit, or trips the dirty HALT every conv).

**Consequences:** The lone carve-out to the sole-author invariant. New CLAUDE.md § "User WIP File" + memory carve-out in `user_hands_off_pilot_workflow.md` + r-end Step 1.5 (validated idempotent on the clean file).

**See:** `USER-WIP.md`; CLAUDE.md § "User WIP File"; `.claude/skills/r-end/SKILL.md` Step 1.5; `memory/user_hands_off_pilot_workflow.md`; Conv 304 Decisions §1.

### `.scratch/conv-turns.md` — CC-Maintained Per-Turn Re-Orientation Log (Conv 294)
**Date:** 2026-06-16 (Conv 294)

A conv-scoped `.scratch/conv-turns.md` captures recent turns as **question (verbatim, in full) + reply (terse summary, or the selected `AskUserQuestion` choice value)**, **newest-first**. It is **CC-maintained** (live-synced like `conv-tasks.md`), not hook-driven: a shell hook can capture the raw prompt deterministically but cannot produce the intelligent reply summary, extract the chosen option value, or filter noise (slash plumbing, bare yes/no) — the valuable part is exactly what only CC can do. Wired into both lifecycle skills: `/r-start` Step 7.7 seeds a fresh file each conv; `/r-end` Step 2 COLLECT reads it as a cross-check. CLAUDE.md "Conversation Turn Log" section codifies the per-turn discipline. Gitignored (not committed).

**Rationale:** Hook-vs-CC test — "does the value depend on judgment/summarization?" Yes → CC-maintained with a CLAUDE.md per-turn discipline. Follows the established `conv-tasks.md` precedent (not novel). Newest-first avoids scrolling for the latest entry. Terseness scopes to the **reply only**; the question is captured in full so it's faithfully recall-able.

**See:** `.scratch/conv-turns.md`; CLAUDE.md "Conversation Turn Log"; r-start Step 7.7; r-end Step 2; Conv 294 Decisions §1, Learnings §1–2.

### `.scratch/vernacular.md` — Persistent 3-Column Acronym Glossary (Conv 294)
**Date:** 2026-06-16 (Conv 294)

A single alphabetical markdown table with **3 columns** (Acronym · Literal meaning · Context/comments), terse 1–2 lines each, append-as-we-go and **not** conv-scoped (persists/accumulates across convs, unlike `conv-turns.md`). The 3rd column carries project-specific usage (e.g. SOP = the RTMIG-4 route-sweep 8-step process porting Tier-1 + Tier-2). ~38 terms at creation (incl. CoW, CD, DOM, DR, WORM, QLINT, DNS, PR). CLAUDE.md "Vernacular Glossary" section is the append-as-we-go pointer. **Promoted Conv 295** from gitignored `.scratch/vernacular.md` to git-tracked `VERNACULAR.md` at the docs-repo root (user found it useful enough to version).

**Rationale:** Single alphabetical table is Ctrl-F friendly; the context column distinguishes our usage from the generic expansion. Persistent (not conv-scoped) because acronym meanings don't reset between convs.

**See:** `VERNACULAR.md` (root; was `.scratch/vernacular.md` pre-Conv-295); CLAUDE.md "Vernacular Glossary"; Conv 294 Decisions §2.

### Same-Machine Session Protection: Launch Guard + Concurrent-Session Lock
**Date:** 2026-06-16 (Conv 293)

Two layers guard against same-machine session footguns. (1) **Launch guard** — a symmetric `_guard_launch` helper in `~/.zshrc` makes the `spt` launcher refuse to run inside Peerloop dirs and the `peerloop` launcher refuse inside spt dirs (hard-block, "cd out to override"). It lives in the alias/function, not r-start, because the launcher's own `cd` destroys the cwd signal before r-start ever runs. `~/.zshrc` is machine-local and the two Minis are kept isolated (no dotfiles sync), so the block is hand-applied per machine (`.scratch/zshrc-launch-guard-for-M4.md` for the M4). (2) **Concurrent-session lock** — `.claude/scripts/conv-session-lock.sh` (check/acquire/release) maintains `active-session.lock` under `~/.claude/projects/<slug>/` with PID+session-id ownership. r-start Step 0 halts on ACTIVE, prompts on STALE, acquires on CLEAR; r-end Step 8 releases (owner-checked). The lock is machine-local and never committed (PIDs are machine-meaningful).

**Rationale:** A second-terminal `spt`+r-start from a Peerloop folder trampled a live spt session (~30 min cleanup). cwd-based detection is impossible in r-start (launcher `cd` already ran), so the guard must live at the alias. The lock uses `CLAUDE_CODE_SESSION_ID` + the walked-up `claude` PID to distinguish a live concurrent session from a stale/crashed one, making it self-healing across crashes and the `/clear` re-run flow without false-blocking the owner. Committed/in-repo locks rejected (PIDs meaningless cross-machine, git noise).

**Consequences:** Same-machine concurrency now guarded; cross-machine simultaneity still caught only by the existing non-ff push-fail halt. Machine-local shell guard needs manual replication on the M4.

**See:** `.claude/scripts/conv-session-lock.sh`; r-start SKILL.md Step 0; r-end SKILL.md Step 8; Conv 293 Decisions §1–3; Learnings §1–2.

### Route All Decisions Through `AskUserQuestion` — QLINT Dropped (supersedes Conv 272)
**Date:** 2026-06-12 (Conv 273)

Decisions (option picks **and** yes/no) are routed through the `AskUserQuestion` tool — reasoning in prose **above**, minimal picker **below**. The malformed compound-`or`/symbol-label question shape is now structurally **unrepresentable** because the user selects rather than types. The Conv-272 QLINT Stop-hook + its `settings.json` registration + sentinel + (machine-local) calibration are **removed**; CLAUDE.md §User-Facing-Questions + §Recurring-Failures #1, MEMORY.md, and `feedback_option_phrasing.md` rewritten to the AskUserQuestion model (the inline `A)/B)/C)` archaeology preserved). Open-ended free-text questions still use the inline `👉` pointer.

**Rationale:** A rule that's known but not retrieved at the authoring moment is a **salience failure**. Proactive prose decays; a post-hoc Stop-hook is only a partial detector (no hook point exists at question-authoring time, and QLINT enforced only a subset — inline `" or "`/slash-list on text-ending turns, missing 3 of 4 failure modes). Changing the **channel** beats both — after a full-conv trial the tool channel worked cleanly. User prefers selecting over typing (mistypes yes/no in haste). Residual risk = remembering to invoke the tool (same salience dependency), accepted as the tradeoff. Options weighed: improve prose / improve hook / three-layer (tool + hook backstop + slim prose) / drop QLINT entirely ← chosen.

**See:** `memory/feedback_option_phrasing.md`; CLAUDE.md §User-Facing-Questions + §Recurring-Failures #1.

### Decompose Plan Work by Cohesion (Vertical Slices), Not Pseudo-Isolated Fragments
**Date:** 2026-06-12 (Conv 271)

Plan decomposition isolates by **cohesion**, not by serializable steps. A fragment that needs a *piece* of a sibling is mis-cut. Correct isolation: each unit (a) owns every layer it touches (pipeline / schema / component / render / seed / tests), (b) depends only on WHOLE prior units, (c) unidirectionally, and (d) has a standalone done-test. Rule (d) is the diagnostic — a fragment with no self-contained done-test was cut through the middle of a cohesive thing. Applied by reassembling the feed/promotion/discovery group: 14 fragments → 3 cohesive vertical units (U1 Seed / U2 Discovery-Rendering / U3 Promotion-System) + independent cleanups.

**Rationale:** The group repeatedly "missed fundamentals" because render-tasks were secretly data-pipeline tasks and "config" steps were secretly schema+cron builds — the decomposition itself was the bug. A foundations-first re-sequence was rejected (still preserved the broken split). Only whole-unit unidirectional deps survive cohesion-based cutting.

**See:** `memory/feedback_decompose_by_cohesion_not_pseudo_isolation.md`; `plan/home-feed-merge/REASSEMBLY-CONV271.md`.

### Option-Question Labels Must Be Typeable Latin — Never Symbols
**Date:** 2026-06-11 (Conv 263)

Option-question labels must use typeable Latin characters (`A/B/C`, and `A1/A2` for nested questions) — never Greek (α/β), circled digits (①②③), emoji, or math glyphs. The user cannot type those back, which forces re-description and breaks the A/B/C "or"-question discipline. Namespace nested questions with Latin compounds, not a different symbol set.

**Rationale:** The whole point of labeled options is a fast, unambiguous reply; a label the user can't type defeats it. Conv 263 incident: CC used ①②③ + α/β labels and the user flagged it. Reinforces CLAUDE.md §Recurring-Failures item 1 + §User-Facing-Questions.

**See:** `memory/feedback_option_phrasing.md` (new "Labels must be typeable" section); MEMORY.md index line.

### conv-tasks.md Two-State Thin Marker (`⚠️ Thin - Stub` vs Stranded → Drop)
**Date:** 2026-06-09 (Conv 254)

A carried-forward thin task carries two independent signals: **"is it real?"** (structurally strong — the code + the /r-start no-shrink reconciliation guard make it undroppable) and **"do we know what it means?"** (weak — the `⚠️ Thin` marker). These are split into two markers: **`⚠️ Thin - Stub`** = terse but a PLAN.md anchor was *verified* (recoverable via grep, leave lazy) vs **stranded** = no definition in PLAN / memory / unbounded git history anywhere (decide keep-or-kill now). A stranded code is born stranded — bundled as a bare code in a compressed carry-over, never described — not decayed over time. First application: 3 of 16 thin codes (PORTED-AUDIT, SETTINGS-WATCHER, STG-SEED) were verified stranded and **dropped**; the 13 anchored were relabeled `Thin - Stub`. Dropped codes must land in RESUME-STATE `## Dropped` at r-end so the next /r-start's no-shrink reconciliation sees the shrink explained.

**Rationale:** The reconciliation guard makes tasks undroppable by design, but a code with no recoverable definition is worse carried (a false "see PLAN.md" pointer) than deliberately killed. The Stub/stranded distinction encodes the actionable difference and makes the at-risk subset visible. Option B (drop the verifiably-stranded, relabel the rest) chosen over (A) hydrate-all-now and (C) leave-as-is.

**See:** `.scratch/conv-tasks.md` (Dropped footer); Conv 254 Decisions.md §2; `memory/feedback_conv_tasks_live_sync.md`.

### `generated` Doc Category Given an Executable Regen Binding + Deterministic r-end Gate (DOCGEN)
**Date:** 2026-06-07 (Conv 246)

The docs registry's `generated` category (previously a passive "do not edit" marker) now carries an executable `regen:{cwd, commands, inputs, alsoWrites}` binding, expressed by **extending the registry group** in `.claude/config.json` (chosen over a separate manifest — the registry already owns per-group config and doc→category, single source of truth). A new deterministic gate `.claude/scripts/regen-generated-docs.mjs` runs at r-end Step 5c: it iterates `generated` groups with a `regen` binding, runs the commands when `inputs` (`src/pages|components|lib`) changed since baseline, and stages both repos; idempotent so day-stamped docs don't churn. The new `route-docs-generated` group covers `route-api-map.md`, `page-connections.md`, the 3 ROUTE-*.tsv, and code `route-map.generated.ts`. `route-stories.md` is hand-authored (canonical story↔route map) and **stays driftCheck** — provenance header is the only reliable discriminator, and classifying it as generated would let the gate clobber it. r-end Agent 3's manual priority-2 route-regen step was removed.

**Rationale:** Route projection docs are pure functions of code; landing them in `driftCheck` alongside hand-written prose meant they leaked out as recurring human tasks (#22) that never stay done. "Regenerate stale route docs" is now a deterministic gate, not a TaskCreate. Future projection docs need only a new registry group — no engine change. Option A (full build) chosen over (B) minimal close-the-loop and (C) capture-as-task.

**See:** `.claude/config.json` (`route-docs-generated` group); `.claude/scripts/regen-generated-docs.mjs`; `.claude/skills/r-end/SKILL.md` Step 5c; `memory/reference_generated_doc_regen.md`; Conv 246 Decisions.md §2–3 + Learnings.md §1–2.

### /r-start Defers RESUME-STATE.md Deletion Until After conv-tasks Reconciliation (Step 7.6)
**Date:** 2026-06-07 (Conv 246)

RESUME-STATE.md deletion moved out of Step 7 into a new Step 7.6 (after the Step 7.5 no-shrink backstop). Step 7.5 is now a **ledger-based reconciliation**: a conv-tasks shrink is reconciled against the RESUME-STATE Completed/Dropped ledger and halts only on *unexplained* loss; the `*DONE*`-count heuristic is demoted to a corroborating fast-path (it breaks on a stale companion file). The dedup-guard no longer deletes RESUME-STATE inline.

**Rationale:** A task-count shrink is expected whenever the prior conv did work, so the backstop was false-halting on legitimate triage (Conv 244, 44→27). RESUME-STATE is the authoritative ledger that explains the shrink, so it must survive until the comparison runs — deleting it in Step 7 left the backstop blind.

**See:** `.claude/skills/r-start/SKILL.md` Steps 7/7.5/7.6; `memory/feedback_conv_tasks_live_sync.md`; Conv 246 Decisions.md §1.

### Figma MCP Set Up Per-Machine on M4Pro (Permissions Travel via Git; Registration + OAuth Are Machine-Local)
**Date:** 2026-06-01 (Conv 231)

Figma MCP was registered on M4Pro (`claude mcp add --transport http figma https://mcp.figma.com/mcp`, project-scoped to peerloop-docs) so the machine becomes self-sufficient for Matt-source Figma work rather than staying M4-pinned. The committed `.claude/settings.json` already allowlists `mcp__figma__*`, so permissions arrive via git; only the server registration (`~/.claude.json`) and the OAuth token are machine-local. A server added mid-session is invisible to the in-session `/mcp` panel and tool list (both populated once at launch) — OAuth and tool use require a CC restart.

**Rationale:** Durable — both dev machines self-host the Figma MCP rather than one being pinned. Option chosen over (B) using a local `.scratch` export or (C) probing on M4.

**See:** `docs/reference/figma-mcp.md`; Conv 231 Learnings.md §1–2 + Decisions.md §3.

### New `/r-checkpoint` Skill — Compaction-Proof Mid-Conv Slate-Clear
**Date:** 2026-06-01 (Conv 230)

`/r-checkpoint` is a lightweight skill that sits between `/r-commit` and `/r-end`: it captures what-changed + why into a conv-scoped scratch note (`.scratch/conv-<NNN>-checkpoint.md`), then instructs the user to `/compact`. No commit, no push, no agents. Use it to clear the slate for fresh work after a housekeeping batch without losing the slice's decisions/learnings to summarization.

**Rationale:** `/compact` (not `/clear`) is the right slate-clear because it preserves the session — TodoWrite + conv number persist, whereas `/clear` resets them. But `/compact` erodes chat-only context, so the WHY of pre-compact work must be written to a durable carrier first. Staying in-conv saves a full `/r-end` + `/r-start` per housekeeping batch.

**See:** `.claude/skills/r-checkpoint/SKILL.md`; `.scratch/README.md` conv-scoped-note convention; Conv 230 Decisions.md §4–5. New skills are invocable in-session without restart (confirmed this conv).

### r-end Step 4d Pre-Commit Checkpoint + Step 2 Scratch-Note Glob Ingestion
**Date:** 2026-06-01 (Conv 230)

Two r-end additions: **(Step 4d)** a mandatory PRE-COMMIT CHECKPOINT halt before any irreversible step (digest of alerts/open-questions/blockers → yes/no; on substantive follow-up, loop back to Step 2) — the only safe place to act on issues surfaced during r-end before save/commit/push/cleanup closes the conv. **(Step 2 action 3)** r-end globs `.scratch/conv-<NNN>-*.md` and folds matches into the Extract, so a `/r-checkpoint` note written before a mid-conv `/compact` still reaches the session logs. Also: Step 9 rewritten to a display-and-stop `Next:` block (no auto-invoke of `/clear` or `/r-start`; neutral `/quit` wording asserting no update-check mechanism).

**Rationale:** A cross-step dependency isn't real until a deterministic hook encodes it — the glob *is* the hook that lets a downstream step consume the scratch artifact (the dependency previously lived only in chat, which `/compact` erodes). This conv's r-end run validated the ingestion path end-to-end: the Extract's §Decisions/§Learnings are a superset of the checkpoint note.

**See:** `.claude/skills/r-end/SKILL.md` Steps 2/4d/9 + §Rules; Conv 230 Decisions.md §1–3.

### Decision-Authoring Skills/Config Repointed Off the Dead `DECISIONS.md` Pointer (DEC-SKILL-SYNC)
**Date:** 2026-06-01 (Conv 229)

The Conv-228 split moved the decision *readers* (DECISIONS.md → a 2.9KB pointer) but left the *writers* aimed at it. DEC-SKILL-SYNC repoints the whole loop across 10 files in three groups: **(A) write-targets** — `fmt-learn-decide.md`, `r-end/SKILL.md`, `w-post-fix/SKILL.md`, `fmt-update-plan.md` now instruct the 3-step `docs/decisions/` write-path (matching `01`–`11` chunk, latest-wins + dated `decision-log.md` entry + `INDEX.md` title); **(B) audit** — `w-sync-docs` Audit 5.1 + output label retargeted from the empty pointer to the chunks; **(C) bookkeeping** — `docs/decisions/` added to `.claude/config.json` `docPathsExclude` + `routineStrip.pathPatterns` + a new `manual`-category doc-registry pattern entry, plus the `r-end`/`r-commit` Doc-Changes exclusion lists. The interim ⚠️ notes in `INDEX.md` + the `docs/DECISIONS.md` pointer flip to ✅. `DOC-DECISIONS.md` (this file) was deliberately untouched — it was never part of the split.

**Rationale:** A half-migrated structure rots from the writers, not the readers — the next `/r-end` would have appended a decision to the dead pointer, desyncing the chunks/log/INDEX. Group C is a billing-integrity fix: decision-chunk churn would otherwise count as billable doc authorship in the timecard. Reading the `routineStrip` consumer (`timecard-day.js`) before editing confirmed `routineStrip.pathPatterns` (substring) + `docPathsExclude` (extraction filter) as the correct keys — and that `docNameWhitelist` matches only ALL-CAPS stems, so lowercase chunk filenames don't belong there.

**Consequences:** Decision-authoring skills target the 3-step write-path directly; first clean dogfood was the leaderboard-dropped entry (391/391 INDEX links resolve). Verified config.json valid JSON, `docs-registry.mjs` resolves a chunk → `manual`, zero stray write-target refs remain. Closes [DEC-SKILL-SYNC] (#33).

**See:** `.claude/skills/r-end/refs/fmt-learn-decide.md`, `.claude/config.json`, `docs/decisions/INDEX.md` write-path/read-path sections, Conv 229 Decisions.md §1.

### Flag Stale Historical Narrative In Place — Don't Rewrite It
**Date:** 2026-05-31 (Conv 226)

When a piece of historical narrative (e.g., a superseded recipe in PLAN.md's log) is now wrong as current guidance, add an inline `🔴 SUPERSEDED` pointer rather than editing/erasing the original text. Migrated ephemeral plan files (CC Plan Mode artifacts) fully represented in PLAN.md are deleted once migrated.

**Rationale:** Historical narrative is a log of what happened — erasing it loses the record. The actual risk is a future reader mistaking a stale entry for current guidance; an inline self-warning pointer neutralizes that without destroying history. Ephemeral plan files, by contrast, carry no historical value once their content lives in PLAN.md.

### Dedicated `/r-prune-memory` Skill for MEMORY.md (Separate from `/r-prune-claude`)
**Date:** 2026-05-29 (Conv 213)

MEMORY.md (the auto-memory index) is pruned by a new dedicated `/r-prune-memory` skill, NOT by `/r-prune-claude`. The two are distinct: `/r-prune-claude` offloads CLAUDE.md → CLAUDE-OFFLOAD.md (soft always-in-context cost); `/r-prune-memory` extracts bulky MEMORY.md content into sibling `memory/*.md` sub-files (hard SessionStart truncation at 200 lines / 25 KB). The /r-start cap alert now points to `/r-prune-memory`.

**Rationale:** Different file, different cap mechanics (line/byte hard cap vs soft context cost), different operations (sub-file extraction vs offload). A dedicated skill keeps each prune's logic and thresholds clean. The naming collision had been routing the recurring MEMORY.md-cap alert to a skill that never touches MEMORY.md.

**See:** `.claude/skills/r-prune-memory/SKILL.md`, `.claude/config.json` (`thresholds.memoryMd`), `.claude/skills/r-start/SKILL.md`.

### MEMORY.md Pointer Display Label = Constant `[link]` (Never Filename-Echo; Never Rename Sub-Files)
**Date:** 2026-05-29 (Conv 213)

Every MEMORY.md index pointer uses the constant display label `[link]` — `[link](filename.md)` — rather than echoing the filename in both halves. Sub-files are NEVER renamed for byte savings.

**Rationale:** The filename-echo display title was ~9% of the hard cap in pure redundancy. Tooling keys on the `](file.md)` target, not the label, so `[link]` is zero-risk and the filename is still visible in the target. Renaming files instead would touch ~127 cross-refs (incl. 37 frozen archival docs) and risk unpredictable names. Scannable meaning lives in the `##` header + hook, not the label. Convention codified in `/r-prune-memory` (operation c, cheapest-first) and `feedback_memory_index_load_bearing.md` so it governs write-time too.

**See:** `.claude/skills/r-prune-memory/SKILL.md`, `feedback_memory_index_load_bearing.md`.

### MEMORY.md Cap Relief Comes From Load-On-Demand Bundling, Not Byte-Shaving (figma-context.md)
**Date:** 2026-06-14 (Conv 281)

When MEMORY.md crosses the SessionStart byte warn, the durable lever is **retiring or bundling whole index lines** into load-on-demand "context" hub files (`plato-context.md`, now `figma-context.md`), NOT further per-line shaving. On a dense index, `/r-prune-memory` byte-trimming hits a ~200B/line "balanced density" floor (18 trims moved only 89%→83%); coherence-check consolidation cleared the 80% warn (→78%). Related Figma entries (never-modify guardrail + reuse-components + mcp-behavior + tokenize-probe) were folded into one `figma-context.md` behind a single trigger line. **Safety carve-out:** a guardrail rule (Figma is READ-ONLY) may move behind a trigger ONLY because its risk exists exclusively during the triggered work — and its headline must still appear inline in the always-loaded index line.

**Rationale:** Trimming trades retrievability for bytes; bundling removes whole lines from the always-loaded budget while preserving full detail behind a trigger that fires exactly when the capability is needed. Figma usage is winding down post-Matt-phase-out, so always-loading those entries spends budget on rarely-needed capability.

**See:** `memory/figma-context.md`, `memory/plato-context.md`, Conv 281 Learnings §1–2 + Decisions §1.

### npm Not Upgraded Standalone — Keep 10.9.3, Bump via `.nvmrc` Node If Ever
**Date:** 2026-05-28 (Conv 212)

npm is NOT upgraded standalone on any one machine. 10.9.3 stays — it's current, `engines` allows it, and the `.nvmrc`-pinned node (22.19.0) bundles it identically on both M4 and M4Pro. If an upgrade is ever wanted, do it as a coordinated **node** bump (`.nvmrc` + `engines.node`) on both machines, never a per-machine `npm i -g npm@11`.

**Rationale:** A one-machine global npm upgrade splits the toolchain and risks author-side lockfile-normalization churn — the exact problem the recent `npm ci` switch eliminated. nvm-global npm upgrades are also non-durable and can break npm's symlink. Both machines stay aligned by construction through the pinned node.

**See:** `.nvmrc`, `package.json` `engines`, `.claude/skills/r-start/SKILL.md` Step 5.5 (`npm ci`).

### Three-Tier CC Settings Split (Global Client Flags / Project Committed Tool Envelope / Project Local Per-Machine)
**Date:** 2026-05-28 (Conv 209)

CC settings are partitioned across three files by **shared-ness**: `~/.claude/settings.json` (global) holds ONLY client-behavior flags (`statusLine`, `alwaysThinkingEnabled`, `verbose`, `autoCompactEnabled`, `agentPushNotifEnabled`) + cross-project hooks (`SessionStart → detect-machine.sh`). `.claude/settings.json` (project committed, 80 allow + 15 deny) holds the repeatable tool envelope: universal shell utilities, Peerloop tech stack (npm/npx/wrangler/path-scoped node/tsx/python3), git/gh, project skills, tech-stack WebFetch domains, AND the destructive-git deny block (`git push --force*`, `git reset --hard*`, `git clean -fd*`, `git checkout -- *`, `git branch -D *` — must travel with the broad `git:*` allow it constrains). `.claude/settings.local.json` (gitignored, 11 allow) holds destructive (`rm:*`/`rsync:*`/`pkill:*`), network (`curl:*`), Tier-1 escape (`python3 *`), Mac-only (`brew install`/`open:*`), editor (`code:*`), and narrow per-machine tools.

**Rationale:** Permissions are project-scoped concerns; client-behavior flags must be global to avoid per-project inconsistency. Destructive grants stay local because they're a per-user trust decision, not a project-level fact. Second machine (M4) inherits ~67 entries via pull instead of rebuilding manually. Path-scoping interpreters (`node .claude/scripts/*`, etc.) is cleaner than wildcard-banning — preserves legitimate use while denying `-e '<arbitrary>'` escape.

**Consequences:** Global backup at `~/.claude/settings.json.bak-conv209`. Any project without its own permission grants will prompt for utilities previously globally allowed (`grep`/`sed`/`cat`/`cursor /tmp/*`). Known matcher limitation: `git -C <path> push --force` form not covered by deny patterns (CC matcher is prefix-based on literal command string).

**See:** `.claude/settings.json`, `.claude/settings.local.json`, `~/.claude/settings.json`, Conv 209 Decisions.md §2-4, Conv 209 Learnings.md §1-4.

### 3-Marker Page-Provenance Convention (`@stand-in` / `@matt-source` / `@matt-inspired`)
**Date:** 2026-05-28 (Conv 208)

Every non-legacy page in `src/pages/` declares its provenance via one of three header markers: `@stand-in` (transient legacy rehost awaiting retrofit), `@matt-source <nodeId>` (1:1 from a Matt Figma frame), or `@matt-inspired` (built with Matt tokens/primitives but no source frame). Unmarked = legacy. Full convention codified in `docs/as-designed/matt-provenance.md` §11 (rationale, marker table, detection extension, examples through Conv 208, relationship to component-level provenance). CLAUDE.md gains a "Page Provenance — 3-Marker Convention" section with concise table + pointer to §11. `prov-sweep.ts` enforces (Decision below).

**Rationale:** Component-level provenance already lived in matt-provenance.md; the page convention extends it, not parallels it. Single home with cross-reference avoids drift. `@matt-inspired` fills a gap the Conv 195 component scheme didn't cover — pages are orchestrators that may have no 1:1 frame but are still "built from Matt's design language."

**Consequences:** All non-legacy pages must declare one of the three markers; unmarked pages flagged by `prov-sweep.ts`. Stand-in backlog visible each sweep run.

**See:** `docs/as-designed/matt-provenance.md` §11, `CLAUDE.md` §Page Provenance, Conv 208 Decisions.md §2.

### prov-sweep.ts Extended With Page-Level Classifier (Line-Anchored Regex)
**Date:** 2026-05-28 (Conv 208)

`scripts/prov-sweep.ts` gained a `classifyPage` walker over `src/pages/` (skipping `old|dev|api/`) that classifies each page as `@matt-source` / `@matt-inspired` / `@stand-in` / unmarked. Three new line-anchored regexes (`PAGE_SRC_RE`, `PAGE_INSPIRED_RE`, `PAGE_STANDIN_RE`) each use `m` flag with `^[\s/*]*<marker>\b` prefix accepting common comment leaders — NOT the component-side bare `MARKER_RE`. Report adds "Pages (Conv 207 3-marker convention)" section with counts + stand-in backlog listing; unmarked pages flagged as drift.

**Rationale:** Pages legitimately cite child-component markers in prose (e.g., 404.astro's header mentions `Button (\`@matt-source 40:482\`) primitive`). Component-side `MARKER_RE` (bare token-anywhere) misclassified 404 as `@matt-source` instead of `@matt-inspired` until the regex was line-anchored. Per `feedback_heuristic_calibration.md`, re-derived accept-condition from scratch and verified against all 8 canonical pages before commit (counts: 1 source / 6 inspired / 1 stand-in / 0 unmarked).

**Consequences:** Stand-in backlog is the remaining-retrofit counter, visible each sweep run. Pattern established: when extending marker detection to a new file class, re-derive the regex — don't assume the original's discipline carries over.

**See:** `scripts/prov-sweep.ts`, `memory/feedback_heuristic_calibration.md`, Conv 208 Learnings.md §1, Conv 208 Decisions.md §3.

### Two Dedicated Vetted-Primitive Registries + 3-Value `data-prov` Runtime Stamp (Approach B)
**Date:** 2026-05-29 (Conv 216)

Vetted UI primitives are catalogued in two dedicated registry files: `scripts/matt-sourced-registry.generated.ts` (generated from the in-file `@matt-source` markers via `scripts/gen-registries.ts` / `npm run gen:registries` — a derived projection, not a hand-maintained SoT) and `scripts/matt-inspired-registry.ts` (hand-maintained, renamed from `prov-candidates.ts` which becomes a thin re-export). Each primitive's outermost element carries a 3-value `data-prov="matt-sourced|matt-inspired|legacy"` stamp (+ name, + node for sourced). A conformity gate keeps marker ⟺ registry ⟺ stamp in sync. Spec written as `docs/as-designed/matt-provenance.md` §12. Chosen over (1) formalizing the existing `@matt-source` grep + `prov-candidates.ts` mechanisms and (3) a doc-only contract.

**Rationale:** Page-level markers say nothing about the vetted-ness of embedded components (`/profile` is `@matt-inspired` yet its 5 settings islands use 105 legacy tokens, 0 Matt) — conformity must be tracked at the DOM/component level. The stamp makes "does this page contain unvetted UI?" a one-line DOM query, with the explicit `legacy` value making unvetted UI visible rather than inferred from absence. Generating the Matt-sourced half from markers (vs hand-maintaining a second SoT) avoids drift and preserves the markers' re-probeable / git-audit virtues; only the Matt-inspired half is a true hand-maintained SoT.

**Consequences:** §12 spec + W1/W2 registries built this conv (35 generated Matt-sourced primitives). Stamping (W3 [PRIM-STAMP] #21) and the /profile legacy-island re-skin (W4 [PROFILE-PRIM-SWEEP] #22) deferred. `@matt-source` in-file markers remain the SoT; stripping them to make the registry literal is an open question, not requested.

**See:** `docs/as-designed/matt-provenance.md` §12, `scripts/gen-registries.ts`, `scripts/matt-sourced-registry.generated.ts`, `scripts/matt-inspired-registry.ts`, Conv 216 Learnings.md §1 & §3.

### CLAUDE.md §Recurring Failures Pre-Send Checklist (Top of File)
**Date:** 2026-05-28 (Conv 208)

New top-level CLAUDE.md section §Recurring Failures (positioned after intro) lists recurring pre-send violations as a self-check checklist: option-phrasing (NEVER ask "X, or Y?" — ALWAYS labels above 👉) + 👉-pause rule (👉👉👉 must be last visible content). Companion memory edit: `feedback_option_phrasing.md` rewritten to lead with the anti-pattern verbatim, not a statement-style stub pointer; MEMORY.md index line updated to expose the anti-pattern (per `feedback_memory_index_load_bearing`).

**Rationale:** When a directive keeps being violated despite being in always-loaded context, the fix isn't "louder doc placement" alone — it's reformulating from statement → vivid trigger (anti-pattern verbatim + self-check question), AND positioning so the rule fires before the failing turn ships. Stub-pointer pattern regresses to topic-label framing in MEMORY.md, which doesn't trigger in-the-moment.

**Consequences:** Sets a pattern for future recurring-failure escalations beyond statement-form. Two of the most-violated pre-send rules now anchored at the top of CLAUDE.md as a checklist.

**See:** `CLAUDE.md` §Recurring Failures, `memory/feedback_option_phrasing.md`, Conv 208 Learnings.md §3, Conv 208 Decisions.md §4.

### `/w-codecheck` Trigger Is a Decision Point, Not a Routine
**Date:** 2026-05-28 (Conv 207)

The `/w-codecheck` invocation is the deliberate "I want to verify this is clean" moment — at that moment CC also decides per-change whether to additionally run `prov-sweep`, the full test suite, and the production build. None of those are auto-bundled into `/w-codecheck` (it stays at 8 deterministic checks: tsc + astro check + lint + 5 Peerloop-specific bug-class checks). Running stock `tsc + astro check + lint` inline as a "lightweight pass" bypasses both the 5 bug-class checks AND the decision point — that's the anti-pattern.

**Rationale:** Auto-bundling forces cost on every routine pass (wasteful for small changes). Leaving prov-sweep / tests / build entirely off the menu means CC forgets to run them when warranted (Conv 207 [issue 1]: manual lightweight pass at quiet-mode off skipped tests and missed 35 form-component regressions for hours). The decision-point framing makes the question explicit at the trigger. Route-doc regen is explicitly NOT part of this decision set (commit-time only).

**Consequences:** Memory `feedback_codecheck_moment_includes_tests_and_build.md` recast as decision-point rule with applicability heuristics. `/w-codecheck` SKILL.md unchanged (3 fold-in edits made then reverted in same conv after user clarification).

**See:** `memory/feedback_codecheck_moment_includes_tests_and_build.md`, Conv 207 Decisions.md §3.

### Investigative Framings — Surface Findings Before Acting
**Date:** 2026-05-28 (Conv 206)

When a user request uses investigative verbs (*audit / review / investigate / examine / classify / analyze / look at / check*), CC surfaces per-item dispositions before executing — even if the user pre-selected an option from a multiple-choice. Picking an option in an investigative framing authorizes the *approach* (depth/scope), not the *execution*. Rule lives in CLAUDE.md `## Investigative Framings — Surface Findings Before Acting` (top-level §, between §Critical Rule and §Skills); motivating-case archaeology in `memory/feedback_audit_surface_findings_first.md`; MEMORY.md index line under §Solution Quality.

**Rationale:** §Solution Quality's "proceed without explicit approval" + §Critical Rule's "size ≠ novelty" were calibrated for directive requests, not investigative ones. The user identified a structural asymmetry — they cannot preemptively scope an action whose findings they haven't yet seen. Conv 206 [MEM-AUDIT]: user picked option C in a MEMORY.md audit expecting per-item dispositions before execution; CC executed end-to-end. Verb test: "tell me what's true/what's there/what's wrong" → surface first. "Make this change/build this thing/fix this bug" → proceed.

**See:** `CLAUDE.md` §Investigative Framings, `memory/feedback_audit_surface_findings_first.md`, Conv 206 Decisions.md §1.

### /r-optimize Subsumed Into /r-coherence-check (Single Composite Audit Skill)
**Date:** 2026-05-28 (Conv 206)

`/r-coherence-check` is the single coherence/lint entry point for CLAUDE.md ↔ MEMORY.md ↔ `memory/*.md` cross-file consistency. Structural by default (4 deterministic checks: BROKEN-REF, STUB-DRIFT, OVERLAP, ORPHAN — cheap, ~5s), `--deep`/`--semantic`/`--all` flags add 6 semantic categories (CONTRADICTION, AMBIGUITY, FRICTION, STALE, REDUNDANCY, GAP, SCOPE-CREEP — opus max, ~60s). Apply-fixes protocol with diff preview for SEMANTIC fixes. Ack file `.claude/coherence-ack.md` suppresses won't-fix findings without deleting them. Marker list configurable via `.claude/config.json` `coherenceCheck.markers`. `/r-prune-claude` Step 4 runs a scoped post-execute [BROKEN-REF] check. `/r-optimize` was deleted (subsumed).

**Rationale:** `/r-optimize` existed but the user had used it once and forgotten — single discoverable entry point beats two parallel charters. Tiered design (cheap structural default + opt-in heavy semantic) lets the unified skill run as a routine post-edit reflex without paying for semantic analysis every invocation. Separation by cadence + cost works better expressed via flags than via separate skills.

**Consequences:** Single name for cross-file coherence work. `/r-prune-claude` ↔ `/r-coherence-check` coordinate on the "edit-coupled vs background-sweep" seam. Pattern for future audit skills: tiered invocation with `--deep` opt-in.

**See:** `.claude/skills/r-coherence-check/SKILL.md`, `.claude/coherence-ack.md`, `.claude/config.json` `coherenceCheck`, Conv 206 Decisions.md §4-5.

### Skill `!`-Backticks Must Use Tilde-Literal Paths (Not Relative, Not $VAR)
**Date:** 2026-05-28 (Conv 206)

All skill `!`-backtick commands must reference files via tilde-literal absolute paths (`~/projects/peerloop-docs/...`, `~/projects/Peerloop/...`). Relative paths resolve from the skill's base directory (NOT project root) — `cat CLAUDE.md` reads the skill's SKILL.md, not the project's CLAUDE.md. `$VAR` form triggers the Bash permission gate's `simple_expansion` prompt. Hardcoded usernames (`livingroom`/`jamesfraser`) break cross-machine portability. Tilde-literal is the only form that's both portable + prompt-free.

**Rationale:** Same rule the Conv 162 sweep established for `git -C` invocations (`feedback_git_dash_c_enforcement.md`). Conv 206 surfaced 3 violations: `/r-prune-claude` returned `CLAUDE.md line count: 12` (its own SKILL.md), `/r-optimize` hardcoded `livingroom`, `/r-coherence-check` Mode-detect bug (separate issue).

**Consequences:** `/r-prune-claude` and `/r-coherence-check` fixed; all future skills should follow. Conv 162 path-convention sweep extended from `git -C` to all skill `!`-backticks.

**See:** `memory/feedback_git_dash_c_enforcement.md`, `.claude/skills/r-prune-claude/SKILL.md`, Conv 206 Learnings.md §2.

### Skill Arguments Reach Body Text, Not Bash `!`-Backticks
**Date:** 2026-05-28 (Conv 206)

The CC harness passes skill `$ARGUMENTS` to the prompt body (appended as `ARGUMENTS: <args>` line) — NOT to the bash environment of `!`-backticks. Conditional content load based on args MUST happen in the skill body's Step 0 (parses `ARGUMENTS:` from the prompt text), not in `!`-backticks. The `${ARGUMENTS:-}` default-to-empty trick in `!`-backticks produces a safe fallback but cannot actually fire on `--deep` etc.

**Rationale:** Empirical finding via Conv 206 [DEEP-INVOKE-BUG]: `/r-coherence-check --deep` fell through to structural-mode default because `$ARGUMENTS` was empty in bash. Always-load + body-side parsing is the durable fix; user-initiated skills bound the per-invocation cost.

**Consequences:** `/r-coherence-check` rewrote to always-load full CLAUDE.md + memory files; body-side Step 0 parses Mode from prompt text. Pattern for future arg-driven skills: parse args in body, not backticks.

**See:** `.claude/skills/r-coherence-check/SKILL.md` Step 0, Conv 206 Learnings.md §3.

### CLAUDE.md Pruned Via /r-prune-claude → docs/reference/CLAUDE-OFFLOAD.md
**Date:** 2026-05-28 (Conv 206)

CLAUDE.md procedural/reference sections (Dual-Repo Architecture, Startup Hooks, Conv Lifecycle, Test Suite Workflow, Schema Discrepancy Discipline, Development Commands, Database Migrations, Tech & Arch Doc) moved to `docs/reference/CLAUDE-OFFLOAD.md`. CLAUDE.md retains all behavioral rules + identity/overview sections (Project Overview, Tech Stack, RFC System, SQLite Datetime, Baseline Verification, Scratch Space + all behavioral-quality §s). 9 offload pointer links inserted at the moved sections' former locations. Reduction: 533 → 286 lines (46%), 30 KB → 20 KB.

**Rationale:** CLAUDE.md is loaded into every conv — every line competes with behavioral rules for attention. Procedural reference content (how to run commands, repo layout, lifecycle workflows) earns its place by being looked-up-on-demand, not always-loaded. Split mirrors the stub-pointer pattern (rule in CLAUDE.md, archaeology in memory body) at a coarser granularity. `/r-prune-claude` "when in doubt, keep" rule preserved navigational + identity content; clean cut at the behavioral-vs-reference seam.

**Consequences:** First offload file in this repo. New convention: `docs/reference/CLAUDE-OFFLOAD.md` is the receiver for hand-trimmed CLAUDE.md content. 22 H2 headers preserved (table of contents intact via pointer links). Future CLAUDE.md growth follows the same pattern: prune → offload, not delete.

**See:** `docs/reference/CLAUDE-OFFLOAD.md`, `.claude/skills/r-prune-claude/SKILL.md`, Conv 206 Decisions.md §3.

### `@stand-in` Transient Provenance Marker (Not Formalized)
**Date:** 2026-05-27 (Conv 203)

A greppable `@stand-in` header marker tags pages that are legacy rehosts — "not ours, not Matt — stand-ins to redesign" (added to 7 pages: login, signup, onboarding, profile, courses, course/[slug]/[...tab], teachers/[handle]). It is deliberately NOT formalized in `matt-provenance.md` or `prov-sweep`, and avoids the literal string "UNMARKED" so it doesn't trip `prov-sweep`'s untracked-note check.

**Rationale:** Retrofitting a page to Matt-style is the act that removes its marker, so the marker's lifecycle is bounded by the [STANDIN-MATT] task (#25). Unlike `@matt-source`/unmarked (permanent classes `prov-sweep` must police forever), `@stand-in` is transient — heavy formalization is low-value for a self-erasing marker. `grep -rl '@stand-in' src/pages` is literally the remaining-retrofit counter.

### `/r-quiet-mode`: The Log File IS the State
**Date:** 2026-05-27 (Conv 204)

The `/r-quiet-mode <on|off>` skill uses a single fixed log file (`.scratch/quiet-mode-log.md`) as its sole state: quiet mode is ON iff the file exists. `off` deletes it; `/r-end` Step 0 blocks while it exists; `/r-start` Step 5.8 surfaces a leftover log. OFF was augmented to a mandatory issue-raising pause (surface deferred items before proceeding). Considered and rejected: context-only + separate marker, and per-turn hook reinforcement.

**Rationale:** Collapsing state and log into one artifact eliminates a separate state mechanism, gives a self-consistent lifecycle (only ever 0 or 1 files), and costs no per-turn hook. The OFF issue-raising checkpoint was added after a conv where 4 deferred issues were logged but not raised on exit.

### Scan Figma `<instance>` Children Before Rendering — Import Existing Primitives, Never Inline Duplicates
**Date:** 2026-05-24 (Conv 184)

Before translating any Figma frame/page/component into code, CC MUST call `get_metadata` on the target node and audit every `<instance name="…">` child. Each instance name maps to one of: (a) an existing imported code component that must be used directly, or (b) a missing-primitive gap that must be surfaced and resolved BEFORE the render proceeds. Inline duplicates of Matt-drawn primitives are forbidden — even "for now" / "temporary" / "Astro-React boundary friction" rationales. Rule codified in `feedback_reuse_existing_components.md` and indexed in MEMORY.md.

**Rationale:** Matt's Figma `<instance>` nodes are explicit reuse boundaries — he chose to compose, not inline. Conv 175 had inlined Avatar/ActionPill/LikeIcon/CommentIcon inside SocialPost.tsx instead of importing UserIcon/IconLabelChip/AnalyticCount/MattIcon (in fairness those Conv 184 primitives didn't exist yet, but the same drift recurred Conv 184 with CourseAnchor inlining Button styling instead of importing Button.tsx). Inlined duplicates accumulate as design-system drift; consolidating refactors are slow, skippable, and tend to surface only after months of work. Codifying as a hard rule catches the next violation before it lands. The "Astro/React boundary as friction" justification proved fictional — Astro renders React components natively as static HTML.

**Consequences:** CourseAnchor.tsx refactored to use Button.tsx. SocialPost.tsx refactored to use UserIcon + IconLabelChip + AnalyticCount + CourseAnchor (embed). `_SocialPostDemo.tsx` updated to use `<CourseAnchor>` as the embed value (replacing inline `CourseEmbed()` helper). All future Matt-side component builds will scan `<instance>` nodes first. Pattern complements `feedback_tokenize_only_matt_variables.md` and `feedback_external_source_of_truth_first.md` (probe-before-recommend).

**See:** `memory/feedback_reuse_existing_components.md`, `src/components/matt/entity/CourseAnchor.tsx`, `src/components/matt/ui/SocialPost.tsx`, `src/components/matt/ui/_SocialPostDemo.tsx`

### `/r-timecard-day` Writes Timecards to Obsidian Vault via Tilde-Prefix Config Path
**Date:** 2026-05-07 (Conv 157)

`/r-timecard-day` now writes its output to a uniquely-named file in the user's Obsidian vault rather than to a `.timecard.md` file at repo root. The vault path is stored in `.claude/config.json → rTimecardDay.vaultPath` as a tilde-prefixed string (`~/Obsidian Vaults/main2025/_projects/Peerloop/timecards`); the script expands `~` at runtime via `process.env.HOME`. Filename mirrors the actual H3 emission with the `:` stripped from the start time — e.g., `Peerloop Timecard • Coding • May 6, 2026 • 0910.md`. The repo-root `.timecard.md` write is removed; the vault file is the only output. Step 5 is a three-branch flow: dir-missing → STOP with mkdir command, file-exists → halt-and-ask, else → write+open.

**Trigger:** User asked to write the timecard to a uniquely-named file in their Obsidian vault.

**Options Considered (path storage):**
1. Gitignored `.local.json` per machine (initial reflex)
2. Tilde-prefix in committed config + runtime `$HOME` expansion ← Chosen

**Options Considered (write target):**
1. Replace `.timecard.md` with vault file ← Chosen
2. Both (dual-write)

**Options Considered (conflict policy):**
1. Overwrite silently
2. Halt-and-ask ← Chosen
3. -v2 suffix on collision

**Options Considered (dir-missing):**
1. Auto-mkdir -p on first run
2. Error with mkdir command, user creates manually ← Chosen

**Rationale:** Tilde-prefix in committed config + Obsidian Sync = full cross-machine portability with zero per-machine bootstrap. The path is identical when expressed as `~/...` (only `$HOME` differs); Obsidian Sync replicates the folder content. Halt-and-ask defends against accidental overwrites of manually-edited timecards. Auto-mkdir would mask vaultPath typos — catching the missing folder once per machine is cheap; catching a typo months later is expensive. Filename matching the actual H3 emission ("May 6, 2026" not "May 06") preserves the literal "non-icon H3" interpretation and avoids changing `renderedMarkdown` byte-for-byte for every prior timecard.

**Consequences:** New script fields: `vaultPath`, `vaultFilename`, `vaultTargetPath`, `vaultDirExists`, `vaultTargetExists`. SKILL.md Step 5 rewritten with three-branch flow. Stale `.timecard.md` deleted from repo root. M4 folder created (Obsidian Sync replicated to M4Pro automatically). Cross-machine audit confirmed all four portability touchpoints clean: tilde via `process.env.HOME`, `path.join`, `fs.existsSync`, no hardcoded usernames. Live HOME=/Users/jamesfraser simulation produced correct M4Pro path.

> **Insight:** Cross-machine portability is two-layered: the **path** (tilde + `$HOME`) and the **content at the path** (Obsidian Sync, iCloud, git, etc.). Tilde-prefix in committed config solves layer 1; the chosen file-sync mechanism solves layer 2. Together: zero per-machine bootstrap. Skills designed against this primitive don't need machine-detection branches.

**See:** `.claude/scripts/timecard-day.js`, `.claude/skills/r-timecard-day/SKILL.md` Step 5, `.claude/config.json` § rTimecardDay.

---

### `placeholderNames[]` Field on `timecard-day.js` JSON Eliminates Regex-Scan in Executor
**Date:** 2026-05-07 (Conv 157)

`timecard-day.js` now exposes a top-level `placeholderNames[]` array alongside `renderedMarkdown`. `emitBlockBody` was refactored from a pure side-effect function to also return `placeholderName | null`; `renderTimecardMarkdown` collects them via array and returns `{markdown, placeholderNames}`; `main()` attaches both to JSON output. SKILL.md Step 4 rewritten to drive from `placeholderNames` array via literal string substitution, with explicit "do not regex-scan" warning citing the hyphen-pitfall (a `[^-]+` negated class stopped at the first hyphen of `(no-block)`, capturing only `(no` and silently miscounting placeholders).

**Trigger:** Hyphen-sensitive regex bug discovered while filling Block-Progress placeholders in /r-timecard-day Step 4.

**Options Considered:**
1. Leave alone — bug was transient, lesson learned
2. Add `placeholderNames[]` field + drive Step 4 from it via literal substitution ← Chosen

**Rationale:** The script-owns-everything rule applies — when a skill executor has to re-derive data the script already knows (placeholder enumeration is rendering-domain), the right fix is to expose it from the script, not to make the executor smarter. ~5 lines of script + ~6 lines of SKILL.md, additive only. `renderedMarkdown` stays byte-identical (verified pre/post: 32022 chars unchanged); end-to-end re-render produces identical final timecard.

**Consequences:** Step 4 future executors no longer touch regex; literal substitution is bulletproof. The "side-effect function with summary return" pattern (function pushes to out-param array AND returns the summary value; caller chooses whether to collect) generalizes to similar refactors elsewhere.

**See:** `.claude/scripts/timecard-day.js` (`emitBlockBody`, `renderTimecardMarkdown`), `.claude/skills/r-timecard-day/SKILL.md` Step 4.

---

### [MSI] /r-start Step 5.7: Presync Forensics + Data-Loss Halt + MEMORY.md Cap Monitor
**Date:** 2026-05-06 (Conv 155)

/r-start Step 5.7 expanded to (a) write a pre-sync `diff -rq mirror live` log to `~/.claude/projects/<slug>/sync-logs/conv-NNN-presync-TS.txt`, (b) capture live's most-recent file mtime, (c) HALT before `rsync -a --delete` if any `Only in $LIVE` entries detected, (d) auto-snapshot live to `sync-logs/conv-NNN-live-backup-TS/` on halt, (e) present A/B/C options on halt (copy-up / proceed-anyway / inspect), (f) MEMORY.md auto-load cap check (silent ≤79%, 🔴🔴🔴 alert at ≥80% of 200 lines / 25 KB).

**Trigger:** Conv 155's first cross-machine /r-start (M4 → M4Pro) ran the prior version of Step 5.7 and the user asked "what was different between mirror and live?" — pre-rsync state was unrecoverable. Same-conv: [MMC] task carried from Conv 154 needed a cap-monitor location; /r-start is the only conv-boundary already touching memory state.

**Options Considered (forensics):**
1. Always log diff but always rsync (audit only, no protection)
2. Log + halt-on-`Only in $LIVE` + auto-snapshot before halt ← Chosen
3. Block every sync for user approval (too noisy on routine syncs)

**Options Considered (cap monitor):**
1. Standalone script invoked manually
2. SessionStart hook (would run for non-Peerloop projects too)
3. Inline in /r-start Step 5.7 (memory boundary, runs every conv) ← Chosen

**Rationale:** Halt fires only on the genuine risk signal (`Only in $LIVE`); incoming `Files X and Y differ` are normal multi-machine syncs and don't halt. The data-loss window is precise: only the first /r-start on a machine where mirror exists but live wasn't sourced from mirror — after one successful /r-end on a machine, mirror reflects live and the halt cannot fire. Local backup at halt time is bulletproof recovery (sync-logs are local-only; git history is the cross-machine forensic trail). Cap monitor co-located with the only conv-boundary that already touches memory state; silent-on-healthy avoids per-conv noise; 80% threshold gives pruning headroom before truncation.

**Consequences:** /r-start Step 5.7 grew ~50 lines of bash. Sync-logs accumulate locally per conv. Future MEMORY.md growth is visible early (currently 57% / 53%). The reverse syncs (live→mirror in /r-commit and /r-end) remain safe because /r-start runs first per conv → live ⊇ mirror.

**See:** `.claude/skills/r-start/SKILL.md` Step 5.7, `memory/feedback_msi_first_sync_data_loss_window.md`

### [MSI] Mirror Folder Project Awareness — Status Quo (Parent-Repo Nesting Sufficient)
**Date:** 2026-05-06 (Conv 155)

Mirror lives at `<project>/.claude/memory-sync/memories/` — inside each repo. Project identity is via parent-repo nesting; spt's mirror would be at `spt-docs/.claude/memory-sync/memories/`, completely separate filesystem location and separate git history. No folder-rename, manifest file, or per-file frontmatter needed.

**Trigger:** User raised concern about scaling [MSI] to spt; worried mirror folder lacked project awareness. Initially misremembered mirror as living at `~/.claude/memory-sync/` (which would be shared and ambiguous).

**Options Considered:**
1. Rename folder to `memory-sync/peerloop/` (folder self-IDs)
2. Add manifest file `<project>/.claude/memory-sync/.project` (skill validates on sync)
3. Per-file frontmatter `project:` field (most rigorous, biggest write cost)
4. Status quo — parent-repo nesting is sufficient ← Chosen

**Rationale:** Mirror IS already project-aware via in-repo nesting. The shared user-level location (`~/.claude/projects/<slug>/`) is the LIVE side, where slug encoding already provides project awareness. Cross-project leak would require manual file copy between two clones; that's an explicit cross-repo move, not an oversight. Before adding identity markers, check whether existing path/nesting already disambiguates — in this case, repo nesting was sufficient.

**Consequences:** [MSI] adoption in spt-docs requires no design changes — same skill code shape, same path-derivation logic. User noted they will create a task in spt to port.

### Promote Pointing-Emoji + Option-Phrasing Rules into CLAUDE.md §User-Facing Questions
**Date:** 2026-05-06 (Conv 151)

The 👉👉👉 + bold pointing-emoji prefix rule and the A) B) C) labeled-list option-phrasing rule were promoted from `memory/feedback_pointing_emoji_prefix.md` and `memory/feedback_option_phrasing.md` into a new CLAUDE.md §User-Facing Questions section adjacent to §Issue Surfacing. Both memory files were rewritten as stub pointers (option-phrasing stub preserves Conv 132/147 motivating-incident archaeology that didn't fit in the CLAUDE.md prescription). The §Schema Discrepancy Discipline cross-reference was updated from naming the two memory files to pointing at the new section.

**Trigger:** [ARP] watch-task: asymmetric placement of related output-formatting rules — 🔴/🟠 Issue Surfacing lived in CLAUDE.md while 👉 + A/B/C lived in memory with one CLAUDE.md cross-reference site (§Schema Discrepancy Discipline). The original revisit trigger ("cross-ref cost grows") had not fired.

**Options Considered:**
1. (A) Leave as-is — trigger hadn't fired, asymmetry is cosmetic
2. (B) Consolidate into CLAUDE.md ← Chosen
3. (C) Reverse direction — move §Issue Surfacing out of CLAUDE.md into memory

**Rationale:** Option C would degrade reliability for marginal aesthetic gain — §Issue Surfacing is referenced by skills, agents, and `/r-end` in critical paths; making it grep-recall-only carries risk. Option A leaves the asymmetry indefinitely. Option B aligns the three visual-format rules under one CLAUDE.md section, matching the proven Conv 150 baseline-consolidation pattern, at modest cost (+37 lines). The `feedback_pause_on_pointing_questions.md` sibling stays in memory because it's *behavior* (sequencing) not *format* — that distinction held up under scrutiny.

**Consequences:** CLAUDE.md grew 446 → 483 lines but gained structural coherence in user-facing-output rules. Two memory files reduced to stubs using the proven `feedback_visual_issue_alerts.md` template. Future cross-references go to a single CLAUDE.md section instead of two memory files.

**See:** CLAUDE.md §User-Facing Questions, `memory/feedback_pointing_emoji_prefix.md` (stub), `memory/feedback_option_phrasing.md` (stub)

### No-Paste-Tokens Memory Covers Both User-Paste AND Claude-Initiated Diagnostic Leaks
**Date:** 2026-04-21 (Conv 145)

`memory/feedback_no_paste_tokens_in_chat.md` was broadened from a single-surface rule (don't ask user to paste secrets) to a two-section document that also covers Claude-initiated diagnostic patterns (`cat .dev.vars`, `stripe config --list`, `od -c`, `env`, bare `grep`) that dump secrets into the transcript. Section 1 preserves Conv 113's rule verbatim; Section 2 adds unsafe-pattern list, safer-alternatives table (question → safe pattern), redactor one-liners (Stripe, JWT, CF hex, JSON), and a response protocol for leaks that happen anyway.

**Trigger:** Conv 144's two near-miss leaks (partial `whsec_`, full `sk_test_`) were both Claude-initiated, not user-paste. The existing memory was silent on this surface.

**Options Considered:**
1. Add a separate sibling memory file — two rules, two files
2. Broaden the existing memory to cover both surfaces in one document ← Chosen
3. Leave as-is and rely on ad-hoc vigilance

**Rationale:** Both surfaces share the same outcome (secret in transcript = burned). Keeping the rule holistic makes it accessible in one read; fragmenting into two files risks one being remembered and the other missed. The unified "Why" section serves as the motivation anchor for both surfaces. Future convs get a pre-flight heuristic: "does this command's output need to contain a secret, or just a presence/identifier check?" Almost always the latter.

**Consequences:** `MEMORY.md` index line updated to reflect both-directions scope. Reusable redactor library (sed one-liners) is now a shared utility for any skill/hook handling secret-adjacent output.

**See:** `memory/feedback_no_paste_tokens_in_chat.md`, `memory/MEMORY.md`

### /r-end Per-Agent Model Selection via `config.json → rEnd.agentModels`
**Date:** 2026-04-19 (Conv 140)

Each of the 3 dispatched agents in `/r-end` (learn-decide, update-plan, docs) now has its model tier selected via `.claude/config.json → rEnd.agentModels`. SKILL.md resolves the values via `!` backticks: one multi-value expression in the Pre-computed Context section, plus inline expressions in each Agent N heading for point-of-use visibility. When a field is absent the expression prints `(inherit)` and Step 3 DISPATCH instructs the runtime to omit the `model` param so the agent falls back to main-context model.

**Default tiers:** `learnDecide: opus`, `updatePlan: haiku`, `docs: sonnet`.

**Rationale:**
- **Config-driven** matches Peerloop's established pattern (`rTimecardDay`, `docsRegistry`) — single source of truth, editable without SKILL.md edits.
- **Tiered defaults** reflect workload: learn-decide routes decisions to DECISIONS.md vs DOC-DECISIONS.md (past misroute in Session 237 justifies opus); update-plan is mechanical (haiku sufficient); docs walks change-detection matrix + 10 checklists (sonnet is cost/quality sweet spot).
- **Inline `!` backticks in headings** surface the model tier right where the dispatching context reads it — DRY violated intentionally because point-of-use visibility outweighs single-source redundancy.

**Consequences:** Subsequent /r-end runs dispatch agents at these tiers. Cost/latency drop for update-plan and docs; learn-decide retains historical reliability. Adding a 4th dispatched agent means one config line + one SKILL.md heading annotation.

**See:** `.claude/config.json → rEnd.agentModels`, `.claude/skills/r-end/SKILL.md` Pre-computed Context + Step 3 DISPATCH + Agent N headings.

### Evolve Same-Named Skills Independently Across Dual-Repo Projects
**Date:** 2026-04-19 (Conv 140)

Past ~3 months of independent evolution, same-named skills in sibling dual-repo projects (e.g., `r-end` in peerloop-docs vs spt-docs) should be treated as sibling-but-distinct rather than mergeable. `/w-sync-skills` port discussions force unwelcome philosophical alignment decisions (e.g., "should PLAN.md have Conv-N attributions?") appropriate for a standalone conversation, not a tool-driven port.

**Trigger:** `/w-sync-skills r-end` flagged 4 HARD RULES additions in SOURCE that LOCAL lacks. SOURCE rule 2 (no `(Conv NNN)` attributions in PLAN.md) directly contradicts LOCAL's current practice (`[MPT] Conv 130 — Multipart…`); SOURCE rule 1 references a `**Current Status:**` fixed pointer line that doesn't exist in LOCAL.

**Rationale:** Structural divergence accumulated via project-specific customizations (Block Sequence table, promoted shared scripts, Peerloop-specific Change Detection Matrix rows, API Route Mapping, expanded checklists 10 vs 7). Merging forces cascading philosophy changes that outweigh the port benefit.

**Exception:** Source-only skills (new capabilities not yet in LOCAL) remain straightforward to adopt — Step 4c REASSESS OPUS TAGS was ported from spt-docs this conv with Peerloop-flavored rubric examples.

**Consequences:** `/w-sync-skills` should detect >30% structural divergence and recommend "evolve independently", skipping the merge discussion. Recorded as persistent guidance in `memory/feedback_skill_sync_same_name_divergence.md`.

### Tech-Doc Drift Detection: CC SessionStart Hook (Option D), CI Drift-Check Deferred (Option A)
**Date:** 2026-04-19 (Conv 134)

Tech-doc drift is detected via a CC SessionStart hook (`.claude/hooks/tech-doc-drift.sh`) that wraps `.claude/scripts/tech-doc-sweep.sh`. Every `/r-start` runs the sweep over `git diff HEAD~5` in the code repo and surfaces flagged reference/as-designed docs. Git pre-commit hook (Option B) and CI drift-check job in `Peerloop/.github/workflows/ci.yml` (Option A) were evaluated and rejected/deferred.

**Options Considered:**
1. A. CI-only drift-check job (needs cross-repo checkout; ~10s in CI; blocks merge)
2. B. Git pre-commit hook in code repo (~1.3s; warn-only; per-clone install via `core.hooksPath`)
3. C. Both A and B (belt-and-suspenders)
4. D. CC SessionStart hook in docs repo ← Chosen

**Rationale:** D fits the actual workflow — the `peerloop` alias is the canonical entry and SessionStart is already a trusted surface. B's per-clone install friction doesn't pay for a 2-machine setup; warn-only pre-commit hooks get ignored. C is overkill given D's coverage of the CC loop.

**Reactivation triggers for Option A (CI drift-check):** non-CC commit path emerges (automated bot commits, a second human contributor not using CC) OR 10+ convs of evidence that SessionStart misses drift. Until then, A stays deferred.

**Silent-on-clean design:** the hook exits 0 with no output when the wrapped script reports "No reference/as-designed docs flagged" or "No recent code changes detected". Only emits a `=== TECH-DOC DRIFT ===` block (🔴 count + flagged doc list + `/w-sync-docs` or `/r-end2` resolve hint) when drift exists. Recurring informational hooks that print "nothing to see" every conv teach the eye to skip the region where real drift would appear; presence-as-signal preserves the hook's value.

**Measurement correction:** PLAN.md Phase 3 originally said "fast subset: sync-gaps only, skip tech-doc-sweep" but actual runtimes are inverted — `sync-gaps.sh` 4.5s vs `tech-doc-sweep.sh` 1.3s. Corrected inline in PLAN.md and `docs/as-designed/doc-sync-strategy.md` before proceeding.

**See:** `docs/as-designed/doc-sync-strategy.md` §4 Phase 3; `.claude/hooks/tech-doc-drift.sh`; `.claude/settings.json` SessionStart entry 4.

### v2 Commit Format: H3 Sections + `Format: v2` Trailer (Additive Forks)
**Date:** 2026-04-18 (Conv 127)

Conv-lifecycle commit messages now support a v2 format authored by `/r-commit2` and `/r-end2` (additive forks of `/r-commit` and `/r-end`). v2 bodies use `### Section Name` H3 headers (matching `h4Sections[].title` in `.claude/config.json`) to group bullets, and end with a `Format: v2` trailer. v1 skills remain untouched; v1 commits flow through the same `timecard-day.js` parser via text heuristics.

**Detection:** explicit `Format: v2` trailer — not a date cutoff and not H3 presence. Date cutoffs drift across timezones and break on backfilled commits; H3-presence heuristics are fragile because legitimate bullet text can contain `###`.

**Authoring rule:** write each bullet ONCE under its most-natural H3; the `timecard-day.js` predicate engine replicates bullets into every matching H4 (e.g., a `### Work Effort` bullet mentioning `/api/foo` and `API-REFERENCE.md` renders in Work Effort + API Changes + Doc Changes).

**Rationale:** Zero risk to existing v1 workflow; user adopts v2 on their own timeline; rollback is trivial. Refactored parser handles both formats through one predicate engine (no branching).

**See:** `docs/reference/COMMIT-MESSAGE-FORMAT.md` (canonical v2 spec).

### `h4Sections[].title` Is the Single Source of Truth for Section Naming
**Date:** 2026-04-18 (Conv 127)

The `title` field in each `.claude/config.json → rTimecardDay.h4Sections[]` entry IS the literal `### Title` string emitted in v2 commit bodies AND the `#### Title` string rendered in the timecard. One string, two uses; parser reverse-lookups title→id when parsing v2 bodies.

**Rationale:** Portability — a sibling dual-repo project renaming "DB Changes" → "Schema Changes" updates a single config field and both commit authors and parser pick it up. No duplication, no sync risk.

**Consequences:** Renaming a section is a single config edit. Separate "commit-header vs timecard-title" strings was rejected; using H4 `id` (e.g., `### userFacing`) as the commit header was rejected — titles are human-readable, IDs are machine-readable.

### `timecard-day.js` Per-H4 Inclusion Predicates Replace Tier Cascade (2-Pass Engine)
**Date:** 2026-04-18 (Conv 127)

`classifyItem()`'s 5-tier first-match-wins cascade (Conv 126) is replaced by per-H4 `include` predicates evaluated independently. Each H4 section in `.claude/config.json → rTimecardDay.h4Sections[]` owns an `include` predicate; a bullet renders in EVERY H4 whose predicate matches — not just the first. Block Progress already did this for multi-Block commits; the refactor extends that semantic to every bullet-rollup H4.

**Predicate DSL (closed set):** `src`, `matchesRegex`, `textContainsAny`, `startsWithAny`, `docsMentionGt`/`Eq`/`Gte`, `testRelated`/`notTestRelated`, `isRoutine`, `commitFileMatchesPrefix`, `allCommitFilesUnder`, `flag`, `fallthrough`, `anyOf`/`allOf`. String values like `"reroute.apiMethodRe"` resolve via `resolveConfigRef(ref, rt)` to config-field references at eval time.

**2-Pass engine + recursive fallthrough:** Pass 1 evaluates every H4 predicate over every bullet independently (`{fallthrough: true}` deliberately returns false). Pass 2 routes any bullets that matched nothing in Pass 1 to whichever H4 has `fallthrough: true` nested (detected by new `predicateHasFallthrough` helper walking `anyOf`/`allOf` trees recursively). Work Effort uses `{anyOf: [{src: "workEffort"}, {fallthrough: true}]}` — home for workEffort bullets AND catch-all, without greedily claiming every bullet.

**Rationale:** Legacy tier cascade lost multi-dimensional bullets (e.g., a bullet mentioning both an API path and a doc file was claimed by whichever tier hit first). Multi-H4 replication preserves all semantic dimensions. Single config pattern covers "primary home AND fallthrough" without duplicating work.

**Consequences:** Engine is O(bullets × H4s). All project-specific constants (`OVERFLOW_CAP_HHMM`, `TAG_PREFIXES`, `HEARTBEAT_RE`, etc.) removed from script and moved to `.claude/config.json → rTimecardDay`. H5/H6 strategies are named in script lookup tables (`H5_STRATEGIES` / `H6_STRATEGIES`) and referenced by name per-H4 in config.

### `/r-start` Closes With Bold Yes/No Prompt; Recommended Action Last
**Date:** 2026-05-06 (Conv 149)

`/r-start` Step 8 Present Context template orders sections as `Quick Context → Recommended Action`, with Recommended Action ending in a bold `**Start [TASK-CODE] now? (yes / no)**` prompt on its own line. The skill HALTS after asking. New rule added: "Recommended Action MUST be the last section."

**Trigger:** Previously `/r-start` ended with prose about the recommended action followed by Quick Context, with no explicit prompt — Claude would resume but the user couldn't see the waiting state at a glance.

**Options Considered:**
1. Add a separator/footer line after Quick Context.
2. Reorder so Recommended Action is last, end with bold Yes/No prompt ← Chosen. Combines `feedback_bold_questions.md` (bold + own line + clear question) with section ordering.
3. Replace recommended-action with a TaskList-style numbered options menu.

**Rationale:** User-driven directive. Combines two existing patterns (bold-question + last-position) into a single closing convention.

**See:** `.claude/skills/r-start/SKILL.md` Step 8.

### `/r-start` Side-Effect Steps Run AFTER Counter Push (Step 5.5+)
**Date:** 2026-04-14 (Conv 115)

Any `/r-start` step with side effects (npm install, codegen, migration sync, etc.) must run after Step 5 (CONV-COUNTER push). Drift detection uses the existing content-hash mechanism in `scripts/check-env.sh` (sha256 of `package-lock.json` vs `node_modules/.package-lock-hash` written by a `postinstall` hook). On drift, prompt the user before running; do not auto-run silently.

**Rationale:** Side-effect artifacts (e.g., lockfile metadata changes from `npm install`) must be attributable to a conv. Running before counter push would land changes in a pre-conv limbo. Prompt-gating preserves the §Critical Rule: Ask Before Deciding and §Skills: Preserve `!` Backtick Determinism rules in CLAUDE.md — silent auto-install masks lockfile changes and can silently fail on a broken lockfile.

### Baseline Claims Must Come From the Current Conv
**Date:** 2026-04-10 (Conv 102)

Any test/tsc/build baseline stated in RESUME-STATE.md, session docs, or `/r-end` docs-agent output must come from a command that actually ran in the current conv. Baselines are never copy-forwarded from prior RESUME-STATE files. If unchanged and not re-verified, mark explicitly: `(unchanged from Conv N, not re-verified this conv)`. Rule encoded in `~/.claude/projects/-Users-jamesfraser-projects-peerloop-docs/memory/feedback_verify_baselines_in_conv.md`.

**Rationale:** Conv 101's RESUME-STATE claimed "6399/6399 passing" without running the suite. Conv 102 ran it and found 5 pre-existing failures that had been lurking across an unknown number of conversations. Copy-forwarding hides regressions in plain sight.

### SKILL.md `!` Backtick Scripts Must Always Exit 0
**Date:** 2026-04-10 (Conv 102)

Scripts invoked via `!` backtick expressions in SKILL.md are pre-computed context, not validation. They must always `exit 0` regardless of what they find. Any script using `grep`, `find`, `test`, or similar commands that exit non-zero on "no match" must explicitly `|| true` those commands or end with `exit 0`. A failing script blocks SKILL.md from loading entirely with a `Shell command failed for pattern` error.

**Rationale:** `.claude/scripts/resume-state-check.sh` broke `/r-end` in Conv 102 because it did `grep 'Saved:'` on a file whose format had changed and no longer contained `Saved:`. grep exited 1, the harness treated the `!` backtick as failed, and SKILL.md never loaded. Fix added broadened regex, `|| head -1` fallback, and explicit `exit 0` safety net.

### Conv (Conversation) Lifecycle — Replaces Session Numbering
**Date:** 2026-03-17 (Session 393)

Work units are tracked as "Conv" (Conversation) numbers, replacing "Session" numbering (which ended at Session 393). Conv numbers start at 001. Both repos treated as a paired unit — same Conv number in both repos' commit messages (`Conv NNN: description`).

**Lifecycle:**
- `/r-start` — check both repos clean, pull both, increment CONV-COUNTER, push, resume
- `/r-commit` — always commits both repos with Conv + Machine metadata
- `/r-end` — EOS sequence, save pending tasks to RESUME-STATE.md, commit both, push both, cleanup `.conv-current`

**Key files:** `CONV-COUNTER` (persistent integer, git-synced), `.conv-current` (ephemeral, gitignored)

**Trigger:** "Session" collided with Claude Code's internal session concept. A CC session can span multiple Convs (via `/clear`), and one Conv can span multiple CC sessions (across machines).

**`/r-pre-clear` eliminated (Conv 010):** Formerly a separate skill for saving state before `/clear`. Its state-save responsibility was incorporated into `/r-end` Step 3 — if pending TaskList items exist, `/r-end` runs `/r-save-state` automatically before committing.

**RESUME-STATE.md as transparent TodoWrite persistence (Conv 012):** RESUME-STATE.md is now purely a serialization layer — the user never interacts with it directly. `/r-start` Step 7 reads remaining items from RESUME-STATE.md, creates TaskCreate entries in TodoWrite, then deletes the file. `/r-end` serializes pending TodoWrite tasks to RESUME-STATE.md before committing. TodoWrite is the single interface for outstanding work; RESUME-STATE.md is just the wire format between conversations.

**Skill consolidation (Conv 001):** Retired 6 w-* skills that had direct r-* equivalents (w-eos, w-learn-decide, w-dump, w-update-plan, w-commit, w-save-state). Merged w-docs into r-docs as single canonical docs skill. Remaining w-* skills (timecard, codecheck, sync-docs, etc.) retain their names — they have no r-* equivalent and are Peerloop-specific.

**See:** `CONV-COUNTER`, `.claude/skills/r-start/SKILL.md`, `CONV-FLOWCHART.md` (in prod-helpers)

### CONV-INDEX.md Replaces SESSION-INDEX.md
**Date:** 2026-03-17 (Conv 005)

`CONV-INDEX.md` tracks Conv-numbered work (001+). `SESSION-INDEX.md` is frozen at Session 393 as a historical archive.

**Rationale:** Clean break between numbering systems. Mixing two numbering schemes in one file would be confusing. SESSION-INDEX.md is a complete 393-entry historical record.

### Dual-Repo Commit Workflow
**Date:** 2026-02-20 (Session 232), updated 2026-03-17 (Session 393)

When changes span both repos, commit code first, then docs. Both commits use the same Conv number. `/r-commit` always commits both repos — if one has nothing to commit, it's skipped silently.

| Scenario | Action |
|----------|--------|
| Code changes only | `git -C ../Peerloop add . && git -C ../Peerloop commit` |
| Doc changes only | `git add . && git commit` |
| Both repos changed | Code first, then docs (same Conv number) |

**Rationale:** Code commits may trigger CI. Docs commits are follow-up context. Same Conv number links them for traceability.

### Dev Log File Naming Convention
**Date:** 2026-02-20 (Session 229)

All dev log files use the format `YYYY-MM-DD_HH-MM-SS {Type}.md` where Type is `Dev`, `Learnings`, or `Decisions`. Files within the same conv share the same timestamp.

**Trigger:** Learnings/Decisions files initially used `YYYYMMDD-HHMM` format while Dev used `YYYY-MM-DD_HH-MM-SS`. Inconsistency caused confusion.

**Rationale:** Single format, shared timestamp groups related files together in directory listing.

### Dev Logs Are Immutable Historical Records
**Date:** 2026-02-27 (Session 307)

Session files in `docs/sessions/` are never modified after creation. They document what happened at that point in time, including file paths, decisions, and references that may later become stale.

**Trigger:** STORY-REMAP stale reference audit found ~200 mentions of deprecated `src/data/pages/` paths in old session logs. Question: should they be updated?

**Decision:** No. Editing session logs to remove stale references rewrites history and undermines their value as an audit trail.

**Rationale:** Session logs are like commit messages — they describe the state of the world at the time. Stale references in old sessions are expected and correct.

### CC Hooks Run in Minimal Shell
**Date:** 2026-02-20 (Session 229)

Claude Code hooks execute in a minimal shell that does NOT source `~/.zshrc` or `~/.bash_profile`. Tools managed by nvm, Homebrew (`/opt/homebrew/bin`), or other profile-dependent managers are invisible.

**Pattern:** Hook scripts must explicitly source dependencies:
```bash
export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
```

**Consequence:** Diagnostic/informational hooks should always `exit 0`. Non-zero exits are treated as errors by CC.

### PostToolUse Hook for Check Output Reminders
**Date:** 2026-03-16 (Session 391)

A PostToolUse hook (`check-output-reminder.sh`) fires after every Bash tool call and reminds Claude to TodoWrite any issues found. Two-layer design:

- **Layer 1 (check commands):** Parses output from `npm test`, `tsc`, `eslint`, `astro check`, `check:tailwind` for detailed error/warning/hint counts. Strong "TodoWrite NOW" language.
- **Layer 2 (general failures):** Catches any non-zero exit code not handled by Layer 1. Softer "Diagnose the failure" language since not all failures are bugs.

**Trigger:** Claude repeatedly dismissed check findings as "pre-existing" instead of tracking them. Feedback memories weren't sufficient — the behavioral gap required intervention at the exact moment of discovery.

**Consequence:** Hook registered in `.claude/settings.json` with `matcher: "Bash"`. Non-check commands exit immediately (minimal overhead). Takes effect from next session.

### TodoWrite-Gap Reminders Embedded in Skill Chain
**Date:** 2026-03-20 (Conv 021)

When `/r-docs` discovers documentation gaps (undocumented endpoints, stale docs, missing coverage), it must TodoWrite them — not just mention them as "pre-existing" in commentary. This rule is now embedded directly in the skill text at two levels:

- **`/r-eos` Rules section** — sets the expectation before `/r-docs` is invoked
- **`/r-docs` Action Plan** — `⚠️ CRITICAL` callout with trigger-word self-monitoring ("pre-existing", "missing", "stale", "gap", "undocumented")

**Trigger:** Despite two feedback memory entries (`feedback_surface_and_track_all_issues.md`, `feedback_codecheck_todos.md`), the behavior kept recurring because memory can be compressed away during long `/r-end` chain executions. Skill SKILL.md files are loaded fresh each invocation.

**Rationale:** Complements the PostToolUse hook (which catches Bash tool output) by covering the skill chain path where gaps are discovered through script output and manual review rather than direct tool calls.

### No-Op Closure as a Valid TodoWrite Terminal State
**Date:** 2026-04-15 (Conv 121)

When a TodoWrite investigation concludes that nothing needs to change, mark the task `completed` and update its description to read `"No-op closure: investigated X, confirmed Y, no change needed"`. Do not leave such tasks pending, and do not delete them.

**Rationale:** A future reader needs to know *what was checked* and *why no action followed* — otherwise they cannot distinguish a solved-no-op from a skipped item. Verified on #20 [SG] (`.astro/` exclusion concern no longer reproducible) and #13 [AD] (auth docs spot-check still holds from Conv 099). Applies as the default closure for any task whose investigation resolves without code change.

### w-git-history: Per-Commit Machine and Repo Tags
**Date:** 2026-02-21 (Session 237)

`/w-git-history` now includes machine name and repo identifier on every commit entry. Previously, `Machine:` lines were filtered out and the repo name was only in a section header.

**Changes:**
- `Machine:` lines no longer excluded — rendered as a regular bullet per commit
- `(code)` or `(docs)` tag appended to each commit's datetime header line

**Trigger:** Timecards combining commits from both repos (via `/w-timecard`) didn't show which computer or which repo each commit came from.

**Rationale:** The data was already in every commit body (`Machine:` footer from `/q-commit-local`) and inherent to the git directory (`repo=` argument). Fixing the display layer is retroactive — all existing commits benefit with no format changes needed.

**See:** `~/.claude/commands/q-git-history.md`

### Conv-Based Timecard Selection (conv=NNN)
**Date:** 2026-03-20 (Conv 019)

`/w-timecard-dual` gained a `conv=NNN[,NNN,...]` parameter as an alternative to count-based `cNdN`. Uses `git log --grep="Conv NNN"` to find all commits matching the requested conv numbers across both repos automatically.

**Trigger:** Generating retroactive timecards for multiple convs required manually counting commits per repo — tedious and error-prone.

**Caveat:** `--grep` matches anywhere in the commit message body, not just the `Conv:` metadata line. A Conv 016 commit mentioning "Conv 015-016" in its body gets returned as a false match for Conv 015. Requires manual verification of subject lines when convs are adjacent.

**See:** `.claude/skills/w-timecard-dual/SKILL.md`

### /r-end Auto-Advances Drift Baseline After Each Conv
**Date:** 2026-04-19 (Conv 137)

`/r-end` Step 6 runs `advance-drift-baseline.sh` after the code repo commit and before the docs repo commit, so `.drift-baseline-sha` is bundled into the docs commit. This means every new conv starts with the baseline at the code SHA that was reviewed in the previous conv.

**Rationale:** Without auto-advance, drift flags reviewed by the /r-end docs agent would reappear at the next SessionStart — the hook sees the same HEAD~5 window because the baseline hadn't moved. Auto-advance closes the loop: docs agent reviews flags → baseline advances → next session starts clean. Manual advance via `advance-drift-baseline.sh` remains available for non-/r-end workflows.

**Consequences:** `/r-end` SKILL.md Step 6 updated. `tech-doc-drift.sh` hook footer notes the auto-advance. `.drift-baseline-sha` is a tracked file in the docs repo.

### Reporting Skills Must Scan All Local Branches; Commit-Creation Skills Stay HEAD-Only
**Date:** 2026-04-11 (Conv 103)

For timecard/history-style **reporting** skills, plain `git log` (which reads HEAD) is a silent billing bug whenever long-lived branches exist. They must scan all local refs/heads/* and de-dup by hash. **Commit-creation** skills (`/r-commit`, `/q-commit`) stay HEAD-only — that's the only sensible semantic for "commit to where you are."

**UX split based on query semantics:**
- **Date-based queries** (`/r-timecard-day`) → per-branch iteration via `git for-each-ref refs/heads/`, count in-window commits per branch, prompt user with 👉👉👉 (default include-all) when non-HEAD branches have hits. Date windows are inherently ambiguous — multiple branches may legitimately have in-window work, not all of which should bill.
- **Unique-ID queries** (`/r-timecard conv=NNN`) → silent `git log --branches --grep=...` + per-commit `git branch --contains` resolution + de-dup. Conv numbers identify a single unambiguous unit of work; just find it wherever it lives.
- **Count-based queries** (`/r-timecard cNdN`) → HEAD-only by design. "Last N commits on the branch I'm on" is the semantic; switching branches before running is user error, not skill bug.

**Trigger:** `/r-timecard-day Apr-10-2026` returned zero code commits because all 4 of Apr 10's code commits lived exclusively on `jfg-dev-10up` (the long-lived Astro 6 upgrade branch) while HEAD was `jfg-dev-9`. Only caught by cross-referencing docs commit messages that textually mentioned the code hashes.

**Rationale:** `git log --branches` is the canonical "all local heads" flag — cleaner than `--all` (no remote/tag noise), more readable than explicit for-each-ref iteration. Use it when you need union-across-branches without per-branch counts.

**Branch column convention:** All reporting-skill Git History tables now include a Branch column between Hash and Machine. Dedup rule: when a commit is reachable from multiple branches (post-merge), record the non-HEAD/non-main branch — that's where the work was actually done.

**See:** `.claude/skills/r-timecard-day/SKILL.md`, `.claude/skills/r-timecard/SKILL.md`

### /r-start Dirty-Repo Guard: Proceed When Only RESUME-STATE.md Is Dirty
**Date:** 2026-04-11 (Conv 103)

When `/r-start`'s Step 1 dirty-repo check halts with `RESUME-STATE.md` as the only modified file, the correct action is to **proceed past the guard**, not commit first. Step 7 of `/r-start` consumes RESUME-STATE.md by reading its TodoWrite Items into TodoWrite and deleting the file — the deletion is the canonical end-state.

**Trigger:** Conv 103 /r-start halted on ` M RESUME-STATE.md` after the user appended insurance tasks pre-/r-start. Committing first would create a commit whose lines are immediately deleted by Step 7's transfer-and-delete, adding noise to git history.

**Rationale:** The dirty-repo guard exists to prevent losing uncommitted work. RESUME-STATE.md is a special case — its "uncommitted work" IS the thing /r-start is supposed to consume.

**Caveat:** RESUME-STATE.md is **tracked**, not gitignored. Edits to it are real uncommitted changes and the deletion is staged as part of the next /r-end commit.

**Known gap:** /r-start Step 7 assumes TodoWrite is empty (true after `/clear`). In no-clear `/r-start` paths, pre-existing TodoWrite items may collide with items transferred from RESUME-STATE.md and need manual dedup. Tracked as task `[RD]`.

**See:** `.claude/skills/r-start/SKILL.md`

### CURRENT-BLOCK-PLAN.md for Multi-Session Blocks
**Date:** 2026-02-24 (Session 276)

For blocks too large for one session, create `CURRENT-BLOCK-PLAN.md` at the docs repo root. Contains checkboxes for every item, key files table, and progress summary updated each session. Deleted when block completes.

**Trigger:** BBB block has 5 sub-blocks with ~25 items. PLAN.md is too high-level for per-item tracking. RESUME-STATE.md is session-specific and gets deleted on resume.

**Pattern:** Each session reads the file first, works through unchecked items, updates checkboxes, adds a session progress summary at top. "Next session" guidance tells the next CC instance where to start.

**Automation:** Use `/q-make-block-persistent <BLOCK-NAME>` to extract a block from PLAN.md and write it to `CURRENT-BLOCK-PLAN.md` with a progress table. Global skill (Session 287).

**See:** `CURRENT-BLOCK-PLAN.md` (exists while block is active), `~/.claude/commands/q-make-block-persistent.md`

### w-* Prefix for Project Skills (Disambiguation)
**Date:** 2026-03-11 (Session 373)

All project skills in `.claude/skills/` use the `w-*` prefix. Global commands in `~/.claude/commands/` retain the `q-*` prefix. This eliminates autocomplete collisions where the UI showed both `/q-eos (project)` and `/q-eos (user)`.

**Trigger:** Repeatedly selecting the wrong skill from the ambiguous autocomplete list.

**Pattern:** `w-*` = project-local (this repo only), `q-*` = global (all projects). The prefix makes origin immediately obvious. 13 project skills renamed; global commands unchanged.

**Consequences:** Updated SKILL.md files, CLAUDE.md, DOC-DECISIONS.md, skills-system.md, DEVELOPMENT-GUIDE.md, detect-changes.sh. Session logs left as-is. Also deleted 3 orphaned `*-local` command files and migrated 2 `L-*` commands to Skills 2 as `w-*` skills. `.claude/commands/` is now empty.

**See:** `docs/as-designed/skills-system.md`, Session 373 Decisions.md

### Skills 2 Migration: Merged Single-File Pattern
**Date:** 2026-03-10 (Session 364)

Skills with paired global/local commands (`q-docs.md` + `q-docs-local.md`) are migrated to Skills 2 as a single merged `SKILL.md` in `.claude/skills/<name>/`. Project-specific content is inlined (not in a separate `project.md`), replacing `<!-- PROJECT -->` placeholders from the canonical template.

**Trigger:** Skills 2 directories naturally accommodate both global logic and project config. The old two-file handoff ("REQUIRED: read project.md") was a reliability risk.

**Pattern:** Project `.claude/skills/r-docs/SKILL.md` overrides global `~/.claude/commands/q-docs.md` — unconverted projects keep working. Use `!` backtick injection for helper scripts that pre-compute data at invocation time.

**See:** Session 364 Decisions.md, `~/skills-canon/` repo

### skills-canon Repository for Skill Template Management
**Date:** 2026-03-10 (Session 364)

Canonical skill templates live in `~/skills-canon/` (git repo, GitHub-backed). Each project gets real copies (not symlinks). Drift is managed, not prevented.

**Tools:**
- `drift-report.sh` — section-level divergence detection across projects
- `skill-patch.sh` — interactive surgical sync (pull/push/hunk selection)
- `install.sh` — deploy skills to new projects

**Pattern:** Each project skill directory has a `.sync` file tracking last reconciliation. Canonical templates use `<!-- PROJECT -->` comments for customization points. `CUSTOMIZATION-GUIDE.md` documents what to change per project.

> **Insight:** This is the cathedral vs. bazaar applied to skills — the symlink approach enforces uniformity (cathedral), while real copies with drift tools allow each project to evolve freely and cross-pollinate improvements (bazaar). The `.sync` file does the same job as `git merge-base` — recording a common ancestor for intelligent reconciliation. (Session 364)

### Marker-Anchored Detection for /r-docs
**Date:** 2026-03-10 (Session 365)

`detect-changes.sh` records both repos' HEAD SHAs in `.last-qdocs-run` after each `/r-docs` run. The next run diffs from that marker forward, showing only changes since the last documentation pass.

**Trigger:** `HEAD~5` was arbitrary and pulled in 260+ files from weeks of prior sessions. Time-based `--since` was better but still duplicated work on multi-session days.

**Pattern:** Marker file is now gitignored (Conv 061). Originally committed so it could travel across machines, but a race condition caused it to be left dirty: if the docs agent writes the marker after the `/r-end` commit, the file blocks the next `/r-start`. Since both machines have full functionality, the cross-machine benefit didn't justify the intermittent breakage. Falls back to `--since "24 hours ago"` when no marker exists or the SHA isn't found locally. `--reset` flag forces fallback.

**See:** `.claude/skills/r-end/scripts/detect-changes.sh`, `docs/as-designed/skills-system.md`

### Separate Skill for Dual-Repo Timecards
**Date:** 2026-03-10 (Session 369)

`/w-timecard-dual` is a standalone skill rather than a `repo=both` mode on `/w-timecard`. The single-repo skill stays clean and composable; the dual skill handles merge logic (unified header, combined Focus/Client/Work sections, two Git History blocks).

**Rationale:** Extending `/w-timecard` would mean either complex argument handling or chaining to itself — but `/w-timecard` opens the editor as a side effect, making chaining impractical. Compact `c2d3` syntax (regex-parsed, order-independent) keeps invocation fast.

**See:** `.claude/skills/w-timecard-dual/SKILL.md`

### Marker Tracking Not Suitable for Billing-Critical Output
**Date:** 2026-03-10 (Session 369)

Evaluated and rejected adding a `latest` argument to `/w-timecard-dual` that would auto-detect un-timecarded commits via a marker file (same pattern as `.last-qdocs-run`).

**Rationale:** Marker-based tracking works when stale/premature markers have low-cost consequences (detect-changes.sh showing extra files — harmless). For timecards, a premature marker advance means *missing billable work*. The marker would update at generation time but the user might not copy the output. Other issues: no sane first-run fallback, cross-skill coordination between single and dual timecard skills. The explicit `c2d3` count syntax costs ~5 seconds but eliminates state-tracking bugs.

> **Insight:** The suitability of marker-based tracking depends on failure mode asymmetry. "Show too much" (harmless) vs "miss data" (costly) — the same pattern works for one and fails for the other. Always evaluate the consequence of a stale or premature marker before adopting this pattern. (Session 369)

### $CLAUDE_PROJECT_DIR Points to CC Home
**Date:** 2026-02-20 (Session 232)

`$CLAUDE_PROJECT_DIR` always resolves to the project where `.claude/` lives (the CC home, `peerloop-docs/`). It does NOT point to directories added via `--add-dir`.

**Consequence:** Hooks needing code repo paths must use `$CLAUDE_PROJECT_DIR/../Peerloop/...`.

### TodoWrite Discipline: Capture Everything
**Date:** 2026-03-12 (Session 386)

Any unresolved issue, opportunity, question, or implied action item must be added to TodoWrite immediately. This includes pre-existing errors found during checks, ideas spotted while reading code, and user messages containing signal words ("should", "might", "could", "need to", "do later", "soon", "eventually").

**Rationale:** TodoWrite items carry forward via `/r-end` → RESUME-STATE.md → `/r-start` → TodoWrite (transparent persistence, Conv 012). Silently skipping items means they're lost in conversation noise. The user decides priority, not the assistant.

**Consequence:** Updated `~/.claude/CLAUDE.md` (global), feedback memories, and `/r-start` Step 7 (deserialize RESUME-STATE.md into TodoWrite on startup).

### Test File Hygiene: Draft Fast, Clean Immediately
**Date:** 2026-03-12 (Session 386)

When writing tests, draft with a full starter-kit of imports for speed, but do a cleanup pass to remove unused imports/variables before moving to the next file.

**Rationale:** Unused imports create persistent Astro/TS hints that accumulate and obscure real issues. A 10-second pass when the file is fresh prevents this entirely.

**See:** `docs/reference/BEST-PRACTICES.md` §8, `docs/reference/CLI-TESTING.md` "Import & Fixture Hygiene"

### Collector + Agent Dispatch Pattern for Multi-Stage Skills
**Date:** 2026-03-25 (Conv 031)

Skills that need to process conversation data in multiple independent ways (learn-decide, dump, update-plan, docs) should use a collector + agent dispatch pattern instead of nested skill calls. Main context scans conversation once into a structured extract file, then dispatches agents in parallel — each reading only their relevant section.

**Rationale:** Skills are prompt injections, not functions — nesting 3 levels deep loses the outer return path. Agents get isolated context windows, and the extract file doubles as a debugging artifact. This replaced the r-end → r-eos → 4 skills nesting that caused recurring failures (stopping after step 2, missing TodoWrite items).

> **Insight:** The instinct to compose skills like functions comes from a programming background, but LLM context windows don't have call stacks. The materialized view pattern — pre-compute shared data to disk, dispatch isolated agents — is the LLM-native equivalent of function composition.

**See:** `.claude/skills/r-end2/SKILL.md`, Conv 031 Decisions.md

### Shared Reference Files (refs/) for Agent Format Rules
**Date:** 2026-03-25 (Conv 031)

When agents need formatting rules from standalone skills, extract those rules into shared `refs/fmt-{name}.md` files rather than inlining them in the orchestrator or having agents read standalone skill files directly.

**Rationale:** Decouples agent format rules from standalone skill execution flow. Agents get focused instructions without pre-computed context or confirmation templates they don't need. Standalone skills remain the source of truth; refs files are curated extracts.

**See:** `.claude/skills/r-end2/refs/`, Conv 031 Decisions.md

### Extract Files: Keep Permanently, Prune Duplicated Content
**Date:** 2026-03-26 (Conv 034)

Keep r-end2 Extract files permanently but prune §Learnings and §Decisions sections after agents produce their companion files. Replace pruned sections with pointer lines. (§Changes is no longer pruned — see "Extract Replaces Dev.md" below.)

**Rationale:** §Prompts & Actions is the unique narrative — the only record of what was discussed and why. §Uncategorized captures stray observations. Both have no equivalent in other files. Pruning eliminates ~70% duplication while preserving 100% of unique value.

> **Insight:** Intermediate artifacts in a pipeline should be pruned to their unique value, not deleted entirely. The pruning boundary is defined by what downstream consumers already materialized — anything they copied is redundant, anything they didn't is irreplaceable.

**See:** `.claude/skills/r-end2/SKILL.md` Step 4b, Conv 034 Decisions.md

### Manifest-Based Pruning for Parallel Agent Coordination
**Date:** 2026-03-26 (Conv 034)

Agents append consumed line numbers to a shared manifest file (`/tmp/extract-manifest.txt`) via atomic `echo >>`. Controller reads manifest after all agents complete, sorts descending, and deletes listed lines. Failed agents don't append, so their sections stay in the Extract as fallback.

**Rationale:** Agents know exactly which lines they cherry-picked. Manifest is append-only (no race conditions under PIPE_BUF). Controller handles deletion at the natural synchronization point. This replaced blunt controller-side section removal that couldn't know if an agent succeeded.

**Current state:** After eliminating the dump agent (see below), only the learn-decide agent writes to the manifest. The manifest infrastructure is retained for forward-compatibility — if a future agent needs to prune Extract content (e.g., a dedicated Changes agent, or a new section type), it can append to the same manifest with zero coordination changes. Simplifying to inline response parsing would save one file I/O but would require re-introducing the manifest if a second writer ever appears.

> **Insight:** The append-only manifest pattern solves a common parallel coordination problem: multiple producers need to signal completion to a single consumer without locks. The key constraint is that the source file must be immutable during agent execution — line numbers are stable addresses only if nothing else modifies the file.

**See:** `.claude/skills/r-end2/SKILL.md`, Conv 034

### Extract Replaces Dev.md — Dump Agent Eliminated
**Date:** 2026-03-26 (Conv 034)

The Extract file is now the primary conv record, fully replacing Dev.md. Added `## Conv Prompts` section (bulleted verbatim user prompts) and kept `## Changes` (git diffs + per-file context) in the Extract instead of pruning them. The dump agent is eliminated — r-end2 dispatches 3 agents instead of 4.

**Per-conv output is now 3 files:**
| File | Content | Produced by |
|---|---|---|
| `Extract.md` | Meta, Prompts & Actions, Changes, Conv Prompts, Progress, Tasks, Uncategorized | r-end2 controller (§Learnings and §Decisions pruned after agents) |
| `Learnings.md` | Formatted learnings with topic tags | learn-decide agent |
| `Decisions.md` | Formatted decisions with options/rationale | learn-decide agent |

**Trigger:** Post-r-end2 review revealed §Prompts & Actions in Extract was nearly word-for-word duplicated in Dev.md's Development Transcript section. Since the Extract already contained the narrative, changes, and progress, adding Conv Prompts made Dev.md entirely redundant.

**Rationale:** Eliminating the dump agent reduces dispatch from 4→3 agents (faster, simpler). The Extract was already being kept permanently — making it the sole conv record avoids maintaining two files with overlapping content. Conv Prompts provides the quick-scan index that Dev.md's prompt list offered.

**Supersedes:** The "Extract Files: Keep Permanently, Prune Duplicated Content" decision above is partially updated — §Changes is no longer pruned (it stays in the Extract since there's no Dev.md to hold it). Only §Learnings and §Decisions are still pruned via manifest.

**See:** `.claude/skills/r-end2/SKILL.md`, Conv 034

### Skill Consolidation: spt-docs Back-Port
**Date:** 2026-03-27 (Conv 035)

Ported the simplified skill architecture from the spt-docs project back to peerloop-docs. The spt-docs skills were originally derived from peerloop-docs but evolved to consolidate 8 end-of-conv skills into a single `/r-end` with 3 parallel agents, inline resume logic in `/r-start`, and a unified `/r-timecard`.

**Changes:**
- `/r-end` now owns all end-of-conv processing: Extract collection, 3 parallel agents (learn-decide, update-plan, docs), state save, commit/push. Replaces r-end (legacy), r-end2, r-eos, r-dump, r-learn-decide, r-docs, r-update-plan, r-save-state.
- `/r-start` inlines resume logic (Step 8) — no separate `/r-resume` skill.
- `/r-timecard` replaces `/w-timecard-dual`. `/w-timecard` (single-repo) preserved separately.
- `/r-prune-claude` renamed from `/w-prune-claude` for prefix consistency.
- Agent format refs moved to `r-end/refs/`, docs scripts to `r-end/scripts/`.
- `r-end-agent-failed` from spt-docs was NOT ported — references non-existent `.claude/agents/` definitions.

**Result:** 22 skills → 14 skills (5 r-* + 9 w-*). Rollback tag: `pre-skill-migration`.

**Rationale:** Fewer skills = less maintenance, fewer skill-to-skill call failures, faster end-of-conv execution. The spt-docs version proved stable over multiple conversations.

**See:** `.claude/skills/r-end/SKILL.md`, Conv 035

### Post-/r-end Fix Pattern: /r-start Without /clear
**Date:** 2026-03-27 (Conv 036)

When fixes are needed after /r-end completes, run `/r-start` (without `/clear`) to open a new conv with full conversation context. Fix the issue, then `/r-end`. Each fix gets its own conv number with proper session docs.

**Rationale:** Zero changes to any skill required. The pattern works because: (1) /r-end commits and pushes, leaving repos clean; (2) /r-start pulls, increments counter, and pushes — which also pushes any post-/r-end commits that piggybacked; (3) /r-start overwrites `.conv-current` with the new conv number. Alternatives (gate inside /r-end, split into /r-end + /r-close, gate + topup skill) all added complexity with no benefit.

**See:** Conv 036 Decisions.md

### r-end Closing Menu
**Date:** 2026-03-27 (Conv 036)

After /r-end completes, a text-based menu offers two options: (1) `/clear` to start fresh, or (2) `/r-start` to continue with existing history. User types 1 or 2. `Skill` added to r-end allowed-tools for /r-start invocation.

**Rationale:** Keyboard-selectable widgets are not possible in Claude Code — text menu is the only UX option.

**See:** `.claude/skills/r-end/SKILL.md`, Conv 036 Decisions.md

### Persist Implementation Plans to Committed Files
**Date:** 2026-03-29 (Conv 056)

Implementation plans that need to survive across conversations are persisted to `docs/as-designed/` and committed to git. `.claude/plans/` is for in-conversation use only — it is gitignored and ephemeral.

**Trigger:** Conv 055 created a detailed plan in Plan Mode. User was told it was "saved." After /r-end, /clear, /r-start, the plan file was gone. Session files capture decisions/learnings but not implementation-level detail (component signatures, SQL queries, file paths).

**Rationale:** When user says "save the plan," they mean persist permanently. `docs/as-designed/{plan-name}.md` is durable, committed, and available to future conversations.

**See:** Conv 056 Decisions.md

### Composable STUMBLE Segments Over Monolithic Instances
**Date:** 2026-04-01 (Conv 071)

STUMBLE walkthroughs should be built from small chainable segments (2-3 steps each) rather than monolithic instances. Segments align with service boundaries (local vs external dependencies). A failed segment can be re-run independently without restarting from the beginning.

**Rationale:** Flywheel STUMBLE hit a natural boundary at checkpoint 10 (Stripe) — checkpoints 11-14 (BBB) couldn't be tested in dev. Composable segments provide failure isolation, incremental coverage, and reuse across instances.

**See:** Conv 071 Decisions.md, `docs/as-designed/plato.md`

### Pre/Post Segment Split for Fix-and-Verify
**Date:** 2026-04-02 (Conv 077)

When a STUMBLE walkthrough encounters a failure, split the instance at the failure point: Pre-segment (steps before) runs in API mode with `snapshot: true` to build DB state fast, Post-segment (failure onward) is walked in browser after restoring the snapshot to verify the fix visually.

**Rationale:** One snapshot per failure point, not N per step. Uses existing infrastructure (API mode, snapshots, browser mode). Segment files are one-off by default but may be promoted to permanent scenarios.

**See:** Conv 077 Decisions.md, `docs/as-designed/stumble-workflow.md`

### Editor Migration: Cursor to VS Code
**Date:** 2026-04-05 (Conv 084)

All editor references migrated from `cursor` to `code` across skills, hooks, config, templates, and docs. VS Code is the standard editor housing the Claude Code terminal.

**Rationale:** User decision to move from Cursor to VS Code. 9 files updated across skills (4), global config (3), template (1), and docs (1). Session logs left as historical records.

> **Insight:** Editor references are scattered across skills, hooks, config templates, permission entries, and docs. When migrating editors, a full-repo search for the old editor command name is necessary — `config.json` alone is not sufficient.

### Structured Commit Tags for Categorical Extraction
**Date:** 2026-04-06 (Conv 085)

Commit messages use prefixed single-line tags (`API:`, `Page:`, `Role:`, `Infra:`) in the commit body. Timecard skills extract these into dedicated sections. Tags are optional and backward-compatible — old commits produce empty sections that get omitted.

**Rationale:** Simple prefix matching on git log output, consistent with existing `User-facing:` / `Admin-facing:` pattern. Avoids parser-maintenance burden of YAML/JSON in commit bodies while remaining human-readable. The commit is the single source of truth; extraction complexity lives in the timecard skills.

> **Insight:** Commit messages as structured data sources follow the Unix philosophy — keep the storage format simple and greppable, push complexity into the extraction tool.

### TodoWrite Mnemonic Short Codes (Global)
**Date:** 2026-04-06 (Conv 089, collision rule Conv 090)

TodoWrite tasks use `[XX] Subject` prefix format (2-3 character mnemonic codes). Added to global `~/.claude/CLAUDE.md` under Work Tracking, not project-specific. On collision within the current task list, append sequential numbers: `[GE]` -> `[GE2]` -> `[GE3]`.

**Rationale:** Convention is project-agnostic — user can say "do PL" in any project to execute the matching task. Collision numbering ensures uniqueness without sacrificing mnemonic readability. Ported from spt-docs.

### Three SPT Governance Directives Ported
**Date:** 2026-04-06 (Conv 089)

Added "Ask Before Deciding" (structural/architectural decisions require user approval), "Preserve `!` Backtick Determinism" (skill pre-computed context is immutable), and "Multi-Session Blocks" (CURRENT-BLOCK-PLAN.md pattern) to peerloop-docs CLAUDE.md.

**Rationale:** Fills governance gaps — Solution Quality override covered solutions but not structural decisions; backtick determinism wasn't documented; CURRENT-BLOCK-PLAN.md existed as skill but wasn't in CLAUDE.md. Ported selectively from spt-docs (not all differences, only actionable rules).

### Claude Code PreToolUse Hook for Timezone Lint Enforcement
**Date:** 2026-04-06 (Conv 091)

A PreToolUse hook (`.claude/hooks/pre-commit-lint-tz.sh`) intercepts `git commit` Bash calls targeting the Peerloop code repo and runs `lint-timezone.sh` before allowing the commit. Violations block the commit with denial; clean runs allow it.

**Rationale:** Claude is currently the sole committer. A git pre-commit hook (husky) would add a build dependency for a single-dev project. The fragility — human commits bypass this gate — is documented in `docs/as-designed/lint-timezone.md` with a mitigation path (add husky + CI when a second developer joins).

**Consequence:** Human commits are ungated. `docs/as-designed/lint-timezone.md` created with full fragility analysis.

### Always Use /r-end for Commits (Never /r-commit Directly)
**Date:** 2026-04-06 (Conv 091)

`/r-commit` should only be used when the user explicitly requests a mid-session save. Default end-of-conv commit path is always `/r-end`.

**Rationale:** `/r-end` runs session documentation agents (learn-decide, update-plan, docs). Committing via `/r-commit` skips those agents, causing overlapped or missing session docs for the next conv. Saved as feedback memory.

### Writer/Reader Tag Contract Must Be Symmetric Across All Readers
**Date:** 2026-04-10 (Conv 099)

When a commit-metadata tag (e.g., `Doc:`, `Infra:`) is added to the writer side (r-commit, r-end), every reader must extract it or content is silently dropped. Readers: `r-timecard-day`, `r-timecard`, `w-git-history`. Symmetric rule also applies in the inverse direction: a reader added without a corresponding writer yields empty sections.

**Rationale:** Conv 098 added `Doc:` extraction to `r-timecard-day` but not to `r-timecard`, leaving r-timecard as a silent orphan for three convs. Fixed in Conv 099 [SS2] by porting the extraction. Checklist: any new writer tag must be traced through every reader; any new reader tag must have a writer emitting it.

### w-sync-docs Audits Expanded: Schema + Cross-Document Consistency
**Date:** 2026-04-10 (Conv 099)

`/w-sync-docs` now covers 5 audit categories (was 3): Test Docs, API Docs, Schema Docs (DB-GUIDE.md vs 0001_schema.sql), CLI Docs, Cross-Document Consistency (5.1 DECISIONS.md/DOC-DECISIONS.md category coverage + mis-routing, 5.2 CLAUDE.md Technology Stack table vs package.json, 5.3 rfc/INDEX.md vs CD-* folders).

**Rationale:** Ported from spt-docs during [SS5] skill-sync with adaptation to Peerloop paths and the DECISIONS/DOC-DECISIONS split. Audits are non-blocking (report-only), no behavior change until invoked.

### w-sync-skills Hardened: DIRECTION Block + Self-Applicable Guardrails
**Date:** 2026-04-10 (Conv 099)

`/w-sync-skills` Step 3 now includes a verbatim DIRECTION block declaring SOURCE/LOCAL, framing every finding as "Source has: … / Local has: …", and treating local-only content as customization to preserve (not a gap). Explore-agent delegations must restate the DIRECTION block and use SOURCE/LOCAL labels (never "project A/B"). Step 5b added: compare CLAUDE.md behavioral directives (including `~/.claude/CLAUDE.md`) in addition to skill files.

**Rationale:** Prevents Claude from suggesting to delete legitimate local customizations as "drift from source". Validated in-session by running the hardened skill on itself ([SS6]), where the rule correctly classified the new DIRECTION block as a local-only customization to preserve.

### PLAN.md Status Markers Must Be Verifiable Against Git State
**Date:** 2026-04-10 (Conv 099)

A PLAN block marked "IN PROGRESS" with a branch name must correspond to a real git branch in the code repo. PACKAGE-UPDATES was marked "IN PROGRESS (Conv 096)" for three convs with zero code changes and no `jfg-package-updates` branch anywhere.

**Rationale:** Silent status drift wastes future-conv cycles (trying to "continue" nonexistent work) or hides missed work. Candidate sanity check: /r-end docs agent or /w-codecheck audit that runs `git branch --list {name}` for any IN PROGRESS block claiming a branch. Tracked as Uncategorized in Conv 099 extract.

### M4Pro Canonical Machine Name: `MacMiniM4Pro` (no hyphen)
**Date:** 2026-05-21 (Conv 168)

The canonical name for the Mac Mini M4 Pro machine is `MacMiniM4Pro` (no hyphen), superseding the previous `MacMiniM4-Pro` (hyphenated) canonical that was locked in via the TypeScript `MachineName` type and 8 docs. Conv 168 [MND] migrated 11 files (hook, `tests/helpers/machine.ts`, `vitest.global-setup.ts`, `tests/README.md`, `dev-env-scan.sh` grep, CLAUDE.md, devcomputers, env-vars-secrets, dev-setup, skills-system, COMMIT-MESSAGE-FORMAT, DEVELOPMENT-GUIDE, cloudflare) to the no-hyphen form.

**Trigger:** [MND] hostname-match fix on `detect-machine.sh` surfaced a contradiction — PLAN.md text said `MacMiniM4Pro` while the codebase used `MacMiniM4-Pro`. Recent Conv 163-167 commit messages had been using the no-hyphen form as a manual workaround because the hook fell into `Unknown ($HOSTNAME)`.

**Options Considered:**
1. `MacMiniM4-Pro` (hyphenated) — code-truth, preserves existing TS type, zero migration churn
2. `MacMiniM4Pro` (no hyphen) ← Chosen — matches PLAN.md + commit-message reality

**Rationale:** The no-hyphen form was already in use across PLAN.md and recent commit messages; maintaining two forms (hyphenated in code, no-hyphen in commits/PLAN) had higher ongoing cognitive cost than the one-time 11-file migration. `M4Pro` is also unambiguous — `M4-Pro` reads ambiguously between "M4-Pro chip" and "Mac-mini-M4 Pro".

**Consequences:** `MachineName` TS type narrowed to `'MacMiniM4Pro' | 'MacMiniM4' | 'CI' | 'unknown'`. Hostname fallback in `getMachineName()` matches `Jamess-Mac-mini`, `M4Pro`, `M4-Pro` patterns (latter two for the M4Pro machine itself). `detect-machine.sh` case statement matches `*M4Pro*` and `*M4-Pro*`. `dev-env-scan.sh` grep accepts all three forms (`MacMiniM4Pro|MacMiniM4-Pro|MacMiniM4`) for forward + historical compat so existing session docs still surface.

**See:** `tests/helpers/machine.ts:12`, `~/.claude/hooks/detect-machine.sh`, `docs/as-designed/devcomputers.md`

> **Conv 191 update:** The M4Pro hostname was renamed to `M4Pro.local`, and the **global** `~/.claude/hooks/detect-machine.sh` (separate from the project hook) still only matched the old `*Jamess-Mac-mini*` pattern → `Unknown (M4Pro.local)`. Re-applied the same canonical decision: added `*M4Pro*`/`*M4-Pro*` patterns (checked before base `*M4*`), kept legacy patterns as fallback, output standardized to `MacMiniM4Pro`. Committed to the global repo (`98cc4c4`); downstream confirmed (test global-setup printed `Machine: MacMiniM4Pro`). The historical name split at that point was 58 hyphen / 12 no-hyphen.

### Cross-Machine Path Verification Harness (`cross-machine-verify.sh`)
**Date:** 2026-05-21 (Conv 168)

Path-derivation patterns used in skills (tilde expansion, `$HOME` references, slug derivation via `echo ~/projects/peerloop-docs | tr / -`, memory-dir composition) are verified pre-commit via `~/projects/peerloop-docs/.claude/scripts/cross-machine-verify.sh` — a shell harness running each canonical pattern under `HOME=/Users/livingroom` (M4) and `HOME=/Users/jamesfraser` (M4Pro) via `bash -c "$expr"` subshells, then asserting structural-glob match (e.g., `/Users/*/projects/peerloop-docs`). 9 baseline cases pass; the script exits non-zero if any case diverges between HOMEs. Also includes `--scan <file>` mode that lists every tilde / `$HOME` / `$CLAUDE_PROJECT_DIR` reference in a target file (advisory, no pass/fail).

**Trigger:** [XMV] task recurring across 4 convs without scope; user prompted to pick a concrete shape after Conv 162's tilde-everywhere sweep had landed without per-machine verification.

**Options Considered:**
1. Build HOME-simulation harness ← Chosen
2. Codify discipline in CLAUDE.md
3. Defer until next sweep triggers it
4. Retire the task

**Rationale:** A runnable check is more durable than a prose rule that depends on someone remembering to apply it. The harness is the discipline made executable; future path-derivation sweeps can run it pre-commit. Single-machine sweeps have silently broken the other machine before (Conv 152/153) — self-falsification beats self-discipline.

**Consequences:** New script with 9/9 cases passing. Documented in `docs/as-designed/devcomputers.md` §Machine Inventory > Cross-Machine Path Verification. Two modes: full suite (`cross-machine-verify.sh`, regression test for sweep invariants) and advisory (`--scan <file>`, ad-hoc pre-commit review of any target file).

**See:** `.claude/scripts/cross-machine-verify.sh`, `docs/as-designed/devcomputers.md` § Cross-Machine Path Verification

---

### Figma MCP: Dev Seat Over Full Seat (Structural Read-Only API Guarantee)
**Date:** 2026-05-23 (Conv 180)

For Figma Remote MCP integration, use a **Dev seat** (not Full seat). The Dev seat provides all read tools needed by the project (`get_design_context`, `get_metadata`, `get_screenshot`, `get_variable_defs`, `get_libraries`, `search_design_system`, `whoami`) and structurally blocks writes at the Figma API boundary. View/Collab seats are unusable (capped at 6 tool calls/month).

**Trigger:** Conv 180 initially recommended switching to Full seat for write flexibility; user pushed back preferring the structural safety guarantee against inadvertent writes.

**Options Considered:**
1. Full seat — read + write, no API-level write blocking
2. Dev seat ← Chosen — read-only outside drafts, structural API-enforced write block
3. View/Collab seat — capped at 6 tool calls/month, unusable

**Rationale:** Project has no plan to push code → Figma; if that ever changes, the seat can be upgraded. The Dev seat removes accidental-edit risk at the API boundary — discipline-as-architecture rather than discipline-as-rule.

**Consequences:** Dev seat already assigned on Peerloop org per Conv 180 `whoami` probe. Brian outreach updated to keep Dev seat (initial message had asked for Full seat).

**See:** `memory/reference_figma_mcp_behavior.md`

### Figma Is Strictly Read-Only — Never Call Write-Shaped MCP Tools
**Date:** 2026-05-23 (Conv 183)

When operating against any Figma file via the Figma MCP server, CC must treat the file as strictly read-only. Permitted tools: `get_metadata`, `get_design_context`, `get_screenshot`, `get_variable_defs`, `get_libraries`, `search_design_system`, `get_figjam`, `whoami`. Forbidden tools: `mcp__figma__use_figma`, `create_new_file`, `upload_assets`, `add_code_connect_map`, `send_code_connect_mappings`, `generate_figma_design`, `generate_diagram` — anything that creates, mutates, or pushes content into a Figma file. The `/figma-use`, `/figma-generate-design`, `/figma-generate-library`, `/figma-code-connect`, `/figma-use-figjam`, `/figma-generate-diagram` skills are out-of-scope on this project unless the user explicitly reopens the door for a specific task.

**Rationale:** Matt (designer) is sole author of all Figma content; CC's role is one-directional translation Figma → code via probes and screenshots. Reinforces `memory/project_matt_collaboration_style.md` ("Matt keeps ALL working material in Figma — specs, notes, decisions, value-prop exploration") and the existing principle that we produce markdown specs FROM Figma probes, not into the file. Explicit user directive: "We are not to change Figma at all."

**Consequences:** New memory file `memory/feedback_never_modify_figma.md` indexed under MEMORY.md §Security & Secrets. When a Figma write-shaped MCP tool's schema appears via ToolSearch, do not load or call it. If a task would require writing to Figma (e.g., back-propagating code-connect mappings), surface the conflict to the user and pause — do not proceed autonomously.

**See:** `memory/feedback_never_modify_figma.md`, `memory/project_matt_collaboration_style.md`

### Pre-Flip Git Worktree as the `/old` Reference Environment (Not an In-Branch Fix)
**Date:** 2026-05-26 (Conv 202)

To inspect the legacy app's look and behavior — which now lives under `/old` on the live branch but whose deep nav links 404 (hardcoded root-path hrefs in the shared `AppNavbar`, broken by ROUTE-FLIP) — stand up a git worktree at the pre-flip commit rather than patching the live branch. `~/projects/Peerloop-preflip` checked out at `608346a2` (parent of ROUTE-FLIP commit `846bab9f`, Conv 197) serves the genuine pre-flip app (legacy at root, Matt at `/matt`) on port :4331. The three in-branch alternatives — client-side href rewrite in `layouts/old/AppLayout.astro`, a `basePath="/old"` prop threaded through the navbars, and a middleware 404→`/old` fallback — were all rejected. No `/old` deep-link/prefix fix is built.

**Rationale:** Highest fidelity (the real historical app, not a patched approximation), zero working-tree modification, and zero removal-debt — when the artifact you'd patch is being deleted anyway, the durable choice is the most-contained one, which here is "don't patch at all; reference history." The middleware fallback specifically would have masked the live-branch `/old` 404s that are RTMIG's verification signal: during the migration a visible 404 is a feature, not a defect.

**Consequences:** Live-branch `/old` deep links keep 404-ing by design. The reference env is machine-local (worktrees aren't pushed); reproduced via the `peerloop-ref` zsh alias plus the committed idempotent bootstrap script `../Peerloop/scripts/setup-preflip-ref.sh` (worktree add + `.dev.vars` copy + `npm install` + `db:setup:local:dev` + alias append), and a `Peerloop-preflip (:4331 ref)` folder added to `peerloop.code-workspace`. The /chrome bridge drives it by URL/port (directory-agnostic), so :4321 live and :4331 reference coexist. Teardown tracked as `[PREFLIP-WT]`; remove when RTMIG-4 inspection is done.

**See:** `memory/project_preflip_worktree_reference.md`

---

### `/r-start` Branch-Match Gate (RSTART-DIFFGATE, Step 5.6)
**Date:** 2026-06-17 (Conv 297)

`/r-start` gains a deterministic branch-match gate that cross-checks the code repo's checked-out branch against RESUME-STATE's recorded `Branch: code:`. New `conv-branch-check.sh` emits a verdict plus a safety classifier (clean / 0-ahead → safe checkout offer); SKILL.md Step 5.6 surfaces a mismatch and offers a safe checkout. Calibrated against 8 cases including the canonical incident (M4 left on `jfg-dev-13-matt` from Conv 291 while all of Conv 292/295/296 — including PALETTE-FDN — lived on `jfg-dev-14`).

**Rationale:** `git pull --ff-only` only fast-forwards the *current* branch; it never switches or surfaces a sibling-branch divergence, and the SessionStart hook merely *printed* the branch without comparing it to recorded state. The first symptom was a colour-token lookup silently failing mid-sweep — a confusing downstream failure for an upstream cause. The gate converts the hazard into an explicit, early, offer-to-fix prompt.

**Consequences:** `.claude/scripts/conv-branch-check.sh` (new) + r-start Step 5.6; /r-start now halts/offers-checkout on a branch mismatch.

---

## 4. Obsidian Vault

### Local .obsidian/ Per User
**Date:** 2026-02-20 (Session 229)

Each user creates their own `.obsidian/` folder locally. It is gitignored and never committed. Users customize their own themes, plugins, and workspace layout independently.

### Markdown Links Over Wikilinks
**Date:** 2026-02-21 (Session 233)

Obsidian configured with `useMarkdownLinks: true` — standard `[text](path)` format, not `[[wikilinks]]`.

**Rationale:** Files are viewed on GitHub (client deliverable), in VS Code, and in CC context. Standard markdown links render correctly everywhere. Wikilinks only work inside Obsidian.

**Trade-off:** Slightly more verbose link syntax, but full portability.

### Two-Vault Architecture: Personal vs Project
**Date:** 2026-02-21 (Session 233)

Personal Obsidian vault (synced via Obsidian Sync) remains separate from peerloop-docs vault (on GitHub). No consolidation.

**Trigger:** Considered merging personal notes, timecards, and daily notes into peerloop-docs. Client visibility on GitHub prevents this — personal content must not be committed.

**Options Considered:**
1. Single vault with gitignored `_private/` folder — no off-machine backup for private content
2. Single vault with Obsidian Sync + git — two sync mechanisms fighting over same files
3. Two separate vaults ← Chosen

**Rationale:** Each vault has exactly one sync mechanism and one audience. Personal vault uses Obsidian Sync (multi-device, no GitHub). Project vault uses git (version control, client-visible). Clean separation.

**Consequence:** Cross-vault linking not possible in Obsidian. Use searchable conventions (e.g., "Session 233 — see peerloop-docs") for cross-references.

> **Insight:** The temptation to consolidate everything into one system is strong, but access-control boundaries (client-visible vs personal, git-backed vs sync-backed) are non-negotiable. The cleanest architectures respect those boundaries rather than trying to abstract over them. Two vaults with clear responsibilities and a few CC skills bridging the gap is simpler to maintain than one vault with layered privacy rules. (Session 233)

---

## 5. Documentation Conventions

### Unified Margins/Layout Style Guide — Doc-First, Code Deferred
**Date:** 2026-06-15 (Conv 288)

The project's first unified layout/margins style guide lives at `docs/as-designed/matt-design-system/08-layout-and-margins.md`, authored from Matt's "Breakpoints and layouts" Figma frames. The guide (§8.3.1/§8.3.2 frame extraction + §8.5 rules) is landed first; the ContentShell build + app-wide rollout is deferred to a later conv (tracked in PLAN.md LAYOUT-SG). Content follows Matt's spec — fills the white "Page Content" card capped at 964px (whole shell caps 1248px); a narrower prose reading-measure would be an explicit documented project extension only, not baked in.

**Rationale:** Matt left a spacing *scale* but no layout *system*, and the content max-width was an open question to him since Conv 172. His new frames finally answer it. Landing the spec before code lets the user gather client input on the one remaining open item (desktop utility-column side, left vs right — Q2) without churning implementation. Adopting the card makes /courses and /course/[slug] both 964px → resolves the "margin jar" (640 vs ~1230) that motivated the guide.

**See:** `docs/as-designed/matt-design-system/08-layout-and-margins.md`; PLAN.md LAYOUT-SG block.

### DOC-DECISIONS.md for Docs-Repo Decisions
**Date:** 2026-02-21 (Session 233)

`/w-learn-decide` (migrated to Skills 2 in Session 367) routes decisions to the appropriate file:
- **Peerloop application decisions** (code, schema, UI, API) → `docs/DECISIONS.md`
- **Docs-repo decisions** (organization, workflows, CC config, vault) → `DOC-DECISIONS.md`

Same structured format (trigger, options, rationale, consequences) for both.

> **Insight:** The split between DECISIONS.md and DOC-DECISIONS.md mirrors a distinction that exists in most software projects but is rarely made explicit: product decisions (what we're building) vs process decisions (how we work). By separating them, each file stays focused and navigable. Because DOC-DECISIONS.md tracks docs-repo conventions, it becomes a portable reference — if you start a new client project with a similar docs-first architecture, the playbook carries forward as a template. (Session 233)

### Durable Insight Capture
**Date:** 2026-02-21 (Session 233)

During `/w-learn-decide` processing, `★ Insight` blocks are scanned for durable, informative insights. Qualifying insights are co-located with the decision they illuminate as `> **Insight:**` blockquotes.

**Rationale:** Co-locating insights with decisions follows the same principle as co-locating tests with code — the context you need to understand *why* something exists should be as close as possible to the thing itself. Separate files create cross-referencing overhead.

**Qualification:** An insight is durable if it connects a decision to broader professional context, explains why a convention works well beyond the immediate rationale, or would teach someone starting a similar project.

### Dynamic Tech Doc Sweep in /r-docs
**Date:** 2026-03-05 (Session 334), migrated to Skills 2 (Session 364)

`/r-docs` dynamically discovers tech docs (`docs/reference/*.md`, `docs/as-designed/*.md`) and cross-references against code paths changed in the session. No hard-coded mapping to maintain — new tech docs are automatically included. Originally implemented in `/q-docs-local` section 7; now runs as `tech-doc-sweep.sh` helper script via `!` backtick injection.

**Trigger:** Session 334 missed updating `session-booking.md` during `/q-docs` because the existing checklist only triggered on package/config changes, not domain code changes.

**Options Considered:**
1. Hard-coded code-path → tech-doc table — drifts as tech docs are added
2. Hard-coded table + maintenance skill in `/w-eos` — extra step, easy to forget
3. Dynamic sweep: discover docs, match against session changes ← Chosen

**Rationale:** 31 tech docs and growing. Any static mapping becomes stale. The dynamic approach has zero maintenance cost and catches new tech docs automatically. The heuristic matching (code path patterns → topic keywords) doesn't need to be perfect — it's a reminder check, not a gate.

**See:** `.claude/scripts/tech-doc-sweep.sh`

### Tech Doc Sweep: Auth-Doc False Positives Are Expected
**Date:** 2026-04-15 (Conv 125)

The `auth` rule in `tech-doc-sweep.sh` (line 32: `"auth|auth"`) matches any changed file under `src/**/auth*` against any doc whose filename contains `auth`. Any commit touching `src/lib/auth/*` or `src/pages/api/auth/**` will flag all 4 auth docs: `API-AUTH.md`, `auth-libraries.md`, `google-oauth.md`, `auth-sessions.md`. This is **expected noise**, not a drift signal.

When reviewing tech-doc-sweep output during `/r-end` or an `[ADR]`-style audit, dismiss these 4 docs quickly unless the underlying code change falls into one of these narrow categories:

| Touch this area of code | Actually review this doc |
|---|---|
| New/changed **HTTP endpoint** under `src/pages/api/auth/**` | `API-AUTH.md` |
| New/changed **JWT library pattern** (jose/bcryptjs/arctic) | `auth-libraries.md` |
| New/changed **OAuth provider setup** or registration | `google-oauth.md` |
| New/changed **session lifecycle**, refresh logic, or permission helpers | `auth-sessions.md` |

Conv 123's `[RA-ADM]` drain added `isUserAdmin`/`getUserPermissionFlags`/`getAllAdminUserIds` to `src/lib/auth/session.ts` — only `auth-sessions.md` was genuinely affected, and Conv 123 updated it in the same commit (line 207 References). The other 3 flags were false positives.

**Rationale:** The sweep script is a **reminder**, not a **gate** — its false-positive rate is acceptable because dismissing a false flag is cheaper than missing a real one. Tightening the `auth` rule to eliminate these false positives would require splitting into 4 granular code-path patterns (30-45 min of work + test coverage), which has been deemed not worth the cost for noise that surfaces ~once per conv that touches auth.

**Trigger:** Conv 125 `[ADR]` task — auditing whether Conv 123 ROLE-AUDIT changes had propagated to the 4 flagged auth docs. All 4 were found current or already updated; investigating the script revealed the noise is structural, not state-based (script is stateless, no "baseline" to reset).

**Alternatives considered:**
1. Tighten the `auth` rule into 4 granular code-path patterns — rejected: effort exceeds value
2. Add a suppression list with TTLs — rejected: significant engineering for low-value problem
3. Accept as known noise + document here ← Chosen

**See:** `.claude/scripts/tech-doc-sweep.sh`, Conv 125 `[ADR]` close-out

### Tech Doc Sweep: Vendor/Area Keyword Noise
**Date:** 2026-04-19 (Conv 135)

The `tech-doc-sweep.sh` matcher flags any doc whose filename contains a topic keyword. This is coarse enough to produce structural false positives for docs whose topics overlap with common code patterns. Conv 133's script-bug fix uncovered 9 such flags on first HEAD~5 run (2 real, 7 false); Conv 135's re-triage after subsequent fixes classified the residual noise.

Four docs are **chronic structural noise** — dismiss quickly unless the underlying code change matches the narrow real-review trigger:

| Doc | Triggers on | Actually review when |
|---|---|---|
| `docs/reference/stream.md` | Any `feed`/`stream`/`community` code path | Stream.io SDK version bump, webhook shape change, or vendor-choice rationale revised |
| `docs/as-designed/ratings-feedback.md` | Anything matching `feed*` (grep substring of `feedback`) | Schema/logic changes to `session_assessments`, `enrollment_reviews`, `course_reviews`, or rating computation |
| `docs/reference/react-big-calendar.md` | Any `calendar` keyword hit — even though the library isn't used in the booking wizard (which uses a custom `AvailabilityCalendar`) | Library upgrade or a new surface that actually adopts react-big-calendar |
| `docs/reference/astrojs.md` | **Any `.astro` file change** (`astro` keyword matches the extension itself) | New Astro pattern established (e.g., islands-strategy shift, adapter swap, SSR contract change) — routine page edits never qualify |

The `astrojs.md` case is especially chronic: every conv that edits any `.astro` page will re-flag it, because the keyword `astro` matches the file extension.

**Non-structural false positives (case-by-case, always verify):**
- `docs/as-designed/feeds.md`, `docs/reference/API-COMMUNITY.md`, `docs/reference/resend.md`, `docs/as-designed/availability-calendar.md` — these *are* real drift-check targets when code truly affects them. They were flagged in the Conv 133/135 batch by tangential refactors (`fetchCourseTabData` SSR consolidation of course metadata, `isUserAdmin` helper extraction, new email template component files, 28-day window already-documented) that didn't actually change the content each doc describes. Read the diff before dismissing.

**Rationale:** The sweep is a reminder, not a gate. Tightening the matcher per-doc (e.g., making the `astro` keyword require an `astro.config.*` touch) would work but is multi-doc engineering for noise that experienced CC instances can dismiss in seconds. Adding a known-noise table here lets fresh sessions triage faster without regressing the matcher's recall for real drift.

**Trigger:** Conv 135 `/r-start` surfaced the standing 9-doc flag via the Phase 3 SessionStart hook; 2 gaps from the Conv 133 batch (`availability-calendar.md` 28-day window, `resend.md` SessionInvite rows) were already fixed. Conv 135 fixed the 1 remaining real gap (`session-booking.md` month-nav cap note) and classified the other 8 as non-drift.

**Alternatives considered:**
1. Per-doc granular code-path patterns (4 × ~30-45 min engineering) — rejected: effort exceeds value for reminder-grade output
2. Suppression list with TTLs — rejected: state management overhead for low-value problem
3. Known-noise entry in DOC-DECISIONS.md ← Chosen (same pattern as Auth-Doc entry above)

**See:** `.claude/scripts/tech-doc-sweep.sh`, `.claude/scripts/docs-registry.mjs`, PLAN.md §DOC-SYNC-STRATEGY Phase 2 Follow-ups, Conv 125 Auth-Doc entry above (same pattern).

### Feature Tracking Rule: All Features Must Be in PLAN.md
**Date:** 2026-03-05 (Session 342)

Any time a feature is mentioned — in a tech doc, session discussion, RFC, or code comment — it must be added to `PLAN.md`. Where it goes is situational (active block, deferred, sub-task of an existing block). If the feature originated from a tech doc, add a cross-reference noting the PLAN block (e.g., "Tracked in PLAN.md: RATINGS-EXT"). Tech docs describe *how* and *why*; PLAN.md is the single source of truth for *what needs to be done*.

**Trigger:** Scanned all 31 tech docs and found 4 blocks worth of untracked development work (POSTHOG, MOCK-DATA-MIGRATION, RATINGS-EXT, CURRENTUSER-REFRESH) plus 1 missing item in an existing block (SessionHistory in MSG-ACCESS.PHASE2).

**Rationale:** Without this rule, features silently accumulate in tech docs where they're invisible to planning. The cross-reference closes the loop in both directions.

**See:** CLAUDE.md "Feature Tracking Rule" section

### DB-GUIDE.md Replaces DB-SCHEMA.md
**Date:** 2026-03-07 (Session 359)

`docs/reference/_DB-SCHEMA.md` deprecated (Session 359) and subsequently deleted (Conv 132). Replaced by slim `docs/reference/DB-GUIDE.md` that covers only design rationale — the *why* behind the schema. For column names, types, and constraints, use the SQL source of truth (`../Peerloop/migrations/0001_schema.sql`).

**Trigger:** Capabilities review found DB-SCHEMA.md massively out of sync: TERMINOLOGY renames never applied, 15+ columns undocumented, 23 tables documented but never built. The file duplicated information already in the SQL and always drifted.

**Options Considered:**
1. Full rewrite of DB-SCHEMA.md to match current SQL
2. Drop entirely — just use SQL
3. Replace with slim guide covering only rationale ← Chosen

**Rationale:** Documentation that duplicates code will always drift. The SQL file is what developers reference. The only value worth maintaining is design rationale: why Community > Progression > Course, why capabilities not roles, how the two rating systems work, payment split architecture. DB-GUIDE.md captures that in ~200 lines vs DB-SCHEMA.md's 2000+.

**Consequences:** DB-SCHEMA.md kept with deprecation banner through Session 359–Conv 131, then deleted in Conv 132 as part of DOC-SYNC-STRATEGY Phase 1 retirement sweep. References updated in CLAUDE.md, DOC-DECISIONS.md, docs/DECISIONS.md, q-docs-local.md (now deleted — migrated to Skills 2 `/r-docs`, Session 364). Session logs left as-is.

**See:** `docs/reference/DB-GUIDE.md`, `../Peerloop/migrations/0001_schema.sql`

### Test Doc Paths: Repo-Root-Relative
**Date:** 2026-03-16 (Session 390)

All test file paths in backtick-quoted references across TEST-COVERAGE.md, TEST-COMPONENTS.md, TEST-PAGES.md, TEST-UNIT.md, and TEST-E2E.md use repo-root-relative format: `tests/api/admin/dashboard.test.ts`, not `admin/dashboard.test.ts`.

**Trigger:** Automated diffing of TEST-COVERAGE.md against disk failed because API paths used section-relative format while other categories used full paths. Required an awk normalization script to compare.

**Rationale:** Repo-root-relative paths: (1) work as direct `npx vitest run` arguments, (2) are unambiguous without section context, (3) are grepable across docs, (4) diff cleanly against `find` output.

### Test Doc Family: One Category Per Secondary Doc
**Date:** 2026-03-16 (Session 390)

Each secondary test doc owns exactly one test category. TEST-UNIT.md covers `tests/lib/`, `tests/unit/`, `tests/integration/`, `tests/ssr/` only — not E2E (which has its own dedicated doc at TEST-E2E.md).

**Trigger:** TEST-UNIT.md contained a stale E2E summary ("4 files, 19 tests") that silently drifted while the real E2E suite grew to 25 files/105 tests.

**Rationale:** Duplication across docs causes silent drift. Each doc should be the single source of truth for its category.

### /w-sync-docs Skill for Documentation Drift Detection
**Date:** 2026-03-16 (Session 390)

Created `/w-sync-docs` as a dedicated skill for auditing documentation against the actual codebase. Replaces the generic `/q-sync-docs` command. Includes a 7-point test doc audit (summary counts, phantoms, undocumented files, cross-reference, section headers, path format, blank counts) plus API and CLI audits.

**Trigger:** Session 390 found significant test doc drift: summary said 379 Vitest files but actual was 321, section headers had wrong counts, 1 file missing from listings, paths inconsistent.

**Rationale:** The manual reconciliation workflow done in Session 390 should be repeatable. The skill encodes the exact checks that caught real issues, including the TodoWrite discipline requirement for any unfixed findings.

**See:** `.claude/skills/w-sync-docs/SKILL.md`

### sync-gaps.sh: Two-Level Route Mapping and Fixed-String Matching
**Date:** 2026-03-20 (Conv 022)

`sync-gaps.sh` API route detection upgraded with three fixes that reduced false positive rate from 93% (63 of 67 reported gaps were false) to 0%:

1. **`index.ts` → parent path:** Search for route path (e.g., `admin/analytics`) instead of literal "index"
2. **Fixed-string grep:** `grep -qiF` instead of `grep -qi` to prevent `[id]` being interpreted as a regex character class
3. **Two-level `me/*` mapping:** 15 sub-route entries (e.g., `me/profile|API-USERS.md`, `me/messages|API-MESSAGES.md`) checked before the fallback `me|API-ENROLLMENTS.md`

Also added 12 missing route prefix mappings and dual-notation search (`:id` and `[id]`) to handle the inconsistent param notation across API docs.

**See:** `.claude/scripts/sync-gaps.sh`, `.claude/scripts/route-mapping.txt`

### Public Endpoints → API-PLATFORM.md
**Date:** 2026-03-20 (Conv 022)

Unauthenticated public endpoints are documented in `API-PLATFORM.md`, not in the domain-specific doc where the authenticated version lives. Example: `/api/certificates/[id]/verify` (public, no auth) → API-PLATFORM.md, while `/api/admin/certificates/*` (admin-only) → API-ADMIN.md.

**Rationale:** API-PLATFORM.md already groups public utility endpoints (`/api/faq`, `/api/stories`, `/api/contact`, `/api/health/*`). Mixing public and admin-only endpoints in the same doc creates confusion about auth requirements.

### Deferred Blocks in PLAN.md
**Date:** 2026-02-21 (Session 233)

Work that is planned but not yet needed uses the `Deferred:` prefix in PLAN.md with:
- Context section (current state, what's needed)
- Task checklist
- **Triggers section** — conditions that indicate when to start the work
- **Dependencies section** — what must be in place first

**Example:** `Deferred: SENTRY` — production error tracking, triggered when MVP-GOLIVE begins.

### PLAN.md is Forward-Looking Only
**Date:** 2026-02-22 (Session 248)

PLAN.md contains only work that remains to be done. Completed content lives exclusively in COMPLETED_PLAN.md. No "Completed Blocks" section, no stubs, no links to completed work.

**Trigger:** PLAN.md had grown to 1,260 lines — ~60% completed content. The old convention of keeping completed sub-blocks as one-liners caused steady bloat over 248 sessions.

**Options Considered:**
1. Keep completed sub-blocks as one-liners until entire block completes (status quo)
2. Strip completed sub-blocks, only show remaining work ← Chosen

**Rationale:** A planning document's value is in showing what's next. Mixing completed and pending work makes the file hard to scan and creates maintenance overhead.

**Consequences:**
- Active blocks show a "Completed:" summary line + only remaining sections
- When a block fully completes: terse entry to COMPLETED_PLAN.md, full removal from PLAN.md
- `/w-update-plan` rewritten to match this philosophy (migrated to Skills 2 in Session 366)

**See:** PLAN.md, `.claude/skills/r-update-plan/SKILL.md`

### Block Completion: Terse Archive, Clean Removal
**Date:** 2026-02-22 (Session 248)

When a block fully completes: (1) add terse entry to COMPLETED_PLAN.md (block name + 1-line summary + session range), (2) fold any deferred items into related blocks in PLAN.md, (3) remove entire block from PLAN.md — no stub or link.

**Trigger:** Old workflow described moving "full details" to COMPLETED_PLAN.md. But COMPLETED_PLAN.md was restructured to terse format (Session 247), creating a mismatch with `/w-update-plan` (then `/w-update-plan-local`).

**Rationale:** Session docs in `docs/sessions/` already preserve full detail. COMPLETED_PLAN.md serves as a quick index of what was done and when. PLAN.md stays clean.

### Deferred Items Folded Into Related Blocks
**Date:** 2026-02-22 (Session 248)

~~Supersedes: "Cross-Reference Pre-Launch Deferred Items in Go-Live Checklists" (Session 247)~~

When a block completes with deferred items, fold those items directly into their related blocks in PLAN.md. No separate "Deferred Items" catch-all table.

**Trigger:** The catch-all Deferred Items table had ~18 items from various completed blocks — disconnected from context, some already resolved, some overlapping with existing blocks.

**Rationale:** Items stay discoverable when their related block is worked on. A flat list becomes a dumping ground where items are easy to forget.

### SCRIPTS.md as Unified Scripts Reference
**Date:** 2026-02-21 (Session 236)

Create `docs/reference/SCRIPTS.md` as the single reference for all npm scripts, script files (`scripts/*.{js,ts,sh,mjs}`), and page test scripts (`scripts/page-tests/test-*.sh`). Organized by category with cross-reference tables mapping npm scripts to underlying script files.

**Trigger:** Audit found 13 of 21 script files had zero documentation. 9 standalone scripts (no npm wrapper) were completely undiscoverable.

**Rationale:** npm scripts were documented across 4 CLI-*.md files but the underlying script files were not. A unified document makes the entire scripts ecosystem discoverable — both "what commands can I run?" and "what do these script files do?"

**Consequences:** Added to CLI-QUICKREF.md navigation table. Added Scripts Sync Check to `/q-docs` global skill (conditional: only runs if SCRIPTS.md exists, keeping the skill portable across projects).

**See:** `docs/reference/SCRIPTS.md`, `~/.claude/commands/q-docs.md`

### ROLES.md for Comprehensive Role Reference
**Date:** 2026-02-21 (Session 237), expanded 2026-02-23 (Sessions 261, 263)

Created `docs/reference/ROLES.md` as the comprehensive roles reference — covers how each role is acquired, what it can do (capabilities, accessible pages, API endpoints), and what it can't (restrictions). Renamed from `ROLE-TRANSITIONS.md` in Session 261 when capabilities/restrictions were added. Session 263 added two-tier moderator model (§5) and Content Hierarchy & Authority Map (§7).

**Trigger:** Needed comprehensive documentation of all role transition paths and capabilities — the information was spread across multiple API endpoints, components, and specs with no single source of truth.

**Rationale:** Role information is cross-cutting (auth, payments, admin tools, creator tools, navigation filtering) and doesn't fit cleanly into any single existing doc. Includes authorization matrix, capability quick reference, CurrentUser runtime methods, navigation menu filtering, and per-role page/API access tables.

**See:** `docs/reference/ROLES.md`

### Authority Map in ROLES.md (Not Standalone Doc)
**Date:** 2026-02-23 (Session 263)

The "Content Hierarchy & Authority Map" — showing who has authority at each level of the Community → Progression → Course chain — lives as a section in ROLES.md rather than a standalone file.

**Trigger:** The hierarchy was documented across 4+ files (CD-036 RFC, docs/DECISIONS.md, url-routing doc, DB-SCHEMA.md), none showing role annotations. Needed a "who can do what at each level" unified reference.

**Options Considered:**
1. New section in ROLES.md ← Chosen
2. Annotate docs/requirements/rfc/CD-036 (historical record, not ideal for living reference)
3. New standalone `AUTHORITY-MAP.md` (yet another file to maintain)

**Rationale:** ROLES.md is already the role reference. The authority map complements the per-role sections (§1-6) by showing the same information from the hierarchy's perspective. Avoids a separate file that duplicates role information.

**See:** `docs/reference/ROLES.md` (§ Content Hierarchy & Authority Map)

### POLICIES.md for Platform Behavior Rules
**Date:** 2026-03-01 (Session 319)

Created `POLICIES.md` for prescriptive platform behavior policies — access control rules, business logic, user capabilities. If code contradicts a policy, the code is the bug.

**Trigger:** Creator access control policies (permission vs state gating, revocation behavior) didn't fit into docs/DECISIONS.md (architectural/implementation) or DOC-DECISIONS.md (docs-repo conventions).

**Options Considered:**
1. Add to docs/DECISIONS.md under a new section
2. Create a separate docs/POLICIES.md ← Chosen

**Rationale:** docs/DECISIONS.md records *how* we build (architecture). docs/POLICIES.md defines *what* the platform does (behavior). The distinction matters because policies are the authority when code is inconsistent — exactly the situation that revealed the creator access bugs.

**Three decision documents now:**
- **docs/POLICIES.md** — How the platform *behaves* (access rules, business logic)
- **docs/DECISIONS.md** — How we *build* it (architecture, tech choices)
- **DOC-DECISIONS.md** — How the *docs repo* works (workflow, conventions)

**See:** `docs/POLICIES.md`, `CLAUDE.md` (project structure + research reference)

### Deleted TEST-API.md — Directory Structure is the Test Index
**Date:** 2026-03-04 (Session 325)

Deleted `docs/reference/TEST-API.md`. The file was a manually maintained table of test counts by API area that repeatedly drifted from reality (corrected in sessions 213, 252, 325). It only had category-level counts, not individual file paths, so it didn't help find specific tests.

**Trigger:** Updated counts for Session 325, then questioned why a manually maintained index exists when `tests/api/` already mirrors the API route structure.

**Options Considered:**
1. Keep maintaining manually
2. Auto-generate from filesystem
3. Delete — directory structure is self-documenting ← Chosen

**Rationale:** `tests/api/sessions/index.test.ts` is self-evident. No skills or active docs referenced TEST-API.md. TEST-COVERAGE.md updated to point to the directory directly.

**See:** `docs/reference/TEST-COVERAGE.md`

### Generated Docs Must Have a Single Regeneration Command
**Date:** 2026-03-12 (Session 383)

Any documentation artifact that is derived from code (test inventories, route matrices, page connections) must be regenerable with a single `npm run` command. One-off scripts that produce committed artifacts must be folded into permanent tooling in the same session they're created.

**Trigger:** ROUTE-GRID TSVs were created by a one-off `/tmp/build-route-grid.js` (Session 367). By Session 383 the script was gone and the TSVs were stale. Had to reverse-engineer the output format to consolidate into `route-matrix.mjs`.

**Rule:** If the output gets committed to the repo, the script that creates it must be committed too, with an npm script entry. The test: can someone who's never seen the project regenerate all docs by reading package.json?

**See:** `scripts/route-matrix.mjs`, `npm run route-matrix`, PLAN.md DOC-SYNC-STRATEGY block

### Skill Script References Must Be Drift-Proof
**Date:** 2026-03-17 (Conv 003, corrected Conv 005)

All `!` backtick pre-computed context and `git -C` instructions in skill SKILL.md files must use drift-proof paths — never relative paths, never hardcoded home directories.

**Trigger (Conv 003):** `/r-end` failed because cwd had drifted to `../Peerloop` after `cd ../Peerloop && npm test`. Relative paths broke.

**Trigger (Conv 005):** Hardcoded `/Users/jamesfraser/` paths from MacMiniM4-Pro broke on MacMiniM4 (`/Users/livingroom/`). The two machines do NOT share a home directory structure.

**Current approach:** Use `$CLAUDE_PROJECT_DIR` in prose `git -C` instructions (Claude resolves at runtime) and in script references. However, `$CLAUDE_PROJECT_DIR` does **not** expand in `!` backtick pre-computation — it expands to empty string, causing `/.claude/scripts/...` errors.

**Open issue:** Need a mechanism for `!` backtick commands that resolves the docs repo root without hardcoding. Possible approaches: wrapper script using `git rev-parse`, anchor-file detection, or a fix from Anthropic to pass env vars into `!` backtick execution.

**Rule:** CWD is unreliable in a dual-repo session. Never use relative paths. Never hardcode home directories. Use `$CLAUDE_PROJECT_DIR` for prose instructions; `!` backtick resolution is an open problem.

---

### Inline Doc Updates Per PLAN Sub-Block
**Date:** 2026-03-24 (Conv 024)

Every PLAN sub-block that changes code must include a doc update task specifying the target file (`session-room.md`, `session-booking.md`, `API-ADMIN.md`, etc.). Code and docs ship together — doc updates are not deferred to a cleanup phase at the end of the block.

**Rationale:** Batching doc updates to a cleanup phase risks drift and loss of context. The person writing the code has the best understanding of what changed and why — capturing it immediately is cheaper than reconstructing it later.

### CLAUDE.md Overrides System Prompt's "Simplest First" Bias
**Date:** 2026-03-24 (Conv 025)

Added a "Solution Quality" section to CLAUDE.md that explicitly overrides the system prompt's "avoid over-engineering" and "try the simplest approach first" defaults. Claude must present quick, durable, and middle-ground options and let the user choose. The user decides what constitutes over-engineering.

**Rationale:** The system prompt's default simplicity bias led to repeated quick-fix choices without presenting alternatives (e.g., generic message link instead of inline form, silent error swallowing, auth expansion without abuse-case analysis). Accumulated simple fixes create long-term debt in a production codebase.

### Browser Testing Comparison → Reference Doc
**Date:** 2026-04-07 (Conv 094)

Chrome MCP vs Playwright comparison created as `docs/reference/BROWSER-TESTING.md` (standalone reference doc), not appended to `plato.md` or placed in `as-designed/`. Cross-referenced from `CLI-TESTING.md`.

**Rationale:** It's a tool comparison with practical guidance ("when to use which tool"), which matches the reference doc pattern established by `CLI-TESTING.md` and other reference docs.

### `Doc:` and `Infra:` Structured Commit Tags Cleanly Separated (Option B)
**Date:** 2026-04-10 (Conv 098)

Doc-related commits (both content edits and structural reorganization — moves, renames, splits, consolidation) use `Doc:`. `Infra:` is reserved for tooling, scripts, hooks, skills, build config, and dev workflow. No overlap. r-commit, r-end, and r-timecard-day are all consistent on this boundary after porting the `Doc:` tag from spt-docs and adding a tiebreaker rule in r-end (content/structural doc changes → Doc; tooling that manages docs → Infra).

**Rationale:** A clean split is easier to follow than a fuzzy boundary. r-end commits are docs-only and become the primary source of `Doc:` lines. Daily timecards now aggregate doc work into a dedicated `#### Doc Changes` section instead of mixing it into Infra.

### "Doc Reorganization" Added as Important Decision Criterion
**Date:** 2026-04-10 (Conv 098)

Added a 6th row to the "Important Decision Criteria" table in `.claude/skills/r-end/refs/fmt-learn-decide.md`: "Doc reorganization | New doc categories, naming conventions, cross-reference patterns, per-section docs, doc consolidation". Ported verbatim from spt-docs.

**Rationale:** Peerloop does substantial doc reorganization work that doesn't fit the existing criteria (architecture, code style, technology selection, breaking change, thwarted-by-conditions) but is durable and worth recording in DOC-DECISIONS.md. Gives the learn-decide agent explicit grounds to promote such decisions. Closely related to the Doc/Infra separation decision above.

### Dated Rationale-Refresh Format for Decision Updates
**Date:** 2026-04-11 (Conv 106)

When a decision's rationale references facts that have changed (e.g., a package version bump, a renamed API), update the decision entry in-place using this format:

1. **Preserve the original `Date:` line** — it records when the decision was made
2. **Append a dated update block** below the Rationale paragraph:

```
**{YYYY-MM-DD} update:** {What changed and why the decision still holds (or has been revised).}
```

Do **not** change the original Rationale text. The update block provides temporal context — readers can see the decision was made at time T and re-validated at time T+N.

**Trigger:** Conv 106 docs sweep found 3 references to "Astro 5.x" in the Stay-on-Node-22 decision context (DECISIONS.md, devcomputers.md, cloudflare.md). The codebase had moved to Astro 6 in Conv 101, but the decision rationale still cited the old version. Needed a convention that updates context without rewriting history.

**Options Considered:**
1. Edit the original Rationale in-place — loses the temporal record of what was believed when the decision was made
2. Add a separate "Decision Updates" log — disconnects updates from decisions
3. Append a dated update block below the original Rationale ← Chosen

**Rationale:** Decisions are historical artifacts — the original reasoning matters even when the facts change. The update block pattern preserves both the original context and the current state. It's lightweight (one line) and self-documenting (the date makes staleness visible).

**See:** `docs/DECISIONS.md` (Stay on Node 22 entry) for a live example.

### `docNameWhitelist` as Explicit Config — Not Auto-Detection of ALL-CAPS Patterns
**Date:** 2026-04-18 (Conv 126)

Commit bullets reference docs by their stem without `.md` extension (e.g., "updated API-ENROLLMENTS"). The `extractDocs()` function in `timecard-day.js` uses an explicit `docNameWhitelist` config field (22 stems) guarded by `validDocs.has(stem + '.md')` — not auto-detection of any ALL-CAPS token.

**Options Considered:**
1. Auto-detect any ALL-CAPS hyphenated token as a potential doc name
2. Explicit whitelist in `config.json → rTimecardDay` ← Chosen
3. Require `.md` extension in commit message conventions

**Rationale:** Auto-detection would false-positive on non-doc ALL-CAPS tokens (acronyms, constants, error codes). Explicit whitelist is maintainable — the doc set is stable and lives next to other routing config. Guarding by `validDocs` prevents the whitelist from running ahead of the actual doc inventory.

**Consequence:** When a new reference doc is added, its stem must be added to `docNameWhitelist` in `config.json` to be recognized in commits that omit `.md`.

**See:** `.claude/config.json → rTimecardDay.docNameWhitelist`, `.claude/scripts/timecard-day.js`

### T3b API Detection Scoped to workEffort Only, Guarded by !isTestRelated
**Date:** 2026-04-18 (Conv 126)

In `classifyItem()`, the T3b API-detection tier (matching `apiMethodRe` and `apiPathRe`) applies only when `item.src === 'workEffort' && !isTestRelated()`. Without this guard, test paths like `tests/api/me/enrollments.test.ts` containing "/api/" were routing to API Changes.

**Options Considered:**
1. Apply API detection to all item sources
2. Apply only to workEffort items, guarded by `!isTestRelated` ← Chosen
3. Use a more specific regex excluding test file paths

**Rationale:** Test items must flow through T4 isTestRelated or structural T3 test-path signals. Scoping T3b to workEffort prevents test bullets from being intercepted mid-tier. The `!isTestRelated` guard adds a second layer for workEffort bullets that mention test-related words.

**General Rule:** Any heuristic that matches on path substrings must be guarded by `!isTestRelated()` when applied to workEffort items — test paths frequently overlap non-test patterns (api/, src/, etc.).

**See:** `.claude/scripts/timecard-day.js → classifyItem() T3b`

### `docNameWhitelist`: Explicit Stem List for Doc-Mention Detection
**Date:** 2026-04-18 (Conv 126)

Commit bullets reference project docs by ALL-CAPS stems without `.md` extension (e.g., "updated API-ENROLLMENTS"). The `timecard-day.js` `extractDocs()` function uses an explicit `docNameWhitelist` in `config.json → rTimecardDay` to detect these references, guarded by `validDocs.has(stem + '.md')` to prevent false positives.

**Rationale:** Auto-detecting any ALL-CAPS hyphenated token would match non-doc tokens (acronyms, constants, error codes). The doc set is stable, so an explicit whitelist maintained alongside the other routing config is clean and maintainable. When a new reference doc is added, its stem must also be added to the whitelist.

### T3b API Detection: workEffort-Only with !isTestRelated Guard
**Date:** 2026-04-18 (Conv 126)

In `timecard-day.js classifyItem()`, T3b API path/method detection (`apiMethodRe`, `apiPathRe`) applies only when `item.src === 'workEffort' && !isTestRelated({ text }, rt)`. This prevents test file paths (e.g., `tests/api/me/enrollments.test.ts`) from being routed to API Changes.

**Rationale:** Any path-substring heuristic in workEffort classification must carry the `!isTestRelated` guard — test paths frequently share prefixes with production paths (api/, src/, etc.). Scoping T3b to workEffort items also ensures test bullets flow through the dedicated T4 isTestRelated tier rather than being intercepted mid-tier. This guard pattern is now canonical for any new path-substring detection tier added to `classifyItem()`.

### Decision Records vs Reference Docs Must Be Structurally Separate
**Date:** 2026-04-18 (Conv 131)

A given doc should be **either** a decision record (frozen-ish history of *why* a choice was made) **or** a living reference (*how* to use the chosen thing). Mixing both in one file guarantees the how rots while the why survives, producing drift and misleading composite docs. When converting an existing mixed doc into a pure decision record, strip code examples and replace with pointers to implementation files (`src/lib/**`, endpoint files). When writing a new reference doc, minimize prose — cite source-file paths, use generators where possible.

**Trigger:** TDS-AUTH audit of `auth-libraries.md` found 8 critical/major drift items (wrong OAuth cookie names, fictional `oauth_accounts`/`sessions` tables, nonexistent middleware path, wrong SALT_ROUNDS and JWT audience) despite a Conv 107 "code examples are generic" disclaimer. All 4 Conv 131 audits (TDS-AUTH, DSA, DEVCOMP-REVIEW, PFC) surfaced the same failure mode.

**Options Considered:**
1. Patch specific factual errors in place — leaves the mixed structure, drift returns
2. Strip code examples entirely, keep decision rationale ← Chosen
3. Delete the doc entirely — loses valuable comparison context (Clerk/Supabase/Auth0)

**Rationale:** Per CLAUDE.md §Solution Quality "Default to durable" — patches preserve the doc's structural drift-proneness; rewriting narrows the doc's job to something stable. Decision records cite immutable prior-art rationale; reference docs point to current code. One job per doc.

**Consequences:** `auth-libraries.md` 505 → 151 lines (decision-record form). `route-api-map.generated.ts` → `route-api-map.md` is the inverse model (pure reference, auto-regenerated). This decision is the general rule; future mixed docs should be reshaped into one mode or the other.

**See:** `docs/reference/auth-libraries.md` (Conv 131 decision-record rewrite)

### "Active vs Proposed" Endpoint Subsection Pattern for DB-API.md
**Date:** 2026-04-18 (Conv 131)

DB-API.md sections that document both implemented and aspirational endpoints MUST use a two-subsection layout: the main body lists only implemented endpoints; a trailing `### Proposed (Block N+ — not yet implemented)` subsection lists aspirational ones. Do NOT interleave proposed endpoints inline with active ones marked `*(proposed — not implemented)*`.

**Trigger:** DSA audit of §Communities — the pre-audit doc interleaved proposed endpoints inline with real ones. Readers typically scan for "what exists now" and the interleaved layout forced them to re-read the `*(proposed)*` tag on every entry to filter.

**Rationale:** "What's live" is the default reader query; it must be the default view. Separating aspirational endpoints into a trailing subsection makes the filter implicit (header boundary) rather than explicit (per-entry tag). The boundary also resists drift — an endpoint moving from proposed to active is a single location change, not a tag edit hidden mid-list.

**Consequences:** §Communities now renders as 15 active endpoints followed by 3 proposed (`/feed`, `/posts`, `/invite`) in a clearly-bounded subsection. Pattern applies to all DB-API.md sections carrying aspirational entries.

**See:** `docs/reference/DB-API.md → §Communities` (Conv 131 audit)

### Shared Skill Scripts Consolidated to `.claude/scripts/`
**Date:** 2026-04-19 (Conv 133)

Scripts shared between sibling skills (notably `/r-end` and `/r-end2`) live in `.claude/scripts/`, not duplicated inside each skill's `scripts/` folder. Phase 2 of DOC-SYNC-STRATEGY moved `sync-gaps.sh`, `tech-doc-sweep.sh`, `route-mapping.txt`, plus a new `docs-registry.mjs` JSON reader, into this shared location. Both skills' SKILL.md + fmt-docs.md reference the canonical paths.

**Trigger:** `r-end/scripts/` and `r-end2/scripts/` each had identical copies of `sync-gaps.sh` + `tech-doc-sweep.sh` + `route-mapping.txt`. `r-end2/SKILL.md` actually referenced the `r-end/scripts/` paths, making the `r-end2/scripts/` copies silent orphans — nobody called them, and nothing enforced that the copies stayed in sync.

**Options Considered:**
1. **Quick:** Update both `r-end/scripts/` and `r-end2/scripts/` copies in place. No structural churn; latent drift risk remains.
2. **Middle:** Keep `.sh` scripts per-skill, hoist only the new `docs-registry.mjs` helper. Partial DRY.
3. **Durable:** Consolidate all 4 files under `.claude/scripts/`. Update both skills to reference the new paths. ← Chosen

**Rationale:** The duplication was silent drift waiting to happen. Consolidating during a migration is cheaper than consolidating later — the callers were already being touched. `.claude/scripts/` already existed with 10 helper scripts (`timecard-day.js`, `conv-*.sh`), so the new location was a natural fit rather than a novel convention.

**Consequences:** 6 files deleted from `r-end/scripts/` + `r-end2/scripts/`; 5 caller files updated (`r-end/SKILL.md`, `r-end/refs/fmt-docs.md`, `r-end2/SKILL.md`, `r-end2/refs/fmt-docs.md`, `w-sync-docs/SKILL.md`); 4 stale `DOC-DECISIONS.md` refs corrected; 2 live paths (`.claude/config.json` `routeMapping` + strategy doc) fixed. `detect-changes.sh` + `dev-env-scan.sh` are still duplicated — out of Phase 2 scope, flagged for future cleanup.

**See:** `.claude/scripts/`, `docs/as-designed/doc-sync-strategy.md`

### JSON Reader for bash Scripts: `docs-registry.mjs` Pattern
**Date:** 2026-04-19 (Conv 133)

When a bash script in `.claude/scripts/` needs to consume a config.json section, use a Node ESM helper (e.g., `docs-registry.mjs`) invoked via `node`-prefixed subshells with TSV output that bash consumes via `IFS=$'\t' read`. Zero npm deps; Node builtins only. Future bash scripts needing structured config should follow this pattern rather than duplicating `node -e "..."` inline snippets.

**Trigger:** Phase 2 of DOC-SYNC-STRATEGY required migrating `tech-doc-sweep.sh` and `sync-gaps.sh` from hardcoded bash arrays / `case` branches to the shared `docsRegistry` JSON section. Reading JSON inline from bash is error-prone; a dedicated helper centralizes the parsing.

**Rationale:** (a) Keeps bash scripts readable — no inline `node -e` soup; (b) centralizes JSON-to-TSV conversion in one testable file; (c) TSV output is unambiguous and survives pipe/IFS mangling that delimiter-ambiguous formats don't.

**Consequences:** `.claude/scripts/docs-registry.mjs` now exposes 4 CLI commands: `vendor-rules` (TSV `codePattern\ttopicKeywords`), `test-shared-basenames`, `get-group <id>`, `list-groups`. `tech-doc-sweep.sh` and `sync-gaps.sh` both consume it. This pattern is canonical for any `.claude/scripts/*.sh` that needs config.json data.

**See:** `.claude/scripts/docs-registry.mjs`, `.claude/scripts/tech-doc-sweep.sh`, `.claude/scripts/sync-gaps.sh`

### Bug Fix: `tech-doc-sweep.sh codePattern` Truncation (Silent Under-Enforcement Since Introduction)
**Date:** 2026-04-19 (Conv 133)

The original `tech-doc-sweep.sh` used bash `${rule%%|*}` to split pipe-delimited rules. Bash parameter expansion uses GLOB, not regex — `\|` is two literal characters, so `${rule%%|*}` truncated every rule at the FIRST `|` regardless of backslash escapes. Every multi-alternation `codePattern` (e.g., `webhook.*bbb\|video\|bigblue\|plugnmeet`) had 3/4 of its alternations silently stripped. Only the `auth|auth` rule (no extra `|`) worked as intended — which is why the "auth-doc false positives" entry above was the only observed signal from this rule family for ~60 convs.

Phase 2 migration reads the full `codePattern` from `docsRegistry` via `docs-registry.mjs vendor-rules`, restoring the intended full-alternation matching. First post-migration run on HEAD~5 surfaced 9 previously-suppressed flags.

**Trigger:** Empirical test `rule='webhook.*bbb\|video\|bigblue\|plugnmeet|bigbluebutton bbb video plugnmeet'; echo "${rule%%|*}"` returned `webhook.*bbb\` — immediately confirming the latent bug.

**Options Considered:**
1. Emit the truncated pattern from `docs-registry.mjs` to reproduce the bug byte-for-byte.
2. Emit the full `codePattern` and accept that flag volume will jump on first post-migration run. ← Chosen
3. Emit truncated + file a follow-up task to fix the bug later.

**Rationale:** The JSON in `docsRegistry` was authored with full-alternation intent from Phase 1 (Conv 132). Preserving the bug means preserving a reader-runtime mismatch — the JSON would be actively misleading about what the tool checks. The strategy doc §4 "no behavioral change" contract yields to this: the runtime is realigning to the documented spec, not changing behavior. The one-time 9-flag bump is an auditable event, not a silent regression.

**Consequences:** 9 flags surfaced on first post-migration HEAD~5 run. Triage: 2 REAL_DRIFT (fixed this conv — `resend.md` + 3 SessionInvite templates, `availability-calendar.md` 28-day window), 2 PARTIAL (generic wording already covered), 5 FALSE_POSITIVE (vendor/area keyword-match noise). The 5 false positives are candidates for a future "known-noise" DOC-DECISIONS entry analogous to the existing Auth-Doc entry above.

**See:** `.claude/scripts/tech-doc-sweep.sh` (Phase 2 migration), `docs/as-designed/doc-sync-strategy.md`

### TodoWrite `[XX]` Mnemonic Codes: Feedback Memory + Skill Patches (Not CLAUDE.md)
**Date:** 2026-04-19 (Conv 135)

TodoWrite subjects are prefixed with a 2-3 letter uppercase mnemonic code in brackets (e.g., `[DT]`, `[RS]`, `[DW]`), unique within the current task list, with collision-number fallback. Codes are assigned at TaskCreate time and carried across conv boundaries via `/r-start` RESUME-STATE → TodoWrite transfer (with code derivation for any code-less items). Users can reference tasks by shortcode.

**Trigger:** User asserted a pre-existing directive should require this. Project-wide search (project CLAUDE.md, global CLAUDE.md, 25 memory files) found no such directive. User supplied the proper text; decision needed on where to store it.

**Options Considered:**
1. Save as a feedback memory only ← Chosen
2. Feedback memory + summary line in project CLAUDE.md
3. Full convention doc in `docs/as-designed/`

**Rationale:** Feedback memories are the established home for "how Claude should behave" rules. CLAUDE.md is for codebase facts, `docs/as-designed/` for architecture. The convention belongs with the rest of the behavioral feedback corpus. Critically, skill-level patches (not memory alone) are required so the convention survives conv boundaries — `/r-start` assigns codes on transfer, `/r-end` + `/r-end2` preserve them on RESUME-STATE write.

**Consequences:** All new TaskCreate calls prefix `[XX] `. Code stability across conv boundaries depends on `[RE]`'s preservation holding up in practice — first real test is Conv 136 `/r-start`. Longer hyphenated PLAN.md codes (e.g., `[BKC-NEXT]`, `[RA-SSR]`) remain a separate convention.

**See:** `memory/feedback_todowrite_mnemonic_codes.md`, `.claude/skills/r-start/SKILL.md` Step 7, `.claude/skills/r-end/SKILL.md` + `/r-end2/SKILL.md` `## Remaining` templates.

### 👉👉👉 Pointing-Emoji Prefix Directive Migrated from CLAUDE-SAVED.md
**Date:** 2026-04-19 (Conv 135)

Audit of `~/.claude/CLAUDE-SAVED.md` revealed that of its 4 legacy directives, three had been transferred to project memory but the "Precede questions with 👉👉👉" directive had not. The existing sibling rule `feedback_pause_on_pointing_questions.md` (pause-after-pointing behavior) assumed the convention existed without anchoring it.

**Options Considered:**
1. Leave as-is, rely on system-prompt baseline knowledge — fragile
2. Add to project CLAUDE.md — mixes behavior rules with codebase facts
3. Create `feedback_pointing_emoji_prefix.md` as parent rule to the pause memory ← Chosen

**Rationale:** Consistent with how the other 3 CLAUDE-SAVED directives were migrated. The prefix + pause pair now forms a complete behavior spec; neither rule is meaningful without the other.

**See:** `memory/feedback_pointing_emoji_prefix.md`, `memory/feedback_pause_on_pointing_questions.md`

### DOC-SYNC-STRATEGY Classified as "Working Scaffold, Not Load-Bearing" — Phase 4 Precision & Coverage Promoted
**Date:** 2026-04-19 (Conv 135)

First real SessionStart drift run (Conv 135 `/r-start`) produced 9 flags — 1 real gap, 8 false positives (11% precision). Block classified across 4 axes: stable (registry + test-drift-detection + silent-hook + DOC-DECISIONS triage), brittle (HEAD~5 hard horizon, grep-based matcher, CC-only-entry assumption), unfinished (Phase 3 Follow-up #3, CI deferred), not battle-tested (1 real run, prose dismissals don't scale). The system needs a prose dismissal table to be usable — which itself becomes doc rot.

**Options Considered:**
1. Accept scaffold state, keep Phase 3 Follow-ups passive (wait-and-see)
2. Promote CI drift-check (Option A) from deferred to active — partial
3. Full precision-and-coverage push: matchers + CI + stored baseline ← Chosen

**Decision:** Add PLAN.md Phase 4 — Precision & Coverage with three active tasks: `[DT]` tighten 4 chronic-noise matchers, `[DC]` implement CI drift-check, `[DW]` extend HEAD~5 window to last-full-sync state. Exit criteria: FP <20% on 3 batches, CI gating main merges, baseline-SHA advancement proven across 3+ drift-clear events.

**Rationale:** Scaffold-vs-load-bearing is about trust. "Reminder, not gate" role requires trustworthy output; prose dismissals don't scale. Phase 4 is ~1-2 convs to convert the block from "useful output requires curation" to "trust the output." Passive validation (`[DV]`) only produces signal after `[DT]` tames FP rate — validating a 89%-FP system would be wasted cycles.

**Consequences:** Block status updated (Phase 4 planned). Phase 3 Follow-up CI bullet promoted (`[x]` → see Phase 4). Three TodoWrite items (`[DT]`, `[DC]`, `[DW]`) carry work across conv boundaries with explicit exit criteria.

**See:** `PLAN.md` DOC-SYNC-STRATEGY Phase 4 subsection, `docs/as-designed/doc-sync-strategy.md`

### v2 Skill Consolidation: Contents-In-Place Promotion, v1 Parallels Deleted
**Date:** 2026-04-19 (Conv 136)

After 9 consecutive convs (127–135) of clean v2 output with zero regressions, all three v2 skill pairs were promoted by overwriting the v1 `SKILL.md` in-place and deleting the v2 directories. Affected skills: r-commit2 → r-commit, r-end2 → r-end, r-timecard-day2 → r-timecard-day.

**Rationale:** In-place overwrite preserves directory names, supporting files (`scripts/`, `refs/`), and all cross-references in CLAUDE.md and other skills — no rename sweep needed. Parallel versioning was the right validation approach; once proven stable, maintaining both is pure overhead.

**Consequences:** /r-commit, /r-end, /r-timecard-day now emit v2 format exclusively. CLAUDE.md skills table simplified (3 rows removed). CC autocomplete clears after restart. The promotion path (overwrite SKILL.md in-place, delete v2 dir) is now the established pattern for future v2-style staged rollouts.

**See:** Conv 136 Decisions.md

### Preserve Audit-Trail Observations When Marking Fixes Closed
**Date:** 2026-04-22 (Conv 146)

When a prior conv recorded a discovery observation (typically with 🔴 framing) and a later conv closes the underlying issue, do not rewrite the historical observation. Flip the closure marker only in forward-looking "gaps — revised" sections. The original 🔴 dated observation stays intact.

**Rationale:** The discovery record explains *why* a fix was prioritized. Erasing the 🔴 framing leaves future readers wondering "was this ever a real concern?" Observations are audit-trail artifacts (frozen history); closure trackers are current-state views. Two-phase lifecycle per fix: 🔴 at Conv N (discovery) → ✅ at Conv N+1 (closure).

**See:** `docs/as-designed/webhook-miss-resilience.md` applied this pattern for Conv 144 [VD]/[VW]/[VA] observations closed by Conv 145.

### Avoid Catch-All "Other"/"Misc" Sections in Reference Docs
**Date:** 2026-04-22 (Conv 146)

Reference docs with a clear per-unit structural pattern (e.g., one H3 per subdir in TEST-COVERAGE.md) should not maintain "Other X" catch-all sections. When a catch-all grows beyond ~3-5 items, split into proper sub-units matching the doc's pattern.

**Trigger:** TEST-COVERAGE.md's `### Other API — tests/api/ top-level (23 files)` section masked 15 files belonging to 10 subdirs (certificates, debug, recommendations, resources, reviews, stories, stream, stripe, submissions, topics) plus 8 true root files. A duplicate `topics/index.test.ts` row went undetected in the flat table for ≥1 year.

**Options Considered:**
1. Rename heading only — cheap, ~2 min
2. Full restructure — split into per-subdir H3s matching doc's pattern ← Chosen
3. Hybrid — split multi-file subdirs only

**Rationale:** Catch-all sections invite low-visibility drift — the heading's imprecision legitimizes imprecise contents. Per CLAUDE.md "default to durable," structural uniformity is cheaper over the long run. Each item becomes grep/anchor-navigable; counts stay honest per-subdir (not just in aggregate); future adds have an obvious home.

**Consequences:** TEST-COVERAGE.md's API section now has 10 new H3 sections (Certificates through Topics) + 1 renamed (Other API → Top-Level for 8 true root files). Duplicate `topics/index.test.ts` row eliminated automatically. Future drift contained to individual H3s, not hidden.

### Asymmetric Cross-Linking: Lessons → Spec, Not the Reverse
**Date:** 2026-04-22 (Conv 146)

For split-by-audience pairs (spec doc vs lessons/gotchas doc) covering the same topic, cross-link from lessons → spec only. Skip the reverse. The split exists because the two docs serve different audiences at different times: spec is "how do I configure this now," lessons is "what bit us during the last upgrade."

**Trigger:** ESLint v10 unknown-rule gotcha — spec portion in `DEVELOPMENT-GUIDE.md §ESLint Configuration` (authored Conv 143); lessons portion added to `PLAN.md PACKAGE-UPDATES notes` (Conv 146). Considered bidirectional cross-link; chose lessons → spec only.

**Rationale:** Spec doc reader is usually configuring fresh (low probability of needing historical gotcha context). Lessons reader is usually debugging / planning an upgrade (high probability of wanting the config spec). Asymmetric cross-linking matches asymmetric demand. Each doc stays maintainable in isolation — the spec can be rewritten across successive tool versions without stale back-references to old upgrade lessons.

**Consequences:** Applied to ESLint v10 entry. Template for future post-upgrade gotcha subsections: lessons entry links to spec; spec stays unchanged. Minor cost: a future upgrade reader starting in the spec doc won't surface the lessons entry without grep.

### Drift-Fix vs Restructure: Classify Before Queuing
**Date:** 2026-04-22 (Conv 147)

Drift-audit findings fall into two classes with different review surfaces and risk profiles. Queue them as separate work units when both exist in the same doc.

- **Drift-fix (values only):** count mismatches, phantom entries, undocumented files, blank counts, path-format fixes. No heading/anchor churn. Safe to batch under one task.
- **Restructure (heading + structure):** catch-all section splits, section renames for clarity, pattern enforcement across siblings (e.g., one H3 per subdir). Changes anchors; other docs' cross-references may go stale; review effort per item is larger.

**Trigger:** Conv 140 queued a 14-item "cosmetic drift" list for `TEST-COVERAGE.md`. Conv 146 executed it, then mid-conv the user sanctioned a further "Other API" restructure (10 new H3s). Both phases landed under one `[TC]` task — scope was accurate only after the fact. §Uncategorized in the Conv 146 Extract captured the lesson: the "cosmetic" label undersold the restructure's durability and review effort.

**How to apply:** When assembling a drift-audit queue (manual or via `/w-sync-docs`), classify each finding before writing it into `PLAN.md` or `RESUME-STATE.md`. Use distinct task subjects — e.g., `[TC] drift-fix` vs `[TC] restructure` — so scope and execution order are explicit. Cross-link restructure tasks to the driving decision record.

**Consequences:** `/w-sync-docs` SKILL.md extended with a "Classify Findings for Queuing" subsection (Conv 147) between Report Format and Fix Mode. Future drift-audit queues should declare class in the subject line rather than batching silently.

**Related:** §"Avoid Catch-All 'Other'/'Misc' Sections in Reference Docs" (Conv 146) — the pattern that drove the example restructure. §"Preserve Audit-Trail Observations When Marking Fixes Closed" (Conv 146) — sibling workflow discipline from the same session.

### /w-sync-skills Divergence Gate — Two-Signal OR (Jaccard + line-diff ratio)
**Date:** 2026-04-22 (Conv 147)

When scanning a cross-project skill via `/w-sync-skills`, classify as DIVERGED (skip per-finding port enumeration, recommend "evolve independently") when **either** structural or content signal fires:

- **Signal A — Structural:** Jaccard similarity on H2/H3 header sets < 0.70
- **Signal B — Content:** post-normalization `diff_ratio = diff_lines / min(src, local)` > 0.30

Either signal fires → DIVERGED. Per-finding enumeration runs only when both signals stay below threshold.

**Trigger:** Conv 140's `r-end` port attempt produced a long per-finding port plan when the right answer was "evolve independently" (captured in `feedback_skill_sync_same_name_divergence.md`). Conv 147 [SY] work added the detection gate.

**Rationale:** An initial single-signal heuristic (Jaccard < 0.70 alone) was tested against the canonical Conv 140 DIVERGED case (`r-end`) before committing — result: Jaccard 1.00. The canonical DIVERGED case would have shipped as "In sync / Updated." Calibration across all 13 peerloop-docs ↔ spt-docs exact-match skills showed Jaccard and line-diff are orthogonal: `r-end` (Jaccard 1.00, diff 30%) catches on content; `w-sync-docs` (Jaccard 0.30, diff 116%) catches on structure. Single-signal designs each miss one class. Thresholds chosen from empirical data — the memory's "~30%" language maps to Jaccard < 0.70 and diff_ratio > 0.30.

**Consequences:** `/w-sync-skills` Step 3 now short-circuits on DIVERGED with a structured presentation (Source/Local section counts, Jaccard value, line counts, diff_ratio, triggered-signal label). Calibration data embedded in the skill so future readers understand threshold grounding. Rules entry cites the memory.

**Related:** `memory/feedback_skill_sync_same_name_divergence.md` (Conv 140 origin).

### CLAUDE.md Restructure: Behavioral Rules vs Navigation/Archaeology
**Date:** 2026-05-06 (Conv 150)

CLAUDE.md is for behavioral rules and essential project context — not for navigation indexes or historical archaeology. When the file accumulates either, the navigation moves to `docs/INDEX.md` and the archaeology moves to `TIMELINE.md` (or, for run-scope content, the relevant `docs/as-designed/` doc).

**Trigger:** Conv 150 audit found CLAUDE.md had grown to 677 lines / 22 H2 sections. ~40% of the file was three sections (§Database Migrations 123 lines, §Research Reference 95 lines, §Project Structure 50 lines), most of which was navigation tables, dead recovery procedures, and Session-numbered archaeology — not behavioral rules. Two CLAUDE.md ↔ memory duplications were also live (Issue Surfacing in CLAUDE.md vs `feedback_visual_issue_alerts.md`; baseline rules — already resolved earlier in the same conv). One direct contradiction was active: §Schema Mismatch's `1/2/3` numbered-prose options format violated the just-strengthened `feedback_option_phrasing.md` rule.

**Rationale:** CLAUDE.md is loaded into every conversation's context — every line costs and competes for attention. Navigation indexes belong in a discoverable docs-tree file (`docs/INDEX.md`) where they don't fight for ranking against rules. Historical Session archaeology belongs in `TIMELINE.md` where dated-inflection-point context already lives. Project arc tables belong with the run scope (`docs/as-designed/run-001/SCOPE.md`). The "size of the change is not the criterion" rule (CLAUDE.md §Critical Rule, added Conv 150) explicitly endorses substantial restructures when they follow established patterns — and these moves all follow the existing docs/ organization.

**What moved out:**
- §Research Reference (95 lines) → `docs/INDEX.md` (NEW)
- §Documentation Reference (31 lines) → folded into `docs/INDEX.md`
- §Project Structure full directory tree (50 lines) → `docs/INDEX.md` § "Repo Layout" (a short top-level summary remains in CLAUDE.md)
- TERMINOLOGY 346-356 archaeology block → `TIMELINE.md` § "TERMINOLOGY Rename Boundary"
- §Block Sequence (15 lines) → `docs/as-designed/run-001/SCOPE.md` § "Block Arc"
- §Schema Mismatch During Testing — relocated within CLAUDE.md from inside §Database Migrations to a new top-level §Schema Discrepancy Discipline section, with the options format rewritten A/B/C per `feedback_option_phrasing.md`

**What got deleted (dead content):**
- D1 Reset orphaned-indexes manual recovery procedure (22 lines) — section header itself said "now handled automatically" and "no longer expected to occur"
- Page specs DELETED tombstone bullets (Sessions 307+311)
- PAGES-MAP.md → orig-pages-map.md rename note (predates Conv numbering)

**What got consolidated:**
- §Issue Surfacing (Visual Alerts) is now the canonical home for the 🔴/🟠 rule; `feedback_visual_issue_alerts.md` shrank to a stub pointer (mirrors the Conv 150 baseline-rules consolidation)

**Consequences:** CLAUDE.md drops from 677 to ~300-350 lines. External references checked and updated: `.claude/config.json` `docsRegistry` entry note that pointed at "CLAUDE.md §Research Reference" updated to point at `docs/INDEX.md` instead; `Peerloop/scripts/reset-d1.js:240-242` comment that pointed at a no-longer-existing "§Known issue" section was cleaned up. Pre-existing reference from `/r-start/SKILL.md:123` to `§Skills: Preserve \`!\` Backtick Determinism` was preserved by keeping that section name verbatim. Five memory files cross-referencing CLAUDE.md sections (`feedback_default_durable_no_ask`, `feedback_verify_baselines_in_conv`, `feedback_baseline_includes_astro_check`, `feedback_visual_issue_alerts`, `feedback_no_paste_tokens_in_chat`) verified to still resolve.

**How to apply going forward:**
- Behavioral rules (what Claude must do/not do) → CLAUDE.md
- Navigation indexes ("where do I find X?") → `docs/INDEX.md`
- Dated inflection-point context → `TIMELINE.md`
- Run-scope context → `docs/as-designed/run-XXX/`
- Archaeology that's no longer load-bearing → either git history or a date-stamped subsection of `TIMELINE.md` (only if future readers will need to resurrect it)
- When a CLAUDE.md section grows past ~30 lines, consider whether some of it is navigation or archaeology that wants a different home.

**Related:** §"CLAUDE.md as Symlink" (Session 229) — original decision establishing CLAUDE.md as the docs-repo CC home. This restructure refines that by saying *what kind of content* belongs there.

### Cross-Machine Memory Sync: Content vs Transport Layer Split
**Date:** 2026-05-06 (Conv 152)

Cross-machine sync of CC memory files has two independent concerns. **Transport** is which machine has which bytes (manual rsync / iCloud / git symlink / separate repo all solve this). **Content** is whether the bytes are correct on the destination machine, independent of how they got there. ALL transport mechanisms propagate bytes verbatim — none rewrite hardcoded usernames or paths. Content portability must be solved separately, and is a *prerequisite* for any durable transport choice.

**Trigger:** Conv 152 manual `[CMS]` sync via Desktop tarball delivered M4Pro's content to M4. M4Pro snapshot included a *new* `§Dual-Repo Shell Discipline` section in MEMORY.md that referenced `/Users/jamesfraser/...` paths. After sync, M4 had M4Pro-correct paths in 2 files; the inverse `/Users/livingroom/...` was M4-correct in a third file. The inconsistency would oscillate — flipping which machine is wrong on every sync — without solving content portability first.

**Rationale:** Manual rsync, iCloud symlinks, git-symlinked memory dirs, and standalone memory repos all share the same byte-level transport model. None of them rewrite per-user paths. Designing a durable transport without first making the bytes themselves portable just dresses up the same content bug in a new container. The portability fix (placeholders like `~`, `<user>`, or `$CLAUDE_PROJECT_DIR`) is independent of and orthogonal to transport choice — and must land first.

**Decision:** Path placeholders precede transport architecture. `[CMS]` durable solution remains pending; `[MPP]` (path-portability rewrite) is the prerequisite. Memory files use `~/projects/...` for shell-friendly paths and `<user>` for the username segment of paths Claude can't shell-expand (e.g., `~/.claude/projects/-Users-<user>-projects-peerloop-docs/memory/`). Manual sync via Desktop tarballs continues as interim transport.

**Consequences:** [MPP] landed Conv 152 (3 files edited: MEMORY.md, feedback_git_dash_c_enforcement.md, feedback_check_memory_before_directive_save.md). [MPS] task created so M4Pro converges with M4 byte-for-byte. Future durable [CMS] design has explicit constraint recorded: *any* sync mechanism must propagate bytes verbatim, so content layer must be solved independent of transport. Same principle applies to any future cross-machine artifact sync (secret rotation, build-artifact transfer).

**See:** Conv 152 Decisions.md §1, §2; Conv 152 Learnings.md §1, §2.

### Memory-File Path Placeholder Convention
**Date:** 2026-05-06 (Conv 152)

Memory files reference paths using portability-safe forms, not hardcoded usernames or absolute machine paths.

**Convention:**
- **Shell-expandable paths** → `~/projects/peerloop-docs`, `~/projects/Peerloop` (tilde reads as a literal path; copy-pastes correctly into any shell on either dev machine)
- **Paths Claude encodes (not shell-expandable)** → use `<user>` segment marker: `~/.claude/projects/-Users-<user>-projects-peerloop-docs/memory/` (Claude encodes absolute project paths replacing `/` with `-`, so the username appears explicitly even after `~` expansion would otherwise hide it)
- **Historical narrative references** → leave hardcoded paths as-is (rewriting erases evidentiary detail; e.g., Conv 150 incident description in `feedback_watch_task_assumptions.md`)

**Trigger:** Conv 152 [MPP] discovered 4 memory files with hardcoded `/Users/jamesfraser/...` (M4Pro-only) or `/Users/livingroom/...` (M4-only) paths produced wrong content on the other machine post-sync.

**Rationale:** Tilde syntax is literal and copy-pastable; survives a future username change for free (Apple ID rename, account migration). `$CLAUDE_PROJECT_DIR` was considered (style B) but rejected — equally portable but less readable in narrative text. The `<user>` placeholder makes the per-user path component visible to readers without committing to one machine's value, and explains *why* the username appears explicitly (Claude's directory encoding scheme).

**Consequences:** Pattern applies to any future memory-file path references. Both dev machines hold byte-identical correct content (after [MPS] runs). Both machines have `~/projects/peerloop-docs` and `~/projects/Peerloop` — that precondition is what makes the tilde form universally correct.

**Refined Conv 153:** L2 forward-portability audit on M4Pro post-[MPS] surfaced exactly 1 expected hit — `feedback_watch_task_assumptions.md:9` historical-narrative `/Users/livingroom/...` quote. Confirmed as a stable invariant: the historical-narrative exemption is real, and future audits should expect "1 hit (historical narrative)" not "0". Memory files exist to record incidents — the username segment of a quoted incident path is part of the record, not a portability bug.

**See:** Conv 152 Decisions.md §2, §3; Conv 153 Decisions.md §1.

### Cross-Machine Memory Sync: Skill-Based Mirror, No Hooks, No Manifest ([MSI] Transport Layer)
**Date:** 2026-05-06 (Conv 154)

Cross-machine memory sync uses an in-repo `.claude/memory-sync/memories/` mirror dir, kept aligned with the live memory dir at `$HOME/.claude/projects/${CLAUDE_PROJECT_DIR//\//-}/memory` via inline rsync steps inside `/r-start`, `/r-commit`, and `/r-end`. No CC hooks. No manifest, index, or checksum file — git itself is the ledger.

**Trigger:** [CMS] gap (Conv 150) and [MPP]/[MPS] content portability arc (Convs 152–153) left transport unsolved. User proposed hook-based packet sync; design discussion converged on a simpler skill-inlined mirror.

**Options Considered (top-level):**
1. CC hooks (PostToolUse + SessionStart/End) for continuous mid-conv sync
2. Symlink the live memory dir into the repo
3. Skill-inlined rsync at /r-start, /r-commit, /r-end touchpoints ← Chosen

**Decision:** Option 3. Sub-decisions:
- **Skill-based, not hook-based:** sync runs inline in `/r-start` (mirror→live + explicit Read of MEMORY.md), `/r-commit` (live→mirror), `/r-end` (live→mirror). Hooks rejected — explicit skill invocations are simpler, no event-edge cases.
- **No manifest / no index:** committed mirror IS the canonical state; `diff -rq mirror live` is the comparator; `shasum` derivable on demand. A separate manifest only matters if detecting tampering, not for plain sync.
- **Bootstrap = first /r-end:** no separate init skill. `mkdir -p` + first rsync seeds the mirror; idempotent thereafter.
- **Conflict UX = git native:** concurrent edits surface via standard git merge-conflict on the in-repo mirror; /r-start's pull step halts on divergence. No custom 3-way merge logic.
- **MEMORY.md auto-load mitigation:** /r-start Step 5.7 explicitly Reads MEMORY.md after the mirror→live rsync, since CC auto-loads MEMORY.md only at SessionStart (not refreshed mid-session).

**Rationale:** "One machine at a time" + "always pull first" invariants make mid-conv continuous sync unnecessary — the other machine only ever sees state at /r-end push boundaries. The user's "all changes through CC" discipline (see Insight) collapses an entire class of defensive logic that file-sync designs normally need. Path derivation via `$HOME` + `${CLAUDE_PROJECT_DIR//\//-}` is one-line portable across machines, no hardcoded usernames or project slugs.

**Consequences:** [CMS] task formally retired, replaced by [MSI]. Mirror at `.claude/memory-sync/memories/` is committed (no .gitignore additions). Mirror reflects "last commit point," not live mid-conv state — invisible to the other machine since the other machine only sees pushed state. Conv 154's /r-end is the live first-run bootstrap on M4. M4Pro converges on next /r-start. `[MSI-VERIFY]` task pending until M4Pro round-trip completes. Same architectural pattern (commit-mirror + rsync-at-skill-boundaries) is reusable for future cross-machine artifacts.

> **Insight:** Designs that can trust a single mediated point of authorship are substantially simpler than designs that must defend against arbitrary edits. The user's "all project-file changes go through CC" discipline does real architectural work — it makes "trust mirror at SessionStart" safe by construction, eliminating fail-stop disambiguation, commit-message machine-name parsing, and per-machine ledger requirements. Workflow discipline is a load-bearing input to system design, not just an observability nicety.

**See:** Conv 154 Decisions.md §1–§6; Conv 154 Learnings.md §1–§5.

### Cross-Machine Memory Sync: Always-Pause on Non-Empty Mirror→Live Diff in /r-start Step 5.7
**Date:** 2026-05-06 (Conv 156)

/r-start Step 5.7 always pauses on ANY non-empty `diff -rq` between the mirror and the live memory dir, displaying the per-file detail and asking the user before running `rsync --delete`. Empty-diff is the only silent path. Two question shapes apply: yes/no for normal incoming changes; A/B/C + auto-backup escalation for `Only in $LIVE` (data-loss).

**Trigger:** User: "There was supposed to be an interruption via question if the diff found memories in live that were not in the mirror. I would now prefer that r-start always interrupt its flow and ask if it should continue and replace the live memories with the mirror as well as show that one line output of the net difference. That way we can deal with any diff that is unexpected." Conv 155 had built halt-and-ask only for the data-loss case; the architecture generalized to "any non-empty diff" with a predicate change rather than a structural change.

**Options Considered:**
1. Keep Conv 155 design — halt only on `Only in $LIVE`; just display diff inline ([SDD] only)
2. Extend halt to all non-empty diffs ← Chosen
3. Halt only on diffs above some change-threshold (e.g., >= N files)

**Rationale:** User is sole pilot per `user_hands_off_pilot_workflow.md` and wants full visibility into every cross-machine state change before destructive `rsync --delete` runs. Per-conv friction (one yes/no when there are incoming changes) is a worthwhile trade. Threshold gates (option 3) introduce a tunable with no clean default; binary always-pause is simpler and more predictable. Empty-diff stays silent because a prompt with no decision behind it is friction without value — "always interrupt" was understood as "always interrupt when there's something to decide."

**Consequences:** Step 5.7 now has two `\`\`\`bash\`\`\`` blocks separated by branching prose (Phase 1 forensics+display+halt, Phase 2 rsync+cap-check). The MEMORY.md cap check moved to Phase 2 so it always runs against post-sync state. The "no" path is a soft escape valve — skip Phase 2 with explicit warning, continue /r-start (the conv counter is already pushed by the time Step 5.7 runs; halting would orphan it). Memory entry `feedback_msi_first_sync_data_loss_window.md` rewritten to reflect the broader rule; filename rename queued.

> **Insight:** The architecture you build for the special case becomes the architecture you have for the general case. Conv 155 built a halt-and-ask path for one trigger (`Only in $LIVE`); Conv 156 widened the predicate to "any non-empty diff" with no structural change. When adding a guard for a narrow risk window, prefer the structural shape that would generalize cleanly (visible bash branches, separate phases, named conditions) over an inline ad-hoc check.

**See:** Conv 156 Decisions.md §1–§4; Conv 156 Learnings.md §1–§3.

### Skill Convention: Tilde-Literal Everywhere; No `$CLAUDE_PROJECT_DIR` or `$HOME` in Skill-Issued Bash
**Date:** 2026-05-19 (Conv 162)

All skill SKILL.md command strings use tilde-literal `~/projects/peerloop-docs` (outside quotes) and unquoted-tilde assignments (`VAR=~/path/$other_var`). `$CLAUDE_PROJECT_DIR` and `$HOME` are forbidden in skill-issued Bash because the Claude Code permission gate flags `$VAR` references as `simple_expansion` and prompts. Tilde resolves at bash parse time before the gate sees it, so tilde-form commands run prompt-free. For slug-style derivations (the Claude Code memory-dir slug), use `$(echo ~/projects/peerloop-docs | tr / -)` instead of `${CLAUDE_PROJECT_DIR//\//-}`. Local-scope script variables (`$SLUG`, `$LIVE`, etc.) defined and consumed inside the same bash block are unaffected — the gate only flags external env-var references.

**Trigger:** User: "I am constantky being interrupted to handle this kind of question from you... It seems to have to do with the $CLAUDE_PROJECT_DIR in expressions. Is it possible to substitute the value of the $CLAUDE_PROJECT_DIR for its $variable before the command is issued?" Cross-checked `~/projects/spt-docs` which had converged on the tilde-everywhere pattern; its `w-test-tilde` skill empirically confirmed `$CLAUDE_PROJECT_DIR` hard-fails on simple_expansion while tilde passes.

**Options Considered:**
1. Run `/fewer-permission-prompts` to add per-path Bash allowlist entries
2. Hand-edit `.claude/settings.local.json` with specific `Bash(git -C /Users/jamesfraser/...:*)` patterns
3. Sweep all skill SKILL.md files to tilde-literal paths ← Chosen

**Rationale:** Substitution-side fix is durable — new skills inherit the convention by example, and the rule survives across machines because tilde resolves per-user at runtime (M4Pro `jamesfraser` ↔ M4 `livingroom`, both work). Settings-allowlist approaches (1 and 2) would still leak prompts whenever a new path or variant appeared. spt-docs's prior convergence proves the pattern works at scale. First sweep iteration mistakenly substituted `$HOME` with literal `/Users/jamesfraser` — user caught it on memory-file review (M4's username is `livingroom`), forcing reversion and confirming that any username-bearing hardcode breaks cross-machine portability.

**Consequences:** 10 skill files swept: `r-start`, `r-commit`, `r-end`, `r-end/refs/fmt-docs.md`, `r-timecard-day`, `w-post-fix`, `w-review-resume-state`, `w-sync-skills`. CLAUDE.md §Path Conventions extended with the tilde-everywhere rule; §Startup Hooks flagged `persist-project-dir.sh` as historical (only `w-test-env` diagnostic skill still references `$CLAUDE_PROJECT_DIR`). Memory `feedback_git_dash_c_enforcement.md` and MEMORY.md one-liner updated. Cross-machine portability verified via `HOME=/Users/livingroom bash -c '...'` simulation — first actual run on M4 will be the empirical confirmation (no specific action required).

> **Insight:** A permission-gate friction loop has two structural fixes — shape the command strings so the gate doesn't fire (substitution-side), or extend the allowlist so the gate accepts them (settings-side). Substitution-side is durable because it's self-propagating: every new skill written by example inherits it. Allowlist-side is leaky because each new path variant requires a new entry. When `~` is functionally equivalent to `$HOME` and the gate treats them differently at parse time, the substitution-side fix is essentially free.

**See:** Conv 162 Decisions.md §1; Conv 162 Learnings.md §1–§3.

### Form-Graduation Pattern: `.scratch/` Working Doc → `docs/as-designed/` Once Permanent
**Date:** 2026-05-21 (Conv 171)

Working documents that begin in `.scratch/` (a gitignored persistent workspace) can graduate to `docs/as-designed/` mid-conv once their content stabilizes into substantially-permanent design intent. Trigger: when a "working form" has accumulated ~60%+ permanent content (strategic context, architectural findings, durable spec sections — not just transient lookup fields). Original .scratch/ file is deleted at the same time to avoid two-source-of-truth drift; the graduated doc keeps a visible "Working draft" banner while batches/sections still resolve.

**Rationale:** `.scratch/` is gitignored (lost on machine swap, doesn't propagate cross-machine via Obsidian sync, no version history). `docs/as-designed/` is git-tracked, indexed in `docs/INDEX.md`, and discoverable. Delaying graduation until "fully complete" leaves substantially-permanent content fragile during the in-progress phase. A single-doc graduation (rather than splitting into polished spec + working form) avoids drift between two sources. The "Working draft" banner sets reader expectations correctly — the doc is real and discoverable but parts may still resolve.

**Consequences:** Conv 171 graduated `.scratch/matt-devmode-form.md` → `docs/as-designed/matt-design-system.md` mid-conv (single doc with Working draft banner). Both [MDM] and [MATT-PRE-PLAN] task descriptions updated to reference the new path. INDEX entry added under "How Should It Look/Work?" with a 🚧 marker. Future working forms in `.scratch/` should apply the same trigger: when permanent content accumulates past ~60%, graduate single-doc with a draft banner rather than waiting for the originating block to fully close.

**See:** `docs/as-designed/matt-design-system.md`, `docs/INDEX.md` § How Should It Look/Work?, Conv 171 Decisions.md §4.

### Figma MCP: Remote Hosted Server Over Local Dev Mode
**Date:** 2026-05-23 (Conv 179)

Use Figma's hosted Remote MCP server (`https://mcp.figma.com/mcp`) over the local Dev Mode MCP path. Registration via `claude mcp add --transport http figma https://mcp.figma.com/mcp`; auth via OAuth in browser at first `/mcp` → figma → Authenticate; no Figma desktop install or paid Dev seat required. Community `figma-developer-mcp` (npx + personal access token) remains documented as fallback.

**Rationale:** (a) Figma's own developer docs recommend the remote path as primary; (b) one-command setup vs multi-step local install + admin + UI toggle + manual settings.json edit; (c) OAuth means account-level identity matches whatever files the logged-in account can see — sidesteps the Dev-seat blocker that killed Conv 169's first MCP attempt; (d) cross-machine: re-run `claude mcp add` and re-auth on each machine, no local install state to maintain. Vendor-docs-first discipline learned hard: training-data recollection led to the local-MCP v1 draft that the user overrode by reading Figma's live docs.

**Consequences:** `.scratch/figma-mcp-setup.md` v1 (local-MCP path) rewritten as v2 (remote primary, local as fallback). Brian's Dev-seat assignment message is now unnecessary for primary path but harmless as fallback intel. OAuth must run in a fresh CC session because MCP server list is loaded once at session start (see "MCP Server List Loaded Once at Session Start" below).

**See:** `feedback_external_source_of_truth_first.md` (memory), `.scratch/figma-mcp-setup.md` v2, Conv 179 Decisions.md §1.

### MCP Config Scope: `.claude.json` `[project: ...]` Tagging Is Effectively Project-Scoped
**Date:** 2026-05-23 (Conv 179)

`claude mcp add` writes MCP entries to the user-level `~/.claude.json` file but tags each entry with `[project: <cwd>]`, so the MCP only activates when CC launches from that project directory. This is functionally equivalent to project-scoping (the original B1 intent) without any manual settings.json edit. Cross-machine: `.claude.json` is per-machine (not git-synced); each machine needs one `claude mcp add` invocation, but the project-tag prevents the entry from leaking into other projects (e.g., spt sibling dual-repo) on that machine.

**Rationale:** Manual settings.json `mcpServers` block editing is the textbook approach but error-prone; `claude mcp add` is the official CLI and produces the same logical scoping via its own mechanism. Project-tag prevents leak to sibling projects without requiring a per-project settings.json edit.

**Consequences:** No `mcpServers` block was added to `.claude/settings.json`. The `.claude.json` path lives outside the docs repo, so the entry doesn't transport via git — captured as a "run on each machine" step in `.scratch/figma-mcp-setup.md` v2.

**See:** `.scratch/figma-mcp-setup.md` v2, Conv 179 Decisions.md §2.

### MCP Server List Loaded Once at Session Start
**Date:** 2026-05-23 (Conv 179)

CC loads its MCP server list when the session starts; `claude mcp add` writes to `~/.claude.json` but does NOT hot-reload into the running session's in-memory list. Opening a separate terminal doesn't help the original session — the in-memory list is per-process. To activate a newly-added MCP server mid-conv, plan an `/r-end` → exit → `/r-start` bridge.

**Rationale:** Discovered when `claude mcp list` confirmed figma was registered with "Needs authentication" but `/mcp` in the running session did not show the entry. This is structural CC behavior, not a Figma-specific issue.

**Consequences:** Conv 179 ended without OAuth completion; Conv 180 will activate via fresh `/r-start` then `/mcp` → figma → Authenticate. RESUME-STATE.md preserves the 28-task working set across the restart.

**See:** Conv 179 Learnings.md §2.

### Memory Consolidation Rule: One File With Named Contexts, Multiple Markers in MEMORY.md Index
**Date:** 2026-05-23 (Conv 179)

When multiple "save memory" captures (≥3) all point at one broader rule, consolidate into a single memory file with N numbered named contexts rather than N separate near-duplicate files. The MEMORY.md index entry exposes every original code marker (`[VDF]`, `[MFM]`, `[STOR]`, `[DTU]` in this case) as distinctive grep-anchored entry points so future recall under any of the triggers still finds the rule.

**Rationale:** Near-duplicate memory files dilute MEMORY.md's auto-load signal (200-line cap is the binding constraint, not per-file count). The shared underlying pattern survives consolidation; the contextual nuances are preserved as numbered sub-cases inside the single file. The per-file vs per-rule tension resolves as "1 rule, 1 file, but N grep-anchored entry points."

**Consequences:** Conv 179 wrote `feedback_external_source_of_truth_first.md` (consolidating 4 captures across Convs 178 + 179) and added a single `## External Source-of-Truth` section to MEMORY.md exposing all 4 markers in one index line. MEMORY.md utilization 62/200 ≈ 31% (still healthy); `[MEM-CAP]` watch-task tracks the cap headroom over time. File structure used: Rule → Why → How to apply (N numbered contexts) → Anti-pattern → Related (with `[[...]]` links).

**See:** `feedback_external_source_of_truth_first.md` (memory), MEMORY.md `## External Source-of-Truth`, Conv 179 Decisions.md §3.

### Doc Reconciliation by Type: Status-Banner vs Path-Swap
**Date:** 2026-05-26 (Conv 198)

When code moves invalidate path/route refs across many docs, do NOT apply a uniform find-replace. Classify each doc by type and treat it accordingly: **timeless-design** (architecture docs whose content outlives the move) → keep canonical content, add one status banner that confines transitional churn to a single section/table; **living-guide** (how-to docs) → straight path swaps so every ref points at a real file; **historical-spec** (specs written during the build, where `/matt/*` is the *name of the work*) → top-of-doc banner to contextualize narrative, fix only concrete code-paths, leave the design-conversation prose; **machine-lookup** (drift-lookup tables) → bulk `replace_all`, every cell is a real path.

**Rationale:** The treatment follows reader intent, not the stale string. A URL *grammar* is permanent while its *file location* under `/old/` is a transitional fact that reverses as pages roll forward — so a durable doc separates "what URLs mean" (timeless) from "which app serves them" (a churning status table). Same historical-narrative content gets opposite treatment in a guide (paths updated, because a developer acts on them today) vs a spec (contextualized, because it records a conversation).

**Consequences:** Conv 198 reconciled four post-flip docs this way: url-routing.md (Option B status banner + file-tree rewrite), DEVELOPMENT-GUIDE.md (~20 path swaps), matt-design-system/ (INDEX banner + concrete-ref fixes), matt-frames-ready-for-dev.md (bulk `replace_all`). The status-banner technique is the reusable artifact. A line-by-line stale-ref pass also surfaces adjacent drift (renamed section anchors, doc-internal contradictions) worth fixing inline.

**See:** Conv 198 Learnings.md §§1–3, Conv 198 Decisions.md §1.

### `/r-start` Step 7.5 Generates a Per-Conv Plain-Language Task Companion File
**Date:** 2026-05-29 (Conv 215)

`/r-start` Step 7.5 regenerates `.scratch/conv-tasks.md` every conv — a plain-language readout of all TodoWrite tasks grouped by theme, with a "what it actually means" intent column, ⚠️-thin flags for codes whose intent didn't survive carry-over, and an opaque section. A stable filename (overwritten each conv, not dated) keeps the user's VS Code tab valid across convs. A mandatory coverage check enforces file-row-count == task-count.

**Rationale:** Terse mnemonic codes (e.g. `[RTB]`, `[DISC-DROP]`) are unreadable while working; the user wanted a standing reference file rather than a one-off chat summary. The coverage check exists because the inaugural generation silently dropped 1 of 31 tasks ([TXTBTN]) — a determinism guard against the regenerator missing rows.

**See:** `.claude/skills/r-start/SKILL.md` (Step 7.5), `.scratch/conv-tasks.md`.

### A Skill's Invocation-Rendered Body Is a Pre-Pull Snapshot — Self-Pulling Skills Must Re-Read After the Pull
**Date:** 2026-05-29 (Conv 218)

The SKILL.md body Claude executes is rendered at invocation. `/r-start` Step 2 then pulls a potentially newer copy of the same skill from the other machine — so any conv where the other machine edited the running skill executes the STALE (pre-pull) body. This is staleness, not truncation. The durable fix is BOTH: (1) a memory rule generalizing to any self-pulling skill, and (2) `/r-start` Step 2.5 — a self-update detector that diffs `HEAD@{1}..HEAD` on its own SKILL.md after the pull and prints ⚠️ + "re-read on-disk" if it self-updated.

**Rationale:** Step 2.5 is deterministic but has a one-conv lag (it only protects once the running machine already has the updated skill); the memory backstops that first-encounter gap. Diagnosed via git when `/r-start` Step 7.5 (added Conv 215) was silently skipped in Conv 218 — the Step-2 pull delivered the newer skill, but the already-rendered body lacked Step 7.5.

**See:** `memory/feedback_skill_body_stale_after_self_pull.md`, `.claude/skills/r-start/SKILL.md` (Step 2.5), Conv 218 Decisions.md §1.

### JFG Annotation Protocol — In-File Located Instruction Channel
**Date:** 2026-05-30 (Conv 219)

The user annotates source files with `/* JFG: <lines> | <act|discuss> | intent */` comments as a lossless instruction channel; CC reads, acts, and then strips (or promotes the *why* into a commit message / permanent comment). Invariants: a JFG *command* never persists past its action, but the *intent* is preserved in git history / promoted comment. This refines (does not reverse) the `user_hands_off_pilot_workflow` rule — the user still doesn't edit project files for content, only to annotate intent.

**Rationale:** Co-located intent eliminates coordinate-passing ("line 167–183") and lossy prose description; the annotated diff is a stronger audit artifact than chat scrollback. First live run succeeded on TopicPicker (`JFG: 111-139 | discuss` → resolved A, comment stripped, zero residue).

**See:** `.scratch/JFG.md`, Conv 219 Decisions.md §7.

### `/r-start` Crash-Survivor Restore + No-Shrink Backstop (Step 7 / 7.5)
**Date:** 2026-05-30 (Conv 219)

`/r-start` Step 7 gains a crash-survivor restore branch: when RESUME-STATE is absent AND `.scratch/conv-tasks.md` is populated AND TodoWrite is empty, rehydrate TodoWrite from conv-tasks.md (skip-silently exception otherwise). Step 7.5 gains a no-shrink backstop so a populated conv-tasks.md is never overwritten with fewer/zero tasks. Companion learning: on a resume-WITHOUT-`/r-start`, the first move is to rehydrate TodoWrite from conv-tasks.md manually.

**Rationale:** A predecessor conv crashed after Step 7 transferred RESUME-STATE → TodoWrite and deleted RESUME-STATE but before `/r-end`; the new process started empty and 22 tasks were lost (caught by the user, not any check). conv-tasks.md is never deleted mid-conv, so it is the surviving on-disk task list. Makes the crash path self-healing instead of silently truncating the backlog.

**See:** `.claude/skills/r-start/SKILL.md` (Step 7, 7.5), Conv 219 Decisions.md §8, Learnings.md §1.

### `/w-prim-candidates` Skill — Agent-Narrated Now, Index Upgrade Later (Option C)
**Date:** 2026-05-30 (Conv 219)

Ship `/w-prim-candidates` as an agent-narrated skill now (deterministic `prim-treewalk.ts` sensor + agent cluster-collapse/likely-primitive-naming table + `.scratch` output named by arg, overwrites on re-run); swap the naming layer to a deterministic index lookup when `[PRIM-MATCH-INDEX]` lands. The sensor was reframed from HOLE/verdict semantics to "primitive candidates to confirm" via 3 stacking AST signals (interactive-cluster, loop-repeated, legacy-tokens) — nominations, not failures, exit 0.

**Rationale:** Runnable today; the narrowing table is agent reasoning that only a skill (script + body) can house; full determinism comes later via the index. Static analysis can surface candidates but can't decide primitive-worthiness — that needs a primitive-existence/fit check the sensor can't do.

**See:** `.claude/skills/w-prim-candidates/SKILL.md`, `scripts/prim-treewalk.ts`, Conv 219 Decisions.md §1–2, Learnings.md §4.

# Peerloop Project Memory

## User Workflow
- [link](user_hands_off_pilot_workflow.md) — User does NOT edit project files directly; CC is sole author. Skill/sync/drift designs can trust state at SessionStart — do NOT defend against arbitrary out-of-band edits ([MSI], state files, tech-doc-drift). **ONE carve-out: `USER-WIP.md`** (Conv 304) — user-authored, CC READ-ONLY, `/r-end` Step 1.5 auto-saves; `/r-start` unmodified.

## Dual-Repo Shell Discipline
- [link](feedback_git_dash_c_enforcement.md) — Always `git -C ~/projects/peerloop-docs`/`git -C ~/projects/Peerloop` (tilde-literal, not `$VAR` → `simple_expansion` prompt); bare git lands in wrong repo on `cd ../Peerloop` cwd drift. Guard regex must tolerate `git -C` (Convs 109/162/214).
- [link](project_route_gen_cross_repo.md) — route-doc regen (`route-api-map.mjs`/`route-matrix.mjs`) writes BOTH repos: code `tests/plato/route-map.generated.ts` + docs route docs/TSVs; `git status` both before committing (Conv 201)

## Icon System
- [link](reference_icon_system.md) — Two icon systems: Astro path registry (`src/lib/icon-paths.ts`) + React `icons.tsx`/`brand-icons.tsx`; Matt `MattIcon` registry (`@components/icons/MattIcon`, SVGs auto-registered from `svg/`, per-icon viewBox, fills MUST be `fill="currentColor"` — wrapper is `fill="none"`, unknown name → dashed placeholder).

## Test Suite
- [link](feedback_full_test_output.md) — Full test suite: `cd ../Peerloop && npm test 2>&1 | tee /tmp/lastFullTestRun.log`; tail 15-20 lines; run strategically (~3min cost); use `--testNamePattern` for iterative fixes. Test DB = better-sqlite3 (all machines).
- [link](e2e-testing-patterns.md) — After `page.goto()` add `waitForLoadState('networkidle')` for Astro `client:load` islands (else buttons visible-but-not-interactive under parallel load); full E2E suite needs `npm run db:setup:local` headroom against cross-test write contamination

## Development Environment
- [link](feedback_db_setup_shorthand.md) — "run the {local/staging} D1 {level} script" → `npm run db:setup:{target}:{level}`. Machine name in commits from `~/.claude/.machine-name`.

## Navigation Architecture
- [link](project_navigation_architecture.md) — **AppLayout (Matt shell)** = canonical layout since ROUTE-FLIP (Conv 197); LegacyAppLayout/AppHeader/AppNavbar wrap `/old/*`. Mind which shell + `startsWith` active-matching when adding routes.

## Testing Preferences
- [link](feedback_no_test_artifacts_in_prod.md) — No dev-only testing infra in production code; use two browser vendors for multi-user testing
- [link](feedback_test_import_cleanup.md) — After writing a test file, quick-pass to remove unused imports/variables before moving on

## Output Formatting
- [link](feedback_conversational_brevity.md) — Match response length to question length. Short conversational questions → short answers. "Need to dig deeper first" is acceptable. Don't auto-expand into A/B/C frameworks unless invited. [MCFRAME]: when user steers with specifics, execute — don't bounce back as MC question.
- [link](feedback_pointing_emoji_prefix.md) — Stub pointer: 👉👉👉 + bold rule lives in CLAUDE.md §User-Facing Questions. Memory-grep anchor for "pointing" / "bold question" searches.
- [link](feedback_option_phrasing.md) — Route every decision (picks AND yes/no) through the **AskUserQuestion tool** — prose above, picker below; user **selects, not types** (kills compound-`"X or Y?"`/symbol-label/misspelled-yes-no failures). **Conv 273 dropped inline A)/B)/C) + retired QLINT Stop-hook.** Open-ended → inline 👉👉👉. Rule in CLAUDE.md §User-Facing Questions; archaeology (132/147/208/263) in file.
- [link](feedback_pause_on_pointing_questions.md) — 👉👉👉 must be the last visible content; do independent work FIRST, then ask, then stop
- [link](feedback_explicit_approval_not_inferred.md) — **Conv 300:** a venting/ambiguous/"Other" reply to a confirm-question is NOT a yes — don't infer consent from tone; re-ask or wait for an explicit go-ahead before consequential/hard-to-reverse acts. Bar is HIGHER right after a miss; xhigh effort doesn't relax the approval gate.
- [link](feedback_visual_issue_alerts.md) — Stub pointer: 🔴🔴🔴 / 🟠🟠🟠 rule lives in CLAUDE.md §Issue Surfacing. Memory-grep anchor so issue-alert searches still resolve.
- [link](feedback_mirror_term_annotation.md) — When CC says "mirror" (memory-sync mirror), append "(from last r-end)" — bare term hard for user to rationalize; mirror = whatever prev conv's /r-end pushed (live→mirror snapshot). Conv 228.

## Tool-Call Discipline
- [link](feedback_no_tool_call_spam_loops.md) — **RECURRING FAILURE:** tool result authoritative on FIRST return; empty=empty; NEVER re-issue to "flush a buffer" (Conv 218: ~420K spamming `Read` ×25). Max one retry. **[TERM-GARBLE] carve-out:** suspicious-empty → verify OUT-OF-BAND (`wc -c`/`git status`), never re-spam or narrate un-received output.
- [link](reference_term_garble_upstream_bug.md) — **[TERM-GARBLE]/[GARBLE-WATCH] (Conv 227):** blank/partial tool-output + confabulated-failure = OPEN upstream CC bug (Opus 4.8 + parallel batch + ANY sibling fail incl. `guard-dangerous-bash.sh`). NOT Peerloop; 2.1.159 unfixed. Mitigate: narrow batches, out-of-band verify, never narrate un-received output. Per-conv detection NOT buildable (Conv 229).

## Solution Quality
- [link](feedback_no_simplest_fix.md) — **Core principle:** favour durable decisions over faster options. Lean durable when deciding; break only with sound reasons.
- [link](feedback_default_durable_no_ask.md) — Quick/durable: rule lives in CLAUDE.md §Solution Quality + §Critical Rule (size ≠ novelty). File retains multi-conv-scope counter-case + Conv 131 TDS-AUTH precedent.
- [link](feedback_audit_surface_findings_first.md) — Investigative verbs (audit/review/investigate/analyze/explore/scan/"look at") → surface per-item dispositions + 👉👉👉 BEFORE writes; **overrides** §Solution Quality default-proceed + §Critical Rule size-≠-novelty. Picking an option authorizes the *approach*, not execution. Conv 206 [MEM-AUDIT].
- [link](feedback_routing_addressability_first.md) — Route shape: decide ADDRESSABILITY (needs deep-link/redirect URL?) NOT page-count; ≠ separate files. Hard-yes: Stripe `success_url`, notification deep-link, entity-by-id. No: transient confirmations → overlays. (Conv 187 [MATT-EXEC-FLAGS])

## Docs Awareness
- [link](feedback_check_docs_on_how_questions.md) — On "how does X work" questions, check docs too; offer doc update if answer required heavy searching
- [link](reference_generated_doc_regen.md) — **[DOCGEN] (Conv 246):** route maps are `generated` docs auto-regenerated at r-end **Step 5c** (`regen-generated-docs.mjs`, inputs-gated on `src/pages|components|lib`). NEVER TaskCreate "regen stale route docs" (#22 anti-pattern). `route-stories.md` is hand-written (driftCheck), NOT generated.

## External Source-of-Truth
- [link](feedback_external_source_of_truth_first.md) — Probe authoritative sources BEFORE inferring: vendor MCP/SDK docs via `WebFetch` ([VDF]), designer catalogues over visual ID ([MFM]), user-supplied source files canonical — ask before drilling ([STOR][DTU]), probe external tool before recommending ([EMP]). Convs 178-180.
- [link](feedback_read_legacy_source_before_conclusion.md) — Review/compare/port/parity → fully read BOTH sides, esp. the legacy `/old` source-of-truth, BEFORE concluding. "Already in context" = genuine full read THIS conv only (never a summary/digest); `feedback_exploration_pacing` is NOT a skip-license. Conv 222.

## Memory Discipline
- [link](feedback_check_memory_before_directive_save.md) — Before offering to save a directive, grep the memory dir for an existing entry on the same topic
- [link](feedback_resume_state_as_todowrite_persistence.md) — RESUME-STATE.md = TodoWrite persistence across convs; user never touches it. **Crash recovery (Conv 219):** `.scratch/conv-tasks.md` survives mid-conv → primary restore source; resume-without-r-start → rehydrate from it FIRST.
- [link](feedback_conv_tasks_live_sync.md) — Keep `.scratch/conv-tasks.md` live-synced with TodoWrite: completed→prepend `*DONE* ` (never delete row); new→add row. **r-start shrink is EXPECTED — reconcile missing codes vs RESUME-STATE `## Completed`/`## Dropped` ledger, halt only on UNEXPLAINED loss** (`*DONE*`-count heuristic breaks on a stale companion). Convs 228-229, 246.
- [link](feedback_confirmations_stand_unless_revoked.md) — User-confirmed sub-decisions survive later topic-level pivots; treat confirmations as sticky until user names the item to revoke
- [link](feedback_memory_index_load_bearing.md) — MEMORY.md one-liners must expose distinctive markers (`👉👉👉`, `A) B) C)`, `tee /tmp/...`), triggers, anti-patterns — not just topic labels (Conv 151). Re-read+reconcile the index line after every memory edit. Pointer label = constant `[link]`, never filename-echo; don't rename sub-files (Conv 213).
- [link](feedback_msi_sync_user_checkpoint.md) — /r-start Step 5.7 ALWAYS pauses on non-empty `diff -rq` mirror vs live: yes/no for incoming changes, A/B/C + auto-backup on `Only in $LIVE` data-loss; rule lives in skill code; reverse (live→mirror) safe (Conv 155-156)

## Skill Execution
- [link](feedback_skill_body_stale_after_self_pull.md) — A skill's in-context body is a pre-pull SNAPSHOT; if Step 2's pull updates SKILL.md, re-read the on-disk file before later steps (Conv 218: Step 7.5 silently skipped). `/r-start` Step 2.5 now auto-detects via `HEAD@{1}` diff. Staleness ≠ truncation. Applies to any self-pulling skill.
- [link](feedback_always_r_end.md) — Autonomous /r-commit OK; /r-end always requires user approval (Conv 108)
- [link](feedback_rend_complete_all_steps.md) — **RECURRING FAILURE:** /r-end must execute ALL 8 steps without stopping after /r-eos (Conv 006, 019, 026, 027)
- [link](feedback_rend_todowrite_alerts.md) — /r-end Step 4: every 🔴/🟠 alert MUST call TaskCreate, not just display
- [link](feedback_post_rend_fixes.md) — Post /r-end fixes: /r-start (no /clear) → fix → /r-end. No gates or topup skills needed.
- [link](feedback_uncategorized_filtering.md) — Extract §Uncategorized: if writing "not a bug" or "no action needed", it doesn't belong there
- [link](feedback_verify_baselines_in_conv.md) — Two baseline-incident pointers (rule lives in CLAUDE.md §Baseline Verification): Conv 101→102 (5 silently-broken time-fragile tests via unverified carry-forward) + Conv 104 (10 `.astro` errors hidden because `astro check` wasn't a gate). Both incidents in-file.
- [link](feedback_codecheck_moment_includes_tests_and_build.md) — `/w-codecheck` trigger = decision point: also decide per-change whether to add prov-sweep + test suite + build (none auto-bundled). Anti-pattern: inline `tsc + lint + astro check` skipping `/w-codecheck` (bypasses Peerloop bug-class checks + the decision menu). Conv 207.
- [link](feedback_exploration_pacing.md) — After Phase 1 establishes patterns (file structure, API, test, component), Phase N+1 jumps straight to writing code; do NOT re-explore (Conv 057: >1hr lost re-exploring before AdminCourseTab)
- [link](feedback_plan_mode_usage.md) — Use CC Plan Mode to stress-test designs AFTER discussion, not just for proposing approaches
- [link](feedback_plan_persistence.md) — CC Plan Mode files are ephemeral; persist plans to committed files before /r-end
- [link](feedback_skill_sync_same_name_divergence.md) — Same-named skills across projects often diverge structurally — default to "evolve independently" recommendation
- [link](feedback_heuristic_calibration.md) — New detection heuristic/threshold/gate from qualitative guidance MUST be run against memo's canonical case BEFORE commit; if it doesn't fire there, threshold wrong OR signal incomplete (Conv 142 [CMH]: `/w-sync-skills` Jaccard `< 0.70` returned `1.000` on canonical DIVERGED case).

## Work Tracking
- [link](feedback_surface_and_track_all_issues.md) — Never silently skip issues; always TodoWrite anything not immediately resolved
- [link](feedback_fix_docs_inline_not_rend.md) — Do NOT rely on /r-end to scrub stale doc references (its update-plan agent only touches ACTIVE-block subtasks/status cells — buried mentions in completed/migrated blocks slip through); fix doc refs INLINE same-conv + don't TaskCreate trivial doc-cleanups (bloats TodoWrite with low-signal rows). Refines [surface-and-track]. Conv 286 [TW-V4].
- [link](feedback_cleanup_step.md) — Every PLAN block must end with a Cleanup phase (check off RFCs, reset temp files, remove scaffolding)
- [link](feedback_mnemonic_collision.md) — Append sequential numbers to mnemonic codes on collision (e.g., [GE] → [GE2])
- [link](feedback_codecheck_todos.md) — Never dismiss codecheck findings as "pre-existing"; always TodoWrite them
- [link](feedback_todowrite_mnemonic_codes.md) — Every TaskCreate subject starts with a unique 2-3 letter bracketed code (e.g., `[PL] Plan update`); user references tasks by code
- [link](feedback_infra_vs_deliverable.md) — Building test infra: pause to check if approach is generalizable or special-cased; surface dual goals early
- [link](feedback_decompose_by_cohesion_not_pseudo_isolation.md) — Split by cohesion (vertical slices), NOT pseudo-isolated fragments where one task needs a *piece* of another; each unit owns its full stack + has a standalone done-test (rule-4 tell); whole-unit unidirectional deps only. Conv 271 feed-group reassembly (14 fragments → 3 units).
- [link](feedback_watch_task_assumptions.md) — Watch-tasks must state the assumed delivery/load precondition in subject ("watching X **assuming** Y is loaded on machine Z"); audit at watch-end falsifies the precondition FIRST before debating content (Conv 149→150 [OPW]).
- [link](rename-lessons.md) — **Load when planning a large rename (>50 files):** baseline tests FIRST; macOS `sed` lacks `\b` → use `perl -pi -e`; short substrings dangerous (`stId`→ mangled `getByTestId`); smaller divergent rename first; `†` comment marker for auto-changed lines (TERMINOLOGY block, Sessions 346-356).

## Security & Secrets
- [link](feedback_no_paste_tokens_in_chat.md) — Block secrets reaching chat from BOTH directions: user-paste AND Claude-initiated diagnostic dumps like `stripe config --list` / `od -c` / `cat .dev.vars`
- [link](figma-context.md) — **Load when** Figma / design-translation / design-token work arises. **GUARDRAIL: Figma is READ-ONLY — NEVER call write-shaped `mcp__figma__*` tools** (`use_figma`/`create_new_file`/`upload_assets`/`add_code_connect_map`); read-tools only ([MNV] Conv 183). Bundle (Conv 281) also covers: reuse-existing-components-on-render, MCP read-behavior, tokenize-what-Matt-tokenized probe.

## PLATO / Browser Testing
- [link](plato-context.md) — **Load when** PLATO, browser-run, STUMBLE-AUDIT, or BrowserIntent is discussed — terminology, execution modes, nav link caveats, screenshot conventions
- [link](feedback_dom_truth_over_screenshots.md) — Precise layout/position/visibility: trust DOM (`getComputedStyle`/`getBoundingClientRect`/`elementFromPoint`) + dev-server log, NOT screenshots (Conv 191: "Duplicate style attribute" named the real bug). Duplicate-`style` JSX gotcha; VT drops island-unique arbitrary utilities.
- [link](reference_chrome_bridge_island_stale_cache.md) — **[BRIDGE-MEM] (Conv 258):** verify client-gated islands via `POST /api/auth/dev-login {email}` + hard navigate + **settle-then-read** (~1.5s, NOT poll-and-break) on `[data-nudge]`. Stale `localStorage['peerloop_user_cache']` flashes wrong-role nudge on first-paint → `[NUDGE-CACHE-FLASH]`. Confirm D1 eligibility first.

## External References
- [link](reference_spt_dual_repo.md) — `spt`/`spt-docs` is a sibling dual-repo at `~/projects/`; `r-end-soft`, `r-end-meta`, `r-start-soft`, `r-start-meta` exist there NOT here. Don't search `peerloop-docs/.claude/skills/` for them.
- [link](reference_staging_url.md) — Staging URL: `peerloop-staging.brian-1dc.workers.dev` (account slug `brian-1dc`, D1 `peerloop-db-staging`); not derivable from wrangler.toml's `<account>` placeholder
- [link](reference_astro_slot_forwarding.md) — Astro Fragment-slot forwarding suppresses child `<slot>FALLBACK` even when the forwarded slot is empty; `Astro.slots.has`+`&&` doesn't restore it. Fix: defaults at layout consumer via ternary inside unconditional Fragments (Conv 175 [MSH-VIZ]).

## Infrastructure / Recovery
- [link](reference_cf_data_recovery.md) — CF recovery floors (Conv 212): **D1** 30d Time Travel (+`d1 export`); **R2** NO versioning → Bucket Locks (WORM) + backup-copy; **KV** no PITR, deletion permanent (SESSION cache-only invariant); **DO** not used. DR = MVP-GOLIVE concern; prevention = [SETTINGS-GUARD].
- [link](feedback_staging_is_deploy_target_prod_gated.md) — Staging is the ONLY deploy target for features; prod undeployed + gated behind MVP-GOLIVE. NEVER `deploy:prod`/`deploy:cron:prod` for features; never auto-answer `confirm-prod.js`. "prod deploy" in a feature task = mis-scoped → fold into MVP-GOLIVE. Conv 262 (reverted same conv).

## Project Context
- [link](project_spacing_snap_over_matt_exception.md) — **SPACING axis (DECIDED Conv 305):** off-scale `@matt-source` spacing SNAPS to nearest 4px step (ties round UP: `gap-[10px]`→`gap-12`, `px-[60px]`→`px-64`) — NOT kept as exception, even when Figma confirms it's Matt's exact value. Overrides §170 for spacing ONLY; Colour keeps exceptions. SoT: migration-ledger §170 carve-out.
- [link](project_role_studios_deconstruct_nudges.md) — **[ROLE-STUDIOS] DECIDED Conv 252:** unified `/dashboard` → role workspaces (`/creating`, `/teaching`) + home triage strip + **MUST-HAVE progression-nudge layer** on SOURCE-role surfaces (never target hub). **Conv 256: 🔴 client wants old-vs-new COMPARISON → do NOT retire UnifiedDashboard/`/old/dashboard`** (blocks Phase 3 retire + Phase 5); Phase 4 nudges next. SoT PLAN.md § ROLE-STUDIOS (6-phase).
- [link](project_matt_phaseout_inspired_default.md) — **Matt phase-out ENDPOINT (Conv 289): Figma now LAYOUT-ONLY (not page specs); CC owns page consistency; tablet=wider-mobile; layout foundation locked ([LAYOUT-SG], `08-layout` §8.3.3).** Earlier (Conv 239): pages default `@matt-inspired` page-by-page, function-FIRST then drape style, NEVER lose `/old/*` function (omit-behavior→**merge**+static data); legacy=behavior-truth.
- [link](project_route_404_honesty_standin.md) — Route migration: unconverted pages must 404 (no redirect layer / no resolving placeholder stubs); stub+convert per-page when its turn comes. `@stand-in` = TRANSIENT marker for legacy-rehost pages (not Matt, not ours) until retrofitted; `grep -rl '@stand-in' src/pages`. Conv 203 (/messages incident); [STANDIN-MATT] task.
- [link](project_old_pages_no_delete_until_vetted.md) — **REVISED Conv 250:** RTMIG-4 ports MOVE `/old/X`→`/X` as `@stand-in` (not copy); `/old` NOT kept live; reference = preflip worktree + git history; rollback = `git revert`. **Supersedes** Conv-221 keep-/old-live rule. 44 already-ported `/old` copies now deletable (follow-up).
- [link](feedback_port_functionality_and_styling.md) — legacy→Matt port = TWO co-equal obligations: faithful **functionality + content** (every field/action/sub-filter/role-view/state) AND full Matt **styling**. Re-skin while dropping behavior = a FAILED port. Diff legacy↔new field-by-field before declaring done (DISC-DROP recipe + all RTMIG-4 ports; Conv 222).
- [link](feedback_route_sweep_pause_protocol.md) — **ROUTE SWEEP (RTMIG-4, Conv 291):** every route = visual-presentation sweep unit (page + ALL subcomponents); 14 `RG-*` group tasks; even already-ported routes swept; **exhaustive, NOT hurried.** Canonical **8-step process**: assess Tier-1 + **assess Tier-2 via `/w-prim-candidates`→ledger (log ALL candidates)** → surface → **PAUSE (no code till cleared)** → do work (ripe extractions) → **browser-verify** (member+visitor; DOM-truth) → **user out-of-scope review → `[<ROUTE>-FIXES]` task** → mark ☑ Swept. SoT `plan/route-migration/README.md` + `tier2-primitive-ledger.md`.
- [link](project_preflip_worktree_reference.md) — Inspect legacy /old look+behavior: `peerloop-ref` alias → pre-flip worktree `~/projects/Peerloop-preflip` (commit 608346a2) on :4331. Machine-LOCAL. Login modal, admin brian@peerloop.com / Peerloop2. Teardown=[PREFLIP-WT].
- [link](project_module_submodule_model.md) — Session↔Module = 1:1; Matt's/Creators' nested "N Modules" = Sub-Modules. Don't build a session→many-modules model. Conv 188 [MOD-SCHEMA].
- [link](project_timezone_confidence.md) — Recurring new Date() issues despite multiple sweeps; user has low confidence in TZ correctness
- [link](project_staging_integration_plan.md) — Expand BBB-VERIFY into full staging block (Stream, Resend, Stripe, BBB); plus-addressed email capture
- [link](project_feeds_hub.md) — Feeds = ~50% learning (client). `/feeds` = Discover destination (DiscoverFeedsGrid + "Your Feeds" role-tabs). **FeedsHub was slated for `/` (Conv 224) but Conv 267 (HOME-FEED-MERGE ph5) UNMOUNTED it — `/` = merged SmartFeed surface now; do NOT re-add FeedsHub/ActionCards/TriageStrip to Home.** Not `/feed` (SmartFeed) / `/course/[slug]/feed`.
- [link](project_obsidian_vault_synced.md) — `~/Obsidian Vaults/main2025/` replicated across M4/M4Pro via Obsidian Sync; one-machine file write propagates — do NOT design skills with per-machine bootstrap steps
- [link](project_scratch_obsidian_symlink.md) — scratch = REAL `_scratch/` dir + `.scratch` compat symlink (peerloop-docs IS an Obsidian vault; Obsidian resolves symlinks + hides dot-targets, so visible dir must be non-dot). Do NOT delete the `.scratch` symlink (all refs resolve through it) or flip it back. Machine-local; re-flip on fresh machine. Conv 300.
- [link](project_ephemeral_dismiss_dev_staging.md) — Dismissible nudges/recs reappear every reload in dev+staging BY DESIGN (`ephemeral-dismiss.ts` `readDismissed()`); "dismiss doesn't stick on staging" is EXPECTED, do NOT re-persist. Conv 292.
- [link](project_settings_tier_local_control.md) — Settings: project `settings.json` + machine-local `settings.local.json` (global deprecated); keep project file PORTABLE (`Read(/**)`, not abs paths). **[SETTINGS-GUARD]**: broad allow + `permissions.ask` + PreToolUse `guard-dangerous-bash.sh` (`wrangler --remote`, `DROP TABLE`, `git push --force`). Conv 212; restart → [GUARD-VERIFY].
- [link](project_jfg_dev_branches_are_snapshots.md) — `jfg-dev-NN` code branches (jfg-dev-2…14, `-matt` variants) are intentional point-in-time SNAPSHOTS kept on purpose — NEVER propose `git branch -d` sweeps as "stale cleanup" nor flag ancestor/duplicate branches deletable. Active = current checkout; older = reference. Conv 292 ([DEV13-RM] mistake).

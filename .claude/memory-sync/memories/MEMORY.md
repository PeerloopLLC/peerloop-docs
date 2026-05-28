# Peerloop Project Memory

## User Workflow
- [user_hands_off_pilot_workflow.md](user_hands_off_pilot_workflow.md) — User does NOT edit project files directly; CC is sole author. Skill/sync/drift designs can trust state at SessionStart — do NOT defend against arbitrary out-of-band edits ([MSI], state files, tech-doc-drift).

## Dual-Repo Shell Discipline
- [feedback_git_dash_c_enforcement.md](feedback_git_dash_c_enforcement.md) — Always `git -C ~/projects/peerloop-docs ...` / `git -C ~/projects/Peerloop ...` (tilde-literal, not `$CLAUDE_PROJECT_DIR` — `$VAR` triggers `simple_expansion` prompt, tilde doesn't); bare git lands in wrong repo after `cd ../Peerloop && npm ...` cwd drift (Conv 109; Conv 162 tilde-sweep).
- [project_route_gen_cross_repo.md](project_route_gen_cross_repo.md) — route-doc regen (`route-api-map.mjs`/`route-matrix.mjs`) writes BOTH repos: code `tests/plato/route-map.generated.ts` + docs route docs/TSVs; `git status` both before committing (Conv 201)

## Icon System
- **Astro path registry** (`src/lib/icon-paths.ts`): 39 entries (5 dir + 4 nav + 4 people + 4 content + 16 obj + 3 community + 3 brand). React: `icons.tsx` ~96 exports; brand: `brand-icons.tsx` (Google/GitHub/Stripe/Twitter/LinkedIn/YouTube/Instagram). Astro pattern `<Icon name="profile" class="w-6 h-6 text-purple-600" />`; React pattern `({ className = 'h-5 w-5' }: IconProps)`.
- **Matt registry** (`src/components/matt/icons/MattIcon.tsx` + `svg/*.svg`): **53 SVGs** via Vite `?raw` glob, fills normalized to `currentColor`. MattIcon wrapper is `fill="none"`, so harvested paths MUST carry `fill="currentColor"`; unknown name → dashed placeholder. Conv 193 [NAV-ICON-SWAP] added 10 Material-outlined for legacy-nav retrofit (menu, search, admin-panel-settings, chevron-right, group, label, assignment, videocam, warning, person-add).

## Test Suite
- [feedback_full_test_output.md](feedback_full_test_output.md) — Full test suite: `cd ../Peerloop && npm test 2>&1 | tee /tmp/lastFullTestRun.log`; tail 15-20 lines; run strategically (~3min cost); use `--testNamePattern` for iterative fixes. Test DB = better-sqlite3 (all machines).
- [e2e-testing-patterns.md](e2e-testing-patterns.md) — After `page.goto()` add `waitForLoadState('networkidle')` for Astro `client:load` islands (else buttons visible-but-not-interactive under parallel load); full E2E suite needs `npm run db:setup:local` headroom against cross-test write contamination

## Development Environment
- [feedback_db_setup_shorthand.md](feedback_db_setup_shorthand.md) — "run the {local/staging} D1 {level} script" → `npm run db:setup:{target}:{level}`. Machine name in commits from `~/.claude/.machine-name`.

## Navigation Architecture
- **AppLayout (Matt shell)** is the canonical layout since ROUTE-FLIP (Conv 197); **LegacyAppLayout/AppHeader/AppNavbar** still wrap `/old/*`. When adding routes, mind which shell + check `startsWith` active-matching for sub-routes.

## Testing Preferences
- [feedback_no_test_artifacts_in_prod.md](feedback_no_test_artifacts_in_prod.md) — No dev-only testing infra in production code; use two browser vendors for multi-user testing
- [feedback_test_import_cleanup.md](feedback_test_import_cleanup.md) — After writing a test file, quick-pass to remove unused imports/variables before moving on

## Output Formatting
- [feedback_conversational_brevity.md](feedback_conversational_brevity.md) — Match response length to question length. Short conversational questions → short answers. "Need to dig deeper first" is acceptable. Don't auto-expand into A/B/C frameworks unless invited. [MCFRAME]: when user steers with specifics, execute — don't bounce back as MC question.
- [feedback_pointing_emoji_prefix.md](feedback_pointing_emoji_prefix.md) — Stub pointer: 👉👉👉 + bold rule lives in CLAUDE.md §User-Facing Questions. Memory-grep anchor for "pointing" / "bold question" searches.
- [feedback_option_phrasing.md](feedback_option_phrasing.md) — Stub pointer: A) B) C) labels rule lives in CLAUDE.md §User-Facing Questions. File preserves Conv 132 / Conv 147 motivating-incident archaeology.
- [feedback_pause_on_pointing_questions.md](feedback_pause_on_pointing_questions.md) — 👉👉👉 must be the last visible content; do independent work FIRST, then ask, then stop
- [feedback_visual_issue_alerts.md](feedback_visual_issue_alerts.md) — Stub pointer: 🔴🔴🔴 / 🟠🟠🟠 rule lives in CLAUDE.md §Issue Surfacing. Memory-grep anchor so issue-alert searches still resolve.

## Solution Quality
- [feedback_no_simplest_fix.md](feedback_no_simplest_fix.md) — **Core principle:** favour durable decisions over faster options. Lean durable when deciding; break only with sound reasons.
- [feedback_default_durable_no_ask.md](feedback_default_durable_no_ask.md) — Quick/durable: rule lives in CLAUDE.md §Solution Quality + §Critical Rule (size ≠ novelty). File retains multi-conv-scope counter-case + Conv 131 TDS-AUTH precedent.
- [feedback_audit_surface_findings_first.md](feedback_audit_surface_findings_first.md) — **Investigative framings** (audit/review/investigate/examine/classify/analyze/scan/explore/survey, "what could be done about", "look at") → surface per-item dispositions + 👉👉👉 BEFORE writes; **overrides** §Solution Quality default-proceed + §Critical Rule size-≠-novelty because user can't anticipate findings. Picking an option within an audit framing authorizes the *approach*, not the execution. Conv 206 [MEM-AUDIT]: user picked C=full MEMORY.md audit, CC executed end-to-end — user: *"I cannot know what you will find."*
- [feedback_routing_addressability_first.md](feedback_routing_addressability_first.md) — Route shape: decide ADDRESSABILITY (needs jump-to/deep-link/redirect URL?) NOT page-count. Addressability ≠ separate files. Hard-yes: external redirect (Stripe `success_url`), notification deep-link, entity-by-id. No: transient confirmations → overlays. (Conv 187 [MATT-EXEC-FLAGS])
- [feedback_tokenize_only_matt_variables.md](feedback_tokenize_only_matt_variables.md) — **Token-ify what Matt tokenized; hardcode what Matt hardcoded; scaffold what Matt hasn't categorized.** Probe: if value appears in `get_design_context` CSS but NOT in `get_variable_defs`, keep hardcoded inline (no invented `--note-yellow`). Honest-orphan principle (Conv 181 [NOTE-YELLOW]).

## Docs Awareness
- [feedback_check_docs_on_how_questions.md](feedback_check_docs_on_how_questions.md) — On "how does X work" questions, check docs too; offer doc update if answer required heavy searching

## External Source-of-Truth
- [feedback_external_source_of_truth_first.md](feedback_external_source_of_truth_first.md) — Consult/probe authoritative sources BEFORE inferring. 4 contexts: vendor MCP/SDK docs via `WebFetch` (Conv 179 [VDF]); designer-supplied catalogues over visual ID (Conv 178 [MFM]); user-supplied source files canonical, ask BEFORE drilling (Conv 178 [STOR][DTU]); probe external tool BEFORE recommending (Conv 180 [EMP]: one tool call beats one rework cycle).

## Memory Discipline
- [feedback_check_memory_before_directive_save.md](feedback_check_memory_before_directive_save.md) — Before offering to save a directive, grep the memory dir for an existing entry on the same topic
- [feedback_resume_state_as_todowrite_persistence.md](feedback_resume_state_as_todowrite_persistence.md) — RESUME-STATE.md is just TodoWrite persistence across convs; user never interacts with it directly
- [feedback_confirmations_stand_unless_revoked.md](feedback_confirmations_stand_unless_revoked.md) — User-confirmed sub-decisions survive later topic-level pivots; treat confirmations as sticky until user names the item to revoke
- [feedback_memory_index_load_bearing.md](feedback_memory_index_load_bearing.md) — MEMORY.md one-liners must expose distinctive markers (`👉👉👉`, `A) B) C)`, `tee /tmp/...`), triggers, anti-patterns — not just topic labels (Conv 151 [ILS]). Re-read+reconcile MEMORY.md line after every memory file edit (Conv 151 [ILS-AUDIT]).
- [feedback_msi_sync_user_checkpoint.md](feedback_msi_sync_user_checkpoint.md) — /r-start Step 5.7 ALWAYS pauses on non-empty `diff -rq` mirror vs live: yes/no for incoming changes, A/B/C + auto-backup on `Only in $LIVE` data-loss; rule lives in skill code; reverse (live→mirror) safe (Conv 155-156)

## Skill Execution
- [feedback_always_r_end.md](feedback_always_r_end.md) — Autonomous /r-commit OK; /r-end always requires user approval (Conv 108)
- [feedback_rend_complete_all_steps.md](feedback_rend_complete_all_steps.md) — **RECURRING FAILURE:** /r-end must execute ALL 8 steps without stopping after /r-eos (Conv 006, 019, 026, 027)
- [feedback_rend_todowrite_alerts.md](feedback_rend_todowrite_alerts.md) — /r-end Step 4: every 🔴/🟠 alert MUST call TaskCreate, not just display
- [feedback_post_rend_fixes.md](feedback_post_rend_fixes.md) — Post /r-end fixes: /r-start (no /clear) → fix → /r-end. No gates or topup skills needed.
- [feedback_uncategorized_filtering.md](feedback_uncategorized_filtering.md) — Extract §Uncategorized: if writing "not a bug" or "no action needed", it doesn't belong there
- [feedback_verify_baselines_in_conv.md](feedback_verify_baselines_in_conv.md) — Conv 101→102 incident pointer (5 silently-broken time-fragile tests inherited via unverified carry-forward); rule lives in CLAUDE.md §Baseline Verification
- [feedback_baseline_includes_astro_check.md](feedback_baseline_includes_astro_check.md) — Conv 104 incident pointer (10 .astro errors hidden across Convs 100–103 because astro check wasn't in baseline); rule lives in CLAUDE.md §Baseline Verification
- [feedback_exploration_pacing.md](feedback_exploration_pacing.md) — After Phase 1 establishes patterns (file structure, API, test, component), Phase N+1 jumps straight to writing code; do NOT re-explore (Conv 057: >1hr lost re-exploring before AdminCourseTab)
- [feedback_plan_mode_usage.md](feedback_plan_mode_usage.md) — Use CC Plan Mode to stress-test designs AFTER discussion, not just for proposing approaches
- [feedback_plan_persistence.md](feedback_plan_persistence.md) — CC Plan Mode files are ephemeral; persist plans to committed files before /r-end
- [feedback_skill_sync_same_name_divergence.md](feedback_skill_sync_same_name_divergence.md) — Same-named skills across projects often diverge structurally — default to "evolve independently" recommendation
- [feedback_heuristic_calibration.md](feedback_heuristic_calibration.md) — New detection heuristic/threshold/gate from qualitative guidance MUST be run against memo's canonical case BEFORE commit; if it doesn't fire there, threshold wrong OR signal incomplete (Conv 142 [CMH]: `/w-sync-skills` Jaccard `< 0.70` returned `1.000` on canonical DIVERGED case).

## Work Tracking
- [feedback_surface_and_track_all_issues.md](feedback_surface_and_track_all_issues.md) — Never silently skip issues; always TodoWrite anything not immediately resolved
- [feedback_cleanup_step.md](feedback_cleanup_step.md) — Every PLAN block must end with a Cleanup phase (check off RFCs, reset temp files, remove scaffolding)
- [feedback_mnemonic_collision.md](feedback_mnemonic_collision.md) — Append sequential numbers to mnemonic codes on collision (e.g., [GE] → [GE2])
- [feedback_codecheck_todos.md](feedback_codecheck_todos.md) — Never dismiss codecheck findings as "pre-existing"; always TodoWrite them
- [feedback_todowrite_mnemonic_codes.md](feedback_todowrite_mnemonic_codes.md) — Every TaskCreate subject starts with a unique 2-3 letter bracketed code (e.g., `[PL] Plan update`); user references tasks by code
- [feedback_infra_vs_deliverable.md](feedback_infra_vs_deliverable.md) — Building test infra: pause to check if approach is generalizable or special-cased; surface dual goals early
- [feedback_watch_task_assumptions.md](feedback_watch_task_assumptions.md) — Watch-tasks must state the assumed delivery/load precondition in subject ("watching X **assuming** Y is loaded on machine Z"); audit at watch-end falsifies the precondition FIRST before debating content (Conv 149→150 [OPW]).

## Security & Secrets
- [feedback_no_paste_tokens_in_chat.md](feedback_no_paste_tokens_in_chat.md) — Block secrets reaching chat from BOTH directions: user-paste AND Claude-initiated diagnostic dumps like `stripe config --list` / `od -c` / `cat .dev.vars`
- [feedback_never_modify_figma.md](feedback_never_modify_figma.md) — Figma is READ-ONLY for CC. Never call `mcp__figma__use_figma`/`create_new_file`/`upload_assets`/`add_code_connect_map` or any write-shaped tool. Translation runs Figma → code only. (Conv 183 [MNV] explicit user rule)
- [feedback_reuse_existing_components.md](feedback_reuse_existing_components.md) — Before rendering any Figma frame/page/component, scan its `<instance>` children, map each to existing code components, IMPORT and USE them. Never inline a duplicate of an existing primitive. Astro CAN render React components as static HTML. (Conv 184 explicit user rule)

## PLATO / Browser Testing
- [plato-context.md](plato-context.md) — **Load when** PLATO, browser-run, STUMBLE-AUDIT, or BrowserIntent is discussed — terminology, execution modes, nav link caveats, screenshot conventions
- [feedback_plato_browser_mode.md](feedback_plato_browser_mode.md) — Browser-runs execute through /chrome MCP bridge, not Playwright; pageAction is prose by design
- [feedback_plato_stumble_terminology.md](feedback_plato_stumble_terminology.md) — PLATO is the system; "API-run [instance]" / "browser-run [instance]" are the run forms; STUMBLE-AUDIT is a project block, not a system
- [feedback_nav_link_existence.md](feedback_nav_link_existence.md) — Browser-runs must verify nav links exist before clicking — some are conditional (e.g., /onboarding hidden after first tag selection)
- [feedback_stumble_screenshots.md](feedback_stumble_screenshots.md) — When user says "with screenshots", capture PNGs at each BrowserIntent checkpoint via macOS `screencapture -x`
- [feedback_dom_truth_over_screenshots.md](feedback_dom_truth_over_screenshots.md) — Precise layout/position/visibility: trust DOM (`getComputedStyle`/`getBoundingClientRect`/`elementFromPoint`) + dev-server log, NOT screenshots (Conv 191: "Duplicate style attribute" named the real bug). Duplicate-`style` JSX gotcha; VT drops island-unique arbitrary utilities.

## External References
- [reference_spt_dual_repo.md](reference_spt_dual_repo.md) — `spt`/`spt-docs` is a sibling dual-repo at `~/projects/`; `r-end-soft`, `r-end-meta`, `r-start-soft`, `r-start-meta` exist there NOT here. Don't search `peerloop-docs/.claude/skills/` for them.
- [reference_staging_url.md](reference_staging_url.md) — Staging URL: `peerloop-staging.brian-1dc.workers.dev` (account slug `brian-1dc`, D1 `peerloop-db-staging`); not derivable from wrangler.toml's `<account>` placeholder
- [reference_astro_slot_forwarding.md](reference_astro_slot_forwarding.md) — Astro `<Fragment slot="x"><slot name="y" /></Fragment>` forwarding suppresses child's `<slot name="x">FALLBACK</slot>` even when slot `y` is empty; `Astro.slots.has` + `&&` short-circuit doesn't restore fallback. Fix: defaults at layout consumer via ternary inside unconditional Fragments (Conv 175 [MSH-VIZ]).
- [reference_figma_mcp_behavior.md](reference_figma_mcp_behavior.md) — Figma Remote MCP: **ALL read tools selection-free with explicit nodeId** (`get_metadata`/`get_design_context`/`get_variable_defs`/`get_screenshot`/`get_libraries`/`search_design_system`); asset URLs return SVG for vector sources (expire 7d); local-file Variables INVISIBLE to library tools; Variable Mode bakes into CSS-var fallback hex (`var(--background,#hex)`); `data-name` = translation key; Dev seat sufficient (verified Convs 180-187).

## Project Context
- [project_route_404_honesty_standin.md](project_route_404_honesty_standin.md) — Route migration: unconverted pages must 404 (no redirect layer / no resolving placeholder stubs); stub+convert per-page when its turn comes. `@stand-in` = TRANSIENT marker for legacy-rehost pages (not Matt, not ours) until retrofitted; `grep -rl '@stand-in' src/pages`. Conv 203 (/messages incident); [STANDIN-MATT] task.
- [project_preflip_worktree_reference.md](project_preflip_worktree_reference.md) — To inspect legacy /old look+behavior: `peerloop-ref` alias → pre-flip worktree `~/projects/Peerloop-preflip` (commit 608346a2=846bab9f^) on :4331 (legacy at root, Matt at /matt). Machine-LOCAL. Login modal, admin brian@peerloop.com / Peerloop2. Teardown=[PREFLIP-WT].
- [project_module_submodule_model.md](project_module_submodule_model.md) — Session↔Module is 1:1; Matt's/Creators' nested "N Modules" = Sub-Modules. Don't build a session→many-modules data model. Resolves Conv 188 [MOD-SCHEMA].
- [project_timezone_confidence.md](project_timezone_confidence.md) — Recurring new Date() issues despite multiple sweeps; user has low confidence in TZ correctness
- [project_staging_integration_plan.md](project_staging_integration_plan.md) — Expand BBB-VERIFY into full staging block (Stream, Resend, Stripe, BBB); plus-addressed email capture
- [project_feeds_hub.md](project_feeds_hub.md) — FEEDS-HUB: Client says feeds = 50% of learning; composite `/feeds` page needed (READY — unblocked Conv 015)
- [project_obsidian_vault_synced.md](project_obsidian_vault_synced.md) — `~/Obsidian Vaults/main2025/` replicated across M4/M4Pro via Obsidian Sync; one-machine file write propagates — do NOT design skills with per-machine bootstrap steps
- [project_matt_collaboration_style.md](project_matt_collaboration_style.md) — Matt (designer) keeps ALL working material in Figma — specs, notes, decisions, value-prop exploration. WE produce markdown specs from Figma probes, not the other way around. "Ready for Dev" status = visual green-banner labels, not API-readable.

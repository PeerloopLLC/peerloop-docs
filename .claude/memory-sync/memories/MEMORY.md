# Peerloop Project Memory

## User Workflow
- [link](user_hands_off_pilot_workflow.md) — User does NOT edit project files directly; CC is sole author. Skill/sync/drift designs can trust state at SessionStart — do NOT defend against arbitrary out-of-band edits ([MSI], state files, tech-doc-drift).

## Dual-Repo Shell Discipline
- [link](feedback_git_dash_c_enforcement.md) — Always `git -C ~/projects/peerloop-docs ...` / `git -C ~/projects/Peerloop ...` (tilde-literal, not `$CLAUDE_PROJECT_DIR` — `$VAR` triggers `simple_expansion` prompt, tilde doesn't); bare git lands in wrong repo after `cd ../Peerloop && npm ...` cwd drift (Conv 109; Conv 162 tilde-sweep).
- [link](project_route_gen_cross_repo.md) — route-doc regen (`route-api-map.mjs`/`route-matrix.mjs`) writes BOTH repos: code `tests/plato/route-map.generated.ts` + docs route docs/TSVs; `git status` both before committing (Conv 201)

## Icon System
- [link](reference_icon_system.md) — Two icon systems: **Astro path registry** (`src/lib/icon-paths.ts`, 39 entries) + React `icons.tsx`/`brand-icons.tsx`; **Matt MattIcon registry** (`@components/icons/MattIcon`, 54 SVGs auto-registered from `svg/`, fills MUST be `fill="currentColor"` since wrapper is `fill="none"`, unknown name → dashed placeholder). Conv 212 added `lock`.

## Test Suite
- [link](feedback_full_test_output.md) — Full test suite: `cd ../Peerloop && npm test 2>&1 | tee /tmp/lastFullTestRun.log`; tail 15-20 lines; run strategically (~3min cost); use `--testNamePattern` for iterative fixes. Test DB = better-sqlite3 (all machines).
- [link](e2e-testing-patterns.md) — After `page.goto()` add `waitForLoadState('networkidle')` for Astro `client:load` islands (else buttons visible-but-not-interactive under parallel load); full E2E suite needs `npm run db:setup:local` headroom against cross-test write contamination

## Development Environment
- [link](feedback_db_setup_shorthand.md) — "run the {local/staging} D1 {level} script" → `npm run db:setup:{target}:{level}`. Machine name in commits from `~/.claude/.machine-name`.

## Navigation Architecture
- **AppLayout (Matt shell)** is the canonical layout since ROUTE-FLIP (Conv 197); **LegacyAppLayout/AppHeader/AppNavbar** still wrap `/old/*`. When adding routes, mind which shell + check `startsWith` active-matching for sub-routes.

## Testing Preferences
- [link](feedback_no_test_artifacts_in_prod.md) — No dev-only testing infra in production code; use two browser vendors for multi-user testing
- [link](feedback_test_import_cleanup.md) — After writing a test file, quick-pass to remove unused imports/variables before moving on

## Output Formatting
- [link](feedback_conversational_brevity.md) — Match response length to question length. Short conversational questions → short answers. "Need to dig deeper first" is acceptable. Don't auto-expand into A/B/C frameworks unless invited. [MCFRAME]: when user steers with specifics, execute — don't bounce back as MC question.
- [link](feedback_pointing_emoji_prefix.md) — Stub pointer: 👉👉👉 + bold rule lives in CLAUDE.md §User-Facing Questions. Memory-grep anchor for "pointing" / "bold question" searches.
- [link](feedback_option_phrasing.md) — **NEVER** ask `"X, or Y?"` as the primary question — reads as yes/no. **ALWAYS** A) B) labels above the 👉, even for binary non-yes/no picks. Recurring failure at least once per conv (Convs 132/147/208). Rule lives in CLAUDE.md §User-Facing Questions + §Recurring Failures.
- [link](feedback_pause_on_pointing_questions.md) — 👉👉👉 must be the last visible content; do independent work FIRST, then ask, then stop
- [link](feedback_visual_issue_alerts.md) — Stub pointer: 🔴🔴🔴 / 🟠🟠🟠 rule lives in CLAUDE.md §Issue Surfacing. Memory-grep anchor so issue-alert searches still resolve.
- [link](feedback_mirror_term_annotation.md) — When CC says "mirror" (memory-sync mirror), append "(from last r-end)" — bare term hard for user to rationalize; mirror = whatever prev conv's /r-end pushed (live→mirror snapshot). Conv 228.

## Tool-Call Discipline
- [link](feedback_no_tool_call_spam_loops.md) — **RECURRING FAILURE:** tool result is authoritative on FIRST return; empty=empty. NEVER re-issue an identical call to "flush a buffer" — no flush exists; repeats just re-run + duplicate output (Conv 218: ~420K/~10min spamming `Read RESUME-STATE.md` ×25). Max one retry, with a reason. Light interaction + climbing tokens → suspect a loop, halt. **[TERM-GARBLE] carve-out (Conv 227):** empty-in-UI ≠ truly-empty under the upstream cascade bug — on a *suspicious* empty (just wrote a file / cmd had side effects), verify OUT-OF-BAND (`wc -c`/`git status`/`ls`), don't re-spam; never narrate un-received output.
- [link](reference_term_garble_upstream_bug.md) — **[TERM-GARBLE] root-caused (Conv 227):** the Conv-226 blank/partial tool-output renders + fabricated-failure narration = a known OPEN upstream Claude Code bug cluster (#22264 parallel cascade-cancel → #63966/#63859/#63797 empty/late/out-of-order results; #63538 model confabulation). Trigger = Opus 4.8 + parallel batch + ANY sibling fail (incl. our `guard-dangerous-bash.sh` PreToolUse hook). NOT a Peerloop bug. 2.1.159 unfixed → assume exposed; `[GARBLE-WATCH]`. Mitigations: narrower batches, out-of-band verify, never narrate un-received output.

## Solution Quality
- [link](feedback_no_simplest_fix.md) — **Core principle:** favour durable decisions over faster options. Lean durable when deciding; break only with sound reasons.
- [link](feedback_default_durable_no_ask.md) — Quick/durable: rule lives in CLAUDE.md §Solution Quality + §Critical Rule (size ≠ novelty). File retains multi-conv-scope counter-case + Conv 131 TDS-AUTH precedent.
- [link](feedback_audit_surface_findings_first.md) — Investigative-framing verbs (audit/review/investigate/analyze/explore/scan/"look at"/"what could be done about") → surface per-item dispositions + 👉👉👉 BEFORE writes; **overrides** §Solution Quality default-proceed + §Critical Rule size-≠-novelty. Picking an option authorizes the *approach*, not the execution. Conv 206 [MEM-AUDIT].
- [link](feedback_routing_addressability_first.md) — Route shape: decide ADDRESSABILITY (needs deep-link/redirect URL?) NOT page-count; ≠ separate files. Hard-yes: Stripe `success_url`, notification deep-link, entity-by-id. No: transient confirmations → overlays. (Conv 187 [MATT-EXEC-FLAGS])
- [link](feedback_tokenize_only_matt_variables.md) — **Token-ify what Matt tokenized; hardcode what he hardcoded; scaffold the uncategorized.** Probe: in `get_design_context` CSS but NOT `get_variable_defs` → keep hardcoded inline. Honest-orphan principle (Conv 181 [NOTE-YELLOW]).

## Docs Awareness
- [link](feedback_check_docs_on_how_questions.md) — On "how does X work" questions, check docs too; offer doc update if answer required heavy searching

## External Source-of-Truth
- [link](feedback_external_source_of_truth_first.md) — Probe authoritative sources BEFORE inferring: vendor MCP/SDK docs via `WebFetch` ([VDF]), designer catalogues over visual ID ([MFM]), user-supplied source files canonical — ask before drilling ([STOR][DTU]), probe external tool before recommending ([EMP]). Convs 178-180.
- [link](feedback_read_legacy_source_before_conclusion.md) — Review/compare/port/parity → fully read BOTH sides, esp. the legacy `/old` source-of-truth, BEFORE concluding. "Already in context" = genuine full read THIS conv only, never a summary/agent-digest/assumption. NO directive permits skipping a full check; `feedback_exploration_pacing` is NOT a skip-license. (Conv 222: twice called role tabs "just filters, at parity" reading only the new components.)

## Memory Discipline
- [link](feedback_check_memory_before_directive_save.md) — Before offering to save a directive, grep the memory dir for an existing entry on the same topic
- [link](feedback_resume_state_as_todowrite_persistence.md) — RESUME-STATE.md is just TodoWrite persistence across convs; user never interacts with it directly. **Crash recovery (Conv 219):** `.scratch/conv-tasks.md` survives mid-conv (RESUME-STATE is deleted by /r-start Step 7) → it's the restore source. Resume-without-r-start → rehydrate TodoWrite from conv-tasks.md FIRST; /r-start Step 7 now has a crash-survivor branch + Step 7.5 no-shrink backstop.
- [link](feedback_conv_tasks_live_sync.md) — Keep `.scratch/conv-tasks.md` live-synced with TodoWrite DURING the conv: on TaskUpdate→completed prepend `*DONE* ` to the row's meaning column (never delete the row); on TaskCreate add a row. User keeps it open in VS Code. Conv 228.
- [link](feedback_confirmations_stand_unless_revoked.md) — User-confirmed sub-decisions survive later topic-level pivots; treat confirmations as sticky until user names the item to revoke
- [link](feedback_memory_index_load_bearing.md) — MEMORY.md one-liners must expose distinctive markers (`👉👉👉`, `A) B) C)`, `tee /tmp/...`), triggers, anti-patterns — not just topic labels (Conv 151 [ILS]). Re-read+reconcile MEMORY.md line after every memory file edit (Conv 151 [ILS-AUDIT]). Pointer display label = constant `[link]`, never filename-echo; don't rename sub-files (Conv 213).
- [link](feedback_msi_sync_user_checkpoint.md) — /r-start Step 5.7 ALWAYS pauses on non-empty `diff -rq` mirror vs live: yes/no for incoming changes, A/B/C + auto-backup on `Only in $LIVE` data-loss; rule lives in skill code; reverse (live→mirror) safe (Conv 155-156)

## Skill Execution
- [link](feedback_skill_body_stale_after_self_pull.md) — A skill's in-context body is a pre-pull SNAPSHOT; if Step 2's pull updates SKILL.md, re-read the on-disk file before later steps (Conv 218: Step 7.5 silently skipped). `/r-start` Step 2.5 now auto-detects via `HEAD@{1}` diff. Staleness ≠ truncation. Applies to any self-pulling skill.
- [link](feedback_always_r_end.md) — Autonomous /r-commit OK; /r-end always requires user approval (Conv 108)
- [link](feedback_rend_complete_all_steps.md) — **RECURRING FAILURE:** /r-end must execute ALL 8 steps without stopping after /r-eos (Conv 006, 019, 026, 027)
- [link](feedback_rend_todowrite_alerts.md) — /r-end Step 4: every 🔴/🟠 alert MUST call TaskCreate, not just display
- [link](feedback_post_rend_fixes.md) — Post /r-end fixes: /r-start (no /clear) → fix → /r-end. No gates or topup skills needed.
- [link](feedback_uncategorized_filtering.md) — Extract §Uncategorized: if writing "not a bug" or "no action needed", it doesn't belong there
- [link](feedback_verify_baselines_in_conv.md) — Conv 101→102 incident pointer (5 silently-broken time-fragile tests inherited via unverified carry-forward); rule lives in CLAUDE.md §Baseline Verification
- [link](feedback_baseline_includes_astro_check.md) — Conv 104 incident pointer (10 .astro errors hidden across Convs 100–103 because astro check wasn't in baseline); rule lives in CLAUDE.md §Baseline Verification
- [link](feedback_codecheck_moment_includes_tests_and_build.md) — `/w-codecheck` trigger = decision point: also decide per-change whether to add prov-sweep + test suite + build (none auto-bundled). Anti-pattern: inline `tsc + lint + astro check` skipping `/w-codecheck` (bypasses Peerloop bug-class checks + the decision menu). Conv 207.
- [link](feedback_exploration_pacing.md) — After Phase 1 establishes patterns (file structure, API, test, component), Phase N+1 jumps straight to writing code; do NOT re-explore (Conv 057: >1hr lost re-exploring before AdminCourseTab)
- [link](feedback_plan_mode_usage.md) — Use CC Plan Mode to stress-test designs AFTER discussion, not just for proposing approaches
- [link](feedback_plan_persistence.md) — CC Plan Mode files are ephemeral; persist plans to committed files before /r-end
- [link](feedback_skill_sync_same_name_divergence.md) — Same-named skills across projects often diverge structurally — default to "evolve independently" recommendation
- [link](feedback_heuristic_calibration.md) — New detection heuristic/threshold/gate from qualitative guidance MUST be run against memo's canonical case BEFORE commit; if it doesn't fire there, threshold wrong OR signal incomplete (Conv 142 [CMH]: `/w-sync-skills` Jaccard `< 0.70` returned `1.000` on canonical DIVERGED case).

## Work Tracking
- [link](feedback_surface_and_track_all_issues.md) — Never silently skip issues; always TodoWrite anything not immediately resolved
- [link](feedback_cleanup_step.md) — Every PLAN block must end with a Cleanup phase (check off RFCs, reset temp files, remove scaffolding)
- [link](feedback_mnemonic_collision.md) — Append sequential numbers to mnemonic codes on collision (e.g., [GE] → [GE2])
- [link](feedback_codecheck_todos.md) — Never dismiss codecheck findings as "pre-existing"; always TodoWrite them
- [link](feedback_todowrite_mnemonic_codes.md) — Every TaskCreate subject starts with a unique 2-3 letter bracketed code (e.g., `[PL] Plan update`); user references tasks by code
- [link](feedback_infra_vs_deliverable.md) — Building test infra: pause to check if approach is generalizable or special-cased; surface dual goals early
- [link](feedback_watch_task_assumptions.md) — Watch-tasks must state the assumed delivery/load precondition in subject ("watching X **assuming** Y is loaded on machine Z"); audit at watch-end falsifies the precondition FIRST before debating content (Conv 149→150 [OPW]).

## Security & Secrets
- [link](feedback_no_paste_tokens_in_chat.md) — Block secrets reaching chat from BOTH directions: user-paste AND Claude-initiated diagnostic dumps like `stripe config --list` / `od -c` / `cat .dev.vars`
- [link](feedback_never_modify_figma.md) — Figma is READ-ONLY for CC. Never call `mcp__figma__use_figma`/`create_new_file`/`upload_assets`/`add_code_connect_map` or any write-shaped tool. Translation runs Figma → code only. (Conv 183 [MNV] explicit user rule)
- [link](feedback_reuse_existing_components.md) — Before rendering any Figma frame/page/component, scan its `<instance>` children, map each to existing code components, IMPORT and USE them. Never inline a duplicate of an existing primitive. Astro CAN render React components as static HTML. (Conv 184 explicit user rule)

## PLATO / Browser Testing
- [link](plato-context.md) — **Load when** PLATO, browser-run, STUMBLE-AUDIT, or BrowserIntent is discussed — terminology, execution modes, nav link caveats, screenshot conventions
- [link](feedback_plato_browser_mode.md) — Browser-runs execute through /chrome MCP bridge, not Playwright; pageAction is prose by design
- [link](feedback_plato_stumble_terminology.md) — PLATO is the system; "API-run [instance]" / "browser-run [instance]" are the run forms; STUMBLE-AUDIT is a project block, not a system
- [link](feedback_nav_link_existence.md) — Browser-runs must verify nav links exist before clicking — some are conditional (e.g., /onboarding hidden after first tag selection)
- [link](feedback_stumble_screenshots.md) — When user says "with screenshots", capture PNGs at each BrowserIntent checkpoint via macOS `screencapture -x`
- [link](feedback_dom_truth_over_screenshots.md) — Precise layout/position/visibility: trust DOM (`getComputedStyle`/`getBoundingClientRect`/`elementFromPoint`) + dev-server log, NOT screenshots (Conv 191: "Duplicate style attribute" named the real bug). Duplicate-`style` JSX gotcha; VT drops island-unique arbitrary utilities.

## External References
- [link](reference_spt_dual_repo.md) — `spt`/`spt-docs` is a sibling dual-repo at `~/projects/`; `r-end-soft`, `r-end-meta`, `r-start-soft`, `r-start-meta` exist there NOT here. Don't search `peerloop-docs/.claude/skills/` for them.
- [link](reference_staging_url.md) — Staging URL: `peerloop-staging.brian-1dc.workers.dev` (account slug `brian-1dc`, D1 `peerloop-db-staging`); not derivable from wrangler.toml's `<account>` placeholder
- [link](reference_astro_slot_forwarding.md) — Astro Fragment-slot forwarding suppresses child `<slot>FALLBACK` even when the forwarded slot is empty; `Astro.slots.has`+`&&` doesn't restore it. Fix: defaults at layout consumer via ternary inside unconditional Fragments (Conv 175 [MSH-VIZ]).
- [link](reference_figma_mcp_behavior.md) — Figma Remote MCP: ALL read tools selection-free with explicit nodeId; asset URLs return SVG (expire 7d); local-file Variables INVISIBLE to library tools; Variable Mode bakes CSS-var fallback hex; `data-name` = translation key; Dev seat sufficient (Convs 180-187).

## Infrastructure / Recovery
- [link](reference_cf_data_recovery.md) — CF recovery floors (Conv 212): **D1** 30d Time Travel (+`d1 export`); **R2** NO versioning → Bucket Locks (WORM) + backup-copy; **KV** no PITR, deletion permanent (SESSION cache-only invariant); **DO** not used. DR = MVP-GOLIVE concern; prevention = [SETTINGS-GUARD].

## Project Context
- [link](project_route_404_honesty_standin.md) — Route migration: unconverted pages must 404 (no redirect layer / no resolving placeholder stubs); stub+convert per-page when its turn comes. `@stand-in` = TRANSIENT marker for legacy-rehost pages (not Matt, not ours) until retrofitted; `grep -rl '@stand-in' src/pages`. Conv 203 (/messages incident); [STANDIN-MATT] task.
- [link](project_old_pages_no_delete_until_vetted.md) — **NEVER delete an `/old/*` legacy page** until ALL pages converted AND client-vetted. "Retire /old/<x>" = repoint hrefs ONLY (`/discover/communities`→`/communities`); leave /old live as reference/fallback. Bulk /old deletion is a single end-of-migration step, NOT per-page. ≠ deleting fake-demo stubs (Conv 203, that's fine). User emphatic, Conv 221.
- [link](feedback_port_functionality_and_styling.md) — A legacy→Matt port = TWO co-equal obligations: faithful **functionality + content transfer** (every field/action/sub-filter/role-view/state) AND full Matt **styling** discipline. Re-skinning while silently dropping behavior = a FAILED port, not a simplification. Diff legacy↔new field-by-field before declaring done. Core of the DISC-DROP Tier-1 recipe + all RTMIG-4 ports. (Conv 222: /courses & /communities collapsed 5 per-role views into a filter-only catalog.)
- [link](project_preflip_worktree_reference.md) — To inspect legacy /old look+behavior: `peerloop-ref` alias → pre-flip worktree `~/projects/Peerloop-preflip` (commit 608346a2=846bab9f^) on :4331 (legacy at root, Matt at /matt). Machine-LOCAL. Login modal, admin brian@peerloop.com / Peerloop2. Teardown=[PREFLIP-WT].
- [link](project_module_submodule_model.md) — Session↔Module is 1:1; Matt's/Creators' nested "N Modules" = Sub-Modules. Don't build a session→many-modules data model. Resolves Conv 188 [MOD-SCHEMA].
- [link](project_timezone_confidence.md) — Recurring new Date() issues despite multiple sweeps; user has low confidence in TZ correctness
- [link](project_staging_integration_plan.md) — Expand BBB-VERIFY into full staging block (Stream, Resend, Stripe, BBB); plus-addressed email capture
- [link](project_feeds_hub.md) — FEEDS-HUB: Client says feeds = 50% of learning; composite `/feeds` page needed (READY — unblocked Conv 015)
- [link](project_obsidian_vault_synced.md) — `~/Obsidian Vaults/main2025/` replicated across M4/M4Pro via Obsidian Sync; one-machine file write propagates — do NOT design skills with per-machine bootstrap steps
- [link](project_matt_collaboration_style.md) — Matt (designer) keeps ALL working material in Figma — specs, notes, decisions, value-prop exploration. WE produce markdown specs from Figma probes, not the other way around. "Ready for Dev" status = visual green-banner labels, not API-readable.
- [link](project_settings_tier_local_control.md) — Settings favor project `settings.json` + machine-local `settings.local.json` (global deprecated); prune local vs PROJECT only (deny always wins). Keep project file PORTABLE: `Read(/**)` not abs `/Users/<name>/` (M4=livingroom / M4Pro=jamesfraser). [SETTINGS-PRUNE] Conv 212: local 173→4. **[SETTINGS-GUARD]**: broad allow + `permissions.ask` tier + PreToolUse hook `guard-dangerous-bash.sh` for mid-command dangers prefix rules can't see (`wrangler --remote`, `DROP TABLE`, `git push --force`; Conv 213 fix excludes commit-message bodies). Restart → [GUARD-VERIFY].

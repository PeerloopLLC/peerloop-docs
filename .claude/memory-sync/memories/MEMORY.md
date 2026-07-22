# Peerloop Project Memory

> **Situational recall index (single-tier).** Flat list of `[link]` pointers into on-demand sub-files. Rules governing this file live in `CLAUDE.md §Memory`; see [[feedback_memory_index_load_bearing]].

---

## Rule detail & incident-history (behind CLAUDE.md rules)

> The one-line **rule** now lives in the named CLAUDE.md section; these sub-files hold the incidents/rationale, read on-demand.

- [link](feedback_option_phrasing.md) — §User-Facing Questions detail: malformed-question archaeology (Convs 132/147/208/263) + QLINT Stop-hook build-then-retire + Conv 273 switch to AskUserQuestion.
- [link](feedback_pause_on_pointing_questions.md) — §Recurring-Failures #2 detail: 👉👉👉/decision must be last visible content; Conv 125 reorder example; "if uncertain, treat as dependent work".
- [link](feedback_conversational_brevity.md) — §Explanatory Style detail: Conv 150 screen-buffer rationale; [MCFRAME] steer-don't-re-ask (Conv 199); Conv 306 work-progress extension.
- [link](feedback_audit_surface_findings_first.md) — §Investigative Framings detail: Conv 206 [MEM-AUDIT] motivating quote + CC-sees-findings-first asymmetry + edge cases.
- [link](feedback_explicit_approval_not_inferred.md) — §Critical Rule (Consent discipline) detail: Conv 300 scratch-folder-flip incident; bar HIGHER right after a miss; xhigh doesn't relax it.
- [link](feedback_no_simplest_fix.md) — §Solution Quality detail: Conv 100 principle quote + drift signal-lists (`TODO:`/"for now" vs consolidating call sites, reading changelogs).
- [link](feedback_default_durable_no_ask.md) — §Solution Quality/§Critical Rule detail: multi-conv-scope counter-case + Conv 131 [TDS-AUTH] precedent.
- [link](feedback_surface_and_track_all_issues.md) — §Issue Surfacing detail: Sessions 386/390 + Conv 340 incidents; self-monitoring trigger words (stale/pre-existing/out-of-scope); "I'll handle at /r-end" = no-op promise.
- [link](feedback_current_tasks_persistence.md) — §Task Persistence detail: CURRENT-TASKS.md is the WRITE-THROUGH board (edit directly, no Task-tool overlay — server-gated off Conv 406). Format: 🎯 Now / ⏸️ Parked TOCs + alphabetical `### [CODE]` bodies (never move) + ✅ Done this conv. RESUME-STATE narrative-only. Boundary skills VALIDATE via `current-tasks-check.sh`. [CURTASKS] 350-352, detach 406.
- [link](feedback_todowrite_mnemonic_codes.md) — §Task Persistence detail: code format/derivation/collision (`[GE]`→`[GE2]`); Conv 135 origin; PLAN.md uses longer codes.
- [link](feedback_rend_discipline.md) — §Conv Lifecycle detail: Conv 062 vanished-alert incident; Conv 108 r-commit-autonomous / r-end-needs-approval change; new-conv-number traceability.
- [link](feedback_git_dash_c_enforcement.md) — §Dual-Repo detail: Conv 109 wrong-repo near-miss; tilde-literal dodges `$VAR` simple_expansion; Conv 214 [GUARD-VERIFY] guard must detect `git -C`.
- [link](feedback_no_tool_call_spam_loops.md) — §Guards detail: Conv 218 ~420K-token Read-spam incident; [TERM-GARBLE] carve-out (suspicious-empty → verify out-of-band, never re-spam).
- [link](feedback_no_paste_tokens_in_chat.md) — §Guards detail: Conv 113 CF-token + Conv 144 Stripe-key leaks; unsafe-patterns list; safe-alternatives table; leak-response procedure.
- [link](feedback_external_source_of_truth_first.md) — §Guards detail: [VDF] vendor docs / [MFM] designer catalogues / [STOR][DTU] user source files / [EMP] probe tool behavior; Convs 178-180.
- [link](feedback_verify_baselines_in_conv.md) — §Baseline Verification detail: Conv 101→102 (5 silently-broken time-fragile tests) + Conv 104 (10 `.astro` errors, astro-check gate added).
- [link](feedback_memory_index_load_bearing.md) — §Memory detail: one-liners must expose distinctive markers not topic labels; `[link]` label convention (Conv 213); index-vs-body drift discipline; Conv 150/151.
- [link](user_hands_off_pilot_workflow.md) — §User WIP File detail: "CC is sole author" architectural implications (sync trusts mirror, skill state needs no locking); USER-WIP.md carve-out (CC read-only).
- [link](feedback_assess_ask_before_acting.md) — Conv 407 Fable-5: user named a branch, CC silently retargeted a newer one; grep-patched a premise change (Focus line survived 2 sweeps). Surface scope choices as questions; premise change ⇒ full-doc rewrite.

---

## Situational recall index (read the sub-file when a marker matches)

### Dual-repo & environment
- [link](project_route_gen_cross_repo.md) — route-doc regen (`route-api-map`/`route-matrix.mjs`) writes BOTH repos; `git status` both before commit. Conv 201.
- [link](feedback_db_setup_shorthand.md) — "run the {local/staging} D1 {level} script" → `npm run db:setup:{target}:{level}`; machine name from `~/.claude/.machine-name`.
- [link](project_schema_edit_remote_d1_propagation.md) — [D1-SCHEMA-REMOTE] `0001_schema.sql` edits do NOT reach an already-migrated remote D1 → `ALTER TABLE ADD COLUMN` or reseed. Conv 394.
- [link](project_code_repo_shared_with_client.md) — [TC-BRANCH-GATE] CODE repo is SHARED with the client (`brian-July-7`, colliding `Conv NNN:` prefixes) — never bare-sweep branches there; allowlist `^jfg-dev`. Docs repo is ours alone. Conv 396.
- [link](project_task_tools_child_session_leak.md) — [TASK-TOOLS-VERIFY] Conv 406 ROOT-CAUSE: Task*/TodoWrite killed by an UNDOCUMENTED server gate `uZ()` reading remote config `tengu_vellum_ash` vs the model ID — not our config, not a version bump (binary identical 214/215/216; `vellum`=0 changelog hits). Project HARD-DETACHED → write-through `CURRENT-TASKS.md`. `/model` non-1M probe untested. `Grep`/`Glob` = separate open upstream bug (#52121/#63525). Decompile the binary's `isEnabled(){}` to diagnose a missing tool. Conv 403→406.

### Navigation & UI
- [link](feedback_orphaned_components_survive_migration.md) — [ORPHAN-DETECT] Route migrations orphan page-level components while tsc/lint/tests stay GREEN (Conv 339/391). Verify route-reachability before trusting/editing a page component. Conv 392.
- [link](reference_icon_system.md) — [ICN-NS] 3 icon systems (legacy RETIRED Conv 370); `MattIcon` canonical, **MattIcon-kebab-name-wins**.
- [link](project_navigation_architecture.md) — AppLayout (Matt shell) = canonical since ROUTE-FLIP (Conv 197); `/old/*` → `layouts/old/AppLayout`→AppNavbar; mind which shell + `startsWith` active-match.
- [link](reference_astro_slot_forwarding.md) — Astro Fragment-slot forwarding suppresses child `<slot>FALLBACK`; fix = defaults at layout consumer via ternary in unconditional Fragments. Conv 175 [MSH-VIZ].
- [link](reference_tailwind_intellisense_canonical_suggestions.md) — Tailwind `suggestCanonicalClasses` arbitrary-`[Npx]`→scale warnings: REJECT — it's the [DEMO-HOME] 4× bug class. Conv 371.

### Testing & PLATO
- [link](feedback_full_test_output.md) — Full suite `npm test 2>&1 | tee /tmp/lastFullTestRun.log` (~3min); tail 15-20; `--testNamePattern` for iterative fixes. Test DB = better-sqlite3.
- [link](e2e-testing-patterns.md) — After `page.goto()` add `waitForLoadState('networkidle')` for `client:load` islands; full E2E needs `db:setup:local` headroom.
- [link](feedback_no_test_artifacts_in_prod.md) — No dev-only testing infra in production code; two browser vendors for multi-user testing.
- [link](feedback_test_import_cleanup.md) — After writing a test file, quick-pass to remove unused imports/variables.
- [link](plato-context.md) — **Load when** PLATO/browser-run/STUMBLE-AUDIT/BrowserIntent discussed — terminology, modes, nav caveats, screenshot conventions.
- [link](feedback_dom_truth_over_screenshots.md) — Precise layout/position/visibility: trust DOM (`getComputedStyle`/`getBoundingClientRect`/`elementFromPoint`) + dev log, NOT screenshots. Conv 191; duplicate-`style` JSX gotcha.
- [link](reference_responsive_iframe_harness.md) — [MINWIDTH][SIDEBAR-COLLIDE] responsive testing = exact-SIZE same-origin IFRAME (media queries key off iframe, NOT viewport). Conv 367/368.
- [link](reference_chrome_bridge_island_stale_cache.md) — [BRIDGE-MEM] client-gated islands: `dev-login` + hard nav + settle-read; also [NUDGE-CACHE-FLASH], [BRIDGE-UPLOAD], blank-first-nav. Conv 258/379.
- [link](feedback_plato_expect_is_legacy_spec.md) — PLATO `expect`/`pageAction` = frozen LEGACY spec; "UI missing" on a Matt page → triage REDESIGN/REGRESSION/NEVER-EXISTED vs preflip BEFORE editing the test. Conv 343.
- [link](feedback_persistent_dev_server_4321.md) — NO persistent dev server (retired Conv 366) — EPHEMERAL `npm run dev` on demand, killed when done. ≠ preflip :4331.
- [link](feedback_codecheck_moment_includes_tests_and_build.md) — `/w-codecheck` trigger = decision point: also decide per-change whether to add prov-sweep + full test suite + build. Anti-pattern: inline `tsc`+`lint`+astro check skipping `/w-codecheck`. Conv 207.
- [link](plato_walk_mocked_service_divergence.md) — [PLATO-SEQ] browser-walk row-identity EXCLUDES `notifications`; [PSA-WAITUNTIL] fixed Conv 384; CUT-2 enroll has NO `payment_intent`.

### Output & terms
- [link](feedback_pointing_emoji_prefix.md) — Stub anchor — 👉👉👉 + bold rule lives in CLAUDE.md §User-Facing Questions.
- [link](feedback_visual_issue_alerts.md) — Stub anchor — 🔴🔴🔴 / 🟠🟠🟠 issue-alert rule lives in CLAUDE.md §Issue Surfacing.
- [link](feedback_mirror_term_annotation.md) — Say "mirror (from last r-end)" not bare "mirror" (= prev conv's live→mirror snapshot). Conv 228.
- [link](reference_term_garble_upstream_bug.md) — [TERM-GARBLE] blank/partial tool output + confabulated failure = OPEN upstream CC bug (Opus 4.8 + parallel batch); mitigate via narrow batches + out-of-band verify. Conv 227.
- [link](feedback_routing_addressability_first.md) — Route shape = decide ADDRESSABILITY (deep-link/redirect URL?) not page-count; transient confirmations → overlays. Conv 187 [MATT-EXEC-FLAGS].
- [link](feedback_afk_nudge_disabled.md) — [AFK-CFG] AskUserQuestion 60s auto-proceed nudge disabled via `CLAUDE_AFK_TIMEOUT_MS`=maxint (both settings scopes); non-answer/timeout ≠ consent. Conv 361.
- [link](feedback_chat_vs_tooling_output_separation.md) — [CHATSEP] `verbose:false` in PROJECT settings (tool output → `ctrl+o to expand` stubs) + `chat-replay.sh`; `/focus`/fullscreen REJECTED — kills scrollback. Conv 395.
- [link](feedback_mouse_disabled_picker_misclick.md) — [MOUSE-GUARD] `CLAUDE_CODE_DISABLE_MOUSE`=1 is DELIBERATE — a stray click once SELECTED an AskUserQuestion option; NEVER re-enable. Conv 395.

### Docs & memory discipline
- [link](feedback_check_docs_on_how_questions.md) — On "how does X work" questions, check docs too; offer doc update if answer needed heavy searching.
- [link](reference_generated_doc_regen.md) — [DOCGEN] route maps = generated docs, auto-regen at r-end Step 5c; NEVER TaskCreate "regen stale route docs". `route-stories.md` is hand-written. Conv 246.
- [link](feedback_read_legacy_source_before_conclusion.md) — Review/compare/port → fully read BOTH sides (esp. legacy `/old` SoT) BEFORE concluding; "in context" = genuine full read this conv. Conv 222.
- [link](feedback_check_memory_before_directive_save.md) — Before offering to save a directive, grep the memory dir for an existing entry on the topic.
- [link](feedback_confirmations_stand_unless_revoked.md) — User-confirmed sub-decisions survive later topic pivots; sticky until user names the item to revoke.
- [link](feedback_msi_sync_user_checkpoint.md) — /r-start Step 5.7 pauses on non-empty mirror-vs-live diff; A/B/C + auto-backup on `Only in $LIVE` data-loss; reverse (live→mirror) safe. Conv 155-156.
- [link](feedback_fix_docs_inline_not_rend.md) — Fix stale doc refs INLINE same-conv; do NOT defer to /r-end (its agent only touches ACTIVE-block subtasks); don't TaskCreate trivial doc cleanups. Conv 286 [TW-V4].

### Skills & planning
- [link](feedback_skill_body_stale_after_self_pull.md) — A skill's in-context body = pre-pull SNAPSHOT; if pull updates SKILL.md, re-read on-disk before later steps. Conv 218 (≠ truncation).
- [link](feedback_uncategorized_filtering.md) — Extract §Uncategorized: if writing "not a bug"/"no action needed", it doesn't belong there.
- [link](feedback_exploration_pacing.md) — After Phase 1 establishes patterns, Phase N+1 writes code — do NOT re-explore. Conv 057.
- [link](feedback_plan_mode.md) — CC Plan Mode: VERIFY/stress-test designs after discussion; plan files EPHEMERAL → persist durable plans to committed files. Conv 055-056.
- [link](feedback_skill_sync_same_name_divergence.md) — Same-named skills across projects often diverge structurally — default to "evolve independently".
- [link](feedback_heuristic_calibration.md) — New detection heuristic/threshold MUST run against the memo's canonical case BEFORE commit (else threshold wrong OR signal incomplete). Conv 142 [CMH].
- [link](feedback_cleanup_step.md) — Every PLAN block ends with a Cleanup phase (check off RFCs, reset temp files, remove scaffolding).
- [link](feedback_infra_vs_deliverable.md) — Building test infra: pause to check generalizable vs special-cased; surface dual goals early.
- [link](feedback_decompose_by_cohesion_not_pseudo_isolation.md) — Split by cohesion (vertical slices), NOT fragments where one needs a *piece* of another; each unit owns full stack + standalone done-test. Conv 271.
- [link](feedback_watch_task_assumptions.md) — Watch-tasks state the assumed delivery/load precondition in subject; audit falsifies the precondition FIRST. Conv 149-150 [OPW].
- [link](rename-lessons.md) — **Load when** planning a large rename (>50 files): baseline tests first; macOS `sed` lacks `\b` → `perl -pi -e`; short substrings dangerous; `†` marker for auto-changed lines.
- [link](feedback_rend_complete_all_steps.md) — **RECURRING FAILURE:** /r-end must execute ALL 8 steps without stopping after /r-eos. Convs 006/019/026/027.

### Security & Figma
- [link](figma-context.md) — **Load when** Figma/design-token work. GUARDRAIL: Figma READ-ONLY — NEVER call write-shaped `mcp__figma__*`; reuse existing components, tokenize what Matt tokenized [MNV].

### References
- [link](reference_spt_dual_repo.md) — `spt`/`spt-docs` is a sibling dual-repo; `r-end-soft`/`r-end-meta`/`r-start-soft`/`r-start-meta` live THERE not here.
- [link](reference_staging_url.md) — Staging: `peerloop-staging.brian-1dc.workers.dev` · slug `brian-1dc` · D1 `peerloop-db-staging` (not in wrangler.toml).
- [link](reference_cf_data_recovery.md) — CF recovery floors: D1 30d Time Travel; R2 no versioning → Bucket Locks + backup-copy; KV no PITR. DR = MVP-GOLIVE. Conv 212.
- [link](feedback_staging_is_deploy_target_prod_gated.md) — [Deploy] staging is the ONLY deploy target; NEVER `deploy:prod`/`deploy:cron:prod`. Conv 262.

### Project context
- [link](project_spacing_snap_over_matt_exception.md) — SPACING axis: off-scale `@matt-source` spacing SNAPS to nearest 4px (ties round UP); Colour keeps exceptions. Conv 305.
- [link](project_role_studios_deconstruct_nudges.md) — [ROLE-STUDIOS] `/dashboard`→role workspaces (`/creating`,`/teaching`) + nudges; comparison-keep REVOKED. Conv 252/317/339/392.
- [link](project_matt_phaseout_inspired_default.md) — Matt phase-out: Figma LAYOUT-ONLY; CC owns page consistency; pages default `@matt-inspired`, function-FIRST then style, NEVER lose `/old` function. Conv 239/289.
- [link](project_route_404_honesty_standin.md) — Route migration: unconverted pages must 404 (no redirect layer/resolving stubs); `@stand-in` = TRANSIENT marker until retrofitted. Conv 203.
- [link](project_old_pages_no_delete_until_vetted.md) — RTMIG-4 ports MOVE `/old/X`→`/X` as `@stand-in`; `/old` not kept live; 74 `/old` pages need per-page vetting (SoT route-migration README). Conv 250/338.
- [link](feedback_port_functionality_and_styling.md) — legacy→Matt port = TWO obligations: faithful function+content AND full Matt styling; re-skin dropping behavior = FAILED. Diff field-by-field. Conv 222 (DISC-DROP).
- [link](feedback_route_sweep_pause_protocol.md) — ROUTE SWEEP (RTMIG-4): every route swept (page + ALL subcomponents), 8-step PAUSE process → `[<ROUTE>-FIXES]` capture → ☑ Swept.
- [link](feedback_scan_for_primitive_candidates_on_retrofit.md) — Retrofitting `@stand-in`→`@matt-inspired`: scan for existing primitive candidates BEFORE writing inline JSX.
- [link](project_preflip_worktree_reference.md) — Inspect legacy /old: `peerloop-ref` → pre-flip worktree `~/projects/Peerloop-preflip` (608346a2) :4331; admin brian@peerloop.com / Peerloop2. Machine-LOCAL [PREFLIP-WT].
- [link](project_module_submodule_model.md) — Session↔Module = 1:1; Matt/Creator nested "N Modules" = Sub-Modules. Don't build session→many-modules. Conv 188 [MOD-SCHEMA].
- [link](project_timezone_confidence.md) — Recurring `new Date()` issues survive sweeps; user has LOW confidence TZ handling is correct.
- [link](project_staging_integration_plan.md) — Expand BBB-VERIFY into full staging block (Stream, Resend, Stripe, BBB); plus-addressed email capture.
- [link](project_feeds_hub.md) — [FEEDS] `/feeds`=Discover destination; `/`=merged SmartFeed (FeedsHub UNMOUNTED Conv 267) — do NOT re-add FeedsHub/ActionCards/TriageStrip to Home.
- [link](project_obsidian_vault_synced.md) — `~/Obsidian Vaults/main2025/` synced across M4/M4Pro via Obsidian Sync — don't design skills with per-machine bootstrap.
- [link](project_scratch_obsidian_symlink.md) — scratch = REAL `_scratch/` + `.scratch` compat symlink (peerloop-docs IS an Obsidian vault); don't delete/flip the symlink. Conv 300.
- [link](project_ephemeral_dismiss_dev_staging.md) — Dismissible nudges reappear every reload in dev+staging BY DESIGN (`ephemeral-dismiss.ts`); "doesn't stick on staging" is EXPECTED. Conv 292.
- [link](project_settings_tier_local_control.md) — Settings: project `settings.json` + machine-local `settings.local.json`; [SETTINGS-GUARD] broad allow + PreToolUse `guard-dangerous-bash.sh`. Conv 212.
- [link](project_jfg_dev_branches_are_snapshots.md) — `jfg-dev-NN` code branches = intentional point-in-time SNAPSHOTS — NEVER propose `git branch -d` cleanup sweeps. Conv 292 [DEV13-RM].
- [link](project_old_appnavbar_retire_by_default.md) — [OLD-RETIRE-DEFAULT] `/old/*` + AppNavbar = RETIRE-by-default; links FROM them don't count as value, only canonical Sidebar/Home/role-workspaces. Conv 331.
- [link](project_admin_conformance_policy.md) — [ADMIN-CONF-POLICY] RG-ADMIN = dense operational console; relaxations A-D, 12px-base+10px-meta, dark `neutral-900` sidebar, drop all `dark:`. Conv 331.
- [link](project_diploma_vs_certificate.md) — [DIPLOMA] Diploma=course-completion (auto, NO table, derived from enrollment) vs Certificate=teach-readiness; NEVER call a completion a 'certificate'. Conv 389.

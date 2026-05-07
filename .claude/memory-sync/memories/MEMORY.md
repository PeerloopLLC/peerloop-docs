# Peerloop Project Memory

## Dual-Repo Shell Discipline

**ALWAYS use `-C` flags for git commands.** Never rely on bare `git` — the shell cwd drifts to `../Peerloop` after `cd ../Peerloop && npm ...` commands and stays there.

- Docs repo: `git -C ~/projects/peerloop-docs ...`
- Code repo: `git -C ~/projects/Peerloop ...`

This applies to ALL git commands (status, add, commit, diff, log).

- [feedback_git_dash_c_enforcement.md](feedback_git_dash_c_enforcement.md) — Always use `git -C <abs-path>` in dual-repo work; bare git after `cd ../Peerloop` lands commits in the wrong repo (Conv 109)

## Icon System
- **React icons** (`icons.tsx`): ~96 exports, JSX components for React islands
- **Brand icons** (`brand-icons.tsx`): Google, GitHub, Stripe, Twitter/X, LinkedIn, YouTube, Instagram
- **Astro icons** (`Icon.astro`): Wraps `icon-paths.ts` registry, zero JS, build-time SVG
- **Path registry** (`src/lib/icon-paths.ts`): ~35 entries of raw HTML path strings for Astro
- React pattern: `({ className = 'h-5 w-5' }: IconProps)`
- Astro pattern: `<Icon name="profile" class="w-6 h-6 text-purple-600" />`

## Test Suite
- Always capture full test output to file first: `npm test 2>&1 | tee /tmp/test-output.txt`
- Fix tests individually with `--testNamePattern` before re-running full suite
- Test DB uses better-sqlite3 (works on all machines)

- [feedback_full_test_output.md](feedback_full_test_output.md) — Full test suite: always `tee /tmp/lastFullTestRun.log`; run strategically (~3min cost)
- [e2e-testing-patterns.md](e2e-testing-patterns.md) — After `page.goto()` add `waitForLoadState('networkidle')` for Astro `client:load` islands (else buttons visible-but-not-interactive under parallel load); full E2E suite needs `npm run db:setup:local` headroom against cross-test write contamination

## Development Environment
- Code branch: `jfg-dev-10up` (promoted to latest working branch Conv 108; eventual target: staging), docs branch: `main`
- Machine name from `~/.claude/.machine-name` (used in commits)
- `npm run db:setup:local` for standard dev data
- `npm run db:setup:booking` for booking flow testing (includes enrollment + teacher seed)

- [feedback_db_setup_shorthand.md](feedback_db_setup_shorthand.md) — "run the {local/staging} D1 {level} script" → `npm run db:setup:{target}:{level}`

## Course Page Merge
- [project_course_page_merge.md](project_course_page_merge.md) — Session 377: `/course/{slug}/learn` merged into `/course/{slug}` as enrolled-only Learn tab + Sessions tab; MyCourses cards gained "Next: date with teacher" banners linking to `/course/{slug}/sessions`

## Navigation Architecture
- **AppNavbar** (primary): persistent left sidebar in `AppLayout.astro`, role-based menu items, `startsWith` path matching (sub-routes auto-highlight parent)
- **AppHeader** (legacy): used by `LegacyAppLayout.astro`, has its own mobile sidebar — check both when adding routes

## Testing Preferences
- [feedback_no_test_artifacts_in_prod.md](feedback_no_test_artifacts_in_prod.md) — No dev-only testing infra in production code; use two browser vendors for multi-user testing
- [feedback_test_import_cleanup.md](feedback_test_import_cleanup.md) — After writing a test file, quick-pass to remove unused imports/variables before moving on

## Output Formatting
- [feedback_conversational_brevity.md](feedback_conversational_brevity.md) — Match response length to question length. Short conversational questions → short answers. "Need to dig deeper first" is acceptable. Don't auto-expand into A/B/C frameworks unless invited.
- [feedback_pointing_emoji_prefix.md](feedback_pointing_emoji_prefix.md) — Stub pointer: 👉👉👉 + bold rule lives in CLAUDE.md §User-Facing Questions. Memory-grep anchor for "pointing" / "bold question" searches.
- [feedback_option_phrasing.md](feedback_option_phrasing.md) — Stub pointer: A) B) C) labels rule lives in CLAUDE.md §User-Facing Questions. File preserves Conv 132 / Conv 147 motivating-incident archaeology.
- [feedback_pause_on_pointing_questions.md](feedback_pause_on_pointing_questions.md) — 👉👉👉 must be the last visible content; do independent work FIRST, then ask, then stop
- [feedback_visual_issue_alerts.md](feedback_visual_issue_alerts.md) — Stub pointer: 🔴🔴🔴 / 🟠🟠🟠 rule lives in CLAUDE.md §Issue Surfacing. Memory-grep anchor so issue-alert searches still resolve.

## Solution Quality
- [feedback_no_simplest_fix.md](feedback_no_simplest_fix.md) — **Core principle:** favour durable decisions over faster options. Lean durable when deciding; break only with sound reasons.
- [feedback_default_durable_no_ask.md](feedback_default_durable_no_ask.md) — Quick/durable: rule lives in CLAUDE.md §Solution Quality + §Critical Rule (size ≠ novelty). This file retains the multi-conv-scope counter-case + Conv 131 TDS-AUTH precedent

## Docs Awareness
- [feedback_check_docs_on_how_questions.md](feedback_check_docs_on_how_questions.md) — On "how does X work" questions, check docs too; offer doc update if answer required heavy searching

## Memory Discipline
- [feedback_check_memory_before_directive_save.md](feedback_check_memory_before_directive_save.md) — Before offering to save a directive, grep the memory dir for an existing entry on the same topic
- [feedback_resume_state_as_todowrite_persistence.md](feedback_resume_state_as_todowrite_persistence.md) — RESUME-STATE.md is just TodoWrite persistence across convs; user never interacts with it directly
- [feedback_confirmations_stand_unless_revoked.md](feedback_confirmations_stand_unless_revoked.md) — User-confirmed sub-decisions survive later topic-level pivots; treat confirmations as sticky until user names the item to revoke
- [feedback_memory_index_load_bearing.md](feedback_memory_index_load_bearing.md) — MEMORY.md one-liners must expose distinctive markers (`👉👉👉`, `A) B) C)`, `tee /tmp/...`), triggers, and anti-patterns — not just topic labels (Conv 151 [ILS]: "Bold questions" elided 👉). **And** after every edit to a `memory/` file, re-read its MEMORY.md line and reconcile drift (Conv 151 [ILS-AUDIT]: `e2e-testing-patterns.md` line claimed two rules that did not exist in the body)

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
- [feedback_heuristic_calibration.md](feedback_heuristic_calibration.md) — Any new detection heuristic / threshold / gate from qualitative guidance MUST be run against the case(s) cited in the driving memo BEFORE commit; if it doesn't fire there, the threshold is wrong OR the signal is incomplete (Conv 142: `/w-sync-skills` Jaccard `< 0.70` returned `1.000` on canonical `r-end` DIVERGED case — almost shipped a gate that fails on its own motivating case)

## Work Tracking
- [feedback_surface_and_track_all_issues.md](feedback_surface_and_track_all_issues.md) — Never silently skip issues; always TodoWrite anything not immediately resolved
- [feedback_cleanup_step.md](feedback_cleanup_step.md) — Every PLAN block must end with a Cleanup phase (check off RFCs, reset temp files, remove scaffolding)
- [feedback_mnemonic_collision.md](feedback_mnemonic_collision.md) — Append sequential numbers to mnemonic codes on collision (e.g., [GE] → [GE2])
- [feedback_codecheck_todos.md](feedback_codecheck_todos.md) — Never dismiss codecheck findings as "pre-existing"; always TodoWrite them
- [feedback_todowrite_mnemonic_codes.md](feedback_todowrite_mnemonic_codes.md) — Every TaskCreate subject starts with a unique 2-3 letter bracketed code (e.g., `[PL] Plan update`); user references tasks by code
- [feedback_infra_vs_deliverable.md](feedback_infra_vs_deliverable.md) — Building test infra: pause to check if approach is generalizable or special-cased; surface dual goals early
- [feedback_watch_task_assumptions.md](feedback_watch_task_assumptions.md) — Watch-tasks must state the assumed delivery/load precondition in the subject ("watching X **assuming** Y is loaded on machine Z"); audit at watch-end falsifies the assumption FIRST before debating content (Conv 149→150 [OPW]: "watch strengthening" framing hid that `feedback_option_phrasing.md` never reached MacMiniM4-Pro)

## Security & Secrets
- [feedback_no_paste_tokens_in_chat.md](feedback_no_paste_tokens_in_chat.md) — Block secrets reaching chat from BOTH directions: user-paste AND Claude-initiated diagnostic dumps like `stripe config --list` / `od -c` / `cat .dev.vars`

## PLATO / Browser Testing
- [plato-context.md](plato-context.md) — **Load when** PLATO, browser-run, STUMBLE-AUDIT, or BrowserIntent is discussed — terminology, execution modes, nav link caveats, screenshot conventions
- [feedback_plato_browser_mode.md](feedback_plato_browser_mode.md) — Browser-runs execute through /chrome MCP bridge, not Playwright; pageAction is prose by design
- [feedback_plato_stumble_terminology.md](feedback_plato_stumble_terminology.md) — PLATO is the system; "API-run [instance]" / "browser-run [instance]" are the run forms; STUMBLE-AUDIT is a project block, not a system
- [feedback_nav_link_existence.md](feedback_nav_link_existence.md) — Browser-runs must verify nav links exist before clicking — some are conditional (e.g., /onboarding hidden after first tag selection)
- [feedback_stumble_screenshots.md](feedback_stumble_screenshots.md) — When user says "with screenshots", capture PNGs at each BrowserIntent checkpoint via macOS `screencapture -x`

## Project Context
- [project_timezone_confidence.md](project_timezone_confidence.md) — Recurring new Date() issues despite multiple sweeps; user has low confidence in TZ correctness
- [project_staging_integration_plan.md](project_staging_integration_plan.md) — Expand BBB-VERIFY into full staging block (Stream, Resend, Stripe, BBB); plus-addressed email capture
- [project_currentuser_optimize.md](project_currentuser_optimize.md) — CURRENTUSER-OPTIMIZE block (Conv 013-015, complete): version polling, redundant API elimination, community memberships + feed index
- [project_feeds_hub.md](project_feeds_hub.md) — FEEDS-HUB: Client says feeds = 50% of learning; composite `/feeds` page needed (READY — unblocked Conv 015)
- [project_skill_portability.md](project_skill_portability.md) — Skills using `$CLAUDE_PROJECT_DIR` work on both dev machines (verified Conv 005)
- [rename-lessons.md](rename-lessons.md) — Large-scale rename (>50 files): use `perl -pi -e` for word boundaries (macOS `sed` lacks `\b`); grep broadly before short-substring replace (`stId` mangled `getByTestId`); run full test suite for baseline BEFORE starting (TERMINOLOGY block, Sessions 346-356)

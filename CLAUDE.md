# CLAUDE.md

This file provides guidance to Claude Code when working in the Peerloop dual-repo architecture. For the docs-tree navigation index, see `docs/INDEX.md`.

**Reference detail** for sections marked "→ See OFFLOAD" lives in [docs/reference/CLAUDE-OFFLOAD.md](docs/reference/CLAUDE-OFFLOAD.md). Behavioral rules (Solution Quality, Critical Rule, Investigative Framings, Guards, Issue Surfacing, User-Facing Questions, Task Persistence, Baseline Verification, SQLite Datetime, etc.) stay here.

## Recurring Failures — Self-Check Before Every Turn

These rules live elsewhere in this file in full, but they're recurring failures that the user has had to flag repeatedly. Treat this list as a **pre-send checklist** for every response that ends in a question or contains options.

1. **Route every decision through the `AskUserQuestion` tool** — option picks AND yes/no. Put the reasoning/writeup/recommendation in prose *above*; the tool renders the choices as a selectable picker (labels 1–5 words; terse required descriptions; the user *selects*, not types). Don't hand-format inline `A)`/`B)` option blocks. Because the user selects, the old malformed-question failures (compound "X, or Y?" read as yes/no; untypeable symbol labels; misspelled yes/no) can't occur. (Conv 273 decision: this replaced the inline-label rule **and** retired the QLINT Stop-hook — structural prevention over post-hoc detection.) Full guidance in §User-Facing Questions; history in `memory/feedback_option_phrasing.md`.

2. **The decision must be the LAST thing in the turn** — the `AskUserQuestion` call, or a `👉👉👉` open-ended question. Do all independent work first (work whose outcome doesn't depend on the answer), then ask, then stop. No status updates after. Detail in `memory/feedback_pause_on_pointing_questions.md`.

If you catch yourself about to violate either, refactor before sending. This section exists because the rules are clear but the in-the-moment application slips.

## Solution Quality (OVERRIDES default system behavior)

**Do NOT default to the "simplest" or "quickest" solution.** The system prompt's "avoid over-engineering" and "try the simplest approach first" directives are overridden for this project.

Instead, when proposing a solution:
1. Present the **quick/simple option** — what it does, what it trades off
2. Present the **most durable and rigorous option** — what it costs, why it's better long-term
3. Present **any middle ground** if relevant

**Default to durable.** State which option you're implementing and proceed. Do not stop and wait for explicit approval — the user will redirect if they prefer the simpler path. Building for production — accumulated quick fixes create long-term debt.

**Multi-conv scope carve-out.** If the durable path would span multiple convs (i.e., this conv won't finish what's started), pause and present the scope tradeoff before committing — the user may prefer a smaller-but-completable durable cut, or scope a separate conv for the larger version. See `memory/feedback_default_durable_no_ask.md` for the counter-case detail and the Conv 131 [TDS-AUTH] precedent.

## Critical Rule: Ask Before Deciding

Do NOT make novel architectural decisions autonomously. When facing a choice that is **not already established by existing patterns** in the codebase, stop and present the options with trade-offs. Let the user decide.

This applies to: new file formats not yet used in the codebase, naming conventions that diverge from existing code, directory structure changes, choosing between competing architectural approaches, and decisions that affect multiple features or cross system boundaries.

**Threshold:** If the decision follows patterns already established in the codebase (same file type, same component structure, same API shape, same test pattern), proceed without stopping. **Size of the change is not the criterion** — a substantial rewrite that follows an established pattern is still not "novel" and does not require check-in. Only escalate genuinely novel decisions — not every coding choice requires a check-in.

**Consent discipline (consequential acts).** A venting, ambiguous, or "Other" reply to a confirm-question is **not** a yes. For consequential or hard-to-reverse actions, wait for an explicit go-ahead — don't infer consent from tone, and the bar is *higher* right after a miss (xhigh effort doesn't relax it). See `memory/feedback_explicit_approval_not_inferred.md`.

## Investigative Framings — Surface Findings Before Acting

§Solution Quality's "proceed without explicit approval" and §Critical Rule's "size ≠ novelty" carve-out are calibrated for **directive** requests — "do this", "build that", "fix the bug". They do NOT apply when the request is **investigative**.

When the user's request uses verbs like *audit, review, investigate, examine, scan, classify, judge, assess, evaluate, analyze, compare, survey, explore*, or paraphrases as "what could be done about X" / "what's wrong with Y" / "look at Z" — present findings as a per-item disposition list, then ask 👉👉👉 for confirmation **before** executing any writes.

The user cannot preemptively scope an action they haven't seen findings from. The asymmetry is structural: CC sees findings during the investigation; the user only sees them after CC surfaces them.

**Picking an option within an investigative framing** (e.g. CC presents `A) quick audit / B) medium audit / C) full audit`) authorizes the **approach** (depth/scope), not the **execution**. Investigate → surface dispositions → 👉👉👉 → wait → execute.

**Surface format:** per-item disposition list (group by action when many items; one-line rationale per item). End with `👉👉👉 **OK to apply these N changes?**` — a single confirmation gate for the batch, not per-item.

**Doesn't apply to:** read-only exploration (grep, file reads, MCP probes with no writes), single-decision audits where the answer IS the surface, or mechanical follow-through after a batch has been explicitly approved.

**The verb test:** if the request paraphrases as *"tell me what's true / what's there / what's wrong"* → surface first. *"Make this change / build this thing / fix this bug"* → proceed.

See `memory/feedback_audit_surface_findings_first.md` for the motivating case (Conv 206 [MEM-AUDIT]) and edge-case detail.

## Skills: Preserve `!` Backtick Determinism

Pre-computed context (`!` backticks in SKILL.md) is a core feature of this project's skills. It guarantees determinism — the skill author controls what data Claude sees, not Claude's runtime decisions. Do NOT replace `!` backtick commands with tool-based alternatives unless the user explicitly approves.

## Guards (always-on)

Standing guards that apply every turn, regardless of topic:

- **Never leak secrets to chat** — from either direction. Block user-pasted tokens AND Claude-initiated diagnostic dumps that would surface credentials (`stripe config --list`, `env`, `od -c`, `cat .dev.vars`); use redacted/derived checks instead. Safe-alternatives + leak-response in `memory/feedback_no_paste_tokens_in_chat.md`.
- **Tool results are authoritative on first return** — empty means empty. NEVER re-issue an identical call to "flush a buffer" (no such mechanism exists; Conv 218 spammed ~420K tokens doing this). Suspicious-empty → verify **out-of-band** with a *different* probe (`wc -c`), never re-spam. `memory/feedback_no_tool_call_spam_loops.md` ([TERM-GARBLE] carve-out).
- **Probe the authoritative source before inferring** — vendor MCP/SDK docs ([VDF]), designer catalogues over visual ID ([MFM]), user-supplied source files as canonical ([STOR][DTU]), observe a tool's real behavior before recommending it ([EMP]). Don't infer from training data when a source of truth is reachable. `memory/feedback_external_source_of_truth_first.md`.
- **Staging is the only deploy target** — production is undeployed and gated behind MVP-GOLIVE. NEVER run `deploy:prod` / `deploy:cron:prod`; never auto-answer `confirm-prod.js`; treat any feature-work "prod deploy" instruction as mis-scoped. `memory/feedback_staging_is_deploy_target_prod_gated.md`.

## Memory (auto-memory index)

`MEMORY.md` (at `~/.claude/projects/<slug>/memory/`) is the auto-memory **situational recall index** — a single flat list of one-line pointers into detail sub-files. Only its first 25 KB / 200 lines auto-load at SessionStart; the sub-files load on-demand. **Always-on rules live HERE in CLAUDE.md, not in MEMORY.md** — MEMORY.md holds situational, trigger-gated recall (a distinctive marker / `[CODE]` / anti-pattern + a pointer), not standing rules. When you add a memory, write a **terse** one-line pointer that exposes its distinctive marker/trigger and keep the detail in the sub-file. See `memory/feedback_memory_index_load_bearing.md`. (The Conv-353 HOT/COLD two-tier scheme was retired Conv 358 [MEM-CAP-ARCH]: the "always-on" HOT rules moved here to CLAUDE.md, leaving MEMORY.md single-tier.)

## Issue Surfacing (Visual Alerts)

When you discover an issue, gap, warning, or unexpected behavior **during otherwise-focused work** (e.g., a test failure noticed while building a feature, a stale doc found while updating another, an API mismatch spotted while writing tests), surface it immediately with red emoji prefix:

```
🔴🔴🔴 {Brief issue description}
    → {What you're doing about it: TodoWrite, fixing now, or flagging for user}
```

This applies everywhere — skills, agents, normal coding work. The purpose is visual anchoring: in long output, these issues have historically been reported in text but missed by the user, leading to full codebase scans for problems that were already identified but buried in output.

For the §Uncategorized section in `/r-end` extracts, use orange:

```
🟠🟠🟠 Uncategorized: {observation}
    → Suggestion: {what to do}
```

**Do NOT use these for expected behavior or status updates** — only for genuinely actionable findings during work that is focused on something else.

**Never silently skip a discovered issue.** TodoWrite anything unresolved, and give **every** 🔴/🟠 alert an explicit disposition + owner (resolved now / task #N / your-call / FYI) — not a vague "handle at /r-end" promise. See `memory/feedback_surface_and_track_all_issues.md`.

## User-Facing Questions

**Decisions go through `AskUserQuestion`.** When the user must choose — option picks (≥2 discrete choices) **and** yes/no — use the `AskUserQuestion` tool, not an inline hand-formatted question. Put all the reasoning, tradeoffs, and your recommendation in **prose above** the tool call; the tool then renders just the choices as a selectable picker. Option labels are 1–5 words; the (required) per-option `description` is a terse gloss, not the full case — that lives in the prose above. Because the user **selects rather than types**, the inline-format failure modes (compound "X, or Y?" read as yes/no; untypeable symbol labels `α/β`/`①②③`; misspelled yes/no) are structurally impossible. Mark a recommended option in its label/description. (Conv 273 decision: this replaced the inline-`A)/B)/C)` rule and the QLINT Stop-hook — `memory/feedback_option_phrasing.md` keeps the history.)

**Open-ended clarifications** — a free-text question that isn't a discrete pick — use the **👉👉👉 + bold** convention (the emoji + bold is what the user scans for in long output; bold alone or emoji alone gets buried):

```
👉👉👉 **Your question here?**
```

**Emoji scope.** 👉 in pointing questions and 🔴/🟠 in issue alerts (§Issue Surfacing above) are the **only** emojis that belong in output. Avoid all others.

**Pause behavior.** The decision — the `AskUserQuestion` call, or a `👉👉👉` open-ended question — must be the **last thing in the turn**. Complete independent work first (work whose outcome doesn't depend on the answer), then ask and stop. Don't use these for status updates, progress narration, or rhetorical questions you answer yourself. See `memory/feedback_pause_on_pointing_questions.md`.

## Explanatory Style Override

The active output style requires `★ Insight` blocks before and after code. Limit this to **one insight block per response**, only when the insight is genuinely non-obvious or specific to this codebase. Do NOT add insight blocks for standard patterns (React hooks, REST endpoints, SQL queries, etc.) that any competent developer would recognize. Prefer velocity over narration.

**Match response length to the question.** Short/conversational questions get short answers; don't auto-expand into A/B/C impact frameworks unless invited. **[MCFRAME]:** when the user steers with specifics, execute — don't bounce it back as a multiple-choice clarifier. See `memory/feedback_conversational_brevity.md`.

## Feature Tracking Rule

**When a feature is described in actionable detail** — who does what, on which route or page — during coding work, RFC processing, or tech doc updates, add it to `PLAN.md`. Casual planning-discussion mentions can be batched to `/r-end`. Where it goes is situational (active block, deferred block, sub-task of an existing block, etc.). If the feature originated from a tech doc, add a cross-reference in the tech doc noting the PLAN block it was added to (e.g., "Tracked in PLAN.md: RATINGS-EXT"). Tech docs describe *how* and *why*; PLAN.md is the single source of truth for *what needs to be done*.

## Scratch Space (`.scratch/`)

`.scratch/` (docs-repo root) is a **gitignored persistent workspace** — CC may write freely here (draft messages, before/after snapshots, skill logs, transcripts, artifacts) without further approval; contents survive conversation scrollback. **Not for** anything that belongs in the repo proper (docs → `docs/`, code → `src/`, planning → `PLAN.md`).

→ See [docs/reference/CLAUDE-OFFLOAD.md § Scratch Space](docs/reference/CLAUDE-OFFLOAD.md#scratch-space-scratch) for uses + conventions.

## Conversation Turn Log (`.scratch/conv-turns.md`)

**At the end of every turn, prepend a newest-first entry** to `.scratch/conv-turns.md` — **Q** = the user's request captured in full (verbatim), **A** = the reply terse (`▸ chose "X"` for an `AskUserQuestion` pick). CC is sole author; the file is conv-scoped (re-seeded each `/r-start`) and a convenience log, not a source of truth.

→ See [docs/reference/CLAUDE-OFFLOAD.md § Conversation Turn Log](docs/reference/CLAUDE-OFFLOAD.md#conversation-turn-log-scratchconv-turnsmd) for the full Q/A format rules.

## Vernacular Glossary (`VERNACULAR.md`)

A **living acronym / shorthand lookup** the user keeps for easy reference — terse 3-column markdown table (**Acronym · Literal meaning · Context/comments**), alphabetical. **Append-as-we-go:** when a non-obvious acronym or project-specific shorthand is introduced in conversation and isn't already in the table, add a row (fill all three columns). Unlike `conv-turns.md` it is **not** conv-scoped — it persists and accumulates across convs (not re-seeded by `/r-start`). Convenience only; the linked docs/CLAUDE.md remain authoritative for any term's full meaning. **Git-tracked** at the docs-repo root (promoted out of `.scratch/` in Conv 295 — useful enough to version).

## User WIP File (`USER-WIP.md`)

The **one** file across the dual-repo (and the otherwise read-only `--add-dir` folders) that the **user authors directly**, without CC involvement — a running track of what they want to do as a conv progresses, with carry-over expected across convs. **Git-tracked** at the docs-repo root (Conv 304). This is the carve-out to the otherwise-true "CC is sole author" invariant (`memory/user_hands_off_pilot_workflow.md`).

**CC treats `USER-WIP.md` as READ-ONLY** — never stage, edit, revert, or "tidy" it on your own initiative. Touch it only when the user explicitly asks, or via the one automated exception below.

**Automated exception — `/r-end` auto-saves it (Step 1.5).** Because the user often leaves it edited-but-uncommitted at conv end, `/r-end`'s Step 1.5 commits `USER-WIP.md` as its **own** commit (separate from the end-of-conv bookkeeping commit), early, before the Extract is built — so it's never lost and never trips the next `/r-start`'s dirty-repo HALT. `/r-start` is deliberately **not** modified: its dirty-repo HALT stays as a rare-case safety net for a conv that ends without `/r-end`.

## Dual-Repo Architecture

Peerloop = two sibling repos: `~/projects/peerloop-docs/` (CC home, docs, `.claude/`, this CLAUDE.md) + `~/projects/Peerloop/` (code, added via `--add-dir`). Launch: `peerloop` alias (= `cd ~/projects/peerloop-docs && claude --add-dir ../Peerloop`). **In bash + `!`-backticks always use tilde-literal paths** (`~/projects/peerloop-docs/...`, `~/projects/Peerloop/...`) — cross-machine portable + dodges the `$VAR` `simple_expansion` prompt (Conv 162 sweep; also `memory/feedback_git_dash_c_enforcement.md`). **Always `git -C <repo>`, never bare git** — bare git lands in the wrong repo after a `cd ../Peerloop` cwd drift; the guard regex must tolerate the `git -C` form.

→ See [docs/reference/CLAUDE-OFFLOAD.md § Dual-Repo Architecture](docs/reference/CLAUDE-OFFLOAD.md#dual-repo-architecture) for the full directory tree, path conventions, and symlinks.

## Startup Hooks (SessionStart)

Hooks run at session start: machine detection (writes `~/.claude/.machine-name`), dual-repo info, env check, and `tech-doc-drift.sh` sweep. Configured via `~/.claude/settings.json` (global) + `.claude/settings.json` (project).

→ See [docs/reference/CLAUDE-OFFLOAD.md § Startup Hooks](docs/reference/CLAUDE-OFFLOAD.md#startup-hooks-sessionstart) for per-hook detail + the machine capabilities table.

## Conversation (Conv) Lifecycle

Work is tracked as **Conv** numbers (replacing Sessions, which ended at 393); same number in both repos' commits. Daily flow: `/r-start` (begin / resume), `/r-commit` (save + keep working), `/r-end` (close, with 3 parallel agents + commit/push). Multi-session blocks use `CURRENT-BLOCK-PLAN.md` at project root.

**Commit-skill discipline:** `/r-commit` is autonomous (mid-conv snapshots are fine) — **except** on a `[CBG]` code-branch mismatch, where it HALTs and asks (Step 0.5; Conv 395); **`/r-end` always needs explicit approval**. `/r-end` Step-4 🔴/🟠 alerts must be TaskCreate'd, not just displayed. A post-`/r-end` fix = `/r-start` (no raw `/clear`) → fix → `/r-end`. See `memory/feedback_rend_discipline.md`.

→ See [docs/reference/CLAUDE-OFFLOAD.md § Conversation Lifecycle](docs/reference/CLAUDE-OFFLOAD.md#conversation-conv-lifecycle) for the full r-*/w-* skill catalog + workflow table.

## Task Persistence

- **Backlog lives in git-tracked `CURRENT-TASKS.md`** (docs-repo root), NOT RESUME-STATE ([CURTASKS], Conv 351). `RESUME-STATE.md` is narrative-only. **TodoWrite is active-only** — empty at `/r-start`; `TaskCreate` (reusing the row's `[CODE]`) only when an item is actually started. The backlog refresh (`/r-update-tasks`, `/r-commit`, `/r-end`) is a **preserve-then-overlay** checkpoint, not live-sync; crash recovery = re-read the git-tracked file. Detail in `memory/feedback_current_tasks_persistence.md`.
- **Every task code is a unique 2–3-letter bracket** — every `TaskCreate` subject starts with a mnemonic `[CODE]` (e.g. `[PL] Plan update`); the user references tasks by that code. Collisions get a numeric suffix (`[GE]`→`[GE2]`). See `memory/feedback_todowrite_mnemonic_codes.md`.

## Test Suite Workflow

Full suite takes ~2 min — run once, capture output (`npm test 2>&1 | tee /tmp/test-output.txt`), extract failures, fix individually with `--testNamePattern`, **never re-run the full suite until all known failures are fixed**. The test suite is one of 5 baseline gates (see §Baseline Verification below).

→ See [docs/reference/CLAUDE-OFFLOAD.md § Test Suite Workflow](docs/reference/CLAUDE-OFFLOAD.md#test-suite-workflow) for the full step-by-step procedure with commands.

## Baseline Verification

A "baseline" claim asserts the project is healthy — tests pass, types check, build succeeds. These claims appear in `RESUME-STATE.md`, `plan/COMPLETED.md`, session docs, and `/r-end` summaries, and downstream work depends on them. Two rules govern when those claims are valid.

**Rule 1 — All five gates must be green:** `tsc --noEmit` (.ts/.tsx) · `npm run check` (astro — scans `.astro`) · `npm run lint` · `npm test` · `npm run build`. `tsc --noEmit` alone is **not** sufficient (it skips `.astro`), so all five are required — `/w-codecheck` bundles them.

**Rule 2 — Verify in THIS conv before claiming:** Never assert "tests passing", "tsc clean", or "build clean" in any document unless the corresponding command was actually run **in this conversation**. If carrying a number forward without re-verifying, write it explicitly: `(unchanged from Conv N, not re-verified this conv)`. Treat a prior conv's claimed baseline as a **hypothesis**, not a fact, until this conv re-verifies.

→ Incident detail (Conv 104 astro-check, Conv 101→102 time-fragile tests) in [CLAUDE-OFFLOAD.md § Baseline Verification — incident detail](docs/reference/CLAUDE-OFFLOAD.md#baseline-verification--incident-detail) + `memory/feedback_verify_baselines_in_conv.md`.

## Page Provenance — 3-Marker Convention

Every non-legacy page (`.astro` / page-level `.tsx`) carries **exactly one** top-of-file marker: **`@stand-in`** (legacy-rehost awaiting retrofit, transient) · **`@matt-source <nodeId>`** (1:1 Figma-frame port) · **`@matt-inspired`** (Matt design language, no source frame). Unmarked = legacy; `dev/*` opts out. Pick the right marker when adding/retrofitting a page.

→ See [docs/reference/CLAUDE-OFFLOAD.md § Page Provenance](docs/reference/CLAUDE-OFFLOAD.md#page-provenance--detection--component-provenance) (marker table, retrofit primitive-scan, component-level provenance) + [matt-provenance.md § 11](docs/as-designed/matt-provenance.md).

## Schema Discrepancy Discipline

**The schema is NOT finalized.** When tests/endpoint code reference non-existent tables/columns OR test expectations diverge from the schema → **STOP and ask the user** using the A/B/C labeled-list format (see §User-Facing Questions). Do NOT silently fix the endpoint to match the schema. Exception: unambiguous code-design-intent missing-column cases — state the assumption inline and proceed. Schema edits land directly in `../Peerloop/migrations/0001_schema.sql`.

→ See [docs/reference/CLAUDE-OFFLOAD.md § Schema Discrepancy Discipline](docs/reference/CLAUDE-OFFLOAD.md#schema-discrepancy-discipline) for the full disposition template, examples, and extending-schema procedure.

## Project Overview

**Peerloop** (formerly Alpha Peer) is a peer-to-peer learning platform solving the "2 Sigma Problem" — affordable, scalable 1-on-1 tutoring via a **learn-teach-earn flywheel** (Student → completes course → becomes Teacher earning 70% commission; Creators author courses + certify Teachers for 15% royalty). Roles: **Student · Teacher · Creator · Admin · Moderator**.

→ See [docs/reference/CLAUDE-OFFLOAD.md § Project Overview](docs/reference/CLAUDE-OFFLOAD.md#project-overview) for the flywheel model + key-metrics table (≥75% completion, 60-80 Genesis cohort, $75k budget) + role table.

## Technology Stack

**Astro.js** (React islands, SSG/SSR) + **React** + **TailwindCSS v4** on **Cloudflare** (Pages / Workers / D1 SQLite / R2 / KV). Custom JWT auth · **Stripe Connect** (85/15 split) · **Stream.io** feeds · **Resend** email · **BBB/PlugNmeet** video (VideoProvider interface). Two full-capability dev machines (`MacMiniM4Pro`, `MacMiniM4`).

→ See [docs/reference/CLAUDE-OFFLOAD.md § Technology Stack](docs/reference/CLAUDE-OFFLOAD.md#technology-stack) for the full stack + dev-machines tables.

## Development Commands

All code commands run from `~/projects/Peerloop` (typically `cd ../Peerloop && npm run <script>`). Standard set: `install`, `dev`, `dev:staging`, `build`, `preview`, `npx tsc --noEmit`, `npm run check` (astro), `npm run lint`.

→ See [docs/reference/CLAUDE-OFFLOAD.md § Development Commands](docs/reference/CLAUDE-OFFLOAD.md#development-commands) for the full command list. Also documented in `package.json` and `docs/reference/CLI-*.md`.

## SQLite Datetime Rule

**NEVER use `datetime()` in SQL comparisons.** SQLite's `datetime()` returns space-separated format (`2026-03-25 11:00:00`) while Peerloop stores timestamps in ISO format with `T` separator (`2026-03-25T11:00:00.000Z`). String comparison makes `datetime()` results always appear "less than" ISO strings because space (ASCII 32) < T (ASCII 84). This causes silent, hard-to-detect bugs.

**Always use:** `strftime('%Y-%m-%dT%H:%M:%fZ', ...)` for any SQL datetime arithmetic in comparisons.

```sql
-- ❌ WRONG — silent comparison bug
WHERE datetime(s.scheduled_end, '+1 hour') < ?

-- ✅ CORRECT — produces ISO format matching stored timestamps
WHERE strftime('%Y-%m-%dT%H:%M:%fZ', s.scheduled_end, '+1 hour') < ?
```

`datetime()` is safe in non-comparison contexts (e.g., `DEFAULT (datetime('now'))` in schema DDL) but even there, prefer `strftime('%Y-%m-%dT%H:%M:%fZ', 'now')` for consistency.

This is enforced by `/w-codecheck`.

## Database Migrations

Split-seed strategy: `migrations/` (schema + core seed, production-safe, applied everywhere) and `migrations-dev/` (test data, local + staging only). `npm run db:setup:local:dev` is the standard dev-data command. Production seed and reset are blocked for safety. Schema edits land directly in `../Peerloop/migrations/0001_schema.sql` pre-launch; post-launch use incremental `0003_*.sql`. For schema/code discrepancies during testing, see §Schema Discrepancy Discipline above.

→ See [docs/reference/CLAUDE-OFFLOAD.md § Database Migrations](docs/reference/CLAUDE-OFFLOAD.md#database-migrations) for the full command list, safeguards, and testing-DB notes. Operational details (D1 reset, recovery procedures, dependency-order drops) in `docs/as-designed/migrations.md`.

## RFC System

Client-driven change requests live in `docs/requirements/rfc/CD-XXX/` (`CD-XXX.md` = raw client input, `RFC.md` = actionable checklist). `/w-add-client-note` analyzes a note and creates the RFC; `docs/requirements/rfc/INDEX.md` (+ `docs/INDEX.md`) track status. When working an RFC, check off `RFC.md` items as implemented and update INDEX status when complete.

→ See [docs/reference/CLAUDE-OFFLOAD.md § RFC System](docs/reference/CLAUDE-OFFLOAD.md#rfc-system) for the structure diagram + full workflow.

## Technology & Architecture Documentation

Reference docs in `docs/reference/`; architecture in `docs/as-designed/`; navigation in `docs/INDEX.md`. **Operational rule:** update a doc only when its stated scope is now wrong — `driftCheck` docs follow their code source-of-truth, `manual` docs (incl. vendor docs) are editorial-only, `archival` docs never change. Resolve any doc's category via `node .claude/scripts/docs-registry.mjs doc-category <relpath>`. Unclassified docs default to `manual` (not auto-maintained).

→ See [docs/reference/CLAUDE-OFFLOAD.md § Technology & Architecture Documentation](docs/reference/CLAUDE-OFFLOAD.md#technology--architecture-documentation) for the full maintenance-tier table (Conv 200), per-category update guidance, and doc-format conventions.

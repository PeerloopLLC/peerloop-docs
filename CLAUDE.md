# CLAUDE.md

This file provides guidance to Claude Code when working in the Peerloop dual-repo architecture. For the docs-tree navigation index, see `docs/INDEX.md`.

**Reference detail** for sections marked "→ See OFFLOAD" lives in [docs/reference/CLAUDE-OFFLOAD.md](docs/reference/CLAUDE-OFFLOAD.md). Behavioral rules (Solution Quality, Critical Rule, Investigative Framings, Issue Surfacing, User-Facing Questions, Baseline Verification, SQLite Datetime, etc.) stay here.

## Recurring Failures — Self-Check Before Every Turn

These rules live elsewhere in this file in full, but they're recurring failures that the user has had to flag repeatedly. Treat this list as a **pre-send checklist** for every response that ends in a question or contains options.

1. **NEVER ask `"X, or Y?"` as the primary question.** Readers parse `"or"` mid-sentence as yes/no and answer `"yes"` meaning the first option. **ALWAYS** put labeled `A)` / `B)` / `C)` options above the `👉👉👉` line, even for binary non-yes/no picks (e.g. "now vs later"). The bold pointing question itself is short and references the letters. Past incidents: Convs 132, 147, 208 — user verbatim *"I really, really wish your MEMORY.md and/or CLAUDE.md would give this more importance. It happens at least once a Conv."* Full rule in §User-Facing Questions; archaeology in `memory/feedback_option_phrasing.md`.

2. **The `👉👉👉` question must be the LAST visible content in the turn.** Do all independent work first (work whose outcome doesn't depend on the answer), then ask, then stop. No status updates after the question. Full rule in §User-Facing Questions; detail in `memory/feedback_pause_on_pointing_questions.md`.

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

## User-Facing Questions

When asking the user a question that requires their answer, follow these formatting rules.

**Pointing prefix.** Prefix the question with **👉👉👉** AND bold the question text. The combined emoji + bold is what the user scans for in long output — bold alone gets buried; emoji alone gets buried.

```
👉👉👉 **Your question here?**
```

No "Decision needed:" or "Your call:" prefix — just the bolded question on its own line.

**Emoji scope.** 👉 in pointing questions and 🔴/🟠 in issue alerts (§Issue Surfacing above) are the **only** emojis that belong in output. Avoid all others.

**Option questions (≥2 discrete options that aren't yes/no).** Format with **A) B) C)** labels, one option per line. The pointing question itself is short and references the letters, not the option text.

```
A) Option one
B) Option two
C) Option three

👉👉👉 **Which — A, B, or C?**
```

Use the labeled format even for binary non-yes/no choices (e.g., "A) port now / B) defer"). Do **NOT** use compound "X, Y, or Z?" sentences as the *primary* question without labeled blocks above — readers parse that shape as yes/no and answer "yes" meaning the first option. (Past incidents: Conv 132 strategy-doc-vs-retirements; Conv 147 LE-TRIAGE.)

**When to use 👉👉👉.** Any time the user's answer is required before you proceed (yes/no decisions, A/B option picks, clarifications, permission prompts). Do NOT use 👉 for status updates, progress narration, or rhetorical questions you answer yourself. Batch multiple required questions into a single block with one 👉👉👉, not per-question.

**Pause behavior.** A 👉👉👉 question must be the **last visible content** in the turn. Independent work (work whose outcome does not depend on the answer) may be completed first, then ask the question last and stop. See `memory/feedback_pause_on_pointing_questions.md` for the full sequencing rule.

## Explanatory Style Override

The active output style requires `★ Insight` blocks before and after code. Limit this to **one insight block per response**, only when the insight is genuinely non-obvious or specific to this codebase. Do NOT add insight blocks for standard patterns (React hooks, REST endpoints, SQL queries, etc.) that any competent developer would recognize. Prefer velocity over narration.

## Feature Tracking Rule

**When a feature is described in actionable detail** — who does what, on which route or page — during coding work, RFC processing, or tech doc updates, add it to `PLAN.md`. Casual planning-discussion mentions can be batched to `/r-end`. Where it goes is situational (active block, deferred block, sub-task of an existing block, etc.). If the feature originated from a tech doc, add a cross-reference in the tech doc noting the PLAN block it was added to (e.g., "Tracked in PLAN.md: RATINGS-EXT"). Tech docs describe *how* and *why*; PLAN.md is the single source of truth for *what needs to be done*.

## Scratch Space (`.scratch/`)

`.scratch/` at the docs-repo root is a **gitignored persistent workspace** for files CC and the user collaborate on but don't want in git history. Files there survive past conversation scrollback so they can be re-read or re-used in later convs.

**Common uses:**
- Draft messages (email, Slack, etc.) awaiting user review/send
- Before/after snapshots when tracking specific changes through a sequence of edits
- One-off skill execution logs and diagnostic output (e.g., script run results)
- Intermediate artifacts: transcripts, paste-ins, error dumps, log excerpts
- Anything that needs to survive past the visible context window but isn't worth committing

**Conventions** (see `.scratch/README.md` for details): one file per artifact, dated descriptive filenames, markdown preferred. CC may write here freely without further approval — the folder is the user's pre-authorization for persistent scratch.

**Not for:** anything that belongs in the repo proper. Docs → `docs/`, code → `src/`, planning → `PLAN.md`. If it's worth keeping in git history, it doesn't belong in `.scratch/`.

## Dual-Repo Architecture

Peerloop = two sibling repos: `~/projects/peerloop-docs/` (CC home, docs, `.claude/`, this CLAUDE.md) + `~/projects/Peerloop/` (code, added via `--add-dir`). Launch: `peerloop` alias (= `cd ~/projects/peerloop-docs && claude --add-dir ../Peerloop`). **In bash + `!`-backticks always use tilde-literal paths** (`~/projects/peerloop-docs/...`, `~/projects/Peerloop/...`) — cross-machine portable + dodges the `$VAR` `simple_expansion` prompt (Conv 162 sweep; also `memory/feedback_git_dash_c_enforcement.md`).

→ See [docs/reference/CLAUDE-OFFLOAD.md § Dual-Repo Architecture](docs/reference/CLAUDE-OFFLOAD.md#dual-repo-architecture) for the full directory tree, path conventions, and symlinks.

## Startup Hooks (SessionStart)

Hooks run at session start: machine detection (writes `~/.claude/.machine-name`), dual-repo info, env check, and `tech-doc-drift.sh` sweep. Configured via `~/.claude/settings.json` (global) + `.claude/settings.json` (project).

→ See [docs/reference/CLAUDE-OFFLOAD.md § Startup Hooks](docs/reference/CLAUDE-OFFLOAD.md#startup-hooks-sessionstart) for per-hook detail + the machine capabilities table.

## Conversation (Conv) Lifecycle

Work is tracked as **Conv** numbers (replacing Sessions, which ended at 393); same number in both repos' commits. Daily flow: `/r-start` (begin / resume), `/r-commit` (save + keep working), `/r-end` (close, with 3 parallel agents + commit/push). Multi-session blocks use `CURRENT-BLOCK-PLAN.md` at project root.

→ See [docs/reference/CLAUDE-OFFLOAD.md § Conversation Lifecycle](docs/reference/CLAUDE-OFFLOAD.md#conversation-conv-lifecycle) for the full r-*/w-* skill catalog + workflow table.

## Test Suite Workflow

Full suite takes ~2 min — run once, capture output (`npm test 2>&1 | tee /tmp/test-output.txt`), extract failures, fix individually with `--testNamePattern`, **never re-run the full suite until all known failures are fixed**. The test suite is one of 5 baseline gates (see §Baseline Verification below).

→ See [docs/reference/CLAUDE-OFFLOAD.md § Test Suite Workflow](docs/reference/CLAUDE-OFFLOAD.md#test-suite-workflow) for the full step-by-step procedure with commands.

## Baseline Verification

A "baseline" claim asserts the project is healthy — tests pass, types check, build succeeds. These claims appear in `RESUME-STATE.md`, `plan/COMPLETED.md`, session docs, and `/r-end` summaries, and downstream work depends on them. Two rules govern when those claims are valid.

**Rule 1 — All five gates must be green:**

```
1. tsc --noEmit          # .ts/.tsx type check
2. npm run check         # astro check (.astro files)
3. npm run lint
4. npm test
5. npm run build
```

`tsc --noEmit` alone is **not** sufficient — it does not scan `.astro` files. Missing any of the five gates leaves a category of errors invisible. Conv 104 discovered 10 pre-existing type errors in `.astro` pages that had been hidden through Convs 100–103 because `astro check` was never run. `/w-codecheck` is the authoritative gate that bundles all five.

**Rule 2 — Verify in THIS conv before claiming:**

Never assert "tests passing", "tsc clean", or "build clean" in any document unless the corresponding command was actually run **in this conversation**. If carrying a number forward from a previous conv without re-verifying, write it explicitly: `(unchanged from Conv N, not re-verified this conv)`. Conv 101's RESUME-STATE confidently claimed "6399/6399 passing" — Conv 102 ran the suite and found 5 silently-broken session-creation tests that had been failing for an unknown number of convs. Carry-forward claims hide regressions.

When `/r-start` reads a previous conv's claimed baseline, treat it as a **hypothesis**, not a fact, until this conv re-verifies. See `memory/feedback_baseline_includes_astro_check.md` and `memory/feedback_verify_baselines_in_conv.md` for the full incident details.

## Page Provenance — 3-Marker Convention

Every non-legacy page (`.astro` or page-level `.tsx`) carries **exactly one** of these markers as a top-of-file doc-comment. Unmarked = legacy. `dev/*` pages opt out.

| Marker | Meaning |
|--------|---------|
| `@stand-in` | Legacy-rehost page awaiting retrofit (transient). |
| `@matt-source <nodeId>` | 1:1 port from a Matt Figma frame (may list multiple nodeIds). |
| `@matt-inspired` | Built with Matt tokens/primitives/design language; no source Figma frame. |

**When adding/retrofitting a page,** pick the right marker. **When retrofitting `@stand-in` → `@matt-inspired`,** scan for primitive candidates BEFORE writing inline JSX (see `memory/feedback_scan_for_primitive_candidates_on_retrofit.md`). Component-level provenance (`@matt-source` on `.tsx` primitives) is a separate axis — page markers don't propagate to children, and Phase-6-extrapolated components don't carry page markers.

→ See [docs/as-designed/matt-provenance.md § 11](docs/as-designed/matt-provenance.md) for the full convention, detection sweep, and examples.

## Schema Discrepancy Discipline

**The schema is NOT finalized.** When tests/endpoint code reference non-existent tables/columns OR test expectations diverge from the schema → **STOP and ask the user** using the A/B/C labeled-list format (see §User-Facing Questions). Do NOT silently fix the endpoint to match the schema. Exception: unambiguous code-design-intent missing-column cases — state the assumption inline and proceed. Schema edits land directly in `../Peerloop/migrations/0001_schema.sql`.

→ See [docs/reference/CLAUDE-OFFLOAD.md § Schema Discrepancy Discipline](docs/reference/CLAUDE-OFFLOAD.md#schema-discrepancy-discipline) for the full disposition template, examples, and extending-schema procedure.

## Project Overview

**Peerloop** (formerly Alpha Peer) is a peer-to-peer learning platform that solves the "2 Sigma Problem" by making 1-on-1 tutoring affordable and scalable through a learn-teach-earn flywheel.

### The Flywheel Model
- Student enrolls and learns from a Teacher
- Student completes course → Teacher recommends → Creator certifies
- Student becomes Teacher → teaches new students → earns 70% commission
- Cycle repeats, creating self-sustaining teaching capacity

### Key Metrics

| Metric | Target |
|--------|--------|
| Course Completion Rate | ≥75% (vs 15-20% MOOC average) |
| Student-to-Teacher Conversion | 10-20% |
| Genesis Cohort | 60-80 students, 4-5 courses |
| Timeline | 4 months |
| Budget | $75,000 |

### Key Roles

| Role | Description |
|------|-------------|
| Student | Learner progressing through courses |
| Teacher | Certified graduate who teaches peers (70% commission) |
| Creator | Course author who certifies Teachers (15% royalty) |
| Admin | Platform operations and oversight |
| Moderator | Community moderation |

## Technology Stack

| Layer | Technology | Notes |
|-------|------------|-------|
| Meta-framework | Astro.js | React islands, SSG/SSR |
| UI Framework | React.js | Component library |
| Styling | TailwindCSS | Utility-first CSS |
| Hosting/Edge | Cloudflare | Pages, Workers, R2, D1 |
| Database | Cloudflare D1 | SQLite-based |
| Auth | Custom JWT | Session management |
| Payments | Stripe Connect | 85/15 split, payouts |
| Activity Feeds | Stream.io | Feeds only (not chat) |
| Video | VideoProvider Interface | BBB/PlugNmeet abstraction |
| Email | Resend | Transactional email |
| File Storage | Cloudflare R2 | S3-compatible |

### Development Machines

| Name | Machine | D1 Support | R2 Support |
|------|---------|------------|------------|
| `MacMiniM4Pro` | Mac Mini M4 Pro (64GB) | Local + Remote | Local + Remote |
| `MacMiniM4` | Mac Mini M4 (24GB) | Local + Remote | Local + Remote |

Both machines have identical, full capabilities. See `docs/as-designed/devcomputers.md` for details.

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

Client-driven change requests are tracked in `docs/requirements/rfc/`. Navigation table (RFC index, source docs, checklists) is in `docs/INDEX.md` § "Client Change Requests (RFCs)".

**Structure:**
```
docs/requirements/rfc/
├── INDEX.md           # Lookup table (status, item counts)
└── CD-XXX/
    ├── CD-XXX.md      # Source: raw client input
    └── RFC.md         # Actionable checklist with checkboxes
```

**Workflow:**
1. Client provides note/directive
2. Run `/w-add-client-note` to analyze and create RFC
3. Check off items in `RFC.md` as implemented
4. Update status in `docs/requirements/rfc/INDEX.md` when complete

**When working on an RFC:**
- Read `docs/requirements/rfc/INDEX.md` to find open RFCs
- Check `docs/requirements/rfc/CD-XXX/RFC.md` for pending items
- Mark checkboxes as completed during implementation

## Technology & Architecture Documentation

Reference docs in `docs/reference/`; architecture in `docs/as-designed/`; navigation in `docs/INDEX.md`. **Operational rule:** update a doc only when its stated scope is now wrong — `driftCheck` docs follow their code source-of-truth, `manual` docs (incl. vendor docs) are editorial-only, `archival` docs never change. Resolve any doc's category via `node .claude/scripts/docs-registry.mjs doc-category <relpath>`. Unclassified docs default to `manual` (not auto-maintained).

→ See [docs/reference/CLAUDE-OFFLOAD.md § Technology & Architecture Documentation](docs/reference/CLAUDE-OFFLOAD.md#technology--architecture-documentation) for the full maintenance-tier table (Conv 200), per-category update guidance, and doc-format conventions.

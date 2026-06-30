---
name: r-end
description: End conversation — collect, dispatch agents, commit and push using v2 commit format (H3 sections + Format v2 trailer)
argument-hint: ""
allowed-tools: Read, Write, Edit, Bash, Glob, Grep, Agent, Skill, TaskCreate, TaskUpdate, TaskList, TaskGet
---

# End Conversation — v2 commit format (Collector + Agent Dispatch)

**Purpose:** Scan the conversation into a structured extract, dispatch 3 agents in parallel to process it, then commit and push both repos using the **v2 commit message format**. The Extract is the primary conv record (narrative, changes, prompts); agents produce Learnings.md, Decisions.md, and update PLAN + docs. No Dev.md — the Extract replaces it. No nested skill calls — the main context runs a flat 9-step sequence.

**Canonical commit-format spec:** `docs/reference/COMMIT-MESSAGE-FORMAT.md`.

**Difference from `/r-end` (v1):** the commit body uses `### SECTION` H3 headers matching timecard H4 titles, and includes a `Format: v2` trailer. `/r-timecard-day2` uses that marker to read bullets directly from their H3 sections — and replicates each bullet into every H4 whose inclusion predicate matches (e.g., a bullet mentioning an API path and a doc file renders under both API Changes and Doc Changes).

---

## Pre-computed Context

**Machine:**
!`cat ~/.claude/.machine-name 2>/dev/null || echo "(unknown)"`

**Current conv:**
!`~/projects/peerloop-docs/.claude/scripts/conv-read-current.sh`

**Shared timestamp:**
!`echo "MONTH: $(date '+%Y-%m')" && echo "FILENAME: $(date '+%Y%m%d_%H%M')"`

**Repo status:**
!`~/projects/peerloop-docs/.claude/scripts/dual-repo-status.sh`

**Active blocks:**
!`sed -n '/^### ACTIVE$/,/^### /p' PLAN.md 2>/dev/null | grep '^| [A-Z]' || echo "(none)"`

**Focus block:**
!`grep '^## Active:' PLAN.md 2>/dev/null | head -1 | sed 's/^## //' || echo "(none)"`

**Enabled commit tags:**
!`node -e "console.log(require('~/projects/peerloop-docs/.claude/config.json').commitTags.join(', '))" 2>/dev/null || echo "(config unavailable)"`

**Agent models** (from `config.rEnd.agentModels`):
!`node -e "const m=require('~/projects/peerloop-docs/.claude/config.json').rEnd.agentModels;console.log('  learn-decide: '+m.learnDecide+'\n  update-plan:  '+m.updatePlan+'\n  docs:         '+m.docs)" 2>/dev/null || echo "(config unavailable — all agents inherit main context model)"`

**Existing conv files this month:**
!`~/projects/peerloop-docs/.claude/scripts/conv-files-learn-decide.sh`

**Existing state file:**
!`~/projects/peerloop-docs/.claude/scripts/resume-state-check.sh`

**Code repo branch:**
!`git -C ~/projects/Peerloop branch --show-current 2>/dev/null || echo "(unknown)"`

**Quiet mode:**
!`test -f ~/projects/peerloop-docs/.scratch/quiet-mode-log.md && echo "ON — quiet-mode-log.md present (r-end is BLOCKED)" || echo "off"`

---

## Paths

- Docs repo: `git -C ~/projects/peerloop-docs ...`
- Code repo: `git -C ~/projects/Peerloop ...`
- Agent refs: `~/projects/peerloop-docs/.claude/skills/r-end/refs/`
- Docs scripts: `~/projects/peerloop-docs/.claude/skills/r-end/scripts/`

---

## Execution Flow

### Step 0: Quiet-mode guard

Check the **Quiet mode** pre-computed line above. If it reports `ON`, **HALT immediately** — quiet mode is still active and its deferred-work log has not been processed:

```
🔴 Quiet mode is still ON — /r-end is blocked.
   Run `/r-quiet-mode off` first to process and clear the quiet log, then re-run /r-end.
```

Do NOT proceed with any end-of-conversation steps while `.scratch/quiet-mode-log.md` exists. (Closing the conv with unprocessed deferred work would silently lose it — and `/r-start` would later flag the orphaned log as an unclean exit.)

### Step 1: Validate Conv

Read `.conv-current`. If missing or says "MISSING", **HALT** — tell the user to run `/r-start` first.

Extract the padded conv number (e.g., `031`) for use throughout.

### Step 1.5: Auto-save USER-WIP.md

`USER-WIP.md` (docs-repo root) is the **one** file the user authors directly — a running WIP tracker they edit without CC involvement, with carry-over across convs (CLAUDE.md § "User WIP File"). It is git-tracked but, by design, often left uncommitted at conv end. Auto-save it here — as its **own** commit, kept separate from the Step-6 end-of-conv bookkeeping commit — so the user's notes are never lost and never trip `/r-start`'s dirty-repo HALT next conv:

```bash
cd ~/projects/peerloop-docs
if ! git diff --quiet -- USER-WIP.md || ! git diff --cached --quiet -- USER-WIP.md; then
  git add USER-WIP.md
  git commit -m "Conv {NNN}: USER-WIP.md update (auto-saved at r-end)"
  echo "✅ USER-WIP.md auto-saved (own commit)"
else
  echo "⏭️  USER-WIP.md unchanged — nothing to auto-save"
fi
```

This commit is pushed along with the rest in Step 7. Committing it **before** Step 2 keeps it out of the Extract's `git diff --stat` change-narrative — it's the user's file, not conv work. CC otherwise treats `USER-WIP.md` as **read-only**: never stage, edit, or revert it except via this step or when the user explicitly asks.

### Step 2: COLLECT — Build the Extract

Scan the **entire conversation** and produce a structured extract file. This is the most important step — every agent depends on the quality of this extract.

**Actions:**

1. Run `git -C ~/projects/peerloop-docs diff --stat` and `git -C ~/projects/Peerloop diff --stat` to capture file changes
2. Call `TaskList` to snapshot pending tasks
3. **Read any conv-scoped scratch notes** — glob `~/projects/peerloop-docs/.scratch/conv-{NNN}-*.md` (using the padded conv number from Step 1) and read every match. These are compaction-proof carriers a prior turn may have written to preserve decisions, rationale, or process learnings that would otherwise live only in chat history — and be lost to `/compact`. Treat their content as **first-class COLLECT input**: fold it into the relevant Extract sections (§Decisions, §Learnings, §Changes, §Uncategorized) alongside what you scan from the conversation. The glob is conv-scoped, so it never picks up `conv-tasks.md` (different prefix) or other convs' notes. Leave the notes in place after reading (they are gitignored and conv-scoped; the user prunes `.scratch/` manually). If no files match, skip silently.
   **Also read `.scratch/conv-turns.md`** if present — the turn-by-turn re-orientation log (each user question captured in full + a terse reply / selected choice). It is a high-signal cross-check for the §Prompts & Actions and §Conv Prompts sections — verify no asked-about thread was dropped from the Extract. It is conv-scoped and re-seeded by `/r-start`, so leave it in place (no delete).
4. Scan the conversation chronologically, populating each section below
5. Write the extract to `docs/sessions/{MONTH}/{FILENAME} Extract.md`

**Extract file format:**

```markdown
# Conv Extract — Conv {NNN} ({YYYY-MM-DD})

## Meta
- **Conv:** {NNN}
- **Date:** {YYYY-MM-DD}
- **Machine:** {from pre-computed}
- **Branch:** code: `{branch}`, docs: `main`
- **Block:** {determined from actual work — see Block determination rules in Step 6}
- **Focus:** {focus block from pre-computed, or "none"}

## Prompts & Actions

### {Topic 1}

**User:** "{Verbatim user prompt, including typos}"

**Claude:** {Concise summary of action taken — files touched, commands run, decisions made}

**User:** "{Next prompt}"

**Claude:** {Action summary}

### {Topic 2}
...

## Learnings

### 1. {Descriptive Title}
**Topics:** {topic1, topic2}
**Context:** {What situation led to this}
**Learning:** {The key insight}
**Pattern:** (optional) {Code or reusable approach}

### 2. ...

(If no learnings: write "None identified this conv.")

## Decisions

### 1. {Brief Decision Title}
**Type:** Strategic | Implementation
**Topics:** {topic1, topic2}
**Trigger:** {What prompted this decision}
**Options Considered:**
1. {Option A}
2. {Option B ← Chosen}
3. {Option C}
**Decision:** {Clear statement}
**Rationale:** {Why}
**Consequences:** {What changed}

### 2. ...

(If no decisions: write "None this conv.")

## Progress

### Completed
- [x] {Subtask from PLAN.md that was finished}
- [x] {Another}

### New Subtasks Discovered
- [ ] {Task surfaced during work, not in original plan}

### Blockers
- {Problem encountered and status — or "None"}

### Open Questions
- {Unresolved item needing user input — or "None"}

## Changes

### Code repo
{git diff --stat output, or "No changes"}

{For each significant change, add context:}
- `src/path/file.ts` — {what and why}

### Docs repo
{git diff --stat output, or "No changes"}

- `docs/path/file.md` — {what and why}

### New Patterns
- {Convention or pattern established — or "None"}

### Package / Config Changes
- {Dependency added/removed, config change — or "None"}

## Tasks
{TaskList snapshot — pending items only, or "No pending tasks"}

- [ ] #{N}: {subject} — {description snippet}

## Conv Prompts
{Bulleted list of every user prompt from this conversation, verbatim (including typos). One bullet per prompt. This serves as a quick-scan index of what the user asked for.}

- "{first user prompt}"
- "{second user prompt}"
- ...

## Uncategorized
{Anything unusual, unexpected, or not easily categorized. Record observations that don't fit above — patterns, anomalies, behavioral notes. This section helps calibrate the skill over time.}

{If nothing: "None"}
```

**CRITICAL:** The extract file MUST be written to disk before proceeding to Step 3. Agents read it from the filesystem.

**Create the prune manifest:** After writing the Extract, create an empty manifest file that agents will append to:

```bash
echo -n > ~/projects/peerloop-docs/.extract-manifest.txt
```

The manifest path is: `~/projects/peerloop-docs/.extract-manifest.txt` (in the docs repo root, gitignored). This path is required because subagents run under a sandbox that blocks writes to `/tmp`.

### Step 3: DISPATCH — Launch 3 Agents

Launch all 3 agents in a **single message** (parallel execution). Each agent reads the extract file and a format reference file, then produces its output.

Use absolute paths for all file references. The extract is at:
`~/projects/peerloop-docs/docs/sessions/{MONTH}/{FILENAME} Extract.md`

The refs are at:
`~/projects/peerloop-docs/.claude/skills/r-end/refs/fmt-{name}.md`

**Model selection:** pass the `model` parameter to each `Agent` tool call using the value shown in the heading annotation below (and in the "Agent models" entry of the Pre-computed Context section at the top of this skill). If a model value is missing or reads `(config unavailable …)`, omit the `model` parameter — the agent inherits the main context model.

---

**Agent 1: learn-decide** (model: !`node -e "console.log(require('~/projects/peerloop-docs/.claude/config.json').rEnd.agentModels.learnDecide)" 2>/dev/null || echo "(inherit)"`)

```
You are the learn-decide agent for Conv {NNN}.

YOUR TASK: Create learnings and decisions files from a conv extract.

READ THESE FILES:
1. {EXTRACT_PATH} — focus on the §Learnings and §Decisions sections. NOTE THE LINE NUMBERS shown by the Read tool — you will need them for the prune manifest.
2. {REFS_PATH}/fmt-learn-decide.md — format rules, topic routing, decision criteria

WRITE THESE FILES in {SESSION_DIR}/:
1. {FILENAME} Learnings.md — always create this
2. {FILENAME} Decisions.md — only if §Decisions has entries (skip if "None")

ALSO: If any decisions qualify as "important" per the format rules criteria, append them to:
- docs/decisions/ chunks (for code topics: d1, stripe, auth, astro, testing, cloudflare, stream, video, deployment) — 3-step write-path: matching `01`–`11` chunk (latest-wins) + dated entry in `docs/decisions/decision-log.md` + title in `docs/decisions/INDEX.md`. See fmt-learn-decide.md § Decision Routing. (NOT the now-pointer `docs/DECISIONS.md`.)
- DOC-DECISIONS.md (for docs topics: docs-infra, dual-repo, cc-workflow, obsidian)
Update the "Last Updated" date on any file you modify.

ALSO: Check §Decisions, §Learnings, and §Progress for timeline-worthy events. If any qualify per the significance criteria in the format rules, append them to TIMELINE.md. See fmt-learn-decide.md for the format and criteria.

PRUNE MANIFEST: After writing your output files, record which Extract lines you consumed. For every line from the Extract that you included in Learnings.md or Decisions.md, append its line number to the manifest file. One line number per line, using Bash:
  echo "{line_number}" >> ~/projects/peerloop-docs/.extract-manifest.txt
You can batch this: echo -e "79\n80\n81\n82" >> ~/projects/peerloop-docs/.extract-manifest.txt
Only record lines whose content you actually copied — not lines you merely read for context.
NOTE: Do NOT write to `/tmp` — the subagent sandbox blocks it. The manifest path above is the only supported location.

When done, respond with EXACTLY this format:
LEARN-DECIDE COMPLETE
  Learnings: {count}
  Decisions: {count}
  Important routed: {count} ({target files or "none"})
  Timeline entries: {count}
  Manifest lines: {count}
```

---

**Agent 2: update-plan** (model: !`node -e "console.log(require('~/projects/peerloop-docs/.claude/config.json').rEnd.agentModels.updatePlan)" 2>/dev/null || echo "(inherit)"`)

```
You are the update-plan agent for Conv {NNN}.

YOUR TASK: Update PLAN.md AND per-block plan files with progress from this conversation.

READ THESE FILES:
1. {EXTRACT_PATH} — focus on §Progress and §Changes sections
2. {REFS_PATH}/fmt-update-plan.md — format rules and block completion logic
3. PLAN.md — current state (read fully). Block Sequence rows ending with `→ [plan/<slug>/README.md](...)` identify MIGRATED blocks whose canonical detail lives outside PLAN.md.
4. plan/COMPLETED.md — read if a block appears fully complete
5. plan/<slug>/README.md — READ for EVERY migrated block this conv advanced (per the pointers in PLAN.md). This is the canonical detail; PLAN.md only carries the thin table-row summary.
6. plan/matt/<phase|sibling>.md — for MATT-family work, also read the relevant phase file (e.g., phase-5-pg2.md, standin-matt.md, cutover.md). plan/matt/README.md is the family index.

MODIFY THESE FILES:
1. PLAN.md — for inline (non-migrated) blocks: check off subtasks, add new subtasks, update inline content. For migrated blocks: update only the Block Sequence table-row status cell when the high-level status changes.
2. plan/<slug>/README.md — for migrated single blocks: this is where subtask check-offs, new subtasks, status changes, and Conv-N progress notes live (NOT in PLAN.md's table row beyond the thin summary).
3. plan/matt/<phase|sibling>.md — for MATT-family work, edit the per-phase / per-sibling file. Update plan/matt/README.md only if family-level status changes.
4. plan/COMPLETED.md — only if a block fully completes (add terse archive entry per format rules).

Do NOT touch files outside `PLAN.md`, `plan/COMPLETED.md`, or the `plan/` directory tree.

When done, respond with EXACTLY this format:
PLAN-UPDATE COMPLETE
  Subtasks checked off: {count}
  New subtasks added: {count}
  Blocks completed: {list or "none"}
  Plan files modified: {comma-separated list, e.g. "PLAN.md, plan/calendar/README.md" or "PLAN.md only"}
```

---

**Agent 3: docs** (model: !`node -e "console.log(require('~/projects/peerloop-docs/.claude/config.json').rEnd.agentModels.docs)" 2>/dev/null || echo "(inherit)"`)

```
You are the docs agent for Conv {NNN}.

YOUR TASK: Keep the DRIFT-CHECK doc set in sync with code changes this
conversation. "No docs needed updating" is a valid and COMMON outcome — most
convs touch few or no drift-check docs. Do NOT manufacture edits to look busy.

SCOPE (Conv 200 policy — read this before acting):
- You maintain ONLY docs whose registry category is `driftCheck`. Resolve a
  doc's category with: `node {DOCS_REPO}/.claude/scripts/docs-registry.mjs doc-category <relpath>`
- `manual` docs (vendor docs, DEVELOPMENT-GUIDE, POLICIES, guides, governance),
  `archival`, and `generated` docs are OUT OF SCOPE. Do not edit them, and do
  NOT report gaps against them. Their currency is editorial, not your job.
- Prose updates to a drift-check doc are allowed ONLY when this conv actually
  changed that doc's subject AND its stated scope is now wrong. Adding a
  speculative "new section" because a pattern *might* be worth documenting is
  exactly the over-maintenance we removed — don't.

READ THESE FILES:
1. {EXTRACT_PATH} — focus on §Changes section
2. {REFS_PATH}/fmt-docs.md — change detection matrix, checklists, script paths

RUN THESE SCRIPTS (read their output, then act on findings):
1. {DOCS_REPO}/.claude/skills/r-end/scripts/detect-changes.sh
2. {DOCS_REPO}/.claude/scripts/sync-gaps.sh        — deterministic coverage gaps (API/CLI/scripts/tests)
3. {DOCS_REPO}/.claude/scripts/tech-doc-sweep.sh   — already category-gated; only surfaces driftCheck docs
4. {DOCS_REPO}/.claude/skills/r-end/scripts/dev-env-scan.sh

PRIORITIES (cheapest, most deterministic first):
1. Fix the concrete coverage gaps sync-gaps reports (undocumented API routes,
   scripts, tests) — these are mechanical and the docs are near-generated.
2. Route docs are regenerated DETERMINISTICALLY by Step 5c (regen-generated-docs.mjs)
   — do NOT run route-matrix.mjs / route-api-map.mjs yourself, and do not report
   `generated`-category docs (route-api-map.md, page-connections.md, ROUTE-*.tsv) as
   gaps. They're out of scope, like manual/archival. (Conv 246 [DOCGEN].)
3. Update a flagged drift-check doc ONLY if its scope is genuinely now wrong.

IMPORTANT CONSTRAINTS:
- Do NOT touch PLAN.md or plan/COMPLETED.md (managed by update-plan agent)
- Report gaps ONLY for driftCheck docs — the main context will TaskCreate them.
  Never report a gap whose doc is manual/archival/vendor; "this vendor doc is
  stale" is not a gap, it's by design.

When done, respond with EXACTLY this format:
DOCS-UPDATE COMPLETE
  Docs modified: {list or "none"}
  Gaps found (for TaskCreate): {driftCheck-only list, or "none"}
```

---

### Step 4: GATHER — Process Agent Results

After all 3 agents return:

1. **Verify outputs exist:**
   - `docs/sessions/{MONTH}/{FILENAME} Learnings.md` — must exist
   - `PLAN.md` — check if modified (git diff)
   - Note any missing outputs

2. **Capture gaps from docs agent:** If the docs agent reported gaps, create a TaskCreate entry for each one.

3. **Note any agent failures:** If an agent failed or returned an error, note which one and continue. Do NOT retry — proceed with remaining steps.

4. **Surface issues (red alert) AND create tasks:** For EVERY issue found by any agent — gaps, failures, errors, warnings, unexpected behavior — display with red emoji prefix AND call TaskCreate so the issue is persisted to `CURRENT-TASKS.md` at Step 5:

```
🔴🔴🔴 {Agent name}: {Issue description}
    → TaskCreate: {task subject}
```

**CRITICAL: After displaying each red alert, immediately call TaskCreate** with the issue as the subject. This is not optional — issues that are only displayed but not written to TodoWrite vanish when the conv ends.

This applies to: docs agent gap reports, agent failures, missing output files, file write errors, and anything unexpected in agent return values. If no issues were found, display nothing (no "all clear" message needed).

5. **Surface uncategorized items (orange alert) AND create tasks:** Read the extract's §Uncategorized section. For each non-"None" entry, display with orange emoji prefix AND call TaskCreate:

```
🟠🟠🟠 Uncategorized: {observation}
    → Suggestion: {what to do}
    → TaskCreate: {task subject}
```

**CRITICAL: After displaying each orange alert, immediately call TaskCreate** with a subject that includes the suggestion. Every surfaced item — red or orange — must flow into TodoWrite so it persists to `CURRENT-TASKS.md` (via the Step 5 refresh). Displaying without TaskCreate is a known failure mode (Conv 062).

If §Uncategorized is "None", display nothing.

### Step 4b: PRUNE EXTRACT (manifest-based)

Agent 1 (learn-decide) appended consumed line numbers to `~/projects/peerloop-docs/.extract-manifest.txt` during its work. Now use this manifest to prune the Extract of duplicated §Learnings and §Decisions content. All other sections (including §Changes, §Prompts & Actions, §Conv Prompts) remain in the Extract — there is no Dev.md to duplicate them.

**How to prune:**

1. Read `~/projects/peerloop-docs/.extract-manifest.txt`. It contains one line number per line (integers). If empty or missing, skip pruning (agent may have found nothing to consume).

2. Read the Extract file to get its current content.

3. Sort the manifest line numbers in **descending order** (highest first).

4. Remove each listed line from the Extract, working top-down through the sorted list. Descending order ensures earlier line numbers remain valid as later lines are deleted.

5. Where a removed section leaves an orphaned `## Heading` with no content before the next heading, insert a pointer line:
   - Under `## Learnings`: `→ See \`{FILENAME} Learnings.md\``
   - Under `## Decisions`: `→ See \`{FILENAME} Decisions.md\``

6. Clean up the manifest: `rm ~/projects/peerloop-docs/.extract-manifest.txt`

**Why this works:** The Extract is immutable after Step 2 — no agent writes to it, so line numbers recorded during agent execution remain valid. Descending-order deletion prevents line-number cascade.

**If manifest is empty:** No pruning needed — agent consumed nothing (unusual but safe). The Extract stays as-is.

### Step 4c: REASSESS OPUS TAGS

**Purpose:** Apply judgment, once per conv, to decide which pending tasks warrant an `[Opus]` suffix — so the model-tier call is made deliberately at session boundary rather than under-applied during foreground work. The tag perpetuates via the task's `[CODE]` row in `CURRENT-TASKS.md` (preserved verbatim by the preserve-then-overlay refresh), so tagging a task once carries forward until it's completed or explicitly re-scoped.

**Actions:**

1. Call `TaskList` to snapshot all pending + in_progress tasks (completed tasks do not carry forward — skip them).
2. For each task, assess against the rubric below.
3. For each task whose tag state should change, call `TaskUpdate` to set the new subject — append ` [Opus]` if it newly qualifies, or strip the trailing ` [Opus]` if a prior tag no longer applies (e.g., task scope shrank, or the Opus-worthy piece already landed and what remains is rote). Description is not modified.
4. Report a summary.

**Rubric — tag `[Opus]` only when the task involves ONE OR MORE of:**

- **Architectural lock-in** — decisions that shape schema, API contracts, or module boundaries and will be costly to revisit. *(Peerloop examples: new columns on `users`/`sessions`/`courses`/`enrollments`; new `/api/*` endpoint shape or auth contract; JWT payload changes; Stripe webhook event-type handling.)*
- **Multi-dimension design** — balancing several trade-offs simultaneously where a weaker model under-explores the option space. *(Peerloop examples: payment/commission split logic with dispute + refund + payout edges; video provider (BBB ↔ PlugNmeet) failover; smart-feed scoring weights; flywheel role transitions — student → teacher certification, teacher → creator.)*
- **Subtle refactors** — cross-cutting changes where local correctness depends on distant invariants. *(Peerloop examples: SSR loader consolidation across multiple `.astro` pages; access-control predicate changes touching several endpoints; timezone handling across availability → booking → session room → email.)*
- **High-stakes migrations** — irreversible or high-blast-radius changes where a wrong call carries real cost. *(Peerloop examples: production D1 schema migrations; `peerloop.com` DNS cutover between Pages and Workers; Stream.io user-ID backfills; Stripe live-mode key rotations.)*
- **Novel prompt / LLM wiring** — designing LLM calls where prompt shape, response schema, and failure modes all need to be reasoned about together.

**Do NOT tag `[Opus]`:**

- Doc sweeps, renames, terminology updates. *(e.g., TEST-COVERAGE.md count fixes, `route-api-map.mjs` regen, vendor-doc caveat additions.)*
- Rote implementations following a locked spec (the spec-writing was the Opus work).
- Test additions, fixture updates, magic-number removals.
- Tooling / hook / config / skill edits with known shape.
- Bug fixes with an obvious cause.
- Tasks with narrow, unambiguous acceptance criteria.

**Format & idempotency:**

- Tag format is literally ` [Opus]` appended as a suffix to the subject (leading space, brackets, exact casing). Code prefix stays in front: `[AUTH] Refresh-token fallback review [Opus]`, not `[Opus] [AUTH] …`.
- Never nest (no `[Opus] [Opus]`). If the suffix is already present, skip; if scope shrank, strip.
- Only one `[Opus]` suffix per subject. No tiered prefixes (`[Sonnet]` / `[Haiku]`) — absence of `[Opus]` implies default tier.

**Report:**

```
🎯 Opus Reassessment
  Tagged:    {count} — {list of "#N subject" or "none"}
  Untagged:  {count} — {list or "none"}
  Unchanged: {count}
```

Display this inline. If the count of changes is zero across both tagged and untagged, still display the report for auditability — visibility of "no changes" is meaningful.

### Step 4d: PRE-COMMIT CHECKPOINT — pause for additional work

**Purpose:** Steps 2–4c surface the conv's actionable residue — red/orange alerts, the Extract's §Open Questions and §Blockers, observations from the agents. Historically these get *displayed* and then the conv closes (Steps 5–8 save, commit, push, and delete `.conv-current`), so the user reads a meaningful issue exactly when it is too late to act on it this conv. This checkpoint inserts a deliberate pause **before** anything irreversible, so the user can choose to act now.

**Actions:**

1. Assemble a short digest of everything surfaced this conv that the user might want to act on *now*:
   - Every 🔴 / 🟠 alert raised in Step 4
   - The Extract's §Open Questions and §Blockers (non-"None" entries)
   - Any notable observation from an agent return that is not already captured as a task

   If all of these are empty, state `Nothing outstanding surfaced this conv.` — but still ask the question (the user may have an item of their own).

2. Present the digest, then ask:

```
👉👉👉 **Anything you want to act on before I commit, push, and close? (yes / no)**
```

**HALT and wait.** This is a mandatory pause point — do not proceed to Step 5 until the user answers.

3. **On `no`:** proceed to Step 5.

4. **On `yes`:** carry out the requested work to completion, then fold it in by one of two paths:
   - **Substantive changes** (code edited, docs authored, files added/removed): return to **Step 2** and rebuild the Extract so the new work is captured, then re-run Steps 3–4c and arrive back at this checkpoint. Repeat until the user answers `no`. Re-running the 3 agents is the cost of capturing new learnings/decisions correctly — accept it when real work happened.
   - **Trivial / non-file changes** (answered a question, created a task, one-line tweak): skip the rebuild — update the Extract's §Changes / §Progress / §Tasks in place to reflect it, then re-ask the checkpoint question.

   Use judgment on which path; when unsure, prefer the rebuild — a stale Extract is the more expensive mistake.

### Step 5: SAVE STATE (inline)

**Timing note:** This step runs *before* the commit (Step 6). Any git HEADs or commit hashes referenced in Key Context describe the pre-commit state, not the final committed state. When referencing branch state, describe uncommitted changes as "will be committed in Step 6" rather than claiming specific commit hashes. `/r-start` consumers should treat Key Context as the conv's pre-close snapshot, not a post-commit record.

1. Call `TaskList` to capture this conv's task state (in-progress / pending / completed).
2. **Refresh `CURRENT-TASKS.md`** (the persistent task store) via **preserve-then-overlay** — the engine specified in `/r-update-tasks`. Either invoke the `r-update-tasks` skill or inline its logic: read the existing `CURRENT-TASKS.md`; parse the H3 `[CODE]` rows under `## 🔥 Ordered` and `## 📋 Unordered backlog`, **preserving** document order, the `> ## ⏸️ PARKED` divider, and every `Why:` line verbatim; overlay live statuses by `[CODE]` (force `· 🔄 Active ·` on in_progress Ordered rows; preserve the hand-set ★ Next / 📋 Planned / ⏸️ On hold symbol on pending rows; **never delete an unmatched row** — active-only TodoWrite means backlog/Parked rows routinely have no `TaskList` counterpart and MUST be preserved); append any new-this-conv pending/in-progress tasks to the backlog **immediately above the Parked divider**; move code-matched **completed** tasks to `## ✅ Completed this conv`; bump the `Last refreshed` date. `Write` the file (full overwrite, never `Edit`). **Run this BEFORE clearing TodoWrite (step 4)** — the overlay reads live statuses, so they must still be accurate.
3. **Write `RESUME-STATE.md` (NARRATIVE only — [CURTASKS], Conv 351)** in the docs repo root. Task data (the old `## Remaining` / `## TodoWrite Items`) now lives in `CURRENT-TASKS.md`; RESUME-STATE is the per-conv **narrative** handoff the next `/r-start` reads for context, then deletes. **Keep the `Branch` line** — `conv-branch-check.sh` + `[RSTART-DIFFGATE]` depend on it. Format:

```markdown
# State — Conv {NNN} ({YYYY-MM-DD} ~{HH:MM})

**Conv:** ended
**Machine:** {machine from pre-computed}
**Branch:** code: `{branch}`, docs: `main`

## Summary

{2-3 sentence description of what this conv did and where it stopped}

## Key Context

{Critical knowledge needed to resume — decisions, gotchas, file paths, workarounds. For the task backlog, point at `CURRENT-TASKS.md`; do NOT re-list pending tasks here.}

## Resume Command

To continue: run `/r-start` — it reads `CURRENT-TASKS.md` for the task sequence and this narrative for context.
```

4. Mark all this conv's tasks as completed via `TaskUpdate` (their state is now persisted in `CURRENT-TASKS.md`; clearing TodoWrite leaves the next conv to start empty — active-only model).
5. Note `State Saved ✅ (CURRENT-TASKS.md refreshed; RESUME-STATE.md narrative written)`

### Step 5b: Sync memory live → mirror

Mirror the live memory directory into the in-repo mirror so any memory changes from this conv are captured in the commit. Place this step **after** Step 5 (RESUME-STATE.md is written) and **before** Step 6 (which commits everything). Steps 2–4 (collector + agents) do not write to the memory dir, so the latest possible memory writes are mid-conv user prompts that have already settled by this point.

```bash
SLUG=$(echo ~/projects/peerloop-docs | tr / -)
LIVE=~/.claude/projects/$SLUG/memory
MIRROR=~/projects/peerloop-docs/.claude/memory-sync/memories

mkdir -p "$MIRROR"
rsync -a --delete "$LIVE/" "$MIRROR/"
```

The `git add .` in Step 6 picks up any mirror changes — no explicit `git add` needed here.

**First-run bootstrap:** If the mirror dir does not yet exist, `mkdir -p` creates it and rsync populates it from live. No separate setup needed; the first `/r-end` (or `/r-commit`) after this skill change lands seeds the mirror naturally.

**Commit body convention:** Memory-sync mirror changes are typically routine background. Do NOT add a `### Infra Changes` bullet for them unless this conv's substance was actually about memory-system work. Mention them only when meaningful.

### Step 5c: Regenerate generated docs (deterministic gate)

Run the generated-doc regen gate **before** the commit and **before** the drift-baseline advance — the gate reads `.drift-baseline-sha` to find this conv's code changes, so advancing the baseline first (Step 6) would zero its change set:

```bash
node ~/projects/peerloop-docs/.claude/scripts/regen-generated-docs.mjs
```

For each `generated` registry group with a `regen` binding (currently `route-docs-generated` → the route maps + `tests/plato/route-map.generated.ts`), the gate re-runs that group's `commands` **only if** this conv's code changes touched any of its `inputs` globs (`src/pages/**`, `src/components/**`, `src/lib/**`), then stages the output in **both** repos. On convs that didn't touch route source it does nothing (so day-stamped generated docs like `page-connections.md` don't churn). This is what makes "regenerate stale route docs" a **deterministic step, not a recurring task** — generated docs are regenerated here, never `TaskCreate`d. Bindings live in `.claude/config.json` docsRegistry. (Conv 246 [DOCGEN].)

### Step 6: COMMIT (inline, v2 format)

Stage and commit both repos. **Code repo first, then docs repo.**

**Before committing the docs repo**, advance the drift baseline so the next SessionStart shows only new drift:

```bash
bash ~/projects/peerloop-docs/.claude/scripts/advance-drift-baseline.sh
```

This records the current code repo HEAD in `.claude/.drift-baseline-sha` so `tech-doc-sweep.sh` diffs from this point forward. Run it after the code repo commit so the SHA is final.

**Canonical spec:** `docs/reference/COMMIT-MESSAGE-FORMAT.md`. Author-time digest follows.

For each repo with changes:

```bash
git -C {REPO_PATH} add .
git -C {REPO_PATH} commit -m "Conv {NNN}: {title}

### Work Effort
- [TAG] bullet describing an effort thread

### User-facing
- visible change for regular users

### Admin-facing
- admin-only change

### API Changes
- METHOD /path — description

### Page Changes
- /route — description

### Role Changes
- RoleName — description

### Infra Changes
- tool/skill/script — description

### Doc Changes
- docfile.md — description

### DB Changes
- migrations/N_schema.sql — description

### Testing
- tests/path.test.ts — description

### Code Changes
- src/path.ts — description

Stats: {N} files changed
Block: {BLOCKNAME}
Conv: {NNN}
Machine: {MACHINE}
Type: end-of-conv
Format: v2
Block-summary: One sentence describing what this commit achieved toward its Block.

Co-Authored-By: Claude <noreply@anthropic.com>"
```

**Field order is fixed.** Blank lines separate subject from body, body-H3s from trailers, and trailers from the `Co-Authored-By` footer. No blank lines within an H3's bullet list or within the trailer block.

### Authoring rule: write each bullet ONCE, in the H3 that best describes what the bullet fundamentally is.

`/r-timecard-day2` evaluates each H4's inclusion predicate independently over every bullet and replicates matching bullets into every H4. A bullet under `### Work Effort` mentioning `/api/foo` and `API-REFERENCE.md` will render in Work Effort, API Changes, *and* Doc Changes. You may duplicate a bullet under multiple H3s to force placement when a predicate wouldn't match; the parser dedups per-H4 by exact text.

**H3 sections — all optional.** Emit only sections with content. `/r-end2` commits are docs-heavy — most bullets usually land in `### Work Effort`, with a few in `### Infra Changes` (skill/script/hook changes) and `### Doc Changes` (when real doc authorship happened).

**`### Doc Changes` exclusion list — DO NOT create a Doc Changes bullet whose only content is one of these files:**
- Session-tracking files under `docs/sessions/**` (Extract / Learnings / Decisions)
- `PLAN.md`, `plan/COMPLETED.md`, `TIMELINE.md`
- `DECISIONS.md`, `DOC-DECISIONS.md`, `docs/decisions/**`
- `RESUME-STATE.md`, `CURRENT-TASKS.md`

These are conv bookkeeping, not doc authorship. `/r-end2` always touches several of them — mentions are filtered out by the timecard's `routineStrip`. Only put a bullet in `### Doc Changes` when the conv authored content in `docs/reference/`, `docs/guides/`, `docs/as-designed/`, `docs/as-built/`, or CLAUDE.md-level files.

**H5/H6 are dynamic** — the parser derives them from bullet content. Authors only emit `### H3` section headers in commits.

**`Block-summary:`** — one-line prose summary, written from the Block's perspective, summarizing what this conv contributed (docs, decisions, plan updates, new reference material). Required when Block is NOT `(misc)`. Single line, 80–150 chars preferred.

**`Format: v2`** — mandatory trailer on all `/r-end2` commits. `/r-timecard-day2` uses this marker to detect v2 format.

**`Type: end-of-conv`** — always include on `/r-end2` commits. This marks the commit as the conv-boundary pair to the corresponding `Conv NNN start — MACHINE` heartbeat from `/r-start`. Metadata-only; timecard tools treat it identically to a regular commit for rollup purposes.

**Block determination rules:**
1. Look at the actual changes being committed (the diff, not the PLAN.md focus block)
2. Identify which PLAN.md block(s) the changes advance — a block is "advanced" if the work directly relates to one of its items or subtasks
3. Apply:
   - **One block advanced:** `Block: BLOCKNAME`
   - **Multiple blocks advanced:** `Block: BLOCK1, BLOCK2`
   - **No block advanced** (tooling, infra, misc config, docs-only housekeeping): `Block: (misc)`
4. Do NOT default to the Focus block — only claim blocks whose work items were actually advanced

If a repo has nothing to commit, skip silently.

**Post-commit drift check:** After committing both repos, run `git status --short` in each repo. If any tracked files still show as modified (agent writes that landed after `git add .`), amend the relevant commit:

```bash
# For each repo with leftover modifications:
git -C {REPO_PATH} add .
git -C {REPO_PATH} commit --amend --no-edit
```

If the drift check amends, note it in the Step 9 summary: `6. Committed ✅ (drift amended)`.

### Step 7: PUSH

```bash
git -C ~/projects/peerloop-docs push
git -C ~/projects/Peerloop push
```

If either push fails, **HALT** and tell the user. Do not report success.

### Step 8: CLEANUP

Remove the conv marker and release the concurrent-session lock (Conv 293). The lock is owner-checked — `release` only removes it if it belongs to this session, so it can never clear another terminal's lock. (Even if this step is skipped — e.g. a crash before `/r-end` — the lock self-heals: the next `/r-start` sees the dead `claude` PID and reports STALE.)

```bash
rm ~/projects/peerloop-docs/.conv-current
~/projects/peerloop-docs/.claude/scripts/conv-session-lock.sh release
```

### Step 9: SUMMARY

```
╔═══════════════════════════════════╗
║  Conv {NNN} closed                ║
╚═══════════════════════════════════╝

End-of-Conv Complete
────────────────────
1. Learn/Decide  ✅
2. Plan Update    ✅
3. Docs Update    ✅
4. Extract Pruned ✅
5. Opus Reassess  ✅
6. State Saved    ✅ or ⏭️
7. Committed      ✅
8. Pushed         ✅
   Docs: ✅
   Code: ✅

Extract: docs/sessions/{MONTH}/{FILENAME} Extract.md

Next:
  • type /clear to start a new conv (then /r-start)
  • type /quit to exit (a new version may be available)
```

If any agent failed, replace its ✅ with ⚠️ and note the failure below the summary.

**This is the end of the flow — display the summary and stop.** The two `Next:` lines are instructions for the user to type, not actions to run. Do NOT invoke `/clear`, `/r-start`, or any Skill tool here; the conv is already closed (push done in Step 7, `.conv-current` removed in Step 8).

---

## Rules

- **HALT if no active conv** — `.conv-current` must exist
- **HALT on push failure** — do not report success if either push fails
- **Extract MUST be on disk before dispatching agents** — agents read it from the filesystem
- **Conv-scoped scratch notes are COLLECT inputs** — Step 2 globs `.scratch/conv-<NNN>-*.md` (padded conv number) and folds them into the Extract; this is how decisions/learnings survive a mid-conv `/compact`
- **All 3 agents launch in one message** — parallel execution, no sequencing
- **After agents complete, Steps 4-9 MUST still execute** — do NOT stop after dispatch
- **HALT at the Step 4d pre-commit checkpoint** — always pause and ask before Steps 5–8 (save/commit/push/cleanup); on additional substantive work, loop back to Step 2 to recapture it
- **If an agent fails, note it and continue** — do NOT retry; proceed with remaining steps
- **Delete `.conv-current` only after successful push** of both repos
- **Do NOT use the Skill tool** — the flow ends by displaying the Step 9 summary and stopping; `/clear` and `/r-start` are printed for the user to type, not invoked by r-end

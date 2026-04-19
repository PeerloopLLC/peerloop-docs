---
name: r-end2
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
!`$CLAUDE_PROJECT_DIR/.claude/scripts/conv-read-current.sh`

**Shared timestamp:**
!`echo "MONTH: $(date '+%Y-%m')" && echo "FILENAME: $(date '+%Y%m%d_%H%M')"`

**Repo status:**
!`$CLAUDE_PROJECT_DIR/.claude/scripts/dual-repo-status.sh`

**Active blocks:**
!`sed -n '/^### ACTIVE$/,/^### /p' PLAN.md 2>/dev/null | grep '^| [A-Z]' || echo "(none)"`

**Focus block:**
!`grep '^## Active:' PLAN.md 2>/dev/null | head -1 | sed 's/^## //' || echo "(none)"`

**Enabled commit tags:**
!`node -e "console.log(require('$CLAUDE_PROJECT_DIR/.claude/config.json').commitTags.join(', '))" 2>/dev/null || echo "(config unavailable)"`

**Existing conv files this month:**
!`$CLAUDE_PROJECT_DIR/.claude/scripts/conv-files-learn-decide.sh`

**Existing state file:**
!`$CLAUDE_PROJECT_DIR/.claude/scripts/resume-state-check.sh`

**Code repo branch:**
!`git -C $CLAUDE_PROJECT_DIR/../Peerloop branch --show-current 2>/dev/null || echo "(unknown)"`

---

## Paths

- Docs repo: `git -C $CLAUDE_PROJECT_DIR ...`
- Code repo: `git -C $CLAUDE_PROJECT_DIR/../Peerloop ...`
- Agent refs: `$CLAUDE_PROJECT_DIR/.claude/skills/r-end/refs/`
- Docs scripts: `$CLAUDE_PROJECT_DIR/.claude/skills/r-end/scripts/`

---

## Execution Flow

### Step 1: Validate Conv

Read `.conv-current`. If missing or says "MISSING", **HALT** — tell the user to run `/r-start` first.

Extract the padded conv number (e.g., `031`) for use throughout.

### Step 2: COLLECT — Build the Extract

Scan the **entire conversation** and produce a structured extract file. This is the most important step — every agent depends on the quality of this extract.

**Actions:**

1. Run `git -C $CLAUDE_PROJECT_DIR diff --stat` and `git -C $CLAUDE_PROJECT_DIR/../Peerloop diff --stat` to capture file changes
2. Call `TaskList` to snapshot pending tasks
3. Scan the conversation chronologically, populating each section below
4. Write the extract to `docs/sessions/{MONTH}/{FILENAME} Extract.md`

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
echo -n > "$CLAUDE_PROJECT_DIR/.extract-manifest.txt"
```

The manifest path is: `$CLAUDE_PROJECT_DIR/.extract-manifest.txt` (in the docs repo root, gitignored). This path is required because subagents run under a sandbox that blocks writes to `/tmp`.

### Step 3: DISPATCH — Launch 3 Agents

Launch all 3 agents in a **single message** (parallel execution). Each agent reads the extract file and a format reference file, then produces its output.

Use absolute paths for all file references. The extract is at:
`$CLAUDE_PROJECT_DIR/docs/sessions/{MONTH}/{FILENAME} Extract.md`

The refs are at:
`$CLAUDE_PROJECT_DIR/.claude/skills/r-end/refs/fmt-{name}.md`

---

**Agent 1: learn-decide**

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
- docs/DECISIONS.md (for code topics: d1, stripe, auth, astro, testing, cloudflare, stream, video, deployment)
- DOC-DECISIONS.md (for docs topics: docs-infra, dual-repo, cc-workflow, obsidian)
Update the "Last Updated" date on any file you modify.

ALSO: Check §Decisions, §Learnings, and §Progress for timeline-worthy events. If any qualify per the significance criteria in the format rules, append them to TIMELINE.md. See fmt-learn-decide.md for the format and criteria.

PRUNE MANIFEST: After writing your output files, record which Extract lines you consumed. For every line from the Extract that you included in Learnings.md or Decisions.md, append its line number to the manifest file. One line number per line, using Bash:
  echo "{line_number}" >> $CLAUDE_PROJECT_DIR/.extract-manifest.txt
You can batch this: echo -e "79\n80\n81\n82" >> $CLAUDE_PROJECT_DIR/.extract-manifest.txt
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

**Agent 2: update-plan**

```
You are the update-plan agent for Conv {NNN}.

YOUR TASK: Update PLAN.md with progress from this conversation.

READ THESE FILES:
1. {EXTRACT_PATH} — focus on §Progress and §Changes sections
2. {REFS_PATH}/fmt-update-plan.md — format rules and block completion logic
3. PLAN.md — current state (read fully)
4. COMPLETED_PLAN.md — read if a block appears fully complete

MODIFY THESE FILES:
1. PLAN.md — check off completed subtasks, add new subtasks, update status, update Block Sequence table if needed
2. COMPLETED_PLAN.md — only if a block fully completes (add terse archive entry per format rules)

Do NOT touch any other files.

When done, respond with EXACTLY this format:
PLAN-UPDATE COMPLETE
  Subtasks checked off: {count}
  New subtasks added: {count}
  Blocks completed: {list or "none"}
```

---

**Agent 3: docs**

```
You are the docs agent for Conv {NNN}.

YOUR TASK: Update project documentation based on code changes this conversation.

READ THESE FILES:
1. {EXTRACT_PATH} — focus on §Changes section
2. {REFS_PATH}/fmt-docs.md — change detection matrix, checklists, script paths

RUN THESE SCRIPTS (read their output, then act on findings):
1. {DOCS_REPO}/.claude/skills/r-end/scripts/detect-changes.sh
2. {DOCS_REPO}/.claude/scripts/sync-gaps.sh
3. {DOCS_REPO}/.claude/scripts/tech-doc-sweep.sh
4. {DOCS_REPO}/.claude/skills/r-end/scripts/dev-env-scan.sh

MODIFY docs as indicated by the change detection matrix in the format rules file.

IMPORTANT CONSTRAINTS:
- Do NOT touch PLAN.md or COMPLETED_PLAN.md (managed by update-plan agent)
- Report any gaps you find but do NOT fix in your output — the main context will TaskCreate them

When done, respond with EXACTLY this format:
DOCS-UPDATE COMPLETE
  Docs modified: {list or "none"}
  Gaps found (for TaskCreate): {list or "none"}
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

4. **Surface issues (red alert) AND create tasks:** For EVERY issue found by any agent — gaps, failures, errors, warnings, unexpected behavior — display with red emoji prefix AND call TaskCreate so the issue is persisted to RESUME-STATE.md:

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

**CRITICAL: After displaying each orange alert, immediately call TaskCreate** with a subject that includes the suggestion. Every surfaced item — red or orange — must flow into TodoWrite so it persists to RESUME-STATE.md. Displaying without TaskCreate is a known failure mode (Conv 062).

If §Uncategorized is "None", display nothing.

### Step 4b: PRUNE EXTRACT (manifest-based)

Agent 1 (learn-decide) appended consumed line numbers to `$CLAUDE_PROJECT_DIR/.extract-manifest.txt` during its work. Now use this manifest to prune the Extract of duplicated §Learnings and §Decisions content. All other sections (including §Changes, §Prompts & Actions, §Conv Prompts) remain in the Extract — there is no Dev.md to duplicate them.

**How to prune:**

1. Read `$CLAUDE_PROJECT_DIR/.extract-manifest.txt`. It contains one line number per line (integers). If empty or missing, skip pruning (agent may have found nothing to consume).

2. Read the Extract file to get its current content.

3. Sort the manifest line numbers in **descending order** (highest first).

4. Remove each listed line from the Extract, working top-down through the sorted list. Descending order ensures earlier line numbers remain valid as later lines are deleted.

5. Where a removed section leaves an orphaned `## Heading` with no content before the next heading, insert a pointer line:
   - Under `## Learnings`: `→ See \`{FILENAME} Learnings.md\``
   - Under `## Decisions`: `→ See \`{FILENAME} Decisions.md\``

6. Clean up the manifest: `rm "$CLAUDE_PROJECT_DIR/.extract-manifest.txt"`

**Why this works:** The Extract is immutable after Step 2 — no agent writes to it, so line numbers recorded during agent execution remain valid. Descending-order deletion prevents line-number cascade.

**If manifest is empty:** No pruning needed — agent consumed nothing (unusual but safe). The Extract stays as-is.

### Step 5: SAVE STATE (inline)

**Timing note:** This step runs *before* the commit (Step 6). Any git HEADs or commit hashes referenced in Key Context describe the pre-commit state, not the final committed state. When referencing branch state, describe uncommitted changes as "will be committed in Step 6" rather than claiming specific commit hashes. `/r-start` consumers should treat Key Context as the conv's pre-close snapshot, not a post-commit record.

1. Call `TaskList` to check for pending (not completed) tasks
2. If **no pending tasks:** Note `State Saved ⏭️ (no pending tasks)` and skip to Step 6
3. If **pending tasks exist:**
   a. Read the extract's §Progress, §Tasks, and §Uncategorized sections
   b. Write `RESUME-STATE.md` in the docs repo root using this format:

```markdown
# State — Conv {NNN} ({YYYY-MM-DD} ~{HH:MM})

**Conv:** ended
**Machine:** {machine from pre-computed}
**Branch:** code: `{branch}`, docs: `main`

## Summary

{2-3 sentence description of what this conv did and where it stopped}

## Completed

{Bulleted list from extract §Progress → Completed}

## Remaining

{Group remaining items from extract §Progress + pending tasks. **Preserve any `[XX]` or `[XXX]` mnemonic-code prefix** when the item came from a TodoWrite pending task — codes must stay stable across conv boundaries so the user can continue to reference them by shortcode (see `memory/feedback_todowrite_mnemonic_codes.md`). Items that originated only in §Progress prose may be code-less; `/r-start` will assign codes on transfer.}
- [ ] [XX] {Item with enough detail to act on}

## TodoWrite Items

{All pending tasks from TaskList}
- [ ] #{N}: {subject} — {description}

## Key Context

{Critical knowledge needed to resume — decisions, gotchas, file paths, workarounds}

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.
```

   c. Mark all tasks as completed via TaskUpdate (they're now persisted in RESUME-STATE.md)
   d. Note `State Saved ✅`

### Step 6: COMMIT (inline, v2 format)

Stage and commit both repos. **Code repo first, then docs repo.**

**Before committing the docs repo**, advance the drift baseline so the next SessionStart shows only new drift:

```bash
bash $CLAUDE_PROJECT_DIR/.claude/scripts/advance-drift-baseline.sh
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
- `PLAN.md`, `COMPLETED_PLAN.md`, `TIMELINE.md`
- `DECISIONS.md`, `DOC-DECISIONS.md`
- `RESUME-STATE.md`

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
git -C $CLAUDE_PROJECT_DIR push
git -C $CLAUDE_PROJECT_DIR/../Peerloop push
```

If either push fails, **HALT** and tell the user. Do not report success.

### Step 8: CLEANUP

```bash
rm $CLAUDE_PROJECT_DIR/.conv-current
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
5. State Saved    ✅ or ⏭️
6. Committed      ✅
7. Pushed         ✅
   Docs: ✅
   Code: ✅

Extract: docs/sessions/{MONTH}/{FILENAME} Extract.md

What next?
  1) /clear — fresh context
  2) /r-start — continue with history
```

If any agent failed, replace its ✅ with ⚠️ and note the failure below the summary.

**Wait for user choice.** If they pick 1, run `/clear`. If they pick 2, invoke `/r-start` via the Skill tool.

---

## Rules

- **HALT if no active conv** — `.conv-current` must exist
- **HALT on push failure** — do not report success if either push fails
- **Extract MUST be on disk before dispatching agents** — agents read it from the filesystem
- **All 3 agents launch in one message** — parallel execution, no sequencing
- **After agents complete, Steps 4-9 MUST still execute** — do NOT stop after dispatch
- **If an agent fails, note it and continue** — do NOT retry; proceed with remaining steps
- **Delete `.conv-current` only after successful push** of both repos
- **Do NOT use the Skill tool** — except for `/r-start` if user picks option 2 at the end

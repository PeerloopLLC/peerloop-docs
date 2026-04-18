---
name: r-timecard-day2
description: Generate intelligent daily timecard — day-as-timecard billing, per-Block reporting, deterministic via .claude/scripts/timecard-day.js
argument-hint: "date (e.g., Mar-30-2026, 2026-03-30, today, yesterday)"
allowed-tools: Bash, Read, Write
---

# Generate Daily Timecard

A daily timecard for client billing. **Day = one billable timecard.** Day Summary rollups (Infra / Doc / Code / Testing / Work Effort) give the tag/file/path-dimension view; Block Progress gives the narrative-dimension view; a per-commit P1 audit is appended. All filter, routing, grouping, and markdown rendering is deterministic — the script in `.claude/scripts/timecard-day.js` owns the full render.

**Two Block Progress render modes:**
1. **Deterministic** — when every commit in a Block has a `Block-summary:` line (per `docs/reference/COMMIT-MESSAGE-FORMAT.md`), the script emits those sentences as bullets directly. **No LLM step.** Byte-identical on re-runs.
2. **Legacy fallback** — when any commit in a Block lacks a `Block-summary:`, the script emits a `<!--BLOCK_PARAGRAPH:NAME-->` placeholder for the skill to fill via LLM synthesis.

Over time, as all commits adopt `Block-summary:`, the LLM step will fall away entirely.

**Data source:** Git commit timestamps and messages from both repos. Never from conversation context.

**Commit-format spec:** `docs/reference/COMMIT-MESSAGE-FORMAT.md` (canonical).

---

## Pre-computed Context

!`cat .claude/config.json 2>/dev/null | head -60 || echo "(no config)"`

---

## Arguments

**Required:** A date in any of these formats:

| Input | Meaning |
|-------|---------|
| `Mar-30-2026` | Month-Day-Year with dashes |
| `2026-03-30` | ISO format |
| `March 30, 2026` | Natural language |
| `today` | Current date |
| `yesterday` | Previous date |

If no argument is provided, stop with: `Usage: /r-timecard-day2 Mar-30-2026`

---

## Workflow

### Step 1: Invoke the data script

Run the script with the user's date argument and capture the JSON:

```bash
node "$CLAUDE_PROJECT_DIR/.claude/scripts/timecard-day.js" <date>
```

If exit code ≠ 0, surface the stderr message to the user and stop.

The JSON output includes (unchanged from before): `window`, `billing`, `convs`, `blocks`, `skippedConvs`, `warnings`, `overflow`, `commits`, `blockProgress`, `dayTags`, `dayWorkEffort`, `candidateBranches`.

**New:** `renderedMarkdown` — the full timecard markdown with `<!--BLOCK_PARAGRAPH:{blockName}-->` placeholders where Block-progress paragraphs belong. This is the only content you render; everything else is already done.

### Step 2: Branch selection (only if needed)

Inspect `candidateBranches[]` from the JSON. If **every** entry has `isHead: true`, skip silently and proceed.

If **any** entry has `isHead: false`, display the list with `[HEAD]` markers and prompt:

```
🔔 Branches with commits on <date>:
  * docs/main         (8 commits)   [HEAD]
    docs/jfg-dev-10up (3 commits)
  * code/main         (4 commits)   [HEAD]

👉👉👉 Include all branches listed above, or deselect some?
    (Enter = include all • space-separated branch names to exclude)
```

If the user excludes branches, re-invoke the script:

```bash
node "$CLAUDE_PROJECT_DIR/.claude/scripts/timecard-day.js" <date> --exclude-branches "br1 br2"
```

If the user excludes everything, display `No branches selected — nothing to process.` and stop.

### Step 3: Handle empty / anomalous outputs

- **No commits found:** `commits[]` is empty → display `No commits found for <date>.` and stop.
- **Skipped Convs / Warnings / Overflow:** the script has already included top-of-file notes and adjusted `renderedMarkdown`. Nothing extra to do.

### Step 4: Fill Block-Progress bullets (LLM fallback only)

**Check first:** scan `renderedMarkdown` for `<!--BLOCK_PARAGRAPH:` markers.

- **No markers present** → deterministic mode. The script already emitted Block-summary bullets directly from commit metadata. Skip to Step 5.
- **Markers present** → legacy fallback. Any marker means at least one commit in that block lacked a `Block-summary:` line. Fill each marker with synthesized bullets (procedure below).

For each placeholder in `renderedMarkdown`, write **2–5 synthesized bullets** describing what that Block (or sub-phase) achieved today, from the Block's perspective. This is the narrative-dimension view — bullets are already visible above in Day Summary rollups (grouped by tag / file / path), so the job here is **synthesis, not enumeration**. Each bullet should be a short, client-readable sentence summarizing a thread of work, not a copy-paste of a raw Changes/Fixes/Tests bullet.

**Where the placeholders live:**
- Non-merged blocks: one `<!--BLOCK_PARAGRAPH:{blockName}-->` placeholder directly under the H5
- Merged parent blocks (when `mergeBlockPattern` matches): one placeholder per sub-block, under the H6 — the H5 parent itself has no placeholder by default. For Peerloop, `mergeBlockPattern` is `^([A-Z][A-Z0-9-]+)\.` — this collapses dot-notation sub-blocks (e.g. `DEPLOYMENT.PROD`, `DEPLOYMENT.GHACTIONS`) under a shared H5 parent (`DEPLOYMENT`).

**Inputs for each placeholder:**
- `blockProgress[parentName].subPhases[].bullets` (merged) or `blockProgress[name].bullets` (non-merged) — the deterministic bullet list pulled from `Changes:`/`Fixes:`/`Tests:` sections of the relevant commits, in commit-time order
- `blockProgress[...].blockSummaries[]` — partial summaries when some commits had `Block-summary:` but not all; use these as strong input signal for the synthesis
- Subject lines of commits in `commitHashes[]` (look them up in `commits[]`)

**Style:**
- Terse, technical, client-readable
- Each bullet ≈ one coherent thread (e.g. "Migrated SessionBooking to use strftime for ISO-compatible datetime comparisons", not a file-by-file enumeration)
- Prefer the "what / why" frame over the "which file" frame (file-level moves are visible in Day Summary above)
- **Do not invent details** not present in the bullets or subjects
- **Do not re-list raw bullets verbatim** — synthesize

Replace each `<!--BLOCK_PARAGRAPH:{name}-->` marker in `renderedMarkdown` with the generated bullet list (plain markdown `- ` items, one per line). The marker is an HTML comment so Obsidian hides it if the skill fails partway.

### Step 5: Write file and open in editor

```bash
# Write the rendered markdown (with paragraphs filled in) to .timecard.md
cat > "$CLAUDE_PROJECT_DIR/.timecard.md" <<'EOF'
<filled-in renderedMarkdown>
EOF

# Open in configured editor (from config.json → editor; default: code)
<editor> "$CLAUDE_PROJECT_DIR/.timecard.md"
```

Tell user: `Opened timecard for <date> in <editor> — ready for review and copying.`

---

## Output Structure (what the script renders)

Top-of-file warnings (only if present):

```markdown
### Skipped Convs
- Conv NNN — <reason>

### Warnings
- <warning text>
```

Day timecard — H3 title, Dataview fields:

```markdown
### 🕒 Timecard • ⚽️ Coding • <Mon DD, YYYY> • <startShort> to <endShort>
- `Tools  `:: [[Claude Code]]
- `Machine`:: <machines>
- `Start  `:: <startShort>
- `End    `:: <endShort>
- `Adjust `:: -<adjustMin><overflow/adhoc annotation>
- `Billable`:: <billableHHMM>
- `Bill?  `:: <billing code>
- `Convs  `:: <convs>
- `Blocks `:: <blocks>
```

Rollup sections (no blank lines preceding H4s). Each H4 has H5 subgroups; some H5s have H6 nesting:

```markdown
#### Infra Changes
##### scripts/
##### (other)
#### Doc Changes
##### CLAUDE.md
##### TIMELINE.md
##### ...
#### Code Changes
##### src/components
##### src/pages
##### ...
#### Testing
##### [tag]
##### tests/
###### tests/api/
###### tests/integration/
###### ...
##### Untagged
#### Work Effort
##### [tag]
##### Untagged
```

Block Progress — non-merged block, **deterministic mode** (all commits have `Block-summary:`):

```markdown
#### Block Progress
##### <Block name>  ·  <billableMin>m allocated
- <Block-summary from commit 1>
- <Block-summary from commit 2>
- <...one bullet per commit, in commit order...>
```

Block Progress — non-merged block, **legacy fallback** (at least one commit lacks `Block-summary:`):

```markdown
#### Block Progress
##### <Block name>  ·  <billableMin>m allocated
<!--BLOCK_PARAGRAPH:<Block name>-->
```

Block Progress — merged block (H5 parent, H6 per sub-phase). Mode is evaluated per sub-phase — one sub-phase may render deterministic bullets while a sibling renders a placeholder.

```markdown
#### Block Progress
##### <Parent Phase>  ·  <total billableMin>m allocated
###### <sub-phase 1 display name>  ·  <billableMin>m
- <Block-summary from commit A>
- <Block-summary from commit B>
###### <sub-phase 2 display name>  ·  <billableMin>m
<!--BLOCK_PARAGRAPH:<sub-phase 2 raw name>-->
```

Per-Commit Audit (P1, appendix):

```markdown
---

#### Per-Commit Audit (P1)

| # | Time | Conv | Repo | Hash | Slot | Block(s) | Subject |
| ... |

#### **Slot totals:** Nm allocated + Mm unallocated = Km day window.
```

---

## Configuration

All filter/routing behavior is driven by `.claude/config.json → rTimecardDay`. Key fields:

| Field | Purpose |
|-------|---------|
| `docPaths` / `docPathsExclude` | Paths under which `.md` files are treated as docs (with exclusions — notably `docs/sessions/`) |
| `docRootExclude` | Root `.md` files explicitly excluded from doc routing |
| `routineStrip.phrases` | Substrings whose presence marks a bullet as routine logging (stripped) |
| `routineStrip.pathPatterns` | Same, for paths |
| `routineStrip.countFiles` | `.md` files where a mentioned count + file combo → strip as /r-end logging |
| `routineStrip.countSkipIfContains` | Word-boundary terms that exempt a count-bullet from stripping (test, suite) |
| `routineStrip.multiDocMinCount` | Bullets mentioning N+ whitelisted docs → strip as "files synced" logging |
| `routineStrip.stripIfTextEquals` | Trivial bullets (e.g. literal `none`) to strip |
| `routineStrip.stripDocTagWithoutDocMention` | Drop Doc: bullets that mention no valid doc |
| `testing.pathPrefixes` / `tagContains` / `wordMatches` | T4 heuristic rules — route a bullet into `#### Testing` when no stronger signal fired. Beaten by any T3 structural match. |
| `reroute.infraPrefixes` | T3 path prefixes that route bullets into `#### Infra Changes`. First match in array order wins; order more-specific prefixes first. |
| `reroute.infraGroupLabels` | Friendly H5 labels for matched prefixes (e.g. `.claude/skills/` → `Skills`). Falls back to the raw prefix when unset. |
| `reroute.slashSkillRe` | Regex for slash-prefixed skill/command names (e.g. `/r-commit`). T3 structural signal that routes into `#### Infra Changes → Skills`. |
| `reroute.codePrefixRe` | Regex that captures an `src/<subdir>` group key for `#### Code Changes`. |
| `mergeBlockPattern` | Regex capturing a shared prefix. When set, blocks sharing that prefix collapse into one H5 parent with H6 sub-blocks. For Peerloop: `^([A-Z][A-Z0-9-]+)\.` — collapses `DEPLOYMENT.PROD` + `DEPLOYMENT.GHACTIONS` → `DEPLOYMENT` parent with H6 children. |

### Classification priority tiers

`timecard-day.js → classifyItem()` applies these tiers top-to-bottom. Tier name wins — within a tier, rules are typically mutually exclusive for real text. This makes the system **insensitive to reordering within a tier**: paths always beat word heuristics, explicit author tags always beat paths.

| Tier | Signal | Typical destinations |
|------|--------|----------------------|
| T1 skip | `routineStrip` phrases / paths / count-files; `multiDocMinCount` threshold | (dropped) |
| T2 explicit | `Test:` tag (src=test); doc-mention (validDocs set); `stripDocTagWithoutDocMention` on src=doc | testing / doc / skip |
| T3 structural | `infraPrefixes` match in text; `slashSkillRe` match; bare-filename match against the commit's `filesChanged`; fully-infra-commit heuristic (every file in commit under an `infraPrefix`); `codePrefixRe` match | infra / code |
| T4 heuristic | `isTestRelated` word/tag heuristic | testing |
| T5 default | carry-over from item source (`workEffort`, `infra`, `userFacing`, …) | source bucket |

---

## Rules

- **Do not perform any commit grouping, slot math, tag dedup, filter, routing, or markdown rendering in the skill** — the script owns all of that. The skill is a placeholder-filler.
- **Do not invent values** for Block paragraphs. Synthesize only from the provided bullets + commit subjects. Do not re-list bullets — write prose.
- **Re-runs must produce byte-identical `renderedMarkdown`** for the same commits + same config. Only Block paragraphs may drift between runs. If you see numbers, group boundaries, tag rollups, or section order changing across runs, that's a bug — surface it.

---

## Edge Cases

| Situation | Handling (script-side) |
|-----------|------------------------|
| Conv with no heartbeat on date | Skipped; appears in `skippedConvs[]`. Top-of-file note added. |
| Conv with heartbeat only, no work commits | Skipped; reason `'heartbeat-only-no-work'`. |
| Multiple heartbeats for same Conv | Earliest used; warning emitted. |
| Last Conv overflows into next day | Slots and window capped at `22:00`. Overflow commits added. Adjust annotated. |
| Commit with no `Block:` line | `blocksNormalized: ['(no-block)']` — gets a `(no-block)` Block Progress section. |
| Multi-Block commit (`Block: A, B`) | Both Blocks see the bullet. P1 row shows both raw forms. |
| Sub-second sibling commits | 0m slot. Bullets still attributed; just zero billable time. |
| Future date / unparseable date | Script exits 1 with stderr message. |
| No commits in window | Script returns empty `commits[]`. Skill displays and stops. |
| Day with only ad-hoc commits | `convs: []`, `billableMinRaw: 0`. Rollup sections will be sparse. |
| Commit reachable from multiple branches | De-duped by hash; non-HEAD/non-main branch preferred. |
| Legacy commits without `Block-summary:` | Script falls back to placeholder (`<!--BLOCK_PARAGRAPH:NAME-->`); skill fills via LLM synthesis. Mixed populations (some summaries, some missing) also fall back — partial summaries become inputs to synthesis. |
| Commit with `Type: end-of-conv` | Metadata only. Treated identically to any other commit for all rollups, Block Progress, and P1 audit. |
| `<id>` or other `<...>` placeholders in bullets | Script wraps inner content as `<{id}>` so Obsidian renders literally (except `<http...>` auto-links). |

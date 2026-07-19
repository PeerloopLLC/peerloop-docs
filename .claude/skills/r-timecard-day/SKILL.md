---
name: r-timecard-day
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
node "~/projects/peerloop-docs/.claude/scripts/timecard-day.js" <date>
```

If exit code ≠ 0, surface the stderr message to the user and stop.

The JSON output includes (unchanged from before): `window`, `billing`, `convs`, `blocks`, `skippedConvs`, `warnings`, `overflow`, `commits`, `blockProgress`, `dayTags`, `dayWorkEffort`, `candidateBranches`.

**`renderedMarkdown`** — the full timecard markdown with `<!--BLOCK_PARAGRAPH:{name}-->` placeholders where Block-progress paragraphs belong. This is the only content you render; everything else is already done.

**`placeholderNames`** — array of literal placeholder names (in render order) for which the markdown still needs LLM-synthesized bullets. Empty when every block rendered deterministically from `Block-summary:` lines. Use this array to drive Step 4 — **do not regex-scan `renderedMarkdown`** for placeholders, because names contain parens, dots, and hyphens (e.g. `(no-block)`, `(misc)`, `DEPLOYMENT.PROD`) that hyphen-sensitive regexes mis-capture.

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
node "~/projects/peerloop-docs/.claude/scripts/timecard-day.js" <date> --exclude-branches "br1 br2"
```

If the user excludes everything, display `No branches selected — nothing to process.` and stop.

**🔒 Code-repo branches are pre-filtered by an allowlist (Conv 396).** The list above will only ever show CODE-repo branches matching `rTimecardDay.codeBranchAllowPattern` in `.claude/config.json` (default `^jfg-dev`). The code repo is shared with the client, who commits on his own branches (`brian-July-7`, `brian-staging`) using the **same `Conv NNN:` prefix convention**, with conv numbers that **collide with ours** — a bare sweep billed 6 of his commits inside our Conv 371 bucket on 2026-07-07 (measured Conv 396). If a branch you expected is missing from the prompt, check that pattern first. **The DOCS repo is deliberately unfiltered** — it lives on `main` and holds the `Conv NNN start —` heartbeats that anchor every day window. `--exclude-branches` still works and composes on top of the allowlist.

### Step 3: Handle empty / anomalous outputs

- **No commits found:** `commits[]` is empty → display `No commits found for <date>.` and stop.
- **Skipped Convs / Warnings / Overflow:** the script has already included top-of-file notes and adjusted `renderedMarkdown`. Nothing extra to do.

### Step 4: Fill LLM placeholders

Two placeholders may need filling: a single `<!--FOCUS_PLACEHOLDER-->` (always present when commits exist) and zero-or-more `<!--BLOCK_PARAGRAPH:NAME-->` markers (only in legacy fallback). Fill Focus first, then Block-Progress.

#### Step 4a: Synthesize Focus

Replace the literal `<!--FOCUS_PLACEHOLDER-->` marker with a single client-understandable theme line summarizing the day's work across both repos. Match `/r-timecard`'s pattern:

- **One unified theme** in the usual case (code + docs work are related)
- **Comma-separated themes** if the day's work is genuinely disparate (multiple unrelated blocks)
- Terse, one line, client-readable — no leading bullet, no trailing period required, no markdown formatting
- Synthesize from `data.commits[].subject`, `data.blocks[]`, and `data.blockProgress[*].blockSummaries[]` — do NOT invent details not present in those inputs

Substitution: `md = md.replace('<!--FOCUS_PLACEHOLDER-->', focusLine)`. Literal string replacement is safe — the marker is a single fixed token (unlike block placeholders, whose names vary).

#### Step 4b: Fill Block-Progress bullets (legacy fallback only)

**Check first:** examine the `placeholderNames` array in the JSON output.

- **Empty array** → deterministic mode. The script already emitted Block-summary bullets directly from commit metadata. Skip to Step 5.
- **Non-empty array** → legacy fallback. Each entry is the literal name (e.g. `(misc)`, `(no-block)`, or a sub-phase name like `DEPLOYMENT.PROD`) that appears in a `<!--BLOCK_PARAGRAPH:${name}-->` marker in `renderedMarkdown`. Fill each marker with synthesized bullets (procedure below), then replace it via **literal string substitution**: `md.replace('<!--BLOCK_PARAGRAPH:' + name + '-->', synthesizedBullets)`. **Do not regex-scan `renderedMarkdown`** for markers — placeholder names contain parens, dots, and hyphens that hyphen-sensitive regexes (e.g. `[^-]+`) mis-capture.

For each name in `placeholderNames`, write **2–5 synthesized bullets** describing what that Block (or sub-phase) achieved today, from the Block's perspective. This is the narrative-dimension view — bullets are already visible above in Day Summary rollups (grouped by tag / file / path), so the job here is **synthesis, not enumeration**. Each bullet should be a short, client-readable sentence summarizing a thread of work, not a copy-paste of a raw Changes/Fixes/Tests bullet.

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

### Step 5: Write file to vault and open in editor

The script computes the destination path from `.claude/config.json → rTimecardDay.vaultPath` (a tilde-prefixed path so the same committed config works on every machine). It exposes four fields the skill consumes here:

- `vaultPath` — the resolved absolute directory (tilde expanded).
- `vaultFilename` — `Peerloop Timecard • Coding • <H3-dayTitle> • <startTimeNoColon>.md`.
- `vaultTargetPath` — `path.join(vaultPath, vaultFilename)`.
- `vaultDirExists` — boolean. Whether the parent folder exists on this machine.
- `vaultTargetExists` — boolean. Whether a file with this exact name already lives there.

**Pre-write checks (in order):**

1. **`vaultDirExists === false`** → STOP and tell the user:

   ```
   ❌ Vault folder does not exist on this machine:
        <vaultPath>
      Create it (`mkdir -p "<vaultPath>"`), then re-run.
   ```

   Do NOT auto-create. Auto-create masks vaultPath typos (config off-by-one silently spawns a fresh folder, files vanish into the wrong place). Catching the missing folder once per machine is cheap; catching a typo months later is expensive.

2. **`vaultTargetExists === true`** → halt-and-ask before overwriting:

   ```
   ⚠️ A timecard file with this name already exists:
        <vaultTargetPath>

   👉👉👉 **Overwrite the existing file? (yes / no)**
   ```

   On `no`: stop without writing.

3. **Otherwise** (or after `yes` to overwrite): write the markdown and open in editor.

**Write + open:**

```bash
cat > "<vaultTargetPath>" <<'EOF'
<filled-in renderedMarkdown>
EOF

<editor> "<vaultTargetPath>"
```

Tell user: `Wrote timecard to <vaultTargetPath> and opened in <editor>.`

Do NOT also write `.timecard.md`. The vault file is the only output — `.timecard.md` was the prior single-target convention and has been replaced.

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
- `Focus  `:: <!--FOCUS_PLACEHOLDER-->
- `Start  `:: <startShort>
- `End    `:: <endShort>
- `Adjust `:: -<adjustMin><overflow/adhoc annotation>
- `Billable`:: <billableHHMM>
- `Bill?  `:: <billing code>
- `Convs  `:: <convs>
- `Blocks `:: <blocks>
```

The `Focus` line carries a `<!--FOCUS_PLACEHOLDER-->` marker that the skill fills via LLM synthesis (see Step 4). The marker is an HTML comment so Obsidian hides it if the skill fails partway, matching the `<!--BLOCK_PARAGRAPH:NAME-->` pattern used in Block Progress fallback.

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

All filter/routing behavior is driven by `.claude/config.json → rTimecardDay`. The H4 section list, each H4's inclusion rules, and each H4's H5/H6 strategy all live in config — adding or reshaping an H4 section is a config edit, not a script edit.

### Top-level fields

| Field | Purpose |
|-------|---------|
| `dayWindow.overflowCapHHMM` | Next-day overflow cap (default `22:00`) |
| `dayWindow.roundToMinutes` | Slot rounding granularity (default `5`) |
| `convMeta.heartbeatPattern` | Regex matching `/r-start` heartbeat subjects (e.g. `^Conv (\d{3}) start —`) |
| `convMeta.convPrefixPattern` | Regex matching non-heartbeat commit-subject Conv tags |
| `commitTagPrefixes` | `{ srcId: "Prefix:" }` map — legacy `API:` / `Doc:` / etc. tag-line parsing |
| `legacy.bulletSectionHeaders` | v1-only: headers like `Changes:` / `Fixes:` / `Tests:` that wrap work-effort bullets |
| `render.tagPattern` / `countPattern` / `verbTagPattern` | Rendering-layer regexes for `[TAG]` extraction and routine-count detection |
| `docPaths` / `docPathsExclude` | Paths scanned for `.md` docs (with exclusions) |
| `docNameWhitelist` | ALL-CAPS stems recognized without `.md` extension |
| `docRootExclude` | Root `.md` files excluded from doc routing |
| `routineStrip.*` | Pattern library for the top-level `skipFilter` (see below) |
| `testing.*` | Patterns for the `testRelated` predicate (path prefixes, tag-contains, word-matches) |
| `reroute.*` | Pattern library referenced by H4 inclusion predicates (`apiMethodRe`, `apiPathRe`, `infraPrefixes`, `infraGroupLabels`, `infraPrefixWords`, `slashSkillRe`, `codePrefixRe`, `dbPathPrefixes`, `dbBulletPrefixWords`, `dbSqlRe`) |
| `mergeBlockPattern` | Regex that collapses sub-blocks into a shared H5 parent with H6 sub-phases (Peerloop: `^([A-Z][A-Z0-9-]+)\.`). Applies to Block Progress, not bullet H4s. |

### Per-H4 inclusion predicates

Each entry in `h4Sections[]` owns its own inclusion rule. The engine evaluates every H4's `include` predicate independently over every bullet — **a bullet can appear in multiple H4s** (e.g. a bullet mentioning both an API path and a doc file renders in API Changes *and* Doc Changes). No first-match-wins, no tier ordering.

```json
{
  "id": "db",
  "title": "DB Changes",
  "include": {
    "anyOf": [
      { "src": "db" },
      { "textContainsAny": "reroute.dbPathPrefixes" },
      { "startsWithAny": "reroute.dbBulletPrefixWords" },
      { "matchesRegex": "reroute.dbSqlRe" }
    ]
  },
  "h5Strategy": "dbBulletPrefix"
}
```

**Predicate DSL keys** (bare object = AND across keys; use `anyOf`/`allOf` for OR/AND groups):
`src`, `matchesRegex`, `textContainsAny`, `startsWithAny`, `docsMentionGt` / `Eq` / `Gte`, `testRelated`, `notTestRelated`, `isRoutine`, `commitFileMatchesPrefix`, `allCommitFilesUnder`, `flag`, `fallthrough`. String values like `"reroute.apiMethodRe"` resolve to the referenced config array/regex at load time.

**`fallthrough: true`** — matches only bullets no other H4 claimed. Used for the Work Effort catch-all; runs last.

**Top-level `skipFilter`** — bullets matching this predicate render in zero H4s (bullet-level skip; commit row still appears in P1 audit). Default rules: `isRoutine` match (routineStrip phrases/paths/countFiles), multi-doc spam, `stripDocTagWithoutDocMention`.

**v2 commit format note.** When a commit carries `Format: v2`, `/r-commit2` / `/r-end2` emit bullets under `### SECTION` H3 headers matching `h4Sections[].title`. The parser uses those headers to set each bullet's `src`, and per-H4 predicates then read `src` naturally. No separate v2 code path — v2 just produces richer `src` metadata.

### H5 / H6 strategies

H5 and H6 groupings **within** each H4 are algorithmic. Each H4 names which strategy it uses; the strategy implementations live in `timecard-day.js` as a lookup table. Adding a new strategy is a one-time script addition; swapping which strategy an H4 uses is config-only.

| `h5Strategy` | Behavior | Config fields read |
|--------------|----------|--------------------|
| `emDashOrFirstWord` | Split at ` — ` else first word | — |
| `firstWord` | First whitespace word | — |
| `infraGroupLabels` | `_matchedInfraPrefix` → label map; else text scan; else first path token; else `(other)` | `reroute.infraPrefixes`, `reroute.infraGroupLabels` |
| `docFilename` | One H5 entry per doc mentioned by `extractDocs` (can multiply one bullet into several H5 entries) | `docNameWhitelist`, `docPaths` |
| `codePrefix` | Regex group 1 of `codePrefixRe`; else `(other)` | `reroute.codePrefixRe` |
| `dbBulletPrefix` | `dbBulletPrefixWords` prefix; else `dbPathPrefixes` path; else `(other)` | `reroute.dbBulletPrefixWords`, `reroute.dbPathPrefixes` |
| `testingPath` | `[TAG]`, else first dir segment, else `Untagged` | — |
| `tagOrUntagged` | `[TAG]`, else `Untagged` | — |

| `h6.strategy` | Behavior |
|---------------|----------|
| `testingSubdir` | Inside the H5 matching `h6.onH5` (e.g. `tests/`), `^tests\/([a-z0-9_-]+)` → `tests/<subdir>/`; else `tests/` |

A bullet can render under **multiple** H5s in the same H4 only when the strategy inherently produces multiple keys (`docFilename`). Otherwise per-H4 dedup collapses exact-text duplicates to a single rendering.

---

## Rules

- **Do not perform any commit grouping, slot math, tag dedup, filter, routing, or markdown rendering in the skill** — the script owns all of that. The skill is a placeholder-filler.
- **Do not invent values** for Block paragraphs. Synthesize only from the provided bullets + commit subjects. Do not re-list bullets — write prose.
- **Re-runs must produce byte-identical `renderedMarkdown`** for the same commits + same config. Only the Focus line and Block paragraphs may drift between runs (both are LLM-synthesized). If you see numbers, group boundaries, tag rollups, or section order changing across runs, that's a bug — surface it.

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

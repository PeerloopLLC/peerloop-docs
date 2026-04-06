---
name: r-timecard-day
description: Generate intelligent daily timecard(s) — auto-groups Convs by gaps, calculates Adjust, rounds to 5 min
argument-hint: "date (e.g., Mar-30-2026, 2026-03-30, today, yesterday)"
allowed-tools: Bash, Read, Write, Glob
---

# Generate Daily Timecard(s)

Automatically analyze a full day's commits across both repos, group Conversations by time proximity, calculate billing gaps (Adjust), and produce ready-to-use timecards — all rounded to the nearest 5 minutes.

**Data source:** Git commit timestamps and messages from both repos. Never from conversation context.

---

## Pre-computed Context

!`cat .claude/config.json 2>/dev/null || echo "(no config)"`

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

**No other arguments.** The skill auto-discovers Convs and groups them.

If no argument is provided, stop with: "Usage: `/r-timecard-day Mar-30-2026`"

---

## Constants

| Name | Value | Notes |
|------|-------|-------|
| Gap threshold | **45 minutes** | Gaps ≥ 45 min between Convs split into separate timecard groups |
| Block change | **judgement** | Material change in `Block:` metadata also triggers a split |
| Rounding | **5 minutes** | All times (Start, End, Adjust) rounded to nearest 5 min |
| Code repo | From config.json `codeRepo` | Usually `../Peerloop` |
| Billing code | From config.json `billing.currentCode` | e.g., `Block-08` |
| Editor | From config.json `editor` | Default: `code` |

---

## Workflow

### Step 1: Parse Date

Convert the argument to two values for git filtering:

```
SINCE="YYYY-MM-DD 00:00:00"
UNTIL="YYYY-MM-DD+1 00:00:00"   # next day midnight
```

For `today`/`yesterday`, resolve using the current date.

Validate: If the date is in the future or can't be parsed, error with: "Could not parse date: [input]"

### Step 2: Extract All Commits

Run these two commands (both repos):

**Docs repo:**
```bash
git log --format="---COMMIT---%nREPO:docs%n%ci%n%h %H%n%s%n%b" --since="SINCE" --until="UNTIL" --reverse
```

**Code repo:**
```bash
git -C ../Peerloop log --format="---COMMIT---%nREPO:code%n%ci%n%h %H%n%s%n%b" --since="SINCE" --until="UNTIL" --reverse
```

If zero commits found across both repos: "No commits found for [date]."

### Step 3: Build Conv Timeline

For each commit, extract the Conv number from the subject line:
- Pattern: `Conv (\d{3})` — extract the 3-digit number

**Heartbeat detection:** A commit is a heartbeat if its subject matches `Conv \d{3} start —`.

**Commits without a Conv number:** These are ad-hoc commits (e.g., one-off config changes). Do not include them in any Conv timeline, but **count them**. If any exist, annotate the final output (see Step 6).

**Carried-over Convs (SKIP):** If a Conv has work commits on this date but **no heartbeat commit on this date**, it belongs to the **previous day's** timecard — skip it entirely. The previous day's timecard handles it via overflow detection (see Step 3.5).

For each Conv that has a heartbeat on this date, determine:

| Field | How to determine |
|-------|-----------------|
| **Start time** | Timestamp of the `Conv NNN start —` heartbeat commit on this date. |
| **End time** | Timestamp of the **latest** non-heartbeat commit for this Conv on this date, across both repos. |
| **Commits** | List of all non-heartbeat commits (both repos) with their full data |

Sort Convs chronologically by start time.

### Step 3.5: Overflow Detection

After building the day's Conv timeline, check whether the **last Conv of the day** has work commits that extend into the **next day**. This happens when the user finishes work but doesn't run `/r-end` until the following day.

**Detection method:** For the last Conv of the day, check the next day for commits matching that Conv number:

```bash
# Check docs repo for next-day commits from the last Conv
git log --grep="Conv NNN" --format="%ci %s" --since="UNTIL" --until="UNTIL+1day"
# Check code repo
git -C ../Peerloop log --grep="Conv NNN" --format="%ci %s" --since="UNTIL" --until="UNTIL+1day"
```

Also check: is the very first commit of the next day a heartbeat? If the first commit of the next day is a **work commit** (not a heartbeat) for the same Conv, overflow is confirmed.

**If overflow is detected:**

1. **Cap the last timecard's End at 22:00** (artificial close — the user wasn't working past this time, they just didn't close the Conv)
2. **Annotate Adjust** with the overflow. The overflow commit happened at time `T` the next day. Since we can't determine exactly how long the user worked the next morning before committing, append to Adjust:
   ```
   MM +? (next day overflow — end commit at HH:MM next day)
   ```
   Where `MM` is the normal inter-Conv gap adjustment and `HH:MM` is the timestamp of the overflow commit on the next day.
3. **Include the overflow Conv's commits in this day's Git History** — the work was done as part of this day's session, even though the commit landed the next day. Tag these commits with `(code, next day)` or `(docs, next day)` in the Git History timestamp line.

### Step 4: Calculate Gaps

For each consecutive pair of Convs (sorted by start time):

```
gap = next_conv.start_time - current_conv.end_time
```

Express as whole minutes. If negative (overlapping), treat as 0.

### Step 5: Auto-Group by Coherence

Walk the sorted Convs. Start a new group when **either** condition is met:

1. **Time gap ≥ 45 minutes** between the end of one Conv and the start of the next (a real break)
2. **Block change** — the `Block:` metadata in commit messages shifts to a materially different focus area (e.g., `EXPLORE-COURSES` → `TAG-TAXONOMY`)

**Block change rules:**
- Extract `Block:` from each Conv's commit bodies. A Conv's block is the block value from its non-heartbeat commits (usually consistent within a Conv).
- If the block changes between consecutive Convs, that's a signal to split — but use judgement:
  - `none` / `(cleanup + bug fixes)` / `(tooling + cleanup)` are thematically neutral — they attach to whichever block they're adjacent to. Don't split just because a Conv has `Block: none`.
  - A Conv that completes one block (e.g., `EXPLORE-COURSES (COMPLETE)`) and the next Conv starts a new block — split.
  - Multiple blocks in the same thematic area (e.g., `UNIFIED-DASHBOARD` + `TAG-TAXONOMY` both being cleanup) — judgement call, lean toward keeping together if the gap is small.
- **A single timecard for the whole day is valid** if the work is coherent and gaps are small.

**Marking splits in the timeline:** Use `⊘` for time-based splits, `◆` for block-change splits.

Each group contains:
- List of Conv numbers
- Group Start = earliest start time in the group
- Group End = latest end time in the group
- Adjust = sum of all inter-Conv gaps within the group (in minutes)
- All commits from all Convs in the group

### Step 6: Round to Nearest 5 Minutes

Apply rounding to:
- **Group Start time** (round to nearest 5 min)
- **Group End time** (round to nearest 5 min)
- **Adjust** (round total minutes to nearest 5 min)

Rounding rule: `Math.round(minutes / 5) * 5`
- 10:07 → 10:05, 10:08 → 10:10, 10:33 → 10:35, 16:58 → 17:00

Format times as `HH:MM` (24-hour, zero-padded).

### Step 7: Present Timeline Analysis

Before the timecards, output a brief timeline analysis to the conversation (NOT to the file) so the user can verify grouping:

```
## [Date] — Daily Timecard Analysis

### Skipped
- Conv 051 — no heartbeat on this date (belongs to previous day)

### Ad Hoc Commits
- (none, or list non-Conv commits if any)

### Timeline
| Conv | Block | Start | End | Duration | Gap → Next |
|------|-------|-------|-----|----------|------------|
| 042  | EXPLORE-COURSES | 07:24 | 08:27 | 1h03m | 2m |
| 043  | EXPLORE-COMMUNITIES | 08:29 | 11:06 | 2h37m | 2m |
| 044  | EXPLORE-COMMUNITIES | 11:08 | 12:22 | 1h14m | 1m |
| 045  | EXPLORE-COMMUNITIES | 12:22 | 12:42 | 0h20m | 1m |
| 046  | ROLE-AWARE | 12:43 | 13:32 | 0h49m | 1h02m ⊘ |
| 047  | (tooling) | 14:34 | 15:10 | 0h36m | 4m |
| 048  | TAG-TAXONOMY | 15:14 | 16:21 | 1h07m | 2m |
| 049  | TAG-TAXONOMY | 16:23 | 16:59 | 0h36m | 2m |
| 050  | TAG-TAXONOMY | 17:00 | 20:49 | 3h49m | 2m |
| 051  | TAG-TAXONOMY | 20:51 | 22:00* | 1h09m* | — |

⊘ = gap ≥ 45 min (time split)
◆ = material block change (theme split)
* = capped at 22:00 (overflow)

### Proposed Groups
- **Timecard 1:** Conv 042–046 • 07:25 to 13:35 • Adjust -05
- **Timecard 2:** Conv 047–051 • 14:35 to 22:00 • Adjust -10 +? (overflow)
```

If overflow is detected for the last Conv (see Step 3.5), also show:
```
### Overflow Detected
- Conv 051 has end commit(s) on next day at 10:07 — End capped at 22:00
```

### Step 8: Generate Timecards

For **each group**, generate a timecard in the standard format. Follow the /r-timecard output format exactly.

**Commit count:** Total non-heartbeat commits across both repos in the group.

**Focus, sections, Work Effort:** Analyze ALL commit messages in the group (unified across both repos):
- **Focus** (1-liner): Single client-understandable theme
- **For Client/Admin**: Extract `User-facing:` / `Admin-facing:` lines from commits. Group under `##### User-facing` and `##### Admin-facing` H5 sub-headers (strip the prefix from each bullet). Omit a sub-header if it has no bullets. Omit the entire section if none.
- **API Changes**: Extract `API:` lines from commits. Deduplicate exact matches, consolidate near-matches. Order by HTTP method then path. Omit section if none.
- **Page Changes**: Extract `Page:` lines from commits. Deduplicate. Order by route path. Omit section if none.
- **Role Changes**: Extract `Role:` lines from commits. Deduplicate. Order by role name. Omit section if none.
- **Infra Changes**: Extract `Infra:` lines from commits. Deduplicate. Order alphabetically. Omit section if none.
- **Work Effort**: Technical work bullets from Changes/Fixes/Tests sections, grouped logically. This captures the "how" — tags above capture the "what changed where".

**Date in title:** Use the target date. If any Conv in the group spans midnight (carried over), still use the target date.

**Timecard format:**

```markdown
### 🕒 Timecard • ⚽️ Coding • (N commits) - Mon DD, YYYY - HH:MM to HH:MM
- `Tools  `:: [[Claude Code]]
- `Machine`:: [machine name(s)]
- `Focus  `:: [unified focus]
- `Start  `:: HH:MM
- `End    `:: HH:MM
- `Adjust `:: -MM
- `Bill?  `:: [billing code]
#### For Client/Admin
##### User-facing
- description (prefix stripped)
##### Admin-facing
- description (prefix stripped)
#### API Changes
- METHOD /path — description
#### Page Changes
- /route — description
#### Role Changes
- RoleName — description
#### Infra Changes
- tool/skill/script — description
#### Work Effort
- [technical bullet]
#### Git History
Mon DD, YYYY

| Time | Conv | Repo | Hash | Machine | Block |
|------|------|------|------|---------|-------|
| HH:MM | NNN | code | abcdefg | MacMiniM4 | BLOCKNAME |
| HH:MM | NNN | docs | hijklmn | MacMiniM4 | BLOCKNAME |
```

**Title date format:** `Mar 29, 2026` (abbreviated month, no zero-padding on day).

**All times in title, Start, End are the rounded values.**

**Adjust format:** The base value is **negative** — it represents inter-Conv gap minutes to subtract from the billing window (e.g., `-50`, `-10`, `00`). If the sum rounds to 0, use `00`. Additional annotations may be appended:
- **Overflow:** `-10 +? (next day overflow — end commit at 10:07 next day)` — see Step 3.5
- **Ad-hoc commits:** `-05 (ad hoc commit(s) detected)` — see Step 3

The sign convention: **negative = subtract** (idle gaps), **positive = add** (overflow work done next day).

**Git History table rules:**
- Exclude heartbeat commits
- Date line above table: `Mon DD, YYYY` (same format as title). For overflow commits on the next day, add a second date line before those rows.
- Interleave both repos chronologically (sorted by commit time, earliest first)
- **Time**: `HH:MM` from commit timestamp
- **Conv**: 3-digit Conv number extracted from subject
- **Repo**: `code` or `docs`
- **Hash**: 7-char short hash
- **Machine**: from `Machine:` line in commit body
- **Block**: from `Block:` line in commit body
- No blank lines between `::` fields (Dataview requirement)

**Machine field:** Union of `Machine:` values from commit bodies in the group. If none found, check heartbeat commit subjects for the `— MachineName` pattern. Omit field entirely if still unknown.

### Step 9: Output

1. Write ALL timecards to `.timecard.md` in the docs repo root (overwrites previous, gitignored)
   - If multiple groups: separate timecards with `---` horizontal rule and a blank line
   - Add a comment header at top: `<!-- Daily timecard: [date] — [N] group(s), [M] total commits -->`
2. Open in editor:
   ```bash
   [editor] .timecard.md
   ```
3. Tell user: "Opened [N] timecard(s) for [date] in [editor] — ready for review and copying."

---

## Edge Cases

| Situation | Handling |
|-----------|----------|
| Conv with no heartbeat on this date | **SKIP entirely** — belongs to previous day's timecard. Previous day handles it via overflow detection (Step 3.5). |
| Conv overflows into next day | Cap End at 22:00. Annotate Adjust with `+? (next day overflow — end commit at HH:MM next day)`. Include overflow commits in Git History tagged `(code, next day)` / `(docs, next day)`. |
| Commits without Conv number | Count them. Annotate last timecard's Adjust with `(ad hoc commit(s) detected)`. |
| Single Conv all day | One group, one timecard, Adjust = 00 |
| Only heartbeat commits (no work commits) | Skip — no timecard to generate. |
| Gap exactly 45 minutes | Split (threshold is ≥ 45) |
| All Convs in one group | Single timecard |
| Conv with commits in only one repo | Still included; Git History shows only the repo that has commits |

---
name: r-timecard-day
description: Generate intelligent daily timecard(s) — auto-groups Convs by time gaps then Block coherence, rounds to 5 min
argument-hint: "date (e.g., Mar-30-2026, 2026-03-30, today, yesterday)"
allowed-tools: Bash, Read, Write, Glob
---

# Generate Daily Timecard(s)

Automatically analyze a full day's commits across both repos, group Conversations by time gaps then Block coherence, calculate billing gaps (Adjust), and produce ready-to-use timecards — all rounded to the nearest 5 minutes.

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
| Gap threshold | **45 minutes** | Gaps ≥ 45 min between Convs split into separate time groups (Pass 1) |
| Block sub-grouping | **nearest-attach** | Within time groups, sub-group by Block; neutral Convs attach to nearest non-neutral (Pass 2) |
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

Commits may live on branches other than HEAD (e.g. long-lived upgrade branches carrying multi-day work). Plain `git log` without a branch argument reads from HEAD only and silently misses commits on other local branches — this is a billing-accuracy bug. The skill therefore scans all local branches in both repos for in-window commits, then prompts if any non-HEAD branches carry in-window work.

#### 2a. Discover candidate branches

For each repo, list local branches with at least one commit in the `[SINCE, UNTIL)` window. Use `git for-each-ref refs/heads/` (local branches only — never `refs/remotes/` so `origin/*` noise is excluded) and count in-window commits per branch:

**Docs repo:**
```bash
for br in $(git for-each-ref --format='%(refname:short)' refs/heads/); do
  n=$(git log "$br" --oneline --since="SINCE" --until="UNTIL" 2>/dev/null | wc -l | tr -d ' ')
  [ "$n" -gt 0 ] && echo "$br $n"
done
```

**Code repo:** same pattern with `git -C ../Peerloop`.

Also record the current HEAD branch of each repo:
```bash
git symbolic-ref --short HEAD
git -C ../Peerloop symbolic-ref --short HEAD
```

#### 2b. Detect-and-prompt

For each repo, if any non-HEAD branch has in-window commits, display a summary:

```
🔔 Branches with commits on [DATE] — [REPO]:
  * [branch-a] (N commits)     [HEAD]
    [branch-b] (M commits)
    [branch-c] (K commits)
```

Mark the current HEAD with `[HEAD]`. Mark every candidate branch (HEAD or not) with `*` when it will be included by default.

If **at least one** non-HEAD branch has in-window commits in either repo, prompt:

```
👉👉👉 Include all branches listed above, or deselect some?
    (Enter = include all • space-separated branch names to exclude)
```

**Default: include all branches with in-window commits** — including branches that aren't HEAD. If HEAD has zero in-window commits but another branch has some, still include the other branch silently (no prompt needed — there's no ambiguity).

If every repo's in-window commits live only on HEAD, proceed silently without prompting.

#### 2c. Extract commits from selected branches

For each selected branch in each repo, run:

```bash
git log <branch> --format="---COMMIT---%nREPO:docs%n%ci%n%h %H%n%s%n%b%nBRANCH:<branch>" --since="SINCE" --until="UNTIL" --reverse
```

(Note the `BRANCH:<branch>` trailer — this is what Step 8 reads to populate the Git History Branch column. Substitute the literal branch name for `<branch>`.)

**De-dup by hash:** a commit reachable from multiple selected branches (typically after a merge) must appear exactly **once** in the timeline. Keep the first occurrence encountered during branch iteration, **but** when choosing which branch to record:

- Prefer the **non-HEAD / non-main** branch if the commit is reachable from both — that's where the work was actually done.
- Fall back to HEAD / main only if the commit exists nowhere else.

If zero commits found across all selected branches in both repos: "No commits found for [date]."

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

### Step 5: Auto-Group by Coherence (Two-Pass)

Grouping uses two passes: first split by time gaps, then sub-group by Block.

#### Pass 1 — Time-gap split

Walk the sorted Convs. Start a new **time group** when:

- **Time gap ≥ 45 minutes** between the end of one Conv and the start of the next (a real break)

This produces coarse time groups. **Marking:** Use `⊘` in the timeline for time-based splits.

#### Pass 2 — Block sub-grouping

Within each time group, sub-group Convs by Block to produce the final **timecards**.

**Block extraction:** Extract `Block:` from each Conv's commit bodies. A Conv's block is the block value from its non-heartbeat commits (usually consistent within a Conv).

**Algorithm:**
1. Identify contiguous runs of the same non-neutral Block within the time group. Each distinct Block run becomes its own timecard.
2. **Neutral blocks** — `none`, `(misc)`, `(cleanup + bug fixes)`, `(tooling + cleanup)`, and similar thematically neutral values — do NOT form their own timecards. Instead, attach each neutral Conv to the **nearest** non-neutral Conv by time proximity (compare gap to preceding non-neutral Conv's end vs following non-neutral Conv's start; ties go forward).
3. If a time group contains **only** neutral-block Convs (no non-neutral blocks at all), they form a single timecard with the neutral block label.
4. If a time group has exactly one non-neutral Block (all Convs share the same Block, ignoring neutrals), it produces a single timecard.

**Marking:** Use `◆` in the timeline for block-change splits (where one timecard ends and another begins within the same time group).

**Example — Apr 06, 2026:**
```
Time Group 1: 086(misc) → 087(SA) → 088(SA) → 089(misc) → 090(misc) → 091(DW)

Neutral attachment (nearest):
  086(misc): only fwd non-neutral = 087(SA), 21m fwd → SA
  089(misc): 088(SA) end 5m back vs 091(DW) start 37m fwd → SA (nearest)
  090(misc): 088(SA) end 103m back vs 091(DW) start 4m fwd → DW (nearest)

Timecards:
  Timecard 1: 086 + 087 + 088 + 089 → STUMBLE-AUDIT
  Timecard 2: 090 + 091 → DEV-WEBHOOKS

Time Group 2: 092(DW)
  Timecard 3: 092 → DEV-WEBHOOKS
```

#### Timecard contents

Each timecard (final group) contains:
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
- Conv 085 — no heartbeat on this date (belongs to previous day)

### Ad Hoc Commits
- (none, or list non-Conv commits if any)

### Timeline
| Conv | Block | Start | End | Duration | Gap → Next |
|------|-------|-------|-----|----------|------------|
| 086  | (misc) | 09:28 | 10:28 | 1h00m | 21m |
| 087  | STUMBLE-AUDIT | 10:49 | 12:17 | 1h28m | 4m |
| 088  | STUMBLE-AUDIT | 12:20 | 12:56 | 0h36m | 5m ◆ |
| 089  | (misc) | 13:01 | 14:36 | 1h35m | 2m |
| 090  | (misc) | 14:38 | 15:09 | 0h31m | 4m |
| 091  | DEV-WEBHOOKS | 15:13 | 15:57 | 0h44m | 2h45m ⊘ |
| 092  | DEV-WEBHOOKS | 18:42 | 19:21 | 0h39m | — |

⊘ = gap ≥ 45 min (time split)
◆ = block-change split (nearest-attach boundary)

### Pass 1 — Time Groups
- Time Group A: Conv 086–091 (gap before 092 = 2h45m ⊘)
- Time Group B: Conv 092

### Pass 2 — Block Sub-grouping (Time Group A)
- 086(misc): only fwd non-neutral = 087(SA), 21m fwd → SA
- 089(misc): 088(SA) end 5m back vs 091(DW) start 37m fwd → SA (nearest)
- 090(misc): 088(SA) end 103m back vs 091(DW) start 4m fwd → DW (nearest)

### Proposed Timecards
- **Timecard 1:** Conv 086–089 • STUMBLE-AUDIT • 09:30 to 14:35 • Adjust -30
- **Timecard 2:** Conv 090–091 • DEV-WEBHOOKS • 14:40 to 15:55 • Adjust -05
- **Timecard 3:** Conv 092 • DEV-WEBHOOKS • 18:40 to 19:20 • Adjust 00
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
- **Doc Changes**: Extract `Doc:` lines from commits. Deduplicate. Order alphabetically. Omit section if none.
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
#### Doc Changes
- file/topic — description
#### Work Effort
- [technical bullet]
#### Git History
Mon DD, YYYY

| Time | Conv | Repo | Hash | Branch | Machine | Block |
|------|------|------|------|--------|---------|-------|
| HH:MM | NNN | code | abcdefg | jfg-dev-10up | MacMiniM4 | BLOCKNAME |
| HH:MM | NNN | docs | hijklmn | main | MacMiniM4 | BLOCKNAME |
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
- Interleave all selected branches from both repos chronologically (sorted by commit time, earliest first)
- **Time**: `HH:MM` from commit timestamp
- **Conv**: 3-digit Conv number extracted from subject
- **Repo**: `code` or `docs`
- **Hash**: 7-char short hash
- **Branch**: the branch recorded for this commit in Step 2c (de-duped — non-HEAD/non-main preferred when a commit is reachable from multiple branches, since that's where the work was actually done). Common values: `main`, `jfg-dev-9`, `jfg-dev-10up`, etc.
- **Machine**: from `Machine:` line in commit body
- **Block**: from `Block:` line in commit body
- No blank lines between `::` fields (Dataview requirement)

**Machine field:** Union of `Machine:` values from commit bodies in the group. If none found, check heartbeat commit subjects for the `— MachineName` pattern. Omit field entirely if still unknown.

### Step 9: Output

1. Write ALL timecards to `.timecard.md` in the docs repo root (overwrites previous, gitignored)
   - If multiple groups: separate timecards with `---` horizontal rule and a blank line
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
| Commits on a long-lived non-HEAD branch | Step 2 scans all local branches via `git for-each-ref refs/heads/`, prompts the user if non-HEAD branches have in-window commits, and records the branch name in each Git History row. De-dup keeps a commit reachable from multiple branches once, preferring the non-HEAD/non-main branch since that's where the work was actually done. |
| Two active branches in one day | Default is include-all; user can deselect branches at the Step 2b prompt. Each commit's Branch column makes it trivial to spot which work went where. |

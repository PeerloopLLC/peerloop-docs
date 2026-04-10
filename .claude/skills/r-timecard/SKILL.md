---
name: r-timecard
description: Generate merged dual-repo timecard for client billing
argument-hint: "c<N>d<N> or conv=NNN[,NNN,...] (e.g., c2d3, conv=019, conv=017,018)"
allowed-tools: Bash, Read, Write, Glob
---

# Generate Dual-Repo Session Timecard

Create a single merged timecard covering both the code repo (Peerloop) and docs repo (peerloop-docs) for client billing.

**Data source:** All timecard content (Focus, For Client, Work Effort) is derived exclusively from git commit messages — never from the current conversation.

---

## Pre-computed Context

!`cat .claude/config.json 2>/dev/null || echo "(no config)"`

---

## Project Defaults

| Field | Value | Notes |
|-------|-------|-------|
| `Bill?` | From config.json `billing.currentCode` | Update config.json as project progresses |
| Code repo path | `../Peerloop` | From config.json `codeRepo` |
| Code repo name | `Peerloop` | For Git History header |
| Docs repo name | `peerloop-docs` | For Git History header |

---

## Arguments

Two mutually exclusive modes:

### Mode 1: Count-based (`cNdN`)

Compact syntax: `c` = code commits, `d` = docs commits, each followed by a count.

| Input | Meaning | Example |
|-------|---------|---------|
| `c2d3` | 2 code + 3 docs commits | `/r-timecard c2d3` |
| `d3c2` | Same (order doesn't matter) | `/r-timecard d3c2` |
| `c1` | Code only (1 commit) | `/r-timecard c1` |
| `d5` | Docs only (5 commits) | `/r-timecard d5` |
| `c10d12` | Multi-digit counts | `/r-timecard c10d12` |

**Parsing:** Extract `c(\d+)` → code count, `d(\d+)` → docs count.

- **At least one** of `c` or `d` is required
- Both are typically provided (the common case)
- If only one is provided, the timecard has a single Git History section (still valid — no need to redirect to another skill)

### Mode 2: Conv-based (`conv=NNN`)

Select commits by conversation number — matches commits containing `Conv NNN` in the message.

| Input | Meaning | Example |
|-------|---------|---------|
| `conv=019` | All commits from Conv 019 | `/r-timecard conv=019` |
| `conv=017,018` | All commits from Conv 017 and 018 | `/r-timecard conv=017,018` |
| `conv=015,016,017` | Multiple convs | `/r-timecard conv=015,016,017` |

**Parsing:** Extract the value after `conv=`, split on `,`, trim each token. Each must be a zero-padded 3-digit number.

- Searches **both repos** automatically — no need to specify `c` or `d`
- If a repo has zero matching commits, its Git History section is simply omitted
- At least one matching commit across both repos is required; error if none found

### General Rules

- **No arguments is NOT allowed.** Stop with usage message if empty.
- **Modes are mutually exclusive.** If both `conv=` and `cNdN` tokens are present, error with: "Use either `conv=NNN` or `cNdN`, not both."
- **Reject** bare numbers, missing digits, or unrecognized tokens.

---

## Workflow

### Step 1: Validate Arguments

1. If empty → exit with: "Usage: `/r-timecard c2d3` or `/r-timecard conv=019`"
2. Detect mode:
   - If argument starts with `conv=` → **conv mode**
   - If argument contains `c` or `d` followed by digits → **count mode**
   - If both patterns are present → error: "Use either `conv=NNN` or `cNdN`, not both."
3. **Count mode:** At least one of `c` or `d` must be present; reject characters other than `c`, `d`, and digits
4. **Conv mode:** Split value after `conv=` on `,`. Each token must be a 3-digit zero-padded number (e.g., `019`, `017`). Reject non-numeric or non-3-digit tokens.

### Step 2: Extract Commits

Run git log directly. Do NOT invoke other skills — they write files and open editors, which conflicts with this workflow.

#### Count mode (cNdN)

**Code repo** (if `c` count provided):
```bash
git -C ../Peerloop log -N --format="---COMMIT---%n%ci%n%h %H%n%B" --date=local
```

**Docs repo** (if `d` count provided):
```bash
git log -N --format="---COMMIT---%n%ci%n%h %H%n%B" --date=local
```

#### Conv mode (conv=NNN)

Search **both repos** for commits matching the conv numbers. Use `--grep` with OR logic to match any of the provided conv numbers.

For each conv number in the list, add a `--grep="Conv NNN"` flag. Multiple `--grep` flags use OR by default in git.

**Code repo:**
```bash
git -C ../Peerloop log --grep="Conv 019" --grep="Conv 017" --format="---COMMIT---%n%ci%n%h %H%n%B" --date=local
```

**Docs repo:**
```bash
git log --grep="Conv 019" --grep="Conv 017" --format="---COMMIT---%n%ci%n%h %H%n%B" --date=local
```

- Run both repos unconditionally — if a repo has zero matches, simply omit its Git History section
- If **zero** commits are found across both repos, error: "No commits found matching Conv NNN in either repo."

### Step 3: Extract Timing (across both repos)

Timing is merged across ALL commits from both repos:

| Field | Rule |
|-------|------|
| Date | Earliest date across both repos. If multi-day: "Jan 15–16, 2026" |
| Start | Earliest `Start:` value across all commits from both repos |
| End | Latest `End:` value across all commits from both repos |
| Machine | Union of `Machine:` values from both repos (comma-separated if multiple) |

**Fallback:** If any commit lacks `Date:`/`Start:`/`End:` fields, use `?` for missing values and derive Date from earliest commit timestamp.

### Step 4: Analyze Commit Messages (unified)

Read ALL commits from both repos together, then derive:

1. **Focus** (1-liner): Synthesize a single client-understandable theme spanning both repos
   - If code and docs work is related (usual case): one unified theme
   - If truly disparate: comma-separated themes

2. **For Client/Admin** bullets: Extract `User-facing:` / `Admin-facing:` lines from commits. Group under `##### User-facing` and `##### Admin-facing` H5 sub-headers (strip the prefix from each bullet). Omit a sub-header if it has no bullets. Omit the entire section if none.

3. **API Changes**: Extract `API:` lines from commits. Deduplicate exact matches, consolidate near-matches. Order by HTTP method then path. Omit section if none.

4. **Page Changes**: Extract `Page:` lines from commits. Deduplicate. Order by route path. Omit section if none.

5. **Role Changes**: Extract `Role:` lines from commits. Deduplicate. Order by role name. Omit section if none.

6. **Infra Changes**: Extract `Infra:` lines from commits. Deduplicate. Order alphabetically. Omit section if none.

7. **Doc Changes**: Extract `Doc:` lines from commits. Deduplicate. Order alphabetically. Omit section if none.

8. **Work Effort** bullets: Technical work from Changes/Fixes/Tests sections
   - Combine from both repos into a single list, grouped logically (not by repo)
   - Be concise but don't limit bullet count

### Step 5: Generate Merged Timecard

```markdown
### 🕒 Timecard • ⚽️ Coding • (5 commits) - Mar 10, 2026 - 12:26 to 14:30
- `Tools  `:: [[Claude Code]]
- `Machine`:: MacMiniM4
- `Focus  `:: [unified 1-liner focus description]
- `Start  `:: 12:26
- `End    `:: 14:30
- `Adjust `:: 00
- `Bill?  `:: Block-04
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
Mar 10, 2026

| Time | Conv | Repo | Hash | Machine | Block |
|------|------|------|------|---------|-------|
| 13:05 | 019 | code | a1b2c3d | MacMiniM4 | EXPLORE-COURSES |
| 13:40 | 019 | docs | e4f5g6h | MacMiniM4 | EXPLORE-COURSES |
| 14:20 | 019 | code | i7j8k9l | MacMiniM4 | EXPLORE-COURSES |
```

**Structure:** One header → sections (each omitted if empty) → Git History table.

**Commit count in title:** Sum of both repos. Always use `(N commits)` format — even for 1 commit (consistency with multi-repo context).

**For Client/Admin:** If no commits have `User-facing:` / `Admin-facing:` lines and all work is purely technical (infrastructure, tooling, docs-only), omit this section entirely.

**Fewer commits than requested:** If `c5` is passed but the code repo only has 3 commits, use the 3 that exist. Do not error — `git log -5` silently returns fewer.

**Field notes:**
- `Adjust` — Minutes to subtract from billable time (user fills in manually). Always default to `00`.
- `Bill?` — Billing code from config.json `billing.currentCode`.

**Formatting rules:**
- **No blank lines between sections** — Obsidian Dataview reads the `::` fields; blank lines break parsing
- Omit `Machine` field if no `Machine:` line in any commit message
- Each Git History section gets its own `####` header with repo name

**Heartbeat commits:** Commits matching the pattern `Conv NNN start — MachineName` (created by `/r-start`) are **excluded from Git History** — they contain no meaningful work. Their timestamps are still used for Start/End timing range.

**Git History table rules:**
- Date line above table: `Mon DD, YYYY` (same format as title). If commits span multiple days, add a second date line before those rows.
- Exclude heartbeat commits
- Interleave both repos chronologically (sorted by commit time, earliest first)
- **Time**: `HH:MM` from commit timestamp
- **Conv**: 3-digit Conv number extracted from subject
- **Repo**: `code` or `docs`
- **Hash**: 7-char short hash
- **Machine**: from `Machine:` line in commit body
- **Block**: from `Block:` line in commit body

### Step 6: Output

1. Write to `.timecard.md` in the docs repo root (overwrites previous, gitignored)
2. Open in editor (from config.json `editor`, default: `code`):
   ```bash
   code .timecard.md
   ```
3. Tell user: "Opened timecard in [editor] — ready for copying"

---
name: w-timecard-dual
description: Generate merged dual-repo timecard for client billing
argument-hint: "c<N>d<N> (e.g., c2d3 = 2 code + 3 docs commits)"
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
| `Bill?` | `Block-07` | Update as project progresses through blocks |
| Code repo path | `../Peerloop` | From config.json `codeRepo` |
| Code repo name | `Peerloop` | For Git History header |
| Docs repo name | `peerloop-docs` | For Git History header |

---

## Arguments

Compact syntax: `c` = code commits, `d` = docs commits, each followed by a count.

| Input | Meaning | Example |
|-------|---------|---------|
| `c2d3` | 2 code + 3 docs commits | `/w-timecard-dual c2d3` |
| `d3c2` | Same (order doesn't matter) | `/w-timecard-dual d3c2` |
| `c1` | Code only (1 commit) | `/w-timecard-dual c1` |
| `d5` | Docs only (5 commits) | `/w-timecard-dual d5` |
| `c10d12` | Multi-digit counts | `/w-timecard-dual c10d12` |

**Parsing:** Extract `c(\d+)` → code count, `d(\d+)` → docs count.

- **At least one** of `c` or `d` is required
- Both are typically provided (the common case)
- If only one is provided, the timecard has a single Git History section (still valid — no need to redirect to `/w-timecard`)
- **No arguments is NOT allowed.** Stop with usage message if empty.
- **Reject** bare numbers, missing digits, or unrecognized tokens.

---

## Workflow

### Step 1: Validate Arguments

1. If empty → exit with: "Usage: `/w-timecard-dual c2d3`"
2. Parse using the regex rules from Arguments section above
3. At least one of `c` or `d` must be present; error if neither found
4. Reject if the argument contains characters other than `c`, `d`, and digits

### Step 2: Extract Commits

Run git log directly for each repo that has a count. Do NOT invoke `/w-timecard` or `/w-git-history` — they write files and open editors, which conflicts with this workflow.

**Code repo** (if `c` count provided):
```bash
git -C ../Peerloop log -N --format="---COMMIT---%n%ci%n%h %H%n%B" --date=local
```

**Docs repo** (if `d` count provided):
```bash
git log -N --format="---COMMIT---%n%ci%n%h %H%n%B" --date=local
```

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

2. **For Client/Admin** bullets: Changes visible to users/admins
   - Combine client-facing changes from both repos into a single list
   - No "(Docs)" or "(Code)" suffixes — this is a unified view
   - Consolidate `User-facing:` / `Admin-facing:` / `for Users:` / `for Admin:` lines from commits

3. **Work Effort** bullets: Technical work performed
   - Combine technical work from both repos into a single list
   - No "(Docs)" or "(Code)" suffixes
   - Group logically (not by repo) — the client doesn't care which repo a change landed in
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
- `Bill?  `:: Block-06
#### For Client/Admin
- [Client-visible change 1]
- [Client-visible change 2]
#### Work Effort
- [Technical work 1]
- [Technical work 2]
#### Git History — Peerloop
##### 2026-Mar-10 14:20:19 (code)
- [Commit title]
- [hash] ([full hash])
- [Bullets from commit...]
##### 2026-Mar-10 13:05:22 (code)
- [Commit title]
- [hash] ([full hash])
- [Bullets from commit...]
#### Git History — peerloop-docs
##### 2026-Mar-10 13:40:55 (docs)
- [Commit title]
- [hash] ([full hash])
- [Bullets from commit...]
```

**Structure:** One header → one For Client/Admin → one Work Effort → code Git History (if present) → docs Git History (if present). Code section comes first.

**Commit count in title:** Sum of both repos. Always use `(N commits)` format — even for 1 commit (consistency with multi-repo context).

**For Client/Admin:** If no commits have `User-facing:` / `Admin-facing:` lines and all work is purely technical (infrastructure, tooling, docs-only), omit this section entirely.

**Fewer commits than requested:** If `c5` is passed but the code repo only has 3 commits, use the 3 that exist. Do not error — `git log -5` silently returns fewer.

**Field notes:**
- `Adjust` — Minutes to subtract from billable time (user fills in manually). Always default to `00`.
- `Bill?` — Billing code from Project Defaults above.

**Formatting rules:**
- **No blank lines between sections** — Obsidian Dataview reads the `::` fields; blank lines break parsing
- Git history commits use `#####` (h5)
- Git History section headers use `####` (h4)
- Omit `Machine` field if no `Machine:` line in any commit message
- Each Git History section gets its own `####` header with repo name

**Heartbeat commits:** Commits matching the pattern `Conv NNN start — MachineName` (created by `/r-start`) are **excluded from Git History** — they contain no meaningful work. They are still counted in the header commit total and their timestamps are still used for Start/End timing range.

**Git history formatting** (same rules as w-git-history):
- Convert date: `2026-01-14 21:13:54` → `2026-Jan-14 21:13:54`
- Tag with `(code)` or `(docs)` on datetime line
- Exclude: `🤖 Generated with`, `Co-Authored-By:`, trailing blank lines, heartbeat commits (see above)
- Keep as bullets: `Machine:`, `Date:`, `Start:`, `End:`, `Block:`
- Convert to past tense
- Include ALL bullets — never truncate

### Step 6: Output

1. Write to `/tmp/timecard.md` (fixed name — overwrites previous; file is disposable once copied)
2. Open in editor (from config.json `editor`, default: `cursor`):
   ```bash
   cursor /tmp/timecard.md
   ```
3. Tell user: "Opened timecard in [editor] — ready for copying"

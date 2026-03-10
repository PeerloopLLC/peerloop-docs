---
name: q-timecard
description: Generate commit(s) timecard for client billing
argument-hint: "N=<number> or commit=<hash>,... (required) [repo=code|docs]"
allowed-tools: Bash, Read, Write, Glob
---

# Generate Session Timecard

Create a formatted timecard for client billing with work summary and git history.

**Data source:** All timecard content (Focus, For Client, Work Effort) is derived exclusively from git commit messages — never from the current conversation.

---

## Pre-computed Context

!`cat .claude/config.json 2>/dev/null || echo "(no config)"`

**Current session** (for output filename only):
!`grep '^## Session' SESSION-INDEX.md 2>/dev/null | tail -1 | sed 's/## Session //' || echo "(unknown)"`

---

## Project Defaults

| Field | Value | Notes |
|-------|-------|-------|
| `Bill?` | `Block-06` | Update as project progresses through blocks |
| `defaultRepo` | `code` | Used when `repo=` is omitted |

---

## Arguments

| Format | Meaning | Example |
|--------|---------|---------|
| `N=<number>` | Last N commits | `/q-timecard N=1` |
| `commit=<hash>,..` | Specific commit(s) | `/q-timecard commit=fb805ed,5be33a1` |
| `repo=code` | Target code repo (default) | `/q-timecard N=1 repo=code` |
| `repo=docs` | Target docs repo | `/q-timecard N=1 repo=docs` |

- `repo=` is orthogonal — combine with `N=` or `commit=`
- If `repo=` omitted, use `defaultRepo` above (`code`)
- **No arguments is NOT allowed.** Stop with usage message if empty.

---

## Workflow

### Step 1: Validate Arguments

1. If empty → exit with: "Usage: `/q-timecard N=1` or `/q-timecard commit=fb805ed`"
2. Strip `repo=` token → store as REPO_ARG (must be `code` or `docs` if present)
3. Parse remainder:
   - `N=<int>` → mode=count
   - `commit=<hashes>` → mode=commits
   - Anything else → exit with usage message

### Step 2: Extract Commits

Run git log directly (do NOT invoke `/q-git-history` — it writes to a file and opens an editor, which conflicts with this workflow):

```bash
cd ../Peerloop  # or CWD for docs repo
git log -N --format="---COMMIT---%n%ci%n%h %H%n%B" --date=local  # for N= mode
git log <hash> -1 --format="---COMMIT---%n%ci%n%h %H%n%B" --date=local  # for commit= mode (per hash)
```

Note the **Repository name** (`Peerloop` or `peerloop-docs`).

### Step 3: Extract Timing

**From commit messages** (new format has `Date:`, `Start:`, `End:` lines):

| Scenario | Date | Start | End |
|----------|------|-------|-----|
| N=1 with timing fields | From `Date:` line | From `Start:` line | From `End:` line |
| N=1 without timing fields | From commit timestamp | ? | ? |
| N>1, all have timing fields | Earliest `Date:` (or range if multi-day: "Jan 15–16, 2026") | Earliest `Start:` | Latest `End:` |
| N>1, any missing timing | From earliest commit timestamp | ? | ? |

**Machine:** Extract `Machine:` lines from commit messages. If multiple unique values, list comma-separated. Omit if none found.

### Step 4: Analyze Commit Messages

From the git history output, derive:

1. **Focus** (1-liner): Broad, client-understandable theme across all commits
   - Single commit: derive from title
   - Multiple commits: synthesize unifying theme, or comma-separated list if disparate

2. **For Client** bullets: Changes visible to users/admins
   - New pages, features, bug fixes users would notice
   - Performance improvements, admin capabilities
   - Consolidate `User-facing:` / `Admin-facing:` / `for Users:` / `for Admin:` lines from commits

3. **Work Effort** bullets: Technical work performed
   - Key decisions, patterns established, problems solved
   - Infrastructure, tooling improvements
   - Be concise but don't limit bullet count

### Step 5: Generate Timecard

```markdown
### 🕒 Timecard • ⚽️ Coding • Jan 16, 2026 - HH:MM to HH:MM
- `Tools  `:: [[Claude Code]]
- `Machine`:: MacMiniM4
- `Focus  `:: [1-liner focus description]
- `Start  `:: HH:MM
- `End    `:: HH:MM
- `Adjust `:: 00
- `Bill?  `:: Block-06
#### For Client/Admin
- [Client-visible change 1]
- [Admin-visible change 2]
#### Work Effort
- [Technical work 1]
- [Technical work 2]
#### Git History — Peerloop
##### 2026-Jan-19 14:20:19 (code)
- [Commit title]
- [hash] ([full hash])
- [Bullets from commit...]
```

**Field notes:**
- `Adjust` — Minutes to subtract from billable time (user fills in manually). Always default to `00`.
- `Bill?` — Billing code from Project Defaults above.

**Formatting rules:**
- **No blank lines between sections** — Obsidian Dataview reads the `::` fields; blank lines break parsing
- Git history commits use `#####` (h5)
- Omit `Machine` field if no `Machine:` line in commit messages
- **Multi-commit header:** `### 🕒 Timecard • ⚽️ Coding • (4 commits) - Jan 16, 2026 - ? to ?`
- **Git History header:** `#### Git History — <RepoName>` (`Peerloop` or `peerloop-docs`)
- **Docs repo tagging:** When `repo=docs`, append " (Docs)" to `#### For Client/Admin` and `#### Work Effort` headings

**Git history formatting** (same rules as q-git-history):
- Convert date: `2026-01-14 21:13:54` → `2026-Jan-14 21:13:54`
- Tag with `(code)` or `(docs)` on datetime line
- Exclude: `🤖 Generated with`, `Co-Authored-By:`, trailing blank lines
- Keep as bullets: `Machine:`, `Date:`, `Start:`, `End:`, `Block:`
- Convert to past tense
- Include ALL bullets — never truncate

### Step 6: Output

1. Write to `/tmp/timecard-session-N.md` (N = session number)
2. Open in editor (from config.json `editor`, default: `cursor`):
   ```bash
   cursor /tmp/timecard-session-N.md
   ```
3. Tell user: "Opened timecard in [editor] — ready for copying"

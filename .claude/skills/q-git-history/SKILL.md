---
name: q-git-history
description: Extract commit history for the current day, period of days, last N commits, or specific commits
argument-hint: "[today | Nd | N | commit=<hash>,...] [repo=code|docs]"
allowed-tools: Bash, Read, Write, Glob
---

# Git History Report

Extract commit history and format as markdown with client-perspective summaries.

---

## Pre-computed Context

!`cat .claude/config.json 2>/dev/null || echo "(no config)"`

**Docs repo:**
!`echo "$(basename $(git rev-parse --show-toplevel 2>/dev/null)) on $(git rev-parse --abbrev-ref HEAD 2>/dev/null)" || echo "(unknown)"`

**Code repo:**
!`echo "$(basename $(git -C ../Peerloop rev-parse --show-toplevel 2>/dev/null)) on $(git -C ../Peerloop rev-parse --abbrev-ref HEAD 2>/dev/null)" || echo "(unknown)"`

---

## Arguments

| Argument | Meaning | Example |
|----------|---------|---------|
| (empty) or `today` | Commits from today only | `/q-git-history` |
| `Nd` or `N days` | Commits from last N days | `/q-git-history 7d` |
| A number `N` | Last N commits | `/q-git-history 10` |
| `commit=<hash>,..` | Specific commit(s) | `/q-git-history commit=fb805ed,5be33a1` |
| `repo=code` | Target code repo | `/q-git-history 5 repo=code` |
| `repo=docs` | Target docs repo (default) | `/q-git-history today repo=docs` |

`repo=` is orthogonal — combine with any filter. Default: docs repo (CWD).

---

## Workflow

### Step 1: Parse Arguments

Strip `repo=` token from arguments before parsing the filter:
- Empty or "today" → today's commits
- Ends with "d" or "days" → last N days
- Plain number → last N commits
- Starts with "commit=" → split by commas for specific hashes

### Step 2: Resolve Repo Path

| `repo=` value | Git target |
|---------------|------------|
| `code` | `../Peerloop` (from config.json `codeRepo`) |
| `docs` or omitted | CWD (docs repo) |
| anything else | Error |

When target is set, all git commands use `git -C <target>`.

Use the pre-computed repo info above for the output header (repo name + branch).

### Step 3: Extract Commits

| Filter | Command |
|--------|---------|
| Today | `git log --since="midnight" --format="---COMMIT---%n%ci%n%h %H%n%B" --date=local` |
| N days | `git log --since="N days ago" --format="---COMMIT---%n%ci%n%h %H%n%B" --date=local` |
| Last N | `git log -N --format="---COMMIT---%n%ci%n%h %H%n%B" --date=local` |
| Specific | `git log <hash> -1 --format="---COMMIT---%n%ci%n%h %H%n%B" --date=local` (per hash) |

### Step 4: Format Each Commit

- Convert date: `2026-01-14 21:13:54` → `2026-Jan-14 21:13:54` (3-letter month: Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec)
- Tag with repo: `(code)` or `(docs)` on the datetime line
- **Exclude:** `🤖 Generated with`, `Co-Authored-By:`, trailing blank lines
- **Keep as regular bullets:** `Machine:`, `Date:`, `Start:`, `End:`, `Block:`
- **Keep as-is if present:** `User-facing:` / `Admin-facing:` lines (already in commit from q-commit)
- **Convert to past tense:** "Add feature" → "Added feature"
- **CRITICAL:** Include ALL bullet points from EVERY commit. Never truncate or summarize.

### Step 5: Client Perspective Summary

If the commit **already has** `User-facing:` or `Admin-facing:` lines, convert them to the `for Users:` / `for Admin:` format — do NOT duplicate.

If the commit **lacks** client perspective lines, assess whether to add them:

```
- for Users: ability to book sessions from teacher profile
- for Admin: new payout approval dashboard
- for Creators: course analytics now show completion rates
```

**Skip** for pure refactoring, infrastructure, or docs-only commits.

**Use Peerloop terminology** (Teacher, Creator, Student — see `docs/GLOSSARY.md`).

### Step 6: Output

1. Write formatted markdown to `/tmp/git-history.md`
2. Open in editor (from config.json `editor`, default: `cursor`):
   ```bash
   cursor /tmp/git-history.md
   ```
3. Tell user: "Opened `/tmp/git-history.md` in [editor]"

If no commits found, report that no commits match the filter.

---

## Output Format Example

```markdown
### Commits
**Repository**: peerloop-docs | **Branch**: main | **Filter**: last 2 commits

##### 2026-Mar-10 13:03:00 (docs)
- Session 368: Auto-synced session numbers across machines
- a843add (a843add...)
- Date: 2026-03-10
- Start: 12:26
- End: 13:03
- Machine: MacMiniM4
- Block: SKILLS-MIGRATE
- Added git pull --ff-only to session-tracker.sh hook
- Replaced manual start=HHMM argument with automatic SESSION-INDEX.md parsing

##### 2026-Mar-10 12:44:00 (docs)
- Session 368: Added timing fields to q-commit skill
- 919bc68 (919bc68...)
- Date: 2026-03-10
- Start: 12:26
- End: 12:44
- Machine: MacMiniM4
- Block: SKILLS-MIGRATE
- Added start=HHMM optional argument to q-commit skill
- Added Date, Start, End fields to commit message footer template
```

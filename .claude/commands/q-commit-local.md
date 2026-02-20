---
description: Project-specific commit conventions (extends /q-commit)
argument-hint: ""
---

# Peerloop Commit Conventions

**Extends:** `/q-commit` (run that first for standard workflow)

This skill adds Peerloop-specific commit message guidance.

---

## Dual-Repo Git Workflow

Peerloop uses two repos: **peerloop-docs** (this repo, CC home) and **Peerloop** (code repo, via `--add-dir`).

### Step 1: Check Both Repos for Changes

```bash
# Code repo changes
git -C ../Peerloop status

# Docs repo changes
git status
```

### Step 2: Commit Based on What Changed

| Scenario | Action |
|----------|--------|
| Code changes only | Commit in code repo via `git -C ../Peerloop add . && git -C ../Peerloop commit -m "..."` |
| Doc changes only | Commit locally: `git add . && git commit -m "..."` |
| Both repos changed | Commit code first (`git -C ../Peerloop`), then docs locally |

### Step 3: Use Same Session Number

Both commits should use the same session number in the commit message (e.g., `Session 232: ...`).

### Push Behavior

- Push code repo: `git -C ../Peerloop push`
- Push docs repo: `git push`
- Always push both if both had commits.

---

## Machine Name in Commits

**Always include the development machine name in commit messages.**

### How to Get Machine Name

Read the file `~/.claude/.machine-name` (created by the global SessionStart hook):

```bash
cat ~/.claude/.machine-name
```

This returns `MacMiniM4-Pro`, `MacMiniM4`, or similar.

### Where to Include

Add a `Machine:` line in the commit footer, before the Claude attribution:

```
Add teacher availability management

- Implement TEACHING.AVAILABILITY section
- Add /api/availability endpoints

Machine: MacMiniM4-Pro

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

**Why:** Tracking which machine was used helps debug environment-specific issues and provides context in the commit history.

---

## Client Perspective Summary

Git commits are technical, but Peerloop commits should also communicate **what changed from a user/admin perspective**.

### Include These Types of Changes

When writing commit bullets, add context about:

| Category | Examples |
|----------|----------|
| **User-visible changes** | New pages, UI improvements, new features |
| **Admin capabilities** | New admin tools, moderation features, dashboard updates |
| **Monitoring/Operations** | New logging, error handling, analytics |
| **Performance** | Speed improvements, optimization |
| **SEO/Marketing** | Meta tags, CTAs, landing page changes |

### Example Commit Message

```
Add teacher availability management

Changes:
- Implement TEACHING.AVAILABILITY section with weekly schedule editor
- Add /api/availability endpoints (GET, POST, PATCH, DELETE)
- Create AvailabilityCalendar component with drag-to-select

Fixes:
- Fix timezone offset bug in schedule display (AvailabilityRow.tsx)

Tests:
- Add 24 API tests covering auth, CRUD, validation, 503 errors
- Add 18 component tests for calendar rendering and interactions
- Fix existing slot overlap test (wrong mock timezone)

Scripts:
- Create scripts/page-tests/test-AVAIL.sh (42 tests across 5 files)

Stats: 8 files changed, 42 tests added, all passing

User-facing: Teachers can now set their weekly availability from dashboard
Admin-facing: Availability data visible in teacher management panel

Block: TEACHING (section 4 of 7)
Machine: MacMiniM4-Pro

🤖 Generated with [Claude Code](https://claude.ai/code)

Co-Authored-By: Claude <noreply@anthropic.com>
```

### When to Add Client Perspective

Add "User-facing:" or "Admin-facing:" lines when the commit includes:

- New pages that users will see
- New functionality (refunds, login options, booking, etc.)
- Changes to existing user flows
- New admin tools or reports
- Performance improvements users might notice

**Skip** the client perspective for purely technical commits (refactoring, type fixes, dependency updates).

---

## Block/Section References

When committing work related to PLAN.md blocks, mention the block code:

```
Implement ADMIN.USERS section

- Add user listing with search and filters
- Create user detail view with role management
...

Block: ADMIN (section 2 of 12)
```

This helps track progress against the plan.

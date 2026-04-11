---
name: w-codecheck
description: Run comprehensive code quality checks
argument-hint: "[smart|fix|clear] - optional mode"
allowed-tools: Read, Edit, Bash, Glob, Grep
---

# Code Quality Check

Run comprehensive code quality checks (TypeScript + ESLint + Tailwind + Astro).

---

## Pre-computed Context

!`cat .claude/config.json 2>/dev/null || echo "(no config)"`

**Required scripts present:**
!`cd ../Peerloop && node -e "const s=require('./package.json').scripts||{}; const need=['typecheck','lint','lint:fix','check','check:tailwind']; const miss=need.filter(n=>!s[n]); console.log(miss.length?'MISSING: '+miss.join(', '):'All present (typecheck, lint, lint:fix, check, check:tailwind)')" 2>/dev/null || echo "(could not check)"`

---

## Usage

- `/w-codecheck` — Run all checks, report errors, add todos for failures
- `/w-codecheck smart` — Skip checks if no relevant files changed
- `/w-codecheck fix` — Run checks, fix issues, re-run, update todos
- `/w-codecheck clear` — Remove all codecheck-related todos

Only one argument allowed. Arguments are mutually exclusive.

**All commands run from the code repo:** `cd ../Peerloop && ...`

---

## Execution Flow

1. Parse argument (none, `smart`, `fix`, or `clear`)
2. If `clear`: remove all codecheck todos and exit
3. Check pre-computed "Required scripts present" above — if any MISSING, exit with warning
4. Run checks (TypeScript, ESLint, Tailwind, Astro)
5. Report combined results
6. Add todos for any failures

---

## Checks

| # | Check | Command | Has auto-fix? |
|---|-------|---------|---------------|
| 1 | TypeScript | `cd ../Peerloop && npm run typecheck` | Manual only |
| 2 | ESLint | `cd ../Peerloop && npm run lint` | `npm run lint:fix` |
| 3 | Tailwind | `cd ../Peerloop && npm run check:tailwind` | Manual (class renames) |
| 4 | Astro | `cd ../Peerloop && npm run check` | No auto-fix |
| 5 | SQLite datetime | Grep check (see below) | Manual (`datetime()` → `strftime()`) |

---

## Smart Mode (`smart`)

Skip checks if no relevant files changed.

### Step 1: Get Changed Files

Compare against **origin** to capture all unpushed changes (not just uncommitted):

```bash
cd ../Peerloop
BRANCH=$(git branch --show-current)
git diff --name-only origin/$BRANCH...HEAD 2>/dev/null
git ls-files --others --exclude-standard
```

**Edge case**: If branch has no upstream, fall back to `git diff --name-only HEAD`.

### Step 2: Determine Which Checks to Run

| Check | Run if ANY of these changed |
|-------|----------------------------|
| **TypeScript** | `*.ts`, `*.tsx`, `tsconfig.json`, `package.json` |
| **ESLint** | `*.ts`, `*.tsx`, `eslint.config.*`, `package.json` |
| **Tailwind** | `*.tsx`, `*.astro`, `src/**/*.ts`, `src/styles/*.css`, `tailwind.config.*`, `package.json` |
| **Astro** | `*.astro`, `astro.config.*` |
| **SQLite datetime** | `*.ts` (in `src/` only) |

If no relevant files changed for a check, report "SKIP (no relevant changes)".

---

## Fix Mode (`fix`)

Single-pass fix attempt:

1. Run all checks to identify issues
2. Attempt fixes:
   - **TypeScript:** Fix type errors manually (missing types, mismatches, null/undefined)
   - **ESLint:** Run `npm run lint:fix` first, then fix remaining manually
   - **Tailwind:** Update deprecated class names using the rename table below
   - **Astro:** Report only — no auto-fix available
3. Re-run all checks once
4. Update todos: passed → complete, still failing → update count
5. Report final status

---

## Clear Mode (`clear`)

Remove all codecheck-related todos:
- `Fix TypeScript errors (*)`
- `Fix ESLint errors (*)`
- `Fix Tailwind issues (*)`
- `Fix Astro errors (*)`

---

## Report Format

```
Code Quality Check
──────────────────

  TypeScript:   [PASS/FAIL/SKIP] (details)
  ESLint:       [PASS/FAIL/SKIP] (details)
  Tailwind:     [PASS/FAIL/SKIP] (details)
  Astro:        [PASS/FAIL/SKIP] (details)

Status: [All Checks Passed / Issues Found]
```

**If issues found (default mode):** Add todos for each failed check with error count:
```
Fix TypeScript errors (X errors)
```

Only add todos for checks that actually failed.

---

## Tailwind v3 → v4 Class Renames

Reference for fix mode. Matches what `check-tailwind-v4.sh` detects:

| Old (v3) | New (v4) | Notes |
|----------|----------|-------|
| `bg-gradient-to-*` | `bg-linear-to-*` | |
| `shadow-sm` | `shadow-xs` | Base shifts down |
| `shadow` | `shadow-sm` | Base shifts down |
| `drop-shadow-sm` | `drop-shadow-xs` | |
| `drop-shadow` | `drop-shadow-sm` | |
| `blur-sm` | `blur-xs` | Base shifts down |
| `blur` | `blur-sm` | |
| `backdrop-blur-sm` | `backdrop-blur-xs` | |
| `backdrop-blur` | `backdrop-blur-sm` | |
| `rounded-sm` | `rounded-xs` | Base shifts down |
| `rounded` | `rounded-sm` | |
| `ring` | `ring-3` | Default width changed 3px→1px |
| `outline-none` | `outline-hidden` | Behavior change |
| `bg-opacity-*` | `bg-color/opacity` | e.g., `bg-black/50` |
| `text-opacity-*` | `text-color/opacity` | |
| `border-opacity-*` | `border-color/opacity` | |
| `flex-shrink-*` | `shrink-*` | |
| `flex-grow-*` | `grow-*` | |
| `overflow-ellipsis` | `text-ellipsis` | |
| `decoration-slice` | `box-decoration-slice` | |
| `decoration-clone` | `box-decoration-clone` | |
| `[--var]` | `(--var)` | CSS variable syntax |

**Note:** `check:tailwind` may report false positives for classes in comments or string literals. Review each match.

---

## SQLite datetime() Check

**Why:** SQLite's `datetime()` returns space-separated format (`2026-03-25 11:00:00`), but Peerloop stores all timestamps in ISO format with `T` separator (`2026-03-25T11:00:00.000Z`). In string comparisons, space (ASCII 32) < T (ASCII 84), causing `datetime()` results to silently compare as "less than" ISO strings. This produces incorrect query results. See `CLAUDE.md > SQLite Datetime Rule`.

**Check:** Use Grep to find `datetime(` in `src/` `.ts` files, excluding lines that are comments (`//` or `*`).

```bash
cd ../Peerloop && grep -rn 'datetime(' src/ --include='*.ts' | grep -v '//' | grep -v '\*.*datetime' | grep -v 'NOTE.*datetime' | grep -v 'legacy'
```

**Pass condition:** Zero non-comment, non-documentation matches. Any `datetime()` call in application SQL is a potential bug.

**Fix:** Replace `datetime(expr, modifier)` with `strftime('%Y-%m-%dT%H:%M:%fZ', expr, modifier)`.

**Known safe uses (excluded from check):**
- Schema DDL defaults: `DEFAULT (strftime('%Y-%m-%dT%H:%M:%fZ', 'now'))` — already uses strftime
- Comments/docs referencing `datetime()` as a concept (excluded by grep filter)

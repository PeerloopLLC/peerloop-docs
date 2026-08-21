---
name: w-codecheck
description: Fast static code-quality checks for commit-safety (runs npm run codecheck; no test/build)
argument-hint: "[smart|fix] - optional mode"
allowed-tools: Read, Edit, Bash, Glob, Grep
---

# Code Quality Check (commit-safety)

Runs **`npm run codecheck`** — the fast **static** quality pass: TypeScript · ESLint · Tailwind ·
Astro · icon-sizing · invented-token/icon names · SQLite-datetime · error-render · env-access ·
Figma-assets · schema-aware `deleted_at`. Its job: a **commit is free of errors, especially nuisance
hints and warnings**. It does **not** run `npm test` or `npm run build`.

> **Two levels of safety.** `/w-codecheck` = *commit-safety* = `npm run codecheck` (fast static). The
> next level up, *deploy-safety*, is **`npm run verify`** = `codecheck` + `npm test` + `npm run build`
> (excludes Playwright E2E and PLATO browser tests). **Every gate is one npm script**, so `verify` is a
> true superset of `codecheck` — nothing runs only in the skill. Gate rationale, fix guidance,
> calibration and the Tailwind rename table live in
> [docs/reference/CODECHECK.md](../../../docs/reference/CODECHECK.md).

---

## Pre-computed Context

!`cat .claude/config.json 2>/dev/null || echo "(no config)"`

**Required scripts present:**
!`cd ../Peerloop && node -e "const s=require('./package.json').scripts||{}; const need=['codecheck','verify','lint:fix']; const miss=need.filter(n=>!s[n]); console.log(miss.length?'MISSING: '+miss.join(', '):'All present (codecheck, verify, lint:fix)')" 2>/dev/null || echo "(could not check)"`

---

## Usage

- `/w-codecheck` — run `npm run codecheck`, report per-check results
- `/w-codecheck smart` — run only the `check:*` scripts whose inputs changed
- `/w-codecheck fix` — run, auto-fix what's fixable, re-run, report

Only one argument allowed. Arguments are mutually exclusive.

**All commands run from the code repo:** `cd ../Peerloop && ...`

---

## Execution Flow

1. Parse argument (none, `smart`, or `fix`)
2. Check pre-computed "Required scripts present" above — if any MISSING, exit with warning
3. **Default:** `cd ../Peerloop && npm run codecheck` — the reporter (`scripts/codecheck.mjs`) runs every
   static check **without short-circuiting** and prints ONE grouped report: 🔴 build-blockers (CI gates) ·
   ⚠️ local quality gates · ℹ️ warnings/hints. **Smart:** run only the `check:*` scripts mapped to changed
   files (see Smart Mode). Commit-safety only — no `test`/`build`; a deploy/baseline claim needs `npm run verify`.
4. **Relay the grouped report**, emphasising anything under 🔴 — those fail CI and block a staging/prod deploy.
5. **Fix on demand:** for each non-PASS finding, fix it when the user says so, or — when a fix is clearly
   needed — invoke it directly and re-run to confirm. Large tracked backlogs (e.g. the ESLint warning
   families → `[A11Y]`/`[RHOOKS]`) are surfaced *with their scope*, not silently bulk-fixed.

---

## Checks (each is one npm script; `npm run codecheck` runs them all)

| # | Check | Command | Has auto-fix? |
|---|-------|---------|---------------|
| 1 | TypeScript | `npm run typecheck` | Manual only |
| 2 | ESLint | `npm run lint` | `npm run lint:fix` |
| 3 | Tailwind | `npm run check:tailwind` | Manual (rename table in CODECHECK.md) |
| 4 | Astro | `npm run check` | No auto-fix |
| 5 | Icon sizing | `npm run check:icons` | Manual |
| 6 | Invented token/icon names | `npm run check:tokens` | Manual (use a declared token / real icon) |
| 7 | SQLite datetime | `npm run check:datetime` | Manual (`datetime()` → `strftime()`) |
| 8 | Error-captured-never-rendered | `npm run check:error-render` | Manual (add error display to JSX) |
| 9 | locals.runtime.env access | `npm run check:env` | Manual (use `getEnv()`/`requireEnv()`) |
| 10 | Figma-asset sweep | `npm run check:figma` | Manual (inline the SVG / move to MattIcon) |
| 11 | Schema-aware deleted_at | `npm run check:deleted-at` | Manual (wrong column for that table) |

Rationale, fix detail and calibration for every row: [docs/reference/CODECHECK.md](../../../docs/reference/CODECHECK.md).
The gate scripts live in `../Peerloop/scripts/` (`check-*.sh`, `check-*.ts`, `codecheck-deleted-at.mjs`).

---

## Smart Mode (`smart`)

Run only the checks whose inputs changed.

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

Run each script (`cd ../Peerloop && npm run <script>`) if ANY of its trigger files changed:

| Script | Run if ANY of these changed |
|--------|----------------------------|
| `typecheck` | `*.ts`, `*.tsx`, `tsconfig.json`, `package.json` |
| `lint` | `*.ts`, `*.tsx`, `eslint.config.*`, `package.json` |
| `check:tailwind` | `*.tsx`, `*.astro`, `src/**/*.ts`, `src/styles/*.css`, `tailwind.config.*`, `package.json` |
| `check` (Astro) | `*.astro`, `astro.config.*` |
| `check:icons` | `*.tsx`, `*.astro`, `src/**/*.ts` |
| `check:tokens` | `*.tsx`, `*.astro`, `src/**/*.ts`, `src/styles/*.css`, `src/components/icons/svg/*.svg` |
| `check:datetime` | `*.ts` (in `src/` only) |
| `check:error-render` | `*.tsx` (in `src/components/` only) |
| `check:env` | `*.ts`, `*.astro` (in `src/` only) |
| `check:figma` | `*.ts`, `*.tsx`, `*.astro`, `*.css` (in `src/` only) |
| `check:deleted-at` | `*.ts` (in `src/` only), `migrations/0001_schema.sql` |

If no relevant files changed for a check, report "SKIP (no relevant changes)".

---

## Fix Mode (`fix`)

Single-pass fix attempt:

1. Run `npm run codecheck` to identify issues
2. Attempt fixes:
   - **ESLint:** run `npm run lint:fix` first, then fix remaining manually
   - **Tailwind:** update deprecated class names using the rename table in [CODECHECK.md](../../../docs/reference/CODECHECK.md)
   - **Everything else** (TypeScript · Astro · icons · tokens · datetime · error-render · env · figma · deleted_at): no auto-fix — apply the manual **Fix** documented for each in [CODECHECK.md](../../../docs/reference/CODECHECK.md)
3. Re-run `npm run codecheck` once
4. Report final status

---

## Report Format

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  Code-Check Report — commit-safety (static; no test/build)
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

🔴 BUILD-BLOCKERS — fail CI, block staging/prod deploy
   ✓ none            (else: TypeScript / Astro / Timezone lint / ESLint errors, with findings)

⚠️  LOCAL QUALITY GATES — not in CI; fix before it spreads, but won't block a deploy
   ✓ none            (else: Tailwind / Icon sizing / tokens / datetime / error-render / env / figma / deleted_at)

ℹ️  WARNINGS / HINTS — reported, non-blocking
   ESLint  163 warning(s)  (88 react-hooks, 75 jsx-a11y)

  Summary: 0 build-blocker(s) · 0 local-gate failure(s) · 163 warning(s)
```

**Build-blocker = a CI gate** (`.github/workflows/ci.yml`): lint-errors · typecheck · astro check ·
`lint:tz` · test · build. Of those, `test` + `build` are deploy-safety — `npm run verify` covers them.
Exit is non-zero iff a 🔴 build-blocker **or** an ⚠️ local gate fails; ESLint warnings alone don't fail it.
`fix` mode additionally attempts fixes and re-runs. Rationale: [CODECHECK.md](../../../docs/reference/CODECHECK.md).

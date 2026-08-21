# Code-Check Reference

Rationale, fix guidance and calibration for the `/w-codecheck` gates. The skill itself
([`.claude/skills/w-codecheck/SKILL.md`](../../.claude/skills/w-codecheck/SKILL.md)) is the
operational surface — *what* runs and *how to invoke it*. This doc is the *why* behind each gate,
and it is where a fix-mode run looks up the Tailwind rename mapping.

Category: **manual** (editorial — not auto-maintained by the docs registry).

---

## Two levels of safety

There are two distinct quality gates, and it matters which one a claim rests on:

| Level | Command | Runs | Purpose |
|-------|---------|------|---------|
| **Commit-safety** | `npm run codecheck`<br>(`/w-codecheck` runs it) | Fast **static** checks only — TypeScript · ESLint · Tailwind · Astro · icon-sizing · invented-token/icon names · the grep/script gates | A commit is **free of errors, especially nuisance hints and warnings**. Fast enough to run constantly while coding. **No `test`/`build`.** |
| **Deploy-safety** | `npm run verify` | **`npm run codecheck`** + `npm test` (vitest unit/integration) + `npm run build` | Safe to deploy. Excludes Playwright **E2E** (`test:e2e`) and **PLATO browser** tests by design. This is the authoritative **baseline** command (see `CLAUDE.md §Baseline Verification`). |

`/w-codecheck` is **not** the baseline — a baseline/deploy claim requires `npm run verify`.

---

## The codecheck reporter

`npm run codecheck` runs `scripts/codecheck.mjs`, which executes **every** static check **without
short-circuiting** (an `&&` chain stops at the first failure and can't report the rest) and prints one
grouped report. Findings are organised by how much they matter:

- **🔴 Build-blockers** — checks that gate CI (`.github/workflows/ci.yml`, on push/PR to `main`) and so
  block a staging/prod deploy: **ESLint errors · `typecheck` · `check` (astro) · `lint:tz` · `test` ·
  `build`**. `test` + `build` are deploy-safety (run via `npm run verify`); the rest are static and run here.
- **⚠️ Local quality gates** — the project's own gates (`check:tailwind`, `check:icons`, `check:tokens`,
  and the five grep/script gates below). **Not** in CI, so a hit is real debt but does not block a deploy.
- **ℹ️ Warnings / hints** — ESLint **warnings** (CI's `lint` passes on warnings, so they never block a
  build). Reported with a per-family breakdown; deliberately warn-only, triaged via `[A11Y]` / `[RHOOKS]`.

**Exit code:** non-zero iff a 🔴 build-blocker or an ⚠️ local gate fails; ESLint warnings alone keep it at
0. So `verify` (= `codecheck && test && build`) still gates on anything that would break CI. `lint:tz` is
included here because it is a CI gate — earlier it ran *only* in CI (the retired `[TZLINT]` finding).

---

## The grep / script gates

Five gates that were once inline greps are now standalone npm scripts — `check:datetime`,
`check:error-render`, `check:env`, `check:figma`, `check:deleted-at` (files in `../Peerloop/scripts/`)
— all part of `npm run codecheck` and `npm run verify`. Their rationale:

### SQLite `datetime()`

**Why:** SQLite's `datetime()` returns space-separated format (`2026-03-25 11:00:00`), but Peerloop
stores all timestamps in ISO format with a `T` separator (`2026-03-25T11:00:00.000Z`). In string
comparisons, space (ASCII 32) < `T` (ASCII 84), so `datetime()` results silently compare as "less
than" ISO strings — incorrect query results. See `CLAUDE.md §SQLite Datetime Rule`.

**Fix:** replace `datetime(expr, modifier)` with `strftime('%Y-%m-%dT%H:%M:%fZ', expr, modifier)`.

**Known-safe (excluded by the grep filter):** schema DDL defaults already using `strftime`;
comments/docs referencing `datetime()` as a concept.

> Not to be confused with **`npm run lint:tz`** (`scripts/lint-timezone.sh`), which scans *test
> files* for JS `Date` timezone-unsafety (`.setHours()` → `.setUTCHours()`) — a different check.
> `lint:tz` is currently wired into neither `/w-codecheck` nor `npm run verify` (open question).

### Error-captured-never-rendered

**Why:** a component catches an error into state (`setError(...)`) but never renders it, so the user
sees nothing when an operation fails. Discovered Conv 105 during `[HW]` cleanup.

**Fix:** add an error render (`{error && …}`) for the captured state.

### `locals.runtime.env` access

**Why:** Cloudflare adapter v13 (Conv 100–101) removed `locals.runtime.env`. All env access must go
through `getEnv()` / `requireEnv()` from `src/lib/env.ts`; a direct `locals.runtime` reference is a
build-time-silent, runtime-failure bug.

**Fix:** use `getEnv()` / `requireEnv()`.

### Figma-asset sweep

**Why:** Matt-design translation runs Figma → code only; Figma asset URLs (`figma.com/…`,
`mcp/asset/…`) expire after 7 days (see `memory/reference_figma_mcp_behavior`), so any such URL in
`src/` is a time-bomb broken image. Verified zero in Conv 186 (`[ASSET-SWEEP]`); this gate keeps it
at zero (`[ASSET-SWEEP-GATE]`, Conv 244).

**Fix:** inline the SVG, or register it through `MattIcon` (`src/components/icons/svg/`) — never
hot-link.

### Schema-aware `deleted_at`

**Why:** only 4 tables have a `deleted_at` column (`users`, `progressions`, `courses`,
`enrollments`). Others use different soft-delete mechanisms (e.g. `communities` uses `is_archived`).
`deleted_at IS NULL` against a table without the column silently returns wrong results or 500s at
runtime (D1: `no such column`). Regression class discovered Conv 117 (`communities` endpoint).

**Runs:** `npm run check:deleted-at` (`scripts/codecheck-deleted-at.mjs`, in the code repo) — parses
`migrations/0001_schema.sql` for which tables have the column, then binds each `deleted_at`
reference in `src/**/*.ts` SQL template literals to its FROM/JOIN table (via alias resolution)
before deciding whether to flag.

**Fix:** use the correct soft-delete column for that table.

**Heuristic v2 (Conv 168).** v1 flagged "table-name and `deleted_at` co-occur in the same block" —
90 false positives across 18 tables (Conv 167). v2 binds each reference to a specific table:

- **Qualified** `<token>.deleted_at` → resolve `<token>` via the alias map (or as a literal table
  name); flag if the resolved table lacks the column.
- **Unqualified** `deleted_at` → flag only when *none* of the in-scope FROM/JOIN tables has the
  column (otherwise the SQL resolves there, or errors as ambiguous — v2 stays silent).

Calibration (Conv 168): the Conv 117 motivating case fires; 5 hand-built counter-examples (3 silent
/ 2 fire) match expected behaviour; a live scan emits 0 violations vs v1's 90. Only scans
template-literal SQL in `.ts` files — `.astro` SSR queries typically delegate to `.ts` lib
functions, so they are covered transitively.

---

## Invented token / icon names (`check:tokens`)

`check:tokens` (`scripts/check-token-names.ts`) is the **only** gate that catches invented design
tokens. Both Tailwind and MattIcon fail **silently** on a name that does not exist — Tailwind emits
no rule for an unknown utility (`bg-success-background` is simply no background), and
`<MattIcon name="check" />` renders a placeholder box with a DEV-only `console.warn` that no gate
reads. So `tsc`, ESLint, `astro check`, the full test suite and `build` all pass green while a banner
ships with no background and a broken icon. Conv 434 (`[TOKEN-TYPO]`) shipped three invented
colour/type tokens (`bg-success-background`, `text-success-700`, `text-text-secondary`) plus
`name="check"` in one small component — every one written by following the naming *convention*
instead of the *catalogue*, and all caught only by looking at the screen (the check that does not
scale).

**How it stays quiet enough to keep on:** it polices **only project-owned colour families** this repo
declares and Tailwind does not ship (`success`, `error`, `text`, `brian`, `course`, …), where
"declared or invalid" is exact. Built-in Tailwind palettes (`neutral`, `blue`, …) are skipped, so a
valid `bg-neutral-700` is never flagged.

**Blind spots:** runtime-built names (`text-${tone}-500`), and *role* correctness — a valid token in
the wrong role still renders wrong.

**Fix:** replace the invented name with a declared token or a real icon from
`src/components/icons/svg/` — verify against the **catalogue**, not the convention that invited the
typo.

---

## Icon sizing (`check:icons`)

`check:icons` (`scripts/check-icon-sizing.ts`) guards icon-sizing conformity against
`scripts/icon-sizing-baseline.json`. It is part of `npm run verify` and (since Conv 439) the
commit-safety pass too.

---

## Tailwind v3 → v4 class renames

Reference for fix mode — matches what `scripts/check-tailwind-v4.sh` detects.

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
| `outline-none` | `outline-hidden` | Behaviour change (preserves outline in forced-colors) |
| `bg-opacity-*` | `bg-color/opacity` | e.g. `bg-black/50` |
| `text-opacity-*` | `text-color/opacity` | |
| `border-opacity-*` | `border-color/opacity` | |
| `flex-shrink-*` | `shrink-*` | |
| `flex-grow-*` | `grow-*` | |
| `overflow-ellipsis` | `text-ellipsis` | |
| `decoration-slice` | `box-decoration-slice` | |
| `decoration-clone` | `box-decoration-clone` | |
| `[--var]` | `(--var)` | CSS variable syntax |

**Note:** `check:tailwind` may report false positives for classes in comments or string literals —
review each match.

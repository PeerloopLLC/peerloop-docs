---
name: w-sync-docs
description: Sync documentation with actual codebase — audit test docs, API docs, CLI docs for drift
argument-hint: "[audit|fix] - default: audit"
allowed-tools: Read, Edit, Write, Bash, Glob, Grep, Agent, TaskCreate, TaskUpdate
---

# Documentation Sync

Audit and fix documentation drift between docs and the actual codebase. Covers test docs, API docs, and CLI docs.

**Dual-repo note:** Docs live in `peerloop-docs/docs/reference/`, code lives in `../Peerloop/`. All file paths in docs should be repo-root-relative (e.g., `tests/api/admin/dashboard.test.ts`, not `admin/dashboard.test.ts`).

---

## Pre-computed Context

**Disk file counts:**
!`echo "Vitest files: $(find ../Peerloop/tests -name '*.test.ts' -o -name '*.test.tsx' 2>/dev/null | wc -l | tr -d ' ')" && echo "E2E files: $(find ../Peerloop/e2e -name '*.spec.ts' 2>/dev/null | wc -l | tr -d ' ')" && echo "API routes: $(find ../Peerloop/src/pages/api -name '*.ts' 2>/dev/null | wc -l | tr -d ' ')" && echo "npm scripts: $(cd ../Peerloop && node -e "console.log(Object.keys(require('./package.json').scripts||{}).length)" 2>/dev/null)"`

**Doc last-updated dates:**
!`for f in docs/reference/TEST-COVERAGE.md docs/reference/TEST-COMPONENTS.md docs/reference/TEST-PAGES.md docs/reference/TEST-UNIT.md docs/reference/TEST-E2E.md docs/reference/CLI-QUICKREF.md docs/reference/API-REFERENCE.md; do echo "$(basename $f): $(grep -m1 'Last Updated' $f 2>/dev/null | sed 's/.*\*\*Last Updated:\*\* //' || echo '(not found)')"; done`

---

## Usage

- `/w-sync-docs` or `/w-sync-docs audit` — Report discrepancies only, do not modify files
- `/w-sync-docs fix` — Report and fix all discrepancies

---

## Execution Flow

Work through these audits in order. For each, report findings. If mode is `fix`, apply corrections after each audit.

---

## Audit 1: Test Documentation

The test doc family has 5 files with specific roles:

| Doc | Scope | Lists individual files? |
|-----|-------|------------------------|
| `TEST-COVERAGE.md` | Master index — all categories | Yes (all except components) |
| `TEST-COMPONENTS.md` | `tests/components/` | Yes |
| `TEST-PAGES.md` | `tests/pages/` | Yes |
| `TEST-UNIT.md` | `tests/lib/`, `tests/unit/`, `tests/integration/`, `tests/ssr/` | Yes |
| `TEST-E2E.md` | `e2e/` | Yes |

### 1.1 Verify file counts in TEST-COVERAGE.md summary table

Run `find` for each category and compare against the summary table:

```bash
cd ../Peerloop
echo "api: $(find tests/api -name '*.test.ts' | wc -l)"
echo "components: $(find tests/components -name '*.test.ts' -o -name '*.test.tsx' | wc -l)"
echo "pages: $(find tests/pages -name '*.test.ts' -o -name '*.test.tsx' | wc -l)"
echo "lib: $(find tests/lib -name '*.test.ts' | wc -l)"
echo "integration: $(find tests/integration -name '*.test.ts' | wc -l)"
echo "ssr: $(find tests/ssr -name '*.test.ts' | wc -l)"
echo "unit: $(find tests/unit -name '*.test.ts' | wc -l)"
echo "e2e: $(find e2e -name '*.spec.ts' | wc -l)"
```

Also verify Vitest total and test case count:
```bash
cd ../Peerloop && npx vitest run 2>&1 | grep -E "Test Files|Tests "
```

Flag any mismatch between disk counts and the summary table.

### 1.2 Check for phantom entries (in doc but not on disk)

For each doc, extract all backtick-quoted test file paths and verify they exist on disk:

```bash
# Extract paths from doc, verify each exists
grep -o '`tests/[^`]*\.test\.ts[x]*`\|`e2e/[^`]*\.spec\.ts`' docs/reference/TEST-COVERAGE.md | sed 's/`//g' | while read f; do
  [ ! -f "../Peerloop/$f" ] && echo "PHANTOM: $f"
done
```

Repeat for TEST-COMPONENTS.md, TEST-PAGES.md, TEST-UNIT.md, TEST-E2E.md.

### 1.3 Check for undocumented files (on disk but not in doc)

```bash
# All test files on disk
find ../Peerloop/tests -name "*.test.ts" -o -name "*.test.tsx" | sed "s|../Peerloop/||" | sort > /tmp/disk-tests.txt

# All paths in TEST-COVERAGE.md
grep -o '`tests/[^`]*\.test\.ts[x]*`' docs/reference/TEST-COVERAGE.md | sed 's/`//g' | sort > /tmp/doc-tests.txt

# Files on disk but not in doc (excluding components — delegated to TEST-COMPONENTS.md)
comm -13 /tmp/doc-tests.txt /tmp/disk-tests.txt | grep -v '^tests/components/'
```

For components, diff against TEST-COMPONENTS.md instead:
```bash
grep -o '`tests/components/[^`]*`' docs/reference/TEST-COMPONENTS.md | sed 's/`//g' | sort > /tmp/doc-components.txt
find ../Peerloop/tests/components -name "*.test.ts" -o -name "*.test.tsx" | sed "s|../Peerloop/||" | sort > /tmp/disk-components.txt
comm -13 /tmp/doc-components.txt /tmp/disk-components.txt
```

### 1.4 Cross-reference primary ↔ secondary docs

Verify that files listed in TEST-COVERAGE.md's category sections match the corresponding secondary doc:

- **Pages**: Extract paths from both TEST-COVERAGE.md (Pages section) and TEST-PAGES.md, diff them
- **Lib/Unit/Integration/SSR**: Extract from TEST-COVERAGE.md and TEST-UNIT.md, diff
- **E2E**: Extract from TEST-COVERAGE.md and TEST-E2E.md, diff
- **Components**: TEST-COVERAGE.md delegates to TEST-COMPONENTS.md — verify the count matches

### 1.5 Verify section header counts

Each section in TEST-COVERAGE.md has a header like `### Admin — tests/api/admin/ (60 files)`. Verify these counts match both the table rows in that section AND the actual file count on disk.

### 1.6 Check path format standardization

All paths in backticks should be repo-root-relative:
- `tests/api/...` (not `admin/...`)
- `tests/lib/...` (not `lib/...`)
- `tests/pages/...` (not `pages/...`)
- `e2e/...` (already correct)

```bash
# Find non-standard paths (missing tests/ or e2e/ prefix)
grep -oE '`[a-z][^`]*\.test\.ts[x]*`' docs/reference/TEST-COVERAGE.md | grep -v '`tests/' | grep -v '`src/' | grep -v '`e2e/'
```

### 1.7 Check for blank test counts

Look for `—` or empty test count cells. If found, run the specific test file to get the count:

```bash
cd ../Peerloop && npx vitest run <file> 2>&1 | grep "Tests "
```

---

## Audit 2: API Documentation

### 2.1 Route file inventory

```bash
cd ../Peerloop && find src/pages/api -name "*.ts" | wc -l
```

Compare against documented endpoint count in `API-REFERENCE.md`.

### 2.2 Undocumented routes

For each API route file, check if its endpoint name appears in the corresponding API doc (use the route mapping from r-docs):

| Route Prefix | Document |
|--------------|----------|
| `/api/auth/*` | `API-AUTH.md` |
| `/api/courses/*` | `API-COURSES.md` |
| `/api/admin/*` | `API-ADMIN.md` |
| `/api/me/*` | `API-ENROLLMENTS.md` (except communities) |
| `/api/sessions/*`, `/api/teachers/*` | `API-SESSIONS.md` |
| `/api/communities/*`, `/api/feeds/*` | `API-COMMUNITY.md` |
| Other | See `r-docs/scripts/route-mapping.txt` |

### 2.3 Phantom endpoints

Check for endpoints documented in API-*.md that no longer have corresponding route files.

---

## Audit 3: Schema Documentation

**Target doc:** `docs/reference/DB-GUIDE.md`

If the doc doesn't exist, report "DB-GUIDE.md not found — skipping schema audit" and move on.

### 3.1 Schema inventory

```bash
cd ../Peerloop && ls migrations/*.sql 2>/dev/null
ls migrations-dev/*.sql 2>/dev/null
```

Extract table names from `migrations/0001_schema.sql`:

```bash
grep -oE 'CREATE TABLE (IF NOT EXISTS )?[a-z_]+' ../Peerloop/migrations/0001_schema.sql | awk '{print $NF}' | sort
```

Compare against tables documented in DB-GUIDE.md.

### 3.2 Undocumented tables

For each table in the schema file, check if its name appears in DB-GUIDE.md. Flag any that don't.

### 3.3 Phantom tables

Check for tables documented in DB-GUIDE.md that no longer have corresponding `CREATE TABLE` entries in the schema file.

---

## Audit 4: CLI Documentation

### 4.1 npm scripts vs CLI-QUICKREF.md

```bash
cd ../Peerloop && node -e "Object.keys(require('./package.json').scripts||{}).sort().forEach(s=>console.log(s))"
```

Compare each script name against `docs/reference/CLI-QUICKREF.md`.

### 4.2 Script files vs SCRIPTS.md

```bash
cd ../Peerloop && ls scripts/*.{js,ts,sh,mjs} 2>/dev/null
```

Compare against `docs/reference/SCRIPTS.md`.

---

## Audit 5: Cross-Document Consistency

### 5.1 DECISIONS.md category coverage

Check that `docs/DECISIONS.md` and `DOC-DECISIONS.md` (docs-repo root) have decision entries present and grouped under category headings. Flag any expected category whose section is empty, and flag decisions that appear to be mis-routed (application decision in DOC-DECISIONS.md or docs-infra decision in DECISIONS.md).

### 5.2 Tech stack drift (CLAUDE.md)

Compare the "Technology Stack" table in `CLAUDE.md` against `../Peerloop/package.json` dependencies:

```bash
cd ../Peerloop && node -e "
const p=require('./package.json');
const deps={...(p.dependencies||{}),...(p.devDependencies||{})};
Object.keys(deps).sort().forEach(k=>console.log(k));
" > /tmp/pkg-deps.txt
```

Flag any package name in CLAUDE.md's tech stack that isn't in `package.json`, and any major framework package (astro, react, @astrojs/*, drizzle, @cloudflare/*) in `package.json` that isn't represented in the tech stack table.

### 5.3 RFC INDEX.md completeness

Every `CD-*` folder under `docs/requirements/rfc/` must have a corresponding row in `docs/requirements/rfc/INDEX.md`:

```bash
ls -1 docs/requirements/rfc/ 2>/dev/null | grep -E '^CD-[0-9]+$' | sort > /tmp/rfc-folders.txt
grep -oE 'CD-[0-9]+' docs/requirements/rfc/INDEX.md 2>/dev/null | sort -u > /tmp/rfc-indexed.txt
comm -23 /tmp/rfc-folders.txt /tmp/rfc-indexed.txt  # folders not in index
comm -13 /tmp/rfc-folders.txt /tmp/rfc-indexed.txt  # index rows with no folder
```

Flag both directions.

---

## Report Format

Present results as:

```
Documentation Sync Report
═════════════════════════

Test Docs:
  Summary table counts:     [OK / N mismatches]
  Phantom entries:          [OK / N phantoms found]
  Undocumented files:       [OK / N files missing from docs]
  Cross-reference:          [OK / N discrepancies]
  Section header counts:    [OK / N mismatches]
  Path format:              [OK / N non-standard paths]
  Blank test counts:        [OK / N blanks]

API Docs:
  Route coverage:           [OK / N undocumented routes]
  Phantom endpoints:        [OK / N phantoms]

Schema Docs (DB-GUIDE.md):
  Table coverage:           [OK / N undocumented tables]
  Phantom tables:           [OK / N phantoms]

CLI Docs:
  Script coverage:          [OK / N undocumented scripts]
  Script file coverage:     [OK / N undocumented files]

Cross-Document:
  DECISIONS.md coverage:    [OK / N empty or mis-routed]
  Tech stack drift:         [OK / N drift items]
  RFC INDEX completeness:   [OK / N unindexed or phantom rows]

Overall: [All synced / N issues found]
```

---

## Fix Mode

If argument is `fix`:

1. **Fix in order of impact**: summary counts first, then phantom/missing entries, then path format, then blank counts
2. **For blank test counts**: run `npx vitest run <file>` to get actual count before filling in
3. **For missing files**: add to the appropriate section with test count from a targeted vitest run
4. **For phantom entries**: remove from doc, update section counts
5. **For path format**: use repo-root-relative (`tests/...`, `e2e/...`)
6. **Update "Last Updated" dates** on every modified doc
7. **Do NOT commit** — leave changes staged for the user to review

### TodoWrite discipline

If any issue is found that you do NOT fix (e.g., a test file exists but you're unsure which section it belongs in), create a TodoWrite item. Never report an issue to the user without either fixing it or tracking it.

---

## When to Use

- After adding/removing test files, API endpoints, or npm scripts
- Periodically (every 5-10 sessions) to catch drift
- When `/r-docs` sync-gaps report flags test documentation issues
- Before end-of-session if test files were created or modified

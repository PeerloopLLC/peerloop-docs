# Documentation Sync Strategy

**Last Updated:** 2026-04-18 (Conv 132)
**Status:** Phase 1 draft — catalog + schema proposal. Phases 2–3 are implementation milestones, not yet started.
**Block:** DOC-SYNC-STRATEGY
**Related:** PLAN.md §DOC-SYNC-STRATEGY, `.claude/config.json`, `.claude/skills/r-end2/`, `.claude/skills/w-sync-docs/`

---

## 1. Problem

Documentation drifts silently from the codebase. Session 383 surfaced this: the COURSE-PAGE-MERGE (Session 379) changed tab count and retired components, but 5 architecture/reference docs still described the old structure two sessions later. A TEST-COVERAGE.md rebuild found 258 of 318 test files undocumented. These are systemic, not one-off.

The platform already has **three independent drift-detection tools**, each with its own hardcoded lists:

| Tool | Scope | Config | Trigger |
|------|-------|--------|---------|
| `sync-gaps.sh` | npm scripts, API routes, scripts, tests | `route-mapping.txt` + inline shared-basenames list | `/r-end2` docs agent |
| `tech-doc-sweep.sh` | src/ → reference + as-designed docs | Inline `RULES` array (11 keyword rules) | `/r-end2` docs agent |
| `/w-sync-docs` | Test docs (5-file family), API, schema, CLI, DECISIONS, tech stack, RFC INDEX | Inline audit sections (5 audits, 15+ checks) | Manual |

Overlap exists (API, CLI, tests appear in multiple tools) without cross-check; `config.json` has doc whitelists/blacklists that only `rTimecardDay` reads; no CI or hook surfaces drift at point-of-change.

---

## 2. Doc Inventory

196 tracked `.md` files (excluding `docs/sessions/**`), grouped for classification:

| Group | Count | Pattern |
|------|------:|---------|
| API reference | 17 | `docs/reference/API-*.md`, `DB-API.md`, `REMOTE-API.md`, `helpers.md` |
| Test reference | 5 | `docs/reference/TEST-*.md` |
| CLI reference | 4 | `docs/reference/CLI-*.md` |
| Scripts doc | 1 | `docs/reference/SCRIPTS.md` |
| DB schema | 2 | `docs/reference/DB-GUIDE.md`, `docs/as-designed/schema-diagram.md` |
| Vendor / tech | 18 | `docs/reference/{astrojs,stripe,cloudflare*,stream,resend,sentry,posthog,bigbluebutton,plugnmeet,reactjs,tailwindcss,cloudinary,charting,google-oauth,auth-libraries,react-big-calendar,react-day-picker}.md` |
| Role / glossary | 2 | `docs/reference/ROLES.md`, `docs/GLOSSARY.md` |
| Architecture (active) | 27 | `docs/as-designed/*.md` (top-level, excluding `_*`) |
| Run-001 planning | 23 | `docs/as-designed/run-001/**` |
| Guides (how-to) | 3 | `docs/guides/*.md` |
| Policy / best-practices | 3 | `docs/POLICIES.md`, `docs/reference/BEST-PRACTICES.md`, `docs/reference/DEVELOPMENT-GUIDE.md` |
| Workflow / skill docs | 5 | `docs/reference/{COMMIT-MESSAGE-FORMAT,BROWSER-TESTING,PLATO-GUIDE,CLI-MISC}.md`, `docs/reference/CLI-REFERENCE.md` |
| Decisions / governance (root) | 6 | `CLAUDE.md`, `PLAN.md`, `COMPLETED_PLAN.md`, `TIMELINE.md`, `DECISIONS.md`, `DOC-DECISIONS.md` |
| Plan state (root) | 2 | `CURRENT-BLOCK-PLAN.md`, `RESUME-STATE.md` (absent when clean) |
| User stories / requirements | 65 | `docs/requirements/**` |
| Indexes (archival) | 4 | `CONV-INDEX.md`, `SESSION-INDEX.md`, `docs/DOCS-REORG-MAP.md`, `docs/as-designed/orig-pages-map.md` |
| Point-in-time audits | 3 | `docs/reference/role-audit-2026-04-15.md`, `docs/reference/STORY-GAP-ANALYSIS.md`, `docs/reference/comp-*.md` |
| Legacy `_`-prefix (retirement candidates) | 9 | `docs/reference/_{API,COMPONENTS,DB-SCHEMA,SERVER}.md`, `docs/as-designed/_{RESEARCH-CLAUDE,STRUCTURE}.md`, `docs/requirements/_{DIRECTIVES,PAGES,SPECS}.md` |
| Generated | 1 | `.timecard.md` (produced by `/r-timecard` skill) |

### Classification

Four categories, defined by **who maintains the doc** and **what happens when code changes**:

| Category | Definition | Policy |
|----------|------------|--------|
| **generated** | Produced entirely from code / data by a tool. No manual authorship. | Regenerate on source change; flag generator failures in CI. |
| **drift-check** | Hand-written, but an automated audit verifies it matches a code source-of-truth. | Run audit on `/r-end2`; surface gaps as 🔴 issues for author to fix. |
| **manual** | Hand-written, no automated check. Drift detection isn't cost-effective or isn't possible (e.g., prose about rationale). | Editorial discipline only. Review during significant refactors. |
| **archival** | Frozen / historical. Not expected to change. | No audit. Flag edits as suspicious. |

Per-group classification:

| Group | Classification | Source of Truth | Check Type |
|-------|----------------|-----------------|------------|
| API reference | drift-check | `../Peerloop/src/pages/api/**/*.ts` | route-coverage, phantom-endpoints |
| Test reference | drift-check | `../Peerloop/tests/**`, `../Peerloop/e2e/**` | file-count, phantom-entries, path-format |
| CLI reference | drift-check | `../Peerloop/package.json:scripts` | script-coverage |
| Scripts doc | drift-check | `../Peerloop/scripts/**` | file-coverage |
| DB schema | drift-check | `../Peerloop/migrations/0001_schema.sql` | table-coverage, phantom-tables |
| Vendor / tech | drift-check | `../Peerloop/src/**` (by keyword) + `package.json:deps` | keyword-match (tech-doc-sweep) |
| Role / glossary | drift-check (proposed) | Role constants in `src/lib/auth/roles.ts`; canonical term use | term-usage audit (new) |
| Architecture (active) | drift-check | `../Peerloop/src/**` (by keyword) | keyword-match (tech-doc-sweep) |
| Run-001 planning | manual | — | — |
| Guides (how-to) | manual | — | — |
| Policy / best-practices | manual | — | — |
| Workflow / skill docs | manual | — | — |
| Decisions / governance (root) | manual | — | — |
| Plan state (root) | manual | — | — |
| User stories / requirements | archival | — | — |
| Indexes (archival) | archival | — | — |
| Point-in-time audits | archival | — | — |
| Legacy `_`-prefix | archival *(retirement candidates)* | — | See §6 |
| Generated | generated | — | (skill-produced) |

---

## 3. Proposed `docsRegistry` Schema

Promote the three tools' hardcoded lists into a single `config.json.docsRegistry` section. All three tools read from it; adding a new doc or tech topic becomes a single config edit.

```jsonc
{
  "docsRegistry": {
    "categories": {
      "generated":  { "description": "Produced entirely by a tool.",             "checkFrequency": "on-source-change" },
      "driftCheck": { "description": "Hand-written with automated audit.",       "checkFrequency": "every-r-end2" },
      "manual":     { "description": "Hand-written, no automated check.",        "checkFrequency": "editorial-only" },
      "archival":   { "description": "Frozen. Edits should be rare and flagged.", "checkFrequency": "never-automated" }
    },

    "groups": [
      {
        "id": "api-docs",
        "category": "driftCheck",
        "pattern": "docs/reference/API-*.md",
        "sourceOfTruth": "../Peerloop/src/pages/api/**/*.ts",
        "checks": ["route-coverage", "phantom-endpoints"],
        "routeMapping": ".claude/skills/r-end2/scripts/route-mapping.txt",
        "consumers": ["sync-gaps.sh#2", "w-sync-docs#2"]
      },
      {
        "id": "test-docs",
        "category": "driftCheck",
        "pattern": "docs/reference/TEST-*.md",
        "sourceOfTruth": ["../Peerloop/tests/**", "../Peerloop/e2e/**"],
        "sharedBasenames": ["download.test.ts", "index.test.ts", "stats.test.ts", "delete.test.ts", "update.test.ts", "create.test.ts"],
        "checks": ["file-count", "phantom-entries", "path-format"],
        "consumers": ["sync-gaps.sh#4", "w-sync-docs#1"]
      },
      {
        "id": "cli-docs",
        "category": "driftCheck",
        "pattern": "docs/reference/CLI-*.md",
        "sourceOfTruth": "../Peerloop/package.json:scripts",
        "checks": ["script-coverage"],
        "consumers": ["sync-gaps.sh#1", "w-sync-docs#4"]
      },
      {
        "id": "scripts-doc",
        "category": "driftCheck",
        "pattern": "docs/reference/SCRIPTS.md",
        "sourceOfTruth": "../Peerloop/scripts/**/*.{js,ts,sh,mjs}",
        "checks": ["file-coverage"],
        "consumers": ["sync-gaps.sh#3", "w-sync-docs#4"]
      },
      {
        "id": "db-guide",
        "category": "driftCheck",
        "pattern": "docs/reference/DB-GUIDE.md",
        "sourceOfTruth": "../Peerloop/migrations/0001_schema.sql",
        "checks": ["table-coverage", "phantom-tables"],
        "consumers": ["w-sync-docs#3"]
      },
      {
        "id": "vendor-docs",
        "category": "driftCheck",
        "docs": {
          "docs/reference/stripe.md":         { "keywords": ["stripe", "checkout", "payment"] },
          "docs/reference/bigbluebutton.md":  { "keywords": ["webhook.*bbb", "video", "bigblue", "plugnmeet"] },
          "docs/reference/plugnmeet.md":      { "keywords": ["webhook.*bbb", "video", "bigblue", "plugnmeet"] },
          "docs/reference/stream.md":         { "keywords": ["feed", "communit", "stream"] },
          "docs/reference/resend.md":         { "keywords": ["email", "resend"] },
          "docs/reference/cloudflare.md":     { "keywords": ["wrangler", "lib/db"] },
          "docs/reference/astrojs.md":        { "keywords": ["\\.astro", "layouts/"] }
          // ... remainder migrated from tech-doc-sweep.sh RULES (lines 27-39)
        },
        "consumers": ["tech-doc-sweep.sh"]
      },
      {
        "id": "architecture-active",
        "category": "driftCheck",
        "pattern": "docs/as-designed/*.md",
        "notPattern": "docs/as-designed/_*.md",
        "sourceOfTruth": "../Peerloop/src/**",
        "checks": ["keyword-match"],
        "consumers": ["tech-doc-sweep.sh"]
      },
      {
        "id": "run-001-planning",
        "category": "manual",
        "pattern": "docs/as-designed/run-001/**",
        "note": "Feature decomposition for the current run. Active but no automated check."
      },
      {
        "id": "guides",
        "category": "manual",
        "pattern": "docs/guides/*.md"
      },
      {
        "id": "policy-governance",
        "category": "manual",
        "docs": [
          "docs/POLICIES.md",
          "docs/DECISIONS.md",
          "docs/reference/BEST-PRACTICES.md",
          "docs/reference/DEVELOPMENT-GUIDE.md",
          "DOC-DECISIONS.md",
          "CLAUDE.md"
        ]
      },
      {
        "id": "plan-state",
        "category": "manual",
        "docs": ["PLAN.md", "COMPLETED_PLAN.md", "TIMELINE.md", "CURRENT-BLOCK-PLAN.md"]
      },
      {
        "id": "user-stories",
        "category": "archival",
        "pattern": "docs/requirements/**",
        "note": "Frozen by convention. Edits should trigger USER-STORIES.md resync."
      },
      {
        "id": "indexes-archival",
        "category": "archival",
        "docs": ["CONV-INDEX.md", "SESSION-INDEX.md", "docs/DOCS-REORG-MAP.md", "docs/as-designed/orig-pages-map.md"]
      },
      {
        "id": "point-in-time-audits",
        "category": "archival",
        "patterns": [
          "docs/reference/role-audit-*.md",
          "docs/reference/STORY-GAP-ANALYSIS.md",
          "docs/reference/comp-*.md"
        ]
      },
      {
        "id": "legacy-underscore",
        "category": "archival",
        "patterns": [
          "docs/reference/_*.md",
          "docs/as-designed/_*.md",
          "docs/requirements/_*.md"
        ],
        "retirementCandidate": true,
        "note": "Pre-rebrand (Alpha Peer) legacy docs. See §6."
      },
      {
        "id": "skill-generated",
        "category": "generated",
        "docs": [".timecard.md"],
        "generator": ".claude/skills/r-timecard/"
      }
    ]
  }
}
```

**Field semantics:**
- `pattern` / `patterns`: glob(s) — match-time list, scales as new docs are added
- `docs`: explicit list — used when a group has mixed ownership
- `notPattern`: exclude sub-patterns (e.g., underscore-prefix inside an include pattern)
- `sourceOfTruth`: what the doc describes; a missing/changed reference is what "drift" means
- `checks`: normalized check names; each tool implements the checks it supports
- `consumers`: which tools currently use this group — for migration tracking

---

## 4. Three-Phase Rollout

### Phase 1 — Catalog + Schema (this conv)

Deliverables:
- [x] This strategy document
- [x] Four-category classification for every doc group
- [x] Proposed `docsRegistry` schema
- [ ] User review of schema before writing it to `config.json`
- [ ] Resolve two retirement candidates (see §6)

**Exit criterion:** Strategy doc merged, schema reviewed, retirement decisions made. No code or config changes committed.

### Phase 2 — Migrate Tools to Registry (future conv)

Migrations, in order of risk:
1. `tech-doc-sweep.sh` — replace inline `RULES` array (lines 27–39) with a reader for `docsRegistry.groups[id=vendor-docs].docs[*].keywords`. Smallest blast radius; the script is already deterministic.
2. `sync-gaps.sh` — replace hardcoded shared-basenames list and doc paths with registry reads. Four checks migrate independently.
3. `/w-sync-docs` — replace inline audit lists with registry-driven loops. Largest tool; migrate last.

**Exit criterion:** All three tools read from `docsRegistry`; the hardcoded tables in their source are removed or reduced to registry lookups. No behavioral change — same audits, same reports.

### Phase 3 — Hook / CI Integration (future conv)

Two integration points to evaluate:
1. **Git pre-commit hook** — run a fast subset (sync-gaps only, skip tech-doc-sweep) on `git commit -m` so drift surfaces at point-of-change, not two convs later.
2. **CI check on PR** — full drift scan on every PR, blocking merge if new phantoms or undocumented files appear.

Pre-commit is the lower-cost option and catches the majority of drift at the right time; CI is the belt-and-suspenders backstop.

**Exit criterion:** Either (a) hook landed and reliable for 10+ convs, or (b) CI check landed and passing on main.

---

## 5. Answers to Open Questions (from PLAN.md)

**Q1: Which docs should be generated?**
Today: only `.timecard.md`. Future candidates: `route-api-map.md` (mechanically derivable from `src/pages/api/` + `src/pages/**/*.astro` routes), `schema-diagram.md` (derivable from `0001_schema.sql` via tooling), `_PAGES-INDEX.md` under run-001 (derivable from the feature files). None are priorities — generation costs engineering time; drift-check is cheaper and sufficient.

**Q2: Which docs should remain hand-written with automated checks?**
37 docs across 8 groups (API, Test, CLI, Scripts, DB-GUIDE, vendor-docs, architecture-active, role/glossary). See §2 classification table.

**Q3 (already answered, Session 390):** `/w-sync-docs` is the dedicated drift-detection skill, separate from `/r-end2`'s inline agent.

**Q4: Can pre-commit or session-start hooks flag stale docs?**
Yes — this is Phase 3. Pre-commit is preferred: drift appears at the moment it's introduced, not two convs later.

**Q5: Right trade-off between completeness and maintenance?**
Codified in the category policy (§2): automate drift-check for code-adjacent docs (API, tests, CLI, schema, vendor); leave prose (architecture, decisions, guides) as editorial. ~37 drift-check docs, ~40 manual, ~80 archival, 1 generated. The cost to maintain a drift-check is bounded by tool runtime; the cost to keep prose in sync is bounded by editorial effort at significant-refactor time.

---

## 6. Retirement Sweep — Executed Conv 132

9 `_`-prefix files were audited for content, branding, and incoming references:

| File | Lines | Outcome | Reason |
|------|-----:|---------|--------|
| `docs/reference/_DB-SCHEMA.md` | 1,937 | **Deleted** | DEPRECATED banner (Session 359), zero incoming links, superseded by `DB-GUIDE.md` + `migrations/0001_schema.sql` |
| `docs/reference/_API.md` | 282 | **Deleted** | Superseded by `API-*.md` family |
| `docs/reference/_COMPONENTS.md` | 1,761 | **Retained** | Active references in `/w-add-client-note` (lines 28, 153) + CLAUDE.md (line 499); reclassified as `driftCheck` against `src/components/**` |
| `docs/reference/_SERVER.md` | 1,368 | **Deleted** | No incoming references; content historical |
| `docs/as-designed/_STRUCTURE.md` | 378 | **Deleted** | Pre-rebrand ("Alpha Peer"), superseded by CLAUDE.md §Project Structure |
| `docs/as-designed/_RESEARCH-CLAUDE.md` | 422 | **Deleted** | Historical CLAUDE.md v7 copy, no active use |
| `docs/requirements/_DIRECTIVES.md` | 109 | **Deleted** | Pre-rebrand GATHER-phase artifact |
| `docs/requirements/_PAGES.md` | 660 | **Deleted** | Superseded by `docs/as-designed/run-001/` + `url-routing.md` |
| `docs/requirements/_SPECS.md` | 69 | **Deleted** | Pre-rebrand v0.1 "Initial Draft", abandoned |

**Totals:** 8 files deleted (~6,265 lines); 1 file retained and reclassified to `driftCheck`.

The surviving `_COMPONENTS.md` joins the drift-check set. A future task (Phase 2+) should add it to the registry's `vendor-docs`-style check, with `src/components/**/*.{tsx,astro}` as source-of-truth.

### Related Conv 132 cleanups

- `.claude/config.json` — `paths.vendorDocs` (`docs/vendors/`, non-existent) → `docs/reference/`; `paths.architectureDocs` (`docs/architecture/`, non-existent) → `docs/as-designed/`. No consumers were found via grep, so this is paper-stale correction.
- `docs/DOCS-REORG-MAP.md` is now partially stale: it documents the `docs/tech/` → `docs/vendors/` move (Session 362) but not the later `docs/vendors/` → `docs/reference/` merge. Not urgent — it's already marked as a historical snapshot.

---

## 7. Out of Scope

- **Rewriting `/r-end2` or `/w-sync-docs`**: Phase 2 migrates them but preserves existing behavior.
- **Changing the session-log workflow**: `docs/sessions/**` is out of scope for `docsRegistry` — it's append-only conv bookkeeping.
- **Migrating `rTimecardDay`**: the existing `docNameWhitelist` / `docRootExclude` serve a different purpose (billing categorization). Leave alone. If needed later, alias them to registry lookups.

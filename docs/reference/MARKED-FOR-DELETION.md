# MARKED-FOR-DELETION Manifest

**Created:** Session 307 (2026-02-27)
**Block:** STORY-REMAP Phase 4
**Status:** AWAITING REVIEW — Nothing deleted yet

This manifest lists all artifacts from the old PageSpec system that are candidates for deletion or archival. **No files will be deleted until this manifest is reviewed and approved.**

---

## Why These Are Dead

The old PageSpec system used JSON files (`src/data/pages/**/*.json`) as page specifications rendered by `PageSpecView.astro`. This was a scaffolding/prototyping system from early development. Pages have since been implemented with real components, and the spec data is now maintained in:

- **Route→story mapping:** `ROUTE-STORIES.md`
- **Page design docs:** `docs/pagespecs/**/*.md`
- **Route definitions:** `docs/tech/tech-021-url-routing.md`

---

## Section A: JSON Page Specs (72 files)

**Location:** `Peerloop/src/data/pages/`
**Action:** Archive to `peerloop-docs/docs/archive/json-page-specs/`

These JSON files are not imported by any Astro page. They're only consumed by:
- `PageSpecView.astro` (also marked for deletion)
- Dead scripts (see Section C)

```
src/data/pages/
├── about.json
├── become-a-teacher.json
├── blog.json
├── careers.json
├── contact.json
├── faq.json
├── for-creators.json
├── help.json
├── how-it-works.json
├── index.json
├── leaderboard.json
├── login.json
├── messages.json
├── notifications.json
├── pricing.json
├── privacy.json
├── profile.json
├── reset-password.json
├── signup.json
├── stories.json
├── terms.json
├── testimonials.json
├── welcome.json
├── admin/
│   ├── analytics.json
│   ├── categories.json
│   ├── certificates.json
│   ├── courses.json
│   ├── enrollments.json
│   ├── index.json
│   ├── moderation.json
│   ├── payouts.json
│   ├── sessions.json
│   ├── student-teachers.json
│   └── users.json
├── community/
│   └── index.json
├── courses/
│   ├── index.json
│   ├── [slug].json
│   └── [slug]/
│       ├── book.json
│       ├── chat.json
│       ├── discuss.json
│       ├── learn.json
│       └── success.json
├── creators/
│   ├── index.json
│   └── [handle].json
├── dash/
│   ├── courses.json
│   ├── discover.json
│   ├── messages.json
│   ├── notifications.json
│   ├── profile.json
│   └── workspace.json
├── dashboard/
│   ├── creator/
│   │   ├── analytics.json
│   │   ├── index.json
│   │   ├── newsletters.json
│   │   └── studio.json
│   ├── learning/
│   │   └── index.json
│   └── teaching/
│       ├── analytics.json
│       ├── earnings.json
│       ├── index.json
│       ├── sessions.json
│       └── students.json
├── groups/
│   └── [id].json
├── invite/
│   └── mod/
│       └── [token].json
├── mod/
│   └── index.json
├── session/
│   └── [id].json
├── settings/
│   ├── index.json
│   ├── notifications.json
│   ├── payments.json
│   ├── profile.json
│   └── security.json
├── teachers/
│   ├── index.json
│   └── [handle].json
└── verify/
    └── [id].json
```

**Total: 72 JSON files**

---

## Section B: Dead PageSpec Components (4 files)

**Location:** `Peerloop/src/`
**Action:** Delete

| File | Lines | Imported By | Notes |
|------|-------|-------------|-------|
| `src/components/PageSpecView.astro` | — | No Astro pages | Renders JSON specs; dead consumer |
| `src/components/dev/SpecPanelToggle.tsx` | — | LandingLayout, LegacyAppLayout | Dev toggle for spec view |
| `src/lib/schemas/page-spec.ts` | — | page-spec-validator.ts | Zod schema for JSON specs |
| `src/lib/validation/page-spec-validator.ts` | — | PageSpecView.astro | Runtime validation |

**Dependency chain:** `SpecPanelToggle` → toggles `PageSpecView` → imports `page-spec-validator` → imports `page-spec` schema.

**Note:** `SpecPanelToggle` is imported in `LandingLayout.astro:18` and `LegacyAppLayout.astro:18`. These imports must be removed when deleting (guarded by `pageCode` prop check, so removal is safe).

**Also dead:**
| File | Notes |
|------|-------|
| `src/lib/types/page-spec.ts` | Type re-exports from schemas/page-spec.ts |

**Total: 5 files**

---

## Section C: Dead Scripts (10 files + 1 directory)

**Location:** `Peerloop/scripts/`
**Action:** Delete

### PageSpec Pipeline Scripts

| Script | Lines | npm Command | Purpose |
|--------|-------|-------------|---------|
| `generate-all-pages.ts` | 156 | `generate-pages` | Generate Astro pages from JSON specs |
| `generate-pages-map.ts` | 267 | `pages-map`, `pages-map:write` | Generate pages map from JSON specs |
| `generate-site-map.ts` | 431 | `site-map`, `site-map:write` | Generate site map from page data |
| `validate-page-spec.ts` | 47 | — | Validate JSON spec files |
| `populate-test-coverage.ts` | 458 | `test:coverage`, `test:coverage:write` | Populate test coverage in JSON specs |
| `populate-page-metadata.ts` | 271 | — | Populate metadata in page specs |
| `page-routes.ts` | 298 | — | Route extraction from JSON specs |
| `parse-page-md.ts` | 356 | `parse-page` | Convert page markdown to JSON spec |
| `parse-all-pages.ts` | 73 | `parse-all-pages` | Batch parse all page markdowns |

### Dead Test Scripts Directory

| Path | Contents | Purpose |
|------|----------|---------|
| `scripts/page-tests/` | 59 shell scripts + 2 markdown files | Per-page test scripts using old page codes |

**Total: 9 scripts (2,357 lines) + 1 directory (61 files)**

### npm Scripts to Remove from package.json

```json
"parse-page": "tsx scripts/parse-page-md.ts",
"parse-all-pages": "tsx scripts/parse-all-pages.ts",
"generate-pages": "tsx scripts/generate-all-pages.ts",
"test:coverage": "tsx scripts/populate-test-coverage.ts",
"test:coverage:write": "tsx scripts/populate-test-coverage.ts --write",
"pages-map": "tsx scripts/generate-pages-map.ts",
"pages-map:write": "tsx scripts/generate-pages-map.ts --write",
"site-map": "tsx scripts/generate-site-map.ts",
"site-map:write": "tsx scripts/generate-site-map.ts --write",
```

**9 npm script entries to remove**

---

## Section D: Old Page Metadata (100 files in 59 directories)

**Location:** `peerloop-docs/docs/pages/`
**Action:** Archive to `peerloop-docs/docs/archive/pages/`

These are per-page metadata files using old 4-letter page codes (ABOU, ACAT, ACRS, etc.), each with a markdown file and optional screenshots. This metadata has been superseded by:
- `ROUTE-STORIES.md` (story mapping)
- `docs/pagespecs/` (design specs)
- `docs/tech/tech-021-url-routing.md` (routes)

**Directories (59):**
```
ABOU  ACAT  ACRS  ACRT  ADMN  AENR  APAY  ASES  ASTC  AUSR
BLOG  BTAT  CANA  CARE  CBRO  CCNT  CDET  CDIS  CDSH  CEAR
CMST  CNEW  CONT  CPRO  CRLS  CSES  CSUC  FAQP  FCRE  FEED
HELP  HOME  HOWI  IFED  LEAD  LGIN  MINV  MODQ  MSGS  NOTF
PRIC  PRIV  PROF  PWRS  SBOK  SDSH  SETT  SGUP  SPAY  SROM
STDR  STOR  STPR  STUD  SUBCOM TDSH  TERM  TSTM  WELC
```

**Total: 100 files (59 .md files + 41 .png screenshots)**

---

## Section E: Layout Import Cleanup (2 files)

**Location:** `Peerloop/src/layouts/`
**Action:** Remove SpecPanelToggle import and usage (not delete the layouts)

| File | Line | Change |
|------|------|--------|
| `LandingLayout.astro` | 18 | Remove `import SpecPanelToggle` |
| `LandingLayout.astro` | 72 | Remove `{pageCode && <SpecPanelToggle ...>}` |
| `LegacyAppLayout.astro` | 18 | Remove `import SpecPanelToggle` |
| `LegacyAppLayout.astro` | 137 | Remove `{pageCode && <SpecPanelToggle ...>}` |

---

## Summary

| Section | Action | Files | Lines of Code |
|---------|--------|-------|---------------|
| A: JSON Page Specs | Archive | 72 | — (data) |
| B: PageSpec Components | Delete | 5 | ~500 |
| C: Dead Scripts | Delete | 9 + 61 dir | ~2,357 |
| D: Old Page Metadata | Archive | 100 | — (docs) |
| E: Layout Cleanup | Edit (2 files) | 2 | 4 lines removed |
| npm scripts | Edit package.json | 1 | 9 entries removed |
| **Total** | | **249 files** | **~2,857 lines** |

---

## Scripts NOT Marked (Still Live)

These scripts in `Peerloop/scripts/` are **not** part of the PageSpec system and remain live:

| Script | Purpose |
|--------|---------|
| `check-env.sh` | Environment validation |
| `check-tailwind-v4.sh` | Tailwind v4 check |
| `confirm-prod.js` | Production deploy guard |
| `generate-mock-data-diagram.ts` | Mock data visualization |
| `link-docs.sh` | Symlink docs/research |
| `reset-d1.js` | D1 database reset |
| `reset-test-db.ts` | Test database reset |
| `run-feed-isolation-test.js` | Feed isolation testing |
| `test-feed-isolation.sh` | Feed isolation testing |
| `audit-api-coverage.mjs` | API coverage auditing |
| `audit-test-sufficiency.mjs` | Test sufficiency auditing |
| `reconcile-planned-apis.mjs` | API reconciliation |

**Note:** `audit-api-coverage.mjs`, `audit-test-sufficiency.mjs`, and `reconcile-planned-apis.mjs` reference page specs internally but serve broader purposes. They may need updating after deletion but are not dead themselves.

---

## Execution Order (When Approved)

1. Archive JSON specs (Section A) → `docs/archive/json-page-specs/`
2. Archive page metadata (Section D) → `docs/archive/pages/`
3. Remove layout imports (Section E)
4. Delete PageSpec components (Section B)
5. Delete dead scripts + page-tests/ (Section C)
6. Remove npm script entries from package.json
7. Run `npx tsc --noEmit` to verify no broken imports
8. Commit

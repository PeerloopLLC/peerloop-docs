# CURRENT-BLOCK-PLAN.md

## Active Block: STORY-REMAP

**Goal:** Realign all 402 user stories to current routes, produce gap analysis, mark dead artifacts for deletion.

**Started:** Session 306 (2026-02-27)
**Completed:** Session 308 (2026-02-27) — All phases done, deletion executed, stale references cleaned, block archived to COMPLETED_PLAN.md

---

### Deliverables

| # | Deliverable | Status |
|---|-------------|--------|
| 1 | `CURRENT-BLOCK-PLAN.md` (this file) | Done |
| 2 | `docs/reference/OLD-CODE-TO-NEW-ROUTE.md` — Translation table | Done |
| 3 | `ROUTE-STORIES.md` — Canonical route→story mapping (402 stories) | Done |
| 4 | `docs/reference/STORY-GAP-ANALYSIS.md` — Gap report | Done |
| 5 | `docs/reference/MARKED-FOR-DELETION.md` — Deletion manifest (249 files) | Done |
| 6 | Cross-reference updates (CLAUDE.md, PLAN.md, etc.) | Done |
| 7 | Verification pass | Done |

---

### Session Log

| Session | Phases | Work Done |
|---------|--------|-----------|
| 306 | 0, 1, 2, 3 | Translation table, full story mapping (402 stories → routes), gap analysis |
| 307 | 4, 5, 6 | MARKED-FOR-DELETION manifest, cross-references, verification |

---

### What's Done (Phases 0-3)

**Phase 0:** Created this file.

**Phase 1:** `docs/reference/OLD-CODE-TO-NEW-ROUTE.md`
- 59 old page codes mapped to current routes
- 23 new routes identified with no old page code
- 6 on-hold pages documented

**Phase 2:** `ROUTE-STORIES.md` (root)
- All 402 unique story IDs mapped (verified by automated diff against USER-STORIES-MAP.md)
- 298 mapped to specific routes across 8 categories
- 72 cross-cutting (infrastructure, notifications, payments, etc.)
- 30 on-hold (goodwill: 23, chat: 2, sub-communities: 2, feed promotion: 2, newsletters: 1)
- 2 gap stories (1 needs /changelog route, 1 creator pricing)
- Zero duplicates (verified by script)

**Phase 3:** `docs/reference/STORY-GAP-ANALYSIS.md`
- No P0 or P1 stories are unserved
- Goodwill system is the biggest deferred cluster (23 stories)
- Route coverage matrix showing high-density and zero-story routes
- All zero-story routes are justified (marketing/legal pages, hubs, redirects)

### What's Done (Phases 4-6)

**Phase 4:** `docs/reference/MARKED-FOR-DELETION.md`
- Section A: 72 JSON page specs → archive
- Section B: 5 dead PageSpec components → delete
- Section C: 9 dead scripts + 61-file page-tests directory → delete
- Section D: 100 old page metadata files → archive
- Section E: 2 layout import cleanups
- 9 npm script entries to remove
- **Total: 249 files, ~2,857 lines of code**

**Phase 5:** Cross-reference updates
- CLAUDE.md: Added ROUTE-STORIES.md to Research Reference, marked JSON specs deprecated
- USER-STORIES-MAP.md: Fixed count 391→402, added cross-reference
- research/run-001/SCOPE.md: Added deprecation note
- research/run-001/pages/PAGES-INDEX.md: Added deprecation note
- PLAN.md: Updated STORY-REMAP status and checkboxes

**Phase 6:** Verification
- ✅ All 402 story IDs in ROUTE-STORIES.md (verified Phase 2)
- ✅ Route completeness: 76 routes match between tech-021 and ROUTE-STORIES.md
  - 2 tech-021 routes not in ROUTE-STORIES: `/@me` (redirect), `/community/[slug]?tag=help` (query variant)
  - 3 ROUTE-STORIES extras: `/teaching/availability`, `/creating/earnings`, `/invite/mod/[token]` (added after tech-021 update)
- ✅ `tsc --noEmit` passes cleanly
- ✅ Stale `src/data/pages/` references cataloged — mostly in session logs (historical, don't modify) and `docs/pages/` (already in MARKED-FOR-DELETION). Live docs needing post-deletion cleanup: BEST-PRACTICES.md, DECISIONS.md, PLAYBOOK.md, 3 slash commands, SITE-MAP.md, CLI references, SCRIPTS.md

---

### Key Numbers

- **Total stories:** 402 (USER-STORIES-MAP header fixed from 391 to 402)
- **Old page codes:** 73 (67 active + 6 on-hold)
- **Current routes:** ~78 (from tech-021-url-routing.md)
- **Mapped to routes:** 298
- **Cross-cutting:** 72
- **On-hold (deferred):** 30
- **Gap (new route needed):** 2
- **All P0/P1 stories covered:** Yes — 0 MVP gaps
- **Files marked for deletion/archival:** 249

### Follow-Up Work (Post-Deletion)

When the MARKED-FOR-DELETION manifest is executed, these live docs will need stale reference cleanup:

| File | Stale References |
|------|------------------|
| `BEST-PRACTICES.md` | JSON spec guidance (lines 75, 78, 601, 634, 655) |
| `DECISIONS.md` | JSON spec pattern reference (line 1385) |
| `PLAYBOOK.md` | Page spec path (line 148) |
| `.claude/commands/L-page-links.md` | JSON spec path examples |
| `.claude/commands/L-convert-page.md` | JSON spec path pattern |
| `.claude/commands/L-verify-page.md` | JSON spec path example |
| `SITE-MAP.md` | Header auto-generated reference |
| `docs/reference/CLI-QUICKREF.md` | validate-page-spec example |
| `docs/reference/CLI-REFERENCE.md` | validate-page-spec examples |
| `docs/reference/SCRIPTS.md` | Multiple script/path references |
| `docs/pagespecs/MISSING-SPECS.md` | JSON file creation references |

### Key Discovery

USER-STORIES-MAP.md said "Total Stories: 391" in its header but the actual count is **402** unique story IDs. The discrepancy: T030-T038 (9 stories) and P101-P108 (8 stories) were added after the header was written. **Fixed** in Session 307.

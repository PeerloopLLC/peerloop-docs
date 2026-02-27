# CURRENT-BLOCK-PLAN.md

## Active Block: STORY-REMAP

**Goal:** Realign all 402 user stories to current routes, produce gap analysis, mark dead artifacts for deletion.

**Started:** Session 306 (2026-02-27)

---

### Deliverables

| # | Deliverable | Status |
|---|-------------|--------|
| 1 | `CURRENT-BLOCK-PLAN.md` (this file) | Done |
| 2 | `docs/reference/OLD-CODE-TO-NEW-ROUTE.md` — Translation table | Done |
| 3 | `ROUTE-STORIES.md` — Canonical route→story mapping (402 stories) | Done |
| 4 | `docs/reference/STORY-GAP-ANALYSIS.md` — Gap report | Done |
| 5 | Code repo cleanup (MARKED-FOR-DELETION manifests) | Pending |
| 6 | Cross-reference updates (CLAUDE.md, PLAN.md, etc.) | Pending |
| 7 | Verification pass | Pending |

---

### Session Log

| Session | Phases | Work Done |
|---------|--------|-----------|
| 306 | 0, 1, 2, 3 | Translation table, full story mapping (402 stories → routes), gap analysis |
| 307+ | 4, 5, 6 | Code cleanup, cross-references, verification |

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

### What's Next (Phases 4-6)

**Phase 4: Code Repo Cleanup** — Create MARKED-FOR-DELETION manifests (NO actual deletion):
- 4a: Archive JSON page specs (`Peerloop/src/data/pages/` → `peerloop-docs/docs/archive/json-page-specs/`)
- 4b: Mark dead PageSpec components (PageSpecView.astro, SpecPanelToggle.tsx, page-spec.ts, etc.)
- 4c: Mark dead scripts (generate-all-pages.ts, generate-pages-map.ts, etc.)
- 4d: Archive old page metadata (`docs/pages/` → `docs/archive/pages/`)
- See the full plan in the original plan document for exact file lists

**Phase 5: Cross-Reference Updates:**
- CLAUDE.md: Add ROUTE-STORIES.md to Research Reference; update Project Structure
- PLAN.md: Mark STORY-REMAP block as completed
- research/run-001/SCOPE.md: Add deprecation note → ROUTE-STORIES.md
- research/run-001/pages/PAGES-INDEX.md: Add deprecation note → ROUTE-STORIES.md
- USER-STORIES-MAP.md: Add cross-reference to ROUTE-STORIES.md

**Phase 6: Verification:**
- All 402 story IDs appear in ROUTE-STORIES.md ✅ (already verified)
- Every route from tech-021 appears in ROUTE-STORIES.md (need to verify)
- Grep docs repo for stale `src/data/pages/` and `docs/pages/` paths
- Verify MARKED-FOR-DELETION manifests list every candidate
- `cd ../Peerloop && npx tsc --noEmit` baseline check
- Present deletion manifests for user review

---

### Key Numbers

- **Total stories:** 402 (USER-STORIES-MAP header says 391 but actual ID count is 402)
- **Old page codes:** 73 (67 active + 6 on-hold)
- **Current routes:** ~75 (from tech-021-url-routing.md)
- **Mapped to routes:** 298
- **Cross-cutting:** 72
- **On-hold (deferred):** 30
- **Gap (new route needed):** 2
- **All P0/P1 stories covered:** Yes — 0 MVP gaps

### Key Discovery

USER-STORIES-MAP.md says "Total Stories: 391" in its header but the actual count is **402** unique story IDs. The discrepancy: T030-T038 (9 stories) and P101-P108 (8 stories) were added after the header was written. The header should be updated to 402.

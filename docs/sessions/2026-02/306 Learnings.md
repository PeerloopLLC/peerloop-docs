# Session Learnings - 2026-02-27

## 1. Story IDs Drift Between Source Documents
**Topics:** docs-infra, workflow

**Context:** SCOPE.md (run-001) and USER-STORIES-MAP.md both assign story IDs like US-S029, but the descriptions for the same ID differ between the two files. SCOPE.md was created earlier and uses a different numbering than USER-STORIES-MAP.md.

**Learning:** When multiple documents assign the same ID format, always verify by description, not just ID. The canonical source for Peerloop user stories is USER-STORIES-MAP.md (which draws from research/stories/*.md). SCOPE.md story assignments are stale and should not be trusted for ID→description mapping.

**Pattern:** When building a mapping from old-to-new, use the canonical source for IDs/descriptions and the old source only for structural hints (which page code a story was grouped under).

---

## 2. USER-STORIES-MAP.md Header Count Is Stale
**Topics:** docs-infra

**Context:** USER-STORIES-MAP.md header says "Total Stories: 391" with role counts T=35 and P=100. But the actual IDs go T001-T038 (38 stories) and P001-P108 (108 stories), giving a true total of 402 unique story IDs.

**Learning:** The header summary table was written before T030-T038 and P101-P108 were added. The per-role counts (18+95+35+57+60+6+9+11+100=391) don't match the actual content (18+95+38+57+60+6+9+11+108=402). Always verify counts by scanning actual content rather than trusting headers.

---

## 3. Automated Verification Catches Mapping Errors
**Topics:** workflow, docs-infra

**Context:** After writing the 400+ story mapping document, I used `grep -oE` + `sort -u` + `diff` to compare story IDs between USER-STORIES-MAP.md and ROUTE-STORIES.md. This immediately caught 1 missing story (US-C007) and 4 duplicates (US-G018, US-P069, US-E002, US-E003).

**Learning:** For any large mapping/translation exercise, build automated verification early. A simple `diff <(grep source | sort -u) <(grep target | sort -u)` is invaluable for completeness checking. Also use `Counter` from Python's collections to find within-file duplicates.

---

## 4. Old Page System Had Clean Separation, New Routes Have Richer Overlap
**Topics:** docs-infra

**Context:** The old ORIG-PAGES-MAP had 73 page codes with roughly 1:1 mapping to routes. The new routing architecture has ~75 routes but stories are more spread across routes — a single feature like "feed interactions" (S036-S041) applies to 3+ routes (/community/[slug], /course/[slug]/feed, /feed).

**Learning:** The Twitter-like UI pivot increased route overlap. Stories that were once isolated to a single page now span multiple feed contexts. When mapping stories to routes, assign to the PRIMARY route and use "also:" notes rather than duplicating entries.

---

## 5. Zero P0/P1 Stories Are Unserved
**Topics:** docs-infra

**Context:** The gap analysis found that all 31 unserved stories are P2 or P3. Every P0 (184) and P1 (125) story has a home in the current route architecture.

**Learning:** The Twitter-like UI pivot was comprehensive — it didn't just reshuffle routes, it actually improved coverage. The biggest deferred cluster is the goodwill points system (23 stories, all P2), which is correctly scoped as a Block 2+ feature. The route architecture is MVP-complete.

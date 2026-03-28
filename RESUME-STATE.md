# State — Conv 047 (2026-03-28 ~15:05)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-8`, docs: `main`

## Summary

Conv 047 fixed two route-matrix scanner bugs (ternary link extraction via balanced brace parser, param name resolution via structural route matching), fixed a real bug in MergedPeople.tsx (teacher.id → teacher.handle), and renamed `src/components/explore/` → `src/components/discover/` for route namespace consistency.

## Completed

- [x] Route-matrix: balanced expression extractor for ternary/conditional href links
- [x] Route-matrix: structural param resolver for dynamic route matching
- [x] MergedPeople.tsx: fix teacher.id → teacher.handle for profile links
- [x] Rename src/components/explore → src/components/discover (37 files + 8 tests)
- [x] Update all imports (12 pages, 19 tests, 5 docs)
- [x] Regenerate route-matrix output (page-connections.md, TSVs)

## Remaining

### User Action Items
- [ ] Email Blindside Networks: webcam policy (instructor-only) + analytics callback JWT confirmation (draft ready from Conv 038)
- [ ] Verify staging webhook setup end-to-end (after Blindside email response + deploy)

### Client Decisions
- [ ] Confirm with client: remove /courses, /feeds, /communities (MyXXX pages) — now enclosed in /discover routes

## TodoWrite Items

- [ ] #1: Email Blindside Networks: webcam policy + analytics JWT confirmation
- [ ] #2: Verify staging webhook setup end-to-end
- [ ] #3: Confirm with client: remove /courses, /feeds, /communities (MyXXX pages)

## Key Context

- Route-matrix scanner now handles ternary expressions and resolves param names structurally — broken targets down to 1 (genuinely missing /course/[slug]/certificate from CERT-APPROVAL block)
- MergedPeople.tsx teacher link uses handle with fallback to id — the fallback still produces broken URLs if handle is null
- components/explore → components/discover rename complete; session logs intentionally left with old paths (historical)
- 350 test files, 6182 tests, all passing

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.

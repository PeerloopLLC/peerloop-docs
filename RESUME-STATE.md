# State — Conv 074 (2026-04-02 ~10:10)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-9`, docs: `main`

## Summary

Conv 074 fixed 3 STUMBLE bugs (dashboard stats 0%, courses disappear, cert UI hidden), built the Route↔API Map infrastructure (scanner script, TypeScript lookup, Markdown reference, docs agent integration), and replaced WalkthroughCheckpoint with the new BrowserIntent type system (structured navigation + prose page actions). Deleted the diagnostic flywheel-to-enrollment instance.

## Completed

- [x] Fix: Dashboard stats 0 modules/0% after webhook completion (module_progress sync in booking.ts)
- [x] Fix: "Your Courses" disappears after completion (added Completed section in MergedCourses.tsx)
- [x] Fix: Cert UI discoverability (Teachers button on CreatorCourseCard + deep-link + tab param in CourseEditor)
- [x] Route↔API Map scanner script + TypeScript lookup + Markdown reference + npm script + docs agent integration
- [x] BrowserIntent + NavClick types in types.ts, navigation-helper.ts created
- [x] flywheel.instance.ts rewritten with 14 BrowserIntents
- [x] new-user-pair.instance.ts rewritten with 8 BrowserIntents
- [x] flywheel-to-enrollment diagnostic instance deleted
- [x] PLATO step verify blocks updated for module_progress
- [x] PLATO step comments updated for new Teachers tab URL

## Remaining

### Carried Forward
- [ ] Security: BBB webhook endpoint has no signature validation
- [ ] Client decision: remove MyXXX pages (/courses, /feeds, /communities)
- [ ] Broken route: /course/[slug]/certificate — page doesn't exist (CERT-APPROVAL block)

### Next Work
- [ ] Backfill BrowserIntent walkthroughs for `ecosystem` and `activities` scenarios

## TodoWrite Items

- [ ] #4: Security: BBB webhook endpoint has no signature validation
- [ ] #5: Client decision: remove MyXXX pages (/courses, /feeds, /communities)
- [ ] #6: Broken route: /course/[slug]/certificate — page doesn't exist

## Key Context

- **Route↔API Map**: `npm run route-api-map` regenerates both `tests/plato/route-map.generated.ts` and `docs/as-designed/route-api-map.md`. 96 pages, 195 API endpoints, 89 reachable routes. Docs agent auto-triggers on API/component changes.
- **BrowserIntent type**: Replaces WalkthroughCheckpoint. Structured `navigate: { via, clicks: NavClick[] }` for deterministic navigation (fail-fast). Prose `pageAction` for on-page instructions. `coversStepActions` links to API-run.
- **Navigation rules (a/b)**: (a) If target route has link on current page → `via: 'same-page'`. (b) If not → start from AppNavbar. Helper: `suggestNavigation()` in `tests/plato/lib/navigation-helper.ts`.
- **Diagnostic instances are ephemeral**: `flywheel-to-enrollment` deleted (Conv 073 bugs fixed). Scenario file kept for reference.
- **ecosystem + activities scenarios**: Need BrowserIntent walkthroughs — deferred to next conv.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.

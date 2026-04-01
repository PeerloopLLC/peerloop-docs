# State — Conv 069 (2026-04-01 ~11:49)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-9`, docs: `main`

## Summary

Conv 069 built the PLATO Instance System (4th PLATO concept), created the complete-onboarding step (20th step), and paired PLATO instances with STUMBLE-AUDIT browser walkthroughs. Login flow walkthrough found and fixed 3 bugs. New-user-pair walkthrough found and fixed an onboarding page crash (API/component field mismatch), plus discovered a systemic page title double-suffix issue across ~70 pages.

## Completed

- [x] Chrome extension working with Claude Code CLI
- [x] Login flow STUMBLE-AUDIT walkthrough — 3 bugs found and fixed (modal over reset-password, stale error, double titles)
- [x] PLATO Instance System — types, runner, reporter (PlatoInstance, PlatoInstanceFile, when guards, executeInstanceFile)
- [x] complete-onboarding PLATO step (20th step)
- [x] new-user-pair instance file with walkthrough checkpoints (Alice skips onboarding, Bob completes it)
- [x] All 6 PLATO tests passing (4 existing + loader + new instance)
- [x] STUMBLE walkthrough of new-user-pair — 8 checkpoints, crash fixed
- [x] Onboarding page crash fix (API returns `tags`, component expected `topicInterests`)
- [x] Page title double-suffix fixes for login, signup, reset-password, onboarding pages

## Remaining

### High Priority — Fix in Next Conv
- [ ] Onboarding tag selections not restored on revisit — TopicPicker shows unchecked despite saved user_tags (Task #17, confusion severity)
- [ ] Systemic double "| Peerloop" in page titles — ~70 pages use "| PeerLoop" but BaseHead appends "| Peerloop" (Task #16, cosmetic but affects every page)

### Needs Browser Testing
- [ ] Verify username change works in settings/profile UI (Task #1)
- [ ] Email pre-fill not tested — verify ModeratorInvite /signup?email=... path (Task #2)

### Needs Client Input
- [ ] Client decision: remove MyXXX pages (/courses, /feeds, /communities) (Task #3)
- [ ] Home page: differentiate new member view from established member (Task #4)

### Monitoring
- [ ] Monitor maybeUpdateActorSession design flaw (Convs 063-065) (Task #5)

### Documentation
- [ ] Broken route: /course/[slug]/certificate — page doesn't exist (Task #7)
- [ ] Hyphenated handles in API doc examples conflict with new validation rules (Task #8)
- [ ] Docs agent detection scripts failed (Bash permission denied) — verify script permissions (Task #18)
- [ ] TopicPicker experienceLevel field has no DB backing — schema gap if feature needed (Task #19)

## TodoWrite Items

- [ ] #16: Systemic double "| Peerloop" in page titles — 70+ pages need "| PeerLoop" removed
- [ ] #17: Onboarding tag selections not restored on revisit — TopicPicker issue
- [ ] #7: Broken route: /course/[slug]/certificate — page doesn't exist
- [ ] #1: Verify username change works in settings/profile UI
- [ ] #2: Email pre-fill not tested — verify ModeratorInvite /signup?email=... path
- [ ] #3: Client decision: remove MyXXX pages (/courses, /feeds, /communities)
- [ ] #8: Hyphenated handles in API doc examples conflict with new validation rules
- [ ] #4: Home page: differentiate new member view from established member
- [ ] #5: Monitor maybeUpdateActorSession design flaw (Convs 063-065)
- [ ] #18: Docs agent detection scripts failed — verify script permissions
- [ ] #19: TopicPicker experienceLevel field has no DB backing

## Key Context

- **PLATO Instance System:** Fully operational. Types in `tests/plato/lib/types.ts`, runner in `api-runner.ts`. Instance files in `tests/plato/instances/`. `when` guard on StepRef gates conditional steps. `executeInstanceFile()` runs multiple instances against same DB (accumulation).
- **STUMBLE-AUDIT pairing:** Instance files include `walkthrough` field with WalkthroughCheckpoint[] for browser test scripts. Execution uses accumulate-with-checkpoints model.
- **Onboarding API/component mismatch:** Fixed the crash (API returns `tags`, component now reads `tags`), but TopicPicker doesn't pre-check saved selections — needs investigation into how TopicPicker consumes the `selections` prop vs tag IDs.
- **Page title pattern:** BaseHead.astro:30 appends `| Peerloop`. Pages must NOT include `| Peerloop` or `| PeerLoop` in their title prop. ~70 pages need this stripped — bulk rename task.
- **Chrome extension setup:** Requires Chrome (not Brave), localhost-only restriction, restart both Chrome and Claude Code terminal.
- **Dev server:** Runs on port 4321 (Astro default when ports are clear).

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.

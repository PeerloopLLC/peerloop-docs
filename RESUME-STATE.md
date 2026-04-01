# State — Conv 070 (2026-04-01 ~12:24)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-9`, docs: `main`

## Summary

Conv 070 fixed two high-priority STUMBLE-AUDIT bugs: onboarding tag selections not saving (field name mismatch `topicInterests` → `tagIds`) and systemic double page title suffix across 77 pages. All fixes were browser-verified end-to-end with Chrome automation. Also verified email pre-fill on signup and username/handle change in profile settings — both working correctly.

## Completed

- [x] Fix onboarding tag selections not saving (field name mismatch: `topicInterests` → `tagIds`)
- [x] Fix systemic double "| Peerloop" in page titles (77 pages + 10 template literal cleanups)
- [x] Browser-verify onboarding tag save & restore round-trip
- [x] Browser-verify page title single-suffix across multiple page types
- [x] Browser-verify email pre-fill on /signup?email=... path
- [x] Browser-verify username/handle change in settings/profile

## Remaining

### Needs Client Input
- [ ] Client decision: remove MyXXX pages (/courses, /feeds, /communities)
- [ ] Home page: differentiate new member view from established member

### Documentation
- [ ] Broken route: /course/[slug]/certificate — page doesn't exist
- [ ] Hyphenated handles in API doc examples conflict with new validation rules
- [ ] Docs agent detection scripts failed — verify script permissions

### Schema / Design
- [ ] TopicPicker experienceLevel field has no DB backing — schema gap if feature needed

### Monitoring
- [ ] Monitor maybeUpdateActorSession design flaw (Convs 063-065)

## TodoWrite Items

- [ ] #5: Client decision: remove MyXXX pages (/courses, /feeds, /communities)
- [ ] #6: Home page: differentiate new member view from established member
- [ ] #7: Monitor maybeUpdateActorSession design flaw (Convs 063-065)
- [ ] #8: Broken route: /course/[slug]/certificate — page doesn't exist
- [ ] #9: Hyphenated handles in API doc examples conflict with new validation rules
- [ ] #10: Docs agent detection scripts failed — verify script permissions
- [ ] #11: TopicPicker experienceLevel field has no DB backing

## Key Context

- **Onboarding fix:** `OnboardingProfile.tsx:194` — changed `topicInterests: formData.topicInterests` to `tagIds: formData.topicInterests.map((t) => t.tagId)`. The API (`/api/me/onboarding-profile`) expects `tagIds` as string[].
- **Page title pattern:** `BaseHead.astro:30` is the single source of truth for `| Peerloop` suffix. Pages must NOT include it in their title prop.
- **Email pre-fill:** Already working — `SignupForm.tsx:29-31` reads `email` from `window.location.search`. ModeratorInvite passes it via URL param.
- **STUMBLE-AUDIT status:** Continues from Conv 067+. Login flow, new-user-pair, onboarding, settings all walked through. Next up: booking wizard, video sessions, two-browser tests per PLAN.md checklist.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.

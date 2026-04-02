# State — Conv 071 (2026-04-01 ~20:14)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-9`, docs: `main`

## Summary

Conv 071 established PLATO/STUMBLE workflow terminology, created the flywheel instance (14 walkthrough checkpoints), and STUMBLE-walked both new-user-pair (8/8 checkpoints) and flywheel (10/14 checkpoints, including a real Stripe test payment). Also added `user_tags.level` column for topic-level proficiency in onboarding, fixed hyphenated handles in 8 doc files, and designed composable STUMBLE segments architecture.

## Completed

- [x] PLATO/STUMBLE terminology documented in plato.md + memory
- [x] TodoWrite task triage — dropped 3, fixed 1 (#4 handles), kept 3
- [x] Fixed `guy-rymberg` → `guy_rymberg` in 8 active doc files
- [x] Added `user_tags.level` column (beginner/intermediate/advanced)
- [x] Updated TopicPicker, onboarding API, OnboardingProfile, InterestsSettings for level
- [x] All tests passing (38 onboarding + 7 PLATO)
- [x] Created flywheel.instance.ts with 14 WalkthroughCheckpoints
- [x] STUMBLE: new-user-pair — all 8 checkpoints passed
- [x] STUMBLE: flywheel — checkpoints 1-10 passed (real Stripe payment)
- [x] Composable STUMBLE segments design added to PLAN.md + plato.md
- [x] Added LEVEL-MATCH deferred block (#40) to PLAN.md

## Remaining

### STUMBLE Issues Found
- [ ] Publish button: no feedback when checklist incomplete
- [ ] Publishing checklist: "Topic selected" shows unchecked despite topic being set
- [ ] Course enrollment card: "live sessions ()" empty parens + blank 3rd checkmark
- [ ] Self-healing enrollment: assigned_teacher_id null + student_count not incremented

### Carried Forward
- [ ] Client decision: remove MyXXX pages (/courses, /feeds, /communities)
- [ ] Broken route: /course/[slug]/certificate — page doesn't exist (CERT-APPROVAL block)

### Future Work
- [ ] Refactor flywheel scenario into chainable composable segments
- [ ] Create post-enrollment instance (seeds enrollment + availability)
- [ ] Flywheel STUMBLE checkpoints 11-14 (blocked by DEV-WEBHOOKS)

## TodoWrite Items

- [ ] #1: Client decision: remove MyXXX pages (/courses, /feeds, /communities)
- [ ] #3: Broken route: /course/[slug]/certificate — page doesn't exist
- [ ] #11: Publish button: no feedback when checklist incomplete
- [ ] #12: Publishing checklist: "Topic selected" shows unchecked despite topic being set
- [ ] #13: Course enrollment card: "live sessions ()" empty parens + blank 3rd checkmark
- [ ] #14: Self-healing enrollment: assigned_teacher_id null + student_count not incremented

## Key Context

- **Local D1 has real data:** Mara Chen (creator, course published, community created) + Alex Rivera (student, enrolled via real Stripe payment). `/r-start` does NOT reset D1 — data persists until explicit `npm run db:setup:local`.
- **Flywheel STUMBLE boundary:** Checkpoints 1-10 browser-walkable, 11-14 need DEV-WEBHOOKS (BBB video provider).
- **Self-healing verified:** Enrollment created without webhook forwarding, but `assigned_teacher_id` null and `student_count` not incremented (webhook side effects skipped).
- **Composable segments:** Design direction agreed — small chainable scenarios (2-3 steps), failure isolation, service boundary alignment. TODO in PLAN.md.
- **Level feature:** `user_tags.level` persisted, UI shows "Your {topicName} level:" dropdown. Smart Feed not yet wired (deferred LEVEL-MATCH block #40).

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.

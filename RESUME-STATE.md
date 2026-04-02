# State — Conv 076 (2026-04-02 ~14:52)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-9`, docs: `main`

## Summary

Conv 076 completed the STUMBLE-AUDIT onboarding walkthrough (5 browser walks), discovered and fixed 5 onboarding UX bugs, redesigned the goal selector from radio-style enum to independent checkbox booleans (schema change: `primary_goal` → `goal_learn`/`goal_teach`), and polished the onboarding UI (TopicPicker level dropdown, side-by-side About fields, nudge banner on homepage/dashboard, "Skip for now" link).

## Completed

- [x] STUMBLE-AUDIT.WALKTHROUGH: Onboarding flow (5 walks — signup, skip, edge cases, TopicPicker, settings)
- [x] Fix: Nudge banner links /settings/interests → /onboarding (dead-end loop)
- [x] Fix: "N topics selected" → "N tags selected" labeling
- [x] Fix: Add nudge banner to homepage (compact) and /dashboard (full)
- [x] Fix: "Skip for now" link for first-time users
- [x] Fix: Settings/Interests change detection + grey disabled button
- [x] Schema: primary_goal TEXT → goal_learn/goal_teach INTEGER booleans
- [x] UI: Goal selector as independent checkboxes, drop "Both"
- [x] UI: Level dropdown fixed width (120px), About You side-by-side, nudge spacing

## Remaining

### Carried Forward
- [ ] Client decision: remove MyXXX pages (/courses, /feeds, /communities)
- [ ] Broken route: /course/[slug]/certificate — page doesn't exist (CERT-APPROVAL block)

### Docs Drift
- [ ] TEST-COVERAGE.md: E2E section header says "25 files" but actual count is 30 (pre-existing)

## TodoWrite Items

- [ ] #1: Client decision: remove MyXXX pages (/courses, /feeds, /communities)
- [ ] #2: Broken route: /course/[slug]/certificate — page doesn't exist (CERT-APPROVAL block)
- [ ] #3: TEST-COVERAGE.md: E2E section header says "25 files" but actual count is 30

## Key Context

- **Schema change**: `member_profiles.primary_goal` replaced with `goal_learn INTEGER` + `goal_teach INTEGER`. API uses `goalLearn`/`goalTeach` booleans. "Both" option removed from UI — selecting both checkboxes is implicit.
- **Nudge banner**: Now on homepage (compact) + /dashboard (full) + discover pages. Links to /onboarding (not /settings/interests). Dismiss is per-context via localStorage.
- **STUMBLE-AUDIT.WALKTHROUGH remaining**: Course creation, Enrollment+payment, Booking+session, Certification, Community+feed walkthroughs still pending.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.

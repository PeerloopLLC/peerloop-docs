# State — Conv 078 (2026-04-02 ~21:29)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-9`, docs: `main`

## Summary

Conv 078 built PLATO split tooling (`plato:split`, `plato:split-cleanup`) and completed the STUMBLE-AUDIT enrollment+payment browser walkthrough. Discovered and fixed a breadcrumb bug, added a port-check guard to prevent D1 corruption, created the `submit-expectations` PLATO step, and promoted `flywheel-pre-9` as a permanent named scenario.

## Completed

- [x] STUMBLE-AUDIT.WALKTHROUGH: Enrollment + payment walkthrough (7 browser intents verified)
- [x] Built plato:split and plato:split-cleanup CLI tools (npm scripts added)
- [x] Added PLATO_INSTANCE dynamic test runner for split instances
- [x] Added port-check guard to plato-restore-snapshot.js (prevents SQLITE_CORRUPT)
- [x] Fixed breadcrumb "My Courses" for unenrolled students on course detail page
- [x] Created submit-expectations PLATO step (flywheel now 12 steps)
- [x] Promoted flywheel-pre-9 to permanent named scenario
- [x] Updated stumble-workflow.md with split tooling docs
- [x] Improved plato:split-cleanup with --keep/--delete flags for non-interactive use

## Remaining

### Carried Forward
- [ ] Client decision: remove MyXXX pages (/courses, /feeds, /communities)
- [ ] Broken route: /course/[slug]/certificate — page doesn't exist (CERT-APPROVAL block)

### Docs Drift
- [ ] TEST-COVERAGE.md: E2E section header says "25 files" but actual count is 30 (pre-existing)

### New
- [ ] Audit codebase for remaining alert()/confirm() calls in admin components

## TodoWrite Items

- [ ] #1: Client decision: remove MyXXX pages (/courses, /feeds, /communities)
- [ ] #2: Broken route: /course/[slug]/certificate — page doesn't exist (CERT-APPROVAL block)
- [ ] #3: TEST-COVERAGE.md: E2E section header says "25 files" but actual count is 30
- [ ] #4: Audit codebase for remaining alert()/confirm() calls in admin components

## Key Context

- **STUMBLE-AUDIT.WALKTHROUGH remaining**: Booking+session, Certification, Community+feed walkthroughs still pending.
- **Split tooling**: `npm run plato:split -- <instance> --at <step>` → creates Pre/Post files. `npm run plato:split-cleanup -- --keep <name> --delete <name>` for non-interactive cleanup.
- **flywheel-pre-9**: Permanent scenario — steps 1-8, produces "enrollment-ready" DB state (published course, registered student, certified teacher). Use for any walkthrough starting from enrollment onward.
- **form_input vs keyboard**: Chrome MCP `form_input` doesn't trigger React onChange. Use `click` + `type` for React forms; `form_input` works for native `<select>` elements.
- **Self-healing enrollment**: Verified working without Stripe webhook on MacMiniM4. Success page retrieves Stripe session and creates enrollment.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.

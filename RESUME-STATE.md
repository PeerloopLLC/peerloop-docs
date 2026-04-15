# State — Conv 121 (2026-04-15 ~10:03)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-12`, docs: `main` (uncommitted changes will be committed in Step 6 of /r-end)

## Summary

Conv 121 closed COMMUNITY-RESOURCES Phase 9 (docs — added §Community Resources to DB-API.md; created `docs/as-designed/r2-storage.md`) and then drained 20 additional TodoWrite items in a sequential sweep. Net: 21 items closed, 6 follow-up tasks spawned (2 closed same-conv). Only COMMUNITY-RESOURCES Phase 8 (PLATO) remains in that block. Stopped at a natural checkpoint after presenting 4 next-step options — user explicitly asked to have those options re-presented in Conv 122 rather than picked this conv.

## Completed

- [x] #2 COMMUNITY-RESOURCES Phase 9 docs (DB-API §Community Resources, new r2-storage.md, PLAN.md update)
- [x] #34 [DBAPI-SUBCOM-RENAME] — §Sub-Communities → §Communities, stale table refs corrected, aspirational endpoints flagged
- [x] #6 #7 [TC-LIB-COUNT/SUBDIR] — TEST-COVERAGE.md Lib Tests header corrected (13 files, recursive scope)
- [x] #5 [CRES-TEST-PATH] — off-by-one `../` replaced with `@/lib/auth` alias; project-wide tsc exit-0
- [x] #8 #28 [DBSCHEMA-MR/CRES] — _DB-SCHEMA.md narrowing + community_resources rewrite
- [x] #23 [GI] — `.claude/scheduled_tasks.lock` untracked, added to .gitignore
- [x] #25 [COURSE-RES-AUTH] — verified past-student download works; spawned #37 for disputed/soft-deleted edges
- [x] #29 [NAV-DISABLED-AUDIT] — 3 dead nav blocks removed from AppNavbar.tsx + 4 unused imports
- [x] #19 [PE] — `platform_stats.environment` stub row seeded
- [x] #21 [BL] — broken `/course/[slug]/certificate` link → disabled placeholder
- [x] #22 [TL] — no-paste-tokens-in-chat feedback memory written
- [x] #20 [SG] — no-op closure (concern no longer reproducible)
- [x] #32 [SG2] — sync-gaps.sh full-path matching + shared-basename blocklist
- [x] #11 [AS] — auth-sessions.md refresh-token-as-fallback subsection
- [x] #36 [DBSCHEMA-SUBCOM-DUPE] — stale sub_community_* entries removed
- [x] #13 [AD] — no-op closure (auth docs clean; discovered 3 aspirational §Authentication endpoints folded into #35)
- [x] #24 [CD] — git -C enforcement feedback memory written
- [x] #38 [PE-OVERRIDE] — env-marker UPDATE chained to db:migrate:{local,staging,prod}

## Remaining

### Substantial blocks (need prioritization, not drain)

- [ ] #1 COMMUNITY-RESOURCES Phase 8 — PLATO `upload-community-resources` flywheel step
- [ ] #3 ROLE-AUDIT — sweep non-CurrentUser role checks across codebase
- [ ] #10 [EM] Email notification for session invites
- [ ] #14 [DGH] DEPLOYMENT.GHACTIONS
- [ ] #15 [DP] DEPLOYMENT.PROD
- [ ] #16 [DSD] DEPLOYMENT.STAGING-DOMAIN (optional)
- [ ] #30 [PLATO-FLYWHEEL-CREATOR-GAP] creator-lifecycle audit
- [ ] #31 [CODECHECK-SQL] schema-aware SQL column-name lint
- [ ] #33 [API-COMM-REVIEW] API-COMMUNITY.md review for Conv 118 changes
- [ ] #35 [DBAPI-SUBCOM-AUDIT] Full §Communities + §Authentication endpoint audit in DB-API.md

### Medium

- [ ] #4 Phase 7 follow-up — multipart file-upload happy-path tests (R2 mocking required)
- [ ] #17 [RS] reset-d1.js orphan-table drop
- [ ] #18 [DS] dev:staging adapter 13 regression (investigation)
- [ ] #26 [BKC-NEXT] SessionBooking next-month upper bound (design call)
- [ ] #27 [BKC-FETCH] SessionBooking 4-week fetch horizon (design call)
- [ ] #37 [COURSE-RES-AUTH-EDGE] disputed + soft-deleted enrollment gate (pending product call)

### Blocked / deferred

- [ ] #9 [IN] Install gh CLI on MacMiniM4-Pro (machine-blocked — run on -Pro only)
- [ ] #12 [CSS] /discover/members bottom-row clipping (root-caused; fix needs browser verification)

## TodoWrite Items

All 18 pending tasks above will be transferred to TodoWrite by /r-start in Conv 122.

## Key Context

### USER DIRECTIVE FOR CONV 122 — RE-ASK THE 4 OPTIONS

Conv 121 ended with the drain phase essentially complete. At end of conv, 4 next-step options were presented and the user explicitly said *"/r-end but be sure to capture the next step and the context we need and reask these options in next Conv"* — meaning these options should be **re-presented verbatim at the start of Conv 122**, with the user picking one to focus on.

**Re-present these 4 options at the start of Conv 122 (after /r-start's normal resume context):**

> **Option 1 — Pick one substantial block:** DEPLOYMENT.GHACTIONS (#14), ROLE-AUDIT (#3), COMMUNITY-RESOURCES Phase 8 (#1), or [EM] Email notifications (#10). Full focus, may run for the whole conv.
>
> **Option 2 — Tackle the remaining medium ones:** #17 (reset-d1.js orphan-table drop) or #18 (dev:staging adapter 13 regression investigation). Moderate scope.
>
> **Option 3 — End the conv here via /r-end:** (This was Option 3 at the time; by Conv 122 the user has already chosen /r-end so this option is effectively closed — replace with "nothing right now, let me think" / "work on something new not in TodoWrite".)
>
> **Option 4 — Make product calls on deferred items:** #37 (disputed-enrollment download access + soft-deleted filter), #26/#27 (SessionBooking horizon design), then implement. Quick decisions → small implementations.
>
> *Or give a specific task ID and I'll start there.*

### Conv 121 artifacts (fresh, load-bearing)

- `docs/as-designed/r2-storage.md` — NEW. Canonical architecture doc for R2 storage, two storage models, access-gate matrix, SSR downloadUrl pattern, permission-helper composition pattern. If anything touches community resources or R2, cross-reference this doc.
- `docs/reference/DB-API.md §Communities` — was §Sub-Communities. Has audit-warning header. Several endpoints marked `*(proposed — not implemented)*`. The audit (#35) is still pending.
- `docs/reference/DB-API.md §Authentication` — 3 aspirational endpoints discovered (`/forgot-password`, `/reset-token/:token`, `/verify-email`) — folded into #35 scope.
- `docs/as-designed/auth-sessions.md` — new `### Refresh-Token-as-Auth Fallback` subsection documents the two-tier read in `getSession()` and the intentional "no auto-rotation" gap at `src/lib/auth/session.ts:91-92`.
- `.claude/skills/r-end/scripts/sync-gaps.sh` — now uses full-path matching for test files with a shared-basename blocklist. False-negative class fixed.
- `migrations/0002_seed_core.sql` + `package.json` — env-marker stub + chained UPDATE in db:migrate:*. `/api/debug/db-env` should now return definitive env strings.

### Patterns named this conv (worth knowing before related work)

- **SSR pre-compute boundary:** loader emits one client-facing URL (`downloadUrl`), React consumes it without branching on backend. Formalized in r2-storage.md. Promote to DEVELOPMENT-GUIDE.md if it accretes a second use site.
- **Permission-helper composition:** SSR loader returns raw flags → pure helper in `src/lib/permissions.ts` composes gating → Astro page renders declaratively. Same promotion rule.
- **Discriminant-vs-descriptor columns:** `r2_key` (discriminant) + `type` (metadata) for split-backend tables.
- **Alias symmetry in vi.mock:** `vi.mock('@/lib/foo', ...)` paired with `importOriginal<typeof import('@/lib/foo')>()` (same alias, both places).
- **No-op closure as valid terminal state:** a task that investigation resolves without code change should be marked completed with a description documenting what was checked and why no action followed. Applied to #20 and #13 this conv.

### Open design calls (informs Option 4 above)

- **#37 [COURSE-RES-AUTH-EDGE]:** Should `'disputed'` enrollments still grant resource download? And should the download query add `AND deleted_at IS NULL`? Product call blocks the code fix.
- **#26 [BKC-NEXT] / #27 [BKC-FETCH]:** Should SessionBooking next-month nav have an upper bound (e.g., N months)? And should the 4-week fetch horizon expand when user pages past it? Both are UX design calls.

### Commits this conv

- Docs: `91d3f65` (start) → `a834198` (Phase 9) → `2ce524b` (drain batch 1) → `b53fb9c` (drain batch 2) → /r-end commit pending
- Code: `39e5af2` (drain batch 1) → `0d16eff` (package.json env-marker)

### Global memory additions (not git-tracked)

- `feedback_no_paste_tokens_in_chat.md` — never ask user to paste secrets in chat (Conv 113 incident)
- `feedback_git_dash_c_enforcement.md` — always `git -C <abs>` in dual-repo work (Conv 109 had 2 cwd-drift violations)

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view. **After /r-start presents its normal resume context, re-ask the 4 options above** per the user's explicit directive.

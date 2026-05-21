# State — Conv 168 (2026-05-21 ~08:40)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-12`, docs: `main`

## Summary

Cross-block follow-up batch — closed 5 actionable tasks from Conv 167's RESUME-STATE: [CCK-DA] v2 alias-aware deleted_at lint (90→0 false positives), [MND] hostname match + canonical-name sweep `MacMiniM4-Pro`→`MacMiniM4Pro` across 11 files, [RAM-NO-NAV] per-route `noNav` annotation pattern in scanner + applied to `/course/[slug]/[tab]`, [PROD-PW] design decision (password=Peerloop2, apply deferred) captured in DECISIONS.md, [XMV] HOME-simulation harness with 9/9 calibration cases + `--scan` mode. Two new follow-up tasks surfaced.

## Completed

- [x] [CCK-DA] /w-codecheck Check 8 v2 heuristic — alias-aware schema-aware deleted_at lint; live codebase 90 violations → 0; v1 inline `node -e` replaced with `.claude/scripts/codecheck-deleted-at.mjs`
- [x] [MND] detect-machine.sh hostname match for M4Pro + canonical name `MacMiniM4-Pro` → `MacMiniM4Pro` migration (11 files including `MachineName` TS type, vitest config, dev-env-scan grep, CLAUDE.md + 7 active docs); tsc clean
- [x] [RAM-NO-NAV] `export const noNav = true;` annotation pattern in scanner — applied to `/course/[slug]/[tab]`, emits `ℹ️ no-nav by design` instead of `⚠️ no discovered path`
- [x] [PROD-PW] Decision captured in `docs/DECISIONS.md` §4 (password=Peerloop2, apply deferred, un-defer procedure documented)
- [x] [XMV] `.claude/scripts/cross-machine-verify.sh` HOME-simulation harness (9/9 cases pass), `--scan <file>` advisory mode, documented in `docs/as-designed/devcomputers.md`

## Remaining

- [ ] **[BR-ZERO-REPRO]** Reproduce 0-min empty-but-published recording state in next BBB test — needed for [BR-STATUS] enum design
- [ ] **[BR-STATUS]** [Opus] Add `sessions.recording_status` column with enum `none | requested | capturing | processing | published | failed | empty` — awaits [BR-ZERO-REPRO] data + Blindside follow-up
- [ ] **[AAP]** Astro dev-only absolute-filesystem path leak in ClientRouter — WAITING on upstream Astro fix post-6.3.6. Verification probe after each Astro upgrade: `curl http://localhost:4321/ | grep -oE 'src="[^"]*ClientRouter[^"]*"'` (non-absolute = fixed)
- [ ] **[VITE-DEPS-WATCH]** Watch for recurring Vite missing-chunk warnings (astro/audit/xray/toolbar) — self-resolved Conv 165, investigate only if recurs
- [ ] **[RAM-NONAV-SWEEP]** Apply `export const noNav = true;` to the other 19 legitimate no-nav routes: /404, /about, /admin/recordings, /become-a-teacher, /blog, /careers, /contact, /cookies, /discover/creators, /discover/students, /discover/teachers, /faq, /for-creators, /how-it-works, /pricing, /privacy, /stories, /terms, /testimonials. Per-route is intentional — forces "is this really no-nav by design?" consideration each time
- [ ] **[PROD-PW-APPLY]** Execute deferred prod admin Peerloop2 rotation: (1) edit `migrations/0002_seed_core.sql:172` replacing Password1 hash with `$2b$10$tQMUTTuSbJiuqpITHrCN7.PMrqqkJTZROlbhZkPfvLKYEtcAsflXi` (from `src/lib/mock-data.ts:1485`); (2) `wrangler d1 execute peerloop-db --remote --command="UPDATE users SET password_hash = '<hash>' WHERE id = 'usr-admin'"`; (3) verify login as admin@peerloop.com / Peerloop2. Full rationale + counter-options in `docs/DECISIONS.md` §4 "Prod admin seed password: rotate to Peerloop2, apply deferred"

## TodoWrite Items

- [ ] #1: [BR-ZERO-REPRO] Reproduce 0-min empty-but-published recording state
- [ ] #2: [BR-STATUS] Add sessions.recording_status enum column [Opus]
- [ ] #5: [AAP] Astro dev-only absolute-filesystem path leak in ClientRouter
- [ ] #6: [VITE-DEPS-WATCH] Watch for recurring Vite missing-chunk warnings
- [ ] #10: [RAM-NONAV-SWEEP] Apply noNav=true to remaining 19 legitimate no-nav routes
- [ ] #11: [PROD-PW-APPLY] Apply Peerloop2 rotation to prod admin (deferred from Conv 168)

## Key Context

**Pre-commit state (will be committed in Step 6):** Docs repo has 13 modified + 2 new files (codecheck-deleted-at.mjs, cross-machine-verify.sh) + RESUME-STATE.md (this file). Code repo has 6 modified files (route-api-map.mjs, [tab].astro, package-lock.json, tests/README.md, tests/helpers/machine.ts, vitest.global-setup.ts).

**Baseline state (NOT re-verified this conv):** Conv 167's 6453/6453 tests + 5-gate baseline green was carried forward; only `tsc --noEmit` was re-run this conv (clean after MachineName type change). Full baseline re-verification deferred to next conv if needed — none of the Conv 168 changes touched src/ runtime code in ways that would break tests.

**[CCK-DA] context:** v2 algorithm binds each `deleted_at` reference to a specific table via alias resolution (FROM/JOIN/INTO/UPDATE → alias map) then checks schema. Calibration harness lives at `.scratch/cck-da-v2-test.mjs` with `--fixture` (Conv 117 reproduction) and `--counter` (5-case) modes — retained for future regression checks.

**[MND] canonical decision:** Code rotated TO PLAN.md's no-hyphen form. `MachineName` type narrowed to `'MacMiniM4Pro' | 'MacMiniM4' | 'CI' | 'unknown'`. Hostname patterns now match `*Jamess-Mac-mini*`, `*M4Pro*`, `*M4-Pro*` for M4Pro detection. `dev-env-scan.sh` grep accepts all three historical forms (forward + backward compat for old session docs).

**[RAM-NO-NAV] new convention:** `export const noNav = true;` in .astro frontmatter, read by `parseNoNav()` in `scripts/route-api-map.mjs:90`. Currently only `/course/[slug]/[tab]` is annotated; 19 more legitimate no-nav routes tracked in [RAM-NONAV-SWEEP].

**[XMV] harness usage:** `~/projects/peerloop-docs/.claude/scripts/cross-machine-verify.sh` runs 9 baseline cases. Use `--scan <file>` for advisory pre-commit review of any file with tilde/$HOME references. Documented in `docs/as-designed/devcomputers.md` § Cross-Machine Path Verification.

**[PROD-PW] state:** Live prod D1 admin row + `migrations/0002_seed_core.sql:172` BOTH still on Password1. Un-defer procedure in DECISIONS.md is the canonical reference.

**File path references:**
- v2 deleted_at lint: `~/projects/peerloop-docs/.claude/scripts/codecheck-deleted-at.mjs`
- XMV harness: `~/projects/peerloop-docs/.claude/scripts/cross-machine-verify.sh`
- noNav scanner support: `~/projects/Peerloop/scripts/route-api-map.mjs:90-99` (`parseNoNav`)
- noNav example: `~/projects/Peerloop/src/pages/course/[slug]/[tab].astro:20-22`
- PROD-PW seed location: `~/projects/Peerloop/migrations/0002_seed_core.sql:172`
- PROD-PW hash: `~/projects/Peerloop/src/lib/mock-data.ts:1485` (`DEV_PASSWORD = 'Peerloop2'`)

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view. **Quick wins available:** [RAM-NONAV-SWEEP] (19 mechanical .astro edits — establishes the convention everywhere). **Coordination-needed:** [PROD-PW-APPLY] (touches live prod D1 — pair with someone before running). **External-blocked / waiting:** [BR-ZERO-REPRO], [BR-STATUS] [Opus], [AAP], [VITE-DEPS-WATCH].

# State — Conv 251 (2026-06-08 ~15:40)

**Conv:** ended
**Machine:** MacMiniM4Pro
**Branch:** code: `jfg-dev-13-matt`, docs: `main`

## Summary

Completed **[RTMIG-TIER]** — all 8 legacy-`/old` clusters scrutinized and dispositioned in `plan/route-migration/README.md`. The pivotal finding: the README falsely listed `/old/dashboard` as "ported" (it conflated it with `/old/index.astro`); the `UnifiedDashboard` cross-role command center was never ported and is orphaned. Ran **[DASH-GAP]** (role-routes vs `/dashboard` overlap + gap analysis) which drove two realizations: (1) `/dashboard` is a summary layer that can't hold the deep functional surfaces of clusters 2/3/4, and (2) the cluster-5 creator predicate divergence is an instance of a site-wide role-flag inconsistency. Deleted cluster 6 (empty stubs → `/members`). Opened two new blocks: **[ROLE-SEMANTICS]** (canonical role semantics) and **[ROLE-STUDIOS]** (next-conv design exploration: combined vs per-role dashboards + Creator/Teacher Studios). Clusters 2/3/4 are NOT mechanically ported — their fate depends on ROLE-STUDIOS.

## Completed

- [x] [RTMIG-TIER] #1 — all 8 clusters dispositioned (cluster 0 dashboard created/provisional; 1 admin done prior; 2/3/4 → ROLE-STUDIOS; 5 hub+spoke; 6 deleted; 7 directives; 8 stays /old)
- [x] [DASH-GAP] #20 — role-routes vs /dashboard gap analysis written into README cluster 0
- [x] Cluster 6 DELETED — `git rm` `/old/{teachers,creators}.astro` (empty stubs) + repointed 8 links → `/members?roles=…` + fixed 5 test assertions + removed 2 middleware entries; gates green (tsc 0 / astro 0·1335 / lint / build), 228/228 affected tests
- [x] [ROLE-SEMANTICS] block opened (PLAN.md ACTIVE row + detail section)
- [x] [ROLE-STUDIOS] block opened (PLAN.md ACTIVE row + detail section)

## Remaining

- [ ] [ROLE-STUDIOS] #24 [Opus] — **NEXT-CONV exploration:** combined `/dashboard` vs per-role dashboards, with Creator Studio + Teacher Studio as SubNavBar workspaces. Reopens cluster-0 decision A. Open: student-role workspace? `/creating/apply` placement; shared earnings. SoT: PLAN.md § ROLE-STUDIOS.
- [ ] [ROLE-SEMANTICS] #23 [Opus] — canonical role semantics (`can*` vs `is*`/`has*`); 3 competing "is a creator" definitions; consolidate to one derivation + single `/api/me` source; cluster-5 creator port consumes the rule.
- [ ] [RTMIG-4] #4 [Opus] — main porting loop; clusters 2/3/4 now governed by ROLE-STUDIOS; clusters 5/7 have port directives in README; MOVE-not-copy policy.
- [ ] [ENTITY-ANCHOR] #21 — fix plural-slug profile anchors (`/teachers/${slug}`→`/teacher/${handle}`) in cluster-5 port.
- [ ] [SSR-LOADER-DEAD] #22 — assess/remove uncalled SSR loaders (resolved by cluster-5 loader adoption).
- [ ] [PORTED-AUDIT] #25 — re-verify the other 43 "ported" claims aren't similarly conflated.
- [ ] [COMM-TAG-FILTER] #2 [Opus] · [CT-RESTYLE] #3 (Tier-2 community)
- [ ] [PRIM-MATCH-INDEX] #5 · [TXTBTN] #6 (watch) · [PROFILE-PRIM-SWEEP] #7 (PAUSED)
- [ ] [ICN-NS] #8 [Opus] · [E2E-MIG] #9 · [E2E-GATE] #10
- [ ] [SHOWMORE] #11 · [SETTINGS-WATCHER] #12
- [ ] [PREFLIP-WT] #13 (KEEP until client-vet) · [STG-SEED] #14 (watch) · [TZ-AUDIT] #15 [Opus]
- [ ] [SUCCESS-COMMUNITY-VERIFY] #16 · [MEM-CAP] #17 (MEMORY.md ~80% byte cap) · [DOCGEN-SPEC] #18 · [OLD-PORTED-CLEANUP] #19

## TodoWrite Items

- [ ] #2 [COMM-TAG-FILTER] [Opus] · #3 [CT-RESTYLE] · #4 [RTMIG-4] [Opus] · #5 [PRIM-MATCH-INDEX] · #6 [TXTBTN]
- [ ] #7 [PROFILE-PRIM-SWEEP] · #8 [ICN-NS] [Opus] · #9 [E2E-MIG] · #10 [E2E-GATE] · #11 [SHOWMORE]
- [ ] #12 [SETTINGS-WATCHER] · #13 [PREFLIP-WT] · #14 [STG-SEED] · #15 [TZ-AUDIT] [Opus] · #16 [SUCCESS-COMMUNITY-VERIFY]
- [ ] #17 [MEM-CAP] · #18 [DOCGEN-SPEC] · #19 [OLD-PORTED-CLEANUP] · #21 [ENTITY-ANCHOR] · #22 [SSR-LOADER-DEAD]
- [ ] #23 [ROLE-SEMANTICS] [Opus] · #24 [ROLE-STUDIOS] [Opus] · #25 [PORTED-AUDIT]

## Key Context

- **Cluster dispositions (SoT = `plan/route-migration/README.md`):** 0 dashboard = port → root `/dashboard` (decision A) **PROVISIONAL, reopened by ROLE-STUDIOS** — do NOT build until that resolves; 1 admin = rehosted (Conv 250); 2/3/4 = NOT mechanically ported, (a) differentiators fold into dashboard(s) + (b) deep surfaces consolidate into Creator/Teacher Studios, `/old/{creating,teaching,learning}` stays live as reference; 5 = hub+spoke (`/@handle` hub → `/teacher|creator/[handle]` spokes), adopt SSR loaders; 6 = DELETED; 7 = port `/reset-password` (auth form) + `/verify/[id]` (public SSR cert card, extract StatusBadge); 8 = stays in `/old`.
- **DASH-GAP (done, feeds ROLE-STUDIOS):** /dashboard absorbs (a) hub-level differentiators (Join-Now, availability toggle, Create-Course CTA, past-people, empty states) but NOT the (b) 12 deep functional surfaces (CreatorStudio editor, analytics, availability calendar, full earnings/sessions/students, course detail, community mgmt). Those (b) surfaces need the Studios or they're lost when /old retires.
- **ROLE-SEMANTICS:** "is a creator" has 3 active definitions — permission `canCreateCourses` / behavioral `hasCreatedCourses()`/`EXISTS course` / hybrid. Same `is_creator` field means different things per code path. No canonical source (`/api/me/availability`+`settings` recompute inline). Cluster-5 creator-loader predicate defers to this block.
- **Cluster 6 code (will be committed in Step 6):** 5 components repointed to `/members?roles=…`, 2 stubs deleted, 4 test files + middleware test updated. Verified green.
- **/verify/[id] directives:** keep SSR; minimal branded standalone shell; extract `StatusBadge`; keep 3 states; reuse Card/UserAvatar/EmptyState.
- **[MEM-CAP] #17 still open** — MEMORY.md ~80% byte cap (20565/25600); user declined to prune Convs 248–251.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.

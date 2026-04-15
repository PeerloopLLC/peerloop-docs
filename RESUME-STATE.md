# State — Conv 118 (2026-04-14 ~20:34)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-12`, docs: `main`

## Summary

Conv 118 shipped COMMUNITY-RESOURCES Phase 5 — the Add Resource modal. Full end-to-end verification in Chrome MCP covered link-JSON path, direct-fetch multipart path, and modal-driven multipart path with R2 round-trip (uploaded file retrieved bytes-perfect via the download endpoint). Along the way, discovered and fixed a Conv 117 regression: both `resources/*.ts` endpoints queried `communities.deleted_at IS NULL`, but communities uses `is_archived` (no `deleted_at` column) — all POST/PUT/DELETE were 500'ing silently. Fixed to match the established pattern. Also flagged a UI/API gate mismatch where `canUploadResources` in 6 Astro pages checks only for creator/teacher membership, missing the `is_admin` branch the backend allows.

## Completed

- [x] COMMUNITY-RESOURCES Phase 5 (UI) — `AddCommunityResourceModal.tsx` with tab toggle, MIME auto-sensing, type override, pin toggle, dark-mode tokens
- [x] CommunityTabs wiring — button onClick, addResourceOpen state, modal mount, onSuccess → reload
- [x] Conv 117 regression fix — `deleted_at IS NULL` → `is_archived = 0` in 2 endpoints
- [x] Full browser smoke test: link + multipart + modal + R2 round-trip

## Remaining

### COMMUNITY-RESOURCES block

- [ ] Phase 7 (Tests) — unit + auth matrix for 6 endpoints
- [ ] Phase 8 (PLATO) — `upload-community-resources` flywheel step
- [ ] Phase 9 (Docs) — DB-API + new `r2-storage.md` + DEVELOPMENT-GUIDE `downloadUrl` pre-compute pattern note
- [ ] [UI-ADMIN-GATE] (new) — `canUploadResources` prop in 6 Astro pages missing `is_admin` branch. Admins can upload via API but see no button.

### DEPLOYMENT block (still in-progress from Conv 116)

- [ ] [DGH] DEPLOYMENT.GHACTIONS — deploy.yml + CLOUDFLARE_API_TOKEN GH secret
- [ ] [DP] DEPLOYMENT.PROD — prod cutover
- [ ] [DSD] DEPLOYMENT.STAGING-DOMAIN (optional)

### Carried forward (filed earlier convs)

- [ ] [IN] Verify/install gh CLI on MacMiniM4-Pro
- [ ] [EM] Email notification for session invites
- [ ] [AS] auth-sessions.md refresh-token-as-fallback docs
- [ ] [CSS] /discover/members bottom-row clipping
- [ ] [AD] Auth docs drift check
- [ ] [RS] reset-d1.js orphan-table drop
- [ ] [DS] dev:staging adapter 13 regression
- [ ] [PE] platform_stats environment marker
- [ ] [SG] sync-gaps.sh .astro/ exclusion
- [ ] [BL] /course/[slug]/certificate broken link
- [ ] [TL] no-paste-tokens-in-chat rule
- [ ] [GI] .claude/scheduled_tasks.lock in gitignore
- [ ] [CD] Bash cwd drift — git -C enforcement
- [ ] [COURSE-RES-AUTH] course download past-student check
- [ ] [BKC-NEXT] SessionBooking next-month upper bound
- [ ] [BKC-FETCH] SessionBooking 4-week fetch horizon gap
- [ ] [DBSCHEMA-CRES] _DB-SCHEMA.md §community_resources stale
- [ ] [NAV-DISABLED-AUDIT] AppNavbar.tsx Conv 110 items — decide fate
- [ ] [PLATO-FLYWHEEL-CREATOR-GAP] broader creator-lifecycle audit
- [ ] [CODECHECK-SQL] (new Conv 118) — `/w-codecheck` schema-aware SQL column-name lint

## TodoWrite Items

- [ ] #1: [IN] Verify/install gh CLI on MacMiniM4-Pro
- [ ] #2: [EM] Add email notification for session invites
- [ ] #3: [AS] auth-sessions.md missing refresh-token-as-auth-fallback docs
- [ ] #4: [CSS] Page scroll stuck on /discover/members — bottom row clipped
- [ ] #5: [AD] Auth docs drift check
- [ ] #6: [DGH] DEPLOYMENT.GHACTIONS
- [ ] #7: [DP] DEPLOYMENT.PROD
- [ ] #8: [DSD] DEPLOYMENT.STAGING-DOMAIN (optional)
- [ ] #9: [RS] reset-d1.js orphan-table drop
- [ ] #10: [DS] dev:staging adapter 13 regression
- [ ] #11: [PE] platform_stats environment marker
- [ ] #12: [SG] sync-gaps.sh .astro/ exclusion
- [ ] #13: [BL] Broken /course/[slug]/certificate link
- [ ] #14: [TL] no-paste-tokens-in-chat rule
- [ ] #15: [GI] scheduled_tasks.lock in gitignore
- [ ] #16: [CD] Bash cwd drift — git -C enforcement
- [ ] #18: COMMUNITY-RESOURCES Phase 7 (Tests)
- [ ] #19: COMMUNITY-RESOURCES Phase 8 (PLATO flywheel)
- [ ] #20: COMMUNITY-RESOURCES Phase 9 (Docs)
- [ ] #21: [COURSE-RES-AUTH] past-student download check
- [ ] #22: [BKC-NEXT] SessionBooking next-month upper bound
- [ ] #23: [BKC-FETCH] SessionBooking 4-week fetch horizon
- [ ] #24: [DBSCHEMA-CRES] _DB-SCHEMA.md community_resources stale
- [ ] #25: [NAV-DISABLED-AUDIT] AppNavbar.tsx Conv 110 disabled items
- [ ] #26: [PLATO-FLYWHEEL-CREATOR-GAP] creator-lifecycle audit
- [ ] #27: [UI-ADMIN-GATE] canUploadResources missing is_admin branch
- [ ] #28: [CODECHECK-SQL] /w-codecheck schema-aware SQL column-name lint

## Key Context

### Phase 5 shipped — UI now works end-to-end

Files to be committed in Step 6:
- NEW `src/components/community/AddCommunityResourceModal.tsx` (315 lines)
- M `src/components/community/CommunityTabs.tsx` (button wiring + modal mount)
- M `src/pages/api/me/communities/[slug]/resources/index.ts` (SQL fix)
- M `src/pages/api/me/communities/[slug]/resources/[resourceId].ts` (SQL fix)

### The Conv 117 bug that blocked Phase 5

`resolveAndAuthorize` in the community resources endpoints used `WHERE slug = ? AND deleted_at IS NULL` — but the `communities` table has no `deleted_at` column (uses `is_archived INTEGER DEFAULT 0` instead). D1 returned `SQLITE_ERROR: no such column: deleted_at`, logged as a generic "Failed to create resource" 500. Phase 5 UI was built correctly but appeared broken until the SQL was fixed. 10+ other endpoints already use `is_archived = 0` on communities — this was an outlier probably copy-pasted from a `session_resources` analog.

### Soft-delete conventions in this schema

| Table | Convention |
|---|---|
| users, courses, enrollments, progressions | `deleted_at TEXT NULL` |
| communities | `is_archived INTEGER DEFAULT 0` |

When writing an endpoint that queries a parent table, always grep an existing endpoint for *that same table*, not a similar-feeling one.

### UI-admin-gate is a real gap

Backend (resolve-and-authorize) allows: creator OR `is_admin = 1`.
Frontend (6 Astro pages) gates: `membership?.role === 'creator' || 'teacher'`.
Admin users who aren't community creators see no Add Resource button. Task #27.

### Modal file-input automation pattern (for future UI tests)

Chrome MCP has no native file-picker support. Use DataTransfer:
```js
const file = new File([content], 'name.txt', {type:'text/plain'});
const dt = new DataTransfer();
dt.items.add(file);
fileInput.files = dt.files;
fileInput.dispatchEvent(new Event('change', {bubbles:true}));
```
React's onChange picks it up and state updates fire (auto-title, preview, dropdowns).

### R2 local storage location

`.wrangler/state/v3/r2/miniflare-R2BucketObject/peerloop-storage/` — useful for direct inspection without hitting the download endpoint.

### Verification gates at conv close

- tsc --noEmit: 0 errors
- astro check: 0 errors, 0 warnings, 4 pre-existing hints (unrelated — AppNavbar Conv 110)
- Full modal → R2 → download round-trip: bytes match

Not run: full test suite, lint, build. Worth running before staging deploy.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.

### Suggested first move for Conv 119

Natural next step within the block: **COMMUNITY-RESOURCES Phase 7 (Tests)** — unit + auth matrix — because #27 (UI-ADMIN-GATE) should be paired with a test that catches the mismatch, and Phase 7 tests would have caught the Conv 117 `deleted_at` regression pre-push. Alternative: **DEPLOYMENT [DGH]** (GH Actions staging auto-deploy) since the COMMUNITY-RESOURCES MVP needs to reach staging for the client's CB3 fix to be visible.

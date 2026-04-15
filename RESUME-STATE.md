# State — Conv 117 (2026-04-14 ~19:57)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-12`, docs: `main`

## Summary

Conv 117 triaged three client-reported bugs and shipped a new PLAN block. **CB1** (My Courses menu) was diagnosed as design-as-intended (Conv 110 nav experiment). **CB2** (calendar won't go back past May) was a day+time comparison bug in `SessionBooking.tsx`; fixed by removing the prev-month guard entirely (unbounded matches existing next-button and teacher AvailabilityCalendar). **CB3** (Resources tab 404s) exposed a deeper schema gap: `community_resources.url` single column vs `session_resources` r2_key+external_url split made community file uploads structurally unrepresentable. Shipped `COMMUNITY-RESOURCES` MVP (Phases 1,2,3,4,6): schema aligned, 3 new API endpoint modules, SSR loader with pre-computed `downloadUrl`, seeds rewritten. Phases 5/7/8/9 deferred. Dev verified green (tsc 0, astro check 0, 74/74 community tests pass, live API probes correct). Not yet committed — happens in `/r-end` Step 6.

## Completed

- [x] CB1 — diagnosed, no fix needed
- [x] CB2 — fixed (SessionBooking.tsx prev-month guard removed + aria-labels added)
- [x] CB3 — fixed (via COMMUNITY-RESOURCES MVP)
- [x] COMMUNITY-RESOURCES Phase 1: schema aligned with session_resources
- [x] COMMUNITY-RESOURCES Phase 2: API endpoints (GET/POST list + GET/PUT/DELETE single)
- [x] COMMUNITY-RESOURCES Phase 3: download endpoint with membership auth
- [x] COMMUNITY-RESOURCES Phase 4: SSR loader + types + 6 Astro callers + component
- [x] COMMUNITY-RESOURCES Phase 6: seed data rewritten (core, dev, plato-topup, test fixture)
- [x] r2.ts helpers: generateCommunityResourceKey + getCommunityResourceDownloadUrl
- [x] PLAN.md: COMMUNITY-RESOURCES block added + detailed section
- [x] Docs (partial): DB-GUIDE §Community Resources, API-COMMUNITY new §Community Resources, CLI-QUICKREF rows, r-end route-mapping.txt

## Remaining

### Immediate next steps for COMMUNITY-RESOURCES block

The highest-value remaining phase is **Phase 5 (UI — Add Resource modal)** because without it, no one can actually upload a community file — the schema/endpoints/downloads all work, but the "Add Resource" button at `src/components/community/CommunityTabs.tsx:516` is inert. Until UI ships, seeded community resources remain external links only.

- [ ] **Phase 5 (UI)** — Wire "Add Resource" button. File-format-sensing per user requirement: auto-detect `type` from file MIME (image/* → image, audio/* → audio, else document), allow creator override via dropdown. Modal should expose two modes: "Upload file" (multipart POST) and "Add link" (JSON POST). The POST endpoint at `/api/me/communities/[slug]/resources` is ready.
- [ ] **Phase 7 (Tests)** — Unit + auth matrix for the 6 new endpoints. Mirror `tests/api/courses/*/resources/` patterns if they exist.
- [ ] **Phase 8 (PLATO)** — Add `upload-community-resources` step between `create-community` (step 3) and `create-course` (step 4) in `tests/plato/scenarios/flywheel.scenario.ts`. Creator uploads 2 community resources (one file via multipart, one external link via JSON). Will require regenerating snapshot fixtures.
- [ ] **Phase 9 (Docs)** — User note: task #28 still open. Docs agent already covered DB-API basics; Phase 9 should additionally create/update `docs/reference/r2-storage.md` (R2 key conventions: `courses/{id}/resources/{resId}/{filename}` vs `communities/{id}/resources/{resId}/{filename}`) and add the `downloadUrl` pre-compute pattern to `docs/reference/DEVELOPMENT-GUIDE.md`.

### Other pending / newly-filed

- [ ] **[COURSE-RES-AUTH]** Verify `src/pages/api/resources/[id]/download.ts:60-62` allows past students. Current gate: `WHERE course_id = ? AND student_id = ? AND status != 'cancelled'`. User wants: current OR past. Need to confirm that `status = 'completed'` / `'graduated'` passes this check — likely does, but verify the enum values and whether any status string would be wrongly excluded.
- [ ] **[BKC-NEXT]** SessionBooking next-month upper bound — design question. Currently unbounded; should it stop at some horizon (4 weeks? 6 months?)?
- [ ] **[BKC-FETCH]** SessionBooking fetches 4 weeks of availability only. Users paging forward beyond week 4 see all-disabled days with no feedback. Options: re-fetch on month change, larger initial window, or empty-state affordance.
- [ ] **[DBSCHEMA-CRES]** `docs/reference/_DB-SCHEMA.md` §community_resources is stale (old `url` + `file/link/video` enum). Needs update and probably a broader _DB-SCHEMA.md drift sweep.
- [ ] **[NAV-DISABLED-AUDIT]** AppNavbar.tsx has 4 `TEMPORARILY DISABLED (Conv 110)` items. Client confirmed intentional — rename marker or file audit to decide remove-vs-reinstate. Location: `src/components/layout/AppNavbar.tsx:292-363`.
- [ ] **[PLATO-FLYWHEEL-CREATOR-GAP]** Flywheel scenario has zero creator-lifecycle steps beyond `create-community`. Broader than Phase 8 — audit missing creator actions (moderation, settings edit, etc.).

### Carried forward (from earlier convs)

- [ ] **[IN]** Verify/install gh CLI on MacMiniM4-Pro
- [ ] **[EM]** Add email notification for session invites
- [ ] **[AS]** auth-sessions.md missing refresh-token-as-auth-fallback docs
- [ ] **[CSS]** Page scroll stuck on /discover/members — bottom row clipped
- [ ] **[AD]** Auth docs drift check (API-AUTH, auth-libraries, google-oauth, auth-sessions)
- [ ] **[DGH]** DEPLOYMENT.GHACTIONS — deploy.yml + CLOUDFLARE_API_TOKEN GH secret
- [ ] **[DP]** DEPLOYMENT.PROD — prod cutover (create peerloop Worker, verify bindings, upload secrets, deploy, custom domain)
- [ ] **[DSD]** DEPLOYMENT.STAGING-DOMAIN (optional) — staging.peerloop.com via Workers Routes
- [ ] **[RS]** reset-d1.js doesn't drop orphan tables outside current schema
- [ ] **[DS]** dev:staging doesn't actually use remote bindings (adapter 13 regression suspected)
- [ ] **[PE]** platform_stats 'environment' marker not seeded by 0002_seed_core.sql
- [ ] **[SG]** Fix sync-gaps.sh — exclude .astro/ subdirs (false positives)
- [ ] **[BL]** Pre-existing broken link: `/course/[slug]/certificate` from discover pages
- [ ] **[TL]** Add explicit no-paste-tokens-in-chat rule (CLAUDE.md or memory)
- [ ] **[GI]** Add `.claude/scheduled_tasks.lock` to docs `.gitignore`
- [ ] **[CD]** Bash cwd drift — strengthen `git -C` enforcement

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
- [ ] #16: [CD] Bash cwd drift
- [ ] #25: COMMUNITY-RESOURCES Phase 5 (UI) — Add Resource modal with mime-sensing
- [ ] #26: COMMUNITY-RESOURCES Phase 7 (Tests) — unit + auth matrix
- [ ] #27: COMMUNITY-RESOURCES Phase 8 (PLATO) — upload-community-resources flywheel step
- [ ] #28: COMMUNITY-RESOURCES Phase 9 (Docs) — DB-API + r2-storage doc + DEVELOPMENT-GUIDE pattern note
- [ ] #29: [COURSE-RES-AUTH] verify course download allows past students
- [ ] #30: [BKC-NEXT] SessionBooking next-month upper bound design
- [ ] #31: [BKC-FETCH] SessionBooking 4-week fetch horizon UX gap
- [ ] #32: [DBSCHEMA-CRES] _DB-SCHEMA.md §community_resources stale
- [ ] #33: [NAV-DISABLED-AUDIT] AppNavbar.tsx Conv 110 disabled items — decide fate
- [ ] #34: [PLATO-FLYWHEEL-CREATOR-GAP] flywheel missing creator-lifecycle steps

## Key Context

### COMMUNITY-RESOURCES data model (what the codebase expects now)

The `community_resources` table now mirrors `session_resources`:

| Column | Purpose |
|---|---|
| `r2_key TEXT NULL` | Set when resource is a file in R2; key format `communities/{communityId}/resources/{resourceId}/{filename}` |
| `external_url TEXT NULL` | Set when resource is a link |
| `size_bytes INTEGER NULL` | File size (null for links) |
| `mime_type TEXT NULL` | MIME (null for links) |
| `type TEXT CHECK (type IN ('document', 'image', 'audio', 'video_link', 'other'))` | Aligned with session_resources |

**Invariant (enforced in app layer, not schema):** a row has either `r2_key` OR `external_url`, never both. The POST endpoint enforces this by branching on request content-type.

### SSR loader pre-computes `downloadUrl`

`src/lib/ssr/loaders/communities.ts` emits `downloadUrl` per resource:
```ts
downloadUrl: r.r2_key
  ? `/api/community-resources/${r.id}/download`
  : (r.external_url ?? ''),
```
Components render `href={resource.downloadUrl}` blindly. This pattern should be applied to session_resources too in the future (Phase 9 docs note).

### Auth model (settled this conv)

| Action | Gate |
|---|---|
| Upload to community | community creator OR `users.is_admin = 1` |
| Download from community | authenticated community member OR creator OR admin (public/private flag does NOT affect download auth) |
| Upload to course | course creator OR admin (existing, unchanged) |
| Download from course | enrolled students — **needs verification** (task #29) for past/graduated status |

### File locations (for Phase 5 UI work)

- Button stub: `src/components/community/CommunityTabs.tsx:516` (`Add Resource` button, currently inert)
- Upload endpoint: `POST /api/me/communities/[slug]/resources` — accepts multipart (file field: `file`, optional: `title`, `description`, `type`, `is_pinned`) OR JSON (`{title, description?, type?, external_url, is_pinned?}`)
- Auto-type-sensing in POST handler: `image/*` → `image`, `audio/*` → `audio`, else `document`; form field `type` overrides
- Course equivalent for UI pattern reference: likely `src/components/creators/studio/ResourcesEditor.tsx` (not yet inspected)

### Verification gates (all green at conv close)

- `npx tsc --noEmit`: 0 errors
- `npm run check` (astro): 0 errors, 0 warnings, 4 pre-existing hints (unused-import noise in AppNavbar.tsx from Conv 110 disabling — unrelated)
- `npm test -- tests/api/communities`: 74/74 pass
- Live dev API probes: `/api/communities/ai-for-you` returns `downloadUrl` correctly; `/api/community-resources/*/download` returns 400 for link-type (correct); `/api/me/communities/*/resources` returns 401 unauth (correct)

**Not run:** full test suite, `npm run lint`, `npm run build`. Worth running once before staging deploy.

### Schema migration impact on staging/prod

- **Local D1:** reset + migrate clean this conv.
- **Staging D1:** will need reset + migrate + reseed on next deploy. The `community_resources.url` column is gone; any existing staging data referring to it would error. Since CLAUDE.md allows direct edits to `0001_schema.sql` pre-launch, this is expected and acceptable.
- **Production D1:** does not yet exist per PLAN DEPLOYMENT block. When [DP] happens, it will get the new schema directly.

### PLATO flywheel blind spot

The flywheel scenario is 13 steps and has zero creator-side work in the community beyond `create-community`. COMMUNITY-RESOURCES Phase 8 will add `upload-community-resources` — but [PLATO-FLYWHEEL-CREATOR-GAP] (task #34) tracks a broader audit of missing creator actions (moderation, settings edits, member management, etc.). This is the right time to raise this: the flywheel will need revising when we have community uploads, so a broader scope sweep at that moment prevents a second rewrite later.

### Conv 110 nav stale marker

`src/components/layout/AppNavbar.tsx:292-363` has 4 items commented out with `TEMPORARILY DISABLED — testing nav layout without these items (Conv 110)`. Client confirmed in Conv 117 that the disable is intentional. The `TEMPORARILY` marker is now misleading. Task #33 tracks renaming the marker or doing a design audit (remove-vs-reinstate decision).

### Files touched this conv (reference)

Code repo (17 modified + 3 new):
- New: `src/pages/api/me/communities/[slug]/resources/index.ts`, `[resourceId].ts`, `src/pages/api/community-resources/[id]/download.ts`
- Modified: `migrations/0001_schema.sql`, `migrations/0002_seed_core.sql`, `migrations-dev/0001_seed_dev.sql`, `src/lib/r2.ts`, `src/lib/db/types.ts`, `src/lib/ssr/loaders/communities.ts`, `src/components/community/CommunityTabs.tsx`, `src/components/booking/SessionBooking.tsx`, 6 Astro callers, 2 test files, `package-lock.json`

Docs repo:
- `PLAN.md` (COMMUNITY-RESOURCES added)
- `docs/reference/DB-GUIDE.md`, `docs/reference/API-COMMUNITY.md`, `docs/reference/CLI-QUICKREF.md` (docs agent updates)
- `.claude/skills/r-end/scripts/route-mapping.txt` (new mapping row)
- `docs/DECISIONS.md` (4 decisions appended by learn-decide)
- `TIMELINE.md` (2 entries appended)
- `docs/sessions/2026-04/20260414_1957 {Extract,Learnings,Decisions}.md`

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.

### Suggested first move for Conv 118

If the immediate goal is "make the CB3 client fix user-visible end-to-end," the logical next step is **COMMUNITY-RESOURCES Phase 5 (UI — Add Resource modal)**. Without it, creators can't upload files even though the backend is ready. Alternative: circle back to **DEPLOYMENT [DGH]** (GH Actions staging auto-deploy) since that's the in-progress block from Conv 116. The COMMUNITY-RESOURCES Phases 2-4+6 MVP changes must reach staging to actually fix CB3 for the client — so a quick deploy iteration is valuable before more feature work.

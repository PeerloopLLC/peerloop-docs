# R2 Storage — File Resources & Recordings

**Type:** Architecture Decision
**Status:** ✅ DECIDED (course resources, community resources, BBB recording replication)
**Created:** 2026-04-15 (Conv 121, COMMUNITY-RESOURCES Phase 9)
**Related:** `docs/reference/cloudflare.md`, `docs/reference/DB-API.md` §Session Resources, §Community Resources, `src/lib/r2.ts`, `src/lib/permissions.ts`

---

## Purpose

Document how Peerloop uses Cloudflare R2 for binary asset storage, the two distinct resource models (course/session vs community), the access-gate matrix for each, and the SSR `downloadUrl` pre-compute pattern that decouples client code from the storage backend choice (R2 file vs external URL).

---

## R2 Binding & Access

R2 is exposed to Astro endpoints as the `STORAGE` binding declared in `wrangler.toml`. All access is mediated through `src/lib/r2.ts`:

```ts
import { getR2, getR2Optional } from '@lib/r2';

const r2 = getR2(Astro.locals);          // throws if binding absent
const r2 = getR2Optional(Astro.locals);  // returns undefined if absent
```

`getR2Optional` exists for upload/delete endpoints that need to gracefully degrade if the binding is missing (returning HTTP 503 instead of 500). Health-check endpoints also use it.

**Test injection.** Tests pass `env: { STORAGE: mockR2 }` to `createAPIContext`, which stashes the mock on `locals.__testEnv.STORAGE`. `getR2*` checks that path before falling back to `cloudflare:workers` env. This avoids per-test wrangler.toml gymnastics and keeps tests synchronous.

---

## Two Storage Models

Peerloop has two parallel resource concepts, each backed by its own table and key-path scheme.

| Aspect | Course/Session Resources | Community Resources |
|--------|--------------------------|---------------------|
| **Table** | `session_resources` | `community_resources` |
| **R2 key prefix** | `courses/{courseId}/resources/{resourceId}/{filename}` | `communities/{communityId}/resources/{resourceId}/{filename}` |
| **Key generator** | `generateResourceKey(courseId, resourceId, filename)` | `generateCommunityResourceKey(communityId, resourceId, filename)` |
| **Download endpoint** | `/api/resources/[id]/download` | `/api/community-resources/[id]/download` |
| **Upload endpoint** | `/api/courses/[id]/resources`, `/api/sessions/[id]/resources` | `/api/me/communities/[slug]/resources` |
| **Upload auth** | Course creator or assigned Teacher | Community creator OR platform admin (`canUploadCommunityResources`) |
| **Download auth** | Enrolled student, course creator, or admin (see [COURSE-RES-AUTH] follow-up) | Community member, creator, or admin |
| **External-link mode** | No (recordings/files only) | Yes (`external_url` column; see Hybrid Storage below) |
| **Quota / size** | Same — 50 MB max, MIME allow-list (`isAllowedFileType`, `MAX_FILE_SIZE`) | Same |

These are intentionally separate: course resources belong to the curriculum and inherit course-level access (enrollment); community resources belong to a community and inherit membership-level access. There is no shared base-table or polymorphism — duplicating the small amount of code is preferable to coupling the two access models.

A third use of R2 — session recordings replicated from Blindside Networks (BBB) — uses key prefix `sessions/{sessionId}/recording.{ext}` and is documented separately under `replicateRecordingToR2` in `src/lib/r2.ts`.

---

## Hybrid Storage: File OR Link (Community Resources Only)

`community_resources` rows are either:

| Mode | `r2_key` | `external_url` | `mime_type` | `size_bytes` |
|------|----------|----------------|-------------|--------------|
| **File** | set | NULL | set (from upload) | set (from upload) |
| **Link** | NULL | set | NULL | NULL |

Both share the same `type` column (`'document' \| 'image' \| 'audio' \| 'video_link' \| 'other'`), which is purely descriptive metadata — it is **not** the discriminant. The discriminant is `r2_key`.

**POST endpoint chooses path by `Content-Type`:**
- `multipart/form-data` → File path: validate MIME, size, upload to R2, persist `r2_key`/`mime_type`/`size_bytes`.
- otherwise → JSON link path: validate `external_url` is a parseable URL, persist `external_url`.

**Download endpoint short-circuits link-only resources** with HTTP 400 (`"This resource is an external link, not a downloadable file"`). The client is expected to navigate `external_url` directly. There is no server-side proxy for external links — intentional, to avoid Peerloop becoming a redirect / scraper for arbitrary URLs.

---

## Access-Gate Matrix

### Community Resources

| Action | Member (any role) | Community creator | Platform admin (`is_admin=1`) | Anonymous |
|--------|:---:|:---:|:---:|:---:|
| **List (member surface, SSR)** | ✅ | ✅ | ✅ | ❌ |
| **List (management API)** | ❌ | ✅ | ✅ | ❌ |
| **Upload file/link** | ❌ | ✅ | ✅ | ❌ |
| **Update metadata** | ❌ | ✅ | ✅ | ❌ |
| **Delete** | ❌ | ✅ | ✅ | ❌ |
| **Download file** | ✅ | ✅ | ✅ | ❌ |

**Public-community caveat:** the `communities.is_public` flag controls discoverability and feed visibility. It does **not** grant resource download access. Non-members of a public community get HTTP 403 from the download endpoint and must join first.

**Why no Moderator / Teacher row.** Moderators have content-moderation powers but no upload rights to community resources per MVP scope. Teaching status was retired from `community_members.member_role` in Conv 120 (COMMUNITY-TEACHER-KILL); it now derives from `teacher_certifications` and is course-scoped, not community-scoped — so it cannot govern community resource access.

### Permission Helper Composition Pattern

Upload gating in Astro pages goes through the pure helper in `src/lib/permissions.ts`:

```ts
import { canUploadCommunityResources } from '@lib/permissions';

const canUpload = canUploadCommunityResources(viewerMembership, isAdmin);
```

The pattern that ships with this:

1. **SSR loader returns raw flags** (`fetchCommunityDetailData` returns `{ membership, isAdmin, ... }`).
2. **Pure helper composes the gating** (`canUploadCommunityResources(membership, isAdmin)` — no DB reads, trivially testable).
3. **Astro page renders declaratively** (`{canUpload && <UploadButton />}`).

This was the pattern that silently fixed [UI-ADMIN-GATE] in Conv 120: previously upload buttons branched on `membership.role === 'creator'` inline, which locked admins out. Centralising the rule in the helper meant admin access was a one-line addition with universal effect across all 6 Astro caller pages.

If this composition pattern accretes a second use site, promote it to `docs/reference/DEVELOPMENT-GUIDE.md` as a named convention. Premature now.

---

## SSR `downloadUrl` Pre-Compute Pattern

**Problem:** the React tree should not know whether a resource is an R2 file or an external link. It just needs a clickable URL.

**Solution:** the SSR loader emits a single `downloadUrl: string` field per resource, computed once on the server:

```ts
// src/lib/ssr/loaders/communities.ts (paraphrased)
return rows.map((r) => ({
  id: r.id,
  title: r.title,
  type: r.type,
  // Files served through the download endpoint; external links pass through verbatim.
  downloadUrl: r.r2_key
    ? `/api/community-resources/${r.id}/download`
    : (r.external_url ?? ''),
  r2Key: r.r2_key,
  externalUrl: r.external_url,
  // ...
}));
```

The React component renders `<a href={resource.downloadUrl}>`. It can still inspect `r2Key` / `externalUrl` for affordance (e.g., showing a file size for files, a domain pill for links), but the click target is always the pre-computed URL.

**Why this is worth a named pattern:**

- The storage-backend choice (R2 vs external URL) is a server-side fact. Pushing it to the client would force every consumer to re-derive the URL and re-encode the same conditional — boilerplate that drifts.
- The download endpoint can change shape (signed URLs, regional rewrites, attribution wrapping) without touching React code.
- The `?? ''` fallback covers malformed rows: should never happen post-migration, but a missing href is a softer failure mode than a runtime exception in the renderer.

**Helper:** `getCommunityResourceDownloadUrl(resourceId)` in `src/lib/r2.ts` returns the API path. The SSR loader inlines the template instead of calling the helper — both are equivalent; the inline form is slightly easier to read in the loader's mapping function. New code should prefer the helper.

The course-resource SSR path uses an analogous helper, `getResourceDownloadUrl(resourceId)`. No external-link variant exists for course resources because they don't have a link mode.

---

## Caveats & Open Items

- **No signed URLs.** Both download endpoints stream R2 bytes through the Worker rather than issuing time-bounded signed URLs. This keeps auth checks server-side and avoids URL-leakage concerns, at the cost of Worker CPU time for the byte stream. Acceptable while file sizes are capped at 50 MB.
- **Best-effort R2 cleanup on DELETE.** Both delete endpoints log-and-continue if the R2 delete fails; the row is dropped regardless. This intentionally favors DB consistency over storage tidiness — orphaned R2 objects can be reaped by a future maintenance script.
- **No re-upload.** PUT endpoints update metadata only. To replace a file, the user must DELETE then POST. This is a UX choice, not a technical limit.
- **[COURSE-RES-AUTH] (open).** `src/pages/api/resources/[id]/download.ts` currently gates on enrollment `status != 'cancelled'`. Past students with `'completed'` or `'graduated'` enrollments need to be verified as covered by that check. Tracked in TodoWrite.
- **[CRES-TEST-PATH] (open).** `tests/api/community-resources/[id]/download.test.ts:29` has an off-by-one `../` in an import path; vitest aliases mask it at runtime, but `tsc --noEmit` flags it. Tracked in TodoWrite.

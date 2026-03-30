# RFC: CD-038 — Recording Downloads, Analytics Callbacks & Account Settings

**Source:** [CD-038.md](./CD-038.md)
**Priority:** High (unblocks RECORDING-PERSIST block)

---

## Analytics Callback Integration

- [x] Build analytics callback endpoint (`POST /api/webhooks/bbb-analytics`) — already exists
- [x] Implement JWT verification (HS512 with BBB shared secret) — already in `bbb-analytics.ts`
- [x] Parse analytics JSON payload and store in `session_analytics` table — already implemented
- [x] Pass `meta_analytics-callback-url` in `BBBProvider.createRoom()` meta parameters so callbacks trigger automatically — already wired (Conv 037: `join.ts:135` → `bbb.ts:306`)
- [ ] Deploy analytics endpoint to production
- [ ] ~~Send production analytics callback URL to Blindside Networks~~ — **Not needed:** URL is self-configuring via `meta_analytics-callback-url` on each `create` call
- [x] Confirm JWT shared secret is the same as `BBB_SECRET` — **Yes, confirmed** (Fred Dixon, 2026-03-29, ticket #21121)
- [ ] Verify end-to-end: run a test session, confirm analytics JSON arrives and is stored

## Recording Downloads

- [x] Implement cookie-based two-step `.m4v` download in recording replication (Conv 037):
  1. `fetchWithCookieAuth()` — fetches capture page, extracts Set-Cookie, fetches .m4v
  2. `parseBlindsideCaptureUrl()` — detects Blindside URLs and extracts both URLs
  3. `replicateRecordingToR2()` — auto-detects Blindside vs direct URLs
- [x] Update `replicateRecordingToR2` in `r2.ts` to use cookie auth (Conv 037)
- [x] Add `recording_size_bytes` column to `sessions` schema (Conv 037)
- [x] Store file size after R2 upload — uses Content-Length header, falls back to R2 head (Conv 037)
- [ ] Verify `getRecordings` response includes the capture URL format
- [ ] Test full flow: session ends → recording ready webhook → download `.m4v` → store in R2
- [ ] Update `recording_url` column: decide whether to store BBB playback URL, R2 URL, or both

## Account Settings

- [x] Decide webcam storage policy: **instructor-only** (Conv 037)
- [x] Contact Blindside Networks with webcam storage decision — **Done** (2026-03-29, ticket #21121, instructor-only enabled)
- [x] Document the chosen policy in `docs/POLICIES.md` §6 Video Session Recordings (Conv 037)

## Documentation

- [x] Register email thread as CD-038
- [x] Update `docs/reference/bigbluebutton.md` with recording download mechanism
- [x] Update `docs/reference/bigbluebutton.md` with analytics callback details
- [x] Update RFC INDEX.md

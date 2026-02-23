# Session Decisions - 2026-02-23

## 1. Defer Moderation Queue Scoping for Community Moderators
**Type:** Strategic
**Topics:** auth, d1

**Trigger:** Tier 2 community moderators were implemented (schema, CRUD, CurrentUser), but the question arose: should they also be able to use the moderation queue in this session?

**Options Considered:**
1. Implement queue scoping now (add `community_id` to `content_flags`, modify 4+ admin endpoints)
2. Defer queue scoping to a separate task ← Chosen
3. Skip queue scoping entirely (community mods never use the queue)

**Decision:** Defer moderation queue scoping. Community moderators can be appointed, revoked, and checked in CurrentUser, but cannot yet access the moderation queue.

**Rationale:** Queue scoping requires adding `community_id` to `content_flags`, changing authorization logic in 4+ admin moderation endpoints (`/api/admin/moderation/*`), and deciding between shared-queue-with-filters vs separate community-scoped endpoint. This is a different architectural concern from the CRUD + CurrentUser foundation work and would roughly double the session scope.

**Consequences:** Community moderators are "known to the system" but functionally limited to what `canModerateFor(courseId)` enables in UI gating. The moderation queue itself still requires Tier 1 (global) or admin access.

---

## 2. Optional Body on DELETE for Moderator Revocation
**Type:** Implementation
**Topics:** auth

**Trigger:** The DELETE endpoint for revoking community moderators accepts an optional `{ reason? }` in the request body.

**Options Considered:**
1. Require reason in body (400 if missing)
2. Accept optional reason, don't fail on empty/missing body ← Chosen
3. Move reason to query parameter

**Decision:** DELETE body parsing uses try/catch — if no body or invalid JSON, reason defaults to null. The endpoint never fails due to missing body.

**Rationale:** REST convention is that DELETE bodies are optional. A revocation reason is useful for audit trails but shouldn't be mandatory. The try/catch pattern gracefully handles both `DELETE /path` (no body) and `DELETE /path` with `{ reason: "..." }`.

**Consequences:** Revocations always succeed if authorization checks pass. The `revoke_reason` column is nullable. Admins/creators can provide context but aren't forced to.

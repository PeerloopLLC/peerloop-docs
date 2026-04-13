# State — Conv 112 (2026-04-13 ~14:57)

**Conv:** ended
**Machine:** MacMiniM4
**Branch:** code: `jfg-dev-11`, docs: `main`

## Summary

Conv 112 created PLATO tests for the unified member directory (browse-members step, activities + standalone scenarios), browser-tested /discover/members, fixed a hydration race bug in MemberDirectory.tsx, added recordLogin() to all auth endpoints, and resolved 5 TodoWrite items.

## Completed

- [x] Created browse-members PLATO step (read-only, 4 API query variations)
- [x] Added browse-members to activities scenario + standalone member-directory scenario
- [x] Browser tested /discover/members (filters, search, cards, role badges)
- [x] Fixed Creator filter empty on initial page load (AbortController + rolesKey)
- [x] Fixed users.last_login never written (recordLogin in 4 auth endpoints)
- [x] Fixed stale DISCOVER_LINKS in route-api-map.mjs
- [x] Investigated auth refresh token issue (deferred to AUTH block)
- [x] Documented Chrome MCP limits + PLATO snapshot strategy in BROWSER-TESTING.md

## Remaining

- [ ] **[EM]** Add email notification for session invites (future enhancement)
- [ ] **[DOC]** auth-sessions.md missing refresh-token-as-auth-fallback documentation
- [ ] **[CSS]** Page scroll stuck on /discover/members — bottom row clipped (pre-existing)

## TodoWrite Items

- [ ] #1: [EM] Add email notification for session invites — future enhancement
- [ ] #12: [DOC] auth-sessions.md missing refresh-token-as-auth-fallback documentation
- [ ] #13: [CSS] Page scroll stuck on /discover/members — bottom row clipped

## Key Context

### PACKAGE-UPDATES block
Still in progress on jfg-dev-11. PLATO testing of member directory complete. Staging smoke test remains as the final gate before merge.

### Auth refresh token issue
getSession() in session.ts:77-84 falls back to refresh token (7-day) when access token (15-min) expires. Comment says "for now, just return the payload." Needs proper /api/auth/refresh endpoint + client auto-refresh. Deferred to future AUTH block.

### recordLogin() added
New function in src/lib/auth/session.ts. Called from login.ts, dev-login.ts, google/callback.ts, github/callback.ts. Writes last_login with strftime ISO format.

## Resume Command

To continue: run `/r-start`, which will consolidate state and present a unified view.

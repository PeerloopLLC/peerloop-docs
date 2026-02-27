# Session Learnings - 2026-02-27

## 1. Playwright Route Interception Must Return Enriched API Format, Not Raw Stream Format
**Topics:** testing, stream

**Context:** Writing E2E tests for feed pages (community, course, home) using Playwright `page.route()` to mock Stream.io API calls. The initial mock data used Stream.io's raw response format with `results` array, nested `actor` object, and `content` field.

**Learning:** Mock data intercepting at the `/api/feeds/**` level must match what the **Peerloop API endpoint** returns to the React component, not the raw Stream.io format. The API endpoints transform Stream responses (e.g., `response.results` becomes `activities`, actor names get flattened into `userName`, post text is in `text` not `content`). Since `page.route()` replaces the API response entirely, the mock must mimic the enriched format.

**Pattern:**
```typescript
// WRONG — raw Stream format (component can't render this)
{ results: [{ actor: { id: '...', data: { name: 'Guy' } }, content: '...' }] }

// RIGHT — enriched Peerloop API format
{ activities: [{ actor: 'user:usr-guy', userName: 'Guy Rymberg', text: '...' }] }
```

---

## 2. E2E Tests Can Pass for Wrong Reasons When Assertions Match Unintended Page Content
**Topics:** testing

**Context:** Community-feed and course-feed E2E tests passed despite the mock data having the wrong format. The home-feed test failed.

**Learning:** The community and course pages have other content matching the assertions (e.g., "Guy Rymberg" appears as community creator in the page header, not from the mocked feed). Only the home-feed test failed because `/feed` has no static content with those names — the feed is the only source. This is a reminder to verify **why** a test passes. A green test with wrong mock data gives false confidence — the test validates page load, not feed rendering.

**Pattern:** When writing mock-dependent tests, include assertions that can ONLY be satisfied by the mock data (e.g., unique mock-only text like "Welcome to the community!" that doesn't appear elsewhere on the page).

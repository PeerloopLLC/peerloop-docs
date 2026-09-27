---
name: DB setup shorthand
description: User refers to DB setup commands as "run the {local/staging} D1 {level} script" — map to npm run db:setup:{target}:{level}
type: feedback
---

When the user says "run the local D1 booking script" (or similar), run the corresponding `npm run db:setup:{target}:{level}` command without asking for clarification.

**Mapping:** `{local/staging} D1 {level}` → `npm run db:setup:{target}:{level}`

Examples:
- "run the local D1 booking script" → `npm run db:setup:local:booking`
- "run the staging D1 stripe script" → `npm run db:setup:staging:stripe`
- "reset local D1" or "run the local D1 script" → `npm run db:setup:local`

**Why:** The full npm script names are verbose. The user prefers natural shorthand.

**How to apply:** Any time the user references running a D1 setup by target and level, execute immediately.

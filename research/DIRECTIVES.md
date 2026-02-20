# Alpha Peer - Directives & Constraints

**Version:** v1
**Last Updated:** 2025-11-30
**Purpose:** Constraints, restrictions, and preferences that MUST be consulted during the RUN phase when generating SPECS.md scenarios.

> **Version History:** Increment version when substantive changes occur (new directives, changed constraints, removed restrictions). Minor edits (typos, formatting) don't require version bump.

---

## How to Use This File

**During GATHER:** Add directives as they are discovered from:
- Client feedback or requirements
- Technical research findings
- Compatibility testing
- Integration issues discovered

**During RUN:** Consult this file before generating any scenario. Every directive must be honored unless explicitly overridden by the user for a specific scenario.

**Adding Directives:** Use `/r-add-directive` or add manually with format:
```
| DIR-NNN | [Type] | [Directive description] | [Source/Reason] | [Date] |
```

---

## Directive Types

| Type | Meaning |
|------|---------|
| **MUST-USE** | Required software/service (client-specified or technically necessary) |
| **MUST-AVOID** | Do not use this software/service/approach |
| **NO-COMBINE** | These technologies don't work well together |
| **PREFER** | Favor this option when alternatives exist |
| **REQUIRES** | If using X, must also use Y |
| **FEATURE-FLAG** | Specific feature of a service to enable/disable |

---

## Active Directives

| ID | Type | Directive | Source/Reason | Date |
|----|------|-----------|---------------|------|
| DIR-001 | MUST-USE | BigBlueButton for video conferencing | Client-specified (CD-002) | 2025-11-30 |
| DIR-002 | MUST-USE | Stream for chat and activity feeds | Client-specified | 2025-11-30 |
| DIR-003 | PREFER | Cloudflare over Vercel for deployment | Cost efficiency, R2 storage | 2025-11-30 |
| DIR-004 | PREFER | Astro.js with React islands | Performance, stated preference | 2025-11-30 |
| DIR-005 | MUST-USE | Tailwind CSS for styling | Confirmed stack choice | 2025-11-30 |
| DIR-006 | MUST-USE | React.js for UI components | Confirmed stack choice | 2025-11-30 |

---

## Compatibility Notes

*Document known compatibility issues or successful combinations here.*

| Software A | Software B | Status | Notes |
|------------|------------|--------|-------|
| *None documented yet* | | | |

---

## Feature-Specific Directives

*Specific features within services to enable or avoid.*

| Service | Feature | Directive | Reason |
|---------|---------|-----------|--------|
| *None documented yet* | | | |

---

## Scenario-Specific Overrides

*Directives that apply only to specific scenarios.*

| Scenario | Directive Override | Reason |
|----------|-------------------|--------|
| sc-001-fully-custom | Ignore MUST-USE for BBB, Stream | Baseline comparison scenario |

---

## Current State

| Metric | Value |
|--------|-------|
| Next Directive ID | DIR-007 |
| Total Directives | 6 |
| MUST-USE | 4 |
| MUST-AVOID | 0 |
| NO-COMBINE | 0 |
| PREFER | 2 |

---

## Adding New Directives

When adding a directive, include:
1. **Clear description** - What exactly is required/forbidden
2. **Source** - Where did this come from? (client, research, testing)
3. **Reason** - Why is this a constraint?
4. **Date** - When was it added?

Example discoveries that become directives:
- "Client says they must use Stripe" → MUST-USE
- "Clerk auth doesn't work with Cloudflare Workers" → NO-COMBINE
- "Stream Video exists but BBB is required" → MUST-AVOID Stream Video
- "If using Supabase, use Supabase Auth too" → REQUIRES

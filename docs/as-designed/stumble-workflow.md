# STUMBLE Fix-and-Verify Workflow

**Purpose:** Formalized process for isolating and re-testing failures discovered during PLATO runs (API mode or Browser mode), using DB snapshots to avoid re-walking entire flows from scratch.

**Status:** Documented Conv 077. Infrastructure already supports the workflow — no new tooling required.

---

## The Problem

A PLATO instance defines a sequence of steps (API actions + BrowserIntents). When a failure is found — either an API-mode test failure or a UX stumble discovered during a browser walk — fixing the code is only half the job. You need to **verify the fix in context**, starting from the DB state that existed right before the failure.

Re-running the entire instance from scratch is wasteful: the steps before the failure haven't changed, and re-walking them burns time and context. The fix-and-verify workflow uses the Pre/Post segment split to isolate exactly the steps that matter.

---

## Workflow

### Trigger A: API-Mode Failure

An API-mode run of a PLATO instance fails at a specific step.

```
Step 1: Run full instance in API mode → fails at step N

Step 2: Fix the code that caused the failure

Step 3: Split the instance into two segment instances
        Pre-segment:  Steps 1 through N-1
        Post-segment: Steps N through end

Step 4: Run Pre-segment in API mode with snapshot: true
        → Produces DB snapshot at the moment right before
           the fixed step

Step 5: Restore Pre-segment snapshot to local D1
        → npm run plato:restore -- {pre-segment-name}

Step 6: Walk Post-segment in Browser mode
        → Verify the fix visually, in real browser context
        → Clean walk through remaining steps = verified
```

### Trigger B: Browser-Mode Stumble

A browser walk discovers a UX issue (not an API failure — the API succeeded but the UI is wrong, confusing, or broken). The same split technique applies:

```
Step 1: During browser walk, discover UX issue at intent N

Step 2: Fix the code (UI component, layout, copy, etc.)

Step 3: Split the instance into two segment instances
        Pre-segment:  Steps 1 through N-1
        Post-segment: Steps N through end

Step 4: Run Pre-segment in API mode with snapshot: true
        → DB state right before the problematic page

Step 5: Restore snapshot, walk Post-segment in browser
        → Verify the fix visually
```

The difference from Trigger A: the API run didn't fail — the issue was only visible in the browser. But the snapshot technique is identical. The Pre-segment runs in API mode (fast, no browser needed) to build up the DB state, then the Post-segment is walked in the browser to verify the fix.

---

## Segment Instance Files

Segment instances created during fix-and-verify are **typically one-off files** — they exist only to produce a snapshot at a specific split point, then verify a fix. They are not permanent scenarios.

However, some segments may turn out to be useful as reusable scenarios (e.g., a "post-enrollment" segment that starts with a student already enrolled). **Ask the user before deleting segment files** — they may want to promote a segment to a permanent scenario.

### Naming Convention

```
{original-instance}-pre-{N}.instance.ts    # Steps 1 through N-1, snapshot: true
{original-instance}-post-{N}.instance.ts   # Steps N through end, no snapshot
```

Example: fixing a failure at flywheel step 8:
```
flywheel-pre-8.instance.ts     # Steps 1-7, produces snapshot
flywheel-post-8.instance.ts    # Steps 8-14, browser walk target
```

### Lifecycle

1. **Create** segments when a fix needs verification
2. **Run** Pre-segment to produce snapshot
3. **Walk** Post-segment in browser to verify fix
4. **Ask user** whether to keep or delete the segment files
5. If kept, consider promoting to a named scenario in the registry

---

## Infrastructure

All required infrastructure already exists:

| Capability | Tool | Notes |
|-----------|------|-------|
| Run instance in API mode | `npm test -- --testNamePattern="{instance}"` | Standard test runner |
| Snapshot at end of run | `snapshot: true` on `PlatoInstanceFile` | Saves to `tests/plato/snapshots/` |
| Restore snapshot to local D1 | `npm run plato:restore -- {name}` | Copies SQLite to wrangler D1 |
| Browser walk | Chrome MCP + BrowserIntents | Manual walk with structured navigation |
| Split instance | Manual: copy steps into two files | No automation needed yet |

### Future Convenience (not required)

A `plato:split` CLI helper could automate the file split:
```bash
npm run plato:split -- flywheel --at 8
# Creates flywheel-pre-8.instance.ts and flywheel-post-8.instance.ts
```

This is a DX convenience, not a capability gap. Manual splitting works today.

---

## Relationship to Other Systems

- **PLATO** (`docs/as-designed/plato.md`): Defines the instance/scenario/step model this workflow operates on
- **STUMBLE-AUDIT** (`PLAN.md`): The project block that systematically walks PLATO steps in the browser — this workflow is the fix-and-verify inner loop within STUMBLE-AUDIT
- **PLATO-ON-STEROIDS** (`PLAN.md` deferred #41): Future automation that could execute this workflow programmatically (agent-driven browser walks with snapshot checkpoints)

---

*Documented: Conv 077 (2026-04-02). Based on workflow observed during STUMBLE-AUDIT course creation walkthrough.*

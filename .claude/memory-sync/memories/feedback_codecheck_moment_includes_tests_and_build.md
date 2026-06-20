---
name: codecheck-trigger-is-the-decision-point-for-thorough-checks
description: "When deciding to run /w-codecheck, also decide whether to run prov-sweep, the test suite, and the build. They aren't auto-bundled — the /w-codecheck trigger is the moment to consider doing the most thorough check the change deserves."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: f1ae7235-3dca-4f6c-905e-f0e2be5a5dc2
---

When I decide to run `/w-codecheck` (for whatever reason), I also **make an explicit decision** about whether to additionally run:

1. **Provenance sweep** (`cd ../Peerloop && npx tsx scripts/prov-sweep.ts`) — read-only, surfaces drift between `@matt-source` markers and `scripts/prov-candidates.ts`. Cheap, ~5s.
2. **Test suite** (`npm test 2>&1 | tee /tmp/lastFullTestRun.log`) — ~3min, structural correctness.
3. **Build** (`npm run build`) — ~10s, structural correctness.

These are **not auto-bundled** into `/w-codecheck`. The point is that the `/w-codecheck` trigger is the deliberate "I want to verify this is clean" moment, and that moment is exactly when I should ask "what's the most thorough check this change deserves?" — then pick the right subset.

**Why:** `/w-codecheck` covers stock code-quality + Peerloop-specific bug-class checks. The other three (prov-sweep, tests, build) are slower or write-shaped and have different cost profiles. Auto-bundling forces the cost on every routine check (wasteful for small/contained changes); leaving them off the decision menu means I forget to run them when the change does warrant a full pass (Conv 207 [issue 1] motivating case — 35 latent test failures from a form-component restructure went undiscovered for hours because the routine `tsc + lint + astro check` skipped them).

**How to apply:**
- Before invoking `/w-codecheck`, briefly characterize the change:
  - Did it touch primitives / shared components / DOM structure? → tests likely affected
  - Did it touch markers, prov-candidates.ts, or component files with `@matt-source` notes? → prov-sweep
  - Was it structural (new routes, new entry points, build-time config)? → build
  - Trivial/local-only change (one file, single function)? → just `/w-codecheck`, skip the extras
- Run `/w-codecheck` first (cheap, fails fast), then the selected extras.
- For test runs, capture output via `tee /tmp/lastFullTestRun.log` per [[feedback_full_test_output]] (don't poll; let it complete).
- Failures of any gate → TaskCreate per [[feedback_surface_and_track_all_issues]].

**Anti-pattern (Conv 207):** running only `npx tsc --noEmit` + `npm run check` + `npm run lint` inline as a "lightweight pass" and skipping `/w-codecheck` entirely. That bypasses the 5 Peerloop-specific bug-class checks AND the decision-point for tests/build. If the change warrants verification at all, `/w-codecheck` is the canonical entry point — and the moment I should consider whether prov-sweep / tests / build belong in this particular pass.

**Route-doc regen** is NOT one of these decisions — it writes files and belongs in commit-time skills (`/r-end`-class), not the check trigger.

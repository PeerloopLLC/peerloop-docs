---
name: Full test suite output capture
description: Always save full test suite output to lastFullTestRun.log for review; run strategically due to ~3min cost
type: feedback
---

When running the full test suite (`npm test`), always capture output to a file:
```bash
cd ../Peerloop && npm test 2>&1 | tee /tmp/lastFullTestRun.log
```

Then tail the last 15-20 lines for the summary.

**Why:** Full suite takes ~3 minutes. Output disappears from context over time. Having `lastFullTestRun.log` means we can always check details (which tests failed, exact error messages) without re-running. Also shows how long ago it was done.

**How to apply:** Use `tee /tmp/lastFullTestRun.log` on every full suite run. Run the suite strategically — not after every small change. Targeted test runs (`--testNamePattern` or specific file) for iterative fixes, full suite only for final verification.

---
name: Large rename lessons
description: Hard-won lessons from the TERMINOLOGY block (Sessions 346-356, ~960 files, ~5000 replacements) — apply to any future large-scale rename
type: feedback
originSessionId: 5cb02e45-1cbd-40f3-926e-c489d261a295
---
Lessons from the TERMINOLOGY block rename (Sessions 346-356). Load this file when planning a large-scale rename (>50 files).

- **Pre-rename baseline:** ALWAYS run full test suite BEFORE starting to establish baseline failures
- **Word boundaries:** macOS `sed` doesn't support `\b` — use `perl -pi -e` for word-boundary-aware replacements
- **Short substrings dangerous:** `stId` → `teacherId` mangled `getByTestId`, `requesterId`, etc. Grep broadly first.
- **Smaller divergent first:** Do the smaller rename first (5 occ) to make the larger rename (217 occ) safe for global replace
- **Comment marker `†`:** When bulk-renaming in code comments, add `†` to flag auto-changed lines for future staleness review
- **DECISIONS.md footnotes:** Use `[^label]` markdown footnotes for "formerly known as" references — keeps text readable while preserving historical context
- **Phase 4B scope creep:** Original estimate was ~15 files. Actual was 83 files (~530+ occurrences). Always grep broadly before estimating doc updates.

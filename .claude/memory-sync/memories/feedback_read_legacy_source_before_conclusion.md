---
name: feedback_read_legacy_source_before_conclusion
description: "In any review / compare / port / parity task, fully read BOTH sides — especially the legacy source-of-truth — before surfacing a conclusion. \"Already in context\" counts only as a genuine full read THIS conv, never a summary, agent digest, or assumption. No directive permits skipping a full check."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: a7f4a411-90a6-4686-843c-4a74a303c9a5
---

When the task is to **review, compare, port, or check parity** between A and B, read the **full** content of **both** sides before drawing or surfacing any conclusion — and the legacy/old artifact is usually the functional source-of-truth, so it is the side most likely to be skipped and most important to read.

**Why:** Conv 222 — asked whether `/courses` and `/communities` role tabs behaved differently per role, I twice concluded "they're just filters, at parity" after reading only the **new** components and **not** the legacy `/old/discover/*` views that were the actual spec. The user corrected both times ("Did you check the code in /old/…?"). The legacy views in fact rendered a distinct component per role (EnrollmentCard with progress, teaching/created/moderation cards) — fidelity the new filter-only catalogs had silently dropped. Reading only one side produced a confidently wrong answer.

**How to apply:**
- Before surfacing a diff/parity/"they match" conclusion, open the full legacy source — not a summary, not an agent's digest, not memory of how it "probably" works.
- "I already have it in context" is acceptable ONLY when it was a genuine full read earlier *this same conv*. If unsure whether the in-context copy is full or stale, re-read.
- There is **no** directive that licenses skipping a full check. [[feedback_exploration_pacing]] ("don't re-explore after patterns are established") is about not re-deriving structural patterns (file layout, API shape) — it is NOT a skip-license for the specific content under comparison.

Related: [[feedback_external_source_of_truth_first]] (probe the authoritative source before inferring), [[feedback_verify_baselines_in_conv]] (verify, don't carry forward unverified), [[feedback_audit_surface_findings_first]] (surface findings before acting).

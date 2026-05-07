---
name: Test new detection heuristics against their canonical motivating case before committing
description: Any new threshold, gate, or detection heuristic derived from qualitative guidance ("~30% divergence", "feels stale") MUST be run against the specific case(s) cited in the driving memo BEFORE commit. If it doesn't fire there, the threshold is wrong OR the signal is incomplete.
type: feedback
originSessionId: a41e95eb-15c4-4545-89cf-53b90e891f0f
---
When designing a detection heuristic — a threshold, gate, classifier, lint rule, or alert — from qualitative guidance in a feedback memory, RFC, incident report, or user note, run the heuristic against the specific case(s) the guidance cites BEFORE committing the design. If the heuristic does not fire (or fires the wrong way) on its own motivating case, the design is broken and shipping it would silently re-allow the bug it was meant to catch.

**Why (Conv 142 incident):** `/w-sync-skills` divergence gate. The driving feedback memory said cross-project skills "diverge by ~30% on average" and named `r-end` (Conv 140 DIVERGED) as the canonical case. Initial single-signal heuristic: Jaccard similarity on H2/H3 headers, threshold `< 0.70` → DIVERGED. Looked clean. Matched the "30%" language. Spot-check before commit: Jaccard on `r-end` = **1.000** — the canonical DIVERGED case would have been classified PORTABLE. Almost shipped a gate that would fail on the *one case it was explicitly designed to catch*. Root cause: headers stayed identical while line-level content forked; the memo conflated structural divergence with content divergence and the initial design followed the conflation. Final design used **two signals** (header Jaccard + post-normalization line-diff ratio) calibrated against all 13 exact-match skills. Captured at the time as "not significant enough yet" with `[CMH]` as the watch-task; codified Conv 151 after the value of the practice was proven.

**How to apply:**

1. **Identify the motivating case(s).** Every feedback memory or incident report names a specific instance — that's the canonical case. If none is named, **demand one** before designing the heuristic; abstract guidance without a case is uncalibratable.
2. **Run the heuristic on that case before commit.** Manually compute, mentally trace, or actually execute — whatever lets you observe the heuristic's verdict on the case.
3. **If the verdict doesn't match the desired outcome,** the design is broken in one of two ways:
   - **Threshold is wrong** — adjust until the canonical case fires correctly without breaking calibration on counter-examples.
   - **Signal is incomplete** — add a second signal that captures the dimension the first missed (e.g., header Jaccard catches structural divergence; post-normalization line-diff catches content divergence; the memo conflated both, so a single signal couldn't separate them).
4. **Calibrate against counter-examples too.** A heuristic that fires on the canonical case but also fires on every benign case is a false-positive machine. Walk a small set of known-PORTABLE / known-PASS cases through the same heuristic and confirm they don't trip.

**Scope:** Applies to anything that programmatically classifies or alerts — codecheck rules (`/w-codecheck`), skill gates (`/w-sync-skills`), drift detectors (`tech-doc-drift.sh`), lint rules, hook conditions, schema validators, threshold-based alerts. Does NOT apply to deterministic transforms (renames, refactors, format conversions) where there is no judgment call to calibrate.

**Failure mode this prevents:** Almost-shipped heuristics — designs that look correct in the abstract and match the memo's prose, but fire wrong on the motivating case because the prose conflated two signals or used threshold language ("~30%") that doesn't translate to the chosen measurement. The prevention cost is one minute of spot-check; the failure cost is silently re-allowing the original bug while believing it's caught.

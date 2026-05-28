# Coherence Acknowledgments

Findings listed here are **suppressed** from `/r-coherence-check` reports — they're counted in the summary but not surfaced as actionable findings. Use this for issues that are intentional-by-design, accepted-as-low-priority, or otherwise WON'T-FIX.

## Format

One acknowledgment per uncommented line, format:

```
[CATEGORY] <location-match-substring>
```

- `CATEGORY` is one of: `BROKEN-REF`, `STUB-DRIFT`, `OVERLAP`, `ORPHAN`, `CONTRADICTION`, `AMBIGUITY`, `FRICTION`, `STALE`, `REDUNDANCY`, `GAP`, `SCOPE-CREEP`.
- `<location-match-substring>` is matched as a substring against the finding's reported `Location:` field (e.g., `CLAUDE.md §Project Overview`, `memory/feedback_X.md`).

A finding is suppressed when **both** the category matches **and** the location-match substring appears in the finding's reported location.

## Active acks

(none)

## Examples (commented out — uncomment to activate)

<!--
[STALE] CLAUDE.md §Project Overview
[REDUNDANCY] feedback_pointing_emoji_prefix.md
[OVERLAP] 👉👉👉 in feedback_pointing_emoji_prefix.md
-->

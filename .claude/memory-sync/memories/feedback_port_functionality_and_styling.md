---
name: feedback_port_functionality_and_styling
description: "A legacy→Matt-inspired port MUST transfer functionality + content faithfully (every field, action, sub-filter, role behavior, state) AND apply full Matt styling discipline — the two are co-equal. Re-skinning the visible surface while silently dropping behavior/content is a FAILED port, not a simplification."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: a7f4a411-90a6-4686-843c-4a74a303c9a5
---

Porting a legacy page/component to its Matt-inspired version is **two co-equal obligations**, not one:
1. **Faithful functionality + content transfer** — every field, action/button, sub-filter, per-role rendering, empty/fallback state, and data path the legacy artifact provides must carry over.
2. **Full Matt styling discipline** — Matt tokens/primitives, provenance markers, the design language.

A port that nails the styling but quietly loses functionality/content is a **regression**, even though it "looks done." Dropping a legacy field/action/behavior is only acceptable when the user explicitly decides to (e.g. a deferral), surfaced and confirmed — never silently.

**Why:** Conv 222. The Conv-205 `/courses` and Conv-221 `/communities` "ports" collapsed five distinct per-role views (student progress card, teaching/created/moderation cards) into a single filter-only browse catalog — they kept (some) styling but dropped the per-role functionality AND per-card content. It read as "done" and shipped. The user surfaced both the missing per-role rendering and, separately, missing card content fields, and stated the rule: *"Porting legacy pages to matt-inspired versions requires faithful functionality transfer as well as all of the styling discipline."*

**How to apply (the porting recipe):**
- First **read the full legacy source** and enumerate its functionality/content per state and per role — do not work from a summary or assumption ([[feedback_read_legacy_source_before_conclusion]]).
- Transfer **all** of it; then apply Matt styling.
- Before declaring a port done, diff legacy vs new field-by-field / action-by-action and confirm nothing was silently dropped.
- This is the core of the DISC-DROP "Tier-1 recipe" and governs every RTMIG-4 page port.

Related: [[figma-context]] (reuse existing primitives, never inline duplicates), [[project_old_pages_no_delete_until_vetted]], [[project_route_404_honesty_standin]].

---
name: feedback_retest_task_premise_before_executing
description: "[PREMISE] A tasked count/target written from the implementation is usually wrong — enumerate the consumers before executing. 7 instances, Convs 418-420."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 552b0867-6641-432d-9293-f94cd4bfcef3
  modified: 2026-07-27T00:35:02.349Z
---

Before executing a task that names a **count, a target set, or a defect class** someone
(usually a past me) wrote down earlier, spend one tool call re-deriving it. Seven consecutive
times the tasked premise has been wrong, always in the same direction — **over-scoped, because
it was written by reading the implementation rather than enumerating the consumers.**

| Conv | Task said | Actually |
|---|---|---|
| 418 | `[CANMSG]` gate is vacuous | Not vacuous on 3 of 4 surfaces |
| 418 | `[MSG-ADOPT-A]` thread `signedIn` through 8 components | Self-resolvable from `useAuthStatus()` |
| 419 | `[MSG-ADOPT-B]` use `appearance="bare"` everywhere | Wrong for 3 sites — profile headers *want* the chrome |
| 419 | `[COURSETAB-HASH]` is a hash-parsing bug | Same hydration race as `[MSGBOOT]` |
| 420 | 46 icons have **no size class at all** | **All 46 false positives** — 14 avatars, 32 sized by a component default |
| 420 | 891 sites "shipped 4px icons" | ~501 icons + ~390 skeleton bars, badge circles, dots, avatars |

**Why:** a scanner or a past summary reports the shape of *its own output*, not the shape of the
code. A rule matching `<[A-Z]\w*Icon>` finds an avatar with a typed `size` prop; a rule matching
`w-/h-/size-N` finds loader bars and hit targets. The count is real; what it counts is not what
the task claims.

**How to apply:** before the first edit, read a representative sample of the *actual sites* —
not the tool output describing them. Ask what supplies the value when the call site omits it
(the answer is often one upstream default, which is also where the leverage is: Conv 420 cleared
200 violations with 94 edits because `MattIcon.tsx:43` sits above every un-classed usage). When
a premise falsifies, surface it before executing — see [[feedback_audit_surface_findings_first]].

**Corollary — don't shell-loop over findings.** A per-site `bash` loop over hundreds of results
spawns a subprocess per item and gets interrupted (Conv 420: ~900 `sed` calls). Write it as one
pass with a file cache instead.

Related: [[feedback_read_legacy_source_before_conclusion]] (read both sides fully),
[[feedback_assess_ask_before_acting]] (a *changed* premise ⇒ full rewrite, not a grep patch).

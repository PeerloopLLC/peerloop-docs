---
name: feedback_retest_task_premise_before_executing
description: "[PREMISE] Verify against CONSUMERS, not the definition — a count, a reachability claim, or a context assumption read off a component's own file is usually wrong. 10 instances, Convs 418-421."
metadata: 
  node_type: memory
  type: feedback
  originSessionId: 552b0867-6641-432d-9293-f94cd4bfcef3
  modified: 2026-07-27T10:13:43.682Z
---

One recurring root cause, three faces: **reading a thing's own definition and inferring what
its consumers do.** Ten times across Convs 418-421 that inference was wrong. Spend the one tool
call to check the consumer side before executing.

| Conv | Assumed (from the definition) | Actually (from the consumers) |
|---|---|---|
| 418 | `[CANMSG]` gate is vacuous | Not vacuous on 3 of 4 surfaces |
| 418 | thread `signedIn` through 8 components | Self-resolvable from `useAuthStatus()` |
| 419 | `appearance="bare"` everywhere | Wrong for 3 — profile headers *want* the chrome |
| 419 | `[COURSETAB-HASH]` is a hash-parsing bug | Same hydration race as `[MSGBOOT]` |
| 420 | 46 icons have **no size class at all** | **All 46 false positives** — 14 avatars, 32 sized by a component default |
| 420 | 891 sites "shipped 4px icons" | ~501 icons + ~390 skeleton bars, dots, avatars |
| 421 | 6 icon sites are "unreachable" | Reachable — I'd probed `brian`, who is neither teacher nor creator, and read *200-with-empty-shell* as unreachable |
| 421 | em icons sit beside a **14px** label | **12px** → they shipped at 13.8px, a **−14% shrink**, for a whole conv |

**The three faces.**
1. **Count / target set** — a scanner reports the shape of *its own output*, not of the code. A
   rule matching `<[A-Z]\w*Icon>` finds an avatar with a typed `size` prop.
2. **Reachability** — "the component didn't render" is not "the route is broken". Check what the
   loader's predicate actually requires and whether any seed row satisfies it. A 200 that renders
   an empty shell looks identical to a component that isn't wired up.
3. **Context** — a token's documented anchor ("1.15em, anchored on 14px body") describes the
   *token*, not the container it lands in. Measure the call site.

**How to apply:** before the first edit, read a representative sample of the *actual sites* — not
the tool output describing them. Ask what supplies the value when the call site omits it (often
one upstream default, which is also where the leverage is: Conv 420 cleared 200 violations with
94 edits because `MattIcon.tsx:43` sits above every un-classed usage). For anything visual,
**measure it live** — Conv 421's 14% shrink survived a full conv, 5 green gates and a
"no regression" scanner run, because the site was never rendered.

**The check is cheap, and sometimes it passes.** Conv 421's 187-site arbitrary-px premise **held**
on re-testing (all 187 genuinely icons, zero contamination) — one tool call bought the confidence
to run a 69-file mechanical migration without hedging. Verifying is not the same as distrusting.

When a premise falsifies, surface it before executing — see
[[feedback_audit_surface_findings_first]].

**Corollary — don't shell-loop over findings.** A per-site `bash` loop over hundreds of results
spawns a subprocess per item and gets interrupted (Conv 420: ~900 `sed` calls). Write it as one
pass with a file cache instead.

Related: [[feedback_read_legacy_source_before_conclusion]] (read both sides fully),
[[feedback_assess_ask_before_acting]] (a *changed* premise ⇒ full rewrite, not a grep patch),
[[feedback_orphaned_components_survive_migration]] (`[ORPHAN-DETECT]` — the reachability face,
where tsc/lint/tests stay green over dead code).

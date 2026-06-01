> **Part of the [DECISIONS](../DECISIONS.md) set** · [full index](INDEX.md) · [chronological log](decision-log.md)
> Decisions are **latest-wins** — a newer decision supersedes an older one. Content is the verbatim section from the pre-split DECISIONS.md (Conv 228).

## 9. Feature Flags

### Two-Tier Feature Flags
**Date:** 2025-12-28

- **Core Features (Custom D1):** Feature enablement, role-based access - must always work
- **Experiments (PostHog):** A/B tests, gradual rollouts - can gracefully fail

**Rationale:** Core features need reliability; experiments can tolerate failures.

---


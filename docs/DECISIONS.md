# DECISIONS.md

This document contains all active architectural and implementation decisions for the Peerloop project. **As of Conv 228 (2026-05-31) the decisions were split out of this single file (then 4572 lines) into [`docs/decisions/`](decisions/) — this file is now a pointer.** Open [`docs/decisions/INDEX.md`](decisions/INDEX.md) to navigate; it lists every decision title under its chunk.

**Last Updated:** 2026-05-31 Conv 228 (split monolithic DECISIONS.md → `docs/decisions/` topic chunks + chronological log + index; root file becomes a pointer)

---

## How This Document Works

- **Latest Wins:** If a newer decision contradicts an older one, only the newer decision appears in the topic chunks.
- **Organized by Impact:** High-impact decisions (architecture, database) come first (chunks `01`, `02`, …).
- **Chronological log:** [`decisions/decision-log.md`](decisions/decision-log.md) keeps dated entries in order — the place to look for *when* / *in what order* decisions were made when checking contradictions.
- **Source:** Consolidated from session decision files in `docs/sessions/`.

**Adding a decision:** put it under the matching topic chunk (latest-wins), append a dated entry to [`decisions/decision-log.md`](decisions/decision-log.md), and add the title to [`decisions/INDEX.md`](decisions/INDEX.md). See the write-path note in the index. (Skills/config that still name `DECISIONS.md` as a write target are tracked by **[DEC-SKILL-SYNC]**.)

---

## Topic Chunks

| # | Section | File |
|---|---------|------|
| 1 | Architecture & Design (Highest Impact) | [decisions/01-architecture.md](decisions/01-architecture.md) |
| 2 | Database & Data Model (High Impact) | [decisions/02-database.md](decisions/02-database.md) |
| 3 | API & Data Fetching (Medium-High Impact) | [decisions/03-api-data-fetching.md](decisions/03-api-data-fetching.md) |
| 4 | Authentication & Authorization | [decisions/04-auth.md](decisions/04-auth.md) |
| 5 | UI/UX & Components | [decisions/05-ui-ux-components.md](decisions/05-ui-ux-components.md) |
| 6 | Testing & CI/CD | [decisions/06-testing-ci.md](decisions/06-testing-ci.md) |
| 7 | Development Workflow & Documentation | [decisions/07-dev-workflow-docs.md](decisions/07-dev-workflow-docs.md) |
| 8 | Deployment & Infrastructure | [decisions/08-deployment-infra.md](decisions/08-deployment-infra.md) |
| 9 | Feature Flags | [decisions/09-feature-flags.md](decisions/09-feature-flags.md) |
| 10 | Admin Implementation | [decisions/10-admin.md](decisions/10-admin.md) |
| 11 | New Routing | [decisions/11-new-routing.md](decisions/11-new-routing.md) |
| — | Decision Log (chronological) | [decisions/decision-log.md](decisions/decision-log.md) |
| — | Terminology Footnotes | [decisions/terminology-footnotes.md](decisions/terminology-footnotes.md) |

➡️ **Full searchable index of all 396 decisions:** [`docs/decisions/INDEX.md`](decisions/INDEX.md)

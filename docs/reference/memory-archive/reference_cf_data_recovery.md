---
name: reference_cf_data_recovery
description: Cloudflare data-layer recovery capabilities (D1/R2/KV/DO) verified against developers.cloudflare.com Conv 212. D1 = 30d Time Travel; R2 = NO versioning (use Bucket Locks); KV = no PITR; DO = not used. Recovery-strategy reference for MVP-GOLIVE / DEPLOYMENT DR work.
metadata: 
  node_type: memory
  type: reference
  originSessionId: 86e3697a-31b1-4cf5-83e8-fddd4932fce3
---

Peerloop's Cloudflare bindings (verified `../Peerloop/wrangler.toml`, Conv 212): **D1** `DB`/`peerloop-db`, **R2** `STORAGE`/`peerloop-storage`, **KV** `SESSION` (sessions only). **No Durable Objects** (no bindings, no `DurableObject` code).

**Recovery capabilities verified against developers.cloudflare.com (Conv 212):**

- **D1 — Time Travel:** automatic, always-on point-in-time recovery, **30 days (paid) / 7 days (free)**, covers **schema + data**. Restore: `wrangler d1 time-travel restore peerloop-db --timestamp=<unix|RFC3339>` or `--bookmark` (get via `wrangler d1 time-travel info`). Caveats: restore is **destructive + whole-DB** (no single-table), **does NOT survive deletion of the DB itself**, 30d ceiling. For >30d / DB-deletion / table-level: `wrangler d1 export peerloop-db --output=dump.sql` → R2 + off-platform (Cloudflare documents export-to-R2 via REST API + Workflows).

- **R2 — NO object versioning / no delete-markers** (unlike S3): an overwrite or delete is unrecoverable unless pre-armed. Protections: **Bucket Locks** (WORM retention — fixed-days / until-date / indefinite, prefix-scoped up to 1000 rules; "a bucket cannot be emptied while lock rules are configured" → blocks even admin/token deletion; strictest rule wins; takes precedence over lifecycle). **Event notifications** (fire on delete/create → Queue/Worker for logging/alerting/copy-before-delete). **Object lifecycles**. Recover via: Bucket Locks on irreplaceable prefixes (e.g. issued certificates, user uploads), backup-bucket/replication copy, or app-level soft-delete (`deleted/` prefix or D1 flag).

- **KV — no native backup / versioning / PITR; deletion is permanent.** Mitigation here is structural: KV holds only `SESSION` data (reconstructable — users re-login), so loss is low-severity. **Invariant to preserve: KV = cache only, never a system of record.** If non-reconstructable data ever lands in KV, add a periodic `wrangler kv` list+get export to D1/R2.

- **Durable Objects — not used.** If added later (realtime/video), prefer the **SQLite-backed** DO class (has its own point-in-time recovery) and design periodic self-export to R2.

**Layered DR model discussed (Conv 212, analysis-only — user deferred PLAN/runbook, chose C):** prevention = the [SETTINGS-GUARD] hook ([[project_settings_tier_local_control]]); recovery = Time Travel (D1) + Bucket Locks/backup (R2) + cache-only invariant (KV); plus a tested restore runbook + nightly export automation (fits pending DEPLOYMENT.GHACTIONS). This is an MVP-GOLIVE / DEPLOYMENT.DB-SYNC concern (prod D1 already holds real rows).

---
name: project_schema_edit_remote_d1_propagation
description: Editing 0001_schema.sql does NOT reach an already-migrated remote D1 — db:migrate:staging silently no-ops; use ALTER or reseed.
metadata: 
  node_type: memory
  type: project
  originSessionId: 03fc7ef6-7e19-4fcb-bc5e-a5de892331f2
---

**[D1-SCHEMA-REMOTE]** Pre-launch schema edits land directly in `migrations/0001_schema.sql` (CLAUDE.md §Database Migrations). But that edit does **NOT** propagate to an **already-migrated remote D1** (staging/prod): `wrangler d1 migrations apply` (= `npm run db:migrate:staging`) only runs migration *files* not yet in the DB's tracking table — editing an already-applied file creates no new file, so it **silently no-ops**. The naive "run db:migrate:staging" after a 0001 edit does nothing and gives no error.

To get new columns onto an existing remote D1, two paths:
- **`ALTER TABLE ADD COLUMN`** — surgical, non-destructive, preserves data: `wrangler d1 execute DB --env staging --remote --command "ALTER TABLE users ADD COLUMN ..."`. Chosen Conv 394 [FEEDBACK-DEPLOY] (staging had client data to keep).
- **Reseed** (`db:setup:staging:*`) — destructive rebuild from the current 0001 + fresh seed. Chosen Conv 388 [SESSION-REMIND-DEPLOY].

Rule of thumb: **must-preserve data → ALTER; disposable seed → reseed.** Full rationale in `docs/decisions/08-deployment-infra.md` (Conv 394). Related: [[feedback_db_setup_shorthand]] · [[feedback_staging_is_deploy_target_prod_gated]].

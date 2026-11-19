---
name: sql
description: Use when interacting with SQL databases, writing queries, investigating data, or running any SQL statement.
---

# SQL Querying

## SELECT Queries (DQL)

`SELECT`, `SHOW`, `DESCRIBE`, `EXPLAIN` and similar read-only statements:

- Do not display the query
- Run immediately — no confirmation required
- Show sample output when it adds context

## Mutation Queries

`INSERT`, `UPDATE`, `DELETE`, `TRUNCATE`, `CREATE`, `ALTER`, `DROP`, `GRANT`, `REVOKE` and any other statement that changes data or schema:

- Always display every mutation query to the user before running it
- if the database tool has the word "production" or "prod": **Wait for explicit user confirmation before running**
- else run immediately — no confirmation required
- Never infer confirmation from prior context — ask each time

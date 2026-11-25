---
name: claude-cloud-litellm-mcp
description: Use when the litellm MCP server is missing or failed in a Claude Code cloud (claude.ai/code) session, when debugging the tailscale hook or localhost:4000 bridge, or when changing the tailnet ACL, auth key or cloud setup script for LiteLLM MCP access.
---

# Cloud sessions: LiteLLM MCP over Tailscale

Cloud sessions reach the LGA LiteLLM MCP gateway (`100.113.111.37:4000`, tailnet only) through a
userspace Tailscale node. The code lives in `doc/claude-code/startup-script.md`: the setup script,
the SessionStart hook (`/root/.claude/hooks/tailscale.sh`), the bridge script
(`tailscale-bridge.sh`) and the user-scope MCP entry.

## Design

- The container joins the tailnet with an **ephemeral, pre-approved, tagged** auth key
  (`TAILSCALE_AUTH_KEY`, tag `tag:claude-code-remote`). `tailscaled` runs in userspace mode and reaches
  the control plane and DERP through the session's HTTPS proxy (`*.tailscale.com` is allowlisted). The
  proxy has no UDP, so DERP over HTTPS is the only data path.
- `socat` bridges `localhost:4000` to the gateway through `tailscale nc`. The bridge script waits
  for the tailnet before dialing, so socat can listen at once.
- A user-scope MCP entry (`/root/.claude.json`) points at `http://localhost:4000/mcp/` with
  `Authorization: Bearer ${LITELLM_API_KEY}`; the `${...}` is expanded at runtime, never written to disk.
- Tailnet ACL: gateway host tagged `tag:ai-gateway`; the cloud tag may reach only
  `tag:ai-gateway` on `tcp:4000`; no allow-all rule; `rthomazel` may reach everything. Tagged nodes
  are not covered by user rules, so check the gateway host can still reach any node it needs.

## Startup race

The MCP client connects in parallel with SessionStart hooks and does not retry a failed first connect.
Once, the hook spent ~13s on `apt-get install socat` and the first connect got ECONNREFUSED.
Mitigations: the setup script installs tailscale and socat (cached), socat listens first, and the
bridge waits for the tailnet. Cold-start test: a request fired 0.3s after the hook started waited 8.3s
and returned 200. Timestamps are in `/var/log/tailscale-ccr.log` (`hook:` lines). If `litellm` still
shows as failed, reconnect with `/mcp`.

## Gotchas

- The auth key must be ephemeral, pre-approved and tagged on the key itself. A `?ephemeral=true&...`
  suffix on the key is rejected with `invalid key`. A tagged key needs `tagOwners` for the tag.
- The hook matcher is `startup|resume|compact`. A resumed container keeps binaries and state but
  loses processes, so without `resume` nothing restarts them.
- The hook returns once the processes run; the node can take a second more to be `Online`.
- `tailscale ping` (disco/TSMP) succeeds regardless of ACLs. Test ACLs with a TCP connect (see below).

## Checks

```bash
TS="/opt/tailscale/tailscale --socket=/var/run/tailscale-ccr.sock"
$TS status --json | python3 -c "import json,sys; s=json.load(sys.stdin)['Self']; print(s['HostName'], s.get('Tags'), s.get('Online'))"
curl -s -H "Authorization: Bearer $LITELLM_API_KEY" localhost:4000/health/liveliness
# ACL: rc=0 in ~1s means open, rc=124 means blocked (hung until timeout)
timeout 8 $TS nc 100.113.111.37 4000 </dev/null; echo rc=$?   # expect 0
timeout 8 $TS nc 100.113.111.37 22 </dev/null; echo rc=$?     # expect 124
```

Also check `/mcp` lists `litellm` as connected without a manual reconnect, and that the `compact`
hook run is an idempotent no-op (not yet checked).

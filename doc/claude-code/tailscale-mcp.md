# Cloud sessions: LiteLLM MCP over Tailscale

Cloud (claude.ai/code) sessions reach the LGA LiteLLM MCP gateway (`100.113.111.37:4000`, tailnet only)
through a userspace Tailscale node. Code lives in `startup-script.md` (setup script, SessionStart hook,
user-scope MCP entry).

## Design

- The container joins the tailnet with an **ephemeral, pre-approved, tagged** auth key
  (`TAILSCALE_AUTH_KEY`, tag `tag:claude-code-remote`). `tailscaled` runs in userspace mode and reaches
  the control plane and DERP through the session's HTTPS proxy (`*.tailscale.com` is allowlisted). The
  proxy has no UDP, so DERP over HTTPS is the only data path.
- `socat` bridges `localhost:4000` to the gateway through `tailscale nc`. The bridge script waits
  for the tailnet before dialing, so socat can listen at once.
- A user-scope MCP entry (`/root/.claude.json`) points at `http://localhost:4000/mcp/` with
  `Authorization: Bearer ${LITELLM_API_KEY}`; the `${...}` is expanded at runtime, never written to disk.
- Tailnet ACL: gateway host tagged (AI Gateway), the Claude Code Remote tag may reach only the
  gateway, no allow-all rule, `rthomazel` may reach everything. Tagged nodes are not covered by user rules,
  so check the gateway host can still reach any node it needs.

## Startup race

The MCP client connects in parallel with SessionStart hooks and does not retry a failed first connect.
In the first test the hook spent ~13s on `apt-get install socat`, so the first connect got ECONNREFUSED.
Mitigations: tailscale and socat are installed by the setup script (cached), socat listens first, and
the bridge waits for the tailnet. Cold-start test: a request fired 0.3s after the hook started waited 8.3s
and returned 200. Timestamps are in `/var/log/tailscale-ccr.log` (`hook:` lines).

## Gotchas

- The auth key must be ephemeral/pre-approved/tagged on the key itself. A `?ephemeral=true&...` suffix on the
  key is rejected with `invalid key`.
- The hook matcher is `startup|resume|compact`. A resumed container keeps binaries and state but loses
  processes, so without `resume` nothing restarts them.
- `tailscale ping` (disco/TSMP) succeeds regardless of ACLs. Test ACLs with a TCP connect:
  `tailscale --socket=/var/run/tailscale-ccr.sock nc <ip> <port> </dev/null` (hangs if blocked).
- A tagged auth key creates nodes with the tag and no owner; it needs `tagOwners` for the tag.

## Checks

1. `tailscale status --json` shows `Self.Tags`.
2. `curl -H "Authorization: Bearer $LITELLM_API_KEY" localhost:4000/health/liveliness`.
3. ACL: TCP to `100.113.111.37:4000` connects; other ports and other nodes hang.
4. `/mcp` lists `litellm` connected without a manual reconnect.
5. `compact` is an idempotent no-op (not yet checked).

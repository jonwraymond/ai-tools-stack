# metatools-a2a

`metatools-a2a` is the **A2A reference server** in the ApertureStack stack. It
exposes the same tool ecosystem as **metatools-mcp**, but with A2A JSON-RPC,
REST, and SSE streaming surfaces.

![MCP vs A2A Surfaces](../assets/diagrams/protocol-surfaces-mcp-a2a.svg)

## Responsibilities

- Publish an A2A AgentCard
- Expose skills derived from `tooldiscovery`
- Execute tools via `toolexec` and stream task updates

## Key Interfaces

- `POST /a2a` — JSON-RPC `agent/invoke`, `agent/status`
- `GET /a2a/agent-card` — AgentCard document
- `GET /a2a/skills` — skill list
- `GET /a2a/tasks/{id}/events` — SSE task updates

## Dependencies

- `toolfoundation` — canonical model + adapters
- `tooldiscovery` — tool registry and docs
- `toolexec` — execution pipeline
- `toolprotocol` — A2A protocol binding

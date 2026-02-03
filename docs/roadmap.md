# ApertureStack Roadmap

**Date:** 2026-02-02
**Scope:** Consolidated multi-repo stack (toolfoundation, tooldiscovery, toolexec, toolexec-integrations, toolcompose, toolops, toolprotocol, metatools-mcp, metatools-a2a)

This is the **single source of truth** roadmap for the stack. `metatools-mcp` is a reference MCP server built from the components below.

## Current State
- Consolidation complete: the original tool* repos have been merged into the 8 core repos.
- MCP alignment: toolfoundation embeds the official MCP Go SDK and targets MCP **2025-11-25**.
- Progressive discovery: tooldiscovery provides search + progressive tool docs.
- Execution + sandboxing: toolexec provides run, code execution, and runtime backends (some backends are stubbed).
- Protocol primitives: toolprotocol contains transport/wire/content/task/stream/session/resource/prompt/elicit/discover.
- A2A reference server: metatools-a2a exposes AgentCard + task flow alongside metatools-mcp.

## Now (0-3 months)
- Protocol crosswalk + adapters: add canonical mappings and adapters for **A2A**, **OpenAI Agents**, **Anthropic**, and **Google Gemini**.
- Tool schema normalization: extend `CanonicalTool` to cover OpenAPI schema subsets and feature-loss reporting across adapters.
- Progressive discovery UX: align discovery outputs with MCP `search_tools`/`describe_tool` semantics and add deterministic paging + stable tool IDs across sources.
- Runtime truth table: document and test which toolexec runtime backends are production-ready vs scaffolded.
- Doc cleanup: archive historical consolidation PRDs and move all live roadmap content here.

## Next (3-6 months)
- Runtime backend parity: implement real execution for Kubernetes, gVisor, Kata, Firecracker, remote HTTP, and Temporal backends.
- Multi-tenant execution: enforce tenancy boundaries (authn/authz + per-tenant toolsets + runtime isolation).
- Protocol bindings: add A2A bindings (JSON-RPC + HTTP/REST; gRPC if needed) using toolprotocol/wire/transport primitives.
- Observable execution: ensure toolops observe/cache/health/resilience are wired end-to-end in metatools-mcp.

## Later (6+ months)
- Proxmox/LXC runtime backend (enterprise isolation).
- Policy-driven tool routing across heterogeneous backends (cost, latency, data locality).
- Tool registry federation across MCP + A2A + vendor agent frameworks.

## Definition of Done (Per Deliverable)
- Adapter: round-trip conversions with feature-loss warnings and tests per protocol.
- Runtime backend: a runnable integration test + error semantics + docs page.
- Protocol binding: end-to-end interoperability test with a reference client.
- Docs: a single canonical doc + 1 example + 1 diagram per new capability.

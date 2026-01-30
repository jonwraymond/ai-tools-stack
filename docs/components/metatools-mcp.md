# metatools-mcp

MCP server that exposes the tool stack via standardized MCP tools with a
progressive-disclosure flow.

## Motivation

- Provide a minimal, consistent MCP surface
- Keep discovery cheap and execution safe
- Enable pluggable search and optional code execution

## Core responsibilities

- Expose `search_tools`, `list_namespaces`
- Expose `describe_tool`, `list_tool_examples`
- Expose `run_tool`, `run_chain`
- Optionally expose `execute_code`
- Use the official MCP Go SDK

## Transport surface

- `stdio` (default): local clients/Claude Desktop.
- `streamable` (recommended HTTP): MCP spec 2025-03-26 with session management.
- `sse` (deprecated): legacy web clients.

See `metatools-mcp/docs/usage.md` for the full config/env matrix.

## Optional runtime integration

`execute_code` is enabled with the `toolruntime` build tag and selects a runtime
profile at startup:

- `dev` profile (default): unsafe subprocess backend.
- `standard` profile: Docker sandbox (set `METATOOLS_RUNTIME_PROFILE=standard`).
- `METATOOLS_DOCKER_IMAGE` overrides the sandbox image name.
- `METATOOLS_WASM_ENABLED=true` enables the WASM backend (wazero).
- `METATOOLS_RUNTIME_BACKEND=wasm` selects WASM for the standard profile.

## Example

```go
srv, _ := server.New(cfg)
_ = srv.Run(context.Background(), &mcp.StdioTransport{})
```

## Diagram


![Diagram](../assets/diagrams/component-metatools-mcp.svg)


## Usability notes

- Small tool surface reduces prompt complexity
- Schemas and examples are fetched on demand

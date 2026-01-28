# metatools-mcp

MCP server that exposes the tool stack via standardized MCP tools with a
progressive-disclosure flow.

## Core responsibilities

- Expose `search_tools`, `list_namespaces`
- Expose `describe_tool`, `list_tool_examples`
- Expose `run_tool`, `run_chain`
- Optionally expose `execute_code`
- Use the official MCP Go SDK

## Example

```go
srv, _ := server.New(cfg)
_ = srv.Run(context.Background(), &mcp.StdioTransport{})
```

## Diagram

```mermaid
flowchart LR
  A[metatools-mcp] --> B[toolindex]
  A --> C[tooldocs]
  A --> D[toolrun]
  A --> E[toolcode]
  E --> F[toolruntime]
```

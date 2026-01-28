# Stack Architecture

This stack is built around progressive disclosure and a clean separation of
schema, discovery, docs, execution, and transport.

## Progressive disclosure pipeline

```mermaid
sequenceDiagram
  participant Agent
  participant MCP as metatools-mcp
  participant Index as toolindex
  participant Docs as tooldocs
  participant Run as toolrun

  Agent->>MCP: search_tools(query)
  MCP->>Index: Search(query)
  Index-->>MCP: summaries
  MCP-->>Agent: summaries

  Agent->>MCP: describe_tool(id, schema)
  MCP->>Docs: DescribeTool(id, schema)
  Docs-->>MCP: tool schema
  MCP-->>Agent: schema

  Agent->>MCP: run_tool(id, args)
  MCP->>Run: Run(id, args)
  Run-->>MCP: result
  MCP-->>Agent: result
```

## Tool execution and runtime isolation

```mermaid
flowchart LR
  A[toolrun] --> B[toolruntime]
  B --> C[unsafe host]
  B --> D[docker]
  B --> E[kubernetes]
  B --> F[firecracker]
  B --> G[gvisor]
  B --> H[wasm]
```

## Search strategy layering

```mermaid
flowchart LR
  A[toolindex] --> B[toolsearch]
  B --> C[BM25]
  B --> D[future: semantic]
  B --> E[future: hybrid]
```

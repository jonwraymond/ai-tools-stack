# Stack Architecture

This stack is built around progressive disclosure and a clean separation of
schema, discovery, docs, execution, and transport.

## Layering model


![Stack Layering Model](../assets/diagrams/stack-layering-model.svg)


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


![Tool Execution and Runtime Isolation](../assets/diagrams/tool-exec-runtime-isolation.svg)


## Search strategy layering


![Search Strategy Layering](../assets/diagrams/search-strategy-layering.svg)


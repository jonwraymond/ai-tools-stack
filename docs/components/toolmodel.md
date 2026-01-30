# toolmodel

Canonical schema definitions for all tools. This is the source of truth for
IDs, schemas, tags, and backend bindings.

## Motivation

- Standardize tool definitions across the stack
- Align directly with MCP via the official Go SDK
- Keep schemas portable and validation deterministic

## Core types

- `Tool` (embeds MCP `mcp.Tool`, adds `Namespace`, `Version`, `Tags`)
- `ToolBackend` (execution binding: mcp, provider, local)
- `SchemaValidator` (input/output validation)

## JSON Schema Validation

toolmodel uses `github.com/google/jsonschema-go` (draft 2020-12) for schema
validation. The default validator accepts MCP-style schema maps and enforces
input/output validation for tool calls.

- **InputSchema/OutputSchema**: validated via `SchemaValidator`.
- **Dialects**: 2020-12 with draft-07 compatibility where possible.
- **External refs**: blocked by default to avoid network lookups.

## Example

```go
import (
  "github.com/jonwraymond/toolmodel"
  "github.com/modelcontextprotocol/go-sdk/mcp"
)

tool := toolmodel.Tool{
  Namespace: "github",
  Tool: mcp.Tool{
    Name:        "get_repo",
    Description: "Fetch repository metadata",
    InputSchema: map[string]any{
      "type": "object",
      "properties": map[string]any{
        "owner": {"type": "string"},
        "repo":  {"type": "string"},
      },
      "required": []string{"owner", "repo"},
    },
  },
  Tags: toolmodel.NormalizeTags([]string{"GitHub", "repos"}),
}

_ = tool.Validate()
```

## Diagram


![Diagram](../assets/diagrams/component-toolmodel.svg)


## Usability notes

- Schemas accept maps or JSON bytes
- Tags are normalized for fast search
- IDs are stable and human‑readable

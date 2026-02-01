# toolfoundation

Foundational layer providing canonical schema definitions and protocol-agnostic
format conversion. This repository contains the core data types that all other
ApertureStack components depend on.

## Packages

| Package | Purpose |
|---------|---------|
| `model` | Canonical MCP tool schema definitions, validation, backend bindings |
| `adapter` | Protocol-agnostic tool format conversion (MCP, OpenAI, Anthropic) |
| `version` | Semantic version parsing, constraints, compatibility matrices |

## Motivation

- Standardize tool definitions across the stack
- Align directly with MCP via the official Go SDK
- Enable multi-provider support without changing the MCP surface
- Keep schemas portable and validation deterministic

## model Package

The `model` package provides the canonical schema definitions for all tools.

### Core Types

- `Tool` (embeds MCP `mcp.Tool`, adds `Namespace`, `Version`, `Tags`)
- `ToolBackend` (execution binding: mcp, provider, local)
- `SchemaValidator` (input/output validation)

### Example

```go
import (
  "github.com/jonwraymond/toolfoundation/model"
  "github.com/modelcontextprotocol/go-sdk/mcp"
)

tool := model.Tool{
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
  Tags: model.NormalizeTags([]string{"GitHub", "repos"}),
}

_ = tool.Validate()
```

### Schema contracts

Canonical schema rules and JSON Schema requirements are documented here:

- [tool schemas](../library-docs-from-repos/toolfoundation/schemas.md)

## adapter Package

The `adapter` package enables bidirectional transformation between MCP, OpenAI,
and Anthropic tool definitions through a canonical intermediate representation.

### Core Types

| Type | Purpose |
|------|---------|
| `CanonicalTool` | Protocol-agnostic intermediate representation |
| `JSONSchema` | Superset of all supported schema features |
| `Adapter` | Interface for format-specific converters |
| `AdapterRegistry` | Thread-safe adapter management and conversion |
| `FeatureLossWarning` | Indicates unsupported features in target format |

### Example

```go
import (
  "github.com/jonwraymond/toolfoundation/adapter"
)

// Set up registry with all adapters
registry := adapter.NewRegistry()
registry.Register(adapter.NewMCPAdapter())
registry.Register(adapter.NewOpenAIAdapter())
registry.Register(adapter.NewAnthropicAdapter())

// Convert MCP tool to OpenAI format
result, err := registry.Convert(mcpTool, "mcp", "openai")
if err != nil {
  log.Fatal(err)
}

// Check for feature loss warnings
for _, w := range result.Warnings {
  log.Printf("Warning: %s", w)
}
```

### Feature Support Matrix

| Feature | MCP | OpenAI | Anthropic |
|---------|:---:|:------:|:---------:|
| `$ref/$defs` | Yes | No | No |
| `anyOf/oneOf/allOf` | Yes | No | Yes |
| `pattern` | Yes | Yes* | Yes |
| `enum/const` | Yes | Yes | Yes |

## Diagram

![toolfoundation component diagram](../assets/diagrams/component-toolfoundation.svg)

## Key Design Decisions

1. **MCP alignment**: Tool embeds official MCP SDK types
2. **Pure transforms**: Adapter conversions have no I/O or side effects
3. **Loss visibility**: Feature loss is tracked as warnings, not errors
4. **Minimal deps**: Foundation has minimal external dependencies
5. **Explicit versioning**: Compatibility rules are defined via `version.Matrix`

## version Package

The `version` package provides SemVer parsing, constraints, and compatibility
negotiation across stack components.

```go
import "github.com/jonwraymond/toolfoundation/version"

base := version.MustParse("v1.0.0")
current := version.MustParse("v1.2.3")

if current.Compatible(base) {
  fmt.Println("compatible")
}
```

## Links

- [Repository](https://github.com/jonwraymond/toolfoundation)
- [Docs index](../library-docs-from-repos/toolfoundation/index.md)
- [Tool schemas](../library-docs-from-repos/toolfoundation/schemas.md)
- [Design notes](../library-docs-from-repos/toolfoundation/design-notes.md)
- [User journey](../library-docs-from-repos/toolfoundation/user-journey.md)

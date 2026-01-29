# tooladapter

Protocol-agnostic tool format conversion library. Enables bidirectional
transformation between MCP, OpenAI, and Anthropic tool definitions through
a canonical intermediate representation.

## Position in the Stack

tooladapter sits between `toolmodel` (MCP-aligned definitions) and higher-level
components that need multi-provider support:

```
toolmodel --> tooladapter --> toolset --> metatools-mcp
    |              |
    v              v
  MCP-aligned    Protocol-agnostic
  definitions    conversion layer
```

**Dependency order (DAG):**

1. `toolmodel` - MCP-aligned tool definitions (foundation)
2. `tooladapter` - Protocol conversion (depends on toolmodel for alignment)
3. `toolset` - Tool composition (can export via tooladapter)
4. `metatools-mcp` - MCP server (can optionally wire toolset)

tooladapter does **not** change the MCP surface. It provides a normalization
layer that other components can use to support multiple LLM providers.

## Motivation

- Expose MCP tools to OpenAI/Anthropic clients without manual conversion
- Track feature loss during format conversion (warnings, not errors)
- Provide deterministic, pure data transforms (no I/O, no execution)
- Maintain minimal dependencies (only MCP SDK for MCP adapter)

## Core Types

| Type | Purpose |
|------|---------|
| `CanonicalTool` | Protocol-agnostic intermediate representation |
| `JSONSchema` | Superset of all supported schema features (2020-12 + draft-07) |
| `Adapter` | Interface for format-specific converters |
| `AdapterRegistry` | Thread-safe adapter management and conversion |
| `FeatureLossWarning` | Indicates unsupported features in target format |
| `ConversionError` | Wrapped error with adapter and direction context |

## Example

```go
import (
  "github.com/jonwraymond/tooladapter"
  "github.com/jonwraymond/tooladapter/adapters"
  "github.com/modelcontextprotocol/go-sdk/mcp"
)

// Set up registry with all adapters
registry := tooladapter.NewRegistry()
registry.Register(adapters.NewMCPAdapter())
registry.Register(adapters.NewOpenAIAdapter())
registry.Register(adapters.NewAnthropicAdapter())

// Convert MCP tool to OpenAI format
mcpTool := mcp.Tool{
  Name:        "get_weather",
  Description: "Get weather for a location",
  InputSchema: map[string]any{
    "type": "object",
    "properties": map[string]any{
      "location": map[string]any{"type": "string"},
    },
    "required": []any{"location"},
  },
}

result, err := registry.Convert(mcpTool, "mcp", "openai")
if err != nil {
  log.Fatal(err)
}

// Check for feature loss warnings
for _, w := range result.Warnings {
  log.Printf("Warning: %s", w)
}

openaiFunc := result.Tool.(adapters.OpenAIFunction)
```

## Feature Support

| Feature | MCP | OpenAI | Anthropic | Notes |
|---------|:---:|:------:|:---------:|-------|
| `$ref/$defs` | Yes | No | No | Schema references |
| `anyOf/oneOf/allOf` | Yes | No | Yes | Combinators |
| `not` | Yes | No | Yes | Schema negation |
| `pattern` | Yes | Yes* | Yes | Regex validation |
| `enum/const` | Yes | Yes | Yes | Value constraints |
| `min/max` constraints | Yes | Yes | Yes | Numeric/string bounds |
| `additionalProperties` | Yes | Yes | Yes | Extra properties control |

*OpenAI supports pattern in strict mode only.

## Diagram

![tooladapter component diagram](../assets/diagrams/component-tooladapter.svg)

## Key Design Decisions

1. **Pure transforms**: No I/O, no network, no tool execution
2. **Determinism**: Same input always produces same output
3. **Loss visibility**: Feature loss is tracked and reported as warnings
4. **Minimal deps**: OpenAI/Anthropic adapters use self-contained types
5. **Go idioms**: Errors support `Unwrap()`, registry is thread-safe

## Versioning and Propagation

tooladapter follows semantic versioning aligned with the stack:

- **Source of truth**: `ai-tools-stack/go.mod`
- **Version matrix**: `VERSIONS.md` (auto-generated, synced to all repos)
- **Propagation**: `scripts/update-version-matrix.sh --apply`

Current version: See the stack version matrix in
[operations/stack-changelog.md](../operations/stack-changelog.md).

## Usability Notes

- All conversions are deterministic (enables caching, testing)
- Feature loss generates warnings, not errors
- Round-trip preserves format-specific metadata via `SourceMeta`
- Thread-safe: registry operations safe under concurrent use
- Type-safe: adapters reject wrong input types with descriptive errors

## Links

- [Repository](https://github.com/jonwraymond/tooladapter)
- [Library Docs](../library-docs-from-repos/tooladapter/index.md) (via multirepo import)

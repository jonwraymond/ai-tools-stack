# toolset

Composable tool collection library for building curated tool surfaces.

## Position in the Stack

toolset sits after `tooladapter` and before server exposure:

```
toolmodel --> tooladapter --> toolset --> metatools-mcp
```

- `tooladapter` normalizes tools into canonical form.
- `toolset` composes and filters tool collections.
- `metatools-mcp` can optionally expose a filtered toolset.

## Motivation

- Build curated tool sets for specific audiences or capabilities
- Enforce safety via filters and policies
- Export to multiple formats (MCP/OpenAI/Anthropic) via adapters

## Core Types

| Type | Purpose |
|------|---------|
| `Toolset` | Thread-safe collection of canonical tools |
| `Builder` | Fluent builder for filters/policies |
| `FilterFunc` | Reusable filter predicate |
| `Policy` | Hard allow/deny decisions |
| `Exposure` | Export to MCP/OpenAI/Anthropic via adapters |

## Example

```go
safeSet, err := toolset.NewBuilder("mcp-safe").
  FromTools(allTools).
  WithNamespace("mcp").
  WithTags([]string{"safe"}).
  ExcludeTools([]string{"mcp:execute"}).
  Build()
```

## Diagram

![toolset component diagram](../assets/diagrams/component-toolset.svg)

## Versioning and Propagation

- Source of truth: `ai-tools-stack/go.mod`
- Version matrix: `VERSIONS.md` (auto-synced)
- Propagation: `scripts/update-version-matrix.sh --apply`

## Links

- [Repository](https://github.com/jonwraymond/toolset)
- [Library Docs](../toolset/index.md) (via multirepo import)

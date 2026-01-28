# toolindex

Global registry and search layer for tools. Provides progressive discovery and
canonical lookup by tool ID.

## Motivation

- Keep discovery fast and cheap
- Decouple search quality from core registry
- Provide a single source of truth for tool IDs and backends

## Core responsibilities

- Register tools + backends
- Search by name/namespace/description/tags
- List namespaces
- Resolve tools by canonical ID

## Example

```go
idx := toolindex.NewInMemoryIndex()

_ = idx.RegisterTool(tool, backend)

summaries, _ := idx.Search("repo", 5)
for _, s := range summaries {
  fmt.Println(s.ID, s.ShortDescription)
}
```

## Diagram

```mermaid
flowchart LR
  A[toolindex] --> B[Searcher]
  B --> C[lexical]
  B --> D[toolsearch BM25]
  A --> E[tooldocs]
  A --> F[toolrun]
```

## Usability notes

- Summaries are token-cheap
- Namespace listing enables simple filtering
- Backends are swappable without changing IDs

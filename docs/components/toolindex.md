# toolindex

Global registry and search layer for tools. Provides progressive discovery and
canonical lookup by tool ID.

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

## Integration note

`toolindex` is the discovery backbone for `metatools-mcp`.

# End-to-End Example

This example shows the full flow:

1. Define a tool
2. Register it + docs
3. Discover and describe it
4. Execute it

It is intentionally small but exercises the core layers.

```go
package main

import (
  "context"
  "fmt"

  "github.com/modelcontextprotocol/go-sdk/mcp"

  "github.com/jonwraymond/toolfoundation/model"
  "github.com/jonwraymond/tooldiscovery/index"
  "github.com/jonwraymond/tooldiscovery/tooldoc"
  "github.com/jonwraymond/toolexec/exec"
)

func main() {
  ctx := context.Background()

  // 1) Define a tool
  tool := model.Tool{
    Tool: mcp.Tool{
      Name:        "add",
      Description: "Add two numbers",
      InputSchema: map[string]any{
        "type": "object",
        "properties": map[string]any{
          "a": map[string]any{"type": "number"},
          "b": map[string]any{"type": "number"},
        },
        "required": []string{"a", "b"},
      },
    },
    Namespace: "math",
    Tags:      []string{"math", "add"},
  }

  // 2) Create registry + docs
  idx := index.NewInMemoryIndex()
  docs := tooldoc.NewInMemoryStore(tooldoc.StoreOptions{Index: idx})

  // 3) Register tool + docs
  _ = idx.RegisterTool(tool, model.ToolBackend{Kind: model.BackendKindLocal, Local: &model.LocalBackend{Name: "math-add"}})
  _ = docs.RegisterDoc(tool.ToolID(), tooldoc.DocEntry{Summary: "Adds two numbers"})

  // 4) Create executor with local handler
  executor, _ := exec.New(exec.Options{
    Index: idx,
    Docs:  docs,
    LocalHandlers: map[string]exec.Handler{
      "math-add": func(_ context.Context, args map[string]any) (any, error) {
        return args["a"].(float64) + args["b"].(float64), nil
      },
    },
  })

  // 5) Discover
  summaries, _ := idx.Search("add", 3)
  fmt.Println("summaries", summaries)

  // 6) Describe
  doc, _ := docs.DescribeTool(tool.ToolID(), tooldoc.DetailSchema)
  fmt.Println("doc", doc.Summary)

  // 7) Execute
  result, _ := executor.RunTool(ctx, tool.ToolID(), map[string]any{"a": 2.0, "b": 3.0})
  fmt.Println("result", result.Value)
}
```

Notes:
- In real use, the registry often sits behind `metatools-mcp` or `metatools-a2a`.
- For server wiring, see `metatools-mcp/examples` and `metatools-a2a` docs.

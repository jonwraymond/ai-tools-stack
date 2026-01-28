# toolcode

Code-mode orchestration layer that wraps search, docs, and execution into a
single programmable surface.

## Motivation

- Enable conditional logic and multi-step orchestration
- Keep tool orchestration explicit and testable
- Provide call traces for debugging

## Core responsibilities

- Execute short orchestration snippets
- Provide a minimal in-sandbox API (SearchTools, DescribeTool, RunTool)
- Enforce timeouts and limits

## Example

```go
executor := toolcode.NewDefaultExecutor(toolcode.Config{
  Index:  idx,
  Docs:   docs,
  Run:    runner,
  Engine: engine,
})

res, _ := executor.ExecuteCode(ctx, toolcode.ExecuteParams{
  Language: "go",
  Code:     "__out = 2 + 2",
})
```

## Diagram


![Diagram](../assets/diagrams/component-toolcode.svg)


## Usability notes

- `ExecuteResult` includes tool call traces
- Limits are enforced consistently across engines

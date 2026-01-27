# ai-tools-stack

Release-train and integration control point for the `jonwraymond` MCP tool
libraries.

This repo exists to stop version sprawl from becoming chaos. It pins tagged
versions, runs a cross-library smoke test, and gives you one place to verify
that the stack still composes before you start bumping downstream repos.

## What this validates

The smoke test in `smoke_test.go` verifies that these layers still compose:

- `toolindex` discovery (with `toolsearch` BM25 injection)
- `tooldocs` progressive detail
- `toolrun` execution
- `toolcode` orchestration
- `toolruntime` adapter integration

## Current pinned versions

These should reflect the current release train:

- `github.com/jonwraymond/toolmodel` `v0.1.0`
- `github.com/jonwraymond/toolindex` `v0.1.2`
- `github.com/jonwraymond/tooldocs` `v0.1.2`
- `github.com/jonwraymond/toolrun` `v0.1.1`
- `github.com/jonwraymond/toolcode` `v0.1.1`
- `github.com/jonwraymond/toolruntime` `v0.1.1`
- `github.com/jonwraymond/toolsearch` `v0.1.1`

## Release-train bump order (DAG-aware)

Always bump in this order unless you have a very good reason not to:

1) `toolmodel`
2) `toolindex`
3) `tooldocs` and `toolrun`
4) `toolcode`
5) `toolruntime`
6) `metatools-mcp`

This repo sits between steps 2 and 3+ as your control point.

## Recommended bump workflow

When you cut a new tag in any upstream module:

1) Update it here first:

```bash
go get github.com/jonwraymond/toolindex@v0.1.3
go mod tidy
go test ./...
```

2) If green, bump the next downstream modules.

3) Only tag downstream repos when you actually need the change.

## Local verification

```bash
go test ./...
go vet ./...
go list -m all | rg jonwraymond
```


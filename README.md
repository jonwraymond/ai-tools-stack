# ai-tools-stack

This repo is the release-train control point for the `jonwraymond` tool stack.
It exists to contain version sprawl and chain effects.

It does three things:

- Pins tagged versions across the DAG.
- Runs a cross-library smoke test (`smoke_test.go`).
- Provides the canonical bump order and workflow.

## What the smoke test covers

`smoke_test.go` checks that the full stack still composes:

- `toolindex` discovery (with `toolsearch` BM25 injection)
- `tooldocs` progressive disclosure
- `toolrun` execution
- `toolcode` orchestration
- `toolruntime` engine adapter
- `metatools-mcp` type compatibility

This is intentionally integration-heavy and implementation-light.

## Version compatibility

See `VERSIONS.md` for the authoritative, auto-generated compatibility matrix.

## Documentation site

This repo also hosts the unified documentation site (MkDocs + multirepo) that
aggregates docs from all tool libraries and the MCP server.

Local build:

```bash
pip install -r requirements.txt
./scripts/prepare-mkdocs-multirepo.sh
mkdocs serve
```

## DAG-aware bump order (do not freestyle)

Always bump in this order unless you deliberately want to pay the blast radius:

1) `toolmodel`
2) `toolindex`
3) `tooldocs` and `toolrun`
4) `toolcode`
5) `toolruntime`
6) `metatools-mcp`

## Release workflow (the point of this repo)

When you cut or receive a new upstream tag:

1) Update it here first.
2) Run the integration gates here.
3) Only then cascade downstream bumps.
4) Only tag downstream repos when you actually need the change.

Example:

```bash
go get github.com/jonwraymond/toolindex@v0.1.3
go mod tidy
go test ./...
go vet ./...
```

If this repo is red, do not bump the DAG.

## Automation (from this repo)

Use the DAG-aware bump helper. It is dry-run by default:

```bash
./scripts/bump-dep.sh --dep toolindex --latest
./scripts/bump-dep.sh --dep toolindex --version v0.1.3 --apply
```

This updates impacted repos under `~/Documents/Projects`, runs `go mod tidy`,
`go test ./...`, and `go vet ./...`. It does not commit or tag for you.

## Operator checklist

Use this as a consistent release train checklist:

1) Upstream repo: merge, tag, push.
2) Here: bump with `go get`, then `go mod tidy`.
3) Here: run `go test ./...` and `go vet ./...`.
4) Here: wait for CI to go green.
5) Downstream: bump in DAG order.

## Local verification

```bash
go test ./...
go vet ./...
go list -m all | rg jonwraymond
```

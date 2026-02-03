# ai-tools-stack

[![Docs](https://img.shields.io/badge/docs-ai--tools--stack-blue)](https://jonwraymond.github.io/ai-tools-stack/)

This repo is the release-train control point for the ApertureStack tool ecosystem.
It exists to contain version sprawl and chain effects.

It does three things:

- Pins tagged versions across the DAG.
- Runs a cross-library smoke test (`smoke_test.go`).
- Provides the canonical bump order and workflow.

## Repository Structure

ApertureStack consists of 9 repositories:

| Repository | Description | Packages |
|------------|-------------|----------|
| [toolfoundation](https://github.com/jonwraymond/toolfoundation) | Core schemas, adapters, versioning | model, adapter, version |
| [tooldiscovery](https://github.com/jonwraymond/tooldiscovery) | Registry, search, semantic, docs | index, search, semantic, tooldoc |
| [toolexec](https://github.com/jonwraymond/toolexec) | Execution, runtime, orchestration | run, runtime, code, backend |
| [toolcompose](https://github.com/jonwraymond/toolcompose) | Toolsets, skills | set, skill |
| [toolops](https://github.com/jonwraymond/toolops) | Observability, caching, auth | observe, cache, auth, resilience, health |
| [toolprotocol](https://github.com/jonwraymond/toolprotocol) | MCP protocol support | transport, wire, discover, content, task, stream, session, elicit, resource, prompt |
| [metatools-mcp](https://github.com/jonwraymond/metatools-mcp) | MCP server application | — |
| [metatools-a2a](https://github.com/jonwraymond/metatools-a2a) | A2A server application | — |
| [ai-tools-stack](https://github.com/jonwraymond/ai-tools-stack) | This repo - docs & version matrix | — |

## What the smoke test covers

`smoke_test.go` checks that the full stack still composes:

- `tooldiscovery/index` discovery (with `tooldiscovery/search` BM25 injection)
- `tooldiscovery/tooldoc` progressive disclosure
- `toolexec/run` execution
- `toolexec/code` orchestration
- `toolexec/runtime` engine adapter
- `metatools-mcp` type compatibility
- `metatools-a2a` surface wiring (AgentCard + skills)

This is intentionally integration-heavy and implementation-light.

## Version compatibility

See `VERSIONS.md` for the authoritative compatibility matrix.

## Documentation site

This repo also hosts the unified documentation site (MkDocs + multirepo) that
aggregates docs from all tool libraries and the MCP server.

Local build:

```bash
pip install -r requirements.txt
./scripts/prepare-mkdocs-multirepo.sh
mkdocs serve
```

Versioned preview (mike):

```bash
pip install -r requirements.txt
./scripts/prepare-mkdocs-multirepo.sh
mike serve
```

## DAG-aware bump order (do not freestyle)

Always bump in this order unless you deliberately want to pay the blast radius:

1) `toolfoundation` (foundation layer)
2) `tooldiscovery` (discovery layer)
3) `toolexec` (execution layer)
4) `toolcompose` (composition layer)
5) `toolops` (operations layer)
6) `toolprotocol` (protocol layer)
7) `metatools-mcp` (application layer)
8) `metatools-a2a` (application layer)

## Release workflow (the point of this repo)

When you cut or receive a new upstream tag:

1) Update it here first.
2) Run the integration gates here.
3) Only then cascade downstream bumps.
4) Only tag downstream repos when you actually need the change.

Example:

```bash
go get github.com/jonwraymond/toolfoundation@v0.1.1
go mod tidy
go test ./...
go vet ./...
```

If this repo is red, do not bump the DAG.

## Automation (from this repo)

Use the DAG-aware bump helper. It is dry-run by default:

```bash
./scripts/bump-dep.sh --dep toolfoundation --latest
./scripts/bump-dep.sh --dep toolfoundation --version v0.1.1 --apply
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

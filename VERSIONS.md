# ApertureStack Version Matrix

## Consolidated Repositories

| Repository | Version | Packages |
|------------|---------|----------|
| toolfoundation | v0.1.0 | model, adapter, version |
| tooldiscovery | v0.1.0 | index, search, semantic, tooldoc |
| toolexec | v0.1.0 | run, runtime, code, backend |
| toolcompose | v0.1.0 | set, skill |
| toolops | v0.1.0 | observe, cache, auth, resilience, health |
| toolprotocol | v0.1.0 | transport, wire, discover, content, task, stream, session, elicit, resource, prompt |
| metatools-mcp | v0.5.0 | MCP server application |

## Compatibility Matrix

| metatools-mcp | toolfoundation | tooldiscovery | toolexec | toolcompose | toolops | toolprotocol |
|---------------|----------------|---------------|----------|-------------|---------|--------------|
| v0.5.0 | v0.1.0 | v0.1.0 | v0.1.0 | v0.1.0 | v0.1.0 | v0.1.0 |

## Archived Repositories

The following standalone repositories have been consolidated and archived (read-only):

| Old Repository | Migrated To | Import Path |
|----------------|-------------|-------------|
| toolmodel | toolfoundation/model | `github.com/jonwraymond/toolfoundation/model` |
| tooladapter | toolfoundation/adapter | `github.com/jonwraymond/toolfoundation/adapter` |
| toolindex | tooldiscovery/index | `github.com/jonwraymond/tooldiscovery/index` |
| toolsearch | tooldiscovery/search | `github.com/jonwraymond/tooldiscovery/search` |
| toolsemantic | tooldiscovery/semantic | `github.com/jonwraymond/tooldiscovery/semantic` |
| tooldocs | tooldiscovery/tooldoc | `github.com/jonwraymond/tooldiscovery/tooldoc` |
| toolrun | toolexec/run | `github.com/jonwraymond/toolexec/run` |
| toolruntime | toolexec/runtime | `github.com/jonwraymond/toolexec/runtime` |
| toolcode | toolexec/code | `github.com/jonwraymond/toolexec/code` |
| toolset | toolcompose/set | `github.com/jonwraymond/toolcompose/set` |
| toolskill | toolcompose/skill | `github.com/jonwraymond/toolcompose/skill` |
| toolobserve | toolops/observe | `github.com/jonwraymond/toolops/observe` |
| toolcache | toolops/cache | `github.com/jonwraymond/toolops/cache` |

See individual archived repos for MIGRATION.md with detailed migration instructions.

---

Generated: 2026-01-31

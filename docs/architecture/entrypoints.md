# Entrypoints

This page summarizes the recommended entrypoints for each layer of the stack.
Use the facade packages unless you need lower-level control.

| Use case | Recommended entrypoint | Why | If you need more control |
|---|---|---|---|
| Define tools + schemas | `toolfoundation/model` | Canonical MCP-aligned types + validation | `toolfoundation/adapter`, `toolfoundation/version` |
| Convert between tool protocols | `toolfoundation/adapter` | Bidirectional MCP/A2A/OpenAI/Anthropic/Gemini conversion | Implement a custom `adapter.Adapter` |
| Register + discover tools | `tooldiscovery/index` | Registry + search orchestration | Implement a custom `index.Searcher` |
| Progressive tool docs | `tooldiscovery/tooldoc` | Summary/schema/full detail levels | Custom `tooldoc.Store` |
| Search (lexical/BM25) | `tooldiscovery/search` | BM25 production search | Custom `index.Searcher` |
| Semantic/hybrid search | `tooldiscovery/semantic` or `tooldiscovery/discovery` | Embeddings + hybrid scoring | Custom `semantic.Embedder` |
| Unified discovery API | `tooldiscovery/discovery` | Convenience facade | Mix `index` + `tooldoc` directly |
| Execute tools + chains | `toolexec/run` | Validation + backend dispatch + chaining | `toolexec/backend`, custom executors |
| Unified exec + discovery | `toolexec/exec` | Single facade for index/docs/run | Compose `index` + `tooldoc` + `run` yourself |
| Code orchestration | `toolexec/code` | Execute code with tool access | Custom `code.Engine` |
| Runtime isolation | `toolexec/runtime` | Security profiles + sandbox backends | Backend-specific packages |
| Runtime integrations | `toolexec-integrations/*` | Concrete runtime clients | Provide your own SDK client |
| Compose toolsets | `toolcompose/set` | Filtered collections + exposure | Custom `set.Policy` |
| Skills/workflows | `toolcompose/skill` | Declarative multi-step skills | Custom `skill.Guard` or `skill.Runner` |
| Observability | `toolops/observe` | Tracing/metrics/logging | Custom exporters/logger |
| AuthN/AuthZ | `toolops/auth` | Authenticator + authorizer primitives | Custom `auth.Authenticator` |
| Caching | `toolops/cache` | Deterministic cache keys + cache API | Custom `cache.Cache` |
| Protocol + transport | `toolprotocol` | Wire/transport/session/resources | Implement `transport.Transport` |
| MCP server | `metatools-mcp` | Opinionated MCP surface | Build your own server with toolprotocol |
| A2A server | `metatools-a2a` | Opinionated A2A surface | Build your own server with toolprotocol |

## Quick decisions

- If you need **basic discovery + execution**, start with `toolexec/exec`.
- If you need **server wiring**, use `metatools-mcp` or `metatools-a2a` (or `toolprotocol` for custom servers).
- If you need **progressive disclosure**, use `tooldiscovery/tooldoc` with `tooldiscovery/index`.
- If you need **sandboxed code execution**, pair `toolexec/code` with `toolexec/runtime`.

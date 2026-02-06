# Stack Map (Repos, Packages, Interfaces)

This page summarizes **what each repo is for** and the primary interfaces that make the stack composable. It is the quickest way to see how pieces fit together and where to extend the system.

## toolfoundation (Schemas + Canonical Tool Model)
Purpose: canonical tool representation, schema validation, adapter registry, versioning.

Key packages:
- `model` (MCP-aligned tool model + tags + backend binding)
- `adapter` (protocol adapters and canonical tool)
- `version` (stack version utilities)

Key interfaces:
- `SchemaValidator` (model)
- `Adapter` (adapter)

## tooldiscovery (Index + Search + Progressive Docs)
Purpose: tool registry, search strategies, and progressive documentation levels.

Key packages:
- `index` (registry + search interfaces)
- `search` (BM25 search)
- `semantic` (embedding-based search)
- `tooldoc` (progressive disclosure)
- `discovery` (composite facade)

Key interfaces:
- `Index`, `Searcher`, `DeterministicSearcher`, `ChangeNotifier`, `Refresher` (index)
- `Indexer`, `Strategy`, `Embedder`, `Searcher` (semantic)
- `Store` (tooldoc)

## toolexec (Execution + Runtime Isolation)
Purpose: validated tool execution across local, provider, and MCP backends; runtime isolation.

Key packages:
- `run` (tool invocation + chaining)
- `backend` (backend registry + aggregator)
- `code` (code execution engine)
- `runtime` (sandboxed execution backends)

Key interfaces:
- `MCPExecutor`, `ProviderExecutor`, `Runner`, `ProgressRunner`, `LocalRegistry` (run)
- `Backend`, `ConfigurableBackend`, `StreamingBackend` (backend)
- `Executor`, `Engine`, `Tools` (code)
- `Runtime`, `Backend`, `ToolGateway` (runtime)

## toolexec-integrations (Runtime Clients)
Purpose: concrete runtime client implementations (Kubernetes, Proxmox, remote HTTP).

Key packages:
- `kubernetes` (client-go PodRunner/HealthChecker)
- `proxmox` (HTTP API client for LXC)
- `remotehttp` (HTTP/SSE client for remote runtime service)

Key interfaces implemented:
- `kubernetes.PodRunner`, `kubernetes.HealthChecker`
- `proxmox.APIClient`
- `remote.RemoteClient`

## toolcompose (Toolsets + Skills)
Purpose: composition of tools into sets/skills with policy and guardrails.

Key packages:
- `set` (registry and policy)
- `skill` (skill execution and guards)

Key interfaces:
- `Registry`, `Policy` (set)
- `Guard`, `Runner` (skill)

## toolops (Auth + Cache + Observe + Health)
Purpose: operational concerns for tool execution and serving.

Key packages:
- `auth` (authn/authz)
- `cache` (tool result caching)
- `observe` (tracing/metrics/logging)
- `health` (health checks)
- `resilience` (retry/circuit/bulkhead utilities)

Key interfaces:
- `Authenticator`, `Authorizer`, `APIKeyStore`, `KeyProvider` (auth)
- `Cache`, `Keyer` (cache)
- `Observer`, `Tracer`, `Metrics`, `Logger` (observe)
- `Checker`, `PingChecker`, `InfoChecker` (health)

## toolops-integrations (Operational Integrations)
Purpose: concrete, opt-in integrations for `toolops` (secret managers and vendor SDK adapters).

Key packages:
- `secret/bws` (Bitwarden Secrets Manager provider)

Key interfaces implemented:
- `secret.Provider`

## toolprotocol (Protocol Primitives)
Purpose: protocol-agnostic primitives for transport/wire/content/task/streaming.

Key packages:
- `transport` (server + transport contracts)
- `wire` (encoding/decoding)
- `discover` (discovery primitives)
- `content` (content payloads)
- `task` (task state machine)
- `stream` (streaming primitives)
- `session` (session storage)
- `resource` (resource providers/subscribers)
- `prompt` (prompt providers)
- `elicit` (elicitation protocol)

Key interfaces:
- `Transport`, `Server` (transport)
- `Wire` (wire)
- `Discovery`, `Discoverable` (discover)
- `Content` (content)
- `Manager`, `Store` (task)
- `Stream`, `Source`, `Sink` (stream)
- `Store` (session)
- `Provider`, `Subscriber` (resource)
- `Provider` (prompt)
- `Elicitor`, `Handler` (elicit)

## metatools-mcp (Reference MCP Server)
Purpose: MCP server that wires the stack together; reference implementation.

Key interfaces:
- `ToolProvider`, `ConfigurableProvider`, `StreamingProvider` (provider)
- `Index`, `Store`, `Runner`, `ProgressRunner`, `Executor` (handlers)
- `Transport`, `Server` (transport)

## metatools-a2a (Reference A2A Server)
Purpose: A2A server that wires the stack together; reference implementation.

Key interfaces:
- `Agent`, `InvokeResult` (toolprotocol/a2a)
- `Index`, `Discovery`, `Runner` (discovery + execution)
- `Task.Manager` (task streaming)

## How It Fits Together (Conceptual)
- `toolfoundation` defines canonical data and adapters.
- `tooldiscovery` finds tools and serves progressive docs.
- `toolexec` validates and runs tools across backends and runtimes.
- `toolexec-integrations` supplies opt-in runtime SDK clients.
- `toolcompose` builds toolsets/skills and applies policies.
- `toolops` adds security, caching, and observability.
- `toolops-integrations` supplies opt-in operational integrations (for example secret providers).
- `toolprotocol` standardizes transports and protocol primitives.
- `metatools-mcp` exposes everything via MCP as a reference server.
- `metatools-a2a` exposes everything via A2A as a reference server.

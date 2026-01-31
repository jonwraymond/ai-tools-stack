# toolops

Operations layer providing observability, caching, authentication, health checks,
and resilience patterns. This repository contains cross-cutting concerns for
production deployments.

## Packages

| Package | Purpose |
|---------|---------|
| `observe` | OpenTelemetry-based tracing, metrics, and logging |
| `cache` | Deterministic caching with pluggable backends |
| `auth` | Authentication and authorization middleware |
| `health` | Health check endpoints and probes |
| `resilience` | Circuit breakers, retries, and rate limiting |

## Motivation

- Provide production-ready observability out of the box
- Enable caching to reduce execution latency and costs
- Support authentication across different providers
- Expose health checks for orchestration platforms
- Handle transient failures gracefully

## observe Package

The `observe` package provides OpenTelemetry-based observability middleware.

### Features

- Distributed tracing with span attributes
- Prometheus-compatible metrics
- Structured logging with tool context
- OTLP export support

### Example

```go
import (
  "context"
  "log"

  "github.com/jonwraymond/toolops/observe"
)

obs, err := observe.NewObserver(ctx, observe.Config{
  ServiceName: "metatools-mcp",
  Tracing:     observe.TracingConfig{Enabled: true, Exporter: "otlp"},
  Metrics:     observe.MetricsConfig{Enabled: true, Exporter: "prometheus"},
  Logging:     observe.LoggingConfig{Enabled: true, Level: "info"},
})
if err != nil {
  log.Fatal(err)
}
defer obs.Shutdown(ctx)

mw, _ := observe.MiddlewareFromObserver(obs)
wrapped := mw.Wrap(func(ctx context.Context, tool observe.ToolMeta, input any) (any, error) {
  return map[string]any{"ok": true}, nil
})

_, _ = wrapped(ctx, observe.ToolMeta{Name: toolID}, args)
```

### Metrics Emitted

| Metric | Type | Description |
|--------|------|-------------|
| `tool.exec.total` | Counter | Total tool executions |
| `tool.exec.duration` | Histogram | Execution duration (ms) |
| `tool.exec.errors` | Counter | Failed executions |

## cache Package

The `cache` package provides deterministic caching with pluggable backends.

### Features

- Content-addressable caching (hash of tool + args)
- TTL and size-based eviction
- Pluggable backends (memory, Redis, file)
- Cache invalidation patterns

### Example

```go
import (
  "context"

  "github.com/jonwraymond/toolops/cache"
)

policy := cache.DefaultPolicy()
c := cache.NewMemoryCache(policy)
keyer := cache.NewDefaultKeyer()
mw := cache.NewCacheMiddleware(c, keyer, policy, nil)

result, err := mw.Execute(ctx, toolID, args, []string{"cacheable"}, func(ctx context.Context, toolID string, input any) ([]byte, error) {
  return []byte("{\"ok\":true}"), nil
})
```

## auth Package

The `auth` package provides authentication and authorization middleware.

### Features

- Multiple auth providers (API keys, JWT, OAuth)
- Per-namespace authorization rules
- Rate limiting per identity
- Audit logging

### Example

```go
import (
  "context"

  "github.com/jonwraymond/toolops/auth"
)

authenticator := auth.NewJWTAuthenticator(auth.JWTConfig{Issuer: "issuer"})
authorizer := auth.NewSimpleRBACAuthorizer(auth.RBACConfig{
  DefaultRole: "reader",
  Roles: map[string]auth.RoleConfig{
    "reader": {AllowedTools: []string{"github:*"}, AllowedActions: []string{"list"}},
  },
})

req := &auth.AuthRequest{Headers: map[string][]string{"Authorization": {"Bearer token"}}}
result, _ := authenticator.Authenticate(ctx, req)
if result != nil && result.Identity != nil {
  _ = authorizer.Authorize(ctx, &auth.AuthzRequest{
    Subject:  result.Identity,
    Resource: "tool:github:list_issues",
    Action:   "list",
  })
}
```

## health Package

The `health` package provides health check endpoints and probes.

### Features

- Kubernetes-compatible probes (liveness, readiness)
- Dependency health checks
- Graceful degradation reporting

### Example

```go
import (
  "context"

  "github.com/jonwraymond/toolops/health"
)

agg := health.NewAggregator()
agg.Register("memory", health.NewMemoryChecker(health.MemoryCheckerConfig{
  WarningThreshold:  0.80,
  CriticalThreshold: 0.95,
}))

results := agg.CheckAll(ctx)
overall := agg.OverallStatus(results)
_ = overall
```

## resilience Package

The `resilience` package provides circuit breakers, retries, and rate limiting.

### Features

- Circuit breaker with configurable thresholds
- Exponential backoff retries
- Token bucket rate limiting
- Bulkhead isolation

### Example

```go
import (
  "context"
  "time"

  "github.com/jonwraymond/toolops/resilience"
)

executor := resilience.NewExecutor(
  resilience.WithCircuitBreaker(resilience.NewCircuitBreaker(resilience.CircuitBreakerConfig{
    MaxFailures:  5,
    ResetTimeout: 30 * time.Second,
  })),
  resilience.WithRetry(resilience.NewRetry(resilience.RetryConfig{
    MaxAttempts: 3,
  })),
  resilience.WithTimeout(5*time.Second),
)

_ = executor.Execute(ctx, func(ctx context.Context) error {
  return nil
})
```

## Diagram

![toolops component diagram](../assets/diagrams/component-toolops.svg)

## Middleware Chain

```mermaid
flowchart LR
    Request --> Auth["auth"]
    Auth --> RateLimit["resilience"]
    RateLimit --> Cache["cache"]
    Cache --> Observe["observe"]
    Observe --> Runner["toolexec/run"]
    Runner --> Response
```

## Key Design Decisions

1. **Middleware pattern**: Observe/cache wrap execution functions
2. **Composable**: Patterns stack in a deterministic order
3. **Explicit wiring**: No implicit instrumentation or caching
4. **Standards-based**: OpenTelemetry, Prometheus, K8s probes

## Links

- [Repository](https://github.com/jonwraymond/toolops)
- [observe docs](../library-docs-from-repos/toolops/observe/index.md)
- [cache docs](../library-docs-from-repos/toolops/cache/index.md)
- [auth docs](../library-docs-from-repos/toolops/auth/index.md)
- [health docs](../library-docs-from-repos/toolops/health/index.md)
- [resilience docs](../library-docs-from-repos/toolops/resilience/index.md)

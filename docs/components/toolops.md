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
import "github.com/jonwraymond/toolops/observe"

// Create middleware
mw := observe.NewMiddleware(observe.Config{
  ServiceName: "metatools-mcp",
  Tracing:     observe.TracingConfig{Enabled: true},
  Metrics:     observe.MetricsConfig{Enabled: true},
})

// Wrap runner
observedRunner := mw.Wrap(runner)

// Executions now emit traces and metrics
result, err := observedRunner.Run(ctx, toolID, args)
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
import "github.com/jonwraymond/toolops/cache"

// Create cache
c := cache.New(cache.Config{
  Backend: cache.NewMemoryBackend(1000),
  TTL:     5 * time.Minute,
})

// Wrap runner
cachedRunner := c.Wrap(runner)

// Subsequent calls with same args return cached result
result, err := cachedRunner.Run(ctx, toolID, args)
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
import "github.com/jonwraymond/toolops/auth"

// Create auth middleware
authMW := auth.NewMiddleware(auth.Config{
  Provider: auth.NewJWTProvider(jwtSecret),
  Rules: []auth.Rule{
    {Namespace: "admin:*", Require: "admin"},
  },
})

// Wrap server handler
authedHandler := authMW.Wrap(handler)
```

## health Package

The `health` package provides health check endpoints and probes.

### Features

- Kubernetes-compatible probes (liveness, readiness)
- Dependency health checks
- Graceful degradation reporting

### Example

```go
import "github.com/jonwraymond/toolops/health"

// Create health checker
checker := health.New(health.Config{
  Checks: []health.Check{
    health.DatabaseCheck(db),
    health.MCPServerCheck(mcpClient),
  },
})

// Register endpoints
http.Handle("/healthz", checker.LivenessHandler())
http.Handle("/readyz", checker.ReadinessHandler())
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
import "github.com/jonwraymond/toolops/resilience"

// Create resilient runner
resilientRunner := resilience.Wrap(runner, resilience.Config{
  CircuitBreaker: resilience.CBConfig{
    Threshold:   5,
    Timeout:     30 * time.Second,
  },
  Retry: resilience.RetryConfig{
    MaxAttempts: 3,
    Backoff:     resilience.ExponentialBackoff(100*time.Millisecond),
  },
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

1. **Middleware pattern**: All features wrap existing runners
2. **Composable**: Stack middlewares in any order
3. **Zero-cost when disabled**: Features have no overhead when off
4. **Standards-based**: OpenTelemetry, Prometheus, K8s probes

## Links

- [Repository](https://github.com/jonwraymond/toolops)
- [observe docs](../library-docs-from-repos/toolops/observe/index.md)
- [cache docs](../library-docs-from-repos/toolops/cache/index.md)
- [auth docs](../library-docs-from-repos/toolops/auth/index.md)
- [health docs](../library-docs-from-repos/toolops/health/index.md)
- [resilience docs](../library-docs-from-repos/toolops/resilience/index.md)

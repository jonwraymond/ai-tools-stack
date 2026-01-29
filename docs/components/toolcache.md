# toolcache

Caching primitives for tool execution and discovery.

## Motivation

- Reduce latency for idempotent tools
- Prevent redundant registry queries
- Provide deterministic caching semantics

## Core responsibilities

- Deterministic cache keying
- TTL and invalidation policies
- Read-through middleware for tool execution

## Position in the Stack

```
toolrun/toolindex --> toolcache --> backends
```

## Diagram

![Diagram](../assets/diagrams/component-toolcache.svg)

## Usability notes

- Default policy should avoid caching unsafe tools
- Cache backends are pluggable

## Links

- Repository: https://github.com/jonwraymond/toolcache
- Library docs: ../library-docs-from-repos/toolcache/index.md

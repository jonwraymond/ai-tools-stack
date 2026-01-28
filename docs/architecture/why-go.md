# Why Go

Go is a strong fit for this stack because it pairs high performance with a
simple concurrency model and a clean interface story.

## Advantages for this stack

### Compiled + fast startup
- Small binaries and quick startup times are ideal for MCP servers
- Predictable performance for low-latency tool calls

### Concurrency without complexity
- Goroutines and channels make async tool execution straightforward
- `context.Context` enables timeouts and cancellation across the stack

### Interface-first extensibility
- Each layer (`Searcher`, `Runner`, `Engine`, `Backend`) is interface-driven
- You can plug in new languages, providers, or runtimes without redesigning

### Operational simplicity
- Static binaries simplify deployment
- Works equally well in containers, VMs, or bare metal

## Summary

Go lets you build a composable system that is fast, concurrent, and easy to
extend. That is exactly what this stack needs.

# toolruntime

Sandbox/runtime abstraction for executing code securely. Provides multiple
backends with a single interface.

## Motivation

- Create an explicit trust boundary for code execution
- Swap isolation backends without changing APIs
- Apply security profiles consistently

## Core responsibilities

- Runtime interface + default implementation
- Backends (unsafe host, docker, kubernetes, gvisor, firecracker, wasm)
- Security profiles and execution limits

## WASM backend

`toolruntime` defines the WASM contracts in `backend/wasm` (Runner, ModuleLoader,
HealthChecker, StreamRunner). The `metatools-mcp` server provides a wazero-based
implementation and wires it into `execute_code` when the `toolruntime` build tag
is enabled.

## Example

```go
rt := toolruntime.NewDefaultRuntime(toolruntime.RuntimeConfig{
  Backends: map[toolruntime.SecurityProfile]toolruntime.Backend{
    toolruntime.ProfileDev: unsafe.New(unsafe.Config{Mode: unsafe.ModeSubprocess}),
  },
  DefaultProfile: toolruntime.ProfileDev,
})
```

## Diagram


![Diagram](../assets/diagrams/component-toolruntime.svg)


## Usability notes

- Profiles separate policy from implementation
- Backends are swappable per environment

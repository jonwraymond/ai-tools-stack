# toolskill

Skill composition primitives for reusable tool workflows.

## Motivation

- Provide a reusable workflow layer over tools
- Support deterministic planning and guardrails
- Expose higher-level skills via metatools-mcp

## Core responsibilities

- Declarative skill model
- Deterministic planning
- Guard and policy enforcement

## Position in the Stack

```
toolset + toolrun + toolobserve --> toolskill --> metatools-mcp
```

## Diagram

![Diagram](../assets/diagrams/component-toolskill.svg)

## Usability notes

- Skills are declarative data, not code
- Execution is delegated to toolrun

## Links

- Repository: https://github.com/jonwraymond/toolskill
- Library docs: ../library-docs-from-repos/toolskill/index.md

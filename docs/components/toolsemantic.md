# toolsemantic

Semantic indexing and retrieval for tools.

## Motivation

- Improve tool discovery beyond exact match
- Combine BM25 and embedding-based ranking
- Keep semantic search decoupled from storage

## Core responsibilities

- Define semantic document model
- Provide indexing and search interfaces
- Compose scoring strategies

## Position in the Stack

```
toolindex --> toolsemantic --> search strategies
```

## Diagram

![Diagram](../assets/diagrams/component-toolsemantic.svg)

## Usability notes

- Backends are pluggable and optional
- Deterministic ranking is required for stability

## Links

- Repository: https://github.com/jonwraymond/toolsemantic
- Library docs: ../library-docs-from-repos/toolsemantic/index.md

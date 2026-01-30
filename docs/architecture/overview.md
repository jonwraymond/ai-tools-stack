# Stack Architecture

This stack is built around progressive disclosure and a clean separation of
schema, discovery, docs, execution, and transport.

---

## System Context (C4 Level 1)

High-level view showing the ApertureStack and its external actors.

```mermaid
%%{init: {'theme': 'base', 'themeVariables': {'primaryColor': '#1a365d', 'primaryTextColor': '#fff', 'primaryBorderColor': '#2c5282', 'lineColor': '#4a5568', 'secondaryColor': '#2d3748', 'tertiaryColor': '#e2e8f0'}}}%%
flowchart TB
    subgraph external["External Systems"]
        Agent["🤖 AI Agent<br/><small>Claude, GPT, etc.</small>"]
        ExtMCP["📡 External MCP Servers<br/><small>GitHub, Filesystem, etc.</small>"]
        Backends["⚙️ Execution Backends<br/><small>Docker, K8s, WASM</small>"]
    end

    subgraph aperture["ApertureStack"]
        direction TB
        MCP["🔷 metatools-mcp<br/><small>MCP Server Surface</small>"]
    end

    subgraph observability["Observability"]
        OTLP["📊 OTLP Collector"]
        Prometheus["📈 Prometheus"]
        Jaeger["🔍 Jaeger"]
    end

    Agent -->|"MCP Protocol<br/>JSON-RPC"| MCP
    MCP -->|"Tool Calls"| ExtMCP
    MCP -->|"Code Execution"| Backends
    MCP -.->|"Traces"| OTLP
    MCP -.->|"Metrics"| Prometheus
    OTLP --> Jaeger

    style aperture fill:#1a365d,stroke:#2c5282,stroke-width:3px
    style external fill:#2d3748,stroke:#4a5568,stroke-width:2px
    style observability fill:#2f855a,stroke:#276749,stroke-width:2px
```

---

## Layering Model (All 14 Components)

Complete view of all stack components organized by architectural layer.

![Stack Layering Model](../assets/diagrams/stack-layering-model.svg)

```mermaid
%%{init: {'theme': 'base', 'themeVariables': {'primaryColor': '#2b6cb0', 'primaryTextColor': '#fff', 'lineColor': '#4a5568'}}}%%
flowchart TB
    subgraph surface["MCP Surface Layer"]
        direction LR
        metatools["🔷 metatools-mcp<br/><small>v0.4.0 • MCP Server</small>"]
    end

    subgraph composition["Composition Layer"]
        direction LR
        toolset["📦 toolset<br/><small>v1.0.1 • Filtered Collections</small>"]
        toolskill["🎯 toolskill<br/><small>v0.2.0 • Skill Workflows</small>"]
    end

    subgraph protocol["Protocol Layer"]
        direction LR
        tooladapter["🔄 tooladapter<br/><small>v0.2.0 • Format Conversion</small>"]
    end

    subgraph execution["Execution Layer"]
        direction LR
        toolrun["▶️ toolrun<br/><small>v0.3.0 • Execution + Chaining</small>"]
        toolcode["💻 toolcode<br/><small>v0.3.0 • Code Orchestration</small>"]
        toolruntime["🏃 toolruntime<br/><small>v0.2.1 • Runtime Isolation</small>"]
    end

    subgraph discovery["Discovery Layer"]
        direction LR
        toolindex["📇 toolindex<br/><small>v0.3.0 • Registry + Search</small>"]
        tooldocs["📚 tooldocs<br/><small>v0.2.0 • Progressive Docs</small>"]
        toolsearch["🔍 toolsearch<br/><small>v0.3.0 • BM25 Strategy</small>"]
        toolsemantic["🧠 toolsemantic<br/><small>v0.2.0 • Semantic Search</small>"]
    end

    subgraph foundation["Foundation Layer"]
        direction LR
        toolmodel["🧱 toolmodel<br/><small>v0.2.0 • Canonical Schema</small>"]
    end

    subgraph crosscutting["Cross-Cutting Concerns"]
        direction LR
        toolobserve["👁️ toolobserve<br/><small>v0.2.0 • Observability</small>"]
        toolcache["💾 toolcache<br/><small>v0.2.0 • Caching</small>"]
    end

    toolmodel --> toolindex
    toolmodel --> tooladapter
    toolmodel --> tooldocs
    toolmodel --> toolrun

    tooladapter --> toolset
    toolindex --> tooldocs
    toolindex --> toolrun
    toolsearch --> toolindex
    toolsemantic -.-> toolindex

    toolrun --> toolcode
    toolcode --> toolruntime
    toolset --> toolrun
    toolskill --> toolrun
    toolskill --> toolset

    toolindex --> metatools
    tooldocs --> metatools
    toolrun --> metatools
    toolcode --> metatools
    toolset --> metatools
    toolskill -.-> metatools

    toolobserve -.-> toolrun
    toolobserve -.-> metatools
    toolcache -.-> toolrun

    style surface fill:#2b6cb0,stroke:#2c5282,stroke-width:2px
    style composition fill:#6b46c1,stroke:#553c9a,stroke-width:2px
    style protocol fill:#d69e2e,stroke:#b7791f,stroke-width:2px
    style execution fill:#38a169,stroke:#276749,stroke-width:2px
    style discovery fill:#3182ce,stroke:#2c5282,stroke-width:2px
    style foundation fill:#718096,stroke:#4a5568,stroke-width:2px
    style crosscutting fill:#e53e3e,stroke:#c53030,stroke-width:2px
```

---

## Progressive Disclosure Pipeline

![Progressive Disclosure Pipeline](../assets/diagrams/progressive-disclosure.svg)

```mermaid
%%{init: {'theme': 'base', 'themeVariables': {'actorBkg': '#2b6cb0', 'actorTextColor': '#fff', 'actorBorder': '#2c5282'}}}%%
sequenceDiagram
    autonumber

    participant Agent as 🤖 AI Agent
    participant MCP as 🔷 metatools-mcp
    participant Index as 📇 toolindex
    participant Search as 🔍 toolsearch
    participant Docs as 📚 tooldocs
    participant Run as ▶️ toolrun

    rect rgb(43, 108, 176, 0.1)
        Note over Agent,Search: Phase 1: Discovery (Token-Cheap)
        Agent->>+MCP: search_tools("create issue", limit=5)
        MCP->>+Index: Search(query, limit)
        Index->>+Search: Search(docs, query, limit)
        Search-->>-Index: scored results
        Index-->>-MCP: Summary[] (no schemas)
        MCP-->>-Agent: summaries
    end

    rect rgb(214, 158, 46, 0.1)
        Note over Agent,Docs: Phase 2: Description (On-Demand)
        Agent->>+MCP: describe_tool("github:create_issue", "schema")
        MCP->>+Docs: DescribeTool(id, DetailSchema)
        Docs->>Index: GetTool(id)
        Index-->>Docs: Tool definition
        Docs-->>-MCP: ToolDoc with schema
        MCP-->>-Agent: full tool schema
    end

    rect rgb(56, 161, 105, 0.1)
        Note over Agent,Run: Phase 3: Execution (Validated)
        Agent->>+MCP: run_tool("github:create_issue", args)
        MCP->>+Run: Run(ctx, id, args)
        Run->>Run: ValidateInput(args)
        Run->>Run: ResolveBackend()
        Run->>Run: Execute via backend
        Run->>Run: ValidateOutput(result)
        Run-->>-MCP: RunResult
        MCP-->>-Agent: execution result
    end
```

---

## Tool Execution and Runtime Isolation

![Tool Execution and Runtime Isolation](../assets/diagrams/tool-exec-runtime-isolation.svg)

```mermaid
%%{init: {'theme': 'base', 'themeVariables': {'primaryColor': '#38a169'}}}%%
flowchart LR
    subgraph input["Input Phase"]
        A["📥 Receive<br/>ToolID + Args"]
    end

    subgraph validation1["Validation Phase 1"]
        B["✅ Validate<br/>Tool ID Format"]
        C["✅ Validate<br/>Input Schema"]
    end

    subgraph resolution["Resolution Phase"]
        D["🔍 Resolve<br/>Tool Definition"]
        E["🎯 Select<br/>Backend"]
    end

    subgraph execution["Execution Phase"]
        F{"Backend<br/>Type?"}
        G["🏠 Local<br/>Handler"]
        H["🔌 Provider<br/>Executor"]
        I["📡 MCP<br/>Server Call"]
    end

    subgraph normalization["Normalization Phase"]
        J["📤 Normalize<br/>Result"]
    end

    subgraph validation2["Validation Phase 2"]
        K["✅ Validate<br/>Output Schema"]
    end

    subgraph output["Output Phase"]
        L["📦 Return<br/>RunResult"]
    end

    A --> B --> C --> D --> E --> F
    F -->|local| G
    F -->|provider| H
    F -->|mcp| I
    G --> J
    H --> J
    I --> J
    J --> K --> L

    style input fill:#3182ce,stroke:#2c5282
    style validation1 fill:#38a169,stroke:#276749
    style resolution fill:#d69e2e,stroke:#b7791f
    style execution fill:#6b46c1,stroke:#553c9a
    style normalization fill:#e53e3e,stroke:#c53030
    style validation2 fill:#38a169,stroke:#276749
    style output fill:#3182ce,stroke:#2c5282
```

---

## Search Strategy Layering

![Search Strategy Layering](../assets/diagrams/search-strategy-layering.svg)

```mermaid
%%{init: {'theme': 'base', 'themeVariables': {'primaryColor': '#3182ce'}}}%%
flowchart TB
    subgraph query["Search Query"]
        Input["🔍 'create github issue'"]
    end

    subgraph index["toolindex"]
        Search["Index.Search(query, limit)"]
        Docs["SearchDoc[]<br/><small>ID, Name, Namespace,<br/>Description, Tags</small>"]
    end

    subgraph strategies["Search Strategies"]
        direction TB

        subgraph lexical["Lexical (Default)"]
            Simple["Simple substring<br/>matching"]
        end

        subgraph bm25["BM25 (toolsearch)"]
            BM["BM25Searcher"]
            Boosts["Field Boosts:<br/><small>name: 4x<br/>namespace: 2x<br/>tags: 1x</small>"]
            Bleve["Bleve Index"]
        end

        subgraph semantic["Semantic (toolsemantic)"]
            Embed["Embedder"]
            Vector["Vector Store"]
            Similarity["Cosine Similarity"]
        end
    end

    subgraph ranking["Ranking"]
        Score["📊 Score + Rank"]
        Dedup["🔄 Deduplicate"]
        Limit["✂️ Apply Limit"]
    end

    subgraph output["Results"]
        Results["Summary[]<br/><small>No schemas (token-cheap)</small>"]
    end

    Input --> Search
    Search --> Docs

    Docs --> Simple
    Docs --> BM --> Boosts --> Bleve
    Docs --> Embed --> Vector --> Similarity

    Simple --> Score
    Bleve --> Score
    Similarity --> Score

    Score --> Dedup --> Limit --> Results

    style strategies fill:#3182ce,stroke:#2c5282,stroke-width:2px
    style bm25 fill:#38a169,stroke:#276749
    style semantic fill:#6b46c1,stroke:#553c9a
    style ranking fill:#d69e2e,stroke:#b7791f
```

---

## Component Dependency Graph

Directed acyclic graph showing module dependencies and bump order.

```mermaid
%%{init: {'theme': 'base', 'themeVariables': {'primaryColor': '#4a5568'}}}%%
flowchart TD
    subgraph order1["Bump Order 1"]
        toolmodel["🧱 toolmodel"]
    end

    subgraph order2["Bump Order 2"]
        toolindex["📇 toolindex"]
        tooladapter["🔄 tooladapter"]
    end

    subgraph order3["Bump Order 3"]
        tooldocs["📚 tooldocs"]
        toolrun["▶️ toolrun"]
        toolset["📦 toolset"]
        toolsearch["🔍 toolsearch"]
        toolsemantic["🧠 toolsemantic"]
    end

    subgraph order4["Bump Order 4"]
        toolcode["💻 toolcode"]
        toolskill["🎯 toolskill"]
        toolobserve["👁️ toolobserve"]
        toolcache["💾 toolcache"]
    end

    subgraph order5["Bump Order 5"]
        toolruntime["🏃 toolruntime"]
    end

    subgraph order6["Bump Order 6"]
        metatools["🔷 metatools-mcp"]
    end

    toolmodel --> toolindex
    toolmodel --> tooladapter
    toolindex --> tooldocs
    toolindex --> toolrun
    toolindex --> toolsearch
    toolindex --> toolsemantic
    tooladapter --> toolset
    toolset --> toolrun
    toolrun --> toolcode
    toolrun --> toolskill
    toolrun --> toolobserve
    toolrun --> toolcache
    toolcode --> toolruntime

    toolindex --> metatools
    tooldocs --> metatools
    toolrun --> metatools
    toolcode --> metatools
    toolset --> metatools

    style order1 fill:#718096,stroke:#4a5568
    style order2 fill:#3182ce,stroke:#2c5282
    style order3 fill:#38a169,stroke:#276749
    style order4 fill:#d69e2e,stroke:#b7791f
    style order5 fill:#e53e3e,stroke:#c53030
    style order6 fill:#6b46c1,stroke:#553c9a
```

---

## Observability Integration

How toolobserve wraps around tool execution with traces, metrics, and logs.

```mermaid
%%{init: {'theme': 'base', 'themeVariables': {'primaryColor': '#e53e3e'}}}%%
flowchart TB
    subgraph client["Client Layer"]
        Request["📥 Tool Request"]
    end

    subgraph middleware["toolobserve Middleware"]
        direction TB
        MW["🔀 Middleware.Wrap()"]

        subgraph tracing["Tracing"]
            SpanStart["StartSpan<br/><small>tool.exec.{namespace}.{name}</small>"]
            SpanEnd["EndSpan"]
            SpanAttrs["Span Attributes<br/><small>tool.id, tool.namespace, tool.name<br/>tool.version, tool.category, tool.tags</small>"]
        end

        subgraph metrics["Metrics"]
            Counter["tool.exec.total<br/><small>{call} counter</small>"]
            Histogram["tool.exec.duration<br/><small>ms histogram</small>"]
        end

        subgraph logging["Structured Logging"]
            LogFields["Fields: tool.id, args (redacted)<br/>duration, error"]
        end
    end

    subgraph execution["Actual Execution"]
        Runner["▶️ toolrun.Runner"]
    end

    subgraph exporters["Exporters"]
        direction LR
        OTLP["📡 OTLP"]
        Jaeger["🔍 Jaeger"]
        Prometheus["📊 Prometheus"]
        Stdout["🖥️ Stdout"]
    end

    Request --> MW
    MW --> SpanStart --> SpanAttrs
    MW --> Counter
    SpanAttrs --> Runner
    Runner --> SpanEnd
    Runner --> Histogram

    SpanEnd --> OTLP
    SpanEnd --> Jaeger
    Histogram --> Prometheus
    Histogram --> OTLP

    style middleware fill:#e53e3e,stroke:#c53030,stroke-width:2px
    style tracing fill:#6b46c1,stroke:#553c9a
    style metrics fill:#38a169,stroke:#276749
    style logging fill:#3182ce,stroke:#2c5282
    style exporters fill:#d69e2e,stroke:#b7791f
```

package stack

import (
	"context"
	"encoding/json"
	"math"
	"testing"
	"time"

	"github.com/jonwraymond/metatools-mcp/pkg/metatools"
	"github.com/jonwraymond/tooldiscovery/index"
	"github.com/jonwraymond/tooldiscovery/search"
	"github.com/jonwraymond/tooldiscovery/tooldoc"
	"github.com/jonwraymond/toolexec/code"
	"github.com/jonwraymond/toolexec/run"
	"github.com/jonwraymond/toolexec/runtime"
	"github.com/jonwraymond/toolexec/runtime/toolcodeengine"
	"github.com/jonwraymond/toolfoundation/model"
	"github.com/modelcontextprotocol/go-sdk/mcp"
)

// localRegistry is a tiny LocalRegistry implementation for smoke tests.
type localRegistry map[string]run.LocalHandler

func (r localRegistry) Get(name string) (run.LocalHandler, bool) {
	h, ok := r[name]
	return h, ok
}

// gatewayBackend is a deterministic backend that exercises the tool gateway.
// It ignores the code snippet and calls a known tool through the gateway.
type gatewayBackend struct {
	toolID string
}

func (b gatewayBackend) Kind() runtime.BackendKind { return runtime.BackendUnsafeHost }

func (b gatewayBackend) Execute(ctx context.Context, req runtime.ExecuteRequest) (runtime.ExecuteResult, error) {
	runRes, err := req.Gateway.RunTool(ctx, b.toolID, map[string]any{
		"a": 1.0,
		"b": 2.0,
	})
	if err != nil {
		return runtime.ExecuteResult{}, err
	}
	return runtime.ExecuteResult{
		Value:   runRes.Structured,
		Backend: runtime.BackendInfo{Kind: b.Kind()},
	}, nil
}

func rawSchema(s string) json.RawMessage { return json.RawMessage(s) }

func toFloat(v any) (float64, bool) {
	switch n := v.(type) {
	case float64:
		return n, true
	case float32:
		return float64(n), true
	case int:
		return float64(n), true
	case int64:
		return float64(n), true
	case json.Number:
		f, err := n.Float64()
		return f, err == nil
	default:
		return 0, false
	}
}

func TestReleaseTrainSmoke(t *testing.T) {
	t.Parallel()

	ctx := context.Background()

	// 1) Index with BM25 searcher injected.
	idx := index.NewInMemoryIndex(index.IndexOptions{
		Searcher: search.NewBM25Searcher(search.BM25Config{}),
	})

	addTool := model.Tool{
		Tool: mcp.Tool{
			Name:        "add",
			Title:       "Add Numbers",
			Description: "Add two numbers together.",
			InputSchema: rawSchema(`{
				"type": "object",
				"properties": {
					"a": {"type": "number"},
					"b": {"type": "number"}
				},
				"required": ["a", "b"]
			}`),
			OutputSchema: rawSchema(`{
				"type": "object",
				"properties": {
					"sum": {"type": "number"}
				},
				"required": ["sum"]
			}`),
		},
		Namespace: "math",
		Tags:      []string{"math", "arithmetic", "add"},
	}

	addBackend := model.ToolBackend{
		Kind:  model.BackendKindLocal,
		Local: &model.LocalBackend{Name: "math-add"},
	}

	if err := idx.RegisterTools([]index.ToolRegistration{{
		Tool:    addTool,
		Backend: addBackend,
	}}); err != nil {
		t.Fatalf("RegisterTools() error = %v", err)
	}

	// 2) Docs store layered on the index.
	docs := tooldoc.NewInMemoryStore(tooldoc.StoreOptions{Index: idx})
	if err := docs.RegisterExamples(addTool.ToolID(), []tooldoc.ToolExample{
		{
			Title:       "Add small numbers",
			Description: "Adds 1 and 2.",
			Args: map[string]any{
				"a": 1,
				"b": 2,
			},
			ResultHint: "Returns {\"sum\": 3}.",
		},
	}); err != nil {
		t.Fatalf("RegisterExamples() error = %v", err)
	}

	// 3) Local runner wired to the same index.
	reg := localRegistry{
		"math-add": func(_ context.Context, args map[string]any) (any, error) {
			a, ok := toFloat(args["a"])
			if !ok {
				return nil, model.ErrInvalidSchema
			}
			b, ok := toFloat(args["b"])
			if !ok {
				return nil, model.ErrInvalidSchema
			}
			return map[string]any{"sum": a + b}, nil
		},
	}

	runner := run.NewRunner(
		run.WithIndex(idx),
		run.WithLocalRegistry(reg),
	)

	// 4) Progressive discovery still works.
	results, err := idx.Search("add numbers", 5)
	if err != nil {
		t.Fatalf("Search() error = %v", err)
	}
	if len(results) == 0 || results[0].ID != addTool.ToolID() {
		t.Fatalf("unexpected search results: %+v", results)
	}
	// The metatools MCP package should stay compatible with index summaries.
	limit := (&metatools.SearchToolsInput{Query: "add"}).GetLimit()
	if limit <= 0 {
		t.Fatalf("metatools limit = %d, want > 0", limit)
	}

	doc, err := docs.DescribeTool(addTool.ToolID(), tooldoc.DetailFull)
	if err != nil {
		t.Fatalf("DescribeTool() error = %v", err)
	}
	if doc.Tool.ToolID() != addTool.ToolID() || len(doc.Examples) == 0 {
		t.Fatalf("unexpected doc: %+v", doc)
	}

	// 5) Execution via run is aligned.
	runRes, err := runner.Run(ctx, addTool.ToolID(), map[string]any{"a": 1.0, "b": 2.0})
	if err != nil {
		t.Fatalf("Run() error = %v", err)
	}
	runMap, ok := runRes.Structured.(map[string]any)
	if !ok {
		t.Fatalf("Run().Structured type = %T, want map[string]any", runRes.Structured)
	}
	sum, ok := toFloat(runMap["sum"])
	if !ok || math.Abs(sum-3.0) > 1e-9 {
		t.Fatalf("Run() sum = %v, want 3", runMap["sum"])
	}

	// 6) code + runtime adapter still composes.
	rt := runtime.NewDefaultRuntime(runtime.RuntimeConfig{
		Backends: map[runtime.SecurityProfile]runtime.Backend{
			runtime.ProfileStandard: gatewayBackend{toolID: addTool.ToolID()},
		},
		DefaultProfile: runtime.ProfileStandard,
	})

	engine, err := toolcodeengine.New(toolcodeengine.Config{
		Runtime: rt,
		Profile: runtime.ProfileStandard,
	})
	if err != nil {
		t.Fatalf("toolcodeengine.New() error = %v", err)
	}

	exec, err := code.NewDefaultExecutor(code.Config{
		Index:          idx,
		Docs:           docs,
		Run:            runner,
		Engine:         engine,
		DefaultTimeout: 2 * time.Second,
	})
	if err != nil {
		t.Fatalf("NewDefaultExecutor() error = %v", err)
	}

	execRes, err := exec.ExecuteCode(ctx, code.ExecuteParams{
		Language: "go",
		Code:     "__out = \"ignored by gateway backend\"",
		Timeout:  time.Second,
	})
	if err != nil {
		t.Fatalf("ExecuteCode() error = %v", err)
	}
	execMap, ok := execRes.Value.(map[string]any)
	if !ok {
		t.Fatalf("ExecuteCode().Value type = %T, want map[string]any", execRes.Value)
	}
	execSum, ok := toFloat(execMap["sum"])
	if !ok || math.Abs(execSum-3.0) > 1e-9 {
		t.Fatalf("ExecuteCode() sum = %v, want 3", execMap["sum"])
	}
}

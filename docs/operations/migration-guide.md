# Migration Guide: Consolidated Repositories (v0.3.0)

This guide helps you migrate from the previous 14 standalone repositories to the
new 6 consolidated repositories introduced in v0.3.0.

## Overview of Changes

The ApertureStack tool framework has been reorganized to group related packages
by architectural concern:

| Old Repository | New Location | Import Path Change |
|---------------|--------------|-------------------|
| `toolmodel` | `toolfoundation/model` | `github.com/jonwraymond/toolfoundation/model` |
| `tooladapter` | `toolfoundation/adapter` | `github.com/jonwraymond/toolfoundation/adapter` |
| `toolindex` | `tooldiscovery/index` | `github.com/jonwraymond/tooldiscovery/index` |
| `tooldocs` | `tooldiscovery/tooldoc` | `github.com/jonwraymond/tooldiscovery/tooldoc` |
| `toolsearch` | `tooldiscovery/search` | `github.com/jonwraymond/tooldiscovery/search` |
| `toolsemantic` | `tooldiscovery/semantic` | `github.com/jonwraymond/tooldiscovery/semantic` |
| `toolrun` | `toolexec/run` | `github.com/jonwraymond/toolexec/run` |
| `toolcode` | `toolexec/code` | `github.com/jonwraymond/toolexec/code` |
| `toolruntime` | `toolexec/runtime` | `github.com/jonwraymond/toolexec/runtime` |
| `toolset` | `toolcompose/set` | `github.com/jonwraymond/toolcompose/set` |
| `toolskill` | `toolcompose/skill` | `github.com/jonwraymond/toolcompose/skill` |
| `toolobserve` | `toolops/observe` | `github.com/jonwraymond/toolops/observe` |
| `toolcache` | `toolops/cache` | `github.com/jonwraymond/toolops/cache` |

## Migration Steps

### 1. Update go.mod Dependencies

Replace old standalone dependencies with consolidated ones:

```bash
# Remove old dependencies
go mod edit -droprequire github.com/jonwraymond/toolmodel
go mod edit -droprequire github.com/jonwraymond/tooladapter
go mod edit -droprequire github.com/jonwraymond/toolindex
# ... repeat for all old repos

# Add consolidated dependencies
go get github.com/jonwraymond/toolfoundation@latest
go get github.com/jonwraymond/tooldiscovery@latest
go get github.com/jonwraymond/toolexec@latest
go get github.com/jonwraymond/toolcompose@latest
go get github.com/jonwraymond/toolops@latest
go get github.com/jonwraymond/toolprotocol@latest
```

### 2. Update Import Statements

Use your editor's find-and-replace or a tool like `gofmt` to update imports:

```go
// Before
import (
    "github.com/jonwraymond/toolmodel"
    "github.com/jonwraymond/toolindex"
    "github.com/jonwraymond/toolrun"
)

// After
import (
    "github.com/jonwraymond/toolfoundation/model"
    "github.com/jonwraymond/tooldiscovery/index"
    "github.com/jonwraymond/toolexec/run"
)
```

### 3. Update Package Aliases (if needed)

If you used short aliases, update them:

```go
// Before
import toolmodel "github.com/jonwraymond/toolmodel"

// After (same alias, new path)
import toolmodel "github.com/jonwraymond/toolfoundation/model"
```

### 4. Run Tests

After updating imports, run your test suite to verify everything works:

```bash
go mod tidy
go test ./...
```

## API Compatibility

All public APIs remain unchanged. The consolidation only affects import paths,
not function signatures or types. Your existing code should work after updating
the import statements.

## Benefits of Consolidation

1. **Simpler dependency management** - 6 repos instead of 14
2. **Clearer architecture** - Packages grouped by concern
3. **Easier versioning** - Related packages released together
4. **Better discoverability** - Find related functionality in one place

## Questions?

If you encounter issues during migration, please open an issue on the
[ai-tools-stack repository](https://github.com/jonwraymond/ai-tools-stack/issues).

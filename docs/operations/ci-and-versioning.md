# CI and Versioning

## CI checks

Each repo runs CI for:

- go vet
- go test
- lint + security (golangci-lint + gosec)

## Version alignment

- `ai-tools-stack/go.mod` is the source of truth.
- `VERSIONS.md` is generated in each repo and updated via:

```bash
scripts/update-version-matrix.sh --apply
```

## Dependency bumping

Use the DAG-aware bump tool:

```bash
scripts/bump-dep.sh --dep toolruntime --latest --apply
```

This updates all downstream repos and ai-tools-stack in order.

## Docs automation

The unified docs site is built from this repo using MkDocs + the multirepo plugin.
GitHub Actions runs on push to main and nightly (scheduled) to pull fresh docs
from the tool repos.

Versioned docs are published with `mike`:

- `latest` alias is deployed from `main`
- tag builds deploy versioned docs (for example, `v0.1.8`) and set `stable`

Local preview:

```bash
pip install -r requirements.txt
./scripts/prepare-mkdocs-multirepo.sh
mkdocs serve
```

Versioned preview:

```bash
pip install -r requirements.txt
./scripts/prepare-mkdocs-multirepo.sh
mike serve
```

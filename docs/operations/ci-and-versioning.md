# CI and Versioning

## CI checks

Each repo runs CI for:

- go vet
- go test
- lint + security (golangci-lint + gosec)

## Go module privacy (fast tag uptake)

CI sets:

- `GOPRIVATE=github.com/jonwraymond/*`
- `GONOSUMDB=github.com/jonwraymond/*`

This bypasses the public proxy/sumdb for the org’s modules so newly‑pushed tags
are immediately usable in CI and local workflows.

## Version alignment

- `ai-tools-stack/go.mod` is the source of truth.
- `VERSIONS.md` is generated in each repo and updated via:

```bash
scripts/update-version-matrix.sh --apply
```

### New modules (example: toolprotocol)

When a new module is added to the stack (for example `toolprotocol`), the propagation
steps are:

1) Tag the new module (`vX.Y.Z`).
2) Add it to `ai-tools-stack/go.mod` at the tagged version.
3) Run `scripts/update-version-matrix.sh --apply` to sync `VERSIONS.md` across repos.
4) Update `mkdocs.yml` to include the new module in **Components** and **Library Docs**.

## Dependency bumping

Use the DAG-aware bump tool:

```bash
scripts/bump-dep.sh --dep toolexec --latest --apply
```

This updates all downstream repos and ai-tools-stack in order.

## Docs automation

The unified docs site is built from this repo using MkDocs + the multirepo plugin.
GitHub Actions runs on push to main and nightly (scheduled) to pull fresh docs
from the tool repos.

Versioned docs are published with `mike`:

- `latest` alias is deployed from `main`
- tag builds deploy versioned docs (for example, `v0.1.8`) and set `stable`
- the version selector appears in the site header once at least one tag build exists

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

# toolops-integrations

**Purpose:** concrete integrations for `toolops` core, kept out of core to avoid heavy/optional dependencies.

## What it provides

- Secret provider implementations for `toolops/secret`
- Bitwarden Secrets Manager provider (`bws`) using `github.com/bitwarden/sdk-go`

## Why it exists

`toolops` is designed to stay dependency-light and portable. Integrations like secret managers, vendor SDKs, and platform clients are opt-in.

## Entrypoints

- `github.com/jonwraymond/toolops-integrations/secret/bws`

## Related

- [`toolops`](toolops.md)
- [`metatools-mcp`](metatools-mcp.md)
- [`stack map`](../architecture/stack-map.md)


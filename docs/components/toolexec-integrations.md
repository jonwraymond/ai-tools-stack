# toolexec-integrations

**Purpose:** concrete runtime client integrations for `toolexec` core.

## What it provides

- Kubernetes client‑go implementation of `kubernetes.PodRunner`
- Proxmox HTTP API client implementing `proxmox.APIClient`
- Remote HTTP/SSE client implementing `remote.RemoteClient`

## Why it exists

`toolexec` core is interface‑only for runtime backends. This repo holds the SDKs and HTTP stacks so downstream consumers can opt in to only what they need.

## Entrypoints

- `github.com/jonwraymond/toolexec-integrations/kubernetes`
- `github.com/jonwraymond/toolexec-integrations/proxmox`
- `github.com/jonwraymond/toolexec-integrations/remotehttp`

## Related

- [`toolexec`](toolexec.md)
- [`stack map`](../architecture/stack-map.md)

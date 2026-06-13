# SURIMI-terminal

Browser terminal sidecar for the SURIMI EDITO catalog services. Bundles `ttyd` (browser TTY),
`tmux`, `bash`, plus `kubectl` and `helm` for in-cluster admin tasks.

Used as a co-pod with `SURIMI-mcp` so partners can attach to a running deployment, inspect logs,
re-run the data loader, or test the MCP server interactively — all from a browser tab.

## Image

Published to `ghcr.io/official-ewe/surimiterminal` by GitHub Actions on every push to `master` and
on version tags (`v*`).

```
docker pull ghcr.io/official-ewe/surimiterminal:latest
```

The image is **public** — no authentication needed.

## Run

```
docker run -p 7681:7681 -e PASSWORD=secret ghcr.io/official-ewe/surimiterminal:latest
# Open http://localhost:7681 — log in as onyxia/secret
```

If `PASSWORD` is unset, ttyd runs without authentication (do not expose to the public internet
this way).

## What's inside

- `ttyd` — browser terminal on port 7681
- `tmux` — preconfigured with mouse + 50k history
- `kubectl`, `helm` — latest stable releases, fetched at build time
- `bash`, `sudo`, `openssh-server`, `htop`, `git`, `curl`, `wget`, `jq`, `vim-tiny`
- `python3`, `python3-pip`
- Network tools: `dnsutils`, `net-tools`, `iputils-ping`

The container runs as a non-root user `onyxia` with passwordless sudo, matching the Onyxia
convention used across the EDITO catalog.

## Connect via Tailscale SSH

In the browser terminal, run:

```
./connect
```

Paste a **one-shot** Tailscale auth key created with **tag:edito** at
https://login.tailscale.com/admin/settings/keys (input is hidden). The script downloads
Tailscale at runtime, joins the tailnet as `surimi-terminal`, and starts a shared tmux
session `work`. From the operator's box:

```
tailscale ssh onyxia@surimi-terminal
tailscale ssh onyxia@surimi-terminal -- tmux attach -t work
```

Gotcha: delete any stale `surimi-terminal` node in the Tailscale admin console first,
otherwise the pod joins as `surimi-terminal-1` and the hostname above won't match.

## NO Tailscale baked in

This image deliberately does **not** ship with the Tailscale binary. Only the inert
`connect` bootstrap script is included; the binary is downloaded at runtime by an operator
who supplies a key. Baking Tailscale into the image would be flagged by EDITO admins.

## Deployment

Helm chart:
`gitlab.mercator-ocean.fr/pub/edito-infra/service-playground/charts/surimi-terminal`

Also used as a sidecar in the `SURIMI-mcp` chart (path-based ingress: `/` → terminal, `/sse` → MCP).

## License

Apache-2.0

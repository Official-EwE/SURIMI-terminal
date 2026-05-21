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

## NO Tailscale

This image deliberately does **not** ship with Tailscale. Tailscale access is a manual paste-only
step by an operator; baking it into the image would be flagged by EDITO admins. See
`pure-claude/docs/deployment/terminal-tunnel-paste.sh` in the SURIMI-edito working repo.

## Deployment

Helm chart:
`gitlab.mercator-ocean.fr/pub/edito-infra/service-playground/charts/surimi-terminal`

Also used as a sidecar in the `SURIMI-mcp` chart (path-based ingress: `/` → terminal, `/sse` → MCP).

## License

Apache-2.0

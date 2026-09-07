# iperf-server

A lightweight, multi-architecture Docker image running `iperf3` / `iperf` based on Alpine Linux.

## Quick Start

### Docker Compose

Run the service with docker compose using the provided [compose.yaml](compose.yaml):

```bash
docker compose up -d
```

### Docker CLI

Run the latest `iperf3` server on port `5201`:

```bash
docker run --init --rm -it -p 5201:5201 ghcr.io/routerzero/iperf-server:latest
```

## Running Different Versions

You can run specific versions of `iperf3` or `iperf2` by specifying the image tag.

### Available Tags

- **iperf 3 (Port 5201):** `latest`, `3`, `3.20`, `3.19`, `3.17`
- **iperf 2 (Port 5001):** `2`, `2.2`, `2.2.0`

### Examples

**iperf3 (specific version):**

```bash
docker run --init --rm -it -p 5201:5201 ghcr.io/routerzero/iperf-server:3.19
```

**iperf2 (requires port 5001):**

```bash
docker run --init --rm -it -p 5001:5001 ghcr.io/routerzero/iperf-server:2
```

For docker compose, override the `image` field accordingly by creating new file `compose.override.yaml`:

```yaml
services:
  iperf:
    image: ghcr.io/routerzero/iperf-server:3.19
```
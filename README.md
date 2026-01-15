# Reusable Elixir Workflow

> [!IMPORTANT]
> This workflow expects your project to use the [ocibuild](https://hex.pm/packages/ocibuild) library for building container images.

This reusable workflow builds, tests, and publishes Elixir projects as OCI container images with full supply chain security.

## Features

- **Reproducible builds** (opt-in) via `SOURCE_DATE_EPOCH` for consistent layer digests
- **Layer caching** - unchanged layers (ERTS, deps) are skipped on upload when enabled
- **SLSA provenance attestation** for supply chain security
- **Automatic OCI annotations** (source URL, revision, version, created timestamp)
- **SBOM generation** (Software Bill of Materials) included in images
- **Private Hex packages** support via organization authentication
- **Multi-platform builds** support (requires `include_erts: false`)

## Workflow Steps

1. **Checkout** - Fetches repository code
2. **Setup Elixir** - Installs Elixir and OTP using erlef/setup-beam
3. **Cache** - Restores deps and _build from cache
4. **Dependencies** - Runs `mix deps.get`
5. **Compile** - Runs `mix compile --warnings-as-errors`
6. **Test** - Runs `mix test` (optional)
7. **Release** - Builds production release with `mix release`
8. **OCI Build** - Builds and pushes image with `mix ocibuild --push`
9. **Attestation** - Generates SLSA build provenance

## Basic Usage

```yaml
name: "Build and publish"

on:
  push:
    tags: ["*"]
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  elixir:
    permissions:
      contents: read      # Checkout repository
      packages: write     # Push to GHCR
      id-token: write     # OIDC token for attestation
      attestations: write # Create attestations
    uses: intility/reusable-elixir/.github/workflows/elixir.yaml@v1
    with:
      docker: ${{ github.event_name != 'pull_request' }}
    secrets: inherit
```

See the full [example workflow](./example.yaml) for more options.

## Available Inputs

| Name | Type | Default | Description |
| :--- | :--- | :------ | :---------- |
| `directory` | string | `.` | Project directory |
| `elixir-version` | string | `1.19` | Elixir version |
| `otp-version` | string | `28` | Erlang/OTP version |
| `hex-organization` | string | - | Hex organization for private packages |
| `test` | boolean | `true` | Run `mix test` |
| `docker` | boolean | `true` | Build and push OCI image |
| `base-image` | string | - | Override base image (e.g., `elixir:1.19-slim`) |
| `platforms` | string | - | Multi-arch platforms (e.g., `linux/amd64,linux/arm64`) |
| `release` | string | - | Release name if multiple configured |
| `tags` | string | semver + branch/pr | Docker metadata tags |
| `source-date-epoch` | string | - | SOURCE_DATE_EPOCH for reproducible builds (use `0` for layer caching) |

## Secrets

| Name | Required | Description |
| :--- | :------- | :---------- |
| `hex-organization-key` | No | Hex organization auth key for private packages |

## Required Permissions

```yaml
permissions:
  contents: read      # Checkout repository
  packages: write     # Push to GitHub Container Registry
  id-token: write     # OIDC token for attestation
  attestations: write # Create build provenance attestation
```

## Project Configuration

Your Elixir project needs `ocibuild` configured. Add to `mix.exs`:

```elixir
defp deps do
  [
    {:ocibuild, "~> 0.10", runtime: false}
  ]
end

def project do
  [
    # ... other config
    releases: [
      my_app: [
        # Optional: exclude ERTS for multi-platform builds
        # include_erts: false
      ]
    ],
    # ocibuild configuration
    ocibuild: [
      base_image: "debian:stable-slim",
      workdir: "/app",
      env: %{"LANG" => "C.UTF-8"},
      expose: [4000]
    ]
  ]
end
```

## Reproducible Builds & Layer Caching

To enable reproducible builds and layer caching, set `source-date-epoch: "0"`:

```yaml
jobs:
  elixir:
    uses: intility/reusable-elixir/.github/workflows/elixir.yaml@v1
    with:
      source-date-epoch: "0"
```

This ensures file timestamps are consistent across builds, enabling:

- **Layer caching** - unchanged ERTS/deps layers keep the same digest and are skipped on upload
- **Reproducible builds** - same source always produces the same image
- **Registry deduplication** - identical content = identical digests

The actual build timestamp is recorded in the `org.opencontainers.image.created` annotation.

## Private Hex Packages

For projects using private Hex organization packages:

```yaml
jobs:
  elixir:
    uses: intility/reusable-elixir/.github/workflows/elixir.yaml@v1
    with:
      hex-organization: intility
    secrets:
      hex-organization-key: ${{ secrets.HEX_ORGANIZATION_KEY }}
```

## Multi-Platform Builds

For multi-architecture images (requires `include_erts: false` in your release config):

```yaml
jobs:
  elixir:
    uses: intility/reusable-elixir/.github/workflows/elixir.yaml@v1
    with:
      base-image: "elixir:1.19-slim"  # Must include ERTS
      platforms: "linux/amd64,linux/arm64"
```

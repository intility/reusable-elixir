# Reusable Elixir Workflows

Reusable GitHub Actions workflows for Elixir projects. Two workflows are available:

- **elixir-test** - Testing, linting, and static analysis
- **elixir-release** - Build and push OCI container images

## elixir-test

Runs tests and static analysis using [team-alembic/staple-actions](https://github.com/team-alembic/staple-actions).

### Features

- **Parallel jobs** for fast feedback (deps, audit, build, test, credo, dialyzer run concurrently)
- **Credo** static code analysis
- **Dialyzer** type checking with PLT caching
- **Sobelow** security scanner (Phoenix)
- **PostgreSQL** service container with Ash/Ecto support
- **SQLite** support for Ash
- **NPM** install for Phoenix assets
- **Hex organization** support for private packages

### Usage

```yaml
name: Test

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    uses: intility/reusable-elixir/.github/workflows/elixir-test.yaml@v1
    with:
      elixir-version: "1.18"
      otp-version: "27"
```

### Inputs

| Name | Type | Default | Description |
| :--- | :--- | :------ | :---------- |
| `elixir-version` | string | `1.18` | Elixir version |
| `otp-version` | string | `27` | Erlang/OTP version |
| `audit` | boolean | `true` | Run hex.audit and deps.audit |
| `credo` | boolean | `true` | Run Credo static analysis |
| `dialyzer` | boolean | `true` | Run Dialyzer type checking |
| `sobelow` | boolean | `false` | Run Sobelow security scanner |
| `postgres` | boolean | `false` | Start PostgreSQL service |
| `postgres-version` | string | `17` | PostgreSQL version |
| `ash-postgres` | boolean | `false` | Run Ash PostgreSQL migrations |
| `ecto-postgres` | boolean | `false` | Run Ecto migrations |
| `sqlite` | boolean | `false` | Run Ash SQLite migrations |
| `npm-install` | boolean | `false` | Run npm install for assets |
| `npm-working-directory` | string | `assets` | Directory for npm install |
| `node-version` | string | `latest` | Node.js version |
| `spark-formatter` | boolean | `false` | Check Spark DSL formatting |
| `hex-organization` | string | - | Hex organization for private packages |

### Secrets

| Name | Required | Description |
| :--- | :------- | :---------- |
| `hex-organization-key` | No | Hex organization auth key |

---

## elixir-release

> [!IMPORTANT]
> This workflow expects your project to use the [ocibuild](https://hex.pm/packages/ocibuild) library for building container images.

Builds and publishes Elixir releases as OCI container images with supply chain security.

### Features

- **Reproducible builds** (opt-in) via `SOURCE_DATE_EPOCH` for consistent layer digests
- **Layer caching** - unchanged layers (ERTS, deps) are skipped on upload
- **SLSA provenance attestation** for supply chain security
- **Automatic OCI annotations** (source URL, revision, version, created timestamp)
- **SBOM generation** (Software Bill of Materials) included in images
- **Private Hex packages** support via organization authentication
- **Multi-platform builds** support (requires `include_erts: false`)

### Usage

```yaml
name: Release

on:
  push:
    tags: ["*"]
    branches: [main]

jobs:
  release:
    permissions:
      contents: read
      packages: write
      id-token: write
      attestations: write
    uses: intility/reusable-elixir/.github/workflows/elixir-release.yaml@v1
    with:
      source-date-epoch: "0"
    secrets: inherit
```

### Inputs

| Name | Type | Default | Description |
| :--- | :--- | :------ | :---------- |
| `directory` | string | `.` | Project directory |
| `elixir-version` | string | `1.19` | Elixir version |
| `otp-version` | string | `28` | Erlang/OTP version |
| `hex-organization` | string | - | Hex organization for private packages |
| `docker` | boolean | `true` | Build and push OCI image |
| `base-image` | string | - | Override base image (e.g., `elixir:1.19-slim`) |
| `platforms` | string | - | Multi-arch platforms (e.g., `linux/amd64,linux/arm64`) |
| `release` | string | - | Release name if multiple configured |
| `tags` | string | semver + branch/pr | Docker metadata tags |
| `source-date-epoch` | string | - | SOURCE_DATE_EPOCH for reproducible builds (use `0` for layer caching) |

### Secrets

| Name | Required | Description |
| :--- | :------- | :---------- |
| `hex-organization-key` | No | Hex organization auth key |

### Required Permissions

```yaml
permissions:
  contents: read      # Checkout repository
  packages: write     # Push to GitHub Container Registry
  id-token: write     # OIDC token for attestation
  attestations: write # Create build provenance attestation
```

### Project Configuration

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

### Reproducible Builds & Layer Caching

Set `source-date-epoch: "0"` to enable reproducible builds and layer caching:

```yaml
jobs:
  release:
    uses: intility/reusable-elixir/.github/workflows/elixir-release.yaml@v1
    with:
      source-date-epoch: "0"
```

This ensures file timestamps are consistent across builds, enabling:

- **Layer caching** - unchanged ERTS/deps layers keep the same digest and are skipped on upload
- **Reproducible builds** - same source always produces the same image
- **Registry deduplication** - identical content = identical digests

The actual build timestamp is recorded in the `org.opencontainers.image.created` annotation.

---

## Complete Example

See [example.yaml](./example.yaml) for a complete workflow using both test and release.

```yaml
name: CI

on:
  push:
    tags: ["*"]
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  test:
    uses: intility/reusable-elixir/.github/workflows/elixir-test.yaml@v1
    with:
      postgres: true
      ash-postgres: true

  release:
    needs: test
    if: github.event_name != 'pull_request'
    permissions:
      contents: read
      packages: write
      id-token: write
      attestations: write
    uses: intility/reusable-elixir/.github/workflows/elixir-release.yaml@v1
    with:
      source-date-epoch: "0"
    secrets: inherit
```

## Private Hex Packages

For projects using private Hex organization packages:

```yaml
jobs:
  test:
    uses: intility/reusable-elixir/.github/workflows/elixir-test.yaml@v1
    with:
      hex-organization: intility
    secrets:
      hex-organization-key: ${{ secrets.HEX_ORGANIZATION_KEY }}

  release:
    needs: test
    uses: intility/reusable-elixir/.github/workflows/elixir-release.yaml@v1
    with:
      hex-organization: intility
    secrets:
      hex-organization-key: ${{ secrets.HEX_ORGANIZATION_KEY }}
```

## Multi-Platform Builds

For multi-architecture images (requires `include_erts: false` in your release config):

```yaml
jobs:
  release:
    uses: intility/reusable-elixir/.github/workflows/elixir-release.yaml@v1
    with:
      base-image: "elixir:1.19-slim"
      platforms: "linux/amd64,linux/arm64"
```

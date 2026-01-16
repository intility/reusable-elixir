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
- **SQLite** support for Ash/Ecto
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
    # Uses .tool-versions from your project
    uses: intility/reusable-elixir/.github/workflows/elixir-test.yaml@v1
```

Or specify versions explicitly:

```yaml
jobs:
  test:
    uses: intility/reusable-elixir/.github/workflows/elixir-test.yaml@v1
    with:
      elixir-version: "1.19"
      otp-version: "28"
```

### Inputs

| Name                    | Type    | Default  | Description                                                           |
|:------------------------|:--------|:---------|:----------------------------------------------------------------------|
| `elixir-version`        | string  | -        | Elixir version (uses `.tool-versions` if not specified)               |
| `otp-version`           | string  | -        | Erlang/OTP version (uses `.tool-versions` if not specified)           |
| `audit`                 | boolean | `true`   | Run hex.audit and deps.audit                                          |
| `credo`                 | boolean | `true`   | Run Credo static analysis                                             |
| `dialyzer`              | boolean | `true`   | Run Dialyzer type checking                                            |
| `sobelow`               | boolean | `false`  | Run Sobelow security scanner (Phoenix projects)                       |
| `postgres`              | string  | -        | PostgreSQL migrations: `ash` or `ecto` (starts service automatically) |
| `postgres-version`      | string  | `18`     | PostgreSQL version                                                    |
| `sqlite`                | string  | -        | SQLite migrations: `ash` or `ecto`                                    |
| `npm-install`           | boolean | `false`  | Run npm install for assets                                            |
| `npm-working-directory` | string  | `assets` | Directory for npm install                                             |
| `node-version`          | string  | `latest` | Node.js version                                                       |
| `spark-formatter`       | boolean | `false`  | Check Spark DSL formatting                                            |
| `hex-organization`      | string  | -        | Hex organization for private packages                                 |

### Secrets

| Name                   | Required | Description                                       |
|:-----------------------|:---------|:--------------------------------------------------|
| `hex-organization-key` | No       | Hex organization auth key                         |
| `ssh-private-key`      | No       | SSH private key(s) for private Git repository access |

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
    # Uses .tool-versions from your project
    uses: intility/reusable-elixir/.github/workflows/elixir-release.yaml@v1
    with:
      source-date-epoch: "0" # Set mtime on all files in the archive to January 1, 1970 00:00:00 UTC to allow reproducible builds
    secrets: inherit
```

### Inputs

| Name                | Type    | Default            | Description                                                           |
|:--------------------|:--------|:-------------------|:----------------------------------------------------------------------|
| `directory`         | string  | `.`                | Project directory                                                     |
| `elixir-version`    | string  | -                  | Elixir version (uses `.tool-versions` if not specified)               |
| `otp-version`       | string  | -                  | Erlang/OTP version (uses `.tool-versions` if not specified)           |
| `hex-organization`  | string  | -                  | Hex organization for private packages                                 |
| `docker`            | boolean | `true`             | Build and push OCI image                                              |
| `base-image`        | string  | -                  | Override base image (e.g., `elixir:1.19-slim`)                        |
| `platforms`         | string  | -                  | Multi-arch platforms (e.g., `linux/amd64,linux/arm64`)                |
| `release`           | string  | -                  | Release name if multiple configured                                   |
| `tags`              | string  | semver + branch/pr | Docker metadata tags                                                  |
| `source-date-epoch` | string  | -                  | SOURCE_DATE_EPOCH for reproducible builds (use `0` for layer caching) |

### Secrets

| Name                   | Required | Description                                       |
|:-----------------------|:---------|:--------------------------------------------------|
| `hex-organization-key` | No       | Hex organization auth key                         |
| `ssh-private-key`      | No       | SSH private key(s) for private Git repository access |

### Required Permissions

```yaml
permissions:
  contents: read      # Checkout repository
  packages: write     # Push to GitHub Container Registry
  id-token: write     # OIDC token for attestation
  attestations: write # Create build provenance attestation
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
      postgres: ash

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

## Version Management

Both workflows support two ways to specify Elixir/OTP versions:

### Using `.tool-versions` (recommended)

If your project has a `.tool-versions` file, simply omit the version inputs:

```yaml
jobs:
  test:
    uses: intility/reusable-elixir/.github/workflows/elixir-test.yaml@v1
    # Uses versions from .tool-versions automatically
```

Example `.tool-versions`:
```
elixir 1.19.0
erlang 28.0
```

### Using explicit versions

Override `.tool-versions` by specifying versions explicitly:

```yaml
jobs:
  test:
    uses: intility/reusable-elixir/.github/workflows/elixir-test.yaml@v1
    with:
      elixir-version: "1.19"
      otp-version: "28"
```

### Matrix strategy for multiple versions

Test against multiple Elixir/OTP combinations:

```yaml
jobs:
  test:
    strategy:
      fail-fast: false
      matrix:
        include:
          # Elixir 1.18 supports OTP 25-27
          - elixir: "1.18"
            otp: "27"
          # Elixir 1.19 supports OTP 27-28
          - elixir: "1.19"
            otp: "27"
          - elixir: "1.19"
            otp: "28"
    uses: intility/reusable-elixir/.github/workflows/elixir-test.yaml@v1
    with:
      elixir-version: ${{ matrix.elixir }}
      otp-version: ${{ matrix.otp }}
```

> [!NOTE]
> When using a matrix, each combination spawns a separate workflow run with independent caching.

---

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

## Private Git Dependencies

For projects with dependencies hosted in private Git repositories:

```yaml
jobs:
  test:
    uses: intility/reusable-elixir/.github/workflows/elixir-test.yaml@v1
    secrets:
      ssh-private-key: ${{ secrets.SSH_PRIVATE_KEY }}

  release:
    needs: test
    permissions:
      contents: read
      packages: write
      id-token: write
      attestations: write
    uses: intility/reusable-elixir/.github/workflows/elixir-release.yaml@v1
    secrets:
      ssh-private-key: ${{ secrets.SSH_PRIVATE_KEY }}
```

Multiple keys are supported for accessing different repositories:

```yaml
secrets:
  ssh-private-key: |
    ${{ secrets.REPO_A_DEPLOY_KEY }}
    ${{ secrets.REPO_B_DEPLOY_KEY }}
```

The SSH key(s) should have read access to your private repositories. You can combine this with Hex organization authentication if needed.

## Database Support

### PostgreSQL

Set `postgres` to start a PostgreSQL service and run migrations:

```yaml
jobs:
  test:
    uses: intility/reusable-elixir/.github/workflows/elixir-test.yaml@v1
    with:
      postgres: ash    # Ash Framework: ash_postgres.create + migrate
      # or
      postgres: ecto   # Ecto/Phoenix: ecto.create + migrate
      postgres-version: "18"  # Optional, defaults to 18
```

### SQLite

Set `sqlite` to run SQLite migrations (no service needed):

```yaml
jobs:
  test:
    uses: intility/reusable-elixir/.github/workflows/elixir-test.yaml@v1
    with:
      sqlite: ash    # Ash Framework: ash_sqlite.create + migrate
      # or
      sqlite: ecto   # Ecto: ecto.create + migrate
```

---

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

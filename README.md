<h1 align="center">
  <img src="https://avatars.githubusercontent.com/u/35199565" width="124px"/><br/>
  Reusable Elixir Workflows
</h1>

<p align="center">
Opinionated reusable GitHub Actions workflows for Elixir projects. 
Ready workflows for testing, linting, static code analysis, documentation and building OCI compliant container images.
</p>

## 🔮 elixir-test

Runs tests and static analysis for Elixir projects.

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

For projects where the Elixir app lives in a subdirectory:

```yaml
jobs:
  test:
    uses: intility/reusable-elixir/.github/workflows/elixir-test.yaml@v1
    with:
      directory: apps/my-elixir-app
      postgres: ecto
```

### Inputs

| Name                    | Type    | Default    | Description                                                           |
|:------------------------|:--------|:-----------|:----------------------------------------------------------------------|
| `directory`             | string  | `.`        | Project directory (for subdirectory support)                          |
| `elixir-version`        | string  | -          | Elixir version (uses `.tool-versions` if not specified)               |
| `otp-version`           | string  | -          | Erlang/OTP version (uses `.tool-versions` if not specified)           |
| `audit`                 | boolean | `true`     | Run hex.audit and deps.audit                                          |
| `credo`                 | boolean | `true`     | Run Credo static analysis                                             |
| `dialyzer`              | boolean | `true`     | Run Dialyzer type checking                                            |
| `sobelow`               | boolean | `false`    | Run Sobelow security scanner (Phoenix projects)                       |
| `postgres`              | string  | -          | PostgreSQL migrations: `ash` or `ecto` (starts service automatically) |
| `postgres-image`        | string  | `postgres` | Docker image name without tag (e.g., `timescale/timescaledb`)         |
| `postgres-version`      | string  | `18`       | Docker image tag for the postgres-image (e.g., `18`, `latest-pg18`)   |
| `sqlite`                | string  | -          | SQLite migrations: `ash` or `ecto`                                    |
| `npm-install`           | boolean | `false`    | Run npm install for assets                                            |
| `npm-working-directory` | string  | `assets`   | Directory for npm install                                             |
| `npm-registry`          | string  | -          | Custom NPM registry URL (e.g., `https://npm.pkg.github.com`)          |
| `node-version`          | string  | `latest`   | Node.js version                                                       |
| `spark-formatter`       | boolean | `false`    | Check Spark DSL formatting                                            |
| `spark-extensions`      | string  | -          | Spark DSL extensions for formatter (multiline, one per line)          |
| `hex-organization`      | string  | -          | Hex organization for private packages                                 |
| `apt-packages`          | string  | -          | Space-separated APT packages to install (e.g., `libvips-dev`)         |
| `env`                   | string  | -          | Environment variables for all jobs (one `KEY=VALUE` per line)         |
| `artifacts`             | string  | -          | Multiline artifact definitions to download (`name:path` per line)     |

### Secrets

| Name                   | Required | Description                                          |
|:-----------------------|:---------|:-----------------------------------------------------|
| `hex-organization-key` | No       | Hex organization auth key                            |
| `ssh-private-key`      | No       | SSH private key(s) for private Git repository access |
| `npm-token`            | No       | NPM authentication token for private registries      |

---

## 📚 elixir-docs

Builds and deploys Elixir documentation to GitHub Pages.

### Usage

```yaml
name: Docs

on:
  push:
    branches: [main]

jobs:
  docs:
    permissions:
      pages: write
      id-token: write
    uses: intility/reusable-elixir/.github/workflows/elixir-docs.yaml@v1
```

### Inputs

| Name               | Type   | Default | Description                                                       |
|:-------------------|:-------|:--------|:------------------------------------------------------------------|
| `elixir-version`   | string | -       | Elixir version (uses `.tool-versions` if not specified)           |
| `otp-version`      | string | -       | Erlang/OTP version (uses `.tool-versions` if not specified)       |
| `hex-organization` | string | -       | Hex organization for private packages                             |
| `apt-packages`     | string | -       | Space-separated APT packages to install (e.g., `libvips-dev`)    |
| `env`              | string | -       | Environment variables (one `KEY=VALUE` per line)                  |
| `artifacts`        | string | -       | Multiline artifact definitions to download (`name:path` per line) |

### Secrets

| Name                   | Required | Description                                          |
|:-----------------------|:---------|:-----------------------------------------------------|
| `hex-organization-key` | No       | Hex organization auth key                            |
| `ssh-private-key`      | No       | SSH private key(s) for private Git repository access |

---

## 📦 elixir-release

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
| `image-name`        | string  | -                  | Image name without registry prefix (e.g., `my-app`). Prefixed with `ghcr.io/<owner>/`. Defaults to repository name. |
| `docker`            | boolean | `true`             | Build and push OCI image                                              |
| `base-image`        | string  | -                  | Override base image (e.g., `elixir:1.19-slim`)                        |
| `platforms`         | string  | -                  | Multi-arch platforms (e.g., `linux/amd64,linux/arm64`)                |
| `release`           | string  | -                  | Release name if multiple configured                                   |
| `tags`              | string  | semver + branch/pr | Docker metadata tags                                                  |
| `source-date-epoch` | string  | -                  | SOURCE_DATE_EPOCH for reproducible builds (use `0` for layer caching) |
| `assets-deploy`     | boolean | `false`            | Run `mix assets.deploy` to build and digest static assets             |
| `npm-install`       | boolean | `false`            | Run npm install and `mix assets.deploy`                               |
| `npm-working-directory` | string | `assets`        | Directory for npm install                                             |
| `npm-registry`      | string  | -                  | Custom NPM registry URL (e.g., `https://npm.pkg.github.com`)          |
| `node-version`      | string  | `latest`           | Node.js version                                                       |
| `apt-packages`      | string  | -                  | Space-separated APT packages to install (e.g., `libvips-dev`)         |
| `artifacts`         | string  | -                  | Multiline artifact definitions to download (`name:path` per line)     |

### Secrets

| Name                   | Required | Description                                                    |
|:-----------------------|:---------|:---------------------------------------------------------------|
| `hex-organization-key` | No       | Hex organization auth key                                      |
| `ssh-private-key`      | No       | SSH private key(s) for private Git repository access           |
| `npm-token`            | No       | NPM authentication token for private registries                |
| `pull-username`        | No       | Username for pulling base image (defaults to `github.actor`)   |
| `pull-password`        | No       | Password for pulling base image (defaults to `GITHUB_TOKEN`)   |

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

## Pre-built Artifacts

For projects that depend on native binaries (Rust, Go, C) or other pre-compiled assets, you can inject artifacts from upstream jobs:

```yaml
name: CI

on:
  push:
    branches: [main]

jobs:
  build-native:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - run: cargo build --release
        working-directory: native/cel_evaluator
      - uses: actions/upload-artifact@v4
        with:
          name: cel-evaluator
          path: native/cel_evaluator/target/release/cel_evaluator

  test:
    needs: [build-native]
    uses: intility/reusable-elixir/.github/workflows/elixir-test.yaml@v1
    with:
      artifacts: |
        cel-evaluator:apps/my_app/priv/bin

  release:
    needs: [build-native, test]
    permissions:
      contents: read
      packages: write
      id-token: write
      attestations: write
    uses: intility/reusable-elixir/.github/workflows/elixir-release.yaml@v1
    with:
      artifacts: |
        cel-evaluator:apps/my_app/priv/bin
    secrets: inherit
```

Multiple artifacts can be specified, one per line:

```yaml
with:
  artifacts: |
    cel-evaluator:apps/my_app/priv/bin
    wasm-module:apps/my_app/priv/wasm
```

> [!NOTE]
> GitHub artifact uploads strip POSIX file permissions. Handle this on your end (e.g., `File.chmod/2` at runtime) rather than expecting executable bits to be preserved.

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

## Private NPM Packages

For Phoenix projects with assets from private NPM registries:

```yaml
jobs:
  test:
    uses: intility/reusable-elixir/.github/workflows/elixir-test.yaml@v1
    with:
      npm-install: true
      npm-registry: https://npm.pkg.github.com
    secrets:
      npm-token: ${{ secrets.NPM_TOKEN }}
```

For GitHub Packages, you can use `GITHUB_TOKEN`:

```yaml
secrets:
  npm-token: ${{ secrets.GITHUB_TOKEN }}
```

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

For PostgreSQL-compatible images (e.g., TimescaleDB), override the image name:

```yaml
jobs:
  test:
    uses: intility/reusable-elixir/.github/workflows/elixir-test.yaml@v1
    with:
      postgres: ash
      postgres-image: timescale/timescaledb
      postgres-version: latest-pg18
```

The service container image is built as `{postgres-image}:{postgres-version}`, defaulting to `postgres:18`.

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

## Phoenix Assets

For Phoenix projects using Mix-based asset tools (Tailwind, esbuild) without npm:

```yaml
jobs:
  release:
    permissions:
      contents: read
      packages: write
      id-token: write
      attestations: write
    uses: intility/reusable-elixir/.github/workflows/elixir-release.yaml@v1
    with:
      assets-deploy: true
    secrets: inherit
```

For Phoenix projects with JavaScript assets managed by npm:

```yaml
jobs:
  release:
    permissions:
      contents: read
      packages: write
      id-token: write
      attestations: write
    uses: intility/reusable-elixir/.github/workflows/elixir-release.yaml@v1
    with:
      npm-install: true
    secrets: inherit
```

Both options run `mix assets.deploy` before building the release. Use `npm-install` when your assets require `npm ci` first, or `assets-deploy` when your project uses Mix-managed tools like Tailwind and esbuild directly.

## Environment Variables

For projects that need custom environment variables at compile time or test time (e.g., [Cloak](https://hexdocs.pm/cloak) encryption keys):

```yaml
jobs:
  test:
    uses: intility/reusable-elixir/.github/workflows/elixir-test.yaml@v1
    with:
      env: |
        CLOAK_KEY=b23S/6av/mvyVEh27ksmXb+784i50afsp1FD0DUf87E=
        MY_OTHER_VAR=value
```

Environment variables are available in all jobs and all steps within the workflow.

## Caching

The `mix-cache` composite action manages two independent caches:

- **Deps cache** — the `deps/` directory, keyed by `.tool-versions` and `mix.lock`
- **Build cache** — the `_build/<env>` directory, keyed by `.tool-versions`, `mix.lock`, and source files

By default both caches are active. Jobs that only need dependencies (formatting, linting, auditing) can skip the build cache:

```yaml
- uses: intility/reusable-elixir/.github/actions/mix-cache@main
  with:
    mix-env: test
    cache-build: "false"   # Only cache deps/
```

| Input         | Type   | Default  | Description                                        |
|:--------------|:-------|:---------|:---------------------------------------------------|
| `mix-env`     | string | `test`   | MIX_ENV to cache for                               |
| `cache-build` | string | `"true"` | Whether to cache `_build/` (set `"false"` to skip) |
| `directory`   | string | `.`      | Directory containing the Elixir project             |

The `elixir-test` workflow uses this internally — deps-only jobs skip the build cache so that `build-test` is the first to save it, and downstream jobs (`test`, `dialyzer`) restore the full build without recompiling.

## Composite Actions

The workflows are built from lightweight composite actions in `.github/actions/`. These assume the environment is already set up (Elixir installed, deps cached) and can also be used independently in your own workflows.

| Action | Description |
|:-------|:------------|
| `install-elixir` | Install Elixir and OTP via `erlef/setup-beam` using `.tool-versions` (supports `directory`) |
| `mix-deps-get` | Install Hex, Rebar, and fetch dependencies (supports `directory`) |
| `mix-compile` | Compile project (`mix-env` required, optional `args`, supports `directory`) |
| `mix-task` | Run any mix task (`task` and `mix-env` required, supports `directory`) |
| `mix-test` | Run `mix test` (`mix-env` required, supports `directory`) |
| `mix-hex-audit` | Run `mix hex.audit` (supports `directory`) |
| `mix-dialyzer` | Run Dialyzer with automatic PLT caching (`mix-env` required, supports `directory`) |
| `mix-docs` | Compile and generate documentation (`mix-env` required) |
| `mix-cache` | Cache `deps/` and `_build/` directories (supports `directory`) |
| `setup-tool-versions` | Generate or use `.tool-versions` file (supports `working-directory`) |
| `ssh-agent` | Set up SSH agent for private Git repositories |
| `set-env` | Export environment variables from multiline input |
| `apt-packages` | Install system packages via apt-get |
| `download-artifacts` | Download workflow artifacts from multiline definitions (supports `directory`) |
| `ocibuild` | Build and push OCI images |

### Using actions directly

```yaml
steps:
  - uses: actions/checkout@v4
  - uses: intility/reusable-elixir/.github/actions/install-elixir@main
  - uses: intility/reusable-elixir/.github/actions/mix-cache@main
    with:
      mix-env: test
  - uses: intility/reusable-elixir/.github/actions/mix-deps-get@main
  - uses: intility/reusable-elixir/.github/actions/mix-compile@main
    with:
      mix-env: test
  - uses: intility/reusable-elixir/.github/actions/mix-task@main
    with:
      mix-env: test
      task: credo --strict
```

All actions support a `directory` input (default `.`) for monorepo projects:

```yaml
steps:
  - uses: actions/checkout@v4
  - uses: intility/reusable-elixir/.github/actions/install-elixir@main
    with:
      directory: apps/my-app
  - uses: intility/reusable-elixir/.github/actions/mix-cache@main
    with:
      mix-env: test
      directory: apps/my-app
  - uses: intility/reusable-elixir/.github/actions/mix-deps-get@main
    with:
      directory: apps/my-app
  - uses: intility/reusable-elixir/.github/actions/mix-test@main
    with:
      mix-env: test
      directory: apps/my-app
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

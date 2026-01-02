# Reusable Elixir Workflow

> [!IMPORTANT]
> This workflow expects the project you're building is using the [ocibuild](https://hex.pm/packages/ocibuild) library to build container images.

This reusable workflow will fetch dependencies, run tests, build and publish your Elixir project.
The workflow includes the following steps.

- `mix deps.get`: Fetches dependencies for your project.
- `mix test`: Runs your test-suite.
- `mix ocibuild`: Builds OCI container image using the `ocibuild` library.
- `mix ocibuild --push`: Pushes the container image to the GitHub Container Registry (ghcr.io).

## Basic usage

The [example workflow](./example.yaml) is set up to run when a tag is pushed, when the `main` branch has been pushed to, or on pull requests to the `main` branch.

### Permissions

- `id-token`: write # Used for the attestation
- `contents`: read # Used for the checkout
- `packages`: write # Used for the publish
- `attestations`: write # Used for the attestation

### Prerequisite

In order to produce standardized deterministic builds, this project requires that you have installed the [ocibuild](https://hex.pm/packages/ocibuild) library in your project.
This library produces OCI compliant container images and automatically handles the following:

- OCI annotations
- Reproducible builds
- Image layering of runtime, dependencies and application code
- SBOM (Software Bill of Materials)

> [!IMPORTANT]
> You need to set up the following things for your reusable workflow repository:

- [x] Repository Settings -> Actions -> General -> Access needs to be set to at least `Accessible from repositories in the 'intility' organization`
- [ ] An org admin needs to grant Dependabot access to the repository here: https://github.com/organizations/intility/settings/security_analysis
- [x] Add the `reusable-workflows` topic to the repository
- [x] Rename `x.yaml` workflow
- [ ] Update `example.yaml` and `README.md`
- [x] Add a branch ruleset to protect the main branch
- [ ] If you need to push a docker image, try re-using [`reusable-docker`](https://github.com/intility/reusable-docker) ([example in `reusable-react`](https://github.com/intility/reusable-react/blob/55a30700735748f3562c0e59bb5f13e3a261f6a2/.github/workflows/react.yaml#L175))
- [ ] Remove this checklist

# Reusable X workflow

<!-- Describe what the workflow is for  -->

Reusable workflow for X.

## Basic usage

<!-- Describe basic usage and what it does -->

See the [example workflow](./example.yaml).

## Available inputs

<!-- Describe available inputs for the reusable workflow -->

| Name            | Type   | Default value | Description             |
| :-------------- | :----- | :------------ | :---------------------- |
| `example-input` | string | `value`       | Descriptive description |

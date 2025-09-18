> [!IMPORTANT]
> You need to set up the following things for your reusable workflow repository:

- [ ] Repository Settings -> Actions -> General -> Access needs to be set to at least `Accessible from repositories in the 'intility' organization`
- [ ] An org admin needs to grant Dependabot access to the repository here: https://github.com/organizations/intility/settings/security_analysis
- [ ] Add the `reusable-workflows` topic to the repository
- [ ] Rename `x.yaml` workflow
- [ ] Update `example.yaml` and `README.md`
- [ ] Add a branch ruleset to protect the main branch
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

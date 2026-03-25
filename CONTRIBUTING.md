# Contributing

Thank you for your interest in contributing to reusable-elixir!

## Getting Started

1. Fork the repository and create a branch from `main`.
2. Make your changes.
3. Open a pull request with a clear description of what you changed and why.

## Reporting Issues

Use [GitHub Issues](https://github.com/intility/reusable-elixir/issues) to report bugs or request features. Include as much detail as possible: what you expected, what happened, and a minimal reproducing example if applicable.

## Pull Requests

- Keep changes focused. One feature or fix per PR makes review easier.
- Update documentation (README, inline comments) if your change affects behavior or adds new inputs/secrets.
- If you add a new workflow input or action, include it in the relevant inputs table in the README.
- All workflows are tested against real GitHub Actions runners. Manual testing by running the workflows in a fork is encouraged for non-trivial changes.

## Workflow and Action Structure

- Reusable workflows live in `.github/workflows/`.
- Composite actions live in `.github/actions/`.
- Each composite action should be self-contained with its own `action.yml`.

## Commit Style

Commits must follow [Conventional Commits](https://www.conventionalcommits.org/). The format is:

```
<type>(<scope>): <short description>
```

Common types: `feat`, `fix`, `docs`, `chore`, `refactor`, `ci`, `test`.

Examples:
- `feat(elixir-test): add sobelow input`
- `fix(mix-cache): correct PLT cache key`
- `docs: update README inputs table`

## License

By contributing, you agree that your contributions will be licensed under the [MIT License](LICENSE).

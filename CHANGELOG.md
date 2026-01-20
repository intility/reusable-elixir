# Changelog

## [1.2.1](https://github.com/intility/reusable-elixir/compare/v1.2.0...v1.2.1) (2026-01-20)


### Bug Fixes

* **ocibuild:** Make pull credentials optional for anonymous registry access ([08b92fc](https://github.com/intility/reusable-elixir/commit/08b92fc236efc6f1306549ee005c266d39ae317e))
* **ocibuild:** Remove fallback to push credentials for pull operations ([d12256a](https://github.com/intility/reusable-elixir/commit/d12256a58a985b403151299179565ad16af4d770))

## [1.2.0](https://github.com/intility/reusable-elixir/compare/v1.1.0...v1.2.0) (2026-01-19)


### Features

* Add reusable Elixir workflow with OCI build support ([edc0c3c](https://github.com/intility/reusable-elixir/commit/edc0c3c17bca569cdd9807ceca975ce9d3c4b002))
* **ci:** add Mix cache action to improve build performance ([530cd7a](https://github.com/intility/reusable-elixir/commit/530cd7a44a19e2aaa50ce7a5055f7d096725108c))
* **ci:** add setup-tool-versions GitHub Action ([f515169](https://github.com/intility/reusable-elixir/commit/f515169003eb5965c75efdaaf4e5d7ecb2ee58da))
* **ci:** add support for APT package installation ([e323b71](https://github.com/intility/reusable-elixir/commit/e323b71d276238e6a8840a53f296919153f75239))
* **ci:** Add support for private NPM registries and authentication ([9b421c1](https://github.com/intility/reusable-elixir/commit/9b421c1b34f0940159be4a30759ebbcbd31c4497))
* **ci:** add Tailwind binary installation step to release workflow ([70a2e40](https://github.com/intility/reusable-elixir/commit/70a2e402587eca45722fda96c41a0c19830eb3c5))
* **ci:** Make SOURCE_DATE_EPOCH configurable via input parameter ([801c3c1](https://github.com/intility/reusable-elixir/commit/801c3c111570ae819da2f2cb7c07e39463065ad1))
* **ci:** Touch cached Mix files to preserve modification times ([af7b085](https://github.com/intility/reusable-elixir/commit/af7b08550ed7174d0bc766dd5a620f17480b20b2))
* **ocibuild:** Add separate pull credentials for base images ([0eca565](https://github.com/intility/reusable-elixir/commit/0eca565fd45d508c5cfc168f223e7f2099805ba2))
* **workflows:** Add SSH private key support for Git dependencies ([a0d284e](https://github.com/intility/reusable-elixir/commit/a0d284e0858099124fea880ac24b65d91a4c8acd))


### Bug Fixes

* Set MIX_ENV ([5d794fa](https://github.com/intility/reusable-elixir/commit/5d794fafb348d79853d8c2be33dd2afacf82e578))

# Changelog

## [2.2.1](https://github.com/intility/reusable-elixir/compare/v2.2.0...v2.2.1) (2026-03-04)


### Bug Fixes

* **mix-compile:** Dereference priv symlinks for NIF caching ([8fa37d7](https://github.com/intility/reusable-elixir/commit/8fa37d77b6155c08b3b5f5d777cc17b26580a21a))

## [2.2.0](https://github.com/intility/reusable-elixir/compare/v2.1.1...v2.2.0) (2026-02-26)


### Features

* add env input and fix named release support ([aa15a27](https://github.com/intility/reusable-elixir/commit/aa15a27e2340c63d83622e029e56e06aecd57704))
* **workflows:** add env input to elixir-release workflow ([4a8e83c](https://github.com/intility/reusable-elixir/commit/4a8e83c2eac459619729b76d898aa4145b074a5b))

## [2.1.1](https://github.com/intility/reusable-elixir/compare/v2.1.0...v2.1.1) (2026-02-24)


### Bug Fixes

* **cache:** clean stale deps on partial cache hit to prevent poisoning ([#53](https://github.com/intility/reusable-elixir/issues/53)) ([2171e6b](https://github.com/intility/reusable-elixir/commit/2171e6b3510f073dc890f50655e08a6ceae83000))
* **cache:** remove cross-lockfile build cache restore-key ([#56](https://github.com/intility/reusable-elixir/issues/56)) ([53ae721](https://github.com/intility/reusable-elixir/commit/53ae72100d8bb11d1b971c0beb65886b40e7db17))

## [2.1.0](https://github.com/intility/reusable-elixir/compare/v2.0.1...v2.1.0) (2026-02-17)


### Features

* add assets-deploy input for Mix-managed asset pipelines ([#51](https://github.com/intility/reusable-elixir/issues/51)) ([11a52dd](https://github.com/intility/reusable-elixir/commit/11a52dd037ada3da51fc60fe4ac7e474daf61cd7))
* Add support for PostgreSQL-compatible Docker images ([686899d](https://github.com/intility/reusable-elixir/commit/686899d1cecf4af01767532f95ef0716f50d3d2d))

## [2.0.1](https://github.com/intility/reusable-elixir/compare/v2.0.0...v2.0.1) (2026-02-16)


### Bug Fixes

* **ci:** Add mix deps get step before docs generation ([a41c3df](https://github.com/intility/reusable-elixir/commit/a41c3df3c5ff9b3c87b9de9c97fe855cb83b8f59))

## [2.0.0](https://github.com/intility/reusable-elixir/compare/v1.6.4...v2.0.0) (2026-02-13)


### ⚠ BREAKING CHANGES

* align image-name input with reusable-docker convention ([#44](https://github.com/intility/reusable-elixir/issues/44))

### Bug Fixes

* align image-name input with reusable-docker convention ([#44](https://github.com/intility/reusable-elixir/issues/44)) ([4f1efbb](https://github.com/intility/reusable-elixir/commit/4f1efbbcb96b1259cea7154388c0097215dd41bc))

## [1.6.4](https://github.com/intility/reusable-elixir/compare/v1.6.3...v1.6.4) (2026-02-13)


### Bug Fixes

* **ci:** restore build cache in formatter job ([#42](https://github.com/intility/reusable-elixir/issues/42)) ([9e6b6aa](https://github.com/intility/reusable-elixir/commit/9e6b6aab140378f2a0eda7e3c64b307411fb033e))

## [1.6.3](https://github.com/intility/reusable-elixir/compare/v1.6.2...v1.6.3) (2026-02-13)


### Bug Fixes

* **ci:** use conventional commit prefix for security fixes ([#39](https://github.com/intility/reusable-elixir/issues/39)) ([86e9b7a](https://github.com/intility/reusable-elixir/commit/86e9b7af6936c22b844b44e302ef22c207d4450f))

## [1.6.2](https://github.com/intility/reusable-elixir/compare/v1.6.1...v1.6.2) (2026-02-13)


### Bug Fixes

* resolve 107 code scanning security alerts ([#36](https://github.com/intility/reusable-elixir/issues/36)) ([d40fa41](https://github.com/intility/reusable-elixir/commit/d40fa41fb092ab6b0f81159f6501eab148f6b1f1))

## [1.6.1](https://github.com/intility/reusable-elixir/compare/v1.6.0...v1.6.1) (2026-02-13)


### Bug Fixes

* **release:** directory input on ocibuild action ([9dec86b](https://github.com/intility/reusable-elixir/commit/9dec86bf7003ac97dc0dfee7fb89315bb068a63c))
* **release:** directory input on ocibuild action ([eb9ba2c](https://github.com/intility/reusable-elixir/commit/eb9ba2c02038e88a48870779148005c2ec18da12))

## [1.6.0](https://github.com/intility/reusable-elixir/compare/v1.5.1...v1.6.0) (2026-02-12)


### Features

* **test:** add directory support for mix tasks ([db9686e](https://github.com/intility/reusable-elixir/commit/db9686edfb7d7231e252e270c75ecc244e350790))
* **test:** add directory support for mix tasks ([80cc79e](https://github.com/intility/reusable-elixir/commit/80cc79e15e6e69efc9e8676fc382cd4fa07f0173))

## [1.5.1](https://github.com/intility/reusable-elixir/compare/v1.5.0...v1.5.1) (2026-02-12)


### Bug Fixes

* **ci:** remove invalid expression from input description ([b89669c](https://github.com/intility/reusable-elixir/commit/b89669c8009d744b73d51c71ae2699e35643adac))

## [1.5.0](https://github.com/intility/reusable-elixir/compare/v1.4.0...v1.5.0) (2026-02-12)


### Features

* **release:** add optional image-name input ([86d8d36](https://github.com/intility/reusable-elixir/commit/86d8d360be2ccabcc1a01ed5888f3367c6f841a5))
* **release:** add optional image-name input ([73bcd0a](https://github.com/intility/reusable-elixir/commit/73bcd0a9ed711f5313691fa370237ae9a5e85a4a))


### Bug Fixes

* **ci:** correct pinned SHA for actions/deploy-pages v4.0.5 ([d95aefc](https://github.com/intility/reusable-elixir/commit/d95aefc356af74c7f563cca427ea71d4c2047369))

## [1.4.0](https://github.com/intility/reusable-elixir/compare/v1.3.0...v1.4.0) (2026-02-10)


### Features

* **ci:** replace staple-actions with lightweight composite actions ([d2307f7](https://github.com/intility/reusable-elixir/commit/d2307f76f0e3fa29f30924ff4e94e1b71ec2bca4))


### Performance Improvements

* **ci:** Remove wasteful deps compilation from deps job ([6bd0d1e](https://github.com/intility/reusable-elixir/commit/6bd0d1ed6080066e379683d50eb8b6aec6850ba5))

## [1.3.0](https://github.com/intility/reusable-elixir/compare/v1.2.2...v1.3.0) (2026-02-10)


### Features

* add artifact injection support to workflows ([a30666d](https://github.com/intility/reusable-elixir/commit/a30666d5d488f756ac8644c7a79f7bb07dacdb69))
* add artifacts input to elixir-release workflow ([b616ba8](https://github.com/intility/reusable-elixir/commit/b616ba8cefb919e991326b76f5c3065ca8aa9a88))
* add artifacts input to elixir-test workflow ([173b3a8](https://github.com/intility/reusable-elixir/commit/173b3a8f73f05686e517ff3829134a78540602c5))
* add download-artifacts composite action ([25255fa](https://github.com/intility/reusable-elixir/commit/25255fab6aae18d63f26d9ee636b705a1e01a229))
* support passing environment variables to reusable workflow ([652dee3](https://github.com/intility/reusable-elixir/commit/652dee3f02636caba3d43ebb3f395fe5fc04479d))
* support passing environment variables to reusable workflow ([e4d5381](https://github.com/intility/reusable-elixir/commit/e4d5381cc1958cf23ef96732e4a4c011299e1e63)), closes [#22](https://github.com/intility/reusable-elixir/issues/22)


### Bug Fixes

* prevent conflicting build caches in test job ([561d159](https://github.com/intility/reusable-elixir/commit/561d159858fbd5d47663d42b0405a01858a7e92d))
* split mix-cache into separate deps and build caches ([20d3aa5](https://github.com/intility/reusable-elixir/commit/20d3aa5b78ea35e16fc6e103c6174029eb55eac8)), closes [#27](https://github.com/intility/reusable-elixir/issues/27)

## [1.2.2](https://github.com/intility/reusable-elixir/compare/v1.2.1...v1.2.2) (2026-02-02)


### Bug Fixes

* **ci:** improve spark-extensions parsing in workflow ([452f661](https://github.com/intility/reusable-elixir/commit/452f661c8e36dfcbaf93902b67d38612fc7ff551))

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

# Stack Changelog

Aggregated highlights from each repo’s latest release. For full history, use each repo’s CHANGELOG.

## Version matrix
### Version compatibility (current tags)

- `toolmodel`: `v0.1.3`
- `toolindex`: `v0.3.0`
- `tooldocs`: `v0.1.11`
- `toolrun`: `v0.3.0`
- `toolcode`: `v0.3.0`
- `toolruntime`: `v0.2.1`
- `toolsearch`: `v0.3.0`
- `metatools-mcp`: `v0.3.0`

Generated from `ai-tools-stack/go.mod`.

## ai-tools-stack
**Latest:** [0.2.0](https://github.com/jonwraymond/ai-tools-stack/compare/ai-tools-stack-v0.1.9...ai-tools-stack-v0.2.0)



### Features

* add dag-aware bump automation and pin metatools ([571afaf](https://github.com/jonwraymond/ai-tools-stack/commit/571afaf136f4610ddb08971e7f6521ec82bb975d))
* add pinned integration release train ([aaf43ce](https://github.com/jonwraymond/ai-tools-stack/commit/aaf43ceed6da0351a71dabceab1ed10c5ba5c08e))
* add version matrix sync script ([05c9415](https://github.com/jonwraymond/ai-tools-stack/commit/05c941507759a05ceaea511f61f0a932394f3ef8))


### Bug Fixes

* correct release-please step id ([6106b51](https://github.com/jonwraymond/ai-tools-stack/commit/6106b51d5c6c755147877461597a48725b8b956e))
* simplify release-please token handling ([aa3d8b9](https://github.com/jonwraymond/ai-tools-stack/commit/aa3d8b935a6c21ba77d3bccd2ed926c3bae4b452))
* **test:** handle toolcodeengine.New error ([#2](https://github.com/jonwraymond/ai-tools-stack/issues/2)) ([7a9b29f](https://github.com/jonwraymond/ai-tools-stack/commit/7a9b29fbff1fa782b0eb8094b0cc6dc0e437caa2))
* use app token for release-please ([5659996](https://github.com/jonwraymond/ai-tools-stack/commit/5659996e14ddeb4b572765ded2805c96b6570dc5))
* use PAT for release-please ([1ba5e64](https://github.com/jonwraymond/ai-tools-stack/commit/1ba5e642963419160b41d119644d9aacd7fd106d))

[Full changelog](https://github.com/jonwraymond/ai-tools-stack/blob/main/CHANGELOG.md)

## toolmodel
**Latest:** [0.2.0](https://github.com/jonwraymond/toolmodel/compare/toolmodel-v0.1.3...toolmodel-v0.2.0)



### Features

* add support for tool tags and normalization ([e72c0e6](https://github.com/jonwraymond/toolmodel/commit/e72c0e684cfa228d3b488efd5e67bfd8d364a9bf))


### Bug Fixes

* add ToolBackend validation and avoid schema mutation ([1e2bd12](https://github.com/jonwraymond/toolmodel/commit/1e2bd1287ca422ac5827b56a71f9fdb942fd3aba))
* correct release-please step id ([523b87b](https://github.com/jonwraymond/toolmodel/commit/523b87b5616b386b99fab0139e3e5bcbae87fc18))
* simplify release-please token handling ([951046d](https://github.com/jonwraymond/toolmodel/commit/951046d9fcf7c4765f19765980414760817523b2))
* use app token for release-please ([8ae5f64](https://github.com/jonwraymond/toolmodel/commit/8ae5f642e73ba882427671ac67cf0d9544f97d0f))
* use PAT for release-please ([4690c67](https://github.com/jonwraymond/toolmodel/commit/4690c67ee64a4b7f72d197df351192c35cd49e95))

[Full changelog](https://github.com/jonwraymond/toolmodel/blob/main/CHANGELOG.md)

## toolindex
**Latest:** [0.3.0](https://github.com/jonwraymond/toolindex/compare/toolindex-v0.2.0...toolindex-v0.3.0)



### Features

* enforce deterministic searcher for pagination ([962da40](https://github.com/jonwraymond/toolindex/commit/962da40e72df6a5ad07d993f44824e965a1108b2))
* **mcp:** add cursor-based pagination ([5f0f95c](https://github.com/jonwraymond/toolindex/commit/5f0f95ca326643b5a789251e516e874af3e9dc7c))
* **mcp:** add cursor-based pagination ([88d0a81](https://github.com/jonwraymond/toolindex/commit/88d0a8123a2eab3ed71720d616715999f21e7c89))

[Full changelog](https://github.com/jonwraymond/toolindex/blob/main/CHANGELOG.md)

## tooldocs
**Latest:** [0.2.0](https://github.com/jonwraymond/tooldocs/compare/tooldocs-v0.1.11...tooldocs-v0.2.0)



### Features

* implement MCP-aligned tooldocs store ([88b6af8](https://github.com/jonwraymond/tooldocs/commit/88b6af8d7b22e91ddc0ff79f123531bc9036a443))


### Bug Fixes

* correct release-please step id ([880cd82](https://github.com/jonwraymond/tooldocs/commit/880cd82d1dc18ddca71a9b4064982be7f7d2ab47))
* enforce max examples on register ([31ffd19](https://github.com/jonwraymond/tooldocs/commit/31ffd1973256385f420677c44dd4402cdef9b7a0))
* revive warnings for ListExamples ([d9430e8](https://github.com/jonwraymond/tooldocs/commit/d9430e8cb716dfd80dfdf4a435689875ccc01bfe))
* simplify release-please token handling ([2452e72](https://github.com/jonwraymond/tooldocs/commit/2452e72c9cda9e430952a05d63de97c99ed3020f))
* use app token for release-please ([53a2b82](https://github.com/jonwraymond/tooldocs/commit/53a2b824f8f3e99d8b25370d6e54963b2ebb86ce))
* use PAT for release-please ([a425fbf](https://github.com/jonwraymond/tooldocs/commit/a425fbf876d551225dac1edd321c398fb40bfb77))

[Full changelog](https://github.com/jonwraymond/tooldocs/blob/main/CHANGELOG.md)

## toolrun
**Latest:** [0.3.0](https://github.com/jonwraymond/toolrun/compare/toolrun-v0.2.0...toolrun-v0.3.0)



### Features

* add progress callbacks and clarify cancellation ([0901636](https://github.com/jonwraymond/toolrun/commit/09016365e4e3fb73a048e2fca564a5e13c414026))
* **mcp:** add context cancellation propagation ([ab5580d](https://github.com/jonwraymond/toolrun/commit/ab5580d4517e5b7ec09a7d339a0392e1edda1e08))
* **mcp:** add context cancellation propagation ([55b51c5](https://github.com/jonwraymond/toolrun/commit/55b51c5348200092cc93f26cbd14e020d15ba3fd))

[Full changelog](https://github.com/jonwraymond/toolrun/blob/main/CHANGELOG.md)

## toolcode
**Latest:** [0.3.0](https://github.com/jonwraymond/toolcode/compare/toolcode-v0.2.0...toolcode-v0.3.0)



### Features

* add context to toolcode tools ([672e132](https://github.com/jonwraymond/toolcode/commit/672e132fba2896c532f446583ff7022ae8d517af))

[Full changelog](https://github.com/jonwraymond/toolcode/blob/main/CHANGELOG.md)

## toolruntime
**Latest:** [0.2.1](https://github.com/jonwraymond/toolruntime/compare/toolruntime-v0.2.0...toolruntime-v0.2.1)



### Bug Fixes

* honor context in stub backends ([f7afa6e](https://github.com/jonwraymond/toolruntime/commit/f7afa6e68d4bf2fcd8851f0055f1bc7bf0426809))
* propagate context through toolruntime gateway ([7972a29](https://github.com/jonwraymond/toolruntime/commit/7972a29eb04105636b73f9bc0a4b56903b1c2a87))

[Full changelog](https://github.com/jonwraymond/toolruntime/blob/main/CHANGELOG.md)

## toolsearch
**Latest:** [0.3.0](https://github.com/jonwraymond/toolsearch/compare/toolsearch-v0.2.0...toolsearch-v0.3.0)



### Features

* mark BM25 searcher deterministic ([efc51c8](https://github.com/jonwraymond/toolsearch/commit/efc51c8f075e860deb45861457ed4e8106c65472))
* mark BM25 searcher deterministic ([e43ae7a](https://github.com/jonwraymond/toolsearch/commit/e43ae7ad69a66c70e99325bd97b8cbd7370ea14f))

[Full changelog](https://github.com/jonwraymond/toolsearch/blob/main/CHANGELOG.md)

## metatools-mcp
**Latest:** [0.3.0](https://github.com/jonwraymond/metatools-mcp/compare/metatools-mcp-v0.2.0...metatools-mcp-v0.3.0)



### Features

* **mcp:** implement spec alignment per PRD-015 ([037326f](https://github.com/jonwraymond/metatools-mcp/commit/037326fbcc932e16dc761f773feea50fd63773fb))
* **mcp:** implement spec alignment per PRD-015 ([bae429c](https://github.com/jonwraymond/metatools-mcp/commit/bae429cb5c43ea8f785f1e67a3b870943bf9d01f))
* **mcp:** stabilize list_changed and add changelog ([7f191e8](https://github.com/jonwraymond/metatools-mcp/commit/7f191e8ceebed1a178f540912df51771293a54cc))
* progress notifications and cancellation codes ([dc1d9a2](https://github.com/jonwraymond/metatools-mcp/commit/dc1d9a2874938518c615de6064489ff0573d8447))


### Bug Fixes

* satisfy revive context parameter order ([c1fefe6](https://github.com/jonwraymond/metatools-mcp/commit/c1fefe6d9431a2cb0eff31c90e8f35a17c3764ec))

[Full changelog](https://github.com/jonwraymond/metatools-mcp/blob/main/CHANGELOG.md)

Generated by scripts/generate-combined-changelog.sh

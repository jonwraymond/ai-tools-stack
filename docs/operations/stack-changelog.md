# Stack Changelog

Aggregated highlights from each repo’s latest release. For full history, use each repo’s CHANGELOG.

## Version matrix
### Version compatibility (current tags)

- `toolmodel`: `v0.2.0`
- `tooladapter`: `v0.2.0`
- `toolset`: `v1.0.1`
- `toolindex`: `v0.3.0`
- `tooldocs`: `v0.2.0`
- `toolrun`: `v0.3.0`
- `toolcode`: `v0.3.0`
- `toolruntime`: `v0.2.1`
- `toolsearch`: `v0.3.0`
- `toolobserve`: `v0.2.0`
- `toolcache`: `v0.2.0`
- `toolsemantic`: `v0.2.0`
- `toolskill`: `v0.2.0`
- `metatools-mcp`: `v0.4.0`

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

## tooladapter
**Latest:** [0.2.0](https://github.com/jonwraymond/tooladapter/compare/tooladapter-v0.1.0...tooladapter-v0.2.0)



### Features

* **tooladapter:** add Adapter interface and SchemaFeature ([94a0617](https://github.com/jonwraymond/tooladapter/commit/94a06173efdc2eafb6eaaa7c9ba2c02856a22402))
* **tooladapter:** add AdapterRegistry ([5d947b1](https://github.com/jonwraymond/tooladapter/commit/5d947b18158adc4b5654c24be4a959b69f893258))
* **tooladapter:** add Anthropic adapter ([fe5c4f5](https://github.com/jonwraymond/tooladapter/commit/fe5c4f5d67c0f3da3b6f67ddbe258a36a253d102))
* **tooladapter:** add CanonicalTool and JSONSchema ([5aff5f2](https://github.com/jonwraymond/tooladapter/commit/5aff5f2654dd7ea81301df62401b87c1f163f3c7))
* **tooladapter:** add MCP adapter ([cb3d86e](https://github.com/jonwraymond/tooladapter/commit/cb3d86ed7fc22e7e16fe9484b192cc73f65e38a0))
* **tooladapter:** add OpenAI adapter ([3472725](https://github.com/jonwraymond/tooladapter/commit/347272560a78a374257b469e7b5132047116b4eb))

[Full changelog](https://github.com/jonwraymond/tooladapter/blob/main/CHANGELOG.md)

## toolset
**Latest:** [1.0.1](https://github.com/jonwraymond/toolset/compare/v1.0.0...v1.0.1)


### Chores

- bump tooladapter dependency to v0.2.0

[Full changelog](https://github.com/jonwraymond/toolset/blob/main/CHANGELOG.md)

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

## toolobserve
**Latest:** [0.2.0](https://github.com/jonwraymond/toolobserve/compare/toolobserve-v0.1.0...toolobserve-v0.2.0)



### Features

* **toolobserve:** add config validation and observer core ([e717465](https://github.com/jonwraymond/toolobserve/commit/e717465e21e075eadfd04df68b8547074280e2e5))
* **toolobserve:** add execution middleware ([bfde9bf](https://github.com/jonwraymond/toolobserve/commit/bfde9bf35f6c8969bb81ea145064f08718b0b0f3))
* **toolobserve:** add exporter configuration ([f2697e8](https://github.com/jonwraymond/toolobserve/commit/f2697e80c4c71ad5c6bae055957712fade01da3c))
* **toolobserve:** add metrics ([1869b3f](https://github.com/jonwraymond/toolobserve/commit/1869b3f72af0d4f4e024a65483f497624c691cfc))
* **toolobserve:** add structured logger ([c6e651c](https://github.com/jonwraymond/toolobserve/commit/c6e651cd314f1a999c5cf3f782fcdc0aa4119d51))
* **toolobserve:** add tracing ([437cac2](https://github.com/jonwraymond/toolobserve/commit/437cac2eeafca9903b41928801f6812ea3a413de))


### Bug Fixes

* **toolobserve:** wire exporters and structured logger ([0e6213a](https://github.com/jonwraymond/toolobserve/commit/0e6213a408188f5236243e5b12362719fed25ea1))

[Full changelog](https://github.com/jonwraymond/toolobserve/blob/main/CHANGELOG.md)

## toolcache
**Latest:** [0.2.0](https://github.com/jonwraymond/toolcache/compare/toolcache-v0.1.0...toolcache-v0.2.0)



### Features

* **toolcache:** add cache primitives and middleware ([3656e97](https://github.com/jonwraymond/toolcache/commit/3656e97fbdccbeb3a2eff47f7d6b936604e10ed4))

[Full changelog](https://github.com/jonwraymond/toolcache/blob/main/CHANGELOG.md)

## toolsemantic
**Latest:** [0.2.0](https://github.com/jonwraymond/toolsemantic/compare/toolsemantic-v0.1.0...toolsemantic-v0.2.0)



### Features

* **toolsemantic:** add document model ([39c83c2](https://github.com/jonwraymond/toolsemantic/commit/39c83c20b5b0bc3cb5e776afa78252f686e7a6b7))
* **toolsemantic:** add filters ([8116bbd](https://github.com/jonwraymond/toolsemantic/commit/8116bbd24427892b5510b2e1dc45a20a38741baf))
* **toolsemantic:** add in-memory indexer ([236b989](https://github.com/jonwraymond/toolsemantic/commit/236b989ff3da5211eac4c61264bd0a5cd52cfb67))
* **toolsemantic:** add scoring strategies ([ebbfc11](https://github.com/jonwraymond/toolsemantic/commit/ebbfc11c0f172a76d363ba12d9c31810c5353097))
* **toolsemantic:** add searcher interface ([9ac507b](https://github.com/jonwraymond/toolsemantic/commit/9ac507b55e2a890c3d504018ac9505b41bb62571))

[Full changelog](https://github.com/jonwraymond/toolsemantic/blob/main/CHANGELOG.md)

## toolskill
**Latest:** [0.2.0](https://github.com/jonwraymond/toolskill/compare/toolskill-v0.1.0...toolskill-v0.2.0)



### Features

* **toolskill:** add deterministic planner ([1c168b1](https://github.com/jonwraymond/toolskill/commit/1c168b1689fc14271d33af08a6c037b6e2ac01eb))
* **toolskill:** add execution adapter ([efe087a](https://github.com/jonwraymond/toolskill/commit/efe087a81bf80306546510c8879e265f4cfcd762))
* **toolskill:** add guard policies ([7171124](https://github.com/jonwraymond/toolskill/commit/7171124fe49e9489e0dfb11c464f2434a1afb569))
* **toolskill:** add skill and step models ([766c561](https://github.com/jonwraymond/toolskill/commit/766c561c03dae7e8d93576d9015314dcaa2ecb40))

[Full changelog](https://github.com/jonwraymond/toolskill/blob/main/CHANGELOG.md)

## metatools-mcp
**Latest:** [0.4.0](https://github.com/jonwraymond/metatools-mcp/compare/metatools-mcp-v0.3.0...metatools-mcp-v0.4.0)



### Features

* **backend:** add registry, local backend, and adapter ([cd0f8a1](https://github.com/jonwraymond/metatools-mcp/commit/cd0f8a1204b6e55d6564dc182148a4bd4c4a9b87))
* **cli:** add Cobra foundation ([bc492ad](https://github.com/jonwraymond/metatools-mcp/commit/bc492adea64eb1c14daf4f26497a83339fac7f1f))
* **config:** add Koanf config layer (PRD-003) ([7fa2403](https://github.com/jonwraymond/metatools-mcp/commit/7fa2403c6b77a23442c2a4929c779d78d6a157d0))
* **middleware:** add middleware chain and config ([4f70bd2](https://github.com/jonwraymond/metatools-mcp/commit/4f70bd2d6579f1aaeb841c36c6ff8ce161ee0e5a))
* **server:** add provider registry and built-in providers ([3c8124f](https://github.com/jonwraymond/metatools-mcp/commit/3c8124f65b9ed388b6ddaff3827beda46ce1d721))
* **transport:** add SSE transport abstraction (PRD-004) ([aa42715](https://github.com/jonwraymond/metatools-mcp/commit/aa4271596d49014f397e230c75663d06a3f60d6f))


### Bug Fixes

* **backend:** address lint issues ([550ebb2](https://github.com/jonwraymond/metatools-mcp/commit/550ebb2a26b527463b0d673b0b6c93bb1084a89c))
* **backend:** silence revive unused params ([70698eb](https://github.com/jonwraymond/metatools-mcp/commit/70698ebc56e165a63583eba546ec8cae912355b5))
* **middleware:** resolve lint in tests and config ([a306e51](https://github.com/jonwraymond/metatools-mcp/commit/a306e51cf3edc59fa53e5875f50791c2ac016228))
* **middleware:** resolve revive unused params ([f87f926](https://github.com/jonwraymond/metatools-mcp/commit/f87f92600bcff0fc82eb2c0e2b4554df70e7e8e6))

[Full changelog](https://github.com/jonwraymond/metatools-mcp/blob/main/CHANGELOG.md)

Generated by scripts/generate-combined-changelog.sh

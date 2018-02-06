# v0.2.1 2018-02-06

### Fixed

* Using `read` types in schemas no longer breaks indexing (solnic)

[Compare v0.2.0...v0.2.1](https://github.com/rom-rb/rom/compare/v0.2.0...v0.2.1)

# v0.2.0 2018-01-23

### Added

* `Relation#order` which sets `:sort` (solnic)
* `Relation#page` which sets `:from` offset (solnic)
* `Relation#per_page` which sets `:size` (solnic)
* `Relation#call` returns custom `ROM::Elasticsearch::Relation::Loaded` object, which provides access to `#total_hits` and raw client response (solnic)

[Compare v0.1.1...v0.2.0](https://github.com/rom-rb/rom/compare/v0.1.1...v0.2.0)

# v0.1.1 2017-11-18

### Changed

* Connection URI is passed directly to the ES client now (solnic)

# v0.1.0 2017-11-17

First public release

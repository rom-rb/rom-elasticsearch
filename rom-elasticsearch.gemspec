# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rom/elasticsearch/version'

Gem::Specification.new do |spec|
  spec.name          = 'rom-elasticsearch'
  spec.version       = Rom::Elasticsearch::VERSION
  spec.authors       = ['Hannes Nevalainen']
  spec.email         = ['hannes.nevalainen@me.com']
  spec.summary       = %q{Experimental ROM adapter for Elasticsearch}
  spec.description   = %q{}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'rom-core', '~> 4.1'
  spec.add_runtime_dependency 'elasticsearch', '~> 6.0'

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'inflecto'
end

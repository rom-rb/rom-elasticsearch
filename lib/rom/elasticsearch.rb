require 'rom'
require 'rom/elasticsearch/version'
require 'rom/elasticsearch/relation'
require 'rom/elasticsearch/gateway'

ROM.register_adapter(:elasticsearch, ROM::Elasticsearch)

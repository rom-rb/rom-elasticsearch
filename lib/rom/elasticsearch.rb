# frozen_string_literal: true

require 'rom'

require 'rom/elasticsearch/version'
require 'rom/elasticsearch/gateway'
require 'rom/elasticsearch/relation'
require 'rom/elasticsearch/commands'

ROM.register_adapter(:elasticsearch, ROM::Elasticsearch)

# frozen_string_literal: true

require 'rom/core'

require 'rom/elasticsearch/version'
require 'rom/elasticsearch/gateway'
require 'rom/elasticsearch/relation'
require 'rom/elasticsearch/commands'

ROM.register_adapter(:elasticsearch, ROM::Elasticsearch)

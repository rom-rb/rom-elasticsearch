require 'rom/gateway'
require 'rom/elasticsearch/dataset'
require 'rom/elasticsearch/relation'
require 'rom/elasticsearch/query_methods'
require 'rom/elasticsearch/commands'
require 'dry/core/inflector'
require 'elasticsearch'
require 'uri'

module ROM
  module Elasticsearch
    class Gateway < ROM::Gateway
      class << self
        def from_uri(url, **options)
          new(url, options)
        end
      end

      adapter :elasticsearch

      attr_reader :client, :root

      def initialize(url, log: false)
        url = URI.parse(url)
        @client = ::Elasticsearch::Client.new(host: "#{url.host}:#{url.port || 9200}", log: log)
        @root = Dataset.new(@client, params: { index: url.path[1..-1] })
      end

      def dataset?(index)
        client.indices.exists?(index: index)
      end
      alias_method :index?, :dataset?

      def [](type)
        root.params(type: Dry::Core::Inflector.singularize(type))
      end
      alias_method :dataset, :[]

      def delete_index(name)
        client.indices.delete(index: name)
      end

      def create_index(name)
        client.indices.create(index: name)
      end
    end
  end
end

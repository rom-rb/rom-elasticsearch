require 'elasticsearch'

require 'rom/gateway'
require 'rom/elasticsearch/dataset'
require 'rom/elasticsearch/commands'

module ROM
  module Elasticsearch
    class Gateway < ROM::Gateway
      attr_reader :index, :datasets

      def initialize(options)
        raise NoIndexProvidedError unless options.key?(:index)

        @index = options[:index]
        @connection = ::Elasticsearch::Client.new(options)
        @datasets = {}
      end

      def [](name)
        datasets[name.to_s]
      end

      def dataset(name)
        datasets[name.to_s] = Dataset.new(connection, index: index, type: name)
      end

      def dataset?(name)
        connection.indices.exists(index: index)
      end
    end
  end
end

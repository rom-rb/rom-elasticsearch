require 'rom/elasticsearch/helpers'
require 'rom/elasticsearch/errors'

module ROM
  module Elasticsearch
    class Dataset
      include Helpers

      attr_reader :client, :options

      def initialize(client, options)
        @client, @options = client, options
      end

      def insert(data)
        client.index(options.merge(body: data))
      end

      alias_method :<<, :insert

      def update(data, id = options[:id])
        client.update(options.merge(id: id, body: {doc: data}))
      end

      def delete(id = options[:id])
        client.delete(options.merge(id: id))
      end

      def delete_by(query)
        client.delete_by_query(options.merge(body: {query: query}))
      end

      def delete_all
        delete_by(match_all: {})
      end

      def search(options)
        with_options(options)
      end

      def get(id = options[:id])
        with_options(options.merge(id: id))
      end

      def filter(filter)
        with_options(body: options.fetch(:body, {}).merge(filter: filter))
      end

      def query(query)
        with_options(body: options.fetch(:body, {}).merge(query: query))
      end

      def query_string(expression)
        query(query_string: {query: expression})
      end

      def to_a
        view
      end

      def each(&block)
        view.each(&block)
      rescue ::Elasticsearch::Transport::Transport::Error => ex
        raise SearchError.new(ex, options)
      end

    private

      def view
        results = if options[:id]
          [client.get(options)]
        else
          client.search(options).fetch('hits').fetch('hits')
        end

        results.map do |item|
          result = {}
          result.merge!(collect_service_fields(item))
          result.merge!(item['_source'])
          deep_symbolize_keys(result)
        end
      end

      def with_options(new_options)
        self.class.new(client, options.merge(new_options))
      end
    end
  end
end

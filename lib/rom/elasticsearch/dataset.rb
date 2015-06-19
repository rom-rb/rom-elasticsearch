require 'rom/elasticsearch/query_methods'
require 'rom/elasticsearch/errors'

module ROM
  module Elasticsearch
    class Dataset
      include QueryMethods

      attr_reader :client, :options

      def initialize(client, options)
        @client, @options = client, options
      end

      def create(data)
        client.index(options.merge(body: data))
      end

      def update(data, id = options[:id])
        client.update(options.merge(id: id, body: {doc: data}))
      end

      def delete(id = options[:id])
        client.delete(options.merge(id: id))
      end

      def delete_all
        client.delete_by_query(options.merge(body: {query: {match_all: {}}}))
      end

      def with_options(new_opts)
        Dataset.new(client, options.merge(new_opts))
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
          [Hash[client.get(options)]] # TODO Figure out why the [Hash[result]] part i s needed
        else
          client.search(options).fetch('hits').fetch('hits')
        end

        results.map do |result|
          result = result.merge(result['_source'])
          result.delete('_source')
          result
        end
      end
    end
  end
end

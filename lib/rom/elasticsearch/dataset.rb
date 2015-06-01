require 'rom/elasticsearch/query_methods'

module ROM
  module Elasticsearch
    class Error < StandardError
      def initialize(wrapped_error)
        super(wrapped_error.message)
        @wrapped_error = wrapped_error
      end

      attr_reader :wrapped_error
    end
    class SearchError < Error
      def initialize(wrapped_error, query)
        super(wrapped_error)
        @query = query
      end

      attr_reader :query
    end
    class Dataset
      def initialize(client, options)
        @client = client
        @options = options
      end

      include QueryMethods

      def index(data)
        client.index(options.merge(body: data))
      end

      def with_options(new_opts)
        Dataset.new(@client, options.merge(new_opts))
      end

      def delete(id = options[:id])
        client.delete(options.merge(id: id))
      end

      def delete_all
        client.delete_by_query(options.merge(body: {query: {match_all: {}}}))
      end

      def to_a
        view
      end

      def each(&block)
        view.each(&block)
      rescue ::Elasticsearch::Transport::Transport::Error => ex
        raise SearchError.new(ex, options)
      end

      attr_reader :client

      private
      def view
        if options[:id]
          [Hash[client.get(options)]] # TODO Figure out why the [Hash[result]] part i s needed
        else
          client.search(options).fetch('hits').fetch('hits')
        end
      end

      attr_reader :options
    end
  end
end
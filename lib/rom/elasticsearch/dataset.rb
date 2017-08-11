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
      extend Initializer

      ALL = { query: { match_all: EMPTY_HASH } }.freeze

      param :client

      option :params, optional: true, default: -> { EMPTY_HASH }
      option :body, optional: true, default: -> { EMPTY_HASH }

      include QueryMethods

      def put(data)
        client.index(**params, body: data)
      end

      def delete(id = params[:id])
        client.delete(id)
      end

      def delete_all
        client.delete_by_query(**params, body: body.merge(ALL))
      end

      def to_a
        view
      end

      def each(&block)
        view.each(&block)
      rescue ::Elasticsearch::Transport::Transport::Error => ex
        raise SearchError.new(ex, options)
      end

      def type
        params[:type]
      end

      def index
        params[:index]
      end

      attr_reader :client

      def body(new = EMPTY_HASH)
        if new.empty?
          @body
        else
          with(body: body.merge(new))
        end
      end

      def params(new = EMPTY_HASH)
        if new.empty?
          @params
        else
          with(params: params.merge(new))
        end
      end

      def wait
        params(refresh: 'wait_for')
      end

      private

      def view
        if params[:id]
          [Hash[client.get(params)]] # TODO Figure out why the [Hash[result]] part i s needed
        else
          client.search(**params, body: body).fetch('hits').fetch('hits')
        end
      end
    end
  end
end

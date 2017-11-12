require 'rom/elasticsearch/query_methods'
require 'rom/elasticsearch/errors'

module ROM
  module Elasticsearch
    # ElasticSearch dataset
    #
    # @api public
    class Dataset
      extend Initializer

      include QueryMethods

      ALL = { query: { match_all: EMPTY_HASH } }.freeze

      # @!attribute [r] client
      #   @return [::Elasticsearch::Client] configured client from the gateway
      param :client

      # @!attribute [r] params
      #   @return [Hash] default params
      option :params, optional: true, default: -> { EMPTY_HASH }

      # @!attribute [r] client
      #   @return [Hash] default body
      option :body, optional: true, default: -> { EMPTY_HASH }

      # Put new data
      #
      # @param [Hash] data
      #
      # @return [Hash]
      #
      # @api public
      def put(data)
        client.index(**params, body: data)
      end

      # Delete by id
      #
      # @return [Hash]
      #
      # @api public
      def delete(id = params[:id])
        client.delete(id)
      end

      # Delete everything matching configured params and body
      #
      # @api public
      def delete_all
        client.delete_by_query(**params, body: body.merge(ALL))
      end

      # Materialize dataset
      #
      # @return [Array<Hash>]
      def to_a
        view
      end

      # Materialize and iterate over results
      #
      # @api public
      def each(&block)
        view.each(&block)
      rescue ::Elasticsearch::Transport::Transport::Error => ex
        raise SearchError.new(ex, options)
      end

      # Return configured type from params
      #
      # @return [String]
      #
      # @api public
      def type
        params[:type]
      end

      # Return configured index name
      #
      # @return [String]
      #
      # @api public
      def index
        params[:index]
      end

      attr_reader :client

      # Return a new dataset with new body
      #
      # @param [Hash] new New body data
      #
      # @return [Hash]
      #
      # @api public
      def body(new = EMPTY_HASH)
        if new.empty?
          @body
        else
          with(body: body.merge(new))
        end
      end

      # Return a new dataset with new params
      #
      # @param [Hash] new New params data
      #
      # @return [Hash]
      #
      # @api public
      def params(new = EMPTY_HASH)
        if new.empty?
          @params
        else
          with(params: params.merge(new))
        end
      end

      # Return a new dataset with 'wait_for' configured
      #
      # @api public
      def wait
        params(refresh: 'wait_for')
      end

      private

      # Return results of a query based on configured params and body
      #
      # @return [Array<Hash>]
      #
      # @api private
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

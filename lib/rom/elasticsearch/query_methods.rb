require 'rom/elasticsearch/errors'

module ROM
  module Elasticsearch
    # Dataset's query methods
    #
    # @see Dataset
    #
    # @api public
    module QueryMethods
      # Return a new dataset configured to search by :id
      #
      # @param [Integer] id
      #
      # @return [Dataset]
      #
      # @see Relation#get
      #
      # @api public
      def get(id)
        params(id: id)
      end

      # Return a new dataset configured to search via new body options
      #
      # @param [Hash] options Body options
      #
      # @return [Dataset]
      #
      # @see Relation#search
      #
      # @api public
      def search(options)
        body(options)
      end

      # Return a new dataset configured to search via :query_string body option
      #
      # @param [String] expression A string query
      #
      # @return [Dataset]
      #
      # @see Relation#query_string
      #
      # @api public
      def query_string(expression)
        query(query_string: { query: expression })
      end

      # Return a new dataset configured to search via :query body option
      #
      # @param [Hash] query A query hash
      #
      # @return [Dataset]
      #
      # @see Relation#query
      #
      # @api public
      def query(query)
        body(query: query)
      end
    end
  end
end

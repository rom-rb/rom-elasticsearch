require 'rom/elasticsearch/errors'

module ROM
  module Elasticsearch
    # @api public
    module QueryMethods
      # Return a new dataset configured to search by :id
      #
      # @param [Integer] id
      #
      # @return [Dataset]
      #
      # @api public
      def get(id)
        params(id: id)
      end

      # Return a new dataset configured to search via :filter body option
      #
      # @param [Integer] id
      #
      # @return [Dataset]
      #
      # @api public
      def filter(filter)
        body(filter: filter)
      end

      # Return a new dataset configured to search via new body options
      #
      # @param [Integer] id
      #
      # @return [Dataset]
      #
      # @api public
      def search(options)
        body(options)
      end

      # Return a new dataset configured to search via :query_string body option
      #
      # @param [Integer] id
      #
      # @return [Dataset]
      #
      # @api public
      def query_string(expression)
        query(query_string: { query: expression })
      end

      # Return a new dataset configured to search via :query body option
      #
      # @param [Integer] id
      #
      # @return [Dataset]
      #
      # @api public
      def query(query)
        body(query: query)
      end
    end
  end
end

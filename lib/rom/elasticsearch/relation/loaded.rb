# frozen_string_literal: true

module ROM
  module Elasticsearch
    class Relation < ROM::Relation
      # Materialized index data
      #
      # @api public
      class Loaded < ROM::Relation::Loaded
        # Return total number of hits
        #
        # @return [Integer]
        #
        # @api public
        def total_hits
          response['hits']['total']['value']
        end

        # Return raw response from the ES client
        #
        # @return [Hash]
        #
        # @api public
        def response
          source.dataset.options[:response]
        end
      end
    end
  end
end

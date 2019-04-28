# frozen_string_literal: true

module ROM
  module Elasticsearch
    # @api private
    class Error < StandardError
      def initialize(wrapped_error)
        super(wrapped_error.message)
        @wrapped_error = wrapped_error
      end

      attr_reader :wrapped_error
    end

    # @api private
    class SearchError < Error
      attr_reader :query

      def initialize(wrapped_error, query)
        super(wrapped_error)
        @query = query
      end
    end
  end
end

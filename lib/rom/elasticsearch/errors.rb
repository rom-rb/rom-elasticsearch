module ROM
  module Elasticsearch
    class Error < StandardError
      def initialize(wrapped_error)
        super(wrapped_error.message)
        @wrapped_error = wrapped_error
      end

      attr_reader :wrapped_error
    end

    class NoIndexProvidedError < StandardError
    end

    class SearchError < Error
      def initialize(wrapped_error, query)
        super(wrapped_error)
        @query = query
      end

      attr_reader :query
    end
  end
end

module ROM
  module Elasticsearch
    module QueryMethods
      def get(id = options[:id])
        with_options(options.merge(id: id))
      end

      def filter(filter)
        with_options(body: options.fetch(:body, {}).merge(filter: filter))
      end

      def search(options)
        with_options(options)
      end

      def query_string(expression)
        query(query_string: {query: expression})
      end

      def query(query)
        with_options(body: options.fetch(:body, {}).merge(query: query))
      end
    end
  end
end
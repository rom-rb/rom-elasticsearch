module ROM
  module Elasticsearch
    module QueryMethods
      def get(id = options[:id])
        params(id: id)
      end

      def filter(filter)
        body(filter: filter)
      end

      def search(options)
        body(options)
      end

      def query_string(expression)
        query(query_string: { query: expression })
      end

      def query(query)
        body(query: query)
      end
    end
  end
end

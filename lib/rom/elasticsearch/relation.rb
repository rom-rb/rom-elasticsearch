require 'rom/relation'
require 'rom/elasticsearch/query_methods'
require 'rom/elasticsearch/schema'

module ROM
  module Elasticsearch
    # Elasticsearch relation API
    #
    # @api public
    class Relation < ROM::Relation
      adapter :elasticsearch

      defines :index

      schema_class Elasticsearch::Schema

      dataset { index ? with(params: { index: index }) : self }

      forward :wait
      forward(*QueryMethods.public_instance_methods(false))

      # Overridden output_schema, as we *always* want to use it,
      # whereas in core, it is only used when there's at least one read-type
      option :output_schema, default: -> { schema.to_output_hash }

      # @api public
      def insert(tuple)
        dataset.put(tuple)
      end
    end
  end
end

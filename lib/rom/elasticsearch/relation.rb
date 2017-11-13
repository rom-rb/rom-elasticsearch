require 'rom/relation'
require 'rom/elasticsearch/query_methods'
require 'rom/elasticsearch/schema'

module ROM
  module Elasticsearch
    # An error raised when methods that rely on configured :index are called
    # on a relation which does not have the index defined
    #
    # @api public
    class MissingIndexError < StandardError
      # @api private
      def initialize(name)
        super "relation #{name.inspect} doesn't have :index configured"
      end
    end

    # Elasticsearch relation API
    #
    # @api public
    class Relation < ROM::Relation
      adapter :elasticsearch

      defines :index

      schema_class Elasticsearch::Schema

      forward :wait
      forward(*QueryMethods.public_instance_methods(false))

      # Overridden output_schema, as we *always* want to use it,
      # whereas in core, it is only used when there's at least one read-type
      option :output_schema, default: -> { schema.to_output_hash }

      # @api private
      def self.inherited(klass)
        super

        klass.class_eval do
          dataset do
            klass.index ? with(params: { index: klass.index }) : self
          end
        end
      end

      # @api public
      def insert(tuple)
        dataset.put(tuple)
      end

      # @api public
      def create_index
        index = self.class.index

        if index
          dataset.create_index(index: index)
        else
          raise MissingIndexError, name
        end
      end
    end
  end
end

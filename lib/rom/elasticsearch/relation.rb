require 'rom/relation'
require 'rom/elasticsearch/query_methods'
require 'rom/elasticsearch/schema'
require 'rom/elasticsearch/attribute'

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

      defines :index_settings

      schema_class Elasticsearch::Schema
      schema_attr_class Elasticsearch::Attribute

      forward :wait
      forward(*QueryMethods.public_instance_methods(false))

      # Overridden output_schema, as we *always* want to use it,
      # whereas in core, it is only used when there's at least one read-type
      option :output_schema, default: -> { schema.to_output_hash }

      index_settings(
        { number_of_shards: 1,
          index: {
            analysis: {
              analyzer: {
                standard_stopwords: {
                  type: "standard",
                  stopwords: "_english_"
                }
              }
            }
          } }.freeze
      )

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
        settings = self.class.index_settings

        if index
          dataset.create_index(
            index: index,
            body: {
              settings: settings,
              mappings: { dataset.type => { properties: schema.to_properties } }
            }
          )
        else
          raise MissingIndexError, name
        end
      end

      # @api public
      def delete_index
        index = self.class.index

        if index
          dataset.delete_index(index: index)
        else
          raise MissingIndexError, name
        end
      end
    end
  end
end

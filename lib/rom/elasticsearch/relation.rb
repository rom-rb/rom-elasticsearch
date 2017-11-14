require 'rom/relation'
require 'rom/elasticsearch/schema'
require 'rom/elasticsearch/attribute'

module ROM
  module Elasticsearch
    # Elasticsearch relation API
    #
    # @api public
    class Relation < ROM::Relation
      adapter :elasticsearch

      defines :index_name

      defines :index_type

      defines :index_settings

      schema_class Elasticsearch::Schema
      schema_attr_class Elasticsearch::Attribute

      forward :wait

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
            if klass.dataset_params.empty?
              self
            else
              params(klass.dataset_params)
            end
          end
        end
      end

      # @api private
      def self.dataset_params
        @__dataset_params__ ||=
          if index_name && index_type
            { index: index_name, type: index_type }
          elsif index_type
            { type: index_type }
          elsif index_name
            { index: index_name }
          else
            {}
          end
      end

      # @api public
      def get(id)
        new(dataset.get(id))
      end

      # @api public
      def search(options)
        new(dataset.search(options))
      end

      # @api public
      def query(query)
        new(dataset.query(query))
      end

      # @api public
      def query_string(expr)
        new(dataset.query_string(expr))
      end

      # @api public
      def create_index
        dataset.create_index(index_params)
      end

      # @api public
      def delete_index
        dataset.delete_index
      end

      # @api public
      def delete
        dataset.wait.delete_all
      end

      private

      def index_params
        self.class.dataset_params.merge(
          body: {
            settings: self.class.index_settings,
            mappings: { dataset.type => { properties: schema.to_properties } }
          }
        )
      end
    end
  end
end

require 'rom/relation'
require 'rom/elasticsearch/types'
require 'rom/elasticsearch/schema'
require 'rom/elasticsearch/attribute'

module ROM
  module Elasticsearch
    # Elasticsearch relation API
    #
    # Provides access to indexed data, and methods for managing indices.
    # Works like a standard Relation, which means it's lazy and composable,
    # and has access to commands via `Relation#command`.
    #
    # Indices are configured based on two settings:
    # - `Relation#name.dataset` - which is configured in a standard way via `schema` block
    # - `Relation.index_settings` - which is a class-level setting
    #
    # Optionally, query DSL can be enabled via `:query_dsl` plugin.
    #
    # @example setting up a relation
    #   class Pages < ROM::Relation[:elasticsearch]
    #     schema do
    #       attribute :id, Types::ID
    #       attribute :title, Types.Keyword
    #       attribute :body, Types.Text(analyzer: "snowball")
    #     end
    #   end
    #
    # @example using query DSL
    #   class Users < ROM::Relation[:elasticsearch]
    #     use :query_dsl
    #
    #     schema do
    #       # ...
    #     end
    #   end
    #
    #   users.search do
    #     query do
    #       match name: "Jane"
    #     end
    #   end
    #
    # @api public
    class Relation < ROM::Relation
      include ROM::Elasticsearch

      adapter :elasticsearch

      # @!method self.index_settings
      #   Manage the index_settings
      #
      #   This is set by default to:
      #
      #   ``` ruby
      #   { number_of_shards: 1,
      #     index: {
      #       analysis: {
      #         analyzer: {
      #           standard_stopwords: {
      #             type: "standard",
      #             stopwords: "_english_"
      #           }
      #         }
      #       }
      #   } }.freeze
      #   ```
      #
      #   @overload index_settings
      #     Return the index_settings that the relation will use
      #     @return [Hash]
      #
      #   @overload index_settings(settings)
      #     Set index settings
      #
      #     @see https://www.elastic.co/guide/en/elasticsearch/guide/current/index-management.html
      #
      #     @example
      #       class Users < ROM::Relation[:elasticsearch]
      #         index_settings(
      #           # your custom settings
      #         )
      #
      #         schema do
      #           # ...
      #         end
      #       end
      #
      #     @param [Hash] index_settings_hash
      defines :index_settings

      schema_class Elasticsearch::Schema
      schema_attr_class Elasticsearch::Attribute

      # Overridden output_schema, as we *always* want to use it,
      # whereas in core, it is only used when there's at least one read-type
      option :output_schema, default: -> { schema.to_output_hash }

      # Default index settings that can be overridden
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

      # Map indexed data
      #
      # @yieldparam [Hash,ROM::Struct]
      #
      # @return [Array<Hash,ROM::Struct>]
      #
      # @api public
      def map(&block)
        to_a.map(&block)
      end

      # Pluck specific attribute values
      #
      # @param [Symbol] name The name of the attribute
      #
      # @return [Array]
      #
      # @api public
      def pluck(name)
        map { |t| t[name] }
      end

      # Restrict indexed data by id
      #
      # @return [Relation]
      #
      # @api public
      def get(id)
        new(dataset.get(id))
      end

      # Restrict relation data by a search query
      #
      # @example
      #   users.search(query: { match: { name: "Jane" } })
      #
      # @param [Hash] options Search options compatible with Elasticsearch::Client API
      #
      # @return [Relation]
      #
      # @api public
      def search(options)
        new(dataset.search(options))
      end

      # Restrict relation data by a query search
      #
      # @example
      #   users.query(match: { name: "Jane" })
      #
      # @param [Hash] query Query options compatible with Elasticsearch::Client API
      #
      # @return [Relation]
      #
      # @api public
      def query(query)
        new(dataset.query(query))
      end

      # Restrict relation data by a string-based query
      #
      # @example
      #   users.query_string("name:'Jane'")
      #
      # @param [Hash] query Query string compatible with Elasticsearch::Client API
      #
      # @return [Relation]
      #
      # @api public
      def query_string(expr)
        new(dataset.query_string(expr))
      end

      # Create relation's index in ES
      #
      # @return [Hash] raw response from the client
      #
      # @api public
      def create_index
        dataset.create_index(index_params)
      end

      # Delete relation's index in ES
      #
      # @return [Hash] raw response from the client
      #
      # @api public
      def delete_index
        dataset.delete_index
      end

      # Delete all indexed data from the current relation
      #
      # @return [Hash] raw response from the client
      #
      # @api public
      def delete
        dataset.delete
      end

      # Refresh indexed data
      #
      # @example
      #   users.command(:create).call(id: 1, name: "Jane").refresh.to_a
      #
      # @return [Relation]
      #
      # @api public
      def refresh
        new(dataset.refresh)
      end

      private

      # Dataset index params based on relation configuration
      #
      # @return [Hash]
      #
      # @api private
      def index_params
        { index: name.dataset,
          body: {
            settings: self.class.index_settings,
            mappings: { dataset.type => { properties: schema.to_properties } } } }
      end
    end
  end
end

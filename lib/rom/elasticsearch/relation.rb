# frozen_string_literal: true

require "rom/relation"

require "rom/elasticsearch/index_name"
require "rom/elasticsearch/relation/loaded"
require "rom/elasticsearch/types"
require "rom/elasticsearch/schema"
require "rom/elasticsearch/schema/dsl"
require "rom/elasticsearch/attribute"

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

      # @!method self.multi_index_types
      #   Manage index types for multi-index search
      #
      #   @overload multi_index_types
      #     @return [Array<Symbol>] a list of index types
      #
      #   @overload multi_index_types(types)
      #     @return [Array<Symbol>] a list of index types
      #
      #     @example
      #       class Search < ROM::Relation[:elasticsearch]
      #         multi_index_types :pages, :posts
      #
      #         schema(multi: true) do
      #           # define your schema
      #         end
      #       end
      defines :multi_index_types

      schema_dsl Elasticsearch::Schema::DSL
      schema_class Elasticsearch::Schema
      schema_attr_class Elasticsearch::Attribute

      # Overridden output_schema, as we *always* want to use it,
      # whereas in core, it is only used when there's at least one read-type
      option :output_schema, default: -> { schema.to_output_hash }

      # @attribute [r] current_page
      #   @return [Integer] Currently set page
      option :current_page, default: -> { 1 }

      # @attribute [r] per_page
      #   @return [Integer] Number of results per page
      option :per_page, reader: false, optional: true, default: -> { 10 }

      # Default index settings that can be overridden
      index_settings(
        {number_of_shards: 1,
         index: {
           analysis: {
             analyzer: {
               standard_stopwords: {
                 type: "standard",
                 stopwords: "_english_"
               }
             }
           }
         }}.freeze
      )

      # Define a schema for the relation
      #
      # @return [self]
      def self.schema(dataset = nil, multi: false, **opts, &block)
        if multi
          super(IndexName[:_all], **opts, &block)
        else
          super(dataset, **opts, &block)
        end
      end

      # Load a relation
      #
      # @return [Loaded]
      #
      # @api public
      def call
        Loaded.new(new(dataset.call))
      end

      # Return a relation with changed sorting logic
      #
      # @param [Array<Symbol,Attribute>] attrs
      #
      # @return [Relation]
      #
      # @api public
      def order(*attrs)
        new(dataset.sort(*schema.project(*attrs).map(&:to_sort_expr)))
      end

      # Return a relation with page number set
      #
      # @param [Integer] num
      #
      # @return [Relation]
      #
      # @api public
      def page(num)
        new(dataset.from((num - 1) * per_page), current_page: num)
      end

      # Return a relation with per-page number set
      #
      # @param [Integer] num
      #
      # @return [Relation]
      #
      # @api public
      def per_page(num = Undefined)
        if num.equal?(Undefined)
          options[:per_page]
        else
          new(dataset.size(num), per_page: num)
        end
      end

      # Return a relation with scroll set
      #
      # @param [String] ttl
      #
      # @return [Relation]
      #
      # @api public
      def scroll(ttl)
        new(dataset.scroll(ttl))
      end

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

      # Return count of documents in the index
      #
      # @example
      #   users.count
      #   GET /_count
      #
      # @example
      #   users.search(<query>).count
      #   GET /_count?q=<query>
      #
      # @return [Integer]
      #
      # @api public
      def count
        dataset.client.count(
          index: dataset.index,
          body: dataset.body
        )["count"]
      end

      # Restrict relation data by offset
      #
      # @example
      #   users.search.from(100)
      #   GET /_search?from=100
      #
      # @return [Integer]
      #
      # @api public
      def from(value)
        new(dataset.from(value))
      end

      # Restrict relation data by limit the count of documents
      #
      # @example
      #   users.search.size(100)
      #   GET /_search?size=100
      #
      # @return [Integer]
      #
      # @api public
      def size(value)
        new(dataset.size(value))
      end

      private

      # Dataset index params based on relation configuration
      #
      # @return [Hash]
      #
      # @api private
      def index_params
        {index: name.dataset.to_sym,
         body: {
           settings: self.class.index_settings,
           mappings: {properties: schema.to_properties}
         }}
      end
    end
  end
end

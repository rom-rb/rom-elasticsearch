# frozen_string_literal: true

require "rom/types"
require "rom/elasticsearch/schema"

module ROM
  module Elasticsearch
    # Elasticsearch types use by schema attributes
    #
    # @api public
    module Types
      include ROM::Types

      # Default integer primary key
      ID = Integer.meta(primary_key: true)

      # Define a keyword attribute type
      #
      # @return [Dry::Types::Type]
      #
      # @api public
      def self.Keyword(meta = {})
        String.meta(type: "keyword", **meta)
      end

      # Define a keyword attribute type
      #
      # @return [Dry::Types::Type]
      #
      # @api public
      def self.Text(meta = {})
        String.meta(type: "text", **meta)
      end

      # Define a nested attribute type
      #
      # @return [Dry::Types::Type]
      #
      # @api public
      def self.Nested(meta = {})
        Hash.meta(type: "nested", **meta)
      end

      # Define an object attribute type
      #
      # @return [Dry::Types::Type]
      #
      # @api public
      def self.Object(meta = {})
        Hash.meta(properties: {}, **meta)
      end
    end
  end
end

# frozen_string_literal: true

require 'rom/attribute'

module ROM
  module Elasticsearch
    # ES-specific attribute types for schemas
    #
    # @api public
    class Attribute < ROM::Attribute
      INTERNAL_META_KEYS = %i[name source primary_key read].freeze
      DEFAULT_SORT_DIRECTION = 'asc'.freeze

      # Return ES mapping properties
      #
      # @return [Hash]
      #
      # @api public
      memoize def properties
        type.meta.reject { |k, _| INTERNAL_META_KEYS.include?(k) }
      end

      # Return if an attribute has any ES mappings
      #
      # @return [Bool]
      #
      # @api public
      def properties?
        properties.size > 0
      end

      # Return attribute with direction set to ascending
      #
      # @return [Attribute]
      #
      # @api public
      def asc
        meta(direction: 'asc')
      end

      # Return attribute with direction set to descending
      #
      # @return [Attribute]
      #
      # @api public
      def desc
        meta(direction: 'desc')
      end

      # @api private
      memoize def to_sort_expr
        "#{name}:#{direction}"
      end

      # @api private
      memoize def direction
        meta[:direction] || DEFAULT_SORT_DIRECTION
      end
    end
  end
end

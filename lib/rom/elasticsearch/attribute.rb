require 'rom/attribute'

module ROM
  module Elasticsearch
    # ES-specific attribute types for schemas
    #
    # @api public
    class Attribute < ROM::Attribute
      INTERNAL_META_KEYS = %i[name source].freeze

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
    end
  end
end

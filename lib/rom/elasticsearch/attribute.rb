require 'rom/attribute'

module ROM
  module Elasticsearch
    # ES-specific attribute types for schemas
    #
    # @api public
    class Attribute < ROM::Attribute
      # Return ES mapping properties
      #
      # @return [Hash]
      #
      # @api public
      def properties
        if meta[:type]
          { type: meta[:type] }
        else
          EMPTY_HASH
        end
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

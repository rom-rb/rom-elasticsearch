require 'rom/types'
require 'rom/schema'

module ROM
  module Elasticsearch
    # Elasticsearch relation schema
    #
    # @api public
    class Schema < ROM::Schema
      # Return a hash with mapping properties
      #
      # @api private
      def to_properties
        select(&:properties?).map { |attr| [attr.name, attr.properties] }.to_h
      end

      # Customized output hash constructor which symbolizes keys
      # and optionally applies custom read-type coercions
      #
      # @api private
      def to_output_hash
        Types::Hash.symbolized(map { |attr| [attr.key, attr.to_read_type] }.to_h)
      end
    end
  end
end

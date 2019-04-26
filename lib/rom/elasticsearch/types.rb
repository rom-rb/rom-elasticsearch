require 'rom/types'

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
        String.meta(type: 'keyword', **meta)
      end

      # Define a keyword attribute type
      #
      # @return [Dry::Types::Type]
      #
      # @api public
      def self.Text(meta = {})
        String.meta(type: 'text', **meta)
      end
    end
  end
end

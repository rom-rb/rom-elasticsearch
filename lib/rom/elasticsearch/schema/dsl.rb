# frozen_string_literal: true

require "rom/schema/dsl"
require "dry/types"

module ROM
  module Elasticsearch
    class Schema
      class DSL < ROM::Schema::DSL
        # Defines a relation attribute with its type and options.
        #
        # Optionally, accepts a block to define nested attributes
        # for Elasticsearch indices.
        #
        # @see Relation.schema
        #
        # @api public
        def attribute(name, type_or_options, options = EMPTY_HASH, &block)
          unless block.nil?
            unless type_or_options.is_a?(::Dry::Types::Hash)
              raise ROM::Elasticsearch::InvalidAttributeError,
                    "You can only specify an attribute block on an object or nested field! " \
                    "Attribute #{name} is a #{type_or_options.name}"
            end

            nested_schema = self.class.new(
              relation,
              schema_class: schema_class,
              attr_class: attr_class,
              inferrer: inferrer,
              &block
            ).call

            type_or_options = type_or_options.meta(properties: nested_schema.to_properties)
          end

          super(
            name,
            type_or_options,
            options
          )
        end
      end
    end
  end
end

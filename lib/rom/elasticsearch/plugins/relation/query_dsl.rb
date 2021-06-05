# frozen_string_literal: true

require "rom/global"
require "elasticsearch/dsl"

module ROM
  module Elasticsearch
    module Plugins
      module Relation
        # Relation plugin which adds query DSL from elasticsearch-dsl gem
        #
        # @api public
        module QueryDSL
          # @api private
          def self.included(klass)
            super
            klass.include(InstanceMethods)
            klass.option :query_builder, default: -> { Builder.new(self) }
          end

          # @api public
          module InstanceMethods
            # Restrict a relation via query DSL
            #
            # @see Relation#search
            # @see https://github.com/elastic/elasticsearch-ruby/tree/master/elasticsearch-dsl
            #
            # @return [Relation]
            #
            # @api public
            def search(options = EMPTY_HASH, &block)
              if block
                super(query_builder.search(&block).to_hash)
              else
                super
              end
            end
          end

          class Builder
            include ::Elasticsearch::DSL

            attr_reader :relation

            def initialize(relation)
              @relation = relation
            end
          end
        end
      end
    end
  end

  plugins do
    adapter :elasticsearch do
      register :query_dsl, ROM::Elasticsearch::Plugins::Relation::QueryDSL, type: :relation
    end
  end
end

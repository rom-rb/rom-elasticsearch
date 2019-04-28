# frozen_string_literal: true

require 'rom/support/inflector'

module ROM
  module Elasticsearch
    # @api private
    class IndexName
      # @api private
      attr_reader :name

      # @api private
      attr_reader :types

      def self.[](name, types = nil)
        if name.is_a?(self)
          name
        else
          new(name, types)
        end
      end

      # @api private
      def initialize(name, types = nil)
        @name = name
        @types = types
        freeze
      end

      # @api private
      def type
        types ? Array(types).join(',') : Inflector.singularize(name).to_sym
      end

      # @api private
      def to_sym
        name
      end
    end

  end
end

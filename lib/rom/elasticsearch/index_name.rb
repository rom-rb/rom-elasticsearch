# frozen_string_literal: true

require 'rom/support/inflector'

module ROM
  module Elasticsearch
    # @api private
    class IndexName
      # @api private
      attr_reader :name

      def self.[](name)
        if name.is_a?(self)
          name
        else
          new(name)
        end
      end

      # @api private
      def initialize(name)
        @name = name
        freeze
      end

      # @api private
      def to_sym
        name
      end
    end
  end
end

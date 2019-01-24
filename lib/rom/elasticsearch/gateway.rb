# frozen_string_literal: true

require 'elasticsearch'
require 'uri'

require 'rom/gateway'
require 'rom/support/inflector'
require 'rom/elasticsearch/dataset'
require 'rom/elasticsearch/index_name'

module ROM
  module Elasticsearch
    # Elasticsearch gateway
    #
    # @example basic configuration
    #   conf = ROM::Configuration.new(:elasticsearch, 'http://localhost:9200')
    #
    #   class Posts < ROM::Relation[:elasticsearch]
    #     schema(:posts) do
    #       attribute :id, Types::Int
    #       attribute :title, Types::String
    #
    #       primary_key :id
    #     end
    #
    #     def like(title)
    #       query(prefix: { title: title })
    #     end
    #   end
    #
    #   conf.register_relation(Posts)
    #
    #   rom = ROM.container(conf)
    #
    #   posts = rom.relations[:posts]
    #
    #   posts.command(:create).call(id: 1, title: 'Hello World')
    #
    #   posts.like('Hello').first
    #
    # @example use an existing client
    #   client = Elasticsearch::Client.new('http://localhost:9200')
    #   conf = ROM::Configuration.new(:elasticsearch, client)
    #
    # @api public
    class Gateway < ROM::Gateway
      adapter :elasticsearch

      # @!attribute [r] client
      #   @return [::Elasticsearch::Client] configured ES client
      attr_reader :client

      # @api private
      def initialize(uri, *_args)
        @client = connect(uri)
      end

      # Return true if a dataset with the given :index exists
      #
      # @param [Symbol] index The name of the index
      #
      # @return [Boolean]
      #
      # @api public
      def dataset?(index)
        client.indices.exists?(index: index)
      end
      alias_method :index?, :dataset?

      # Get a dataset by its :index name
      #
      # @param [Symbol] index The name of the index
      #
      # @return [Dataset]
      #
      # @api public
      def dataset(index)
        idx_name = IndexName[index]
        Dataset.new(client, params: { index: idx_name.to_sym, type: idx_name.type })
      end
      alias_method :[], :dataset

      private

      # Connect to Elasticsearch cluster or reuse an existing client
      #
      # @return [::Elasticsearch::Client] a connection client
      #
      # @api private
      def connect(uri)
        case uri
        when ::Elasticsearch::Transport::Client
          uri
        when String
          ::Elasticsearch::Client.new(url: uri)
        end
      end
    end
  end
end

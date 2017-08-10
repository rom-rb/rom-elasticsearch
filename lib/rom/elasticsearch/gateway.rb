require 'rom/gateway'
require 'rom/elasticsearch/dataset'
require 'rom/elasticsearch/query_methods'
require 'rom/elasticsearch/commands'
require 'elasticsearch'
require 'uri'

module ROM
  module Elasticsearch
    class Gateway < ROM::Gateway
      def initialize(url, log: false)
        url = URI.parse(url)
        @client = ::Elasticsearch::Client.new(host: "#{url.host}:#{url.port || 9200}", log: log)
        @index = url.path[1..-1]
      end

      def dataset(type)
        Dataset.new(@client, index: @index, type: type)
      end

      attr_reader :client

      class << self
        def from_uri(url, **options)
          new(url, options)
        end
      end
    end


    class Relation < ROM::Relation
      adapter :elasticsearch

      forward :with_options
      forward(*QueryMethods.public_instance_methods(false))
    end
  end
end

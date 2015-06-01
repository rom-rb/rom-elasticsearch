require 'rom/gateway'
require 'rom/elasticsearch/dataset'
require 'rom/elasticsearch/query_methods'
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
        def from_uri(url)
          new(url)
        end
      end
    end


    class Relation < ROM::Relation
      forward :with_options, :get
      forward *QueryMethods.public_instance_methods(false)
    end

    require 'rom/commands'
    module Commands
      class Create < ROM::Commands::Create
        def execute(attributes)
          validator.call(attributes)
          result = dataset.index(attributes.to_h)
          relation.get(result['_id'])
        end

        private
        def dataset
          relation.dataset
        end
      end

      class Delete < ROM::Commands::Delete
        def execute
          relation.delete
        end
      end
    end
  end
end
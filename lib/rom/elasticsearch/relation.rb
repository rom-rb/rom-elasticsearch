require 'rom/relation'
require 'rom/elasticsearch/query_methods'

module ROM
  module Elasticsearch
    # Elasticsearch relation API
    #
    # @api public
    class Relation < ROM::Relation
      adapter :elasticsearch

      defines :index

      dataset { index ? with(params: { index: index }) : self }

      forward :wait
      forward(*QueryMethods.public_instance_methods(false))
    end
  end
end

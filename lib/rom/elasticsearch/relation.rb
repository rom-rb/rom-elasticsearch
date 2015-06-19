require 'rom/relation'
require 'rom/elasticsearch/query_methods'

module ROM
  module Elasticsearch
    class Relation < ROM::Relation
      forward :with_options, :get
      forward *QueryMethods.public_instance_methods(false)
    end
  end
end

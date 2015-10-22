require 'rom/relation'

module ROM
  module Elasticsearch
    class Relation < ROM::Relation
      adapter :elasticsearch
      
      forward :search
      forward :<<, :insert, :bulk
      forward :get, :filter, :sort, :query_string, :query
    end
  end
end

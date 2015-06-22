require 'rom/relation'

module ROM
  module Elasticsearch
    class Relation < ROM::Relation
      forward :search
      forward :<<, :insert
      forward :get, :filter, :query_string, :query
    end
  end
end

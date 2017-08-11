require 'rom/types'

module ROM
  module Elasticsearch
    class Relation < ROM::Relation
      adapter :elasticsearch

      defines :index

      dataset { index ? with(params: { index: index }) : self }

      forward :wait
      forward(*QueryMethods.public_instance_methods(false))
    end
  end
end

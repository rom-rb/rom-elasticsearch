require 'rom/commands'
require 'rom/commands/create'

module ROM
  module Elasticsearch
    class Commands
      class Create < ROM::Commands::Create
        def execute(attributes)
          validator.call(attributes)
          result = dataset.create(attributes.to_h)
          relation.get(result['_id'])
        end

      private
      
        def dataset
          relation.dataset
        end
      end
    end
  end
end

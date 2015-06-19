require 'rom/commands'
require 'rom/commands/update'

module ROM
  module Elasticsearch
    class Commands
      class Update < ROM::Commands::Update
        def execute(attributes)
          validator.call(attributes)
          result = dataset.update(attributes.to_h)
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

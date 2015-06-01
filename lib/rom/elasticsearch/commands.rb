require 'rom/commands'

module ROM
  module Elasticsearch
    class Commands
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

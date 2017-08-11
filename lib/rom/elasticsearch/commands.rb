require 'rom/commands'

module ROM
  module Elasticsearch
    class Commands
      class Create < ROM::Commands::Create
        def execute(attributes)
          result = dataset.put(attributes.to_h)
          relation.get(result['_id']).one['_source']
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

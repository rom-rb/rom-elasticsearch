require 'rom/commands'

module ROM
  module Elasticsearch
    class Commands
      class Create < ROM::Commands::Create
        def execute(tuple)
          attributes = input[tuple]
          validator.call(attributes)
          result = relation.dataset.insert(attributes.to_h)
          relation.get(result['_id'])
        end
      end

      class Update < ROM::Commands::Update
        def execute(tuple)
          attributes = input[tuple]
          validator.call(attributes)
          result = relation.dataset.update(attributes.to_h)
          relation.get(result['_id'])
        end
      end

      class Delete < ROM::Commands::Delete
        def execute
          deleted = relation.dataset.to_a
          relation.dataset.delete
          deleted
        end
      end
    end
  end
end

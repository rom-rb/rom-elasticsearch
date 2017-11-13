require 'rom/commands'

module ROM
  module Elasticsearch
    # ElasticSearch relation commands
    #
    # @api public
    class Commands
      # Create command
      #
      # @api public
      class Create < ROM::Commands::Create
        # @api private
        def execute(attributes)
          result =
            if _id
              dataset.params(id: attributes.fetch(_id)).put(attributes.to_h)
            else
              dataset.put(attributes.to_h)
            end
          [relation.get(result['_id']).one]
        end

        private

        # @api private
        def dataset
          relation.dataset
        end

        def _id
          relation.schema.primary_key_name
        end
      end

      # Delete command
      #
      # @api public
      class Delete < ROM::Commands::Delete
        # @api private
        def execute
          relation.dataset.delete
        end
      end
    end
  end
end

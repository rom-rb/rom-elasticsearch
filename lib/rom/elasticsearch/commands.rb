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
          result = dataset.put(attributes.to_h)
          [relation.get(result['_id']).one]
        end

        private

        # @api private
        def dataset
          relation.dataset
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

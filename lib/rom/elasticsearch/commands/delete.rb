require 'rom/commands'
require 'rom/commands/delete'

module ROM
  module Elasticsearch
    class Commands
      class Delete < ROM::Commands::Delete
        def execute
          deleted = dataset.to_a
          dataset.delete
          deleted
        end

      private
      
        def dataset
          relation.dataset
        end
      end
    end
  end
end

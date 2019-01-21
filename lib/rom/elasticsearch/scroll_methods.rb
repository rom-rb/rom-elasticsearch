require 'rom/elasticsearch/errors'

module ROM
  module Elasticsearch
    # Dataset's scoll methods
    #
    # @see Dataset
    #
    # @api public
    module ScrollMethods
      # @api private
      def scroll_enumerator(client, response)
        Enumerator.new do |yielder|
          current_response = response

          loop do
            results = current_response.fetch('hits').fetch('hits')

            break if results.empty?

            results.each do |result|
              yielder.yield(result)
            end

            scroll_id = current_response.fetch('_scroll_id')

            current_response = client.scroll(
              scroll_id: scroll_id,
              scroll: params[:scroll]
            )
          end
        end
      end
    end
  end
end

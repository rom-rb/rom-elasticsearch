module ROM
  module Helpers
    SERVICE_FIELDS = %w[_index _type _id _version].freeze

    def collect_service_fields(item)
      values = SERVICE_FIELDS.map do |field|
        [field, item[field]]
      end

      Hash[values]
    end

    def deep_symbolize_keys(hash)
      _deep_transform_keys_in_object(hash) { |key| key.to_sym rescue key }
    end

    def _deep_transform_keys_in_object(object, &block)
      case object
      when Hash
        object.each_with_object({}) do |(key, value), result|
          result[yield(key)] = _deep_transform_keys_in_object(value, &block)
        end
      when Array
        object.map {|e| _deep_transform_keys_in_object(e, &block) }
      else
        object
      end
    end
  end  
end

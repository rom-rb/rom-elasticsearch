require 'rom/elasticsearch'
require_relative 'support/helpers'

RSpec.configure do |config|
  config.include Helpers

  config.before(:all) do
    create_database('test_db')
  end

  config.after(:all) do
    drop_database('test_db')
  end
end

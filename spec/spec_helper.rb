
begin
  require 'pry-byebug'
rescue LoadError
  require 'pry'
end

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.warnings = true

  config.before do
    module Test
    end
  end

  config.after do
    Object.send(:remove_const, :Test)
  end
end

require 'rom/elasticsearch'


begin
  require 'pry-byebug'
rescue LoadError
  require 'pry'
end

SPEC_ROOT = root = Pathname(__FILE__).dirname

RSpec.configure do |config|
  config.disable_monkey_patching!
  config.warnings = true

  config.before do
    module Test
    end
  end

  Dir[root.join('shared/**/*.rb')].each { |f| require f }

  config.after do
    Object.send(:remove_const, :Test)
  end
end

require 'rom/elasticsearch'

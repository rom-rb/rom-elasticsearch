begin
  require 'byebug'
rescue LoadError
end

require 'support/coverage'
require 'rom-elasticsearch'

SPEC_ROOT = Pathname(__FILE__).dirname

Dir[SPEC_ROOT.join('shared/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  config.disable_monkey_patching!

  # elasticsearch-dsl warnings are killing me - solnic
  config.warnings = false

  config.before do
    module Test
    end
  end

  config.after do
    Object.send(:remove_const, :Test)
  end
end

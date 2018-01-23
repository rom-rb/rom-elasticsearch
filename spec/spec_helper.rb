require 'bundler'
Bundler.setup

if RUBY_ENGINE == 'ruby' && ENV['COVERAGE'] == 'true'
  require 'yaml'
  rubies = YAML.load(File.read(File.join(__dir__, '..', '.travis.yml')))['rvm']
  latest_mri = rubies.select { |v| v =~ /\A\d+\.\d+.\d+\z/ }.max

  if RUBY_VERSION == latest_mri
    require 'simplecov'
    SimpleCov.start do
      add_filter '/spec/'
    end
  end
end

begin
  require 'byebug'
rescue LoadError
end

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

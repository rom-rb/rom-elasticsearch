source 'https://rubygems.org'

# Specify your gem's dependencies in rom-elasticsearch.gemspec
gemspec

gem 'rom', git: 'https://github.com/rom-rb/rom', branch: 'master' do
  gem 'rom-core'
  gem 'rom-mapper'
end

gem 'simplecov', require: false

gem 'byebug', platform: :mri
gem 'elasticsearch-dsl'

group :tools do
  gem 'kramdown' # for yard
end

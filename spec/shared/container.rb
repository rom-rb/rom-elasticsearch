RSpec.shared_context 'container' do
  let(:uri) { 'http://127.0.0.1:9200/rom-test' }

  let(:conf) { ROM::Configuration.new(:elasticsearch, uri) }
  let(:container) { ROM.container(conf) }

  let(:gateway) { conf.gateways[:default] }

  let(:relations) { container[:relations] }
  let(:commands) { container[:commands] }
end

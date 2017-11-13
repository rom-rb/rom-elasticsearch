RSpec.shared_context 'setup' do
  let(:uri) { "http://127.0.0.1:9200/#{index}" }

  let(:conf) { ROM::Configuration.new(:elasticsearch, uri) }
  let(:container) { ROM.container(conf) }
  let(:index) { 'rom-test' }

  let(:gateway) { conf.gateways[:default] }
  let(:client) { gateway.client }

  let(:relations) { container[:relations] }
  let(:commands) { container[:commands] }

  before do
    client.indices.create(index: index)
  end

  after do
    client.indices.delete(index: index)
  end

  def refresh
    client.indices.refresh(index: index)
  end
end

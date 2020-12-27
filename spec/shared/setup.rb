RSpec.shared_context 'setup' do
  let(:uri) { "http://127.0.0.1:9200" }

  let(:conf) { ROM::Configuration.new(:elasticsearch, client: Elasticsearch::Client.new(url: uri)) }
  let(:container) { ROM.container(conf) }

  let(:gateway) { conf.gateways[:default] }
  let(:client) { gateway.client }

  let(:relations) { container[:relations] }
  let(:commands) { container[:commands] }

  after do
    client.indices.delete(index: :users) if gateway.index?(:users)
  end
end

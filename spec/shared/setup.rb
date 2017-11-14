RSpec.shared_context 'setup' do
  let(:uri) { "http://127.0.0.1:9200/#{root_index}" }

  let(:conf) { ROM::Configuration.new(:elasticsearch, uri) }
  let(:container) { ROM.container(conf) }
  let(:root_index) { :rom_test }

  let(:gateway) { conf.gateways[:default] }
  let(:client) { gateway.client }

  let(:relations) { container[:relations] }
  let(:commands) { container[:commands] }

  before do
    client.indices.create(index: root_index) unless gateway.index?(root_index)
  end

  after do
    client.indices.delete(index: root_index)
  end

  def refresh
    client.indices.refresh(index: root_index)
  end
end

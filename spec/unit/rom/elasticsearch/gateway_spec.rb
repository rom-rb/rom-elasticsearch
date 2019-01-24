require 'rom/lint/spec'

RSpec.describe ROM::Elasticsearch::Gateway do
  let(:uri) { 'http://localhost:9200/rom-test' }

  it_behaves_like 'a rom gateway' do
    let(:identifier) { :elasticsearch }
    let(:gateway) { ROM::Elasticsearch::Gateway }
  end

  context 'when uri is a `Elasticsearch::Transport::Client`' do
    it_behaves_like 'a rom gateway' do
      let(:identifier) { :elasticsearch }
      let(:gateway) { ROM::Elasticsearch::Gateway }
      let(:uri) do
        ::Elasticsearch::Client.new(url: 'http://localhost:9200/rom-test')
      end
    end
  end
end

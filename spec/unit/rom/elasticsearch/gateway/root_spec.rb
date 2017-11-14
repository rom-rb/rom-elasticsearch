require 'rom/elasticsearch/gateway'

RSpec.describe ROM::Elasticsearch::Gateway, '#root' do
  subject(:gateway) do
    ROM::Elasticsearch::Gateway.new(uri)
  end

  context 'with a path' do
    let(:uri) do
      'http://localhost:9200/rom'
    end

    it 'returns root index set to uri path' do
      expect(gateway.root.index).to be(:rom)
    end
  end

  context 'without a path' do
    let(:uri) do
      'http://localhost:9200'
    end

    it 'raises argument error' do
      expect { gateway }.to raise_error(ROM::Elasticsearch::ConfigurationError, /must have a path/)
    end
  end
end

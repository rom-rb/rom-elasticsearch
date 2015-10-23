require 'rom/lint/spec'

describe ROM::Elasticsearch::Gateway do
  let(:gateway) { ROM::Elasticsearch::Gateway }
  let(:opts)    { Hash[host: 'http://localhost:9200', index: 'rom-test'] }
  let(:uri)     { opts }

  it_behaves_like "a rom gateway" do
    let(:identifier) { :elasticsearch }
  end

  describe '.new' do
    context 'default values' do
      let(:connection) { gateway.new(opts).connection }

      it 'returns them' do
        expect(connection).to be_kind_of(::Elasticsearch::Transport::Client)
      end
    end
  end
end

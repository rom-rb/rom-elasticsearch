require 'rom/lint/spec'

RSpec.describe ROM::Elasticsearch::Gateway do
  include_context 'container'

  it_behaves_like 'a rom gateway' do
    let(:identifier) { :elasticsearch }
    let(:gateway) { ROM::Elasticsearch::Gateway }
  end
end

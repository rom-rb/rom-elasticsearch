RSpec.describe ROM::Elasticsearch::Dataset, '#query_string' do
  subject(:dataset) do
    ROM::Elasticsearch::Dataset.new(client, params: { index: :users })
  end

  include_context 'user fixtures'

  it 'returns data matching query string' do
    expect(dataset.query_string('username:alice').to_a).to eql([{'username' => 'alice'}])
    expect(dataset.query_string('username:nisse').to_a).to eql([])
  end
end

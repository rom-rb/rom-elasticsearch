RSpec.describe ROM::Elasticsearch::Dataset, '#search' do
  subject(:dataset) do
    ROM::Elasticsearch::Dataset.new(client, params: { index: root_index, type: 'users' })
  end

  include_context 'setup'

  before do
    dataset.put(username: 'eve')
    dataset.put(username: 'bob')
    dataset.put(username: 'alice')

    refresh
  end

  it 'returns data matching query options' do
    expect(dataset.search(query: {query_string: {query: 'username:eve'}}).to_a).
      to eql([{'username' => 'eve'}])
  end
end

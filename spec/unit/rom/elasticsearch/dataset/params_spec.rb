RSpec.describe ROM::Elasticsearch::Dataset, '#params' do
  subject(:dataset) do
    ROM::Elasticsearch::Dataset.new(client, params: { index: root_index, type: 'users' })
  end

  include_context 'user fixtures'

  it 'returns a new dataset with updated params' do
    expect(dataset.params(size: 100).to_a.size).to eq(3)
    expect(dataset.params(size: 2).to_a.size).to eq(2)
  end
end

RSpec.describe ROM::Elasticsearch::Dataset, '#params' do
  subject(:dataset) do
    ROM::Elasticsearch::Dataset.new(client, params: { index: :users })
  end

  include_context 'user fixtures'

  it 'returns a new dataset with updated params' do
    new_ds = dataset.params(size: 100)

    expect(new_ds.params).to eql(size: 100, index: :users)
  end
end

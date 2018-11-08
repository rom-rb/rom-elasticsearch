RSpec.describe ROM::Elasticsearch::Dataset, '#scroll' do
  subject(:dataset) do
    ROM::Elasticsearch::Dataset.new(client, params: { index: :users, type: :user })
  end

  include_context 'user fixtures'

  it 'returns a new dataset with updated params' do
    new_ds = dataset.scroll('5m')

    expect(new_ds.params).to eql(scroll: '5m', index: :users, type: :user)
  end
end

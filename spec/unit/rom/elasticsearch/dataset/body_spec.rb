RSpec.describe ROM::Elasticsearch::Dataset, '#body' do
  subject(:dataset) do
    ROM::Elasticsearch::Dataset.new(client, params: { index: :users, type: :user })
  end

  include_context 'user fixtures'

  it 'returns a new dataset with updated body' do
    new_ds = dataset.body(id: 1)

    expect(new_ds.body).to eql(id: 1)
  end
end

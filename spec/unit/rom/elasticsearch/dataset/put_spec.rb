RSpec.describe ROM::Elasticsearch::Dataset, '#put' do
  subject(:dataset) do
    ROM::Elasticsearch::Dataset.new(client, params: { index: :users, type: :user })
  end

  include_context 'setup'

  it 'puts new data' do
    result = dataset.put(username: 'eve')

    expect(result['_id']).to_not be(nil)
    expect(result['result']).to eql('created')
  end
end

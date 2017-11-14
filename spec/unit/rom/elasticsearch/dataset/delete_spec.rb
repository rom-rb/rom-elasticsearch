RSpec.describe ROM::Elasticsearch::Dataset, '#delete' do
  subject(:dataset) do
    ROM::Elasticsearch::Dataset.new(client, params: { index: root_index, type: 'users' })
  end

  include_context 'user fixtures'

  it 'deletes data' do
    expect(dataset.to_a.size).to eql(3)

    dataset.wait.delete_all

    expect(dataset.to_a.size).to eql(0)
  end
end

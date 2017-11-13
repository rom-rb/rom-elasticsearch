RSpec.describe ROM::Elasticsearch::Dataset do
  let(:index) { 'rom-test' }
  let(:client) { Elasticsearch::Client.new(log: false) }
  let(:dataset) { ROM::Elasticsearch::Dataset.new(client, params: { index: index, type: 'users' }) }

  def refresh
    client.indices.refresh(index: index)
  end

  before do
    client.indices.delete(index: index) if client.indices.exists?(index: index)
    client.indices.create(index: index)

    dataset.put(username: 'eve')
    dataset.put(username: 'bob')
    dataset.put(username: 'alice')
    refresh
  end

  describe 'insert' do
    it 'works' do
      expect(dataset.params(size: 100).to_a.size).to eq(3)
      expect(dataset.params(size: 2).to_a.size).to eq(2)

      result = dataset.search(
        query: {
          query_string: {
            query: 'username:eve'
          }
        }
      ).to_a

      expect(result.map { |r| r['_source'] }).to match_array([{'username' => 'eve'}])

      result = dataset.query_string('username:nisse').to_a
      expect(result).to match_array([])

      result = dataset.query_string('username:alice').to_a
      expect(result.map { |r| r['_source'] }).to match_array([{'username' => 'alice'}])
    end
  end

  describe 'delete' do
    it 'works' do
      expect(dataset.to_a.size).to eql(3)
      dataset.wait.delete_all

      expect(dataset.to_a.size).to eql(0)
    end
  end
end

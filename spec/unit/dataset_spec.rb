describe ROM::Elasticsearch::Dataset do
  let(:conn)    { Elasticsearch::Client.new(db_options) }
  let(:dataset) { ROM::Elasticsearch::Dataset.new(conn, index: db_options[:index], type: 'users') }

  before do
    reindex(conn)
    dataset.create(username: 'eve')
    dataset.create(username: 'bob')
    dataset.create(username: 'alice')

    refresh(conn)
  end

  after { drop_index(conn) }

  describe 'insert' do
    it 'works' do
      expect(dataset.with_options(size: 100).to_a.size).to eq(3)

      expect(dataset.with_options(size: 2).to_a.size).to eq(2)

      result = dataset.search(body: {
                                  query: {
                                      query_string: {
                                          query: 'username:eve'
                                      }
                                  }
                              }).to_a

      expect(result.size).to eq(1)
      expect(result.first['username']).to eq('eve')

      result = dataset.query_string('username:nisse').to_a
      expect(result).to match_array([])

      result = dataset.query_string('username:alice').to_a
      expect(result.size).to eq(1)
      expect(result.first['username']).to eq('alice')
    end
  end

  describe 'delete' do
    it 'works' do
      expect(dataset.to_a.size).to eq(3)
      dataset.delete_all

      expect(dataset.to_a.size).to eq(0)
    end
  end
end

describe ROM::Elasticsearch::Dataset do
  let(:conn)    { Elasticsearch::Client.new(db_options) }
  let(:dataset) { ROM::Elasticsearch::Dataset.new(conn, index: db_options[:index], type: 'users') }

  before do
    create_index(conn)

    dataset.insert(username: 'eve')
    dataset.insert(username: 'bob')
    dataset.insert(username: 'alice')

    refresh_index(conn)
  end

  context 'bulk query' do
    it 'use index and type from dataset options' do
      expect(conn).to receive(:bulk)
        .with(index: 'rom-test', type: 'users',
          body: [{:index=>{:data=>{:title=>"foo"}}},
                 {:index=>{:data=>{:title=>"bar"}}}])

      dataset.bulk([
        {index: {data: {title: 'foo'}}},
        {index: {data: {title: 'bar'}}}
      ])
    end
  end

  context 'query inserted objects' do
    it { expect(dataset.search(size: 100).to_a.size).to eq(3) }
    it { expect(dataset.search(size: 2).to_a.size).to eq(2) }

    it '#search' do
      result = dataset.search(body: {
        query: {
          query_string: {
            query: 'username:eve'
          }
        }
      }).to_a

      expect(result.size).to eq(1)
      expect(result.first[:username]).to eq('eve')
    end

    it '#query_string with unexist object' do
      result = dataset.query_string('username:nisse').to_a
      expect(result).to match_array([])
    end

    it '#query_string with existent object' do
      result = dataset.query_string('username:alice').to_a
      expect(result.size).to eq(1)
      expect(result.first[:username]).to eq('alice')
    end
  end

  context 'objects deletion' do
    it 'works' do
      expect(dataset.to_a.size).to eq(3)
      dataset.delete_all
      expect(dataset.to_a.size).to eq(0)
    end
  end
end

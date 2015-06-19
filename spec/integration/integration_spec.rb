describe 'integration' do
  let(:gateway)  { ROM::Elasticsearch::Gateway.new(db_options) }
  let(:conn)     { gateway.connection }
  let(:setup)    { ROM.setup(:elasticsearch, db_options) }
  let(:rom)      { setup.finalize }
  let(:users)    { rom.relation(:users) }
  let(:commands) { rom.command(:users) }

  before { reindex(conn) }
  after  { drop_index(conn) }

  before do
    setup.relation(:users) do
      register_as :users
      dataset :users

      def like(name)
        filter({match_all: {}}).query_string("username:#{name}")
      end
    end

    setup.commands(:users) do
      define :create
    end

    setup
  end

  it 'creating records' do
    expect(users.to_a).to be_a(Array)

    user_id = 3289

    result = commands.create.with_options(id: user_id).call(username: 'kwando', email: 'hannes@bemt.nu')

    expect(result).to be_a_kind_of(ROM::Relation)

    array = result.to_a
    expect(array).to be_a_kind_of(Array)
    expect(array.size).to be(1)
    expect(array[0]['_id']).to eq(user_id.to_s)

    refresh(conn)

    expect(users.like('kwando').to_a).not_to be_empty
  end


  describe 'sanity checks' do
    it 'is a ROM::Gateway' do
      expect(gateway).to be_a_kind_of(ROM::Gateway)
    end
  end
end

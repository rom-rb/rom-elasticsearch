describe 'integration' do
  let(:gateway) { ROM::Elasticsearch::Gateway.new(db_options) }
  let(:conn)    { gateway.connection }
  let(:setup)   { ROM.setup(:elasticsearch, db_options) }
  let(:rom)     { setup.finalize }
  let(:user_id) { 3289 }
  let(:data)    { Hash[name: 'kwando', email: 'hannes@bemt.nu'] }

  before { create_index(conn) }

  before do
    class User
      attr_reader :name, :email

      def initialize(attrs)
        @name, @email = attrs.values_at(:name, :email)
      end
    end

    setup.relation(:users) do
      register_as :users
      dataset :users
    end

    setup.mappers do
      define(:users) do
        model User
        register_as :entity
      end
    end

    setup.commands(:users) do
      define :create
    end

    setup
  end

  context 'relation :users' do
    let(:users) { rom.relation(:users) }

    before do
      rom.commands.users.create.call(data)
      refresh_index(conn)
    end

    it { expect(users.to_a).to be_an(Array) }
    it { expect(users.as(:entity).to_a).to be_an(Array) }
    it { expect(users.as(:entity).to_a.first).to be_an(User) }
    it { expect(users.as(:entity).to_a.first.name).to eq(data[:name]) }
    it { expect(users.as(:entity).to_a.first.email).to eq(data[:email]) }
  end

  context 'command :users' do
    let(:users)   { rom.command(:users) }
    let!(:results) { users.create.get(user_id).call(data) }

    it { expect(results).to be_an(ROM::Relation) }
    it { expect(results.to_a).to be_an(Array) }
    it { expect(results.to_a.count).to eq(1) }
    it { expect(results.to_a.first[:_id]).to eq(user_id.to_s) }

    it 'returns created record' do
      refresh_index(conn)

      expect(rom.relations.users.to_a.size).to eq(1)
    end
  end

  describe 'sanity checks' do
    it 'is a ROM::Gateway' do
      expect(gateway).to be_a_kind_of(ROM::Gateway)
    end
  end
end

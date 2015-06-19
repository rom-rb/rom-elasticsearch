describe 'Commands / Updates' do
  let(:setup)   { ROM.setup(:elasticsearch, db_options) }
  let(:gateway) { ROM::Elasticsearch::Gateway.new(db_options) }
  let(:conn)    { gateway.connection }

  let(:rom)     { setup.finalize }
  let(:users)   { rom.command(:users) }
  let(:element) { rom.relation(:users).as(:entity).to_a.first }

  before { reindex(conn) }
  after  { drop_index(conn) }

  before do
    setup.relation(:users) do
      register_as :users
      dataset :users

      def by_id(id)
        get(id)
      end
    end

    class User
      attr_accessor :id, :name, :street

      def initialize(attrs)
        @id, @name, @street = attrs.values_at('_id', 'name', 'street')
      end
    end

    setup.mappers do
      define(:users) do
        model User
        register_as :entity
      end
    end

    setup.commands(:users) do
      define(:update)
    end

    [
      { name: 'John', street: 'Main Street' }
    ].each do |data|
      gateway.dataset('users').create(data)
    end

    refresh(conn)
  end

  it 'has data' do
    expect(element.name).to eql('John')
    expect(element.street).to eql('Main Street')
  end

  it 'partial updates on original data' do
    result = users.try do
      users.update.by_id(element.id).call(street: '2nd Street')
    end

    result = result.value.to_a

    expect(result.first['name']).to eq('John')
    expect(result.first['street']).to eq('2nd Street')
  end
end

describe 'Commands / Delete' do
  let(:setup)   { ROM.setup(:elasticsearch, db_options) }
  let(:gateway) { ROM::Elasticsearch::Gateway.new(db_options) }
  let(:conn)    { gateway.connection }

  let(:rom)     { setup.finalize }
  let(:users)   { rom.command(:users) }
  let(:element) { rom.relation(:users).to_a.first }

  before { create_index(conn) }

  before do
    setup.relation(:users) do
      register_as :users
      dataset :users
    end

    setup.commands(:users) do
      define :delete
    end

    [
      { name: 'John', street: 'Main Street' }
    ].each do |data|
      gateway.dataset('users') << data
    end

    refresh_index(conn)
  end

  it 'deletes all tuples in a restricted relation' do
    result = users.try do
      users.delete.get(element['_id']).call
    end

    result = result.value

    expect(result.first['name']).to eql('John')
    expect(result.first['street']).to eql('Main Street')

    refresh_index(conn)

    result = rom.relation(:users).to_a
    expect(result.count).to eql(0)
  end
end

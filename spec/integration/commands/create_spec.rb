describe 'Commands / Create' do
  let(:setup)   { ROM.setup(:elasticsearch, db_options) }
  let(:gateway) { ROM::Elasticsearch::Gateway.new(db_options) }
  let(:conn)    { gateway.connection }

  let(:rom)     { setup.finalize }
  let(:users)   { rom.command(:users) }
  let(:data)    { Hash['name' => 'John Doe', 'street' => 'Main Street'] }

  before { create_index(conn) }

  before do
    setup.relation(:users) do
      register_as :users
      dataset :users
    end

    setup.commands(:users) do
      define :create
    end
  end

  it 'returns a tuple' do
    result = users.try do
      users.create.call(data)
    end

    result = result.value.to_a.first
    expect(result[:name]).to eql(data['name'])
    expect(result[:street]).to eql(data['street'])

    refresh_index(conn)

    result = rom.relation(:users).to_a.first
    expect(result[:name]).to eq('John Doe')
  end
end

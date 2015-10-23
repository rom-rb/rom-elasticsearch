describe 'Commands / Create' do
  let(:gateway) { ROM::Elasticsearch::Gateway.new(db_options) }
  let(:conn)    { gateway.connection }

  let!(:env) do
    env = ROM::Environment.new
    env.setup(:elasticsearch, db_options)
    env.use :auto_registration
    env
  end

  let(:rom)     { env.finalize.env }
  let(:users)   { rom.command(:users) }
  let(:data)    { Hash['name' => 'John Doe', 'street' => 'Main Street'] }

  before { create_index(conn) }

  before do
    env.relation(:users) do
      register_as :users
      dataset :users
    end

    env.commands(:users) do
      define(:create) do
        input ->(attrs) { attrs.merge('street' => attrs['street'].upcase) }
      end
    end
  end

  it 'returns a tuple' do
    result = users.try do
      users.create.call(data)
    end

    result = result.value.to_a.first
    expect(result[:name]).to eql(data['name'])
    expect(result[:street]).to eql('MAIN STREET')

    refresh_index(conn)

    result = rom.relation(:users).to_a.first
    expect(result[:name]).to eq('John Doe')
  end
end

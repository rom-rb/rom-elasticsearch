describe 'Commands / Updates' do
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
  let(:element) { rom.relation(:users).to_a.first }

  before { create_index(conn) }

  before do
    env.relation(:users) do
      register_as :users
      dataset :users
    end

    env.commands(:users) do
      define :update
    end

    [
      { name: 'John', street: 'Main Street' }
    ].each do |data|
      gateway.dataset('users') << data
    end

    refresh_index(conn)
  end

  it 'has data' do
    expect(element[:name]).to eql('John')
    expect(element[:street]).to eql('Main Street')
  end

  it 'partial updates on original data' do
    result = users.try do
      users.update.get(element[:_id]).call(street: '2nd Street')
    end

    result = result.value.to_a.first

    expect(result[:name]).to eq('John')
    expect(result[:street]).to eq('2nd Street')
  end
end

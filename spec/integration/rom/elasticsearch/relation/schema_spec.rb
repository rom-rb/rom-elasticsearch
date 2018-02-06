RSpec.describe ROM::Elasticsearch::Relation, '.schema' do
  subject(:relation) { relations[:users] }

  include_context 'setup'

  before do
    conf.relation(:users) do
      schema(:users) do
        attribute :id,   ROM::Elasticsearch::Types::ID
        attribute :name, ROM::Elasticsearch::Types.Text, read: ROM::Types.Constructor(Symbol, &:to_sym)
      end
    end
  end

  it 'defines read/write types' do
    relation.create_index

    relation.command(:create).call(id: 1, name: 'Jane')

    user = relation.get(1).one

    expect(user[:id]).to be(1)
    expect(user[:name]).to be(:Jane)
  end
end

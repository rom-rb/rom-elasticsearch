RSpec.describe ROM::Elasticsearch::Relation, '#command' do
  subject(:relation) { relations[:users] }

  include_context 'setup'

  before do
    conf.relation(:users) do
      schema(:users) do
        attribute :id,   ROM::Types::Int.meta(primary_key: true)
        attribute :name, ROM::Types::String
      end
    end
  end

  describe ':create' do
    it 'returns a create command' do
      command = relation.command(:create, result: :one)

      expect(command.call(id: 1, name: 'Jane')).to eql(id: 1, name: 'Jane')
    end

    it 'applies input function' do
      command = relation.command(:create, result: :one)

      input = double(:user, to_hash: { id: 1, name: 'Jane' })

      expect(command.call(input)).to eql(id: 1, name: 'Jane')
    end
  end

  describe ':delete' do
    before do
      relation.command(:create).call(id: 1, name: 'Jane')
      relation.command(:create).call(id: 2, name: 'John')

      refresh
    end

    it 'deletes matching data' do
      relation.get(2).command(:delete).call

      refresh

      expect(relation.to_a).to eql([{ id: 1, name: 'Jane' }])
    end
  end
end

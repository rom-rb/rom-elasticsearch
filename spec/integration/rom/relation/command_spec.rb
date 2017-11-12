RSpec.describe ROM::Elasticsearch::Relation, '#command' do
  subject(:relation) { relations[:users] }

  include_context 'container'

  before do
    conf.relation(:users) do
      schema(:users) do
        attribute :id,   ROM::Types::Int
        attribute :name, ROM::Types::String
      end
    end
  end

  describe ':create' do
    it 'returns a create command' do
      command = relation.command(:create, result: :one)

      expect(command.call(id: 1, name: 'Jane')).to eql('id' => 1, 'name' => 'Jane')
    end
  end
end

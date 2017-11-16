require 'rom/elasticsearch/relation'

RSpec.describe ROM::Elasticsearch::Relation, '#dataset' do
  subject(:relation) { relations[:users] }

  include_context 'setup'

  context 'with default index settings' do
    before do
      conf.relation(:users) do
        schema do
          attribute :id, ROM::Types::Int
          attribute :name, ROM::Types::String
        end
      end
    end

    it 'sets up correct index name' do
      expect(relation.dataset.index).to eql(:users)
    end

    it 'sets up default index type' do
      expect(relation.dataset.type).to eql(:user)
    end
  end
end

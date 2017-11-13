require 'rom/elasticsearch/relation'

RSpec.describe ROM::Elasticsearch::Relation, '#dataset' do
  subject(:relation) { relations[:users] }

  include_context 'setup'

  context 'when custom :index is not configured' do
    before do
      conf.relation(:users) do
        schema do
          attribute :id, ROM::Types::Int
          attribute :name, ROM::Types::String
        end
      end
    end

    it 'sets up dataset at root index' do
      expect(relation.dataset.index).to eql(root_index)
    end
  end

  context 'when custom :index is configured' do
    before do
      conf.relation(:users) do
        schema do
          attribute :id, ROM::Types::Int
          attribute :name, ROM::Types::String
        end

        index :people
      end
    end

    it 'sets up dataset at root index' do
      expect(relation.dataset.index).to eql(:people)
    end
  end
end

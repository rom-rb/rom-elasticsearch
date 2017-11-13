require 'rom/elasticsearch/relation'

RSpec.describe ROM::Elasticsearch::Relation, '#create_index' do
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

    it 'raises error' do
      expect { relation.create_index }.to raise_error(ROM::Elasticsearch::MissingIndexError)
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

    after do
      relation.delete_index
    end

    it 'creates an index' do
      relation.create_index

      expect(gateway.index?(:people)).to be(true)
    end
  end
end

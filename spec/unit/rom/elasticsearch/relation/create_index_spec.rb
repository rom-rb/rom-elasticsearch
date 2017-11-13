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
    after do
      relation.delete_index
    end

    context 'with default settings' do
      before do
        conf.relation(:users) do
          schema do
            attribute :id, ROM::Types::Int
            attribute :name, ROM::Types::String
          end

          index :people
        end
      end

      it 'creates an index' do
        relation.create_index

        expect(gateway.index?(:people)).to be(true)
      end
    end

    context 'with customized settings' do
      before do
        conf.relation(:users) do
          schema do
            attribute :id, ROM::Types::Int
            attribute :name, ROM::Types::String
          end

          index :people

          index_settings number_of_shards: 2
        end
      end

      it 'creates an index' do
        relation.create_index

        expect(gateway.index?(:people)).to be(true)
        expect(relation.dataset.settings['number_of_shards']).to eql("2")
      end
    end
  end
end

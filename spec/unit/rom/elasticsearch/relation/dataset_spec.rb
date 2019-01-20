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

  context 'overridding default dataset object' do
    let(:users) { relations[:users] }

    before do
      conf.relation(:users) do
        dataset do
          with(include_metadata: true)
        end

        schema do
          attribute :id, ROM::Types::Int
          attribute :name, ROM::Types::String
          attribute :_metadata, ROM::Types::Hash,
                    read: ROM::Types::Hash.symbolized(_index: 'string')
        end
      end

      users.create_index
      users.command(:create).call(id: 1, name: 'Jane')
    end

    it 'uses customized dataset' do
      expect(relation.to_a).to eql([{ id: 1, name: 'Jane', _metadata: { _index: 'users' } }])
    end
  end
end

require 'rom/elasticsearch/relation'

RSpec.describe ROM::Elasticsearch::Relation, '#dataset' do
  subject(:relation) { relations[:users] }

  include_context 'setup'

  context 'with default index settings' do
    before do
      conf.relation(:users) do
        schema do
          attribute :id, ROM::Types::Integer
          attribute :name, ROM::Types::String
        end
      end
    end

    it 'sets up correct index name' do
      expect(relation.dataset.index).to eql(:users)
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
          attribute :id, ROM::Types::Integer
          attribute :name, ROM::Types::String
          attribute :_metadata, ROM::Types::Hash,
                    read: ROM::Types::Hash.schema(_index: ROM::Types::String)
                                          .with_key_transform(&:to_sym)
        end
      end

      users.create_index
      users.command(:create).call(id: 1, name: 'Jane')
      users.refresh
    end

    it 'uses customized dataset' do
      expect(relation.to_a).to eql([{ id: 1, name: 'Jane', _metadata: { _index: 'users' } }])
    end
  end
end

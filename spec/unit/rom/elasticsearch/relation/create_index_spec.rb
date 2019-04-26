require 'rom/elasticsearch/relation'

RSpec.describe ROM::Elasticsearch::Relation, '#create_index' do
  subject(:relation) { relations[:users] }

  include_context 'setup'

  context 'when custom :index is configured' do
    after do
      relation.delete_index
    end

    context 'with default settings' do
      before do
        conf.relation(:users) do
          schema do
            attribute :id, ROM::Elasticsearch::Types::ID
            attribute :name, ROM::Types::String
          end
        end
      end

      it 'creates an index' do
        relation.create_index

        expect(gateway.index?(:users)).to be(true)
      end
    end

    context 'with customized settings' do
      before do
        conf.relation(:users) do
          schema do
            attribute :id, ROM::Types::Integer
            attribute :name, ROM::Types::String
          end

          index_settings number_of_shards: 2
        end
      end

      it 'creates an index' do
        relation.create_index

        expect(gateway.index?(:users)).to be(true)
        expect(relation.dataset.settings['number_of_shards']).to eql("2")
      end
    end

    context 'with customized attribute mappings' do
      before do
        conf.relation(:users) do
          schema do
            attribute :id, ROM::Elasticsearch::Types::ID
            attribute :name, ROM::Elasticsearch::Types.Keyword
            attribute :desc, ROM::Elasticsearch::Types.Text(analyzer: "snowball")
          end

          index_settings number_of_shards: 2
        end
      end

      it 'creates an index' do
        relation.create_index

        expect(gateway.index?(:users)).to be(true)

        expect(relation.dataset.mappings).
          to eql("properties" => {
                   "name" => { "type" => "keyword" },
                   "desc" => { "type" => "text", "analyzer" => "snowball" }})
      end
    end
  end
end

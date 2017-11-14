require 'rom/elasticsearch/relation'

RSpec.describe ROM::Elasticsearch::Relation, '#dataset' do
  subject(:relation) { relations[:users] }

  include_context 'setup'

  context 'when custom :index_name is not configured' do
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

    it 'sets up default index type' do
      expect(relation.dataset.type).to eql(:user)
    end
  end

  context 'when custom :index_name is configured' do
    before do
      conf.relation(:users) do
        schema do
          attribute :id, ROM::Types::Int
          attribute :name, ROM::Types::String
        end

        index_name :people
      end
    end

    it 'sets up dataset at root index' do
      expect(relation.dataset.index).to eql(:people)
    end
  end

  context 'when custom :index_name and :index_type are configured' do
    before do
      conf.relation(:users) do
        schema do
          attribute :id, ROM::Types::Int
          attribute :name, ROM::Types::String
        end

        index_name :people
        index_type :user
      end
    end

    it 'sets custom name and type' do
      expect(relation.dataset.index).to eql(:people)
      expect(relation.dataset.type).to eql(:user)
    end
  end

  context 'when custom :index_type is configured' do
    before do
      conf.relation(:users) do
        schema do
          attribute :id, ROM::Types::Int
          attribute :name, ROM::Types::String
        end

        index_type :person
      end
    end

    it 'sets custom type under root index' do
      expect(relation.dataset.index).to eql('rom-test')
      expect(relation.dataset.type).to eql(:person)
    end
  end
end

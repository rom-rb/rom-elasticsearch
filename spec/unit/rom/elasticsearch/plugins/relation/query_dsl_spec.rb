require 'rom/elasticsearch/plugins/relation/query_dsl'
require 'rom/elasticsearch/relation'

RSpec.describe ROM::Elasticsearch::Relation, '#search' do
  subject(:relation) { relations[:users] }

  include_context 'setup'

  before do
    conf.relation(:users) do
      schema do
        attribute :id, ROM::Types::Integer.meta(type: "integer")
        attribute :name, ROM::Types::Integer.meta(type: "text")
      end

      use :query_dsl
    end

    relation.command(:create).(id: 1, name: 'Jane')
    relation.command(:create).(id: 2, name: 'John')

    relation.refresh
  end

  it 'builds a query using a block-based DSL' do
    result = relation.search do
      query do
        match name: 'Jane'
      end
    end

    expect(result.to_a).to eql([{ id: 1, name: 'Jane' }])
  end
end

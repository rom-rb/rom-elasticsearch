require 'rom/elasticsearch/relation'

RSpec.describe ROM::Elasticsearch::Relation, '#order' do
  subject(:relation) { relations[:users] }

  include_context 'users'

  before do
    relation.command(:create).(id: 1, name: 'John')
    relation.command(:create).(id: 2, name: 'Jane')
    relation.command(:create).(id: 3, name: 'Jade')
    relation.command(:create).(id: 4, name: 'Joe')

    relation.refresh
  end

  it 'with ascending direction' do
    result = relation.order(:id).to_a

    expect(result).
      to eql([
               { id: 1, name: 'John' },
               { id: 2, name: 'Jane' },
               { id: 3, name: 'Jade' },
               { id: 4, name: 'Joe' }
             ])
  end

  it 'with descending direction' do
    result = relation.order(relation[:id].desc).to_a

    expect(result).
      to eql([
               { id: 4, name: 'Joe' },
               { id: 3, name: 'Jade' },
               { id: 2, name: 'Jane' },
               { id: 1, name: 'John' }
             ])
  end
end

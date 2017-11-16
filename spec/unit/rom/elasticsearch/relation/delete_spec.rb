require 'rom/elasticsearch/relation'

RSpec.describe ROM::Elasticsearch::Relation, '#delete' do
  subject(:relation) { relations[:users] }

  include_context 'users'

  before do
    relation.command(:create).(id: 1, name: 'Jane')
    relation.command(:create).(id: 2, name: 'John')

    relation.refresh
  end

  it 'deletes all data' do
    relation.delete

    expect(relation.refresh.to_a).to be_empty
  end

  it 'deletes all data from a relation restricted by id' do
    relation.get(2).delete

    expect(relation.refresh.to_a).to eql([{ id: 1, name: 'Jane' }])
  end

  it 'deletes all data from a relation restricted by a query' do
    relation.query(match: { name: 'Jane' }).delete

    expect(relation.refresh.to_a).to eql([{ id: 2, name: 'John' }])
  end
end

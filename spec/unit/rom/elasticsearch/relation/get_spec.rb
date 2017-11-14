require 'rom/elasticsearch/relation'

RSpec.describe ROM::Elasticsearch::Relation, '#get' do
  subject(:relation) { relations[:users] }

  include_context 'users'

  before do
    relation.command(:create).(id: 1, name: 'Jane')
    relation.command(:create).(id: 2, name: 'John')

    refresh
  end

  it 'returns user tuple by its id' do
    expect(relation.get(1).one).to eql(id: 1, name: 'Jane')
  end

  it 'raises search error' do
    expect { relation.get(12421).one }.to raise_error(ROM::Elasticsearch::SearchError)
  end
end

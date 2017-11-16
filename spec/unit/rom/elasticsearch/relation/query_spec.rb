require 'rom/elasticsearch/relation'

RSpec.describe ROM::Elasticsearch::Relation, '#query' do
  subject(:relation) { relations[:users] }

  include_context 'users'

  before do
    relation.command(:create).(id: 1, name: 'Jane')
    relation.command(:create).(id: 2, name: 'John')

    relation.refresh
  end

  it 'returns data matching query options' do
    expect(relation.query(match: { name: 'Jane' }).one).to eql(id: 1, name: 'Jane')
  end
end

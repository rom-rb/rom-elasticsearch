require 'rom/elasticsearch/relation'

RSpec.describe ROM::Elasticsearch::Relation, '#query_string' do
  subject(:relation) { relations[:users] }

  include_context 'users'

  before do
    relation.command(:create).(id: 1, name: 'Jane')
    relation.command(:create).(id: 2, name: 'John')

    refresh
  end

  it 'returns data matching query string' do
    expect(relation.query_string('name:Jane').one).to eql(id: 1, name: 'Jane')
  end
end

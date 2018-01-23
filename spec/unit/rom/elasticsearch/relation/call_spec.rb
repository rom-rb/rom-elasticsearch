require 'rom/elasticsearch/relation'

RSpec.describe ROM::Elasticsearch::Relation, '#call' do
  subject(:relation) { relations[:users] }

  include_context 'users'

  before do
    relation.command(:create).(id: 1, name: 'Jane')
    relation.command(:create).(id: 2, name: 'John')

    relation.refresh
  end

  it 'returns loaded relation' do
    result = relation.call

    expect(result).to match_array([{ id: 1, name: 'Jane' }, { id: 2, name: 'John' }])

    expect(result.total_hits).to be(2)
  end
end

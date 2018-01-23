require 'rom/elasticsearch/relation'

RSpec.describe ROM::Elasticsearch::Relation, '#page' do
  subject(:relation) { relations[:users].order(:id) }

  include_context 'users'

  before do
    relation.command(:create).(id: 1, name: 'Jane')
    relation.command(:create).(id: 2, name: 'John')

    relation.refresh
  end

  it 'returns relation with page set' do
    result = relation.per_page(1).page(2).to_a

    expect(result).to match_array([{ id: 2, name: 'John' }])
  end
end

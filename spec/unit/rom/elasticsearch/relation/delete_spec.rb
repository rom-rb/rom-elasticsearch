require 'rom/elasticsearch/relation'

RSpec.describe ROM::Elasticsearch::Relation, '#delete' do
  subject(:relation) { relations[:users] }

  include_context 'users'

  before do
    relation.command(:create).(id: 1, name: 'Jane')
    relation.command(:create).(id: 2, name: 'John')

    relation.refresh
  end

  it 'deletes all matching data' do
    relation.delete

    expect(relation.refresh.to_a).to be_empty
  end
end

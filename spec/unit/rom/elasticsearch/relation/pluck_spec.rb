require 'rom/elasticsearch/relation'

RSpec.describe ROM::Elasticsearch::Relation, '#pluck' do
  subject(:relation) { relations[:users] }

  include_context 'users'

  before do
    relation.command(:create).(id: 1, name: 'Jane')
    relation.command(:create).(id: 2, name: 'John')

    relation.refresh
  end

  it 'returns an array with plucked values' do
    expect(relation.pluck(:name)).to match_array(%w[Jane John])
  end
end

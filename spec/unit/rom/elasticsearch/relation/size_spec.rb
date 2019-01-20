require 'rom/elasticsearch/relation'

RSpec.describe ROM::Elasticsearch::Relation, '#size' do
  subject(:relation) { relations[:users] }

  include_context 'users'

  before do
    relation.command(:create).(id: 1, name: 'John')
    relation.command(:create).(id: 2, name: 'Jane')
    relation.command(:create).(id: 3, name: 'Jade')

    relation.refresh
  end

  it 'returns a relation limited by the number of documents' do
    expect(relation.size(1).to_a.size).to eql 1
    expect(relation.size(2).to_a.size).to eql 2
  end
end

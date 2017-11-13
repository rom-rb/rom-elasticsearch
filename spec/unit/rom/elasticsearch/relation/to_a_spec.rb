require 'rom/elasticsearch/relation'

RSpec.describe ROM::Elasticsearch::Relation, '#to_a' do
  subject(:relation) { relations[:users] }

  include_context 'users'

  before do
    relation.insert(id: 1, name: 'Jane')
    relation.insert(id: 2, name: 'John')
  end

  it 'returns user tuples' do
    expect(relation).to match_array([{ id: 1, name: 'Jane' }, { id: 2, name: 'John' }])
  end

  it 'returns user structs' do
    jane, john = relation.with(auto_struct: true).to_a

    expect(jane.id).to be(1)
    expect(jane.name).to eql('Jane')

    expect(john.id).to be(2)
    expect(john.name).to eql('John')
  end
end

RSpec.describe ROM::Elasticsearch::Relation, '.schema' do
  subject(:relation) { relations[:search] }

  include_context 'setup'

  let(:posts) { relations[:posts] }
  let(:pages) { relations[:pages] }

  before do
    conf.relation(:posts) do
      schema(:posts) do
        attribute :id, ROM::Elasticsearch::Types::ID
        attribute :title, ROM::Elasticsearch::Types.Text
      end
    end

    conf.relation(:pages) do
      schema(:pages) do
        attribute :id, ROM::Elasticsearch::Types::ID
        attribute :title, ROM::Elasticsearch::Types.Text
      end
    end

    conf.relation(:search) do
      schema(:_all) do
        attribute :id, ROM::Elasticsearch::Types::ID
        attribute :title, ROM::Elasticsearch::Types.Text
      end
    end

    posts.create_index
    pages.create_index
  end

  after do
    posts.delete_index
    pages.delete_index
  end

  it 'search through specified indices' do
    posts.command(:create).call(id: 1, title: 'Post 1')
    posts.command(:create).call(id: 2, title: 'Post 2')

    pages.command(:create).call(id: 1, title: 'Page 1')
    pages.command(:create).call(id: 2, title: 'Page 2')

    posts.refresh
    pages.refresh

    result = relation.query(match: { title: 'Post'})

    expect(result.to_a).to eql([{ id: 1, title: 'Post 1'}, { id: 2, title: 'Post 2'}])

    result = relation.query(match: { title: '1'})

    expect(result.to_a).to eql([{ id: 1, title: 'Page 1'}, { id: 1, title: 'Post 1'}])
  end
end

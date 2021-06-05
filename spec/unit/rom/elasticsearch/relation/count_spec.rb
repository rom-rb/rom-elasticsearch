# frozen_string_literal: true

require "rom/elasticsearch/relation"

RSpec.describe ROM::Elasticsearch::Relation, "#count" do
  subject(:relation) { relations[:users] }

  include_context "users"

  before do
    relation.command(:create).(id: 1, name: "John")
    relation.command(:create).(id: 2, name: "Jane")
    relation.command(:create).(id: 3, name: "Jade")

    relation.refresh
  end

  it "returns a relation limited by the number of documents" do
    expect(relation.count).to eql 3
    expect(relation.query(match: {name: "Jane"}).count).to eql 1
  end
end

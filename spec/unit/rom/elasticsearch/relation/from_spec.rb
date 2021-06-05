# frozen_string_literal: true

require "rom/elasticsearch/relation"

RSpec.describe ROM::Elasticsearch::Relation, "#from" do
  subject(:relation) { relations[:users] }

  include_context "users"

  before do
    relation.command(:create).(id: 1, name: "John")
    relation.command(:create).(id: 2, name: "Jane")
    relation.command(:create).(id: 3, name: "Jade")

    relation.refresh
  end

  it "returns a relation sliced by offset" do
    expect(relation.from(1).to_a.size).to eql 2
    expect(relation.from(2).to_a.size).to eql 1
  end
end

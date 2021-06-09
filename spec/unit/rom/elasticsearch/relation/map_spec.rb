# frozen_string_literal: true

require "rom/elasticsearch/relation"

RSpec.describe ROM::Elasticsearch::Relation, "#map" do
  subject(:relation) { relations[:users] }

  include_context "users"

  before do
    relation.command(:create).(id: 1, name: "Jane")
    relation.command(:create).(id: 2, name: "John")

    relation.refresh
  end

  it "yields result tuples" do
    expect(relation.map { |t| t[:name] }).to match_array(%w[Jane John])
  end
end

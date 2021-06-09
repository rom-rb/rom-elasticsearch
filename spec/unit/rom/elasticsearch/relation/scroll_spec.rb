# frozen_string_literal: true

require "rom/elasticsearch/relation"

RSpec.describe ROM::Elasticsearch::Relation, "#scroll" do
  subject(:relation) { relations[:users].order(:id) }

  include_context "users"

  before do
    relation.command(:create).(id: 1, name: "Jane")
    relation.command(:create).(id: 2, name: "John")
    relation.command(:create).(id: 3, name: "David")
    relation.command(:create).(id: 4, name: "Dorin")
    relation.command(:create).(id: 5, name: "Petru")

    relation.refresh
  end

  it "returns relation with page set" do
    result = relation.per_page(2).scroll("5s").to_a

    expect(result).to match_array(
      [
        {id: 1, name: "Jane"},
        {id: 2, name: "John"},
        {id: 3, name: "David"},
        {id: 4, name: "Dorin"},
        {id: 5, name: "Petru"}
      ]
    )
  end
end

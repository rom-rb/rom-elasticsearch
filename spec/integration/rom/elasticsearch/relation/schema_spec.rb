# frozen_string_literal: true

RSpec.describe ROM::Elasticsearch::Relation, ".schema" do
  subject(:relation) { relations[:users] }

  include_context "setup"

  context "read/write types" do
    before do
      conf.relation(:users) do
        schema(:users) do
          attribute :id,   ROM::Elasticsearch::Types::ID
          attribute :name, ROM::Elasticsearch::Types.Text, read: ROM::Types.Constructor(Symbol, &:to_sym)
        end
      end
    end

    it "defines read/write types" do
      relation.create_index

      relation.command(:create).call(id: 1, name: "Jane")

      user = relation.get(1).one

      expect(user[:id]).to be(1)
      expect(user[:name]).to be(:Jane)
    end
  end

  context "nested fields" do
    before do
      conf.relation(:users) do
        schema(:users) do
          attribute :id,   ROM::Elasticsearch::Types::ID
          attribute :name, ROM::Elasticsearch::Types.Text
          attribute :profile, ROM::Elasticsearch::Types.Nested do
            attribute :email, ROM::Elasticsearch::Types.Text
          end
        end
      end
    end

    it "persists and reads nested types" do
      relation.create_index

      relation.command(:create).call(
        id: 1,
        name: "Jane",
        profile: {
          email: "jane@sample.com"
        }
      )

      user = relation.get(1).one

      expect(user[:id]).to be(1)
      expect(user[:profile]).to eql({"email" => "jane@sample.com"})
    end
  end
end

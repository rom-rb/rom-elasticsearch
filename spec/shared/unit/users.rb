# frozen_string_literal: true

RSpec.shared_context "users" do
  include_context "setup"

  before do
    conf.relation(:users) do
      schema(:users) do
        attribute :id, ROM::Elasticsearch::Types::ID
        attribute :name, ROM::Elasticsearch::Types.Text

        primary_key :id
      end
    end
  end

  after do
    gateway[:users].refresh.delete
  end
end

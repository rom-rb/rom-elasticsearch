# frozen_string_literal: true

RSpec.describe ROM::Elasticsearch::Dataset, "#delete" do
  subject(:dataset) do
    ROM::Elasticsearch::Dataset.new(client, params: {index: :users})
  end

  include_context "user fixtures"

  it "deletes data" do
    expect(dataset.to_a.size).to eql(3)

    dataset.refresh.delete

    dataset.refresh

    expect(dataset.to_a.size).to eql(0)
  end
end

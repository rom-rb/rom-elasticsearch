# frozen_string_literal: true

require "rom/lint/spec"

RSpec.describe ROM::Elasticsearch::Gateway do
  let(:uri) { "http://localhost:9200/rom-test" }

  it_behaves_like "a rom gateway" do
    let(:identifier) { :elasticsearch }
    let(:gateway) { ROM::Elasticsearch::Gateway }
  end
end

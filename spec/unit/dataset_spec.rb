require 'spec_helper'

RSpec.describe ROM::Elasticsearch::Dataset do
  let(:client) { Elasticsearch::Client.new(log: false) }
  let(:dataset) { ROM::Elasticsearch::Dataset.new(client, index: 'rom-test', type: 'users') }


  before {
    dataset.delete_all
    dataset.index(username: 'eve')
    dataset.index(username: 'bob')
    dataset.index(username: 'alice')

    sleep 2 # let elasticsearch digest our documents..
  }
  describe 'insert' do
    it 'works' do
      expect(dataset.with_options(size: 100).to_a.size).to eq(3)

      expect(dataset.with_options(size: 2).to_a.size).to eq(2)

      result = dataset.search(body: {
                                  query: {
                                      query_string: {
                                          query: 'username:eve'
                                      }
                                  }
                              }).to_a

      expect(result.map { |r| r['_source'] }).to match_array([{'username' => 'eve'}])

      result = dataset.query_string('username:nisse').to_a
      expect(result).to match_array([])

      result = dataset.query_string('username:alice').to_a
      expect(result.map { |r| r['_source'] }).to match_array([{'username' => 'alice'}])
    end
  end

  describe 'delete' do
    it 'works' do
      expect(dataset.to_a.size).to eq(3)
      dataset.delete_all

      sleep 2
      expect(dataset.to_a.size).to eq(0)
    end
  end
end

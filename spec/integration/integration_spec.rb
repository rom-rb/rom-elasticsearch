require 'spec_helper'

describe 'integration' do
  let(:gateway) { ROM::Elasticsearch::Gateway.from_uri('http://127.0.0.1:9200/rom-test') }
  let(:conf) {
    conf = ROM::Configuration.new(default: gateway)
    conf.relation(:users) do
      schema(:users)

      def like(name)
        query(prefix: { username: name })
      end
    end

    conf.commands(:users) do
      define(:create)
    end

    conf
  }

  let(:rom) { ROM.container(conf) }


  before {
    begin
      if gateway.client.indices.exists?(index: 'users')
        gateway.client.indices.delete(index: 'users')
      end
      gateway.client.indices.create(index: 'users')
    rescue
    end
  }

  after {
    gateway.client.indices.delete(index: 'users')
  }


  let(:users) { rom.relations[:users] }
  let(:commands) { rom.commands[:users] }

  it 'creating records' do
    expect(users.to_a).to be_a(Array)

    user_id = 3289

    result = commands.create.call(id: user_id, username: 'kwando', email: 'hannes@bemt.nu')

    expect(result).to be_a_kind_of(ROM::Relation)

    array = result.to_a
    expect(array).to be_a_kind_of(Array)
    expect(array.size).to be(1)
    expect(array[0]['_source']['id']).to eql(user_id)

    sleep 2
    expect(users.like('kwando').to_a).not_to be_empty
  end

  describe 'sanity checks' do
    it 'is a ROM::Gateway' do
      expect(gateway).to be_a_kind_of(ROM::Gateway)
    end
  end
end

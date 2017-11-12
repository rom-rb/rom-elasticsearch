RSpec.describe 'integration' do
  include_context 'container'

  before {
    gateway['user'].delete_all

    conf.relation(:users) do
      schema(:users)

      def like(name)
        query(prefix: { username: name })
      end
    end

    conf.commands(:users) do
      define(:create)
    end
  }

  after {
    gateway['user'].wait.delete_all
  }


  let(:users) { container.relations[:users] }

  it 'creating records' do
    expect(users.to_a).to be_a(Array)

    user_id = 3289

    result = commands[:users].create.(id: user_id, username: 'kwando', email: 'hannes@bemt.nu')

    expect(result).to be_a(Hash)
    expect(result).
      to eql(
           'id' => 3289,
           'username' => 'kwando',
           'email' => 'hannes@bemt.nu'
         )

    expect(users.like('kwando').to_a).not_to be_empty
  end

  describe 'sanity checks' do
    it 'is a ROM::Gateway' do
      expect(gateway).to be_a_kind_of(ROM::Gateway)
    end
  end
end

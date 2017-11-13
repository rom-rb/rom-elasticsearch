RSpec.describe 'integration' do
  let(:users) { relations[:users] }

  include_context 'container'

  before do
    gateway[:users].delete_all

    conf.relation(:users) do
      schema(:users) do
        attribute :id, ROM::Types::Int
        attribute :username, ROM::Types::String
        attribute :email, ROM::Types::String
      end

      def like(name)
        query(prefix: { username: name })
      end
    end

    conf.commands(:users) do
      define(:create)
    end
  end

  after do
    gateway[:users].wait.delete_all
  end

  it 'creating records' do
    expect(users.to_a).to be_a(Array)

    user_id = 3289

    result = commands[:users].create.(id: user_id, username: 'kwando', email: 'hannes@bemt.nu').first

    expect(result).to be_a(Hash)

    expect(result).to eql(id: 3289, username: 'kwando', email: 'hannes@bemt.nu')

    expect(users.like('kwando').to_a).not_to be_empty
  end
end

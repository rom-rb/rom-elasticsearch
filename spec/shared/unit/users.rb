RSpec.shared_context 'users' do
  include_context 'setup'

  before do
    conf.relation(:users) do
      schema(:users) do
        attribute :id, ROM::Types::Integer
        attribute :name, ROM::Types::String

        primary_key :id
      end
    end
  end

  after do
    gateway[:users].refresh.delete
  end
end

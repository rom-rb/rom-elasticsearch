RSpec.shared_context 'users' do
  include_context 'container'

  before do
    gateway[:users]

    conf.relation(:users) do
      schema(:users) do
        attribute :id, ROM::Types::Int
        attribute :name, ROM::Types::String
      end
    end
  end

  after do
    gateway[:users].wait.delete_all
  end
end

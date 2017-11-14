RSpec.shared_context 'user fixtures' do
  include_context 'setup'

  before do
    dataset.put(username: 'eve')
    dataset.put(username: 'bob')
    dataset.put(username: 'alice')

    refresh
  end
end

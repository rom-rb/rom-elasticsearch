RSpec.describe ROM::Elasticsearch::Relation do
  include_context 'container'

  before { gateway['user'] }

  def build_attribute(source, name, type)
    ROM::Attribute.new(ROM::Types.const_get(type)).
      meta(
        source: ROM::Relation::Name[source],
        name: name
      )
  end

  describe 'schema' do
    before do
      class Test::Users < ROM::Relation[:elasticsearch]
        schema(:users) do
          attribute :id,   ROM::Types::Int
          attribute :name, ROM::Types::String
          attribute :age,  ROM::Types::Int
        end
      end

      conf.register_relation(Test::Users)

      conf.commands(:users) do
        define(:create)
      end
    end

    it 'defines a schema' do
      users = relations[:users]
      expect(users.schema[:name]).
        to eql(build_attribute(:users, :name, :String))
    end
  end
end

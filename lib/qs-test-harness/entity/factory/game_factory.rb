class Qs::Test::Harness::Entity::Factory
  class GameFactory
    attr_reader :harness

    def initialize(harness)
      @harness = harness
    end

    def create(options = {})
      user = @harness.entity_factory.create(:user)
      @harness.provider(:devcenter).client.authorize_with(@harness.provider(:auth).system_access) do |client|
        client.post("/v1/developers/#{user.uuid}").must_respond_with(status: 201)
      end

      Qs::Test::Harness::Entity::Developer.new(self, user)
    end
  end
end
class Qs::Test::Harness::Entity
  module UUIDEntity
    def roles
      harness = @factory.harness
      harness.provider(:graph).client.authorize_with(harness.provider(:auth).system_access) do |client|
        JSON.parse(client.get("/v1/entities/#{uuid}/roles").must_respond_with(status: 200).body)
      end
    end
  end
end
class Qs::Test::Harness::Entity::Factory
  class UserFactory
    attr_reader :harness, :test_helpers

    def initialize(harness)
      @harness = harness
      @counter = 0
    end

    def create(options = {})
      @counter += 1
      options = {
        'name' => "Paula Sample #{@counter}",
        'email' => "example-#{@counter}@example.com",
        'password' => 'quarterspiral',
        :tos_not_accepted => false,
        :no_invitation => false
      }.merge(options)

      app_result = test_helpers.create_user!(options)
      user_data = test_helpers.user_data(app_result['name'])
      user = Qs::Test::Harness::Entity::User.new(self, user_data.merge('password' => options['password']))

      user
    end

    def test_helpers
      @harness.provider(:auth).test_helpers
    end
  end
end
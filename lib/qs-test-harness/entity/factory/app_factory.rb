class Qs::Test::Harness::Entity::Factory
  class AppFactory
    attr_reader :harness, :test_helpers

    def initialize(harness)
      @harness = harness
    end

    def create(options = {})
      app_result = test_helpers.create_app!
      if options[:redirect_url]
        test_helpers.set_app_redirect_uri!(app_result[:internal_id], options[:redirect_url])
        app_result[:redirect_url] = options[:redirect_url]
      end
      Qs::Test::Harness::Entity::App.new(self, app_result)
    end

    def test_helpers
      @harness.provider(:auth).test_helpers
    end
  end
end
module Qs::Test::Harness::Provider
  class Auth < Base
    def initialize(harness)
      super
      require 'auth-backend'
      require 'auth-backend/test_helpers'

      augment_with(:graph)

      harness.entity_factory.register :user, ::Qs::Test::Harness::Entity::Factory::UserFactory
    end

    def app(*args)
      # silence test mode warning when instantiating the app
      silently do
        super
      end
    end

    def app_options
      {test: true}
    end

    def app_class
      ::Auth::Backend::App
    end

    def system_access
      @system_access_token ||= test_helpers.get_app_token(system_access_app['id'], system_access_app['secret'])
    end

    def test_helpers
      return @test_helpers if @test_helpers

      # silencing the migration messages when setting up the test helpers
      silently do
        @test_helpers = ::Auth::Backend::TestHelpers.new(app)
      end
    end

    def inject_into(parent)
      app = self.app
      ::Auth::Client.class_eval do
        alias raw_initialize initialize
        define_method(:initialize) do |url, options = {}|
          raw_initialize(url, options.merge(adapter: [:rack, app]))
        end
      end
    end

    protected
    def system_access_app
      return @system_access_app if @system_access_app
      app = test_helpers.create_app!
      ENV['QS_OAUTH_CLIENT_ID'] = app[:id]
      ENV['QS_OAUTH_CLIENT_SECRET'] = app[:secret]
      @system_access_app = {'id' => app[:id], 'secret' => app[:secret]}
    end

    def silently
      orig_std_out = STDOUT.clone
      STDOUT.reopen('/dev/null') if File.exist?('/dev/null')

      result = nil
      begin
        result = yield
      ensure
        STDOUT.reopen(orig_std_out)
      end
      result
    end
  end
end
class Qs::Test::Harness
  class Initializer
    attr_reader :providers, :app_under_test

    def initialize
      @providers = []
    end

    def provide(provider)
      @providers << provider
    end

    def test(app_under_test)
      @app_under_test = app_under_test
    end
  end
end
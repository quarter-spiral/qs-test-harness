module Qs::Test::Harness::Provider
  class Base
    def initialize(harness)
      @harness = harness
    end

    def adaptor
      @adaptor ||= Service::Client::Adapter::Faraday.new(adapter: [:rack, app])
    end

    def app
      @app ||= app_options ? app_class.new(app_options) : app_class.new
    end

    def callsign
      self.class.name.split('::').last.downcase
    end

    def app_options
    end

    def client
      app = self.app
      @client ||= Rack::Client.new {run app}
    end

    def inject_into(parent)
      harness = @harness
      callsign = self.callsign
      provider = self

      appender_module = Module.new
      appender_module.class_eval do
        self.class.class_eval do
          define_method(:_qs_callsign) {callsign}
          define_method(:_qs_provider) {provider}
        end
        def self.included(base) # built-in Ruby hook for modules
          callsign = _qs_callsign
          provider = _qs_provider
          base.class_eval do
            original_method = instance_method(:initialize)
            define_method(:initialize) do |*args, &block|
              original_method.bind(self).call(*args, &block)
              instance_variable_get("@#{callsign}").client.raw.adapter = provider.adaptor
            end
          end
        end
      end
      parent.connection_class.class_eval do
        include appender_module
      end
    end

    protected
    def augment_with(*provider_names)
      provider_names.each do |provider_name|
        provider = @harness.provider(provider_name)
        provider.inject_into(self)
      end
    end

    def connection_class
      app_class.name.gsub(/::[^:]+$/, "::Connection").split('::').inject(Kernel) {|scope, const| scope.const_get(const)}
    end
  end
end
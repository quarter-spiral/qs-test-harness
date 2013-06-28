require 'json'

module Qs
  module Test
    class Harness
      attr_reader :app

      def initialize(initializer)
        @app = initializer.app_under_test.new

        @providers = []
        initializer.providers.uniq.each do |provider|
          @providers << provider.new(self)
        end

        ready!
      end

      def client
        @client ||= Client.new(self)
      end

      def entity_factory
        @entity_factory ||= Entity::Factory.new(self)
      end

      def provider(callsign)
        @providers.detect {|provider| provider.callsign.to_s == callsign.to_s}
      end

      def when_ready(&block)
        return block.call(self) if ready?

        when_ready_callbacks << block
      end

      def self.reset!
        @client = nil
        @entity_factory = nil
        @when_ready_callbacks = nil
        @ready = false
      end

      def self.setup!(&block)
        reset!
        initializer = Initializer.new
        initializer.instance_eval(&block)
        @harness = new(initializer)
      end

      def self.harness
        @harness
      end

      protected
      def ready!
        @ready = true
        when_ready_callbacks.each do |callback|
          callback.call(self)
        end
      end

      def ready?
        @ready
      end

      def when_ready_callbacks
        @when_ready_callbacks ||= []
      end
    end
  end
end

require "qs-test-harness/version"
require "qs-test-harness/response_enhancement"
require "qs-test-harness/rack_client_enhancement"
require "qs-test-harness/initializer"
require "qs-test-harness/entity"
require "qs-test-harness/client"
require "qs-test-harness/provider"
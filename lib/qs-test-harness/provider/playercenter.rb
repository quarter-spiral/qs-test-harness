module Qs::Test::Harness::Provider
  class Playercenter < Base
    def initialize(harness)
      super
      require 'playercenter-backend'
      require 'playercenter-client'

      augment_with(:graph, :auth, :devcenter)

      harness.entity_factory.register :player, ::Qs::Test::Harness::Entity::Factory::PlayerFactory
    end

    def app_class
      ::Playercenter::Backend::API
    end

    def qs_client_class
      ::Playercenter::Client
    end
  end
end
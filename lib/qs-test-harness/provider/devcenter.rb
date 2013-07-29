module Qs::Test::Harness::Provider
  class Devcenter < Base
    def initialize(harness)
      super
      require 'devcenter-backend'
      require 'devcenter-client'

      augment_with(:graph, :datastore, :auth)

      harness.entity_factory.register :developer, ::Qs::Test::Harness::Entity::Factory::DeveloperFactory
      harness.entity_factory.register :game, ::Qs::Test::Harness::Entity::Factory::GameFactory
    end

    def app_class
      ::Devcenter::Backend::API
    end

    def qs_client_class
      ::Devcenter::Client
    end
  end
end
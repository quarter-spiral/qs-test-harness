module Qs::Test::Harness::Provider
  class Devcenter < Base
    def initialize(harness)
      super
      require 'devcenter-backend'

      augment_with(:graph, :datastore, :auth)

      harness.entity_factory.register :developer, ::Qs::Test::Harness::Entity::Factory::DeveloperFactory
    end

    def app_class
      ::Devcenter::Backend::API
    end
  end
end
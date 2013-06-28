class Qs::Test::Harness::Entity
  class Factory
    def initialize(harness)
      @harness = harness
      @factories = {}
    end

    def register(entity, factory)
      @factories[entity] = factory.new(@harness)
    end

    def create(entity, *args)
      factory = @factories[entity]
      raise "No factory for entity type: #{entity} registered!" unless factory
      factory.create(*args)
    end
  end
end

require "qs-test-harness/entity/factory/user_factory"
require "qs-test-harness/entity/factory/developer_factory"
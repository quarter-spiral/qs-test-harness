require_relative './spec_helper'

class MockEntityFactory
  def initialize(harness)
    @counter = 0
  end

  def create(string = nil, options = {})
    result = ''
    result = "#{options[:prefix]} " if options[:prefix]

    result += "Mock #{string || (@counter += 1)}"
  end
end

class MockApp
  def initialize(harness)
    harness.entity_factory.register :mock_entity, MockEntityFactory
  end
end

class EntitiesSpec < MiniTest::Spec
  before_all do
    basic_harness_setup! do
      provide MockApp
    end
  end

  before do
    @harness = Qs::Test::Harness.harness
  end

  describe "registered entities" do
    it "can be created" do
      entity1 = @harness.entity_factory.create(:mock_entity)
      entity1.must_equal "Mock 1"

      entity2 = @harness.entity_factory.create(:mock_entity)
      entity2.must_equal "Mock 2"
    end

    it "can take options for their creation" do
      entity = @harness.entity_factory.create(:mock_entity, 77, :prefix => "HAHA")
      entity.must_equal "HAHA Mock 77"
    end
  end
end
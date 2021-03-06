require_relative '../spec_helper'

class DeveloperFactorySpec < MiniTest::Spec
  before_all do
    default_harness_setup!
  end

  describe Qs::Test::Harness::Entity::Factory::DeveloperFactory do
    before do
      @harness = Qs::Test::Harness.harness
    end

    it "can create developer" do
      developer = @harness.entity_factory.create(:developer)

      developer.name.wont_be_empty
      developer.uuid.wont_be_empty
      developer.password.wont_be_empty
      developer.accepted_tos_version.wont_be_nil
      developer.roles.must_include 'developer'
    end
  end
end
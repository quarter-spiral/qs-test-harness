require_relative '../spec_helper'

class DeveloperFactorySpec < MiniTest::Spec
  before_all do
    Qs::Test::Harness.setup! do
      provide Qs::Test::Harness::Provider::Datastore
      provide Qs::Test::Harness::Provider::Graph
      provide Qs::Test::Harness::Provider::Auth
      provide Qs::Test::Harness::Provider::Devcenter

      test Qs::Test::Harness::SampleApp
    end
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
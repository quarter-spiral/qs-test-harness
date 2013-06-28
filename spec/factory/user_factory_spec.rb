require_relative '../spec_helper'

class UserFactorySpec < MiniTest::Spec
  before_all do
    default_harness_setup!
  end

  describe Qs::Test::Harness::Entity::Factory::UserFactory do
    before do
      @harness = Qs::Test::Harness.harness
    end

    it "can create users" do
      user = @harness.entity_factory.create(:user)
      user.name.wont_be_empty
      user.uuid.wont_be_empty
      user.password.wont_be_empty
      user.accepted_tos_version.wont_be_nil
    end

    it "can create multiple users" do
      user1 = @harness.entity_factory.create(:user)
      user2 = @harness.entity_factory.create(:user)

      user1.name.wont_be_empty
      user2.name.wont_be_empty
      user1.name.wont_equal user2.name

      user1.uuid.wont_be_empty
      user2.uuid.wont_be_empty
      user1.uuid.wont_equal user2.uuid
    end

    it "can create users with custom options" do
      user = @harness.entity_factory.create(:user, 'name' => "Jim")
      user.name.must_equal 'Jim'

      user = @harness.entity_factory.create(:user, :tos_not_accepted => true)
      user.accepted_tos_version.must_be_nil
    end
  end
end
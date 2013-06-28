require_relative '../spec_helper'

class UserSpec < MiniTest::Spec
  before_all do
    Qs::Test::Harness.setup! do
      provide Qs::Test::Harness::Provider::Datastore
      provide Qs::Test::Harness::Provider::Graph
      provide Qs::Test::Harness::Provider::Auth

      test Qs::Test::Harness::SampleApp
    end
  end

  describe Qs::Test::Harness::Entity::User do
    before do
      @harness = Qs::Test::Harness.harness
      @user = @harness.entity_factory.create(:user)
    end

    describe "token creation" do
      before do
        @token = @user.token
      end

      it "works" do
        @token.wont_be_empty
      end

      it "does only generate new tokens once" do
        @token.must_equal @user.token
      end

      it "creates a new token when a token refresh is requested" do
        new_token = @user.refresh_token!
        new_token.wont_be_empty
        new_token.wont_equal @token
        new_token.must_equal @user.token
      end
    end
  end
end
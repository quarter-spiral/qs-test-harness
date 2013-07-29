require_relative '../spec_helper'

class GameFactorySpec < MiniTest::Spec
  before_all do
    default_harness_setup!
  end

  describe Qs::Test::Harness::Entity::Factory::GameFactory do
    before do
      @harness = Qs::Test::Harness.harness
      @factory = @harness.entity_factory
    end

    it "can create games" do
      game = @factory.create(:game)
      game.name.wont_be_empty
      game.uuid.wont_be_empty
      game.developers.wont_be_empty

      game2 = @factory.create(:game)
      game2.name.wont_equal game.name
      game2.uuid.wont_equal game.uuid
      game2.developers.first.wont_equal game.developers.first
    end

    it "can create games with given developers" do
      dev = @factory.create(:developer)
      game = @factory.create(:game, 'developers' => [dev])
      game.name.wont_be_empty
      game.uuid.wont_be_empty
      game.developers.must_equal [dev.uuid]
    end

    describe "enabling venues" do
      it "works for embedded" do
        game = @factory.create(:game, 'venues' => ['embedded'])
        game.uuid.wont_be_empty
        game.venues.size.must_equal 1
        game.venues["embedded"]["enabled"].must_equal true
      end

      it "works for spiral-galaxy" do
        game = @factory.create(:game, 'venues' => ['spiral-galaxy'])
        game.uuid.wont_be_empty
        game.venues.size.must_equal 1
        game.venues["spiral-galaxy"]["enabled"].must_equal true
      end

      it "works for facebook" do
        game = @factory.create(:game, 'venues' => ['facebook'])
        game.venues.size.must_equal 1
        game.venues['facebook']['enabled'].must_equal true
        game.venues['facebook']['app-id'].wont_be_empty
        game.venues['facebook']['app-secret'].wont_be_empty
      end

      it "works for multiple venues" do
        game = @factory.create(:game, 'venues' => ['facebook', 'embedded'])
        game.venues.size.must_equal 2

        game.venues["embedded"]["enabled"].must_equal true

        game.venues['facebook']['enabled'].must_equal true
        game.venues['facebook']['app-id'].wont_be_empty
        game.venues['facebook']['app-secret'].wont_be_empty
      end
    end
  end
end
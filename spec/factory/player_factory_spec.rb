require_relative '../spec_helper'

class PlayerFactorySpec < MiniTest::Spec
  before_all do
    default_harness_setup!
  end

  describe Qs::Test::Harness::Entity::Factory::PlayerFactory do
    before do
      @harness = Qs::Test::Harness.harness
      @factory = @harness.entity_factory
    end

    it "can create player" do
      player = @factory.create(:player)

      player.name.wont_be_empty
      player.uuid.wont_be_empty
      player.password.wont_be_empty
      player.accepted_tos_version.wont_be_nil
      player.roles.must_include 'player'
    end

    it "can create a player of a game" do
      game = @factory.create(:game)
      player = @factory.create(:player, 'game' => game)

      player.games.map(&:uuid).must_include(game.uuid)
    end
  end
end
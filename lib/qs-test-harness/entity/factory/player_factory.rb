class Qs::Test::Harness::Entity::Factory
  class PlayerFactory
    attr_reader :harness

    def initialize(harness)
      @harness = harness
    end

    def create(options = {})
      player = ::Qs::Test::Harness::Entity::Player.new(self, @harness.entity_factory.create(:user))

      game = options['game'] || @harness.entity_factory.create(:game, 'venues' => ['embedded'])

      player.add_to_game(game, 'embedded')

      player
    end
  end
end
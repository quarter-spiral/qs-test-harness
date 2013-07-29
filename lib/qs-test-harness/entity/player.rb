class Qs::Test::Harness::Entity
  class Player < User
    def initialize(*args)
      super

      @playercenter_client = @factory.harness.provider(:playercenter).qs_client
      @devcenter_client = @factory.harness.provider(:devcenter).qs_client

      @harness = @factory.harness
    end

    def games
      token = @harness.provider(:auth).system_access
      @playercenter_client.list_games(uuid, token).map {|game_data| ::Qs::Test::Harness::Entity::Game.new(token, @devcenter_client.get_game(token, game_data['uuid']))}
    end

    def add_to_game(game, venue)
      @playercenter_client.register_player(uuid, game.uuid, venue, @harness.provider(:auth).system_access)
    end
  end
end
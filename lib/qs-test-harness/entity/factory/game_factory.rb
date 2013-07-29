class Qs::Test::Harness::Entity::Factory
  class GameFactory
    DEFAULTS = {
      "description" => "A good game",
      "configuration" => {type: "html5", url: "http://example.com/game"},
      "category" => "Jump n run",
      "venues" => {
        "facebook" => {
          "enabled" => true,
          "app-id" => "119766961504555",
          "app-secret" => "0b40a9fb11f5f42f1c48835ea8eac220"
        },
        "spiral-galaxy" => {
          "enabled" => true
        },
        "embedded" => {
          "enabled" => true
        }
      }
    }

    attr_reader :harness

    def initialize(harness)
      @harness = harness
      @counter = 0
    end

    def create(options = {})
      @counter += 1

      developer = @harness.entity_factory.create(:developer)

      options["name"] ||= "Test Game #{@counter}"
      options["developers"] ||= [developer.uuid]

      options["developers"] = options["developers"].map {|developer| developer.respond_to?(:uuid) ? developer.uuid : developer}

      if options['venues'] && options['venues'].kind_of?(Array)
        options['venues'] = Hash[options['venues'].map do |venue|
          case venue
          when 'embedded'
            ['embedded', {'enabled' => true}]
          when 'facebook'
            ['facebook', {'enabled' => true, 'app-id' => (12300000 + @counter).to_s, 'app-secret' => (45600000 + @counter).to_s}]
          when 'spiral-galaxy'
            ['spiral-galaxy', {'enabled' => true}]
          end
        end]
      end

      @harness.provider(:devcenter).client.authorize_with(@harness.provider(:auth).system_access) do |client|
        app_result = JSON.parse(client.post("/v1/games", json: DEFAULTS.merge(options)).must_respond_with(status: 201).body)
        ::Qs::Test::Harness::Entity::Game.new(client.auth_token, app_result)
      end
    end
  end
end
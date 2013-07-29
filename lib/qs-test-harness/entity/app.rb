class Qs::Test::Harness::Entity
  class App
    include UUIDEntity

    MASS_ASSIGNABLE_ATTRIBTUES = %w{id secret redirect_url}

    attr_accessor :id, :secret, :redirect_url

    def initialize(factory, options = {})
      @factory = factory
      update_from_hash(options)
    end

    def token
      return @token if @token

      app = @factory.harness.provider(:auth).app
      authed_client = Rack::Client.new {run Rack::Client::Auth::Basic.new(app, id, secret, true)}
      @token = JSON.parse(authed_client.post("http://example.com/api/v1/token/app").body)['token']
    end

    def refresh_token!
      @token = nil
      token
    end

    def update_from_hash(hash)
      MASS_ASSIGNABLE_ATTRIBTUES.each do |field|
        if hash.has_key?(field) || hash.has_key?(field.to_s) || hash.has_key?(field.to_sym)
          value = hash[field] || hash[field.to_s] || hash[field.to_sym]
          self.send("#{field}=", value)
        end
      end
    end
  end
end
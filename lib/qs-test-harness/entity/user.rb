require 'uri'

class Qs::Test::Harness::Entity
  class User
    include UUIDEntity

    DEFAULTS = {
      'name' => "John",
      'email' => "john@example.com",
      'admin' => 'false',
      'password' => 'quarterspiral'
    }

    MASS_ASSIGNABLE_ATTRIBTUES = %w{name email admin password uuid accepted_tos_version}

    attr_accessor :name, :email, :admin, :password, :uuid, :accepted_tos_version
    attr_writer :password_confirmation

    def initialize(factory, options = {})
      @factory = factory

      if options.kind_of?(User)
        update_from_user(options)
      else
        options = DEFAULTS.merge(options)
        update_from_hash(options)
      end
    end

    def password_confirmation
      @password_confirmation || @password
    end

    def token
      return @token if @token

      app = @factory.harness.provider(:auth).app
      name = self.name
      password = self.password
      authed_client = Rack::Client.new {run Rack::Client::Auth::Basic.new(app, name, password, true)}
      @token = JSON.parse(authed_client.post("http://example.com/api/v1/token").body)['token']
    end

    def refresh_token!
      @token = nil
      token
    end

    def accept_tos!
      @factory.test_helpers.accept_tos!(to_hash).body
    end

    def logged_in_cookie
      client = @factory.harness.provider(:auth).client
      response = client.post "/login", body: URI.encode_www_form(name: name, password: password)
      response.headers['Set-Cookie']
    end

    def to_hash
      {
        'name' => name,
        'email' => email,
        'password' => password,
        'password_confirmation' => password_confirmation
      }
    end

    def update_from_hash(hash)
      MASS_ASSIGNABLE_ATTRIBTUES.each do |field|
        if hash.has_key?(field) || hash.has_key?(field.to_s)
          value = hash[field] || hash[field.to_s]
          self.send("#{field}=", value)
        end
      end
    end

    def update_from_user(user)
      MASS_ASSIGNABLE_ATTRIBTUES.each do |field|
        self.send("#{field}=", user.send(field))
      end
    end
  end
end
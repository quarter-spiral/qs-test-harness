require 'rack/client'

class Qs::Test::Harness
  class Client
    attr_reader :auth_token, :app
    def initialize(app)
      @app = app
    end

    def authorize_with(token)
      old_auth_token = @auth_token
      @auth_token = token
      if block_given?
        result = yield self
        @auth_token = old_auth_token
        result
      end
    end

    def reset_authorization
      @auth_token = nil
    end

    def request(method, url, options = {})
      body = options[:body]
      headers = options[:headers] || {}

      if options[:json]
        body = JSON.dump(options[:json])
        headers['Content-Type'] = 'application/json'
      end

      headers['Content-Length'] = body.size if body && body.respond_to?(:size)

      headers['Authorization'] ||= "Bearer #{@auth_token}" if @auth_token

      client.request(method.to_s, url, headers, body)
    end

    [:get, :post, :put, :delete, :patch, :head, :options, :trace, :connect].each do |method|
      define_method(method) do |url, options = {}|
        request(method, url, options)
      end
    end

    protected
    def client
      app = self.app
      @rack_client ||= Rack::Client.new do
        run app
      end
    end
  end
end
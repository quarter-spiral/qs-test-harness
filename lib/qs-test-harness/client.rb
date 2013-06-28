require 'rack/client'

class Qs::Test::Harness
  class Client
    def initialize(harness)
      @rack_client = Rack::Client.new do
        run harness.app
      end
    end

    def request(method, url, options = {})
      headers = options[:headers] || {}
      body = options[:body]
      body = JSON.dump(options[:json]) if options[:json]

      @rack_client.request(method, url, headers, body)
    end

    [:get, :post, :put, :delete, :patch, :head, :options, :trace, :connect].each do |method|
      define_method(method) do |url, options = {}|
        request(method, url, options)
      end
    end
  end
end
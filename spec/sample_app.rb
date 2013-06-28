class Qs::Test::Harness
  class SampleApp
    def call(env)
      request = Rack::Request.new(env)

      body = request.body.read
      body = 'Hello' if body.empty?

      [200, {'Content-Type' => 'text/plain'}, [body]]
    end
  end
end
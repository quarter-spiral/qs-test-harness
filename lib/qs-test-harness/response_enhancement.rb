class Qs::Test::Harness
  module ResponseEnhancement
    def must_respond_with(options)
      status = options[:status]
      body = options[:body]

      self.status.must_equal status if status
      self.body.must_equal body if body

      self
    end

    def data
      JSON.parse(body)
    end
  end
end

require 'rack'
class Rack::Response
  include Qs::Test::Harness::ResponseEnhancement
end
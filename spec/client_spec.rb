require_relative './spec_helper'

class ClientSpec < MiniTest::Spec
  before_all do
    basic_harness_setup!
  end

  describe Qs::Test::Harness::Client do
    before do
      @harness = Qs::Test::Harness.harness
      @client = @harness.client
    end

    it "is there" do
      @harness.client.wont_be_nil
    end

    it "can send requests" do
      response = @harness.client.get "/"
      response.status.must_equal 200

      @harness.client.get('/').must_respond_with(status: 200, body: 'Hello')
    end

    it "has the parsed JSON response data available" do
      response = @harness.client.post('/echo', json: {"bla" => "blub", "1" => 2})
      response.data.must_equal("bla" => "blub", "1" => 2)
    end
  end
end
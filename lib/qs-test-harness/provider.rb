module Qs::Test::Harness::Provider
  def self.from_app(app_class, providers)
    provider = Class.new(Base)
    provider.class_eval do
      define_method(:app_class) {app_class}

      define_method(:initialize) do |harness|
        super(harness)
        augment_with(*providers)
      end
    end
    provider
  end
end

require "qs-test-harness/provider/base"
require "qs-test-harness/provider/datastore"
require "qs-test-harness/provider/graph"
require "qs-test-harness/provider/auth"
require "qs-test-harness/provider/devcenter"
require "qs-test-harness/provider/playercenter"
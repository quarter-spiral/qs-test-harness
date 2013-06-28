module Qs::Test::Harness::Provider
  class Datastore < Base
    def initialize(harness)
      super
      require 'datastore-backend'
    end

    def app_class
      ::Datastore::Backend::API
    end
  end
end
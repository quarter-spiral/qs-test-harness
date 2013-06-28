Bundler.require

require 'minitest/autorun'

require 'qs-test-harness'
require "qs-test-harness/mini_test_enhancement"

require_relative './sample_app'

def basic_harness_setup!(&block)
  has_block = block_given?
  Qs::Test::Harness.setup! do
    instance_eval(&block) if has_block

    test Qs::Test::Harness::SampleApp
  end
end

def default_harness_setup!(&block)
  Qs::Test::Harness.setup! do
    provide Qs::Test::Harness::Provider::Datastore
    provide Qs::Test::Harness::Provider::Graph
    provide Qs::Test::Harness::Provider::Auth
    provide Qs::Test::Harness::Provider::Devcenter

    test Qs::Test::Harness::SampleApp
  end
end
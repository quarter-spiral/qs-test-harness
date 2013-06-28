require_relative './spec_helper'

class HarnessSpec < MiniTest::Spec
  before_all do
    default_harness_setup!
  end

  describe Qs::Test::Harness do
    it 'returns a singleton harness' do
      harness = Qs::Test::Harness.harness
      harness.wont_be_nil

      Qs::Test::Harness.harness.must_be_same_as harness
    end
  end
end
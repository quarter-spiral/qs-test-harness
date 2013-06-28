class PreparedSwitch
  def prepared?
    @prepared
  end

  def prepared!
    @prepared = true
  end
end


class MiniTest::Spec
  def self.before_all(&blck)
    tests = PreparedSwitch.new
    before do
      unless tests.prepared?
        blck.call
        tests.prepared!
      end
    end
  end
end
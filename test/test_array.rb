require 'test/unit'
require 'rushcheck'

class TC_RandomArray < Test::Unit::TestCase

  def setup
    MyRandomArray.set_pattern(Integer) {|i| i}
  end

  def teardown
  end

  class MyRandomArray < RandomArray; end
  def test_arbitrary
    assert_instance_of(RushCheck::Gen, MyRandomArray.arbitrary)
  end

  def test_coarbitrary
    g = RushCheck::Gen.unit(0)
    assert_instance_of(RushCheck::Gen, MyRandomArray.new.coarbitrary(g))
  end

end

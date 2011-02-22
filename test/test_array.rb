require 'test/unit'
require 'rushcheck/rushcheck'

class TC_RandomArray < Test::Unit::TestCase

  def setup
    MyRandomArray.set_pattern(0) {|i| i}
  end

  def teardown
  end

  class TestSPArray < RandomArray; end
  def test_set_pattern
    RushCheck::Assertion.new(Integer, Integer, Integer) do |x, i, n|
      RushCheck::guard {i > 0}
      TestSPArray.set_pattern(x) {|j| j}
      a = TestSPArray.arbitrary.value(n, RushCheck::StdGen.new)
      len = a.length
      case len
      when 0
        a.empty? 
      else 
        RushCheck::Gen.choose(0, len - 1).bind {|i| (a.first == x && a[i]==i)}
      end
    end.quick_check
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

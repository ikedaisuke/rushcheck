require 'test/unit'
require 'rushcheck'

class TC_RandomArray < Test::Unit::TestCase

  class MyRandomArray < NonEmptyRandomArray; end

  def setup
    MyRandomArray.set_pattern(Integer) {|i| Integer}
  end

  def teardown
  end

  def test_random_array_nonempty
    assert_equal true,
    RushCheck::Assertion.new(MyRandomArray) { |xs|
       ! xs.empty?
    }.check
  end

  def test_random_array_class
    results = []
    RushCheck::Assertion.new(MyRandomArray) { |xs|
      # each_with_index skips if xs is empty
      xs.each_with_index { |x, i|
        # x[i].class should be Fixnum or merely Bignum
        results << (Integer == x[i].class.superclass)
      }
      results.all? {|r| r == true}
    }.check
  end

  def test_arbitrary
    assert_instance_of(RushCheck::Gen, MyRandomArray.arbitrary)
  end

  def test_coarbitrary
    g = RushCheck::Gen.unit(0)
    assert_instance_of(RushCheck::Gen, MyRandomArray.new.coarbitrary(g))
  end

end

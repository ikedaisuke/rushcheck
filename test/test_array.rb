require 'test/unit'
require 'rushcheck/array'

class TC_RandomArray < Test::Unit::TestCase

  class IntegerRandomArray < NonEmptyRandomArray; end
  class StringRandomArray < NonEmptyRandomArray; end

  def setup
    IntegerRandomArray.set_pattern {|i| Integer}
    StringRandomArray.set_pattern {|i| String}
  end

  def teardown
  end

  def test_random_array_nonempty
    assert_equal true,
      RushCheck::Assertion.new(IntegerRandomArray) { |xs|
         ! xs.empty?
      }.check
  end

  def test_random_array_class_integer
    results = []
    assert_equal true,
      RushCheck::Assertion.new(IntegerRandomArray) { |xs|
        # skips if xs is empty
        xs.each { |x|
          # x.class should be Fixnum or merely Bignum
          results << (Integer == x.class.superclass)
        }
        results.all? {|r| r == true}
      }.check
  end

  def test_random_array_class_string
    results = []
    assert_equal true,
      RushCheck::Assertion.new(StringRandomArray) { |xs|
        # skips if xs is empty
        xs.each { |x|
          # x.class should be String
          results << (String == x.class)
        }
        results.all? {|r| r == true}
      }.check
  end

  def test_arbitrary
    assert_instance_of(RushCheck::Gen,
      IntegerRandomArray.arbitrary)
  end

  def test_coarbitrary
    g = RushCheck::Gen.unit(0)
    assert_instance_of(RushCheck::Gen,
     IntegerRandomArray.new.coarbitrary(g))
  end

end

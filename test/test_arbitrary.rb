require 'test/unit'
require 'rushcheck/arbitrary'

class TC_Arbitrary < Test::Unit::TestCase

  extend RushCheck::Arbitrary

  def setup
  end

  def teardown
  end

  def test_arbitrary
    assert_raise(NameError) { arbitrary }
  end

end

class TC_Coarbitrary < Test::Unit::TestCase

  include RushCheck::Coarbitrary

  def setup
  end

  def teardown
  end

  def test_coarbitrary
    assert_raise(NameError) { coarbitrary(nil) }
  end

end

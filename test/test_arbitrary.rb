require 'test/unit'
require 'rushcheck/arbitrary'

class TC_Arbitrary < Test::Unit::TestCase

  include RushCheck::Arbitrary

  def setup
  end

  def teardown
  end

  def test_arbitrary
    assert_raise(NotImplementedError) { arbitrary }
  end

end

class TC_Coarbitrary < Test::Unit::TestCase

  include RushCheck::Coarbitrary

  def setup
  end

  def teardown
  end

  def test_coarbitrary
    assert_raise(NotImplementedError) { coarbitrary(nil) }
  end

end

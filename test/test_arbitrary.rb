require 'test/unit'
require 'rushcheck/arbitrary'

class TC_Arbitrary < Test::Unit::TestCase

  class TC_Arbitrary_Foo
    extend RushCheck::Arbitrary
  end

  def setup
  end

  def teardown
  end

  def test_arbitrary
    assert_raise(NotImplementedError) { TC_Arbitrary_Foo.arbitrary }
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

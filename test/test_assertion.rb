require 'test/unit'
require 'rushcheck/assertion'

class TC_Assertion < Test::Unit::TestCase

  def setup 
  end

  def teardown
  end

  def test_assertion_failed_not_class
    assert_raise(RushCheck::RushCheckError) {
      RushCheck::Assertion.new(0) { |x| false }
    }
  end

  def test_assertion_failed_invalid_vars
    assert_raise(RushCheck::RushCheckError) {
      RushCheck::Assertion.new(Integer) { 
        |x, y| 
        false 
      }
    }
  end

  def test_assertion_nothing_raised_trivial
    assert_nothing_raised(RushCheck::RushCheckError) {
      RushCheck::Assertion.new { false }
    }
  end

  def test_assertion_nothing_raised
    assert_nothing_raised {
      RushCheck::Assertion.new(Integer, String) { 
        |x, y| 
        false 
      }
    }
  end

end

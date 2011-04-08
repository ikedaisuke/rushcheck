require 'test/unit'
require 'rushcheck/error'
require 'rushcheck/assertion'

class TC_Assertion < Test::Unit::TestCase

  def setup
  end

  def teardown
  end

  def test_assertion_illegal
    assert_raise(RushCheck::InternalError::RushCheckError) {
      RushCheck::Assertion.new(Integer) { |x| nil }.check
    }
  end

  def test_assertion_failed_not_class
    assert_raise(RushCheck::InternalError::RushCheckError) {
      RushCheck::Assertion.new(0) { |x| true }.check
    }
  end

  def test_assertion_failed_invalid_vars
    assert_raise(RushCheck::InternalError::RushCheckError) {
      RushCheck::Assertion.new(Integer) {
        |x, y|
        true
      }.check
    }
  end

  def test_assertion_raise_trivial
    assert_raise(RushCheck::InternalError::RushCheckError) {
      RushCheck::Assertion.new { true }.check
    }
  end

  def test_assertion_nothing_raised
    assert_nothing_raised {
      RushCheck::Assertion.new(Integer, String) {
        |x, y|
        true
      }.check
    }
  end

  def test_assertion_guard_passed
    assert_nothing_raised {
      RushCheck::Assertion.new(Integer) {
        |x|
        RushCheck::guard { true }
        true
      }.check
    }
  end

end

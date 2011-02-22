#= claim.rb
# this file provides a class Claim for random testing.

require 'rushcheck/gen'
require 'rushcheck/guard'
require 'rushcheck/property'
require 'rushcheck/result'
require 'rushcheck/testable'

module RushCheck

  # class Claim is one of main features of RushCheck.
  # You can write a testcase for random testing as follows:
  #
  # Claim.new(Integer, String) do |x, y|
  #   RushCheck::guard { precondition }
  #   body
  # end
  #
  # The notation of Claim.new is same as Assertion.new is,
  # however the semantics are different. When checking the
  # body of testcase, the returned value is ignored. In 
  # other words, the body is executed but not checked the
  # result. However, if an exception is raised while executing 
  # the body, then checking is failed. This means that the
  # above testing case can be written by Assertion.new 
  # as follows:
  #
  # # meaning of Claim.new is similar to Assertion.new
  # Assertion.new(Integer, String) do |x, y|
  #   RushCheck::guard { precondition }
  #   body
  #   true
  # end
  # 
  # Claim maybe useful for combining unit testing library,
  # because sometimes we want to execute several assertions
  # of unit testing library such as assert_equal(x, y).
  # The assertions of unit testing library does not return
  # true or false, but return nil (just only testing).
  #
  # Claim is-an Assertion so its subclass. See also Assertion.
  
  class Claim < Assertion

    include RushCheck::Testable

    def property
      _property { |args|
        @proc.call(*args)
        RushCheck::Result.new(true)
      }
    end

  end
end

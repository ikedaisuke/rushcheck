# = assertion.rb
# this file provides a class Assertion for random testing.

require 'rushcheck/gen'
require 'rushcheck/guard'
require 'rushcheck/property'
require 'rushcheck/result'
require 'rushcheck/testable'

module RushCheck

  # Assertion class is one of main features of RushCheck.
  # You can write a testcase for random testing as follows:
  # 
  # Assertion.new(Integer, String) do |x, y|
  #   RushCheck::guard { precondition }
  #   body
  # end
  #
  # The return value of the body of testcase is checked by
  # the method 'check'. 
  #
  # Note that the number of arguments in the block must be
  # equal to the number of arguments of Assertion.new.
  # However, for a curried block, we can write also
  #   Assertion.new(*cs) {|*xs| ...}
  #
  # See also class Claim, which is a subclass of Assertion
  # See also the RushCheck tutorial and several examples.
  #
  class Assertion
    
    include RushCheck::Testable

    attr_reader :proc

    def initialize(*xs, &f)
      @inputs = xs[0..(f.arity - 1)]
      @proc = f
    end

    def _property
      # :nodoc:
      # should be raise when the number of arguments are differ?
      g = RushCheck::Gen.new do |n, r|
        r2 = r
        if @inputs
        then
          @inputs.map do |c|
            r1, r2 = r2.split
            c.arbitrary.value(n, r1)
          end
        else
          []
        end
      end.bind do |args|
        test = begin
                 @proc.call(*args) # not yield here!
               rescue Exception => ex
                 case ex
                 when RushCheck::GuardException
                   RushCheck::Result.new(nil)
                 else
                   err = "Unexpected exception: #{ex.inspect}\n" + 
                     ex.backtrace.join("\n")
                   RushCheck::Result.new(false, [], [err])
                 end
               end
        # not use ensure here because ensure clause
        # does not return values
        test.property.gen.fmap do |res|
          res.arguments << args.inspect
          res
        end
      end

      RushCheck::Property.new(g)
    end
    private :_property

    def property
      _property { |args|
        if @proc.call(*args)
        then RushCheck::Result.new(true)
        else RushCheck::Result.new(false)
        end
        }
    end

  end

end

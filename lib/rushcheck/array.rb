# = array.rb
# The file provides a random generator of arrays.

require 'rushcheck/arbitrary'
require 'rushcheck/error'
require 'rushcheck/gen'
require 'rushcheck/testable'

# class RandomArray acts a random generator of arrays.
# Programmer can make a subclass of RandomArray to get
# user defined generators.
class RandomArray < Array

  extend RushCheck::Arbitrary
  include RushCheck::Coarbitrary

  # self.set_pattern must be executed before calling self.arbitrary.
  # The method defines pattern of random arrays for self.arbitrary.
  # This takes a block, where the variable should be a class which
  # is used for the first element of random array.
  #
  # For example, the following code create a class of array which
  # consists of random integers;
  #
  #     require 'rushcheck'
  #
  #     class IntegerRandomArray < RandomArray; end
  #     # for all index i, components belong to Integer
  #     IntegerRandomArray.set_pattern {|i| Integer}
  #
  #     RushCheck::Assertion.new(IntegerRandomArray) { |arr|
  #       ... # test codes here
  #     }
  #
  def self.set_pattern(&f)
    @proc = f
    nil
  end

  def self.generate_array(len)
    RushCheck::Gen.new do |n, r|
      ary = []
      r2 = r
      (0..len).each do |i|
        r1, r2 = r2.split
        ary << @proc.call(i).arbitrary.value(n, r1)
      end

      ary
    end
  end

  def self.arrange_len
    RushCheck::Gen.sized do |m|
      m = 1 - m if m <= 0
      RushCheck::Gen.choose(0, m).bind do |len|
        yield len
      end
    end
  end

  def self.arbitrary
    self.arrange_len do |len|
      if len == 0
      then RushCheck::Gen.unit([])
      else self.generate_array(len)
      end
    end
  end

  def coarbitrary(g)
    r = g.variant(0)
    each do |c|
      r = c.coarbitrary(r.variant(1))
    end
    r
  end

end

class NonEmptyRandomArray < RandomArray

  def self.arbitrary
    self.arrange_len do |len|
      self.generate_array(len + 1)
    end
  end

end

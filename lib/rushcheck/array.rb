# = array.rb
# The file provides a random generator of arrays.

require 'rushcheck/arbitrary'
require 'rushcheck/gen'
require 'rushcheck/testable'

# class RandomArray acts a random generator of arrays.
# Programmer can make a subclass of RandomArray to get
# user defined generators.
class RandomArray < Array

  extend RushCheck::Arbitrary
  include RushCheck::Coarbitrary

  # self.set_pattern must be executed before calling self.arbitrary.
  # self.set_pattern defines pattern of random arrays for self.arbitrary.
  # self.set_pattern takes a variable and a block, where the variable
  # should be a class which is used for the first element of random array.
  # On the other hand,
  # the block should define random array by inductive way; the block
  # takes two variables and the first variable is assumed as an array
  # and the second variable is the index of array.
  def self.set_pattern(base, &f)
    @@base, @@indp = base, f
    nil
  end

  def self.create_components(cs, n, r)
    case cs
    when Class
      cs.arbitrary.value(n, r)
    when Array
      cs.map {|c| self.create_components(c, n, r)}
    else
      raise RuntimeError, "Unexpected arguments #{cs.inspect}. Maybe forgotten calling set_pattern before?"
    end
  end

  # a private method for self.arbitrary
  def self.create_array(len)
    RushCheck::Gen.new do |n, r|
      ary = [self.create_components(@@base, n, r)]
      r2 = r
      (1..len).each do |i|
        r1, r2 = r2.split
        ary << self.create_components(@@indp.call(ary, i), n, r1)
      end
      
      ary
    end
  end

  # a private method for self.arbitrary
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
      else self.create_array(len)
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
      self.create_array(len + 1)
    end
  end

end

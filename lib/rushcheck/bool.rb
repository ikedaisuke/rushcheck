# This file extends the default Ruby's class TrueClass and FalseClass
# for RushCheck.

require 'rushcheck/arbitrary'
require 'rushcheck/integer'
require 'rushcheck/random'
require 'rushcheck/result'
require 'rushcheck/testable'

module RushCheck
  module RandomBool
    def arbitrary
      RushCheck::Gen.elements([true, false])
    end
    
    def random_range(gen, lo=@@min_bound, hi=@@max_bound)
      v, g = Integer.random_range(gen, 0, 1)
      [v==0, g]
    end
  end
end

class TrueClass

  extend RushCheck::Arbitrary
  extend RushCheck::HsRandom
  extend RushCheck::RandomBool

  include RushCheck::Testable
  include RushCheck::Coarbitrary

  @@min_bound = 0
  @@max_bound = 1

  def self.bound
    [@@min_bound, @@max_bound]
  end

  def coarbitrary(g)
    g.variant(0)
  end

  def property
    RushCheck::Result.new(self).result
  end

end

class FalseClass

  extend RushCheck::Arbitrary
  extend RushCheck::HsRandom
  extend RushCheck::RandomBool

  include RushCheck::Coarbitrary
  include RushCheck::Testable

  @@min_bound = 0
  @@max_bound = 1

  def self.bound
    [@@min_bound, @@max_bound]
  end

  def coarbitrary(g)
    g.variant(1)
  end
  
  def property
    RushCheck::Result.new(self).result
  end
end

class NilClass
  extend RushCheck::Arbitrary

  include RushCheck::Coarbitrary
  include RushCheck::Testable
  
  def self.arbitrary
    Gen.unit(nil)
  end

  def coarbitrary(g)
    g.variant(0)
  end

  def property
    RushCheck::Result.nothing
  end

end

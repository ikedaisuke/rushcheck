# = integer.rb
# an extension to Integer class for RushCheck
#

require 'rushcheck/arbitrary'
require 'rushcheck/gen'
require 'rushcheck/random'

# ruby's Integer class is extended to use RushCheck library.
# See also HsRandom, Arbitrary and Coarbitrary.
class Integer
  extend RushCheck::HsRandom
  extend RushCheck::Arbitrary

  include RushCheck::Coarbitrary

  @@max_bound =  2**30 - 1
  @@min_bound = -(2**30)

  # this method is needed to include HsRandom.
  def self.bound
    [@@min_bound, @@max_bound]
  end

  # this method is needed to use Arbitrary.
  def self.arbitrary
    RushCheck::Gen.sized {|n| RushCheck::Gen.choose(-n, n) }
  end

  # this method is needed to include HsRandom.
  def self.random_range(gen, lo=@@min_bound, hi=@@max_bound)
    hi, lo = lo, hi if hi < lo 
    v, g = gen.gen_next
    d = hi - lo + 1

    if d == 1
    then [lo, g]
    else [(v % d) + lo, g]
    end
  end

  # this method is needed to use Coarbitrary.
  def coarbitrary(g)
    m = (self >= 0) ? 2 * self  : (-2) * self + 1
    g.variant(m)
  end
end

class PositiveInteger < Integer

  @@max_bound = 2**30 - 1
  @@min_bound = 1

  # this method is needed to include HsRandom.
  def self.random_range(gen, lo=@@min_bound, hi=@@max_bound)
    hi, lo = lo, hi if hi < lo 
    raise RuntimeError, "PositiveInteger requires positive lower bound." if lo <= 0
    v, g = gen.gen_next
    d = hi - lo + 1

    if d == 1
    then [lo, g]
    else [(v % d) + lo, g]
    end
  end

  # this method is needed to use Arbitrary.
  def self.arbitrary
    RushCheck::Gen.sized do |n| 
      n = 1 - n if n <= 0
      RushCheck::Gen.choose(1, n) 
    end
  end

end

class NegativeInteger < Integer

  @@max_bound = -1
  @@min_bound = -(2**30)

  # this method is needed to include HsRandom.
  def self.random_range(gen, lo=@@min_bound, hi=@@max_bound)
    hi, lo = lo, hi if hi < lo 
    raise RuntimeError, "NegativeInteger requires negative upper bound." if hi >= 0
    v, g = gen.gen_next
    d = hi - lo + 1

    if d == 1
    then [lo, g]
    else [(v % d) + lo, g]
    end
  end

  # this method is needed to use Arbitrary.
  def self.arbitrary
    RushCheck::Gen.sized do |n| 
      n = (-1) - n if n >= 0
      RushCheck::Gen.choose(n, -1) 
    end
  end

end

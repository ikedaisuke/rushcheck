# = float.rb
# an extension to Float class for RushCheck

require 'rushcheck/arbitrary'
require 'rushcheck/integer'
require 'rushcheck/random'

class Float
  
  extend RushCheck::Arbitrary
  extend RushCheck::HsRandom
  
  include RushCheck::Coarbitrary

  @@min_bound = 0.0
  @@max_bound = 1.0

  def self.arbitrary
    RushCheck::Gen.new do |n, r|
      a, b, c = (1..3).map { Integer.arbitrary.value(n, r) }
      a + (b / (c.abs + 1))
    end
  end

  def self.bound
    [@@min_bound, @@max_bound]
  end

  def self.random_range(gen, lo=@@min_bound, hi=@@max_bound)
    x, g = Integer.random(gen)
    a, b = Integer.bound
    r = (lo+hi/2).to_f + ((hi - lo).to_f / (b - a) * x)

    [r, g]
  end

  def coarbitrary(g)
    h = truncate
    t = (self * (10 ** ((self - h).to_s.length - 2))).truncate
    h.coarbitrary(t.coarbitrary(g))
  end

end

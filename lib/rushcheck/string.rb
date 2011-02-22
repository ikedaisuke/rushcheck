# = string.rb
# an extension to String class for RushCheck
# this file provides two classes String and SpecialString

require 'rushcheck/arbitrary'
require 'rushcheck/gen'
require 'rushcheck/integer'
require 'rushcheck/random'

class String

  extend RushCheck::Arbitrary
  extend RushCheck::HsRandom

  include RushCheck::Coarbitrary

  @@min_range = 0
  @@max_range = 1024

  def self.arbitrary
    RushCheck::Gen.sized do |n|
      # Note the Benford's law;
      # http://mathworld.wolfram.com/BenfordsLaw.html
      # This says that (a random integer % 128).chr seems not
      # have /really randomness/.
      RushCheck::Gen.unit((0..n).map{rand(128).chr}.join)
    end
  end

  def self.bound
    [@@min_range, @@max_range]
  end

  def self.random_range(gen, lo=@@min_range, hi=@@max_range)
    len, g = Integer.random(gen, lo, hi)
    result = ''
    len.times do
      v, g = Integer.random(g, 0, 127)
      result += v.chr
    end
    
    [result. g]
  end

  def coarbitrary(g)
    r = g.variant(0)
    each_byte do |c|
      r = c.coarbitrary(r.variant(1))
    end
    r
  end

end

# class SpecialString is a subclass of String.
# SpecialString provides another generator which prefers 
# control codes and special unprinted codes than usual alphabets or numbers.
# This class maybe useful to find a counter example efficiently than
# using the standard generator of String.
class SpecialString < String

  # ASCII code (see man ascii)
  @@alphabet = (65..90).to_a + (97..122).to_a
  @@control  = (0..32).to_a + [177]
  @@number   = (48..57).to_a
  @@special  = 
    [[33,47],[58,64],[91,96],[123,126]].inject([]) do |ary, pair|
      lo, hi = pair
      ary = ary + (lo..hi).to_a 
    end

  @@frequency = { 'alphabet' => 3,
                  'control'  => 10,
                  'number'   => 2,
                  'special'  => 5 }

  def self.arbitrary
    f = @@frequency
    frq = []
    [f['alphabet'],f['control'],f['number'],f['special']].zip(
    [ @@alphabet,   @@control,   @@number,   @@special]) do 
      |weight, table|
        gen = RushCheck::Gen.oneof(table.map {|n| RushCheck::Gen.unit(n.chr)})
        frq << [weight, gen]
    end

    RushCheck::Gen.sized do |m|
      RushCheck::Gen.choose(0, m).bind do |len|
        RushCheck::Gen.new do |n, r|
          r2 = r
          (1..len).map do
            r1, r2 = r2.split
            RushCheck::Gen.frequency(frq).value(n, r1)
          end.join
        end
      end
    end
  end

end

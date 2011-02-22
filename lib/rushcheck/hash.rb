# = hash.rb
# a random generator of Hash
require 'rushcheck/arbitrary'
require 'rushcheck/gen'
require 'rushcheck/testable'

# RandomHash is a subclass of Hash which provides a random generator
# of hash. Programmer can make a subclass of RandomHash to make user
# defined random generator of Hash.
class RandomHash < Hash

  extend RushCheck::Arbitrary
  include RushCheck::Coarbitrary

  # class method set_pattern takes a hash object of
  # random pattern. For example, the following pattern
  #   pat = { 'key1' => Integer, 'key2' => String }
  # means that an arbitrary hash is randomly generated
  # which has two keys (say 'key1' and 'key2') and
  # has indicated random object as its values.
  def self.set_pattern(pat)
    @@pat = pat
    self
  end
  
  def self.arbitrary
    RushCheck::Gen.new do |n, r|
      h = {}
      r2 = r
      @@pat.keys.each do |k|
        r1, r2 = r2.split
        h[k] = @@pat[k].arbitrary.value(n, r1)
      end
      h
    end
  end

  def coarbitrary(g)
    r = g.variant(0)
    values.each do |c|
      r = c.coarbitrary(r.variant(1))
    end
    r
  end

end

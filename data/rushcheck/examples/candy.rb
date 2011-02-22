# candy.rb
# an example to write a random generator

require 'rushcheck'

class Candy

  extend RushCheck::Arbitrary

  def initialize(name, price)
    raise unless price >= 0
    @name, @price = name, price
  end

  def self.arbitrary
    RushCheck::Gen.create(String, Integer) do |name, price|
      RushCheck::guard { price >= 0 }
      new(name, price)
    end
  end

end

class ExpensiveCandy < Candy

  def initialize(name, price)
    raise unless price >= 100000
    @name, @price = name, price
  end

  def self.arbitrary
    lo = 100000
    g = RushCheck::Gen.sized { |n| Gen.choose(lo, n + lo)}
    xs = [String.arbitrary, g]
    RushCheck::Gen.create_by_gen(xs) do |name, price|
      RushCheck::guard { price >= 100000 }
      new(name, price)
    end
  end

end

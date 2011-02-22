# roguetile.rb
# an example of bug patterns
# appeared in "Bug patterns: an introduction - diagnosing and
# correcting recurring bug type in your Java programs", written by
# Eric Allen, 2001. 
# http://www-128.ibm.com/developerworks/library/j-diag1.html

# Tree is an abstract class
class Tree
  def add
    raise(NotImplementedError, "override!")
  end

  def multiply
    raise(NotImplementedError, "override!")
  end
end

class Leaf < Tree

  attr_reader :value
  def initialize(v)
    @value = v
  end

  def add
    @value.to_i
  end

  def multiply
    @value.to_i
  end

end

class Branch < Tree

  attr_reader :value, :left, :right
  def initialize(v, l, r)
    @value, @left, @right = v, l, r
  end

  def add
    @value.to_i + @left.add + @right.add
  end

  def multiply
    # Here, there is a bug in multiply because the auther forgot to
    # change after copying the add method. This bug is called Rogue-Tile
    # pattern in the article.

    @value.to_i * @left.multiply + @right.multiply # bug!
  end    

  # To not write a bug such as above, the author of the article
  # recommends to use Command-Pattern. See also the article.
  # Because the aim of this example is to find a bug, I leave
  # a wrong style implementation.
end

# ok, then let's test them and find a bug.

require 'rushcheck'

class Tree
  extend RushCheck::Arbitrary
  include RushCheck::Coarbitrary

  def self.arbitrary
    RushCheck::Gen.frequency([[3, Leaf.arbitrary], [1, Branch.arbitrary]])
  end

  # In this example, coarbitrary isn't needed, however,
  # I write them to see how to write coarbitrary.
  def coarbitrary
    raise(NotImplementedError, "override!")
  end
end

class Leaf < Tree
  extend RushCheck::Arbitrary
  include RushCheck::Coarbitrary
  
  def self.arbitrary
    Integer.arbitrary.bind {|x| RushCheck::Gen.unit(new(x)) }
  end

  def coarbitrary(g)
    @value.coarbitrary(g)
  end
end

class Branch < Tree
  extend RushCheck::Arbitrary
  include RushCheck::Coarbitrary

  def self.arbitrary
    RushCheck::Gen.new do |n, g|
      g2 = g
      v, l, r = [Integer.arbitrary, Tree.arbitrary, Tree.arbitrary].map do |x|
        g1, g2 = g2.split
        x.value(n, g1)
      end
      new(v, l, r)
    end
  end

  def coarbitrary(g)
    @value.coarbitrary(@left.coarbitrary(@right.coarbitrary(g)))
  end
end

def prop_leaf_add
  RushCheck::Assertion.new(Leaf) {|x| x.add == x.value }.check
end

def prop_leaf_multiply
  RushCheck::Assertion.new(Leaf) {|x| x.multiply == x.value }.check
end

def prop_branch_add
  RushCheck::Assertion.new(Branch) do |t|
    t.add == t.value + t.left.add + t.right.add
  end.check
end

# a bad example
def prop_branch_multiply
  # If the tester write a wrong test case by copying the code snippet?
  # Then we will meet the same problem! Even this test is passed, but
  # it is wrong.
  RushCheck::Assertion.new(Branch) do |t|
    t.add == t.value * t.left.add + t.right.add # Oops, a bug in testcase.
  end.check
end

# But, we can test another /primitive/ properties about
# branch_multiply.
def prop_branch_multiply_zero
  RushCheck::Assertion.new(Leaf) do |x|
    Branch.new(0, x, x).multiply == 0
  end.check
end

def prop_branch_multiply_power
  RushCheck::Assertion.new(Leaf) do |x|
    Branch.new(1, x, x).multiply == x.value * x.value
  end.check
end
# Yay, then we can find a bug in Branch#multiply.
# In this example, we gain a practical experience that
# don't test by copying the definition, but consider /primitive/
# properties!

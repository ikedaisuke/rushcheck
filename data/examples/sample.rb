# a simple example

require 'rushcheck'

# assert_sort_one should be true
def assert_sort_one
  RushCheck::Assertion.new(Integer) { |x|
    [x].sort == [x]
  }.check
end

# however, assert_sort_two is not true generally,
# and RushCheck finds a counter example.
def assert_sort_two
  RushCheck::Assertion.new(Integer, Integer) { |x, y|
    ary = [x, y]
    ary.sort == ary
  }.check
end

# if given array is already sorted, then the
# assertion turns true.
def assert_sort_two_sorted
  RushCheck::Assertion.new(Integer, Integer) { |x, y|
    RushCheck::guard {x <= y}
    ary = [x, y]
    ary.sort == ary
  }.check
end

# watch statistics
def assert_sort_two_sorted_trivial
  RushCheck::Assertion.new(Integer, Integer) { |x, y|
    RushCheck::guard {x <= y}
    ary = [x, y]
    (ary.sort == ary).trivial{x == y}
  }.check
end

def assert_sort_two_sorted_classify
  RushCheck::Assertion.new(Integer, Integer) { |x, y|
    RushCheck::guard {x <= y}
    ary = [x, y]
    (ary.sort == ary).classify('same'){x == y}.
      classify('bit diff') { (x - y).abs == 1 }
  }.check
end

# Because Assertion.new has to take at least one variable,
# the following example should be failed.
# def assert_sort
#   RushCheck::Assertion.new { [].sort == [] }.check
# end

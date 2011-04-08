require 'rushcheck'

def find_pythagoras
  RushCheck::Assertion.new(Integer,Integer,Integer) {
    |x, y, z|
    RushCheck::guard { x > 0 }
    RushCheck::guard { y > 0 }
    RushCheck::guard { z > 0 }
    (x*x + y*y) != z*z
  }.check
end

def find_p
  c = RushCheck::Config.new(1000, 10000,
                            Proc.new {|x| x / 6 + 1})
  RushCheck::Assertion.new(Integer,Integer,Integer) {
    |x, y, z|
    RushCheck::guard { x > 0 }
    RushCheck::guard { y > 0 }
    RushCheck::guard { z > 0 }
    # p [x, y, z]
    (x*x + y*y) != z*z
  }.check(c)
end

# proc.rb
# a sample of RushCheck

require 'rushcheck'

class Proc
  # application
  def **(other)
    Proc.new do |*args|
      res = other.call(*args)
      call(*res)
    end
  end
end

class MyRandomProc < RandomProc; end

def associativity_integer
  MyRandomProc.set_pattern([Integer], [Integer])
  RushCheck::Assertion.new(MyRandomProc, MyRandomProc, MyRandomProc, Integer) do
    |a, b, c, x|
    (a ** (b ** c)).call(x) == ((a ** b) ** c).call(x)
  end.check
end

# this test takes much time than associativity_integer
def associativity_string
  MyRandomProc.set_pattern([String], [String])
  RushCheck::Assertion.new(MyRandomProc, MyRandomProc, MyRandomProc, String) do
    |a, b, c, x|
    (a ** (b ** c)).call(x) == ((a ** b) ** c).call(x)
  end.check
end

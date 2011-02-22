# This example is quoted from the RSpec tutorial and also
# test/spec.
# check also 
#   http://rspec.rubyforge.org/tutorials/index.html
#   http://blade.nagaokaut.ac.jp/cgi-bin/scat.rb/ruby/ruby-talk/217242
#
# To execute this example, you have to follow
# 1. install rspec
#    % sudo gem install rspec
# 2. then, execute the 'spec' command
#    % spec stack_spec.rb -f s
#
# On my PowerBook PC, this example takes about 50 seconds.

begin
  require 'rubygems'
  require_gem 'rushcheck'
rescue LoadError
  require 'rushcheck'
end

def for_all(*cs, &f)
  RushCheck::Claim.new(*cs, &f).check.should_equal true
end

require 'stack'

context "An empty stack" do

  specify "should not be empty after 'push'" do
    for_all(Integer) do |item|
      stack = Stack.new
      stack.push item
      stack.should_not_be_empty
    end
  end

end

# setup for general stack
class NotEmptyAndFullStack < Stack
  extend RushCheck::Arbitrary

  def self.arbitrary
    stack = self.new
    RushCheck::Gen.choose(1, SIZE-2).bind do |size|
      RushCheck::Gen.vector(String, size).fmap do |ary|
        ary.each { |i| stack.push i }
        stack
      end
    end
  end
end

context "A stack (in general)" do

  setup do
    puts "  This test consumes time. Please wait few seconds."
  end

  specify "should add the top when sent 'push'" do
    for_all(NotEmptyAndFullStack, String) do |stack, item|
      stack.push item
      stack.peek.should_equal item
    end
  end

  specify "should NOT remove the top item when sent 'peek'" do
    for_all(NotEmptyAndFullStack, Integer) do |stack, item| 
      stack.push item
      stack.peek.should_equal item
      stack.peek.should_equal item
    end
  end

 specify "should return the top item when sent 'pop'" do
   for_all(NotEmptyAndFullStack, Integer) do |stack, item| 
     stack.push item
     stack.pop.should_equal item
   end
 end

  specify "should remove the top item when sent 'pop'" do
    for_all(NotEmptyAndFullStack, Integer, Integer) do |stack, dummy, item| 
      stack.push item
      stack.push dummy
      stack.pop
      stack.pop.should_equal item
    end
  end

end

context "An empty stack" do

  specify "should be empty" do
    Stack.new.should_be_empty
  end

  specify "should no longer be empty" do
    for_all(Integer) do |item|
      stack = Stack.new
      stack.push item
      stack.should_not_be_empty
    end
  end

  specify "should complain when sent 'peek'" do
    lambda { Stack.new.peek }.should_raise StackUnderflowError
  end

  specify "should complain when sent 'pop'" do
    lambda { Stack.new.pop }.should_raise StackUnderflowError
  end
end

context "An almost empty stack (with one item)" do
  specify "should not be empty" do
    for_all(Integer) do |item|
      stack = Stack.new
      stack.push item
      stack.should_not_be_empty
    end
  end
  
  specify "should remain not empty after 'peek'" do
    for_all(Integer) do |item|
      stack = Stack.new
      stack.push item
      stack.peek
      stack.should_not_be_empty
    end
  end
  
  specify "should become empty after 'pop'" do
    for_all(Integer) do |item|
      stack = Stack.new
      stack.push item
      stack.pop
      stack.should_be_empty
    end
  end
  
end

# setup for almost full stack
class AlmostFullStack < Stack
  extend RushCheck::Arbitrary

  def self.arbitrary
    stack = self.new
    RushCheck::Gen.vector(String, SIZE-1).fmap do |ary|
      ary.each { |i| stack.push i }
      stack
    end
  end
end

context "An almost full stack (with one item less than capacity)" do

  setup do
     puts "  This test consumes time. Please wait few seconds."
  end

  specify "should not be full" do
    for_all(AlmostFullStack) do |stack|
      stack.should_not_be_full
    end
  end
  
  specify "should become full when sent 'push'" do
    for_all(AlmostFullStack, Integer) do |stack, item|
      stack.push item
      stack.should_be_full
    end
  end
end

# setup for full stack
class FullStack < Stack
  extend RushCheck::Arbitrary

  def self.arbitrary
    stack = self.new
    RushCheck::Gen.vector(String, SIZE).fmap do |ary|
      ary.each { |i| stack.push i }
      stack
    end
  end
end

context "A full stack" do
  
   setup do
      puts "  This test consumes time. Please wait few seconds."
   end

  specify "should be full" do
    for_all(FullStack) do |stack|
      stack.should_be_full
    end
  end
  
  specify "should remain full after 'peek'" do
    for_all(FullStack) do |stack|
      stack.peek
      stack.should_be_full
    end
  end
  
  specify "should no longer be full after 'pop'" do
    for_all(FullStack) do |stack|
      stack.pop
      stack.should_not_be_full
    end
  end

  specify "should complain on 'push'" do
    for_all(FullStack, Integer) do |stack, item|
      lambda { stack.push item }.should_raise StackOverflowError
    end
  end
end

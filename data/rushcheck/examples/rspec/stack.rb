# This example is quoted from the RSpec tutorial.
# check also http://rspec.rubyforge.org/tutorials/index.html

class StackUnderflowError < RuntimeError; end
class StackOverflowError  < RuntimeError; end

class Stack

  SIZE = 5

  def initialize
    @items = []
  end
  
  def empty?
    @items.empty?
  end

  def length
    @items.length
  end

  def full?
    @items.length == SIZE
  end

  def push(item)
    raise StackOverflowError  if full?
    @items.push item
  end

  def pop
    raise StackUnderflowError if empty?
    @items.pop
  end

  def peek
    raise StackUnderflowError if empty?
    @items.last
  end

end

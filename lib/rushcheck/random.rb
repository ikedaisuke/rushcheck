# = random.rb - A library for psuedo-random number from Haskell
#
# This library deals with the common task of 
# psuedo-random number generation from Haskell98. The library 
# makes it possible to generate repeatable results, by starting
# with a specified initial random number generator; or to get
# different results on each run by using the system-initialised
# generator, or by supplying a seed from some other source.
#
# This file provides two module RandomGen, HsRandom, two classes
# StdGen and TheStdGen.

module RushCheck

  # The module RandomGen is an abstract module. This is included
  # to add instance methods. The author considers that few developers 
  # need to read this implementation. See StdGen as an example.
  # Check also Haskell's System.Random library.
  module RandomGen
    
    # gen_next should be overrided as an instance method.
    # It is assumed that gen_next returns an array with length 2.
    # Here, call 'Foo' the class which includes RandomGen.
    # The first components of the result should be an integer, and the
    # last components should be an object which belongs to the class
    # Foo. 
    def gen_next
      raise_not_implemented_error
    end

    # split should be overrided as an instance method.
    # It is assumed that split returns an array with length 2.
    # Here, call 'Foo' the class which includes RandomGen.
    # Then the components of the result are objects which belongs to the
    # class Foo.
    def split
      raise_not_implemented_error
    end

    # gen_range should be overrided as an instance method.
    # It is assumed that split returns an array with length 2.
    # Here, call 'Foo' the class which includes RandomGen.
    # Then the components of the result are integers where
    # the first components should be the lowest bound of
    # the first components of gen_next. Another should be
    # the highest bound of the first components of gen_next.
    def gen_range
      raise_not_implemented_error
    end

    private 
    def raise_not_implemented_error
      raise(NotImplementedError, "This method should be overrided.")
    end

  end

  # StdGen is a class (and the unique class) which includes RandomGen.
  # This class provides a functional random number generator.
  class StdGen 

    include RushCheck::RandomGen

    @@min_bound = -(2**30)
    @@max_bound = 2**30 - 1

    # left and right are two seeds of random number generator.
    attr_reader :left, :right
    def initialize(left=nil, right=nil)
      @left, @right = [left, right].map do |x| 
        if x.nil?
        then random
        else in_range(x) 
        end
      end
    end

    # gen_next returns an array with length 2. The first component of
    # result is a random integer. The last component is a new StdGen
    # object as a new random number generator. See also RandomGen.
    def gen_next
      s, t = [@left, @right].map {|x| random(x) }
      z = ((s - t) % (@@max_bound - @@min_bound)) + @@min_bound

      [z, RushCheck::StdGen.new(s, t)]
    end

    # split returns an array with length 2. The components are
    # two new StdGen objects as two new random number generators.
    def split
      g = gen_next[1]
      s, t = g.left, g.right

      [RushCheck::StdGen.new(s + 1, t), RushCheck::StdGen.new(s, t + 1)]
    end

    # gen_range returns an array with length 2 which represents
    # a bound of generated random numbers.
    def gen_range
      [@@min_bound, @@max_bound]
    end

    def to_s
      @left.to_s + ' ' + @right.to_s
    end

    private
    def random(s=nil)
      if s.nil? then srand else srand s end
      rand(@@max_bound - @@min_bound) + @@min_bound
    end

    def in_range(n)
      (n % (@@max_bound - @@min_bound)) + @@min_bound
    end

  end


  require 'singleton'

  # TheStdGen is a singleton class to get the unique random number
  # generator using StdGen. TheStdGen includes ruby's Singleton module.
  class TheStdGen < StdGen

    include Singleton
    include RushCheck::RandomGen  

    def initialize
      @gen = RushCheck::StdGen.new
    end

    def gen_next
      @gen, result = @gen.split
      
      result.gen_next
    end

    def split
      result = @gen.split
      @gen = @gen.gen_next[1]

      result
    end

    def to_s
      @gen.to_s
    end

    def gen_range
      @gen.gen_range
    end

  end


  # HsRandom module provides several random number function with the
  # functional random generator. This module is implemented Haskell\'s
  # System.Random library. This module assumes that the class which
  # includes HsRandom should have an instance method random_range to
  # generate a random number and a new random number generator.
  # It assumes also that the class which includes HsRandom should have
  # a class method bound to give a bound of random numbers.
  module HsRandom

    # random requires the functional random number generater (StdGen
    # object) and optionally requires the bound of random numbers.
    # It returns an array with length 2, where the first component
    # should be a new random number, and the last should be a new random
    # number generator.
    def random(gen, lo=nil, hi=nil)
      lo = bound[0] if lo.nil?
      hi = bound[1] if hi.nil?
      random_range(gen, hi, lo) if lo > hi

      random_range(gen, lo, hi)
    end

    # random_array requires the functional random number generater
    # (StdGen object). Optionally, it requires the length of results and
    # the bound of random numbers. This method returns different result
    # whether the second argument length is nil or not. When the second
    # argument is nil, then random_array returns a Proc which takes one
    # variable as an integer and return a new random value, such as an
    # infinite sequence of random numbers. Otherwise, the second
    # argument of random_array is not nil but some integer, then
    # random_array returns an array of random numbers with the length.
    def random_array(gen, len=nil, lo=nil, hi=nil)
      g = gen
      if len.nil?
      then
        Proc.new do |i|
          (i+1).times do
            v, g = random(g, lo, hi)
          end
          v
        end
      else
        (1..len).map do
          v, g = random(g, lo, hi)
          v
        end
      end
    end

    # random_std requires optionally the bound of random numbers.
    # It returns an array with length 2, where the first component
    # should be a new random number, and the last should be a new random
    # number generator. This method uses the unique standard random
    # generator TheStdGen.
    def random_std(lo=nil, hi=nil)
      random(RushCheck::TheStdGen.instance, lo, hi)
    end

    def random_range(gen, lo=nil, hi=nil)
      raise(NotImplementedError, "This method should be overrided.")
    end
    private :random_range

  end

end

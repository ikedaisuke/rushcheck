# = Gen.rb
# This file is implemented the type class Gen in Haskell's QuickCheck.
# Almost all implementations are similar to Haskell's one.
# Therefore check also the Haskell implementation.

require 'rushcheck/gen'
require 'rushcheck/integer'

module RushCheck

  # Gen provides functions for generating test instances.
  class Gen

    @@max_create = 10000

    # choose is one of primitive generators to create a random Gen object. 
    # choose returns a Gen object which generates a random value in the
    # bound. It may useful to implement arbitrary method into your class.
    def self.choose(lo=nil, hi=nil)
      rand.fmap do |x| 
        lo.class.random(x, lo, hi).first
      end
    end

    # create_gen is one of primitive generators to create a random Gen object.
    # create_gen takes an array of Gen objects, and any block to generate object.
    # Then create_gen returns a Gen object. It may useful to implement
    # arbitrary method into your class.
    def self.create_by_gen(xs, &f)
      self.new do |n, r|
        r2 = r

        try = 0
        begin
          if try > @@max_create 
            raise(RuntimeError, "Failed to guards too many in the assertion.") 
          end
          args = xs.map do |gen|
            r1, r2 = r2.split
            gen.value(n, r1)
          end
          f.call(*args)
        rescue Exception => ex
          case ex
          when RushCheck::GuardException
            try += 1
            retry
          else
            raise(ex, ex.to_s)
          end
        end
      end
    end

    # create is one of primitive generators to create a random Gen object.
    # create takes at least a class, and any block to generate object.
    # Then create returns a Gen object. It may useful to implement
    # arbitrary method into your class.
    def self.create(*cs, &f)
      self.create_by_gen(cs.map {|c| c.arbitrary}, &f) 
    end

    # elements is one of primitive generators to create a random Gen
    # object. elements requires an array and returns a Gen object which
    # generates an object in the array randomly. It may useful to
    # implement arbitrary method into your class. 
    def self.elements(xs)
      raise(RuntimeError, "given argument is empty") if xs.empty?

      choose(0, xs.length - 1).fmap {|i| xs[i] }
    end

    # frequency is one of primitive generators to create a random Gen
    # object. frequency requires an array of pairs and returns a Gen
    # object. The first component of pair should be a positive Integer
    # and the second one should be a Gen object. The integer acts as a
    # weight for choosing random Gen object in the array. For example,
    # frequency([[1, Gen.rand], [2, Integer.arbitrary]]) returns the
    # random generator Gen.rand in 33%, while another random generator
    # of Integer (Integer.arbitrary) in 67%.
    def self.frequency(xs)
      tot = xs.inject(0) {|r, pair| r + pair.first}
      raise(RuntimeError, "Illegal frequency:#{xs.inspect}") if tot == 0
      choose(0, tot - 1).bind do |n|
        m = n
        xs.each do |pair|
          if m <= pair[0]
          then break pair[1]
          else m -= pair[0]
          end
        end
      end 
    end

    # lift_array is one of primitive generators to create a randam Gen
    # object. lift_array takes an array and a block which has a
    # variable. The block should return a Gen object. lift_array returns
    # a Gen object which generates an array of the result of given block
    # for applying each member of given array. 
    def self.lift_array(xs)
      self.new do |n, r|
        r2 = r
        xs.map do |c|
          r1, r2 = r2.split
          yield.value(n, r1)
        end
      end
    end

    # oneof is /one of/ primitive generators to create a random Gen object.
    # oneof requires an array of Gen objects, and returns a Gen object
    # which choose a Gen object in the array randomly.
    # It may useful to implement arbitrary method into your class.
    def self.oneof(gens)
      elements(gens).bind {|x| x}
    end

    # promote is the function to create a Gen object which generates a
    # procedure (Proc). promote requires a block which takes one
    # variable and the block should be return a Gen object.
    # promote returns a Gen object which generate a new procedure
    # with the given block.
    # It may useful to implement coarbitrary method into your class.
    def self.promote
      new {|n, r| Proc.new {|a| yield(a).value(n, r) } }
    end

    # rand returns a Gen object which generates a random number
    # generator. 
    def self.rand
      new {|n, r| r}
    end

    # sized is a combinator which the programmer can use to access the
    # size bound. It requires a block which takes a variable as an
    # integer for size. The block should be a function which changes the
    # size of random instances.
    def self.sized
      new {|n, r| yield(n).value(n, r) }
    end

    # unit is a monadic function which equals the return function in
    # the Haskell's monad. It requires one variable and returns a Gen
    # object which generates the given object.
    def self.unit(x)
      new {|n, r| x}
    end

    # vector is one of primitive generators to create a Gen object.
    # vector takes two variables, while the first one should be class,
    # and the second one should be length. vector returns a Gen object
    # which generates an array whose components belongs the given class
    # and given length.
    def self.vector(c, len)
      new do |n, r|
        r2 = r
        (1..len).map do 
          r1, r2 = r2.split
          c.arbitrary.value(n, r1) 
        end
      end
    end

    # to initialize Gen object, it requires a block which takes two
    # variables. The first argument of block is assumed as an integer,
    # and the second one is assumed as a random generator of RandomGen.
    def initialize(&f)
      @proc = f    
    end

    # bind is a monadic function such as Haskel's (>>=).
    # bind takes a block which has a variable where is the return value
    # of the Gen object. The block should return a Gen object.
    def bind
      self.class.new do |n, r| 
        r1, r2 = r.split
        yield(value(n, r1)).value(n, r2)
      end
    end

    # value is a method to get the value of the internal procedure.
    # value takes two variables where the first argument is assumed as
    # an integer and the second one is assumed as a random generator of
    # RandomGen. 
    def value(n, g)
      @proc.call(n, g)
    end

    # fmap is a categorical function as same in Haskell.
    # fmap requires a block which takes one variable.
    def fmap
      bind {|x| self.class.unit(yield(x)) }
    end

    # forall is a function to create a Gen object.
    # forall requires a block which takes any variables
    # and returns a Property object. Then forall returns
    # a generator of the property.
    def forall
      bind do |*a|
        yield(*a).property.gen.bind do |res|
          res.arguments.push(a.to_s)
          self.class.unit(res)
        end
      end
    end

    # generate returns the random instance. generates takes two
    # variables, where the first one should be an integer and the second
    # should be the random number generator such as StdGen.
    def generate(n, rnd)
      s, r = Integer.random(rnd, 0, n)
      value(s, r)
    end

    # resize returns another Gen object which resized by the given
    # paramater. resize takes one variable in Integer.
    def resize(n)
      self.class.new {|x, r| value(n, r) }
    end

    # variant constructs a generator which transforms the random number
    # seed. variant takes one variable which should be an
    # Integer. variant is needed to generate random functions.
    def variant(v)
      self.class.new do |n, r| 
        gen = r
        v.times { gen, dummy = gen.split }
        value(n, gen)
      end
    end

  end

end


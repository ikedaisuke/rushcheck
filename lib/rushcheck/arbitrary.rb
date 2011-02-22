# = arbitrary.rb
#
# This file includes two modules Arbitrary and Coarbitrary.
# Arbitrary provides an instance method arbitrary.
# Coarbitrary provides a class method coarbitrary.
# However they are abstract methods and should be overrided
# in each class after extend/include them.
#
# class YourClass
#   extend  RushCheck::Arbitrary
#   include RushCheck::Coarbitrary
#
#   def self.arbitrary
#   # must be overrided   
#   end
#
#   def coarbitrary
#   # must be overrided also
#   end
# end
#

module RushCheck

  module Arbitrary

    # It is assumed that the arbitrary method must be overrided
    # and return a Gen object with the same class of self. 
    # See also rushcheck/gen.rb.
    def arbitrary
      raise(NotImplementedError, "This method should be overrided.")
    end

  end

  module Coarbitrary

    # It is assumed that the coarbitrary method must be overrided
    # and return a Gen object. See also rushcheck/gen.rb.
    def coarbitrary(g)
      raise(NotImplementedError, "This method should be overrided.")
    end

  end

end

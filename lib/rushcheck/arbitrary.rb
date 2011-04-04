# = arbitrary.rb
#
# This file consists of two modules _Arbitrary_ and _Coarbitrary_.
# They are abstract modules.
# _Arbitrary_ provides an instance method _arbitrary_.
# On the other hand, _Coarbitrary_ provides a class method
# _coarbitrary_. They are abstract methods and should be overrided in
# each class after *extend/include* them. See the following example.
#
# == Example how to use
#
# You have to define the overrided methods both _arbitrary_ and
# _coarbitrary_ at +YourClass+ to generate random test instances.
#
# See also the manual how to build a random generator.
#
#   require 'rushcheck/arbitrary'
#
#   class YourClass
#     extend  RushCheck::Arbitrary
#     include RushCheck::Coarbitrary
#
#     def self.arbitrary
#       # must be overrided
#     end
#
#     def coarbitrary
#       # must be overrided, too
#     end
#   end
#

module RushCheck

  def _message_should_be_overrided # :nodoc:
    /^.+?:\d+(?::in (`.*'))?/ =~ caller.first
    [ "The method", $1, "should be overrided at",
      self.class.to_s ].join(" ") + "."
  end

  private :_message_should_be_overrided

  module Arbitrary

    include RushCheck

    # A generator for values of the object.
    # It is an instance-specific method. The method must be
    # overrided as a instance method, and return a Gen object
    # with the same class of self.
    def arbitrary
      raise(NotImplementedError, _message_should_be_overrided)
    end

  end

  module Coarbitrary

    include RushCheck

    # Used to generate a function of self to other.
    # The method must be overrided as a class method which
    # takes one argument of Gen and return a Gen object.
    # You can often use Gen.variant to implement.
    def coarbitrary(g)
      raise(NotImplementedError, _message_should_be_overrided)
    end

  end

end

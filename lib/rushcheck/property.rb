# = property.rb
# This file defines properties of testcase
# class Property is used for RushCheck internally
require 'rushcheck/gen'
require 'rushcheck/result'
require 'rushcheck/testable'

module RushCheck

  class Property

    include RushCheck::Testable

    attr_reader :gen
    def initialize(obj=nil, stamp=[], arguments=[])
      case obj
      when nil, true, false
        result = RushCheck::Result.new(obj, stamp, arguments)
        @gen   = RushCheck::Gen.unit(result)
      when Gen
        @gen = obj
      else
        raise(RuntimeError, "illegal arguments")
      end
    end

    def property
      self
    end

  end

end

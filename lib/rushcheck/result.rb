# = result.rb
# This file defines results of testcase
# class Result is used for RushCheck internally

require 'rushcheck/property'
require 'rushcheck/testable'

module RushCheck

  class Result

    include RushCheck::Testable

    def self.nothing
      RushCheck::Result.new(false)
    end

    attr_reader :ok, :stamp, :arguments
    def initialize(ok=nil, stamp=[], arguments=[])
      @ok, @stamp, @arguments = ok, stamp, arguments
    end

    def result
      RushCheck::Property.new(@ok, @stamp, @arguments)
    end
    alias property :result

  end

end

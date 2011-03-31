# = error.rb
# define the original exception for RushCheck

module RushCheck

  module InternalError

    class RushCheckError < StandardError; end

  end

end

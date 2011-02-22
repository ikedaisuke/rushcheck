# = testoptions.rb
# define class TestOptions for a batch process for RushCheck

module RushCheck

  class TestOptions

    attr_reader :ntests, :length
    def initialize(ntests=100, length=1, debug=false)
      @ntests, @length, @debug = ntests, length, debug
    end

    def debug?
      @debug
    end

  end

end


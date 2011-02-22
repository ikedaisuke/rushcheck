# = testresult.rb
# 

module RushCheck

  class TestResult
    attr_reader :message, :ntests, :stamps
    def initialize(message, ntests, stamps)
      @message, @ntest, @stamps = message, ntests, stamps
    end
  end

  class TestOk < TestResult; end

  class TestExausted < TestResult; end

  class TestFailed
    attr_reader :results, :ntests
    def initialize(results, ntests)
      @results, @ntests = results, ntests
    end
  end

end


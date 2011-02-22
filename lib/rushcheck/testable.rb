# = testable.rb
# this provides an abstract interface of Testable
# See also QuickCheck in Haskell

require 'rushcheck/config'
require 'rushcheck/random'
require 'rushcheck/testresult'

module RushCheck

  module Testable 

    def property
      raise(NotImplementedError, "This method should be overrided.")    
    end

    def check(config=RushCheck::Config.new)
      config.tests(property.gen, RushCheck::TheStdGen.instance)
    end
    alias quick_check :check
    alias quickcheck  :check

    def classify(name)
      yield ? label(name) : property
    end

    def imply
      yield ? property : RushCheck::Result.nothing.result
    end

    def label(s)
      RushCheck::Property.new(property.gen.fmap {|res| res.stamp << s.to_s; res })
    end
    alias collect :label

    def run(opts)
      RushCheck::Config.batch(opts.ntests, opts.debug?).
        tests_batch(property, RushCheck::StdGen.new(0))
    end

    def rjustify(n, s)
      ' ' * [0, n - s.length].max + s
    end
    private :rjustify

    def try_test(ts)
      ntests = 1
      count  = 0
      others = []
      if ! ts.empty?
        ts.each do |t|
          begin
            r = t.call(opts)
            case r
            when RushCheck::TestOk
              puts "."
              ntests += 1
              count  += r.ntests
            when RushCheck::TestExausted
              puts "?"
              ntests += 1
              count += r.ntests
            when RushCheck::TestFailed
              puts "#"
              ntests += 1
              others << [r.results, ntests, r.ntests]
              count += r.ntests
            else
              raise(RuntimeError, "RushCheck: illegal result")
            end
          rescue
            puts "*"
            ntests += 1
            next
          end
        end
      end
      print(rjustify([0, 35-ntests].max, " (") + count.to_s + ")\n")
      others
    end
    private :try_test

    def final_run(f, n, no, name)
      puts
      puts "    ** test " + n.to_s + " of " + name + " failed with the binding(s)"
      f.each do |v|
        puts "    **  " + v.to_s
      end
      puts
    end
    private :final_run

    def run_tests(name, opts, tests)
      print(rjustify(25, name) + " : ")
      f = try_test(tests)
      f.each { |f, n, no| final_run(f, n, no, name) }
      nil
    end

    def silent_check
      check(RushCheck::Config.silent)
    end

    def test
      check(RushCheck::Config.verbose)
    end
    alias verbose_check :test

    def testcase
      Proc.new {|opts| run(opts)}
    end

    def trivial
      classify('trivial') { yield }
    end
  end

end


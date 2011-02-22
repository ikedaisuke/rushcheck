$: << File.dirname(__FILE__) + "/../lib"
require 'rushcheck'

def for_all(*cs, &f)
  RushCheck::Claim.new(*cs, &f).check.should_equal true
end

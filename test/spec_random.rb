require File.dirname(__FILE__) + '/prelude.rb'

require 'rushcheck/random'

context 'class StdGen' do

  specify 'left and right of StdGen.new should be an random integer in the range' do
    sg = RushCheck::StdGen.new
    left, right = sg.left, sg.right
    [left, right].each do |n|
      n.should_be_a_kind_of Integer
    end
  end

end

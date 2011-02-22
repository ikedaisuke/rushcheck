require File.dirname(__FILE__) + '/prelude.rb'

module RushCheck
  class Gen
    extend RushCheck::Arbitrary
    def self.arbitrary
      Integer.arbitrary.fmap {|x| self.unit(x)}
    end
  end
end

class MyRandomArray < RandomArray; end
class MyRandomProc  < RandomProc;  end
context 'type checking for a subclass of RandomArray' do

  specify 'self.arbitrary should return Gen object' do
    MyRandomArray.arbitrary.should_be_an_instance_of RushCheck::Gen
  end

  specify 'coarbitrary should return Gen object' do
    for_all(RushCheck::Gen) do |gen|
      MyRandomArray.new.coarbitrary(gen).should_be_an_instance_of RushCheck::Gen
    end
  end

end

context 'properties of self.arbitrary' do
  
  setup do
    MyRandomArray.set_pattern(Integer) {|ary, i| Integer}
    @stdgen = RushCheck::TheStdGen.instance
  end

  specify 'returned object is Gen of Array without set_pattern' do
    for_all(Integer) do |n|
      MyRandomArray.arbitrary.value(n, @stdgen).should_be_an_instance_of Array
    end
  end

  specify 'returned object is Gen of Array with set_pattern - base:Class, ind:Class' do
    MyRandomArray.set_pattern(Integer) {|ary, i| Integer}
    for_all(Integer) do |n|
      MyRandomArray.arbitrary.value(n, @stdgen).each do |x| 
        x.should_be_a_kind_of Integer
      end
    end
  end

  specify 'returned object is Gen of Array with set_pattern - base:Array, ind:Class' do
    MyRandomArray.set_pattern([Integer]) {|ary, i| Integer}
    for_all(Integer) do |n|
      ary = MyRandomArray.arbitrary.value(n, @stdgen)
      ary.should_be_a_kind_of Array
    end
  end

  specify 'returned object is Gen of Array with set_pattern - base:Array, ind:Class' do
    MyRandomArray.set_pattern([Integer]) {|ary, i| Integer}
    for_all(Integer) do |n|
      ary = MyRandomArray.arbitrary.value(n, @stdgen)
      RushCheck::guard {! ary.empty?}
      q = ary.first 
      q.should_be_a_kind_of Array
      q.first.should_be_a_kind_of Integer
    end
  end

  specify 'returned object is Gen of Array with set_pattern - base:Class, ind:Array' do
    MyRandomArray.set_pattern(Integer) {|ary, i| [Integer]}
    for_all(Integer) do |n|
      ary = MyRandomArray.arbitrary.value(n, @stdgen)
      RushCheck::guard {! ary.empty?}
      q = ary.first 
      q.should_be_a_kind_of Integer
      ary[1..(-1)].each do |x| 
        x.should_be_a_kind_of Array
        x.first.should_be_a_kind_of Integer
      end
    end
  end

end

context 'properties of coarbitrary' do

  specify 'returned object is Gen of Integer when coarbitrary takes Gen of Integer' do
    for_all(RushCheck::Gen, Integer) do |gen, n|
      MyRandomArray.new.coarbitrary(gen).value(n, @stdgen).should_be_a_kind_of Integer
    end
  end

end


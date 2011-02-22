require File.dirname(__FILE__) + '/prelude.rb'

module RushCheck
  class Gen
    extend RushCheck::Arbitrary
    def self.arbitrary
      Integer.arbitrary.fmap {|x| self.unit x}
    end
  end
end

class MyRandomArray < NonEmptyRandomArray; end
class MyRandomProc  < RandomProc; end
context 'type checking for Gen' do

  setup do
    @stdgen = RushCheck::TheStdGen.instance
  end

  specify 'Gen.choose should be Random a => (a, a) -> Gen a' do
    for_all(Integer, Integer) do |lo, hi|
      RushCheck::Gen.choose(lo, hi).should_be_an_instance_of RushCheck::Gen
    end
  end

  specify 'Gen.elements should be [a] -> Gen a' do
    MyRandomArray.set_pattern(Integer) {|ary, i| Integer}
    for_all(MyRandomArray, Integer) do |xs, n|
      g = RushCheck::Gen.elements(xs)
      g.should_be_an_instance_of RushCheck::Gen
      g.value(n, @stdgen).should_be_a_kind_of Integer
    end
  end

  specify 'Gen.frequency should be [(Int, Gen a)] -> Gen a' do
    MyRandomArray.set_pattern([PositiveInteger, RushCheck::Gen]) do 
       |ary, i| [PositiveInteger, RushCheck::Gen] end
    for_all(MyRandomArray, Integer) do |xs, n|
      g = RushCheck::Gen.frequency(xs)
      g.should_be_an_instance_of RushCheck::Gen
      g.value(n, @stdgen).should_be_a_kind_of Integer
    end
  end

  specify 'Gen.oneof should be [Gen a] -> Gen a' do
    MyRandomArray.set_pattern(RushCheck::Gen) {|ary, i| RushCheck::Gen}
    for_all(MyRandomArray, Integer) do |xs, n|
      g = RushCheck::Gen.oneof(xs)
      g.should_be_an_instance_of RushCheck::Gen
      g.value(n, @stdgen).should_be_a_kind_of Integer
    end
  end

  specify 'Gen.promote should be (a -> Gen b) -> Gen (a -> b)' do
    MyRandomProc.set_pattern([Integer], [RushCheck::Gen])
    for_all(MyRandomProc, Integer, Integer) do |proc, n, x|
      g = RushCheck::Gen.promote(&proc)
      g.should_be_an_instance_of RushCheck::Gen
      g.value(n, @stdgen).should_be_a_kind_of Proc
      g.value(n, @stdgen).call(x).should_be_a_kind_of Integer
    end
  end

  specify 'Gen.rand should be Gen StdGen' do
    for_all(Integer) do |gen, n|
      g = RushCheck::Gen.rand
      g.should_be_an_instance_of RushCheck::Gen
      g.value(n, @stdgen).should_be_a_kind_of RushCheck::StdGen
    end
  end

  specify 'Gen.sized should be (Int -> Gen a) -> Gen a' do
    MyRandomProc.set_pattern([Integer], [RushCheck::Gen])
    for_all(MyRandomProc, Integer) do |proc, n|
      g = RushCheck::Gen.sized(&proc)
      g.should_be_an_instance_of RushCheck::Gen
      g.value(n, @stdgen).should_be_a_kind_of Integer
    end
  end

  specify 'Gen.unit should be a -> Gen a' do
    for_all(Integer, Integer) do |x, n|
      g = RushCheck::Gen.unit(x)
      g.should_be_an_instance_of RushCheck::Gen
      g.value(n, @stdgen).should_be_a_kind_of Integer
    end
  end

  specify 'Gen.vector should be Arbitrary a => Int -> Gen [a]' do
    for_all(PositiveInteger, Integer) do |len, n|
      g = RushCheck::Gen.vector(Integer, len)
      g.should_be_an_instance_of RushCheck::Gen
      ary = g.value(n, @stdgen)
      ary.should_be_a_kind_of Array
      ary.each {|i| i.should_be_a_kind_of Integer}
    end
  end

  specify 'bind should be Gen a |-> (a -> Gen b) -> Gen b' do
    MyRandomProc.set_pattern([Integer], [RushCheck::Gen])
    for_all(RushCheck::Gen, MyRandomProc, Integer) do |g, proc, n|
      h = g.bind(&proc)
      h.should_be_an_instance_of RushCheck::Gen
      h.value(n, @stdgen).should_be_a_kind_of Integer
    end
  end

  specify 'value should be Gen a |-> Integer -> StdGen -> a' do
    for_all(RushCheck::Gen, Integer) do |g, n|
      g.value(n, @stdgen).should_be_a_kind_of Integer
    end
  end

  specify 'fmap should be Gen a |-> (a -> b) -> Gen b' do
    MyRandomProc.set_pattern([Integer], [String])
    for_all(RushCheck::Gen, MyRandomProc, Integer) do |g, proc, n|
      h = g.fmap(&proc)
      h.should_be_an_instance_of RushCheck::Gen
      h.value(n, @stdgen).should_be_a_kind_of String
    end
  end

  specify 'forall should be (Show a, Testable b) => Gen a |-> (a -> b) -> Gen Result' do
    MyRandomProc.set_pattern([Integer], [TrueClass])
    for_all(RushCheck::Gen, MyRandomProc, Integer) do |g, proc, n|
      h = g.forall(&proc)
      h.should_be_a_kind_of RushCheck::Gen
      h.value(n, @stdgen).should_be_a_kind_of RushCheck::Result
    end
  end

  specify 'generate should be Gen a |-> Int -> StdGen -> a' do
    for_all(RushCheck::Gen, Integer) do |g, x|
      g.generate(x, @stdgen).should_be_a_kind_of Integer
    end
  end

  specify 'resize should be Gen a |-> Int -> Gen a' do
    for_all(RushCheck::Gen, Integer, Integer) do |g, x, n|
      h = g.resize(x)
      h.should_be_an_instance_of RushCheck::Gen
      h.value(n, @stdgen).should_be_a_kind_of Integer
    end
  end

  specify 'variant should be Gen a |-> Int -> Gen a' do
    for_all(RushCheck::Gen, Integer, Integer) do |g, x, n|
      h = g.variant(x)
      h.should_be_an_instance_of RushCheck::Gen
      h.value(n, @stdgen).should_be_a_kind_of Integer
    end
  end

end

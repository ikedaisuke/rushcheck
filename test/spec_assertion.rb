require File.dirname(__FILE__) + '/prelude.rb'

context 'properties of Assertion.new.property' do 
  specify 'no argument with empty block should be an instance of Property' do
    RushCheck::Assertion.new(){}.property.should_be_an_instance_of RushCheck::Property
  end

  specify 'some arguments with empty block should be an instance of Property' do
    RushCheck::Assertion.new(Integer){}.property.should_be_an_instance_of RushCheck::Property
    RushCheck::Assertion.new(Integer, String){}.property.should_be_an_instance_of RushCheck::Property
  end
end

context 'properties of Assertion.new() {...}.check' do 
  specify 'checking true should be true' do
    RushCheck::Assertion.new(){true}.check.should_be true
  end

  specify 'checking false should be raised' do
    RushCheck::Assertion.new(){false}.check.should_be_raise 
  end
end

context 'properties of Assertion.new(some classes) {...}.check' do 
  specify 'checking true should be true' do
    RushCheck::Assertion.new(Integer){|x| true}.check.should_be true
    RushCheck::Assertion.new(Integer, String){|x, y| true}.check.should_be true
  end

  specify 'checking false should be raised' do
    RushCheck::Assertion.new(Integer){|x| false}.check.should_be_raise
    RushCheck::Assertion.new(Integer, String){|x, y| false}.check.should_be_raise
  end
end


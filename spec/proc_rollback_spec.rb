require 'proc_rollback'

class SomeClass
  class << self
    def modify_class_var(new_value)
      @@class_var = new_value
    end
    def class_var
      @@class_var
    end

    attr_accessor :class_inst_var    
  end

  attr_accessor :inst_var
  def modify_inst_var(new_value)
    self.inst_var = new_value
  end
end

module SomeModule
  class << self
    attr_accessor :inst_var
  end
end

describe Proc do
  it 'should provide a rollback method after the call' do
    p = proc{}
    p.call_rollbackable
    p.respond_to?(:rollback).should == true
  end

  it 'should return the value of the proc' do
    p = proc{ 'foo' }
    p.call_rollbackable.should == 'foo'
  end

  it 'should rollback object instance variables' do
    @obj = SomeClass.new
    @obj.inst_var = 'foo'
    p = proc{ @obj.inst_var = 'bar' }
    p.call_rollbackable
    @obj.inst_var.should == 'bar'

    p.rollback
    @obj.inst_var.should == 'foo'
  end

  it 'should rollback class instance variables' do
    SomeClass.class_inst_var = 'foo'
    p = proc{ SomeClass.class_inst_var = 'bar' }
    p.call_rollbackable
    SomeClass.class_inst_var.should == 'bar'

    p.rollback
    SomeClass.class_inst_var.should == 'foo'
  end

  it 'should rollback module instance variables' do
    SomeModule.inst_var = 'foo'
    p = proc{ SomeModule.inst_var = 'bar' }
    p.call_rollbackable
    SomeModule.inst_var.should == 'bar'

    p.rollback
    SomeModule.inst_var.should == 'foo'
  end

  it 'should rollback method calls' do
    @obj = SomeClass.new
    @obj.inst_var = 'foo'
    p = proc{ @obj.modify_inst_var 'bar' }
    p.call_rollbackable
    @obj.inst_var.should == 'bar'

    p.rollback
    @obj.inst_var.should == 'foo'
  end
end

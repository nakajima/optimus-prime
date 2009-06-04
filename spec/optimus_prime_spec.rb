require 'spec/spec_helper'

describe OptimusPrime do
  before(:each) do
    @klass = Class.new do
      include OptimusPrime

      option :name, :age
    end
  end

  def with_args(*args)
    args.each { |a| ARGV << a }
    yield
    args.size.times { ARGV.pop }
  end

  it "should set instance variables" do
    with_args '--name', 'Pat', '--age', '21' do
      @klass.new.name.should == 'Pat'
      @klass.new.age.should == '21'
    end
  end


end

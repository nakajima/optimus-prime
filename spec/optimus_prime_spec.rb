require 'spec/spec_helper'

describe OptimusPrime do
  def with_args(*args)
    old = ARGV.dup
    ARGV.clear
    args.each { |a| ARGV << a }
    yield
    ARGV.replace(old)
  end

  it "should set instance variables" do
    with_args '--name', 'Pat', '--age', '21' do
      new_parser = Class.new {
        include OptimusPrime

        attr_reader :name, :age

        option :name, :age
      }.new

      new_parser.name.should == 'Pat'
      new_parser.age.should == '21'
    end
  end

  it "finds commands" do
    with_args 'show' do
      new_parser = Class.new {
        include OptimusPrime

        attr_reader :shown

        command :show do
          @shown = true
        end
      }.new

      new_parser.shown.should be_true
    end
  end

  it "allows 1 command argument" do
    with_args 'show', 'awesome' do
      new_parser = Class.new {
        include OptimusPrime

        attr_reader :shown

        command :show do |val|
          @shown = val
        end
      }.new

      new_parser.shown.should == 'awesome'
    end
  end

  it "allows multiple block arguments" do
    with_args 'show', 'fizz', 'buzz' do
      new_parser = Class.new {
        include OptimusPrime

        attr_reader :shown

        command :show do |a, b|
          @shown = [a, b]
        end
      }.new

      new_parser.shown.should == ['fizz', 'buzz']
    end
  end

  it "fakes rdoc" do
    with_args [] do
      new_parser = Class.new {
        include OptimusPrime

        ##
        # Shows something
        # sorta
        command :show do |a, b|
        end

        # Something else
        command :fizz do
        end
      }.new

      new_parser.help('show').should == "Shows something\nsorta"
      new_parser.help('fizz').should == 'Something else'
    end
  end
end

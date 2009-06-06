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

  it "should allow shorthand" do
    with_args '-n', 'Pat', '-a', '21' do
      new_parser = Class.new {
        include OptimusPrime

        attr_reader :name, :age

        option :name, :age
      }.new

      new_parser.name.should == 'Pat'
      new_parser.age.should == '21'
    end
  end

  it "should allow flags" do
    with_args '--verbose' do
      new_parser = Class.new {
        include OptimusPrime

        attr_reader :verbose
        alias_method :verbose?, :verbose

        flag :verbose
      }.new

      new_parser.should be_verbose
    end
  end

  context "using a block" do
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
  end

  context "using a method" do
    it "finds commands" do
      with_args 'show' do
        new_parser = Class.new {
          include OptimusPrime

          attr_reader :shown

          command :show

          def show
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

          command :show

          def show(val)
            @shown = val
          end
        }.new

        new_parser.shown.should == 'awesome'
      end
    end
  end

  it "fakes rdoc" do
    with_args do
      new_parser = Class.new {
        include OptimusPrime

        command :show do |something|
          ##
          # Shows something
          # sorta
          ##
          puts something
        end

        command :fizz do
          # Something else
        end
      }.new

      new_parser.help('show').should == "Shows something\nsorta"
      new_parser.help('fizz').should == 'Something else'
    end
  end
end

# optimus-prime

An option parsing yak shave. I blame python.

## Usage

### Options

Create a parser class:

    class OptionClass
      include OptimusPrime

      attr_reader :name, :age

      option :name, :age
    end

    options = OptionClass.new

    puts "Name: " + options.name
    puts "Age:  " + options.age

Then run your program:

    $ ruby option_class.rb --name Pat --age 22
    Name: Pat
    Age:  22

#### You can also have options that don't need a value (flags):

    class FlagsClass
      include OptimusPrime

      attr_reader :verbose

      flag :verbose
    end

    options = FlagsClass.new

    puts "Verbose: " + options.verbose ? 'Yes' : 'No'

Then run your program:

    $ ruby flags_class.rb --verbose
    Verbose: Yes

### Commands

You can specify commands using `command`, then passing a block
which will get evaluated in the context of an instance of the class,
so it will have all option values available.

    class Commands
      include OptimusPrime

      option :name, :age

      command :show do
        puts "Name: " + (@name || '(n/a)')
        puts "Age:  " + (@age  || '(n/a)')
      end
    end

    Commands.new

Then run your program:

    $ ruby commands.rb show --name Pat
    Name: Pat
    Age:  (n/a)

### Commands with arguments

    class CommandsWithArgs
      include OptimusPrime

      command :show do |name|
        puts "Name: " + name
      end
    end

    CommandsWithArgs.new

Then run your program:

    $ ruby commands_with_args.rb show Pat
    Name: Pat

## Help

Add comments below command declarations to generate help:

    command :show do |name|
      # Shows the name.
      #
      # USAGE
      #
      #   $ ruby commands.rb show Pat
      puts "Name: " + name
    end

Running your program:

    $ ruby commands.rb help show
    Shows the name.

### TODO

* Actually use `optparse`. It's good for what it does.

require File.join(File.dirname(__FILE__), *%w[.. lib optimus_prime])

class Commands
  include OptimusPrime

  attr_reader :name, :age

  option :age, :prompt => 'Enter an age:'
  option :name, :prompt => 'Enter a name:'

  command :show do
    ##
    # Shows name and age.
    #
    # Usage:
    #
    #   $ ruby commands.rb show --name Pat
    puts "Name: " + (@name || '(n/a)')
    puts "Age:  " + (@age  || '(n/a)')
  end
end

Commands.new

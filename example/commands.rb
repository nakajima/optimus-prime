require File.join(File.dirname(__FILE__), *%w[.. lib optimus_prime])

class Commands
  include OptimusPrime

  option :name, :age

  ##
  # Shows name and age.
  #
  # Usage:
  #
  #   $ ruby commands.rb show --name Pat
  command :show do
    puts "Name: " + (@name || '(n/a)')
    puts "Age:  " + (@age  || '(n/a)')
  end
end

Commands.new

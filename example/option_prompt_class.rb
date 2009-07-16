require File.join(File.dirname(__FILE__), *%w[.. lib optimus_prime])

class OptionPromptClass
  include OptimusPrime

  attr_reader :name

  option :name, :prompt => 'Enter a name:'
end

options = OptionPromptClass.new

puts "Name: " + options.name

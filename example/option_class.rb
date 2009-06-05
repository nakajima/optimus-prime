require File.join(File.dirname(__FILE__), *%w[.. lib optimus_prime])

class OptionClass
  include OptimusPrime
  
  attr_reader :name, :age
  
  option :name, :age
end

options = OptionClass.new

puts "Name: " + options.name
puts "Age:  " + options.age
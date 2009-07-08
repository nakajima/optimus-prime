require File.join(File.dirname(__FILE__), *%w[.. lib optimus_prime])

class CommandsAsMethods
  include OptimusPrime
  
  command :show
  
  def show(name)
    puts "Name: " + name
  end
end

CommandsAsMethods.new
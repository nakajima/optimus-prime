require File.join(File.dirname(__FILE__), *%w[.. lib optimus_prime])

class CommandsWithArgs
  include OptimusPrime

  command :show do |name|
    # This will show the name.
    puts "Name: " + (name || '(n/a)')
  end
end

CommandsWithArgs.new

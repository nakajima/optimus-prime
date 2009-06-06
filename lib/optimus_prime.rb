require 'rubygems'
require 'nakajima'
require 'optparse'

$LOAD_PATH.unshift File.dirname(__FILE__)

require 'optimus_prime/command'
require 'optimus_prime/optor'

module OptimusPrime
  def self.included(klass)
    klass.class_eval do
      extend ClassMethods

      command :help do |cmd|
        ##
        # Show this help message
        if cmd and self.class.commands.include?(cmd)
          puts help(cmd)
        else
          puts "Commands:"
          puts self.class.commands.map { |name| "- #{name}" }
        end
      end

      def initialize
        self.class.init(self)
      end

      def help(name)
        self.class.help(name)
      end
    end
  end

  module ClassMethods
    def __optor__
      @__optor__ ||= Optor.new(self, ARGV.dup)
    end

    def init(instance)
      __optor__.init(instance)
    end

    def help(name)
      __optor__.help(name)
    end

    def command(name, &block)
      __optor__.command(name, block)
    end

    def commands
      __optor__.commands.keys
    end

    def flag(*flags)
      flags.each { |name| __optor__.flag(name) }
    end

    def option(*names)
      names.each { |name| __optor__.option(name) }
    end
  end
end

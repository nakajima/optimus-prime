require 'rubygems'
require 'nakajima'

module OptimusPrime
  class Command
    def initialize(caller, handler)
      @caller, @handler = caller[1], handler
    end

    def help
      @help ||= begin
        lines = file.split(/\n/)
        result = []
        i = 2
        while lines[line-i] =~ /^\s*##?/
          string = lines[line-i].gsub(/^\s*#*\s?/, '')
          result << string
          i += 1
        end
        result.pop if result.last.empty?
        result.reverse.join("\n")
      end
    end

    def file
      @file ||= File.read(@caller.split(':').first)
    end

    def line
      @caller.split(':').last.to_i
    end

    def arity
      @handler.arity
    end

    def to_proc
      @handler
    end
  end

  class Optor
    def initialize(klass, args)
      @klass, @args = klass, args
    end

    def options
      @options ||= {}
    end

    def commands
      @commands ||= {}
    end

    def command(name, &block)
      commands[name.to_s] = Command.new(caller, block)
    end

    def help(name)
      @commands[name].help
    end

    def option(name)
      if i = @args.index('--' + name.to_s)
        res = @args[i+1]
        options[name.to_s] = @args.delete(res)
        @args.delete('--' + name.to_s)
      end
    end

    def init(instance)
      options.each do |key,val|
        instance.instance_variable_set("@#{key}", val)
      end

      args = @args.dup
      args.each do |val|
        args.delete(val)
        run_command(instance, val, args)
      end
    end

    private

    def run_command(instance, name, args)
      return unless command = commands[name]
      block_args = []
      command.arity.times { block_args << args.shift }
      instance.instance_exec(*block_args, &command)
    end
  end

  def self.included(klass)
    klass.class_eval do
      extend ClassMethods

      ##
      # Show this help message
      command :help do |cmd|
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
      __optor__.command(name, &block)
    end
    
    def commands
      __optor__.commands.keys
    end

    def option(*names)
      names.each { |name| __optor__.option(name) }
    end
  end
end

require 'rubygems'
require 'nakajima'

module OptimusPrime
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
      commands[name.to_s] = block
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
      block_args = []
      command = commands[name]
      command.arity.times { block_args << args.shift }
      instance.instance_exec(*block_args, &command)
    end
  end

  def self.included(klass)
    klass.class_eval do
      extend ClassMethods

      def initialize
        self.class.init(self)
      end

      def command

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

    def command(name, &block)
      __optor__.command(name, &block)
    end

    def option(*names)
      names.each { |name| __optor__.option(name) }
    end
  end
end

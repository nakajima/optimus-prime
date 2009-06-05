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
end
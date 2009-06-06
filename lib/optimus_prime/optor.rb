module OptimusPrime
  class Optor
    def initialize(klass, args)
      @klass, @args = klass, args
    end

    def options
      @options ||= begin
        list = [''] # need single options for getopts. psh.
        list += @option_list || []
        OptionParser.getopts(@args, *list)
      end
    end

    def commands
      @commands ||= {}
    end

    def command(name, handler)
      commands[name.to_s] = handler && Command.new(handler, caller)
    end

    def help(name)
      @commands[name].help
    end

    def flag(name)
      @option_list ||= []
      @option_list << name.to_s
    end

    def option(name)
      @option_list ||= []
      @option_list << name.to_s + ':'
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

    def get_command(instance, name)
      Command.new(@klass.instance_method(name).bind(instance))
    end

    def run_command(instance, name, args)
      command = commands[name] || get_command(instance, name)
      block_args = []
      command.arity.times { block_args << args.shift }
      instance.instance_exec(*block_args, &command)
    end
  end
end

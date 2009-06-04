require 'rubygems'
require 'nakajima'

module OptimusPrime
  class Optor
    def initialize(klass)
      @klass = klass
    end

    def setup(name)
      @klass.class_eval do
        define_method(name) do
          instance_variable_get("@#{name}") || begin
            args = ARGV
            if i = args.index('--' + name.to_s)
              res = args[i+1]
              instance_variable_set("@#{name}", res) ; res
            end
          end
        end
      end
    end
  end

  def self.included(klass)
    klass.class_eval do
      extend ClassMethods
    end
  end

  module ClassMethods
    def __optor__
      @__optor__ ||= Optor.new(self)
    end

    def option(*names)
      names.each { |name| __optor__.setup(name) }
    end
  end
end

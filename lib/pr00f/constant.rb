module Pr00f
  class Constant
    include RespondToChecker

    def initialize constant, &b
      @object = constant
      @instances = []

      instance_eval &b
    end

    def constants array
      undefined = array.reject { |constant| @object.constants.include? constant }

      unless undefined.empty?
        raise "#{@object} is supposed to include #{undefined}, which doesn't seem to be the case."
      end
    end

    def instance symbol = :unnamed, &b
      instance = Instance.new symbol, &b
      @instances << instance

      define_method_for_instance instance unless symbol == :unnamed
    end

    def all_instances &b
      @instances.each do |instance|
        instance.instance_eval &b
      end
    end

    private

    def define_method_for_instance instance
      self.class.send :define_method, instance.name do |&b|
        instance.instance_eval &b
      end
    end
  end
end

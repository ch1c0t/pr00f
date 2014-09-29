module Pr00f
  module Testable
    attr_reader :this 
    def initialize *args
      @methods = []
      super
    end

    def respond_to symbol
      test = Test.new do
        fail_message "#{this} is supposed to have :#{symbol} defined, which doesn't seem to be the case."
        this.respond_to? symbol
      end

      @methods << test
    end

    def constants array
      test = Test.new do
        undefined_constants = array.reject { |constant| object.constants.include? constant }

        fail_message "#{this} is supposed to include #{undefined_constants}, which doesn't seem to be the case."
        undefined_constants.empty?
      end

      @constants << test
    end

    def instance name = :unnamed, &definition
      instance = Instance.new name: name, &definition
      define_method_for_instance instance unless name == :unnamed
      @instances << instance
    end

    def all_instances &b
      @instances.each do |instance|
        instance.instance_eval &b
      end
    end

    def define_method_for_instance instance
      self.class.send :define_method, instance.name do |&b|
        instance.instance_eval &b
      end
    end
  end
end

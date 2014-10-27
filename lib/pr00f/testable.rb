module Pr00f
  module Testable
    class MethodTest < Test
      attr_reader :signatures
      def << signature
        input, output = signature
      end
    end

    attr_reader :this 
    def initialize *args
      @methods = {}; def @methods.to_a; values end
      super
    end

    def respond_to name, input = nil, with: nil
      if @methods[name]
      else
        test = MethodTest.new do
          fail_message "#{this} is supposed to have :#{name} defined, which doesn't seem to be the case."
          this.respond_to? name
        end

        if input || with
          test << [input, with]
        end

        @methods[name] = test
      end
    end

    def constants array
      @constants = Test.new do
        undefined_constants = array.reject { |constant| this.constants.include? constant }

        fail_message "#{this} is supposed to include #{undefined_constants}, which doesn't seem to be the case."
        undefined_constants.empty?
      end
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

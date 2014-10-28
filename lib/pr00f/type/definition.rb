module Pr00f
  class Type
    class Definition
      attr_reader :instances,
                  :method_tests

      def initialize type, &definition
        @instances = {}
        def @instances.add i
          self[Random.srand] = i
        end

        @method_tests = {}

        @this = type
        instance_eval &definition if block_given?
      end
      
      private

      attr_reader :this

      def instance name = nil, &b
        i = Instance.new &b
        name.nil? ? (@instances.add i) : (@instances[name] = i)
      end

      def respond_to method_name, &method_description
        test = MethodTest.new method_name, this
        test.check_signatures &method_description if test.existential_test.passed? && block_given?
        @method_tests[method_name] = test
      end
    end
  end
end

module Pr00f
  class Type
    class Definition
      attr_reader :instances,
                  :method_tests

      def initialize type, instances: nil, method_tests: nil, &definition
        @instances = instances || {}
        def @instances.add i
          self[Random.srand] = i
        end

        @method_tests = method_tests || {}

        @this = type
        instance_eval &definition if block_given?
      end

      def + other_definition
        common_instances = instances.keys & other_definition.instances.keys
        common_method_tests = method_tests.keys & other_definition.method_tests.keys
        unless common_instances.empty? || common_method_tests.empty?
          raise 'A conflict occured when trying to merge the definitions: common instances or method_tests.'
        end

        self.class.new @this, instances: (instances.merge other_definition.instances),
          method_tests: (method_tests.merge other_definition.method_tests)
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

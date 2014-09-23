module Pr00f
  class Constant
    include CommonCheckers

    attr_reader :this, :passed_tests, :failed_tests
    def initialize constant, &requirements
      @this  = constant # object under test
      @tests = []

      @instances = []

      begin
        instance_eval &requirements
      rescue BadInstanceDefinitionError
        @tests << $!.test
      end

      @tests += @instances.map(&:tests).reduce(&:+) unless @instances.empty?
      @passed_tests, @failed_tests = @tests.partition { |test| test.passed? }
    end

    def fulfill_requirements?
      @tests.all? &:passed?
    end

    def constants array
      test = Test.new do
        undefined_constants = array.reject { |constant| object.constants.include? constant }

        fail_message "#{this} is supposed to include #{undefined_constants}, which doesn't seem to be the case."
        undefined_constants.empty?
      end

      @tests << test
    end

    def instance name = :unnamed, &b
      instance = Instance.new name: name, &b
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

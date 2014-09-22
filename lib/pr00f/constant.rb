module Pr00f
  class Constant
    include CommonCheckers

    attr_reader :object, :passed_tests, :failed_tests
    def initialize constant, &requirements
      @object = constant
      @tests  = []

      @instances = []

      instance_eval &requirements

      @tests += @instances.map(&:tests).reduce(&:+) unless @instances.empty?
      @passed_tests, @failed_tests = @tests.partition { |test| test.passed? }
    end

    def fulfill_requirements?
      @tests.all? &:passed?
    end

    def constants array
      test = Test.new do
        undefined_constants = array.reject { |constant| object.constants.include? constant }

        fail_message "#{object} is supposed to include #{undefined_constants}, which doesn't seem to be the case."
        undefined_constants.empty?
      end

      @tests << test

      # if a failure occurred so early, it would be a very little use in proceeding
      # without giving it a look first
      (puts test.fail_message; exit) if test.failed?
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

module Pr00f
  class Constant
    class InvalidSpecError < StandardError
      def initialize message
        @spec, @spec_error = message.values_at :spec, :spec_error
        @clarification = if @spec.include? 'constant'
          "That string doesn't look like a correct specification."
        else
          "That string doesn't look at all like a correct specification, as it even doesn't include a constant definition."
        end
      end

      def message
        %!
          Someone have tried to create a report for the following string:
          
          #{@spec}
          
          #{@clarification} Consequently, the following error raised while executing it:

          #{@spec_error}
        !
      end
    end

    class << self
      def from_string spec
        begin
          instance_eval spec
        rescue
          message = { spec: spec, spec_error: $! }
          raise InvalidSpecError.new message
        end
      end

      def constant constant, &b
        @constant = new constant, &b
      end
    end

    prepend Testable
    def initialize constant, &requirements
      @this = constant # object under test
      @instances = []

      begin
        instance_eval &requirements
      rescue BadInstanceDefinitionError
        @tests << $!.test
      end

      prepare_tests
    end

    def fulfill_requirements?
      @tests.all? &:passed?
    end

    def prepare_tests
      @tests += @instances.map(&:tests).reduce(&:+) unless @instances.empty?
      @passed_tests, @failed_tests = @tests.partition { |test| test.passed? }
    end

    def constants array
      test = Test.new do
        undefined_constants = array.reject { |constant| object.constants.include? constant }

        fail_message "#{this} is supposed to include #{undefined_constants}, which doesn't seem to be the case."
        undefined_constants.empty?
      end

      @tests << test
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

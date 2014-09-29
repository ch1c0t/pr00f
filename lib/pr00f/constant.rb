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
    end

    def fulfill_requirements?
      [*@constants, *@methods].all? &:passed?
    end
  end
end

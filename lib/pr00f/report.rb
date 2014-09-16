module Pr00f
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

  require 'forwardable'
  class Report
    extend Forwardable

    def initialize spec
      begin
        instance_eval spec
      rescue
        message = { spec: spec, spec_error: $! }
        raise InvalidSpecError.new message
      end
    end

    def_delegators :@constant, :passed_tests, :failed_tests
    def constant constant, &b
      @constant = Constant.new constant, &b
    end

    def to_s
      # TODO: Make this report a little bit more informative.
      if @constant.fulfill_requirements?
        'Everything seems to be okay.'
      else
        'Something goes terribly wrong.'
      end
    end
  end
end

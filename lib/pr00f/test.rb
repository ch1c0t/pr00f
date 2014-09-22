module Pr00f
  class Test
    def initialize &code
      @code_self = code.binding.eval 'self'
      @code      = code

      check
    end

    [:passed, :failed].each do |symbol|
      define_method "#{symbol}?" do
        @status == symbol
      end
    end

    def fail_message message = nil
      if message.nil?
        @fail_message
      else
        @fail_message = message
      end
    end

    private

    def check
      begin
        bool = instance_eval &@code
      rescue
        @fail_message = "#{$!.inspect}\nHappened at:\n#{$!.backtrace[0..3]}"
        @status = :failed
      end

      @status = bool ? :passed : :failed
    end
    
    def method_missing method, *args, &b
      if (@code_self.respond_to? method) || (@code_self.private_methods.include? method)
        @code_self.send method, *args, &b
      else
        super
      end
    end
  end
end

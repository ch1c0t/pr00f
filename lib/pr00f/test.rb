module Pr00f
  class Test
    attr_reader :status
    def initialize &code
      @code_self = code.binding.eval 'self'
      @code      = code

      @status = :pending
    end

    def check!
      begin
        bool = instance_eval &@code
      rescue StandardError => e
        p e
        @fail_message = e; @status = :failed
      end

      @status = bool ? :passed : :failed
    end

    [:passed, :failed, :pending].each do |symbol|
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
    
    def method_missing method, *args, &b
      if @code_self.respond_to? method
        @code_self.send method, *args, &b
      else
        super
      end
    end
  end
end

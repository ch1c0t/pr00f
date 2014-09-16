module Pr00f
  module RespondToChecker
    def respond_to symbol
      test = Test.new do
        fail_message "#{object} is supposed to have :#{symbol} defined, which doesn't seem to be the case."
        object.respond_to? symbol
      end

      @tests << test
    end
  end
end

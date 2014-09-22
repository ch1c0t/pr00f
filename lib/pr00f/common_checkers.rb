module Pr00f
  module CommonCheckers
    def respond_to symbol
      test = Test.new do
        fail_message "#{this} is supposed to have :#{symbol} defined, which doesn't seem to be the case."
        this.respond_to? symbol
      end

      @tests << test
    end
  end
end
